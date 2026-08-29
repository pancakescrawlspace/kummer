\\ cubic-residues.gp -- checks for cubic-residues.typ
\\
\\ Run from this directory:
\\     gp -q -s 4000000000 cubic-residues.gp < /dev/null > results/cubic-residues.txt
\\
\\ The question: for which primes p is 3 a cube modulo p?  For p = 3 and for
\\ p = 2 mod 3 the answer is "always", cubing being a bijection.  For p = 1 mod 3
\\ the answer is the classical one: write 4p = L^2 + 27 M^2 (possible, and
\\ essentially uniquely so) and ask whether 3 | M.

{iscube(q, p) = Mod(q, p)^((p-1)/3) == 1;}

\\ 4p = L^2 + 27 M^2 with L = 1 mod 3 and M > 0
{LM(p) = for (m = 1, sqrtint(4*p\27) + 1,
    my(t = 4*p - 27*m^2, L);
    if (t > 0 && issquare(t, &L),
      if ((L % 3 + 3) % 3 == 2, L = -L);
      return([L, m])));
  0;}

\\ is p represented by x^2 + x y + 61 y^2 ?  4p = (2x+y)^2 + 243 y^2
{f61(p) = for (y = 0, sqrtint(4*p\243) + 1, if (issquare(4*p - 243*y^2), return(1))); 0;}
{f243(p) = for (y = 0, sqrtint(p\243) + 1, if (issquare(p - 243*y^2), return(1))); 0;}

\\ ---------------------------------------------------------------- check 1
\\ The representation exists and is unique (up to the sign normalisation).

check1(X) =
{ my(tot = 0, none = 0, many = 0);
  forprime (p = 7, X,
    if (p % 3 != 1, next);
    tot++;
    my(s = 0);
    for (m = 1, sqrtint(4*p\27) + 1, if (issquare(4*p - 27*m^2), s++));
    if (s == 0, none++); if (s > 1, many++));
  printf("  (1) 4p = L^2 + 27M^2 for p = 1 mod 3, p < %d : %d primes,\n", X, tot);
  printf("      no representation %d times, more than one %d times\n", none, many);
};

\\ ---------------------------------------------------------------- check 2
\\ The criteria, in terms of the same L and M.  These are the classical
\\ supplements to cubic reciprocity.

check2(X) =
{ my(b2 = 0, b3 = 0, b5 = 0, b7 = 0, tot = 0);
  forprime (p = 7, X,
    if (p % 3 != 1, next);
    tot++;
    my(lm = LM(p), L = lm[1], M = lm[2]);
    if (iscube(2,p) != (M % 2 == 0),    b2++);
    if (iscube(3,p) != (M % 3 == 0),    b3++);
    if (iscube(5,p) != ((L*M) % 5 == 0), b5++);
    if (iscube(7,p) != ((L*M) % 7 == 0), b7++));
  printf("  (2) on the %d primes p = 1 mod 3 below %d:\n", tot, X);
  printf("      2 is a cube mod p  <=>  2 | M     : %d mismatches\n", b2);
  printf("      3 is a cube mod p  <=>  3 | M     : %d mismatches\n", b3);
  printf("      5 is a cube mod p  <=>  5 | L M   : %d mismatches\n", b5);
  printf("      7 is a cube mod p  <=>  7 | L M   : %d mismatches\n", b7);
};

\\ ---------------------------------------------------------------- check 3
\\ The quadratic-form phrasing.  3 | M says 4p = L^2 + 243 M'^2, which is
\\ 4 times the principal form of discriminant -243.  And the tempting
\\ x^2 + 243 y^2 -- the analogue of Gauss's x^2 + 27 y^2 for 2 -- is only
\\ SUFFICIENT: it is the principal form of the smaller order, discriminant -972.

check3(X) =
{ my(bad = 0, cub = 0, g = 0, gnot = 0, tot = 0);
  forprime (p = 7, X,
    if (p % 3 != 1, next);
    tot++;
    my(c = iscube(3,p));
    if (c, cub++);
    if (f61(p) != c, bad++);
    if (f243(p), g++; if (!c, gnot++)));
  printf("  (3) p = x^2 + xy + 61y^2  <=>  3 is a cube  : %d mismatches of %d\n", bad, tot);
  printf("      3 is a cube for %d of them; p = x^2 + 243y^2 for only %d,\n", cub, g);
  printf("      and that never fails to imply it (%d counterexamples) -- sufficient,\n", gnot);
  printf("      not necessary.   h(-243) = %d, h(-972) = %d, h(-108) = %d\n",
         qfbclassno(-243), qfbclassno(-972), qfbclassno(-108));
};

\\ ---------------------------------------------------------------- check 4
\\ No congruence can decide it.  Q(zeta_3, 3^(1/3)) is S_3 over Q, hence
\\ non-abelian, so by class field theory the splitting condition is not a
\\ congruence.  Here are the witnesses.

check4(MS, X) =
{ for (i = 1, #MS,
    my(m = MS[i], seen = Map(), wit = 0);
    forprime (p = 7, X,
      if (p % 3 != 1 || wit, next);
      my(r = p % m, c = iscube(3,p), t);
      if (mapisdefined(seen, r, &t),
        if (t[2] != c, wit = [t[1], p, r]),
        mapput(seen, r, [p, c])));
    if (wit,
      printf("      mod %-5d : %d and %d are both %d mod %d, and 3 is a cube mod %d but not mod %d\n",
             m, wit[1], wit[2], wit[3], m,
             if (iscube(3,wit[1]), wit[1], wit[2]), if (iscube(3,wit[1]), wit[2], wit[1])),
      printf("      mod %-5d : no witness below %d\n", m, X)));
  printf("  (4) witnesses above: a congruence on p cannot decide the question\n");
};

\\ ---------------------------------------------------------------- check 5
\\ Density.  These p are exactly the primes splitting completely in
\\ Q(zeta_3, 3^(1/3)), of degree 6, so Chebotarev gives density 1/6.

check5(KS) =
{ printf("  (5) density of { p : 3 is a cube mod p, p = 1 mod 3 } among all primes:\n");
  for (i = 1, #KS,
    my(X = 10^KS[i], tot = 0, cub = 0);
    forprime (p = 5, X,
      tot++;
      if (p % 3 == 1 && iscube(3,p), cub++));
    printf("      x = 10^%d : %8d of %8d primes = %.5f\n", KS[i], cub, tot, cub*1.0/tot));
  printf("      1/6 = %.5f\n", 1.0/6);
};

\\ ---------------------------------------------------------------- check 6
\\ THE GENERAL PICTURE.  Everything above is the case l = 3 of one mechanism.
\\ Let l be an odd prime, K = Q(zeta_l) (a PID for l <= 19), lambda = 1 - zeta,
\\ and p = 1 mod l.  Each prime above p is principal; normalise a generator to be
\\ PRIMARY, i.e. congruent to a rational integer mod lambda^2 -- exactly one of
\\ the l associates zeta^j pi is.  Eisenstein reciprocity then says, for a
\\ rational integer a coprime to l,
\\
\\     ( a / pi )_l  =  ( pi / a )_l ,
\\
\\ and the right-hand side is computed in the residue fields of a.  For a = q a
\\ rational prime with f = ord_l(q), q is unramified in K with residue field
\\ F_(q^f) at each of the (l-1)/f primes above it, and
\\
\\     ( pi / q )_l  =  prod_{Q | q}  ( pi mod Q )^((q^f - 1)/l) .
\\
\\ So "q is an l-th power mod p" becomes a CONGRUENCE ON pi MODULO q -- not a
\\ congruence on p, which is impossible (check 4).

{setupl(l) = my(K = bnfinit(polcyclo(l,y), 1));
  [K, idealprimedec(K,l)[1], Mod(y, polcyclo(l,y))];}

{isprimary(D, a, l) = for (c = 1, l-1, if (nfeltval(D[1], lift(a)-c, D[2]) >= 2, return(1))); 0;}

{primarize(D, a, l) = for (j = 0, l-1, my(t = a*D[3]^j); if (isprimary(D,t,l), return(t))); 0;}

\\ the symbol (pi/q)_l, returned as an exponent of zeta modulo l (0 = trivial)
{sym(D, pi, q, l) = my(K = D[1], s = 0, PD = idealprimedec(K,q));
  for (i = 1, #PD,
    my(Q = PD[i], mp = nfmodprinit(K, Q),
       t = nfmodpr(K, lift(pi), mp)^((q^Q.f - 1)/l), found = -1);
    for (a = 0, l-1, if (nfmodpr(K, lift(D[3]^a), mp) == t, found = a; break));
    if (found < 0, return(-1));
    s += found);
  s % l;}

check6(LS, QSS, XS) =
{ for (li = 1, #LS,
    my(l = LS[li], D = setupl(l), QS = QSS[li], X = XS[li]);
    printf("      l = %d, h(Q(zeta_%d)) = %d :\n", l, l, D[1].no);
    for (qi = 1, #QS,
      my(q = QS[qi], f = znorder(Mod(q,l)), g = (l-1)/f, tot = 0, bad = 0);
      forprime (p = 2*l+1, X,
        if (p % l != 1, next);
        my(pr = idealprimedec(D[1],p)[1], v = bnfisprincipal(D[1], pr, 1),
           pi = primarize(D, Mod(nfbasistoalg(D[1], v[2]), polcyclo(l,y)), l));
        if (pi == 0, next);
        tot++;
        if ((sym(D, pi, q, l) == 0) != (Mod(q,p)^((p-1)/l) == 1), bad++));
      printf("        q = %-2d : ord_%d(q) = %d, %d prime%s above q, residue field F_%d^%d : %d wrong of %d\n",
        q, l, f, g, if (g == 1, " ", "s"), q, f, bad, tot)));
  printf("  (6) q is an l-th power mod p  <=>  (pi/q)_l = 1 : counts above\n");
};

\\ ---------------------------------------------------------------- check 7
\\ Why the criterion is well defined.  pi is only determined up to units, and
\\ several associates can be primary at once -- for l = 5 both pi and
\\ (1+zeta) zeta^2 pi are.  What saves it is that every PRIMARY UNIT has trivial
\\ symbol, so the answer depends only on the ideal.  (zeta itself is not
\\ primary, which is what the normalisation is for.)

check7(LS, QSS) =
{ my(bad = 0, np = 0, nu = 0);
  for (li = 1, #LS,
    my(l = LS[li], D = setupl(l), K = D[1], z = D[3], FU = K.fu, QS = QSS[li]);
    for (s = 1, 2, for (j = 0, l-1,
      forvec (e = vector(#FU, i, [-2,2]),
        my(u = (-1)^s * z^j);
        for (i = 1, #FU, u *= Mod(nfbasistoalg(K, FU[i]), polcyclo(l,y))^e[i]);
        nu++;
        if (!isprimary(D, u, l), np++; next);
        for (qi = 1, #QS,
          if (sym(D, u, QS[qi], l) != 0, bad++))))));
  printf("  (7) primary units have trivial symbol : %d violations\n", bad);
  printf("      (%d units swept, %d of them not primary and so not tested)\n", nu, np);
};

\\ ---------------------------------------------------------------- check 8
\\ The quintic structure, for contrast with l = 3.  Q(zeta_5) has degree 4, not
\\ 2, so there is no imaginary quadratic field underneath and no BINARY
\\ quadratic form: the criterion of check 6 is the honest answer, and the
\\ classical quaternary substitute does not give a clean divisibility rule.

check8(X) =
{ my(L = nfsplitting(x^5 - 3), G, tot = 0, q = 0);
  printf("  (8) splitting field of x^5-3 has degree %d, ", poldegree(L));
  G = galoisinit(L);
  printf("Galois group %s, abelian: %s\n", galoisidentify(G), if (galoisisabelian(G,1), "yes", "NO"));
  forprime (p = 7, X, tot++; if (p % 5 == 1 && Mod(3,p)^((p-1)/5) == 1, q++));
  printf("      density of { 3 is a 5th power } below %d : %.5f   (1/20 = %.5f)\n",
         X, q*1.0/tot, 1.0/20);
};

\\ ---------------------------------------------------------------- check 9
\\ The negative result.  Dickson's quaternary system
\\     16p = x^2 + 50u^2 + 50v^2 + 125w^2 ,   xw = v^2 - 4uv - u^2 ,  x = 1 mod 5
\\ is the classical substitute for 4p = L^2 + 27M^2.  As written it does not
\\ pin the representation down -- several (u,v,w) occur for one p -- and no
\\ simple divisibility condition on it reproduces the quintic character.

{dick(p) = my(S = List(), B = sqrtint(16*p));
  for (x = -B, B,
    if ((x % 5 + 5) % 5 != 1, next);
    my(r1 = 16*p - x^2); if (r1 < 0, next);
    for (w = -sqrtint(r1\125)-1, sqrtint(r1\125)+1,
      my(r2 = r1 - 125*w^2); if (r2 < 0 || r2 % 50 != 0, next);
      my(s2 = r2/50);
      for (uu = -sqrtint(s2)-1, sqrtint(s2)+1,
        my(t = s2 - uu^2, vv); if (t < 0 || !issquare(t, &vv), next);
        for (sg = 1, 2, my(v = if (sg == 1, vv, -vv));
          if (x*w == v^2 - 4*uu*v - uu^2, listput(S, [x,uu,v,w]))))));
  Vec(S);}

check9(X) =
{ my(tot = 0, multi = 0, nm = ["3|w","3|u v","3|u v w","9|w","3|x-1"], bad = vector(5));
  forprime (p = 11, X,
    if (p % 5 != 1, next);
    my(S = dick(p), c = (Mod(3,p)^((p-1)/5) == 1));
    if (#S == 0, next);
    tot++;
    if (#Set([[abs(t[2]),abs(t[3]),abs(t[4])] | t <- S]) > 1, multi++);
    my(t = S[1], cond = [t[4]%3==0, (t[2]*t[3])%3==0, (t[2]*t[3]*t[4])%3==0,
                         t[4]%9==0, (t[1]-1)%3==0]);
    for (k = 1, 5, if (cond[k] != c, bad[k]++)));
  printf("  (9) Dickson's 16p = x^2+50u^2+50v^2+125w^2 with xw = v^2-4uv-u^2:\n");
  printf("      %d primes; %d of them admit essentially different (u,v,w)\n", tot, multi);
  for (k = 1, 5, printf("        %-10s : %d mismatches of %d\n", nm[k], bad[k], tot));
  printf("      -- no clean divisibility rule, unlike 3 | M at l = 3\n");
};

\\ a small table, for the eye
table(X) =
{ forprime (p = 7, X,
    if (p % 3 != 1, next);
    my(lm = LM(p));
    printf("      p = %-4d  4p = %4d = (%3d)^2 + 27*%d^2   3|M : %-3s   3 a cube : %s\n",
      p, 4*p, lm[1], lm[2], if (lm[2] % 3 == 0, "yes", "no"),
      if (iscube(3,p), "YES", "no")));
};

\\ ------------------------------------------------------------------------ run

{
print("======================================================================");
print("cubic-residues.gp -- checks for cubic-residues.typ");
print("");
print("For p = 3 and p = 2 mod 3, every residue is a cube: cubing is a");
print("bijection on F_p^*.  Everything below is about p = 1 mod 3.");
print("");
check1(100000);
print("");
check2(50000);
print("");
check3(50000);
print("");
check4([9, 27, 81, 243, 729], 200000);
print("");
check5([3,4,5,6,7]);
print("");
print("  (6) the general mechanism, of which all of the above is the case l = 3:");
check6([3,5,7], [[2,5],[2,3,7],[2,3,5]], [20000,20000,6000]);
print("");
check7([3,5], [[2,5],[2,3]]);
print("");
check8(1000000);
print("");
check9(1500);
print("");
print("A small table, for the eye:");
print("");
table(130);
print("");
print("Note 7 and 61: same L, different M -- and 7 = 61 mod 27.  That pair alone");
print("shows no congruence can work, and shows what a congruence throws away.");
}
quit;
