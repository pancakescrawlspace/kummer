\\ critical-orbit-stability.gp -- checks for critical-orbit-stability.typ
\\
\\ Run from this directory:
\\     gp -q -s 4000000000 critical-orbit-stability.gp < /dev/null > results/critical-orbit-stability.txt
\\
\\ g = X^2 - X + 1, gamma = 1/2 its critical point, c_n = g^{o n}(gamma) the
\\ critical orbit.  The claim being checked is that irreducibility of every
\\ iterate g^{o n} over F_q is decided, once and for all, by the single sequence
\\ c_1, c_2, c_3, ... : the tower of quadratic steps K_1 c K_2 c ... has an
\\ obstruction group F^*/(F^*)^2 = Z/2 on every floor, the norm identifies all
\\ those floors with the ground floor, and the map it induces on obstruction
\\ classes is g itself.  So an infinite tower of conditions collapses onto the
\\ forward orbit of one point, which is eventually periodic; the check is finite.
\\
\\ Everything is verified twice where possible: the criterion against brute-force
\\ factorisation, and the norms both one step at a time and telescoped.

ERRS = 0;
{note(ok, msg) = if (!ok, ERRS++; printf("      *** FAILED: %s\n", msg));}

\\ ---------------------------------------------------------------- scaffolding

g(X) = X^2 - X + 1;

\\ n-th iterate of a quadratic q (given as a closure) started from X.
{iter(q, n) = my(P = 'X); for (i = 1, n, P = subst(q('X), 'X, P)); P;}

\\ Critical point of a monic quadratic X^2 + aX + b is -a/2; here gamma = 1/2.
{critorbit(q, gam, N) = my(v = vector(N), x = gam);
  for (j = 1, N, x = q(x); v[j] = x); v;}

\\ The adjusted critical orbit relative to a basepoint b:  D_1 = b - c_1,
\\ D_j = c_j - b for j >= 2.  The sign on the first term is the only place the
\\ odd number of conjugates at the bottom floor is felt.
{adjorbit(c, b) = my(D = vector(#c)); D[1] = b - c[1];
  for (j = 2, #c, D[j] = c[j] - b); D;}

{issq(x, p) = kronecker(lift(x), p) >= 0;}
{isnonsq(x, p) = kronecker(lift(x), p) == -1;}

\\ ---------------------------------------------------------------------- (1)
\\ The tower, floor by floor, made explicit over F_5.  K_{i} = F_5(alpha_i) with
\\ g(alpha_i) = alpha_{i-1} and alpha_1 = 0.  Lemma 1 says the step is quadratic
\\ exactly when alpha_i - beta is a non-square, beta = g(gamma) = 3/4 = 2 the
\\ critical VALUE -- because g(Y) - alpha = (Y - gamma)^2 - (alpha - beta).
\\ Checked against honest irreducibility of g(Y) - alpha_i over K_i.

check1(p, N) =
{ my(gam = Mod(1,p)/2, bet = g(gam), c = critorbit(x -> g(x), gam, N+1));
  printf("  (1) the tower over F_%d, floor by floor\n", p);
  printf("      critical point gamma = %s, critical value beta = g(gamma) = %s\n",
         lift(gam), lift(bet));
  printf("      K_i = F_5(alpha_i), g(alpha_i) = alpha_{i-1}, alpha_1 = 0\n");
  printf("      %-4s %-10s %-16s %-16s %-14s %s\n",
         "i", "[K_i:F_5]", "N(alpha_i-beta)", "predicted", "square?", "step K_i -> K_{i+1}");
  for (i = 1, N,
    my(P, d, al, u, sq, irr, nrm, want);
    if (i == 1,
      P = 'X*Mod(1,p); d = 1; al = Mod(0,p),
      P = iter(x -> g(x), i-1)*Mod(1,p); d = poldegree(P);
      note(polisirreducible(P), Str("g^{o ", i-1, "} reducible mod ", p, " -- tower broken"));
      al = ffgen(P, 'a));
    u = al - bet;
    nrm = if (i == 1, u, u^((p^d - 1)/(p - 1)));
    \\ N(alpha_i - beta) = (-1)^d g^{o(i-1)}(beta) = (-1)^d c_i
    want = (-1)^d * c[i];
    note(nrm == want + 0*nrm, Str("norm of alpha_i - beta is not (-1)^d c_i at i = ", i));
    sq = (u == 0) || if (i == 1, issq(u, p), u^((p^d - 1)/2) == 1);
    irr = if (i == 1, polisirreducible(g('Y)*Mod(1,p)), polisirreducible(g('Y) - al));
    note(irr == !sq, Str("Lemma 1 fails at i = ", i));
    note(isnonsq(want, p) == irr, Str("criterion disagrees with irreducibility at i = ", i));
    printf("      %-4d %-10d %-16s %-16s %-14s %s\n", i, d,
           Str(lift(if (i == 1, nrm, nrm + 0*Mod(1,p)))),
           Str(if (d % 2 == 1, "-c_", "c_"), i, " = ", lift(want)),
           if (sq, "yes", "NO"), if (irr, "degree 2", "SPLITS")));
  printf("      critical orbit c_1..c_%d mod %d: %s\n", N+1, p, Str(lift(c)));
  printf("      squares mod %d: %s -- the orbit lands in the complement\n", p,
         Str(Vec(Set(vector(p, i, ((i-1)^2) % p)))));
};

\\ ---------------------------------------------------------------------- (2)
\\ Lemma 2, the mechanism.  As polynomials in C:
\\        g(C) - g(Y) = (C - Y)(C - (1 - Y)),
\\ and 1 - Y is the conjugate of Y over F(g(Y)).  Hence for any c in the base,
\\        N_{K_i / K_{i-1}}(c - alpha_i) = g(c) - alpha_{i-1} :
\\ one norm step moves the base point one step ALONG THE CRITICAL ORBIT and drops
\\ one floor.  That single identity is the whole "travels upward" phenomenon.
\\ Telescoping gives N_{K_i/F_p}(c - alpha_i) = g^{o (i-1)}(c), so at c = c_1 the
\\ answer is c_i.  Checked one step at a time AND telescoped, at three base
\\ points each.

check2(p, N) =
{ my(gam = Mod(1,p)/2, c = critorbit(x -> g(x), gam, N+2), sym, steps = 0);
  printf("  (2) the norm identity, one step at a time and telescoped\n");
  sym = g('C) - g('Y) - ('C - 'Y)*('C - (1 - 'Y));
  note(sym == 0, "g(C) - g(Y) != (C-Y)(C-(1-Y)) as polynomials");
  printf("      symbolic identity g(C) - g(Y) - (C-Y)(C-(1-Y)) = %s\n", sym);
  printf("      %-4s %-10s %-28s %-28s %s\n",
         "i", "[K_i:F_5]", "one step at c = c_1,c_2,c_3", "telescoped N(c_1-alpha_i)", "= c_i");
  for (i = 2, N,
    my(P = iter(x -> g(x), i-1)*Mod(1,p), d, al, alprev, cc, lhs, rhs, nrm, tel, allok = 1);
    d = poldegree(P); al = ffgen(P, 'a); alprev = g(al);
    for (k = 1, 3,
      cc = c[k] + 0*al;
      lhs = (cc - al) * (cc - (1 - al));            \\ N_{K_i/K_{i-1}}(c - alpha_i)
      rhs = g(c[k]) - alprev;
      if (lhs != rhs, allok = 0);
      note(lhs == rhs, Str("one-step norm fails at i = ", i, ", c = c_", k));
      nrm = (cc - al)^((p^d - 1)/(p - 1));          \\ N_{K_i/F_p}(c - alpha_i)
      tel = subst(iter(x -> g(x), i-1), 'X, c[k]);  \\ g^{o (i-1)}(c) = c_{k+i-1}
      if (nrm != tel + 0*nrm, allok = 0);
      note(nrm == tel + 0*nrm, Str("telescoped norm fails at i = ", i, ", c = c_", k));
      note(tel == c[k + i - 1], Str("g^{o(i-1)}(c_k) != c_{k+i-1} at i = ", i));
      steps++);
    nrm = (c[1] + 0*al - al)^((p^d - 1)/(p - 1));
    printf("      %-4d %-10d %-28s %-28s %s\n", i, d,
           if (allok, "all three agree", "*** MISMATCH"),
           Str(lift(nrm + 0*Mod(1,p))), Str("c_", i, " = ", lift(c[i]))));
  printf("      %d (floor, base point) pairs, each verified twice\n", steps);
};

\\ ---------------------------------------------------------------------- (3)
\\ Lemma 3.  Over a FINITE field the norm detects squares in every degree, not
\\ just in degree 2:  N(x)^((q-1)/2) = x^((q^d-1)/2), so x is a square in F_{q^d}
\\ iff N(x) is a square in F_q.  Equivalently F^*/(F^*)^2 = Z/2 on every floor
\\ and the norm is an isomorphism between consecutive floors.  Exhaustive.

check3(qs, ds) =
{ printf("  (3) over finite fields the norm detects squares in EVERY degree\n");
  printf("      %-8s %-4s %-10s %-12s %s\n", "q", "d", "#F_{q^d}^*", "mismatches", "|F^*/(F^*)^2|");
  foreach (qs, q,
    foreach (ds, d,
      my(t = ffgen(ffinit(q, d), 'w), bad = 0, cnt = 0, x, n, s1, s2);
      x = t^0;
      for (e = 1, q^d - 1,
        x = t^e; cnt++;
        n = x^((q^d - 1)/(q - 1));
        s1 = (x^((q^d - 1)/2) == 1);
        s2 = (n^((q - 1)/2) == 1);
        if (s1 != s2, bad++));
      printf("      %-8d %-4d %-10d %-12d %d\n", q, d, cnt, bad, 2);
      note(bad == 0, Str("norm fails to detect squares for q = ", q, ", d = ", d))));
};

\\ ---------------------------------------------------------------------- (4)
\\ The criterion against brute force, for MANY primes and for quadratics other
\\ than g -- it is a theorem about quadratics, not a coincidence about this one.
\\ Criterion: g^{o n} (basepoint b = 0) is irreducible for all n <= N iff
\\ D_1, ..., D_N are all non-squares in F_p.

check4(pmax, N) =
{ my(tot = 0, bad = 0, shown = 0);
  printf("  (4) criterion vs. brute-force factorisation, g = X^2-X+1, basepoint 0\n");
  printf("      %-6s %-22s %-22s %s\n", "p", "irreducible? n=1..N", "predicted", "adjusted orbit");
  forprime (p = 3, pmax,
    my(gam = Mod(1,p)/2, c = critorbit(x -> g(x), gam, N), D = adjorbit(c, Mod(0,p)),
       P = Mod(1,p)*'X, brute = vector(N), pred = vector(N), ok = 1);
    for (n = 1, N,
      P = subst(g('X), 'X, P);
      brute[n] = polisirreducible(P);
      pred[n] = 1; for (j = 1, n, if (!isnonsq(D[j], p), pred[n] = 0)));
    tot++;
    if (brute != pred, bad++; ok = 0);
    if (!ok || shown < 10,
      shown++;
      printf("      %-6d %-22s %-22s %s%s\n", p, Str(brute), Str(pred), Str(lift(D)),
             if (ok, "", "   *** MISMATCH")));
    note(brute == pred, Str("criterion wrong at p = ", p)));
  printf("      %d primes tested, %d mismatches\n", tot, bad);
};

check4random(pmax, N, trials) =
{ my(tot = 0, bad = 0);
  printf("      random monic quadratics q = X^2 + aX + b, basepoint b0, same criterion:\n");
  forprime (p = 3, pmax,
    for (t = 1, trials,
      my(a = random(p), bq = random(p), b0 = random(p), q, gam, c, D, P, brute, pred);
      q = (X -> X^2 + a*X + bq);
      gam = -Mod(a,p)/2;
      c = critorbit(q, gam, N);
      D = adjorbit(c, Mod(b0,p));
      P = Mod(1,p)*'X; brute = vector(N); pred = vector(N);
      for (n = 1, N,
        P = subst(q('X), 'X, P);
        brute[n] = polisirreducible(P - b0);
        pred[n] = 1; for (j = 1, n, if (!isnonsq(D[j], p), pred[n] = 0)));
      tot++;
      if (brute != pred, bad++;
        printf("      *** MISMATCH p=%d q=%s b0=%d brute=%s pred=%s\n",
               p, Str(q('X)), b0, Str(brute), Str(pred)));
      note(brute == pred, Str("criterion wrong for random quadratic at p = ", p))));
  printf("      %d random (p, quadratic, basepoint) triples tested, %d mismatches\n", tot, bad);
};

\\ ---------------------------------------------------------------------- (5)
\\ WHY the critical orbit and not some other sequence: because it IS the sequence
\\ of discriminants, modulo squares.  (g^{o n})' = prod_{j<n} g'(g^{o j}) and
\\ g' = 2(X - gamma), so every factor with j >= 1 enters to an even power and
\\        disc(g^{o n}) = D_n  mod squares.
\\ Ramification of the covering g^{o n} : P^1 -> P^1 lies over the post-critical
\\ set; this is that statement, counted.

check5(pmax, N) =
{ my(tot = 0, bad = 0, shown = 0);
  printf("  (5) disc(g^{o n}) = D_n modulo squares\n");
  printf("      %-6s %-6s %-14s %-14s %s\n", "p", "n", "chi(disc)", "chi(D_n)", "");
  forprime (p = 3, pmax,
    my(gam = Mod(1,p)/2, c = critorbit(x -> g(x), gam, N), D = adjorbit(c, Mod(0,p)),
       P = Mod(1,p)*'X, dd, k1, k2);
    for (n = 1, N,
      P = subst(g('X), 'X, P);
      dd = poldisc(P);
      if (dd == 0 || D[n] == 0, next);
      tot++;
      k1 = kronecker(lift(dd), p); k2 = kronecker(lift(D[n]), p);
      if (k1 != k2, bad++);
      if (p <= 13 && n <= 4 || k1 != k2,
        shown++;
        printf("      %-6d %-6d %-14d %-14d %s\n", p, n, k1, k2,
               if (k1 == k2, "", "*** MISMATCH")));
      note(k1 == k2, Str("disc != D_n mod squares at p = ", p, ", n = ", n))));
  printf("      %d (p,n) pairs tested, %d mismatches\n", tot, bad);
};

\\ ---------------------------------------------------------------------- (6)
\\ How special the prime 5 is.  The critical orbit mod p is eventually periodic,
\\ so the test is finite for every p; it PASSES only when the whole tail-and-
\\ cycle avoids the squares, which for a set of size ~sqrt(p) costs about
\\ 2^{-sqrt(p)}.  Scan and see.

check6(pmax) =
{ my(good = List(), tot = 0);
  printf("  (6) for which p does the test prove that ALL iterates are irreducible?\n");
  forprime (p = 3, pmax,
    my(gam = Mod(1,p)/2, x = gam, seen = vector(p), orb = List(), pos = 0, ok, tail);
    \\ walk the forward orbit of gamma until it repeats
    while (1,
      x = g(x);
      if (seen[lift(x) + 1], break);
      seen[lift(x) + 1] = 1; listput(orb, x));
    orb = Vec(orb);
    tot++;
    \\ need: -c_1 a non-square, and c_j a non-square for every j >= 2, i.e. for
    \\ every value the orbit takes from the second step on
    ok = isnonsq(-orb[1], p);
    for (j = 2, #orb, if (!isnonsq(orb[j], p), ok = 0));
    \\ if c_1 recurs inside the cycle it is also some c_j with j >= 2
    if (ok, listput(good, [p, #orb, lift(orb)])));
  printf("      %d primes below %d tested; the test succeeds for:\n", tot, pmax);
  foreach (Vec(good), G,
    printf("        p = %-6d orbit length %-4d %s\n", G[1], G[2], Str(G[3])));
  note(#good == 1 && Vec(good)[1][1] == 5, "p = 5 is not the unique success");
  printf("      exactly %d prime, p = 5, whose critical orbit {2,3} IS the set of\n", #good);
  printf("      non-squares mod 5 -- the shortest possible orbit, landing on the nose\n");
};

\\ ---------------------------------------------------------------------- (7)
\\ What the two families delta_i, delta'_i of the posted answer were.  There
\\ delta_i = 2 + 4 alpha_i and delta'_i = 3 + 4 alpha_i.  In F_5, 4 = 2^2 is a
\\ square and 2 = c_1, 3 = c_2, so up to squares
\\        delta_i = alpha_i - c_1,      delta'_i = alpha_i - c_2 :
\\ ONE family, indexed by the two points of the critical cycle.  The alternation
\\ delta -> delta' -> delta is the cycle turning under g.  The answer's two-step
\\ norm is Lemma 2 applied twice.

check7(p, N) =
{ my(gam = Mod(1,p)/2, c = critorbit(x -> g(x), gam, N+2));
  printf("  (7) delta_i and delta'_i are one family indexed by the critical cycle\n");
  printf("      %-4s %-16s %-22s %-16s %s\n",
         "i", "delta_i", "= 4(alpha_i - c_1)?", "delta'_i", "= 4(alpha_i - c_2)?");
  for (i = 2, N,
    my(P = iter(x -> g(x), i-1)*Mod(1,p), d, t, al, del, delp, e1, e2, nd);
    d = poldegree(P); t = ffgen(P, 'a); al = t;
    del  = 2 + 4*al;
    delp = 3 + 4*al;
    e1 = (del  == 4*(al - (c[1] + 0*al)));
    e2 = (delp == 4*(al - (c[2] + 0*al)));
    note(e1 && e2, Str("delta / delta' identification fails at i = ", i));
    \\ the answer's step: N_{K_i/K_{i-1}}(delta_i) = delta'_{i-1} up to squares
    nd = del * (2 + 4*(1 - al));
    note(nd == 3 + 4*g(al) || nd == -(3 + 4*g(al)),
         Str("N(delta_i) is not +- delta'_{i-1} at i = ", i));
    printf("      %-4d %-16s %-22s %-16s %s\n", i, "2 + 4 alpha_i",
           if (e1, "yes", "NO"), "3 + 4 alpha_i", if (e2, "yes", "NO")));
  printf("      and N_{K_i/K_{i-1}}(delta_i) = +- delta'_{i-1}: two floors per norm,\n");
  printf("      which is Lemma 2 applied twice with c_1 -> c_2 -> c_3 = c_1\n");
};

\\ ---------------------------------------------------------------------- (8)
\\ The conclusion, on the original polynomials.  f_1 = X, f_2 = X+1,
\\ f_n = f_{n-1}^2 - f_{n-1} + 1, so f_n = g^{o (n-2)}(X + 1) and deg f_n = 2^{n-2}.
\\ Irreducible mod 5 => irreducible over Q (monic).  The question's own Sage run
\\ reached f_15; the criterion covers every n at once.

check8(nmax) =
{ my(f = 'X, fs = vector(nmax));
  printf("  (8) the original polynomials\n");
  fs[1] = 'X; fs[2] = 'X + 1;
  for (n = 3, nmax, fs[n] = fs[n-1]^2 - fs[n-1] + 1);
  \\ product form: f_{n+1} = 1 + prod_{i<=n} f_i
  for (n = 2, min(nmax, 12) - 1,
    my(pr = 1); for (i = 1, n, pr *= fs[i]);
    note(fs[n+1] == 1 + pr, Str("f_", n+1, " != 1 + prod f_i")));
  printf("      the two recursions agree: f_{n+1} = 1 + prod_{i<=n} f_i  (n <= %d)\n",
         min(nmax,12) - 1);
  printf("      %-5s %-8s %-24s %-16s %s\n", "n", "deg", "f_n = g^{o(n-2)}(X+1)?",
         "irred mod 5", "irred over Q");
  for (n = 2, nmax,
    my(d = poldegree(fs[n]), gi = subst(iter(x -> g(x), n-2), 'X, 'X + 1), i5, iq);
    note(fs[n] == gi, Str("f_", n, " != g^{o(n-2)}(X+1)"));
    i5 = polisirreducible(fs[n]*Mod(1,5));
    iq = if (d <= 512, polisirreducible(fs[n]), -1);
    note(i5, Str("f_", n, " reducible mod 5"));
    if (iq >= 0, note(iq == 1, Str("f_", n, " reducible over Q")));
    printf("      %-5d %-8d %-24s %-16s %s\n", n, d, "yes", "yes",
           if (iq < 0, "(implied by mod 5)", "yes")));
};

\\ ---------------------------------------------------------------------- (9)
\\ The same criterion in characteristic zero, where it is only a SUFFICIENT
\\ condition (the norm still sends non-squares downstairs, but Q^*/(Q^*)^2 is
\\ infinite, so nothing comes back up).  Stoll's test for X^2 + c over Q:
\\ -c and (X^2+c)^{o n}(0) for n >= 2 all non-squares => every iterate irreducible.

check9(cmax, N) =
{ my(tot = 0, bad = 0);
  printf("  (9) the char-0 form (Stoll) for X^2 + c over Q: sufficient, not necessary\n");
  printf("      %-6s %-30s %-14s %s\n", "c", "adjusted orbit -c, f^n(0)", "test passes", "all iterates irred");
  for (c = -12, cmax,
    my(q = (X -> X^2 + c), o = critorbit(q, 0, N), D, pass, P, allirr = 1);
    D = vector(N); D[1] = -o[1]; for (j = 2, N, D[j] = o[j]);
    pass = 1; for (j = 1, N, if (issquare(D[j]), pass = 0));
    P = 'X; for (n = 1, N, P = subst(q('X), 'X, P); if (!polisirreducible(P), allirr = 0));
    tot++;
    if (pass && !allirr, bad++);
    note(!(pass && !allirr), Str("Stoll's test passed but an iterate is reducible at c = ", c));
    if (c >= -3 && c <= 8,
      printf("      %-6d %-30s %-14s %s\n", c, Str(D), if (pass, "yes", "no"),
             if (allirr, "yes", "no"))));
  printf("      %d values of c; %d cases where the test passed and an iterate was reducible\n",
         tot, bad);
  printf("      (c = 1 is the classical one: -1, 2, 5, 26, 677, ... never squares)\n");
};

print("======================================================================");
print("critical-orbit-stability.gp -- iterates of a quadratic and its critical orbit");
{driver() =
  print("");
  check1(5, 9); print("");
  check2(5, 8); print("");
  check3([3, 5, 7], [1, 2, 3, 4]); print("");
  check4(200, 5); check4random(60, 4, 6); print("");
  check5(200, 5); print("");
  check6(20000); print("");
  check7(5, 8); print("");
  check8(15); print("");
  check9(30, 6); print("");
  printf("  %d failed assertions in total\n", ERRS);
  print("======================================================================");}
if (type(NORUN) != "t_INT", driver());
