"""Plot maximum Luster-Morris m-prime on EBSD grain boundaries."""

import argparse
from dataclasses import dataclass
from io import StringIO
from itertools import product
from pathlib import Path

import matplotlib.pyplot as plt
import numpy as np
import yaml
from matplotlib.collections import LineCollection
from scipy.sparse import coo_matrix
from scipy.sparse.csgraph import connected_components
from scipy.spatial import cKDTree
from scipy.spatial.transform import Rotation


CUBIC = Rotation.create_group("O")


def bunge_rotations(eulers):
    """Convert Bunge Euler angles in degrees to crystal-to-sample rotations.

    These matrices are the transpose of STABiX's eulers2g.m matrices.
    """
    return Rotation.from_euler("ZXZ", eulers, degrees=True)


def slip_systems(structure):
    """Return cubic slip, HCP basal plus Prism1 <a>, or one HCP family.

    HCP Cartesian vectors follow the first six systems in STABiX slip_systems.m
    and its Miller-Bravais conversions. These families do not depend on c/a.
    """
    if structure in ("hcp", "hcp_basal", "hcp_prismatic", "hcp_prismatic1", "hcp_prismatic2"):
        directions = np.tile([
            [3, 0, 0], [-1.5, 1.5 * np.sqrt(3), 0], [-1.5, -1.5 * np.sqrt(3), 0],
        ], (2, 1))
        normals = np.array([
            [0, 0, 1], [0, 0, 1], [0, 0, 1],
            [0, 2 / np.sqrt(3), 0], [-1, -1 / np.sqrt(3), 0],
            [1, -1 / np.sqrt(3), 0],
        ])
        normals /= np.linalg.norm(normals, axis=1, keepdims=True)
        directions /= np.linalg.norm(directions, axis=1, keepdims=True)
        if structure == "hcp_prismatic2":
            return directions[3:6], normals[3:6]
        selected = {"hcp": slice(None), "hcp_basal": slice(0, 3),
                    "hcp_prismatic": slice(3, 6), "hcp_prismatic1": slice(3, 6)}[structure]
        return normals[selected], directions[selected]
    if structure not in ("fcc", "bcc"):
        raise ValueError("Unknown slip structure or family.")
    vectors = np.array(list(product((-1, 0, 1), repeat=3)))
    nonzero = np.any(vectors != 0, axis=1)
    vectors = vectors[nonzero]
    first = np.argmax(vectors != 0, axis=1)
    vectors = vectors[vectors[np.arange(len(vectors)), first] > 0]
    lengths = np.sum(vectors**2, axis=1)
    plane_length, direction_length = (3, 2) if structure == "fcc" else (2, 3)
    systems = [
        (normal, direction)
        for normal in vectors[lengths == plane_length]
        for direction in vectors[lengths == direction_length]
        if np.dot(normal, direction) == 0
    ]
    normals, directions = np.array(systems, dtype=float).transpose(1, 0, 2)
    normals /= np.linalg.norm(normals, axis=1, keepdims=True)
    directions /= np.linalg.norm(directions, axis=1, keepdims=True)
    return normals, directions


@dataclass(frozen=True)
class ReconstructedMap:
    """Grain averages and an exact boundary network from TSL GF2/RB exports."""

    grain_ids: np.ndarray
    eulers: np.ndarray
    centers: np.ndarray
    phases: np.ndarray
    segments: np.ndarray
    pairs: np.ndarray
    segment_pairs: np.ndarray
    boundary_lengths: np.ndarray


def read_tsl_reconstruction(grain_path, boundary_path):
    """Read TSL Grain File Type 2 and Reconstructed Boundaries files.

    GF2 Euler angles (degrees) are authoritative, as in the MATLAB importer.
    RB columns 1-6 contain redundant rounded Euler angles in radians and are
    not used. RB endpoints and grain IDs define the imported boundary network.
    Pair indices refer to sorted grain rows, never directly to grain IDs.
    """
    grains = np.loadtxt(grain_path, comments="#", ndmin=2)
    boundaries = np.loadtxt(boundary_path, comments="#", ndmin=2)
    if grains.shape[1] != 12 or boundaries.shape[1] != 14:
        raise ValueError("Expected 12 GF2 columns and 14 RB columns.")
    if not np.all(np.isfinite(grains)) or not np.all(np.isfinite(boundaries)):
        raise ValueError("GF2 and RB values must be finite.")
    if np.any(grains[:, 0] <= 0) or not np.all(grains[:, [0, 9]] == grains[:, [0, 9]].astype(int)):
        raise ValueError("GF2 grain IDs must be positive integers and phases must be integers.")
    grains = grains[np.argsort(grains[:, 0])]
    grain_ids = grains[:, 0].astype(int)
    if len(np.unique(grain_ids)) != len(grain_ids):
        raise ValueError("GF2 grain IDs must be unique.")
    boundary_ids = boundaries[:, 12:14]
    if not np.all(boundary_ids == boundary_ids.astype(int)):
        raise ValueError("RB grain IDs must be integers.")
    if not np.all(np.isin(boundary_ids, grain_ids)):
        raise ValueError("RB refers to grain IDs missing from GF2.")
    indices = np.searchsorted(grain_ids, boundary_ids.astype(int))
    if np.any(indices[:, 0] == indices[:, 1]):
        raise ValueError("RB contains a boundary with the same grain on both sides.")
    if np.any(boundaries[:, 6] <= 0):
        raise ValueError("RB boundary lengths must be positive.")
    segments = boundaries[:, 8:12].reshape(-1, 2, 2)
    if np.any(np.linalg.norm(segments[:, 1] - segments[:, 0], axis=1) == 0):
        raise ValueError("RB contains a zero-length boundary segment.")
    pairs, inverse = np.unique(np.sort(indices, axis=1), axis=0, return_inverse=True)
    return ReconstructedMap(
        grain_ids, grains[:, 1:4], grains[:, 4:6], grains[:, 9].astype(int),
        segments, pairs, inverse, boundaries[:, 6],
    )


def reconstructed_mprime(scan, phase_structures=None):
    """Compute pair maxima, including phase interfaces, from grain averages.

    The default phase table matches the MPIE Ti-alloy export: 1 = HCP alpha,
    2 = BCC beta. This is a geometric comparison, not an interface slip model.
    """
    if phase_structures is None:
        phase_structures = {1: "hcp", 2: "bcc"}
    if any(phase not in phase_structures for phase in np.unique(scan.phases)):
        raise ValueError("Supply a slip structure for every GF2 phase.")
    rotations = bunge_rotations(scan.eulers)
    phase_pairs = scan.phases[scan.pairs]
    values = np.empty(len(scan.pairs))
    for first_phase, second_phase in np.unique(phase_pairs, axis=0):
        selected = np.all(phase_pairs == [first_phase, second_phase], axis=1)
        values[selected] = maximum_mprime(
            rotations, scan.pairs[selected],
            phase_structures[first_phase], phase_structures[second_phase],
        )
    return values


def cubic_disorientation(first, second):
    """Return minimum cubic disorientation angles in degrees."""
    relative = (first.inv() * second).as_quat()
    cosine = np.max(np.abs(relative @ CUBIC.as_quat().T), axis=-1)
    return np.degrees(2 * np.arccos(np.clip(cosine, 0, 1)))


def read_ctf(path, phase):
    """Read a complete rectangular CTF scan, including decimal-comma files.

    Return x/y coordinates, Euler angles (degrees), and a selected-phase mask.
    Only the explicitly selected cubic phase is used for reconstruction.
    """
    with Path(path).open(encoding="utf-8-sig", errors="replace") as stream:
        metadata = {}
        phases = []
        for line in stream:
            fields = line.split()
            if not fields:
                continue
            if fields[0] == "Phases":
                phases = [next(stream).split() for _ in range(int(fields[1]))]
            elif fields[:3] == ["Phase", "X", "Y"]:
                columns = fields
                break
            elif len(fields) == 2:
                metadata[fields[0]] = fields[1]
        else:
            raise ValueError("CTF column header 'Phase X Y ...' was not found.")
        if not 1 <= phase <= len(phases):
            raise ValueError("Requested phase is not in the CTF phase table.")
        if phases[phase - 1][-2] != "11":
            raise ValueError("Selected phase must have cubic CTF Laue group 11.")
        data = np.loadtxt(StringIO(stream.read().replace(",", ".")), ndmin=2)
    required = ("Phase", "X", "Y", "Euler1", "Euler2", "Euler3")
    if not all(name in columns for name in required) or data.shape[1] != len(columns):
        raise ValueError("CTF data columns do not match the required header.")
    selected = data[:, columns.index("Phase")] == phase
    if not np.any(selected):
        raise ValueError("No pixels belong to the requested phase.")
    x_values = data[:, columns.index("X")]
    y_values = data[:, columns.index("Y")]
    x, x_index = np.unique(x_values, return_inverse=True)
    y, y_index = np.unique(y_values, return_inverse=True)
    if len(x) < 2 or len(y) < 2:
        raise ValueError("A two-dimensional scan with at least 2 x 2 pixels is required.")
    for coordinates in (x, y):
        if not np.allclose(np.diff(coordinates), np.diff(coordinates)[0], rtol=1e-3):
            raise ValueError("Only regular rectangular CTF grids are supported.")
    flat = y_index * len(x) + x_index
    if len(data) != len(x) * len(y) or len(np.unique(flat)) != len(data):
        raise ValueError("CTF grid has missing or duplicate pixels.")
    if int(metadata.get("XCells", len(x))) != len(x) or int(
        metadata.get("YCells", len(y))
    ) != len(y):
        raise ValueError("CTF grid dimensions do not match its header.")
    eulers = np.empty((len(data), 3))
    eulers[flat] = data[:, [columns.index(name) for name in required[3:]]]
    mask = np.empty(len(data), dtype=bool)
    mask[flat] = selected
    if not np.all(np.isfinite(eulers[mask])):
        raise ValueError("Selected-phase Euler angles must be finite.")
    return x, y, eulers.reshape(len(y), len(x), 3), mask.reshape(len(y), len(x))


def demo_scan():
    """Create a deterministic, explicitly synthetic cubic orientation map."""
    random = np.random.default_rng(42)
    x, y = np.arange(120, dtype=float), np.arange(90, dtype=float)
    xx, yy = np.meshgrid(x, y)
    seeds = random.uniform([0, 0], [x[-1], y[-1]], size=(28, 2))
    _, regions = cKDTree(seeds).query(np.column_stack((xx.ravel(), yy.ravel())))
    orientations = Rotation.random(len(seeds), random_state=random)
    eulers = orientations[regions].as_euler("ZXZ", degrees=True)
    return x, y, eulers.reshape(len(y), len(x), 3), np.ones(xx.shape, dtype=bool)


def grain_mean_rotations(rotations, labels):
    """Compute symmetry-aligned chordal quaternion means for each grain."""
    grain_ids, first = np.unique(labels, return_index=True)
    references = rotations[first].as_quat()[labels]
    best = np.full(len(labels), -1.0)
    aligned = np.empty((len(labels), 4))
    for operator in CUBIC:
        candidates = (rotations * operator).as_quat()
        dots = np.sum(candidates * references, axis=1)
        better = np.abs(dots) > best
        aligned[better] = candidates[better] * np.where(dots[better, None] < 0, -1, 1)
        best[better] = np.abs(dots[better])
    totals = np.zeros((len(grain_ids), 4))
    np.add.at(totals, labels, aligned)
    return Rotation.from_quat(totals)


def reconstruct_grains(eulers, mask, threshold):
    """Connect four-neighbor selected-phase pixels below a cubic threshold."""
    if not 0 < threshold < 62.8:
        raise ValueError("Grain threshold must lie between 0 and 62.8 degrees.")
    if not np.any(mask):
        raise ValueError("No selected-phase pixels to reconstruct.")
    pixels = np.arange(mask.size).reshape(mask.shape)
    first = np.concatenate((pixels[:, :-1].ravel(), pixels[:-1, :].ravel()))
    second = np.concatenate((pixels[:, 1:].ravel(), pixels[1:, :].ravel()))
    valid = mask.ravel()[first] & mask.ravel()[second]
    first, second = first[valid], second[valid]
    mapping = np.full(mask.size, -1, dtype=int)
    mapping[mask.ravel()] = np.arange(np.count_nonzero(mask))
    rotations = bunge_rotations(eulers[mask])
    connected = np.zeros(len(first), dtype=bool)
    for start in range(0, len(first), 20000):
        section = slice(start, start + 20000)
        connected[section] = cubic_disorientation(
            rotations[mapping[first[section]]], rotations[mapping[second[section]]]
        ) <= threshold
    graph = coo_matrix(
        (np.ones(np.count_nonzero(connected)),
         (mapping[first[connected]], mapping[second[connected]])),
        shape=(len(rotations), len(rotations)),
    )
    _, selected_labels = connected_components(graph, directed=False)
    labels = np.full(mask.size, -1, dtype=int)
    labels[mask.ravel()] = selected_labels
    return labels.reshape(mask.shape), grain_mean_rotations(rotations, selected_labels)


def maximum_mprime(rotations, pairs, structure, second_structure=None):
    """Evaluate max |(n1.n2)(d1.d2)| over all slip-system pairs per boundary."""
    normals, directions = slip_systems(structure)
    matrices = rotations.as_matrix()
    sample_normals = np.einsum("gij,sj->gsi", matrices, normals)
    sample_directions = np.einsum("gij,sj->gsi", matrices, directions)
    other_normals, other_directions = sample_normals, sample_directions
    if second_structure is not None and second_structure != structure:
        normals, directions = slip_systems(second_structure)
        other_normals = np.einsum("gij,sj->gsi", matrices, normals)
        other_directions = np.einsum("gij,sj->gsi", matrices, directions)
    values = np.empty(len(pairs))
    for start in range(0, len(pairs), 4096):
        section = slice(start, start + 4096)
        first, second = pairs[section].T
        normal_dots = np.einsum("bsi,bti->bst", sample_normals[first], other_normals[second])
        direction_dots = np.einsum(
            "bsi,bti->bst", sample_directions[first], other_directions[second]
        )
        values[section] = np.max(np.abs(normal_dots * direction_dots), axis=(1, 2))
    return np.clip(values, 0, 1)


def guo_literature_comparison(folder, tolerance=0.0051):
    """Compare supported Guo (2014) Table 3 blocks with stored references.

    Match Guo2014_Table3_mprime_plot.m exactly: mprime_all has grain B on
    rows and grain A on columns. Thus the stored 'pribas' value is compared
    with A basal / B prismatic, not the opposite directional block.
    The default tolerance is half the two-decimal reference precision plus
    0.0001 for rounded input orientations. Pyramidal families are not checked.
    """
    if not np.isfinite(tolerance) or tolerance < 0:
        raise ValueError("Literature tolerance must be finite and nonnegative.")
    paths = sorted(Path(folder).glob("Guo2014_Table3Case*.yaml"))
    if not paths:
        raise ValueError("No Guo2014 Table 3 cases found in the supplied folder.")
    comparisons = (
        ("mprime_pripri", "A prismatic / B prismatic", "hcp_prismatic", "hcp_prismatic"),
        ("mprime_pribas", "A basal / B prismatic", "hcp_basal", "hcp_prismatic"),
    )
    results = []
    for path in paths:
        with path.open(encoding="utf-8-sig") as stream:
            data = yaml.safe_load(stream)
        if data["Phase_A"] != "hcp" or data["Phase_B"] != "hcp":
            raise ValueError(f"Expected HCP grains in {path.name}.")
        rotations = bunge_rotations([data["eulerA"], data["eulerB"]])
        for key, label, first_family, second_family in comparisons:
            calculated = float(maximum_mprime(
                rotations, np.array([[0, 1]]), first_family, second_family,
            )[0])
            reference = float(data[key])
            error = abs(calculated - reference)
            results.append({
                "case": path.stem,
                "comparison": label,
                "reference": reference,
                "calculated": calculated,
                "absolute_error": error,
                "within_tolerance": bool(error <= tolerance),
                "tolerance": tolerance,
            })
    return results


def boundary_segments(x, y, labels):
    """Return shared pixel edges and their unique, unordered grain pairs."""
    dx, dy = np.diff(x)[0], np.diff(y)[0]
    segments, pairs = [], []
    for axis in (1, 0):
        first = labels[:, :-1] if axis == 1 else labels[:-1, :]
        second = labels[:, 1:] if axis == 1 else labels[1:, :]
        rows, cols = np.nonzero((first >= 0) & (second >= 0) & (first != second))
        centers = np.column_stack((x[cols], y[rows])).astype(float)
        centers[:, 0 if axis == 1 else 1] += (dx if axis == 1 else dy) / 2
        offset = np.array([0, dy / 2]) if axis == 1 else np.array([dx / 2, 0])
        segments.append(np.stack((centers - offset, centers + offset), axis=1))
        pairs.append(np.sort(np.column_stack((first[rows, cols], second[rows, cols])), axis=1))
    pairs, inverse = np.unique(np.concatenate(pairs), axis=0, return_inverse=True)
    return np.concatenate(segments), pairs, inverse


def plot_map(x, y, labels, segments, values, title):
    """Plot a muted grain-label map and a quantitatively scaled boundary layer."""
    figure, axes = plt.subplots(figsize=(10, 7), constrained_layout=True)
    dx, dy = np.diff(x)[0], np.diff(y)[0]
    extent = (x[0] - dx / 2, x[-1] + dx / 2, y[-1] + dy / 2, y[0] - dy / 2)
    axes.imshow(np.ma.masked_less(labels, 0), cmap="tab20", alpha=0.18,
                extent=extent, interpolation="nearest")
    boundaries = LineCollection(segments, cmap="viridis", norm=plt.Normalize(0, 1), linewidths=1.5)
    boundaries.set_array(values)
    axes.add_collection(boundaries)
    axes.set(title=title, xlabel="X (um)", ylabel="Y (um)", aspect="equal")
    figure.colorbar(boundaries, ax=axes, label="Maximum m-prime")
    return figure


def reconstructed_grain_polygons(scan):
    """Polygonize RB segments and identify regions from their adjacent grain IDs.

    The rectangular outer edge is inferred from segment extrema. A region whose
    boundary IDs do not identify exactly one grain is left unassigned.
    """
    from shapely.geometry import LineString, Point, box
    from shapely.ops import polygonize, unary_union
    from shapely.strtree import STRtree

    endpoints = scan.segments.reshape(-1, 2)
    lower, upper = endpoints.min(axis=0), endpoints.max(axis=0)
    edges = [LineString(segment) for segment in scan.segments]
    edges.append(box(*lower, *upper).boundary)
    polygons = list(polygonize(unary_union(edges)))
    if not polygons:
        raise ValueError("The reconstructed boundary network contains no closed regions.")

    tree = STRtree(polygons)
    candidates = [None] * len(polygons)
    for segment, pair_index in zip(scan.segments, scan.segment_pairs):
        direction = segment[1] - segment[0]
        length = np.linalg.norm(direction)
        normal = np.array([-direction[1], direction[0]]) / length
        midpoint = segment.mean(axis=0)
        pair = set(scan.pairs[pair_index])
        for side in (-1, 1):
            point = Point(midpoint + side * min(0.001, length / 100) * normal)
            matches = tree.query(point, predicate="within")
            if len(matches) != 1:
                raise ValueError("A boundary side could not be associated with exactly one region.")
            index = int(matches[0])
            candidates[index] = pair if candidates[index] is None else candidates[index] & pair
    grain_indices = np.array([
        next(iter(candidate)) if candidate is not None and len(candidate) == 1 else -1
        for candidate in candidates
    ], dtype=int)
    return polygons, grain_indices


def plot_grain_tessellation(axes, scan, values, cmap="coolwarm", vmin=-1, vmax=1):
    """Fill reconstructed RB regions by grain value and draw measured boundaries."""
    from matplotlib.collections import PatchCollection
    from matplotlib.patches import PathPatch
    from matplotlib.path import Path
    from shapely.geometry import Point
    from shapely.geometry.polygon import orient
    from shapely.strtree import STRtree

    values = np.asarray(values, dtype=float)
    if values.shape != (len(scan.grain_ids),):
        raise ValueError("Supply one value per GF2 grain.")
    polygons, indices = reconstructed_grain_polygons(scan)
    patches = []
    for polygon in polygons:
        polygon = orient(polygon, sign=1)
        rings = [polygon.exterior, *polygon.interiors]
        patches.append(PathPatch(Path.make_compound_path(
            *(Path(np.asarray(ring.coords)) for ring in rings)
        )))
    colors = np.full(len(indices), np.nan)
    assigned = indices >= 0
    colors[assigned] = values[indices[assigned]]
    missing = np.setdiff1d(np.arange(len(scan.grain_ids)), indices[assigned])
    tree = STRtree(polygons)
    ambiguous = np.zeros(len(indices), dtype=bool)
    for center in scan.centers[missing]:
        ambiguous[tree.query(Point(center), predicate="intersects")] = True
    colors[ambiguous] = np.nan
    palette = plt.get_cmap(cmap).copy()
    palette.set_bad("lightgray")
    collection = PatchCollection(patches, cmap=palette, norm=plt.Normalize(vmin, vmax), edgecolors="none")
    collection.set_array(np.ma.masked_invalid(colors))
    axes.add_collection(collection)
    axes.add_collection(LineCollection(scan.segments, colors="black", linewidths=0.35))
    axes.autoscale_view()
    axes.invert_yaxis()
    axes.set(xlabel="TD / X (um)", ylabel="RD / Y (um)", aspect="equal")
    return collection, scan.grain_ids[missing], int(((~assigned) | ambiguous).sum())


def plot_reconstructed_map(scan, values, title="Reconstructed Ti-alloy EBSD | maximum m-prime",
                          cmap="viridis", vmin=0, vmax=1, colorbar_label="Maximum m-prime"):
    """Plot exact RB segments with a scalar boundary metric.

    The files contain no raw pixel orientations or grain polygons. Grain
    centers mark the phases; no raster map or artificial grain fill is inferred.
    """
    values = np.asarray(values, dtype=float)
    if values.shape != (len(scan.pairs),):
        raise ValueError("Supply one value per unique grain pair.")
    figure, axes = plt.subplots(figsize=(11, 8), constrained_layout=True)
    boundaries = LineCollection(
        scan.segments, cmap=cmap, norm=plt.Normalize(vmin, vmax), linewidths=1,
    )
    boundaries.set_array(np.ma.masked_invalid(values[scan.segment_pairs]))
    axes.add_collection(boundaries)
    for phase, color, name in ((1, "#777777", "Alpha (HCP)"), (2, "#c44932", "Beta (BCC)")):
        selected = scan.phases == phase
        if np.any(selected):
            axes.scatter(*scan.centers[selected].T, s=7, color=color, label=name, zorder=3)
    axes.autoscale_view()
    axes.invert_yaxis()
    axes.set(title=title, xlabel="TD / X (um)", ylabel="RD / Y (um)", aspect="equal")
    axes.legend(loc="upper left", bbox_to_anchor=(0, -0.08), ncol=2, frameon=False,
                title="Grain centers")
    figure.colorbar(boundaries, ax=axes, label=colorbar_label)
    return figure


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--ctf", type=Path, help="Rectangular cubic-phase CTF scan; omit for synthetic demo")
    parser.add_argument("--phase", type=int, default=1, help="CTF phase ID (default: 1)")
    parser.add_argument("--structure", choices=("fcc", "bcc"), default="fcc")
    parser.add_argument("--threshold", type=float, default=10, help="Grain misorientation threshold in degrees")
    parser.add_argument("--output", type=Path, help="Save figure, e.g. mprime.png")
    parser.add_argument("--no-show", action="store_true", help="Do not open an interactive plot")
    args = parser.parse_args(argv)
    if args.no_show:
        plt.switch_backend("Agg")
    try:
        x, y, eulers, mask = read_ctf(args.ctf, args.phase) if args.ctf else demo_scan()
        labels, means = reconstruct_grains(eulers, mask, args.threshold)
        segments, pairs, inverse = boundary_segments(x, y, labels)
        if not len(pairs):
            raise ValueError("No selected-phase grain boundaries found at this threshold.")
        values = maximum_mprime(means, pairs, args.structure)
    except (ValueError, OSError) as error:
        parser.error(str(error))
    source = args.ctf.name if args.ctf else "Synthetic EBSD demo"
    title = f"{source} | {args.structure.upper()} | {len(means)} grains"
    figure = plot_map(x, y, labels, segments, values[inverse], title)
    print(f"{len(means)} grains, {len(pairs)} grain pairs; max-m-prime range: "
          f"{values.min():.4f} to {values.max():.4f}")
    if args.output:
        figure.savefig(args.output, dpi=200)
        print(f"Saved {args.output.resolve()}")
    if not args.no_show:
        plt.show()
    plt.close(figure)


if __name__ == "__main__":
    main()