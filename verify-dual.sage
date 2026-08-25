# =====================================================================
# Independent check, in Sage, of the one computational input to the
# theorem of section 5.2.4:  both dual-isogeny images lie in E_1.
#
# The PARI version (control.gp, dualinE1) builds the duals by hand --
# locating the kernel by trial and matching the codomain up to a sixth
# power -- and evaluates them with its own substitution code.  Here we
# use Sage's EllipticCurveIsogeny.dual() and rational_maps() instead, so
# the dual construction and the evaluation are both independent.
#
# Run (image is amd64, so it emulates on Apple silicon):
#   docker run --rm --platform linux/amd64 -v "$PWD":/work -w /work \
#          sagemath/sagemath:latest sage verify-dual.sage
# =====================================================================

R.<x> = QQ[]

print("=== Kodaira type at 3, four classes (f = x^3 - 2) ===")
for (cls, d) in [("[1]", -1115), ("[u]", -1), ("[3]", 3), ("[u*3]", -3)]:
    E = EllipticCurve(QQ, [0, -2*d^3])
    ld = E.local_data(3)
    print("   class %-6s d=%-6s  Kodaira %-5s  c_3 = %s"
          % (cls, d, ld.kodaira_symbol(), ld.tamagawa_number()))

print()
print("=== dual images: does any Q_3-point of the codomain leave E_1 ? ===")
K = Qp(3, 60)

def qp_points(C, XMAX):
    """Q_3-points of C with integral x-coordinate."""
    a4, a6 = C.a4(), C.a6()
    pts = []
    for x0 in range(-XMAX, XMAX + 1):
        s = x0^3 + a4*x0 + a6
        if s == 0:
            continue
        v = s.valuation(3)
        if v % 2:
            continue
        if kronecker((s / 3^v) % 3, 3) != 1:
            continue
        y = K(s).sqrt()
        pts += [(K(x0), y), (K(x0), -y)]
    return pts

total, bad = 0, 0
for d in [-3, 6, -21, 87]:
    E = EllipticCurve(QQ, [0, -2*d^3])
    for nm, ker in [("phi_1", x), ("phi_2", x - 2*d)]:
        ph = E.isogeny(ker)
        C, du = ph.codomain(), ph.dual()
        assert du.domain() == C and du.degree() == 3
        if E.rank() > 0:                       # dual o phi = [3]
            P = E.gens()[0]
            assert du(ph(P)) == 3*P
        fx, fy = du.rational_maps()
        tested = outside = 0
        for (X, Y) in qp_points(C, 300):
            try:
                xx = fx(X, Y)
            except ZeroDivisionError:
                continue                       # image is O, which lies in E_1
            tested += 1
            if xx.valuation() >= 0:            # integral x  =>  NOT in E_1
                outside += 1
        total += tested; bad += outside
        print("   d=%-4s %s : %4d points tested, %d outside E_1"
              % (d, nm, tested, outside))

print()
print("total %d points tested, %d outside E_1" % (total, bad))
print("=> W_3 is NOT phi-stable, i.e. beta_3 is not identically zero"
      if bad == 0 else "=> UNEXPECTED: containment fails")
