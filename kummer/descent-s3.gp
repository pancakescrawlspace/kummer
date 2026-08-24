\\ descent-s3.gp -- 2-descent when E[2] is generic (Gal(Q(E[2])/Q) = S_3)
\\ companion to descent-s3.typ.  Run from this directory:
\\     gp -q -s 4000000000 descent-s3.gp < /dev/null > results/descent-s3.txt
\\
\\ For each curve it reports, in the order the document develops them:
\\   (1) the cubic f with y^2 = f(x), its discriminant, and the Galois type;
\\   (2) that E(Q)[2] = 0 and that there is NO rational 2-isogeny -- so no
\\       partial descent over Q is available;
\\   (3) the cubic field K = Q[x]/f: discriminant, signature, class group, units;
\\   (4) S, the primes of K above it, and dim K(S,2);
\\   (5) the norm condition, as an F_2-linear map, and the resulting bound
\\       dim Sel_2 <= dim ker(N) -- the answer BEFORE any local condition;
\\   (6) the local conditions dim L_v, from Lemma B' of selmer-involution.typ;
\\   (7) the true dim Sel_2 from ellrank, and the gap dim Sha[2].

\\ ---------------------------------------------------------------- the cubic

\\ y^2 = f(x) for f = x^3 + b2 x^2 + 8 b4 x + 16 b6 : the standard model got
\\ from (4y + a1 x + a3)^2 = ... by X = 4x, Y = 4(2y + a1 x + a3).
cubicf(E) = { x^3 + E.b2*x^2 + 8*E.b4*x + 16*E.b6 };

galtype(f) =
{ if (!polisirreducible(f), return("REDUCIBLE (f has a rational root)"));
  if (issquare(poldisc(f)), "A_3 = C_3 (cyclic)", "S_3 (generic)");
};

\\ ------------------------------------------------- local condition at a place

\\ dim_F2 E[2](Q_v) = dim of the F_2-span of the roots of f in Q_v,
\\ which is 0, 1 or 2 according as f has 0, 1 or 3 roots there.
dimtors2p(f, p) =
{ my(F = factorpadic(f, p, 60), n = 0);
  for (i = 1, #F~, if (poldegree(F[i,1]) == 1, n += F[i,2]));
  min(n, 2);
};

dimtors2R(f) = { if (#polrootsreal(f) == 1, 1, 2) };

\\ Lemma B': dim L_v = dim M^{G_v} for finite v != 2, +1 at v = 2, -1 at oo.
dimLv(f, p) = { dimtors2p(f, p) + if (p == 2, 1, 0) };
dimLoo(f)   = { dimtors2R(f) - 1 };

\\ dim_F2 Cl_S(K)[2], where Cl_S = Cl(K) modulo the classes of the primes in S.
\\ For a finite abelian group A = Z^n/M one has dim A[2] = n - rank_F2(M mod 2).
dimClS2(bnf, pr) =
{ my(cyc = bnf.clgp.cyc, n = #cyc, M);
  if (n == 0, return(0));
  M = matdiagonal(vector(n, i, cyc[i]));
  for (i = 1, #pr, M = concat(M, bnfisprincipal(bnf, pr[i])[1]));
  n - matrank(M * Mod(1, 2));
};

\\ --------------------------------------------------- Q(S,2) as an F_2 vector

\\ coordinates of a rational square class in the basis (-1, p_1, ..., p_k)
qvec(a, S) =
{ my(c = core(a), v = vector(#S + 1));
  v[1] = if (c < 0, 1, 0);
  c = abs(c);
  for (i = 1, #S, v[i+1] = valuation(c, S[i]) % 2);
  v;
};

\\ ------------------------------------------------------------- the main report

report(coeffs, name) =
{ my(E, f, bnf, S, pr, su, gens, M, ker, r, dsel, dKS2, dcls, bnd);
  E = ellinit(coeffs);
  f = cubicf(E);
  print("======================================================================");
  print(name, "   ", coeffs, "   conductor ", ellglobalred(E)[1]);
  print("");
  print("(1) y^2 = f(x),  f = ", f);
  print("    disc f  = ", factor(poldisc(f)));
  print("    Galois  : ", galtype(f));
  print("");
  print("(2) E(Q)_tors        = ", elltors(E)[1], "   (so E(Q)[2] = 0)");
  print("    isogeny degrees  = ", ellisomat(E, 0, 1)[2],
        "   (no 2 among them: no partial descent over Q)");
  print("");
  bnf = bnfinit(polredbest(f), 1);
  print("(3) K = Q[x]/f : disc ", bnf.disc, "   signature ", bnf.sign,
        "   Cl(K) = ", bnf.clgp.cyc, "   unit rank ", #bnf.fu);
  print("");
  S = factor(2*abs(E.disc))[,1];
  pr = [];
  print("(4) S = ", S~);
  for (i = 1, #S,
    my(D = idealprimedec(bnf, S[i]));
    print("      ", S[i], " -> ", #D, " prime(s) of K,  e = ",
          [D[j].e | j <- [1..#D]], "  f = ", [D[j].f | j <- [1..#D]]);
    pr = concat(pr, D));
  dcls = dimClS2(bnf, pr);
  dKS2 = bnf.sign[1] + bnf.sign[2] + #pr + dcls;
  print("    #S_f = ", #pr, "     dim K(S,2) = (r1+r2) + #S_f + dim Cl_S[2] = ",
        bnf.sign[1] + bnf.sign[2], " + ", #pr, " + ", dcls, " = ", dKS2);
  print("");
  \\ Generators of the S-UNIT part of K(S,2): -1, the fundamental units, and
  \\ the S-unit generators.  These span the kernel of K(S,2) ->> Cl_S[2], so
  \\ the norm-kernel on all of K(S,2) exceeds the one computed here by at
  \\ most dim Cl_S[2].  That is what the bound below reports.
  su = bnfsunit(bnf, pr);
  gens = concat([-1], concat(bnf.fu, [nfbasistoalg(bnf, g) | g <- su[1]]));
  print("(5) norms of the ", #gens, " S-unit generators, modulo squares:");
  M = matrix(#S + 1, #gens);
  for (i = 1, #gens,
    my(n = nfeltnorm(bnf, gens[i]), v = qvec(n, S));
    print("      g", i, "  N = ", n, "   core ", core(n), "   coords ", v);
    for (j = 1, #S + 1, M[j,i] = Mod(v[j], 2)));
  ker = matker(M);
  print("    on the S-unit part the norm map has rank ", #gens - #ker,
        ", so its kernel has dim ", #ker);
  if (dcls == 0,
    print("    Cl_S[2] = 0, so this IS the norm kernel on K(S,2)");
    print("    ==> dim Sel_2 <= ", #ker, "   (before ANY local condition)")
  ,
    print("    dim Cl_S[2] = ", dcls, ", so the norm kernel on K(S,2) has dim <= ",
          #ker + dcls);
    print("    ==> dim Sel_2 <= ", #ker + dcls, "   (before ANY local condition)"));
  bnd = #ker + dcls;
  print("");
  print("(6) local conditions:");
  for (i = 1, #S,
    print("      v = ", S[i], "   dim E[2](Q_v) = ", dimtors2p(f, S[i]),
          "   dim L_v = ", dimLv(f, S[i])));
  print("      v = oo  dim E[2](R)   = ", dimtors2R(f),
        "   dim L_oo = ", dimLoo(f));
  print("");
  r = ellrank(E);
  dsel = r[1] + r[3];
  print("(7) ellrank : rank in [", r[1], ", ", r[2], "],  dim Sha[2] = ", r[3]);
  print("    dim Sel_2 = rank + dim Sha[2] + dim E(Q)[2] = ",
        r[1], " + ", r[3], " + 0 = ", dsel);
  print("    the local conditions cut ", bnd, " down to ", dsel);
  print("");
};

\\ ------------------------------------------------------------ descent by hand

\\ 37a1 : the generator is (0,0) on y^2 + y = x^3 - x, i.e. (X,Y) = (0,4)
\\ on Y^2 = X^3 - 16X + 16.  Its descent image is X - theta = -theta.
byhand() =
{ my(f = x^3 - 16*x + 16, K, th, nrm);
  print("======================================================================");
  print("the descent map on 37a1, by hand");
  print("");
  K = nfinit(subst(f, x, y));          \\ field in y so that x stays free
  th = Mod(y, subst(f, x, y));
  print("  P = (0,0) on y^2 + y = x^3 - x   maps to   (X,Y) = (0,4) on Y^2 = ", f);
  print("  delta(P) = X - theta = -theta");
  nrm = nfeltnorm(K, -th);
  print("  N(-theta) = ", nrm, "   a square in Q? ", issquare(nrm),
        "     (it must be: N(x - theta) = f(x) = Y^2)");
  print("  is -theta a square in K?  roots of X^2 + theta : ",
        nfroots(K, x^2 + y), "   (empty = not a square, so delta(P) != 1)");
  print("  (theta) is supported above 2 since N(theta) = ", nfeltnorm(K, th),
        ", so -theta lies in K(S,2)");
  print("  hence Sel_2(37a1) = <-theta>, of dimension 1, and rank = 1, Sha[2] = 0");
  print("");
};

\\ ------------------------------------------------------------------------ run

report([0,0,1,-1,0],           "37a1   -- rank 1, Sha[2] = 0");
report([0,-1,1,-929,-10595],   "571a1  -- rank 0, Sha[2] = (Z/2)^2");
report([0,1,1,-2,0],           "389a1  -- rank 2, Sha[2] = 0");
byhand();
quit;
