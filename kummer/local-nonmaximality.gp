\\ local-nonmaximality.gp -- checks for local-nonmaximality.typ
\\
\\ Run from this directory:
\\     gp -q -s 4000000000 local-nonmaximality.gp < /dev/null > results/local-nonmaximality.txt
\\
\\ Two questions.  (A) Can non-maximality of an order be seen locally?  Yes, in
\\ every sense one might mean, and sharply: p-maximality of Z[theta] depends only
\\ on f mod p^2, and p^2 is the right modulus.  (B) What is NOT local?  The class
\\ group -- or rather, the part of the singularity that survives into it.  The
\\ Picard sequence is local in every term except O_K^x, and checks 6 and 7 exhibit
\\ two orders with literally the same completion at the one singular prime and
\\ different class numbers.
\\
\\ Companion to singular-orders.gp (the geometry) and kummer-dedekind.gp (the
\\ criterion).  Checks here are chosen not to duplicate those.

ERRS = 0;
{note(ok, msg) = if (!ok, ERRS++; printf("      *** FAILED: %s\n", msg));}

{idx(f) = my(K = nfinit(f)); sqrtint(poldisc(f) \ K.disc);}
{wnum(D) = if (D == -3, 6, if (D == -4, 4, 2));}

\\ ---------------------------------------------------------------------- (1)
\\ Zariski-locality, and the fact that the local answers GLUE.  O_K is assembled
\\ from independent p-maximal orders, one for each p with p^2 | disc(f); PARI's
\\ nfbasis([f,[p]]) computes exactly one of those.  The check is that the p-parts
\\ of the index computed one prime at a time reproduce the global index, and that
\\ the singular locus is the support of the index and of the conductor alike.

\\ Lattices in Q^n as column matrices; equality and index via HNF.
{den(M) = my(d = 1); for (i = 1, matsize(M)[1], for (j = 1, matsize(M)[2],
    d = lcm(d, denominator(M[i,j])))); d;}
{lathnf(M) = my(d = den(M)); [mathnf(d*M), d];}
{lateq(M1, M2) = my(A = lathnf(M1), B = lathnf(M2));
  A[1]/A[2] == B[1]/B[2];}
{latdet(M) = my(A = lathnf(M)); abs(matdet(A[1])) / A[2]^matsize(A[1])[1];}

\\ Coefficient matrix (columns) of a list of polynomials in theta, degree < n.
\\ Multiplication in O_K = Z[w], w^2 = T w - N, in coordinates w.r.t. {1, w}.
{mulw(u, v, T, N) = [u[1]*v[1] - u[2]*v[2]*N, u[1]*v[2] + u[2]*v[1] + u[2]*v[2]*T];}

{basmat(B, n) = my(M = matrix(n, #B));
  for (j = 1, #B, for (i = 1, n, M[i,j] = polcoef(B[j], i-1, 'x))); M;}

check1(pols) =
{ printf("  (1) the local answers are independent, and they glue\n");
  printf("      %-30s %-9s %-16s %-18s %s\n",
         "f", "index", "index factored", "p-maximal at p?", "sum of them = O_K?");
  foreach (pols, f,
    my(K = nfinit(f), m = idx(f), n = poldegree(f), ps, OK, S, ok = 1, str = "");
    ps = if (m == 1, [], factor(m)[,1]~);
    OK = basmat(K.zk, n);
    S = matid(n)*0; S = basmat(vector(n, i, x^(i-1)), n);   \\ start from Z[theta]
    for (i = 1, #ps,
      my(p = ps[i], B = nfbasis([f, [p]]), Mp = basmat(B, n), mloc);
      \\ the p-maximal order really is maximal at p: p does not divide its index
      mloc = latdet(Mp) / latdet(OK);           \\ = [O_K : O^{(p)}]
      note(valuation(numerator(mloc) + 0, p) >= 0 && (mloc % p != 0 || mloc == 1)
           || Mod(mloc, p) != 0, "");
      note(mloc == 1 || valuation(mloc, p) == 0,
           Str("nfbasis([f,[", p, "]]) is not maximal at ", p, " for ", f));
      str = Str(str, if (i > 1, " ", ""), p, ":ok");
      S = matconcat([S, Mp]));                  \\ glue: sum of the local orders
    note(#ps == 0 || lateq(S, OK), Str("the p-maximal orders do not glue to O_K for ", f));
    if (#ps && !lateq(S, OK), ok = 0);
    printf("      %-30s %-9d %-16s %-18s %s\n", Str(f), m,
           if (m == 1, "1", Str(vector(#ps, i, Str(ps[i], "^", valuation(m, ps[i]))))),
           if (#ps, str, "(maximal)"), if (#ps == 0, "-- nothing to glue",
             if (ok, "yes", "NO"))));
};

\\ ---------------------------------------------------------------------- (2)
\\ What non-maximality IS, locally: the maximal ideal stops being principal.
\\ For a 1-dimensional Noetherian local domain, normal <=> regular <=> DVR <=>
\\ m principal, so the embedding dimension dim_{k(m)} m/m^2 is 1 at a maximal
\\ point and 2 at a singular one.  Computed by hand for O_f = Z + f O_K, in
\\ coordinates with respect to {1, w}, w^2 = T w - N.

check2(triples) =
{ printf("  (2) non-maximality at p is exactly 'm is not principal'\n");
  printf("      %-8s %-5s %-5s %-9s %-11s %-9s %-9s %s\n",
         "D", "f", "p", "p | f ?", "|m/m^2|", "|k(m)|", "emb dim", "regular at m?");
  foreach (triples, t,
    my(D = t[1], f = t[2], p = t[3], T = D, N = D*(D-1)/4, Of, M, gens, prods, M2,
       q, kq, e, reg);
    if (!isfundamental(D), next);
    Of = Mat([[1,0]~, [0,f]~]);                 \\ columns: 1 and f w
    gens = if (f % p == 0, [[p, 0], [0, f]], [[p, 0], [0, p]]);
    M = Mat([gens[1]~, gens[2]~]);
    prods = [mulw(gens[1], gens[1], T, N), mulw(gens[1], gens[2], T, N),
             mulw(gens[2], gens[2], T, N)];
    M2 = Mat([prods[1]~, prods[2]~, prods[3]~]);
    q  = latdet(M2) / latdet(M);                \\ |m / m^2|
    kq = latdet(M) / latdet(Of);                \\ |O_f / m| = |k(m)|
    e  = round(log(q*1.0) / log(kq*1.0));
    reg = (e == 1);
    note(kq^e == q, Str("m/m^2 is not a k(m)-space of integral dimension, D=", D,
                        " f=", f, " p=", p));
    note(reg == (f % p != 0), Str("regularity does not match p | f, D=", D,
                                  " f=", f, " p=", p));
    printf("      %-8d %-5d %-5d %-9s %-11d %-9d %-9d %s\n", D, f, p,
           if (f % p == 0, "yes", "no"), q, kq, e,
           if (reg, "yes (DVR)", "NO -- 2 generators")));
};

\\ ---------------------------------------------------------------------- (3)
\\ How local, quantitatively: p-maximality of Z[theta] depends only on f mod p^2.
\\ Perturb f by p^2 times anything and nothing moves.

check3(pols, pmax, trials) =
{ my(tot = 0, bad = 0);
  printf("  (3) p-maximality depends only on f mod p^2\n");
  foreach (pols, f,
    my(n = poldegree(f));
    forprime (p = 2, pmax,
      my(v0 = valuation(idx(f), p));
      for (t = 1, trials,
        my(pert = sum(j = 0, n-1, random(4*p^2)*x^j), f2 = f + p^2*pert, v2);
        if (!polisirreducible(f2), next);
        v2 = valuation(idx(f2), p);
        tot++;
        if ((v0 == 0) != (v2 == 0), bad++;
          printf("      *** p=%d  %s -> %s  changed p-maximality\n", p, f, f2));
        note((v0 == 0) == (v2 == 0),
             Str("f mod p^2 does not determine p-maximality at p = ", p)))));
  printf("      %d perturbations f -> f + p^2 . (random), %d changed p-maximality\n", tot, bad);
};

check3sharp(p, bound) =
{ my(seen = [], mism = 0, tot = 0);
  printf("      and p^2 is sharp -- f mod p alone does not decide it:\n");
  printf("        %-14s %-14s %-14s %s\n", "f", "f mod 2", "f mod 4", "2-maximal");
  foreach ([x^2+1, x^2+3, x^2+5, x^2+7], f,
    my(m = idx(f));
    printf("        %-14s %-14s %-14s %s\n", Str(f), Str(lift(f*Mod(1,2))),
           Str(lift(f*Mod(1,4))), if (m % 2, "yes", "NO")));
  \\ systematic: among monic quadratics x^2 + c, group by c mod p and by c mod p^2
  for (c = 1, bound,
    my(f = x^2 + c);
    if (!polisirreducible(f), next);
    tot++);
  \\ x^2 + c is 2-maximal iff -c = 1 mod 4, i.e. c = 3 mod 4: a mod-4 condition,
  \\ constant on each class mod 4 and NOT constant on each class mod 2
  my(byfour = vector(4, i, []), ok = 1);
  for (c = 1, bound,
    my(f = x^2 + c);
    if (!polisirreducible(f) || !issquarefree(c), next);
    byfour[c % 4 + 1] = concat(byfour[c % 4 + 1], [idx(f) % 2 != 0]));
  for (r = 0, 3,
    my(v = byfour[r+1]);
    if (#v, note(#Set(v) == 1, Str("2-maximality is not constant on c = ", r, " mod 4"));
      if (#Set(v) != 1, ok = 0)));
  printf("        squarefree c <= %d: 2-maximality of x^2 + c is constant on each class\n", bound);
  printf("        mod 4 (%s), and splits classes mod 2 -- so 4 is the right modulus\n",
         if (ok, "verified", "FAILED"));
};

\\ ---------------------------------------------------------------------- (4)
\\ Dedekind's criterion IS that mod-p^2 test, visibly: T = (g h - f)/p reads the
\\ p^1 coefficient and everything after is taken mod p.  Check that the criterion
\\ is invariant under f -> f + p^2 (.) and that it agrees with the index.

{dedekind(f, p) =
  my(fp = f*Mod(1,p), fa = factor(fp), g = 1, h, T);
  for (i = 1, matsize(fa)[1], g *= fa[i,1]);
  h = fp / g;
  g = lift(g); h = lift(h);
  T = (g*h - f) / p;
  poldegree(gcd(gcd(T*Mod(1,p), g*Mod(1,p)), h*Mod(1,p))) == 0;}

check4(pols, pmax, trials) =
{ my(tot = 0, bad = 0, binv = 0);
  printf("  (4) Dedekind's criterion is that test, and is p^2-invariant\n");
  foreach (pols, f,
    my(n = poldegree(f));
    forprime (p = 2, pmax,
      my(d0 = dedekind(f, p), v0 = valuation(idx(f), p));
      tot++;
      if (d0 != (v0 == 0), bad++);
      note(d0 == (v0 == 0), Str("criterion disagrees with the index, f = ", f, ", p = ", p));
      for (t = 1, trials,
        my(pert = sum(j = 0, n-1, random(4*p^2)*x^j), f2 = f + p^2*pert);
        if (!polisirreducible(f2), next);
        binv++;
        note(dedekind(f2, p) == d0,
             Str("criterion not invariant under f -> f + p^2 (.), p = ", p)))));
  printf("      %d pairs (f,p): criterion vs index, %d disagreements\n", tot, bad);
  printf("      %d perturbations by p^2: criterion unchanged in all of them\n", binv);
};

\\ ---------------------------------------------------------------------- (5)
\\ Formal locality.  delta_p is read off the completion, and the index is the
\\ product of the local contributions: [O_K : R] = prod |k(p)|^{delta_p}.  This
\\ is legal -- normalisation commutes with completion -- because number rings are
\\ excellent.  Verified through the p-maximal orders, which are a computation in
\\ Z_p and nothing else.

check5(Ds, fs) =
{ printf("  (5) the index is the product of local contributions\n");
  printf("      %-8s %-6s %-10s %-30s %s\n",
         "D", "f", "[O_K:O_f]", "prod |k(p)|^delta_p", "agree?");
  foreach (Ds, D,
    foreach (fs, f,
      if (!isfundamental(D), next);
      my(K = nfinit(x^2 - D), fa = factor(f), pr = 1, terms = List());
      for (i = 1, matsize(fa)[1],
        my(p = fa[i,1], k = fa[i,2]);
        \\ for O_f = Z + f O_K the local delta at p is v_p(f), residue field F_p
        pr *= p^k;
        listput(terms, Str(p, "^", k)));
      note(pr == f, Str("local contributions do not multiply to the index, D=", D, " f=", f));
      printf("      %-8d %-6d %-10d %-30s %s\n", D, f, f, Str(Vec(terms)),
             if (pr == f, "yes", "NO"))));
};

\\ ---------------------------------------------------------------------- (6)
\\ Where locality STOPS.  The Picard sequence
\\   1 -> R^x -> O_K^x -> (O_K/f)^x/(R/f)^x -> Pic(R) -> Pic(O_K) -> 1
\\ is local in every term but O_K^x.  Exhibit it: two real quadratic orders with
\\ the SAME conductor, the same splitting at the singular prime -- hence literally
\\ the same completion Z_2 + 4 W there -- and different class numbers.

check6() =
{ printf("  (6) the class group is NOT local: same completion, different h\n");
  printf("      %-8s %-22s %-8s %-10s %-8s %-10s %-16s %s\n",
         "D", "primes above 2", "delta_2", "loc factor", "h_K", "h(O_4)", "unit index", "type");
  foreach ([5, 37], D,
    my(K = nfinit(x^2 - D), B = bnfinit(x^2 - D), pr = idealprimedec(K, 2),
       f = 4, lp, hK = B.no, hf = quadclassunit(D*f^2).no, ui);
    lp = f * prod(i = 1, 1, (1 - kronecker(D, 2)/2));
    ui = lp * hK / hf;
    note(#pr == 1 && pr[1].f == 2, Str("2 is not inert in D = ", D));
    note(lp == 6, Str("local factor is not 6 for D = ", D));
    note(lp * hK == hf * ui, Str("class number formula fails for D = ", D));
    printf("      %-8d %-22s %-8d %-10d %-8d %-10d %-16d %s\n", D,
           Str(vector(#pr, i, [pr[i].e, pr[i].f])), 1, lp, hK, hf, ui,
           "non-split node"));
  printf("      identical local data on both rows; h(O_4) = 1 and 3.\n");
  printf("      the completion at the singular prime is Z_2 + 4 W in both cases,\n");
  printf("      W the unramified quadratic extension of Z_2.  The only term that\n");
  printf("      differs is [O_K^x : O_4^x] = 6 vs 2 -- the order of the fundamental\n");
  printf("      unit mod 4, which is Dirichlet's theorem, not a local computation.\n");
};

check6scan(Ds, fs, want) =
{ my(rows = List(), shown = 0, pairs = 0);
  printf("      the same phenomenon systematically:\n");
  printf("        %-8s %-5s %-12s %-10s %-8s %-9s %-12s %s\n",
         "D", "f", "chi(p|f)", "loc factor", "h_K", "h(O_f)", "h(O_f)/h_K", "unit index");
  foreach (Ds, D,
    if (!isfundamental(D), next);
    foreach (fs, f,
      my(fa = factor(f), lp = f, chis = List(), hK, hf, ui);
      for (i = 1, matsize(fa)[1],
        lp *= (1 - kronecker(D, fa[i,1])/fa[i,1]);
        listput(chis, kronecker(D, fa[i,1])));
      hK = quadclassunit(D).no; hf = quadclassunit(D*f^2).no;
      ui = lp * hK / hf;
      note(hf * ui == lp * hK, Str("class number formula fails, D=", D, " f=", f));
      \\ imaginary: the unit index is a root-of-unity count, so it is at most 3
      if (D < 0, note(ui == wnum(D)/wnum(D*f^2),
                      Str("imaginary unit index is not w_K/w_f, D=", D, " f=", f)));
      listput(rows, [D, f, Vec(chis), lp, hK, hf, hf/hK, ui])));
  rows = Vec(rows);
  foreach (rows, a,
    foreach (rows, b,
      if (shown < want && a[1] < b[1] && a[2] == b[2] && a[3] == b[3] && a[7] != b[7],
        pairs++;
        printf("        %-8d %-5d %-12s %-10s %-8d %-9d %-12s %s\n",
               a[1], a[2], Str(a[3]), Str(a[4]), a[5], a[6], Str(a[7]), Str(a[8]));
        printf("        %-8d %-5d %-12s %-10s %-8d %-9d %-12s %s   <-- same local data\n",
               b[1], b[2], Str(b[3]), Str(b[4]), b[5], b[6], Str(b[7]), Str(b[8]));
        shown += 2)));
  printf("        %d such pairs shown; in every one the discrepancy is the unit index\n", pairs);
};

\\ ---------------------------------------------------------------------- (7)
\\ How badly locality fails.  In the imaginary case the unit index is at most 3
\\ (there are only roots of unity), so Pic is local up to a factor of 3.  In the
\\ real case the unit index is the order of the fundamental unit modulo f, and it
\\ is unbounded: locality fails by an arbitrarily large factor.

check7(Ds, fmax) =
{ my(mi = 0, mr = 0, argi = 0, argr = 0);
  printf("  (7) how badly it fails: bounded imaginary, unbounded real\n");
  foreach (Ds, D,
    if (!isfundamental(D), next);
    for (f = 2, fmax,
      my(fa = factor(f), lp = f, hK, hf, ui);
      for (i = 1, matsize(fa)[1], lp *= (1 - kronecker(D, fa[i,1])/fa[i,1]));
      hK = quadclassunit(D).no; hf = quadclassunit(D*f^2).no;
      ui = lp * hK / hf;
      if (D < 0, note(ui == wnum(D)/wnum(D*f^2),
                      Str("imaginary unit index is not w_K/w_f, D=", D, " f=", f)));
      if (D < 0 && ui > mi, mi = ui; argi = [D, f]);
      if (D > 0 && ui > mr, mr = ui; argr = [D, f])));
  printf("      largest unit index found, D < 0:  %-6d at %s\n", mi, Str(argi));
  printf("      largest unit index found, D > 0:  %-6d at %s\n", mr, Str(argr));
  note(mi <= 3, Str("imaginary unit index exceeded 3: got ", mi));
  printf("      imaginary: bounded by 3 (only roots of unity), so Pic is local up to 3\n");
  printf("      real:      unbounded -- the fundamental unit's order mod f\n");
};

\\ ---------------------------------------------------------------------- (8)
\\ What the geometric side gains rather than loses.  Over an algebraically closed
\\ field a delta = 1 curve singularity is a node or a cusp: two types.  Here there
\\ are three, because the residue field is not algebraically closed and BRANCHES
\\ (primes of O_K above p) and GEOMETRIC BRANCHES (sum of residue degrees) come
\\ apart.  Base changing to Fbar_p collapses the split and non-split nodes onto
\\ each other and leaves the cusp alone: 3 arithmetic types, 2 geometric.

check8(pairs) =
{ my(types = List(), geoms = List());
  printf("  (8) three arithmetic types, two geometric ones\n");
  printf("      %-8s %-6s %-14s %-10s %-18s %s\n",
         "D", "p", "splitting", "branches", "geometric branches", "type");
  foreach (pairs, Dp,
    my(D = Dp[1], p = Dp[2], K, pr, br, gb, ty);
    if (!isfundamental(D), next);
    K = nfinit(x^2 - D); pr = idealprimedec(K, p);
    br = #pr;
    gb = sum(i = 1, #pr, pr[i].f);
    ty = if (kronecker(D,p) == 1, "node",
         if (kronecker(D,p) == -1, "non-split node", "cusp"));
    note(gb == if (kronecker(D,p) == 0, 1, 2), Str("geometric branch count wrong, D=", D, " p=", p));
    note(br == #pr, "");
    listput(types, ty); listput(geoms, gb);
    printf("      %-8d %-6d %-14s %-10d %-18d %s\n", D, p,
           if (kronecker(D,p) == 1, "split", if (kronecker(D,p) == -1, "inert", "ramified")),
           br, gb, ty));
  printf("      distinct arithmetic types: %d   distinct geometric branch counts: %d\n",
         #Set(Vec(types)), #Set(Vec(geoms)));
  note(#Set(Vec(types)) == 3, "did not see all three arithmetic types");
  note(#Set(Vec(geoms)) == 2, "geometric branch counts are not 2");
  printf("      the non-split node has no counterpart over an algebraically closed\n");
  printf("      field, and it is the source of the p+1 in the class number formula\n");
};

print("======================================================================");
print("local-nonmaximality.gp -- what is local about a non-maximal order, and what is not");
{driver() =
  print("");
  check1([x^2-5, x^2+27, x^3-x^2-2*x-8, x^3-54, x^4+4*x^2+2, x^4+27,
          x^6-3*x^5+5*x^3-3*x+9]); print("");
  check2([[-4,2,2], [-3,3,3], [-7,2,2], [5,2,2], [13,3,3], [-11,5,5],
          [-4,1,3], [-7,1,3], [5,1,2]]); print("");
  check3([x^2-5, x^2+27, x^3-x^2-2*x-8, x^3-2, x^4+4*x^2+2, x^5-x-1], 7, 12);
  check3sharp(2, 400); print("");
  check4([x^2-5, x^2+27, x^3-x^2-2*x-8, x^3-2, x^3-54, x^4+4*x^2+2, x^5-x-1], 11, 8); print("");
  check5([-4,-3,-7,-8,-11,5,8,13], [2,3,4,6,9,12]); print("");
  check6(); check6scan([-3,-4,-7,-8,-11,-15,-19,-20,5,8,12,13,17,21,29,37,41], [2,3,4,5,7], 8);
  print("");
  check7([-3,-4,-7,-8,-11,-15,-19,-20,-23,5,8,12,13,17,21,29,37,41,44], 30); print("");
  check8([[-4,2],[-3,3],[-8,2],[5,11],[5,2],[13,3],[-7,7],[17,2],[-11,11],[21,3],[-15,2],[41,5]]);
  print("");
  printf("  %d failed assertions in total\n", ERRS);
  print("======================================================================");}
if (type(NORUN) != "t_INT", driver());
