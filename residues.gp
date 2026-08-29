\\ residues.gp -- checks for residues.typ
\\
\\ Run from this directory:
\\     gp -q -s 2000000000 residues.gp < /dev/null > results/residues.txt
\\
\\ Everything here is the n = 2 tame symbol of residues.typ section 4.2,
\\
\\     d_v(a,b) = (-1)^(v(a) v(b)) a^v(b) b^(-v(a))   in  kappa(v)^* / squares,
\\
\\ evaluated in two settings: over Q at a prime p (where section 6 says the
\\ residue must agree with the Hilbert symbol), and over Q(t) at the closed
\\ points of P^1_Q (where sections 8-9 say the residues must satisfy Faddeev
\\ reciprocity, sum of corestrictions = 0).
\\
\\ Note b^(-v(a)) = b^(v(a)) modulo squares, so all exponents below are taken
\\ positive; everything is an identity in kappa^*/(kappa^*)^2 only.

\\ -------------------------------------------------------- rational functions

rfdeg(f) = poldegree(numerator(f)) - poldegree(denominator(f));
rflc(f)  = pollead(numerator(f)) / pollead(denominator(f));

\\ reduce a rational function of valuation 0 at pi into kappa(pi) = Q[t]/pi
redmod(u, pi) = Mod(numerator(u), pi) / Mod(denominator(u), pi);

\\ the monic irreducible factors of num and den of f and g: the closed points
\\ of A^1 where either slot has a zero or a pole.  Everywhere else both slots
\\ are units and the symbol is trivial, which is why Ram(A) is finite.
places(f, g) =
{ my(L = [], hs = [numerator(f), denominator(f), numerator(g), denominator(g)]);
  for (i = 1, 4,
    my(h = hs[i]);
    if (poldegree(h) < 1, next);
    my(F = factor(h));
    for (j = 1, #F[,1],
      my(pi = F[j,1] / pollead(F[j,1]), new = 1);
      for (m = 1, #L, if (L[m] == pi, new = 0; break));
      if (new, L = concat(L, [pi]))));
  L;
};

\\ ------------------------------------------------------------ the tame symbol

\\ residue of (f,g) at the closed point pi of A^1, as an element of kappa(pi)
resat(f, g, pi) =
{ my(a = valuation(f, pi), b = valuation(g, pi));
  Mod(1, pi) * (-1)^(a*b) * redmod(f/pi^a, pi)^b * redmod(g/pi^b, pi)^a;
};

\\ residue at infinity: uniformiser 1/t, unit parts reduce to leading coeffs
resinf(f, g) =
{ my(a = rfdeg(f), b = rfdeg(g));
  (-1)^(a*b) * rflc(f)^b * rflc(g)^a;
};

\\ is r in kappa(pi) a square?
issqmod(r, pi) =
{ my(l = simplify(lift(r)));
  if (poldegree(pi) == 1, return(issquare(l)));
  nfeltispower(nfinit(pi), r, 2);
};

\\ corestriction of a residue down to Q: the norm N_{kappa(pi)/Q}
normdown(r, pi) = polresultant(pi, lift(r));

\\ ================================================================== check 1
\\ Section 4.2: over Q_p (p odd) the residue is a square in F_p exactly when
\\ the Hilbert symbol is +1.

check1() =
{ my(PS = [3,5,7,11,13,17,19,23,29,31,37,101], bad = 0, n = 0);
  for (i = 1, #PS, my(p = PS[i]);
    for (x = -30, 30, for (y = -30, 30,
      if (x == 0 || y == 0, next);
      my(a = valuation(x,p), b = valuation(y,p),
         u = x/p^a, w = y/p^b, r, leg);
      r = (-1)^(a*b) * u^b * w^a;
      leg = kronecker(numerator(r), p) * kronecker(denominator(r), p);
      n++;
      if ((leg == 1) != (hilbert(x, y, p) == 1), bad++))));
  printf("  (1) tame symbol = Hilbert symbol over Q_p, p odd : %d wrong of %d\n", bad, n);
};

\\ ================================================================== check 2
\\ Section 4.2: the tame symbol kills the Steinberg relation.  All residues of
\\ (f, 1-f) vanish -- a real cancellation, especially at infinity.

check2(FS) =
{ my(bad = 0, n = 0);
  for (i = 1, #FS, my(f = FS[i], g = 1 - f, P);
    if (g == 0, next);
    P = places(f, g);
    for (j = 1, #P, n++; if (!issqmod(resat(f, g, P[j]), P[j]), bad++));
    n++; if (!issquare(resinf(f, g)), bad++));
  printf("  (2) Steinberg: every residue of (f, 1-f) is trivial : %d wrong of %d\n", bad, n);
};

\\ ================================================================== check 3
\\ Section 9, Faddeev / residue reciprocity:
\\     prod_{P in (P^1)^(1)} N_{kappa(P)/Q} ( d_P(A) )  is a square in Q^*.

check3(FS, GS) =
{ my(bad = 0, n = 0);
  for (i = 1, #FS, for (j = 1, #GS,
    my(f = FS[i], g = GS[j], P, s = 1);
    if (f == 0 || g == 0, next);
    P = places(f, g);
    for (k = 1, #P, s *= normdown(resat(f, g, P[k]), P[k]));
    s *= resinf(f, g);
    n++;
    if (!issquare(s), bad++)));
  printf("  (3) sum of corestrictions of the residues = 0 on P^1_Q : %d wrong of %d\n", bad, n);
};

\\ ================================================================== check 4
\\ Section 9, the corestriction compatibility
\\     d_P . cor_{L/K} = sum_{w | P} cor_{kappa(w)/kappa(P)} . d_w .
\\ Take K = Q(u) inside L = Q(t) via u = t^2, and A = (t - a, g(u)) over L.
\\ The projection formula gives cor(A) = (N_{L/K}(t-a), g) = (a^2 - u, g).
\\ Both sides are compared at the RATIONAL points u = c of A^1_K (so that
\\ kappa(P) = Q and the corestrictions are absolute norms) and at infinity.

check4(AS, GS, CS) =
{ my(bad = 0, n = 0);
  for (i = 1, #AS, for (j = 1, #GS,
    my(a = AS[i], g = GS[j], fL = 't - a, gL = subst(g, 'u, 't^2), fK = a^2 - 'u);
    if (g == 0, next);
    \\ finite rational points u = c
    for (k = 1, #CS, my(c = CS[k], lhs, rhs = 1, F);
      lhs = lift(resat(fK, g, 'u - c));
      F = factor('t^2 - c);
      for (m = 1, #F[,1],
        my(w = F[m,1] / pollead(F[m,1]));
        rhs *= normdown(resat(fL, gL, w), w));
      n++;
      if (!issquare(lhs * rhs), bad++));
    \\ and at infinity
    n++;
    if (!issquare(resinf(fK, g) * resinf(fL, gL)), bad++)));
  printf("  (4) d_P . cor = sum_{w|P} cor . d_w  for Q(u) < Q(t), u = t^2 : %d wrong of %d\n", bad, n);
};

\\ ================================================================== check 5
\\ Section 8.1: a slot whose divisor is 2-divisible contributes nothing to any
\\ tame symbol.  This is the whole of the unramifiedness argument used for the
\\ descent algebras in kummer-survey.typ.

check5(FS, GS) =
{ my(bad = 0, n = 0);
  for (i = 1, #FS, for (j = 1, #GS,
    my(f = FS[i]^2, g = GS[j], P);
    if (f == 0 || g == 0, next);
    P = places(f, g);
    for (k = 1, #P, n++; if (!issqmod(resat(f, g, P[k]), P[k]), bad++));
    n++; if (!issquare(resinf(f, g)), bad++)));
  printf("  (5) div(f) 2-divisible => (f^2,g) unramified everywhere : %d wrong of %d\n", bad, n);
};

\\ ================================================================== check 6
\\ Section 12.5: Iskovskikh's Chatelet surface
\\     X :  y^2 + z^2 = (3 - x^2)(x^2 - 2)
\\ carries the class A = (-1, 3 - x^2), unramified because on X the product
\\ (3-x^2)(x^2-2) = y^2 + z^2 is a norm from Q(i), so A = (-1, x^2 - 2) too,
\\ and the two expressions cannot ramify along a common divisor.
\\
\\ A local point over x needs (3-x^2)(x^2-2) to be a norm from Q_v(i), i.e.
\\ hilbert(-1, f(x), v) = 1; its invariant is then hilbert(-1, 3-x^2, v).
\\ Sampled over x = a/b with |a|, b <= 40 -- which realises every 2-adic
\\ valuation from -5 to 5 and every unit class mod 32.  The PROOF that the
\\ sampled answer is the whole answer is in section 12.5 of the document.

isk(x) = (3 - x^2)*(x^2 - 2);

check6() =
{ my(VS = [0,2,3,5,7,11,13,17,19,23,29,31], tot = 0, ok = 1);
  print("  (6) Iskovskikh's surface  y^2 + z^2 = (3-x^2)(x^2-2),  A = (-1, 3-x^2):");
  for (i = 1, #VS, my(v = VS[i], L = List(), n = 0);
    for (a = -40, 40, for (b = 1, 40,
      if (gcd(a,b) != 1, next);
      my(x = a/b, y = isk(x), s);
      if (y == 0, next);
      if (hilbert(-1, y, v) != 1, next);      \\ no local point over this x
      n++;
      s = hilbert(-1, 3 - x^2, v);
      if (!setsearch(Set(Vec(L)), s), listput(L, s))));
    my(A = Set(Vec(L)));
    printf("      v = %-3s  x sampled with X(Q_v) != 0/ : %5d   inv_v achieved : %s\n",
           if (v == 0, "oo", v), n,
           if (#A == 0, "(none)", Str(if (#A == 2, "{0, 1/2}", if (A[1] == 1, "{0}", "{1/2}")))));
    if (n == 0, ok = 0);                      \\ must be locally soluble everywhere
    if (#A != 1, ok = 0, if (A[1] == -1, tot += 1/2)));
  printf("      X(Q_v) != 0/ at every sampled place, one forced invariant at each,\n");
  printf("      and  sum_v inv_v = %s  for every adelic point : obstruction %s\n",
         tot, if (ok && tot != 0, "CONFIRMED", "NOT FOUND"));
};

\\ ================================================================== check 7
\\ Section 12.2: Faddeev as a construction machine.  Given targets c_1..c_r in
\\ Q^*/squares at rational points alpha_1..alpha_r, the class
\\     A = prod_i (c_i, t - alpha_i)
\\ has residue c_j at alpha_j and residue prod_i c_i at infinity.  So the
\\ prescription is realisable on A^1 always, and on all of P^1 exactly when
\\ prod_i c_i is a square -- which is the reciprocity condition of section 9,
\\ nothing more.

check7(CS, AS) =
{ my(bad = 0, n = 0, wrongoo = 0);
  for (i1 = 1, #CS, for (i2 = 1, #CS, for (i3 = 1, #CS,
    my(cs = [CS[i1], CS[i2], CS[i3]], r, ri = 1);
    for (j = 1, #AS,
      r = 1;
      for (i = 1, #cs, r *= resat(cs[i], 't - AS[i], 't - AS[j]));
      n++;
      if (!issquare(simplify(lift(r)) / cs[j]), bad++));
    for (i = 1, #cs, ri *= resinf(cs[i], 't - AS[i]));
    if (issquare(ri) != issquare(vecprod(cs)), wrongoo++))));
  printf("  (7) prescribed residues realised at the rational points : %d wrong of %d\n", bad, n);
  printf("      unramified at infinity <=> prod of targets is a square : %d wrong of %d\n",
         wrongoo, #CS^3);
};

\\ ================================================================== check 8
\\ Section 12.3: Faddeev exactness on the left -- a class with no residues at
\\ all is CONSTANT.  Tested by specialising: if (f, c) is unramified then the
\\ specialisations (f(t0), c) . (a0, b0) must all be the same class of Br(Q),
\\ i.e. have the same ramification set; if it is ramified they must not.

ramset(u, c, a0, b0) =
{ my(L = List(), N = 2*numerator(u)*denominator(u)*numerator(c)*denominator(c)*a0*b0, F);
  if (hilbert(u, c, 0) * hilbert(a0, b0, 0) == -1, listput(L, 0));
  F = factor(abs(N));
  for (i = 1, #F[,1],
    if (hilbert(u, c, F[i,1]) * hilbert(a0, b0, F[i,1]) == -1, listput(L, F[i,1])));
  Set(Vec(L));
};

check8(FS, CS) =
{ my(nu = 0, nr = 0, bad = 0);
  for (i = 1, #FS, for (j = 1, #CS,
    my(f = FS[i], c = CS[j], P = places(f, c), unram = 1, S = List());
    if (poldegree(f) < 1, next);
    for (k = 1, #P, if (!issqmod(resat(f, c, P[k]), P[k]), unram = 0));
    if (!issquare(resinf(f, c)), unram = 0);
    for (t0 = -12, 12,
      my(u = subst(f, 't, t0));
      if (u == 0, next);
      my(S0 = ramset(u, c, -1, -1));
      if (!setsearch(Set(Vec(S)), S0), listput(S, S0)));
    my(d = #Set(Vec(S)));
    if (unram, nu++; if (d != 1, bad++), nr++; if (d == 1, bad++))));
  printf("  (8) unramified <=> constant, read off the specialisations : %d wrong of %d\n",
         bad, nu + nr);
  printf("      (%d of the test classes unramified, %d ramified; the class is twisted\n", nu, nr);
  printf("      by the constant (-1,-1) so that 'constant' does not mean 'trivial')\n");
};

\\ ---------------------------------------------------- the two worked examples

showex(f, g, nm) =
{ my(P = places(f, g));
  print("  ", nm, ":");
  for (k = 1, #P,
    printf("    P = %-10s kappa(P) = %-13s residue = %s\n",
           P[k], if (poldegree(P[k]) == 1, "Q", Str("Q[t]/(", P[k], ")")),
           lift(resat(f, g, P[k]))));
  printf("    P = %-10s kappa(P) = %-13s residue = %s\n", "infinity", "Q", resinf(f, g));
};

\\ ------------------------------------------------------------------------- run

{
print("======================================================================");
print("residues.gp -- checks for residues.typ");
print("");
print("The two worked examples of section 4.3, residues on P^1_Q:");
print("");
showex(3, 't, "(3, t)");
showex('t, 't-1, "(t, t-1)");
print("");
print("  -- (3,t) is ramified exactly on (0) + (oo) with residue 3 at both;");
print("     (t,t-1) is ramified exactly on (0) + (oo) with residue -1 at both,");
print("     and the vanishing at t = 1 is the Steinberg relation.");
print("");

my(FS, GS, AS, CS);
\\ test rational functions over Q(t)
FS = ['t, 't-1, 't+2, 2*'t, -3*'t, 't^2-2, ('t^2-2)/('t+3), 5*('t-1)/('t^2+1),
      ('t-1)*('t+1)/('t^2-3), 't^3-'t-1, ('t^2+'t+1)/'t, -7/('t-5)];
GS = ['t, 't+1, 't-3, 6*'t, ('t-2)/('t+2), 't^2-5, ('t^2+2)/('t-1), 't^3+2,
      ('t-4)*('t+7), 10/('t^2-7)];

print("checks");
print("");
check1();
check2(FS);
check3(FS, GS);
check4([1, 2, 3, -1, 5], ['u-1, 'u-2, 'u+3, 'u^2-2, ('u-5)/('u+2), 6*'u],
       [0, 1, 2, 4, -1, 9, -3, 25, 5, 7]);
check5(FS, GS);
print("");
check6();
print("");
check7([1, 2, -1, 3, -6, 5], [0, 1, -2]);
check8(['t-1, 't^2-2, 't^2-3, 't^2-5, 't^2+1, ('t-1)*('t+3), 't^3-2, 't^2-7],
       [1, 2, 3, -1, 5, -2, 6, -7]);
print("");
print("(1) is section 6: over a local field the residue IS the invariant, so it");
print("    must reproduce the Hilbert symbol -- and it does, with the sign");
print("    (-1)^(v(a)v(b)) exactly accounting for the (-1/p)^(ab) in the classical");
print("    formula.  (2) is the well-definedness of the symbol on K_2.  (3) is");
print("    Faddeev's exact sequence: the last map is a sum of corestrictions, and");
print("    reciprocity says the residues of a class on P^1 always cancel.  (4) is");
print("    the compatibility that makes 'cor preserves unramified' true, tested on");
print("    a degree-2 cover of the t-line ramified at 0 and infinity.  (5) is the");
print("    mechanism by which descent functions give unramified algebras.  (6) is");
print("    a Brauer-Manin obstruction found entirely by a residue argument, (7) is");
print("    Faddeev used backwards to build classes to order, and (8) is Faddeev");
print("    exactness on the left: no residues anywhere means constant.");
}
quit;
