# =====================================================================
# circle-genus.sage -- the curve of configurations obtained from a rigid
# two-row zigzag by dropping one tangency, and its genus (circle-genus.typ).
#
#     cd kummer
#     sage circle-genus.sage > ../results/circle-genus.txt
#
# Writes circle-genus.json (figure data for circle-genus.typ).
#
# Height 1.  Top row A_1..A_k, bottom row B_1..B_k; the pattern is a
# lattice path of pairs (i, j) = tangencies A_i B_j from (1,1) to (k,k).
# Coordinates: a_i = sqrt r(A_i), b_j = sqrt r(B_j) (signed), X_i, Y_j the
# x-coordinates of the centres, K = Q(sqrt 2), s = sqrt 2.
#
#   row tangency      X_{i+1} - X_i = 2 a_i a_{i+1}
#   cross tangency    (X_i - Y_j)^2 = 2 (a_i^2 + b_j^2) - 1
#   left corner       a_1 + b_1 = 1,  X_1 = a_1^2,  Y_1 = b_1^2
#   next circle       a_i / a_{i+1} = Y_j - X_i + s b_j   (A_{i+1} after A_i B_j)
#                     b_j / b_{j+1} = X_i - Y_j + s a_i   (B_{j+1} after A_i B_j)
#
# Dropping the tangency A_{i0} B_{j0} at a turn of the path splits the
# circles into a left chain, built from t = a_1, and a right chain, built
# by the same recursion from the right wall from v = a_k in the mirrored
# coordinate x' = W - x.  The two row tangencies across the cut both
# contain W; eliminating W gives Phi(t, v) = 0.  The component H of
# Phi = 0 through the packing is birational to the family of
# configurations, and its geometric genus is computed by Singular.
# =====================================================================
import json, time
from collections import Counter

K.<s> = QuadraticField(2)
R2.<t, v> = K[]
FF = R2.fraction_field()
RF = RealField(300)
emb = {+1: [e for e in K.embeddings(RF) if e(s) > 0][0], -1: [e for e in K.embeddings(RF) if e(s) < 0][0]}
TOL = 1e-12


def lattice_paths(k):
    out = []
    def rec(p):
        i, j = p[-1]
        if (i, j) == (k, k):
            out.append(p); return
        if i < k: rec(p + [(i + 1, j)])
        if j < k: rec(p + [(i, j + 1)])
    rec([(1, 1)])
    return out


def pstr(path):
    return ' '.join('%d%d' % e for e in path)


def chain(path, var):
    """The recursion along a prefix of a path, from a_1 = var."""
    a = {1: FF(var)}; b = {1: FF(1 - var)}; X = {1: FF(var^2)}; Y = {1: FF((1 - var)^2)}
    for (i, j), (i2, j2) in zip(path, path[1:]):
        if i2 == i + 1:
            a[i2] = a[i] / (Y[j] - X[i] + s * b[j]); X[i2] = X[i] + 2 * a[i] * a[i2]
        else:
            b[j2] = b[j] / (X[i] - Y[j] + s * a[i]); Y[j2] = Y[j] + 2 * b[j] * b[j2]
    return a, b, X, Y


def chain_num(path, tv, sg=1):
    """The same recursion, evaluated step by step at a number tv, with
    sqrt 2 -> sg * sqrt 2 (avoids 0/0 in the composed rational functions)."""
    q = sg * sqrt(RF(2))
    a = {1: RF(tv)}; b = {1: 1 - RF(tv)}; X = {1: RF(tv)^2}; Y = {1: (1 - RF(tv))^2}
    for (i, j), (i2, j2) in zip(path, path[1:]):
        if i2 == i + 1:
            a[i2] = a[i] / (Y[j] - X[i] + q * b[j]); X[i2] = X[i] + 2 * a[i] * a[i2]
        else:
            b[j2] = b[j] / (X[i] - Y[j] + q * a[i]); Y[j2] = Y[j] + 2 * b[j] * b[j2]
    return a, b, X, Y


def ev(fn, sg, tv, vv=0):
    e = emb[sg]
    num = fn.numerator().map_coefficients(e, RF); den = fn.denominator().map_coefficients(e, RF)
    return num(tv, vv) / den(tv, vv)


def circles_from(A, B):
    """A, B: dicts label -> (x, signed sqrt r).  Returns a list of
    (label, x, y, r)."""
    out = [('A%d' % i, x, 1 - a^2, a^2) for i, (x, a) in sorted(A.items())]
    out += [('B%d' % j, x, b^2, b^2) for j, (x, b) in sorted(B.items())]
    return out


def honest(W, circ, tol=1e-9):
    if W <= 0:
        return False
    for _, x, y, r in circ:
        if r <= 0 or x - r < -tol or x + r > W + tol or y - r < -tol or y + r > 1 + tol:
            return False
    for p in range(len(circ)):
        for q in range(p + 1, len(circ)):
            _, x1, y1, r1 = circ[p]; _, x2, y2, r2 = circ[q]
            if sqrt((x1 - x2)^2 + (y1 - y2)^2) - r1 - r2 < -tol:
                return False
    return True


def contacts(W, circ, tol=1e-20):
    """All tangencies of a configuration (to compare with the pattern)."""
    cc = []
    for p in range(len(circ)):
        for q in range(p + 1, len(circ)):
            _, x1, y1, r1 = circ[p]; _, x2, y2, r2 = circ[q]
            if abs(sqrt((x1 - x2)^2 + (y1 - y2)^2) - r1 - r2) < tol:
                cc.append((circ[p][0], circ[q][0]))
    return cc


def rigid(k, path):
    """The irreducible factor f over K of the closing equation that
    vanishes at the packing, and the packing value of t."""
    a, b, X, Y = chain(path, t)
    E = (X[k] + a[k]^2 - Y[k] - b[k]^2).numerator()
    found = []
    for f, _ in E.factor():
        fu = f.polynomial(t) if f.degree() > 0 else None
        if fu is None:
            continue
        for rt in fu.map_coefficients(emb[1], RF).roots(RF, multiplicities=False):
            if not 0 < rt < 1:
                continue
            try:
                an, bn, Xn, Yn = chain_num(path, rt)
                A = {i: (Xn[i], an[i]) for i in an}
                B = {j: (Yn[j], bn[j]) for j in bn}
            except ZeroDivisionError:
                continue
            W = A[k][0] + A[k][1]^2
            if min(A[i][1] for i in A) > 0 and min(B[j][1] for j in B) > 0 and honest(W, circles_from(A, B)):
                found.append((fu, rt))
    assert len(found) == 1, (path, len(found))
    return found[0]


def turns(path):
    out = []
    for n0 in range(1, len(path) - 1):
        (i0, j0), p, q = path[n0], path[n0 - 1], path[n0 + 1]
        if (p == (i0 - 1, j0) and q == (i0, j0 + 1)) or (p == (i0, j0 - 1) and q == (i0 + 1, j0)):
            out.append(n0)
    return out


def glue(k, path, n0):
    """Phi(t, v) for the pattern minus the tangency path[n0], and a function
    returning the configuration at a point (t, v) of Phi = 0."""
    i0, j0 = path[n0]
    ab_turn = path[n0 - 1] == (i0 - 1, j0)
    aL, bL, XL, YL = chain(path[:n0], t)
    mirrored = [(k + 1 - i, k + 1 - j) for i, j in reversed(path)]
    aR, bR, XR, YR = chain(mirrored[:len(path) - 1 - n0], v)
    m = lambda i: k + 1 - i
    if ab_turn:
        # A_{i0} is in the right chain, B_{j0} in the left chain; glue
        # A_{i0-1} -- A_{i0} and B_{j0} -- B_{j0+1}
        Wt = XR[m(i0)] + XL[i0 - 1] + 2 * aL[i0 - 1] * aR[m(i0)]
        Wb = YR[m(j0 + 1)] + YL[j0] + 2 * bL[j0] * bR[m(j0 + 1)]
    else:
        Wb = YR[m(j0)] + YL[j0 - 1] + 2 * bL[j0 - 1] * bR[m(j0)]
        Wt = XR[m(i0 + 1)] + XL[i0] + 2 * aL[i0] * aR[m(i0 + 1)]
    Phi = Wt - Wb

    def configuration(sg, tv, vv):
        W = ev(Wt, sg, tv, vv)
        A = {i: (ev(XL[i], sg, tv, vv), ev(aL[i], sg, tv, vv)) for i in aL}
        B = {j: (ev(YL[j], sg, tv, vv), ev(bL[j], sg, tv, vv)) for j in bL}
        A.update({m(i): (W - ev(XR[i], sg, tv, vv), ev(aR[i], sg, tv, vv)) for i in aR})
        B.update({m(j): (W - ev(YR[j], sg, tv, vv), ev(bR[j], sg, tv, vv)) for j in bR})
        return W, circles_from(A, B)
    return Phi, configuration


def component(Phi, tv, vv):
    hits = [g for g, _ in Phi.numerator().factor()
            if abs(g.map_coefficients(emb[1], RF)(tv, vv)) < RF(10)^-60]
    assert len(hits) == 1
    return hits[0]


def genus_of(H):
    if H.degree(t) <= 1 or H.degree(v) <= 1:
        return 0                                   # a graph over one of the coordinates
    A2 = AffineSpace(K, 2, 'T,V')
    return Curve(H(*A2.coordinate_ring().gens()), A2).genus()


def symmetry_class(k, path, edge):
    """Orbit of (pattern, dropped edge) under the symmetries of the rectangle."""
    imgs = []
    for f in (lambda i, j: (i, j), lambda i, j: (j, i),
              lambda i, j: (k + 1 - i, k + 1 - j), lambda i, j: (k + 1 - j, k + 1 - i)):
        imgs.append((tuple(sorted(f(*e) for e in path)), f(*edge)))
    return min(imgs)


# ---------------------------------------------------------------------
# 1. all zigzags k = 2, 3, 4, every tangency at a turn
# ---------------------------------------------------------------------
print('=' * 72)
print(' Two-row zigzags: drop a cross tangency at a turn of the path')
print('=' * 72)
print()
print(' k  pattern                  dropped  bidegree (t,v)  genus   [orbit size]')
T0 = time.time()
seen = {}
stats = Counter()
for k in (2, 3, 4):
    for path in lattice_paths(k):
        f, t0 = rigid(k, path)
        v0 = chain_num(path, t0)[0][k]
        for n0 in turns(path):
            key = symmetry_class(k, path, path[n0])
            if key in seen:
                seen[key][-1] += 1
                continue
            Phi, configuration = glue(k, path, n0)
            H = component(Phi, t0, v0)
            g = genus_of(H)
            seen[key] = [k, path, path[n0], (H.degree(t), H.degree(v)), g, 1]
    for key, (kk, path, e, bd, g, cnt) in seen.items():
        if kk == k:
            stats[(k, g)] += 1
for key, (k, path, e, bd, g, cnt) in sorted(seen.items(), key=lambda kv: (kv[1][0], kv[1][4], kv[1][3])):
    print(' %d  %-24s A%dB%d    (%d,%d)           %d       [%d]' % (k, pstr(path), e[0], e[1], bd[0], bd[1], g, cnt))
print()
for k in (2, 3, 4):
    print(' k = %d: %s' % (k, ', '.join('%d classes of genus %d' % (stats[(k, g)], g) for g in sorted(set(g for kk, g in stats if kk == k)))))
print(' (%.0fs)' % (time.time() - T0))
print()

# ---------------------------------------------------------------------
# 2. the genus-one family
# ---------------------------------------------------------------------
k = 4
path = [(1, 1), (2, 1), (2, 2), (3, 2), (3, 3), (3, 4), (4, 4)]
mirror = sorted((k + 1 - i, k + 1 - j) for i, j in path)
n0 = path.index((3, 2))
f, t0 = rigid(k, path)
v0 = chain_num(path, t0)[0][k]
Phi, configuration = glue(k, path, n0)
H = component(Phi, t0, v0)
H = H / H.lc()
print('=' * 72)
print(' The genus-one family: pattern %s minus A3B2' % pstr(path))
print('=' * 72)
print()
print(' packing: t0 = sqrt r(A1) = %s,  v0 = sqrt r(A4) = %s' % (t0.n(60), v0.n(60)))
print(' f = %s  (degree m = %d over K)' % (f, f.degree()))
print(' H = %s' % H)
print(' H symmetric in t and v: %s' % (H == H(v, t)))
# the mirror pattern gives the same curve
fM, tM = rigid(k, mirror)
PhiM, configurationM = glue(k, mirror, mirror.index((2, 3)))
HM = component(PhiM, tM, chain_num(mirror, tM)[0][k])
print(' mirror pattern %s minus A2B3: same curve: %s;  its packing (t, v) = (%s, %s)'
      % (pstr(mirror), HM / HM.lc() == H, tM.n(30), chain_num(mirror, tM)[0][k].n(30)))
print(' so the mirror packing is the point (v0, t0) of H: %s' % (abs(tM - v0) < 1e-60))
print(' genus of H: %d' % genus_of(H))
Px.<x> = K[]
cA = Px(H.coefficient({v: 2}).polynomial(t)); cB = Px(H.coefficient({v: 1}).polynomial(t)); cC = Px(H.coefficient({v: 0}).polynomial(t))
Delta = cB^2 - 4 * cA * cC
print(' as a quadratic in v: (%s) v^2 + (%s) v + (%s)' % (cA, cB, cC))
print(' Delta(t) = %s' % Delta)
print('          = %s' % Delta.factor())
print(' Delta squarefree of degree 4: %s' % (Delta.is_squarefree() and Delta.degree() == 4))
print(' H irreducible over Kbar (Delta not a constant times a square): %s' % (not (Delta / Delta.lc()).is_square()))
e_, d_, c_, b_, a_ = [Delta[i] for i in range(5)]
I = 12 * a_ * e_ - 3 * b_ * d_ + c_^2
J = 72 * a_ * c_ * e_ + 9 * b_ * c_ * d_ - 27 * a_ * d_^2 - 27 * e_ * b_^2 - 2 * c_^3
j = 1728 * 4 * I^3 / (4 * I^3 - J^2)
print(' invariants of Delta: I = %s, J = %s' % (I, J))
print(' j = %s = %s' % (j, j.factor()))
print(' j^sigma = %s;  minimal polynomial of j: %s' % (j.galois_conjugate(), j.minpoly()))
E0 = EllipticCurve(K, [-27 * I, -27 * J])
E = E0.global_minimal_model()
print(' Jacobian (minimal model): y^2 + a1 xy + a3 y = x^3 + a2 x^2 + a4 x + a6, [a1,a2,a3,a4,a6] = %s' % list(E.a_invariants()))
print('   j(E) = j: %s' % (E.j_invariant() == j))
print('   conductor %s = %s,  norm %s' % (E.conductor(), E.conductor().factor(), E.conductor().norm().factor()))
print('   minimal discriminant: %s, norm %s' % (E.discriminant().factor(), E.minimal_discriminant_ideal().norm().factor()))
print('   torsion subgroup: %s' % (E.torsion_subgroup().invariants(),))
print('   CM: %s' % E.has_cm())
Es = EllipticCurve(K, [c.galois_conjugate() for c in E.a_invariants()])
print('   isomorphic to its conjugate: %s' % E.is_isomorphic(Es))
print('   traces a_P(E), a_P(E^sigma) at the primes of degree one (equal for all P iff E is isogenous to E^sigma):')
for p in prime_range(3, 60):
    for P in K.primes_above(p):
        if P.residue_class_degree() == 1:
            print('      p = %2d  P = (%s):  a_P(E) = %3d   a_P(E^sigma) = %3d'
                  % (p, P.gens_reduced()[0], P.norm() + 1 - E.reduction(P).cardinality(), P.norm() + 1 - Es.reduction(P).cardinality()))
print('   j modulo primes of K:')
for p in prime_range(3, 50):
    for P in K.primes_above(p):
        F = P.residue_field()
        print('      p = %2d  P = (%s), N(P) = %4d:  j = %s' % (p, P.gens_reduced()[0], P.norm(), F(j)))
print()

# the involution (t, v) -> (v, t): its fixed points
fix = Px(H(x, x).polynomial(t) if False else H.subs(v=t).polynomial(t).change_variable_name('x'))
print(' fixed points of the involution (t, v) -> (v, t): t = v, roots of %s' % fix.factor())
print('   real fixed points: %s' % [r.n(30) for r in fix.map_coefficients(emb[1], RF).roots(RF, multiplicities=False)])
print()

# the honest arc
print(' the honest arc (real branch through the packing):')
Pv.<V> = RF[]
Hs = {sg: H.map_coefficients(emb[sg], RF) for sg in (1, -1)}
def v_on(sg, tv):
    q = Pv(sum(c * tv^mm[0] * V^mm[1] for mm, c in Hs[sg].dict().items()))
    return q.roots(RF, multiplicities=False)
def branch(tv):
    rts = v_on(1, tv)
    return min(rts, key=lambda r: abs(r - (v0 + t0 - tv)))   # the arc runs from (t0, v0) to (v0, t0)
lo, hi = t0, v0
W0, circ0 = configuration(1, t0, v0)
print('   at t0: honest %s, W = %.6f, contacts beyond the pattern minus A3B2: %s'
      % (honest(W0, circ0), W0, [c for c in contacts(W0, circ0, 1e-40) if c == ('A3', 'B2')]))
W1, circ1 = configuration(1, v0, t0)
print('   at t1 = v0: honest %s, W = %.6f, A2 and B3 tangent: %s'
      % (honest(W1, circ1), W1, ('A2', 'B3') in contacts(W1, circ1, 1e-40)))
inside = all(honest(*configuration(1, tv, branch(tv))) for tv in [t0 + (v0 - t0) * i / 200 for i in range(1, 200)])
outside = [honest(*configuration(1, tv, branch(tv))) for tv in (t0 - RF(1e-3), v0 + RF(1e-3))]
print('   honest at 199 interior points of [t0, v0]: %s;  just outside the interval: %s' % (inside, outside))
tm = [r for r in fix.map_coefficients(emb[1], RF).roots(RF, multiplicities=False) if t0 < r < v0]
print('   symmetric member: t = v = %s' % [r.n(30) for r in tm])
Wm, circm = configuration(1, tm[0], tm[0])
print('   there: W - 2 = %.1e;  radii %s' % (Wm - 2, ', '.join('%s %.6f' % (nm, rr) for nm, x, y, rr in circm)))
print('   A2, B2 touch the line x = 1: %s' % all(abs(x + rr - 1) < 1e-60 for nm, x, y, rr in circm if nm in ('A2', 'B2')))
aL_, bL_, XL_, YL_ = chain(path[:3], t)
mir = [(k + 1 - i, k + 1 - j) for i, j in reversed(path)]
aR_, bR_, XR_, YR_ = chain(mir[:3], v)
Wt_ = XR_[2] + XL_[2] + 2 * aL_[2] * aR_[2]
Wd = Wt_.numerator().subs(v=t) / Wt_.denominator().subs(v=t)
print('   W on the diagonal t = v: %s' % Wd.factor())
print()

# the conjugate curve
print(' the conjugate curve H^sigma (s -> -s):')
for sg in (1, -1):
    rts = f.map_coefficients(emb[sg], RF).roots(RF, multiplicities=False)
    print('   real roots of f%s: %s' % ('' if sg == 1 else '^sigma', [r.n(20) for r in rts]))
cnt = {1: [0, 0], -1: [0, 0]}
for sg in (1, -1):
    for i in range(-4000, 4001):
        tv = RF(i) / 1000
        for vv in v_on(sg, tv):
            try:
                W, circ = configuration(sg, tv, vv)
            except ZeroDivisionError:
                continue
            cnt[sg][0] += 1
            cnt[sg][1] += honest(W, circ)
print('   real points sampled with -4 <= t <= 4 (step 1/1000): H %d, of which honest %d;  H^sigma %d, of which honest %d'
      % (cnt[1][0], cnt[1][1], cnt[-1][0], cnt[-1][1]))
for r in f.map_coefficients(emb[-1], RF).roots(RF, multiplicities=False)[1:2]:
    vv = chain_num(path, r, -1)[0][k]
    W, circ = configuration(-1, r, vv)
    print('   a conjugate packing, t = %.6f: Phi^sigma = %.1e, W = %.4f' % (r, abs(ev(Phi, -1, r, vv)), W))
    for nm, x, y, rr in circ:
        print('      %s: x = %9.4f  y = %8.4f  r = %8.4f' % (nm, x, y, rr))

# ---------------------------------------------------------------------
# 3. figure data
# ---------------------------------------------------------------------
def jcirc(W, circ):
    return {'W': float(W), 'circles': [{'label': nm, 'x': float(x), 'y': float(y), 'r': float(r)} for nm, x, y, r in circ]}
members = []
for lam in (0, 1/4, 1/2, 3/4, 1):
    tv = t0 + (v0 - t0) * RF(lam)
    vv = v0 if lam == 0 else (t0 if lam == 1 else branch(tv))
    if lam == 1/2:
        tv = vv = tm[0]
    d = jcirc(*configuration(1, tv, vv)); d['t'] = float(tv); d['v'] = float(vv)
    members.append(d)
locus = {}
for sg in (1, -1):
    pts = []
    for i in range(-1500, 2501):
        tv = RF(i) / 1000
        for vv in v_on(sg, tv):
            if -1.5 <= vv <= 2.5:
                pts.append([float(tv), float(vv)])
    locus['plus' if sg == 1 else 'minus'] = pts
cpk = f.map_coefficients(emb[-1], RF).roots(RF, multiplicities=False)
conj = []
for r in cpk:
    W, circ = configuration(-1, r, chain_num(path, r, -1)[0][k])
    d = jcirc(W, circ); d['t'] = float(r); conj.append(d)
json.dump({'members': members, 'locus': locus, 'conjugate_packings': conj,
           'packing': [float(t0), float(v0)], 'fixed': [float(r) for r in fix.map_coefficients(emb[1], RF).roots(RF, multiplicities=False)]},
          open('circle-genus.json', 'w'), indent=1)
print()
print(' figure data written to circle-genus.json')

# bad primes of the model w^2 = Delta(t)
dD = Delta.discriminant()
print()
print(' discriminant of Delta: %s, norm %s' % (dD.factor(), dD.norm().factor()))
print(' leading coefficient of Delta: %s, norm %s' % (Delta.lc(), Delta.lc().norm().factor()))
