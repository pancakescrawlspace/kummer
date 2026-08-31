\\ splitting-galois-closure.gp -- checks for splitting-galois-closure.typ
\\
\\ Run from this directory:
\\     gp -q -s 6000000000 splitting-galois-closure.gp < /dev/null \
\\         > results/splitting-galois-closure.txt
\\
\\ If p splits completely in the Galois closure L of K, must it split
\\ completely in K?  Yes, and trivially: e and f are multiplicative in towers
\\ and K sits inside L.  The CONVERSE is the substantive statement, and it is
\\ where the words "Galois closure" earn their place: p splits completely in K
\\ iff the decomposition group lies in every conjugate of H = Gal(L/K), i.e.
\\ inside the core of H, which is trivial exactly because L is the closure.
\\ These checks confirm the equivalence, the density 1/[L:Q] that follows from
\\ it, and -- as controls -- that a larger field which is NOT the closure does
\\ not have the property.

default(realprecision, 20);

PMAX = 100000;

\\ does p split completely in the number field nf?
spl(nf, p) = #idealprimedec(nf, p) == poldegree(nf.pol);

\\ the primes below PMAX that split completely in nf
splset(nf, pmax) =
{ my(v = List(), p = 2);
  while (p <= pmax, if (spl(nf, p), listput(v, p)); p = nextprime(p+1));
  Set(Vec(v));
};

FLDS = [x^3 - 2, x^4 - 2, x^4 - x - 1];

\\ ---------------------------------------------------------------- check 1
\\ The equivalence itself.  For three non-Galois fields K and their closures
\\ L, the two sets of completely split primes below 10^5 are compared element
\\ by element.  Neither inclusion may fail: Spl(L) subset Spl(K) is the easy
\\ direction of the note, Spl(K) subset Spl(L) is the converse.

check1() =
{ my(bad1 = 0, bad2 = 0);
  printf("  (1) Spl(K) = Spl(L) below %d\n", PMAX);
  printf("      %-12s %-6s %-6s %-9s %-9s %-11s %s\n",
         "K", "[K:Q]", "[L:Q]", "#Spl(K)", "#Spl(L)", "in K not L", "in L not K");
  for (i = 1, #FLDS,
    my(f = FLDS[i], g = nfsplitting(f), K = nfinit(f), L = nfinit(polredbest(g)),
       SK, SL, a, b);
    SK = splset(K, PMAX); SL = splset(L, PMAX);
    a = setminus(SK, SL); b = setminus(SL, SK);
    bad1 += #a; bad2 += #b;
    printf("      %-12s %-6d %-6d %-9d %-9d %-11d %d\n",
           f, poldegree(f), poldegree(g), #SK, #SL, #a, #b));
  printf("      primes splitting in K but not in L : %d\n", bad1);
  printf("      primes splitting in L but not in K : %d\n", bad2);
};

\\ ---------------------------------------------------------------- check 2
\\ The easy direction, for EVERY subfield at once.  L is Galois here, and any
\\ intermediate field will do -- the argument uses only multiplicativity of e
\\ and f, never normality.  Taken over all subfields of the closure of x^4-2.

check2() =
{ my(g = nfsplitting(x^4 - 2), L = nfinit(polredbest(g)), subs, SL, bad = 0);
  subs = nfsubfields(L);
  SL = splset(L, PMAX);
  printf("  (2) p split in L implies p split in every subfield of L\n");
  printf("      L = closure of x^4-2, degree %d, %d subfields, |Spl(L)| = %d\n",
         poldegree(L.pol), #subs, #SL);
  for (i = 1, #subs,
    my(h = subs[i][1], d = poldegree(h), M, miss = 0);
    if (d <= 1, next);
    M = nfinit(polredbest(h));
    for (j = 1, #SL, if (!spl(M, SL[j]), miss++));
    bad += miss;
    printf("      subfield of degree %-3d : %d of %d fail to split\n", d, miss, #SL));
  printf("      total failures : %d\n", bad);
};

\\ ---------------------------------------------------------------- check 3
\\ Control: a bigger field is not enough, it has to be the CLOSURE.  Take
\\ K = Q(2^(1/3)) and M = K(sqrt 7), also of degree 6 over Q but not Galois
\\ and not the closure.  Plenty of primes split completely in K and not in M,
\\ so the converse of check 1 is a statement about the closure specifically.

check3() =
{ my(K = nfinit(x^3 - 2), g = nfsplitting(x^3 - 2), L = nfinit(polredbest(g)),
    M = nfinit(polredbest(polcompositum(x^3 - 2, x^2 - 7)[1])), SK, SL, SM);
  SK = splset(K, PMAX); SL = splset(L, PMAX); SM = splset(M, PMAX);
  printf("  (3) control: the closure is not just any larger field\n");
  printf("      K = Q(2^(1/3)), degree 3          |Spl(K)| = %d\n", #SK);
  printf("      L = closure of K, degree %d        |Spl(L)| = %d,  Spl(K) minus Spl(L) = %d\n",
         poldegree(L.pol), #SL, #setminus(SK, SL));
  printf("      M = K(sqrt 7), degree %d, NOT the closure and not Galois:\n", poldegree(M.pol));
  printf("        |Spl(M)| = %d,  Spl(K) minus Spl(M) = %d\n", #SM, #setminus(SK, SM));
  printf("      so K and M share no such equivalence; only the closure gives one\n");
};

\\ ---------------------------------------------------------------- check 4
\\ The density.  Chebotarev applied to L gives |Spl(K) below X| / pi(X) ->
\\ 1/[L:Q], NOT 1/[K:Q].  This is the corollary that most often surprises.

check4() =
{ my(pi = primepi(PMAX));
  printf("  (4) density of Spl(K) is 1/[L:Q], not 1/[K:Q]   (pi(%d) = %d)\n", PMAX, pi);
  printf("      %-12s %-10s %-12s %-12s %s\n", "K", "observed", "1/[L:Q]", "1/[K:Q]", "verdict");
  for (i = 1, #FLDS,
    my(f = FLDS[i], g = nfsplitting(f), K = nfinit(f), S, obs, dL, dK);
    S = splset(K, PMAX);
    obs = 1.0 * #S / pi;
    dL = 1.0 / poldegree(g); dK = 1.0 / poldegree(f);
    printf("      %-12s %-10.5f %-12.5f %-12.5f %s\n", f, obs, dL, dK,
           if (abs(obs - dL) < abs(obs - dK), "matches 1/[L:Q]", "MATCHES 1/[K:Q]")));
};

\\ ---------------------------------------------------------------- check 5
\\ The corollary: Spl(K) depends only on the closure, so two non-isomorphic
\\ fields with the same closure have the SAME completely split primes.  The
\\ closure of x^4-2 has degree 8 and several quartic subfields; those whose
\\ own closure is all of L share one splitting set, while the quartic subfield
\\ that is already Galois has a strictly larger one.

check5() =
{ my(g = nfsplitting(x^4 - 2), L = nfinit(polredbest(g)), subs, rows = List());
  subs = nfsubfields(L, 4);
  printf("  (5) Spl depends only on the closure: quartic subfields of L\n");
  printf("      %-26s %-9s %-9s %s\n", "subfield", "[clos:Q]", "|Spl|", "Galois?");
  for (i = 1, #subs,
    my(h = polredbest(subs[i][1]), M = nfinit(h), c = poldegree(nfsplitting(h)), S);
    S = splset(M, PMAX);
    listput(rows, [c, #S, Set(S)]);
    printf("      %-26s %-9d %-9d %s\n", h, c, #S, if (c == 4, "yes", "no")));
  my(v = Vec(rows), nn = select(r -> r[1] == 8, v), same = 1);
  for (i = 2, #nn, if (nn[i][3] != nn[1][3], same = 0));
  printf("      the %d non-Galois quartic subfields all have closure of degree 8\n", #nn);
  printf("      and identical splitting sets : %d\n", same);
  printf("      x^4-2 and x^4+2 isomorphic as fields? %d   (discriminants %d and %d)\n",
         nfisisom(x^4 - 2, x^4 + 2) != 0, nfdisc(x^4 - 2), nfdisc(x^4 + 2));
  printf("      so two NON-isomorphic quartic fields share one splitting set,\n");
  printf("      because they share one Galois closure\n");
};

print("======================================================================");
print("splitting-galois-closure.gp -- splitting completely in K and in its closure");
print("");
check1(); print("");
check2(); print("");
check3(); print("");
check4(); print("");
check5(); print("");
print("======================================================================");
