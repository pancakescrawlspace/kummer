# =====================================================================
# circle-degrees.sage -- algebraic degrees for the two-row zigzag
# packings of circle-packings.typ (section 3).
#
#     cd kummer
#     sage circle-degrees.sage > ../results/circle-degrees.txt
#
# Unknowns: a_i = sqrt(r(A_i)), b_j = sqrt(r(B_j)), height 1.  With
# square roots of radii the tangencies inside a row are linear in the
# horizontal positions (contact points 2 sqrt(r r') apart), so
#
#     x(A_i) = a_1^2 + 2 (a_1 a_2 + ... + a_{i-1} a_i),   same for B,
#     W = x(A_k) + a_k^2 = x(B_k) + b_k^2,
#     a_1 + b_1 = 1, a_k + b_k = 1        (end circles stacked on a side),
#     (x(A_i) - x(B_j))^2 = 2 (a_i^2 + b_j^2) - 1   for the other cross
#                                          tangencies A_i B_j.
#
# That is 2k equations in 2k unknowns.
#
# Two methods.
#
#  (exact, k <= 3)  The ideal is zero-dimensional; the characteristic
#    polynomial of multiplication by f on Q[a,b]/I is the product of
#    (T - f(P)) over its points P, and the irreducible factor vanishing
#    at the real packing is the minimal polynomial of f there.  For k = 4
#    some ideals have spurious positive-dimensional components
#    (degenerate circles of radius 0) and the Groebner computations
#    needed to remove them did not finish in reasonable time.
#
#  (numerical, all k)  Newton's method to DIGITS digits from the
#    double-precision packing in circle-packings.json, then PARI's algdep
#    (LLL) for degree bounds 8, 16, 32, 64; the irreducible factor of the
#    result vanishing at the value is the candidate minimal polynomial.
#    It is accepted only if it vanishes to within 10^(-0.9 DIGITS) and
#    (deg + 1) log10(height) < DIGITS / 4, so that a spurious relation of
#    that size would be a coincidence of probability about 10^(-DIGITS/2);
#    and it is then rechecked at 2 DIGITS digits.  For k <= 3 the two
#    methods are compared.
#
# A random Q-combination of the coordinates generates the field they
# generate, so its degree is [Q(radii, centres, W) : Q]; the same with
# the square roots of the radii gives [Q(sqrt radii, ...) : Q].
# =====================================================================
import json, random, time

data = json.load(open('circle-packings.json'))
RF = RealField(200)
random.seed(int(1))


def system(k, path):
    R = PolynomialRing(QQ, ['a%d' % i for i in range(1, k + 1)]
                       + ['b%d' % j for j in range(1, k + 1)], order='degrevlex')
    g = R.gens()
    a, b = g[:k], g[k:]
    XA, XB = [a[0]^2], [b[0]^2]
    for i in range(k - 1):
        XA.append(XA[-1] + 2 * a[i] * a[i + 1])
        XB.append(XB[-1] + 2 * b[i] * b[i + 1])
    W = XA[-1] + a[-1]^2
    eqs = [a[0] + b[0] - 1, a[-1] + b[-1] - 1, W - (XB[-1] + b[-1]^2)]
    for (i, j) in path:
        if (i, j) not in ((1, 1), (k, k)):
            eqs.append((XA[i - 1] - XB[j - 1])^2 - 2 * (a[i - 1]^2 + b[j - 1]^2) + 1)
    return R, a, b, XA, XB, W, eqs


def refine(R, eqs, point, digits=150):
    """Newton in high precision from the double-precision packing."""
    Jm = jacobian(vector(eqs), R.gens())
    K = RealField(int(digits * 3.33))
    z = vector(K, point)
    for _ in range(60):
        Fz = vector(K, [e(*z) for e in eqs])
        Jz = matrix(K, [[e(*z) for e in row] for row in Jm.rows()])
        d = Jz.solve_right(-Fz)
        z += d
        if max(abs(t) for t in d) < K(10)^(-digits):
            break
    return z


def minpoly_at(I, B, f, val):
    """Irreducible factor of charpoly(mult by f) vanishing at val."""
    G = I.groebner_basis()
    pos = {m: n for n, m in enumerate(B)}
    M = matrix(QQ, len(B), len(B))
    for c, m in enumerate(B):
        red = (f * m).reduce(G)
        for coeff, mon in zip(red.coefficients(), red.monomials()):
            M[pos[mon], c] = coeff
    chi = M.charpoly('T')
    best = min((fac for fac, _ in chi.factor()),
               key=lambda fac: abs(fac(val)) / max(1, abs(fac.derivative()(val))))
    return best



DIGITS = 3000


def numeric_minpoly(val, digits=DIGITS):
    pv = pari(val)
    for d in (8, 16, 32, 64):
        p = pari.algdep(pv, d)
        best = None
        for fac in p.factor()[0]:
            if fac.poldegree() < 1:
                continue
            r = abs(fac(pv))
            if best is None or r < best[0]:
                best = (r, fac)
        r, fac = best
        height = max(abs(c) for c in fac.Vec())
        if r < pari(10)**(-0.9 * digits) and (fac.poldegree() + 1) * float(log(RR(height) + 1, 10)) < digits / 4:
            return QQ['T'](str(fac).replace('x', 'T'))
    return None


def values(R, a, b, XA, XB, W, eqs, rec, digits):
    z = refine(R, eqs, [sqrt(RF(c['r'])) for c in rec['circles']], digits=digits)
    return z, dict(zip(R.gens(), z))


print('two-row zigzags, height 1: algebraic degrees')
print('deg W = degree of the aspect ratio; deg F = [Q(radii, centres, W) : Q];')
print('deg F(sqrt) = the same with the square roots of the radii adjoined.')
print()
summary = {}
for k in (2, 3, 4):
    print('k = %d' % k)
    for rec in data['zigzag'][str(k)]:
        path = [tuple(e) for e in rec['path']]
        t0 = time.time()
        R, a, b, XA, XB, W, eqs = system(k, path)
        coords = [v^2 for v in R.gens()] + XA + XB + [W]
        f = sum(random.randint(int(-9), int(9)) * c for c in coords)
        g = sum(random.randint(int(-9), int(9)) * v for v in R.gens())
        z, at = values(R, a, b, XA, XB, W, eqs, rec, DIGITS)
        z2, at2 = values(R, a, b, XA, XB, W, eqs, rec, 2 * DIGITS)
        res = []
        for h in (W, f, g):
            m = numeric_minpoly(h.subs(at))
            assert m is not None, (path, h)
            assert abs(m(h.subs(at2))) < RealField(2 * 3330)(10)^(-int(1.8 * DIGITS)), 'recheck failed'
            res.append(m)
        mW, mF, mS = res
        if k <= 3:                      # exact cross-check
            I = R.ideal(eqs)
            B = I.normal_basis()
            for h, m in ((W, mW), (f, mF), (g, mS)):
                assert minpoly_at(I, B, h, h.subs(at)) == m(R.base_ring()['T'].gen()) or \
                    minpoly_at(I, B, h, h.subs(at)).monic() == m.monic(), 'exact and numerical disagree'
        # exact certificate: write every unknown as a polynomial in theta = g
        # (found by lindep), check all equations exactly in K = Q(theta),
        # and recompute the minimal polynomials of W and f inside K
        D = mS.degree()
        K = NumberField(mS.monic(), 't')
        th = g.subs(at)
        exact = []
        for v in R.gens():
            rel = pari.lindep([pari(v.subs(at))] + [pari(th)^m for m in range(D)])
            rel = [QQ(c) for c in rel]
            assert rel[0] != 0
            exact.append(-sum(c * K.gen()^m for m, c in enumerate(rel[1:])) / rel[0])
        assert all(e(*exact) == 0 for e in eqs), 'exact check failed'
        assert g(*exact) == K.gen()
        assert W(*exact).minpoly('T') == mW.monic() and f(*exact).minpoly('T') == mF.monic()
        disc = K.discriminant()
        try:
            gal = str(pari(mS.monic().change_variable_name('x')).polgalois()[3])
        except Exception:
            gal = '?'
        summary[(k, tuple(path))] = (mW, mF, mS, disc, gal, RF(W.subs(at)))
        print('  %-28s deg W %3d   deg F %3d   deg F(sqrt) %3d   W = %s   (%.0fs)'
              % (' '.join('%d%d' % e for e in path), mW.degree(), mF.degree(), mS.degree(),
                 str(RF(W.subs(at)))[:12], time.time() - t0))
        print('      W: %s' % mW.monic())
        print('      field: degree %d, disc %s, Galois group %s; exact check passed'
              % (D, factor(disc), gal))
    print()

# ---------------------------------------------------------------------
# summary by symmetry orbit (patterns with the same W), plus structure
# ---------------------------------------------------------------------
print('summary: one line per orbit of the symmetries of the rectangle')
print('(top <-> bottom, left <-> right, half-turn), which preserve W')
print()
orbits = {}
for (k, path), (mW, mF, mS, disc, gal, Wval) in summary.items():
    key = (k, mW.monic())
    orbits.setdefault(key, []).append((path, mS, disc, gal, Wval))
fields = []
for (k, mW), members in sorted(orbits.items(), key=lambda t: (t[0][0], t[0][1].degree())):
    path, mS, disc, gal, Wval = members[0]
    K = NumberField(mS.monic(), 't')
    fields.append((k, mW, K))
    print('  k = %d  %d pattern(s)  deg W = %d  field degree %d  disc %s  Galois %s  sqrt2 in field: %s'
          % (k, len(members), mW.degree(), K.degree(), factor(disc), gal, K(2).is_square()))
    print('      W = %s,  minpoly %s' % (str(Wval)[:10], mW))
    print('      patterns: %s' % ', '.join(' '.join('%d%d' % e for e in m[0]) for m in members))
print()
for i in range(len(fields)):
    for j in range(i + 1, len(fields)):
        Ki, Kj = fields[i][2], fields[j][2]
        if Ki.degree() == Kj.degree() and Ki.discriminant() == Kj.discriminant():
            print('  fields of W = %s and W = %s: same degree and discriminant; isomorphic: %s'
                  % (fields[i][1], fields[j][1], Ki.is_isomorphic(Kj)))
