"""Read-only-first Granta MI bridge for provenance-aware descriptor exports."""

from dataclasses import dataclass
from hashlib import sha256
from pathlib import Path
from urllib.parse import urlparse
from zipfile import ZIP_DEFLATED, ZipFile
import json


@dataclass(frozen=True)
class MIConfig:
    server_url: str
    database_key: str
    table_name: str
    timeout_ms: int = 30000

    def __post_init__(self):
        parsed = urlparse(self.server_url)
        if parsed.scheme != "https" or not parsed.hostname or parsed.username or parsed.password or parsed.query or parsed.fragment:
            raise ValueError("Use an HTTPS service-layer URL without credentials, query, or fragment.")
        if not self.database_key.strip() or not self.table_name.strip() or self.timeout_ms <= 0:
            raise ValueError("Database key, table name, and a positive timeout are required.")


def load_sdk():
    try:
        from ansys.grantami import core
        return core
    except ImportError:
        try:
            from GRANTA_MIScriptingToolkit import granta
            return granta
        except ImportError:
            raise ImportError("Install the Granta MI Scripting Toolkit in this kernel.") from None


def connect_mi(config, authentication="sso", username=None, password=None, sdk=None):
    """Connect without implicit authentication fallback or persisted credentials.

    Passwords must come from a local secure prompt or secret store, never from
    a notebook literal. This function performs no record creation or writes.
    """
    if authentication not in ("sso", "password"):
        raise ValueError("Authentication must be 'sso' or 'password'.")
    if authentication == "password" and (not username or not password):
        raise ValueError("Explicit username and securely supplied password required.")
    sdk = load_sdk() if sdk is None else sdk
    try:
        legacy_connect = getattr(sdk, "connect", None)
        if callable(legacy_connect):
            arguments = {"timeout": config.timeout_ms, "max_retries": 0, "store_password": False}
            if authentication == "sso":
                arguments["autologon"] = True
            else:
                arguments.update({"user_name": username, "password": password, "autologon": False})
            session = legacy_connect(config.server_url, **arguments)
        else:
            configuration = sdk.SessionConfiguration(timeout=config.timeout_ms, max_retries=0)
            builder = sdk.SessionBuilder(config.server_url, session_configuration=configuration)
            session = (builder.with_autologon() if authentication == "sso" else
                       builder.with_credentials(username=username, password=password, store_password=False))
    except Exception:
        raise ConnectionError("Granta MI authentication/network connection failed; no record writes attempted.") from None
    try:
        database = session.get_db(db_key=config.database_key)
        database.set_unit_system("Metric")
        table = database.get_table(config.table_name)
    except Exception:
        raise ConnectionError("Connected, but database/table access failed; check keys and permissions. No records changed.") from None
    return session, database, table


def schema_from_export(path):
    """Read the alternating attribute/meta-list JSON format in the supplied helper."""
    with Path(path).open(encoding="utf-8-sig") as stream:
        exported = json.load(stream)
    attributes = {}
    for category, entries in exported.items():
        previous = None
        for entry in entries:
            if isinstance(entry, dict) and "Name" in entry:
                previous = entry["Name"]
                attributes[previous] = {
                    "name": previous, "type": entry["Type"], "unit": entry.get("Unit", ""),
                    "category": category, "column_headers": entry.get("ColumnHeaders", []), "meta_attributes": [],
                }
            elif isinstance(entry, list) and previous is not None:
                attributes[previous]["meta_attributes"].extend(entry)
    return {"attributes": attributes, "source": "offline_schema_export", "schema_path": str(Path(path))}


def inspect_mi_schema(table, sample_record=None):
    """Inspect schema and optional record column headers without changing data."""
    attributes = {}
    for name, attribute in table.attributes.items():
        description = {"name": name, "type": attribute.type, "unit": attribute.unit,
                       "meta_attributes": [{"name": key, "type": value.type, "unit": value.unit}
                                           for key, value in attribute.meta_attributes.items()]}
        if sample_record is not None and attribute.type in ("FUNC", "TABL"):
            value = sample_record.attributes[name]
            description["column_headers"] = value.column_headers if attribute.type == "FUNC" else value.columns
        attributes[name] = description
    return {"attributes": attributes, "source": "live_read_only_schema"}


def read_scalar(record, attribute_name):
    """Return the SDK value as-is; missing values stay None, never become zero."""
    return record.attributes[attribute_name].value


def read_function_frame(record, attribute_name):
    """Preserve function headers, ranges, and units rather than guessing columns."""
    import pandas as pd

    attribute = record.attributes[attribute_name]
    if attribute.type != "FUNC":
        raise ValueError("The selected attribute is not a function.")
    values = attribute.value
    if values is None or not len(values):
        return pd.DataFrame()
    return pd.DataFrame(values[1:], columns=values[0])


def parse_mi_boolean(value):
    if isinstance(value, bool):
        return value
    if isinstance(value, str):
        value = value.strip().lower()
    if value in (1, "1", "true", "yes"):
        return True
    if value in (0, "0", "false", "no"):
        return False
    if value is None or value == "":
        return None
    raise ValueError("Expected an explicit true/false value, not generic Python truthiness.")


def build_descriptor_packet(export_folder, archive_path):
    """Package the real-data CSVs and provenance without any credentials/config."""
    export_folder, archive_path = Path(export_folder), Path(archive_path)
    names = ("grain_descriptors.csv", "boundary_descriptors.csv", "provenance.json")
    sources = [export_folder / name for name in names]
    if not all(path.is_file() for path in sources):
        raise ValueError("Generate the two descriptor CSVs and provenance.json first.")
    with sources[-1].open(encoding="utf-8-sig") as stream:
        manifest = json.load(stream)
    if manifest.get("dataset_role") != "experimental" or manifest.get("information_level") != "derived":
        raise ValueError("Only the explicitly experimental, derived descriptor export can be uploaded.")
    archive_path.parent.mkdir(parents=True, exist_ok=True)
    if archive_path.suffix.lower() != ".zip" or archive_path.resolve() in [path.resolve() for path in sources]:
        raise ValueError("Use a separate .zip output path.")
    with ZipFile(archive_path, "w", compression=ZIP_DEFLATED) as archive:
        for path in sources:
            archive.write(path, arcname=path.name)
    return {"archive_path": str(archive_path.resolve()), "sha256": sha256(archive_path.read_bytes()).hexdigest(),
            "byte_count": archive_path.stat().st_size, "members": list(names),
            "dataset_role": "experimental", "information_level": "derived"}


def plan_new_record_upload(schema, packet, record_name, file_attribute, notes_attribute="Additional notes",
                           acknowledge_raw_slot=False):
    """Validate an explicit schema mapping; no connection or writes are made.

    The provided schema exposes a FILE attribute called 'Raw results'. A
    dedicated derived-results field is preferable. Reusing the raw slot for
    this clearly marked derived-data record requires explicit acknowledgement.
    No numeric descriptors are assigned to guessed fields or converted units.
    """
    if not record_name.strip():
        raise ValueError("An explicit new record name is required.")
    attributes = schema["attributes"]
    if file_attribute not in attributes or attributes[file_attribute]["type"] != "FILE":
        raise ValueError("Choose an existing FILE attribute from the selected table's schema.")
    if notes_attribute not in attributes or attributes[notes_attribute]["type"] not in ("LTXT", "STXT"):
        raise ValueError("Choose an existing text attribute for the derived-data provenance warning.")
    if "raw" in file_attribute.casefold() and not acknowledge_raw_slot:
        raise ValueError("The chosen field is labeled raw data; explicitly acknowledge reuse for derived results or choose a dedicated FILE field.")
    if packet.get("dataset_role") != "experimental" or packet.get("information_level") != "derived":
        raise ValueError("The packet must be explicitly identified as experimental-derived data.")
    path = Path(packet["archive_path"])
    if not path.is_file() or sha256(path.read_bytes()).hexdigest() != packet["sha256"]:
        raise ValueError("Packet file is missing or its hash changed.")
    notes = (
        "DERIVED DESCRIPTOR PACKAGE, NOT RAW INDENTATION DATA. "
        "Contains grain-average orientation and grain-boundary descriptors from STABiX GF2/RB sources. "
        "No synthetic indentation/AFM records, experimental mechanism labels, or fitted paper coefficients are uploaded. "
        "The export cohort is not the selected matched indentation/AFM cohort. "
        f"Packet SHA-256: {packet['sha256']}. Units, methods, source hashes and validity are in provenance.json."
    )
    return {"record_name": record_name, "file_attribute": file_attribute, "notes_attribute": notes_attribute,
            "notes": notes, "packet": dict(packet), "schema_source": schema.get("source"),
            "acknowledge_raw_slot": acknowledge_raw_slot, "new_record_only": True}


def create_new_descriptor_record(session, table, plan, parent_record=None, confirm=False):
    """Dry-run by default; create one new record only after live revalidation.

    No clear_attributes, updates of existing records, deletion, guessed schema
    creation, implicit links, or automatic retries are performed. SDK writes
    may be non-transactional: on failure inspect the server before retrying.
    """
    if confirm is not True:
        return {"status": "dry_run", "plan": plan}
    live_schema = inspect_mi_schema(table)
    checked = plan_new_record_upload(
        live_schema, plan["packet"], plan["record_name"], plan["file_attribute"], plan["notes_attribute"],
        acknowledge_raw_slot=plan["acknowledge_raw_slot"],
    )
    if table.search_for_records_by_name(checked["record_name"], filter_by_subset=False):
        raise ValueError("A matching record already exists; refusing to overwrite or select a possibly ambiguous match.")
    try:
        record = table.create_record(checked["record_name"], parent=parent_record)
        file_value = record.attributes[checked["file_attribute"]]
        file_value.load(Path(checked["packet"]["archive_path"]))
        notes_value = record.attributes[checked["notes_attribute"]]
        notes_value.value = checked["notes"]
        record.set_attributes([file_value, notes_value])
        updated = session.update([record])
    except Exception:
        raise RuntimeError("Upload failed. Inspect server state before retrying; no automatic retry or clearing was attempted.") from None
    return {"status": "created", "records": updated, "record_name": checked["record_name"],
            "packet_sha256": checked["packet"]["sha256"]}