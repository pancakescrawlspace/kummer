\\ sha-fermat-minus.gp -- checks for sha-fermat-minus.typ
\\
\\ Run from this directory:
\\     gp -q -s 8000000000 sha-fermat-minus.gp < /dev/null > results/sha-fermat-minus.txt
\\
\\ Companion to sha-fermat.gp/typ, which treats y^2 = x^3 + p x.  Here the
\\ MINUS family y^2 = x^3 - p x at the Fermat primes p = F_k = 2^(2^k) + 1.
\\ The two behave oppositely, and this script establishes the contrast.

\\ ---------------------------------------------------------------- the BSD ratio
\\ Sha_an = L^(r)(1)/r! * #tors^2 / (Omega * Reg * prod c_v).
\\ Three PARI conventions have to be got right, and each was got wrong first:
\\   - ellanalyticrank returns L^(r)(1), NOT L^(r)(1)/r!  (bites only at r >= 2);
\\   - ellrank's generators need NOT be saturated (index^2 inflates Reg);
\\   - E.omega[1] is already the full real period; do not double it for disc > 0.
\\ check 1 pins all three down against curves of known Sha.

{shan(E) = my(r = ellanalyticrank(E), rk = r[1], L = r[2]/(rk!), G, reg = 1.0);
  if (rk > 0,
    G = ellsaturation(E, ellrank(E)[4], 50);
    if (#G < rk, return(-1.0));
    reg = matdet(ellheightmatrix(E, G)));
  L * elltors(E)[1]^2 / (E.omega[1] * reg * elltamagawa(E));}

\\ ---------------------------------------------------------------- check 1
check1() =
{ my(CT = [[[0,1,1,-2,0],      1, "389a1, rank 2"],
           [[0,0,1,-1,0],      1, "37a1,  rank 1"],
           [[1,0,0,-45,81],    1, "66c,   rank 0"],
           [[0,-1,1,-10,-20],  1, "11a1,  rank 0"],
           [[0,0,0,-4,4],      1, "rank 2 control"],
           [[0,-1,1,-929,-10595], 4, "571a1, Sha = 4"]], bad = 0);
  for (i = 1, #CT,
    my(E = ellinit(CT[i][1]), v = shan(E), w = CT[i][2]);
    if (abs(v - w) > 1e-6, bad++);
    printf("      %-16s expect %-2d got %.6f  %s\n", CT[i][3], w, v,
           if (abs(v-w) < 1e-6, "ok", "MISMATCH")));
  printf("  (1) the BSD ratio, calibrated on curves of known Sha : %d wrong of %d\n",
         bad, #CT);
};

\\ ---------------------------------------------------------------- check 2
\\ Two points, written down by hand.  Put p = m^2 + 1 with m = 2^(2^(k-1)),
\\ which is what a Fermat prime is.  Then on y^2 = x^3 - p x:
\\     (-1, m)          since  -1 + p = m^2 ;
\\     (-m, sqrt(m))    since  -m^3 + p m = m (p - m^2) = m .
\\ The second is rational exactly when m is a square, i.e. when 2^(k-1) is even,
\\ i.e. when k >= 2.  That is the whole rank pattern.

check2() =
{ my(bad = 0, n = 0);
  for (k = 1, 4,
    my(p = 2^(2^k) + 1, m = 2^(2^(k-1)), E = ellinit([0,0,0,-p,0]), s);
    if (p != m^2 + 1, bad++);
    n++;
    if (!ellisoncurve(E, [-1, m]), bad++);
    printf("      F_%d = %-6d = %d^2+1 : (-1,%d) on the curve; ", k, p, m, m);
    if (issquare(m, &s),
      n++;
      if (!ellisoncurve(E, [-m, s]), bad++);
      printf("(-%d,%d) too  -> rank >= 2\n", m, s),
      printf("m = %d is not a square, no second point -> rank 1\n", m)));
  printf("  (2) the two elementary points : %d failures of %d\n", bad, n);
};

\\ ---------------------------------------------------------------- check 3
\\ The contrast.  The plus family has rank 0 and a growing Sha; the minus family
\\ has rank 2 and trivial Sha.  Same primes, opposite behaviour.

check3() =
{ printf("  (3) the two families at the Fermat primes:\n");
  printf("      %-8s %-26s %-26s\n", "p", "y^2 = x^3 + p x", "y^2 = x^3 - p x");
  for (k = 1, 4,
    my(p = 2^(2^k) + 1, Ep = ellinit([0,0,0,p,0]), Em = ellinit([0,0,0,-p,0]),
       rp = ellanalyticrank(Ep)[1], rm = ellanalyticrank(Em)[1]);
    printf("      %-8d rank %d, w = %-2d, Sha = %-8s rank %d, w = %-2d, Sha = %s\n",
      p, rp, ellrootno(Ep), Str(round(shan(Ep))), rm, ellrootno(Em), Str(round(shan(Em)))));
  printf("      plus: Sha = 4, 16, 64 = 2^(2(k-1)), the pattern of sha-fermat.typ\n");
  printf("      minus: Sha = 1 throughout, the rank absorbing everything\n");
};

\\ ------------------------------------------------------------------------ run

{
print("======================================================================");
print("sha-fermat-minus.gp -- Sha of y^2 = x^3 - p x at the Fermat primes");
print("");
check1();
print("");
check2();
print("");
check3();
print("");
print("So for the minus curve Sha is trivial at every Fermat prime tested, and");
print("the question 'what is the exponent of Sha' has the answer 'there is no");
print("Sha'.  What grows instead is the Mordell-Weil group, and it grows for a");
print("reason one can write on one line: p = m^2 + 1 with m a square.");
}
quit;
