"""Experimental crystallographic, indentation, and topography descriptors."""

from datetime import datetime, timezone
from hashlib import sha256
from importlib.metadata import version
from itertools import product
from pathlib import Path
import json

import numpy as np
from scipy.integrate import trapezoid
from scipy.interpolate import RegularGridInterpolator
from scipy.optimize import least_squares
from scipy.signal import find_peaks
from scipy.stats import bootstrap, circmean, circstd, spearmanr
from scipy.spatial.transform import Rotation

from ebsd_mprime import bunge_rotations, slip_systems


METHOD_VERSION = "experimental-descriptors-1.0"


def unit_vectors(vectors):
    values = np.asarray(vectors, dtype=float)
    if values.ndim == 0:
        raise ValueError("Expected three-component vectors.")
    lengths = np.linalg.norm(values, axis=-1, keepdims=True)
    if values.shape[-1] != 3 or not np.all(np.isfinite(values)) or np.any(lengths == 0):
        raise ValueError("Expected finite, nonzero three-component vectors.")
    return values / lengths


def orientation_descriptors(eulers_deg, structure="hcp", sample_direction=(0, 0, 1)):
    """Return Bunge conventions and antipodal stereographic IPF coordinates.

    HCP uses the 0-30 degree basal sector and positive c hemisphere. Cubic
    directions use the standard [001]-[011]-[111] sector. Quaternions are xyzw.
    """
    eulers = np.asarray(eulers_deg, dtype=float)
    if eulers.ndim != 2 or eulers.shape[1] != 3 or not np.all(np.isfinite(eulers)):
        raise ValueError("Euler angles must be a finite N x 3 array in degrees.")
    rotations = bunge_rotations(eulers)
    crystal_direction = rotations.inv().apply(unit_vectors(sample_direction))
    if structure == "hcp":
        azimuth = np.mod(np.arctan2(crystal_direction[:, 1], crystal_direction[:, 0]), np.pi / 3)
        azimuth = np.minimum(azimuth, np.pi / 3 - azimuth)
        vertical = np.abs(crystal_direction[:, 2])
        lateral = np.sqrt(np.clip(1 - vertical**2, 0, 1))
        reduced = np.column_stack((lateral * np.cos(azimuth), lateral * np.sin(azimuth), vertical))
    elif structure in ("fcc", "bcc"):
        reduced = np.sort(np.abs(crystal_direction), axis=1)
    else:
        raise ValueError("IPF reduction currently supports HCP, FCC, and BCC.")
    return {
        "sample_to_crystal": rotations.as_matrix().transpose(0, 2, 1),
        "crystal_to_sample": rotations.as_matrix(),
        "quaternion_xyzw": rotations.as_quat(),
        "loading_direction_crystal": crystal_direction,
        "ipf_direction": reduced,
        "ipf_xy": reduced[:, :2] / (1 + reduced[:, 2, None]),
        "c_axis_angle_deg": np.degrees(np.arccos(np.clip(np.abs(crystal_direction[:, 2]), 0, 1))),
    }


def family_orientation_factors(eulers_deg, families, sample_direction=(0, 0, 1)):
    """Compute each family's max |l.n| |l.d|; this is not indentation RSS."""
    rotations = bunge_rotations(np.asarray(eulers_deg, dtype=float))
    loading = rotations.inv().apply(unit_vectors(sample_direction))
    results = {}
    for name, (normals, directions) in families.items():
        normals, directions = unit_vectors(normals), unit_vectors(directions)
        if normals.shape != directions.shape or np.any(np.abs(np.sum(normals * directions, axis=1)) > 1e-8):
            raise ValueError("Each slip normal must be perpendicular to its paired direction.")
        systems = np.abs(loading @ normals.T) * np.abs(loading @ directions.T)
        results[name] = {"per_system": systems, "maximum": systems.max(axis=1),
                         "maximizing_system": systems.argmax(axis=1)}
    return results


def competition_index(first, second, epsilon=1e-12):
    """Return (first-second)/(first+second+epsilon) and a definedness mask."""
    first, second = np.broadcast_arrays(np.asarray(first, dtype=float), np.asarray(second, dtype=float))
    if epsilon <= 0 or np.any(first < 0) or np.any(second < 0) or not np.all(np.isfinite(first + second)):
        raise ValueError("Factors must be finite and nonnegative; epsilon must be positive.")
    valid = first + second > epsilon
    values = np.where(valid, (first - second) / (first + second + epsilon), np.nan)
    return values, valid


def resistance_competition(first, second, crss_first, crss_second, epsilon=1e-12):
    """Return log(D_first/D_second) using dimensionless driving-force scales.

    CRSS inputs share a stress unit. Multiplying M/tau by a common CRSS scale
    makes the numerical epsilon dimensionless and avoids stress-unit dependence.
    """
    if not np.isfinite(crss_first + crss_second) or min(crss_first, crss_second) <= 0:
        raise ValueError("Both CRSS values must be finite and positive in the same unit.")
    _, valid = competition_index(first, second, epsilon)
    scale = np.sqrt(crss_first * crss_second)
    driving_first = np.asarray(first) * scale / crss_first
    driving_second = np.asarray(second) * scale / crss_second
    return np.where(valid, np.log((driving_first + epsilon) / (driving_second + epsilon)), np.nan)


def slip_trace_angles(eulers_deg, normals_crystal, surface_normal=(0, 0, 1)):
    """Sample XY line angles modulo 180; in-plane surface normal must be Z."""
    surface = unit_vectors(surface_normal)
    if not np.allclose(surface, [0, 0, 1]):
        raise ValueError("XY trace angles currently require the sample Z surface normal.")
    matrices = bunge_rotations(np.asarray(eulers_deg, dtype=float)).as_matrix()
    normals = np.einsum("gij,sj->gsi", matrices, unit_vectors(normals_crystal))
    traces = np.cross(surface, normals)
    valid = np.linalg.norm(traces, axis=-1) > 1e-10
    angles = np.mod(np.degrees(np.arctan2(traces[..., 1], traces[..., 0])), 180)
    return np.where(valid, angles, np.nan)


def trace_deviation(observed_deg, predicted_deg, calibration_deg=None):
    """Minimum unoriented-line deviation; refuse uncalibrated AFM angles."""
    if calibration_deg is None or not np.isfinite(calibration_deg):
        raise ValueError("An independently calibrated AFM-to-sample rotation is required.")
    predicted = np.asarray(predicted_deg, dtype=float)
    predicted = predicted[np.isfinite(predicted)]
    if not len(predicted):
        return np.full_like(np.asarray(observed_deg, dtype=float), np.nan)
    observed = np.asarray(observed_deg, dtype=float) + calibration_deg
    differences = np.abs((observed[..., None] - predicted + 90) % 180 - 90)
    return differences.min(axis=-1)


def same_phase_misorientation(eulers_first, eulers_second, structure="hcp"):
    """Minimum disorientation angle under proper HCP or cubic crystal symmetry."""
    groups = {"hcp": "D6", "fcc": "O", "bcc": "O"}
    if structure not in groups:
        raise ValueError("Disorientation supports same-phase HCP, FCC, and BCC only.")
    relative = (bunge_rotations(eulers_first).inv() * bunge_rotations(eulers_second)).as_quat()
    operators = Rotation.create_group(groups[structure]).as_quat()
    cosine = np.max(np.abs(relative @ operators.T), axis=-1)
    return np.degrees(2 * np.arccos(np.clip(cosine, 0, 1)))


def basal_prism_families():
    return {"basal": slip_systems("hcp_basal"), "prism1": slip_systems("hcp_prismatic1")}


def hcp_slip_families(c_over_a=0.471 / 0.298):
    """All six HCP slip families (33 systems), following STABiX MATLAB indices.

    Twins are deliberately excluded; their polarity requires other treatment.
    """
    if not np.isfinite(c_over_a) or c_over_a <= 0:
        raise ValueError("The c/a lattice ratio must be finite and positive.")
    families = {**basal_prism_families(), "prism2": slip_systems("hcp_prismatic2")}
    indices = {
        "pyram1_a": (
            [[0, -1, 1, 1], [1, 0, -1, 1], [-1, 1, 0, 1], [1, -1, 0, 1], [0, 1, -1, 1], [-1, 0, 1, 1]],
            [[2, -1, -1, 0], [-1, 2, -1, 0], [-1, -1, 2, 0], [1, 1, -2, 0], [-2, 1, 1, 0], [1, -2, 1, 0]],
        ),
        "pyram1_ca": (
            [[-1, 1, 0, 1], [-1, 1, 0, 1], [1, 0, -1, 1], [1, 0, -1, 1], [0, -1, 1, 1], [0, -1, 1, 1],
             [1, -1, 0, 1], [1, -1, 0, 1], [-1, 0, 1, 1], [-1, 0, 1, 1], [0, 1, -1, 1], [0, 1, -1, 1]],
            [[2, -1, -1, 3], [1, -2, 1, 3], [-1, -1, 2, 3], [-2, 1, 1, 3], [-1, 2, -1, 3], [1, 1, -2, 3],
             [-2, 1, 1, 3], [-1, 2, -1, 3], [1, 1, -2, 3], [2, -1, -1, 3], [1, -2, 1, 3], [-1, -1, 2, 3]],
        ),
        "pyram2_ca": (
            [[-2, 1, 1, 2], [1, -2, 1, 2], [1, 1, -2, 2], [2, -1, -1, 2], [-1, 2, -1, 2], [-1, -1, 2, 2]],
            [[2, -1, -1, 3], [-1, 2, -1, 3], [-1, -1, 2, 3], [-2, 1, 1, 3], [1, -2, 1, 3], [1, 1, -2, 3]],
        ),
    }
    for name, (planes, directions) in indices.items():
        planes, directions = np.asarray(planes), np.asarray(directions)
        normals = np.column_stack((planes[:, 0], (2 * planes[:, 1] + planes[:, 0]) / np.sqrt(3), planes[:, 3] / c_over_a))
        vectors = np.column_stack((1.5 * directions[:, 0], np.sqrt(3) / 2 * (2 * directions[:, 1] + directions[:, 0]), directions[:, 3] * c_over_a))
        families[name] = unit_vectors(normals), unit_vectors(vectors)
    return families


def cubic_slip_families(structure="bcc"):
    """Generate FCC {111}<110> or BCC {110}/{112}/{123}<111> families."""
    if structure == "fcc":
        return {"fcc111": slip_systems("fcc")}
    if structure != "bcc":
        raise ValueError("Cubic slip-family enumeration supports FCC and BCC.")
    directions = np.array(list(product((-1, 1), repeat=3)))
    directions = directions[directions[:, 0] > 0]
    families = {}
    for name, seed in (("bcc110", [1, 1, 0]), ("bcc112", [1, 1, 2]), ("bcc123", [1, 2, 3])):
        normals = np.rint(Rotation.create_group("O").apply(seed)).astype(int)
        first = np.argmax(normals != 0, axis=1)
        normals *= np.sign(normals[np.arange(len(normals)), first])[:, None]
        normals = np.unique(normals, axis=0)
        systems = np.array([(normal, direction) for normal in normals for direction in directions if np.dot(normal, direction) == 0])
        families[name] = unit_vectors(systems[:, 0]), unit_vectors(systems[:, 1])
    return families


def slip_pair_descriptors(euler_a, euler_b, systems_a, systems_b, burgers_a_nm=None,
                          burgers_b_nm=None, boundary_normal_sample=None):
    """Slip-pair m-prime, signed N factor, and optional residual Burgers vectors.

    N follows slip_transfer/N_factor.m. Residual magnitude uses the smaller
    of bA-bB and bA+bB for bidirectional slip. Family minima need not occur at
    the m-prime maximum. A boundary trace alone does not determine inclination.
    """
    rotations = bunge_rotations([euler_a, euler_b])
    normal_a, direction_a = [rotations[0].apply(unit_vectors(vectors)) for vectors in systems_a]
    normal_b, direction_b = [rotations[1].apply(unit_vectors(vectors)) for vectors in systems_b]
    if np.any(np.abs(np.sum(normal_a * direction_a, axis=1)) > 1e-8) or np.any(np.abs(np.sum(normal_b * direction_b, axis=1)) > 1e-8):
        raise ValueError("Slip plane normals and directions must be perpendicular.")
    normal_dot, direction_dot = normal_a @ normal_b.T, direction_a @ direction_b.T
    products = normal_dot * direction_dot
    n_factor = products + (normal_a @ direction_b.T) * (direction_a @ normal_b.T)
    maximum_pair = np.unravel_index(np.argmax(np.abs(products)), products.shape)
    result = {"mprime_matrix": np.abs(products), "N_signed_matrix": n_factor,
              "max_mprime": float(np.max(np.abs(products))), "max_abs_N": float(np.max(np.abs(n_factor))),
              "maximizing_pair": tuple(int(index) for index in maximum_pair),
              "min_residual_burgers_nm": np.nan, "residual_at_max_mprime_nm": np.nan,
              "boundary_inclination_deg": np.nan}
    if (burgers_a_nm is None) != (burgers_b_nm is None):
        raise ValueError("Supply Burgers magnitudes for both grains or neither.")
    if burgers_a_nm is not None:
        first = np.broadcast_to(np.asarray(burgers_a_nm, dtype=float), (len(direction_a),))
        second = np.broadcast_to(np.asarray(burgers_b_nm, dtype=float), (len(direction_b),))
        if np.any(first <= 0) or np.any(second <= 0) or not np.all(np.isfinite(first)) or not np.all(np.isfinite(second)):
            raise ValueError("Burgers-vector magnitudes must be finite and positive.")
        abs_direction_dot = np.abs(direction_dot)
        residual = np.sqrt(np.maximum(first[:, None]**2 + second[None, :]**2 - 2 * first[:, None] * second[None, :] * abs_direction_dot, 0))
        result.update({"residual_burgers_matrix_nm": residual, "min_residual_burgers_nm": float(residual.min()),
                       "residual_at_max_mprime_nm": float(residual[maximum_pair])})
    if boundary_normal_sample is not None:
        normal = unit_vectors(boundary_normal_sample)
        result["boundary_inclination_deg"] = float(np.degrees(np.arccos(np.clip(abs(normal[2]), 0, 1))))
    return result


def unloading_descriptors(depth_nm, load_mn, area_function_nm2=None, fit_fraction=(0.2, 0.95)):
    """Fit an unloading segment to P=alpha*(h-hf)^m in nm and mN.

    Hardness is conventional Oliver-Pharr hardness, not pile-up corrected.
    The caller must pass an independently calibrated area function in nm^2.
    """
    depth, load = np.asarray(depth_nm, dtype=float), np.asarray(load_mn, dtype=float)
    if depth.ndim != 1 or depth.shape != load.shape or len(depth) < 8:
        raise ValueError("An unloading segment with at least eight paired samples is required.")
    if not np.all(np.isfinite(depth + load)) or np.any(depth < 0) or np.any(load < 0):
        raise ValueError("Depth and load must be finite and nonnegative after baseline correction.")
    lower, upper = fit_fraction
    if not 0 < lower < upper <= 1:
        raise ValueError("Fit fractions must satisfy 0 < lower < upper <= 1.")
    maximum_load = float(load.max())
    maximum_depth = float(depth[np.argmax(load)])
    selected = (load >= lower * maximum_load) & (load <= upper * maximum_load)
    if maximum_load <= 0 or np.count_nonzero(selected) < 6 or np.ptp(depth[selected]) == 0:
        raise ValueError("Insufficient unloading data in the requested load interval.")
    fit_depth, fit_load = depth[selected], load[selected]
    residual_upper = fit_depth.min() - 1e-8
    if residual_upper <= 0:
        raise ValueError("Selected unloading depths must exceed zero.")
    initial_residual = residual_upper * 0.5
    initial_exponent = 1.5
    initial_alpha = maximum_load / (maximum_depth - initial_residual)**initial_exponent

    def residual(parameters):
        log_alpha, residual_depth, exponent = parameters
        return (np.exp(log_alpha) * (fit_depth - residual_depth)**exponent - fit_load) / maximum_load

    fit = least_squares(
        residual, [np.log(initial_alpha), initial_residual, initial_exponent],
        bounds=([-50, 0, 1.01], [50, residual_upper, 3]), x_scale="jac", max_nfev=5000,
        ftol=1e-12, xtol=1e-12, gtol=1e-12,
    )
    if not fit.success:
        raise ValueError(f"Unloading fit did not converge: {fit.message}")
    log_alpha, residual_depth, exponent = fit.x
    alpha = float(np.exp(log_alpha))
    stiffness = float(alpha * exponent * (maximum_depth - residual_depth)**(exponent - 1))
    contact_depth = float(maximum_depth - 0.75 * maximum_load / stiffness)
    if contact_depth <= 0:
        raise ValueError("The fit produces a nonpositive Oliver-Pharr contact depth.")
    area = np.nan if area_function_nm2 is None else float(area_function_nm2(contact_depth))
    if area_function_nm2 is not None and (not np.isfinite(area) or area <= 0):
        raise ValueError("The calibrated area function must return a positive finite area.")
    predicted = alpha * (fit_depth - residual_depth)**exponent
    denominator = np.sum((fit_load - fit_load.mean())**2)
    return {
        "pmax_mN": maximum_load, "hmax_nm": maximum_depth,
        "alpha_mN_nm_minus_m": alpha, "exponent_m": float(exponent), "hf_nm": float(residual_depth),
        "stiffness_mN_per_nm": stiffness, "stiffness_N_per_m": stiffness * 1e6,
        "contact_depth_nm": contact_depth, "contact_area_nm2": area,
        "hardness_GPa": float(maximum_load / area * 1e6),
        "fit_r_squared": float(1 - np.sum((fit_load - predicted)**2) / denominator) if denominator > 0 else np.nan,
        "fit_samples": int(selected.sum()), "fit_fraction": list(fit_fraction),
        "hardness_valid": bool(area_function_nm2 is not None),
        "fit_depth_nm": fit_depth, "fit_load_mN": fit_load, "predicted_load_mN": predicted,
    }


def read_afm_height(path):
    """Read a measured height channel with Gwyddion's calibrated SI units."""
    import gwyddionpy

    path = Path(path)
    if not path.is_file():
        raise FileNotFoundError(f"AFM scan not found: {path}")
    data = gwyddionpy.load(str(path))
    if "Height" not in data.channels:
        raise ValueError(f"No Height channel in {path.name}; available: {list(data.channels)}")
    channel = data.channels["Height"]
    if channel.si_unit_xy != "m" or channel.si_unit_z != "m":
        raise ValueError("The AFM height channel must have lateral and height units in meters.")
    height = np.asarray(channel.data, dtype=float)
    if height.ndim != 2 or min(height.shape) < 3 or not np.isfinite(height).any():
        raise ValueError("The AFM Height channel must be a nonempty two-dimensional measurement.")
    if not np.isfinite(channel.xreal) or not np.isfinite(channel.yreal) or min(channel.xreal, channel.yreal) <= 0:
        raise ValueError("The AFM scan dimensions must be finite and positive.")
    rows, columns = height.shape
    return {
        "x_um": (np.arange(columns) + 0.5) * channel.xreal * 1e6 / columns,
        "y_um": (np.arange(rows) + 0.5) * channel.yreal * 1e6 / rows,
        "height_nm": height * 1e9,
        "source_format": data.source_format,
        "source_sha256": sha256(path.read_bytes()).hexdigest(),
        "channel": "Height",
        "metadata": channel.meta,
    }


def afm_descriptors(x_um, y_um, height_nm, center_um, radius_um, level_annulus_um,
                    intensity_annulus_um, hmax_nm=None, level_mask=None,
                    positive_threshold_nm=0, angle_samples=180):
    """Plane-level a regular AFM field and integrate only valid circular ROI data.

    X/Y are increasing micrometer coordinates and Z is in nanometers. The
    leveling annulus (or explicit mask) must represent undeformed surface.
    Angular intensity is integral(h_positive[um] dr[um]), hence um^2.
    """
    x_values, y_values = np.asarray(x_um, dtype=float), np.asarray(y_um, dtype=float)
    heights = np.asarray(height_nm, dtype=float)
    if heights.shape != (len(y_values), len(x_values)) or min(len(x_values), len(y_values)) < 3:
        raise ValueError("Height shape must be (len(y), len(x)) on a regular 2D grid.")
    for coordinates in (x_values, y_values):
        if not np.all(np.isfinite(coordinates)) or np.any(np.diff(coordinates) <= 0):
            raise ValueError("AFM coordinates must be finite and strictly increasing.")
        if not np.allclose(np.diff(coordinates), np.diff(coordinates)[0]):
            raise ValueError("AFM integration requires a uniformly spaced grid.")
    if not np.all(np.isfinite(center_um)) or radius_um <= 0 or positive_threshold_nm < 0 or angle_samples < 12:
        raise ValueError("Invalid ROI center, radius, height threshold, or angle sampling.")
    level_inner, level_outer = level_annulus_um
    radial_inner, radial_outer = intensity_annulus_um
    if not (0 <= level_inner < level_outer <= radius_um and 0 <= radial_inner < radial_outer <= radius_um):
        raise ValueError("Leveling and intensity annuli must lie within the circular ROI.")
    if hmax_nm is not None and (not np.isfinite(hmax_nm) or hmax_nm <= 0):
        raise ValueError("hmax must be finite and positive when supplied.")
    xx, yy = np.meshgrid(x_values - center_um[0], y_values - center_um[1])
    radial = np.hypot(xx, yy)
    roi = radial <= radius_um
    finite = np.isfinite(heights)
    leveling = (radial >= level_inner) & (radial <= level_outer) if level_mask is None else np.asarray(level_mask, dtype=bool)
    if leveling.shape != heights.shape:
        raise ValueError("The leveling mask must match the height field.")
    leveling = leveling & roi & finite
    design = np.column_stack((xx[leveling], yy[leveling], np.ones(np.count_nonzero(leveling))))
    if len(design) < 6 or np.linalg.matrix_rank(design) < 3:
        raise ValueError("Insufficient noncollinear valid pixels for plane leveling.")
    coefficients = np.linalg.lstsq(design, heights[leveling], rcond=None)[0]
    plane = coefficients[0] * xx + coefficients[1] * yy + coefficients[2]
    levelled = np.where(roi & finite, heights - plane, np.nan)
    numerical_zero = 100 * np.finfo(float).eps * max(1, float(np.nanmax(np.abs(heights[finite]))))
    levelled[np.abs(levelled) < numerical_zero] = 0
    positive = np.where(np.isfinite(levelled), np.where(levelled > positive_threshold_nm, levelled, 0), np.nan)
    pixel_area = float(np.diff(x_values)[0] * np.diff(y_values)[0])
    pileup_height = float(np.nanmax(np.maximum(levelled, 0)))
    radial_samples = np.linspace(radial_inner, radial_outer, 256)
    angles = np.linspace(0, 2 * np.pi, angle_samples, endpoint=False)
    polar_x = center_um[0] + np.cos(angles)[:, None] * radial_samples
    polar_y = center_um[1] + np.sin(angles)[:, None] * radial_samples
    interpolator = RegularGridInterpolator((y_values, x_values), positive, bounds_error=False, fill_value=np.nan)
    polar_height = interpolator(np.stack((polar_y, polar_x), axis=-1))
    complete_rays = np.all(np.isfinite(polar_height), axis=1)
    intensity = np.where(complete_rays, trapezoid(polar_height * 1e-3, radial_samples, axis=1), np.nan)
    peak_angles = np.array([])
    symmetry = {}
    if np.all(np.isfinite(intensity)) and intensity.max() > 0:
        peaks, _ = find_peaks(np.tile(intensity, 3), prominence=0.1 * intensity.max())
        peaks = peaks[(peaks >= angle_samples) & (peaks < 2 * angle_samples)] - angle_samples
        peak_angles = np.degrees(angles[peaks])
        for order in (2, 3, 6):
            symmetry[str(order)] = float(abs(np.sum(intensity * np.exp(-1j * order * angles))) / intensity.sum())
    return {
        "height_levelled_nm": levelled, "roi_mask": roi, "valid_mask": roi & finite,
        "plane_coefficients_nm_per_um_nm": coefficients,
        "h_PU_nm": pileup_height, "R_h": pileup_height / hmax_nm if hmax_nm is not None else np.nan,
        "A_PU_um2": float(np.count_nonzero(positive > 0) * pixel_area),
        "V_PU_um3": float(np.nansum(positive) * 1e-3 * pixel_area),
        "roi_valid_fraction": float(np.count_nonzero(roi & finite) / np.count_nonzero(roi)),
        "roi_clipped_by_field": bool(center_um[0] - radius_um < x_values[0] or center_um[0] + radius_um > x_values[-1]
                                     or center_um[1] - radius_um < y_values[0] or center_um[1] + radius_um > y_values[-1]),
        "angles_deg": np.degrees(angles), "intensity_um2": intensity,
        "angular_ray_valid_fraction": np.mean(np.isfinite(polar_height), axis=1),
        "peak_angles_deg": peak_angles, "angular_symmetry_amplitudes": symmetry,
        "processing": {"center_um": list(center_um), "radius_um": radius_um,
                       "level_annulus_um": list(level_annulus_um), "intensity_annulus_um": list(intensity_annulus_um),
                       "positive_threshold_nm": positive_threshold_nm, "angle_samples": angle_samples,
                       "pixel_area_um2": pixel_area, "level_mask_supplied": level_mask is not None},
    }


def association_summary(first, second, n_resamples=400, seed=42, cluster_ids=None):
    """Spearman association with percentile bootstrap CI, optionally by grain."""
    first, second = np.asarray(first, dtype=float), np.asarray(second, dtype=float)
    if first.ndim != 1 or first.shape != second.shape:
        raise ValueError("Association inputs must be matching vectors.")
    valid = np.isfinite(first) & np.isfinite(second)
    if np.count_nonzero(valid) < 5 or np.ptp(first[valid]) == 0 or np.ptp(second[valid]) == 0:
        raise ValueError("At least five finite, nonconstant paired values are required.")
    first, second = first[valid], second[valid]
    estimate = spearmanr(first, second)
    if cluster_ids is None:
        interval = bootstrap(
            (first, second), lambda left, right: spearmanr(left, right).statistic,
            paired=True, vectorized=False, n_resamples=n_resamples, method="percentile", random_state=seed,
        )
        resampling_unit = "record"
    else:
        clusters = np.asarray(cluster_ids)
        if clusters.shape != valid.shape:
            raise ValueError("Cluster IDs must match association inputs.")
        clusters = clusters[valid]
        identities = np.unique(clusters)
        if len(identities) < 5:
            raise ValueError("Cluster bootstrap requires at least five independent grains.")

        def statistic(indices):
            selected = np.concatenate([np.flatnonzero(clusters == identities[int(index)]) for index in indices])
            return spearmanr(first[selected], second[selected]).statistic

        interval = bootstrap((np.arange(len(identities)),), statistic, vectorized=False,
                             n_resamples=n_resamples, method="percentile", random_state=seed)
        resampling_unit = "grain"

    result = {
        "spearman_rho": float(estimate.statistic),
        "p_value": float(estimate.pvalue) if cluster_ids is None else np.nan,
        "p_value_note": "record independence assumed" if cluster_ids is None else "not reported for clustered data",
        "rho_ci_95": [float(interval.confidence_interval.low), float(interval.confidence_interval.high)],
        "paired_records": len(first), "bootstrap_resampling_unit": resampling_unit,
        "bootstrap_resamples": n_resamples, "seed": seed,
    }
    return result


def axial_statistics(angles_deg):
    """Unoriented-line circular statistics using doubled angles."""
    angles = np.asarray(angles_deg, dtype=float)
    angles = angles[np.isfinite(angles)]
    if not len(angles):
        raise ValueError("At least one finite line angle is required.")
    doubled = 2 * np.radians(angles)
    resultant = float(abs(np.mean(np.exp(1j * doubled))))
    mean = float(np.degrees(circmean(doubled)) / 2 % 180) if resultant > 1e-10 else np.nan
    if np.isfinite(mean) and np.isclose(mean, 180):
        mean = 0.0
    return {"mean_line_angle_deg": mean, "resultant_length": resultant,
            "circular_std_deg": float(np.degrees(circstd(doubled)) / 2), "count": len(angles)}


def ordinal_evidence_model(eta, classes, leave_one_out=False, grain_ids=None):
    """Proportional-odds evidence classification: logit P(Y<=k)=alpha_k-beta*eta.

    Class codes are 0=basal-compatible, 1=mixed, 2=prismatic-compatible.
    Classes must come from independent evidence, not thresholding eta itself.
    Grain IDs switch cross-validation to leave-one-grain-out. Failed folds
    retain NaN predictions and are reported rather than silently removed.
    """
    from statsmodels.miscmodels.ordinal_model import OrderedModel

    eta, classes = np.asarray(eta, dtype=float), np.asarray(classes)
    if eta.ndim != 1 or eta.shape != classes.shape or len(eta) < 9 or not np.all(np.isfinite(eta)):
        raise ValueError("At least nine complete eta/class pairs are required.")
    if set(classes.tolist()) != {0, 1, 2} or np.ptp(eta) == 0:
        raise ValueError("All three ordered classes and a varying predictor are required.")

    def fit_model(predictor, labels):
        fitted = OrderedModel(labels, predictor[:, None], distr="logit").fit(method="bfgs", disp=False)
        if not fitted.mle_retvals.get("converged", False):
            raise ValueError("Ordinal fit did not converge.")
        return fitted

    fitted = fit_model(eta, classes)
    result = {"fit": fitted, "beta": float(fitted.params[0]),
              "beta_ci_95": np.asarray(fitted.conf_int())[0].tolist(),
              "beta_ci_note": "model-based interval, not cluster-robust",
              "thresholds": fitted.model.transform_threshold_params(fitted.params)[1:-1].tolist(),
              "probabilities": np.asarray(fitted.model.predict(fitted.params, exog=eta[:, None])),
              "cross_validation": None}
    if leave_one_out:
        folds = np.arange(len(eta)) if grain_ids is None else np.asarray(grain_ids)
        if folds.shape != eta.shape or len(np.unique(folds)) < 2:
            raise ValueError("Cross-validation requires matching IDs with at least two independent groups.")
        probabilities = np.full((len(eta), 3), np.nan)
        failures = []
        for fold in np.unique(folds):
            test = folds == fold
            if len(np.unique(classes[~test])) < 3:
                failures.append(str(fold))
                continue
            try:
                held_out = fit_model(eta[~test], classes[~test])
                probabilities[test] = held_out.model.predict(held_out.params, exog=eta[test, None])
            except (ValueError, np.linalg.LinAlgError):
                failures.append(str(fold))
        complete = np.all(np.isfinite(probabilities), axis=1)
        result["cross_validation"] = {
            "unit": "record" if grain_ids is None else "grain", "probabilities": probabilities,
            "valid_fraction": float(complete.mean()), "failed_folds": failures,
            "accuracy": float(np.mean(probabilities[complete].argmax(axis=1) == classes[complete])) if np.any(complete) else np.nan,
        }
    return result


def provenance_manifest(sources, parameters, units, dataset_role="experimental"):
    """Processing metadata suitable for a sidecar to exported descriptor tables."""
    if dataset_role not in ("experimental", "synthetic_demonstration"):
        raise ValueError("Explicit experimental or synthetic_demonstration role required.")
    return {
        "method_version": METHOD_VERSION, "created_utc": datetime.now(timezone.utc).isoformat(),
        "dataset_role": dataset_role, "information_level": "derived",
        "sources": [{"path": Path(path).as_posix(), "sha256": sha256(Path(path).read_bytes()).hexdigest()} for path in sources],
        "parameters": parameters, "descriptor_units": units,
        "conventions": {"euler": "Bunge degrees; g is sample-to-crystal", "quaternion": "xyzw",
                        "angles": "line angles modulo 180; AFM polar angles modulo 360"},
        "software": {name: version(name) for name in ("numpy", "scipy", "pandas", "statsmodels")},
        "limitations": ["Export generation does not establish a Granta MI connection",
                "No constitutive calibration or activation inference"],
    }


def export_descriptor_tables(folder, tables, manifest):
    """Export named DataFrames and a shared JSON provenance sidecar.

    CSV missing values remain empty, not zero. Column units, information levels,
    validity definitions, and links belong in the explicit companion manifest.
    """
    folder = Path(folder)
    names = list(tables)
    if any(not name or Path(name).name != name or not name.replace("_", "").isalnum() for name in names):
        raise ValueError("Table names must be simple alphanumeric/underscore identifiers.")
    content = json.dumps(manifest, indent=2, allow_nan=False)
    folder.mkdir(parents=True, exist_ok=True)
    paths = []
    for name, table in tables.items():
        path = folder / f"{name}.csv"
        table.to_csv(path, index=False)
        paths.append(path)
    sidecar = folder / "provenance.json"
    sidecar.write_text(content, encoding="utf-8")
    return [*paths, sidecar]