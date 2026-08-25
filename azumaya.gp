/* azumaya.gp --- the Brauer class behind beta, at level 2.
 *
 * X : y^2 = f(x) f(t) is the Kummer surface of E_d x E_d, and a point of X
 * coming from (P,Q) in E_d(Q)^2 has x = U(P)/d, t = U(Q)/d, where E_d is the
 * doc's model Y^2 = d^3 f(U/d) and U = d x.
 *
 * The classical descent map is c_i(P) = U(P) - d e_i, which depends on the
 * twist. The claim tested here is that on X it can be rewritten WITHOUT d,
 * as the product of the other two factors:
 *
 *     c_i(P) = (x - e_j)(x - e_k)  mod squares,   {i,j,k} = {1,2,3},
 *
 * so that beta_v(P,Q) = (c_i(P), c_j(Q))_v is the local invariant of the
 * quaternion algebra
 *
 *     A_{ij} = ( (x-e_k)(x-e_l),  (t-e_m)(t-e_n) )   over Q(X),
 *
 * a class that mentions no twist and is therefore a candidate element of
 * Br(X). The script checks, place by place on rational pairs, that the two
 * agree, and that the invariants sum to zero (reciprocity).
 *
 * Run:  gp -q -s 2000000000 < azumaya.gp
 */

allplaces(n) = { my(L = List([-1])); forprime(p = 2, 3000, if(n % p == 0, listput(L, p))); Vec(L); }
hil(a, b, v) = if(v == -1, if(a < 0 && b < 0, -1, 1), hilbert(a, b, v));
oth(i) = setminus([1, 2, 3], [i]);

/* e = the three roots of f; beta_v = (c_i1(P), c_i3(Q))_v */
runsplit(name, e, dlist, hmax, i1, i3) = {
  my(E, pts, x, t, up, uq, ca, cb, Ca, Cb, bad, tot, o1, o3,
     nb = 0, nmis = 0, np = 0, N, nplaces = 0);
  o1 = oth(i1); o3 = oth(i3);
  for(k = 1, #dlist,
    my(d = dlist[k]);
    E = ellinit([0, -d*(e[1]+e[2]+e[3]), 0,
                 d^2*(e[1]*e[2]+e[1]*e[3]+e[2]*e[3]), -d^3*e[1]*e[2]*e[3]]);
    pts = ellratpoints(E, hmax);
    for(i = 1, #pts, for(j = 1, #pts,
      up = pts[i][1]; uq = pts[j][1];
      x = up/d; t = uq/d;
      ca = up - d*e[i1];  cb = uq - d*e[i3];
      Ca = (x - e[o1[1]])*(x - e[o1[2]]);
      Cb = (t - e[o3[1]])*(t - e[o3[2]]);
      if(ca == 0 || cb == 0 || Ca == 0 || Cb == 0, next);
      np++;
      N = numerator(ca*cb*Ca*Cb) * denominator(ca*cb*Ca*Cb) * 2;
      bad = allplaces(N); tot = 1; nplaces += #bad;
      for(m = 1, #bad,
        if(hil(ca, cb, bad[m]) != hil(Ca, Cb, bad[m]), nmis++);
        tot *= hil(Ca, Cb, bad[m]));
      if(tot != 1, nb++))));
  print("  ", name, ":  beta = (c_", i1, "(P), c_", i3, "(Q))");
  print("     ", np, " rational pairs over ", #dlist, " twists, ", nplaces,
        " place evaluations;  mismatches beta_v vs inv_v A: ", nmis,
        ";  reciprocity failures: ", nb);
}

/* f = u(u^2 + a u + b) with only one rational root: c(P) = U(P) = q(x) mod squares */
runmonic(name, a, b, dlist, hmax) = {
  my(E, pts, x, t, up, uq, qa, qb, bad, tot, nb = 0, nmis = 0, np = 0, N, nplaces = 0);
  for(k = 1, #dlist,
    my(d = dlist[k]);
    E = ellinit([0, a*d, 0, b*d^2, 0]);
    pts = ellratpoints(E, hmax);
    for(i = 1, #pts, for(j = 1, #pts,
      up = pts[i][1]; uq = pts[j][1];
      if(up == 0 || uq == 0, next);
      x = up/d; t = uq/d;
      qa = x^2 + a*x + b; qb = t^2 + a*t + b;
      if(qa == 0 || qb == 0, next);
      np++;
      N = numerator(up*uq*qa*qb) * denominator(up*uq*qa*qb) * 2;
      bad = allplaces(N); tot = 1; nplaces += #bad;
      for(m = 1, #bad,
        if(hil(up, uq, bad[m]) != hil(qa, qb, bad[m]), nmis++);
        tot *= hil(qa, qb, bad[m]));
      if(tot != 1, nb++))));
  print("  ", name, ":  beta = (x(P), x(Q)),  A = (q(x), q(t)) with q = f/u");
  print("     ", np, " rational pairs over ", #dlist, " twists, ", nplaces,
        " place evaluations;  mismatches beta_v vs inv_v A: ", nmis,
        ";  reciprocity failures: ", nb);
}

print("=== the level-2 Brauer class: inv_v A  vs  beta_v ===");
print("");
runmonic("x^3 + x        (thm of sec 5.5)", 0, 1, [1,-1,2,3,5,6,7,10,11,13,14,15], 400);
runmonic("15a4  x(x^2+14x+625)", 14, 625, [1,-1,11,19,21,29,31,41,59,61], 400);
print("");
runsplit("15a1  (x-17)(x-1)(x+8)", [17,1,-8], [1,-1,11,19,29,31,41,59], 400, 1, 3);
runsplit("15a1, transpose      ", [17,1,-8], [1,-1,11,19,29,31,41,59], 400, 3, 1);
runsplit("15a1, untwisted pair ", [17,1,-8], [1,-1,11,19,29,31,41,59], 400, 1, 2);
runsplit("x(x-1)(x-4)          ", [0,1,4],   [1,-1,3,5,7,11,13], 300, 1, 3);
print("");
print("### azumaya finished");
quit;
