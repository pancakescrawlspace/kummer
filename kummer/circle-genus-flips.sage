# =====================================================================
# circle-genus-flips.sage -- genus of the curve of a dropped turn tangency
# for larger zigzags, and the symmetric flips (circle-genus.typ).
#
#     cd kummer
#     sage circle-genus-flips.sage K [SHARD NSHARDS] > ../results/circle-genus-flips-kK.txt
#
# For every two-row zigzag with k circles per row and every turn of its
# path (one per symmetry class), the plane curve H of circle-genus.sage
# (§3 of the note).  Its genus is computed modulo two primes p = +-1 mod 8
# (reduction at a prime of K = Q(sqrt 2) above p): a lower bound for the
# genus, equal to it for all but finitely many p.
#
# Symmetry of the flip.  Dropping the turn tangency gives the
# quadrilateral pattern Q; putting in the other diagonal gives the flipped
# path P'.  Q is invariant under a symmetry sigma of the rectangle that
# exchanges the two diagonals exactly when sigma(P) = P'.  Then sigma acts
# on the curve H as an involution exchanging the two packings.  The
# symmetries: L (left-right), T (top-bottom), R (half-turn).
# =====================================================================
import sys, time
from collections import Counter, defaultdict

K_ROW = int(sys.argv[1]) if len(sys.argv) > 1 else 5
SHARD = int(sys.argv[2]) if len(sys.argv) > 2 else 0
NSHARDS = int(sys.argv[3]) if len(sys.argv) > 3 else 1

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


def sym(k, path, name):
    f = {'L': lambda i, j: (k + 1 - i, k + 1 - j), 'T': lambda i, j: (j, i),
         'R': lambda i, j: (k + 1 - j, k + 1 - i)}[name]
    return tuple(sorted(f(i, j) for i, j in path))


def cls(k, path, e):
    imgs = []
    for f in (lambda i, j: (i, j), lambda i, j: (j, i), lambda i, j: (k + 1 - i, k + 1 - j), lambda i, j: (k + 1 - j, k + 1 - i)):
        imgs.append((tuple(sorted(f(*x) for x in path)), f(*e)))
    return min(imgs)


k = K_ROW
print('=' * 78)
print(' k = %d: turns of all two-row zigzags, one per symmetry class' % k)
print('=' * 78)
print(' pattern%s dropped  flipped pattern%s symmetric  bideg   genus mod p   [time]' % (' ' * (3 * k - 7), ' ' * (3 * k - 15)))
seen = set()
stats = Counter()
idx = -1
for path in lattice_paths(k):
    for n0 in turns(path):
        key = cls(k, path, path[n0])
        if key in seen:
            continue
        seen.add(key)
        idx += 1
        if idx % NSHARDS != SHARD:
            continue
        T0 = time.time()
        i0, j0 = path[n0]
        prev, nxt = path[n0 - 1], path[n0 + 1]
        other = (prev[0] + nxt[0] - i0, prev[1] + nxt[1] - j0)
        flip = path[:n0] + [other] + path[n0 + 1:]
        syms = [nm for nm in 'LTR' if sym(k, path, nm) == tuple(sorted(flip))]
        try:
            f, t0 = rigid(k, path)
            v0 = chain_num(path, t0)[0][k]
            Phi, configuration = glue(k, path, n0)
            H = component(Phi, t0, v0)
        except Exception as ex:
            print(' %-*s A%dB%d  ERROR %s' % (int(3 * k + 1), pstr(path), i0, j0, str(ex)[:80]), flush=True)
            stats['error'] += 1
            continue
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
        stats[(g, ''.join(syms) or '-')] += 1
        print(' %-*s A%dB%d   %-*s %-9s (%d,%d)   %-12s  [%.0fs]'
              % (int(3 * k + 1), pstr(path), i0, j0, int(3 * k + 1), pstr(flip), ''.join(syms) or '-', bd[0], bd[1], str(gs), time.time() - T0), flush=True)
print()
print(' classes in this shard: %d' % sum(stats.values()))
for (g, sy), c in sorted(stats.items(), key=lambda kv: str(kv[0])):
    print('   genus %s, symmetric flip %s: %d' % (g, sy, c))
