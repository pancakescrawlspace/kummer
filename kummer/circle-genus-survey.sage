# =====================================================================
# circle-genus-survey.sage -- genus of the family obtained from every
# triangulated pattern with n circles by dropping one tangency
# (circle-genus.typ, section "Other tangencies and smaller patterns").
#
#     cd kummer
#     sage circle-genus-survey.sage N SHARD NSHARDS SECONDS
#
# (patterns with index = SHARD mod NSHARDS; SECONDS = time limit per case).
# Patterns from circle-graph-search.py (plantri).
#
# Coordinates: a circle touching the top or the bottom line gets (p, x)
# with r = p^2 and y = 1 - p^2 or y = p^2 (signed square root of the
# radius); any other circle gets (x, y, r).  Plus the width W.  Two
# circles on the same line that touch: x' - x = sigma * 2 p p', sigma the
# sign of x' - x at the packing.  Everything else is the plain tangency
# equation.  The packing is lifted with p = +sqrt(r).  The ideal over
# K = Q(sqrt 2) is saturated by the product of the p's and the interior
# radii, decomposed into minimal primes, and the prime through the lifted
# packing is kept.  Its image in the geometric coordinates (x, y, r, W)
# (add r = p^2, eliminate the p's) is the family of configurations; its
# geometric genus is computed by Singular.
# =====================================================================
import sys, time, importlib.util
from cysignals.signals import AlarmInterrupt

spec = importlib.util.spec_from_file_location('cgs', 'circle-graph-search.py')
cgs = importlib.util.module_from_spec(spec)
spec.loader.exec_module(cgs)

RN = RealField(400)
KF.<s2> = QuadraticField(2)
embK = [e for e in KF.embeddings(RN) if e(s2) > 0][0]


def newton_geo(n, cc, walls, z0, digits=110):
    names = ['x%d' % i for i in range(n)] + ['y%d' % i for i in range(n)] + ['r%d' % i for i in range(n)] + ['W']
    R = PolynomialRing(QQ, names)
    g = R.gens(); x, y, r, W = g[:n], g[n:2 * n], g[2 * n:3 * n], g[3 * n]
    eqs = [(x[p] - x[q])^2 + (y[p] - y[q])^2 - (r[p] + r[q])^2 for p, q in cc]
    for p, sd in walls:
        eqs.append({'top': y[p] + r[p] - 1, 'bottom': y[p] - r[p], 'left': x[p] - r[p], 'right': W - x[p] - r[p]}[sd])
    F = RealField(int(digits * 3.33) + 20)
    J = jacobian(vector(eqs), g)
    z = vector(F, [F(c) for c in z0])
    for _ in range(60):
        Fz = vector(F, [e(*z) for e in eqs])
        Jz = matrix(F, [[e(*z) for e in row] for row in J.rows()])
        d = Jz.solve_right(-Fz)
        z += d
        if max(abs(c) for c in d) < F(10)^(-digits):
            break
    return z


def setup(n, cc, walls, zgeo, drop):
    cc2 = [e for e in cc if e != drop]
    walls2 = [w for w in walls if w != drop]
    touch = {i: set() for i in range(n)}
    for p, sd in walls2:
        touch[p].add(sd)
    kind = {i: 'T' if 'top' in touch[i] else ('B' if 'bottom' in touch[i] else 'I') for i in range(n)}
    names = []
    for i in range(n):
        names += (['p%d' % i, 'x%d' % i] if kind[i] != 'I' else ['x%d' % i, 'y%d' % i, 'r%d' % i])
    names.append('W')
    R = PolynomialRing(KF, names, order='degrevlex')
    V = dict(zip(names, R.gens()))
    X = {i: V['x%d' % i] for i in range(n)}
    Rad, Yc = {}, {}
    for i in range(n):
        if kind[i] == 'I':
            Rad[i] = V['r%d' % i]; Yc[i] = V['y%d' % i]
        else:
            Rad[i] = V['p%d' % i]^2
            Yc[i] = 1 - Rad[i] if kind[i] == 'T' else Rad[i]
    W = V['W']
    xs, ys, rs, Wn = zgeo[:n], zgeo[n:2 * n], zgeo[2 * n:3 * n], zgeo[3 * n]
    pt = {'W': Wn}
    for i in range(n):
        pt['x%d' % i] = xs[i]
        if kind[i] == 'I':
            pt['y%d' % i] = ys[i]; pt['r%d' % i] = rs[i]
        else:
            pt['p%d' % i] = sqrt(rs[i])
    point = [pt[nm] for nm in names]
    eqs = []
    for p, q in cc2:
        if kind[p] == kind[q] and kind[p] in 'TB':
            sg = 1 if xs[q] > xs[p] else -1
            eqs.append(X[q] - X[p] - sg * 2 * V['p%d' % p] * V['p%d' % q])
        else:
            eqs.append((X[p] - X[q])^2 + (Yc[p] - Yc[q])^2 - (Rad[p] + Rad[q])^2)
    for p, sd in walls2:
        if sd == 'top' and kind[p] != 'T':
            eqs.append(Yc[p] + Rad[p] - 1)
        elif sd == 'bottom' and kind[p] != 'B':
            eqs.append(Yc[p] - Rad[p])
        elif sd == 'left':
            eqs.append(X[p] - Rad[p])
        elif sd == 'right':
            eqs.append(W - X[p] - Rad[p])
    for p in range(n):
        if kind[p] == 'T' and 'bottom' in touch[p]:
            eqs.append(1 - 2 * Rad[p])
    sat = prod([V['p%d' % i] for i in range(n) if kind[i] != 'I'] + [V['r%d' % i] for i in range(n) if kind[i] == 'I'])
    return R, eqs, point, sat, kind


def vanishes(g, point):
    gg = g.map_coefficients(embK, RN)
    scale = max(abs(c) for c in gg.coefficients()) * max(1, max(abs(c) for c in point))^g.degree()
    return abs(gg(*point)) < scale * RN(10)^-80


def analyse(n, cc, walls, zgeo, drop):
    T0 = time.time()
    R, eqs, point, sat, kind = setup(n, cc, walls, zgeo, drop)
    J = R.ideal(eqs).saturation(R.ideal(sat))[0]
    primes = [P for P in J.minimal_associated_primes() if all(vanishes(g, point) for g in P.gens())]
    assert len(primes) == 1, len(primes)
    P = primes[0]
    out = {'dim': P.dimension()}
    if out['dim'] == 1:
        rho = ['r%d' % i for i in range(n) if kind[i] != 'I']
        S = PolynomialRing(KF, [str(v) for v in R.gens()] + rho, order='degrevlex')
        Pg = S.ideal([S(g) for g in P.gens()] + [S('r%d' % i) - S('p%d' % i)^2 for i in range(n) if kind[i] != 'I'])
        E = Pg.elimination_ideal([S('p%d' % i) for i in range(n) if kind[i] != 'I'])
        Sg = PolynomialRing(KF, [str(v) for v in R.gens() if not str(v).startswith('p')] + rho)
        out['genus'] = Curve([Sg(g) for g in E.gens()], AffineSpace(Sg)).genus()
    out['time'] = time.time() - T0
    return out


if __name__ == '__main__' or True:
    n = int(sys.argv[1]); shard, nshards = int(sys.argv[2]), int(sys.argv[3]); TLIM = int(sys.argv[4])
    for idx, (cc, walls, key) in enumerate(cgs.patterns(n)):
        if idx % nshards != shard:
            continue
        z = cgs.solve(n, cc, walls)
        if z is None:
            print('PATTERN n=%d %s no packing found' % (n, key), flush=True)
            continue
        zg = newton_geo(n, cc, walls, [RN(float(c)) for c in z])
        print('PATTERN n=%d %s W=%.6f cc=%s walls=%s' % (n, key, float(zg[3 * n]), cc, walls), flush=True)
        for drop in cc + walls:
            try:
                alarm(TLIM)
                o = analyse(n, cc, walls, zg, drop)
                cancel_alarm()
                print('  DROP %s dim %d genus %s  [%.1fs]' % (drop, o['dim'], o.get('genus'), o['time']), flush=True)
            except AlarmInterrupt:
                print('  DROP %s TIMEOUT' % (drop,), flush=True)
            except Exception as e:
                cancel_alarm()
                print('  DROP %s ERROR %s' % (drop, str(e)[:100]), flush=True)
