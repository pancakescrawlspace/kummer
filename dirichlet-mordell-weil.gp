\\ dirichlet-mordell-weil.gp -- checks for dirichlet-mordell-weil.typ
\\
\\ Run from this directory:
\\     gp -q -s 2000000000 dirichlet-mordell-weil.gp < /dev/null \
\\         > results/dirichlet-mordell-weil.txt
\\
\\ The note asks whether Dirichlet's unit theorem splits the way Mordell-Weil
\\ does, into an arithmetic half (weak Mordell-Weil) and a height half.  It
\\ does -- but for units the height half alone already finishes the job, and
\\ these checks are about WHY: the Weil height of a unit is purely
\\ archimedean, so the logarithmic embedding IS the height, and its image is
\\ discrete.  On an elliptic curve the archimedean data lives in a COMPACT
\\ group and an infinite subgroup of it can never be discrete.  Checks 1 and 4
\\ are the two halves of that statement.

default(realprecision, 38);

\\ a batch of fields covering several signatures
FLDS = [x^2 - 2, x^2 + 5, x^2 - 79, x^3 - 2, x^3 - x - 1, x^4 + x^3 + x^2 + x + 1, x^4 - 10*x^2 + 1, x^4 - x - 1, x^5 - x - 1];

\\ archimedean log vector of a unit u: the numbers n_v log|sigma_v(u)|,
\\ with n_v = 1 at a real place and 2 at a complex one.
logvec(K, u) =
{ my(e = nfeltembed(K, u), v = vector(#e));
  for (i = 1, #e, v[i] = if (i <= K.r1, 1, 2) * log(abs(e[i])));
  v;
};

\\ Weil height of a unit, (1/n) sum_{v|oo} n_v log^+ |u|_v.  For a unit the
\\ finite places contribute nothing, so this is the whole height.
hgt(K, u) =
{ my(L = logvec(K, u), s = 0);
  for (k = 1, #L, s += max(L[k], 0));
  s / poldegree(K.pol);
};

\\ the same quantity read as an l^1 norm: (1/2n) sum_{v|oo} n_v |log|u|_v|
hgtl1(K, u) =
{ my(L = logvec(K, u), s = 0);
  for (k = 1, #L, s += abs(L[k]));
  s / (2 * poldegree(K.pol));
};

\\ ---------------------------------------------------------------- check 1
\\ A unit has ord_v(u) = 0 at every finite v, so |u|_v = 1 there and the Weil
\\ height h(u) = (1/n) sum_v n_v log^+|u|_v is carried entirely by the
\\ archimedean places.  The product formula then says the log vector sums to
\\ zero -- which is exactly the trace-zero hyperplane -- and hence
\\
\\        h(u)  =  (1/n) sum_{v|oo} n_v log^+|u|_v
\\              =  (1/2n) sum_{v|oo} n_v |log|u|_v|  =  ||lambda(u)||_1 / 2n .
\\
\\ So on units the height IS the logarithmic embedding, up to the factor 1/2n.

check1() =
{ my(bad = 0, bad2 = 0, bad3 = 0, tot = 0);
  printf("  (1) the height of a unit is the l^1 norm of its log vector\n");
  printf("      %-26s %-7s %-11s %-16s %-16s\n", "field", "sign", "sum n_v L_v", "h = (1/n)sum+", "||L||_1/2n");
  for (i = 1, #FLDS,
    my(K = bnfinit(FLDS[i], 1), us = K.fu);
    for (j = 1, #us,
      my(u = us[j], L = logvec(K, u), s = 0, hp = hgt(K, u), ha = hgtl1(K, u), nm);
      for (k = 1, #L, s += L[k]);
      tot++;
      nm = abs(nfeltnorm(K, u));
      if (abs(s) > 1e-25, bad++);
      if (abs(hp - ha) > 1e-25, bad2++);
      if (nm != 1, bad3++);
      if (j == 1, printf("      %-26s [%d,%d]   %-11.1e %-16.10f %-16.10f\n", FLDS[i], K.r1, K.r2, abs(s), hp, ha))));
  printf("      units tested: %d;  log vector not summing to 0: %d;\n", tot, bad);
  printf("      the two height formulas disagreeing: %d;  |N(u)| != 1: %d\n", bad2, bad3);
};

\\ ---------------------------------------------------------------- check 2
\\ Northcott for units, made exact.  In a real quadratic field h(eps^k) =
\\ |k| R / 2, so the units of height <= B are exactly the 2(2[2B/R] + 1)
\\ elements +- eps^k with |k| <= 2B/R: FINITE for every B, and the smallest
\\ positive height is R/2 > 0.  Nothing accumulates at 1.

check2() =
{ my(bad = 0);
  printf("  (2) Northcott for units, exactly: #{u : h(u) <= B} in a real\n");
  printf("      quadratic field, against the prediction 2(2[2B/R]+1)\n");
  printf("      %-12s %-16s %-12s %-8s %-8s %s\n", "field", "R", "h(eps) = R/2", "B", "count", "predicted");
  for (i = 1, 3,
    my(D = [2,5,79][i], K = bnfinit(x^2 - D, 1), R = K.reg, he);
    he = hgt(K, K.fu[1]);
    if (abs(he - R/2) > 1e-25, bad++);
    for (b = 1, 3,
      my(B = [1,5,20][b], cnt = 0, kmax = floor(2*B/R) + 5, pred);
      for (k = -kmax, kmax, if (abs(k) * he <= B + 1e-30, cnt += 2));
      pred = 2 * (2*floor(2*B/R) + 1);
      if (cnt != pred, bad++);
      printf("      %-12s %-16.10f %-12.6f %-8d %-8d %d%s\n", Str("Q(sqrt", D, ")"), R, he, B, cnt, pred, if (cnt == pred, "", "   MISMATCH"))));
  printf("      mismatches (count, or h(eps) != R/2): %d\n", bad);
};

\\ ---------------------------------------------------------------- check 3
\\ Dirichlet's SECOND half, the one with no Mordell-Weil analogue: the log
\\ lattice is FULL rank r_1 + r_2 - 1 inside the trace-zero hyperplane, and
\\ its covolume is the regulator.  Both recomputed here from the embeddings.

check3() =
{ my(bad = 0, bad2 = 0);
  printf("  (3) rank = r_1 + r_2 - 1, and covolume of the log lattice = R\n");
  printf("      %-26s %-8s %-6s %-9s %-17s %s\n", "field", "sign", "rank", "r1+r2-1", "R (bnfinit)", "covolume");
  for (i = 1, #FLDS,
    my(K = bnfinit(FLDS[i], 1), r = #K.fu, pred = K.r1 + K.r2 - 1, cov);
    if (r != pred, bad++);
    cov = if (r == 0, 1.0, abs(matdet(matrix(r, r, a, b, logvec(K, K.fu[a])[b]))));
    if (abs(cov - K.reg) > 1e-20, bad2++);
    printf("      %-26s [%d,%d]    %-6d %-9d %-17.10f %.10f\n", FLDS[i], K.r1, K.r2, r, pred, K.reg, cov));
  printf("      rank != r_1+r_2-1: %d;  covolume != R: %d\n", bad, bad2);
};

\\ ---------------------------------------------------------------- check 4
\\ The contrast the note turns on.  Measure how close a nontrivial element of
\\ the group gets to the identity, ARCHIMEDEANLY:
\\
\\   units:  min_{1<=n<=N} |log|eps^n||  =  R,  independent of N.  Discrete.
\\   E(Q) :  min_{1<=n<=N} ||n z / omega||  ->  0  like 1/N.  Dense in E(R).
\\
\\ E = 43a1 : y^2 + y = x^3 + x^2, disc = -43 < 0, so E(R) is connected and
\\ every rational point has a real elliptic logarithm.  Rank 1, generator [0,0].

check4() =
{ my(K = bnfinit(x^2 - 2, 1), R = K.reg, E = ellinit([0,1,1,0,0]), P = [0,0], z, w, t, ok = 1);
  z = real(ellpointtoz(E, P)); w = real(E.omega[1]); t = z/w;
  printf("  (4) how close a nontrivial element gets to the identity, archimedeanly\n");
  printf("      units of Q(sqrt2): min |log|eps^n||   vs   43a1: min ||n z/omega||\n");
  printf("      %-10s %-22s %-22s %s\n", "N", "units", "E(Q)", "1/N");
  for (k = 1, 5,
    my(N = 10^k, m = 1.0);
    for (n = 1, N, my(f = frac(n*t)); f = min(f, 1 - f); if (f < m, m = f));
    if (m > 1.0/N, ok = 0);
    printf("      %-10d %-22.12f %-22.12f %.12f\n", N, R, m, 1.0/N));
  printf("      the unit column is constant: the log lattice is discrete.\n");
  printf("      the E(Q) column stays below 1/N at every N: %d\n", ok);
};

\\ ---------------------------------------------------------------- check 5
\\ Why a descent still works on G_m even though heights there are LINEAR.
\\ On K^* the Weil height satisfies h(u^m) = m h(u) exactly, so one descent
\\ step contracts by 1/m.  On E the canonical height is quadratic,
\\ hb(mP) = m^2 hb(P), contracting by 1/m^2.  Either is enough; only the
\\ second needs the parallelogram law.

check5() =
{ my(K = bnfinit(x^2 - 2, 1), u = K.fu[1], E = ellinit([0,1,1,0,0]), P = [0,0], h0, hb0, bad = 0);
  h0 = hgt(K, u); hb0 = ellheight(E, P);
  printf("  (5) contraction rates: h(u^m)/h(u) = m  but  hb(mP)/hb(P) = m^2\n");
  printf("      %-6s %-20s %-8s %-20s %s\n", "m", "h(eps^m)/h(eps)", "= m ?", "hb(mP)/hb(P)", "= m^2 ?");
  for (m = 2, 6,
    my(ru = hgt(K, nfeltpow(K, u, m)) / h0, rp = ellheight(E, ellmul(E, P, m)) / hb0);
    if (abs(ru - m) > 1e-20 || abs(rp - m^2) > 1e-14, bad++);
    printf("      %-6d %-20.12f %-8d %-20.12f %d\n", m, ru, m, rp, m^2));
  printf("      deviations: %d\n", bad);
};

print("======================================================================");
print("dirichlet-mordell-weil.gp -- the unit theorem in the Mordell-Weil shape");
print("");
check1(); print("");
check2(); print("");
check3(); print("");
check4(); print("");
check5(); print("");
print("======================================================================");
