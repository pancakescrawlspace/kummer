# =====================================================================
# cert-lprimary.sage -- the l-primary certificate for the single-place
# sweep of kummer-padic-density.typ sections 3.3 and 3.4, in Sage.
#
# A port of cert-lprimary.gp, which is left untouched.  As with
# cert-extended.sage, the two are meant to be run against each other:
#
#     sage cert-lprimary.sage > results/cert-lprimary-sage.txt
#     diff results/cert-lprimary.txt results/cert-lprimary-sage.txt
#
# so the output format is PARI's throughout, down to the "Mod(a, p)"
# spelling of a residue and the "[x, y]" spelling of a point.  Nothing is
# printed here that the GP version does not print.
#
# THE MATHEMATICS IS UNCHANGED and is stated in full at the head of
# cert-lprimary.gp: G := E^d(Q_p) is profinite abelian and topologically
# finitely generated, so a closed subgroup R equals G as soon as
# R.Phi(G) = G; for abelian G the Frattini quotient is prod_l G/lG; with
# G = Z_p x T only l = p and the primes dividing #T contribute, and those
# factors have coprime orders.  Hence density is checked one l at a time,
# and each layer is a basis, a matrix of images, and a rank over F_l.
#
# ---------------------------------------------------------------------
# THE GP DEPENDENCY, AND WHY IT SURVIVES THE PORT AFTER ALL.
#
# cert-lprimary.gp opens with read("ledger.gp"), which reads sadic.gp,
# which reads kummer2.gp.  Of everything that chain defines, the file
# uses exactly one name: padiccurve, at the single call site inside
# valalpha.  (PRECL2 is set locally and is not ledger.gp's PRECL.)  So
# the chain is inlined here as the six lines below and nothing else is
# carried across.
#
# padiccurve(Em, p) is ellinit with each a_i replaced by a_i + O(p^PREC),
# i.e. the same curve over Z_p rather than over Z.  It LOOKS like a
# type-conversion convenience: in valalpha its visible job is to make
# ellmul return a point whose coordinates are t_PADIC, so that
# valuation(Q[1], p) can be asked at all -- GP's `valuation` wants either
# a p-adic or an explicit second argument -- and the depth is read off as
# -v/2.  The point being multiplied is RATIONAL, and so is M*P, so the
# exact x-coordinate has the same valuation and Sage will hand it over
# without any base change.  The obvious reading is that padiccurve is a
# GP-ism with no content and that the port should drop it, along with
# PRECL2 and the guard `if (k > PRECL2 \ 4, -1, k)` that protects against
# exhausting the precision.
#
# THAT READING IS WRONG, and the reason is worth recording, because it is
# invisible in the source and only shows up when the two are timed.
# Multiplication by M multiplies the canonical height by M^2, so the
# numerator of x(M P) has about M^2 h(P) / log 10 decimal digits.  On
# this sweep M = c_p * #Etilde^ns runs to ~600 and the generators have
# heights around 20, and those two numbers multiply:
#
#     p    d       M     h(P)     digits of x(MP)   exact     p-adic
#    149   13559   596   19.91     3 071 818        21.775s   0.010s
#    131   8646    524   18.05     2 152 650        16.447s   0.002s
#    197   394     394   19.63     1 323 522         5.688s   0.002s
#    199   -199    398   17.41     1 197 893         5.352s   0.002s
#    101   -2626   101   30.26       134 046         0.278s   0.002s
#    149   94      164    4.27        49 876         0.088s   0.001s
#
# (Measured in this Sage, both routes agreeing on every value.  The
# p-adic column includes building the curve over Q_p on each call, so it
# is if anything pessimistic.)  Working modulo p^80 makes the cost of a
# multiplication flat in h(P) and in M; working exactly makes it grow
# like M^2 h(P), and the sweep is precisely where both are large.  Over
# 180 blocks the exact route costs minutes and buys nothing.
#
# So padiccurve is not a type-conversion convenience but the thing that
# makes valalpha cheap, and it is kept -- inlined, cached per (curve,
# prime), and with PRECL2 and its guard intact.  What the guard is for:
# when M P is genuinely O, the p-adic computation does not return the
# point at infinity but an x of enormous negative valuation, so a depth
# above PRECL2/4 is read as "the precision ran out", i.e. alpha = 0.
# Exactly, M*P.is_zero() would decide that outright -- that much of the
# exact route really is cleaner, and it is the only part of it that is.
#
# The rest of the file's p-adic arithmetic is in phiclass, and there it
# is unavoidable for a mathematical rather than a numerical reason: at
# additive reduction with Phi = (Z/2)^2 the basis is the 2-torsion, whose
# x-coordinates lie in Z_p and not in Z, so those points do not exist
# over Q at all.
#
# ---------------------------------------------------------------------
# WHAT IS ACTUALLY INDEPENDENT.  Sage sits on PARI, so this is a rewrite
# and not a second proof.  What changes is which layer does the work:
#
#   ellrank + ellsaturation  ->  E.gens(algorithm='pari')
#   elltors                  ->  E.torsion_subgroup()
#   ellgroup                 ->  E.change_ring(GF(p)).abelian_group()
#   elllocalred              ->  E.kodaira_symbol(p), E.tamagawa_number(p)
#   factorpadic              ->  roots over Qp(p, prec)
#   ellsub with p-adic coords->  arithmetic on E over Qp(p, prec)
#   matrank over Mod(-, l)   ->  matrix(GF(l), rows).rank()
#   padiccurve               ->  EllipticCurve(Qp(p, PRECL2), ...), inlined
#
# and every convention the GP file had to state by hand -- the canonical
# base, the ordering of the p-adic roots, the divisors-only search for
# the order in E/E_1 -- is restated here in a different language, so a
# transcription error in either version shows up as a diff.
#
# WHAT THE DIFF SAYS (run of 2026-08-25, 33s against the GP file's own
# run).  Both files report 180 blocks, 419 layer lines, 180 dense and 0
# disagreements with section 3.3.  The diff is not empty; it is 224
# lines, and every one of them is either a `P_i = ` generator listing
# (98) or a `P_i |-> ` image row (126).  No block header, reduction line,
# layer list, basis line, rank line or verdict line differs at all.
#
# The generator diff is the one cert-extended.sage already documents:
# Sage sorts the points it returns and PARI does not, and a point may
# come back negated.  Checked mechanically over all 180 blocks -- the two
# bases agree as unordered sets up to sign, with no block differing by
# more than that.  The image rows move with the generators, since a class
# is a discrete log and negates with the point.
#
# That the verdicts survive is not an accident of the rank being a coarse
# invariant.  Both files coordinatise E^d(Q_p)/l against the SAME
# canonical basis -- the basis lines are identical -- so the image is not
# merely a subspace of the same dimension in each, it is the same
# subspace.  Checked: the reduced row echelon form over F_l of the image
# matrix agrees in all 419 layer lines.  A basis is a choice; the image
# of E^d(Q) in the Frattini quotient is not.
# =====================================================================

from sage.rings.padics.precision_error import PrecisionError

# ---------------------------------------------------------------------
# PARI-shaped printing.
# ---------------------------------------------------------------------

def ptstr(P):
    """A rational point as PARI prints it: [x, y], or [0] at infinity."""
    if P.is_zero():
        return "[0]"
    return "[%s, %s]" % (P[0], P[1])

def modstr(P, p):
    """A point of E(F_p) as PARI prints it: [Mod(x, p), Mod(y, p)]."""
    if P.is_zero():
        return "[0]"
    return "[Mod(%s, %s), Mod(%s, %s)]" % (ZZ(P[0]), p, ZZ(P[1]), p)

def modliststr(L, p):
    return "[" + ", ".join(modstr(P, p) for P in L) + "]"

def veci(v):
    """A vector of integers as PARI prints it: [a, b]."""
    return "[" + ", ".join(str(a) for a in v) + "]"

def vecs(v):
    """A vector of strings as PARI prints it: ["a", "b"]."""
    return "[" + ", ".join('"%s"' % a for a in v) + "]"


# ---------------------------------------------------------------------
# the curve and the size of E(Q_p)/E_1
# ---------------------------------------------------------------------

def cden(P):
    """c, where P = (a/c^2, b/c^3).  0 at infinity."""
    if P.is_zero():
        return ZZ(0)
    return ZZ(P[0].denominator()).isqrt()

def Ed(d):
    return EllipticCurve(QQ, [d^2, d^3])

def MvalE(E, p):
    """#(E(Q_p)/E_1).  E_d is minimal at p on every line here:
    v_p(c_4) = v_p(48) + 2 v_p(d) <= 3 < 4."""
    a = E.ap(p)
    if E.discriminant() % p != 0:
        return ZZ(p + 1 - a)
    return ZZ(E.tamagawa_number(p) * (p - a))


# ---------------------------------------------------------------------
# the additive lines: T = Phi(F_p), and it need not be cyclic.
#
# This is the one place where p-adic arithmetic is unavoidable: the
# 2-torsion has x-coordinates in Z_p and not in Z, so the basis points
# do not exist over Q.
# ---------------------------------------------------------------------

def prootsQp(E, p, prec):
    """Roots of x^3 + a4 x + a6 in Q_p, with multiplicity, canonically ordered.

    Canonical order: by the p-adic expansion read from the BOTTOM, i.e. by
    the leading digit u = (r/p^v) mod p.  Sorting by the integer lift
    instead orders by the HIGH-order digits and therefore depends on the
    working precision -- the same kind of irreproducibility as a randomly
    chosen base.  Here the three roots have valuation 1 with distinct
    leading digits (they are the roots of the good-reduction cubic modulo
    p, which are distinct for I_0^*), so the leading digit already
    separates them; the full lift is kept only as a tiebreak.
    """
    K = Qp(p, prec)
    R = PolynomialRing(K, 'X')
    X = R.gen()
    f = X^3 + K(E.a4()) * X + K(E.a6())
    L = []
    for (r, m) in f.roots():
        L += [r] * m
    def key(r):
        return (ZZ(r.unit_part()) % p, ZZ(r))
    return sorted(L, key=key)

def rootlabel(r, p):
    """A short label for a root: these all have valuation 1, so u p."""
    if r.valuation() == 1:
        return "%sp" % (ZZ(r / p) % p)
    return str(ZZ(r))

def singptp(E, p):
    """The singular point of the reduction mod p, or None.

    The GP version searches the whole of F_p x F_p.  It need not: p is odd
    throughout, so the partial in y, 2y + a1 x + a3 = 0, already determines
    y from x, and only the p values of x have to be tried.  The x are still
    taken in increasing order, so the point returned is the same one.
    """
    F = GF(p)
    a1, a2, a3, a4, a6 = [F(a) for a in E.a_invariants()]
    for x0 in range(p):
        X = F(x0)
        Y = -(a1*X + a3) / 2
        if (Y^2 + a1*X*Y + a3*Y - X^3 - a2*X^2 - a4*X - a6 == 0
                and a1*Y - 3*X^2 - 2*a2*X - a4 == 0):
            return (ZZ(x0), ZZ(Y))
    return None

def inE0pad(Q, sp):
    """Is a p-ADIC point in E_0(Q_p)?

    Negative valuation means it reduces to O, hence lies in E_1 and so in
    E_0; otherwise compare the reduction with the singular point.
    """
    if Q.is_zero():
        return True
    if Q[0].valuation() < 0:
        return True
    if sp is None:
        return True
    return not ((Q[0] - sp[0]).valuation() > 0 and (Q[1] - sp[1]).valuation() > 0)

def phiclass(E, P, p, rts, sp, prec):
    """The class of P in Phi = (Z/2)^2, against the first two 2-torsion points."""
    K = Qp(p, prec)
    EK = EllipticCurve(K, [K(E.a4()), K(E.a6())])
    Pp = EK.point([K(P[0]), K(P[1]), K(1)], check=False)
    if inE0pad(Pp, sp):
        return [0, 0]
    idx = [[1, 0], [0, 1], [1, 1]]
    for j in range(3):
        T2 = EK.point([K(ZZ(rts[j])), K(0), K(1)], check=False)
        if inE0pad(Pp - T2, sp):
            return idx[j]
    return [-1, -1]


# ---------------------------------------------------------------------
# A CANONICAL base for E(F_p), so that the class column is reproducible.
#
# A generator chosen by the library is chosen AT RANDOM on each call, so a
# class computed against it is neither reproducible nor checkable by a
# reader, and two generators dlogged against separate calls are not even
# mutually consistent.  Instead: order the affine points of E(F_p)
# lexicographically by (x,y) and take the FIRST point of maximal order; in
# the non-cyclic case the first g_2 of order n_2 independent of g_1.  The
# STRUCTURE is deterministic and is used freely.
# ---------------------------------------------------------------------

def ellgroup(E, p):
    """The structure of E(F_p) in PARI's order: [n1] or [n1, n2] with n2 | n1.

    Sage lists the invariants the other way round (d1 | d2 | ...), so they
    are reversed here; the printed group is C_n1 x C_n2 as in the GP file.
    """
    inv = E.change_ring(GF(p)).abelian_group().invariants()
    return [ZZ(n) for n in reversed(inv)]

def canonbase(E, p):
    """(E(F_p), canonical generators, structure in PARI's order)."""
    Ep = E.change_ring(GF(p))
    G = ellgroup(E, p)
    F = GF(p)
    a4, a6 = F(E.a4()), F(E.a6())
    # The affine points, lexicographically by (x, y).  The GP version tries
    # every y for every x; here the two y over a given x are the square roots
    # of r, listed smaller lift first, which is the same order in p steps
    # instead of p^2.
    pts = []
    for x0 in range(p):
        X = F(x0)
        r = X^3 + a4*X + a6
        if r == 0:
            pts.append(Ep.point([X, F(0), F(1)], check=False))
        elif r.is_square():
            y0 = ZZ(r.sqrt())
            for y in sorted([y0, p - y0]):
                pts.append(Ep.point([X, F(y), F(1)], check=False))
    n1 = G[0]
    g1 = None
    for P in pts:
        if g1 is None and P.order() == n1:
            g1 = P
    if len(G) == 1:
        return (Ep, [g1], G)
    n2 = G[1]
    # independent of g1 iff <g1> meets <g2> only in O
    span1 = set()
    Q = Ep(0)
    for e in range(n1):
        span1.add(Q)
        Q = Q + g1
    g2 = None
    for P in pts:
        if g2 is None and P.order() == n2:
            ok = True
            R = P
            for k in range(1, n2):
                if R.is_zero():
                    break
                if R in span1:
                    ok = False
                    break
                R = R + P
            if ok:
                g2 = P
    return (Ep, [g1, g2], G)

def dlog(Ep, P, gens, cyc):
    """Discrete log of Pbar in E(F_p), against the CANONICAL base above."""
    g1, n1 = gens[0], cyc[0]
    if P.is_zero():
        return [0] if len(cyc) == 1 else [0, 0]
    if len(cyc) == 1:
        for e in range(n1):
            if e * g1 == P:
                return [e]
        return [-1]
    g2, n2 = gens[1], cyc[1]
    for e in range(n1):
        eg = e * g1
        for f in range(n2):
            if eg + f * g2 == P:
                return [e, f]
    return [-1, -1]


def kodsym(E, p):
    """The Kodaira symbol as the GP file spells it: I_0, I_n, I_0*, I_n*, II*.

    The GP file decodes PARI's integer code by hand against a calibration
    table.  Sage hands back a KodairaSymbol, whose string form differs only
    in punctuation, so the translation is from PARI's code again -- keeping
    the two files honest about the same convention rather than trusting two
    different pretty-printers to agree.
    """
    k = ZZ(E.kodaira_symbol(p)._pari_code())
    if k == 1:  return "I_0"
    if k == 2:  return "II"
    if k == 3:  return "III"
    if k == 4:  return "IV"
    if k > 4:   return "I_%s" % (k - 4)
    if k == -1: return "I_0*"
    if k == -2: return "II*"
    if k == -3: return "III*"
    if k == -4: return "IV*"
    return "I_%s*" % (-k - 4)


# ---------------------------------------------------------------------
# the diagonal layer l = p.  v_p(alpha_P), from depth(M P) = v_p(alpha) + 1.
# ---------------------------------------------------------------------

PRECL2 = 80

_qpcurves = {}

def padiccurve(E, p, prec=PRECL2):
    """E over Q_p -- kummer2.gp's padiccurve, inlined and memoised.

    The GP original is ellinit with each a_i replaced by a_i + O(p^prec);
    here the base ring carries the precision instead, which is the same
    curve.  Memoised on (a4, a6, p, prec) because every generator of a
    given block wants the same one, and building it is not free.

    Why this is not dead weight in Sage -- the timings are at the head of
    the file: exact arithmetic in E(Q) would give the same valuations,
    but x(M P) has ~M^2 h(P) / log 10 digits, three million of them on
    the worst line here, and 80 p-adic digits are enough.
    """
    key = (E.a4(), E.a6(), p, prec)
    EK = _qpcurves.get(key)
    if EK is None:
        K = Qp(p, prec)
        EK = EllipticCurve(K, [K(E.a4()), K(E.a6())])
        _qpcurves[key] = EK
    return EK

def valalpha(E, P, p, M):
    """v_p(alpha_P), or -1 when alpha = 0 (P locally torsion at p).

    depth(M P) = v_p(alpha) + 1 and depth = -v_p(x)/2, so the answer is
    -v_p(x(M P))/2 - 1.  The guard is the GP file's: when M P is really O
    the p-adic multiple is not the point at infinity but an x of enormous
    negative valuation, so a depth past PRECL2/4 means the precision ran
    out rather than that the point is deep.
    """
    EK = padiccurve(E, p)
    K = EK.base_ring()
    try:
        Q = M * EK.point([K(P[0]), K(P[1]), K(1)], check=False)
    except (ZeroDivisionError, ArithmeticError, PrecisionError):
        # the same overflow the guard below catches, raised instead of
        # returned: the multiple is O to the working precision
        return ZZ(-1)
    if Q.is_zero():
        return ZZ(-1)
    v = Q[0].valuation()
    if v >= 0:
        return ZZ(-1)
    k = ZZ(-v // 2 - 1)
    if k > PRECL2 // 4:
        return ZZ(-1)
    return k

def ordE1(E, P, p, M):
    """Order of Pbar in E(Q_p)/E_1: the least divisor e of M with eP in E_1.

    Testing the divisors of M by scalar multiplication, rather than M
    repeated additions, is the difference between minutes and milliseconds
    once the generators have large height.
    """
    for e in divisors(M):
        Q = e * P
        if not Q.is_zero() and cden(Q) % p == 0:
            return ZZ(e)
    return ZZ(M)


def rankFl(rows, l):
    """Rank over F_l of a matrix of images given as rows."""
    if len(rows) == 0:
        return 0
    return matrix(GF(l), [[ZZ(a) for a in r] for r in rows]).rank()


# ---------------------------------------------------------------------
# one block per (p, class, d): the generators of E^d(Q) once, then one
# line per relevant l with basis, images and rank.
# ---------------------------------------------------------------------

def entry(p, cls, d):
    E = Ed(d)
    M = MvalE(E, p)
    good = (E.discriminant() % p != 0)

    # E.gens(algorithm='pari') is ellrank followed by Sage's own saturation --
    # the same two steps as the GP file's ellrank + ellsaturation, and it raises
    # rather than guess if the rank is not determined.  Sage's DEFAULT algorithm
    # is mwrank, which is not a variant reading of the same computation but a
    # different and far slower one, with no extra certainty.
    fgens = E.gens(algorithm='pari')
    gens = list(fgens) + [T.element() for T in E.torsion_subgroup().gens()]
    rank = E.rank()
    ntors = E.torsion_order()

    # the torsion T and its structure
    CB, rts, sp = None, None, None
    if good and M % p != 0:
        Tstruct = ellgroup(E, p)
        CB = canonbase(E, p)
    else:
        c = M // p^(M.valuation(p))
        if c == 1:
            Tstruct = []
        elif c == 4 and len(prootsQp(E, p, 40)) == 3:
            Tstruct = [ZZ(2), ZZ(2)]
        else:
            Tstruct = [ZZ(c)]
        if len(Tstruct) > 0:
            rts = prootsQp(E, p, 40)
            sp = singptp(E, p)
    if len(Tstruct) == 0:
        Tord = ZZ(1)
    elif len(Tstruct) == 1:
        Tord = Tstruct[0]
    else:
        Tord = Tstruct[0] * Tstruct[1]

    print("  p = %s  class %s  d = %s    E_d : y^2 = x^3 + %sx + %s"
          % (p, cls, d, d^2, d^3))
    if good:
        redname = "good"
    elif E.ap(p) == 0:
        redname = "additive"
    else:
        redname = "multiplicative"
    if len(Tstruct) == 0:
        Tname = "trivial"
    elif len(Tstruct) == 1:
        Tname = "C%s" % Tstruct[0]
    else:
        Tname = "C2 x C2"
    print("      reduction %s,  Kodaira %s,  c_p = %s,  a_p = %s,  M = %s,  T = %s,"
          "   E^d(Q_p) = Z_%s%s"
          % (redname, kodsym(E, p), E.tamagawa_number(p), E.ap(p), M, Tname,
             p, " x T" if Tord > 1 else ""))
    print("      E^d(Q) : rank %s, torsion %s;  generators" % (rank, ntors))
    for i in range(len(gens)):
        print("        P_%s = %s" % (i + 1, ptstr(gens[i])))

    # the relevant l: p, and the primes dividing #T
    layers = [ZZ(p)]
    if Tord > 1:
        for (q, _) in ZZ(Tord).factor():
            if q != p:
                layers.append(ZZ(q))
    print("      relevant l (p, and the primes dividing #T) : %s" % veci(layers))

    allonto = True
    for l in layers:
        if l == p:
            # G/pG = Z_p/p, one-dimensional, no canonical basis: the only
            # invariant content of an image is whether it vanishes.
            dim = 1
            basis = "-- (dim 1; the identification with F_p is only up to F_p^*)"
            ws = [valalpha(E, P, p, M) for P in gens]
            rows = [[1 if w == 0 else 0] for w in ws]
            print("      l = %s  (= p)   dim E^d(Q_p)/%s = %s" % (l, l, dim))
            print("            basis  : %s" % basis)
            for i in range(len(gens)):
                w = ws[i]
                print("            P_%s |-> %s      (v_%s(alpha) = %s)"
                      % (i + 1, "nonzero" if w == 0 else "0", p,
                         "infinity" if w < 0 else w))
        else:
            if good and M % p != 0:
                # T = Etilde(F_p) = C_n1 (+) C_n2 against the canonical base
                Ep, bg, cyc = CB
                idx = [i for i in range(len(cyc)) if cyc[i] % l == 0]
                dim = len(idx)
                basis = "images of %s in Etilde(F_%s)" % (
                    modliststr([bg[i] for i in idx], p), p)
                rows = []
                for P in gens:
                    Pb = Ep(0) if cden(P) % p == 0 else Ep.point(
                        [GF(p)(P[0]), GF(p)(P[1]), GF(p)(1)], check=False)
                    c = dlog(Ep, Pb, bg, cyc)
                    rows.append([ZZ(c[j]) % l for j in idx])
            elif len(Tstruct) == 2:
                # additive with Phi = (Z/2)^2: the basis is the 2-torsion,
                # named by its x-coordinate, which has v_p = 1 and so is u p.
                dim = 2
                basis = "the 2-torsion at x = %s" % vecs(
                    [rootlabel(rts[0], p), rootlabel(rts[1], p)])
                rows = [phiclass(E, P, p, rts, sp, 40) for P in gens]
            else:
                # T cyclic.  This covers BOTH additive with Phi cyclic AND
                # multiplicative -- the p = 31 lines, where 31 is the bad prime
                # of E itself.  At multiplicative reduction E_0/E_1 is the
                # non-split torus, cyclic of order p - a_p prime to p, and IS
                # the whole of T, so the component group is the wrong place to
                # look.  The order of Pbar in E/E_1 needs no case analysis: for
                # cyclic T = C_m the image in T/lT is nonzero exactly when
                # v_l(order) = v_l(m), i.e. the class is prime to l.
                dim = 1
                basis = "a generator of the cyclic T = C%s" % Tord
                rows = []
                for P in gens:
                    o = ordE1(E, P, p, M)
                    o = o // p^(o.valuation(p))
                    rows.append([1 if o.valuation(l) == ZZ(Tord).valuation(l) else 0])
            print("      l = %s        dim E^d(Q_p)/%s = %s" % (l, l, dim))
            print("            basis  : %s" % basis)
            for i in range(len(gens)):
                print("            P_%s |-> %s" % (i + 1, veci(rows[i])))
        r = rankFl(rows, l)
        onto = (r == dim)
        if not onto:
            allonto = False
        print("            rank over F_%s = %s of %s   ==> %s"
              % (l, r, dim, "ONTO" if onto else "*** NOT ONTO ***"))
    print("      dense at p : %s"
          % ("YES (onto for every l)" if allonto else "*** NO ***"))
    return (allonto, len(gens), Tstruct, layers)


# ---------------------------------------------------------------------
# the witness table of section 3.3, verbatim from cert-extended.gp
# ---------------------------------------------------------------------

WIT = [
  (3,   [7, -1, 3, 6]),        (5,   [1, 3, 5, -35]),
  (7,   [1, -1, 7, -7]),       (11,  [3, 6, 11, -11]),
  (13,  [-1, 5, -13, 26]),     (17,  [-1, 7, 34, 51]),
  (19,  [1, -1, 95, -95]),     (23,  [1, -1, 46, 115]),
  (29,  [-1, 11, -29, 58]),    (31,  [1, -1, 31, -62]),
  (37,  [-11, 6, -37, 74]),    (41,  [-1, 3, 41, 123]),
  (43,  [1, -1, -86, 86]),     (47,  [-11, -149, 94, 705]),
  (53,  [11, 22, 53, 106]),    (59,  [1, 6, 295, -59]),
  (61,  [1, 7, -61, 122]),     (67,  [-221, 51, 2211, 134]),
  (71,  [1, -1, 71, -71]),     (73,  [3, -21, 146, -365]),
  (79,  [1, -1, 158, -158]),   (83,  [-22, -11, 83, 166]),
  (89,  [1, -7, 178, -267]),   (97,  [1, 7, 97, 485]),
  (101, [-1, 3, 101, -2626]),  (103, [1, -1, 103, 2266]),
  (107, [-7, -1, -1605, -107]),(109, [1, 6, 109, 654]),
  (113, [1, 3, 113, 339]),     (127, [-6, 3, 254, -127]),
  (131, [53, -11, 131, 8646]), (137, [7, 3, 274, -411]),
  (139, [51, 3, 139, -139]),   (149, [53, 94, -149, 13559]),
  (151, [1, -1, 755, 453]),    (157, [1, 5, 157, 2355]),
  (163, [1, -1, 978, 815]),    (167, [-13, -6, 334, -334]),
  (173, [51, 53, -173, 519]),  (179, [1, -19, 179, -537]),
  (181, [1, 7, -181, -1086]),  (191, [1, -1, 191, -191]),
  (193, [1, 5, -193, 965]),    (197, [-6, 3, 197, 394]),
  (199, [-6, 3, 199, -199])
]

CLS = ["[1]", "[u]", "[p]", "[up]"]

print("=========================================================================")
print(" l-primary certificate for the single-place sweep, sections 3.3 and 3.4")
print("=========================================================================")
print("")
print("E : v^2 = u^3 + u + 1 (496a).   E_d : Y^2 = X^3 + d^2 X + d^3.")
print("")
print("G := E^d(Q_p) is profinite abelian and topologically finitely generated,")
print("so a closed subgroup R equals G as soon as R.Phi(G) = G, and for abelian")
print("G,  G/Phi(G) = prod_l G/lG.  With G = Z_p x T only l = p and the primes")
print("dividing #T contribute, and those factors have coprime orders.  Hence")
print("")
print("   E^d(Q) dense in E^d(Q_p)  <=>  E^d(Q) --> E^d(Q_p)/l onto for each l,")
print("")
print("checked one l at a time.  Each E^d(Q_p)/l is an F_l-space of dimension")
print("<= 2, so a line is: a basis, the images of the generators of E^d(Q) in")
print("it, and the rank of that matrix.  Generators are listed ONCE per (p,d).")
print("")

nl, nd, rows_total, bad = 0, 0, 0, []
for (p, ds) in WIT:
    for j in range(4):
        t = entry(p, CLS[j], ds[j])
        nl += 1
        rows_total += len(t[3])
        if t[0]:
            nd += 1
        else:
            bad.append((p, CLS[j], ds[j]))
        print("", flush=True)
print("-------------------------------------------------------------------------")
print("  blocks (p, class, d)          : %s" % nl)
print("  layer lines (p, d, l)         : %s" % rows_total)
print("  dense at p (onto for every l) : %s" % nd)
print("  disagreements with section 3.3: %s" % (nl - nd))
for b in bad:
    print("    *** p = %s %s d = %s" % (b[0], b[1], b[2]))
print("-------------------------------------------------------------------------")
print("")
print("done.")
