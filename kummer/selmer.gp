/* ============================================================================
   selmer.gp -- the 2-Selmer involution a |-> -1/a, companion to
   selmer-involution.typ.  MathOverflow 227987.

   CONJECTURE (Pannekoek).  For a odd, y^2 = x^3 + a and y^2 = x^3 - 1/a
   (isomorphic to y^2 = x^3 - a^5) have equal 2-Selmer ranks.

   Sage's selmer_rank is dim_F2 Sel_2.  PARI's ellrank returns [r1,r2,s,L] with
   C = T + r2 + s, T = dim E(Q)[2], which is 1 exactly when x^3+a has a rational
   root.  That is what C2 computes.

   THEOREM A (see the document): theta |-> -1/theta is an isomorphism of
   Q-algebras Q[t]/(t^3+a) -> Q[t]/(t^3-1/a), so the two curves have ISOMORPHIC
   mod-2 Galois modules -- although they are not isogenous.  Hence both 2-Selmer
   groups sit inside one and the same H^1(Q, M), which is why the ranks are
   correlated at all.  `samemod` checks this: the factorisation types of the two
   cubics agree at every good prime, and the 2-division fields are isomorphic.

   Functions: dimtors2, C2, compare2, samemod, run.  (NB: `cmp` is a PARI
   builtin, so the comparison driver cannot be called that.)
   Output: results/selmer-involution.txt
   ============================================================================ */

dimtors2(E) = { my(f = factor(x^3 + E.a6)); sum(i = 1, #f~, if(poldegree(f[i,1]) == 1, 1, 0)); }
C2(k) = { my(E, r);
  E = ellinit([0,0,0,0,k]);
  if(E == 0 || E.disc == 0, return(-1));
  r = ellrank(E);
  if(dimtors2(E) > 0, 1, 0) + r[2] + r[3]; }
compare2(nam, lst) = { my(ag = 0, dis = 0);
  print(""); print("=== ", nam, " ===");
  foreach(lst, a,
    my(c1 = C2(a), c2 = C2(-a^5));
    if(c1 < 0 || c2 < 0, next);
    if(c1 == c2, ag++, dis++;
      print("   a = ", a, "   Sel2(x^3+a) = ", c1, "   Sel2(x^3-a^5) = ", c2,
            "   *** DISAGREE by ", abs(c1-c2), " ***")));
  print("   --- ", ag, " agree, ", dis, " disagree ---"); }
factype(f, q) = { my(F = factor(Mod(1,q)*f)); vecsort(vector(#F~, i, poldegree(F[i,1]))); }
samemod(a) = { my(f = x^3+a, g = x^3-a^5, bad = 0, n = 0, K1, K2);
  forprime(q = 5, 300,
    if(q == 3 || (6*a) % q == 0, next);
    n++; if(factype(f,q) != factype(g,q), bad++));
  K1 = polredbest(polcompositum(f, x^2+3)[1]);
  K2 = polredbest(polcompositum(g, x^2+3)[1]);
  print("   a = ", a, "   factorisation types agree at ", n-bad, " of ", n,
        " good primes   2-division fields ",
        if(nfisisom(K1, K2), "ISOMORPHIC", "*** DIFFERENT ***")); }

run() = {
  print("=== Theorem A: the two curves share their mod-2 Galois module ===");
  foreach([3,5,7,9,11,13,15,25,27,-5,-7,49,121], a, samemod(a));
  compare2("odd a, |a| <= 25", select(x -> x % 2 != 0, vector(51, i, i-26)));
  compare2("odd a, prime powers and composites", [3,5,7,9,15,21,25,27,33,35,45,49,55,63,75,81,99,121,125]);
  compare2("odd a < 0", [-3,-5,-7,-9,-15,-21,-25,-27,-33,-35,-45,-49]);
  compare2("EVEN a -- the hypothesis is needed", [2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,32]);
}
run();
print("");
print("### selmer finished");
quit;
