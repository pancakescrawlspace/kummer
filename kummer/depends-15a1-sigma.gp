/* ============================================================================
   depends-15a1-sigma.gp -- the full Sigma(d) for both phi on 15a1, d = -1.

   Sanity check prompted by an apparent conflict: chapter 3 witnesses every
   class of 15a1 at p = 3, while chapter 10's recipe reports 3 as critical for
   the phi pairing c_2 and c_3.  There is no conflict.  The recipe at ell = 2
   covers only the ODD MULTIPLICATIVE places; here it computes every place.

   Result:  phi_A = (c_1,c_3):  Sigma = {5}          -- the theorem of 7.1
            phi_B = (c_2,c_3):  Sigma = {infinity, 2, 3}
   So for phi_B reciprocity gives beta_oo + beta_2 + beta_3 = 0, a three-place
   correlation with no constraint at 3 alone -- exactly the invisibility of 9.2,
   and exactly why the chapter 3 search succeeds at p = 3.

   Note also that beta_oo is non-zero on the ONE-dimensional W_oo, so beta is
   not alternating for phi_B: the norm lemma is a statement about a particular
   pair of descent maps, not about the curve.  Document 10.5.1.

   Functions: realchk, fin.  Output: results/survey-15a1-sigma.txt
   ============================================================================ */

read("kummer2.gp"); read("survey.gp");
E3 = [17, 1, -8];
/* real place: E_d(R), symbol (c_a, c_b)_oo = -1 iff both negative */
realchk(d, ia, ib) = { my(f, rts, s = 0, msg = "");
  f = (x - d*E3[1])*(x - d*E3[2])*(x - d*E3[3]);
  rts = vecsort(apply(t -> t*d, E3));
  print("   d = ", d, "  real roots ", rts, "   phi = (c_", ia, ", c_", ib, ")");
  /* egg = [rts[1], rts[2]], unbounded = [rts[3], oo) */
  foreach([[rts[1], rts[2], "egg"], [rts[3], rts[3]+30, "unbounded"]], I,
    my(x0 = (I[1]+I[2])/2, ca = x0 - d*E3[ia], cb = x0 - d*E3[ib]);
    print("      ", I[3], ": x = ", x0, "   c_", ia, " = ", ca, "   c_", ib, " = ", cb,
          "   symbol = ", if(ca < 0 && cb < 0, -1, 1))); }
/* finite place */
uni(a,v) = truncate(a*v^(-valuation(a,v)))*v^valuation(a,v);
cl(z,v) = if(v==2, [valuation(z,2)%2, lift(Mod(truncate(z/2^valuation(z,2)),8))], [valuation(z,v)%2, if(issquare(Mod(truncate(z/v^valuation(z,v)),v)),1,-1)]);
fin(d, v, ia, ib) = { my(E = ellinit([0, -d*(E3[1]+E3[2]+E3[3]), 0,
    d^2*(E3[1]*E3[2]+E3[1]*E3[3]+E3[2]*E3[3]), -d^3*E3[1]*E3[2]*E3[3]]),
  pts, RA = List(), RB = List(), SA = Set(), SB = Set(), nz = 0, tot = 0);
  pts = ppointsE(E, v, 30, 60);
  for(k = 1, #pts, my(x0 = pts[k][1], ca, cb);
    ca = x0 - d*E3[ia]; cb = x0 - d*E3[ib];
    if(ca == 0 || cb == 0, next);
    if(valuation(ca,v) > 20 || valuation(cb,v) > 20, next);
    if(!setsearch(SA,cl(ca,v)), SA=setunion(SA,[cl(ca,v)]); listput(RA, uni(ca,v)));
    if(!setsearch(SB,cl(cb,v)), SB=setunion(SB,[cl(cb,v)]); listput(RB, uni(cb,v))));
  for(i=1,#RA, for(j=1,#RB, tot++; if(hilbert(RA[i],RB[j],v)!=1, nz++)));
  print("   d = ", d, "  v = ", v, "  phi = (c_", ia, ", c_", ib, ")   |im c_a| = ", #SA,
        "  |im c_b| = ", #SB, "   non-trivial symbols ", nz, "/", tot,
        if(nz, "   ==> LIVE", "   ==> trivial")); }
print("=== phi_B = (c_2, c_3) on 15a1, d = -1 (class [u] at 3, class [1] at 5) ===");
print(" real place:");
realchk(-1, 2, 3);
print(" finite places:");
fin(-1, 2, 2, 3); fin(-1, 3, 2, 3); fin(-1, 5, 2, 3);
print("");
print("=== the document's phi_A = (c_1, c_3) at the same d, for contrast ===");
print(" real place:");
realchk(-1, 1, 3);
print(" finite places:");
fin(-1, 2, 1, 3); fin(-1, 3, 1, 3); fin(-1, 5, 1, 3);
quit;
