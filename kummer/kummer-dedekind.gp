\\ kummer-dedekind.gp -- checks for kummer-dedekind.typ
\\
\\ Run from this directory:
\\     gp -q -s 4000000000 kummer-dedekind.gp < /dev/null \
\\         > results/kummer-dedekind.txt
\\
\\ The Kummer-Dedekind theorem: for K = Q(theta) with theta an algebraic
\\ integer of minimal polynomial f, and for a prime p NOT dividing the index
\\ [O_K : Z[theta]], the factorisation of f mod p into irreducibles
\\
\\        f = prod g_i^e_i   (mod p)
\\
\\ reads off the factorisation of p in O_K: the primes above p are
\\ P_i = (p, g_i(theta)), with e(P_i/p) = e_i and f(P_i/p) = deg g_i.
\\
\\ These checks confirm the theorem where it applies, exhibit its failure at
\\ an index-dividing prime (Dedekind's own example), verify Dedekind's
\\ criterion for the hypothesis, and show that at p = 2 in that example NO
\\ generator can work -- 2 is a common index divisor.

default(realprecision, 20);

PMAX = 500;

FLDS = [x^2 + 1, x^2 - 5, x^2 + 5, x^2 - 12, x^3 - 2, x^3 - x - 1, x^3 - x^2 - 2*x - 8, x^4 - 2, x^4 + 1, x^4 - x - 1, x^5 - x - 1];

\\ the multiset {[e_i, deg g_i]} predicted by Kummer-Dedekind from f mod p
kdpred(f, p) =
{ my(F = factormod(f, p), v = List());
  for (j = 1, matsize(F)[1], listput(v, [F[j,2], poldegree(lift(F[j,1]))]));
  vecsort(Vec(v));
};

\\ the truth, from the ring of integers
truth(nf, p) = vecsort([[P.e, P.f] | P <- idealprimedec(nf, p)]);

\\ ---------------------------------------------------------------- check 1
\\ The theorem, wherever its hypothesis holds.  Every prime below PMAX with
\\ p not dividing the index, over eleven fields of degree 2 to 5.

check1() =
{ my(bad = 0, tot = 0, skip = 0);
  printf("  (1) Kummer-Dedekind against idealprimedec, all p < %d with p not dividing the index\n", PMAX);
  printf("      %-22s %-7s %-9s %-9s %s\n", "f", "index", "p tested", "p skipped", "mismatches");
  for (i = 1, #FLDS,
    my(f = FLDS[i], nf = nfinit(f), n = 0, sk = 0, b = 0, p = 2);
    while (p < PMAX,
      if (nf.index % p == 0, sk++,
        n++; if (kdpred(f, p) != truth(nf, p), b++));
      p = nextprime(p+1));
    bad += b; tot += n; skip += sk;
    printf("      %-22s %-7d %-9d %-9d %d\n", f, nf.index, n, sk, b));
  printf("      total: %d prime-field pairs tested, %d skipped, %d mismatches\n", tot, skip, bad);
};

\\ ---------------------------------------------------------------- check 2
\\ The hypothesis is not decorative.  Dedekind's example
\\ f = x^3 - x^2 - 2x - 8 has disc(f) = -2012 = 2^2 . (-503) and index 2, and
\\ at p = 2 the theorem's conclusion is simply false.

check2() =
{ my(f = x^3 - x^2 - 2*x - 8, nf = nfinit(f), F = factormod(f, 2), s = "");
  printf("  (2) failure at an index-dividing prime: Dedekind's example\n");
  printf("      f = %s,  disc(f) = %d,  disc(K) = %d,  index = %d\n",
         f, poldisc(f), nf.disc, nf.index);
  for (j = 1, matsize(F)[1], s = Str(s, if (j>1, " * ", ""), "(", lift(F[j,1]), ")^", F[j,2]));
  printf("      f mod 2 = %s\n", s);
  printf("      Kummer-Dedekind would predict [e,f] = %s\n", Str(kdpred(f, 2)));
  printf("      the truth is                   [e,f] = %s\n", Str(truth(nf, 2)));
  printf("      they differ: %d  (2 splits completely; the polynomial says it ramifies)\n",
         kdpred(f, 2) != truth(nf, 2));
  printf("      and at every other p < %d the theorem holds: %d mismatches\n", PMAX,
    sum(k = 1, 0, 0) + #select(q -> q, vector(#primes([3, PMAX]), j,
      my(p = primes([3, PMAX])[j]); kdpred(f, p) != truth(nf, p))));
};

\\ ---------------------------------------------------------------- check 3
\\ Worse: at p = 2 in that field NO generator works.  2 splits completely,
\\ so a valid f would have to factor into three DISTINCT monic linear factors
\\ mod 2 -- but F_2[x] has only two monic linear polynomials.  So 2 divides
\\ the index of every Z[theta], and is a "common index divisor".

check3() =
{ my(f = x^3 - x^2 - 2*x - 8, nf = nfinit(f), dec = idealprimedec(nf, 2), lin = 0, bad = 0);
  printf("  (3) 2 is a common index divisor of that field\n");
  printf("      primes above 2: %d of them, all with e = f = 1 : %d\n", #dec,
         #dec == 3 && #select(P -> P.e == 1 && P.f == 1, dec) == 3);
  lin = #select(q -> poldegree(q) == 1, [x, x+1]);
  printf("      monic linear polynomials over F_2 : %d (namely x and x+1)\n", lin);
  printf("      a cubic needing %d distinct linear factors mod 2 cannot exist : %d\n", #dec, #dec > lin);
  \\ brute-force confirmation over many generators
  for (a = -6, 6, for (b = -6, 6, for (c = -6, 6,
    my(t = Mod(a + b*x + c*x^2, f), g);
    g = minpoly(t);
    if (poldegree(g) != 3, next);
    if (!polisirreducible(g), next);
    if (nfinit(g).index % 2 != 0, bad++))));
  printf("      generators a+b.theta+c.theta^2 with |a|,|b|,|c| <= 6 whose index is odd : %d\n", bad);
};

\\ ---------------------------------------------------------------- check 4
\\ Dedekind's criterion: a test for the hypothesis that uses only f mod p.
\\ Write f = g1^bar . h^bar mod p with g1 the radical of f mod p, lift both
\\ monic, set T = (g1 h - f)/p.  Then p does not divide the index iff
\\ gcd(T, g1, h) = 1 in F_p[x].

dedekind(f, p) =
{ my(F = factormod(f, p), g1 = 1, T, hb, gb);
  for (j = 1, matsize(F)[1], g1 *= lift(F[j,1]));
  gb = Mod(1, p) * g1;
  hb = Mod(1, p) * f / gb;
  T = (lift(gb) * lift(hb) - f) / p;
  poldegree(gcd(gcd(Mod(1,p)*T, gb), hb)) == 0;
};

check4() =
{ my(bad = 0, tot = 0);
  printf("  (4) Dedekind's criterion agrees with the true index\n");
  for (i = 1, #FLDS,
    my(f = FLDS[i], nf = nfinit(f), p = 2);
    while (p < PMAX,
      tot++;
      if (dedekind(f, p) != (nf.index % p != 0), bad++);
      p = nextprime(p+1)));
  printf("      %d pairs (f, p) tested, disagreements with nf.index : %d\n", tot, bad);
};

\\ ---------------------------------------------------------------- check 5
\\ Two sanity identities.  The fundamental identity sum e_i f_i = n holds on
\\ both sides, and disc(f) = index^2 . disc(K), so a prime dividing the index
\\ divides disc(f) to at least the second power -- which is why "p does not
\\ divide disc(f)" is a usable sufficient condition for the hypothesis.

check5() =
{ my(bad1 = 0, bad2 = 0, bad3 = 0);
  printf("  (5) fundamental identity, and disc(f) = index^2 . disc(K)\n");
  for (i = 1, #FLDS,
    my(f = FLDS[i], nf = nfinit(f), n = poldegree(f), p = 2);
    if (poldisc(f) != nf.index^2 * nf.disc, bad1++);
    while (p < PMAX,
      my(t = truth(nf, p));
      if (sum(j = 1, #t, t[j][1]*t[j][2]) != n, bad2++);
      if (nf.index % p == 0 && poldisc(f) % p^2 != 0, bad3++);
      p = nextprime(p+1)));
  printf("      disc(f) != index^2 . disc(K) : %d of %d fields\n", bad1, #FLDS);
  printf("      sum e_i f_i != n             : %d\n", bad2);
  printf("      p divides index but p^2 does not divide disc(f) : %d\n", bad3);
};

\\ ---------------------------------------------------------------- check 6
\\ The worked table of the note: x^3 - 2, which has index 1, so the theorem
\\ applies at every prime including the ramified ones.

check6() =
{ my(g = x^3 - 2, L = nfinit(g));
  printf("  (6) worked example: x^3 - 2, index %d, so every p is covered\n", L.index);
  printf("      %-6s %-36s %s\n", "p", "f mod p", "[e,f] of the primes above p");
  for (i = 1, 7,
    my(p = [2,3,5,7,29,31,127][i], F = factormod(g,p), s = "");
    for (j = 1, matsize(F)[1],
      s = Str(s, if (j>1, " . ", ""), "(", lift(F[j,1]), ")",
              if (F[j,2] > 1, Str("^", F[j,2]), "")));
    printf("      %-6d %-36s %s\n", p, s, Str(truth(L, p))));
};


\\ ---------------------------------------------------------------- check 7
\\ THE LOCAL PICTURE.  The unconditional statement is p-adic: K tensor Q_p is
\\ the product of the completions K_P, so the primes above p correspond to the
\\ irreducible factors of f over Q_p, with deg F_P = e(P/p) f(P/p).  No index
\\ hypothesis anywhere.  Kummer-Dedekind is the assertion that when p does not
\\ divide the index, the factorisation mod p already determines this one.

pprec(f, p) = max(20, 3*valuation(poldisc(f), p) + 10);

check7() =
{ my(bad = 0, badd = 0, tot = 0);
  printf("  (7) primes above p <-> irreducible factors of f over Q_p, unconditionally\n");
  for (i = 1, #FLDS,
    my(f = FLDS[i], nf = nfinit(f), p = 2);
    while (p < 200,
      my(F = factorpadic(f, p, pprec(f, p)), dec = idealprimedec(nf, p));
      tot++;
      if (matsize(F)[1] != #dec, bad++);
      if (vecsort(vector(matsize(F)[1], j, poldegree(F[j,1]))) !=
          vecsort([P.e * P.f | P <- dec]), badd++);
      p = nextprime(p+1)));
  printf("      %d pairs (f, p) tested, all p < 200\n", tot);
  printf("      wrong number of p-adic factors        : %d\n", bad);
  printf("      degrees not matching the e.f of O_K   : %d\n", badd);
  \\ the three index-dividing pairs in the batch, in detail
  printf("      at p dividing the index: mod-p count, p-adic count, and the [e,f] verdict\n");
  for (i = 1, #FLDS,
    my(f = FLDS[i], nf = nfinit(f), p = 2);
    while (p < 200,
      if (nf.index % p == 0,
        my(F = factorpadic(f, p, pprec(f, p)), r = matsize(factormod(f,p))[1]);
        printf("        %-22s p=%-3d  mod p: %d   over Q_p: %d   KD says %-16s truth %-16s %s\n",
               f, p, r, matsize(F)[1], Str(kdpred(f,p)), Str(truth(nf,p)),
               if (kdpred(f,p) == truth(nf,p), "holds anyway", "FAILS")));
      p = nextprime(p+1)));
};

\\ ---------------------------------------------------------------- check 8
\\ Why common index divisors exist, locally.  Every O_P is monogenic over Z_p,
\\ but the PRODUCT over P | p need not be: if prod O_P = Z_p[x]/(f) then
\\ reducing mod p forces the residue fields to be F_p[x]/(g_P) with the g_P
\\ DISTINCT, so for each d there must be at least as many monic irreducibles
\\ of degree d over F_p as there are primes with residue degree d.  Below,
\\ that count is run at every (f, p); it can fail only at a common index
\\ divisor, and in this batch it fails exactly once.

\\ number of monic irreducible polynomials of degree d over F_p
nirr(p, d) = sumdiv(d, e, moebius(e) * p^(d/e)) / d;

check8() =
{ my(viol = 0, tot = 0);
  printf("  (8) the monogenicity count: #{P : f(P/p) = d} <= #monic irreducibles of degree d\n");
  for (i = 1, #FLDS,
    my(f = FLDS[i], nf = nfinit(f), p = 2);
    while (p < 200,
      my(dec = idealprimedec(nf, p));
      for (d = 1, poldegree(f),
        my(c = #select(P -> P.f == d, dec));
        tot++;
        if (c > nirr(p, d),
          viol++;
          printf("        %-22s p=%-3d d=%d : %d primes but only %d monic irreducibles\n",
                 f, p, d, c, nirr(p, d))));
      p = nextprime(p+1)));
  printf("      %d (field, p, d) triples tested, violations : %d\n", tot, viol);
  printf("      a violation is exactly an obstruction to prod_{P|p} O_P being\n");
  printf("      monogenic over Z_p, i.e. exactly a common index divisor\n");
};

print("======================================================================");
print("kummer-dedekind.gp -- factoring p by factoring f mod p");
print("");
check1(); print("");
check2(); print("");
check3(); print("");
check4(); print("");
check5(); print("");
check6(); print("");
check7(); print("");
check8(); print("");
print("======================================================================");
