#!/usr/bin/env python3
"""Does the bare tangency graph of a triangulated circle packing in a
rectangle determine the radii?  (Companion to circle-packings.typ.)

For square tilings the bare adjacency graph does not determine the sizes
(md/squared-rectangles-adjacency-graph.md: a 2x5 and a 3x4 tiling share
the graph K4 minus an edge).  Here is the same search for circle packings.

Patterns.  A triangulated packing of n circles has a pattern G*: the
circles and the four sides as vertices, tangencies as edges, the four
corners as edges between adjacent sides, every inner face a triangle,
and no edge top-bottom or left-right.  Adding a vertex "infinity" joined
to the four sides gives a triangulation of the sphere with n + 5
vertices in which infinity has degree 4 and its opposite neighbours are
not adjacent; conversely every such triangulation and choice of
infinity gives a pattern.  plantri (through Sage) lists the sphere
triangulations, so this enumerates all patterns with n circles.

Packings.  By Koebe-Andreev-Thurston every pattern has exactly one
packing.  It is found by least squares from a Tutte (barycentric)
embedding of the pattern, and accepted only if it is an honest packing
of exactly that pattern: circles inside the rectangle, no overlaps, no
extra tangencies.

Comparison.  G = the tangency graph of the circles alone, with no side
information; and, as in the squared-rectangle theorem, G with the
circles touching one pair of opposite sides marked ("G + T + B").  Two packings conflict if their graphs G are isomorphic but
no isomorphism carries the radii of one to the radii of the other, both
normalised so that the largest radius is 1 (a packing turned through 90
degrees is the same packing).  Canonical labels are Sage's, as in the
squared-rectangle search.

    cd kummer
    sage -python circle-graph-search.py [NMAX] [--irreducible]   # default NMAX = 6

With --irreducible only patterns in which every circle touches at least
four objects are used, so that no circle is just inscribed in a gap.
With --no-spanning, patterns with a circle touching two opposite sides
(top and bottom, or left and right) are left out.
"""
import sys
import time

import numpy as np
from scipy.optimize import least_squares
from sage.all import Graph, graphs

SIDES = ('top', 'right', 'bottom', 'left')
TOL = 1e-7
rng = np.random.default_rng(1)
IRREDUCIBLE = False
NO_SPANNING = False


def patterns(n):
    """(circle edges, wall contacts, pattern key) for all patterns with n
    circles, up to isomorphism (symmetries of the rectangle included)."""
    seen = set()
    for S in graphs.triangulations(n + 5):
        emb = S.get_embedding()
        for inf in S.vertices():
            if S.degree(inf) != 4:
                continue
            u = emb[inf]                      # cyclic order of the neighbours
            if S.has_edge(u[0], u[2]) or S.has_edge(u[1], u[3]):
                continue
            side_of = dict(zip(u, SIDES))
            circles = [v for v in S.vertices() if v != inf and v not in side_of]
            idx = {v: i for i, v in enumerate(circles)}
            cc = sorted((min(idx[a], idx[b]), max(idx[a], idx[b]))
                        for a, b in S.edges(labels=False) if a in idx and b in idx)
            walls = sorted((idx[a], side_of[b]) for a, b in
                           [(a, b) for a, b in S.edges(labels=False)] + [(b, a) for a, b in S.edges(labels=False)]
                           if a in idx and b in side_of)
            Gs = Graph([list(range(n + 4)),
                        [list(e) for e in cc]
                        + [(c, n + SIDES.index(s)) for c, s in walls]
                        + [(n + i, n + (i + 1) % 4) for i in range(4)]],
                       format='vertices_and_edges')
            key = Gs.canonical_label(partition=[list(range(n)), list(range(n, n + 4))]).graph6_string()
            if key not in seen:
                seen.add(key)
                yield cc, walls, key


def residual(z, n, cc, walls):
    x, y, r, W = z[:n], z[n:2 * n], z[2 * n:3 * n], z[3 * n]
    res = [np.hypot(x[p] - x[q], y[p] - y[q]) - r[p] - r[q] for p, q in cc]
    for p, s in walls:
        res.append({'top': 1 - y[p] - r[p], 'bottom': y[p] - r[p],
                    'left': x[p] - r[p], 'right': W - x[p] - r[p]}[s])
    return np.array(res)


def honest(z, n, cc, walls):
    x, y, r, W = z[:n], z[n:2 * n], z[2 * n:3 * n], z[3 * n]
    if min(r) <= TOL:
        return False
    found_cc, found_w = [], []
    for a in range(n):
        for b in range(a + 1, n):
            gap = np.hypot(x[a] - x[b], y[a] - y[b]) - r[a] - r[b]
            if gap < -TOL:
                return False
            if gap < TOL:
                found_cc.append((a, b))
        for s, gap in (('top', 1 - y[a] - r[a]), ('bottom', y[a] - r[a]),
                       ('left', x[a] - r[a]), ('right', W - x[a] - r[a])):
            if gap < -TOL:
                return False
            if gap < TOL:
                found_w.append((a, s))
    return sorted(found_cc) == cc and sorted(found_w) == walls


def tutte_start(n, cc, walls, W0):
    """Barycentric embedding: each circle at the average of its neighbours,
    sides pinned at the midpoints of the sides of a W0 x 1 rectangle."""
    anchor = {'top': (W0 / 2, 1.0), 'bottom': (W0 / 2, 0.0),
              'left': (0.0, 0.5), 'right': (W0, 0.5)}
    M = np.zeros((n, n))
    rhs = np.zeros((n, 2))
    for p, q in cc:
        M[p, p] += 1; M[q, q] += 1; M[p, q] -= 1; M[q, p] -= 1
    for p, s in walls:
        M[p, p] += 1
        rhs[p] += anchor[s]
    P = np.linalg.solve(M, rhs)
    P += rng.normal(0, 0.01, P.shape)
    r = np.full(n, 0.5)
    for p, q in cc:
        d = np.linalg.norm(P[p] - P[q]) / 2
        r[p] = min(r[p], d); r[q] = min(r[q], d)
    for p in range(n):
        r[p] = max(0.02, 0.8 * min(r[p], P[p, 1], 1 - P[p, 1]))
    return np.concatenate([P[:, 0], P[:, 1], r, [W0]])


def solve(n, cc, walls, attempts=60):
    for t in range(attempts):
        W0 = rng.uniform(0.5, 1.5) * max(1.0, 0.6 * np.sqrt(n) + 0.3 * t / attempts * n)
        z0 = tutte_start(n, cc, walls, W0)
        sol = least_squares(residual, z0, args=(n, cc, walls), xtol=1e-15, ftol=1e-15, gtol=1e-15)
        if np.max(np.abs(residual(sol.x, n, cc, walls))) < 1e-11 and honest(sol.x, n, cc, walls):
            return sol.x
    return None


def main():
    global IRREDUCIBLE
    args = [a for a in sys.argv[1:] if not a.startswith('--')]
    IRREDUCIBLE = '--irreducible' in sys.argv
    global NO_SPANNING
    NO_SPANNING = '--no-spanning' in sys.argv
    if NO_SPANNING:
        print('(no circle touching two opposite sides)')
    nmax = int(args[0]) if args else 6
    if IRREDUCIBLE:
        print('(only patterns in which every circle touches at least 4 objects:')
        print(' no circle can have been dropped into a triangular gap)')
    print('Triangulated circle packings in a rectangle: does the bare tangency')
    print('graph G of the circles determine the radii (up to scale)?')
    print()
    print('  n  patterns  solved  graphs G  G with >1 pattern  conflicts  conflicts G+T+B   time')
    examples = []
    tb_examples = []
    for n in range(1, nmax + 1):
        t0 = time.time()
        byG = {}
        byTB = {}
        npat = nsolved = 0
        failed = []
        for cc, walls, key in patterns(n):
            if NO_SPANNING:
                touched = {}
                for p, sd in walls:
                    touched.setdefault(p, set()).add(sd)
                if any({'top', 'bottom'} <= t or {'left', 'right'} <= t for t in touched.values()):
                    continue
            if IRREDUCIBLE:
                deg = [0] * n
                for p, q in cc:
                    deg[p] += 1; deg[q] += 1
                for p, sd in walls:
                    deg[p] += 1
                if min(deg) < 4:
                    continue
            npat += 1
            z = solve(n, cc, walls)
            if z is None:
                failed.append((cc, walls))
                continue
            nsolved += 1
            r = z[2 * n:3 * n] / max(z[2 * n:3 * n])
            G = Graph([list(range(n)), [list(e) for e in cc]], format='vertices_and_edges')
            gkey = G.canonical_label().graph6_string()
            classes = {}
            for v, rv in enumerate(np.round(r, 7)):
                classes.setdefault(float(rv), []).append(v)
            vals = sorted(classes)
            ckey = (tuple(vals), tuple(len(classes[v]) for v in vals),
                    G.canonical_label(partition=[classes[v] for v in vals]).graph6_string())
            byG.setdefault(gkey, []).append((ckey, cc, walls, z))
            # G with the circles touching one pair of opposite sides marked,
            # for both pairs (a packing turned through 90 degrees is the same
            # packing); the pair is unordered (top <-> bottom is a symmetry)
            for pair in (('top', 'bottom'), ('left', 'right')):
                ext = [list(e) for e in cc]
                for c, sd in walls:
                    if sd == pair[0]:
                        ext.append((c, n))
                    elif sd == pair[1]:
                        ext.append((c, n + 1))
                H = Graph([list(range(n + 2)), ext], format='vertices_and_edges')
                hkey = H.canonical_label(partition=[list(range(n)), [n, n + 1]]).graph6_string()
                hck = (ckey[0], ckey[1], H.canonical_label(
                    partition=[classes[v] for v in vals] + [[n, n + 1]]).graph6_string())
                byTB.setdefault(hkey, []).append((hck, cc, walls, z, pair))
        multi = sum(1 for v in byG.values() if len(v) > 1)
        conflicts = []
        for gkey, lst in byG.items():
            ck = {}
            for item in lst:
                ck.setdefault(item[0], item)
            if len(ck) > 1:
                conflicts.append((gkey, list(ck.values())))
        tb_conflicts = []
        for hkey, lst in byTB.items():
            ck = {}
            for item in lst:
                ck.setdefault(item[0], item)
            if len(ck) > 1:
                tb_conflicts.append((hkey, list(ck.values())))
        print(' %2d  %8d  %6d  %8d  %17d  %9d  %12d  %5.0fs'
              % (n, npat, nsolved, len(byG), multi, len(conflicts), len(tb_conflicts),
                 time.time() - t0), flush=True)
        tb_examples += [(n, c) for c in tb_conflicts]
        if failed:
            print('     not solved: %d patterns' % len(failed))
        examples += [(n, c) for c in conflicts]
    print()
    print('conflicts for G with the top and bottom circles marked: %d' % len(tb_examples))
    for n, (hkey, items) in tb_examples[:4]:
        print()
        print('conflict (G + T + B), n = %d' % n)
        for hck, cc, walls, z, pair in items:
            r = z[2 * n:3 * n]
            print('   marked sides %s/%s  W = %.6f  radii %s' % (pair[0], pair[1], z[3 * n],
                  ' '.join('%.6f' % v for v in r)))
            print('      tangencies %s' % cc)
            print('      sides      %s' % walls)
    for n, (gkey, items) in examples[:3]:
        print()
        print('conflict, n = %d, graph6 %s' % (n, gkey))
        for ckey, cc, walls, z in items:
            r = z[2 * n:3 * n]
            print('   W = %.6f  radii %s' % (z[3 * n], ' '.join('%.6f' % v for v in r)))
            print('      tangencies %s' % cc)
            print('      sides      %s' % walls)


if __name__ == '__main__':
    main()
