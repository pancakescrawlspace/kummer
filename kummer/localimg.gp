/* localimg.gp --- the local statements of section 6, made exhaustive.
 *
 * Several steps in section 6 are stated as checks over a range of global twists
 * ("all 202 twists", "640 of 640 places"). Each is really a statement about
 * E_d over a single Q_v, and E_d over Q_v depends on d only through its class
 * in Q_v^x modulo squares -- a group of order 4 for v odd and 8 for v = 2. So a
 * bounded number of local computations settles every squarefree d at once.
 *
 * Two things make each computation a proof rather than a sample:
 *   (1) the sampled points are shown to GENERATE the relevant finite quotient
 *       of E_d(Q_v), and the descent maps are homomorphisms, so their image on
 *       a generating set is the whole image;
 *   (2) the class of a value in Q_v^x modulo ell-th powers is read off from the
 *       valuation and finitely many digits, so no precision is lost.
 *
 * ell E(Q_v) contains ell E_1, and E_1 is uniquely ell-divisible when v != ell,
 * so it is enough to generate E(Q_v)/E_1 at v != ell and E(Q_v)/E_2 at v = ell.
 *
 * Run:  gp -q -s 4000000000 < localimg.gp
 */

read("kummer2.gp");
read("survey.gp");

/* ---- classes in Q_v^x modulo cubes, for v = 1 mod 3 (so mu_3 is in Q_v) ---- */
cubcls(z, v) = { my(k = valuation(z, v), u = z/v^k);
                 [k % 3, lift(Mod(truncate(u), v)^((v-1)/3))]; }

gv(ev, X)  = X^3 + ev[2]*X^2 + ev[4]*X + ev[5];
dgv(ev, X) = 3*X^2 + 2*ev[2]*X + ev[4];

/* does the sample generate E(Q_v)/E_1 ?  (v != ell) */
gen1(Em, v, pts) = {
  my(Ep = padiccurve(Em, v), G = List([[0]]), nw, grew = 1, T);
  for(k = 1, #pts, nw = 1;
    for(j = 1, #G, if(inE1(elladd(Ep, pts[k], ellneg(Ep, G[j])), v), nw = 0; break));
    if(nw, listput(G, pts[k])));
  while(grew, grew = 0;
    for(i = 1, #G, for(j = 1, #G, T = elladd(Ep, G[i], G[j]); nw = 1;
      for(k = 1, #G, if(inE1(elladd(Ep, T, ellneg(Ep, G[k])), v), nw = 0; break));
      if(nw, listput(G, T); grew = 1))));
  [#G, Mval(Em, v)];
}

/* ---------------- 14a1 at v = 7, level 3 ----------------
 * E_d : Y^2 = X^3 + d(5X + 28d)^2, a model of the twist by d of 14a1 in
 * 3-torsion normal form. Both lines of E[3] are Q_7-rational because
 * 7 = 1 mod 3; c_i is evaluation of the tangent at a generator of the i-th.
 * Claim of section 6.2.2: the image of (c_1, c_2) on W_7 has 9 elements, so
 * c_1 alone identifies W_7 with Q_7^x modulo cubes. */
E14(d) = [0, 25*d, 0, 280*d^2, 784*d^3];

run7(d, prec, XMAX) = {
  my(ev = E14(d), E = ellinit(ev), Em, vE, K, xs, ys, ms, pts, img = List(),
     g, diag = 0, anti = 0, tri = 1);
  Em = ellminimalmodel(E, &vE);
  K  = select(f -> poldegree(f) == 1, Vec(factor(elldivpol(E, 3))[,1]~));
  if(#K != 2, print("   d = ", d, ": ", #K, " rational lines -- skipped"); return);
  xs = vector(2, i, -polcoef(K[i], 0)/polcoef(K[i], 1));
  ys = vector(2, i, sqrt(gv(ev, xs[i]) + O(7^prec)));
  ms = vector(2, i, dgv(ev, xs[i])/(2*ys[i]));
  /* the tangent at a point of order 3 meets E only there: check that
     g(x) - (y_i + m_i(x - x_i))^2 is (x - x_i)^3 to full precision */
  for(i = 1, 2,
    my(D = gv(ev, x) - (ys[i] + ms[i]*(x - xs[i]))^2 - (x - xs[i])^3);
    for(j = 0, 2, if(valuation(polcoef(D, j) + O(7^prec), 7) < prec - 8, tri = 0)));
  pts = ppointsE(E, 7, prec, XMAX);
  g = gen1(Em, 7, apply(P -> ellchangepoint(P, vE), pts));
  for(k = 1, #pts,
    my(L1 = pts[k][2] - ys[1] - ms[1]*(pts[k][1] - xs[1]),
       L2 = pts[k][2] - ys[2] - ms[2]*(pts[k][1] - xs[2]));
    if(valuation(L1, 7) > prec - 10 || valuation(L2, 7) > prec - 10, next);
    img = List(setunion(Set(Vec(img)), [[cubcls(L1, 7), cubcls(L2, 7)]])));
  for(k = 1, #img,
    my(a = img[k][1], b = img[k][2]);
    if(a == b, diag++);
    if(a[1] == (-b[1]) % 3 && lift(Mod(a[2]*b[2], 7)) == 1, anti++));
  print("   d = ", d, "   lines at x = ", xs, "   tangents triple: ", tri == 1,
        "   generates E(Q_7)/E_1: ", g[1], " of ", g[2],
        if(g[1] == g[2], " yes", " NO"));
  print("      image of (c_1, c_2): ", #img, " elements;  on the diagonal ",
        diag, ", on the ANTIdiagonal ", anti,
        if(anti == #img && #img == 9, "   => c_2 = c_1^-1, so c_1 is an isomorphism W_7 -> Q_7^x/cubes", ""));
}

print("=== 14a1 at v = 7 (level 3): the image of the two descent maps ===");
print("");
print("Only the class [1] of Q_7^x matters (that is the failing class), and");
print("E_d over Q_7 depends only on that class, so one d settles it; the rest");
print("are consistency checks.");
print("");
foreach([1, 2, 4, 8, 11, 22], d, run7(d, 40, 40));
print("");
print("### localimg finished");
quit;
