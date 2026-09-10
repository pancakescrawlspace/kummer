from sage.all import *

R = PolynomialRing(QQ, 'x'); x = R.gen()

def cubic_of(E):
    """integral monic cubic f with E : y^2 = f(x)  (from b-invariants)"""
    b2, b4, b6 = E.b2(), E.b4(), E.b6()
    return x**3 + b2*x**2 + 8*b4*x + 16*b6

def isintegral(f):
    return all(co in ZZ for co in f.coefficients(sparse=False))

def reduce_cubic(f):
    """minimise f over the orbit  f -> c^-3 f(cx+mu),  c in Q*, mu in Q,
       staying integral monic.  Greedy on primes, then a shift."""
    changed = True
    while changed:
        changed = False
        a = ZZ(f[2]); b = ZZ(f[1]); c = ZZ(f[0])
        D = ZZ(f.discriminant())
        for q in prime_range(2, 200):
            if D % q**2 != 0 and q > 3:
                continue
            for mu in range(q):
                g = f(q*x + mu) / q**3
                if isintegral(g):
                    f = R(g); changed = True; break
            if changed:
                break
    # translate to make the x^2 coefficient small
    best = f; bh = max(abs(ZZ(co)) for co in f.coefficients(sparse=False))
    a2 = ZZ(f[2])
    for mu in range(-abs(a2)//3 - 3, abs(a2)//3 + 4):
        g = R(f(x + mu))
        h = max(abs(ZZ(co)) for co in g.coefficients(sparse=False))
        if h < bh:
            bh = h; best = g
    return best

def reduce_AB(A, B):
    A = ZZ(A); B = ZZ(B); u = ZZ(1)
    if A == 0:
        for (q, e) in B.factor(): u *= q**(e//3)
    elif B == 0:
        for (q, e) in A.factor(): u *= q**(e//2)
    else:
        for (q, e) in A.abs().factor(): u *= q**min(e//2, B.valuation(q)//3)
    A //= u**2; B //= u**3
    return (A, abs(B))

CM = {0:-3, 1728:-4, -3375:-7, 8000:-8, 54000:-12, 287496:-16, -32768:-11,
      -884736:-19, 16581375:-28, -12288000:-27, -884736000:-43,
      -147197952000:-67, -262537412640768000:-163}

db = CremonaDatabase()
NMAX = 40
seen = {}
rows = []
for N in range(11, NMAX + 1):
    for lbl, cur in sorted(db.allcurves(N).items()):
        E = EllipticCurve(cur[0])
        Es = E.short_weierstrass_model()
        key = reduce_AB(Es.a4(), Es.a6())
        if key in seen:
            continue
        seen[key] = lbl
        f = reduce_cubic(cubic_of(E))
        Emin, D = E.minimal_quadratic_twist()
        j = E.j_invariant()
        rows.append((ZZ(Emin.conductor()), "%s%s" % (N, lbl), N,
                     [ZZ(f[2]), ZZ(f[1]), ZZ(f[0])], j,
                     CM.get(j, 0), E.rank(), E.torsion_order(),
                     len(f.factor()), key))

rows.sort(key=lambda r: (r[0], r[2], r[1]))
print("#Nmin label N a2 a4 a6 j cm rank tors nfac Ared Bred")
for r in rows:
    print("%s %s %s %s %s %s %s %s %s %s %s %s" %
          (r[0], r[1], r[2], r[3][0], r[3][1], r[3][2], r[4], r[5], r[6], r[7], r[8],
           "%s %s" % r[9]))
print("total", len(rows))
