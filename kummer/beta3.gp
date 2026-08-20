/* beta3.gp --- the local input of section 5.1.5, with the isogenous curves
 *
 * For E_d : y^2 = x^3 - 2d^3 and d in the class [u*3] at 3, this records
 *   (a) the reduction data of E_d and of the two 3-isogeny quotients
 *       B_i = E_d/C_i: minimal model, Kodaira type, c_3, and M = c_3 * #Ens,
 *   (b) the filtration E_1 < E_0 < E(Q_3) of the sampled points, which is
 *       what makes A = E(Q_3)/E_1 killed by 3,
 *   (c) v_3(x(psihat_i P_i)) for a point P_i of B_i(Q_3) outside N_i.
 *
 * Run:  gp -q -s 2000000000 < beta3.gp
 */

read("kummer2.gp");
read("survey.gp");

kodname(k) = {
  if(k == 1, return("I0"));  if(k == 2, return("II"));
  if(k == 3, return("III")); if(k == 4, return("IV"));
  if(k == -1, return("I*0")); if(k == -2, return("II*"));
  if(k == -3, return("III*")); if(k == -4, return("IV*"));
  if(k > 4, return(Str("I", k-4)));
  Str("I*", -k-4);
}
mod5(C) = [C.a1, C.a2, C.a3, C.a4, C.a6];

/* the singular point of the reduction mod p of a minimal model, or -1 */
singpt(Cm, p) = {
  my(a1 = Cm.a1, a2 = Cm.a2, a3 = Cm.a3, a4 = Cm.a4, a6 = Cm.a6, F, Fx, Fy);
  for(X = 0, p-1, for(Y = 0, p-1,
    F  = Y^2 + a1*X*Y + a3*Y - X^3 - a2*X^2 - a4*X - a6;
    Fx = a1*Y - 3*X^2 - 2*a2*X - a4;
    Fy = 2*Y + a1*X + a3;
    if(Mod(F,p) == 0 && Mod(Fx,p) == 0 && Mod(Fy,p) == 0, return([X, Y]))));
  -1;
}

/* 0 = in E_1, 1 = in E_0 \ E_1, 2 = outside E_0 */
layer(Cm, P, p, sp) = {
  if(P == [0] || valuation(P[1], p) < 0, return(0));
  if(sp == -1, return(1));
  if(Mod(truncate(P[1]) - sp[1], p) == 0 && Mod(truncate(P[2]) - sp[2], p) == 0,
     return(2));
  1;
}

/* first sampled point in a prescribed layer, or 0 */
firstinlayer(Cm, p, prec, XMAX, want) = {
  my(pts = ppointsE(Cm, p, prec, XMAX), sp = singpt(Cm, p));
  for(i = 1, #pts, if(layer(Cm, pts[i], p, sp) == want, return(pts[i])));
  0;
}

/* how many sampled points fall in each layer */
layercensus(Cm, p, prec, XMAX) = {
  my(pts = ppointsE(Cm, p, prec, XMAX), sp = singpt(Cm, p), c = [0,0,0]);
  for(i = 1, #pts, my(l = layer(Cm, pts[i], p, sp)); c[l+1] = c[l+1] + 1);
  c;
}

run(d) = {
  my(E, Em, vE, lrE, sp, P, Ep, ker, kerdual, Ei, B, Bm, vB, lr,
     Edd, Eddm, vdd, w, Pi, img, xv);
  E  = ellinit([0,0,0,0,-2*d^3]);
  Em = ellminimalmodel(E, &vE);
  lrE = elllocalred(Em, 3);
  Ep = padiccurve(Em, 3);
  sp = singpt(Em, 3);
  print("d = ", d, "   E : y^2 = x^3 - 2d^3 = x^3 + ", -2*d^3);
  print("  E   minimal ", mod5(Em), "  change ", vE,
        "   Kodaira ", kodname(lrE[2]), "  c_3 = ", lrE[4],
        "  M = c_3 * #Ens(F_3) = ", lrE[4], " * 3 = ", lrE[4]*3);
  print("      singular point of the reduction: ", sp,
        "   sampled points by layer [E_1, E_0\\E_1, outside E_0]: ",
        layercensus(Em, 3, 30, 60));
  /* half one, structurally: one point outside E_0, killed by 3 in A */
  P = firstinlayer(Em, 3, 30, 60, 2);
  if(P == 0,
    print("      NO point outside E_0 found"),
    print("      P outside E_0 with x = ", truncate(P[1]) % 27,
          " (mod 27):  3P in E_1 ? ", inE1(ellmul(Ep, P, 3), 3)));
  for(i = 1, 2,
    ker     = if(i == 1, x - 2*d, x);
    kerdual = if(i == 1, 0, 2*d);   /* x-coord of the OTHER kernel */
    Ei = ellisogeny(E, ker);
    B  = ellinit(Ei[1]);
    Bm = ellminimalmodel(B, &vB);
    lr = elllocalred(Bm, 3);
    print("  B_", i, " = E/C_", i, "  (C_", i, " : x = ",
          if(i == 1, 2*d, 0), ")   raw ", Ei[1], "   minimal ", mod5(Bm),
          "   change ", vB);
    print("      Kodaira ", kodname(lr[2]), "  c_3 = ", lr[4],
          "   M_", i, " = ", lr[4], " * 3 = ", lr[4]*3,
          "   singular point ", singpt(Bm, 3),
          "   layers ", layercensus(Bm, 3, 30, 60));
    /* the dual: kernel = psi_i(C_j), then land back on E */
    my(xk = subst(Ei[2][1], x, kerdual) / subst(Ei[2][3], x, kerdual)^2);
    Edd  = ellisogeny(B, x - xk);
    Eddm = ellminimalmodel(ellinit(Edd[1]), &vdd);
    print("      dual psihat_", i, " : B_", i, " -> ", Edd[1],
          "   whose minimal model is ", mod5(Eddm),
          "   = minimal model of E ? ", mod5(Eddm) == mod5(Em));
    Pi = firstinlayer(Bm, 3, 30, 60, 1);
    if(Pi == 0, print("      NO point outside N_", i, " found"),
      Pi  = ellchangepointinv(Pi, vB);            /* back to the raw B_i */
      img = isogapply(Edd[2], Pi);                /* onto the raw target */
      img = ellchangepoint(img, vdd);             /* onto its minimal model */
      xv  = if(img == [0], -oo, valuation(img[1], 3));
      print("      P_", i, " outside N_", i, " has x = ",
            truncate(Pi[1]) % 27, " (mod 27);  v_3(x(psihat_", i, " P_", i,
            ")) = ", xv, "   in E_1 ? ", inE1(img, 3))));
  print("");
}

print("=== the local input of section 5.1.5, with the isogenous curves ===");
print("E_d : y^2 = x^3 - 2d^3,  d in the class [u*3] at 3");
print("");
run(-3); run(6); run(-21); run(87); run(-30); run(69);
print("### beta3 finished");
quit;
