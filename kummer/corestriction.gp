\\ corestriction.gp -- checks for corestriction.typ
\\
\\ Run from this directory:
\\     gp -q -s 2000000000 corestriction.gp < /dev/null > results/corestriction.txt
\\
\\ Everything here tests the Theorem of section 5 and the two corollaries of
\\ section 5.1, on two etale algebras:
\\     A = Q[x]/(x^3 - 16x + 16)   the cubic field of 37a1  (a field)
\\     B = Q x Q(i)                a genuinely decomposable one
\\ The pairing under test is
\\     <alpha,beta>_v = prod_{w | v} (alpha_w, beta_w)_{A_w}.

\\ ---------------------------------------------------------------- local symbols

hilbR(a, b) = { if (a < 0 && b < 0, -1, 1) };

\\ product of Hilbert symbols over the places of the number field K above p
corsym(K, a, b, p) =
{ my(D = idealprimedec(K, p), s = 1);
  for (i = 1, #D, s *= nfhilbert(K, a, b, D[i]));
  s;
};
\\ and over the real places
corsymoo(K, a, b) =
{ my(ra = nfeltembed(K, a), rb = nfeltembed(K, b), s = 1);
  for (i = 1, #ra, if (real(ra[i]) < 0 && real(rb[i]) < 0, s = -s));
  s;
};

\\ ------------------------------------------------------------------ the algebra

f = y^3 - 16*y + 16;                 \\ A = Q[y]/f, the cubic field of 37a1
K = nfinit(f);
th = Mod(y, f);

VS = [2, 3, 5, 7, 11, 13, 37, 101];  \\ finite places to test

\\ test classes: -1, the units, the S-units, and a few x - theta
tests() =
{ my(bnf = bnfinit(f,1), pr, su, g);
  pr = concat(idealprimedec(K,2), idealprimedec(K,37));
  su = bnfsunit(bnf, pr);
  g = concat([Mod(-1,f)], [Mod(u,f) | u <- bnf.fu]);
  g = concat(g, [Mod(nfbasistoalg(K,h),f) | h <- su[1]]);
  concat(g, [-th, 1-th, 2-th, -2*th]);
};

\\ ------------------------------------------------------------------- the checks

\\ (P2) + degree 1 is the norm:  <alpha, b> = (N alpha, b) for rational b
checkP2(g) =
{ my(bad = 0, bs = [-1, 2, 3, 37, -74]);
  for (i = 1, #g,
    my(a = g[i], n = nfeltnorm(K, a));
    for (j = 1, #bs,
      my(b = bs[j]);
      for (t = 1, #VS,
        if (corsym(K, a, Mod(b,f), VS[t]) != hilbert(n, b, VS[t]), bad++));
      if (corsymoo(K, a, Mod(b,f)) != hilbR(n, b), bad++)));
  printf("  (P2) <alpha,b> = (N alpha, b) for rational b : %d discrepancies in %d symbols\n",
         bad, #g * #bs * (#VS + 1));
};

\\ (P1) cor . res = dim_k A : both slots rational
checkP1() =
{ my(bad = 0, as = [-1, 2, 3, -5, 7, 11, -13, 37, 101, -74]);
  for (i = 1, #as, for (j = 1, #as,
    my(a = as[i], b = as[j]);
    for (t = 1, #VS,
      \\ prod_w (a,b)_{A_w} should be (a,b)_v ^ (sum_w [A_w:Q_v]) = (a,b)_v^3
      if (corsym(K, Mod(a,f), Mod(b,f), VS[t]) != hilbert(a,b,VS[t])^3, bad++));
    if (corsymoo(K, Mod(a,f), Mod(b,f)) != hilbR(a,b)^3, bad++)));
  printf("  (P1) prod_w (a,b)_{A_w} = (a,b)_v^3 for rational a,b : %d discrepancies in %d symbols\n",
         bad, #as^2 * (#VS + 1));
};

\\ reciprocity: the local invariants sum to zero
checkrecip(g) =
{ my(bad = 0);
  for (i = 1, #g, for (j = 1, #g,
    my(s = corsymoo(K, g[i], g[j]));
    for (t = 1, #VS, s *= corsym(K, g[i], g[j], VS[t]));
    if (s != 1, bad++)));
  printf("  reciprocity  prod_v prod_{w|v} (a,b)_w = 1 : %d failures in %d pairs\n",
         bad, #g^2);
};

\\ the decomposable algebra B = Q x Q(i): the pairing is a product of two symbols,
\\ one over Q and one over Q(i).  Check (P2) there too, where N_{B/Q}(a1,a2) = a1*N(a2).
checkB() =
{ my(L = nfinit(y^2 + 1), bad = 0, n = 0,
     a1 = [-1, 2, 3, 5, -7], a2 = [Mod(1+y, y^2+1), Mod(2,y^2+1), Mod(y,y^2+1), Mod(3+2*y,y^2+1)],
     bs = [-1, 2, 5, -3]);
  for (i = 1, #a1, for (j = 1, #a2, for (m = 1, #bs,
    my(b = bs[m], nrm = a1[i] * nfeltnorm(L, a2[j]), lhs, rhs);
    for (t = 1, #VS,
      lhs = hilbert(a1[i], b, VS[t]);
      my(D = idealprimedec(L, VS[t]));
      for (s = 1, #D, lhs *= nfhilbert(L, a2[j], Mod(b, y^2+1), D[s]));
      rhs = hilbert(nrm, b, VS[t]);
      n++; if (lhs != rhs, bad++)))));
  printf("  (P2) over B = Q x Q(i) : %d discrepancies in %d symbols\n", bad, n);
};

\\ Degree 1 is the norm, recovered rather than assumed.  cor(alpha) is the square
\\ class of Q^* characterised by (cor alpha, b)_v = prod_w (alpha_w, b)_w for all
\\ b and all v.  Solve for it by brute force over the square classes supported on
\\ {-1, 2, 37} and check the answer is core(N_{A/Q} alpha).
checkdeg1(g) =
{ my(basis = [-1, 2, 37], cls = [], bad = 0, amb = 0,
     bs = [-1, 2, 3, 5, 7, 37, -74, 101]);
  forvec(e = vector(#basis, i, [0,1]),
    my(c = 1); for (i = 1, #basis, if (e[i], c *= basis[i])); cls = concat(cls, [c]));
  for (i = 1, #g,
    my(a = g[i], n = core(nfeltnorm(K, a)), sol = []);
    for (t = 1, #cls,
      my(c = cls[t], ok = 1);
      for (j = 1, #bs, my(b = bs[j]);
        for (u = 1, #VS,
          if (hilbert(c, b, VS[u]) != corsym(K, a, Mod(b,f), VS[u]), ok = 0; break(2)));
        if (hilbR(c, b) != corsymoo(K, a, Mod(b,f)), ok = 0; break));
      if (ok, sol = concat(sol, [c])));
    if (#sol != 1, amb++, if (sol[1] != n, bad++)));
  printf("  degree 1: cor(alpha) recovered from its symbols = N(alpha) : %d wrong, %d ambiguous, of %d\n",
         bad, amb, #g);
};

\\ ------------------------------------------------------------------------- run

{
print("======================================================================");
print("corestriction.gp -- checks for corestriction.typ");
print("");
print("A = Q[y]/(y^3 - 16y + 16), the cubic field of 37a1; disc ", K.disc);
print("places tested: ", VS, " and oo");
print("");
my(g = tests());
print("test classes: ", #g);
print("");
checkP1();
checkP2(g);
checkrecip(g);
checkB();
checkdeg1(g);
print("");
print("All four are statements about cor: (P1) is cor . res = deg, (P2) is the");
print("projection formula together with 'cor in degree 1 is the norm', reciprocity");
print("is inv . cor = inv summed over all places, and the last recovers cor in");
print("degree 1 from the pairing alone and finds the norm, as section 3 says.");
}
quit;
