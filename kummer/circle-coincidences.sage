# =====================================================================
# circle-coincidences.sage -- "length coincidences" in the rigid circle
# packings of circle-packings.typ and circle-interior.sage.
#
#     cd kummer
#     sage circle-coincidences.sage > ../results/circle-coincidences.txt
#
# The MathOverflow six-circle problem asks why the segment joining the
# centres of A and A' is as long as the rectangle is high.  Here every
# diagram considered so far is searched for such coincidences.
#
# Diagrams: the two-row zigzags k = 2..5 (one per symmetry orbit), the
# patterns with an interior circle and at most 6 circles, and the brick
# family k = 2..4.  Each packing is certified exactly in its number field
# F (circle-interior.sage).
#
# Special points: the four corners of the rectangle, the circle centres,
# and all points of tangency (circle-circle and circle-side).  Segments:
# all pairs of special points.  Two segments of equal length form a
# coincidence unless the equality is trivial:
#   (1) it holds locally: on random configurations that satisfy only the
#       constraints among the circles occurring in the two segments (their
#       side contacts and their mutual tangencies), obtained by perturbing
#       the packing and projecting back by Gauss-Newton steps.  This
#       catches radii of one circle, corner squares, equal sides of the
#       rectangle, chords of one circle, and so on;
#   (2) it follows from (1) and a symmetry of the diagram (of the
#       rectangle, or of the square when W = 1): the random
#       configurations of (1) are also required to have the symmetries of
#       the diagram, and segments mapped to each other are identified.
# Each coincidence is then classified by its support: every contact is
# dropped in turn, the configuration is moved a little along the
# resulting one-parameter family, and the coincidence is tested there.
# A "rigid" coincidence survives no drop (like AA' = height); a "porism"
# survives at least one, so it is an identity on a flexible family.
# Segments are grouped by length; within a group, segments related by (1)
# or (2) are merged, and a group with two or more classes left is a
# coincidence.  Each one is then checked exactly in F.
# =====================================================================
import random, itertools, time, sys
_NO_MAIN = True
sys.argv = sys.argv[:1]
load('circle-degrees-growth.sage')   # lattice_paths, canonical
load('circle-interior.sage')
random.seed(int(11))
RN = RealField(400)


def zigzag_pattern(k, path):
    A = lambda i: i - 1
    B = lambda j: k + j - 1
    cc = [(A(i), A(i + 1)) for i in range(1, k)] + [(B(j), B(j + 1)) for j in range(1, k)]
    cc += [(A(i), B(j)) for i, j in path]
    walls = [(A(i), 'top') for i in range(1, k + 1)] + [(B(j), 'bottom') for j in range(1, k + 1)]
    walls += [(A(1), 'left'), (B(1), 'left'), (A(k), 'right'), (B(k), 'right')]
    names = ['A%d' % i for i in range(1, k + 1)] + ['B%d' % j for j in range(1, k + 1)]
    return 2 * k, sorted(tuple(sorted(e)) for e in cc), sorted(walls), names


def special_points(n, cc, walls, X, Y, Rr, W, one=1, zero=0):
    """(name, (x, y)) for the corners, centres and points of tangency."""
    pts = [('corner BL', (zero, zero)), ('corner BR', (W, zero)), ('corner TL', (zero, one)), ('corner TR', (W, one))]
    pts += [('centre %d' % i, (X[i], Y[i])) for i in range(n)]
    for i, j in cc:
        lam = Rr[i] / (Rr[i] + Rr[j])
        pts.append(('touch %d-%d' % (i, j), (X[i] + lam * (X[j] - X[i]), Y[i] + lam * (Y[j] - Y[i]))))
    for i, sd in walls:
        p = {'top': (X[i], one), 'bottom': (X[i], zero), 'left': (zero, Y[i]), 'right': (W, Y[i])}[sd]
        pts.append(('touch %d-%s' % (i, sd), p))
    return pts


def sq(p, q):
    return (p[0] - q[0])^2 + (p[1] - q[1])^2


def generic_sample(n, walls):
    """Random x, y, r, W satisfying the side contacts only."""
    touch = {}
    for i, sd in walls:
        touch.setdefault(i, set()).add(sd)
    r = [RN(random.uniform(0.05, 0.45)) for _ in range(n)]
    y = [RN(random.uniform(0.1, 0.9)) for _ in range(n)]
    W = RN(random.uniform(1.0, 3.0))
    for i, s_ in touch.items():
        if {'top', 'bottom'} <= s_:
            r[i] = RN(1) / 2
        if {'left', 'right'} <= s_:
            W = 2 * r[i]
    x = [RN(random.uniform(0.1, 0.9)) * W for _ in range(n)]
    for i, s_ in touch.items():
        if 'top' in s_: y[i] = 1 - r[i]
        if 'bottom' in s_: y[i] = r[i]
        if 'left' in s_: x[i] = r[i]
        if 'right' in s_: x[i] = W - r[i]
    return x, y, r, W


AFFINE = {
    'x -> W-x': ((-1, 0, 1, 0), (0, 1, 0, 0)),
    'y -> 1-y': ((1, 0, 0, 0), (0, -1, 0, 1)),
    'half-turn': ((-1, 0, 1, 0), (0, -1, 0, 1)),
    # only for a square (W = 1)
    'diagonal': ((0, 1, 0, 0), (1, 0, 0, 0)),
    'antidiagonal': ((0, -1, 0, 1), (-1, 0, 0, 1)),
    'quarter-turn': ((0, -1, 0, 1), (1, 0, 0, 0)),
    'three-quarter-turn': ((0, 1, 0, 0), (-1, 0, 0, 1)),
}
SQUARE_ONLY = ('diagonal', 'antidiagonal', 'quarter-turn', 'three-quarter-turn')


def apply_affine(kind, p, W):
    (ax, bx, cx, dx), (ay, by, cy, dy) = AFFINE[kind]
    return (ax * p[0] + bx * p[1] + cx * W + dx, ay * p[0] + by * p[1] + cy * W + dy)


def symmetries(pts_num, W):
    """Isometries of the rectangle (of the square, if W = 1) mapping the
    special points to themselves, as permutations of the point indices."""
    found = []
    for name in AFFINE:
        if name in SQUARE_ONLY and abs(W - 1) > 1e-40:
            continue
        perm = []
        for nm, p in pts_num:
            q = apply_affine(name, p, W)
            hit = [j for j, (nm2, p2) in enumerate(pts_num) if abs(p2[0] - q[0]) + abs(p2[1] - q[1]) < 1e-40
                   and nm2.split()[0] == nm.split()[0]]
            if len(hit) != 1:
                break
            perm.append(hit[0])
        else:
            found.append((name, perm))
    return found

import numpy as np


def involved(seg_names):
    """Circles occurring in the endpoints of two segments."""
    out = set()
    for nm in seg_names:
        parts = nm.split()
        if parts[0] == 'centre':
            out.add(int(parts[1]))
        elif parts[0] == 'touch':
            a, b = parts[1].split('-')
            out.add(int(a))
            if b.isdigit():
                out.add(int(b))
    return out


def local_samples(n, cc, walls, z0, circles, count=2, circle_syms=()):
    """Random points near the packing satisfying the side contacts of the
    given circles and their mutual tangencies."""
    # close the set of circles under the symmetries of the diagram
    circles = set(circles)
    changed = True
    while changed:
        changed = False
        for kind, cp in circle_syms:
            for i in list(circles):
                if cp[i] not in circles:
                    circles.add(cp[i]); changed = True
    eqs = []
    for kind, cp in circle_syms:
        for i in circles:
            eqs.append(('sym', i, cp[i], kind))
    if any(kind in SQUARE_ONLY for kind, cp in circle_syms):
        eqs.append(('square',))
    for i, sd in walls:
        if i in circles:
            eqs.append(('wall', i, sd))
    for i, j in cc:
        if i in circles and j in circles:
            eqs.append(('cc', i, j))
    def F(z):
        x, y, r, W = z[:n], z[n:2 * n], z[2 * n:3 * n], z[3 * n]
        out = []
        for e in eqs:
            if e[0] == 'sym':
                i, j, kind = e[1], e[2], e[3]
                (ax, bx, cx, dx), (ay, by, cy, dy) = AFFINE[kind]
                out.append(r[j] - r[i])
                out.append(x[j] - (ax * x[i] + bx * y[i] + cx * W + dx))
                out.append(y[j] - (ay * x[i] + by * y[i] + cy * W + dy))
                continue
            if e[0] == 'square':
                out.append(W - 1)
                continue
            if e[0] == 'wall':
                i, sd = e[1], e[2]
                out.append({'top': y[i] + r[i] - 1, 'bottom': y[i] - r[i], 'left': x[i] - r[i], 'right': W - x[i] - r[i]}[sd])
            else:
                i, j = e[1], e[2]
                out.append((x[i] - x[j])**2 + (y[i] - y[j])**2 - (r[i] + r[j])**2)
        return np.array(out)
    def J(z):
        x, y, r, W = z[:n], z[n:2 * n], z[2 * n:3 * n], z[3 * n]
        rows = []
        def row(): return np.zeros(3 * n + 1)
        X, Y, R, WW = (lambda i: i), (lambda i: n + i), (lambda i: 2 * n + i), 3 * n
        for e in eqs:
            if e[0] == 'sym':
                i, j, kind = e[1], e[2], e[3]
                (ax, bx, cx, dx), (ay, by, cy, dy) = AFFINE[kind]
                a = row(); a[R(j)] = 1; a[R(i)] -= 1; rows.append(a)
                a = row(); a[X(j)] += 1; a[X(i)] -= ax; a[Y(i)] -= bx; a[WW] -= cx; rows.append(a)
                a = row(); a[Y(j)] += 1; a[X(i)] -= ay; a[Y(i)] -= by; a[WW] -= cy; rows.append(a)
            elif e[0] == 'square':
                a = row(); a[WW] = 1; rows.append(a)
            elif e[0] == 'wall':
                i, sd = e[1], e[2]
                a = row()
                if sd == 'top': a[Y(i)] = 1; a[R(i)] = 1
                elif sd == 'bottom': a[Y(i)] = 1; a[R(i)] = -1
                elif sd == 'left': a[X(i)] = 1; a[R(i)] = -1
                else: a[WW] = 1; a[X(i)] = -1; a[R(i)] = -1
                rows.append(a)
            else:
                i, j = e[1], e[2]
                a = row()
                a[X(i)] += 2 * (x[i] - x[j]); a[X(j)] -= 2 * (x[i] - x[j])
                a[Y(i)] += 2 * (y[i] - y[j]); a[Y(j)] -= 2 * (y[i] - y[j])
                a[R(i)] -= 2 * (r[i] + r[j]); a[R(j)] -= 2 * (r[i] + r[j])
                rows.append(a)
        return np.array(rows)
    samples = []
    rng = np.random.default_rng(int(17 * len(circles) + n))
    for _ in range(count):
        z = np.array(z0, dtype=float) + rng.normal(0, 0.03, len(z0))
        for _ in range(200):
            Fz = F(z)
            if len(Fz) == 0 or np.max(np.abs(Fz)) < 1e-14:
                break
            z = z - np.linalg.lstsq(J(z), Fz, rcond=None)[0]
        samples.append(z)
    return samples


def drop_residuals(z, n, cc, walls, skip):
    x, y, r, W = z[:n], z[n:2 * n], z[2 * n:3 * n], z[3 * n]
    out = []
    for e in cc:
        if e != skip:
            i, j = e
            out.append(np.hypot(x[i] - x[j], y[i] - y[j]) - r[i] - r[j])
    for e in walls:
        if e != skip:
            i, sd = e
            out.append({'top': 1 - y[i] - r[i], 'bottom': y[i] - r[i], 'left': x[i] - r[i], 'right': W - x[i] - r[i]}[sd])
    return np.array(out)


def moved(z0, n, cc, walls, skip, eps=0.01):
    """A configuration near the packing with every contact except `skip`:
    a point of the one-parameter family obtained by dropping `skip`."""
    z = np.array(z0, float)
    for trial in range(6):
        d = np.random.default_rng(int(trial)).normal(0, 1, len(z)); d /= np.linalg.norm(d)
        zt = z + eps * d
        for _ in range(100):
            F = drop_residuals(zt, n, cc, walls, skip)
            if np.max(np.abs(F)) < 1e-14:
                break
            J = np.zeros((len(F), len(zt))); h = 1e-7
            for c in range(len(zt)):
                dz = np.zeros(len(zt)); dz[c] = h
                J[:, c] = (drop_residuals(zt + dz, n, cc, walls, skip) - drop_residuals(zt - dz, n, cc, walls, skip)) / (2 * h)
            zt = zt - np.linalg.lstsq(J, F, rcond=None)[0]
        if np.max(np.abs(drop_residuals(zt, n, cc, walls, skip))) < 1e-12 and np.linalg.norm(zt - z) > 1e-4:
            return zt
    return None


class UF:
    def __init__(self, items): self.p = {a: a for a in items}
    def find(self, a):
        while self.p[a] != a:
            self.p[a] = self.p[self.p[a]]; a = self.p[a]
        return a
    def union(self, a, b): self.p[self.find(a)] = self.find(b)


def coincidences(n, cc, walls, names, label):
    z = cgs.solve(n, cc, walls, attempts=200)
    if z is None:
        return label, 'not solved', []
    res = analyse(n, cc, walls, z)
    if res is None:
        return label, 'degree too large for LLL', []
    Kf, ex, zz = res['field'], res['exact'], res['numeric']
    certified = res['certified']
    if certified:
        Xe, Ye, Re, We = ex[:n], ex[n:2 * n], ex[2 * n:3 * n], ex[3 * n]
    Xn, Yn, Rn, Wn = [RN(v) for v in zz[:n]], [RN(v) for v in zz[n:2 * n]], [RN(v) for v in zz[2 * n:3 * n]], RN(zz[3 * n])
    pe = special_points(n, cc, walls, Xe, Ye, Re, We, Kf(1), Kf(0)) if certified else None
    pn = special_points(n, cc, walls, Xn, Yn, Rn, Wn, RN(1), RN(0))
    segs = list(itertools.combinations(range(len(pn)), 2))
    L = {s: sq(pn[s[0]][1], pn[s[1]][1]) for s in segs}
    segs = [s for s in segs if L[s] > 1e-40]                 # drop coincident points
    z0 = [float(v) for v in zz]
    cache = {}
    syms = symmetries(pn, Wn)
    centre_idx = {i: [j for j, (nm, p) in enumerate(pn) if nm == 'centre %d' % i][0] for i in range(n)}
    circle_syms = []
    for kind, perm in syms:
        cp = {}
        for i in range(n):
            img = pn[perm[centre_idx[i]]][0]
            cp[i] = int(img.split()[1])
        circle_syms.append((kind, cp))
    # group by numerical length
    order = sorted(segs, key=lambda s: L[s])
    groups, cur = [], [order[0]]
    for s in order[1:]:
        if abs(L[s] - L[cur[0]]) < 1e-80 * max(1, L[s]):
            cur.append(s)
        else:
            groups.append(cur); cur = [s]
    groups.append(cur)
    found = []
    for g in groups:
        if len(g) < 2:
            continue
        uf = UF(g)
        gs = set(g)
        for a, b in itertools.combinations(g, 2):
            if uf.find(a) == uf.find(b):
                continue
            circ = frozenset(involved([pn[a[0]][0], pn[a[1]][0], pn[b[0]][0], pn[b[1]][0]]))
            if circ not in cache:
                cache[circ] = []
                for zs in local_samples(n, cc, walls, z0, circ, circle_syms=circle_syms):
                    Xs, Ys, Rs, Ws = list(zs[:n]), list(zs[n:2 * n]), list(zs[2 * n:3 * n]), zs[3 * n]
                    cache[circ].append(special_points(n, cc, walls, Xs, Ys, Rs, Ws, 1.0, 0.0))
            if all(abs(sq(P[a[0]][1], P[a[1]][1]) - sq(P[b[0]][1], P[b[1]][1])) < 1e-9 for P in cache[circ]):
                uf.union(a, b)
        for name, perm in syms:
            for a in g:
                im = tuple(sorted((perm[a[0]], perm[a[1]])))
                if im in gs:
                    uf.union(a, im)
        classes = {}
        for a in g:
            classes.setdefault(uf.find(a), []).append(a)
        if len(classes) < 2:
            continue
        reps = [c[0] for c in classes.values()]
        exact_ok = all(sq(pe[r[0]][1], pe[r[1]][1]) == sq(pe[reps[0][0]][1], pe[reps[0][1]][1]) for r in reps) if certified else '?'
        found.append((float(sqrt(L[g[0]])), exact_ok, list(classes.values()), pn))
    # support: which contacts can be dropped without destroying the coincidence?
    contacts = list(cc) + list(walls)
    family = {e: moved(z0, n, cc, walls, e) for e in contacts} if found else {}
    for idx, (length, ok, classes, pn_) in enumerate(found):
        reps = [c[0] for c in classes]
        survives, tested = [], 0
        for e, zt in family.items():
            if zt is None:
                continue
            tested += 1
            Xs, Ys, Rs, Ws = list(zt[:n]), list(zt[n:2 * n]), list(zt[2 * n:3 * n]), zt[3 * n]
            P = special_points(n, cc, walls, Xs, Ys, Rs, Ws, 1.0, 0.0)
            ls = [sq(P[r_[0]][1], P[r_[1]][1]) for r_ in reps]
            if max(ls) - min(ls) < 1e-9 * max(1.0, max(ls)):
                survives.append(e)
        found[idx] = (length, ok, classes, pn_, survives, tested)
    return label, res, found, syms


def describe(name, names):
    parts = name.split()
    if parts[0] == 'corner':
        return 'corner ' + parts[1]
    if parts[0] == 'centre':
        return 'centre(%s)' % names[int(parts[1])]
    a, b = parts[1].split('-')
    if b.isdigit():
        return 'touch(%s,%s)' % (names[int(a)], names[int(b)])
    return 'touch(%s,%s)' % (names[int(a)], b)


def report(label, out, names):
    label, res, found, syms = out if len(out) == 4 else (out[0], out[1], out[2], [])
    if isinstance(res, str):
        print('%s: %s' % (label, res)); return 0
    print('%s   [deg F = %d%s, W = %.6f, symmetries: %s]' % (label, res['degF'], '' if res['certified'] else ' (not certified)', res['W'], ', '.join(s[0] for s in syms) or 'none'))
    for length, ok, classes, pn, survives, tested in found:
        segtxt = []
        for c in classes:
            a = c[0]
            segtxt.append('%s--%s%s' % (describe(pn[a[0]][0], names), describe(pn[a[1]][0], names),
                                        ' (+%d)' % (len(c) - 1) if len(c) > 1 else ''))
        kind = 'rigid' if not survives else 'porism (survives dropping %d of %d contacts)' % (len(survives), tested)
        KINDS.append((res['degF'], 'rigid' if not survives else 'porism', label))
        print('   length %.10f  exact: %-5s  %-45s %s' % (length, str(ok), kind, '  =  '.join(segtxt)))
    return len(found)


KINDS = []
T0 = time.time()
total = 0
print('=' * 76)
print(' Two-row zigzags')
print('=' * 76)
for k in range(2, 6):
    seen = set()
    for path in lattice_paths(k):
        key = canonical(k, path)
        if key in seen:
            continue
        seen.add(key)
        n, cc, walls, names = zigzag_pattern(k, list(key))
        out = coincidences(n, cc, walls, names, 'k=%d %s' % (k, ' '.join('%d%d' % e for e in key)))
        total += report(out[0], out, names)
    sys.stdout.flush()
print()
print('=' * 76)
print(' Packings with interior circles (at most 6 circles), and the brick family')
print('=' * 76)
for n in range(5, 7):
    for cc, walls, key in cgs.patterns(n):
        deg = [0] * n
        for p, q in cc:
            deg[p] += 1; deg[q] += 1
        for p, sd in walls:
            deg[p] += 1
        touched = set(p for p, sd in walls)
        if all(i in touched for i in range(n)) or min(deg) < 4:
            continue
        tch = {}
        for p, sd in walls:
            tch.setdefault(p, []).append(sd[0].upper())
        names = ['c%d%s' % (i, ''.join(sorted(tch.get(i, ['o'])))) for i in range(n)]
        out = coincidences(n, list(cc), list(walls), names, 'n=%d %s' % (n, key))
        total += report(out[0], out, names)
    sys.stdout.flush()
for k in range(2, 5):
    n, cc, walls = brick(k)
    names = ['A%d' % i for i in range(1, k + 1)] + ['B%d' % j for j in range(1, k + 1)] + ['M%d' % i for i in range(1, k)]
    out = coincidences(n, cc, walls, names, 'brick k=%d' % k)
    total += report(out[0], out, names)
print()
print('%d coincidences in total  (%.0fs)' % (total, time.time() - T0))
print()
print('rigid coincidences (survive dropping no contact) and porisms, by degree of the field:')
from collections import Counter
cnt = Counter((d, k) for d, k, lab in KINDS)
for d in sorted(set(d for d, k, lab in KINDS)):
    print('   deg F = %2d: %3d rigid, %3d porisms' % (d, cnt[(d, 'rigid')], cnt[(d, 'porism')]))
print('rigid coincidences in fields of degree >= 4:')
for d, k, lab in KINDS:
    if k == 'rigid' and d >= 4:
        print('   ', lab, ' deg F =', d)
