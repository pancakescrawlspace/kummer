# =====================================================================
# circle-galois.sage -- Galois groups of the two-row zigzag packings.
#
#     cd kummer
#     sage circle-galois.sage [KMAX] > ../results/circle-galois.txt
#
# By circle-degrees-growth.sage, F = K(t) with K = Q(sqrt 2) and
# t = sqrt(r(A_1)) a root of an irreducible f in K[t] of degree m.  The
# minimal polynomial of t over Q is f * f^sigma (sigma: sqrt2 -> -sqrt2),
# so the Galois group G of the Galois closure over Q is a subgroup of the
# wreath product S_m wr C_2, of order 2 (m!)^2, and G contains elements
# swapping the two blocks {roots of f}, {roots of f^sigma}.
#
# Claim tested: G = S_m wr C_2 (the largest possibility).
#
#  m <= 5: PARI's polgalois on the degree-2m polynomial f f^sigma.
#  m >= 5: a certificate from Frobenius elements.  For a prime p = +-1 mod 8
#    (split in K) not dividing the discriminant, the factorisations of f
#    modulo the two primes above p give the cycle types of a pair (g, h)
#    in G_K = G n (S_m x S_m).  G_K projects onto a transitive subgroup
#    of each factor (f is irreducible), and the two projections are
#    conjugate by the block swap.
#      (a) an m-cycle and an (m-1)-cycle (fixing a point) make the
#          projection 2-transitive, hence primitive.  If moreover some
#          cycle type has exactly one cycle of length divisible by a prime
#          p, of length exactly p, with p = 2, p = 3 or p <= m - 3, then a
#          power of that element is a p-cycle, and by Jordan's theorem a
#          primitive group containing it contains A_m.  The m-cycle or the
#          (m-1)-cycle is odd, so the projection is S_m;
#      (b) by Goursat's lemma a subdirect product of S_m x S_m (m >= 5) is
#          S_m x S_m, or {(g, h) : sgn g = sgn h}, or the graph of an
#          automorphism; a pair with sgn g != sgn h excludes the second,
#          and a pair in which g is an m-cycle (for m = 6: a 5-cycle,
#          a class fixed by the outer automorphism) and h is not of the
#          same type excludes the third.
#    Then G_K = S_m x S_m and G = S_m wr C_2.
# =====================================================================
import sys, time
from collections import Counter

_NO_MAIN = True
load('circle-degrees-growth.sage')

KMAX = int(sys.argv[1]) if len(sys.argv) > 1 else 6
PRIMES = 3000           # how many split primes to try for a certificate


def absolute(f):
    """f * f^sigma as a polynomial over Q."""
    fs = f.map_coefficients(lambda c: c.galois_conjugate())
    g = f * fs
    return QQ['x']([QQ(c) for c in g.list()])


def cycle_type(fp):
    fac = fp.factor()
    if any(e > 1 for _, e in fac):
        return None
    return tuple(sorted((q.degree() for q, _ in fac), reverse=True))


def sign(ct):
    return (-1) ** (sum(ct) - len(ct))


def certificate(f):
    m = f.degree()
    den = lcm([c.denominator() for c in f.list()])
    F = f * den                                   # coefficients in O_K? use Z[sqrt2] reps
    D = absolute(f).discriminant() * absolute(f).leading_coefficient()
    found = {'mcycle': False, 'm1cycle': False, 'jordan': False, 'sign': False, 'nondiag': False}
    target = (5, 1) if m == 6 else (m,)
    count = 0
    p = 2
    while count < PRIMES and not all(found.values()):
        p = next_prime(p)
        if p % 8 not in (1, 7):
            continue
        if D.numerator() % p == 0 or D.denominator() % p == 0:
            continue
        r = GF(p)(2).sqrt()
        types = []
        for root in (r, -r):
            coeffs = []
            ok = True
            for c in f.list():
                c0, c1 = c[0], c[1]              # c = c0 + c1 * sqrt2
                if (c0.denominator() * c1.denominator()) % p == 0:
                    ok = False
                    break
                coeffs.append(GF(p)(c0) + GF(p)(c1) * root)
            if not ok:
                types = None
                break
            types.append(cycle_type(GF(p)['x'](coeffs)))
        if types is None or None in types:
            continue
        count += 1
        g, h = types
        for ct in (g, h):                         # both are elements of a projection (up to the swap)
            if ct == (m,):
                found['mcycle'] = True
            if ct == (m - 1, 1):
                found['m1cycle'] = True
            for q in prime_divisors(prod(ct)):
                if (q in (2, 3) or q <= m - 3) and [c % q == 0 for c in ct].count(True) == 1 and q in ct:
                    found['jordan'] = True
        if sign(g) != sign(h):
            found['sign'] = True
        if (g == target and h != target) or (h == target and g != target):
            found['nondiag'] = True
    return all(found.values()), found, count


print('Galois groups of the two-row zigzags: G inside S_m wr C_2, m = [F : Q(sqrt 2)]')
print()
total = Counter()
exceptions = []
for k in range(2, KMAX + 1):
    t0 = time.time()
    seen = set()
    groups = Counter()
    for path in lattice_paths(k):
        key = canonical(k, path)
        if key in seen:
            continue
        seen.add(key)
        f, root, num, _ = find_factor(k, path)
        m = f.degree()
        if m <= 5:
            name = str(pari(absolute(f)).polgalois()[3])
            order = int(pari(absolute(f)).polgalois()[0])
            full = order == 2 * factorial(m) ** 2
            label = ('S_%d wr C_2' % m) if full else name
            if not full:
                exceptions.append((k, key, m, name))
        else:
            ok, found, used = certificate(f)
            label = ('S_%d wr C_2' % m) if ok else 'undecided %s' % found
            if not ok:
                exceptions.append((k, key, m, str(found)))
        groups[label] += 1
    print('k = %d (%d patterns up to symmetry, %.0fs):' % (k, len(seen), time.time() - t0))
    for label, c in sorted(groups.items(), key=lambda t: (len(t[0]), t[0])):
        print('   %-40s %d' % (label, c))
    sys.stdout.flush()
    total.update(groups)
print()
print('patterns whose group is not the full wreath product (or undecided):')
for k, key, m, name in exceptions:
    print('   k = %d  m = %d  %s  : %s' % (k, m, ' '.join('%d%d' % e for e in key), name))
