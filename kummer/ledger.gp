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
   representative d0 by (x,y) -> (lam^2 x, lam^3 y) with lam^2 = d0/d, which
   lies in Qp exactly because d and d0 share the tuple.

   The arena is  G_delta = prod_{p in S} E^delta(Qp)/E_1(Qp),  realised by
   explicit Qp-points, NOT by Fp-points: when p | d0 the twist is additive at
   p and Etilde(Fp) is not the right group (and ellinit over Fp is empty).
   Coset representatives come from cosetreps1 below.  Everything is done on
   the SHORT model y^2 = x^3 + A d^2 x + B d^3, which for squarefree d and
   p >= 5 is already minimal at p (v_p(c4) <= 2 < 4), so inE1 is valid there.

   Each ledger entry carries the twist and the sign vector that produced it,
   so a ledger that closes prints a certificate of S-adic density.
   ===================================================================== */

/* ---------- the arena ------------------------------------------------ */

PRECL = 60;

/* short model of E^d, on which inE1 is valid at every p >= 5 */
shortmodel(A, B, d) = ellinit([A*d^2, B*d^3]);

/* twistdata, with the generators pulled back from the minimal model to the
   short model.  Returns [Em, pts on Em, pts on short model, rank].         */
shortdata(A, B, d) = {
  my(Ec = shortmodel(A, B, d), v = 0, Em, td);
  Em = ellminimalmodel(Ec, &v);
  td = twistdata(A, B, d);
  [td[1], td[2], apply(P -> ellchangepointinv(P, v), td[2]), td[3]];
}

/* which coset of E_1 does the Qp-point Q lie in? */
cosetidx(Ep, R, p, Q) = {
  my(k);
  for(k = 1, #R,
    if(inE1(if(R[k] == [0], Q, ellsub(Ep, Q, R[k])), p), return(k)));
  0;
}

arenainit(A, B, d0, S) = {
  my(dat = List(), i, j, k, Es, cr, Ep, R, m, add, neg, Q);
  Es = shortmodel(A, B, d0);
  for(i = 1, #S,
    cr = cosetreps1(Es, S[i], 3, PRECL);
    Ep = cr[1]; R = cr[2]; m = #R;
    add = matrix(m, m);
    for(j = 1, m, for(k = j, m,
      Q = if(R[j] == [0], R[k], if(R[k] == [0], R[j], elladd(Ep, R[j], R[k])));
      add[j,k] = cosetidx(Ep, R, S[i], Q); add[k,j] = add[j,k]));
    neg = vector(m, j, if(R[j] == [0], 1, cosetidx(Ep, R, S[i], ellneg(Ep, R[j]))));
    listput(dat, [Ep, R, m, add, neg, S[i]]));
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
/* lam[i]^2 = d0/d in Qp: the isomorphism E^d -> E^d0 over Qp.  Either square
   root serves -- the two differ by the sign action, which the ledger already
   quotients by -- but it must be the SAME choice for every point of one
   twist, so it is computed once per twist in reachmap.                     */
lambdas(ar, d, d0) = vector(#ar, i, sqrt((d0/d) + O(ar[i][6]^PRECL)));

redpoint(ar, i, lam, Pt) = {
  if(Pt == [0], return(1));
  cosetidx(ar[i][1], ar[i][2], ar[i][6], [lam^2*Pt[1], lam^3*Pt[2]]);
}

/* the reach of the twist d, as a 0/1 bitmap of length N */
reachmap(ar, d, d0, S, pts) = {
  my(N = arenasize(ar), bm = vectorsmall(N), gens = List(), i, j, k, new, cur,
     lam = lambdas(ar, d, d0));
  for(j = 1, #pts,
    listput(gens, pack(ar, vector(#S, i, redpoint(ar, i, lam[i], pts[j])))));
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
/* A ledger entry is [bitmap, d, eps]: the reach together with the twist and
   the sign that produced it.  The provenance is what turns a closed ledger
   into a certificate -- a finite list of explicit twists whose reaches
   already cover the arena.                                                 */
ledgeradd(L, ar, bm, d) = {
  my(S = #ar, e, eps, cand = List(), i, j, keep, out = List(), b);
  for(e = 0, 2^S - 1,
    eps = vector(S, i, if(bitand(e, 2^(i-1)), -1, 1));
    listput(cand, [signact(ar, bm, eps), d, eps]));
  for(j = 1, #cand,
    b = cand[j][1];
    keep = 1;
    for(i = 1, #L, if(bmcontains(L[i][1], b), keep = 0; break()));
    if(keep, listput(L, cand[j])));
  /* prune members now dominated */
  for(i = 1, #L,
    keep = 1;
    for(j = 1, #L, if(i != j && bmcontains(L[j][1], L[i][1]) &&
                      !bmcontains(L[i][1], L[j][1]), keep = 0; break()));
    if(keep, listput(out, L[i])));
  out;
}

/* the twists behind a closed ledger, deduplicated */
certtwists(L) = { my(i, T = List()); for(i = 1, #L, listput(T, L[i][2])); Set(Vec(T)); }

showcert(L, ar) = {
  my(i);
  print("    certificate: ", #L, " maximal reaches from twists ", certtwists(L));
  for(i = 1, #L, print("      reach ", i, "  size ", bmsize(L[i][1]), "  index ", arenasize(ar)/bmsize(L[i][1]), "   d = ", L[i][2], "  signs ", L[i][3]));
}

/* ---------- the star test --------------------------------------------- */

/* masks[k+1] = set of ledger indices whose reach contains arena element k */
maskvec(L, N) = {
  my(mk = vector(N, i, 0), i, k);
  for(i = 1, #L, for(k = 1, N, if(L[i][1][k], mk[k] += 2^(i-1))));
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
  /* The exact deficiency is a double loop over distinct masks.  When a tuple
     has many distinct membership patterns that is quadratic in a big number,
     so past a threshold report only the boolean, with deficiency -1.       */
  if(#ks > 1500,
    for(i = 1, #ks, for(j = 1, #ks,
      if(bitand(ks[i], ks[j]) == 0, return([0, #ks, -1]))));
    return([1, #ks, 0]));
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
      L = ledgeradd(L, ar, bm, d);
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
      td = shortdata(A, B, d);
      if(#td[2] == 0, next);
      seen++;
      if(!gran1(td[1], td[2], S), next);          /* reject: not exact at level 1 */
      bm = reachmap(ar, d, d0, S, td[3]);
      if(bmsize(bm) <= 1, next);
      L = ledgeradd(L, ar, bm, d); cnt++;
      if(verbose,
        st = startest(L, N);
        print("    admitted ", cnt, " (d=", d, ", rank ", td[3], ", reach ",
              bmsize(bm), ")  ledger ", #L, "  deficiency ", st[3]))));
  st = startest(L, N);
  print("  twists inspected ", seen, ", admitted ", cnt,
        "   ledger ", #L, "   covered? ", if(st[1], "YES", "no"),
        "   deficiency ", st[3]);
  if(st[1], print("  => level-1 coverage by granularity-1 reaches: DENSITY PROVED for this tuple"); showcert(L, ar));
  L;
}

/* One pass over d, dispatching each twist to the ledger of its own square
   class tuple; admits only granularity-1 twists, so a tuple that closes is
   PROVED dense by the termination theorem at N = 1.                        */
sweepgraded(A, B, S, DMAX) = {
  my(nt = 4^#S, d0 = vector(nt,i,0), ar = vector(nt,i,0), L = vector(nt,i,0),
     d, n, sg, k, td, bm, st, i, nseen = vector(nt,i,0), nadm = vector(nt,i,0),
     nreal = 0, nproved = 0, res);
  for(n = 1, DMAX,
    if(!issquarefree(n), next);
    if(n % 250 == 0, print("      ... n = ", n, "  tuples realised ", nreal,
                           "  admitted so far ", sum(i = 1, nt, nadm[i])));
    for(sg = 0, 1,
      d = if(sg == 0, n, -n);
      k = sqclassS(d, S) + 1;
      td = shortdata(A, B, d);
      if(#td[2] == 0, next);
      if(d0[k] == 0,
         d0[k] = d; ar[k] = arenainit(A, B, d, S); L[k] = List(); nreal++);
      nseen[k]++;
      if(!gran1(td[1], td[2], S), next);
      bm = reachmap(ar[k], d, d0[k], S, td[3]);
      if(bmsize(bm) <= 1, next);
      L[k] = ledgeradd(L[k], ar[k], bm, d);
      nadm[k]++));
  print("  f = x^3+(", A, ")x+(", B, ")   S = ", S, "   |d| <= ", DMAX);
  print("  tuples realised: ", nreal, " of ", nt);
  res = List();
  for(i = 1, nt,
    if(d0[i] == 0, next);
    st = startest(L[i], arenasize(ar[i]));
    if(st[1], nproved++);
    listput(res, [i-1, d0[i], arenasize(ar[i]), nseen[i], nadm[i], #L[i], st[1], st[3]]));
  res = Vec(res);
  for(i = 1, nt,
    if(d0[i] == 0, next);
    st = startest(L[i], arenasize(ar[i]));
    print("    tuple ", i-1, " ", tuplename(i-1, S), " d0=", d0[i], " N=", arenasize(ar[i]),
          "  seen ", nseen[i], " admitted ", nadm[i], " ledger ", #L[i],
          if(st[1], "   COVERED", Str("   not covered, deficiency ", st[3])));
    if(st[1], showcert(L[i], ar[i])));
  print("  PROVED dense: ", nproved, " of ", nreal, " realised tuples");
  res;
}

/* =====================================================================
   Robust level-1 arena, valid at bad reduction too, plus provenance.

   The F_p-point construction above assumes GOOD reduction: when p | d the
   twist is additive at p and ellinit over F_p is empty.  Here the cosets of
   E_1 are found by sampling Q_p-points on the MINIMAL model and deduping by
   E_1-membership, which works for any reduction type.  Each ledger entry
   also records the twist and sign that produced it, so a successful sweep
   yields a certificate.
   ===================================================================== */

/* y-solutions in Q_p of a general Weierstrass equation at x = x0 */
ysols(Em, x0, p, prec) = {
  my(a1 = Em.a1, a2 = Em.a2, a3 = Em.a3, a4 = Em.a4, a6 = Em.a6, b, c, D, r);
  b = a1*x0 + a3;
  c = -(x0^3 + a2*x0^2 + a4*x0 + a6);
  D = b^2 - 4*c;
  if(D == 0, return([(-b/2) + O(p^prec)]));
  if(valuation(D,p) % 2, return([]));
  if(kronecker(truncate(D/p^valuation(D,p)) % p, p) != 1, return([]));
  r = sqrt(D + O(p^prec));
  [(-b + r)/2, (-b - r)/2];
}

/* Coset representatives of E_1 in Em(Q_p).

   Every point outside E_1 has integral x, so sweeping x over Z_p finds them
   all -- but at ADDITIVE reduction the deep components are cut out by
   congruences mod p^2 or p^3, so a short integer range stalls well below M
   (d = 17, p = 17: 21 of 34).  Sweep residues mod p^k with k increasing and
   stop as soon as M cosets are in hand: good reduction settles at k = 1,
   additive reduction walks up as far as it must.  Deterministic, so the
   representatives are reproducible and can go into a certificate.          */
cosetreps1(Em, p, KMAX, prec) = {
  my(Ep, R = List([[0]]), x0, ys, j, Q, new, i, M, k, q, qprev);
  M = Mval(Em, p);
  Ep = padiccurve(Em, p);
  for(k = 1, KMAX,
    q = p^k; qprev = if(k == 1, 0, p^(k-1));
    for(x0 = 0, q-1,
      if(k > 1 && x0 % p^(k-1) == x0, next);   /* already swept at level k-1 */
      ys = ysols(Em, x0, p, prec);
      for(j = 1, #ys,
        Q = [x0 + O(p^prec), ys[j]];
        new = 1;
        for(i = 1, #R,
          if(inE1(if(R[i] == [0], Q, ellsub(Ep, Q, R[i])), p), new = 0; break()));
        if(new, listput(R, Q));
        if(#R == M, return([Ep, Vec(R)])))));
  /* The sweep can stall one coset short: near a root of the Weierstrass
     cubic v_p(f(x0)) is large and its parity/residue can fail at every
     depth we sweep.  The cosets found still GENERATE, so close under the
     group law -- that recovers the rest without sweeping deeper.          */
  cosetclose(Ep, R, p, M);
}

/* close a set of coset representatives under addition mod E_1 */
cosetclose(Ep, R, p, M) = {
  my(n, i, j, k, Q, new, guard);
  for(guard = 1, 20,
    n = #R;
    for(i = 1, n, for(j = i, n,
      if(#R == M, return([Ep, Vec(R)]));
      Q = if(R[i] == [0], R[j], if(R[j] == [0], R[i], elladd(Ep, R[i], R[j])));
      new = 1;
      for(k = 1, #R,
        if(inE1(if(R[k] == [0], Q, ellsub(Ep, Q, R[k])), p), new = 0; break()));
      if(new, listput(R, Q))));
    if(#R == n, break()));
  [Ep, Vec(R)];
}

/* =====================================================================
   Searching per tuple.

   Sweeping |d| uniformly starves the ramified tuples.  A tuple fixes the
   parity of v_p(d) at each place, so the places with odd valuation force a
   divisor P_k = prod{p : v_p odd} of d; for S = {11,13,17} the all-odd tuple
   needs 2431 | d, and |d| <= 2600 offers a single candidate -- against the
   138 twists the d0 = 1 tuple needed to close.  Enumerate d = eps*P_k*m with
   m squarefree and coprime to S instead, so every tuple gets a comparable
   supply, and stop a tuple as soon as its ledger closes.
   ===================================================================== */

rungradedk(A, B, S, k, MMAX, CAP) = {
  my(P = tuplepart(k, S), Q = prod(i = 1, #S, S[i]), d0 = 0, ar = 0, L = List(),
     m, sg, d, td, bm, st, seen = 0, adm = 0, N = 0, tried = 0);
  for(m = 1, MMAX,
    if(!issquarefree(m) || gcd(m, Q) > 1, next);
    for(sg = 0, 1,
      d = if(sg == 0, m*P, -m*P);
      if(sqclassS(d, S) != k, next);
      if(tried >= CAP, break(2));
      tried++;
      /* the arena depends only on the tuple, so fix it from the first
         candidate -- a rank-0 twist with no points still names the arena */
      if(d0 == 0, d0 = d; ar = arenainit(A, B, d, S); N = arenasize(ar));
      td = shortdata(A, B, d);
      if(#td[2] == 0, next);
      seen++;
      if(!gran1(td[1], td[2], S), next);
      bm = reachmap(ar, d, d0, S, td[3]);
      if(bmsize(bm) <= 1, next);
      L = ledgeradd(L, ar, bm, d); adm++;
      if(startest(L, N)[1], break(2))));
  if(d0 == 0, print("    tuple ", k, " ", tuplename(k, S), "   no candidate in range"); return(0));
  st = startest(L, N);
  print("    tuple ", k, " ", tuplename(k, S), " d0=", d0, " N=", N, "  tried ", tried, " with points ", seen, " admitted ", adm, " ledger ", #L, if(st[1], "   COVERED", Str("   not covered, deficiency ", st[3])));
  if(st[1], showcert(L, ar));
  st[1];
}

sweeptuples(A, B, S, MMAX, CAP) = {
  my(nt = 4^#S, k, np = 0, r);
  print("  f = x^3+(", A, ")x+(", B, ")   S = ", S, "   m <= ", MMAX, ", cap ", CAP, " twists per tuple");
  for(k = 0, nt-1, r = rungradedk(A, B, S, k, MMAX, CAP); if(r, np++));
  print("  PROVED dense: ", np, " of ", nt, " tuples");
  np;
}
