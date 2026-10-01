# =====================================================================
# circle-monodromy.sage -- the realization curve of a zigzag with one
# tangency dropped, and the half-angle cover (circle-monodromy.typ).
#
#     cd kummer
#     sage circle-monodromy.sage > ../results/circle-monodromy.txt
#
# Notation of circle-degrees-growth.sage: height 1, a_i = sqrt(r(A_i)),
# b_j = sqrt(r(B_j)) (signed), X_i, Y_j the x-coordinates of the centres,
# K = Q(sqrt 2).
#
# Dropping a tangency.  Let e = (i0, j0) be an edge of the lattice path at
# a turn: the step into e adds A_{i0} and the step out of it adds
# B_{j0+1} (an "AB turn"), or the other way round.  Without the tangency
# A_{i0} B_{j0} the configuration falls apart into
#   - a left chain, the circles of the edges before e, built by the
#     recursion from t = a_1 (b_1 = 1 - t, both on the left wall), and
#   - a right chain, the circles of the edges after e, built by the same
#     recursion read from the right wall, from v = a_k (b_k = 1 - v),
#     in the coordinate x' = W - x,
# glued by the two row tangencies across the cut.  Both contain the width
# W linearly; eliminating it leaves one equation Phi(t, v) = 0: the
# realization curve C of the pattern minus the tangency A_{i0} B_{j0}.
#
# On C, delta = the inversive distance of A_{i0} and B_{j0} (1 = external
# tangency, cos(angle) when they cross), and the half-angle function
#     u^2 = (delta + 1) / 2 = (D^2 + (1 - 2a^2)(1 - 2b^2)) / (4 a^2 b^2),
# D the horizontal distance of the centres, a, b the signed square roots
# of the two radii.  The packing is the fibre u = -1 (or +1, depending on
# the signs) of u on the component of C through the packing.
# =====================================================================
import json, sys, time
from collections import Counter

ARGS = sys.argv[1:]
sys.argv = sys.argv[:1]          # circle-degrees-growth.sage reads sys.argv
_NO_MAIN = True
load('circle-degrees-growth.sage')

R2.<t, v> = K[]
RF = RealField(300)
embR = [e for e in K.embeddings(RF) if e(K.gen()) > 0][0]


def univ_recursion(path, var):
    """recursion() of circle-degrees-growth.sage for a prefix of a path, in
    the variable var of R2.  Returns dicts a, b, X, Y of elements of
    Frac(R2)."""
    FF2 = R2.fraction_field()
    a = {1: FF2(var)}; b = {1: FF2(1 - var)}; X = {1: FF2(var^2)}; Y = {1: FF2((1 - var)^2)}
    for (i, j), (i2, j2) in zip(path, path[1:]):
        if i2 == i + 1:
            a[i2] = a[i] / (Y[j] - X[i] + s * b[j]); X[i2] = X[i] + 2 * a[i] * a[i2]
        else:
            b[j2] = b[j] / (X[i] - Y[j] + s * a[i]); Y[j2] = Y[j] + 2 * b[j] * b[j2]
    return a, b, X, Y


def family(k, path, n0):
    """Left and right chains for the pattern minus the edge path[n0]."""
    i0, j0 = path[n0]
    prev, nxt = path[n0 - 1], path[n0 + 1]
    ab_turn = prev == (i0 - 1, j0) and nxt == (i0, j0 + 1)
    ba_turn = prev == (i0, j0 - 1) and nxt == (i0 + 1, j0)
    assert ab_turn or ba_turn, 'the dropped edge must be at a turn'
    left = univ_recursion(path[:n0], t)
    mirrored = [(k + 1 - i, k + 1 - j) for i, j in reversed(path)]
    m0 = len(path) - 1 - n0                      # index of the dropped edge in the mirrored path
    right = univ_recursion(mirrored[:m0], v)
    return left, right, (i0, j0), ab_turn


def glue(k, path, n0):
    """Phi(t, v), and D, a, b for the pair A_{i0}, B_{j0}, as elements of Frac(R2)."""
    (aL, bL, XL, YL), (aR, bR, XR, YR), (i0, j0), ab_turn = family(k, path, n0)
    m = lambda i: k + 1 - i                      # label in the mirrored chain
    if ab_turn:
        # A_{i0} is in the right chain, B_{j0} in the left chain.
        #   A_{i0-1} -- A_{i0}:  (W - X'_{A_{i0}}) - X_{A_{i0-1}} = 2 a_{i0-1} a_{i0}
        #   B_{j0} -- B_{j0+1}:  (W - Y'_{B_{j0+1}}) - Y_{B_{j0}} = 2 b_{j0} b_{j0+1}
        aA, XA_r = aR[m(i0)], XR[m(i0)]
        aP, XP = aL[i0 - 1], XL[i0 - 1]
        bB, YB = bL[j0], YL[j0]
        bN, YN_r = bR[m(j0 + 1)], YR[m(j0 + 1)]
        Phi = (-XA_r - XP - 2 * aP * aA) - (-YN_r - YB - 2 * bB * bN)
        W = XA_r + XP + 2 * aP * aA
        D = (W - XA_r) - YB
        return Phi, D, aA, bB
    else:
        aA, XA = aL[i0], XL[i0]
        bB, YB_r = bR[m(j0)], YR[m(j0)]
        bP, YP = bL[j0 - 1], YL[j0 - 1]
        aN, XN_r = aR[m(i0 + 1)], XR[m(i0 + 1)]
        Phi = (-YB_r - YP - 2 * bP * bB) - (-XN_r - XA - 2 * aA * aN)
        W = YB_r + YP + 2 * bP * bB
        D = XA - (W - YB_r)
        return Phi, D, aA, bB


def ev(fn, tv, vv):
    num, den = fn.numerator(), fn.denominator()
    e = lambda p: sum(embR(c) * tv^m[0] * vv^m[1] for m, c in p.dict().items())
    return e(num) / e(den)


def analyse(k, path, n0, label):
    T0 = time.time()
    print('=' * 72)
    print(' %s: pattern %s, dropping the tangency %s' % (label, ' '.join('%d%d' % e for e in path), path[n0]))
    print('=' * 72)
    f, root, num, (a, b, X, Y) = find_factor(k, path)
    t_h = root
    v_h = evaluate(a[k], root)                   # honest sqrt r(A_k)
    print('honest packing: t = %s, v = %s, m = [F : K] = %d' % (str(t_h)[:12], str(v_h)[:12], f.degree()))
    Phi, D, aA, bB = glue(k, path, n0)
    print('honest point on Phi = 0: |Phi| = %.1e' % abs(ev(Phi, t_h, v_h)))
    N = Phi.numerator()
    comps = [(g, e) for g, e in N.factor()]
    H = [g for g, e in comps if abs(sum(embR(c) * t_h^m[0] * v_h^m[1] for m, c in g.dict().items())) < 1e-50]
    assert len(H) == 1
    H = H[0]
    print('components of Phi = 0 (deg_t, deg_v):', [(g.degree(t), g.degree(v)) for g, e in comps])
    print('component through the packing: deg_t %d, deg_v %d   (%.0fs)' % (H.degree(t), H.degree(v), time.time() - T0))
    out = {'label': label, 'path': path, 'n0': n0, 'm': f.degree(), 'H_degrees': [H.degree(t), H.degree(v)]}
    if H.degree(v) != 1:
        print('the component is not a graph over the t-line; stopping here')
        return out, None
    # v as a rational function of t on the component
    c1 = H.coefficient({v: 1}).polynomial(t) if False else None
    P1.<x> = K[]
    A0 = P1(sum(c * x^m[0] for m, c in H.dict().items() if m[1] == 0))
    A1 = P1(sum(c * x^m[0] for m, c in H.dict().items() if m[1] == 1))
    Fx = P1.fraction_field()
    vt = -A0 / A1
    sub = lambda fn: (fn.numerator()(x, vt) / fn.denominator()(x, vt))
    u2 = sub((D^2 + (1 - 2 * aA^2) * (1 - 2 * bB^2)) / (4 * aA^2 * bB^2))
    delta = 2 * u2 - 1
    n_, d_ = u2.numerator(), u2.denominator()
    sq = (n_ * d_).is_square()
    print('delta = 2u^2 - 1 is a rational function of t of degree %d; u^2 is a square in K(t): %s'
          % (max(delta.numerator().degree(), delta.denominator().degree()), sq))
    if not sq:
        return out, None
    u = Fx((n_ * d_).sqrt()) / d_
    # orientation: u = -1 at the packing
    if abs(sum(embR(c) * t_h^i for i, c in enumerate(u.numerator().list())) / sum(embR(c) * t_h^i for i, c in enumerate(u.denominator().list())) + 1) > 1e-30:
        u = -u
    un, ud = u.numerator(), u.denominator()
    degu = max(un.degree(), ud.degree())
    print('u = %s' % u if degu <= 4 else 'u: a rational function of t of degree %d' % degu)
    fib_m = (un + ud).factor()
    fib_p = (un - ud).factor()
    print('fibre u = -1 (the packing): %s' % [(g.degree(), e) for g, e in fib_m])
    print('fibre u = +1 (the other tangency): %s' % [(g.degree(), e) for g, e in fib_p])
    fh = [g for g, e in fib_m if abs(g.map_coefficients(embR, RF)(t_h)) < 1e-50][0]
    print('the honest factor of u = -1 is f itself: %s' % (fh.monic() == f.change_variable_name('x').change_ring(K).monic()))
    # monodromy of u: Frobenius cycle types of u = c for a few c
    crit = un.derivative() * ud - un * ud.derivative()
    print('critical points of u: %s' % [(g.degree(), e) for g, e in crit.factor()])
    for c in (QQ(3), QQ(-5), QQ(7) / 3):
        g = un - c * ud
        types = Counter(); used = 0; p = 2
        while used < 300:
            p = next_prime(p)
            if p % 8 not in (1, 7):
                continue
            r = GF(p)(2).sqrt()
            try:
                gp = GF(p)['z']([GF(p)(cc[0]) + GF(p)(cc[1]) * r for cc in g.list()])
            except ZeroDivisionError:
                continue
            if gp.degree() != g.degree() or not gp.is_squarefree():
                continue
            used += 1
            types[tuple(sorted((q.degree() for q, _ in gp.factor()), reverse=True))] += 1
        n = g.degree()
        full = (n,) in types and (n - 1, 1) in types and any(ct.count(2) == 1 and ct.count(1) == n - 2 for ct in types)
        print('   u = %s: irreducible over K %s; contains an n-cycle, an (n-1)-cycle and a transposition: %s'
              % (c, g.is_irreducible(), full))
    # discriminant of the fibre u = -1 = product over critical points of (u(c) + 1)
    print('ramification of F against the critical points of u:')
    print('   disc f has norm %s' % factor(f.discriminant().norm()))
    rows = []
    for g, e in crit.factor():
        Rs = f.change_variable_name('x').change_ring(K).resultant(g)
        nm = Rs.norm()
        crit_vals = []
        for rt in g.map_coefficients(embR, RF.complex_field()).roots(multiplicities=False):
            uv = (un.map_coefficients(embR, RF.complex_field())(rt) / ud.map_coefficients(embR, RF.complex_field())(rt))
            crit_vals.append((rt, uv))
        print('   critical point %-40s N Res(f, .) = %-14s  critical values u = %s'
              % (g if g.degree() <= 2 else 'of degree %d' % g.degree(), factor(nm) if nm != 0 else 0,
                 ', '.join('%.4f%+.4fi' % (cv.real(), cv.imag()) for _, cv in crit_vals)))
        rows.append((g, crit_vals, nm))
    out.update({'u_degree': degu})
    print('(%.0fs)' % (time.time() - T0))
    return out, (u, vt, D, aA, bB, rows, f)





def chains_membership(path, n0):
    """Which circles belong to the left chain (edges before path[n0])."""
    leftA = set(i for i, j in path[:n0]); leftB = set(j for i, j in path[:n0])
    return leftA, leftB


def configuration(k, path, n0, tv, vv):
    """All circles (x, y, r, label, signed sqrt) and W at the point (t, v)."""
    (aL, bL, XL, YL), (aR, bR, XR, YR), (i0, j0), ab_turn = family(k, path, n0)
    ev1 = lambda fn: ev(fn, tv, vv)
    if ab_turn:
        W = ev1(XR[k + 1 - i0] + XL[i0 - 1] + 2 * aL[i0 - 1] * aR[k + 1 - i0])
    else:
        W = ev1(YR[k + 1 - j0] + YL[j0 - 1] + 2 * bL[j0 - 1] * bR[k + 1 - j0])
    leftA, leftB = chains_membership(path, n0)
    out = []
    for i in range(1, k + 1):
        if i in leftA:
            a_, x_ = ev1(aL[i]), ev1(XL[i])
        else:
            a_, x_ = ev1(aR[k + 1 - i]), W - ev1(XR[k + 1 - i])
        out.append({'x': float(x_), 'y': float(1 - a_^2), 'r': float(a_^2), 'label': 'A%d' % i, 'row': 'top', 'sqrt': float(a_)})
    for j in range(1, k + 1):
        if j in leftB:
            b_, y_ = ev1(bL[j]), ev1(YL[j])
        else:
            b_, y_ = ev1(bR[k + 1 - j]), W - ev1(YR[k + 1 - j])
        out.append({'x': float(y_), 'y': float(b_^2), 'r': float(b_^2), 'label': 'B%d' % j, 'row': 'bottom', 'sqrt': float(b_)})
    return out, float(W)


def special_points(u):
    """K-rational poles and critical points of u, and oo."""
    un, ud = u.numerator(), u.denominator()
    crit = un.derivative() * ud - un * ud.derivative()
    pts = set()
    for g, e in (crit * ud).factor():
        if g.degree() == 1:
            pts.add(-g[0] / g[1])
    return list(pts) + ['oo']


def to_matrix(p1, p2, p3):
    """2x2 matrix of the Mobius map sending p1, p2, p3 to 0, oo, 1."""
    if p1 == 'oo':
        return matrix(K, [[0, p3 - p2], [1, -p2]])
    if p2 == 'oo':
        return matrix(K, [[1, -p1], [0, p3 - p1]])
    if p3 == 'oo':
        return matrix(K, [[1, -p1], [1, -p2]])
    return matrix(K, [[p3 - p2, -p1 * (p3 - p2)], [p3 - p1, -p2 * (p3 - p1)]])


def compose(u, M):
    """u o mu, mu(x) = (M00 x + M01) / (M10 x + M11)."""
    Fx = u.parent(); x = Fx.gen()
    mu = (M[0, 0] * x + M[0, 1]) / (M[1, 0] * x + M[1, 1])
    return u.numerator()(mu) / u.denominator()(mu)


def mobius_equivalent(u1, u2):
    """Find mu with u1 o mu = u2, mapping special points to special points."""
    import itertools
    S1, S2 = special_points(u1), special_points(u2)
    for q in itertools.permutations(S2, int(3)):
        Mq = to_matrix(*q)
        for p in itertools.permutations(S1, int(3)):
            mu = to_matrix(*p).inverse() * Mq           # sends q_i to p_i
            if compose(u1, mu) == u2:
                return mu
    return None


def half_angle(k, path, n0):
    """u(t) on the component through the packing (None if not a graph over t)."""
    f, root, num, (a, b, X, Y) = find_factor(k, path)
    v_h = evaluate(a[k], root)
    Phi, D, aA, bB = glue(k, path, n0)
    N = Phi.numerator()
    H = [g for g, e in N.factor() if abs(sum(embR(c) * root^m[0] * v_h^m[1] for m, c in g.dict().items())) < 1e-50][0]
    if H.degree(v) != 1:
        return None, f, root
    P1.<x> = K[]
    A0 = P1(sum(c * x^m[0] for m, c in H.dict().items() if m[1] == 0))
    A1 = P1(sum(c * x^m[0] for m, c in H.dict().items() if m[1] == 1))
    vt = -A0 / A1
    sub = lambda fn: (fn.numerator()(x, vt) / fn.denominator()(x, vt))
    u2 = sub((D^2 + (1 - 2 * aA^2) * (1 - 2 * bB^2)) / (4 * aA^2 * bB^2))
    n_, d_ = u2.numerator(), u2.denominator()
    if not (n_ * d_).is_square():
        return None, f, root
    u = P1.fraction_field()((n_ * d_).sqrt()) / d_
    val = u.numerator().map_coefficients(embR, RF)(root) / u.denominator().map_coefficients(embR, RF)(root)
    if abs(val + 1) > 1e-30:
        u = -u
    return (u, vt), f, root


# =====================================================================
SIX = [(1, 1), (1, 2), (2, 2), (2, 3), (3, 3)]
out, data = analyse(3, SIX, 2, 'six circles')
u, vt, D, aA, bB, rows, f = data

# ---- figure data for circle-monodromy.typ ----------------------------
x = u.numerator().parent().gen()
evu = lambda tv: float(u.numerator().map_coefficients(embR, RF)(tv) / u.denominator().map_coefficients(embR, RF)(tv))
evv = lambda tv: vt.numerator().map_coefficients(embR, RF)(tv) / vt.denominator().map_coefficients(embR, RF)(tv)
figs = {}
def snapshot(name, tv):
    tv = RF(tv)
    cs, W = configuration(3, SIX, 2, tv, evv(tv))
    figs[name] = {'t': float(tv), 'u': evu(tv), 'W': W, 'circles': cs}
# honest packing and a few points of the family on either side
t_h = [r for r in f.change_ring(K).map_coefficients(embR, RF).roots(RF, multiplicities=False) if 0 < r < 1][0]
snapshot('packing', t_h)
for tv in (0.50, 0.53, 0.57, 0.60):
    snapshot('t=%.2f' % tv, tv)
# (the other tangent fibre u = +1, t = 1 - sqrt2/2, is degenerate: B is a line)
# the critical points of u
for g, crit_vals, nm in rows:
    for rt, cv in crit_vals:
        if abs(rt.imag()) < 1e-30 and abs(cv.real()) < 1e10 and abs(cv.real() - 1) > 1e-6:
            snapshot('critical t=%.4f' % rt.real(), rt.real())
# the graph of u over the real t-line
graph = []
for i in range(-300, 701):
    tv = RF(i) / 200
    try:
        val = evu(tv)
        if abs(val) < 40:
            graph.append((float(tv), val))
        else:
            graph.append((float(tv), None))
    except ZeroDivisionError:
        graph.append((float(tv), None))
figs['graph'] = graph
figs['u'] = str(u)
figs['critical'] = [{'poly': str(g), 'points': [[float(rt.real()), float(rt.imag())] for rt, cv in cr],
                     'values': [[float(cv.real()), float(cv.imag())] if cv.real() == cv.real() else None for rt, cv in cr],
                     'norm_res': str(factor(nm)) if nm != 0 else '0'} for g, cr, nm in rows]

if 'more' in ARGS:
    print()
    print('=' * 72)
    print(' Different patterns, isomorphic fields: are the half-angle covers the same?')
    print('=' * 72)
    pairs = [((3, [(1,1),(2,1),(3,1),(3,2),(3,3)], 2), (3, [(1,1),(2,1),(2,2),(2,3),(3,3)], 1)),
             ((4, [(1,1),(1,2),(2,2),(3,2),(3,3),(3,4),(4,4)], 3), (4, [(1,1),(1,2),(1,3),(1,4),(2,4),(3,4),(4,4)], 3))]
    for (k1, p1, n1), (k2, p2, n2) in pairs:
        (U1, f1, r1) = half_angle(k1, p1, n1)
        (U2, f2, r2_) = half_angle(k2, p2, n2)
        print('%s (dropping %s)  vs  %s (dropping %s):' % (' '.join('%d%d' % e for e in p1), p1[n1], ' '.join('%d%d' % e for e in p2), p2[n2]))
        if U1 is None or U2 is None:
            print('   one of the components is not a graph over the t-line')
            continue
        u1, u2 = U1[0], U2[0]
        print('   degrees of u: %d, %d' % (max(u1.numerator().degree(), u1.denominator().degree()),
                                         max(u2.numerator().degree(), u2.denominator().degree())))
        mu = mobius_equivalent(u1, u2)
        print('   u2 = u1 o mu for a Mobius map mu over K: %s' % ('mu = %s' % list(mu) if mu is not None else 'no'))
        if mu is not None:
            # where does mu send the honest t of the second packing?
            t2 = r2_
            M = mu.apply_map(embR)
            img = (M[0, 0] * t2 + M[0, 1]) / (M[1, 0] * t2 + M[1, 1])
            print('   mu(t of the second packing) = %s;  t of the first packing = %s' % (str(img)[:12], str(r1)[:12]))

    print()
    print('=' * 72)
    print(' The exceptional zigzag (k = 6) in the same picture')
    print('=' * 72)
    EXC = [(1,1),(1,2),(1,3),(1,4),(2,4),(3,4),(4,4),(5,4),(5,5),(5,6),(6,6)]
    T0 = time.time()
    U, fE, rE = half_angle(6, EXC, 9)
    if U is None:
        print('component through the packing is not a graph over the t-line')
    else:
        uE = U[0]
        n = max(uE.numerator().degree(), uE.denominator().degree())
        print("dropping %s: u has degree %d = m (%.0fs)" % (EXC[9], n, time.time() - T0))
        g = uE.numerator() - 3 * uE.denominator()
        print('generic fibre u = 3 irreducible over K: %s' % g.is_irreducible())
        fib = (uE.numerator() + uE.denominator()).factor()
        print('fibre u = -1: %s; contains f: %s' % ([(h.degree(), e) for h, e in fib],
              any(h.monic() == fE.change_variable_name('x').change_ring(K).monic() for h, e in fib)))
        # the involution t -> -a_5(t) on the t-line: does it preserve u?
        a, b, X, Y = recursion(6, EXC)
        Pk = uE.numerator().parent()
        num5 = Pk(a[5].numerator().list()); den5 = Pk(a[5].denominator().list())
        tau = -num5 / den5
        print('the involution t -> -a_5(t) is a rational map of degree %d; u(tau(t)) = u(t) identically: %s'
              % (max(num5.degree(), den5.degree()), uE.numerator()(tau) / uE.denominator()(tau) == uE))
        print('generic fibre u = 3: Galois certificate (n-cycle, (n-1)-cycle, Jordan prime, from Frobenius):')
        types = Counter(); used = 0; p = 2
        while used < 2000:
            p = next_prime(p)
            if p % 8 not in (1, 7): continue
            r = GF(p)(2).sqrt()
            try:
                gp = GF(p)['z']([GF(p)(cc[0]) + GF(p)(cc[1]) * r for cc in g.list()])
            except ZeroDivisionError:
                continue
            if gp.degree() != g.degree() or not gp.is_squarefree(): continue
            used += 1
            types[tuple(sorted((q.degree() for q, _ in gp.factor()), reverse=True))] += 1
        jordan = any(any(q in (2, 3) or q <= n - 3 for q in prime_divisors(prod(ct)) if [c % q == 0 for c in ct].count(True) == 1 and q in ct) for ct in types)
        print('   n-cycle %s, (n-1)-cycle %s, Jordan prime %s  =>  monodromy S_%d: %s'
              % ((n,) in types, (n - 1, 1) in types, jordan, n, (n,) in types and (n - 1, 1) in types and jordan))

with open('circle-monodromy.json', 'w') as fh:
    json.dump(figs, fh, indent=1)
print()
print('figure data written to circle-monodromy.json')
