\\ cert-p2.gp -- the extended certificate at p = 2, for section 3.2.
\\ Run from this directory:
\\     gp -q -s 4000000000 cert-p2.gp < /dev/null > results/cert-p2.txt
\\
\\ Section 3.2 lists eight witness twists, one per class of Q_2^*/(Q_2^*)^2, and
\\ nothing else.  This is the same certificate as section 3.4, at p = 2 -- where
\\ the conventions of 3.4.1 do not apply verbatim and have to be shifted.
\\
\\ WHAT SHIFTS.  For p >= 3 the formal group is E_1(Q_p) = Z_p.  At p = 2 that
\\ fails -- E_1(Q_2) can carry 2-torsion -- and one goes one step down:
\\     E_2(Q_2) = Ehat(4 Z_2) = Z_2 ,   with  E_n <-> 2^(n-2) Z_2 .
\\ So the finite quotient to surject onto is E(Q_2)/E_2, of order
\\     Q_2 = 2 * M_2 ,   M_2 = c_2 * #Etilde^ns(F_2) = c_2 * (2 - a_2) ,
\\ the factor 2 being #(E_1/E_2).  A point P generates E(Q_2) topologically iff
\\ its order m in E(Q_2)/E_2 is Q_2 AND the depth v = v_2(c(mP)) is exactly 2 --
\\ the shifted form of "depth 1" at odd p.  In general the closure has index
\\     (Q_2 / m) * 2^(v-2) .
\\
\\ WHY THE TORSION VANISHES HERE, so that E^d(Q_2) = Z_2 with no C_a x C_b at
\\ all.  Two halves, and neither uses the certificate (so there is no
\\ circularity):
\\   * no odd torsion: the odd part of T injects into E(Q_2)/E_1, of order M_2,
\\     which is a power of 2 for every one of the eight twists;
\\   * no 2-torsion: E_2 is torsion-free, so 2-torsion injects into E(Q_2)/E_2,
\\     but E[2](Q_2) = 0 because the cubic x^3 + d^2 x + d^3 is IRREDUCIBLE over
\\     Q_2 -- its roots are d times those of x^3 + x + 1, so irreducibility is
\\     the same statement for every twist.  A point of order 4 would give one of
\\     order 2, so the whole 2-part vanishes with it.
\\ Hence T = 1, the base and T-coordinate columns are empty throughout, and the
\\ entire content of a line is the pair (m, v).
\\
\\ This is also exactly the condition section 2.2 needs: E(Q_2) = Z_2 is
\\ procyclic, so one generator can suffice and the Kummer surface's supply of
\\ PAIRS of points is enough.  Had f split completely over Q_2 the group would be
\\ Z_2 x (Z/2)^2, three generators would be needed, and the argument would break.

cden(Q) = if (Q == [0], 0, sqrtint(denominator(Q[1])));
Ed(d)   = ellinit([d^2, d^3]);

\\ order of Pbar in E(Q_2)/E_2, and the depth of that multiple
ordv2(E, P, Q2) =
{ foreach (divisors(Q2), e,
    my(R = ellmul(E, P, e));
    if (R != [0] && valuation(cden(R), 2) >= 2,
      return([e, valuation(cden(R), 2)])));
  [0, 0];
}
kodname(k) =
{ if (k == 1, "I_0", if (k == 2, "II", if (k == 3, "III", if (k == 4, "IV",
    if (k == -1, "I_0*", if (k > 4, Str("I_", k-4), Str("code ", k)))))));
}

WIT = 0;
{
WIT = [[1, 1], [3, 3], [5, 5], [7, -1], [2, -30], [6, 6], [10, -6], [14, 30]];
}

print("=========================================================================");
print(" Extended certificate at p = 2  (section 3.2)");
print("=========================================================================");
print("");
print("E : v^2 = u^3 + u + 1 (496a).   E_d : Y^2 = X^3 + d^2 X + d^3.");
print("At p = 2 the formal group is E_2(Q_2) = Z_2, so the finite quotient is");
print("E(Q_2)/E_2 of order Q_2 = 2 M_2, and a point generates iff m = Q_2 and");
print("the depth v is exactly 2.  Closure index = (Q_2/m) 2^(v-2).");
print("");

{
print("(1) The model is minimal at 2 for every twist, so the denominator test is");
print("    the right one:");
print("");
print("      d       v_2(c_4)  v_2(Delta)   minimal at 2 ?");
foreach (WIT, t,
  my(E = Ed(t[2]), mm = ellminimalmodel(E));
  print("     ", t[2], "         ", valuation(E.c4, 2), "         ",
        valuation(E.disc, 2), "          ",
        if (E.disc == mm.disc, "yes", "NO")));
print("");
}

{
print("(2) Local data at 2, and the vanishing of the torsion:");
print("");
print("      class   d      type   c_2  a_2   M_2   Q_2   cubic over Q_2   T");
foreach (WIT, t,
  my(cl = t[1], d = t[2], E = Ed(d), lr = elllocalred(E,2), a = ellap(E,2));
  my(M2 = lr[4]*(2 - a), fp = factorpadic(x^3 + d^2*x + d^3, 2, 20));
  my(degs = [poldegree(g) | g <- fp[,1]~]);
  print("       ", cl, "      ", d, "     ", kodname(lr[2]), "     ", lr[4],
        "    ", a, "    ", M2, "     ", 2*M2, "    ", degs,
        if (#degs == 1, " irreducible", " REDUCIBLE"),
        "   ", if (M2 == 2^valuation(M2,2) && #degs == 1, "trivial", "??")));
print("");
print("    M_2 is a power of 2 in every line, so no odd torsion; the cubic is");
print("    irreducible over Q_2 in every line, so no 2-torsion.  Hence T = 1 and");
print("    E^d(Q_2) = Z_2 throughout -- no base, and no T-coordinate to record.");
print("");
}

{
print("(3) The certificate.  One line per (twist, generator); every twist here has");
print("    rank 1 and trivial torsion, so one line each.");
print("");
print("      class   d      E^d(Q_2)   x(P)                    (alpha; t)   m    v   index");
foreach (WIT, t,
  my(cl = t[1], d = t[2], E = Ed(d), lr = elllocalred(E,2));
  my(Q2 = 2*lr[4]*(2 - ellap(E,2)), g = ellrank(E));
  my(gens = concat(ellsaturation(E, g[4], 200), elltors(E)[3]));
  foreach (gens, P,
    my(r = ordv2(E, P, Q2), idx = if (r[1] == 0, -1, (Q2/r[1])*2^(r[2]-2)));
    print("       ", cl, "      ", d, "      Z_2       ", P,
          "        ( ", if (r[2] == 2, "u", Str("2^", r[2]-2, " u")), " ; - )    ",
          r[1], "    ", r[2], "    ", idx,
          if (idx == 1, "   generates", "   NOT full"))));
print("");
print("    Every line has m = Q_2 and v = 2, hence index 1: each class of");
print("    Q_2^*/(Q_2^*)^2 is covered by a single FULL twist, which is what");
print("    section 3.2 asserts.  Note that unlike the odd-p table there is no");
print("    hyperplane mechanism here and nothing to stack: one twist per class,");
print("    outright.");
print("");
}

print("done.");
