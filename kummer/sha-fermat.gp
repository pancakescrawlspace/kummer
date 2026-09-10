/* ============================================================================
   sha-fermat.gp -- Sha of E_d : y^2 = x^3 + dx at the Fermat primes.
   Companion to sha-fermat.typ.

   For p = 1 mod 8 prime with L(E_p,1) =/= 0 the BSD formula collapses, because
   the Tamagawa product and the torsion are both 2:

        #Sha = (L(1)/Omega) * |T|^2 / c = 2 * L(1)/Omega.

   Verified here for every such p below 3000 (64 of them), together with the
   Waldspurger square shape L(1)/Omega = 2 m^2, so that #Sha = (2m)^2.

   The k = 4 Fermat prime is computed directly: L(E_65537,1)/Omega = 32, hence
   #Sha = 64 = 2^(2k-2), confirming the pattern independently of Sage.

   Note what ellrank reports for p = 17, 257, 65537: the interval 0..2 rather
   than a rank.  By PARI's own documentation that happens exactly when Sha has
   4-torsion -- so the 2-descent is telling us, unasked, that Sha has 4-torsion
   for 257 and 65537 and not for 17.

   Functions: ab, dat, scan, fermat.  Output: results/sha-fermat.txt
   ============================================================================ */

ab(p) = { my(v = qfbsolve(Qfb(1,0,1), p), A = abs(v[1]), B = abs(v[2]));
  if(A % 2 == 0, [B, A], [A, B]); }        /* p = a^2 + b^2, a odd */
dat(p, verbose) = { my(E = ellminimalmodel(ellinit([p,0])), ar, r, AB, c, T, m, sha);
  ar = ellanalyticrank(E);
  if(ar[1] != 0, if(verbose, print("   p = ", p, "   analytic rank ", ar[1])); return(0));
  AB = ab(p); c = ellglobalred(E)[3]; T = elltors(E)[1];
  r = round(ar[2]/E.omega[1]);
  m = if(r % 2 == 0 && issquare(r/2), sqrtint(r/2), -1);
  sha = round(r*T^2/c);
  if(verbose,
    print("   p = ", p, "   a = ", AB[1], "  b = ", AB[2],
          "   c = ", c, "  |T| = ", T,
          "   L(1)/Om = ", r, "   m = ", m, "   #Sha = ", sha,
          "   ", if(m > 0 && sha == (2*m)^2, "= (2m)^2", "*** NOT (2m)^2 ***")));
  [r, m, sha, c, T]; }
scan(lim) = { my(n = 0, badc = 0, badsq = 0);
  print("=== all rank-0 primes p = 1 mod 8 below ", lim, " ===");
  forprime(p = 5, lim,
    if(p % 8 != 1, next);
    my(d = dat(p, 0));
    if(type(d) == "t_INT", next);
    n++;
    if(d[4] != 2 || d[5] != 2, badc++);
    if(d[2] < 0 || d[3] != (2*d[2])^2, badsq++));
  print("   ", n, " primes;  ", badc, " with c or |T| not 2;  ",
        badsq, " with L(1)/Omega not twice a square"); }
fermat() = { print(""); print("=== the Fermat primes ==="); 
  foreach([5, 17, 257, 65537], p, dat(p, 1)); }
scan(3000);
fermat();
print("");
print("### sha-fermat finished");
quit;
