# =====================================================================
# circle-porism.sage -- the six-circle packing ITvhHdEUW and its length
# coincidence (circle-porism.typ).
#
#     cd kummer
#     sage circle-porism.sage > ../results/circle-porism.txt
#
# The diagram is the triangulated pattern with graph6 key ITvhHdEUW from
# circle-graph-search.py (six circles, one of them touching no side).
# The search of circle-coincidences.sage found that the centre of the
# top-left corner circle is equidistant from the point where the top-right
# corner circle touches the top and the point where the bottom-left corner
# circle touches the bottom.
#
# This script
#   (1) solves and certifies the packing exactly (circle-interior.sage)
#       and verifies the coincidence in the number field;
#   (2) removes the interior circle; the remaining five circles have one
#       contact fewer than needed and move in a one-parameter family.  It
#       follows that family (fixing the radius of the top-left circle at a
#       range of values) and checks the coincidence at every member;
#   (3) writes circle-porism.json for the figures.
# =====================================================================
import json, sys, importlib.util
import numpy as np

sys.argv = sys.argv[:1]
_NO_MAIN = True
load('circle-interior.sage')

KEY = 'ITvhHdEUW'
for cc, walls, key in cgs.patterns(6):
    if key == KEY:
        break
cc, walls = [tuple(e) for e in cc], [tuple(e) for e in walls]
n = 6
touch = {}
for p, sd in walls:
    touch.setdefault(p, set()).add(sd)
print('pattern %s' % KEY)
print('   tangencies:', cc)
print('   sides     :', walls)

# roles of the circles, read off from their side contacts
def role(i):
    t = touch.get(i, set())
    if t == {'top', 'left'}: return 'TL'
    if t == {'top', 'right'}: return 'TR'
    if t == {'bottom', 'left'}: return 'BL'
    if t == {'bottom', 'right'}: return 'BR'
    if t == {'bottom'}: return 'Bm'
    if t == {'top'}: return 'Tm'
    if not t: return 'In'
    return ''.join(sorted(s[0].upper() for s in t))
roles = [role(i) for i in range(n)]
print('   roles     :', roles)
iTL, iTR, iBL = roles.index('TL'), roles.index('TR'), roles.index('BL')
inner = [i for i in range(n) if roles[i] == 'In'][0]

# (1) exact packing and the coincidence -------------------------------
z = cgs.solve(n, cc, walls, attempts=300)
res = analyse(n, cc, walls, z)
assert res['certified']
Kf, ex = res['field'], res['exact']
X, Y, R_, W = ex[:n], ex[n:2 * n], ex[2 * n:3 * n], ex[3 * n]
c1 = (X[iTL], Y[iTL])
T2 = (X[iTR], Kf(1))
T4 = (X[iBL], Kf(0))
d2 = (c1[0] - T2[0])^2 + (c1[1] - T2[1])^2
d4 = (c1[0] - T4[0])^2 + (c1[1] - T4[1])^2
print()
print('(1) the packing: field of degree %d, Galois group %s, W = %.10f' % (res['degF'], res['galois'], res['W']))
print('    |centre(TL) - touch(TR, top)|^2 == |centre(TL) - touch(BL, bottom)|^2 exactly: %s' % (d2 == d4))
emb = [e for e in Kf.embeddings(RealField(100)) if abs(e(W) - RealField(100)(res['W'])) < 1e-10][0]
print('    common length %.12f, its square has minimal polynomial %s' % (sqrt(emb(d2)), d2.minpoly()))
print('    radii: %s' % ', '.join('%s %.6f' % (roles[i], float(emb(R_[i]))) for i in range(n)))

# (2) the family without the interior circle ----------------------------
cc5 = [e for e in cc if inner not in e]
walls5 = [e for e in walls if e[0] != inner]
keep = [i for i in range(n) if i != inner]
print()
print('(2) without the interior circle: %d circles, %d contacts, %d unknowns -> a one-parameter family'
      % (len(keep), len(cc5) + len(walls5), 3 * len(keep) + 1))

def residual(zz, rfix):
    x, y, r, Wv = zz[:n], zz[n:2 * n], zz[2 * n:3 * n], zz[3 * n]
    out = [np.hypot(x[i] - x[j], y[i] - y[j]) - r[i] - r[j] for i, j in cc5]
    for i, sd in walls5:
        out.append({'top': 1 - y[i] - r[i], 'bottom': y[i] - r[i], 'left': x[i] - r[i], 'right': Wv - x[i] - r[i]}[sd])
    out.append(r[iTL] - rfix)
    # keep the (now irrelevant) interior circle where it was
    out += [x[inner] - z0[inner], y[inner] - z0[n + inner], r[inner] - z0[2 * n + inner]]
    return np.array(out)

def solve_member(start, rfix):
    zz = np.array(start, float)
    for _ in range(100):
        F = residual(zz, rfix)
        if np.max(np.abs(F)) < 1e-15:
            break
        J = np.zeros((len(F), len(zz))); h = 1e-7
        for c in range(len(zz)):
            dz = np.zeros(len(zz)); dz[c] = h
            J[:, c] = (residual(zz + dz, rfix) - residual(zz - dz, rfix)) / (2 * h)
        zz = zz - np.linalg.lstsq(J, F, rcond=None)[0]
    return zz, np.max(np.abs(residual(zz, rfix)))

def lengths(zz):
    x, y, r, Wv = zz[:n], zz[n:2 * n], zz[2 * n:3 * n], zz[3 * n]
    a = np.hypot(x[iTL] - x[iTR], y[iTL] - 1)
    b = np.hypot(x[iTL] - x[iBL], y[iTL] - 0)
    return a, b

def honest(zz):
    x, y, r, Wv = zz[:n], zz[n:2 * n], zz[2 * n:3 * n], zz[3 * n]
    E = set(cc5)
    for a_ in keep:
        if r[a_] <= 0 or x[a_] - r[a_] < -1e-9 or x[a_] + r[a_] > Wv + 1e-9 or y[a_] - r[a_] < -1e-9 or y[a_] + r[a_] > 1 + 1e-9:
            return False
        for b_ in keep:
            if a_ < b_ and (a_, b_) not in E and np.hypot(x[a_] - x[b_], y[a_] - y[b_]) < r[a_] + r[b_] - 1e-9:
                return False
    return True

z0 = [float(v) for v in res['numeric']]
r0 = z0[2 * n + iTL]
members = []
for rfix in sorted(set([r0] + [r0 + d for d in np.linspace(-0.08, 0.08, 17)])):
    # walk from the packing to rfix in small steps
    zz = np.array(z0)
    for s_ in np.linspace(r0, rfix, 12)[1:]:
        zz, err = solve_member(zz, s_)
    a, b = lengths(zz)
    ok = honest(zz)
    members.append((rfix, a, b, err, ok, zz))
    print('    r(TL) = %.4f: |c(TL) T(TR,top)| = %.12f, |c(TL) T(BL,bottom)| = %.12f, difference %.1e, residual %.0e, honest %s'
          % (rfix, a, b, a - b, err, ok))
print('    largest difference along the family: %.1e' % max(abs(a - b) for _, a, b, _, ok, _ in members))

# (3) figure data -----------------------------------------------------
def circles(zz, drop_inner=False):
    x, y, r, Wv = zz[:n], zz[n:2 * n], zz[2 * n:3 * n], zz[3 * n]
    return [{'x': float(x[i]), 'y': float(y[i]), 'r': float(r[i]), 'label': roles[i],
             'row': {'TL': 'top', 'TR': 'top', 'Tm': 'top', 'BL': 'bottom', 'BR': 'bottom', 'Bm': 'bottom'}.get(roles[i], 'mid')}
            for i in range(n) if not (drop_inner and i == inner)]
fig = {'W': float(res['W']), 'circles': circles(z0), 'cc': [list(e) for e in cc],
       'walls': [[i, sd] for i, sd in walls], 'roles': roles, 'iTL': int(iTL), 'iTR': int(iTR), 'iBL': int(iBL), 'inner': int(inner),
       'length': float(sqrt(emb(d2))), 'degF': int(res['degF']), 'galois': str(res['galois']), 'r0': float(r0),
       'minpoly_len2': str(d2.minpoly()),
       'family': [{'r': float(rf), 'W': float(zz[3 * n]), 'a': float(a), 'b': float(b), 'honest': bool(ok),
                   'circles': circles(zz, drop_inner=True)} for rf, a, b, err, ok, zz in members]}
with open('circle-porism.json', 'w') as fh:
    json.dump(fig, fh, indent=1)
print()
print('figure data written to circle-porism.json')
