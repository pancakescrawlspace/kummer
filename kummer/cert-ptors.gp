\\ cert-ptors.gp -- the p-part of the torsion, which the other two certificates
\\ assert rather than compute.  Run from this directory:
\\     gp -q -s 4000000000 cert-ptors.gp < /dev/null > results/cert-ptors.txt
\\
\\ THE GAP.  cert-extended.gp and cert-ledger.gp both write E^d(Q_p) = Z_p x T
\\ and read T off the prime-to-p part of M = #(E^d(Q_p)/E_1):
\\        T = if (Mp == 1, [], ... )   with Mp = M / p^v_p(M).
\\ Nothing there computes the p-part of T.  It is not always trivial: whenever
\\ p | M -- at every additive place, and at a good place exactly when E^d is
\\ ANOMALOUS at p (a_p = 1, so #Etilde(F_p) = p) -- the group E^d(Q_p) may be
\\ Z_p x Z/p^k with k > 0.  That is not a cosmetic error in the fourth column:
\\ Z_p x Z/p needs TWO topological generators, so a rank-1 twist cannot be a
\\ density witness there at all, however unit its Z_p-coordinate looks.
\\
\\ THE CRITERION.  Write E(Q_p) = Z_p x C_n x C_{p^k} with p not dividing n, and
\\ let M = [E(Q_p) : E_1].  For p >= 3 the formal group is E_1 = Z_p with
\\ E_j <-> p^(j-1) Z_p, and E_1 is torsion-free, so the finite part injects into
\\ E(Q_p)/E_1 and n p^k divides M.  Let Q = (alpha, beta, gamma) be ANY point.
\\ Then M Q = (M alpha, 0, 0) lies in E_1.  Writing E_1 as the closure of
\\ Z_p (b, c, e) -- it need not be b Z_p x 0 x 0, the complement can be skew --
\\ the index computation gives v_p(b) = v_p(M) - k, and M Q corresponds to the
\\ parameter lambda = M alpha / b, so
\\        depth(M Q)  =  v_p(lambda) + 1  =  k + v_p(alpha) + 1 .
\\ Hence depth(M Q) >= k+1 for every Q, with equality iff alpha is a unit:
\\
\\        k  =  min over Q in E(Q_p) of depth(M Q)  -  1 .
\\
\\ One point of depth 1 therefore PROVES k = 0; no search has to be exhausted.
\\ This is also why the two certificates are sound where a single generator P
\\ carries the line: "ord in E/E_1 = M and depth 1" is exactly the k = 0
\\ criterion above, so on those lines the assertion is a theorem (equivalently:
\\ P then generates topologically, and Z_p x Z/p is not procyclic).  It is the
\\ 22 lines of table 6.3 needing two generators, and the additive ledger places,
\\ where nothing backed the assertion.  Those are what this file settles.
\\
\\ Sampling is deterministic -- x_0 runs through 0, 1, 2, ... and keeps the
\\ first few for which x_0^3 + d^2 x_0 + d^3 is a square in Q_p -- so the
\\ certificate is reproducible, with no setrand and no random generator.

Ed(d) = ellinit([d^2, d^3]);
Mval(E,p) =
{ my(a = ellap(E,p));
  if (Mod(E.disc,p) != 0, p + 1 - a, elllocalred(E,p)[4] * (p - a));
}
\\ k = min_Q depth(M Q) - 1, over the first ntry deterministic Q_p-points.
\\ Returns [M, mindepth, k, #samples, x_0 attaining the minimum].
ppartk(d, p, ntry, prec) =
{ my(E = Ed(d), M = Mval(E,p), best = 10^6, arg = -1, cnt = 0, f, y0, R, dep);
  for (t = 0, 100000,
    if (cnt >= ntry, break);
    my(x0 = t + O(p^prec));
    f = x0^3 + d^2*x0 + d^3;
    if (f == 0 || !issquare(f, &y0), next);
    cnt++;
    R = ellmul(E, [x0, y0], M);
    if (R == [0], next);
    \\ M Q must land in E_1, i.e. reduce to O, i.e. have x of negative valuation
    if (valuation(R[1], p) >= 0, error("M Q not in E_1 at d=", d, " p=", p));
    dep = -valuation(R[1], p) / 2;
    if (dep < best, best = dep; arg = t));
  [M, best, best - 1, cnt, arg];
}

\ ---- table 6.3: the 45 primes and their four witness twists (from cert-extended.gp)
{
WIT = [
  [3,   [7, -1, 3, 6]],        [5,   [1, 3, 5, -35]],
  [7,   [1, -1, 7, -7]],       [11,  [3, 6, 11, -11]],
  [13,  [-1, 5, -13, 26]],     [17,  [-1, 7, 34, 51]],
  [19,  [1, -1, 95, -95]],     [23,  [1, -1, 46, 115]],
  [29,  [-1, 11, -29, 58]],    [31,  [1, -1, 31, -62]],
  [37,  [-11, 6, -37, 74]],    [41,  [-1, 3, 41, 123]],
  [43,  [1, -1, -86, 86]],     [47,  [-11, -149, 94, 705]],
  [53,  [11, 22, 53, 106]],    [59,  [1, 6, 295, -59]],
  [61,  [1, 7, -61, 122]],     [67,  [-221, 51, 2211, 134]],
  [71,  [1, -1, 71, -71]],     [73,  [3, -21, 146, -365]],
  [79,  [1, -1, 158, -158]],   [83,  [-22, -11, 83, 166]],
  [89,  [1, -7, 178, -267]],   [97,  [1, 7, 97, 485]],
  [101, [-1, 3, 101, -2626]],  [103, [1, -1, 103, 2266]],
  [107, [-7, -1, -1605, -107]],[109, [1, 6, 109, 654]],
  [113, [1, 3, 113, 339]],     [127, [-6, 3, 254, -127]],
  [131, [53, -11, 131, 8646]], [137, [7, 3, 274, -411]],
  [139, [51, 3, 139, -139]],   [149, [53, 94, -149, 13559]],
  [151, [1, -1, 755, 453]],    [157, [1, 5, 157, 2355]],
  [163, [1, -1, 978, 815]],    [167, [-13, -6, 334, -334]],
  [173, [51, 53, -173, 519]],  [179, [1, -19, 179, -537]],
  [181, [1, 7, -181, -1086]],  [191, [1, -1, 191, -191]],
  [193, [1, 5, -193, 965]],    [197, [-6, 3, 197, 394]],
  [199, [-6, 3, 199, -199]]
];
}
CLS = ["[1]", "[u]", "[p]", "[up]"];

\ ---- the twists occurring in results/cert-ledger.txt, S = {11,13,17}
LDGR = [-3441,-1590,-1213,-1086,-938,-889,-641,-519,-511,-367,-349,-199,-149,-127,53,94,131,134,241,335,586,1047,1154,1730,1821,1923,2546,2859,2994,3391,3714,4279,4886];

print("=========================================================================");
print(" The p-part of E^d(Q_p)_tors, for both certificates");
print("=========================================================================");
print("");
print("k = min over Q in E^d(Q_p) of depth(M Q), minus 1.   k = 0 <=> no");
print("p-torsion <=> E^d(Q_p) is procyclic <=> one generator can carry the line.");
print("Only the places with p | M are at issue; elsewhere the finite part");
print("injects into Etilde(F_p), of order M prime to p, so k = 0 for free.");
print("");
print("-------------------------------------------------------------------------");
print(" Table 6.3.  Places with p | M, listed in full.");
print("-------------------------------------------------------------------------");
{
my(tot = 0, exposed = 0, anom = 0, bad = 0);
foreach (WIT, w,
  my(p = w[1], ds = w[2]);
  for (j = 1, 4,
    my(d = ds[j], E = Ed(d), good = (Mod(E.disc,p) != 0), r = ppartk(d, p, 8, 60));
    tot++;
    if (r[3] != 0, bad++);
    if (r[1] % p == 0,
      exposed++;
      if (good, anom++);
      print("  p = ", p, "  class ", CLS[j], "  d = ", d,
            "   M = ", r[1], "   min depth = ", r[2], " (at x_0 = ", r[5], ")",
            "   k = ", r[3], if (good, "   <-- ANOMALOUS (a_p = 1)", ""), if (r[3] != 0, "   <<<<<< p-TORSION", "")))));
print("");
print("  lines in table            : ", tot);
print("  lines with p | M          : ", exposed, "  (of which good, i.e. ANOMALOUS: ", anom, ")");
print("  lines with p-torsion      : ", bad);
}

print("");
print("-------------------------------------------------------------------------");
print(" The ledger of section 2.5, S = {11,13,17}.  Places with p | M.");
print("-------------------------------------------------------------------------");
{
my(tot = 0, exposed = 0, anom = 0, bad = 0);
foreach (LDGR, d,
  foreach ([11,13,17], p,
    my(E = Ed(d), good = (Mod(E.disc,p) != 0), r = ppartk(d, p, 8, 60));
    tot++;
    if (r[3] != 0, bad++);
    if (r[1] % p == 0,
      exposed++;
      if (good, anom++);
      print("  d = ", d, "   p = ", p, "   M = ", r[1],
            "   min depth = ", r[2], " (at x_0 = ", r[5], ")   k = ", r[3],
            if (good, "   <-- ANOMALOUS (a_p = 1)", ""),
            if (r[3] != 0, "   <<<<<< p-TORSION", "")))));
print("");
print("  (twist, place) pairs      : ", tot);
print("  pairs with p | M          : ", exposed, "  (of which good, i.e. ANOMALOUS: ", anom, ")");
print("  pairs with p-torsion      : ", bad);
}
print("");
print("-------------------------------------------------------------------------");
print(" p = 2 (section 3.2) is not exposed: Disc(E_d) = -16 * 31 * d^6, so");
print(" v_2(Disc) >= 4 for every d and 2 is never a place of good reduction,");
print(" hence never anomalous.  Its additive place is treated in cert-p2.gp.");
print("-------------------------------------------------------------------------");
print("");
print("done.");
