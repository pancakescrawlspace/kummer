# =====================================================================
# circle-degrees-growth.sage -- degrees of the two-row zigzag packings of
# circle-packings.typ for larger k, by an exact recursion.
#
#     cd kummer
#     sage circle-degrees-growth.sage [KMAX] > ../results/circle-degrees-growth.txt
#
# Height 1, a_i = sqrt(r(A_i)), b_j = sqrt(r(B_j)), X_i, Y_j the
# x-coordinates of the centres.  If A_i B_j is tangent and the next
# circle is A_{i+1} (tangent to the top, to A_i and to B_j), then
#
#     a_i / a_{i+1} = Y_j - X_i + sqrt(2) b_j,   X_{i+1} = X_i + 2 a_i a_{i+1},
#
# and symmetrically for B_{j+1}: the quadratic for a_{i+1} has
# discriminant 2 (a_i b_j)^2, so no new square root appears.  Starting
# from a_1 = t, b_1 = 1 - t, X_1 = t^2, Y_1 = (1 - t)^2 every coordinate
# is a rational function of t over K = Q(sqrt 2), and the packing is cut
# out by the single equation  X_k + a_k^2 = Y_k + b_k^2  (both end circles
# touch the right side).  Hence F = K(t), and [F : Q] = 2 deg f, where f
# is the irreducible factor over K of the numerator of that equation that
# vanishes at the t of the actual packing.  That factor is identified by
# evaluating the recursion at every real root in (0, 1) of every factor
# and keeping the root that gives an honest packing.
# =====================================================================
import itertools, sys, time

KMAX = int(sys.argv[1]) if len(sys.argv) > 1 else 7
K.<s> = QuadraticField(2)
R.<t> = K[]
FF = R.fraction_field()
RRR = RealField(300)
emb = K.embeddings(RRR)
emb = [e for e in emb if e(s) > 0][0]          # sqrt 2 > 0


def recursion(k, path):
    a = {1: FF(t)}; b = {1: FF(1 - t)}; X = {1: FF(t^2)}; Y = {1: FF((1 - t)^2)}
    for (i, j), (i2, j2) in zip(path, path[1:]):
        if i2 == i + 1:
            a[i2] = a[i] / (Y[j] - X[i] + s * b[j]); X[i2] = X[i] + 2 * a[i] * a[i2]
        else:
            b[j2] = b[j] / (X[i] - Y[j] + s * a[i]); Y[j2] = Y[j] + 2 * b[j] * b[j2]
    return a, b, X, Y


def evaluate(fn, x):
    num, den = fn.numerator(), fn.denominator()
    n = sum(emb(c) * x^e for e, c in enumerate(num.list()))
    d = sum(emb(c) * x^e for e, c in enumerate(den.list()))
    return n / d


def honest(k, path, a, b, X, Y, x):
    try:
        A = [(evaluate(X[i], x), 1 - evaluate(a[i], x)^2, evaluate(a[i], x)^2) for i in range(1, k + 1)]
        B = [(evaluate(Y[j], x), evaluate(b[j], x)^2, evaluate(b[j], x)^2) for j in range(1, k + 1)]
        av = [evaluate(a[i], x) for i in range(1, k + 1)]
        bv = [evaluate(b[j], x) for j in range(1, k + 1)]
    except ZeroDivisionError:
        return False
    if min(av + bv) <= 0:
        return False
    W = A[-1][0] + A[-1][2]
    cs = A + B
    tang = set((i - 1, k + j - 1) for i, j in path)
    tang |= set((i, i + 1) for i in range(k - 1)) | set((k + j, k + j + 1) for j in range(k - 1))
    for (x0, y0, r0) in cs:
        if x0 - r0 < -1e-30 or x0 + r0 > W + 1e-30 or r0 >= RRR(1) / 2:
            return False
    for p in range(2 * k):
        for q in range(p + 1, 2 * k):
            (x1, y1, r1), (x2, y2, r2) = cs[p], cs[q]
            gap = ((x1 - x2)^2 + (y1 - y2)^2).sqrt() - r1 - r2
            if (p, q) in tang:
                if abs(gap) > 1e-30:
                    return False
            elif gap <= 1e-30:
                return False
    return True


def lattice_paths(k):
    for ups in itertools.combinations(range(2 * k - 2), k - 1):
        i = j = 1
        p = [(1, 1)]
        for st in range(2 * k - 2):
            if st in ups:
                i += 1
            else:
                j += 1
            p.append((i, j))
        yield p


def canonical(k, path):
    """Representative of the orbit under the symmetries of the rectangle:
    top <-> bottom is (i, j) -> (j, i); left <-> right is
    (i, j) -> (k+1-i, k+1-j) read backwards."""
    P = tuple(path)
    T = tuple((j, i) for i, j in path)
    L = tuple(sorted((k + 1 - i, k + 1 - j) for i, j in path))
    LT = tuple(sorted((k + 1 - j, k + 1 - i) for i, j in path))
    return min(P, T, L, LT)


def find_factor(k, path):
    """The irreducible factor f over K with f(t) = 0 at the honest packing."""
    a, b, X, Y = recursion(k, path)
    E = X[k] + a[k]^2 - Y[k] - b[k]^2
    num = E.numerator()
    found = []
    for f, _ in num.factor():
        fr = f.change_ring(K).map_coefficients(emb, RRR)
        for root, _ in fr.roots(RRR):
            if 0 < root < 1 and honest(k, path, a, b, X, Y, root):
                found.append((f, root))
    assert len(found) == 1, (path, len(found))
    return found[0][0], found[0][1], num, (a, b, X, Y)


if not globals().get('_NO_MAIN'):
    print('two-row zigzags: F = Q(sqrt2, t), t = sqrt(r(A_1)), height 1')
    print('m = [F : Q(sqrt 2)], so deg F = 2m;  N = degree of the numerator of the final equation')
    print()
    for k in range(2, KMAX + 1):
        t0 = time.time()
        rows = {}
        for path in lattice_paths(k):
            key = canonical(k, path)
            if key in rows:
                continue
            a, b, X, Y = recursion(k, path)
            E = X[k] + a[k]^2 - Y[k] - b[k]^2
            num = E.numerator()
            found = []
            for f, _ in num.factor():
                fr = f.change_ring(K).map_coefficients(emb, RRR)
                for root, _ in fr.roots(RRR):
                    if 0 < root < 1 and honest(k, path, a, b, X, Y, root):
                        found.append((f, root))
            assert len(found) == 1, (path, len(found))
            f, root = found[0]
            L = K.extension(f.change_variable_name('T'), 'u')
            u = L.gen()
            Wexpr = X[k] + a[k]^2
            Wv = Wexpr.numerator()(u) / Wexpr.denominator()(u)
            degW = Wv.absolute_minpoly().degree()
            rows[key] = (num.degree(), f.degree(), degW, evaluate(Wexpr, root))
        ms = sorted(set(v[1] for v in rows.values()))
        print('k = %d: %d patterns up to symmetry   (%.0fs)' % (k, len(rows), time.time() - t0))
        print('   deg F = 2m takes the values %s' % sorted(set(2 * m for m in ms)))
        print('   max deg F = %d,  min deg F = %d,  N ranges over %d..%d'
              % (2 * max(ms), 2 * min(ms), min(v[0] for v in rows.values()), max(v[0] for v in rows.values())))
        print('   patterns with deg W < deg F: %d' % sum(1 for v in rows.values() if v[2] < 2 * v[1]))
        for key in sorted(rows, key=lambda p: (rows[p][1], p)):
            N, m, dW, Wval = rows[key]
            if k <= 5 or key in (min(rows, key=lambda p: rows[p][1]), max(rows, key=lambda p: rows[p][1])):
                print('     %-40s deg F %3d  deg W %3d  N %3d  W = %s'
                      % (' '.join('%d%d' % e for e in key), 2 * m, dW, N, str(Wval)[:10]))
        sys.stdout.flush()
