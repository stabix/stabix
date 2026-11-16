"""Visualize the slip transfer factor chi = cos(alpha) * cos(delta) (Jimenez et al., 2019).

An incoming FCC slip system in grain 1 is combined with a rotated grain 2 and a
grain boundary normal. chi is computed for all 12 outgoing {111}<110> systems.
"""

import argparse
from itertools import product

import matplotlib.pyplot as plt
import numpy as np
from scipy.spatial.transform import Rotation

PLANES = np.array([[1, 1, 1], [-1, 1, 1], [1, -1, 1], [1, 1, -1]], dtype=float)


def fcc_slip_systems():
    """Return list of (plane normal, slip direction) for the 12 FCC {111}<110> systems."""
    directions = [np.array(d, dtype=float) for d in product((-1, 0, 1), repeat=3)
                  if sorted(map(abs, d)) == [0, 1, 1]]
    systems = []
    for n in PLANES:
        seen = []
        for d in directions:
            if abs(n @ d) < 1e-9 and not any(np.allclose(d, -s) or np.allclose(d, s) for s in seen):
                seen.append(d)
        systems += [(n / np.linalg.norm(n), d / np.linalg.norm(d)) for d in seen]
    return systems


def acute_angle(a, b):
    """Angle in degrees between two lines (sign independent), in [0, 90]."""
    c = abs(a @ b) / (np.linalg.norm(a) * np.linalg.norm(b))
    return np.degrees(np.arccos(np.clip(c, 0, 1)))


def chi_factor(n1, d1, n2, d2, n_gb):
    """Return (chi, alpha, delta) with chi = cos(alpha) * cos(delta); angles in degrees."""
    alpha = acute_angle(np.cross(n1, n_gb), np.cross(n2, n_gb))
    delta = acute_angle(d1, d2)
    return np.cos(np.radians(alpha)) * np.cos(np.radians(delta)), alpha, delta


def outgoing_chi(incoming, rotation, n_gb):
    """chi, alpha, delta, Schmid factor of every outgoing system (sample frame)."""
    n1, d1 = incoming
    results = []
    for n2, d2 in fcc_slip_systems():
        chi, alpha, delta = chi_factor(n1, d1, rotation.apply(n2), rotation.apply(d2), n_gb)
        results.append((chi, alpha, delta))
    return np.array(results)


def schmid(n, d, load=np.array([0.0, 0.0, 1.0])):
    return abs((n @ load) * (d @ load))


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--incoming", type=int, default=0, help="index (0-11) of the incoming system")
    parser.add_argument("--euler", type=float, nargs=3, default=[30, 40, 20],
                        help="Bunge ZXZ angles (deg) rotating grain 2 relative to grain 1")
    parser.add_argument("--gb-normal", type=float, nargs=3, default=[1, 0, 0])
    parser.add_argument("--no-show", action="store_true")
    parser.add_argument("--save", help="optional output image path")
    args = parser.parse_args(argv)

    n_gb = np.array(args.gb_normal) / np.linalg.norm(args.gb_normal)
    rotation = Rotation.from_euler("ZXZ", args.euler, degrees=True)
    systems = fcc_slip_systems()
    incoming = systems[args.incoming]
    values = outgoing_chi(incoming, rotation, n_gb)
    schmid_out = np.array([schmid(rotation.apply(n), rotation.apply(d)) for n, d in systems])

    order = np.argsort(values[:, 0])[::-1]
    fig, axes = plt.subplots(1, 3, figsize=(15, 4.5))

    axes[0].bar(range(12), values[order, 0], color="tab:blue")
    axes[0].set_xticks(range(12), [str(i) for i in order])
    axes[0].set_xlabel("outgoing system index")
    axes[0].set_ylabel(r"$\chi = \cos\alpha\,\cos\delta$")
    axes[0].set_title("Outgoing systems ranked by $\\chi$")
    axes[0].set_ylim(0, 1)

    sc = axes[1].scatter(values[:, 1], values[:, 2], c=values[:, 0], cmap="viridis", vmin=0, vmax=1, s=60)
    axes[1].axvline(45, color="grey", ls="--")
    axes[1].axhline(45, color="grey", ls="--")
    axes[1].set(xlim=(0, 90), ylim=(0, 90), xlabel=r"twist angle $\alpha$ (deg)",
                ylabel=r"$\delta$ (deg)", title=r"$\alpha$ vs $\delta$ (dashed: 45$^\circ$)")
    fig.colorbar(sc, ax=axes[1], label=r"$\chi$")

    axes[2].scatter(schmid_out, values[:, 0], s=60, color="tab:red")
    axes[2].set(xlabel="outgoing Schmid factor (load // z)", ylabel=r"$\chi$",
                xlim=(0, 0.5), ylim=(0, 1), title=r"$\chi$ vs Schmid factor")

    fig.suptitle(f"FCC slip transfer, incoming system {args.incoming}, GB normal {n_gb.round(2)}")
    fig.tight_layout()
    best = order[0]
    print(f"Best outgoing system: {best} with chi = {values[best, 0]:.3f} "
          f"(alpha = {values[best, 1]:.1f} deg, delta = {values[best, 2]:.1f} deg)")
    if args.save:
        fig.savefig(args.save, dpi=150)
    if not args.no_show:
        plt.show()


if __name__ == "__main__":
    main()
