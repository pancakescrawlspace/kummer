/* ============================================================================
   depends-check.gp -- OUT-OF-SAMPLE test of survey document 10.7 (Theorem 5).

   For curves that appear nowhere else in the document, and for each of the
   three rank-one phi on a curve with full rational 2-torsion, this predicts
   the verdict at every odd bad place from reduction data ALONE (the recipe of
   10.6: split class, full local 2-torsion, canonical line vs phi) and then
   computes the symbol table directly to check it.

   Theorem 5 predicts more than the verdict: at a live place beta_v should be
   NON-DEGENERATE, so both descent images should be all four square classes and
   6 of the 16 ordered pairs should carry a non-trivial symbol -- 6 being the
   number of ordered independent pairs in F_2^2. At a dead place the descent
   map belonging to the canonical line should COLLAPSE to a single class.

   CAVEAT on the direct side: ppointsE samples x = +- m p^k with m <= 40, so a
   square class can be missed and an image reported as 3 rather than 4. A LIVE
   verdict is still a proof (the symbols are computed at actual points); a
   reported image size below 4 is a sampling artefact, and Lemma 4(b) says the
   true image is everything. A "dead" verdict here is evidence, not proof --
   the proof is the necessity half of Lemma 4.

   Functions: sqreps, tw, ntorsx, ismult, splitclass, canroot, symtab, oos.
   Output: results/survey-depends-check.txt
   ============================================================================ */

read("kummer2.gp"); read("survey.gp");
sqreps(v) = if(v == 2, [1,-1,2,-2,5,-5,10,-10], my(u = lift(znprimroot(v))); [1, u, v, u*v]);
tw(E, d) = ellminimalmodel(ellinit([-27*E.c4*d^2, -54*E.c6*d^3]));
ntorsx(E, v) = { my(ps = factorpadic(elldivpol(E,2), v, 40), c = 0);
  for(i = 1, #ps~, if(poldegree(ps[i,1]) == 1, c += ps[i,2])); c; }
ismult(E,v) = elllocalred(E,v)[2] > 4;
splitclass(E, v) = { my(r = sqreps(v), o = 0);
  for(i = 1, 2, my(Ed = tw(E, r[i])); if(ismult(Ed,v) && ellap(Ed,v) == 1, o = r[i])); o; }
/* canonical line among the roots es, at v */
canroot(es, v) = { my(Ea = ellinit([0, -(es[1]+es[2]+es[3]), 0,
    es[1]*es[2]+es[1]*es[3]+es[2]*es[3], -es[1]*es[2]*es[3]]), vD, lab = [0,0]);
  vD = valuation(ellminimalmodel(Ea).disc, v);
  for(i = 1, 3, if(valuation(ellminimalmodel(ellinit(ellisogeny(Ea, [es[i],0], 1))).disc, v) == 2*vD,
    lab = [1, i])); lab; }
/* DIRECT computation: the symbol table of (c_a, c_b) on E_d(Q_v) */
symtab(es, d, v, ia, ib) = { my(XM = 110); my(E = ellinit([0, -d*(es[1]+es[2]+es[3]), 0,
    d^2*(es[1]*es[2]+es[1]*es[3]+es[2]*es[3]), -d^3*es[1]*es[2]*es[3]]),
  pts, RA = List(), RB = List(), SA = Set(), SB = Set(), nz = 0, tot = 0, ca, cb);
  pts = ppointsE(E, v, 30, XM);
  for(k = 1, #pts, my(x0 = pts[k][1], u, w);
    ca = x0 - d*es[ia]; cb = x0 - d*es[ib];
    if(ca == 0 || cb == 0, next);
    if(valuation(ca,v) > 20 || valuation(cb,v) > 20, next);
    u = [valuation(ca,v)%2, if(issquare(Mod(truncate(ca/v^valuation(ca,v)),v)),1,-1)];
    w = [valuation(cb,v)%2, if(issquare(Mod(truncate(cb/v^valuation(cb,v)),v)),1,-1)];
    if(!setsearch(SA,u), SA=setunion(SA,[u]); listput(RA, truncate(ca*v^(-valuation(ca,v)))*v^valuation(ca,v)));
    if(!setsearch(SB,w), SB=setunion(SB,[w]); listput(RB, truncate(cb*v^(-valuation(cb,v)))*v^valuation(cb,v))));
  for(i = 1, #RA, for(j = 1, #RB, tot++; if(hilbert(RA[i],RB[j],v) != 1, nz++)));
  [#SA, #SB, nz, tot]; }
/* one fresh curve: predict, then verify */
oos(es, excl) = { my(Ea = ellinit([0, -(es[1]+es[2]+es[3]), 0,
    es[1]*es[2]+es[1]*es[3]+es[2]*es[3], -es[1]*es[2]*es[3]]), E, N, bad, ia, ib, k = 0);
  E = ellminimalmodel(Ea); N = ellglobalred(E)[1]; bad = factor(N)[,1]~;
  for(i = 1, 3, if(i != excl, k++; if(k == 1, ia = i, ib = i)));
  print("");
  print("f = (x-", es[1], ")(x-", es[2], ")(x-", es[3], ")   N = ", N,
        "   phi = (c_", ia, ", c_", ib, "), excluding e_", excl, " = ", es[excl]);
  for(i = 1, #bad, my(v = bad[i], cls, nt, lab, pred, got);
    if(v == 2, next);
    cls = splitclass(E, v);
    if(cls == 0, print("   v = ", v, "   no split class -- recipe: dead"); next);
    nt = ntorsx(tw(E,cls), v);
    lab = canroot(es, v);
    pred = (nt == 3) && (lab[1] == 0 || lab[2] == excl);
    got = symtab(es, cls, v, ia, ib);
    print("   v = ", v, "   split class d = ", cls, "   2-torsion x-coords ", nt, "/3",
          "   canonical line ", if(lab[1], concat(["e_", lab[2]]), "irrational"),
          "   RECIPE: ", if(pred, "LIVE", "dead"),
          "      DIRECT: |im c_a| = ", got[1], " |im c_b| = ", got[2],
          "  non-trivial symbols ", got[3], "/", got[4],
          "   ", if((got[3] > 0) == pred, "AGREE", "*** DISAGREE ***"))); }
print("=== out-of-sample: curves that appear nowhere in the document ===");
oos([0, 5, -4], 1); oos([0, 5, -4], 2); oos([0, 5, -4], 3);
oos([0, 9, -7], 1); oos([0, 9, -7], 2);
oos([1, 6, -6], 3);
quit;
