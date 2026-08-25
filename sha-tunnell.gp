/* ============================================================================
   sha-tunnell.gp -- the square root m of L(E_p,1)/Omega = 2 m^2 for
   E_p : y^2 = x^3 + p x, and what governs its 2-adic valuation.
   Companion to sha-tunnell.typ.

   OBSERVATION 1 (holds, 82/82 for p < 4000):
        m is even  <=>  2 is a quartic residue mod p  <=>  8 | b,
   where p = a^2 + b^2 with a odd.  This is Gauss's criterion, equivalently
   p = x^2 + 64 y^2.  For a Fermat prime, b = 2^(2^(k-1)), so 8 | b iff k >= 3
   -- which is exactly when m stops being odd.

   OBSERVATION 2 (fails, 48 of 101 for p < 20000):
        4 | m  <=>  2 is an octic residue mod p.
   Counterexample pair: 4177 and 4937 both have b = 64 and are both of the form
   x^2 + 256 y^2 with y = 4, yet m = 2 and m = 4 respectively.

   Functions: ab, mval, rung1, rung2.  Output: results/sha-tunnell.txt
   ============================================================================ */

ab(p) = { my(v = qfbsolve(Qfb(1,0,1), p), A = abs(v[1]), B = abs(v[2]));
  if(A % 2 == 0, [B, A], [A, B]); }
/* m with L(1)/Omega = 2 m^2, or -1 if rank > 0 or the shape fails */
mval(p) = { my(E = ellminimalmodel(ellinit([p,0])), ar, r);
  ar = ellanalyticrank(E);
  if(ar[1] != 0, return(-1));
  r = round(ar[2]/E.omega[1]);
  if(r == 0 || r % 2 != 0 || !issquare(r/2), return(-1));
  sqrtint(r/2); }
rung1(lim) = { my(n = 0, bad = 0);
  print("=== Observation 1: m even <=> 2 a quartic residue mod p <=> 8 | b ===");
  forprime(p = 5, lim,
    if(p % 8 != 1, next);
    my(m = mval(p), AB, q);
    if(m < 0, next);
    AB = ab(p); q = (Mod(2,p)^((p-1)/4) == 1);
    n++;
    if((m % 2 == 0) != q || (AB[2] % 8 == 0) != q, bad++;
      print("   *** p = ", p, "  a = ", AB[1], "  b = ", AB[2], "  m = ", m)));
  print("   ", n, " rank-0 primes p = 1 mod 8 below ", lim, ";  ", bad, " exceptions"); }
rung2(lim) = { my(n = 0, bad = 0);
  print("");
  print("=== Observation 2: does '4 | m' match '2 is an octic residue'? ===");
  forprime(p = 5, lim,
    if(p % 8 != 1, next);
    my(m = mval(p), oct);
    if(m < 0 || m % 2 != 0, next);
    oct = (Mod(2,p)^((p-1)/8) == 1);
    n++;
    if((valuation(m,2) >= 2) != oct, bad++));
  print("   ", n, " primes with m even below ", lim, ";  ", bad, " DISAGREEMENTS");
  print("   counterexample pair, same b and both x^2 + 256 y^2 with y = 4:");
  print("      p = 4177 = 9^2 + 256*16,   m = ", mval(4177));
  print("      p = 4937 = 29^2 + 256*16,  m = ", mval(4937)); }
rung1(4000);
rung2(20000);
print("");
print("### sha-tunnell finished");
quit;
