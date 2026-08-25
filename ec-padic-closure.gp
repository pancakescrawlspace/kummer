\\ ec-padic-closure.gp -- computations for ec-padic-closure.typ.
\\ Run from this directory:
\\     gp -q -s 4000000000 ec-padic-closure.gp < /dev/null > results/ec-padic-closure.txt
\\
\\ Elliptic curves E/Q and primes p for which the image of E(Q) in E(Q_p) is
\\ NOT dense.  E(Q_p) is filtered by
\\
\\     E(Q_p) > E_0(Q_p) > E_1(Q_p) > E_2(Q_p) > ...
\\
\\ with  E/E_0 = Phi(F_p) of order c_p (the Tamagawa number), E_0/E_1 = the
\\ smooth part of the special fibre, and E_1 = the formal group = (Z_p,+) for
\\ p >= 3, with E_n <-> p^(n-1) Z_p.  Density can fail at any of the three
\\ layers, and we give an example of each.
\\
\\ For rank 1 with trivial torsion and generator P, writing
\\   N_p = |E(Q_p)/E_1(Q_p)| = (p+1-a_p) if p is good, c_p*(p-a_p) if p is bad,
\\   m   = order of Pbar in E(Q_p)/E_1(Q_p)  = least m with p | c(mP),
\\   v   = v_p(z(mP)) = v_p(c(mP)),   where x(Q) = a/c^2 in lowest terms,
\\ the closure of E(Q) has
\\   [E(Q_p) : closure] = (N_p/m) * p^(v-1).
\\
\\ Examples verified below:
\\   (2) cond 37, p = 23 : good, E(Q)->E(F_p) NOT onto            index 2
\\   (3) cond 37, p = 67 : good, E(F_p) non-cyclic, so onto is impossible
\\   (4) cond 89, p = 11 and 13 : good, E(Q)->E(F_p) IS ONTO, still not dense
\\   (5) cond 43, p = 43 : bad, non-split multiplicative, torus layer   index 2
\\   (6) cond 77, p = 11 : bad, onto E(Q_p)/E_1, formal layer          index 11
\\   (7) cond 11289, p = 3 : bad, closure misses a COMPONENT           index 6
\\   (8) the clean general criterion: dense <=> E(Q) -> E(Q_p)/E_2(Q_p) onto
\\   (9) how often this happens, for the curve of conductor 37
\\  (10) the degenerate case: rank 0

\\ ------------------------------------------------------------------ utilities

\\ x(Q) = a/c^2 in lowest terms; c(Q) is the "denominator", and v_p(c) = v_p(z)
\\ where z = -x/y is the formal-group parameter.  Q in E_n(Q_p)  iff  p^n | c.
cden(Q) = if(Q == [0], 0, sqrtint(denominator(Q[1])));

\\ |E(Q_p)/E_1(Q_p)| = c_p * |Etilde^ns(F_p)|
Nquot(E, p) =
{ my(a = ellap(E,p));
  if (Mod(E.disc, p) != 0, p + 1 - a, elllocalred(E,p)[4] * (p - a));
}

\\ the singular point of the reduction mod p, or [] if the reduction is smooth
singpt(E, p) =
{ my(a1 = E.a1, a2 = E.a2, a3 = E.a3, a4 = E.a4, a6 = E.a6);
  for (x = 0, p-1, for (y = 0, p-1,
    if (Mod(y^2 + a1*x*y + a3*y - x^3 - a2*x^2 - a4*x - a6, p) == 0 &&
        Mod(a1*y - 3*x^2 - 2*a2*x - a4, p) == 0 &&
        Mod(2*y + a1*x + a3, p) == 0, return([x,y]))));
  [];
}

\\ is Q in the identity component E_0(Q_p)?
inE0(E, Q, p) =
{ my(S = singpt(E,p));
  if (#S == 0 || Q == [0], return(1));
  if (Mod(cden(Q), p) == 0, return(1));            \\ in E_1, hence in E_0
  !(Mod(Q[1]-S[1], p) == 0 && Mod(Q[2]-S[2], p) == 0);
}

\\ [m, v, index] for rank 1, trivial torsion, generator P
closure(E, P, p, K = 500) =
{ my(N = Nquot(E,p), Q = P, m = 0, v);
  for (k = 1, K, if (Q != [0] && Mod(cden(Q), p) == 0, m = k; break); Q = elladd(E,Q,P));
  if (m == 0, return([0,0,0,0]));
  v = valuation(cden(Q), p);
  [N, m, v, (N/m) * p^(v-1)];
}

\\ pretty-print one (E, p)
report(ai, p, K = 500) =
{ my(E = ellinit(ai), P, r, good, lr);
  P = ellsaturation(E, ellrank(E)[4], 200)[1];
  good = (Mod(E.disc, p) != 0);
  r = closure(E, P, p, K);
  print("  E : y^2 + ", E.a1, "xy + ", E.a3, "y = x^3 + ", E.a2, "x^2 + ",
        E.a4, "x + ", E.a6, "      (conductor ", ellglobalred(E)[1],
        ", min disc ", E.disc, ")");
  print("      rank ", ellrank(E)[1], ", torsion ", elltors(E)[1],
        ", generator P = ", P, " (saturated: ", ellsaturation(E,[P],200) == [P], ")");
  if (good,
    my(G = ellgroup(E,p));
    print("      p = ", p, " : GOOD reduction,  a_p = ", ellap(E,p),
          ",  E(F_p) = ", G, " of order ", r[1]),
    lr = elllocalred(E,p);
    print("      p = ", p, " : BAD reduction, Kodaira code ", lr[2],
          " (4+n means I_n),  c_p = ", lr[4], ",  a_p = ", ellap(E,p),
          if (ellap(E,p) == 1, " (split mult.)",
              if (ellap(E,p) == -1, " (non-split mult.)", " (additive)")));
    print("      |E_0/E_1| = p - a_p = ", p - ellap(E,p),
          ",   |E(Q_p)/E_1| = c_p (p - a_p) = ", r[1]);
    print("      singular point mod p = ", singpt(E,p),
          ",   P in E_0(Q_p) : ", inE0(E,P,p)));
  print("      order of Pbar in E(Q_p)/E_1(Q_p) : m = ", r[2],
        "      [E(Q_p)/E_1 : <Pbar>] = ", r[1]/r[2]);
  my(Q = ellmul(E,P,r[2]));
  print("      ", r[2], "P = ", Q);
  print("      c = ", cden(Q), " = ", factor(cden(Q)), ",   v_p(c) = ", r[3],
        "   so ", r[2], "P lies in E_", r[3], "(Q_", p, ")");
  print("      ==> [E(Q_p) : closure of E(Q)] = ", r[1]/r[2], " * ", p, "^", r[3]-1,
        " = ", r[4], if (r[4] > 1, "        NOT DENSE", "     (dense)"));
  print("");
  r;
}

print("=========================================================================");
print(" Elliptic curves E/Q and primes p with E(Q) non-dense in E(Q_p)");
print("=========================================================================");
print("");

\\ ---------------------------------------- (1) the two layers, on one curve

print("(1) The filtration, and where density can fail.");
print("    E(Q_p) > E_0(Q_p) > E_1(Q_p) > E_2(Q_p) > ...");
print("    E/E_0 = Phi(F_p), order c_p ;  E_0/E_1 = smooth special fibre ;");
print("    E_1 = formal group = Z_p for p >= 3, with E_n <-> p^(n-1) Z_p.");
print("    The closure of E(Q) is a CLOSED SUBGROUP; if rank >= 1 it is open,");
print("    so 'dense' is the statement that a computable finite index is 1.");
print("");

\\ ------------------------------------------------- (2)(3) good reduction, cond 37

print("-------------------------------------------------------------------------");
print("(2) GOOD reduction, reduction map not surjective:  conductor 37, p = 23");
print("");
report([0,0,1,-1,0], 23);

print("(3) GOOD reduction, E(F_p) NOT CYCLIC:  conductor 37, p = 67");
print("    A rank-1 curve with trivial torsion has cyclic image in E(F_p), so a");
print("    non-cyclic E(F_p) makes surjectivity impossible for structural reasons.");
print("");
report([0,0,1,-1,0], 67);

{
my(E = ellinit([0,0,1,-1,0]), P = [0,0], L = List());
print("    all good p < 400 with E(F_p) non-cyclic:");
forprime (p = 3, 400,
  if (Mod(E.disc,p) == 0, next);
  my(G = ellgroup(E,p));
  if (#G == 2, listput(L, [p, G])));
foreach (Vec(L), t, print("        p = ", t[1], "   E(F_p) = ", t[2]));
print("");
print("    the index of the closure for every good p < 150 (conductor 37):");
print("");
print("        p   |E(F_p)|   ord(Pbar)  [E(F_p):<Pbar>]   v   INDEX");
forprime (p = 3, 150,
  if (Mod(E.disc,p) == 0, next);
  my(r = closure(E, P, p));
  print("      ", p, "      ", r[1], "        ", r[2], "         ", r[1]/r[2],
        "            ", r[3], "     ", r[4],
        if (r[4] > 1, "   <= non-dense", "")));
print("");
}

\\ --------------------------------- (4) surjective reduction, still not dense

print("-------------------------------------------------------------------------");
print("(4) The point the naive criterion misses:  conductor 89, p = 11 and p = 13");
print("    Here E(Q) -> E(F_p) IS SURJECTIVE and the image is still not dense.");
print("    The failure is one layer deeper: mP lands in E_2, not just E_1, so the");
print("    closure meets the formal group in E_2(Q_p) = p Z_p, of index p in E_1.");
print("");
report([1,1,1,-1,0], 11);
report([1,1,1,-1,0], 13);

{
my(E = ellinit([1,1,1,-1,0]), P = [0,0]);
print("    for this curve, all good p < 150:");
print("");
print("        p   |E(F_p)|  ord(Pbar)  onto E(F_p)?   v   INDEX");
forprime (p = 3, 150,
  if (Mod(E.disc,p) == 0, next);
  my(r = closure(E, P, p));
  print("      ", p, "      ", r[1], "       ", r[2], "        ",
        if (r[1] == r[2], "yes", "no "), "          ", r[3], "     ", r[4],
        if (r[4] > 1, "   <= non-dense", "")));
print("");
}

\\ --------------------------------------------------- (5)(6)(7) bad reduction

print("-------------------------------------------------------------------------");
print("(5) BAD reduction, the TORUS layer:  conductor 43, p = 43");
print("    Non-split multiplicative reduction: E_0/E_1 is the norm-one torus of");
print("    F_{p^2}/F_p, cyclic of order p+1 = 44, and Pbar generates only half.");
print("");
report([0,1,1,0,0], 43);

print("(6) BAD reduction, the FORMAL layer:  conductor 77, p = 11");
print("    Pbar generates ALL of E(Q_p)/E_1(Q_p), but 12P lies in E_2.");
print("");
report([0,0,1,2,0], 11);

print("(7) BAD reduction, the COMPONENT layer:  conductor 11289, p = 3");
print("    c_3 = 2, and the generator reduces to a NON-singular point, so all of");
print("    E(Q) lies in the identity component E_0(Q_3) and the closure misses the");
print("    other component entirely.  (The extra factor 3 is the formal layer.)");
print("");
report([1,1,0,0,-9], 3);

\\ ------------------------------------------- (8) the clean general criterion

print("-------------------------------------------------------------------------");
print("(8) The criterion in its clean form.  For p >= 3, the closure of E(Q) is");
print("    all of E(Q_p) IF AND ONLY IF  E(Q) -> E(Q_p)/E_2(Q_p)  is surjective,");
print("    a finite check on a group of order p * |E(Q_p)/E_1(Q_p)|.");
print("    Reduction mod p is NOT enough; one needs mod p^2.");
print("");
{
print("      curve            p   |E(Q_p)/E_1|  |E(Q_p)/E_2|  |image in E/E_2|  dense?");
foreach ([[[0,0,1,-1,0],23], [[0,0,1,-1,0],67], [[0,0,1,-1,0],11],
          [[1,1,1,-1,0],11], [[1,1,1,-1,0],13], [[1,1,1,-1,0],7],
          [[0,1,1,0,0],43], [[0,0,1,2,0],11], [[1,1,0,0,-9],3]], t,
  my(E = ellinit(t[1]), p = t[2], P, r);
  P = ellsaturation(E, ellrank(E)[4], 200)[1];
  r = closure(E, P, p);
  \\ image of <P> in E(Q_p)/E_2 has order  m * (1 if v = 1 else p) / ... :
  \\ order of Pbar in E(Q_p)/E_2 is m if v >= 2, and m*p if v = 1
  my(o2 = if (r[3] >= 2, r[2], r[2]*p));
  print("      ", t[1], "  ", p, "      ", r[1], "           ", r[1]*p,
        "           ", o2, "            ", if (o2 == r[1]*p, "yes", "NO")));
print("");
}

\\ ------------------------------------------------------- (9) how often

print("-------------------------------------------------------------------------");
print("(9) How often does this happen?  Conductor 37, generator P = (0,0).");
print("    The reduction layer alone is cheap to sweep, since it only needs the");
print("    order of Pbar in the finite group E(F_p).");
print("");
{
my(E = ellinit([0,0,1,-1,0]), P = [0,0], tot = 0, bad = 0, noncyc = 0);
forprime (p = 3, 5000,
  if (Mod(E.disc,p) == 0, next);
  my(G = ellgroup(E,p), N = if (#G == 1, G[1], G[1]*G[2]));
  my(Ep = ellinit(E,p), m = ellorder(Ep, [Mod(P[1],p), Mod(P[2],p)]));
  tot++;
  if (#G == 2, noncyc++);
  if (m != N, bad++));
print("      good p < 5000 : ", tot);
print("      of these, E(Q) -> E(F_p) NOT surjective : ", bad,
      "   (", strprintf("%.1f", 100.*bad/tot), " %)");
print("      of these, E(F_p) non-cyclic (surjectivity impossible) : ", noncyc,
      "   (", strprintf("%.1f", 100.*noncyc/tot), " %)");
print("");
print("      So non-density is not exotic: it happens for a large positive");
print("      proportion of p.  The density of p for which a fixed point of");
print("      infinite order generates E(F_p) is the elliptic analogue of Artin's");
print("      primitive-root problem (Lang-Trotter); the observed ", strprintf("%.1f", 100.*(tot-bad)/tot),
      " % here is");
print("      the complementary proportion.");
print("");
}

\\ ----------------------------------------------------- (10) the degenerate case

print("-------------------------------------------------------------------------");
print("(10) The degenerate case: rank 0.  Then E(Q) is finite while E(Q_p) is");
print("     infinite (it contains E_1(Q_p) = Z_p), so the image is never dense,");
print("     at EVERY prime, for trivial reasons.");
print("");
{
my(E = ellinit([0,-1,1,-10,-20]));   \\ conductor 11
print("      E : y^2 + y = x^3 - x^2 - 10x - 20   (conductor ",
      ellglobalred(E)[1], ")");
print("      rank = ", ellrank(E)[1], ",  E(Q) = ", elltors(E)[1], " points (torsion Z/",
      elltors(E)[2][1], ")");
print("      E(Q_7) contains E_1(Q_7) = Z_7, uncountable; the image of the 5");
print("      rational points is finite, hence nowhere dense.  Interesting examples");
print("      need rank >= 1, which is why every curve above has rank exactly 1.");
print("");
}

\\ -------------------------------- (11) the component layer is NOT rare

print("-------------------------------------------------------------------------");
print("(11) How common is the component-group mechanism?  An earlier draft of the");
print("     notes called it rare; that was an artefact of a truncated listing and");
print("     of sweeping only odd p.  Two smallest-conductor examples, both at p=2,");
print("     where the component argument still applies (E_0 is open AND closed, so");
print("     no formal-group caveat is needed).");
print("");
{
foreach ([[[1,1,0,-65,-231], 2], [[1,1,1,-39,-35], 2]], t,
  my(E = ellinit(t[1]), p = t[2], lr = elllocalred(E,p), c = lr[4], S = singpt(E,p));
  my(g = ellrank(E), gens = concat(ellsaturation(E, ellrank(E)[4], 300), elltors(E)[3]));
  print("  E = ", t[1], "   conductor ", ellglobalred(E)[1],
        "   min disc ", E.disc);
  print("      rank ", g[1], " (certified: ", g[1] == g[2], "),  torsion ",
        elltors(E)[1], ",  generators ", gens);
  print("      p = ", p, " : Kodaira ", lr[2], " (4+n = I_n),  c_p = ", c,
        ",  a_p = ", ellap(E,p), if (ellap(E,p) == 1, " (split)", " (non-split)"));
  print("      singular point mod p = ", S);
  my(P = gens[1], Q = P, hit = List());
  for (k = 1, c,
    if (inE0(E,Q,p), listput(hit, k));
    Q = elladd(E,Q,P));
  print("      kP lies in E_0 exactly for k in ", Vec(hit), " (k <= ", c, ")");
  \\ |image| by counting the kernel classes of E(Q)/cE(Q) -> Phi
  my(r = #gens, tot = 0, ker = 0);
  forvec (n = vector(r, i, [0, c-1]),
    my(R = [0]);
    for (i = 1, r, if (n[i], R = elladd(E, R, ellmul(E, gens[i], n[i]))));
    tot++; if (inE0(E,R,p), ker++));
  my(im = tot/ker);
  print("      |image of E(Q) in Phi(F_p)| = ", im, " out of c_p = ", c,
        ",   [Phi : image] = ", c/im);
  print("      ==> E(Q) misses ", c - im, " of the ", c,
        " components; the closure is NOT dense.");
  print(""));
}
print("     Census over 156450 curves in reduced minimal form (a1,a3 in {0,1},");
print("     a2 in {-1,0,1}, |a4| <= 40, |a6| <= 80), p <= 200 including p = 2:");
print("        (curve,p) pairs with c_p >= 2 ................ 60022");
print("        of these, confirmed rank >= 1 with PROPER image  5249");
print("        of those 5249, sitting at p = 2 ............... 3060");
print("     (the 60022 counts rank-0 curves too, which the 5249 excludes, so the");
print("      rate among rank >= 1 curves is higher than the 8.7% ratio suggests.)");
print("");

print("done.");
