read("kummer2.gp");
read("control.gp");

/* =====================================================================
   Which families are obstructed at p = 3?   (document, section 5.2.3)

   The obstruction needs E[3] decomposable (two independent rational
   3-isogenies) and an M = 9 class at p = 3.  Every decomposable family has
   a twist with a rational 3-torsion POINT -- twist by the character cutting
   one of the two kernels -- so scanning the X_1(3) family

        y^2 + a1 x y + a3 y = x^3        (rational 3-torsion at (0,0))

   and asking for a SECOND rational root of psi_3 finds them all up to twist.

   Outcome (19 of 19 testable families, no mismatch): the obstructed ones are
   exactly those whose j has denominator 1 or a power of 2, i.e. whose only
   prime of potentially multiplicative reduction is 2, or none.  Those primes
   -- the p with v_p(j) < 0 -- are exactly the extra places at which inv_v of
   a Brauer class could vary, and a Brauer-Manin obstruction can localise at
   p = 3 only when there are none.

   Caveat: only TWO families are obstructed, and scan2pow below shows that is
   the entire population, not a small sample -- over 2.4 million parameter
   values on the genus-0 curve of decomposable families, only j = 0 and
   j = 9261/8 have 2-power denominator.  So the positive direction of the
   criterion is underdetermined: any property those two share would fit.
   ===================================================================== */

/* strip 4th/6th power factors: minimal representative of the twist family */
reduce(A, B) = {
  my(u = 1, p, e, fa, i);
  fa = factor(gcd(A^3, B^2));
  for(i = 1, #fa~,
    p = fa[i,1];
    e = min(if(A == 0, 1000, valuation(A,p) \ 4), if(B == 0, 1000, valuation(B,p) \ 6));
    u *= p^e);
  [A/u^4, B/u^6];
}

/* all quadratic-twist families with E[3] decomposable, deduped by j */
families(M) = {
  my(E, f, nlin, i, a1, a3, jj, seen = Map(), L = List());
  for(a1 = -M, M,
    for(a3 = -M, M,
      if(a3 == 0, next);
      E = ellinit([a1, 0, a3, 0, 0]);
      if(E == [], next);
      f = factor(elldivpol(E,3)); nlin = 0;
      for(i = 1, #f~, if(poldegree(f[i,1]) == 1, nlin += f[i,2]));
      if(nlin < 2, next);
      jj = E.j;
      if(mapisdefined(seen, jj), next);
      mapput(seen, jj, 1);
      listput(L, [-27*E.c4, -54*E.c6, jj])
    ));
  Vec(L);
}

/* test one family against the criterion */
testfamily(A0, B0) = {
  my(r, A, B, cls, E, den, pr, pred, k, d, n, sg, td, nrk = 0, nd = 0);
  r = reduce(A0, B0); A = r[1]; B = r[2];
  cls = find3(A, B);
  if(#cls == 0, return());                 /* no M=9 class at p=3: not testable */
  E = ellinit([A,B]);
  den = denominator(E.j);
  pr = if(den == 1, [], apply(v -> v, factor(den)[,1]~));
  pred = (den == 1) || (#pr == 1 && pr[1] == 2);
  k = cls[1][1];
  for(n = 1, 1200,
    if(!issquarefree(n), next);
    for(sg = 0, 1,
      d = if(sg == 0, n, -n);
      if(sqclass(d,3) != k, next);
      td = twistdata(A, B, d);
      if(Mval(td[1],3) != 9 || td[3] < 2, next);
      nrk++;
      if(densegroup(td[1], td[2], 3), nd++)));
  print("  j = ", E.j, "   denom primes ", pr,
        "   rank>=2: ", nrk, "  dense: ", nd,
        "   predicted ", if(pred, "OBSTRUCTED", "free"),
        "   ", if((nd == 0) == pred, "OK", "*** MISMATCH ***"));
}

/* the whole experiment */
sweepfamilies(M) = {
  my(L = families(M), i);
  print("decomposable families found: ", #L, " ; testing those with an M=9 class at p=3");
  for(i = 1, #L, testfamily(L[i][1], L[i][2]));
}

/* ---- the genus-0 parametrisation of decomposable families ----
   psi_3 = x(3x^3 + a1^2 x^2 + 3 a1 a3 x + 3 a3^2); solving the cubic factor
   for a3 forces -3(12x+1) to be a square, so with a1 = 1:
        x = -(w^2+3)/36,   a3 = x(-3 +- w)/6,   w in Q.                     */
jofw(w, sgn) = {
  my(xx, s, E);
  xx = -(w^2 + 3)/36;
  s = xx*(-3 + sgn*w)/6;
  if(s == 0, return(0));
  E = ellinit([1, 0, s, 0, 0]);
  if(E == [], return(0));
  E.j;
}
is2pow(n) = (n == 1) || (n == 2^valuation(n,2));

/* all decomposable families whose j has 2-power denominator */
scan2pow(W) = {
  my(m, n, w, j, seen = Map(), L = List(), sgn, tot = 0, i);
  for(n = 1, W,
    for(m = -W, W,
      if(gcd(m,n) != 1, next);
      w = m/n;
      for(sgn = -1, 1,
        if(sgn == 0, next);
        j = jofw(w, sgn);
        if(j == 0 && w == 0, next);
        tot++;
        if(!is2pow(denominator(j)), next);
        if(mapisdefined(seen, j), next);
        mapput(seen, j, 1);
        listput(L, [j, w, sgn]))));
  print("  scanned ", tot, " parameter values (|m|,n <= ", W, ")");
  print("  distinct j with 2-power denominator: ", #L);
  for(i = 1, #L, print("     j = ", L[i][1], "   (w = ", L[i][2], ", sign ", L[i][3], ")"));
}

/* pooled spanning rate among the UNOBSTRUCTED families, against the null
   48/81 for two uniform random vectors in F_3^2  (document, section 5.2.4) */
poolstats(M) = {
  my(L = families(M), i, r, A, B, cls, k, d, n, sg, td, E, den, R = 0, D = 0);
  for(i = 1, #L,
    r = reduce(L[i][1], L[i][2]); A = r[1]; B = r[2];
    cls = find3(A,B);
    if(#cls == 0, next);
    E = ellinit([A,B]); den = denominator(E.j);
    if(den == 1 || den == 2^valuation(den,2), next);    /* skip obstructed side */
    k = cls[1][1];
    for(n = 1, 1200,
      if(!issquarefree(n), next);
      for(sg = 0, 1,
        d = if(sg == 0, n, -n);
        if(sqclass(d,3) != k, next);
        td = twistdata(A, B, d);
        if(Mval(td[1],3) != 9 || td[3] < 2, next);
        R++;
        if(densegroup(td[1], td[2], 3), D++))));
  print("  unobstructed families pooled: ", D, " spanning out of ", R, " = ", D*1.0/R);
  print("  null (two uniform random vectors span F_3^2): 48/81 = ", 48.0/81);
}
