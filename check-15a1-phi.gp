/* check-15a1-phi.gp -- tests the prediction of survey document 10.5.1: for 15a1
   the canonical line is e = 17 at v = 3 and e = 1 at v = 5, so the two rank-one
   phi have DISJOINT obstructed sets. Run after depends.gp. */
read("kummer2.gp");
read("survey.gp");
/* 15a1: f = (x-17)(x-1)(x+8).  E_d : y^2 = (x-17d)(x-d)(x+8d).
   c_i(P) = x(P) - d*e_i.  Test beta(P,Q) = (c_a(P), c_b(Q))_v for the two phi:
     phi_A stabilises e = 17, -8  (the document's, excluding e = 1)  -> (c_1, c_3)
     phi_B stabilises e =  1, -8  (the other one, excluding e = 17)  -> (c_2, c_3)
   Chapter 10 predicts: phi_A live at 5 dead at 3; phi_B dead at 5 LIVE at 3 (class [u]). */
E3 = [17, 1, -8];
uni(a, v) = truncate(a*v^(-valuation(a,v))) * v^valuation(a,v);
cls(z, v) = [valuation(z,v) % 2, if(issquare(Mod(truncate(z/v^valuation(z,v)), v)), 1, -1)];
tab(d, v, ia, ib, prec, XMAX) = { my(E = ellinit([0, -d*(E3[1]+E3[2]+E3[3]), 0,
     d^2*(E3[1]*E3[2]+E3[1]*E3[3]+E3[2]*E3[3]), -d^3*E3[1]*E3[2]*E3[3]]),
   pts, RA = List(), RB = List(), SA = Set(), SB = Set(), nz = 0, ca, cb);
  pts = ppointsE(E, v, prec, XMAX);
  for(k = 1, #pts, my(x0 = pts[k][1]);
    ca = x0 - d*E3[ia]; cb = x0 - d*E3[ib];
    if(ca == 0 || cb == 0, next);
    if(valuation(ca,v) > prec-10 || valuation(cb,v) > prec-10, next);
    if(!setsearch(SA, cls(ca,v)), SA = setunion(SA,[cls(ca,v)]); listput(RA, uni(ca,v)));
    if(!setsearch(SB, cls(cb,v)), SB = setunion(SB,[cls(cb,v)]); listput(RB, uni(cb,v))));
  for(i = 1, #RA, for(j = 1, #RB, if(hilbert(RA[i], RB[j], v) != 1, nz++)));
  print("   d = ", d, "  v = ", v, "  phi = (c_", ia, ", c_", ib, ")",
        "   #pts = ", #pts, "   |im c_a| = ", #SA, "   |im c_b| = ", #SB,
        "   non-trivial symbols: ", nz, if(nz, "   ==> beta LIVE", "   ==> beta trivial")); }
print("=== phi_A = (c_1, c_3), the document's choice: predicted LIVE at 5, dead at 3 ===");
tab(1, 5, 1, 3, 30, 40);
tab(2, 3, 1, 3, 30, 40);
print("");
print("=== phi_B = (c_2, c_3), the other choice: predicted dead at 5, LIVE at 3 ===");
tab(1, 5, 2, 3, 30, 40);
tab(2, 3, 2, 3, 30, 40);
quit;
