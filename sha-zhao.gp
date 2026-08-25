/* ============================================================================
   sha-zhao.gp -- testing what the Zhao-method literature can say about
   E_p : y^2 = x^3 + p x at the Fermat primes.  Companion to sha-zhao.typ.

   Nomoto (arXiv:2207.10380, Thm 1.1) treats EXACTLY this family: y^2 = x^3+Dx
   over K = Q(i) with D quartic-free, and proves
        v_2( L_2(psibar_{-D},1) / Omega ) >= (r(D) - 2)/2,
   with r(D) the number of distinct primes of O_K dividing D.  For D = p a
   rational prime = 1 mod 4 the prime SPLITS, so r(D) = 2 and the bound is 0 --
   vacuous, while the truth for Fermat primes is 2k-3, growing without bound.

   Nomoto's Prop 2.1 gives the local invariant at 2: E_{-D} has good reduction
   at (1+i) iff (i/D)_4 = i.  For D = p rational, (i/p)_4 = i^((p-1)/2), which
   is 1 for every p = 1 mod 8 -- CONSTANT on the family, so it cannot account
   for any growth.  Checked below.

   Also eliminated below: v_2(p-1) does not determine the answer (193 and 577
   share v_2(p-1) = 6 with m = 1 and 2).

   Output: results/sha-zhao.txt
   ============================================================================ */

/* Nomoto arXiv:2207.10380, Prop 2.1: E_{-D}: y^2 = x^3+Dx has good reduction
   at (1+i) iff (i/D)_4 = i.  For D = p a rational prime = 1 mod 4, p = pi*pibar,
   (i/p)_4 = (i/pi)_4 (i/pibar)_4 = i^((p-1)/4) i^((p-1)/4) = i^((p-1)/2).      */
sym(p) = { my(e = ((p-1)/2) % 4); ["1","i","-1","-i"][e+1]; }
ab(p) = { my(v = qfbsolve(Qfb(1,0,1), p), A = abs(v[1]), B = abs(v[2]));
  if(A % 2 == 0, [B, A], [A, B]); }
mval(p) = { my(E = ellminimalmodel(ellinit([p,0])), ar, r);
  ar = ellanalyticrank(E); if(ar[1] != 0, return(-1));
  r = round(ar[2]/E.omega[1]);
  if(r == 0 || r % 2 != 0 || !issquare(r/2), return(-1)); sqrtint(r/2); }
go() = {
  print("=== Nomoto's r(D) for D = p a rational prime ===");
  print("   p splits in Z[i] as pi*pibar, so r(D) = 2 and the bound");
  print("   v_2 >= (r(D)-2)/2 = 0 is VACUOUS.  Zhao's D in K^*2 bound gives 1/2.");
  print("");
  print("=== the quartic symbol (i/p)_4 = i^((p-1)/2) on our family ===");
  foreach([17, 41, 97, 137, 193, 257, 577, 65537], p,
    print("   p = ", p, "   p mod 8 = ", p % 8, "   (i/p)_4 = ", sym(p),
          "   good reduction at (1+i)? ", if(sym(p) == "i", "yes", "NO")));
  print("   -> constant on the whole family, so it cannot explain any growth.");
  print("");
  print("=== does v_2(p-1) determine v_2(L(1)/Omega)? ===");
  foreach([17, 41, 97, 193, 257, 577, 65537], p,
    my(m = mval(p));
    print("   p = ", p, "   v_2(p-1) = ", valuation(p-1,2),
          "   b = ", ab(p)[2], "   m = ", m,
          "   v_2(L/Om) = ", if(m > 0, 1 + 2*valuation(m,2), -1)));
  print("   -> 193 and 577 both have v_2(p-1) = 6 but different m.  So no."); }
go();
quit;
