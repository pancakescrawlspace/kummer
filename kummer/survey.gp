read("driver.gp");    /* sqfreepart, classrep */
read("p2.gp");        /* densegroup2, sqclass2; both read kummer2.gp */

/* =====================================================================
   survey.gp -- the same density test, run over a list of surfaces.

   GENERAL CUBICS.  The construction needs only a monic cubic: for
   f = x^3 + a x^2 + b x + c, E : v^2 = f(u), the twist E_d : d v^2 = f(u)
   becomes, on multiplying by d^3 and putting (U, Y) = (d u, d^2 v),

        E_d :  Y^2 = U^3 + a d U^2 + b d^2 U + c d^3,

   and a rational t0 with f(t0) = d*gamma^2 gives the point (d t0, d^2 gamma).
   The scripts in kummer2.gp / driver.gp hard-code the depressed form
   f = x^3 + Ax + B.  Depressing costs a shift x -> x - a/3, cleared by
   scaling with 3^2, 3^3, so the coefficients blow up by 3^4 and 3^6:
   the curve 11a2 has f = x^3 - 14x^2 - 31216x - 1983614 but depresses to
   f = x^3 - 281532 x + 57496282.  Working with monic cubics throughout
   keeps every model small.

   A cubic is passed as F = [a, b, c].  Everything downstream
   (densegroup, Mval, sqclass, densegroup2, M2val) acts on a minimal
   model and is unchanged.
   ===================================================================== */

fev(F, t) = t^3 + F[1]*t^2 + F[2]*t + F[3];
fdisc(F) = poldisc(x^3 + F[1]*x^2 + F[2]*x + F[3]);

/* the twisted curve E_d, minimal model + change of variable */
twistcurve(F, d) = {
  my(Ec = ellinit([0, F[1]*d, 0, F[2]*d^2, F[3]*d^3]), v = 0, Em);
  Em = ellminimalmodel(Ec, &v);
  [Em, v];
}

/* generators of a finite-index subgroup of E_d(Q), by descent */
twistdata3(F, d) = {
  my(tc = twistcurve(F, d), Em = tc[1], R, pts, tors);
  R = ellrank(Em);
  pts = R[4];
  if(#pts > 0, pts = ellsaturation(Em, pts, 50));
  tors = elltors(Em);
  pts = concat(pts, tors[3]);
  [Em, pts, R[1], R[2]];
}

/* ---------- stage 1: the cheap t0 sweep ----------------------------- */

sweep3(F, HN, HD) = {
  my(M = Map(), t0, q, d, keys);
  for(b = 1, HD,
    for(a = -HN, HN,
      if(gcd(a,b) != 1, next);
      t0 = a/b; q = fev(F, t0);
      if(q == 0, next);
      d = sqfreepart(q)[1];
      if(mapisdefined(M,d), mapput(M, d, concat(mapget(M,d), [t0])),
                            mapput(M, d, [t0]))
    )
  );
  keys = vecsort(Mat(M)[,1], z -> abs(z));
  [M, keys];
}

sweptdata3(F, d, t0s) = {
  my(tc = twistcurve(F, d), Em = tc[1], v = tc[2], pts = List(), t0, c);
  for(i = 1, #t0s,
    t0 = t0s[i];
    c = sqfreepart(fev(F, t0))[2];
    listput(pts, ellchangepoint([d*t0, d^2*c], v))
  );
  [Em, Vec(pts)];
}

/* ---------- stage 2: local triage ----------------------------------- */

classrep3(p, target, DMAX) = {
  my(d);
  for(n = 1, DMAX,
    if(!issquarefree(n), next);
    for(sg = 0, 1,
      d = if(sg == 0, n, -n);
      if(sqclass(d,p) == target, return(d))));
  0;
}

procyclic3(F, p, target) = {
  my(d = classrep3(p, target, 4000), Em, lr, ns, c);
  if(d == 0, return(0));
  Em = twistcurve(F, d)[1];
  lr = elllocalred(Em, p);
  if(lr[2] == 1, return(#ellgroup(Em,p) == 1));
  ns = p - ellap(Em, p); c = lr[4];
  gcd(c, ns) == 1 && c <= 3;
}

/* ---------- stage 3: witnesses -------------------------------------- */

/* odd p: hybrid search, returning the witness table.
   W[j][k] = witness d for class k-1 at the j-th odd prime, 0 if none;
   P[j][k] = "s" (sweep) / "d" (descent) / "-" (not found).          */
witnessodd(F, SW, PMAX, TRIES, MMAX) = {
  my(M = SW[1], keys = SW[2], prs = primes([3,PMAX]),
     W, P, p, w, path, d, td, tried, ncheap = 0, ndesc = 0, hit);
  W = vector(#prs); P = vector(#prs);
  for(j = 1, #prs,
    p = prs[j];
    w = vector(4, i, 0); path = vector(4, i, "-");
    for(k = 0, 3,
      hit = 0;
      if(procyclic3(F, p, k),
        ncheap++; tried = 0;
        for(i = 1, #keys,
          d = keys[i];
          if(sqclass(d,p) != k, next);
          tried++; if(tried > TRIES, break());
          td = sweptdata3(F, d, mapget(M,d));
          if(densegroup(td[1], td[2], p),
             w[k+1] = d; path[k+1] = "s"; hit = 1; break())));
      if(!hit,
        ndesc++;
        d = classdescent(F, p, k, MMAX);
        if(d != 0, w[k+1] = d; path[k+1] = "d"; hit = 1))
    );
    W[j] = w; P[j] = path
  );
  [W, P, ncheap, ndesc];
}

/* p = 2: witnesses for the 8 square classes */
witness2(F, MMAX) = {
  my(w = vector(8, i, 0), d, td, k);
  for(m = 1, MMAX,
    if(!issquarefree(m) || m % 2 == 0, next);
    for(e = 0, 1,
      for(sg = 0, 1,
        d = (-1)^sg * 2^e * m;
        k = sqclass2(d);
        if(w[k+1] != 0, next);
        td = twistdata3(F, d);
        if(#td[2] == 0, next);
        if(densegroup2(td[1], td[2]), w[k+1] = d))));
  w;
}

/* ---- enumerate a square class by COFACTOR, not by |d| ---------------
   The classes [p] and [u*p] force p | d, so a search bounded by |d| <= D
   offers them only about D/p candidates against D/2 for [1] and [u] -- a
   100:1 starvation at p = 103, and it is what makes 11a3 look obstructed
   there.  Writing d = +- P*m with P = p (classes 2,3) or P = 1 (classes
   0,1) and m squarefree coprime to p gives every class the same supply.
   This is the per-tuple enumeration of sadic.gp, applied at one place. */
classdescent(F, p, k, MMAX) = {
  my(P = if(k >= 2, p, 1), d, td);
  for(m = 1, MMAX,
    if(!issquarefree(m) || gcd(m, p) != 1, next);
    for(sg = 0, 1,
      d = if(sg == 0, P*m, -P*m);
      if(sqclass(d, p) != k, next);
      td = twistdata3(F, d);
      if(#td[2] == 0, next);
      if(densegroup(td[1], td[2], p), return(d))));
  0;
}

/* a targeted deeper search in one class, over a cofactor window */
deephunt(F, p, target, MLO, MHI) = {
  my(P = if(target >= 2, p, 1), d, td);
  for(m = MLO, MHI,
    if(!issquarefree(m) || gcd(m, p) != 1, next);
    for(sg = 0, 1,
      d = if(sg == 0, P*m, -P*m);
      if(sqclass(d, p) != target, next);
      td = twistdata3(F, d);
      if(#td[2] == 0, next);
      if(densegroup(td[1], td[2], p),
        print("  HUNT p=", p, " class ", sqclassname(target,p), ": d=", d,
              "  rank in [", td[3], ",", td[4], "]");
        return(d))));
  print("  HUNT p=", p, " class ", sqclassname(target,p),
        ": NOT FOUND for cofactor ", MLO, " <= m <= ", MHI);
  0;
}

/* ---------- one surface, with timings -------------------------------- */

runsurface(lbl, F, HN, HD, PMAX, TRIES, MMAX, M2) = {
  my(t, tsw, thy, tp2, SW, R, W, P, prs, nfull = 0, nf, w2, n2 = 0, nr2);
  print("=== ", lbl, "  f = x^3 + (", F[1], ")x^2 + (", F[2], ")x + (", F[3], ")");
  nr2 = #polrootspadic(x^3 + F[1]*x^2 + F[2]*x + F[3], 2, 30);
  print("INFO discf=", fdisc(F), " rootsQ2=", nr2);
  t = getwalltime(); SW = sweep3(F, HN, HD); tsw = getwalltime() - t;
  print("SWEEP twists=", #SW[2], " time=", tsw);
  t = getwalltime(); R = witnessodd(F, SW, PMAX, TRIES, MMAX);
  thy = getwalltime() - t;
  W = R[1]; P = R[2]; prs = primes([3,PMAX]);
  for(j = 1, #prs,
    nf = 0; for(k = 1, 4, if(W[j][k] != 0, nf++));
    if(nf == 4, nfull++);
    print("P ", prs[j], " ", W[j][1], " ", W[j][2], " ", W[j][3], " ", W[j][4],
          " ", P[j][1], P[j][2], P[j][3], P[j][4], " ", nf));
  print("ODD full=", nfull, "/", #prs, " cheap=", R[3], " desc=", R[4], " time=", thy);
  t = getwalltime(); w2 = witness2(F, M2); tp2 = getwalltime() - t;
  for(k = 1, 8, if(w2[k] != 0, n2++));
  print("TWO ", w2, " cover=", n2, "/8 time=", tp2);
  print("TOTAL time=", tsw + thy + tp2);
  print("");
  [W, P, w2, [tsw, thy, tp2]];
}

/* =====================================================================
   Diagnostics for a class that the search failed to witness.

   g = the minimal number of topological generators of E_delta(Q_p).
   It is local data: it depends on (p, delta) only, not on the twist, so
   one computation settles the whole class and no point search is needed.
   Writing E_delta(Q_p) = Z_p x T,  g = max_l dim G/lG, which is
   1 + dim T[p] at l = p and dim T[l] at l != p.  (Same computation as
   gexactS in sadic.gp, at a single place, for a general monic cubic.)
   ===================================================================== */

torsdim3(F, d, p, l) = {
  my(a2 = F[1]*d, a4 = F[2]*d^2, a6 = F[3]*d^3, Ec, ps, rt, x0, s, cnt = 1);
  Ec = ellinit([0, a2, 0, a4, a6]);
  ps = elldivpol(Ec, l);
  rt = polrootspadic(ps, p, 30);
  for(i = 1, #rt,
    x0 = rt[i];
    if(l == 2, cnt += 1; next);
    s = x0^3 + a2*x0^2 + a4*x0 + a6;
    if(issquare(s), cnt += 2));
  valuation(cnt, l);
}

torsdimloc3(F, d, Em, p, l) = {
  my(G, c = 0);
  if(elllocalred(Em, p)[2] == 1,
    if(l != p,
      G = ellgroup(Em, p);
      for(i = 1, #G, if(G[i] % l == 0, c++));
      return(c));
    if((p + 1 - ellap(Em, p)) % p != 0, return(0))
  ,
    if(l != p && ellap(Em, p) == 0 && elllocalred(Em, p)[4] % l != 0, return(0))
  );
  torsdim3(F, d, p, l);
}

/* minimal number of topological generators of E_delta(Q_p), delta = class of d */
gloc(F, d, p) = {
  my(Em = twistcurve(F, d)[1], ells, l, r, g = 0);
  ells = Set(concat([p], Vec(factor(Mval(Em, p))[,1]~)));
  for(i = 1, #ells,
    l = ells[i];
    r = if(l == p, 1, 0) + torsdimloc3(F, d, Em, p, l);
    if(r > g, g = r));
  g;
}

/* Everything the search saw in one square class: how many twists carried a
   rational point at all, and what their Mordell-Weil ranks were. */
classaudit(lbl, F, p, k, MMAX) = {
  my(P = if(k >= 2, p, 1), d, Em, lr, ranks = vector(6, i, 0), npt = 0,
     ntry = 0, g, dr, t = getwalltime());
  dr = classrep3(p, k, 4000);
  g  = gloc(F, dr, p);
  Em = twistcurve(F, dr)[1];
  lr = elllocalred(Em, p);
  print("AUDIT ", lbl, " p=", p, " class ", sqclassname(k,p),
        "  g=", g, "  M=", Mval(Em, p),
        "  kodaira=", lr[2], " c_p=", lr[4],
        "  procyclic=", procyclic3(F, p, k));
  for(m = 1, MMAX,
    if(!issquarefree(m) || gcd(m, p) != 1, next);
    for(sg = 0, 1,
      d = if(sg == 0, P*m, -P*m);
      if(sqclass(d, p) != k, next);
      ntry++;
      my(td = twistdata3(F, d), r = #td[2]);
      if(r > 0, npt++; ranks[min(r,6)+0]++)));
  print("      twists tried=", ntry, "  with points=", npt,
        "  by #generators: ", ranks, "  time=", getwalltime()-t);
}

/* How many twists in one square class actually have Mordell-Weil rank >= 2?
   With g = 2 a rank-1 twist cannot be dense however many there are, so this
   is the number that decides whether a failed search means anything. */
rankaudit(lbl, F, p, k, MMAX) = {
  my(P = if(k >= 2, p, 1), d, td, rk = vector(5, i, 0), n2 = 0, npt = 0,
     t = getwalltime());
  for(m = 1, MMAX,
    if(!issquarefree(m) || gcd(m, p) != 1, next);
    for(sg = 0, 1,
      d = if(sg == 0, P*m, -P*m);
      if(sqclass(d, p) != k, next);
      td = twistdata3(F, d);
      if(#td[2] == 0, next);
      npt++;
      rk[min(td[3],4)+1]++;
      if(td[3] >= 2, n2++)));
  print("RANK ", lbl, " p=", p, " class ", sqclassname(k,p),
        "  m<=", MMAX, "  withpoints=", npt,
        "  rank 0/1/2/3/4+: ", rk, "  rank>=2: ", n2,
        "  time=", getwalltime()-t);
}

/* targeted deeper search in one square class at p = 2 */
hunt2(lbl, F, k, MLO, MHI) = {
  my(d, td, t = getwalltime());
  for(m = MLO, MHI,
    if(!issquarefree(m) || m % 2 == 0, next);
    for(e = 0, 1,
      for(sg = 0, 1,
        d = (-1)^sg * 2^e * m;
        if(sqclass2(d) != k, next);
        td = twistdata3(F, d);
        if(#td[2] == 0, next);
        if(densegroup2(td[1], td[2]),
          print("HUNT2 ", lbl, " class [", sqclass2name(k), "]: d=", d,
                " rank in [", td[3], ",", td[4], "] time=", getwalltime()-t);
          return(d)))));
  print("HUNT2 ", lbl, " class [", sqclass2name(k), "]: NOT FOUND m<=", MHI,
        " time=", getwalltime()-t);
  0;
}

/* minimal number of topological generators of E_delta(Q_2).
   E_delta(Q_2) = Z_2 x T, so g = max(1 + dim T[2], max_{l odd} dim T[l]);
   dim T[2] = dim E[2](Q_2) is read off the roots of f (0, 1 or 3 roots
   give dimension 0, 1, 2) and is the same for every twist.            */
gloc2(F, d) = {
  my(Em = twistcurve(F, d)[1], g, ells, l, r, nr);
  nr = #polrootspadic(x^3 + F[1]*x^2 + F[2]*x + F[3], 2, 40);
  g = 1 + if(nr == 3, 2, if(nr == 1, 1, 0));
  ells = Vec(factor(M2val(Em))[,1]~);
  for(i = 1, #ells,
    l = ells[i];
    if(l == 2, next);
    r = torsdim3(F, d, 2, l);
    if(r > g, g = r));
  g;
}

/* rank supply inside one square class at p = 2 */
rankaudit2(lbl, F, k, MMAX) = {
  my(d, td, rk = vector(5, i, 0), n2 = 0, npt = 0, t = getwalltime());
  for(m = 1, MMAX,
    if(!issquarefree(m) || m % 2 == 0, next);
    for(e = 0, 1,
      for(sg = 0, 1,
        d = (-1)^sg * 2^e * m;
        if(sqclass2(d) != k, next);
        td = twistdata3(F, d);
        if(#td[2] == 0, next);
        npt++; rk[min(td[3],4)+1]++; if(td[3] >= 2, n2++))));
  print("RANK2 ", lbl, " class [", sqclass2name(k), "]  m<=", MMAX,
        "  g=", gloc2(F, 1), "  M2=", M2val(twistcurve(F,1)[1]),
        "  withpoints=", npt, "  rank 0/1/2/3/4+: ", rk,
        "  rank>=2: ", n2, "  time=", getwalltime()-t);
}

/* ---- family scans: one place, many members --------------------------
   The sextic family j = 0 is  f = x^3 + B, B cubefree > 0; the quartic
   family j = 1728 is  f = x^3 + A x, A squarefree.  Both are infinite,
   so the question "is the known defect of x^3 - 2 at p = 3 a fact about
   the family or about that member?" is answered by walking the family at
   the single place that matters.                                      */

/* witnesses at ONE odd prime, sweep + descent as usual */
oneprime(F, p, HN, HD, TRIES, MMAX) = {
  my(SW = sweep3(F, HN, HD), R = witnessodd(F, SW, p, TRIES, MMAX));
  [R[1][#R[1]], R[2][#R[2]]];
}

cubefree(n) = { my(fa = factor(n)); for(i = 1, #fa~, if(fa[i,2] >= 3, return(0))); 1; }

sexticscan(BMAX, p, MMAX) = {
  my(F, r, w, nf, t, bad = List());
  print("sextic family x^3 + B at p = ", p, ", cofactor m <= ", MMAX);
  for(B = 1, BMAX,
    if(!cubefree(B), next);
    F = [0, 0, B];
    t = getwalltime();
    r = oneprime(F, p, 1500, 50, 60, MMAX);
    w = r[1]; nf = 0; for(k = 1, 4, if(w[k] != 0, nf++));
    if(nf < 4, listput(bad, B));
    print("  B=", B, "  ", w, "  ", r[2], "  ", nf, "/4  time=", getwalltime()-t)
  );
  print("SEXTIC defective B: ", Vec(bad));
  Vec(bad);
}

quarticscan(AMAX, MMAX) = {
  my(F, w, n, t, bad = List());
  print("quartic family x^3 + A x at p = 2, cofactor m <= ", MMAX);
  for(a = -AMAX, AMAX,
    if(a == 0 || !issquarefree(a), next);
    F = [0, a, 0];
    t = getwalltime();
    w = witness2(F, MMAX);
    n = 0; for(k = 1, 8, if(w[k] != 0, n++));
    if(n < 8, listput(bad, a));
    print("  A=", a, "  ", w, "  ", n, "/8  g2=", gloc2(F,1),
          "  time=", getwalltime()-t)
  );
  print("QUARTIC defective A: ", Vec(bad));
  Vec(bad);
}

/* =====================================================================
   The section-5.1.5 question at ell = 2, for f = x^3 + x.

   The mechanism there is: a NON-SCALAR phi in End_G(E[ell]) twists the
   local Tate pairing, beta_v(P,Q) = <delta_v P, phi delta_v Q>_v;
   reciprocity sum_v beta_v = 0; every v != ell contributes 0; hence the
   image of E_d(Q) in W_ell = E_d(Q_ell)/ell is beta_ell-isotropic, so of
   dimension <= 1 in a 2-dimensional space.  Section 5.1.5 gets phi from
   DECOMPOSABILITY of E[3].  At ell = 2 that is not the only route: see
   torsionmodule below.

   The falsifiable prediction is about the image of E_d(Q) in W_2, and in
   particular whether the line it spans VARIES with d (a pairing) or is
   the same for every d (a linear functional).  halvable/imageline
   measure it.
   ===================================================================== */

/* is Q in 2*E(Q_2)?   x(2R) = phi2(x)/psi2(x)^2 with a1 = a3 = 0, so the
   halves of Q = (X,Y) have x-coordinate a root of phi2(x) - 4X f(x), and
   R is rational exactly when f(x) is a square in Q_2.                  */
halvable(F, d, Q, prec) = {
  my(a2 = F[1]*d, a4 = F[2]*d^2, a6 = F[3]*d^3, ff, phi2, G, rt, s);
  if(Q == [0], return(1));
  ff   = x^3 + a2*x^2 + a4*x + a6;
  phi2 = x^4 - 2*a4*x^2 - 8*a6*x + a4^2 - 4*a2*a6;
  G    = phi2 - 4*Q[1]*ff;
  rt = polrootspadic(G, 2, prec);
  for(i = 1, #rt,
    s = subst(ff, x, rt[i]);
    if(s == 0 || issquare(s), return(1)));
  0;
}

/* the Galois module E[2]: how the roots of f sit, and whether
   End_G(E[2]) is bigger than F_2.  Over F_2 the group ring of the
   Galois image need not be semisimple, so E[2] can be INDECOMPOSABLE
   and still carry a non-scalar endomorphism -- which is all the twisted
   pairing needs. */
torsionmodule(F) = {
  my(ff = x^3 + F[1]*x^2 + F[2]*x + F[3], fa, degs, K, nsc);
  fa = factor(ff);
  degs = vector(#fa~, i, poldegree(fa[i,1]));
  print("  f factors over Q with degrees ", degs);
  if(degs == [1,2] || degs == [2,1],
    K = if(poldegree(fa[1,1]) == 2, fa[1,1], fa[2,1]);
    print("  2-torsion field of the two conjugate points: Q[x]/(", K, ")");
    print("  Galois acts through Z/2, swapping them: the matrix is [[1,1],[0,1]],");
    print("  a single unipotent block, so End_G(E[2]) = F_2[N]/(N^2), NON-SCALAR,");
    print("  while E[2] itself is INDECOMPOSABLE (no complementary stable line).");
    nsc = 1
  ,
  degs == [1,1,1],
    print("  E[2] is split: End_G(E[2]) = all of M_2(F_2), non-scalar.");
    nsc = 1
  ,
    print("  f irreducible: Galois image contains an element of order 3,");
    print("  End_G(E[2]) = F_4 or F_2 -- scalar over F_2 if the image is all of GL_2.");
    nsc = 0
  );
  nsc;
}

/* dim_F2 W_v = dim E_d(Q_v)/2 at an ODD place v = l.
   E_d(Q_l) = Z_l x T with Z_l 2-divisible, so W_l = T[2] = E_d(Q_l)[2],
   which is read off the roots of f_d in Q_l. */
dimW(F, d, l, prec) = {
  my(a2 = F[1]*d, a4 = F[2]*d^2, a6 = F[3]*d^3, n);
  n = #polrootspadic(x^3 + a2*x^2 + a4*x + a6, l, prec);
  if(n == 3, 2, if(n == 1, 1, 0));
}


/* --- the image of E_d(Q) in the Frattini quotient of E_delta(Q_2) -----
   For these twists E_delta(Q_2) is pro-2 (M_2 is a 2-power and E_2 is
   torsion free), so density means surjecting onto G/2G, and the quotient
   map G/2G -> A/2A with A = G/E_2 finite of order M_2 is an isomorphism
   whenever both sides have F_2-dimension 2.  Working in A keeps every
   test a valuation rather than a root-finding, which is what p-adic
   x-coordinates make awkward.

   All d in one square class give Q_2-isomorphic curves, the isomorphism
   sending x to x*dref/d -- rational, so the transported group is exactly
   as computable as the original.                                      */

Ecurve(F, d) = ellinit([0, F[1]*d, 0, F[2]*d^2, F[3]*d^3]);
padiccrv(F, d, prec) = ellinit([0, F[1]*d+O(2^prec), 0, F[2]*d^2+O(2^prec), F[3]*d^3+O(2^prec)]);

sameclass2(Ep, P, Q) = inE2(elladd(Ep, P, ellneg(Ep, Q)));

/* coset representatives of E_2 in E_d(Q_2), by closing under the points
   found from a scan of x-coordinates */
cosetsE2(F, d, prec, XMAX) = {
  my(Ep = padiccrv(F, d, prec), ff, L = List([[0]]), M = M2val(twistcurve(F,d)[1]),
     s, y, P, isnew, T);
  ff = x^3 + F[1]*d*x^2 + F[2]*d^2*x + F[3]*d^3;
  for(k = -8, XMAX,
    if(#L >= M, break);
    my(u = if(k <= 0, 1/2^(-k), k));
    s = subst(ff, x, u + O(2^prec));
    if(s == 0 || !issquare(s, &y), next);
    P = [u + O(2^prec), y];
    /* close L under adding P */
    for(rep = 1, M,
      my(add = List());
      for(i = 1, #L,
        T = if(L[i] == [0], P, elladd(Ep, L[i], P));
        isnew = 1;
        for(j = 1, #L, if(sameclass2(Ep, T, L[j]), isnew = 0; break));
        for(j = 1, #add, if(sameclass2(Ep, T, add[j]), isnew = 0; break));
        if(isnew, listput(add, T)));
      if(#add == 0, break);
      for(i = 1, #add, listput(L, add[i]));
      if(#L >= M, break))
  );
  [Ep, Vec(L)];
}

cidx(Ep, L, P) = { for(i = 1, #L, if(sameclass2(Ep, P, L[i]), return(i))); 0; }

/* A/2A as a list of classes; returns [L, cls] with cls[i] the class of L[i] */
mod2A(Ep, L) = {
  my(n = #L, dbl = vector(n), sq = List(), cls = vector(n), reps = List());
  for(i = 1, n, dbl[i] = cidx(Ep, L, ellmul(Ep, L[i], 2)));
  sq = Set(Vec(dbl));                       /* indices of 2A */
  for(i = 1, n,
    my(found = 0);
    for(r = 1, #reps,
      for(t = 1, #sq,
        my(T = elladd(Ep, L[i], ellneg(Ep, L[sq[t]])));
        if(sameclass2(Ep, T, L[reps[r]]), found = r; break(2))));
    if(found, cls[i] = found, listput(reps, i); cls[i] = #reps));
  [cls, #reps];
}

/* the F_2-span of the image of E_d(Q) in A/2A, for every twist in one
   square class, with the classes labelled once and for all on E_dref. */
imagelines(lbl, F, dref, MMAX, prec) = {
  my(cs, Ep, L, m2, cls, nc, d, td, Em, v, pts, im, seen, dim,
     ndim = vector(3, i, 0), tot = 0, lines = Map(), key, t = getwalltime());
  cs = cosetsE2(F, dref, prec, 400); Ep = cs[1]; L = cs[2];
  m2 = mod2A(Ep, L); cls = m2[1]; nc = m2[2];
  print("IMAGE ", lbl, "   |A| = ", #L, "   |A/2A| = ", nc);
  if(nc != 4, print("   (A/2A is not (Z/2)^2 -- skipping)"); return());
  for(m = 1, MMAX,
    if(!issquarefree(m) || m % 2 == 0, next);
    for(sg = 0, 1,
      d = (-1)^sg * abs(dref) * m;
      if(sqclass2(d) != sqclass2(dref), next);
      td = twistdata3(F, d);
      if(#td[2] < 2, next);
      Em = ellminimalmodel(Ecurve(F, d), &v);
      pts = vector(#td[2], i, ellchangepointinv(td[2][i], v));
      /* all subset sums, computed rationally on E_d, then transported */
      seen = List();
      for(msk = 0, 2^#pts - 1,
        my(S = [0], Ed = Ecurve(F, d));
        for(i = 1, #pts, if(bittest(msk, i-1),
          S = if(S == [0], pts[i], elladd(Ed, S, pts[i]))));
        if(S == [0], listput(seen, cls[1]); next);
        my(Pt = [S[1]*dref/d + O(2^prec), 0], j);
        /* recover a y for the transported x on E_dref */
        my(ss = subst(x^3 + F[1]*dref*x^2 + F[2]*dref^2*x + F[3]*dref^3,
                      x, S[1]*dref/d + O(2^prec)), yy);
        if(ss == 0, Pt = [S[1]*dref/d + O(2^prec), 0],
           if(!issquare(ss, &yy), next); Pt = [S[1]*dref/d + O(2^prec), yy]);
        j = cidx(Ep, L, Pt);
        if(j == 0, next);
        listput(seen, cls[j]));
      seen = Set(Vec(seen));
      dim = if(#seen <= 1, 0, if(#seen == 2, 1, 2));
      tot++; ndim[dim+1]++;
      if(dim == 1,
        key = Str(select(z -> z != cls[1], Vec(seen)));
        mapput(lines, key, if(mapisdefined(lines,key), mapget(lines,key), 0) + 1))
    )
  );
  print("      twists with >= 2 generators: ", tot,
        "    image dim 0/1/2: ", ndim);
  if(#Mat(lines) > 0, print("      dim-1 images by line: ", Mat(lines)));
  print("      time=", getwalltime()-t);
}

/* =====================================================================
   The obstruction at the place 2, in elementary form.

   NOTATION.  Two different 2's meet here.  The LEVEL of the descent is 2
   (we use E[2] and square classes) and the PLACE that survives
   reciprocity is also v = 2 -- a layer and a place, the two families the
   main document keeps apart in section 2.3.  They coincide numerically,
   so below the level is never given a letter (always the literal 2),
   while v is a place of Q and q a finite ODD place.  Nothing here is
   called l.

   Nothing here needs Galois cohomology.  For E_d : y^2 = x(x^2+d^2) set

       c(O) = 1,  c(T) = d^2,  c(x,y) = x     (T = (0,0)),

   a map to K^x modulo squares.

   Lemma 1 (Vieta).  c is a homomorphism: three collinear points have
   x-coordinates the roots of x^3 - lam^2 x^2 + (d^2 - 2 lam nu) x - nu^2,
   whose product is nu^2 -- a square; and if nu = 0 the line passes
   through T and the other two x's multiply to d^2.

   Lemma 2 (norm lemma).  x(x^2+d^2) = y^2 makes x congruent to x^2+d^2
   modulo squares, and x^2+d^2 = N_{K(i)/K}(x + d i).  So c(P) is a norm
   from K(i), i.e. (c(P), -1)_v = 1 at every place.  For a general
   y^2 = x(x^2+ax+b) the field is K(sqrt(a^2-4b)); the twist of x^3+Ax
   has a^2-4b = -4Ad^2 = -A, so this is Q(i) exactly when A = 1.

   The pairing is then just the quadratic Hilbert symbol of two
   x-coordinates, (c(P), c(Q))_v, and the only imported theorem is
   Hilbert reciprocity.  See section 5.5 of kummer-survey.typ.
   ===================================================================== */

/* c(P) in Q^x mod squares for E_d : y^2 = x^3 + a x^2 + b x  (a6 = 0) */
cmap(F, d, P) = {
  my(b = F[2]*d^2);
  if(P == [0], return(1));
  if(P[1] == 0, return(b));
  P[1];
}

/* beta_v(P,Q) as a Hilbert symbol; returns 0 (trivial) or 1 */
betav(F, d, P, Q, v) = if(hilbert(cmap(F,d,P), cmap(F,d,Q), v) == 1, 0, 1);

/* the claim to be tested: beta_v(P,P) = 0 for every point and place */
alttest(F, d, prec, VMAX) = {
  my(td = twistdata3(F, d), E = Ecurve(F, d), Em, v = 0, pts, bad = 0, n = 0,
     P, cP, prs);
  Em = ellminimalmodel(E, &v);
  if(#td[2] == 0, return([0,0]));
  pts = vector(#td[2], i, ellchangepointinv(td[2][i], v));
  prs = concat([0], primes([2, VMAX]));       /* 0 is PARI's real place */
  for(msk = 1, 2^#pts - 1,
    P = [0];
    for(i = 1, #pts, if(bittest(msk, i-1),
      P = if(P == [0], pts[i], elladd(E, P, pts[i]))));
    if(P == [0], next);
    cP = cmap(F, d, P);
    for(j = 1, #prs,
      n++;
      if(betav(F, d, P, P, prs[j]) != 0, bad++)));
  [n, bad];
}

/* --- where beta_v can be non-zero, place by place --------------------
   beta_v(P,Q) = (x(P), x(Q))_v, so this is a question about the image of
   c in Q_v^x mod squares.  cimagep computes that image by sampling the
   Q_v-points; nzbeta asks whether the Hilbert symbol is non-trivial on
   it, i.e. whether beta_v is not identically zero on W_v.            */

nonres(p) = { my(u = 2); while(kronecker(u,p) == 1, u++); u; }
clsrep(k, p) = if(p == 2, [1,3,5,7,2,6,10,14][k+1], [1, nonres(p), p, nonres(p)*p][k+1]);
clsof(z, p) = if(p == 2, sqclass2(z), sqclass(z, p));

/* square classes of x(P) as P runs over E_d(Q_p), for f = x^3+ax^2+bx */
cimagep(F, d, p, prec, EMAX, MMAX) = {
  my(S = List(), ff, s);
  ff = x^3 + F[1]*d*x^2 + F[2]*d^2*x + F[3]*d^3;
  listput(S, 0);                                  /* O  -> 1        */
  listput(S, clsof(F[2]*d^2, p));                 /* T  -> b        */
  for(e = -EMAX, EMAX,
    for(m = 1, MMAX,
      if(m % p == 0, next);
      for(sg = 0, 1,
        my(xx = (-1)^sg * p^e * m);
        s = subst(ff, x, xx);
        if(s == 0, listput(S, clsof(xx, p)); next);
        if(issquare(s + O(p^prec)), listput(S, clsof(xx, p))))));
  Set(Vec(S));
}

/* is beta_p non-zero somewhere on W_p? */
nzbeta(im, p) = {
  for(i = 1, #im, for(j = 1, #im,
    if(hilbert(clsrep(im[i],p), clsrep(im[j],p), p) == -1, return(1))));
  0;
}

/* the norm identity behind the alternating property:
   x*(x^2+ax+b) = y^2, so x = N_{K/Q}(x-theta) mod squares with
   K = Q(sqrt(a^2-4b)); hence (x, a^2-4b)_v = 1 at every place.      */
normtest(F, d, VMAX) = {
  my(td = twistdata3(F, d), E = Ecurve(F, d), Em, v = 0, pts, disc, n = 0,
     bad = 0, P, prs);
  if(#td[2] == 0, return([0,0]));
  Em = ellminimalmodel(E, &v);
  pts = vector(#td[2], i, ellchangepointinv(td[2][i], v));
  disc = (F[1]*d)^2 - 4*F[2]*d^2;
  prs = concat([0], primes([2, VMAX]));
  for(msk = 1, 2^#pts - 1,
    P = [0];
    for(i = 1, #pts, if(bittest(msk, i-1),
      P = if(P == [0], pts[i], elladd(E, P, pts[i]))));
    if(P == [0], next);
    for(j = 1, #prs, n++;
      if(hilbert(cmap(F,d,P), disc, prs[j]) != 1, bad++)));
  [n, bad];
}

/* --- cyclicity of c(E_d(Q_l)) at bad odd l --------------------------
   Lemma A.  For P in E_d(Q_q) with k = v_q(x(P)) and e = v_q(d):
   if k < e then x^2+d^2 = x^2 (1 + (d/x)^2) and the second factor is a
   1-unit, hence a square (q odd); if k > e then x^2+d^2 = d^2(1+(x/d)^2)
   likewise.  Either way x^2+d^2 is a square times x^2 or d^2, and
   x(x^2+d^2) = y^2 forces x to be a square.  So c(P) = 1.

   Lemma B.  Hence every non-identity element of S = c(E_d(Q_q)) has
   valuation congruent to e mod 2.  S is a subgroup of Q_q^x mod squares,
   a group of order 4.  If e is even then S is contained in the units
   {1,u}; if e is odd then S minus the identity lies in {q, q*u}, and if
   both were in S so would be their product u -- a non-identity element
   of even valuation.  Either way #S <= 2 and S is cyclic.  No condition
   on q mod 4 is needed.                                              */

/* Lemma A, tested: sample Q_q-points with v_q(x) != v_q(d) and check
   that x is a square in Q_q.  (The argument l of lemmaA is that odd
   place q; the name is kept for the call signature.) */
lemmaA(F, d, l, prec, EMAX, MMAX) = {
  my(ff, e = valuation(d, l), n = 0, bad = 0, s, xx);
  ff = x^3 + F[1]*d*x^2 + F[2]*d^2*x + F[3]*d^3;
  for(k = -EMAX, EMAX,
    if(k == e, next);
    for(m = 1, MMAX,
      if(m % l == 0, next);
      for(sg = 0, 1,
        xx = (-1)^sg * l^k * m;
        s = subst(ff, x, xx);
        if(s == 0 || !issquare(s + O(l^prec)), next);
        n++;
        if(!issquare(xx + O(l^prec)), bad++))));
  [n, bad];
}

/* Lemma B, tested: #c(E_d(Q_q)) over every bad odd place q of every
   twist in one square class. */
cyctest(F, dref, MMAX, prec) = {
  my(d, fa, im, n = 0, big = 0, sizes = Map(), t = getwalltime(), k);
  for(m = 1, MMAX,
    if(!issquarefree(m) || m % 2 == 0, next);
    for(sg = 0, 1,
      d = (-1)^sg * abs(dref) * m;
      if(sqclass2(d) != sqclass2(dref), next);
      fa = factor(abs(d))[,1]~;
      for(i = 1, #fa,
        if(fa[i] == 2, next);
        im = cimagep(F, d, fa[i], prec, 4, 40);
        n++;
        k = Str(#im);
        mapput(sizes, k, if(mapisdefined(sizes,k), mapget(sizes,k), 0) + 1);
        if(#im > 2, big++))));
  print("  ", n, " bad odd places, sizes of c(E_d(Q_l)): ", Mat(sizes),
        "   with more than 2 elements: ", big, "   time=", getwalltime()-t);
}

/* =====================================================================
   The elementary form of the argument.  Nothing below mentions Galois
   cohomology: c is the classical square-class-of-x map, the pairing is
   the Hilbert symbol, and the only imported theorem is Hilbert
   reciprocity (equivalently quadratic reciprocity).
   ===================================================================== */

/* c is a homomorphism: if P + Q + R = O then x(P)x(Q)x(R) is a square,
   because the three x-coordinates are the roots of
   x^3 - lam^2 x^2 + (b - 2 lam nu) x - nu^2 for the line y = lam x + nu. */
homtest(F, d, NP) = {
  my(E = Ecurve(F, d), Em, v = 0, td, pts, P, Q, n = 0, bad = 0, S);
  td = twistdata3(F, d);
  if(#td[2] == 0, return([0,0]));
  Em = ellminimalmodel(E, &v);
  pts = vector(#td[2], i, ellchangepointinv(td[2][i], v));
  for(i = 1, NP,
    for(j = 1, NP,
      P = ellmul(E, pts[1], i);
      Q = if(#pts > 1, ellmul(E, pts[2], j), ellmul(E, pts[1], j+NP));
      if(P == [0] || Q == [0], next);
      S = elladd(E, P, Q);
      n++;
      if(!issquare(cmap(F,d,P) * cmap(F,d,Q) * cmap(F,d,S)), bad++)));
  [n, bad];
}

/* the image of c on E_d(Q_2), tabulated against d = 2^e * m mod 8 --
   the mod-8 computation of the elementary proof. */
img2table(F, MMAX) = {
  my(T = Map(), key, im, d);
  for(m = 1, MMAX,
    if(!issquarefree(m) || m % 2 == 0, next);
    for(e = 0, 1,
      for(sg = 0, 1,
        d = (-1)^sg * 2^e * m;
        if(!issquarefree(d), next);
        im = cimagep(F, d, 2, 40, 8, 60);
        key = Str("v2=", e, " m mod 8 = ", ((-1)^sg*m) % 8, " -> ",
                  vector(#im, i, clsrep(im[i],2)));
        mapput(T, key, if(mapisdefined(T,key), mapget(T,key), 0) + 1))));
  Mat(T);
}
