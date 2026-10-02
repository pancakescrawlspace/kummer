# =====================================================================
# circle-genus-shared.sage -- dropped row tangencies and dropped cross
# tangencies in the middle of a fan (circle-genus.typ).
#
#     cd kummer
#     sage circle-genus-shared.sage K > ../results/circle-genus-shared-kK.txt
#
# Dropping A_i A_{i+1} blocks exactly one step of the lattice path, the
# step (i, j) -> (i+1, j).  The chain from the left corner (parameter t)
# runs up to (i, j), the chain from the right corner (parameter v) back to
# (i+1, j); both contain B_j.  The two copies of B_j must coincide: equal
# signed square roots of the radius,
#     f(t) = b_j^left(t) = b_j^right(v) = h(v),
# and equal positions, which fixes W.  So the family is the fibre product
# {f(t) = h(v)}.  Likewise for B_j B_{j+1} with the roles of the rows
# exchanged.
#
# Dropping the cross tangency A_i B_j in the middle of a fan (the path
# runs (i, j-1), (i, j), (i, j+1), or (i-1, j), (i, j), (i+1, j)) blocks
# the steps into and out of (i, j).  The left chain runs up to (i, j-1),
# the right chain back to (i, j+1); both contain A_i, and the family is
# the fibre product {a_i^left(t) = a_i^right(v)}.  The circle B_j then
# touches the bottom, B_{j-1} and B_{j+1}, which determines it.
#
# The component through the packing and its genus (modulo two primes)
# as in circle-genus-flips.sage, one line per symmetry class.
# =====================================================================
import sys, time
from collections import Counter

K_ROW = int(sys.argv[1]) if len(sys.argv) > 1 else 4
src = open('circle-genus.sage').read()
exec(preparse(src[:src.index('# 1. all zigzags')]))
from sage.libs.singular.function import singular_function, lib as singular_lib
singular_lib('normal.lib')
_sgenus = singular_function('genus')
PRIMES = [p for p in prime_range(1000000, 1001000) if p % 8 in (1, 7)][:6]


def genus_modp(H, p):
    F = GF(p); r2 = F(2).sqrt()
    Rp.<T_, V_> = PolynomialRing(F)
    Hp = sum((F(c[0]) + F(c[1]) * r2) * T_^m[0] * V_^m[1] for m, c in H.dict().items())
    if Hp.total_degree() != H.total_degree() or Hp.degree(T_) != H.degree(t) or Hp.degree(V_) != H.degree(v):
        return None
    fac = Hp.factor()
    if len(fac) != 1 or fac[0][1] != 1:
        return None
    return ZZ(_sgenus(Rp.ideal([Hp])))


Pz.<z> = K[]


def branch_values(F, var):
    """The polynomial whose roots are the branch values of z = F(var)."""
    T_.<Zt> = K[]
    U_.<Xu> = T_[]
    co = lambda c: K(c.constant_coefficient()) if hasattr(c, 'constant_coefficient') else K(c)
    n_ = R2(F.numerator()).polynomial(var); d_ = R2(F.denominator()).polynomial(var)
    G = U_([co(c) for c in n_.list()]) - Zt * U_([co(c) for c in d_.list()])
    return Pz(G.discriminant()(z))


def shared_maps(k, path, tau):
    """(f, h, description) for a row tangency ('A', i) / ('B', j), or a fan
    cross tangency ('X', (i, j)); None if tau is of neither kind."""
    mir = [(k + 1 - a_, k + 1 - b_) for a_, b_ in reversed(path)]
    m = lambda x: k + 1 - x
    if tau[0] in 'AB':
        row, i = tau
        idx = 0 if row == 'A' else 1
        n = [n for n in range(len(path) - 1) if path[n][idx] == i and path[n + 1][idx] == i + 1][0]
        aL, bL, XL, YL = chain(path[:n + 1], t)
        aR, bR, XR, YR = chain(mir[:len(path) - 1 - n], v)
        if row == 'A':
            j = path[n][1]
            return bL[j], bR[m(j)], 'B%d' % j
        j = path[n][0]
        return aL[j], aR[m(j)], 'A%d' % j
    (i, j) = tau[1]
    n = path.index((i, j))
    if n == 0 or n == len(path) - 1:
        return None
    p_, q_ = path[n - 1], path[n + 1]
    if p_ == (i, j - 1) and q_ == (i, j + 1):
        centre = ('A', i)
    elif p_ == (i - 1, j) and q_ == (i + 1, j):
        centre = ('B', j)
    else:
        return None                              # a turn
    aL, bL, XL, YL = chain(path[:n], t)
    aR, bR, XR, YR = chain(mir[:len(path) - 1 - n], v)
    if centre[0] == 'A':
        return aL[i], aR[m(i)], 'A%d' % i
    return bL[j], bR[m(j)], 'B%d' % j


def cls(k, path, tau):
    imgs = []
    for sw in (False, True):
        for mi in (False, True):
            def fp(i, j):
                if sw: i, j = j, i
                if mi: i, j = k + 1 - i, k + 1 - j
                return (i, j)
            q = tuple(sorted(fp(*e) for e in path))
            if tau[0] in 'AB':
                row, i = tau
                row2 = {'A': 'B', 'B': 'A'}[row] if sw else row
                i2 = k - i if mi else i                  # the pair (i, i+1) -> (k-i, k+1-i)
                imgs.append((q, (row2, i2)))
            else:
                imgs.append((q, ('X', fp(*tau[1]))))
    return min(imgs)


k = K_ROW
print('=' * 78)
print(' k = %d: dropped row tangencies and fan tangencies, one per symmetry class' % k)
print('=' * 78)
seen = set()
stats = Counter()
for path in lattice_paths(k):
    taus = [('A', i) for i in range(1, k)] + [('B', j) for j in range(1, k)] + [('X', e) for e in path]
    f0 = None
    for tau in taus:
        key = cls(k, path, tau)
        if key in seen:
            continue
        r = shared_maps(k, path, tau)
        if r is None:
            continue
        seen.add(key)
        if f0 is None:
            f0, t0 = rigid(k, path)
            v0 = chain_num(path, t0)[0][k]
        T0 = time.time()
        fm, hm, sh = r
        H = component(fm - hm, t0, v0)
        dfm = max(fm.numerator().degree(t), fm.denominator().degree(t))
        dhm = max(hm.numerator().degree(v), hm.denominator().degree(v))
        bd = (H.degree(t), H.degree(v))
        if min(bd) <= 1:
            gs = [0]
        else:
            gs = []
            for p in PRIMES:
                g = genus_modp(H, p)
                if g is not None:
                    gs.append(g)
                if len(gs) == 2:
                    break
        g = max(gs) if gs else None
        what = ('%s%d%s%d' % (tau[0], tau[1], tau[0], tau[1] + 1)) if tau[0] in 'AB' else 'A%dB%d (fan)' % tau[1]
        kind = 'row' if tau[0] in 'AB' else 'fan'
        stats[(kind, g)] += 1
        note = ''
        if g is not None and g != (bd[0] - 1) * (bd[1] - 1):
            cb = gcd(branch_values(fm, t), branch_values(hm, v))
            note = '  below (p-1)(q-1): common branch values %s' % (cb.factor() if cb.degree() else 'none')
            stats[('below (p-1)(q-1)', None)] += 1
        print(' %-*s drop %-12s shared %s  map degrees (%d,%d)  H (%d,%d)  genus %s  [%.0fs]%s'
              % (int(3 * k + 1), pstr(path), what, sh, dfm, dhm, bd[0], bd[1], gs, time.time() - T0, note), flush=True)
print()
for (kind, g), c in sorted(stats.items(), key=str):
    print('   %s tangencies, genus %s: %d classes' % (kind, g, c))
