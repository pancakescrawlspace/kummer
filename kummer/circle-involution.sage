# =====================================================================
# circle-involution.sage -- the hidden involution of the two-row zigzag
# 11 12 13 14 24 34 44 54 55 56 66 (k = 6), section 6 of
# circle-packings.typ.
#
#     cd kummer
#     sage circle-involution.sage > ../results/circle-involution.txt
#
# Notation as in circle-degrees-growth.sage: a_i = sqrt(r(A_i)),
# b_j = sqrt(r(B_j)) (signed), X_i, Y_j the x-coordinates of the centres,
# t = a_1, K = Q(sqrt 2), F = K(t), f the irreducible factor over K of the
# final equation that vanishes at the packing.  The "core" is everything
# except the end circles B_1 and A_k.
#
#   (1) the involution: f has a second root t' in F, t' = -a_{k-1}; the
#       configuration at t' contains the honest core with its labels
#       reversed (A_i <-> A_{k-i}, B_j <-> B_{k+2-j}), plus two new end
#       circles;
#   (2) the end porism, as an identity of rational functions in t;
#   (3) the branch signs of the reversed configuration for every pattern
#       with a mirror-symmetric core, k <= 8, and the parity rule;
#   (4) the patterns predicted by the parity rule for k <= 10, checked
#       exactly for k <= 8 and, for k = 10, by factoring the final
#       equation and evaluating its factors at t and t' to 4000 bits;
#   (5) the fixed field of the involution is not the field of any
#       smaller zigzag.
# =====================================================================
import itertools, time, importlib.util
import numpy as np

_NO_MAIN = True
load('circle-degrees-growth.sage')

spec = importlib.util.spec_from_file_location('cgs', 'circle-graph-search.py')
cgs = importlib.util.module_from_spec(spec)
spec.loader.exec_module(cgs)

T0 = time.time()
EXC = [(1,1),(1,2),(1,3),(1,4),(2,4),(3,4),(4,4),(5,4),(5,5),(5,6),(6,6)]


def pstr(p):
    return ' '.join('%d%d' % e for e in p)


def num_run(k, path, t0, eps, R):
    """The recursion in floating point, with branch signs eps per step."""
    r2 = R(2).sqrt()
    a = {1: t0}; b = {1: 1 - t0}; X = {1: t0^2}; Y = {1: (1 - t0)^2}
    for n, ((i, j), (i2, j2)) in enumerate(zip(path, path[1:])):
        if i2 == i + 1:
            a[i2] = a[i] / (Y[j] - X[i] + eps[n] * r2 * b[j]); X[i2] = X[i] + 2 * a[i] * a[i2]
        else:
            b[j2] = b[j] / (X[i] - Y[j] + eps[n] * r2 * a[i]); Y[j2] = Y[j] + 2 * b[j] * b[j2]
    return a, b, X, Y


def final(k, path, t0, R, eps=None):
    a, b, X, Y = num_run(k, path, t0, eps or [1] * (2 * k - 2), R)
    return X[k] + a[k]^2 - Y[k] - b[k]^2


def mirror_core(k, path):
    if path[1] != (1, 2) or path[-2] != (k - 1, k):
        return False
    core = path[1:-1]
    return set((k - i, k + 2 - j) for i, j in core) == set(core)


def parity_ok(path):
    bi = set(i % 2 for (i, j), (i2, j2) in zip(path, path[1:]) if i2 == i)
    aj = set(j % 2 for (i, j), (i2, j2) in zip(path, path[1:]) if i2 == i + 1)
    return len(bi) <= 1 and len(aj) <= 1


def aut_order(f):
    L = K.extension(f.change_variable_name('T'), 'u')
    return sum(1 for g, _ in f.change_ring(L).factor() if g.degree() == 1)


def honest_t(k, path, R):
    """t of the honest packing: least squares from a Tutte embedding
    (circle-graph-search.py), then Newton on the final equation."""
    n = 2 * k
    cc = sorted([(i, i + 1) for i in range(k - 1)] + [(k + j, k + j + 1) for j in range(k - 1)]
                + [(i - 1, k + j - 1) for i, j in path])
    walls = sorted([(i, 'top') for i in range(k)] + [(k + j, 'bottom') for j in range(k)]
                   + [(0, 'left'), (k, 'left'), (k - 1, 'right'), (2 * k - 1, 'right')])
    z = cgs.solve(n, cc, walls, attempts=300)
    x = R(float(np.sqrt(z[2 * n])))
    h = R(2)^(-R.prec() // 3)
    for _ in range(60):
        x = x - final(k, path, x, R) / ((final(k, path, x + h, R) - final(k, path, x - h, R)) / (2 * h))
    return x


print('=' * 72)
print(' The hidden involution of the zigzag %s' % pstr(EXC))
print('=' * 72)

# (1) ------------------------------------------------------------------
k = 6
f, root, num, (a, b, X, Y) = find_factor(k, EXC)
L = K.extension(f.change_variable_name('T'), 'u')
u = L.gen()
lin = [g for g, _ in f.change_ring(L).factor() if g.degree() == 1]
print()
print('(1) m = deg f = %d; f has %d roots in F = K(t)' % (f.degree(), len(lin)))
tau = [-g[0] / g[1] for g in lin if -g[0] / g[1] != u][0]
am1 = a[k - 1].numerator()(u) / a[k - 1].denominator()(u)
print('    the second root is t\' = -a_5 exactly: %s' % (tau == -am1))
e = [e for e in L.embeddings(RRR) if abs(e(u) - root) < 1e-30 and e(K.gen()) > 0][0]
tv = e(tau)
print('    t = %s,  t\' = %s' % (str(root)[:14], str(tv)[:14]))
for name, x in (('honest', root), ('at t\'', tv)):
    print('    %-7s r(A) = %s' % (name, ' '.join('%.6f' % evaluate(a[i], x)^2 for i in range(1, k + 1))))
    print('    %-7s r(B) = %s' % ('', ' '.join('%.6f' % evaluate(b[j], x)^2 for j in range(1, k + 1))))
    print('    %-7s W    = %.6f' % ('', evaluate(X[k] + a[k]^2, x)))
ok = all(abs(evaluate(a[i], root)^2 - evaluate(a[k - i], tv)^2) < 1e-40 for i in range(1, k)) and \
     all(abs(evaluate(b[j], root)^2 - evaluate(b[k + 2 - j], tv)^2) < 1e-40 for j in range(2, k + 1))
shift = [evaluate(X[i], root) - evaluate(X[k - i], tv) for i in range(1, k)] + \
        [evaluate(Y[j], root) - evaluate(Y[k + 2 - j], tv) for j in range(2, k + 1)]
print('    core at t\' = honest core with labels reversed: radii %s, translated by %.10f (spread %.1e)'
      % (ok, shift[0], max(shift) - min(shift)))

# (2) ------------------------------------------------------------------
print()
print('(2) end porism.  Left end: a_1 = t, b_1 = 1 - t (stacked on the left wall),')
print('    B_2 tangent to B_1 and A_1.  A top circle D stacked with B_2 against the')
print('    vertical tangent on the right of B_2 (signed sqrt d = 1 + b_2) touches A_1:')
t_ = FF.gen()
b2 = (1 - t_) / (t_^2 - (1 - t_)^2 + s * t_)
Y2 = (1 - t_)^2 + 2 * (1 - t_) * b2
xw = Y2 + b2^2
XD = xw - (1 + b2)^2
resid = (XD - t_^2)^2 - 4 * (1 + b2)^2 * t_^2
print('    residual, as a rational function of t: %s' % resid)

# (3) ------------------------------------------------------------------
print()
print('(3) branch signs of the reversed configuration, all patterns with a')
print('    mirror-symmetric core (end circles B_1 and A_k), k <= 8')
R = RealField(300)
for kk in (4, 6, 8):
    for p in lattice_paths(kk):
        if not mirror_core(kk, p):
            continue
        try:
            tt = honest_t(kk, p, R)
        except Exception:
            print('    k=%d %-46s honest packing not found' % (kk, pstr(p)))
            continue
        aa, bb, XX, YY = num_run(kk, p, tt, [1] * (2 * kk - 2), R)
        tp = -aa[kk - 1]
        hits = []
        for eps in itertools.product((1, -1), repeat=2 * kk - 2):
            try:
                a2, b2_, X2, Y2_ = num_run(kk, p, tp, eps, R)
            except ZeroDivisionError:
                continue
            if abs(X2[kk] + a2[kk]^2 - Y2_[kk] - b2_[kk]^2) > 1e-60:
                continue
            if all(abs(a2[i]^2 - aa[kk - i]^2) < 1e-60 for i in range(1, kk)) and \
               all(abs(b2_[j]^2 - bb[kk + 2 - j]^2) < 1e-60 for j in range(2, kk + 1)):
                hits.append(''.join('+' if x > 0 else '-' for x in eps))
        print('    k=%d %-46s parity rule %-5s  reversed branch %s'
              % (kk, pstr(p), parity_ok(p), hits))

# (4) ------------------------------------------------------------------
print()
print('(4) patterns predicted by the parity rule (mirror-symmetric core and')
print('    parity), up to the symmetries of the rectangle')
R = RealField(4000)
emb4 = [e for e in K.embeddings(R) if e(K.gen()) > 0][0]
for kk in range(3, 11):
    orbits = {}
    for p in lattice_paths(kk):
        if parity_ok(p) and mirror_core(kk, p):
            orbits.setdefault(canonical(kk, p), p)
    print('    k = %2d: %d orbit(s)' % (kk, len(orbits)), flush=True)
    for p in orbits.values():
        if kk <= 8:
            q = list(canonical(kk, p))      # Aut(F/K) is an invariant of the orbit
            f_, r_, n_, _ = find_factor(kk, q)
            print('        %-58s m = %3d, |Aut(F/K)| = %d' % (pstr(p), f_.degree(), aut_order(f_)))
        else:
            tt = honest_t(kk, p, R)
            tp = -num_run(kk, p, tt, [1] * (2 * kk - 2), R)[0][kk - 1]
            aa_, bb_, XX_, YY_ = recursion(kk, p)
            N = (XX_[kk] + aa_[kk]^2 - YY_[kk] - bb_[kk]^2).numerator()
            found = []
            for g, _ in N.factor():
                gr = g.change_ring(K).map_coefficients(emb4, R)
                sc = lambda x: sum(abs(c) * abs(x)^d for d, c in enumerate(gr.list()))
                found.append((g.degree(), abs(gr(tt)) / sc(tt), abs(gr(tp)) / sc(tp)))
            ft = [d for d, vt, vp in found if vt < R(10)^-1000]
            fp = [d for d, vt, vp in found if vp < R(10)^-1000]
            print('        %-58s final equation of degree %d; t on the factor of degree %s, t\' on %s'
                  % (pstr(p), N.degree(), ft, fp))

# (5) ------------------------------------------------------------------
print()
print('(5) the fixed field E of the involution')
fixed = (b[4]^2).numerator()(u) / (b[4]^2).denominator()(u)
Epol = fixed.absolute_minpoly()
print('    r(B_4) is fixed and generates E: [E : Q] = %d' % Epol.degree())
Ered = pari(Epol).polredbest()
for kk in range(2, 6):
    seen = set()
    for p in lattice_paths(kk):
        key = canonical(kk, p)
        if key in seen:
            continue
        seen.add(key)
        f_, r_, n_, _ = find_factor(kk, list(key))
        if Epol.degree() % (2 * f_.degree()):
            continue
        fs = f_.map_coefficients(lambda c: c.galois_conjugate())
        absr = pari(QQ['x']([QQ(c) for c in (f_ * fs).list()])).polredbest()
        rel = 'isomorphic to E' if 2 * f_.degree() == Epol.degree() else 'embeds in E'
        test = pari.nfisisom(absr, Ered) if rel == 'isomorphic to E' else pari.nfisincl(absr, Ered)
        print('    k=%d %-34s degree %2d  %s: %s' % (kk, pstr(key), 2 * f_.degree(), rel, bool(test)))
print()
print('(%.0fs)' % (time.time() - T0))
