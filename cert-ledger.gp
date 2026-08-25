\\ cert-ledger.gp -- the extended certificate for the LEDGER of section 2.
\\ Run from this directory:
\\     gp -q -s 12000000000 cert-ledger.gp < /dev/null > results/cert-ledger.txt
\\
\\ Section 3.4 extends the single-place certificate of section 3.3.  This does the
\\ same for the S-adic ledger of section 2.5, S = {11,13,17}, f = x^3+x+1.
\\
\\ LEDGER, NOT TALLY.  A record of level-1 images alone is a TALLY: those images
\\ are over-approximations of the reaches, so closure is a necessary condition
\\ and nothing more (document section 2.3).  What makes an entry a LEDGER entry
\\ is a GRANULARITY n_d certifying R(d) contains ker_{n_d}, which pins the finite
\\ datum to R(d) exactly and lets the termination theorem apply.  An earlier
\\ version of this file printed level-1 images and the reach index and called the
\\ result a ledger certificate; it was a tally certificate.  Every twist is now
\\ put through gran1 from ledger.gp -- the same admission test sweepgraded and
\\ rungradedk use, so this certificate and the sweeps agree by construction --
\\ and the verdict is printed per twist and per place.
\\
\\ What changes.  There the certificate had one line per (p, square class): one
\\ twist sufficed a priori.  Here a tuple of square classes is covered by SEVERAL
\\ twists -- seven index-2 reaches, in three of the five covered tuples -- so a
\\ tuple gets several lines.  And a twist of rank 2 contributes two generators, so
\\ ONE LINE PER (TWIST, GENERATOR): the line records where that generator sits in
\\     E^d(Q_S) = prod_{p in S} E^d(Q_p) = prod_p (Z_p x T_p),
\\ i.e. a TRIPLE of coordinates (alpha_p ; t_p), one per place, in the conventions
\\ of section 3.4.1.
\\
\\ The extra column a ledger line needs and a single-place line does not is the
\\ INDEX OF THE REACH in the arena G(1) = prod_p E^d(Q_p)/E_1, of order
\\ N = prod_p M_p.  Index 1 is a full twist; index 2 is one of the hyperplanes
\\ that the ledger stacks up.  That index is what the ledger is bookkeeping, so it
\\ is computed here rather than quoted: at level 1 each G_p is E^d(F_p) at the
\\ good places, the images are read off by discrete logarithm, and the index is
\\ the determinant of the Hermite form of the lattice they span together with the
\\ relations M_p e_p.

\\ gran1 / hitsE1 / shortdata come from ledger.gp, so the admission test here is
\\ literally the one the sweeps run.  Loading it first lets the definitions below
\\ win on the few shared names; they agree with ledger.gp's (Mval in particular).
read("ledger.gp");

cden(Q) = if (Q == [0], 0, sqrtint(denominator(Q[1])));
Ed(d)   = ellinit([d^2, d^3]);
Mval(E,p) =
{ my(a = ellap(E,p));
  if (Mod(E.disc,p) != 0, p + 1 - a, elllocalred(E,p)[4] * (p - a));
}
\\ order of Pbar in E(Q_p)/E_1 and the formal depth, by testing divisors of M
ordv(E, P, p, M) =
{ foreach (divisors(M), e,
    my(Q = ellmul(E, P, e));
    if (Q != [0] && Mod(cden(Q), p) == 0, return([e, valuation(cden(Q), p)])));
  [0, 0];
}
\\ discrete log of Pbar in a CYCLIC E(F_p), against ellgroup's generator

\\ The CANONICAL base of E(F_p), identical to the convention of cert-extended.gp:
\\ order the affine points lexicographically by (x,y) and take the first of
\\ maximal order.  ellgroup's own generator is chosen at random on each call, so
\\ a class computed against it is not reproducible and cannot be checked by a
\\ reader; fixing one per run removes the inconsistency between generators but
\\ not the irreproducibility.  This removes both, and the base is printed.
canonbase(E, p) =
{ my(Ep = ellinit(E, p), G = ellgroup(E, p), pts = List(), n1, g1 = 0);
  for (x = 0, p-1,
    my(r = x^3 + E.a4*x + E.a6);
    for (y = 0, p-1, if (Mod(y^2 - r, p) == 0, listput(pts, [Mod(x,p), Mod(y,p)]))));
  n1 = G[1];
  foreach (Vec(pts), P, if (g1 == 0 && ellorder(Ep, P) == n1, g1 = P));
  [Ep, g1, n1];
}

\\ Discrete log against a base that must be supplied by the caller.  ellgroup's
\\ generator is chosen at RANDOM on each call, so computing it inside this routine
\\ would express different points against different bases and make the resulting
\\ lattice -- and the reach index read off it -- meaningless.  Fix one base per
\\ (curve, prime) and pass it in.
dlogc(Ep, P, p, base, n) =
{ my(Q);
  \\ a point of E_1(Q_p) reduces to O, so its class is 0 -- and its coordinates
  \\ have p in the denominator, which would otherwise break the reduction
  if (P == [0] || Mod(cden(P), p) == 0, return(0));
  Q = [Mod(P[1],p), Mod(P[2],p)];
  for (e = 0, n-1, if (ellmul(Ep, base, e) == Q, return(e)));
  -1;
}

\\ The reach index computed WITHOUT discrete logarithms, straight on points of
\\ prod_p E(F_p).  Independent of any choice of generator, so it is used to
\\ cross-check the lattice computation above.
reachdirect(E, gens, Sloc) =
{ my(Ep = vector(#Sloc, j, ellinit(E, Sloc[j])));
  my(N = prod(j = 1, #Sloc, ellcard(Ep[j])));
  my(red(P, p) = if (P == [0] || Mod(cden(P), p) == 0, [0], [Mod(P[1],p), Mod(P[2],p)]));
  my(V = Vec(apply(P -> vector(#Sloc, j, red(P, Sloc[j])), gens)));
  my(L = List([vector(#Sloc, j, [0])]), seen = Set([Str(vector(#Sloc, j, [0]))]), i = 1);
  while (i <= #L,
    my(x = Vec(L)[i]);
    foreach (V, g,
      my(y = vector(#Sloc, j, elladd(Ep[j], x[j], g[j])), k = Str(y));
      if (!setsearch(seen, k), seen = setunion(seen, Set([k])); listput(L, y)));
    i++);
  [N, #L, N / #L];
}

\\ ---- the star test, on subgroups of the arena prod_p C_{M_p}
enc(v, M) = ((v[1] % M[1]) * M[2] + (v[2] % M[2])) * M[3] + (v[3] % M[3]);
dec(e, M) = [(e \ (M[2]*M[3])) % M[1], (e \ M[3]) % M[2], e % M[3]];
subgrp(gens, M) =
{ my(L = List([[0,0,0]]), seen = Set([0]), i = 1);
  while (i <= #L,
    my(x = Vec(L)[i]);
    foreach (gens, g,
      my(y = [(x[1]+g[1]) % M[1], (x[2]+g[2]) % M[2], (x[3]+g[3]) % M[3]], e = enc(y,M));
      if (!setsearch(seen, e), seen = setunion(seen, Set([e])); listput(L, y)));
    i++);
  Set(apply(v -> enc(v,M), Vec(L)));
}
negv(v, s) = [if(s[1]<0,-v[1],v[1]), if(s[2]<0,-v[2],v[2]), if(s[3]<0,-v[3],v[3])];
signim(R, s, M) = Set(apply(e -> enc(negv(dec(e,M), s), M), Vec(R)));
covers(L, N) =
{ for (a = 0, N-1,
    my(St = Set([]));
    foreach (L, R, if (setsearch(R, a), St = setunion(St, R)));
    if (#St < N, return(0)));
  1;
}
SIGNS = [[1,1,1],[1,1,-1],[1,-1,1],[-1,1,1],[1,-1,-1],[-1,1,-1],[-1,-1,1],[-1,-1,-1]];

S = [11, 13, 17];

\\ the five covered tuples of section 2.5, plus the two probed ones
TUP = 0;
{
TUP = [
  ["(1,1,1)",  1,   [-1590, -519, -127, 53, 586, 1730, 1923],   "seven hyperplanes"],
  ["(1,1,u)",  3,   [335],                                       "one full twist"],
  ["(u,1,1)",  -1,  [-511, 94, 134, 1154, 1821, 2994, 3714],     "seven hyperplanes"],
  ["(u,1,u)",  74,  [-3441, -1213, -641, -367, -199, 131, 2859], "seven hyperplanes"],
  ["(11,u,u)", 11,  [4279],                                      "one full twist"],
  ["(u,u,u)",  6,   [241, -889, -938, 1047, 4886],               "five of seven -- NOT covered"],
  ["(1,u,1)",  -19, [-149, -349, -1086, 2546, 3391],             "five of seven -- NOT covered"]
];
}

entry(tname, d, Ms) =
{ my(E = Ed(d), g = ellrank(E), gens, allgood = 1, vecs = List(), idx = 0);
  gens = concat(ellsaturation(E, g[4], 200), elltors(E)[3]);
  for (j = 1, 3, if (Mod(E.disc, S[j]) == 0, allgood = 0));
  print("    d = ", d, "   rank ", g[1], " (certified ", g[1] == g[2],
        "), torsion ", elltors(E)[1]);
  \\ the three local groups
  my(strs = vector(3), cyc = 1);
  for (j = 1, 3,
    my(p = S[j], M = Ms[j], Tstr);
    if (Mod(E.disc,p) != 0,
      my(G = ellgroup(E,p));
      if (#G > 1, cyc = 0);
      Tstr = if (#G == 1, Str("C", G[1]), Str("C", G[1], " x C", G[2])),
      Tstr = Str("C", M / p^valuation(M,p)));
    strs[j] = Tstr);
  print("      E^d(Q_p) = ", [Str("Z_", S[j], " x ", strs[j]) | j <- [1,2,3]]);
  \\ per generator: the triple of coordinates
  \\ ONE base per prime, reused for every generator
  my(Eps = vector(3), bases = vector(3), ords = vector(3), bstr = vector(3, j, "-"));
  for (j = 1, 3,
    if (Mod(E.disc, S[j]) != 0 && cyc,
      my(CB = canonbase(E, S[j]));
      Eps[j] = CB[1]; bases[j] = CB[2]; ords[j] = CB[3];
      bstr[j] = Str("(", lift(CB[2][1]), ",", lift(CB[2][2]), ")")));
  print("      canonical bases of E^d(F_p), p = 11, 13, 17 : ", bstr);
  \\ GRANULARITY.  Admission is per twist, not per generator: hitsE1 asks whether
  \\ the whole reach meets E_1 \\ E_2 at p, which may need a COMBINATION of
  \\ generators that no single one achieves.  n_p = 1 at every place is the
  \\ exactness certificate R(d) contains ker_1, and only then is the line a
  \\ ledger entry rather than a tally entry.
  my(sd = shortdata(1, 1, d), gr = vector(3), adm = 1);
  for (j = 1, 3,
    gr[j] = if (#sd[2] == 0, 0, hitsE1(sd[1], sd[2], S[j]));
    if (!gr[j], adm = 0));
  print("      granularity n_p at p = 11, 13, 17 : ",
        vector(3, j, if (gr[j], 1, ">1")),
        if (adm, "   ADMITTED: reach contains ker_1, so this is a LEDGER entry",
                 "   NOT ADMITTED: tally entry only, no exactness certificate"));
  foreach (gens, P,
    my(row = List());
    for (j = 1, 3,
      my(p = S[j], r = ordv(E, P, p, Ms[j]), c);
      if (Mod(E.disc,p) != 0 && cyc,
        c = dlogc(Eps[j], P, p, bases[j], ords[j]), c = -1);
      listput(row, [r[1], r[2], c]));
    row = Vec(row);
    print("      P = ", P);
    for (j = 1, 3,
      print("         at ", S[j], " : ( ",
            if (row[j][2] == 1, "u", Str(S[j], "^", row[j][2]-1, " u")), " ; ",
            if (row[j][3] >= 0, Str("class ", row[j][3]),
                Str("order ", row[j][1])), " )",
            "    [ord ", row[j][1], ", depth ", row[j][2], "]"));
    if (allgood && cyc, listput(vecs, vector(3, j, row[j][3]))));
  \\ the reach index at level 1
  if (allgood && cyc && #vecs > 0,
    my(m = matrix(3, #vecs + 3));
    for (i = 1, #vecs, for (j = 1, 3, m[j,i] = Vec(vecs)[i][j]));
    for (j = 1, 3, m[j, #vecs + j] = Ms[j]);
    idx = matdet(mathnf(m));
    my(chk = reachdirect(E, gens, S));
    print("      reach index in the arena (order ", Ms[1]*Ms[2]*Ms[3], ") : ", idx,
          if (idx == 1, "   FULL", if (idx == 2, "   a hyperplane", "")));
    print("        cross-check without discrete logs : order ", chk[2],
          ", index ", chk[3],
          if (chk[3] == idx, "   AGREES", "   *** DISAGREES ***")),
    print("      reach index : not computed (additive place, or non-cyclic E(F_p))"));
  print("");
  [idx, Vec(vecs)];
}

print("=========================================================================");
print(" Extended certificate for the ledger of section 2.5:  S = {11,13,17}");
print("=========================================================================");
print("");
print("E : v^2 = u^3 + u + 1 (496a).   E_d : Y^2 = X^3 + d^2 X + d^3.");
print("Each twist carries a GRANULARITY verdict: n_p = 1 at every place is the");
print("exactness certificate R(d) contains ker_1, and only an admitted twist is a");
print("ledger entry.  Without it the line would be a TALLY entry, whose level-1");
print("image over-approximates the reach and certifies nothing (section 2.3).");
print("");
print("One line per (twist, generator); the image is a TRIPLE, one entry per");
print("place of S, in the conventions of section 3.4.1.");
print("");

{
foreach (TUP, t,
  my(E0 = Ed(t[2]), Ms = vector(3, j, Mval(E0, S[j])), N = Ms[1]*Ms[2]*Ms[3]);
  print("-------------------------------------------------------------------------");
  print("  tuple ", t[1], "   d_0 = ", t[2], "   M = ", Ms, "   arena order N = ", N);
  print("  ", t[4]);
  print("");
  my(tot = List(), vecs = List());
  foreach (t[3], d,
    my(r = entry(t[1], d, Ms));
    listput(tot, r[1]);
    if (#r[2] > 0, listput(vecs, r[2])));
  print("  reach indices for this tuple : ", Vec(tot));
  \\ the star test, on the sign-closed ledger
  if (#vecs == #t[3],
    my(L = List(), bad = 0, use = Vec(vecs));
    foreach (use, v, foreach (SIGNS, sg, listput(L, signim(subgrp(v, Ms), sg, Ms))));
    print("  star test on the sign-closed ledger : covers ? ",
          if (covers(Vec(L), N), "YES", "NO")));
  print(""));
}
print("done.");
