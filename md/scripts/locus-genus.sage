"""Genus of two classical loci: Cassini ovals and four-bar coupler curves.

The note is md/locus-curves-of-positive-genus.md.  Run with

    sage md/scripts/locus-genus.sage

For each curve the script computes the plane equation, checks that it
is irreducible, lists the singular points of the projective closure
over Q(i) (the circular points I, J = (1 : +-i : 0) live there) with
their multiplicities, counts the singular points over Qbar, and asks
Singular for the geometric genus.  The total Tjurina number is the
degree of the singular subscheme: 1 for a node, 4 for an ordinary
triple point.

Coupler curve.  X moves on the circle about A = (0,0) of radius r1,
Y on the circle about B = (d,0) of radius r2, |XY| = l, and the coupler
point is P = X + s (Y - X) + t J(Y - X) with J the rotation by 90
degrees.  The equation of the locus of P is found by eliminating
X and Y.  Watt's curve is the case r1 = r2, s = 1/2, t = 0.
"""

K.<i> = QuadraticField(-1)
R.<x, y> = QQ[]
S.<x1, y1, x2, y2, X, Y> = QQ[]


def report(name, f):
    facs = f.factor()
    print(name)
    print("  degree %d, irreducible: %s" % (f.degree(), len(facs) == 1 and facs[0][1] == 1))
    P2 = ProjectiveSpace(K, 2, 'u, v, w')
    C = Curve(f.homogenize()(*P2.coordinate_ring().gens()), P2)
    sing = C.singular_points()
    print("  singular points over Q(i): " +
          (", ".join("%s (mult %d%s)" % (p, C.multiplicity(p),
                                         ", ordinary" if C.is_ordinary_singularity(p) else "")
                     for p in sing) or "none"))
    Z = C.singular_subscheme()
    print("  over Qbar: %d singular points, total Tjurina number %d"
          % (Z.defining_ideal().radical().hilbert_polynomial(), Z.degree()))
    print("  geometric genus: %d" % Curve(f).genus())
    print()


def coupler(d, r1, r2, l, s, t):
    eqs = [x1^2 + y1^2 - r1^2,
           (x2 - d)^2 + y2^2 - r2^2,
           (x2 - x1)^2 + (y2 - y1)^2 - l^2,
           X - (x1 + s*(x2 - x1) - t*(y2 - y1)),
           Y - (y1 + s*(y2 - y1) + t*(x2 - x1))]
    g = S.ideal(eqs).elimination_ideal([x1, y1, x2, y2]).gens()[0]
    return R(g.subs(X=x, Y=y))


def grashof(*bars):
    b = sorted(bars)
    return b[0] + b[3] - b[1] - b[2]


print("=" * 72)
print(" Cassini ovals  |PA| |PB| = k^2,  A, B = (-c, 0), (c, 0)")
print("=" * 72)
print()
for c, k in [(1, 2), (1, 1/2), (1, 1)]:
    f = (x^2 + y^2)^2 - 2*c^2*(x^2 - y^2) + c^4 - k^4
    report("c = %s, k = %s%s" % (c, k, "  (lemniscate)" if c == k else ""), f)

print("=" * 72)
print(" Four-bar coupler curves")
print("=" * 72)
print()
for d, r1, r2, l, s, t in [(5, 2, 4, 7/2, 1/3, 1/2),   # generic
                           (4, 3, 3, 3/2, 1/2, 0),     # Watt's curve
                           (5, 2, 4, 3, 1/3, 1/2),     # Grashof boundary
                           (4, 3, 3, 2, 1/2, 0)]:      # Grashof boundary, Watt
    name = ("d = %s, r1 = %s, r2 = %s, l = %s, s = %s, t = %s;  b1+b4-b2-b3 = %s"
            % (d, r1, r2, l, s, t, grashof(d, r1, r2, l)))
    report(name, coupler(d, r1, r2, l, s, t))
