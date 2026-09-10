/* ============================================================================
   corollary6.gp -- search for (E, ell) with a SINGLE obstructed prime, using
   Corollary 6 and Theorem 8 of the survey document (chapter 10).

   For ell odd, Theorem 8 settles every place away from ell:  v is in Sigma(d)
   exactly when E_d is split multiplicative at v, E_d[ell] is fully rational
   over Q_v, and phi does not stabilise the canonical line C_can(v).  So a
   single-place obstruction is arranged by asking:

     (i)   E[ell] DECOMPOSABLE, so that a non-scalar phi exists.  With exactly
           two rational ell-lines the rank-one phi stabilise both, so (c) holds
           iff NO rational line is canonical at v.
     (ii)  ell does NOT divide N_E, so E has good reduction at ell and Lemma
           1(b) kills the wild place.
     (iii) infinity and the primes q | d die by Lemma 2, ell being odd.
     (iv)  EXACTLY ONE bad prime p passes (a), (b), (c).

   Then Sigma(d) = {p} for every d in the square class that (a) selects, and
   reciprocity forces beta_p = 0 on rational pairs: a single-place obstruction,
   with X(Q) not dense in X(Q_p).  Chapter 3's search should then witness every
   square class at every odd prime EXCEPT that one class at p.

   The search runs over the universal curve with a rational 3-torsion point,
   y^2 + a x y + b y = x^3, since E[3] decomposable is rare in a naive box.
   For the surface we need the monic model y^2 = f(x) with
   f = x^3 + b2 x^2 + 8 b4 x + 16 b6.

   Functions: monicF, nisog, canline, splitclass, fulltors, sigma1, scan.
   Output: results/survey-corollary6.txt
   ============================================================================ */

sqreps(v) = if(v == 2, [1,-1,2,-2,5,-5,10,-10], my(u = lift(znprimroot(v))); [1, u, v, u*v]);
tw(E, d) = ellminimalmodel(ellinit([-27*E.c4*d^2, -54*E.c6*d^3]));
monicF(E) = [E.b2, 8*E.b4, 16*E.b6];
nisog(E, l) = { my(m = ellisomat(E, l, 1)[2]); sum(j = 1, #m, m[1,j] == l); }
ismult(E, v) = elllocalred(E, v)[2] > 4;

/* (c): is any rational ell-line canonical at v?  v(q) = -v(j), twist-invariant */
canrational(E, ell, v) = { my(vq = -valuation(E.j, v), cs, out = 0);
  if(vq <= 0, return(-1));                    /* not potentially multiplicative */
  cs = ellisomat(E, ell, 1)[1];
  for(i = 2, #cs, my(F = ellminimalmodel(ellinit(cs[i])));
    if(-valuation(F.j, v) == ell*vq, out = 1));
  out; }

/* (a): the square class making E_d split multiplicative at v, or 0 */
splitclass(E, v) = { my(reps = sqreps(v), out = 0);
  for(i = 1, #reps, my(Ed = tw(E, reps[i]));
    if(ismult(Ed, v) && ellap(Ed, v) == 1, out = reps[i])); out; }

/* (b): is all of E_d[ell] rational over Q_v? */
fulltors(E, ell, v) = { my(ps = factorpadic(elldivpol(E, ell), v, 30), c = 0);
  for(i = 1, #ps~, if(poldegree(ps[i,1]) == 1,
    my(xr = -polcoeff(ps[i,1],0)/polcoeff(ps[i,1],1), yy);
    yy = (xr^3 + E.a2*xr^2 + E.a4*xr + E.a6) + (E.a1*xr + E.a3)^2/4;
    if(yy == 0 || issquare(yy), c += ps[i,2])));
  c == (ell^2-1)/2; }

/* the critical places of E at level ell, by Theorem 8 */
sigma1(E, ell) = { my(N = ellglobalred(E)[1], out = List());
  if(N % ell == 0, return(0));               /* need good reduction at ell */
  if(nisog(E, ell) < 2, return(0));          /* need E[ell] decomposable */
  foreach(factor(N)[,1]~, v,
    if(v == ell, next);
    my(cls = splitclass(E, v), Ed);
    if(cls == 0, next);
    Ed = tw(E, cls);
    if(!fulltors(Ed, ell, v), next);
    if(canrational(Ed, ell, v) != 0, next);  /* (c): no rational line canonical */
    listput(out, [v, cls]));
  Vec(out); }

/* level 5: the Tate normal form carrying a point of order 5 */
scan5(CMAX) = { my(nd = 0, hits = List(), seen = List());
  print("=== ell = 5: scanning the 5-torsion family y^2 + (1-c)xy - cy = x^3 - cx^2");
  for(cn = -CMAX, CMAX, for(cd = 1, 6,
    my(c = cn/cd, E, Em, S, N);
    if(cn == 0, next);
    E = ellinit([1-c, -c, -c, 0, 0]);
    if(E == 0 || E.disc == 0, next);
    Em = ellminimalmodel(E); N = ellglobalred(Em)[1];
    if(N % 5 == 0, next);
    if(nisog(Em, 5) < 2, next);
    if(setsearch(Set(Vec(seen)), N), next);
    listput(seen, N); nd++;
    S = sigma1(Em, 5);
    if(type(S) == "t_INT" || #S != 1, next);
    listput(hits, [c, N, S[1][1], S[1][2], monicF(Em)]);
    print("   c = ", c, "   N = ", N, "   SINGLE critical prime p = ", S[1][1],
          "   class d = ", S[1][2], "   f = x^3 + (", monicF(Em)[1], ")x^2 + (",
          monicF(Em)[2], ")x + (", monicF(Em)[3], ")")));
  print("   [", nd, " curves with E[5] decomposable and good reduction at 5]");
  Vec(hits); }

scan(ell, AMAX, BMAX) = { my(nd = 0, hits = List());
  print("=== ell = ", ell, ": scanning y^2 + a x y + b y = x^3, |a| <= ", AMAX,
        ", 1 <= |b| <= ", BMAX);
  for(a = -AMAX, AMAX,
    for(b = -BMAX, BMAX,
      if(b == 0, next);
      my(E = ellinit([a, 0, b, 0, 0]), Em, S, N);
      if(E == 0 || E.disc == 0, next);
      Em = ellminimalmodel(E); N = ellglobalred(Em)[1];
      if(N % ell == 0, next);
      if(nisog(Em, ell) < 2, next);
      nd++;
      S = sigma1(Em, ell);
      if(type(S) == "t_INT" || #S != 1, next);
      listput(hits, [a, b, N, S[1][1], S[1][2], monicF(Em)]);
      print("   a=", a, " b=", b, "   N = ", N, "   SINGLE critical prime p = ", S[1][1],
            "   class d = ", S[1][2], "   f = x^3 + (", monicF(Em)[1], ")x^2 + (",
            monicF(Em)[2], ")x + (", monicF(Em)[3], ")")));
  print("   [", nd, " curves with E[", ell, "] decomposable and good reduction at ", ell, "]");
  Vec(hits); }

/* ---------------------------------------------------------------------------
   Searching by j-invariant.  Quadratic twists give the SAME Kummer surface --
   f_d(x) = d^3 f(x/d) and the substitution x = du, t = dw turns y^2 = f_d f_d
   into y^2 = d^6 f f -- so j, not the curve, is the surface parameter.  Scan
   the genus-0 Hauptmodul of X_0(ell) and keep the j whose curves have
   DECOMPOSABLE E[ell].
   --------------------------------------------------------------------------- */
j3(t) = (t + 27)*(t + 3)^3 / t;
j5(t) = (t^2 + 250*t + 3125)^3 / t^5;
j7(t) = (t^2 + 13*t + 49)*(t^2 + 245*t + 2401)^3 / t^7;
mintw(jj) = { my(E0 = ellinit(ellfromj(jj)), D = ellminimaltwist(E0));
  ellminimalmodel(ellinit([-27*E0.c4*D^2, -54*E0.c6*D^3])); }
scanj(ell, jf, NMAX, DMAX) = { my(seen = List(), hits = List(), n = 0);
  for(a = -NMAX, NMAX, for(b = 1, DMAX,
    my(t = a/b, jj, E);
    if(a == 0 || gcd(a,b) != 1, next);
    jj = jf(t);
    if(jj == 0 || jj == 1728, next);
    if(setsearch(Set(Vec(seen)), jj), next);
    listput(seen, jj); n++;
    E = ellminimalmodel(ellinit(ellfromj(jj)));
    if(nisog(E, ell) < 2, next);
    listput(hits, jj)));
  print("   ell = ", ell, ": ", n, " distinct j scanned on X_0(", ell, "),  ",
        #hits, " with E[", ell, "] decomposable");
  for(i = 1, #hits, my(Em = mintw(hits[i]), N = ellglobalred(Em)[1], S, F);
    F = [Em.b2, 8*Em.b4, 16*Em.b6];
    print("      j = ", hits[i], "   minimal-twist N = ", N);
    if(N % ell == 0, print("         ", ell, " | N: the wild place is not covered, skipped"), 
      S = sigma1(Em, ell);
      if(type(S) == "t_INT", print("         no non-scalar phi"),
        print("         critical places ", S,
              if(#S == 1, "   <== SINGLE, f = ", "   "),
              if(#S == 1, concat(["x^3 + (", F[1], ")x^2 + (", F[2], ")x + (", F[3], ")"]), "")))));
  Vec(hits); }

main() = {
  print("=== Corollary 6: curves with exactly one critical prime ===");
  print("");
  H3 = scan(3, 40, 40);
  print("");
  print("total hits at ell = 3: ", #H3);
  print("");
  H5 = scan5(60);
  print("");
  print("total hits at ell = 5: ", #H5);
  print("");
  print("=== the j-line search: quadratic twists give the SAME surface, so j is");
  print("=== the parameter.  Scanning the genus-0 Hauptmodul of X_0(ell).");
  scanj(5, j5, 200, 8);
  print("");
  scanj(7, j7, 200, 8);
  print("");
  print("ell = 7 is EMPTY, and necessarily so: E[ell] decomposable forces a");
  print("rational cyclic ell^2-isogeny on E/C_1, and by Mazur-Kenku the rational");
  print("cyclic isogeny degrees stop at 19 apart from 21, 25, 27, 37, 43, 67, 163");
  print("-- so ell^2 must be 4, 9 or 25 and ell <= 5.  For ell = 3 and 5 the");
  print("families are INFINITE, X_0(9) and X_0(25) both having genus 0.");
}
main();
print("");
print("### corollary6 finished");
quit;
