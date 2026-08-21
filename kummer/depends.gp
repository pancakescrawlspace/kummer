/* ============================================================================
   depends.gp -- the obstructed set S read off (E, ell, phi) directly.

   Survey document chapter 10.  Nothing here computes a local point, a descent
   image or a symbol: every test is reduction data (Tate's algorithm, the
   factorisation of the minimal discriminant, the ell-isogeny class) plus one
   factorisation of the ell-division polynomial over Q_v.

   The criterion behind it: L_v = image of E_d(Q_v)/ell in H^1 is MAXIMAL
   ISOTROPIC, so beta_v = 0 exactly when phi_* L_v = L_v.  Hence

       Sigma(d) = { v : L_v is not phi-stable },

   and the obstructed sets are the S containing Sigma(d).  The five steps:

     1. only bad places survive.  At good v not ell, L_v = H^1_ur; at good
        v = ell, L_v = H^1_f; both are functorial in the Galois module, hence
        phi-stable for EVERY phi.  For ell odd, infinity and the q | d also die.
     2. a non-zero alternating beta_v needs dim W_v = 2, i.e. all of E_d[ell]
        rational over Q_v; for v not ell that forces v = 1 mod ell.
     3. at a multiplicative v that means ell | v(Delta_min).  Additive places
        have c_v <= 4, so for ell >= 5 only split multiplicative places survive.
     4. the live square class is the unique unramified one making E_d SPLIT.
     5. phi decides: live iff the canonical line C_can = mu_ell is NOT phi-stable.
        C_can is detected without local points -- quotienting by it MULTIPLIES
        v(Delta) by ell, an etale line DIVIDES it by ell.

   CAVEAT AT ell = 2.  Step 1 leans on Lemma 2, which needs ell odd.  At ell = 2
   the output is Sigma(d) intersected with the ODD MULTIPLICATIVE places: it says
   which of those are critical, and NOTHING about infinity, v = 2, or the q | d,
   which need 6.2.2 and the norm lemma and are phi-dependent.  A one-element
   output at ell = 2 is therefore NOT a one-place obstruction.  Worked example:
   for 15a1 with phi = (c_2,c_3) the recipe correctly reports 3 as critical, but
   Sigma(-1) = {infinity, 2, 3}, so nothing is obstructed at 3 alone -- which is
   why the chapter 3 search witnesses that class.  See document 10.5.1.

   Functions: sqreps, tw, ratroots, ntorsx, redtype, canline, splitclass, run.
   Output: results/survey-depends.txt
   ============================================================================ */

PREC = 40;

sqreps(v) = if(v == 2, [1,-1,2,-2,5,-5,10,-10], my(u = lift(znprimroot(v))); [1, u, v, u*v]);
tw(E, d) = ellminimalmodel(ellinit([-27*E.c4*d^2, -54*E.c6*d^3]));
needx(ell) = if(ell == 2, 3, (ell^2-1)/2);
ratroots(f) = { my(F = factor(f), L = List()); for(i = 1, #F~, if(poldegree(F[i,1]) == 1, listput(L, -polcoeff(F[i,1],0)/polcoeff(F[i,1],1)))); Vec(L); }

/* step 2: how many x-coordinates of ell-torsion are rational over Q_v */
ntorsx(E, ell, v) = { my(ps = factorpadic(elldivpol(E, ell), v, PREC), c = 0);
  for(i = 1, #ps~, if(poldegree(ps[i,1]) == 1,
    my(xr = -polcoeff(ps[i,1],0)/polcoeff(ps[i,1],1), yy);
    yy = (xr^3 + E.a2*xr^2 + E.a4*xr + E.a6) + (E.a1*xr + E.a3)^2/4;
    if(yy == 0 || issquare(yy), c += ps[i,2]))); c; }

/* step 3: reduction type at v, with split / non-split spelled out */
redtype(E, v) = { my(r = elllocalred(E, v), k = r[2]);
  if(k == 1, "good", if(k <= 4 || k < 0, "additive",
    concat(["I", k-4, if(ellap(E, v) == 1, " split", " nonsplit")]))); }
ismult(E, v) = elllocalred(E, v)[2] > 4;

/* step 5: is some rational ell-line canonical at v, i.e. does its quotient
   MULTIPLY v(q) by ell?  We use v(q) = -v(j) rather than v(Delta): j is
   TWIST-INVARIANT, which is why the label may be read off the untwisted curve
   (document 10.7, the remark after Theorem 5), and unlike v(Delta) it survives
   additive potentially multiplicative reduction, where a type I_n* fibre adds 6.
   Returns [1, e] with e the root for ell = 2 (kernels are (e,0)), [1, i] with i
   the index in the isogeny class for ell odd, [0, 0] if no rational line is
   canonical. */
canline(Ea, ell, v) = { my(E = ellminimalmodel(Ea), vq = -valuation(E.j, v), lab = [0, 0]);
  if(vq <= 0, return(lab));       /* not potentially multiplicative at v */
  if(ell == 2,
    foreach(ratroots(x^3 + Ea.a2*x^2 + Ea.a4*x + Ea.a6), e,
      if(-valuation(ellminimalmodel(ellinit(ellisogeny(Ea, [e,0], 1))).j, v) == 2*vq, lab = [1, e])),
    my(cs = ellisomat(E, ell, 1)[1]);
    for(i = 2, #cs, if(-valuation(ellminimalmodel(ellinit(cs[i])).j, v) == ell*vq, lab = [1, i])));
  lab; }

/* step 4: which unramified square class makes E_d split multiplicative at v */
splitclass(E, v) = { my(reps = sqreps(v), out = 0);
  for(i = 1, 2, my(Ed = tw(E, reps[i]));
    if(ismult(Ed, v) && ellap(Ed, v) == 1, out = reps[i])); out; }

/* one case.  excl = the x-coordinate of the line phi does NOT stabilise
   (ell = 2 with full 2-torsion); 0 means phi stabilises every rational line. */
run(nam, ainv, ell, excl, obs) = { my(Ea = ellinit(ainv), E, N, bad, S = List());
  E = ellminimalmodel(Ea); N = ellglobalred(E)[1]; bad = factor(N)[,1]~;
  print(""); print("=== ", nam, "   ell = ", ell, "   N = ", N,
        if(excl, concat(["   phi excludes the line e = ", excl]), "   phi stabilises all rational lines"));
  for(i = 1, #bad, my(v = bad[i], why = 0, cls, lab, nt, live = 0);
    if(v == ell, print("    v = ", v, " = ell   WILD PLACE, not covered by the recipe (see 10.8)"); next);
    cls = splitclass(E, v);
    nt = if(cls, ntorsx(tw(E, cls), ell, v), 0);
    lab = canline(Ea, ell, v);
    if(v % ell != 1 && ell != 2, why = "step 2: v is not 1 mod ell, so zeta_ell is not in Q_v",
      if(!cls, why = "step 3: no square class is split multiplicative here",
        if(valuation(E.disc, v) % ell, why = "step 3: ell does not divide v(Delta)",
          if(nt != needx(ell), why = concat(["step 2: only ", nt, " of ", needx(ell), " ell-torsion x-coords are Q_v-rational"]),
            if(lab[1] && !(ell == 2 && excl != 0 && lab[2] == excl), why = concat(["step 5: the canonical line", if(ell == 2, concat([" e = ", lab[2]]), ""), " IS phi-stable"]),
              live = 1)))));
    if(live, listput(S, v));
    print("    v = ", v, "   ", redtype(E, v), "   v(Delta) = ", valuation(E.disc, v),
          "   split class = ", if(cls, cls, "none"),
          "   torsion ", nt, "/", needx(ell),
          "   canonical line ", if(lab[1] == 0, "irrational", if(ell == 2, lab[2], "rational")),
          if(live, "      ==> LIVE", concat(["      dead -- ", why]))));
  if(ell == 2,
    print("    CRITICAL PLACES FOUND = ", Vec(S),
          "   (ell = 2: infinity, v = 2 and the q | d are NOT covered -- this is NOT all of Sigma)"),
    print("    PREDICTED S = ", Vec(S)));
  print("        observed: ", obs); }

main() = {
  print("=== the recipe of chapter 10, run on every case in the document ===");
  print("No local points, no descent images, no symbols: reduction data only.");
  run("x^3-2",    [0,0,0,0,-2],          3, 0, "3 (the wild place)");
  run("11a1",     [0,-1,1,-10,-20],      5, 0, "11, class [1]");
  run("14a1",     [0,10,0,105,-116],     3, 0, "7, class [1]");
  run("14a2",     [0,-11,0,-528,-2240],  3, 0, "7, class [1]");
  run("19a1(tw)", [0,-10,0,-4,-6],       3, 0, "19, class [u]");
  run("15a4",     [0,14,0,625,0],        2, 0, "5, class [1]");
  run("17a1",     [0,30,0,289,0],        2, 0, "17, class [1]");
  run("twoplace", [0,66,0,4225,0],       2, 0, "5 and 13, class [1] of each");
  print("");
  print("=== 15a1: full 2-torsion, so phi matters.  f = (x-17)(x-1)(x+8) ===");
  print("The document's phi pairs c_1 and c_3, i.e. stabilises e = 17 and e = -8,");
  print("and therefore EXCLUDES e = 1.");
  run("15a1, phi excluding e = 1",  [0,-10,0,-127,136], 2, 1,  "5, class [1]");
  print("");
  print("The other phi, pairing c_2 and c_3, excludes e = 17.  PREDICTION:");
  run("15a1, phi excluding e = 17", [0,-10,0,-127,136], 2, 17,
      "3 IS critical (confirmed), but Sigma(-1) = {infinity, 2, 3}: see 10.5.1");
}
main();
print("");
print("### depends finished");
quit;
