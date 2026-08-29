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
print("(1) is section 6: over a local field the residue IS the invariant, so it");
print("    must reproduce the Hilbert symbol -- and it does, with the sign");
print("    (-1)^(v(a)v(b)) exactly accounting for the (-1/p)^(ab) in the classical");
print("    formula.  (2) is the well-definedness of the symbol on K_2.  (3) is");
print("    Faddeev's exact sequence: the last map is a sum of corestrictions, and");
print("    reciprocity says the residues of a class on P^1 always cancel.  (4) is");
print("    the compatibility that makes 'cor preserves unramified' true, tested on");
print("    a degree-2 cover of the t-line ramified at 0 and infinity.  (5) is the");
print("    mechanism by which descent functions give unramified algebras.");
}
quit;
