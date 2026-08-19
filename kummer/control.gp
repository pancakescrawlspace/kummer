read("kummer2.gp");

/* =====================================================================
   Control experiment for the open case at p = 3   (document, section 5.2.2)

   For f = x^3-2 the square class [u*3] at p = 3 admits no witness, and
   E_d(Q_3)/E_1 = (Z/3)^2 there, so rank >= 2 is needed and never suffices.
   Is that about the local structure, about p = 3, or about the curve?

   At p = 3, M = 9 forces additive reduction with c_3 = 3, and other curves
   have classes with exactly that local structure -- so the phenomenon can
   be tested against controls.

     armA(A,B,p,class,DMAX)  p != 3 with M = 9: do rank>=2 twists surject?
                             (x^3-2 at p=7, class [u]: 20 of 25 do)
     find3(A,B)              which classes of f have M = 9 at p = 3
     armB(A,B,class,DMAX)    same question at p = 3

   Result: CM is NOT necessary (x^3+21x+-26 is non-CM and obstructed), and
   decomposable E[3] is necessary in every observed case but not sufficient
   (x^3-24x+-26 is decomposable and behaves normally).  The obstructed and
   non-obstructed non-CM families are locally indistinguishable at 3, so the
   obstruction cannot be local.
   ===================================================================== */

PREC = 60;

inE1p(P, p) = (P == [0]) || (valuation(P[1],p) < 0);

/* Q_p-points with integral x on the minimal model Em */
sampleE(Em, p, XMAX) = {
  my(L = List(), s, y, x0, a4, a6);
  a4 = Em.a4; a6 = Em.a6;
  if(Em.a1 || Em.a2 || Em.a3, return(0));      /* only short models here */
  for(x0 = -XMAX, XMAX,
    s = x0^3 + a4*x0 + a6;
    if(s == 0, next);
    if(valuation(s,p) % 2, next);
    if(kronecker(s/p^valuation(s,p), p) != 1, next);
    y = sqrt(s + O(p^PREC));
    listput(L, [x0 + O(p^PREC), y]);
    listput(L, [x0 + O(p^PREC), -y])
  );
  Vec(L);
}
/* structure of Em(Qp)/E_1 : returns [#cosets, max order of a coset] */
quotstruct(Em, p, XMAX) = {
  my(Ep, S, R = List(), Q, new, i, j, ords, P, o, n);
  Ep = ellinit([Em.a4 + O(p^PREC), Em.a6 + O(p^PREC)]);
  S = sampleE(Em, p, XMAX);
  if(S == 0, return(0));
  for(i = 1, #S,
    new = 1;
    for(j = 1, #R, Q = ellsub(Ep, S[i], R[j]); if(inE1p(Q,p), new = 0; break()));
    if(new, listput(R, S[i]))
  );
  ords = vector(#R, i,
    P = R[i]; Q = R[i]; o = 0;
    for(n = 1, 40, if(inE1p(Q,p), o = n; break()); Q = elladd(Ep, Q, P)); o);
  [#R + 1, if(#R, vecmax(ords), 1)];
}

/* --- Arm A: p != 3, quotient (Z/3)^2 : do rank-2 twists surject there? --- */
armA(A, B, p, target, DMAX) = {
  my(d, n, sg, td, qs, nrk2 = 0, nwin = 0, shown = 0);
  for(n = 1, DMAX,
    if(!issquarefree(n), next);
    for(sg = 0, 1,
      d = if(sg==0, n, -n);
      if(sqclass(d,p) != target, next);
      td = twistdata(A, B, d);
      if(Mval(td[1],p) != 9, next);
      if(td[3] < 2, next);
      nrk2++;
      if(densegroup(td[1], td[2], p),
        nwin++;
        if(shown < 4, shown++;
           qs = quotstruct(td[1], p, 400);
           print("   d=", d, "  rank ", td[3], "  M=9  quotient [#,maxord]=", qs,
                 "  DENSE")))
    ));
  print("   -> rank>=2 twists with M=9: ", nrk2, ",  of which dense: ", nwin);
}

/* --- Arm B: p = 3, find (f, class) with M = 9, then test rank-2 twists --- */
find3(A, B) = {
  my(k, d, res = List(), td);
  for(k = 0, 3,
    d = 0;
    for(n = 1, 400,
      if(!issquarefree(n), next);
      for(sg = 0, 1,
        my(dd = if(sg==0, n, -n));
        if(sqclass(dd,3) == k, d = dd; break(2))));
    if(d == 0, next);
    td = twistdata(A, B, d);
    if(Mval(td[1], 3) == 9, listput(res, [k, d, elllocalred(td[1],3)[4]]))
  );
  Vec(res);
}
armB(A, B, target, DMAX) = {
  my(d, n, sg, td, nrk2 = 0, nwin = 0, qs, shown = 0);
  for(n = 1, DMAX,
    if(!issquarefree(n), next);
    for(sg = 0, 1,
      d = if(sg==0, n, -n);
      if(sqclass(d,3) != target, next);
      td = twistdata(A, B, d);
      if(Mval(td[1],3) != 9, next);
      if(td[3] < 2, next);
      nrk2++;
      if(densegroup(td[1], td[2], 3),
         nwin++;
         if(shown < 3, shown++;
            print("      *** DENSE: d=", d, " rank ", td[3])))
    ));
  print("      rank>=2 twists with M=9: ", nrk2, ",  dense: ", nwin);
}

/* ---- which places can support a non-zero beta_v ?  (document, 5.2.4) ----
   For l != 3, W_l = E_d(Q_l)[3], and for E_d : y^2 = x^3 - 2d^3 the 3-torsion
   sits at x = 0 (y^2 = -2d^3) and x = 2d (y^2 = 6d^3).  So W_l != 0 iff -2d
   or 6d is a square in Q_l.  For l | d with l not 2,3 and d squarefree both
   have valuation 1, hence are non-squares: W_l = 0.  Only l = 2 survives, and
   only for even d.                                                          */
sqinQ2(a) = { my(v, u); if(a == 0, return(0)); v = valuation(a,2); u = a/2^v;
              (v % 2 == 0) && (u % 8 == 1); }
sqinQl(a, l) = { my(v); if(a == 0, return(0)); v = valuation(a,l);
                 (v % 2 == 0) && (kronecker(a/l^v, l) == 1); }
placeaudit(D) = {
  my(n, sg, d, fa, i, l, bad2 = 0, badl = 0, tot = 0);
  for(n = 1, D,
    if(!issquarefree(n), next);
    for(sg = 0, 1,
      d = if(sg == 0, n, -n);
      if(sqclass(d,3) != 3, next);
      tot++;
      fa = factor(abs(6*d))[,1]~;
      for(i = 1, #fa,
        l = fa[i];
        if(l == 3, next);
        if(l == 2,
          if(sqinQ2(-2*d) || sqinQ2(6*d), bad2++)
        ,
          if(sqinQl(-2*d,l) || sqinQl(6*d,l), badl++;
             print("  *** unexpected: W_l != 0 at l=", l, " for d=", d))))));
  print("  class [u*3], |d| <= ", D, " : ", tot, " twists");
  print("  places l | d outside {2,3} with W_l != 0 : ", badl, "  (proved to be 0)");
  print("  twists with W_2 != 0 (all even d) : ", bad2, " of ", tot);
}
