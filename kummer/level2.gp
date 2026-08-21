/* ============================================================================
   level2.gp -- the ell = 2 split case: the norm lemma fails, what replaces it,
   and why a genuinely additive critical place cannot be isolated.
   Survey document §10.10.

   (1) THE NORM LEMMA IS FALSE FOR SPLIT f.  It controls (c(P),c(P)) =
       (c(P),-1), which needs BOTH SLOTS to be the same descent map -- true only
       in the indecomposable case, where phi = N has ker N = im N.  For split f
       the rank-one phi has ker = C_a and im = C_b with a != b, and the diagonal
       is (c_a(P), c_b(P))_v, which nothing controls.  Checked below: it is
       non-trivial already at the 2-torsion points.

   (2) SO beta IS SYMMETRIC WITH A QUADRATIC REFINEMENT, not alternating.
       Isotropy of L_v gives (c_a(P),c_b(Q)) = (c_b(P),c_a(Q)), hence symmetry;
       q_v(P) = beta_v(P,P) is a quadratic refinement, and "alternating" is the
       special case q_v = 0.  Consequence: Lemma 3's dimension bound FAILS here,
       so a 1-dimensional W_v can be live -- which is exactly what happened at
       infinity for 15a1's second phi (10.5.1).

   (3) WHAT REPLACES IT at the places q | d.  For odd q | d with q not dividing
       2 disc f, every symbol reduces to root differences; the (T_b,T_a) term is
       Steinberg, (x,-x) = 1, and the rest collapse, giving

          beta_q = 0 for all such q   <==>   f'(e_a) and f'(e_b) are SQUARES.

       Lemma C of 7.1.2 is the case of 15a1: f'(e_1) = 400, f'(e_3) = 225.
       Writing r_1 < r_2 < r_3, p = r_2-r_1, q = r_3-r_2, the condition is
       p(p+q) and q(p+q) square, hence pq square; with p = g a^2, q = g b^2 it
       becomes a^2 + b^2 = square -- PYTHAGOREAN TRIPLES again, 15a1 being
       (3,4,5).  And beta_infinity dies for every d iff the EXCLUDED root is the
       middle one.

   (4) WHY NO ISOLATED ADDITIVE CRITICAL PLACE, FOR SPLIT f AT ODD v.  Two
       facts.  disc f is a perfect square for split f, so v(Delta_min) is EVEN
       at odd v, excluding III, III* and I_n* with n odd; and of the remaining
       potentially good types, II, IV, IV* and II* have Phi trivial or Z/3, so
       Phi[2] = 0 and Lemma 7 gives W_v = 0.  Only I0* is left -- and I0* IS a
       ramified quadratic twist of good reduction, so rescaling f by a square
       gives an equivalent model where the place is GOOD.

       THIS DOES NOT APPLY TO x^3 - 2, which is an honest additive example: its
       live class [u*3] at v = 3 has type IV* with c_3 = 3, and NO quadratic
       twist of it is good at 3.  It escapes the parity argument (f does not
       split), the Phi[2] argument (ell = 3 there, and Phi = Z/3 is what
       survives), and Lemma 7 itself, since v = ell -- Phi_3[3] is 1-dimensional
       while dim W_3 = 2, the missing dimension being the formal group.  So an additive live place is a q | d place in disguise,
       and those come as an infinite family indexed by the primes dividing d,
       all live or all dead together by the criterion in (3).  A surface-level
       statement needs them dead, so an additive place can never be the only
       live one.  Verified below: x(x-507)(x-845) is u(u-3)(u-5) rescaled by
       169, its "I0* at 13" is the class 13 | d, and in the good model 13 is not
       even a bad prime.

   Functions: fp, ci, diagonal, betaq, family, analyse.
   Output: results/survey-level2.txt
   ============================================================================ */
read("kummer2.gp"); read("survey.gp");

fp(es, i) = prod(k = 1, 3, if(k == i, 1, es[i]-es[k]));
ci(es, i, j) = if(i == j, fp(es,i), es[j]-es[i]);
kodname(k) = if(k==1,"I0", if(k==2,"II", if(k==3,"III", if(k==4,"IV", if(k>4, concat(["I",k-4]), if(k==-1,"I0*", if(k==-2,"II*", if(k==-3,"III*", if(k==-4,"IV*", concat(["I",-k-4,"*"]))))))))));
crv(es, d) = ellinit([0, -d*(es[1]+es[2]+es[3]), 0, d^2*(es[1]*es[2]+es[1]*es[3]+es[2]*es[3]), -d^3*es[1]*es[2]*es[3]]);
uni(a,v) = truncate(a*v^(-valuation(a,v)))*v^valuation(a,v);
cl(z,v) = if(v==2, [valuation(z,2)%2, lift(Mod(truncate(z/2^valuation(z,2)),8))], [valuation(z,v)%2, if(issquare(Mod(truncate(z/v^valuation(z,v)),v)),1,-1)]);
sqreps(v) = if(v == 2, [1,-1,2,-2,5,-5,10,-10], my(u = lift(znprimroot(v))); [1, u, v, u*v]);

/* (1) the diagonal beta(P,P) at the 2-torsion */
diagonal(nam, es, ia, ib, v) = { my(nz = 0);
  for(j = 1, 3, if(hilbert(ci(es,ia,j), ci(es,ib,j), v) != 1, nz++));
  print("   ", nam, "  v = ", v, "  phi = (c_", ia, ",c_", ib, "):  ", nz,
        " of the 3 two-torsion points have beta(P,P) != 0   ",
        if(nz, "==> NOT ALTERNATING", "==> alternating here")); }

/* (3) beta at a place q | d, from root differences */
betaq(es, ia, ib, q, m) = { my(d = q*m, nz = 0);
  for(j = 1, 3, for(k = 1, 3,
    my(a = if(j == ia, d^2*fp(es,ia), d*(es[j]-es[ia])),
       b = if(k == ib, d^2*fp(es,ib), d*(es[k]-es[ib])));
    if(hilbert(a, b, q) != 1, nz++))); nz; }
qdtest(nam, es, ia, ib) = { my(bad = 0, D = poldisc((x-es[1])*(x-es[2])*(x-es[3])));
  forprime(q = 3, 60, if(D % q == 0, next);
    foreach([1,2,3,5,7], m, if(m % q == 0, next); if(betaq(es,ia,ib,q,m), bad++)));
  print("   ", nam, "   f'(e_", ia, ") = ", fp(es,ia), if(issquare(fp(es,ia)), " (square)", " (NOT)"),
        "   f'(e_", ib, ") = ", fp(es,ib), if(issquare(fp(es,ib)), " (square)", " (NOT)"),
        "   ==> ", if(bad, concat([bad, " live (q,d) pairs"]), "every q | d DEAD")); }

/* the full local picture for one f and one phi */
live(es, d, v, ia, ib) = { my(E = crv(es,d), pts, RA=List(), RB=List(), SA=Set(), SB=Set(), nz=0);
  pts = ppointsE(E, v, 30, 45);
  for(k = 1, #pts, my(x0 = pts[k][1], a, b);
    a = x0 - d*es[ia]; b = x0 - d*es[ib];
    if(a == 0 || b == 0, next);
    if(valuation(a,v) > 20 || valuation(b,v) > 20, next);
    if(!setsearch(SA,cl(a,v)), SA=setunion(SA,[cl(a,v)]); listput(RA, uni(a,v)));
    if(!setsearch(SB,cl(b,v)), SB=setunion(SB,[cl(b,v)]); listput(RB, uni(b,v))));
  for(i=1,#RA, for(j=1,#RB, if(hilbert(RA[i],RB[j],v)!=1, nz++))); nz; }
analyse(es, ia, ib) = { my(E1 = ellminimalmodel(crv(es,1)), D, out = List());
  D = poldisc((x-es[1])*(x-es[2])*(x-es[3]));
  print("");
  print("   f = (x-", es[1], ")(x-", es[2], ")(x-", es[3], ")  phi = (c_", ia, ",c_", ib, ")",
        "   N = ", ellglobalred(E1)[1], "   bad ", factor(2*D)[,1]~);
  foreach(factor(2*D)[,1]~, v, foreach(sqreps(v), m,
    my(nz = live(es, m, v, ia, ib), Em = ellminimalmodel(crv(es,m)), r = elllocalred(Em, v));
    if(nz, listput(out, [v,m]);
      print("      v = ", v, "  d = ", m, "  ", kodname(r[2]), "  c_v = ", r[4],
            "  v(j) = ", valuation(Em.j,v), "   LIVE",
            if(r[2] <= 4 && r[2] != 1 && valuation(Em.j,v) >= 0, "   *** additive, potentially good ***", "")))));
  print("      live: ", Vec(out)); }

main() = {
  print("=== (1) the norm lemma fails for split f: beta is not alternating ===");
  diagonal("x(x-5)(x+5)", [0,5,-5], 2, 3, 5);
  diagonal("x(x-5)(x+5)", [0,5,-5], 1, 3, 5);
  diagonal("x(x-3)(x+3)", [0,3,-3], 2, 3, 3);
  print("");
  print("=== (3) what replaces it at q | d: f'(e_a) and f'(e_b) both squares ===");
  qdtest("15a1, phi = (c_1,c_3)", [17,1,-8], 1, 3);
  qdtest("15a1, phi = (c_2,c_3)", [17,1,-8], 2, 3);
  qdtest("x(x-9)(x-25)        ", [0,9,25], 1, 3);
  qdtest("x(x-3)(x-5)         ", [0,3,5], 1, 3);
  print("");
  print("=== the Pythagorean family: roots r, r+g a^2, r+g(a^2+b^2), a^2+b^2 square ===");
  analyse([0, 9, 25], 1, 3);       /* g=1, (3,4,5): the 15a1 surface */
  analyse([0, 63, 175], 1, 3);     /* g=7: I0* at 7, and it is DEAD */
  print("");
  print("=== (4) an additive live place is a q | d place in disguise (split f, odd v) ===");
  analyse([0, 507, 845], 1, 3);    /* I0* at 13 is live here ... */
  analyse([0, 3, 5], 1, 3);        /* ... but this is the SAME surface, 13 good */
  print("");
  print("=== but x^3 - 2 IS an honest additive example, at the WILD place ===");
  x32(); }
x32() = { my(E = ellminimalmodel(ellinit([0,0,0,0,-2])), E6, g = 0);
  foreach([1,2,3,6], d, my(F = ellminimalmodel(ellinit([-27*E.c4*d^2, -54*E.c6*d^3])), r = elllocalred(F,3));
    print("   d = ", d, "   type ", kodname(r[2]), "   c_3 = ", r[4]));
  E6 = ellminimalmodel(ellinit([-27*E.c4*36, -54*E.c6*216]));
  foreach([1,-1,2,-2,3,-3,6,-6,5,-5,10,-10,15,-15,30,-30,7,-7,21,-21], d,
    if(elllocalred(ellminimalmodel(ellinit([-27*E6.c4*d^2, -54*E6.c6*d^3])),3)[2] == 1, g = 1));
  print("   the live class [u*3] has type IV* with c_3 = 3, and a quadratic twist of it good at 3: ",
        if(g, "exists", "DOES NOT EXIST -- honest additive reduction"));
  print("   it escapes the parity argument (f does not split), the Phi[2] argument");
  print("   (ell = 3, and Phi = Z/3 is what survives), and Lemma 7 itself (v = ell)."); }
main();
print("");
print("### level2 finished");
quit;
