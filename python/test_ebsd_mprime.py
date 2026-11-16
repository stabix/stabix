"""Numerical, EBSD import, and literature checks; run with unittest discover."""

from pathlib import Path
from tempfile import TemporaryDirectory
from types import SimpleNamespace
import unittest

import numpy as np
import yaml
from numpy.testing import assert_allclose
from scipy.spatial.transform import Rotation

from ebsd_mprime import (
    CUBIC, boundary_segments, bunge_rotations, cubic_disorientation,
    guo_literature_comparison, maximum_mprime, read_ctf, read_tsl_reconstruction, reconstructed_mprime,
    reconstruct_grains, reconstructed_grain_polygons, plot_grain_tessellation, plot_reconstructed_map,
    slip_systems,
)
from literature_checks import diagnose_guo_mismatches, patriarca_residual_comparison


class MprimeTests(unittest.TestCase):
    def test_patriarca_selected_slip_residuals_and_reference_mismatches(self):
        folder = Path(__file__).resolve().parents[1] / "gui_bicrystal" / "gui_bicrystal_data" / "patriarca_2013"
        rows = patriarca_residual_comparison(folder)
        self.assertEqual(len(rows), 12)
        self.assertEqual([row["number"] for row in rows if not row["within_tolerance"]], [5, 6])
        assert_allclose(rows[0]["calculated"], 0.157582, atol=1e-6)
        assert_allclose(rows[3]["calculated"], 0.284339, atol=1e-6)
        assert_allclose(rows[4]["calculated"], 1.168134, atol=1e-6)
        assert_allclose(rows[5]["calculated"], 1.138499, atol=1e-6)
        with self.assertRaisesRegex(ValueError, "tolerance"):
            patriarca_residual_comparison(folder, -1)

    def test_slip_systems(self):
        for structure in ("fcc", "bcc"):
            normals, directions = slip_systems(structure)
            self.assertEqual(normals.shape, (12, 3))
            assert_allclose(np.linalg.norm(normals, axis=1), 1)
            assert_allclose(np.linalg.norm(directions, axis=1), 1)
            assert_allclose(np.sum(normals * directions, axis=1), 0, atol=1e-15)

    def test_bunge_matches_stabix_transpose(self):
        phi1, phi, phi2 = np.radians([23, 47, 81])
        cos1, cos_phi, cos2 = np.cos([phi1, phi, phi2])
        sin1, sin_phi, sin2 = np.sin([phi1, phi, phi2])
        passive = np.array([
            [cos1*cos2-sin1*sin2*cos_phi, sin1*cos2+cos1*sin2*cos_phi, sin2*sin_phi],
            [-cos1*sin2-sin1*cos2*cos_phi, -sin1*sin2+cos1*cos2*cos_phi, cos2*sin_phi],
            [sin1*sin_phi, -cos1*sin_phi, cos_phi],
        ])
        assert_allclose(bunge_rotations([[23, 47, 81]]).as_matrix()[0], passive.T, atol=1e-15)

    def test_hcp_basal_prismatic_matches_matlab(self):
        normals, directions = slip_systems("hcp")
        self.assertEqual(normals.shape, (6, 3))
        assert_allclose(np.linalg.norm(normals, axis=1), 1)
        assert_allclose(np.linalg.norm(directions, axis=1), 1)
        assert_allclose(np.sum(normals * directions, axis=1), 0, atol=1e-15)
        assert_allclose(directions[0], [1, 0, 0])
        assert_allclose(directions[1], [-0.5, np.sqrt(3) / 2, 0])
        assert_allclose(normals[4], [-np.sqrt(3) / 2, -0.5, 0])
        base = bunge_rotations([[23, 47, 81]])
        equivalent = base * Rotation.create_group("D6")
        rotations = Rotation.concatenate([base, equivalent])
        pairs = np.column_stack((np.zeros(12, dtype=int), np.arange(1, 13)))
        assert_allclose(maximum_mprime(rotations, pairs, "hcp"), 1, atol=1e-14)

    def test_hcp_individual_family_selection(self):
        normals, directions = slip_systems("hcp")
        for family, section in (("hcp_basal", slice(0, 3)), ("hcp_prismatic", slice(3, 6))):
            family_normals, family_directions = slip_systems(family)
            assert_allclose(family_normals, normals[section])
            assert_allclose(family_directions, directions[section])

    def test_hcp_prism2_matches_matlab_indices_and_preserves_prism_prism_maximum(self):
        normals, directions = slip_systems("hcp_prismatic2")
        plane_indices = np.array([[2, -1, -1, 0], [-1, 2, -1, 0], [-1, -1, 2, 0]])
        direction_indices = np.array([[0, 1, -1, 0], [-1, 0, 1, 0], [1, -1, 0, 0]])
        expected_normals = np.column_stack((
            plane_indices[:, 0],
            (2 * plane_indices[:, 1] + plane_indices[:, 0]) / np.sqrt(3), np.zeros(3),
        ))
        expected_directions = np.column_stack((
            1.5 * direction_indices[:, 0],
            np.sqrt(3) / 2 * (2 * direction_indices[:, 1] + direction_indices[:, 0]), np.zeros(3),
        ))
        expected_normals /= np.linalg.norm(expected_normals, axis=1, keepdims=True)
        expected_directions /= np.linalg.norm(expected_directions, axis=1, keepdims=True)
        assert_allclose(normals, expected_normals, atol=1e-15)
        assert_allclose(directions, expected_directions, atol=1e-15)
        for actual, expected in zip(slip_systems("hcp_prismatic1"), slip_systems("hcp_prismatic")):
            assert_allclose(actual, expected)
        rotations = Rotation.random(10, random_state=11)
        pairs = np.arange(10).reshape(-1, 2)
        assert_allclose(maximum_mprime(rotations, pairs, "hcp_prismatic2"),
                        maximum_mprime(rotations, pairs, "hcp_prismatic1"), atol=1e-15)

    def test_guo_calculations_match_independent_matlab_matrix_formulas(self):
        folder = Path(__file__).resolve().parents[1] / "gui_bicrystal" / "gui_bicrystal_data" / "guo_2014"
        rows = guo_literature_comparison(folder)

        def matlab_sample_matrix(euler):
            phi1, phi, phi2 = np.radians(euler)
            first = np.array([
                [np.cos(phi1), np.sin(phi1), 0],
                [-np.sin(phi1), np.cos(phi1), 0], [0, 0, 1],
            ])
            middle = np.array([
                [1, 0, 0], [0, np.cos(phi), np.sin(phi)],
                [0, -np.sin(phi), np.cos(phi)],
            ])
            last = np.array([
                [np.cos(phi2), np.sin(phi2), 0],
                [-np.sin(phi2), np.cos(phi2), 0], [0, 0, 1],
            ])
            return (last @ middle @ first).T

        for row in rows:
            with self.subTest(case=row["case"], comparison=row["comparison"]):
                with (folder / f"{row['case']}.yaml").open(encoding="utf-8-sig") as stream:
                    data = yaml.safe_load(stream)
                first_matrix = matlab_sample_matrix(data["eulerA"])
                second_matrix = matlab_sample_matrix(data["eulerB"])
                first_family = "hcp_basal" if "A basal" in row["comparison"] else "hcp_prismatic"
                first_normals, first_directions = slip_systems(first_family)
                second_normals, second_directions = slip_systems("hcp_prismatic")
                expected = max(
                    abs(np.dot(first_matrix @ normal1, second_matrix @ normal2)
                        * np.dot(first_matrix @ direction1, second_matrix @ direction2))
                    for normal1, direction1 in zip(first_normals, first_directions)
                    for normal2, direction2 in zip(second_normals, second_directions)
                )
                assert_allclose(row["calculated"], expected, atol=2e-15, rtol=0)

    def test_guo_prismatic_values_reproduce_supplied_matlab_figure(self):
        folder = Path(__file__).resolve().parents[1] / "gui_bicrystal" / "gui_bicrystal_data" / "guo_2014"
        rows = [row for row in guo_literature_comparison(folder)
                if row["comparison"] == "A prismatic / B prismatic"]
        self.assertEqual(len(rows), 7)
        assert_allclose([row["reference"] for row in rows], [0.94, 0.46, 0.95, 0.41, 0.84, 0.73, 0.91])
        assert_allclose(np.round([row["calculated"] for row in rows], 2),
                        [0.94, 0.47, 0.95, 0.41, 0.84, 0.75, 0.91], atol=0, rtol=0)

    def test_guo_reference_comparison_reports_discrepancies(self):
        folder = Path(__file__).resolve().parents[1] / "gui_bicrystal" / "gui_bicrystal_data" / "guo_2014"
        rows = guo_literature_comparison(folder)
        self.assertEqual(len(rows), 14)
        self.assertEqual(rows[0]["reference"], 0.94)
        self.assertTrue(rows[0]["within_tolerance"])
        self.assertEqual(rows[1]["reference"], 0.04)
        self.assertFalse(rows[1]["within_tolerance"])
        for row in rows:
            self.assertEqual(row["tolerance"], 0.0051)
            self.assertEqual(row["within_tolerance"], row["absolute_error"] <= 0.0051)
        with self.assertRaisesRegex(ValueError, "tolerance"):
            guo_literature_comparison(folder, tolerance=-1)
        with TemporaryDirectory() as directory:
            with self.assertRaisesRegex(ValueError, "No Guo2014"):
                guo_literature_comparison(directory)

    def test_guo_diagnostics_rule_out_invariant_and_precision_errors(self):
        folder = Path(__file__).resolve().parents[1] / "gui_bicrystal" / "gui_bicrystal_data" / "guo_2014"
        results = diagnose_guo_mismatches(folder)
        self.assertEqual(len(results), 14)
        for result in results:
            with self.subTest(case=result["case"], comparison=result["comparison"]):
                for metric in ("unit_norm_error", "orthogonality_error", "normalization_delta",
                               "scaling_delta", "sign_delta", "periodic_delta", "symmetry_delta",
                               "sample_frame_delta"):
                    self.assertLess(result[metric], 5e-14)
                self.assertAlmostEqual(result["rounding_bound"], 12 * np.deg2rad(0.00005), places=14)
                self.assertLessEqual(abs(result["rounding_sample_min"] - result["calculated"]),
                                     result["rounding_bound"])
                self.assertLessEqual(abs(result["rounding_sample_max"] - result["calculated"]),
                                     result["rounding_bound"])
                if not result["within_tolerance"]:
                    self.assertTrue(result["rounding_excluded"])
                if "A prismatic" in result["comparison"]:
                    self.assertAlmostEqual(result["prism2_value"], result["calculated"], places=14)
        case7 = next(result for result in results
                     if result["case"].endswith("Case7") and "A basal" in result["comparison"])
        self.assertEqual(case7["closest_pair_indices"], (3, 5))
        self.assertAlmostEqual(case7["closest_pair_value"], 0.152869, places=6)
        self.assertLess(case7["closest_pair_error"], case7["tolerance"])
        case4 = next(result for result in results
                     if result["case"].endswith("Case4") and "A basal" in result["comparison"])
        self.assertAlmostEqual(case4["reverse_closest_pair_value"], 0.639450, places=6)
        self.assertLess(case4["reverse_closest_pair_error"], case4["tolerance"])

    def test_mixed_hcp_bcc_matches_direct_dot_products(self):
        rotations = Rotation.random(2, random_state=8)
        first_normals, first_directions = slip_systems("hcp")
        second_normals, second_directions = slip_systems("bcc")
        expected = max(
            abs(np.dot(rotations[0].apply(normal1), rotations[1].apply(normal2))
                * np.dot(rotations[0].apply(direction1), rotations[1].apply(direction2)))
            for normal1, direction1 in zip(first_normals, first_directions)
            for normal2, direction2 in zip(second_normals, second_directions)
        )
        assert_allclose(maximum_mprime(rotations, np.array([[0, 1]]), "hcp", "bcc"), [expected])
        assert_allclose(maximum_mprime(rotations, np.array([[1, 0]]), "bcc", "hcp"), [expected])

    def test_tsl_noncontiguous_ids_units_and_missing_grain(self):
        grains = "20 30 40 50 5 6 100 1 1 2 0 10\n10 0 0 0 1 2 100 1 1 1 0 10\n"
        boundaries = "0.5 0.6 0.7 0 0 0 5 30 1 2 4 6 20 10\n"
        with TemporaryDirectory() as directory:
            grain_path = Path(directory) / "grains.txt"
            boundary_path = Path(directory) / "boundaries.txt"
            grain_path.write_text(grains, encoding="utf-8")
            boundary_path.write_text(boundaries, encoding="utf-8")
            scan = read_tsl_reconstruction(grain_path, boundary_path)
            assert_allclose(scan.grain_ids, [10, 20])
            assert_allclose(scan.eulers, [[0, 0, 0], [30, 40, 50]])
            assert_allclose(scan.centers, [[1, 2], [5, 6]])
            assert_allclose(scan.phases, [1, 2])
            assert_allclose(scan.pairs, [[0, 1]])
            assert_allclose(scan.segments, [[[1, 2], [4, 6]]])
            rotations = bunge_rotations(scan.eulers)
            assert_allclose(reconstructed_mprime(scan), maximum_mprime(rotations, scan.pairs, "hcp", "bcc"))
            boundary_path.write_text(boundaries.replace("20 10", "99 10"), encoding="utf-8")
            with self.assertRaisesRegex(ValueError, "missing"):
                read_tsl_reconstruction(grain_path, boundary_path)

    def test_bundled_ti_reconstruction(self):
        folder = Path(__file__).resolve().parents[1] / "gui_ebsd_map" / "ebsd_dataExamples"
        scan = read_tsl_reconstruction(
            folder / "MPIE_Ti_alloy_GF2_RDdownTDright.txt",
            folder / "MPIE_Ti_alloy_RB_RDdownTDright.txt",
        )
        assert_allclose(scan.eulers[0], [252.802, 83.370, 98.58])
        assert_allclose(scan.segments[0], [[0, 9.30], [19.60, 15.36]])
        self.assertEqual(set(scan.phases), {1, 2})
        values = reconstructed_mprime(scan)
        self.assertEqual(len(values), len(scan.pairs))
        self.assertTrue(np.all(np.isfinite(values)))
        self.assertTrue(np.all((values >= 0) & (values <= 1)))

    def test_ti_boundary_regions_use_adjacency_not_centroid(self):
        from shapely.geometry import Point
        from shapely.strtree import STRtree

        folder = Path(__file__).resolve().parents[1] / "gui_ebsd_map" / "ebsd_dataExamples"
        scan = read_tsl_reconstruction(
            folder / "MPIE_Ti_alloy_GF2_RDdownTDright.txt",
            folder / "MPIE_Ti_alloy_RB_RDdownTDright.txt",
        )
        polygons, indices = reconstructed_grain_polygons(scan)
        self.assertEqual(len(polygons), 429)
        self.assertTrue(np.all(indices >= 0))
        missing = np.setdiff1d(scan.grain_ids, scan.grain_ids[indices])
        assert_allclose(missing, [425])
        point = Point(scan.centers[np.flatnonzero(scan.grain_ids == 425)[0]])
        polygon_index = STRtree(polygons).query(point, predicate="within")[0]
        self.assertEqual(scan.grain_ids[indices[polygon_index]], 383)
        import matplotlib.pyplot as plt
        fig, axes = plt.subplots()
        try:
            collection, missing_ids, unresolved = plot_grain_tessellation(axes, scan, np.ones(len(scan.grain_ids)))
            assert_allclose(missing_ids, [425])
            self.assertEqual(unresolved, 1)
            self.assertTrue(np.ma.getmaskarray(collection.get_array())[polygon_index])
        finally:
            plt.close(fig)

    def test_identical_and_symmetry_equivalent_grains(self):
        base = bunge_rotations([[23, 47, 81]])
        equivalent = base * CUBIC
        assert_allclose(cubic_disorientation(base, equivalent), 0, atol=3e-6)
        rotations = Rotation.concatenate([base, equivalent])
        pairs = np.column_stack((np.zeros(len(equivalent), dtype=int), np.arange(1, 25)))
        for structure in ("fcc", "bcc"):
            assert_allclose(maximum_mprime(rotations, pairs, structure), 1, atol=1e-14)

    def test_mprime_matches_direct_dot_products_and_sample_rotation(self):
        rotations = Rotation.random(5, random_state=7)
        pairs = np.array([[0, 1], [1, 2], [3, 4]])
        normals, directions = slip_systems("fcc")
        expected = []
        for first, second in pairs:
            expected.append(max(
                abs(np.dot(rotations[first].apply(normal1), rotations[second].apply(normal2))
                    * np.dot(rotations[first].apply(direction1), rotations[second].apply(direction2)))
                for normal1, direction1 in zip(normals, directions)
                for normal2, direction2 in zip(normals, directions)
            ))
        values = maximum_mprime(rotations, pairs, "fcc")
        assert_allclose(values, expected)
        common = Rotation.from_euler("xyz", [19, 71, 34], degrees=True)
        assert_allclose(maximum_mprime(common * rotations, pairs, "fcc"), values)

    def test_reconstructed_map_supports_signed_metrics_and_masks_missing_values(self):
        import matplotlib.pyplot as plt

        scan = SimpleNamespace(
            pairs=np.array([[0, 1], [0, 2]]),
            segments=np.array([[[0, 0], [1, 0]], [[0, 0], [0, 1]], [[0, 0], [1, 1]]], dtype=float),
            segment_pairs=np.array([0, 1, 1]),
            phases=np.array([1, 1, 2]),
            centers=np.array([[0, 0], [1, 0], [0, 1]], dtype=float),
        )
        figure = plot_reconstructed_map(
            scan, [-0.5, np.nan], title="Signed N", cmap="coolwarm",
            vmin=-1, vmax=1, colorbar_label="Signed N factor",
        )
        try:
            boundaries = figure.axes[0].collections[0]
            assert_allclose([boundaries.norm.vmin, boundaries.norm.vmax], [-1, 1])
            assert_allclose(boundaries.get_array().compressed(), [-0.5])
            self.assertTrue(np.all(np.ma.getmaskarray(boundaries.get_array())[1:]))
            self.assertEqual(figure.axes[-1].get_ylabel(), "Signed N factor")
        finally:
            plt.close(figure)

    def test_reconstruction_and_boundary_geometry(self):
        eulers = np.zeros((2, 3, 3))
        eulers[:, 1:, 0] = 30
        labels, means = reconstruct_grains(eulers, np.ones((2, 3), dtype=bool), 10)
        self.assertEqual(len(means), 2)
        segments, pairs, inverse = boundary_segments(np.arange(3), np.arange(2), labels)
        self.assertEqual(len(pairs), 1)
        self.assertEqual(len(segments), 2)
        assert_allclose(segments[:, :, 0], 0.5)
        assert_allclose(inverse, 0)

    def test_symmetry_does_not_split_grain_and_unindexed_pixels_are_excluded(self):
        eulers = np.zeros((2, 3, 3))
        eulers[:, 1:, 0] = 90
        mask = np.ones((2, 3), dtype=bool)
        mask[0, 0] = False
        labels, means = reconstruct_grains(eulers, mask, 10)
        self.assertEqual(len(means), 1)
        self.assertEqual(labels[0, 0], -1)
        assert_allclose(cubic_disorientation(means, Rotation.identity()), 0, atol=3e-6)

    def test_ctf_decimal_commas_shuffled_rows_and_phase_mask(self):
        text = (
            "Channel Text File\nXCells 2\nYCells 2\nPhases 1\n"
            "2,86;2,86;2,86 90;90;90 Ferrite 11 229\n"
            "Phase X Y Euler1 Euler2 Euler3\n"
            "1 0,5 0,5 30 0 0\n0 0 0 0 0 0\n"
            "1 0,5 0 20 0 0\n1 0 0,5 10 0 0\n"
        )
        with TemporaryDirectory() as directory:
            path = Path(directory) / "test.ctf"
            path.write_text(text, encoding="utf-8")
            x, y, eulers, mask = read_ctf(path, 1)
            assert_allclose(x, [0, 0.5])
            assert_allclose(y, [0, 0.5])
            assert_allclose(eulers[:, :, 0], [[0, 20], [10, 30]])
            self.assertFalse(mask[0, 0])
            path.write_text(text.replace(" 11 229", " 9 194"), encoding="utf-8")
            with self.assertRaisesRegex(ValueError, "cubic"):
                read_ctf(path, 1)


if __name__ == "__main__":
    unittest.main()