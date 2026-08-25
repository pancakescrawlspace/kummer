\\ integral-bm.gp -- computations for integral-bm.typ.
\\ Run from this directory:
\\     gp -q -s 2000000000 integral-bm.gp < /dev/null > results/integral-bm.txt
\\
\\ A Brauer-Manin obstruction to INTEGRAL points, on the negative Pell conic
\\
\\     X : x^2 - 34 y^2 = -1        over Spec Z.
\\
\\ The facts verified here:
\\   (1) X(Z) = 0/     -- the fundamental unit of Z[sqrt 34] has norm +1.
\\   (2) X(Z_v) != 0/  for every place v, and X(Q) is infinite and dense.
\\   (3) A = (2, x+4) is an unramified quaternion class on X_Q, non-constant:
\\       the zeros of x+4 have residue field Q(sqrt 2), where 2 IS a square,
\\       so the only residue sits at the removed point at infinity.
\\   (4) inv_oo A = 0 at every real point (because 2 > 0).
\\   (5) inv_2 A = 1/2 at every Z_2-point (because x = +-1 mod 8 is forced).
\\   (6) inv_p A = 0 at every Z_p-point, p odd.
\\   (7) hence sum_v inv_v A = 1/2 on all of X(A_Z): the obstruction.
\\   (8) rational points obey reciprocity, and escape (5)+(6) only by having
\\       a denominator divisible by a prime p = +-3 mod 8.
\\   (9) the residue of A is the genus character of Q(sqrt 34): this Brauer
\\       class IS the classical genus-theory obstruction to negative Pell.
\\  (10) the same recipe over a range of d, to see it is not a one-off.
\\
\\ PARI conventions: hilbert(a,b,p) is the Hilbert symbol, p = 0 the real place.
\\ Additively, inv_v (a,b) = 1/2 exactly when hilbert(a,b,v) = -1.

D = 34;            \\ the discriminantal parameter
C = 4;             \\ the shift in lambda = x + C
A = 2;             \\ the first slot of the quaternion algebra (A, x+C)

\\ ---------------------------------------------------------------- (1) no Z-point

nointegralpoint() =
{ my(u, n, found);
  print("(1) X(Z) = 0/  for  x^2 - ", D, " y^2 = -1");
  u = quadunit(4*D);
  n = norm(u);
  print("    fundamental unit of Z[sqrt ", D, "] : ", u, "   norm = ", n);
  print("    negative Pell is soluble iff that norm is -1, so: soluble = ", n == -1);
  found = List();
  for (y = 0, 200000,
    if (issquare(D*y^2 - 1), listput(found, y)));
  print("    brute force 0 <= y <= 200000 : solutions found = ", #found);
  print("");
}

\\ ------------------------------------------------- (2) local points, everywhere

localpoints() =
{ my(bad, ok);
  print("(2) X(Z_v) != 0/  for every v");
  print("    real: x^2 = 34 y^2 - 1 has real solutions, e.g. y = 1, x = sqrt 33.");
  print("    p = 2: take y = 1, x^2 = 33.  33 mod 8 = ", 33 % 8,
        ", so 33 is a square in Z_2  ->  point exists.");
  bad = List();
  forprime (p = 3, 2000,
    ok = 0;
    for (y = 0, p-1, if (issquare(Mod(D*y^2 - 1, p)), ok = 1; break));
    if (!ok, listput(bad, p)));
  print("    odd p < 2000 with no point mod p : ", Vec(bad));
  print("    X is smooth over Z[1/2]: the gradient (2x, -", 2*D, "y) vanishes mod p");
  print("    only if x = 0 and ", D, "y = 0 mod p, which contradicts x^2 - ", D,
        "y^2 = -1.");
  print("    So Hensel lifts every F_p-point, and X(Z_p) != 0/ for all odd p.");
  print("");
}

\\ ------------------------------------------------------ (3) A = (2, x+4) is good

classisgood() =
{ my(q, disc);
  print("(3) the class  A = (", A, ", x + ", C, ")  is unramified on X_Q");
  print("    zeros of x + ", C, " on X:  x = -", C, ",  ", D, " y^2 = ", C^2+1,
        ",  so y^2 = ", (C^2+1)/D);
  disc = D * (C^2 + 1);
  print("    residue field  Q(sqrt(", D, "*(", C, "^2+1))) = Q(sqrt ", disc, ")",
        "  and ", disc, " = ", factor(disc));
  q = core(disc);
  print("    squarefree part = ", q, ", so the residue field is Q(sqrt ", q, ")");
  print("    is ", A, " a square there?  ", A == q, "   -> residue at the zeros is trivial");
  print("    (this is why C = ", C, " was chosen:  ", (D/2), "*(", C, "^2+1) = ",
        (D/2)*(C^2+1), " = ", sqrtint((D/2)*(C^2+1)), "^2, a perfect square)");
  print("    poles: the single closed point at infinity, residue field Q(sqrt ", D, ").");
  print("    is ", A, " a square in Q(sqrt ", D, ")?  ", core(A*D) == 1,
        "   -> A is NON-CONSTANT, ramified only at the removed point.");
  print("");
}

\\ ------------------------------------------------------------ (4) the real place

realplace() =
{ print("(4) inv_oo A = 0 at every real point");
  print("    (a,b)_oo = -1 needs a < 0 AND b < 0, and here a = ", A, " > 0.");
  print("    sample: hilbert(", A, ", -1000, 0) = ", hilbert(A, -1000, 0),
        ",  hilbert(", A, ", 1000, 0) = ", hilbert(A, 1000, 0));
  print("");
}

\\ ------------------------------------------------------------------- (5) p = 2

place2(k) =
{ my(M, xs, hs, cnt);
  print("(5) inv_2 A = 1/2 at EVERY Z_2-point");
  M = 2^k;
  xs = List(); hs = List(); cnt = 0;
  for (x = 0, M-1,
    for (y = 0, M-1,
      if (Mod(x^2 - D*y^2 + 1, M) == 0,
        cnt++;
        listput(xs, x % 8);
        listput(hs, hilbert(A, x + C, 2)))));
  print("    exhaustive over Z/2^", k, ":  ", cnt, " solutions");
  print("    values of x mod 8 that occur      : ", Set(Vec(xs)));
  print("    values of hilbert(", A, ", x+", C, ", 2)   : ", Set(Vec(hs)));
  print("    proof: x^2+1 = 2*17*y^2 forces x odd and y a unit; then");
  print("      (x^2+1)/2 = 17 y^2 = 1 mod 8, and (x^2+1)/2 = 5 mod 8 when x = +-3 mod 8,");
  print("      so x = +-1 mod 8, x+4 = +-3 mod 8, and (2, +-3 mod 8)_2 = -1.");
  print("");
}

\\ -------------------------------------------------------------- (6) odd places

oddplaces() =
{ my(bad, hit, chi);
  print("(6) inv_p A = 0 at every Z_p-point, p odd");
  print("    (", A, ", x+", C, ")_p = (", A, "/p)^v_p(x+", C, "), so it is trivial unless");
  print("    2 is a non-residue mod p AND v_p(x+", C, ") is odd.");
  print("    but x = -", C, " mod p forces ", D, "y^2 = ", C^2+1,
        " mod p, i.e. 2y^2 = 1: 2 must be a square.");
  bad = List();
  forprime (p = 3, 5000,
    hit = 0;
    for (y = 0, p-1, if (Mod(2*y^2, p) == 1, hit = 1; break));
    chi = (kronecker(A, p) == 1);
    if (hit != chi, listput(bad, p)));
  print("    p < 5000 where 'p | x+", C, " is possible' differs from '2 is a QR mod p': ",
        Vec(bad));
  print("    so v_p(x+", C, ") >= 1 only when (2/p) = +1, where the symbol is +1 anyway.");
  print("");
}

\\ ------------------------------------------------------------- (7) the obstruction

obstruction() =
{ print("(7) sum_v inv_v A  =  0 (oo)  +  1/2 (at 2)  +  0 (odd p)  =  1/2");
  print("    X(A_Z) != 0/  but  X(A_Z)^Br = 0/,  hence X(Z) = 0/.");
  print("    This is a Brauer-Manin obstruction to an INTEGRAL point,");
  print("    on a variety whose rational points are Zariski dense.");
  print("");
}

\\ ------------------------------------------------------- (8) rational points

evalplaces(x) =
{ my(N, ps, L);
  N = numerator(x + C) * denominator(x + C);
  ps = factor(2 * abs(N))[,1];
  L = List();
  for (j = 1, #ps, if (hilbert(A, x + C, ps[j]) == -1, listput(L, ps[j])));
  Vec(L);
}

rationalpoints(dmax) =
{ my(L, t, a, P, u, ux, uy, nx, ny);
  print("(8) rational points: reciprocity holds, and they escape via a denominator");
  print("    all (x,y) in X(Q) with denominator <= ", dmax, ":");
  print("");
  print("        x          y        denom   places with inv = 1/2");
  L = List();
  for (d = 1, dmax,
    for (b = 1, 2*d + ceil(sqrt(D)*d),
      t = D*b^2 - d^2;
      if (t > 0 && issquare(t),
        a = sqrtint(t);
        if (gcd(gcd(a, b), d) == 1, listput(L, [a, b, d])))));
  for (j = 1, #L,
    my(v = L[j], x = v[1]/v[3], y = v[2]/v[3], P0 = evalplaces(x));
    print("      ", x, "   ", y, "   ", v[3], "      ", P0,
          "   #odd = ", #P0 % 2));
  print("");
  print("    every list has even length: that is Hilbert reciprocity.");
  print("    every list contains 2 (the point is 2-integral) and one odd p;");
  print("    that p is = +-3 mod 8 and divides the denominator -- the point is");
  print("    NOT p-integral, which is exactly how it dodges (6).");
  print("");
  print("    the orbit of (3/5, 1/5) under the fundamental unit (35 + 6 sqrt 34):");
  ux = 3/5; uy = 1/5;
  for (i = 1, 5,
    print("      x = ", ux, "   y = ", uy, "   x^2-", D, "y^2 = ", ux^2 - D*uy^2,
          "   inv=1/2 at ", evalplaces(ux));
    nx = ux*35 + D*uy*6; ny = ux*6 + uy*35; ux = nx; uy = ny);
  print("    the denominator 5 never goes away, and 5 = 5 mod 8.");
  print("");
  print("    the two representatives of the class agree, as they must:");
  print("      (", A, ", x+", C, ") * (", A, ", x-", C, ") = (", A, ", ", D,
        "y^2 - ", C^2+1, ") = (", A, ", 17) * (", A, ", 2y^2-1),");
  print("      and (2,17) is split (17 = 1 mod 8) while 2y^2-1 = -N(1+y sqrt 2),");
  print("      so (2, 2y^2-1) = (2,-1) = 1.  Check at (3/5,1/5) and (5/3,1/3):");
  foreach ([3/5, 5/3, 27/11], x,
    print("        x = ", x, " : ",
          [hilbert(A, x+C, p) * hilbert(A, x-C, p) | p <- [0,2,3,5,11,17]]));
  print("");
}

\\ --------------------------------------------------------------- (9) genus theory

genustheory() =
{ my(K, hK);
  print("(9) the residue of A is the genus character of K = Q(sqrt ", D, ")");
  K = bnfinit(x^2 - D, 1);
  hK = K.no;
  print("    class number h(K) = ", hK, ",  class group = ", K.cyc);
  print("    K has ", omega(D), " ramified primes, so genus theory gives a 2-rank of ",
        omega(D) - 1, " in the narrow class group,");
  print("    and the genus field is K(sqrt 2) = Q(sqrt 2, sqrt 17), unramified over K.");
  print("    residue of A at the point at infinity = class of ", A, " in K*/K*^2:");
  print("      is ", A, " a square in K?  ", core(A*D) == 1,
        "  -> the residue is exactly the genus character.");
  print("    So this Brauer-Manin obstruction IS the classical genus-theory");
  print("    obstruction to x^2 - ", D, " y^2 = -1, in Brauer clothing.");
  print("");
}

\\ ---------------------------------------------------- (10) is 34 special?

family(dmax) =
{ my(rows, q, u, sol, loc, c, found, cc);
  print("(10) the same recipe for other d: squarefree d = 2q, q = 1 mod 8 prime");
  print("");
  print("      d     q    neg Pell?   c with q(c^2+1) a square   residue field");
  rows = 0;
  forstep (q = 17, dmax, 8,
    if (!isprime(q), next);
    my(d = 2*q);
    u = quadunit(4*d);
    sol = (norm(u) == -1);
    \\ search a shift c making q*(c^2+1) a perfect square
    found = -1;
    for (c = 1, 20000, if (issquare(q*(c^2+1)), found = c; break));
    if (found < 0, next);
    cc = found;
    print("     ", d, "   ", q, "     ", if(sol, "soluble ", "INSOLUBLE"),
          "        c = ", cc, "                Q(sqrt ", core(d*(cc^2+1)), ")");
    rows++;
    if (rows >= 12, break));
  print("");
  print("    q(c^2+1) = square has the solution c with c^2+1 = q k^2, i.e. a point on");
  print("    another Pell conic; when it exists, (2, x+c) is unramified on x^2-2q y^2 = -1");
  print("    by the same computation.  Whenever negative Pell is INSOLUBLE there, the");
  print("    obstruction below reproduces it.  d = 34 is the first such d.");
  print("");
  print("    the 2-adic step in full, for the soluble d as well as the insoluble:");
  forstep (q = 17, dmax, 8,
    if (!isprime(q), next);
    my(d = 2*q, uu = quadunit(4*d), sol2 = (norm(quadunit(4*d)) == -1));
    found = -1;
    for (c = 1, 20000, if (issquare(q*(c^2+1)), found = c; break));
    if (found < 0, next);
    my(M = 2^10, S = List(), H = List());
    for (xx = 0, M-1, for (yy = 0, M-1,
      if (Mod(xx^2 - d*yy^2 + 1, M) == 0,
        listput(S, xx % 8);
        listput(H, hilbert(2, xx + found, 2)))));
    print("      d = ", d, "  c = ", found, "  x mod 8 in ", Set(Vec(S)),
          "  inv_2 values ", Set(Vec(H)),
          if (Set(Vec(H)) == Set([-1]), "   obstruction", "   no obstruction"),
          "   neg Pell ", if (sol2, "SOLUBLE", "insoluble"),
          if (sol2 == (Set(Vec(H)) == Set([-1])), "   *** INCONSISTENT ***", "   consistent")));
  print("");
}

\\ ------------------------------------------------------------------------ driver

print("=========================================================================");
print(" A Brauer-Manin obstruction to integral points:  x^2 - 34 y^2 = -1");
print("=========================================================================");
print("");
nointegralpoint();
localpoints();
classisgood();
realplace();
place2(10);
oddplaces();
obstruction();
rationalpoints(60);
genustheory();
family(200);
print("done.");
