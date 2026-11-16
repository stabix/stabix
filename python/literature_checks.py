"""Reproducible diagnostics for Guo literature discrepancies."""

from decimal import Decimal
from itertools import product
from pathlib import Path

import numpy as np
import yaml
from scipy.spatial.transform import Rotation

from ebsd_mprime import bunge_rotations, guo_literature_comparison, maximum_mprime, slip_systems
from experimental_descriptors import slip_pair_descriptors


def patriarca_residual_comparison(folder, tolerance=0.0051):
    """Compare selected BCC slip pairs in units of lattice parameter.

    The historical MATLAB example uses half the unnormalized <111> indices.
    Its reference is not the minimum over all possible slip systems.
    """
    if not np.isfinite(tolerance) or tolerance < 0:
        raise ValueError("The comparison tolerance must be finite and nonnegative.")
    paths = sorted(Path(folder).glob("Patriarca2013_*.yaml"))
    if not paths:
        raise ValueError("No Patriarca 2013 reference cases found.")

    def vector(data, key):
        value = data[key]
        if isinstance(value, list) and len(value) == 1 and isinstance(value[0], str):
            value = value[0].split()
        result = np.asarray(value, dtype=float)
        if result.shape != (3,) or not np.all(np.isfinite(result)):
            raise ValueError(f"{key} must contain three finite indices.")
        return result

    results = []
    for path in paths:
        with path.open(encoding="cp1252") as stream:
            data = yaml.safe_load(stream)
        if data["Phase_A"] != "bcc" or data["Phase_B"] != "bcc":
            raise ValueError(f"{path.name}: expected BCC phases.")
        normal_a, direction_a, normal_b, direction_b = (
            vector(data, key) for key in ("SlipA_norm", "SlipA_dir", "SlipB_norm", "SlipB_dir")
        )
        pair = slip_pair_descriptors(
            data["eulerA"], data["eulerB"],
            (normal_a[None, :], direction_a[None, :]),
            (normal_b[None, :], direction_b[None, :]),
            burgers_a_nm=np.linalg.norm(direction_a) / 2,
            burgers_b_nm=np.linalg.norm(direction_b) / 2,
        )
        calculated = float(pair["residual_burgers_matrix_nm"][0, 0])
        reference = float(data["rbv"])
        error = abs(calculated - reference)
        results.append({
            "case": path.stem, "number": int(data["GB_Number"]),
            "grain_a": int(data["GrainA"]), "grain_b": int(data["GrainB"]),
            "reference": reference, "calculated": calculated,
            "absolute_error": error, "within_tolerance": error <= tolerance,
        })
    return sorted(results, key=lambda row: row["number"])


def _pair_matrix(rotations, first_vectors, second_vectors):
    normals_a, directions_a, normals_b, directions_b = [
        vectors / np.linalg.norm(vectors, axis=1, keepdims=True)
        for vectors in (*first_vectors, *second_vectors)
    ]
    return np.abs(
        (rotations[0].apply(normals_a) @ rotations[1].apply(normals_b).T)
        * (rotations[0].apply(directions_a) @ rotations[1].apply(directions_b).T)
    )


def diagnose_guo_mismatches(folder, tolerance=0.0051):
    """Test invariants, precision, family choices, and individual slip pairs.

    Euler uncertainty is half the last printed decimal place in each YAML
    component. A rigorous change bound is twice the sum of these uncertainties
    in radians, also valid for the maximum over slip pairs. Corner perturbations
    are samples, not guaranteed extrema. Nearest individual pairs are post-hoc
    diagnostics, not identified active slip. References are never modified.
    """
    group = Rotation.create_group("D6")
    symmetry_pairs = np.array(list(product(range(12), range(12, 24))))
    corners = np.array(list(product((-1, 1), repeat=6))).reshape(-1, 2, 3)
    corner_pairs = np.arange(128).reshape(-1, 2)
    common = Rotation.from_euler("xyz", [13, 47, 82], degrees=True)
    results = []
    for comparison in guo_literature_comparison(folder, tolerance):
        path = Path(folder) / f"{comparison['case']}.yaml"
        text = path.read_text(encoding="utf-8-sig")
        data = yaml.safe_load(text)
        nodes = {key.value: value for key, value in yaml.compose(text).value}
        eulers = np.array([data["eulerA"], data["eulerB"]])
        widths = np.array([
            [0.5 * 10.0**Decimal(value.value).as_tuple().exponent for value in nodes[key].value]
            for key in ("eulerA", "eulerB")
        ])
        commented = []
        for key in ("eulerA", "eulerB"):
            line = text.splitlines()[nodes[key].end_mark.line]
            _, separator, comment = line.partition("#")
            value = yaml.safe_load(comment) if separator else None
            if not isinstance(value, list) or len(value) != 3:
                raise ValueError(f"Expected a commented Euler triplet for {key} in {path.name}.")
            commented.append(value)
        rotations = bunge_rotations(eulers)
        first_family = "hcp_basal" if "A basal" in comparison["comparison"] else "hcp_prismatic1"
        second_family = "hcp_prismatic1"
        first_vectors, second_vectors = slip_systems(first_family), slip_systems(second_family)
        baseline, reference = comparison["calculated"], comparison["reference"]

        def maximum(orientations, family_a=first_family, family_b=second_family):
            return float(maximum_mprime(orientations, np.array([[0, 1]]), family_a, family_b)[0])

        pair_matrix = _pair_matrix(rotations, first_vectors, second_vectors)
        reverse_matrix = _pair_matrix(rotations, second_vectors, first_vectors)
        closest = np.unravel_index(np.argmin(np.abs(pair_matrix - reference)), pair_matrix.shape)
        reverse_closest = np.unravel_index(np.argmin(np.abs(reverse_matrix - reference)), reverse_matrix.shape)
        scale_factors = (np.array([0.2, 3, 10]), np.array([7, 0.4, 2]))
        scaled_a = [vectors * scales[:, None] for vectors, scales in zip(first_vectors, scale_factors)]
        scaled_b = [vectors * scales[::-1, None] for vectors, scales in zip(second_vectors, scale_factors)]
        signed_a = [vectors * signs[:, None] for vectors, signs in zip(
            first_vectors, (np.array([-1, 1, -1]), np.array([1, -1, -1])),
        )]
        symmetry_rotations = Rotation.concatenate([rotations[0] * group, rotations[1] * group])
        symmetry_values = maximum_mprime(symmetry_rotations, symmetry_pairs, first_family, second_family)
        perturbed = bunge_rotations((eulers[None, :, :] + corners * widths).reshape(-1, 3))
        rounding_values = maximum_mprime(perturbed, corner_pairs, first_family, second_family)
        bound = float(2 * np.deg2rad(widths.sum()))
        first_offset = 1 if first_family == "hcp_basal" else 4
        results.append({
            **comparison,
            "unit_norm_error": float(max(
                np.max(np.abs(np.linalg.norm(vectors, axis=1) - 1))
                for vectors in (*first_vectors, *second_vectors)
            )),
            "orthogonality_error": float(max(
                np.max(np.abs(np.sum(normals * directions, axis=1)))
                for normals, directions in (first_vectors, second_vectors)
            )),
            "normalization_delta": float(abs(pair_matrix.max() - baseline)),
            "scaling_delta": float(abs(_pair_matrix(rotations, scaled_a, scaled_b).max() - baseline)),
            "sign_delta": float(np.max(np.abs(_pair_matrix(rotations, signed_a, second_vectors) - pair_matrix))),
            "periodic_delta": max(abs(maximum(bunge_rotations(eulers % 360)) - baseline),
                                  abs(maximum(bunge_rotations(eulers + 360)) - baseline)),
            "symmetry_delta": float(np.max(np.abs(symmetry_values - baseline))),
            "sample_frame_delta": abs(maximum(common * rotations) - baseline),
            "rounding_bound": bound,
            "rounding_sample_min": float(rounding_values.min()),
            "rounding_sample_max": float(rounding_values.max()),
            "rounding_excluded": bool(comparison["absolute_error"] > tolerance + bound),
            "integer_angles_value": maximum(bunge_rotations(np.round(eulers))),
            "commented_angles_value": maximum(bunge_rotations(commented)),
            "inverse_orientation_value": maximum(rotations.inv()),
            "modulo180_value": maximum(bunge_rotations(eulers % 180)),
            "reversed_family_maximum": maximum(rotations, second_family, first_family),
            "prism2_value": maximum(rotations, "hcp_basal" if first_offset == 1 else "hcp_prismatic2",
                                    "hcp_prismatic2"),
            "closest_pair_value": float(pair_matrix[closest]),
            "closest_pair_error": float(abs(pair_matrix[closest] - reference)),
            "closest_pair_indices": (int(closest[0] + first_offset), int(closest[1] + 4)),
            "reverse_closest_pair_value": float(reverse_matrix[reverse_closest]),
            "reverse_closest_pair_error": float(abs(reverse_matrix[reverse_closest] - reference)),
            "reverse_closest_pair_indices": (int(reverse_closest[0] + 4), int(reverse_closest[1] + first_offset)),
        })
    return results


if __name__ == "__main__":
    folder = Path(__file__).resolve().parents[1] / "gui_bicrystal" / "gui_bicrystal_data" / "guo_2014"
    results = diagnose_guo_mismatches(folder)
    for result in results:
        print(
            result["case"], result["comparison"],
            f"reference={result['reference']:.2f} maximum={result['calculated']:.6f}",
            f"nearest={result['closest_pair_value']:.6f} {result['closest_pair_indices']}",
            f"reverse-nearest={result['reverse_closest_pair_value']:.6f}",
            f"Prism2={result['prism2_value']:.6f}",
        )
    for metric in ("unit_norm_error", "orthogonality_error", "normalization_delta", "scaling_delta",
                   "sign_delta", "periodic_delta", "symmetry_delta", "sample_frame_delta", "rounding_bound"):
        print(f"{metric}: {max(result[metric] for result in results):.6g}")