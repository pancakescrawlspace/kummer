/* ============================================================================
   selmer-local2.gp -- the local condition at v = 2 for the Selmer involution
   a |-> -1/a.  Companion to selmer-involution.typ, section 7.

   Both L_2(E_a) and L_2(E_{-1/a}) are computed inside ONE algebra,
   A_2 = Q_2[theta] = Q_2 x K with theta^3 = -a and K = Q_2(zeta) the
   unramified quadratic extension, using the canonical identification
   theta' = -1/theta of Theorem A.  E' has roots theta'_i = -1/theta_i, so its
   descent value at X is X + 1/theta in the Q_2-component and
   X - theta'_2 = (X - 1/theta) - (1/theta) zeta in the K-component.

   THE CHECK IS EXHAUSTIVE, not a sample.  Over Q_2 every unit is a cube, so
   E_a depends only on the class of a in Q_2^x modulo squares -- for a odd,
   only on a mod 8.  Four classes, all four checked.

   TWO BUGS were hit getting here, both worth recording:
     * comparing L_2(y^2=x^3+a) with L_2(y^2=x^3-a) under the NAIVE
       identification "cube root <-> cube root" instead of theta' = -1/theta.
       Those differ by an automorphism of E[2], so it compares subspaces of two
       different copies of H^1 and reports a spurious disagreement.
     * the 2-torsion entry for E\': theta\'_1 - theta\'_2 = (zeta^2-1)/theta
       = (-2-zeta)/theta, i.e. [-2/th, -1/th].  Getting it wrong inflated the
       group to order 8, which is already impossible since dim L_2 = 2.
   Both were caught by parity: a lone discrepancy at 2 would force the Selmer
   ranks to differ by an odd number, contradicting the computation.

   Functions: kmul, kval, kissq, kinv, samecl, mulcl, addto, closure, LE, LEp.
   Output: results/selmer-local2.txt
   ============================================================================ */

PR = 40;
kmul(A,B) = [A[1]*B[1] - A[2]*B[2], A[1]*B[2] + A[2]*B[1] - A[2]*B[2]];
kval(A) = min(if(A[1]==0, oo, valuation(A[1],2)), if(A[2]==0, oo, valuation(A[2],2)));
kissq(A) = { my(v = kval(A), u, found = 0);
  if(v % 2, return(0));
  u = [A[1]/2^v, A[2]/2^v];
  for(w0 = 0, 15, for(w1 = 0, 15,
    my(s = kmul([w0,w1],[w0,w1]));
    if((lift(Mod(s[1]-u[1],16)) == 0) && (lift(Mod(s[2]-u[2],16)) == 0), found = 1)));
  found; }
kinv(A) = { my(n = A[1]^2 - A[1]*A[2] + A[2]^2); [(A[1]-A[2])/n, -A[2]/n]; }
samecl(P, Q) = { my(r = P[1]/Q[1]);
  if(valuation(r,2) % 2, return(0));
  if(lift(Mod(truncate(r/2^valuation(r,2)), 8)) != 1, return(0));
  kissq(kmul(P[2], kinv(Q[2]))); }
mulcl(P, Q) = [P[1]*Q[1], kmul(P[2], Q[2])];
addto(L, P) = { for(i = 1, #L, if(samecl(L[i], P), return(L))); listput(L, P); L; }
closure(L) = { my(new = 1);
  while(new, new = 0;
    for(i = 1, #L, for(j = 1, #L,
      my(P = mulcl(L[i], L[j]), fnd = 0);
      for(k = 1, #L, if(samecl(L[k], P), fnd = 1; break));
      if(!fnd, listput(L, P); new = 1))));
  L; }
/* BOTH conditions computed in the SAME algebra A = Q_2[theta], theta^3 = -a.
   E : y^2 = x^3 + a,   roots theta, theta*zeta, theta*zeta^2
       descent at x:  [x - theta,  [x, -theta]]
   E': Y^2 = X^3 - 1/a, roots theta'_i = -1/theta_i
       descent at X:  [X + 1/theta, [X - 1/theta, -1/theta]]     */
LE(a, XMAX) = { my(th = sqrtn(-a + O(2^PR), 3), L = List(), z);
  listput(L, [1, [1,0]]);
  listput(L, [3*th^2, [th, -th]]);                       /* the 2-torsion point */
  for(k = -6, XMAX, for(m = 1, 80, if(m % 2 == 0, next);
    foreach([1,-1], sg, my(x = sg*m*2^k);
      z = x^3 + a + O(2^PR);
      if(z == 0 || valuation(z,2) % 2 != 0 || !issquare(z) || x - th == 0, next);
      L = addto(L, [x - th, [x, -th]]))));
  closure(L); }
LEp(a, XMAX) = { my(th = sqrtn(-a + O(2^PR), 3), t1, L = List(), z);
  t1 = -1/th;                                            /* the rational root of E' */
  listput(L, [1, [1,0]]);
  /* 2-torsion of E': g'(t1) = 3 t1^2, and
     t1 - theta'_2 = -1/th + zeta^2/th = (-2 - zeta)/th  ->  [-2/th, -1/th] */
  listput(L, [3*t1^2, [-2/th, -1/th]]);
  for(k = -6, XMAX, for(m = 1, 80, if(m % 2 == 0, next);
    foreach([1,-1], sg, my(X = sg*m*2^k);
      z = X^3 - 1/a + O(2^PR);
      if(z == 0 || valuation(z,2) % 2 != 0 || !issquare(z) || X - t1 == 0, next);
      L = addto(L, [X + 1/th, [X - 1/th, -1/th]]))));
  closure(L); }
main() = { my(ok = 1);
  print("=== L_2(E_a) versus L_2(E_{-1/a}), compared in ONE algebra ===");
  print("    identification theta' = -1/theta, as in Theorem A");
  foreach([1,3,5,7,-1,-3,9,11], a,
    my(A = LE(a,5), B = LEp(a,5), same = 1);
    if(#A != #B, same = 0);
    for(i = 1, #A, my(f = 0);
      for(j = 1, #B, if(samecl(A[i], B[j]), f = 1; break));
      if(!f, same = 0));
    if(!same, ok = 0);
    print("   a = ", a, "   |L_2(E)| = ", #A, "   |L_2(E')| = ", #B,
          "   ", if(same, "EQUAL", "*** DIFFERENT ***")));
  print("");
  print("   ==> ", if(ok, "L_2 AGREES: the local conditions at 2 coincide", "they differ")); }
\\ Run standalone.  A caller that only wants LE/LEp sets NOAUTORUN = 1 before
\\ read()ing this file (an undefined NOAUTORUN is a t_POL, so != 1 is true).
if(NOAUTORUN != 1, main(); quit);
