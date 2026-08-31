\\ j0-obstruction-family.gp -- checks for j0-obstruction-family.typ
\\
\\ Run from this directory:
\\     gp -q -s 6000000000 j0-obstruction-family.gp < /dev/null \
\\         > results/j0-obstruction-family.txt
\\
\\ kummer-example-j0.typ proves that X = Kum(E x E') is not 2-adically dense
\\ for E : y^2 = x^3 + 9 and E' : y^2 = x^3 - 81.  This asks which pairs of
\\ j = 0 curves the argument generalises to, and searches for them.
\\
\\ Write E_a : y^2 = x^3 + a.  The structural conditions are derived in the
\\ note; the ones that can be tested are
\\
\\   (i)   a = 1 mod 8 and a' = 7 mod 8   -- makes the local pair at 2
\\         isomorphic to the example's, so beta_2 != 0 exactly on the even
\\         square classes;
\\   (ii)  x^3+a irreducible and Q[x]/(x^3+a) = Q[x]/(x^3+a')  -- E[2] = E'[2];
\\   (iii) v_3(a), v_3(a') != 0 mod 3   -- W_3 = 0, so beta_3 = 0;
\\   (iv)  no odd q has v_q(a) = 3 mod 6  -- keeps E_d ADDITIVE at every q | d,
\\         which is what makes L_q the span of the 2-torsion classes;
\\   (v)   E, E' not isogenous.
\\
\\ Condition (E) of the criterion -- beta_q = 0 at every q != 2 -- does NOT
\\ follow from these, and check 4 is the search that finds which pairs it
\\ survives for.

default(realprecision, 20);

sixfree(a) = { my(s = sign(a), f = factor(abs(a)), r = 1);
  for (i = 1, matsize(f)[1], r *= f[i,1]^(f[i,2] % 6)); s*r; };

\\ is z a 6th power in Q_2^* ?
is6th2(z) = { my(v = valuation(z,2), u); if (v % 6, return(0)); u = z/2^v; ((u%8)+8)%8 == 1; };

\\ (iv): no odd prime divides a to an exponent = 3 mod 6
efilter(a) = { my(f = factor(abs(a)));
  for (i = 1, matsize(f)[1], if (f[i,1] != 2 && f[i,2] % 6 == 3, return(0))); 1; };

isog(a, b) = { my(E = ellinit([0,0,0,0,a]), F = ellinit([0,0,0,0,b]), q = 5);
  while (q < 300, if (a % q && b % q, if (ellap(E,q) != ellap(F,q), return(0)));
                  q = nextprime(q+1)); 1; };

cond(a, ap) =
{ if (a % 2 == 0 || ap % 2 == 0, return(0));
  if (((a%8)+8)%8 != 1 || ((ap%8)+8)%8 != 7, return(0));
  if (!polisirreducible(x^3+a) || !polisirreducible(x^3+ap), return(0));
  if (!nfisisom(x^3+a, x^3+ap), return(0));
  if (valuation(a,3)%3 == 0 || valuation(ap,3)%3 == 0, return(0));
  if (!efilter(a) || !efilter(ap), return(0));
  if (isog(a, ap), return(0));
  1; };

\\ local x-coordinates at q on y^2 = x^3 + A
sq2(r) = { if (r == 0, return(0)); my(v = valuation(r,2), u); if (v%2, return(0));
           u = r/2^v; ((numerator(u)*denominator(u))%8+8)%8 == 1; };
sqq(r,q) = { if (r == 0, return(0)); my(v = valuation(r,q), u); if (v%2, return(0));
             u = r/q^v; issquare(Mod(numerator(u)*denominator(u), q)); };
locx(A, q, XB) = { my(L = List());
  for (n = -XB, XB, if (if (q == 2, sq2(n^3+A), sqq(n^3+A,q)), listput(L, n))); Vec(L); };

\\ beta_q on sampled local points.  K = Q(alpha), alpha^3 = a.
\\   branch "aa' cube":  classes  x + d.alpha  and  x' + d.c/alpha,  c^3 = a.a'
\\   branch "a'/a cube": classes  x + d.alpha  and  x' + d.k.alpha,  k^3 = a'/a
beta(a, ap, d, q, XB) =
{ my(K = nfinit(x^3 - a), Pq = idealprimedec(K, q), al = Mod(x, x^3 - a), sec, X, Y, nz = 0);
  if (ispower(a*ap, 3),
      sec = sqrtnint(abs(a*ap),3) * sign(a*ap) / al,
      sec = (sqrtnint(abs(ap/a),3) * sign(ap/a)) * al);
  X = locx(a*d^3, q, XB); Y = locx(ap*d^3, q, XB);
  for (i = 1, #X, for (j = 1, #Y,
    my(u = X[i] + d*al, v = Y[j] + d*sec, s = 1);
    if (u == 0 || v == 0, next);
    for (m = 1, #Pq, s *= nfhilbert(K, lift(u), lift(v), Pq[m]));
    if (s != 1, nz++)));
  nz;
};

\\ ---------------------------------------------------------------- check 1
\\ The local-at-2 transfer.  a = 1 (mod 8) makes a a 6th power in Q_2^*, so
\\ E_{a d^3} = E_{d^3} over Q_2; a' = 7 (mod 8) makes -a' one, so
\\ E'_d = E_{-d}.  The pair at 2 is then the example's pair verbatim, and its
\\ Theorem (section 6.8 of kummer-example-j0.typ) applies unchanged.

check1() =
{ my(P = [[9,-81],[9,-9],[33,-33],[225,15],[-15,-225],[105,-105],[-63,63]], bad = 0);
  printf("  (1) the local-at-2 transfer\n");
  printf("      %-8s %-9s %-9s %-10s %-10s %s\n", "a", "a'", "a mod 8", "a' mod 8", "a 6th pow", "-a' 6th pow");
  for (i = 1, #P,
    my(a = P[i][1], ap = P[i][2], u = is6th2(a), v = is6th2(-ap));
    if (!u || !v, bad++);
    printf("      %-8d %-9d %-9d %-10d %-10d %d\n", a, ap, ((a%8)+8)%8, ((ap%8)+8)%8, u, v));
  printf("      failures : %d\n", bad);
};

\\ ---------------------------------------------------------------- check 2
\\ beta_2 itself, by Hilbert symbols over K, reproducing the note's table for
\\ the known pair and extending it.  Zero on the odd square classes and
\\ non-zero on the even ones is the signature.

check2() =
{ my(P = [[9,-81],[225,15],[9,-9],[33,-33]], D = [1,-7,3,2,-6,10], bad = 0);
  printf("  (2) beta_2 by Hilbert symbols (0 = zero, 1 = non-zero)\n");
  printf("      %-8s %-9s %s\n", "a", "a'", Str("d = ", D));
  for (i = 1, #P,
    my(a = P[i][1], ap = P[i][2], row = vector(#D, j, beta(a, ap, D[j], 2, 110) > 0));
    printf("      %-8d %-9d %s\n", a, ap, Str(row)));
  printf("      the known pair (9,-81) reproduces section 6.9 of kummer-example-j0.typ:\n");
  printf("      zero on d = 1,-7,3 (odd) and non-zero on d = 2,-6,10 (even)\n");
};

\\ ---------------------------------------------------------------- check 3
\\ Isotropy of the local Kummer image -- the soundness test for the symbol
\\ machinery.  Pairing two points of the SAME curve must give zero.

check3() =
{ my(bad = 0, tot = 0);
  printf("  (3) isotropy of L_2 (soundness of the symbols)\n");
  for (i = 1, 4,
    my(ad = [[9,1],[9,2],[33,1],[225,2]][i], a = ad[1], d = ad[2],
       K = nfinit(x^3-a), P2 = idealprimedec(K,2), al = Mod(x,x^3-a), X, nz = 0, n = 0);
    X = locx(a*d^3, 2, 90);
    for (j = 1, #X, for (k = 1, #X,
      my(u = X[j]+d*al, v = X[k]+d*al, s = 1);
      if (u == 0 || v == 0, next);
      for (m = 1, #P2, s *= nfhilbert(K, lift(u), lift(v), P2[m]));
      n++; if (s != 1, nz++)));
    bad += nz; tot += n;
    printf("      a=%-5d d=%-3d : %d non-zero of %d symbols\n", a, d, nz, n));
  printf("      total non-zero (must be 0) : %d of %d\n", bad, tot);
};

\\ ---------------------------------------------------------------- check 4
\\ THE SEARCH.  Pairs meeting (i)-(v), then swept for condition (E) at the
\\ odd primes q | d.  The mechanism of the note guarantees L_q is spanned by
\\ the 2-torsion classes; what it does NOT guarantee is that psi matches those
\\ classes, and that is what the sweep tests.

check4(B, QB) =
{ my(n = 0, surv = 0);
  printf("  (4) the search: pairs meeting (i)-(v), swept for (E) at q <= %d\n", QB);
  printf("      %-8s %-9s %-12s %-16s %s\n", "a", "a'", "branch", "first bad q", "verdict");
  for (a = -B, B, if (a == 0 || sixfree(a) != a, next);
    for (ap = -B, B, if (ap == 0 || sixfree(ap) != ap, next);
      if (!cond(a, ap), next);
      n++;
      my(bad = 0, q = 5);
      while (q <= QB && !bad,
        if (beta(a, ap, q, q, 130) > 0 || beta(a, ap, -q, q, 130) > 0, bad = q);
        q = nextprime(q+1));
      if (!bad, surv++);
      printf("      %-8d %-9d %-12s %-16s %s\n", a, ap,
             if (ispower(a*ap,3), "aa' cube", "a'/a cube"),
             if (bad, Str("q = ", bad), "none"),
             if (bad, "(E) fails", "SURVIVES"))));
  printf("      %d pairs meet (i)-(v); %d survive the sweep\n", n, surv);
};

\\ ---------------------------------------------------------------- check 5
\\ The filter of condition (iv) earns its place: (9, 375) meets every other
\\ condition, has the right beta_2, and fails (E) at q = 5 -- because
\\ v_5(375) = 3, so E'_d has GOOD reduction at 5 when 5 | d and the
\\ no-4-torsion mechanism lapses there.

check5() =
{ printf("  (5) why the reduction-type filter is needed: the pair (9, 375)\n");
  printf("      v_5(375) = %d, so v_5(375 d^3) = 6 = 0 (mod 6) when 5 || d: GOOD reduction\n",
         valuation(375,3*0+5));
  printf("      passes (i),(ii),(iii),(v): %d   passes (iv): %d\n",
         (((9%8)+8)%8 == 1) && (((375%8)+8)%8 == 7) && (nfisisom(x^3+9,x^3+375) != 0),
         efilter(375));
  printf("      beta_2 on d = 2 : %s\n", if (beta(9,375,2,2,110) > 0, "non-zero (as wanted)", "zero"));
  printf("      beta_5 on d = 10: %s\n", if (beta(9,375,10,5,130) > 0, "NON-ZERO -- (E) fails", "zero"));
  printf("      beta_5 on d = -15: %s\n", if (beta(9,375,-15,5,130) > 0, "NON-ZERO -- (E) fails", "zero"));
};


\\ ---------------------------------------------------------------- exact test
\\ THE EXACT TORSION-CLASS TEST.  By the Proposition, L_q is spanned by the
\\ classes delta_q(T), T in E[2](Q_q).  So psi_* L'_q = L_q can be decided on
\\ the torsion alone -- no sampling.  For the quadratic-twist branch a' = -a
\\ the roots satisfy s_i = -r_i and psi(s_i) = r_i, so
\\
\\     psi_* delta'(T'_i) / delta(T_i)  =  (1 in slot i, -1 in the other two).
\\
\\ The twisting parameter surfaces as the ratio.  It is a square exactly when
\\ -1 is, so the danger zone is q = 1 mod 3 (cubic split) AND q = 3 mod 4.

PRC = 40;
cl2(z, q) = { my(v = valuation(z,q), u = z/q^v);
              [v % 2, if (issquare(Mod(truncate(u), q)), 0, 1)]; };
delT(R, i, q) = { my(P = 1, C = vector(#R));
  for (j = 1, #R, if (j != i, P *= (R[i]-R[j])));
  for (j = 1, #R, C[j] = if (j == i, cl2(P,q), cl2(R[i]-R[j], q))); concat(C); };
add2(u,v) = vector(#u, i, (u[i]+v[i]) % 2);
inspan2(U,V,c) = { my(Z = vector(#U)); c == Z || c == U || c == V || c == add2(U,V); };

\\ 0 / 1 / 2 = equal (with dim W_q), -1 = different
verdict(a, d, q) =
{ my(R = polrootspadic(x^3 + a*d^3, q, PRC), U, V, C1, C2, m1);
  if (#R == 0, return(0));
  if (#R == 1, return(1));
  U = delT(R,1,q); V = delT(R,2,q); m1 = cl2(-1 + O(q^PRC), q);
  C1 = concat(vector(3, j, if (j == 1, [0,0], m1)));
  C2 = concat(vector(3, j, if (j == 2, [0,0], m1)));
  if (inspan2(U,V,C1) && inspan2(U,V,C2), 2, -1);
};

\\ ---------------------------------------------------------------- check 6
\\ The diagnosis.  delta restricted to E[2](Q_q) is the connecting map of
\\ 0 -> E[2] -> E[4] -> E[2] -> 0, so it remembers E[4], which psi does not
\\ see.  The three regimes, exactly.

check6() =
{ my(T = [[225,-7,7],[33,31,31],[9,61,61],[9,5,5],[9,7,7],[105,139,139]], bad = 0);
  printf("  (6) the three regimes of the torsion-class comparison\n");
  printf("      %-6s %-6s %-5s %-9s %-8s %-8s %s\n",
         "a","d","q","q mod 12","dim W_q","-1 sq?","psi_* L'_q vs L_q");
  for (i = 1, #T,
    my(a = T[i][1], d = T[i][2], q = T[i][3], v = verdict(a,d,q), n = #polrootspadic(x^3+a*d^3,q,PRC));
    printf("      %-6d %-6d %-5d %-9d %-8d %-8d %s\n", a, d, q, q%12,
           if (n == 0, 0, if (n == 1, 1, 2)), (q%4) == 1,
           if (v < 0, "DIFFERENT", "equal")));
  printf("      dim W_q = 1 is always equal: -1 is a square in the unramified quadratic\n");
  printf("      dim W_q = 2 needs -1 square in Q_q, i.e. q = 1 mod 4\n");
};

\\ ---------------------------------------------------------------- check 7
\\ The corrected sweep.  Every quadratic-twist pair fails, at the first prime
\\ q = 7 mod 12 at which x^3 - a splits.  An earlier version of this script
\\ sampled local points to evaluate beta_q and reported survivors; that
\\ sampling under-covers Q_q as q grows and the survivors were spurious.

check7(QB) =
{ my(AS = [9, 33, 81, 105, 129, 177, 249, -39, -63, -87, -159, -207, -231, 57, 153, 225],
    surv = 0);
  printf("  (7) exact sweep of condition (E), branch a' = -a, q <= %d\n", QB);
  printf("      %-8s %-18s %-10s %s\n", "a", "first bad q", "q mod 12", "verdict");
  for (i = 1, #AS,
    my(a = AS[i], bad = 0, q = 5);
    while (q <= QB && !bad,
      if (a % q, if (verdict(a,q,q) < 0 || verdict(a,-q,q) < 0, bad = q));
      q = nextprime(q+1));
    if (!bad, surv++);
    printf("      %-8d %-18s %-10s %s\n", a,
           if (bad, Str("q = ", bad), Str("none up to ", QB)),
           if (bad, Str(bad % 12), "--"),
           if (bad, "(E) FAILS", "no failure yet")));
  printf("      survivors: %d of %d -- the branch does not work\n", surv, #AS);
  printf("      the first bad q is = 7 (mod 12) in every case\n");
};


\\ ---------------------------------------------------------------- check 8
\\ The criterion: if Q(sqrt d) is inside Q(E[2]) = Q(zeta_3, a^(1/3)) then
\\ beta_q = 0 at every odd q.  For j = 0 that field is S_3 with unique
\\ quadratic subfield Q(sqrt -3), so the candidate is d = -3.  It works -- and
\\ it also kills beta_2, which is the dichotomy.

verdD(a, d, q, DL) =
{ my(R = polrootspadic(x^3 + a*d^3, q, PRC), U, V, C1, C2, c);
  if (#R == 0, return(0)); if (#R == 1, return(1));
  U = delT(R,1,q); V = delT(R,2,q); c = cl2(DL + O(q^PRC), q);
  C1 = concat(vector(3, j, if (j == 1, [0,0], c)));
  C2 = concat(vector(3, j, if (j == 2, [0,0], c)));
  if (inspan2(U,V,C1) && inspan2(U,V,C2), 2, -1); };
sweepD(a, DL, QB) =
{ my(bad = 0, q = 5);
  while (q <= QB && !bad,
    if (a % q, if (verdD(a,q,q,DL) < 0 || verdD(a,-q,q,DL) < 0, bad = q));
    q = nextprime(q+1)); bad; };

check8() =
{ printf("  (8) the criterion Q(sqrt d) inside Q(E[2]), i.e. d = -3 modulo squares\n");
  printf("      %-7s %-12s %-12s %-12s %-12s %s\n", "a", "twist -1", "twist 3", "twist 5", "twist -7", "twist -3");
  for (i = 1, 5,
    my(a = [9, 81, 105, 129, 33][i]);
    printf("      %-7d %-12s %-12s %-12s %-12s %s\n", a,
      Str("q=", sweepD(a,-1,400)), Str("q=", sweepD(a,3,400)),
      Str("q=", sweepD(a,5,400)), Str("q=", sweepD(a,-7,400)),
      if (sweepD(a,-3,400) == 0, "NONE up to 400", Str("q=", sweepD(a,-3,400)))));
  printf("      (entries are the first odd q at which condition (E) fails)\n");
  printf("      but the same twist makes beta_2 vanish too:\n");
  for (i = 1, 4,
    my(t = [[9,1],[9,2],[105,1],[33,2]][i]);
    printf("        a = %-5d d = %-3d : beta_2 %s\n", t[1], t[2],
      if (beta(t[1], t[1]*(-3)^3, t[2], 2, 100) > 0, "NON-ZERO", "zero")));
  printf("      so the branch is a dichotomy: (E) at odd q and beta_2 != 0 are incompatible\n");
};


\\ ---------------------------------------------------------------- check 9
\\ THE CORRECTED CRITERION.  What the conclusion needs is not "Sigma = {2}"
\\ but: Sigma = {v : psi_* L'_v != L_v} finite and INDEPENDENT OF d, and
\\ non-empty.  Then X(Q) is not dense in the product of the X(Q_q), q in Sigma.
\\
\\ For a pair with full rational 2-torsion, E : y^2 = x(x-m)(x-n), everything
\\ is global: the descent algebra is Q x Q x Q, Aut(E[2]) = S_3 permutes the
\\ three slots, so there are SIX psi to choose from, and the torsion classes
\\ are rational triples.  Twisting by d multiplies slot k of delta(T_i) by d
\\ for k != i, so
\\
\\     beta_v^(d)(T_i,T'_j) = beta_v^(1)(T_i,T'_j) . (d, M_ij)_v ,
\\     M_ij = (prod_{s(k) != j} u_ik) . (prod_{k != i} v_j,s(k)) . (-1)^(1+[s(i)=j]) ,
\\
\\ so beta_v is independent of d exactly where M_ij is a local square.  Hence
\\
\\     Sigma  =  S_1  union  S_2 ,
\\     S_1 = {v : beta_v^(1) != 0},   S_2 = {v : some M_ij is not a square in Q_v},
\\
\\ which is finite, computable, and independent of d.  Reciprocity on the
\\ torsion classes forces |S_1| != 1.

dT3(m,n) = [ [m*n,-m,-n], [m,m*(m-n),m-n], [n,n-m,n*(n-m)] ];
sqf(z) = { my(g = sign(z), f = factor(abs(z)), r = 1);
  for (i=1,matsize(f)[1], r *= f[i,1]^(f[i,2]%2)); g*r; };
MM(A,B,s,i,j) = { my(P=1,Q=1,C);
  for (k=1,3, if (s[k]!=j, P *= A[i][k]));
  for (k=1,3, if (k!=i, Q *= B[j][s[k]]));
  C = 1 + (s[i]==j); sqf(P*Q*(-1)^C); };
plc3(m,n,mp,np) = { my(L=List([0,2]), D=m*n*(m-n)*mp*np*(mp-np), f=factor(abs(D)));
  for (i=1,matsize(f)[1], if (f[i,1]!=2, listput(L,f[i,1]))); Vec(L); };
Sig1(m,n,mp,np,s) = { my(A=dT3(m,n), B=dT3(mp,np), PL=plc3(m,n,mp,np), S=List());
  for (t=1,#PL, my(v=PL[t], bad=0);
    for (i=1,3, for (j=1,3, my(p=1);
      for (k=1,3, p *= hilbert(A[i][k], B[j][s[k]], v));
      if (p!=1, bad=1)));
    if (bad, listput(S,v)));
  Set(Vec(S)); };
Sig2(m,n,mp,np,s) = { my(A=dT3(m,n), B=dT3(mp,np), L=List());
  for (i=1,3, for (j=1,3, my(M=MM(A,B,s,i,j));
    if (M != 1, if (M<0, listput(L,0));
      my(f=factor(abs(M))); for (t=1,matsize(f)[1], listput(L,f[t,1]));
      listput(L,2))));
  Set(Vec(L)); };
S3P = [[1,2,3],[1,3,2],[2,1,3],[2,3,1],[3,1,2],[3,2,1]];
nonisog(m,n,mp,np) = { my(E=ellinit([0,-(m+n),0,m*n,0]), F=ellinit([0,-(mp+np),0,mp*np,0]), q=3);
  if (E==0 || F==0, return(0));
  while (q<200, if (ellap(E,q)!=ellap(F,q), return(1)); q=nextprime(q+1)); 0; };

check9() =
{ my(C = [[1,2],[1,3],[1,4],[2,3],[1,-1],[1,5],[2,5],[1,6],[3,4],[1,-2],[2,-1],[1,9],[1,-3],[3,5],[1,8],[4,5]],
    best = 99, res = List(), tot = 0);
  printf("  (9) full rational 2-torsion: minimising Sigma = S_1 union S_2\n");
  for (i=1,#C, for (j=i+1,#C,
    my(m=C[i][1], n=C[i][2], mp=C[j][1], np=C[j][2]);
    if (m*n*mp*np*(m-n)*(mp-np) == 0, next);
    if (!nonisog(m,n,mp,np), next);
    for (t=1,6, tot++;
      my(SS = setunion(Sig1(m,n,mp,np,S3P[t]), Sig2(m,n,mp,np,S3P[t])));
      if (#SS == 0, next);
      if (#SS < best, best = #SS; res = List());
      if (#SS == best, listput(res, [m,n,mp,np,t,SS])))));
  printf("      %d (pair, psi) scanned; smallest non-empty Sigma has size %d\n", tot, best);
  for (k=1, min(#res,6), my(r=res[k]);
    printf("      x(x-%d)(x-%d) / x(x-%d)(x-%d)  psi = %s  Sigma = %s\n",
           r[1],r[2],r[3],r[4], Str(S3P[r[5]]), Str(r[6])));
  printf("      |S_1| = 1 never occurs: reciprocity on the torsion classes forbids it\n");
};

print("======================================================================");
print("j0-obstruction-family.gp -- how far the j=0 obstruction generalises");
print("");
check1(); print("");
check2(); print("");
check3(); print("");
check5(); print("");
check4(250, 31); print("");
check6(); print("");
check7(200); print("");
check8(); print("");
check9(); print("");
print("======================================================================");
