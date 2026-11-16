"""Offline Granta tests: no network or credentials required."""

from pathlib import Path
from tempfile import TemporaryDirectory
from types import SimpleNamespace
import json
import unittest
from unittest.mock import Mock

from granta_mi_bridge import (
    MIConfig, build_descriptor_packet, connect_mi, create_new_descriptor_record,
    parse_mi_boolean, plan_new_record_upload, read_function_frame, read_scalar, schema_from_export,
)


class GrantaBridgeTests(unittest.TestCase):
    def setUp(self):
        self.config = MIConfig("https://example.invalid/mi_servicelayer", "db_key", "Results")

    def test_sso_connection_is_read_only_and_does_not_store_passwords(self):
        sdk = Mock()
        session = sdk.connect.return_value
        actual_session, database, table = connect_mi(self.config, sdk=sdk)
        self.assertIs(actual_session, session)
        sdk.connect.assert_called_once_with(self.config.server_url, timeout=30000, max_retries=0,
                                            store_password=False, autologon=True)
        session.get_db.assert_called_once_with(db_key="db_key")
        database.get_table.assert_called_once_with("Results")
        database.set_unit_system.assert_called_once_with("Metric")
        session.update.assert_not_called()

    def test_modern_sdk_builder_supports_sso_and_explicit_password(self):
        configuration, builder_factory = Mock(), Mock()
        sdk = SimpleNamespace(SessionConfiguration=configuration, SessionBuilder=builder_factory)
        connect_mi(self.config, sdk=sdk)
        configuration.assert_called_once_with(timeout=30000, max_retries=0)
        builder_factory.assert_called_once_with(self.config.server_url, session_configuration=configuration.return_value)
        builder = builder_factory.return_value
        builder.with_autologon.assert_called_once_with()
        builder.with_credentials.assert_not_called()
        connect_mi(self.config, authentication="password", username="local-test-user", password="mock-value", sdk=sdk)
        builder.with_credentials.assert_called_once_with(username="local-test-user", password="mock-value", store_password=False)

    def test_authentication_errors_are_redacted_and_not_retried(self):
        sdk = Mock()
        sdk.connect.side_effect = RuntimeError("credential-bearing vendor exception")
        with self.assertRaisesRegex(ConnectionError, "authentication/network") as caught:
            connect_mi(self.config, sdk=sdk)
        self.assertNotIn("credential-bearing", str(caught.exception))
        self.assertEqual(sdk.connect.call_count, 1)

    def test_schema_export_meta_lists_are_attached_to_the_correct_attribute(self):
        data = {"Results": [
            {"Name": "Raw results", "Type": "FILE", "Unit": ""}, [],
            {"Name": "Matrix", "Type": "TABL", "Unit": ""},
            [{"MetaName": "Hardness", "MetaType": "FUNC", "MetaUnit": "MPa"}],
        ]}
        with TemporaryDirectory() as directory:
            path = Path(directory) / "schema.json"
            path.write_text(json.dumps(data), encoding="utf-8")
            schema = schema_from_export(path)
        self.assertEqual(schema["attributes"]["Raw results"]["type"], "FILE")
        self.assertEqual(schema["attributes"]["Matrix"]["meta_attributes"][0]["MetaName"], "Hardness")

    def test_missing_values_and_boolean_strings_are_not_corrupted(self):
        record = SimpleNamespace(attributes={"eta": SimpleNamespace(value=None)})
        self.assertIsNone(read_scalar(record, "eta"))
        self.assertIsNone(record.attributes["eta"].value)
        self.assertFalse(parse_mi_boolean("False"))
        self.assertFalse(parse_mi_boolean("0"))
        self.assertTrue(parse_mi_boolean("true"))
        self.assertIsNone(parse_mi_boolean(None))

    def test_function_extraction_preserves_ranges_headers_and_missing_values(self):
        value = SimpleNamespace(type="FUNC", value=[
            ["Y min (Load [mN])", "Y max (Load [mN])", "Vertical displacement [nm]"],
            [1.0, 1.2, 100], [None, None, 200],
        ])
        record = SimpleNamespace(attributes={"Load": value})
        frame = read_function_frame(record, "Load")
        self.assertEqual(frame.columns.tolist(), value.value[0])
        self.assertEqual(frame.iloc[0, 0], 1.0)
        self.assertEqual(frame.iloc[0, 1], 1.2)
        self.assertTrue(frame.iloc[1, :2].isna().all())
        self.assertIsNone(value.value[2][0])

    def test_credentials_cannot_be_embedded_in_server_url(self):
        with self.assertRaises(ValueError):
            MIConfig("https://user:secret@example.invalid/mi_servicelayer", "key", "table")

    def test_packet_mapping_and_dry_run_never_write(self):
        with TemporaryDirectory() as directory:
            folder = Path(directory)
            (folder / "grain_descriptors.csv").write_text("grain_id,eta_BP\n1,0.2\n", encoding="utf-8")
            (folder / "boundary_descriptors.csv").write_text("grain_A,grain_B\n1,2\n", encoding="utf-8")
            (folder / "provenance.json").write_text(json.dumps({"dataset_role": "experimental", "information_level": "derived"}), encoding="utf-8")
            packet = build_descriptor_packet(folder, folder / "packet.zip")
            schema = {"attributes": {"Raw results": {"type": "FILE"}, "Additional notes": {"type": "LTXT"}}}
            with self.assertRaisesRegex(ValueError, "raw data"):
                plan_new_record_upload(schema, packet, "New derived record", "Raw results")
            plan = plan_new_record_upload(schema, packet, "New derived record", "Raw results", acknowledge_raw_slot=True)
            session, table = Mock(), Mock()
            result = create_new_descriptor_record(session, table, plan)
            self.assertEqual(result["status"], "dry_run")
            session.update.assert_not_called()
            table.path_from.assert_not_called()
            table.create_record.assert_not_called()
            table.search_for_records_by_name.assert_not_called()
            (folder / "packet.zip").write_bytes(b"changed")
            with self.assertRaisesRegex(ValueError, "hash changed"):
                plan_new_record_upload(schema, packet, "New derived record", "Raw results", acknowledge_raw_slot=True)

    def test_commit_revalidates_live_schema_and_refuses_existing_records(self):
        with TemporaryDirectory() as directory:
            folder = Path(directory)
            for name in ("grain_descriptors.csv", "boundary_descriptors.csv"):
                (folder / name).write_text("id\n1\n", encoding="utf-8")
            (folder / "provenance.json").write_text(json.dumps({"dataset_role": "experimental", "information_level": "derived"}), encoding="utf-8")
            packet = build_descriptor_packet(folder, folder / "packet.zip")
            attribute = lambda kind: SimpleNamespace(type=kind, unit="", meta_attributes={})
            table = Mock()
            table.attributes = {"Derived results": attribute("FILE"), "Additional notes": attribute("LTXT")}
            schema = {"attributes": {"Derived results": {"type": "FILE"}, "Additional notes": {"type": "LTXT"}}}
            plan = plan_new_record_upload(schema, packet, "New derived record", "Derived results")
            session = Mock()
            table.search_for_records_by_name.return_value = [Mock()]
            with self.assertRaisesRegex(ValueError, "already exists"):
                create_new_descriptor_record(session, table, plan, confirm=True)
            table.search_for_records_by_name.assert_called_once_with("New derived record", filter_by_subset=False)
            table.path_from.assert_not_called()
            table.create_record.assert_not_called()
            table.search_for_records_by_name.return_value = []
            record = table.create_record.return_value
            file_value, notes_value = Mock(), Mock()
            record.attributes = {"Derived results": file_value, "Additional notes": notes_value}
            created = create_new_descriptor_record(session, table, plan, confirm=True)
            self.assertEqual(created["status"], "created")
            session.update.assert_called_once_with([record])
            table.create_record.assert_called_once_with("New derived record", parent=None)
            table.path_from.assert_not_called()
            record.clear_attributes.assert_not_called()
            file_value.load.assert_called_once_with(Path(packet["archive_path"]))

    def test_synthetic_packet_is_rejected(self):
        with TemporaryDirectory() as directory:
            folder = Path(directory)
            for name in ("grain_descriptors.csv", "boundary_descriptors.csv"):
                (folder / name).write_text("id\n1\n", encoding="utf-8")
            (folder / "provenance.json").write_text(json.dumps({"dataset_role": "synthetic_demonstration", "information_level": "derived"}), encoding="utf-8")
            with self.assertRaisesRegex(ValueError, "experimental"):
                build_descriptor_packet(folder, folder / "packet.zip")


if __name__ == "__main__":
    unittest.main()