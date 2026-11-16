"""Analytical checks for experimental descriptor calculations."""

import unittest
import json
from pathlib import Path
from tempfile import TemporaryDirectory
from types import SimpleNamespace
from unittest.mock import patch

import numpy as np
from numpy.testing import assert_allclose

from experimental_descriptors import (
    afm_descriptors, association_summary, axial_statistics, basal_prism_families,
    competition_index, cubic_slip_families, family_orientation_factors,
    export_descriptor_tables,
    hcp_slip_families,
    ordinal_evidence_model, orientation_descriptors, provenance_manifest, read_afm_height, resistance_competition, same_phase_misorientation,
    slip_pair_descriptors, slip_trace_angles, trace_deviation, unloading_descriptors,
)


class ExperimentalDescriptorTests(unittest.TestCase):
    def test_bunge_loading_direction_and_ipf(self):
        eulers = np.array([[0, 0, 0], [23, 47, 81], [0, 90, 0]])
        results = orientation_descriptors(eulers)
        phi, phi2 = np.radians(eulers[:, 1]), np.radians(eulers[:, 2])
        expected = np.column_stack((np.sin(phi2) * np.sin(phi), np.cos(phi2) * np.sin(phi), np.cos(phi)))
        assert_allclose(results["loading_direction_crystal"], expected, atol=1e-15)
        assert_allclose(results["ipf_xy"][0], [0, 0])
        assert_allclose(np.linalg.norm(results["ipf_direction"], axis=1), 1)
        self.assertTrue(np.all(results["ipf_direction"][:, 1] <= results["ipf_direction"][:, 0] / np.sqrt(3) + 1e-15))

    def test_factors_and_zero_driving_force_are_not_a_mixed_mechanism(self):
        factors = family_orientation_factors([[0, 0, 0], [0, 45, 0]], basal_prism_families())
        assert_allclose(factors["basal"]["maximum"][0], 0)
        assert_allclose(factors["prism1"]["maximum"][0], 0)
        eta, valid = competition_index(factors["prism1"]["maximum"], factors["basal"]["maximum"])
        self.assertFalse(valid[0])
        self.assertTrue(np.isnan(eta[0]))
        self.assertTrue(valid[1])
        for result in factors.values():
            self.assertTrue(np.all(result["maximum"] <= 0.5 + 1e-15))

    def test_crss_sensitivity_is_stress_unit_invariant(self):
        first = resistance_competition([0.3, 0], [0.2, 0], 100, 150)
        second = resistance_competition([0.3, 0], [0.2, 0], 1e8, 1.5e8)
        assert_allclose(first, second)
        self.assertTrue(np.isnan(first[1]))

    def test_traces_use_line_angles_and_require_calibration(self):
        assert_allclose(trace_deviation([179, 2], [1], calibration_deg=0), [2, 1])
        with self.assertRaisesRegex(ValueError, "calibrated"):
            trace_deviation([30], [40])
        angles = slip_trace_angles([[0, 0, 0]], [[0, 0, 1], [1, 0, 0]])
        self.assertTrue(np.isnan(angles[0, 0]))
        assert_allclose(angles[0, 1], 90)

    def test_hcp_disorientation_under_sixty_degree_c_axis_rotation(self):
        assert_allclose(same_phase_misorientation([[0, 0, 0]], [[60, 0, 0]]), 0, atol=3e-6)

    def test_exact_unloading_curve_and_area_calibration_requirement(self):
        depth = np.linspace(300, 75, 120)
        alpha = 6 / (300 - 70)**1.6
        load = alpha * (depth - 70)**1.6
        result = unloading_descriptors(depth, load, area_function_nm2=lambda contact: 1e6)
        assert_allclose(result["exponent_m"], 1.6, atol=1e-6)
        assert_allclose(result["hf_nm"], 70, atol=1e-5)
        assert_allclose(result["hardness_GPa"], 6)
        assert_allclose(result["stiffness_mN_per_nm"], 6 * 1.6 / 230, rtol=1e-6)
        self.assertFalse(unloading_descriptors(depth, load)["hardness_valid"])
        self.assertTrue(np.isnan(unloading_descriptors(depth, load)["hardness_GPa"]))

    def test_afm_plane_has_zero_pileup_and_roi_mask_is_preserved(self):
        coordinates = np.linspace(-2, 2, 101)
        xx, yy = np.meshgrid(coordinates, coordinates)
        height = 3 * xx - 2 * yy + 7
        result = afm_descriptors(coordinates, coordinates, height, (0, 0), 1.8, (1.5, 1.8), (0.6, 1.0))
        assert_allclose(result["h_PU_nm"], 0)
        assert_allclose(result["V_PU_um3"], 0)
        assert_allclose(result["A_PU_um2"], 0)
        self.assertTrue(np.all(np.isnan(result["height_levelled_nm"][~result["roi_mask"]])))

    def test_afm_reader_converts_calibrated_channel_and_checks_units(self):
        channel = SimpleNamespace(
            data=np.arange(12).reshape(3, 4) * 1e-9, xreal=4e-6, yreal=6e-6,
            si_unit_xy="m", si_unit_z="m", meta={},
        )
        scan = SimpleNamespace(channels={"Height": channel}, source_format="nanoscope")
        with TemporaryDirectory() as directory:
            path = Path(directory) / "scan.000"
            path.write_bytes(b"measurement")
            with patch("gwyddionpy.load", return_value=scan):
                result = read_afm_height(path)
                assert_allclose(result["x_um"], [0.5, 1.5, 2.5, 3.5])
                assert_allclose(result["y_um"], [1, 3, 5])
                assert_allclose(result["height_nm"], np.arange(12).reshape(3, 4))
                channel.si_unit_z = "V"
                with self.assertRaisesRegex(ValueError, "units"):
                    read_afm_height(path)

    def test_afm_angular_intensity_units_and_missing_data(self):
        coordinates = np.linspace(-2, 2, 101)
        xx, yy = np.meshgrid(coordinates, coordinates)
        radius = np.hypot(xx, yy)
        height = np.where((radius > 0.4) & (radius < 1.2), 20.0, 0)
        result = afm_descriptors(coordinates, coordinates, height, (0, 0), 1.8, (1.5, 1.8), (0.6, 1.0), hmax_nm=200)
        assert_allclose(result["intensity_um2"], 0.008, atol=1e-14)
        assert_allclose(result["R_h"], 0.1)
        height[50, 70] = np.nan
        incomplete = afm_descriptors(coordinates, coordinates, height, (0, 0), 1.8, (1.5, 1.8), (0.6, 1.0))
        self.assertTrue(np.isnan(incomplete["height_levelled_nm"][50, 70]))
        self.assertTrue(np.isnan(incomplete["intensity_um2"][0]))
        self.assertLess(incomplete["roi_valid_fraction"], 1)

    def test_all_hcp_and_cubic_family_counts_and_orthogonality(self):
        families = hcp_slip_families()
        self.assertEqual([len(systems[0]) for systems in families.values()], [3, 3, 3, 6, 12, 6])
        bcc = cubic_slip_families()
        self.assertEqual([len(systems[0]) for systems in bcc.values()], [12, 12, 24])
        for normals, directions in [*families.values(), *bcc.values(), *cubic_slip_families("fcc").values()]:
            assert_allclose(np.sum(normals * directions, axis=1), 0, atol=1e-15)
            assert_allclose(np.linalg.norm(normals, axis=1), 1)

    def test_slip_pair_limits_and_unknown_boundary_plane(self):
        systems = basal_prism_families()["basal"]
        result = slip_pair_descriptors([0, 0, 0], [0, 0, 0], systems, systems, 0.298, 0.298)
        assert_allclose(result["max_mprime"], 1)
        assert_allclose(result["max_abs_N"], 1)
        assert_allclose(result["min_residual_burgers_nm"], 0, atol=1e-8)
        self.assertTrue(np.isnan(result["boundary_inclination_deg"]))
        known = slip_pair_descriptors([0, 0, 0], [0, 0, 0], systems, systems, boundary_normal_sample=[1, 0, 0])
        assert_allclose(known["boundary_inclination_deg"], 90)

    def test_statistics_and_grain_held_out_ordinal_probabilities(self):
        summary = association_summary(np.arange(20), np.arange(20)**2, n_resamples=50)
        assert_allclose(summary["spearman_rho"], 1)
        assert_allclose(axial_statistics([179, 1])["mean_line_angle_deg"], 0, atol=1e-12)
        eta = np.linspace(-1, 1, 18)
        labels = np.tile([0, 1, 2], 6)
        result = ordinal_evidence_model(eta, labels, leave_one_out=True, grain_ids=np.repeat(np.arange(6), 3))
        assert_allclose(result["probabilities"].sum(axis=1), 1)
        assert_allclose(result["cross_validation"]["valid_fraction"], 1)
        self.assertEqual(result["cross_validation"]["unit"], "grain")

    def test_provenance_records_hashes_and_role(self):
        with TemporaryDirectory() as directory:
            source = Path(directory) / "source.txt"
            source.write_text("measured data", encoding="utf-8")
            result = provenance_manifest([source], {"families": ["basal", "prism1"]}, {"eta_BP": "1"})
            self.assertEqual(result["information_level"], "derived")
            self.assertEqual(result["dataset_role"], "experimental")
            self.assertEqual(len(result["sources"][0]["sha256"]), 64)

    def test_export_preserves_missing_values_and_sidecar(self):
        import pandas as pd

        with TemporaryDirectory() as directory:
            table = pd.DataFrame({"grain_id": [1, 2], "eta_BP": [0.2, np.nan]})
            paths = export_descriptor_tables(directory, {"grain_descriptors": table},
                                             {"dataset_role": "experimental", "units": {"eta_BP": "1"}})
            self.assertEqual(len(paths), 2)
            restored = pd.read_csv(paths[0])
            self.assertTrue(np.isnan(restored.eta_BP.iloc[1]))
            self.assertEqual(json.loads(paths[1].read_text())["dataset_role"], "experimental")


if __name__ == "__main__":
    unittest.main()