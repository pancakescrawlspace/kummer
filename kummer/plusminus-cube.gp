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

Emin(a,d) = ellinit([0,0,0,0, -a^3*d^3]);
Epls(a,d) = ellinit([0,0,0,0,  a^3*d^3]);
Ecur(a,d,s) = if (s < 0, Emin(a,d), Epls(a,d));

\\ ---------------------------------------------------------------- the cache
\\ Everything expensive here is a Mordell-Weil computation -- ellrank, and then
\\ ellheegner / ellsaturation on the survivors -- and it is a pure function of
\\ the curve.  The density test on top of it costs nothing.  So the ranks and
\\ the saturated generators are written to results/, keyed by (a, d, sign), and
\\ a later run reuses them: changing the density test, the filtering, or the
\\ bound then costs no Mordell-Weil work at all.  One file per value of a, so
\\ that parallel runs never write to the same file.
\\
\\ A line is  [a, d, s, rank, gflag, points]  with s = -1 for y^2 = x^3 - a^3d^3
\\ and s = +1 for y^2 = x^3 + a^3d^3, gflag = 1 if the points are SATURATED
\\ generators and 0 if they are only what ellrank happened to return.  Entries
\\ are appended, never rewritten, so a key may occur twice (rank first, then
\\ the saturated upgrade); the later line wins on reload.

CFILE = "";
CMAP = Map();
{ckey(a,d,s) = Str(a, ",", d, ",", s);}

{cinit(a) = my(V, n = 0);
  CFILE = Str("results/plusminus-cube-cache-", a, ".txt");
  CMAP = Map();
  V = iferr(readvec(CFILE), E, []);
  foreach(V, e,
    if (type(e) == "t_VEC" && #e == 6,
      mapput(CMAP, ckey(e[1],e[2],e[3]), [e[4],e[5],e[6]]); n++));
  printf("      cache %s: %d lines, %d keys\n", CFILE, #V, #CMAP);
  n;}

{cput(a,d,s,r,gf,P) =
  mapput(CMAP, ckey(a,d,s), [r,gf,P]);
  write(CFILE, Str("[", a, ", ", d, ", ", s, ", ", r, ", ", gf, ", ", P, "]"));}

\\ The rank, computed once ever.  ellrank's own points are cached with it.
{crank(a,d,s) = my(z, r);
  if (mapisdefined(CMAP, ckey(a,d,s), &z), return(z[1]));
  r = ellrank(Ecur(a,d,s));
  cput(a,d,s, r[1], 0, r[4]);
  r[1];}

\\ Saturated generators, computed once ever.  Reuses the cached ellrank points
\\ when they are there, so a twist that check 3 has already ranked does not pay
\\ for ellrank again in check 4.
{cgens(a,d,s) = my(z, E = Ecur(a,d,s), P, r);
  if (mapisdefined(CMAP, ckey(a,d,s), &z),
    if (z[2], return(z[3]));
    r = z[1]; P = z[3]
  ,
    my(rr = ellrank(E)); r = rr[1]; P = rr[4]);
  if (#P == 0 && r == 1, P = [ellheegner(E)]);
  P = if (#P == 0, [], ellsaturation(E,P,40));
  cput(a,d,s, r, 1, P);
  P;}

{dense(a,d,s,p) = my(E = Ecur(a,d,s), v, Em, P);
  P = concat(cgens(a,d,s), elltors(E)[3]);
  Em = ellminimalmodel(E,&v);
  P = apply(Q -> ellchangepoint(Q,v), P);
  if(#P == 0, 0, if(p == 2, densegroup2(Em,P), densegroup(Em,P,p)));}

\\ ---------------------------------------------------------------- check 1
\\ The pair itself: conductors, ranks, torsion, non-isogeny, and the split
\\ of the 2-division polynomial.

check1() =
{ printf("  (1) the pair, for small odd primes a\n");
  printf("      %-5s %-9s %-9s %-7s %-9s %-11s %s\n",
         "a","N(E)","N(E')","ranks","torsion","isogenous?","2-division field");
  foreach([3,5,7,11,13], a,
    my(E = Emin(a,1), F = Epls(a,1), iso = 1, q = 5);
    cinit(a);
    while (q < 400, if (a%q, if (ellap(E,q) != ellap(F,q), iso = 0; break)); q = nextprime(q+1));
    printf("      %-5d %-9d %-9d %d, %-4d %-9s %-11d Q(zeta_3), disc = %d\n",
           a, ellglobalred(E)[1], ellglobalred(F)[1],
           crank(a,1,-1), crank(a,1,1), Str(elltors(E)[2]), iso, -3*a^2));
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
  cinit(a);
  for (k = 1, B, foreach([k,-k], d,
    if (core(abs(d)) != abs(d), next);
    if (crank(a,d,-1) < 1, next);
    if (crank(a,d,1) < 1, next);
    listput(L, d)));
  printf("      a = %d : %d twists |d| <= %d with both ranks positive\n", a, #L, B);
  foreach(ps, p,
    my(wit = vector(4), got = 0);
    foreach(Vec(L), d,
      my(c = sqclass(d,p) + 1);
      if (wit[c], next);
      if (dense(a,d,-1,p) && dense(a,d,1,p), wit[c] = d));
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

check4(a, B, step, budget) =
{ my(wit = vector(8), got = 0, cand = 0, both = 0, n = 0, f = 0,
     t0 = getwalltime(), dmax = 0, stopped = 0);
  printf("  (4) deep scan at p = 2 for a = %d, squarefree |d| <= %d, budget %d s\n",
         a, B, budget);
  cinit(a);
  for (k = 1, B,
    if (!stopped && budget && (getwalltime() - t0) > budget*1000,
        stopped = 1; dmax = k - 1);
    if (!stopped,
      foreach([k,-k], d,
        if (core(abs(d)) == abs(d),
          n++;
          my(c = sqclass2(d) + 1);
          if (!wit[c],
            my(w1 = ellrootno(Emin(a,d)), sg, sh, ok = 1);
            if (d % 2 == 0,
              sg = if (w1 == 1, -1, 1); sh = -sg;
              if (crank(a,d,sg) < 2, ok = 0, cand++; if (crank(a,d,sh) < 1, ok = 0, both++))
            ,
              if (crank(a,d,-1) < 1 || crank(a,d,1) < 1, ok = 0)
            );
            if (ok, if (dense(a,d,-1,2) && dense(a,d,1,2), wit[c] = d)));
          if (step && n % step == 0,
            f = 0; for (c2 = 1, 8, if (wit[c2], f++));
            printf("        ... |d| <= %5d, %6d twists, %4d rank>=2, %5d s, %d of 8:",
                   k, n, cand, (getwalltime()-t0)\1000, f);
            for (c2 = 1, 8, printf(" %s=%s", sqclass2name(c2-1),
                                   if (wit[c2], Str(wit[c2]), "--")));
            printf("\n"))))));
  if (!stopped, dmax = B);
  for (c = 1, 8, if (wit[c], got++));
  printf("      reached |d| <= %d in %d s%s\n", dmax, (getwalltime()-t0)\1000,
         if (stopped, " (budget exhausted)", " (completed)"));
  printf("      %d squarefree twists scanned; %d even ones with rank >= 2 on the\n", n, cand);
  printf("      even-root-number curve, %d of those with both ranks positive\n", both);
  printf("      %d of 8 square classes covered:\n", got);
  for (c = 1, 8, printf("        [%-3s] : %s\n", sqclass2name(c-1),
                        if (wit[c], Str("d = ", wit[c]), "none")));
  [got, dmax, n, cand, both];
};

\\ ---------------------------------------------------------------- check 5
\\ A CACHE AUDIT, and an honest limit on what check 4 proves.
\\
\\ gens() calls ellheegner only when the rank is exactly 1.  On a curve of rank
\\ >= 2 whose generators ellrank does not find, the point list stays EMPTY, so
\\ dense() returns 0 -- the twist is recorded as not-dense without any density
\\ test having happened.  That is a false negative.  It can never manufacture a
\\ witness, so the odd-prime results of check 3 are proofs regardless; but it
\\ means the empty even column at p = 2 is partly untested rather than tested
\\ and failed.  This check counts which is which, using only the cache, so it
\\ costs nothing.  dense(E) && dense(F) short-circuits, so a twist rejected on
\\ the first curve may have no generator data for the second at all.

check5(a) =
{ my(tot = 0, both = 0, tested = 0, vac = 0, nog = 0, dmax = 0);
  cinit(a);
  for (k = 1, 100000,
    foreach([k,-k], d,
      if (core(abs(d)) != abs(d), next);
      my(z1, z2);
      if (!mapisdefined(CMAP, ckey(a,d,-1), &z1), next);
      if (!mapisdefined(CMAP, ckey(a,d, 1), &z2), next);
      if (abs(d) > dmax, dmax = abs(d));
      tot++;
      if (d % 2, next);
      my(w1 = ellrootno(Emin(a,d)), sg, zg, zh);
      sg = if (w1 == 1, -1, 1);
      zg = if (sg < 0, z1, z2); zh = if (sg < 0, z2, z1);
      if (zg[1] < 2 || zh[1] < 1, next);
      both++;
      \\ dense(E) && dense(F) short-circuits on the SIGN: E (s = -1) is always
      \\ tested first, so z1 is the one that decides.  A verdict is vacuous when
      \\ that curve's saturated generator list is empty -- not-dense by absence
      \\ of points rather than by a density test.
      if (z1[2] == 0, nog++,
        if (#z1[3] == 0, vac++, tested++))));
  printf("      a = %d : cache covers |d| <= %d, %d twists with both curves cached\n",
         a, dmax, tot);
  printf("        %d even twists with rank >= 2 and rank >= 1 on the two curves, of which\n", both);
  printf("          %d were genuinely tested: generators found on E, density decided\n", tested);
  printf("          %d gave a VACUOUS verdict: no generators found on E, so not-dense\n", vac);
  printf("          %d have no generator data for E at all (should be 0)\n", nog);
  [both, tested, vac, nog];
};

print("======================================================================");
print("plusminus-cube.gp -- y^2 = x^3 -+ a^3, and the 2-adic gap");
/* The driver.  check4 is the expensive part and its cost per twist grows
   faster than |d|^4, with a heavy tail (a single ellheegner / ellsaturation on
   a large-conductor curve can dominate), so it takes a WALL-CLOCK BUDGET in
   seconds rather than a promised bound: it reports the |d| it actually reached.
   The budget is only tested BETWEEN values of |d|, and a single twist can run
   for an hour inside one of them, so treat it as a floor, not a deadline; the
   per-step line carries the full witness table for exactly that reason, so a
   run stopped by hand is still self-documenting.  The DEFAULT budget is small
   (300 s per value of a) so that the documented invocation above finishes in
   under an hour; results/plusminus-cube-deep.txt records a much longer run.
   Do not edit this file while a run is in flight: gp reads it incrementally,
   so an edit shifts the offset it resumes from and it executes garbage after
   the driver returns (the results already computed are unaffected).
   The three values of a are independent, so they can be run in parallel --
   set AONLY before reading this file to do just one of them, e.g.
        echo 'AONLY=5; BUDGET=5400; read("plusminus-cube.gp")' | gp -q -s 8000000000
   Setting CHEAP instead runs only checks 1-3, which cost seconds.  Leaving
   both unset runs everything sequentially.                                   */
BUDGET = if (type(BUDGET) == "t_INT", BUDGET, 300);
BMAX   = if (type(BMAX)   == "t_INT", BMAX,   100000);

{driver() =
  if (type(CHEAP) == "t_INT",
    print("");
    check1(); print("");
    check2(200); print("");
    print("  (3) the scan at the odd primes p <= 19");
    check3(3, 150, [3,5,7,11,13,17,19]);
    check3(5, 150, [3,5,7,11,13,17,19]);
    check3(7, 150, [3,5,7,11,13,17,19]);
    print("")
  ,
  if (type(AONLY) == "t_INT",
    print(""); check4(AONLY, BMAX, 250, BUDGET); print("")
  ,
    print("");
    check1(); print("");
    check2(200); print("");
    print("  (3) the scan at the odd primes p <= 19");
    check3(3, 150, [3,5,7,11,13,17,19]);
    check3(5, 150, [3,5,7,11,13,17,19]);
    check3(7, 150, [3,5,7,11,13,17,19]);
    print("");
    check4(3, BMAX, 250, BUDGET); print("");
    check4(5, BMAX, 250, BUDGET); print("");
    check4(7, BMAX, 250, BUDGET); print("");
    print("  (5) cache audit: how much of the even column was actually tested");
    check5(3); check5(5); check5(7); print("");
  ));
  print("======================================================================");}
\\ Reading this file runs the driver, unless NORUN is set -- set it to use the
\\ file as a library (Emin/Epls, the cache, check1..check4) without scanning.
if (type(NORUN) != "t_INT", driver());
