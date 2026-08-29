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
print("A small table, for the eye:");
print("");
table(130);
print("");
print("Note 7 and 61: same L, different M -- and 7 = 61 mod 27.  That pair alone");
print("shows no congruence can work, and shows what a congruence throws away.");
}
quit;
