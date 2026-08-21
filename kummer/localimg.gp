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

/* ---------------- level 2: classes in Q_v^x modulo squares ---------------- */
sqcls(z, v) = { my(k = valuation(z, v), u = z/v^k);
  if(v == 2, [k % 2, lift(Mod(truncate(u), 8))],
             [k % 2, if(issquare(Mod(truncate(u), v)), 1, -1)]); }
inEn(P, v, n) = (P == [0]) || (valuation(P[1], v) <= -2*n);

/* 2E(Q_v) contains E_1 for v odd (E_1 is pro-v, so uniquely 2-divisible), and
   contains 2E_2 = E_3 at v = 2 (E_2(Q_2) = Z_2, torsion-free, since the formal
   logarithm converges from level e/(p-1) + 1 = 2 on). */
lvl2(v) = if(v == 2, 3, 1);
genq(Em, v, pts) = {
  my(n = lvl2(v), Ep = padiccurve(Em, v), G = List([[0]]), nw, grew = 1, T);
  for(k = 1, #pts, nw = 1;
    for(j = 1, #G, if(inEn(elladd(Ep, pts[k], ellneg(Ep, G[j])), v, n), nw = 0; break));
    if(nw, listput(G, pts[k])));
  while(grew, grew = 0;
    for(i = 1, #G, for(j = 1, #G, T = elladd(Ep, G[i], G[j]); nw = 1;
      for(k = 1, #G, if(inEn(elladd(Ep, T, ellneg(Ep, G[k])), v, n), nw = 0; break));
      if(nw, listput(G, T); grew = 1))));
  [#G, Mval(Em, v) * if(v == 2, 4, 1)];
}

/* f = u(u^2 + a u + b), c(P) = x(P) modulo squares, T = (0,0). c(T) = b d^2 is
   a square, so the 2-torsion point contributes the trivial class. */
runc(name, a, b, d, v, prec, XMAX) = {
  my(ev = [0, a*d, 0, b*d^2, 0], E = ellinit(ev), Em, vE, pts, S = Set([[0,1]]), g);
  Em = ellminimalmodel(E, &vE);
  pts = ppointsE(E, v, prec, XMAX);
  g = genq(Em, v, apply(P -> ellchangepoint(P, vE), pts));
  for(k = 1, #pts,
    if(valuation(pts[k][1], v) > prec - 10, next);
    S = setunion(S, [sqcls(pts[k][1], v)]));
  print("   ", name, "  d = ", d, "   class of d at ", v, ": ", sqcls(d, v),
        "   generates ", g[1], " of ", g[2], if(g[1] == g[2], " yes", " NO"),
        "      image of c: ", #S, " classes ", Vec(S));
  #S;
}

print("");
print("=== 15a4, f = x(x^2 + 14x + 625), level 2 ===");
print("");
print("--- v = 5, the critical place: the image of c must be ALL FOUR classes.");
print("    Only the failing class [1] of Q_5^x occurs, so one d settles it. ---");
foreach([1, 4, 11, 19, 21], d, runc("15a4", 14, 625, d, 5, 40, 40));
print("");
print("--- v = 2, the wild place: the image of c must have order at most 2,");
print("    since beta is alternating there (Lemma 2). The class of d at 2 is");
print("    unconstrained by the class at 5, so all EIGHT classes are needed. ---");
foreach([1, -1, 2, -2, 5, -5, 10, -10, 34], d, runc("15a4", 14, 625, d, 2, 40, 40));


/* ---------------- 15a1, f = (x-17)(x-1)(x+8), level 2 ----------------
 * beta_v(P,Q) = (c_1(P), c_3(Q))_v with c_i(P) = x(P) - d e_i, and
 * c_i(T_i) = prod_{j != i} d(e_i - e_j) at the 2-torsion point T_i. */
EE = [17, 1, -8];
E15a1(d) = [0, -d*(EE[1]+EE[2]+EE[3]), 0, d^2*(EE[1]*EE[2]+EE[1]*EE[3]+EE[2]*EE[3]), -d^3*EE[1]*EE[2]*EE[3]];
cval(d, i, X, v, prec) = if(valuation(X - d*EE[i], v) > prec - 10, prod(j = 1, 3, if(j == i, 1, d*(EE[i] - EE[j]))), X - d*EE[i]);
unitpart(a, v) = truncate(a*v^(-valuation(a, v))) * v^valuation(a, v);

run1(d, v, prec, XMAX, wantgen) = {
  my(E = ellinit(E15a1(d)), Em, vE, pts, g, S1 = Set(), S3 = Set(), bad = 0,
     R1 = List(), R3 = List(), tot);
  Em = ellminimalmodel(E, &vE);
  pts = ppointsE(E, v, prec, XMAX);
  g = if(wantgen, genq(Em, v, apply(P -> ellchangepoint(P, vE), pts)), [0,0]);
  for(k = 1, #pts,
    my(a = cval(d,1,pts[k][1],v,prec), b = cval(d,3,pts[k][1],v,prec));
    S1 = setunion(S1, [sqcls(a, v)]); S3 = setunion(S3, [sqcls(b, v)]);
    listput(R1, unitpart(a, v)); listput(R3, unitpart(b, v)));
  tot = #R1 * #R3;
  for(i = 1, #R1, for(j = 1, #R3, if(hilbert(R1[i], R3[j], v) != 1, bad++)));
  print("   d = ", d, "   class of d at ", v, ": ", sqcls(d, v),
        if(wantgen, Str("   generates ", g[1], " of ", g[2],
                        if(g[1] == g[2], " yes", " NO")), ""),
        "   |im c_1| = ", #S1, "  |im c_3| = ", #S3,
        "   non-trivial symbols: ", bad, " of ", tot);
  [Vec(S1), Vec(S3), bad];
}

print("");
print("=== 15a1, f = (x-17)(x-1)(x+8), level 2 ===");
print("");
print("--- v = 5, the critical place: c_1 must be onto Q_5^x/squares, and");
print("    beta_5 must be non-trivial. One class of Q_5^x, namely [1]. ---");
foreach([1, -1, 11, 19], d, run1(d, 5, 40, 40, 1));
print("");
print("--- v = 3: every symbol must be trivial. All four classes. ---");
foreach([1, 2, 3, 6], d, run1(d, 3, 40, 40, 1));
print("");
print("--- v = 2: every symbol must be trivial. All eight classes. ---");
foreach([1, -1, 2, -2, 5, -5, 10, -10], d, run1(d, 2, 40, 40, 1));
print("");
print("--- odd q | d, q not 3 or 5: the Lemma of section 6.1.3 predicts");
print("    im c_1 = {1, -q d'} and im c_3 = {1, q d'} with d = q d'.");
print("    The Lemma proves this for q not dividing 2*3*5*17; at q = 17 the");
print("    third case of its proof needs 17 | e_1 = 17 handled separately, and");
print("    17 | d leaves only TWO classes of d in Q_17^x, both run below. ---");
qcheck(q, d) = { my(r = run1(d, q, 30, 30, 0), dp = d/q); print("        predicted im c_1 = {", sqcls(1,q), ", ", sqcls(-q*dp,q), "}   im c_3 = {", sqcls(1,q), ", ", sqcls(q*dp,q), "}   agrees: ", Set(r[1]) == Set([sqcls(1,q), sqcls(-q*dp,q)]) && Set(r[2]) == Set([sqcls(1,q), sqcls(q*dp,q)]) && r[3] == 0); }
foreach([[7,7],[7,14],[7,-7],[11,11],[11,-22],[13,13],[23,23],[29,58],[17,17],[17,34],[17,-17],[17,323],[17,51],[17,-51],[17,17*7]], w, qcheck(w[1], w[2]));

print("");
print("### localimg finished");
quit;
