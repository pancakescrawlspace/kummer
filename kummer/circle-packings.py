#!/usr/bin/env python3
"""Figures and checks for circle-packings.typ.

A packing of n circles in a W x 1 rectangle (corner at the origin) has
3n + 1 unknowns: a centre (x, y) and radius r per circle, and the width W.
Every tangency -- circle-circle, or circle-side -- is one equation.  A
pattern is a list of tangencies; it is *triangulated* when every gap is a
curvilinear triangle, which by Euler's formula happens exactly when there
are 3n + 1 tangencies.

For every pattern below this script

  (1) solves the tangency equations from many random starting points;
  (2) keeps the solutions that are honest packings of that pattern: all
      circles inside the rectangle, no two overlapping, and *no tangency
      beyond the prescribed ones*;
  (3) counts the distinct ones and the rank of the Jacobian there.

The theorem in the note predicts exactly one packing per triangulated
pattern, with full Jacobian rank 3n + 1.  It writes the solutions to
circle-packings.json, which circle-packings.typ reads to draw the figures,
and a report to ../results/circle-packings.txt.

Needs numpy and scipy; Sage's Python has both:

    cd kummer
    sage -python circle-packings.py
"""
import itertools
import json

import numpy as np
from scipy.optimize import least_squares

SIDES = ('top', 'right', 'bottom', 'left')
TOL_CONTACT = 1e-7      # |dist - (r1 + r2)| below this counts as tangent
STARTS = 300            # random starting points per pattern
rng = np.random.default_rng(20261001)


# ---------------------------------------------------------------------
# patterns
# ---------------------------------------------------------------------

class Pattern:
    def __init__(self, name, labels, rows, cc, walls, fix=None):
        self.name = name
        self.labels = labels          # one label per circle
        self.rows = rows              # 'top' / 'bottom' / 'mid': colour and initial guess
        self.n = len(labels)
        self.cc = sorted(tuple(sorted(e)) for e in cc)
        self.walls = sorted(walls)    # (circle, side)
        self.fix = fix or []          # extra equations r_i = t

    def equations(self):
        return len(self.cc) + len(self.walls) + len(self.fix)

    def residual(self, z):
        n = self.n
        x, y, r, W = z[:n], z[n:2 * n], z[2 * n:3 * n], z[3 * n]
        res = [np.hypot(x[p] - x[q], y[p] - y[q]) - r[p] - r[q] for p, q in self.cc]
        for p, side in self.walls:
            res.append({'top': 1 - y[p] - r[p], 'bottom': y[p] - r[p],
                        'left': x[p] - r[p], 'right': W - x[p] - r[p]}[side])
        for p, t in self.fix:
            res.append(r[p] - t)
        return np.array(res)


def zigzag(k, path, name=None):
    """Top row A1..Ak, bottom row B1..Bk; `path` lists the cross
    tangencies (i, j) = A_i B_j, a lattice path from (1, 1) to (k, k)."""
    A = lambda i: i - 1
    B = lambda j: k + j - 1
    cc = [(A(i), A(i + 1)) for i in range(1, k)] + [(B(j), B(j + 1)) for j in range(1, k)]
    cc += [(A(i), B(j)) for i, j in path]
    walls = [(A(i), 'top') for i in range(1, k + 1)] + [(B(j), 'bottom') for j in range(1, k + 1)]
    walls += [(A(1), 'left'), (B(1), 'left'), (A(k), 'right'), (B(k), 'right')]
    labels = ['A%d' % i for i in range(1, k + 1)] + ['B%d' % j for j in range(1, k + 1)]
    return Pattern(name or 'zigzag %d %s' % (k, path), labels,
                   ['top'] * k + ['bottom'] * k, cc, walls)


def lattice_paths(k):
    for ups in itertools.combinations(range(2 * k - 2), k - 1):
        i = j = 1
        path = [(1, 1)]
        for s in range(2 * k - 2):
            if s in ups:
                i += 1
            else:
                j += 1
            path.append((i, j))
        yield path


SIX_PATH = [(1, 1), (1, 2), (2, 2), (2, 3), (3, 3)]


def six_circles():
    p = zigzag(3, SIX_PATH, 'six circles')
    p.labels = ['A', 'B', 'C', "C'", "B'", "A'"]
    return p


def three_rows():
    """Top row A1 A2 A3, bottom row B1 B2 B3, and two circles M1 M2 in
    between that touch no side.  Every circle touches at least 5 others."""
    A1, A2, A3, B1, B2, B3, M1, M2 = range(8)
    cc = [(A1, A2), (A2, A3), (B1, B2), (B2, B3), (A1, B1), (A3, B3),
          (M1, A1), (M1, A2), (M1, B1), (M1, B2), (M1, M2),
          (M2, A2), (M2, A3), (M2, B2), (M2, B3)]
    walls = [(A1, 'top'), (A2, 'top'), (A3, 'top'),
             (B1, 'bottom'), (B2, 'bottom'), (B3, 'bottom'),
             (A1, 'left'), (B1, 'left'), (A3, 'right'), (B3, 'right')]
    return Pattern('three rows', ['A1', 'A2', 'A3', 'B1', 'B2', 'B3', 'M1', 'M2'],
                   ['top'] * 3 + ['bottom'] * 3 + ['mid'] * 2, cc, walls)


def with_insertions(base, gaps):
    """`base` plus one new circle in each listed triangular gap (three
    circles of `base`), tangent to all three."""
    labels = list(base.labels)
    rows = list(base.rows)
    cc = list(base.cc)
    for g, gap in enumerate(gaps):
        new = len(labels)
        labels.append('')
        rows.append('new')
        cc += [(new, c) for c in gap]
    return Pattern(base.name + ' + %d inserted' % len(gaps), labels, rows, cc, list(base.walls))


# ---------------------------------------------------------------------
# solving
# ---------------------------------------------------------------------

def random_start(p):
    n = p.n
    W0 = rng.uniform(0.4, 0.9) * max(1.0, 0.55 * n)
    x = rng.uniform(0, W0, n)
    for row in ('top', 'bottom', 'mid'):
        idx = [i for i in range(n) if p.rows[i] == row]
        x[idx] = np.sort(x[idx])
    y = np.array([{'top': rng.uniform(0.55, 0.9), 'bottom': rng.uniform(0.1, 0.45),
                   'mid': rng.uniform(0.35, 0.65), 'new': rng.uniform(0.2, 0.8)}[row]
                  for row in p.rows])
    r = rng.uniform(0.1, 0.45, n)
    return np.concatenate([x, y, r, [W0]])


def contacts(p, z):
    """The tangencies actually present in z, or None if two circles
    overlap or a circle sticks out of the rectangle."""
    n = p.n
    x, y, r, W = z[:n], z[n:2 * n], z[2 * n:3 * n], z[3 * n]
    if min(r) <= TOL_CONTACT:
        return None
    cc, walls = [], []
    for a in range(n):
        for b in range(a + 1, n):
            gap = np.hypot(x[a] - x[b], y[a] - y[b]) - r[a] - r[b]
            if gap < -TOL_CONTACT:
                return None
            if gap < TOL_CONTACT:
                cc.append((a, b))
        for side, gap in (('top', 1 - y[a] - r[a]), ('bottom', y[a] - r[a]),
                          ('left', x[a] - r[a]), ('right', W - x[a] - r[a])):
            if gap < -TOL_CONTACT:
                return None
            if gap < TOL_CONTACT:
                walls.append((a, side))
    return sorted(cc), sorted(walls)


def solve_from(p, z0):
    sol = least_squares(p.residual, z0, xtol=1e-15, ftol=1e-15, gtol=1e-15)
    return sol.x if np.max(np.abs(p.residual(sol.x))) < 1e-11 else None


def jac_rank(p, z):
    J = least_squares(p.residual, z, max_nfev=1).jac
    return int(np.linalg.matrix_rank(J, tol=1e-8))


def survey(p, starts=STARTS, extra_starts=()):
    """All distinct honest packings of p found from random starts."""
    found = []
    for z0 in itertools.chain(extra_starts, (random_start(p) for _ in range(starts))):
        z = solve_from(p, z0)
        if z is None:
            continue
        c = contacts(p, z)
        if c is None or c != (p.cc, p.walls):
            continue
        if not any(np.max(np.abs(z - w)) < 1e-7 for w in found):
            found.append(z)
    return found


def record(p, z):
    n = p.n
    return {'name': p.name, 'W': float(z[3 * n]),
            'circles': [{'x': float(z[i]), 'y': float(z[n + i]), 'r': float(z[2 * n + i]),
                         'label': p.labels[i], 'row': p.rows[i]} for i in range(n)],
            'cc': [list(e) for e in p.cc],
            'walls': [[c, s] for c, s in p.walls]}


# ---------------------------------------------------------------------
# main
# ---------------------------------------------------------------------

def main():
    out = {}
    report = []
    say = report.append

    say('=' * 72)
    say(' Rigid circle packings in a rectangle: checks for circle-packings.typ')
    say('=' * 72)
    say('')
    say(' Height 1, width W.  "found" = distinct honest packings of the pattern')
    say(' (inside the rectangle, no overlaps, no extra tangencies) reached from')
    say(' %d random starting points.  The theorem predicts found = 1 and' % STARTS)
    say(' Jacobian rank = 3n + 1 for every triangulated pattern.')

    # (1) two-row zigzags, all lattice paths for k = 2, 3, 4
    out['zigzag'] = {}
    for k in (2, 3, 4):
        say('')
        say('-' * 72)
        say(' (1) two-row zigzags, k = %d: %d circles, %d equations'
            % (k, 2 * k, 6 * k + 1))
        say('-' * 72)
        say('   cross tangencies A_i B_j' + ' ' * 22 + 'found  rank       W      r(A1)')
        out['zigzag'][str(k)] = []
        for path in lattice_paths(k):
            p = zigzag(k, path)
            assert p.equations() == 3 * p.n + 1
            sols = survey(p)
            ranks = [jac_rank(p, z) for z in sols]
            assert len(sols) == 1 and ranks == [3 * p.n + 1], (path, len(sols), ranks)
            z = sols[0]
            say('   %-44s %3d  %4d  %.6f  %.6f'
                % (' '.join('%d%d' % e for e in path), len(sols), ranks[0], z[3 * p.n], z[2 * p.n]))
            rec = record(p, z)
            rec['path'] = path
            out['zigzag'][str(k)].append(rec)

    # (2) the six circles
    six = six_circles()
    six_sols = survey(six)
    assert len(six_sols) == 1
    z6 = six_sols[0]
    out['six'] = record(six, z6)
    say('')
    say('-' * 72)
    say(' (2) the six circles (k = 3, alternating path)')
    say('-' * 72)
    for i, lab in enumerate(six.labels):
        say('   r(%-2s) = %.12f' % (lab, z6[12 + i]))
    say('   W     = %.12f' % z6[18])
    say('   check: r(A) = r(A\'), r(B) = r(B\'), r(C) = r(C\') (half-turn symmetry)')
    assert abs(z6[12] - z6[17]) + abs(z6[13] - z6[16]) + abs(z6[14] - z6[15]) < 1e-9

    # (3) three rows, with two circles touching no side
    tr = three_rows()
    assert tr.equations() == 3 * tr.n + 1
    sols = survey(tr)
    ranks = [jac_rank(tr, z) for z in sols]
    assert len(sols) == 1 and ranks == [3 * tr.n + 1]
    out['three_rows'] = record(tr, sols[0])
    say('')
    say('-' * 72)
    say(' (3) three rows: 8 circles, 25 equations; M1, M2 touch no side')
    say('-' * 72)
    say('   found %d, Jacobian rank %d' % (len(sols), ranks[0]))
    for i, lab in enumerate(tr.labels):
        say('   r(%-2s) = %.12f' % (lab, sols[0][16 + i]))
    say('   W     = %.12f' % sols[0][24])

    # (4) circles inserted into gaps of the six circles
    A, B, C, Cp, Bp, Ap = range(6)
    gaps = [(A, B, Bp), (A, Bp, Cp), (B, Bp, Ap), (B, C, Ap)]
    ins = with_insertions(six, gaps)
    assert ins.equations() == 3 * ins.n + 1
    starts = []
    for _ in range(20):
        z0 = np.concatenate([z6[:6], np.zeros(4), z6[6:12], np.zeros(4),
                             z6[12:18], np.zeros(4), [z6[18]]])
        for g, gap in enumerate(gaps):
            i = 6 + g
            n = ins.n
            z0[i] = np.mean([z6[c] for c in gap]) + rng.normal(0, 0.01)
            z0[n + i] = np.mean([z6[6 + c] for c in gap]) + rng.normal(0, 0.01)
            z0[2 * n + i] = 0.03
        starts.append(z0)
    sols = survey(ins, starts=0, extra_starts=starts)
    assert len(sols) == 1
    out['inserted'] = record(ins, sols[0])
    say('')
    say('-' * 72)
    say(' (4) six circles + one circle inserted in each of the 4 central gaps')
    say('-' * 72)
    say('   found %d, Jacobian rank %d of %d; old circles unchanged: %s'
        % (len(sols), jac_rank(ins, sols[0]), 3 * ins.n + 1,
           np.allclose(sols[0][:6], z6[:6]) and np.allclose(sols[0][20:26], z6[12:18])))
    say('   inserted radii: ' + ', '.join('%.6f' % v for v in sols[0][26:30]))

    # (5) dropping the tangency B B' from the six circles: a one-parameter family
    say('')
    say('-' * 72)
    say(" (5) six circles without the tangency B B': fix r(A) = t and solve")
    say('-' * 72)
    say("       t       W      gap(B, B')   honest packing?")
    flex = []
    base_cc = [e for e in six.cc if e != (B, Bp)]
    for t in np.round(np.arange(0.270, 0.3401, 0.005), 3):
        p = Pattern('six circles, no BB\'', six.labels, six.rows, base_cc, six.walls, fix=[(A, t)])
        z = solve_from(p, z6)
        if z is None:
            say('   %.3f   no solution near the rigid one' % t)
            continue
        gap = np.hypot(z[B] - z[Bp], z[6 + B] - z[6 + Bp]) - z[12 + B] - z[12 + Bp]
        c = contacts(p, z)
        ok = c is not None and c == (p.cc, p.walls)
        say('   %.3f  %.6f  %+.6f     %s' % (t, z[18], gap, 'yes' if ok else 'no (B, B\' overlap)' if gap < 0 else 'no'))
        if ok:
            rec = record(p, z)
            rec['t'] = float(t)
            flex.append(rec)
    out['flex'] = flex
    say("   (at t = r(A) of the rigid packing, %.6f, the gap closes)" % z6[12])

    with open('circle-packings.json', 'w') as f:
        json.dump(out, f, indent=1)
    with open('../results/circle-packings.txt', 'w') as f:
        f.write('\n'.join(report) + '\n')
    print('\n'.join(report))


if __name__ == '__main__':
    main()
