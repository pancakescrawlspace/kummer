from sage.all import *

R = PolynomialRing(QQ, 'x'); x = R.gen()

def cubic_of(E):
    b2, b4, b6 = E.b2(), E.b4(), E.b6()
    return x**3 + b2*x**2 + 8*b4*x + 16*b6

def isintegral(f):
    return all(co in ZZ for co in f.coefficients(sparse=False))

def reduce_cubic(f):
    changed = True
    while changed:
        changed = False
        D = ZZ(f.discriminant())
        for q in prime_range(2, 400):
            if D % q**2 != 0 and q > 3:
                continue
            for mu in range(q):
                g = f(q*x + mu) / q**3
                if isintegral(g):
                    f = R(g); changed = True; break
            if changed:
                break
    best = f; bh = max(abs(ZZ(co)) for co in f.coefficients(sparse=False))
    a2 = ZZ(f[2])
    for mu in range(-abs(a2)//3 - 3, abs(a2)//3 + 4):
        g = R(f(x + mu))
        h = max(abs(ZZ(co)) for co in g.coefficients(sparse=False))
        if h < bh:
            bh = h; best = g
    return best

def row(tag, D, E):
    Em, _ = E.minimal_quadratic_twist()
    f = reduce_cubic(cubic_of(Em))
    a, b, c = ZZ(f[2]), ZZ(f[1]), ZZ(f[0])
    # the surface actually surveyed is the one of the cubic we print
    Es = EllipticCurve([0, a, 0, b, c])
    nfac = len(R(f).factor())
    print("%s %s %s %s %s %s %s %s %s" %
          (tag, D, a, b, c, Em.conductor(), Es.conductor(),
           Es.rank(), nfac))

# ---- the eleven rigid CM surfaces (j != 0, 1728) -----------------------
RIGID = {-7: -3375, -28: 16581375, -8: 8000, -11: -32768, -12: 54000,
         -16: 287496, -19: -884736, -27: -12288000, -43: -884736000,
         -67: -147197952000, -163: -262537412640768000}
print("#RIGID tag D a b c Nmin N rank nfac")
for D in sorted(RIGID, reverse=True):
    E = EllipticCurve_from_j(QQ(RIGID[D]))
    row("rigid", D, E)

# ---- j = 0  (D = -3): surfaces <-> cubefree B > 0 ----------------------
print("#J0 tag B a b c Nmin N rank nfac")
for B in range(1, 21):
    if not ZZ(B).is_squarefree() and any(e >= 3 for _, e in ZZ(B).factor()):
        continue
    E = EllipticCurve([0, 0, 0, 0, B])
    Em, _ = E.minimal_quadratic_twist()
    nfac = len(R(x**3 + B).factor())
    print("j0 %s 0 0 %s %s %s %s %s" %
          (B, B, Em.conductor(), E.conductor(), E.rank(), nfac))

# ---- j = 1728 (D = -4): surfaces <-> squarefree A ----------------------
print("#J1728 tag A a b c Nmin N rank nfac")
for A in [a for a in range(-10, 11) if a != 0 and ZZ(a).is_squarefree()]:
    E = EllipticCurve([0, 0, 0, A, 0])
    Em, _ = E.minimal_quadratic_twist()
    nfac = len(R(x**3 + A*x).factor())
    print("j1728 %s 0 %s 0 %s %s %s %s" %
          (A, A, Em.conductor(), E.conductor(), E.rank(), nfac))
