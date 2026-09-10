\\ integral-points.gp -- checks for integral-points.typ
\\
\\ Run from this directory:
\\     gp -q -s 4000000000 integral-points.gp < /dev/null > results/integral-points.txt
\\
\\ The running example is the 37a1 model already used in analytic-local.typ 8:
\\     E : y^2 = x^3 - 16x + 16,   rank 1, trivial torsion, P0 = (0,4) a generator.
\\ Everything below is about one question: which multiples n P0 are integral, and
\\ why the answer is "only |n| <= 6".

E  = ellinit([0,0,0,-16,16]);
P0 = [0,4];
h0 = ellheight(E, P0);

\\ ---------------------------------------------------------------- check 1
\\ The canonical height is a quadratic form: h^(n P0) = n^2 h^(P0).  This is
\\ what turns "the coefficients are large" into "the point is enormous".

check1(N) =
{ my(bad = 0);
  for (n = 1, N,
    if (abs(ellheight(E, ellmul(E,P0,n)) - n^2*h0) > 1e-20, bad++));
  printf("  (1) h^(n P0) = n^2 h^(P0) for n <= %d : %d wrong\n", N, bad);
  printf("      h^(P0) = %.10f, so an integral point with coefficient n has\n", h0);
  printf("      log|x| about %.4f n^2 -- n = 20 already means |x| ~ 10^%d\n",
         h0, round(h0*400/log(10)));
};

\\ ---------------------------------------------------------------- check 2
\\ The integral points, found by brute force and then identified.  Rank 1 with
\\ trivial torsion, so E(Q) = Z P0 and every rational point is some n P0.

check2(B) =
{ my(L = List(), bad = 0, mx = 0);
  for (x = -B, B,
    my(s = x^3 - 16*x + 16);
    if (s >= 0 && issquare(s, &yy), listput(L, [x, yy])));
  L = Vec(L);
  printf("  (2) integral points with |x| <= %d : %d of them (%d up to sign of y)\n",
         B, 2*#L - #select(t -> t[2] == 0, L), #L);
  for (k = 1, #L,
    my(P = L[k], n = 0);
    for (m = -40, 40, if (ellmul(E,P0,m) == P, n = m));
    if (n == 0, bad++, mx = max(mx, abs(n)));
    printf("      (%6d, %8d) = %s P0\n", P[1], P[2], if (n, Str(n), "NOT FOUND")));
  printf("      every one is n P0 with |n| <= %d : %d unidentified\n", mx, bad);
};

\\ ---------------------------------------------------------------- check 3
\\ THE DICTIONARY.  For P in the kernel of reduction at p,
\\     v_p( log_E P ) = v_p( z(P) ) = -v_p(x(P)) / 2 ,
\\ z = -x/y being the formal parameter.  So "x has p^(2m) in its denominator"
\\ and "log_p P is divisible by p^m" are the same statement.

check3(CS, NM, N) =
{ my(bad = 0, tot = 0);
  for (c = 1, #CS,
    my(Ec = ellinit(CS[c]), rk = ellrank(Ec), G = rk[4]);
    if (#G == 0, next);
    for (gi = 1, #G, for (n = 1, N,
      my(Q = ellmul(Ec, G[gi], n));
      if (Q == [0], next);
      my(d = denominator(Q[1]));
      if (d == 1, next);
      my(f = factor(d));
      for (k = 1, #f[,1],
        my(p = f[k,1]);
        if (p == 2 || Mod(Ec.disc, p) == 0, next);
        my(vx = valuation(Q[1], p), lg = ellpadiclog(Ec, p, 12, Q));
        tot++;
        if (valuation(lg, p) != -vx/2, bad++)))));
  printf("  (3) v_p(log_E P) = -v_p(x(P))/2 : %d wrong of %d (p odd, good reduction)\n",
         bad, tot);
};

\\ ---------------------------------------------------------------- check 4
\\ Where the denominators come from.  n P0 first acquires p in its denominator
\\ exactly when n reaches the ORDER of P0 in E~(F_p) -- that is when n P0 first
\\ lands in the kernel of reduction -- and thereafter the p-adic valuation grows
\\ only when p divides n.  Both statements are the dictionary, read backwards.

check4(PS, N) =
{ my(bad = 0, bad2 = 0, dens = vector(N, n, denominator(ellmul(E,P0,n)[1])));
  for (i = 1, #PS,
    my(p = PS[i], first = 0, ord);
    for (n = 1, N, if (valuation(dens[n], p) > 0, first = n; break));
    if (first == 0, next);
    ord = ellorder(ellinit(E, p), [0,4]*Mod(1,p));
    if (first != ord, bad++);
    printf("      p = %-4d first n with p | den : %-3d   order of P0 mod p : %-3d  %s\n",
           p, first, ord, if (first == ord, "equal", "DIFFER"));
    \\ growth: v_p(den) = 2 (1 + v_p(n/first)) whenever first | n
    for (n = 1, N,
      if (n % first != 0, next);
      if (valuation(dens[n], p) != 2*(1 + valuation(n/first, p)), bad2++)));
  printf("  (4) first n with p in the denominator = order of P0 mod p : %d wrong\n", bad);
  printf("      and v_p(den) = 2(1 + v_p(n/n_0)) thereafter : %d wrong\n", bad2);
};

\\ ---------------------------------------------------------------- check 5
\\ S-integral points.  Enlarging S admits exactly those multiples whose
\\ denominator is supported on S -- a few more each time, and never many.

check5(SL, N) =
{ my(dens = vector(N, n, denominator(ellmul(E,P0,n)[1])));
  for (i = 1, #SL,
    my(SS = SL[i], L = List());
    for (n = 1, N,
      my(d = dens[n]);
      for (k = 1, #SS, d /= SS[k]^valuation(d, SS[k]));
      if (d == 1, listput(L, n)));
    printf("      S = %-28s : n = %s\n",
           if (#SS == 0, "{}  (integral points)", Str(SS)), Vec(L)));
  printf("  (5) S-integral multiples with n <= %d, listed above\n", N);
};

\\ ---------------------------------------------------------------- check 6
\\ The archimedean half.  For x(P) large and positive the elliptic logarithm is
\\     psi(P) = int_{x(P)}^oo dt / (2 sqrt(t^3+At+B)) ~ x(P)^(-1/2) ,
\\ so an integral point with large coefficients gives an ABSURDLY small value of
\\ a linear form in elliptic logarithms.  That is the collision Baker exploits.

check6(NS) =
{ my(w = E.omega[1], worst = 0);
  for (i = 1, #NS,
    my(n = NS[i], Q = ellmul(E,P0,n), x = Q[1]*1.0);
    if (x < 10, next);
    my(z = ellpointtoz(E, Q), psi = abs(real(z) - round(real(z)/w)*w),
       pred = x^(-1/2), rat = psi/pred);
    worst = max(worst, abs(rat - 1));
    printf("      n=%-3d x = %-12.4f  |psi| = %.6e   x^(-1/2) = %.6e   ratio %.4f\n",
           n, x, psi, pred, rat));
  printf("  (6) |psi(P)| = x(P)^(-1/2) (1 + O(1/x)) : worst relative error %.4f\n", worst);
};

\\ ---------------------------------------------------------------- check 7
\\ Rank 2, where the linear form is genuinely a linear form.  On 389a1 with
\\ generators P1, P2, put lambda_i = log_p(c P_i) with c killing the reduction.
\\ S-integrality with a large power of p in the denominator says
\\     v_p( n1 lambda1 + n2 lambda2 ) >= m ,
\\ a sublattice of Z^2 of index p^m.  So the solutions thin out by a factor p
\\ for every extra power of p -- which is why lattice reduction finishes the job.

check7(p, prec, N, MS) =
{ my(F = ellinit([0,1,1,-2,0]), rk = ellrank(F), G = rk[4], c, l1, l2);
  c = ellcard(ellinit(F, p));
  l1 = ellpadiclog(F, p, prec, ellmul(F, G[1], c));
  l2 = ellpadiclog(F, p, prec, ellmul(F, G[2], c));
  printf("  (7) 389a1, rank %d, p = %d : v_p(lambda_1) = %d, v_p(lambda_2) = %d\n",
         rk[1], p, valuation(l1,p), valuation(l2,p));
  for (i = 1, #MS,
    my(m = MS[i], cnt = 0);
    for (n1 = -N, N, for (n2 = -N, N,
      if (n1 == 0 && n2 == 0, next);
      if (valuation(n1*l1 + n2*l2, p) >= m, cnt++)));
    printf("      v_p(n1 l1 + n2 l2) >= %-2d : %6d of %d pairs   (expected ~ %.1f)\n",
           m, cnt, (2*N+1)^2 - 1, ((2*N+1)^2 - 1)/p^(m - valuation(l1,p))));
};

\\ ------------------------------------------------------------------------ run

{
print("======================================================================");
print("integral-points.gp -- checks for integral-points.typ");
print("");
print("E : y^2 = x^3 - 16x + 16   (a model of 37a1),  P0 = (0,4)");
print("rank 1, torsion trivial, so E(Q) = Z P0.");
print("");
check1(30);
print("");
check2(1000000);
print("");
check3([[0,0,0,-16,16], [0,0,1,-1,0], [0,1,1,-2,0], [0,0,0,-2,0], [0,0,0,0,-2]],
       0, 12);
print("");
print("  (4) where the denominators come from:");
check4([3,5,7,11,13,17,23,29,31,43,59], 60);
print("");
print("  (5) S-integral multiples:");
check5([[], [2], [3], [5], [2,3], [2,3,5], [2,3,5,7], [2,3,5,7,11,13,17,23,29]], 60);
print("");
print("  (6) the archimedean estimate:");
check6([2,4,6,10,16,22,28,34]);
print("");
check7(5, 20, 12, [2,3,4,5]);
print("");
print("Checks (1), (2) and (6) are the archimedean half of the method: the height");
print("is a quadratic form, integral points are therefore gigantic, and gigantic");
print("points have tiny elliptic logarithms.  Checks (3), (4), (5) and (7) are the");
print("p-adic half, and they say the same thing in the other topology: a large");
print("power of p in the denominator IS a large power of p dividing the p-adic");
print("logarithm.  Baker's theorem, in each topology, says a non-zero linear form");
print("in logarithms cannot be that small -- and the two estimates collide.");
}
quit;
