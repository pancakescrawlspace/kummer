\\ padic-ptorsion.gp -- checks for padic-ptorsion.typ
\\
\\ Run from this directory:
\\     gp -q -s 6000000000 padic-ptorsion.gp < /dev/null > results/padic-ptorsion.txt
\\
\\ Theorem 1 of arXiv:1211.5833 (Pannekoek): for E/Q_p with additive reduction
\\ given by a minimal model with every a_i in pZ_p, E_0(Q_p) = Z_p except in
\\ four cases, where it is pZ_p x F_p -- i.e. except when there is p-torsion:
\\     p=2, a_1+a_3 = 2 mod 4;   p=3, a_2 = 6 mod 9;
\\     p=5, a_4 = 10 mod 25;     p=7, a_6 = 14 mod 49.
\\ This script tests three things about that list.

{hasptors(v, p, prec) = my(E = ellinit(v), f = elldivpol(E, p), R);
  if (poldegree(f) < 1, return(0));
  R = polrootspadic(f, p, prec);
  for (i = 1, #R,
    my(x0 = R[i], b = E.a1*x0 + E.a3,
       c = -(x0^3 + E.a2*x0^2 + E.a4*x0 + E.a6), d = b^2 - 4*c);
    if (d == 0 || issquare(d*1) || #polrootspadic(y^2 - d, p, prec) > 0, return(1)));
  0;}

\\ semistability defect: |image of inertia| for potentially good reduction
{sdefect(E, p) = my(Em = ellinit(ellminimalmodel(E)));
  if (valuation(Em.j, p) < 0, return(2));
  12 / gcd(valuation(Em.disc, p), 12);}

\\ ---------------------------------------------------------------- check 1
\\ The four congruences are one congruence.  a_i has WEIGHT i for the scaling
\\ (x,y) -> (u^2 x, u^3 y), under which a_i -> u^(-i) a_i.  For u in Z_p^*,
\\ u^(p-1) = 1 mod p, so a_(p-1)/p mod p is the ONE coefficient whose leading
\\ term is an invariant of the model.  And the criterion is exactly
\\     a_(p-1) = 2p mod p^2 .
\\ Weierstrass equations have a_1, a_2, a_3, a_4, a_6 and nothing else, so
\\ p-1 in {1,2,3,4,6} -- which happens only for p = 2, 3, 5, 7.

check1() =
{ my(bad = 0, W = [1,2,3,4,6]);
  printf("  (1) the criterion as a_(p-1) = 2p mod p^2, tested directly:\n");
  for (i = 1, 3,
    my(p = [3,5,7][i], slot = [2,4,5][i], hits = List(), pred = List());
    for (b = 0, p^2 - 1,
      my(v = vector(5, j, 0));
      v[slot] = p*b;
      v[5] += p;                       \\ keep all a_i in pZ_p, additive
      my(E = ellinit(v));
      if (E == 0 || E.disc == 0, next);
      my(a = if (p == 3, v[2], p == 5, v[4], v[5]));
      if (hasptors(v, p, 30), listput(hits, a % p^2));
      if (a % p^2 == 2*p % p^2, listput(pred, a % p^2)));
    my(H = Set(Vec(hits)), P = Set(Vec(pred)));
    if (H != P, bad++);
    printf("      p=%d, coefficient a_%d : torsion at a_%d = %s (mod %d); 2p = %d  %s\n",
      p, p-1, p-1, H, p^2, 2*p, if (H == P, "agrees", "DISAGREES")));
  printf("      p-1 must be a Weierstrass weight, i.e. p-1 in %s, i.e. p in %s\n",
         W, [q | q <- [2,3,5,7,11,13,17,19,23], setsearch(Set(W), q-1)]);
  printf("      mismatches : %d of 3\n", bad);
};

\\ ---------------------------------------------------------------- check 2
\\ THE MECHANISM, inside Q_p.  Additive reduction means the special fibre of the
\\ connected Neron model is G_a, which is killed by p.  So [p] carries E_0 into
\\ E_1 and induces an F_p-linear map
\\     lambda : E_0/E_1 = G_a(F_p) --> E_1/E_2 = Lie(E) (x) F_p ,
\\ a map between two one-dimensional F_p-spaces, i.e. a scalar.  There is
\\ p-torsion exactly when lambda = 0.  Test: take P in E_0 \ E_1 and read off
\\ v(x(pP)):  -2 means pP is in E_1 \ E_2 (lambda nonzero), <= -4 means E_2.

check2() =
{ my(bad = 0, n = 0);
  printf("  (2) p-torsion <=> [p] kills E_0/E_1 into E_2:\n");
  for (i = 1, 2,
    my(p = [5,7][i], slot = [4,5][i]);
    for (b = 1, 3*p,
      my(v = vector(5, j, 0), x0, y0, E, Q, d, bb, c, vq);
      v[slot] = p*b;
      if (slot == 4, v[5] = p);
      E = ellinit(v);
      if (E == 0 || E.disc == 0, next);
      x0 = 1 + O(p^40);
      bb = E.a1*x0 + E.a3; c = -(x0^3 + E.a2*x0^2 + E.a4*x0 + E.a6); d = bb^2 - 4*c;
      if (!issquare(d, &y0), next);
      y0 = (-bb + y0)/2;
      if (!ellisoncurve(E, [x0,y0]), next);
      Q = ellmul(E, [x0,y0], p);
      vq = if (Q == [0], 999, valuation(Q[1], p));
      n++;
      \\ lambda = 0  <=>  v(x(pP)) <= -4  <=>  the congruence holds
      if ((vq <= -4) != (v[slot] % p^2 == 2*p % p^2), bad++)));
  printf("      v(x(pP)) drops below -2 exactly when the congruence holds : %d wrong of %d\n",
         bad, n);
};

\\ ---------------------------------------------------------------- check 3
\\ THE GEOMETRIC BOUND.  E acquires good reduction over L with e = |image of
\\ inertia| the semistability defect.  The connected Neron model over Z_p has
\\ special fibre G_a, and there is no non-trivial homomorphism G_a -> (elliptic
\\ curve), so every point of E_0(Q_p) reduces to O over O_L: E_0(Q_p) sits
\\ inside the FORMAL GROUP there.  A formal group over a field of absolute
\\ ramification e has no point of order p unless e >= p-1.  Hence
\\
\\        p-torsion  ==>  e >= p - 1 .
\\
\\ And for potentially good reduction e divides |Aut(Ebar)|, so e <= 6 for
\\ p >= 5:  therefore p - 1 <= 6, i.e. p <= 7.  The same four primes, by a
\\ completely different route from check 1.

check3() =
{ my(bad = 0);
  printf("  (3) p-torsion forces the inertia image to be large:\n");
  for (i = 1, 2,
    my(p = [5,7][i], with = List(), without = List());
    for (b4 = 0, 6, for (b6 = 1, 8,
      my(v = [0,0,0,p*b4,p*b6], E = ellinit(v));
      if (E == 0 || E.disc == 0, next);
      if (valuation(ellinit(ellminimalmodel(E)).disc, p) == 0, next);
      my(e = sdefect(E, p));
      if (hasptors(v, p, 30), listput(with, e), listput(without, e))));
    my(W = Set(Vec(with)));
    for (k = 1, #W, if (W[k] < p-1, bad++));
    printf("      p=%d : e with torsion %s, e without %s;  need e >= %d : %s\n",
      p, W, Set(Vec(without)), p-1,
      if (#[x | x <- W, x < p-1] == 0, "holds", "FAILS")));
  printf("      violations of e >= p-1 : %d\n", bad);
  printf("      and e <= 6 for p >= 5 (Aut of an elliptic curve), so p - 1 <= 6, p <= 7\n");
};

\\ ------------------------------------------------------------------------ run

{
print("======================================================================");
print("padic-ptorsion.gp -- where the p-torsion of arXiv:1211.5833 comes from");
print("");
check1();
print("");
check2();
print("");
check3();
print("");
print("Two independent reasons for the same list of four primes.  Arithmetically,");
print("the criterion is a congruence on a_(p-1), and a Weierstrass equation has");
print("no coefficient of index p-1 once p > 7.  Geometrically, the torsion point");
print("must live in the formal group over the field where good reduction is");
print("attained, which needs ramification at least p-1, while the inertia image");
print("of a potentially good curve has order at most 6.  Both bounds are Aut(E).");
}
quit;
