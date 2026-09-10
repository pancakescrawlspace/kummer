read("kummer2.gp");

/* =====================================================================
   Search strategy.

   A twist E_d has an affine rational point iff d is the squarefree part
   of f(t_0) for some t_0 in Q, and then (t_0, 1) IS such a point.  So a
   sweep over t_0, bucketed by squarefree part, hands out one generator
   per twist essentially for free (~0.007 ms/twist), whereas a per-twist
   2-descent costs ~2.3 ms/twist -- some 300x more.

   The catch: the sweep almost never gives TWO independent points on the
   same twist.  That needs a collision of squarefree parts, and |a|,b <= H
   yields ~H^2 values of f(t_0) spread over a range ~H^4, so collisions
   stay negligible (a 92000-point sweep produced 54).  Rank 1 is not
   enough exactly when E_delta(Qp)/E_1 fails to be cyclic.

   Key point: that condition depends only on (p, delta), not on which
   twist in the class you pick, because all d in one class give
   Qp-isomorphic curves.  So one cheap local test per (p, delta) -- four
   per prime, no point search -- decides which path to take:

     procyclic      -> settle it from the sweep, no descent at all
     not procyclic  -> rank >= 2 is mandatory, run ellrank on twists in
                       that class only (already a 4x saving)

   For f = x^3+x+1 and odd p < 200 this puts 158 of 180 (p,delta) pairs
   on the cheap path; for the CM curve f = x^3-2 the expensive pairs are
   exactly p = 3 and p = 1 mod 3, which is precisely why a rank-1-only
   search appears to "fail for p = 1 mod 3" -- a blind spot of the
   method, not a fact about the surface.
   ===================================================================== */

/* ---------- stage 1: the cheap t_0 sweep ---------------------------- */

/* q rational nonzero -> [d,c] with q = d*c^2, d squarefree */
sqfreepart(q) = {
  my(n = numerator(q), m = denominator(q), N = n*m, fa, d = 1, c = 1/m);
  fa = factor(N);
  for(i = 1, #fa~,
    my(pp = fa[i,1], e = fa[i,2]);
    if(e % 2, d *= pp);
    c *= pp^(e \ 2)
  );
  [d, c];
}

/* bucket t_0 = a/b (|a| <= HN, b <= HD) by the squarefree part of f(t_0).
   Returns [Map: d -> vector of t_0, keys sorted by |d|]. */
sweep(A, B, HN, HD) = {
  my(M = Map(), a, b, t0, q, d, keys);
  for(b = 1, HD,
    for(a = -HN, HN,
      if(gcd(a,b) != 1, next);
      t0 = a/b; q = t0^3 + A*t0 + B;
      if(q == 0, next);
      d = sqfreepart(q)[1];
      if(mapisdefined(M,d), mapput(M, d, concat(mapget(M,d), [t0])),
                            mapput(M, d, [t0]))
    )
  );
  keys = Mat(M)[,1];
  keys = vecsort(keys, x -> abs(x));
  [M, keys];
}

/* minimal model of E_d together with the points coming from the swept t_0 */
sweptdata(A, B, d, t0s) = {
  my(Ec, v = 0, Em, pts = List(), t0, c);
  Ec = ellinit([A*d^2, B*d^3]);
  Em = ellminimalmodel(Ec, &v);
  for(i = 1, #t0s,
    t0 = t0s[i];
    c = sqfreepart(t0^3 + A*t0 + B)[2];
    listput(pts, ellchangepoint([d*t0, d^2*c], v))
  );
  [Em, Vec(pts)];
}

/* ---------- stage 2: local triage, no point search ------------------ */

/* smallest squarefree representative of a square class */
classrep(A, B, p, target, DMAX) = {
  my(d, n, sg);
  for(n = 1, DMAX,
    if(!issquarefree(n), next);
    for(sg = 0, 1,
      d = if(sg == 0, n, -n);
      if(sqclass(d,p) == target, return(d))
    )
  );
  0;
}

/* Is E_delta(Qp)/E_1 cyclic?  Depends only on (p,target).
   Conservative at additive primes: may return 0 for a cyclic group,
   never 1 for a non-cyclic one, so the "cheap" set is never overstated. */
procyclic(A, B, p, target) = {
  my(d = classrep(A,B,p,target,4000), Ec, v = 0, Em, lr, ns, c);
  if(d == 0, return(0));
  Ec = ellinit([A*d^2, B*d^3]);
  Em = ellminimalmodel(Ec, &v);
  lr = elllocalred(Em, p);
  if(lr[2] == 1, return(#ellgroup(Em,p) == 1));   /* good: G_1 = Etilde(Fp) */
  ns = p - ellap(Em, p); c = lr[4];               /* bad: |G_1| = c_p * ns  */
  gcd(c, ns) == 1 && c <= 3;
}

/* ---------- stage 3: the hybrid search ------------------------------ */

/* SW = output of sweep().  For each odd p <= PMAX and each square class,
   find a witness d, taking the cheap or the expensive path as triaged.
   TRIES caps densegroup calls per (p,class) on the sweep path;
   DMAX caps |d| on the descent path. */
hybrid(A, B, SW, PMAX, TRIES, DMAX) = {
  my(M = SW[1], keys = SW[2], prs = primes([3,PMAX]), good = List(),
     p, k, w, path, nf, i, j, n, sg, d, td, tried, ncheap = 0, ndesc = 0, hit);
  print("f(x) = x^3 + (", A, ")x + (", B, ")     [hybrid search]");
  for(j = 1, #prs,
    p = prs[j];
    w = vector(4, i, 0); path = vector(4, i, "");
    for(k = 0, 3,
      hit = 0;
      if(procyclic(A, B, p, k),
        /* --- cheap path: witnesses straight from the sweep --- */
        ncheap++;
        tried = 0;
        for(i = 1, #keys,
          d = keys[i];
          if(sqclass(d,p) != k, next);
          tried++; if(tried > TRIES, break());
          td = sweptdata(A, B, d, mapget(M,d));
          if(densegroup(td[1], td[2], p),
             w[k+1] = d; path[k+1] = "sweep"; hit = 1; break())
        )
      );
      if(!hit,
        /* --- descent path: only twists in this class --- */
        ndesc++;
        for(n = 1, DMAX,
          if(!issquarefree(n), next);
          for(sg = 0, 1,
            d = if(sg == 0, n, -n);
            if(sqclass(d,p) != k, next);
            td = twistdata(A, B, d);
            if(#td[2] == 0, next);
            if(densegroup(td[1], td[2], p),
               w[k+1] = d; path[k+1] = "descent"; hit = 1; break(2))
          )
        )
      )
    );
    nf = 0; for(k = 1, 4, if(w[k] != 0, nf++));
    if(nf == 4,
      listput(good, p);
      print("  p=", p, "  OK   ",
            strjoin(vector(4, k, Str("[", sqclassname(k-1,p), "]=", w[k],
                                     "(", path[k], ")")), " "))
    ,
      print("  p=", p, "  ", nf, "/4   ", w)
    )
  );
  print("GOOD PRIMES: ", Vec(good));
  print("count = ", #good, " out of ", #prs);
  print("(p,class) pairs: ", ncheap, " cheap-path attempts, ", ndesc, " fell through to descent");
  Vec(good);
}

/* ---------- legacy / targeted helpers ------------------------------- */

/* pure per-twist descent over all squarefree |d| <= D (slow reference path) */
build(A, B, D) = {
  my(L = List(), d, td);
  for(n = 1, D,
    if(!issquarefree(n), next);
    for(sg = 0, 1,
      d = if(sg == 0, n, -n);
      td = twistdata(A, B, d);
      listput(L, [d, td[1], td[2], td[3], td[4]])
    )
  );
  Vec(L);
}

report(A, B, data, PMAX) = {
  my(prs = primes([3,PMAX]), good = List(), p, w, k, nf, i, j);
  print("f(x) = x^3 + (", A, ")x + (", B, ")");
  for(j = 1, #prs,
    p = prs[j];
    w = vector(4, i, 0);
    for(i = 1, #data,
      k = sqclass(data[i][1], p);
      if(w[k+1] != 0, next);
      if(densegroup(data[i][2], data[i][3], p), w[k+1] = data[i][1])
    );
    nf = 0; for(k = 1, 4, if(w[k] != 0, nf++));
    if(nf == 4,
      listput(good, p);
      print("  p=", p, "  OK   d: [1]=", w[1], "  [u]=", w[2],
            "  [", p, "]=", w[3], "  [u", p, "]=", w[4])
    ,
      print("  p=", p, "  ", nf, "/4   ", w)
    )
  );
  print("GOOD PRIMES: ", Vec(good));
  print("count = ", #good, " out of ", #prs);
  Vec(good);
}

/* targeted search in one square class, for the stubborn cases
   (f=x^3+x+1 at p=131,149; f=x^3-2 at p=3).  target = 0,1,2,3. */
hunt(A, B, p, target, DMAX) = {
  my(d, td, n, sg);
  for(n = 1, DMAX,
    if(!issquarefree(n), next);
    for(sg = 0, 1,
      d = if(sg == 0, n, -n);
      if(sqclass(d, p) != target, next);
      td = twistdata(A, B, d);
      if(#td[2] == 0, next);
      if(densegroup(td[1], td[2], p),
        print("  p=", p, " class ", sqclassname(target,p), ": d=", d,
              "  rank in [", td[3], ",", td[4], "]  gens=", td[2]);
        return(d))
    )
  );
  print("  p=", p, " class ", sqclassname(target,p), ": NOT FOUND up to |d|=", DMAX);
  0;
}
