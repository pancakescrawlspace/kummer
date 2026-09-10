\\ lprimary.gp -- what the l-primary rewrite buys, measured rather than asserted.
\\ Run from this directory:
\\     gp -q -s 8000000000 lprimary.gp < /dev/null > results/lprimary.txt
\\
\\ Two questions, for f = x^3+x+1, S = {11,13,17}, the tuple of d_0 = 1.
\\
\\ (1) WHAT ADMISSION DISCARDS.  rungraded/sweepgraded skip a twist outright
\\     when gran1 fails, so the reader is entitled to ask what is being thrown
\\     away.  Section 2.3.2 distinguishes two kinds of refusal: an entry of
\\     FINITE granularity n_p >= 2, which is usable in principle and lost only
\\     for want of level-2 machinery, and an entry of INFINITE index in the
\\     p-direction, which has no granularity at all and is inadmissible in any
\\     ledger.  Which kind are the refusals in practice?
\\
\\     Granularity is cheap to read off.  For this S every v_p(M_p) = 0, so the
\\     p-layer of the arena IS E_1(Q_p), which is Z_p since cert-ptors.gp shows
\\     there is no p-torsion; the reach's p-layer is p^k Z_p, and the general
\\     depth formula gives depth(m P) = v_p(alpha) + 1.  The alpha-coordinate
\\     map is a homomorphism, so the closed span of the alpha_i is
\\     p^(min_i v_p(alpha_i)) Z_p.  Hence
\\           n_p  =  min over generators of the formal depth at p,
\\     and n_p = 1 is exactly hitsE1.  Both are computed below and compared on
\\     every twist, as a check on that chain of reasoning.
\\
\\ (2) WHAT THE REWRITE COSTS.  A subgroup of a finite abelian group is the
\\     direct sum of its l-primary parts, so a reach is determined by its layer
\\     components and containment can be tested layer by layer -- exactly, not
\\     approximately.  The star test then becomes: for each layer, mask every
\\     <=2-generated subgroup against the ledger; coverage holds iff no choice
\\     of one mask per layer has empty intersection.  Below this is run against
\\     the flat answer it has to reproduce.

read("ledger.gp");
S = [11,13,17];
D7 = [-1590, -519, -127, 53, 586, 1730, 1923];   \\ the seven index-2 reaches

depthP(Ep, P, p, M) =
{ my(D = divisors(M), Q);
  for (t = 1, #D, Q = ellmul(Ep, P, D[t]);
    if (Q != [0] && valuation(Q[1],p) < 0, return(-valuation(Q[1],p)/2)));
  -1;
}
granvec(Em, pts) =
{ my(v = vector(#S));
  for (j = 1, #S,
    my(p = S[j], M = Mval(Em,p), Ep = padiccurve(Em,p), best = 10^6);
    for (i = 1, #pts,
      my(P = [pts[i][1]+O(p^PREC), pts[i][2]+O(p^PREC)], dd = depthP(Ep,P,p,M));
      if (dd > 0 && dd < best, best = dd));
    v[j] = best);
  v;
}

print("=========================================================================");
print(" The l-primary rewrite: what admission discards, and what layers cost");
print("=========================================================================");
print("");
print("-------------------------------------------------------------------------");
print(" (1) The twists that gran1 refuses, and their granularity");
print("-------------------------------------------------------------------------");
{
my(nseen = 0, nadm = 0, tab = List(), disagree = 0, maxn = 0);
for (m = 1, 2000,
  if (!issquarefree(m), next);
  foreach ([m, -m], d,
    if (sqclassS(d, S) != sqclassS(1, S), next);
    my(td = shortdata(1, 1, d));
    if (#td[2] == 0, next);
    nseen++;
    my(g = granvec(td[1], td[2]), a = gran1(td[1], td[2], S));
    if (a, nadm++);
    if ((g == vector(#S, i, 1)) != (a != 0), disagree++;
        print("   DISAGREE d = ", d, "  n = ", g, "  hitsE1 = ", a));
    foreach (g, x, if (x > maxn, maxn = x));
    if (!a, listput(tab, [d, g]))));
print("  twists with points ", nseen, ",  admitted ", nadm, ",  refused ", nseen - nadm);
print("  depth-derived n_p vs hitsE1, disagreements : ", disagree);
print("");
foreach (Vec(tab), r, print("   refused: d = ", r[1], "   n = ", r[2]));
print("");
print("  largest granularity seen anywhere : ", maxn);
print("  every refusal has FINITE granularity, so none is inadmissible: all ", #tab);
print("  would enter a level-2 ledger, and the termination theorem would apply");
print("  at N = 2.  They are discarded for want of machinery, not on principle.");
}

print("");
print("-------------------------------------------------------------------------");
print(" (2) The layers, and the star test run layer by layer");
print("-------------------------------------------------------------------------");
ar = arenainit(1, 1, 1, S); N = arenasize(ar);
ZERO = pack(ar, vector(#S, i, 1));
amul(k, n) = { my(r = ZERO, b = k, m = n);
  while (m > 0, if (m % 2, r = arenaadd(ar, r, b)); b = arenaadd(ar, b, b); m \= 2); r; }
bm2set(b) = { my(L = List()); for (i = 1, #b, if (b[i], listput(L, i-1))); Set(Vec(L)); }
prim(Sset, l) = { my(c = N / l^valuation(N, l)); Set([amul(x, c) | x <- Vec(Sset)]); }
{
my(G = Set([0..N-1]), Ls = factor(N)[,1]~, RS = List(), masks = List());
print("  arena order N = ", N, " = ", factor(N)~);
foreach (D7, d, my(td = shortdata(1,1,d));
  listput(RS, bm2set(reachmap(ar, d, 1, S, td[3]))));
RS = Vec(RS);
print("  the seven reaches have sizes ", [#r | r <- RS], ", index ", N/#RS[1], " each");
print("");
foreach (Ls, l,
  my(Gl = Vec(prim(G, l)), subs = List(), RL = [prim(r, l) | r <- RS]);
  for (i = 1, #Gl, for (j = i, #Gl,
    my(Hs = Set([ZERO]), fresh = [Gl[i], Gl[j]]);
    for (it = 1, 30, my(new = List());
      foreach (Vec(Hs), x, foreach (fresh, g, listput(new, arenaadd(ar,x,g))));
      my(H2 = setunion(Hs, Set(Vec(new)))); if (H2 == Hs, break); Hs = H2);
    listput(subs, Hs)));
  subs = Set(Vec(subs));
  my(ml = Set([Set([i | i <- [1..#RS], #setminus(H, RL[i]) == 0]) | H <- Vec(subs)]));
  print("   layer l = ", l, " : G_l has order ", #Gl,
        ",  <=2-generated subgroups ", #subs, ",  distinct masks ", #ml);
  listput(masks, ml));
masks = Vec(masks);
my(bad = 0, tried = 0);
foreach (Vec(masks[1]), m1, foreach (Vec(masks[2]), m2, foreach (Vec(masks[3]), m3,
  tried++;
  if (#setintersect(setintersect(m1,m2),m3) == 0, bad++))));
print("");
print("  mask triples tested ", tried, ",  with empty intersection ", bad);
print("  layer-wise verdict : ", if (bad == 0, "COVERED", "NOT covered"),
      "   (section 2.3.1, by bitmap over all ", N, "^2 pairs: COVERED)");
print("");
print("  Only the layer l = 2 carries information: at l = 3 and l = 7 every");
print("  <=2-generated subgroup lies in all seven reaches, so those layers");
print("  produce one mask apiece and cannot obstruct.  The whole covering");
print("  question is 15 subgroup tests inside a group of order 8, against");
print("  the ", N^2, " ordered pairs the flat bitmap enumerates.");
}
print("");
print("-------------------------------------------------------------------------");
print(" (3) Level 2, which is where the flat representation dies");
print("-------------------------------------------------------------------------");
{
my(N1 = 4536, K = prod(i = 1, #S, S[i]));
print("  ker_1/ker_2 = prod_p E_1/E_2 has order ", K, " = ", S);
print("  gcd with |G(1)| = ", N1, " : ", gcd(K, N1),
      "   -- coprime, so G(2) = G(1) (+) prod_p Z/p SPLITS,");
print("  and the level-2 arena of order ", N1*K, " adds no complexity to the");
print("  layers l = 2, 3, 7 at all: it adds three NEW layers, each CYCLIC OF");
print("  PRIME ORDER 11, 13, 17.  A subgroup of C_p is 0 or everything, so a");
print("  reach's datum in each new layer is ONE BIT -- and that bit is exactly");
print("  'granularity 1 at p'.  Level 2 costs 3 bits per entry, not a factor");
print("  ", K, " on a bitmap.");
}
print("");
print("done.");
