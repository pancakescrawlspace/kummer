\\ plusminus-cube.gp -- checks for plusminus-cube.typ
\\
\\ Run from this directory:
\\     gp -q -s 8000000000 plusminus-cube.gp < /dev/null \
\\         > results/plusminus-cube.txt
\\
\\ The pair  E : y^2 = x^3 - a^3  and  E' : y^2 = x^3 + a^3,  a an odd prime.
\\ E' is the quadratic twist of E by -1, and here that holds GLOBALLY:
\\ E'_d = E_{-d}, since -a^3(-d)^3 = a^3 d^3.  Both curves have a RATIONAL
\\ 2-torsion point, since x^3 -+ a^3 = (x -+ a)(x^2 +- a x + a^2), and both
\\ 2-division fields are Q(zeta_3) -- the quadratic factor has discriminant
\\ -3a^2.  So E[2] = E'[2] as Galois modules, but the module is F_2[C_2] with
\\ a rational point, NOT the S_3-module of kummer-example-j0.typ.
\\
\\ The density tests are the repository's own single-curve ones from
\\ kummer2.gp / p2.gp, applied twice -- once to each curve.

read("p2.gp");

{gens(E) = my(r = ellrank(E), P = r[4]);
  if(#P == 0 && r[1] == 1, P = [ellheegner(E)]);
  if(#P == 0, [], ellsaturation(E,P,40));}
{allpts(E) = concat(gens(E), elltors(E)[3]);}
{dense(E,p) = my(v, Em = ellminimalmodel(E,&v),
                 P = apply(Q -> ellchangepoint(Q,v), allpts(E)));
  if(#P == 0, 0, if(p == 2, densegroup2(Em,P), densegroup(Em,P,p)));}

Emin(a,d) = ellinit([0,0,0,0, -a^3*d^3]);
Epls(a,d) = ellinit([0,0,0,0,  a^3*d^3]);

\\ ---------------------------------------------------------------- check 1
\\ The pair itself: conductors, ranks, torsion, non-isogeny, and the split
\\ of the 2-division polynomial.

check1() =
{ printf("  (1) the pair, for small odd primes a\n");
  printf("      %-5s %-9s %-9s %-7s %-9s %-11s %s\n",
         "a","N(E)","N(E')","ranks","torsion","isogenous?","2-division field");
  foreach([3,5,7,11,13], a,
    my(E = Emin(a,1), F = Epls(a,1), iso = 1, q = 5);
    while (q < 400, if (a%q, if (ellap(E,q) != ellap(F,q), iso = 0; break)); q = nextprime(q+1));
    printf("      %-5d %-9d %-9d %d, %-4d %-9s %-11d Q(zeta_3), disc = %d\n",
           a, ellglobalred(E)[1], ellglobalred(F)[1],
           ellrank(E)[1], ellrank(F)[1], Str(elltors(E)[2]), iso, -3*a^2));
};

\\ ---------------------------------------------------------------- check 2
\\ Root numbers.  w(E_d) w(E'_d) = +1 for every odd d and -1 for every even d.
\\ So on the even square classes one curve always has odd analytic rank and
\\ the other needs rank >= 2 -- which is what makes the even classes sparse,
\\ and what the deep scan of check 4 has to fight through.

check2(B) =
{ printf("  (2) root numbers of the pair, by parity of d, |d| <= %d\n", B);
  printf("      %-5s %-24s %s\n", "a", "odd d: w.w' = +1 / -1", "even d: +1 / -1");
  foreach([3,5,7,11], a,
    my(o = [0,0], e = [0,0]);
    for (k = 1, B, foreach([k,-k], d,
      if (core(abs(d)) != abs(d), next);
      my(w = ellrootno(Emin(a,d)) * ellrootno(Epls(a,d)));
      if (d % 2, if (w == 1, o[1]++, o[2]++), if (w == 1, e[1]++, e[2]++))));
    printf("      %-5d %-24s %s\n", a, Str(o[1], " / ", o[2]), Str(e[1], " / ", e[2])));
};

\\ ---------------------------------------------------------------- check 3
\\ The scan at every odd p <= 19.  One twist per square class suffices, so a
\\ full row means X(Q) is dense in X(Q_p) for that p.

check3(a, B, ps) =
{ my(L = List());
  for (k = 1, B, foreach([k,-k], d,
    if (core(abs(d)) != abs(d), next);
    if (ellrank(Emin(a,d))[1] < 1, next);
    if (ellrank(Epls(a,d))[1] < 1, next);
    listput(L, d)));
  printf("      a = %d : %d twists |d| <= %d with both ranks positive\n", a, #L, B);
  foreach(ps, p,
    my(wit = vector(4), got = 0);
    foreach(Vec(L), d,
      my(c = sqclass(d,p) + 1);
      if (wit[c], next);
      if (dense(Emin(a,d),p) && dense(Epls(a,d),p), wit[c] = d));
    for (c = 1, 4, if (wit[c], got++));
    printf("        p = %-3d : %d of 4  ", p, got);
    for (c = 1, 4, printf("[%s]=%s ", sqclassname(c-1,p), if (wit[c], Str(wit[c]), "--")));
    printf("\n"));
};

\\ ---------------------------------------------------------------- check 4
\\ THE DEEP SCAN AT p = 2.  Steered by check 2: on an even class one curve has
\\ w = -1 (odd analytic rank) and the other w = +1, so the binding constraint
\\ is rank >= 2 on the w = +1 curve.  Test that first and skip otherwise;
\\ ellrank on the partner and the density test run only on survivors.

check4(a, B, step) =
{ my(wit = vector(8), got = 0, cand = 0, both = 0, n = 0, f = 0);
  printf("  (4) deep scan at p = 2 for a = %d, squarefree |d| <= %d\n", a, B);
  for (k = 1, B,
    foreach([k,-k], d,
      if (core(abs(d)) == abs(d),
        n++;
        my(c = sqclass2(d) + 1);
        if (!wit[c],
          my(E = Emin(a,d), F = Epls(a,d), w1 = ellrootno(E), G, H, ok = 1);
          if (d % 2 == 0,
            G = if (w1 == 1, E, F); H = if (w1 == 1, F, E);
            if (ellrank(G)[1] < 2, ok = 0, cand++; if (ellrank(H)[1] < 1, ok = 0, both++))
          ,
            if (ellrank(E)[1] < 1 || ellrank(F)[1] < 1, ok = 0)
          );
          if (ok, if (dense(E,2) && dense(F,2), wit[c] = d)));
        if (step && n % step == 0,
          f = 0; for (c2 = 1, 8, if (wit[c2], f++));
          printf("        ... %6d twists, %4d rank>=2 candidates, %d of 8 classes filled\n",
                 n, cand, f)))));
  for (c = 1, 8, if (wit[c], got++));
  printf("      %d squarefree twists scanned; %d even ones with rank >= 2 on the\n", n, cand);
  printf("      even-root-number curve, %d of those with both ranks positive\n", both);
  printf("      %d of 8 square classes covered:\n", got);
  for (c = 1, 8, printf("        [%-3s] : %s\n", sqclass2name(c-1),
                        if (wit[c], Str("d = ", wit[c]), "none")));
  got;
};

print("======================================================================");
print("plusminus-cube.gp -- y^2 = x^3 -+ a^3, and the 2-adic gap");
print("");
check1(); print("");
check2(200); print("");
print("  (3) the scan at the odd primes p <= 19");
check3(3, 150, [3,5,7,11,13,17,19]);
check3(5, 150, [3,5,7,11,13,17,19]);
check3(7, 150, [3,5,7,11,13,17,19]);
print("");
check4(3, 3000, 500); print("");
check4(5, 3000, 500); print("");
check4(7, 3000, 500); print("");
print("======================================================================");
