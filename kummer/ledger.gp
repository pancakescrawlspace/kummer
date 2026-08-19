read("sadic.gp");

/* =====================================================================
   The ledger and the star test at level 1   (document, section 2.3)

   At level 1, and at primes of good reduction, the arena is just

       G = prod_{p in S} Etilde_{d0}(F_p),

   so the whole computation is finite-field arithmetic plus integer
   bookkeeping.  Data types, all elementary:

     arena element   an integer in [0, N), N = prod_p M_p, obtained by
                     mixed-radix packing of one point-index per place
     reach           a 0/1 Vecsmall of length N (the subgroup as a bitmap)
     ledger          a list of such bitmaps, closed under the sign group
                     and pruned to an antichain
     membership mask for an arena element a, the set of ledger indices whose
                     reach contains a, packed as an integer bitmask
     coverage        the distinct masks pairwise AND to something non-zero

   All twists d in one square-class tuple give Qp-isomorphic curves, so the
   arena is fixed per tuple; a twist is transported to the chosen
   representative d0 by (x,y) -> (x/u^2, y/u^3) with u^2 = d/d0 in F_p.
   ===================================================================== */

/* ---------- the arena ------------------------------------------------ */

/* points of Etilde_{d0}(F_p), indexed from 1; index 1 is the identity */
placepoints(A, B, d0, p) = {
  my(E = ellinit([A*d0^2, B*d0^3], p), L = List([[0]]), x, s, y);
  for(x = 0, p-1,
    s = Mod(x^3 + A*d0^2*x + B*d0^3, p);
    if(!issquare(s, &y), next);
    listput(L, [Mod(x,p), y]);
    if(y != -y, listput(L, [Mod(x,p), -y])));
  [E, Vec(L)];
}

/* arena: per place the curve, its point list, addition and negation tables */
arenainit(A, B, d0, S) = {
  my(dat = List(), i, j, k, E, P, m, add, neg, Q);
  for(i = 1, #S,
    my(pp = placepoints(A, B, d0, S[i]));
    E = pp[1]; P = pp[2]; m = #P;
    add = matrix(m, m);
    for(j = 1, m, for(k = 1, m,
      Q = elladd(E, P[j], P[k]);
      add[j,k] = idxin(P, Q)));
    neg = vector(m, j, idxin(P, ellneg(E, P[j])));
    listput(dat, [E, P, m, add, neg, S[i]]));
  Vec(dat);
}
idxin(P, Q) = { my(j); for(j = 1, #P, if(P[j] == Q, return(j))); 0; }

arenasize(ar) = { my(t = 1, i); for(i = 1, #ar, t *= ar[i][3]); t; }

/* mixed-radix packing of a per-place index vector into 0..N-1 */
pack(ar, v) = { my(k = 0, i); for(i = 1, #ar, k = k*ar[i][3] + (v[i]-1)); k; }
unpack(ar, k) = {
  my(v = vector(#ar), i);
  forstep(i = #ar, 1, -1, v[i] = (k % ar[i][3]) + 1; k = k \ ar[i][3]);
  v;
}
arenaadd(ar, k1, k2) = {
  my(a = unpack(ar,k1), b = unpack(ar,k2), i);
  pack(ar, vector(#ar, i, ar[i][4][a[i], b[i]]));
}
arenaneg(ar, k) = {
  my(a = unpack(ar,k), i);
  pack(ar, vector(#ar, i, ar[i][5][a[i]]));
}

/* ---------- reaches --------------------------------------------------- */

/* reduce a rational point of E^d, transported to E^{d0}, at place i */
redpoint(ar, d, d0, i, Pt) = {
  my(p = ar[i][6], P = ar[i][2], u, x, y);
  if(Pt == [0], return(1));
  if(valuation(denominator(Pt[1]), p) > 0 ||
     valuation(denominator(Pt[2]), p) > 0, return(1));   /* reduces to O */
  u = sqrt(Mod(d,p)/Mod(d0,p));
  x = Mod(Pt[1],p)/u^2; y = Mod(Pt[2],p)/u^3;
  idxin(P, [x,y]);
}

/* the reach of the twist d, as a 0/1 bitmap of length N */
reachmap(ar, d, d0, S, pts) = {
  my(N = arenasize(ar), bm = vectorsmall(N), gens = List(), i, j, k, new, g, cur);
  for(j = 1, #pts,
    listput(gens, pack(ar, vector(#S, i, redpoint(ar, d, d0, i, pts[j])))));
  gens = Vec(gens);
  bm[1] = 1;                                   /* identity has index 0 */
  new = 1;
  while(new,
    new = 0;
    for(k = 0, N-1,
      if(bm[k+1] == 0, next);
      for(j = 1, #gens,
        cur = arenaadd(ar, k, gens[j]);
        if(bm[cur+1] == 0, bm[cur+1] = 1; new = 1))));
  bm;
}

/* the sign group acts by negating the chosen places */
signact(ar, bm, eps) = {
  my(N = #bm, out = vectorsmall(N), k, v, i);
  for(k = 0, N-1,
    if(bm[k+1] == 0, next);
    v = unpack(ar, k);
    for(i = 1, #ar, if(eps[i] < 0, v[i] = ar[i][5][v[i]]));
    out[pack(ar, v)+1] = 1);
  out;
}
bmcontains(b1, b2) = { my(i); for(i = 1, #b1, if(b2[i] && !b1[i], return(0))); 1; }
bmsize(b) = { my(t = 0, i); for(i = 1, #b, t += b[i]); t; }

/* ---------- the ledger ------------------------------------------------ */

/* add a reach and all its sign translates, keeping only maximal members */
ledgeradd(L, ar, bm) = {
  my(S = #ar, e, eps, cand = List(), i, j, keep, out = List(), b);
  for(e = 0, 2^S - 1,
    eps = vector(S, i, if(bitand(e, 2^(i-1)), -1, 1));
    listput(cand, signact(ar, bm, eps)));
  for(j = 1, #cand,
    b = cand[j];
    keep = 1;
    for(i = 1, #L, if(bmcontains(L[i], b), keep = 0; break()));
    if(keep, listput(L, b)));
  /* prune members now dominated */
  for(i = 1, #L,
    keep = 1;
    for(j = 1, #L, if(i != j && bmcontains(L[j], L[i]) && !bmcontains(L[i], L[j]),
                      keep = 0; break()));
    if(keep, listput(out, L[i])));
  out;
}

/* ---------- the star test --------------------------------------------- */

/* masks[k+1] = set of ledger indices whose reach contains arena element k */
maskvec(L, N) = {
  my(mk = vector(N, i, 0), i, k);
  for(i = 1, #L, for(k = 1, N, if(L[i][k], mk[k] += 2^(i-1))));
  mk;
}

/* coverage holds iff the distinct masks pairwise intersect;
   returns [covered?, #distinct masks, uncovered ordered pairs]            */
startest(L, N) = {
  my(mk = maskvec(L, N), D = Map(), ks, i, j, c, tot = 0, bad = 0);
  for(k = 1, N,
    c = if(mapisdefined(D, mk[k]), mapget(D, mk[k]), 0);
    mapput(D, mk[k], c+1));
  ks = Mat(D)[,1];
  for(i = 1, #ks, for(j = 1, #ks,
    tot += mapget(D, ks[i]) * mapget(D, ks[j]);
    if(bitand(ks[i], ks[j]) == 0,
       bad += mapget(D, ks[i]) * mapget(D, ks[j]))));
  [bad == 0, #ks, bad];
}

/* ---------- driver ----------------------------------------------------
   Accumulate reaches from every twist in the square-class tuple of d0 and
   watch the star test.  Reports, after each addition: ledger size, the
   largest reach so far, the number of distinct membership masks, and the
   deficiency (ordered pairs of arena elements not covered by any reach).  */
runledger(A, B, d0, S, DMAX, verbose) = {
  my(ar = arenainit(A, B, d0, S), N, L = List(), d, n, sg, td, bm, st, k0, cnt = 0);
  N = arenasize(ar);
  k0 = sqclassS(d0, S);
  print("  arena: ", vector(#S, i, ar[i][3]), "   N = ", N,
        "   tuple = ", k0);
  for(n = 1, DMAX,
    if(!issquarefree(n), next);
    for(sg = 0, 1,
      d = if(sg == 0, n, -n);
      if(sqclassS(d, S) != k0, next);
      td = twistdata(A, B, d);
      if(#td[2] == 0, next);
      bm = reachmap(ar, d, d0, S, td[2]);
      if(bmsize(bm) <= 1, next);
      L = ledgeradd(L, ar, bm);
      cnt++;
      if(verbose || cnt % 5 == 0,
        st = startest(L, N);
        print("    twists used ", cnt, " (last d=", d, ", rank ", td[3],
              ", reach ", bmsize(bm), ")   ledger ", #L,
              "   masks ", st[2], "   deficiency ", st[3], "/", N^2))));
  st = startest(L, N);
  print("  FINAL: ledger ", #L, "   covered? ", if(st[1], "YES", "no"),
        "   deficiency ", st[3], " of ", N^2, " ordered pairs",
        "   (", 100.0*st[3]/N^2, "%)");
  L;
}

/* =====================================================================
   Granularity   (document, section 2.3.2)

   Places p in S index columns, layer primes l dividing #G index rows.
   Cell (p,l) is the l-primary part of E^delta(Q_p): off-diagonal cells
   (l != p) are FINITE, only the diagonal ones (l = p) are infinite, and
   ker_n is pro-p at each place so lives entirely on the diagonal.  Hence
   granularity is a per-place vector, and n_p = 1 exactly when the reach's
   p-layer is all of E_1(Q_p).

   When no p in S divides M_q for q != p (checked, and true for
   S = {11,13,17}) the p-layer of the arena is E_1(Q_p) alone, so that test
   is the old condition (ii): the subgroup meets E_1 \ E_2 at p.
   ===================================================================== */

/* The p-layer of the arena is E_1(Q_p) alone whenever p divides no M_q,
   q in S.  Then the reach contains ker_1 at p iff some element of the
   subgroup lies in E_1 \ E_2 -- the old condition (ii).                  */
hitsE1(Em, pts, p) = {
  my(M, r, Ep, P, S0, coefs, basis, idx, rem, dv, mi, bvec, k, kP, Q, S2, C2,
     jP, cc, b, T, i, j, s, t);
  M = Mval(Em, p); r = #pts;
  if(M == 0 || r == 0, return(0));
  Ep = padiccurve(Em, p);
  P = vector(r, i, [pts[i][1]+O(p^PREC), pts[i][2]+O(p^PREC)]);
  S0 = [[0]]; coefs = [vector(r, j, 0)]; basis = List(); idx = 1;
  for(i = 1, r,
    rem = M \ idx; dv = divisors(rem); mi = 0; bvec = 0;
    for(t = 1, #dv, k = dv[t]; kP = ellmul(Ep, P[i], k);
      for(s = 1, #S0,
        Q = if(S0[s] == [0], kP, elladd(Ep, kP, S0[s]));
        if(inE1(Q, p), mi = k; bvec = coefs[s]; bvec[i] += k; break(2))));
    if(mi == 0, next);
    listput(basis, bvec);
    S2 = List(); C2 = List();
    for(j = 0, mi-1, jP = if(j==0, [0], ellmul(Ep, P[i], j));
      for(s = 1, #S0,
        Q = if(j==0, S0[s], if(S0[s]==[0], jP, elladd(Ep, jP, S0[s])));
        cc = coefs[s]; cc[i] += j; listput(S2, Q); listput(C2, cc)));
    S0 = Vec(S2); coefs = Vec(C2); idx *= mi);
  for(i = 1, #basis,
    b = basis[i]; Q = [0];
    for(j = 1, r, if(b[j] != 0, T = ellmul(Ep, P[j], b[j]);
      Q = if(Q == [0], T, elladd(Ep, Q, T))));
    if(Q != [0] && valuation(Q[1], p) == -2, return(1)));
  0;
}
/* granularity 1 at every place? */
gran1(Em, pts, S) = { my(i); for(i = 1, #S, if(!hitsE1(Em, pts, S[i]), return(0))); 1; }


/* Ledger admitting only granularity-1 twists.  If this closes at level 1 the
   termination theorem applies with N = 1 and density is PROVED.            */
rungraded(A, B, d0, S, DMAX, verbose) = {
  my(ar = arenainit(A, B, d0, S), N, L = List(), d, n, sg, td, bm, st, k0,
     cnt = 0, seen = 0);
  N = arenasize(ar); k0 = sqclassS(d0, S);
  print("  arena ", vector(#S, i, ar[i][3]), "  N = ", N, "   tuple ", k0,
        "   (granularity-1 twists only)");
  for(n = 1, DMAX,
    if(!issquarefree(n), next);
    for(sg = 0, 1,
      d = if(sg == 0, n, -n);
      if(sqclassS(d, S) != k0, next);
      td = twistdata(A, B, d);
      if(#td[2] == 0, next);
      seen++;
      if(!gran1(td[1], td[2], S), next);          /* reject: not exact at level 1 */
      bm = reachmap(ar, d, d0, S, td[2]);
      if(bmsize(bm) <= 1, next);
      L = ledgeradd(L, ar, bm); cnt++;
      if(verbose,
        st = startest(L, N);
        print("    admitted ", cnt, " (d=", d, ", rank ", td[3], ", reach ",
              bmsize(bm), ")  ledger ", #L, "  deficiency ", st[3]))));
  st = startest(L, N);
  print("  twists inspected ", seen, ", admitted ", cnt,
        "   ledger ", #L, "   covered? ", if(st[1], "YES", "no"),
        "   deficiency ", st[3]);
  if(st[1], print("  => level-1 coverage by granularity-1 reaches: DENSITY PROVED for this tuple"));
  L;
}
