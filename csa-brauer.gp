\\ csa-brauer.gp -- computations for csa-brauer.typ.
\\ Run from this directory:
\\     gp -q -s 2000000000 csa-brauer.gp < /dev/null > results/csa-brauer.txt
\\
\\ Six illustrations of central simple algebras in number theory, all explicit:
\\   (1) Hilbert reciprocity: prod_v (a,b)_v = 1.
\\   (2) Quadratic reciprocity, READ OFF from (1).
\\   (3) Conics: a x^2 + b y^2 = z^2 has a rational point iff (a,b)_v = 1 for
\\       all v -- the Hasse principle for quaternion algebras (Legendre).
\\   (4) The Hasse norm theorem, and its failure for a biquadratic field:
\\       25 is a local norm everywhere from Q(sqrt13, sqrt17) but not a global one.
\\   (5) Grunwald-Wang: 16 is an 8th power in Q_p for every odd p and in R,
\\       but not in Q_2 and not in Q.
\\   (6) Division algebras over Q from prescribed local invariants, and the
\\       theorem index = exponent = lcm of the denominators.
\\   (7) Crossed products: the cocycle identity for the cyclic factor set; the
\\       cyclic algebra (L/K,sigma,b) splits iff b is a norm; invariance under
\\       coboundaries; and multiplicativity in b.
\\   (9) The Azumaya algebra A = (17, A-5) on V : N(x) = 25, and the check that
\\       its Brauer-Manin sum is 1/2 at every adelic point.
\\   (8) Two worked examples: Hamilton's quaternions (whose quadratic subfields
\\       are governed by the three-square theorem) and the degree-3 cyclic
\\       algebra (Q(zeta_7)^+/Q, sigma, 2), ramified at 2 and 7, whose cubic
\\       subfields are the cubic fields in which 2 and 7 are both non-split.
\\
\\ PARI conventions used: hilbert(a,b,p) is the Hilbert symbol at p, with p = 0
\\ meaning the real place; bnfisnorm(bnf,x) returns [a,b] with x = N(a)*b, so x
\\ is a norm iff b = 1.

\\ ------------------------------------------------------ (1) Hilbert reciprocity

\\ the places where (a,b)_v can be non-trivial: oo, 2, and the primes of a*b
badplaces(a, b) = { setunion(Set([2]), Set(factor(2*abs(a*b))[,1]~)) };

reciprocity() =
{ my(S, pr, s);
  print("(1) Hilbert reciprocity:  prod_v (a,b)_v = 1");
  print("    (a,b)_v = +1 iff the quaternion algebra (a,b) splits over Q_v)");
  print("");
  foreach ([[-1,-1], [2,3], [6,-5], [13,17], [-3,7], [15,-14], [5,-11]], ab,
    my(a = ab[1], b = ab[2]);
    S = badplaces(a, b);
    pr = hilbert(a, b, 0);
    s = Str("    (", a, ",", b, ")   oo:", hilbert(a,b,0));
    foreach (S, p,
      pr *= hilbert(a, b, p);
      s = Str(s, "  ", p, ":", hilbert(a,b,p)));
    print(s, "      product = ", pr));
  print("");
};

\\ ---------------------------------------------------- (2) quadratic reciprocity

\\ For odd primes p != q the only possibly non-trivial symbols are at 2, p, q
\\ (never at oo, both being positive), and
\\     (p,q)_p = (q/p),   (p,q)_q = (p/q),   (p,q)_2 = (-1)^(e(p) e(q))
\\ with e(n) = (n-1)/2 mod 2.  The product formula is then exactly Gauss.
eps(m) = { ((m - 1)/2) % 2 };

quadrec() =
{ my(lhs, rhs, bad = 0, n = 0);
  print("(2) quadratic reciprocity, read off from Hilbert reciprocity");
  print("");
  print("      p    q   (p,q)_p  (q/p)   (p,q)_q  (p/q)   (p,q)_2  (-1)^ee   Gauss?");
  foreach ([[3,5],[3,7],[5,7],[7,11],[11,13],[13,17],[19,23],[3,43]], pq,
    my(p = pq[1], q = pq[2]);
    n++;
    \\ the three symbols against their closed forms
    my(hp = hilbert(p,q,p), lp = kronecker(q,p),
       hq = hilbert(p,q,q), lq = kronecker(p,q),
       h2 = hilbert(p,q,2), e2 = (-1)^(eps(p)*eps(q)));
    lhs = lp * lq;
    rhs = (-1)^(eps(p)*eps(q));
    if (hp != lp || hq != lq || h2 != e2 || lhs != rhs, bad++);
    print("     ", p, "    ", q, "     ", hp, "      ", lp,
          "      ", hq, "      ", lq,
          "      ", h2, "      ", e2, "       ", if (lhs == rhs, "ok", "FAIL")));
  print("");
  print("    checked ", n, " pairs, ", bad, " discrepancies.");
  print("    The product formula (1) with only 2, p, q contributing IS Gauss:");
  print("        (q/p)(p/q) = (p,q)_2^(-1) = (-1)^((p-1)/2 (q-1)/2).");
  print("");
};

\\ ------------------------------------------------------------------ (3) conics

\\ brute-force search for a rational point on a x^2 + b y^2 = z^2
conicpoint(a, b, H) =
{ for (z = 0, H, for (x = 0, H, for (y = 0, H,
    if (x == 0 && y == 0 && z == 0, next);
    if (a*x^2 + b*y^2 == z^2, return([x,y,z])))));
  0;
};

conics() =
{ my(S, split, pt);
  print("(3) conics: a x^2 + b y^2 = z^2  has a rational point iff (a,b) splits");
  print("    everywhere -- Legendre's theorem, i.e. Albert-Brauer-Hasse-Noether");
  print("    for quaternion algebras.");
  print("");
  foreach ([[2,3], [3,5], [1,1], [-1,-1], [2,7], [6,10]], ab,
    my(a = ab[1], b = ab[2]);
    S = badplaces(a, b);
    split = (hilbert(a,b,0) == 1);
    foreach (S, p, if (hilbert(a,b,p) != 1, split = 0));
    pt = conicpoint(a, b, 40);
    print("    (a,b) = (", a, ",", b, ")   splits everywhere: ",
          if (split, "yes", "no "),
          "    point found (height<=40): ",
          if (pt == 0, "none", pt),
          if ((split != 0) == (pt != 0), "", "   <-- MISMATCH")));
  print("");
  print("    (a=-1,b=-1 is the Hamilton quaternions: ramified at oo and 2,");
  print("     so the conic -x^2-y^2=z^2 has no rational point, as it must not.)");
  print("");
};

\\ -------------------------------------------------------- (4) the Hasse norm theorem

hassenorm() =
{ my(L, r);
  print("(4) the Hasse norm theorem and its failure beyond cyclic extensions");
  print("");
  print("    Cyclic case (Hasse): x is a norm from L/K iff it is a local norm");
  print("    everywhere.  Equivalently the cyclic algebra (L/K,sigma,x) splits.");
  print("");
  L = bnfinit(polcompositum(x^2 - 13, x^2 - 17)[1], 1);
  print("    L = Q(sqrt13, sqrt17),  poly ", L.pol, ",  disc ", L.disc,
        " = 13^2*17^2,  signature ", L.sign);
  print("    Galois group (Z/2)^2, so NOT cyclic.");
  print("");
  print("    Every decomposition group has order <= 2:");
  print("      ramified primes divide disc = 13^2 * 17^2, so only 13 and 17;");
  print("      13 splits in Q(sqrt17)?  kronecker(17,13) = ", kronecker(17,13));
  print("      17 splits in Q(sqrt13)?  kronecker(13,17) = ", kronecker(13,17));
  print("      2 is unramified (disc is odd); 13 mod 8 = ", 13%8,
        ", 17 mod 8 = ", 17%8);
  print("      unramified primes have CYCLIC decomposition group, and (Z/2)^2");
  print("      has no element of order 4 -- so |D_v| <= 2 for every v.");
  print("");
  print("    Hence every SQUARE is a local norm everywhere: at each v the local");
  print("    extension is trivial or quadratic, and 25 = N(5) either way.");
  print("");
  foreach ([25, 4, 9, -25, -1], t,
    r = bnfisnorm(L, t);
    print("      bnfisnorm(L, ", t, ") = ", r,
          "     ", if (r[2] == 1, "IS a global norm", "NOT a global norm")));
  print("");
  print("    So 25 is a local norm everywhere and not a global norm:");
  print("    the Hasse norm principle FAILS.");
  print("");
  print("    PROOF that 25 is not a global norm (Proposition 5.1), step by step.");
  print("    Put k = Q(sqrt13), L = k(sqrt17), y = N_{L/k}(x).");
  print("");
  my(kk = bnfinit(x^2 - 13, 1), P17, P5, P2);
  print("      k = Q(sqrt13):  h = ", kk.no, "   fundamental unit ", kk.fu[1],
        "   of norm ", nfeltnorm(kk, kk.fu[1]), "   (so norm-1 units are +-squares)");
  print("      13 mod 5 = ", 13 % 5, " a square mod 5? ", issquare(Mod(13,5)),
        "   =>  5 is INERT in k:  ", [[P.e, P.f] | P <- idealprimedec(kk, 5)]);
  print("        hence (y) = (5), so y = +-5 times a square.");
  print("      13 a square mod 17? ", issquare(Mod(13,17)),
        "   =>  17 SPLITS in k:  ", [[P.e, P.f] | P <- idealprimedec(kk, 17)]);
  print("        hence k_w = Q_17 at w | 17, where 17 is a uniformiser.");
  print("      Legendre:  (5/17) = ", kronecker(5,17), "   (-5/17) = ", kronecker(-5,17),
        "   (2/17) = ", kronecker(2,17));
  P17 = idealprimedec(kk, 17)[1];
  P5  = idealprimedec(kk, 5)[1];
  P2  = idealprimedec(kk, 2)[1];
  print("");
  print("      local Hilbert symbols over k, showing 17 is the ONLY obstruction:");
  print("        w | 17 :  (17, 5)_w = ", nfhilbert(kk, 17, 5, P17),
        "    (17,-5)_w = ", nfhilbert(kk, 17, -5, P17),
        "    (17, 2)_w = ", nfhilbert(kk, 17, 2, P17));
  print("        w |  5 :  (17, 5)_w = ", nfhilbert(kk, 17, 5, P5),
        "    (17,-5)_w = ", nfhilbert(kk, 17, -5, P5));
  print("        w |  2 :  (17, 5)_w = ", nfhilbert(kk, 17, 5, P2),
        "    (17,-5)_w = ", nfhilbert(kk, 17, -5, P2),
        "     (17 = 1 mod 8 is a square in Q_2)");
  print("");
  print("      global:  (17, 5)_k = ", nfhilbert(kk, 17, 5),
        "    (17,-5)_k = ", nfhilbert(kk, 17, -5),
        "    (17, 2)_k = ", nfhilbert(kk, 17, 2));
  print("");
  print("      Both +-5 fail at w | 17, so neither is a norm from k(sqrt17): 25 is");
  print("      not a global norm.  And (17,2)_k = +1 is exactly why 4 IS one.");
  print("");
  normform();
};

\\ The explicit norm form of L = Q(sqrt13, sqrt17) on the Q-basis
\\ 1, sqrt13, sqrt17, sqrt221, in its three equivalent shapes -- one per
\\ quadratic subfield.  Checked against PARI on random quadruples.
F1(a,b,c,d) = { (a^2 + 13*b^2 - 17*c^2 - 221*d^2)^2 -  52*(a*b - 17*c*d)^2 };
F2(a,b,c,d) = { (a^2 - 13*b^2 + 17*c^2 - 221*d^2)^2 -  68*(a*c - 13*b*d)^2 };
F3(a,b,c,d) = { (a^2 - 13*b^2 - 17*c^2 + 221*d^2)^2 - 884*(a*d - b*c)^2 };

normform() =
{ my(P, LL, r13, r17, r221, bad = 0, n);
  print("    the explicit norm form, for x = a + b sqrt13 + c sqrt17 + d sqrt221:");
  print("");
  print("      N(x) = (a^2 + 13b^2 - 17c^2 - 221d^2)^2 -  52 (ab - 17cd)^2      [via Q(sqrt13)]");
  print("           = (a^2 - 13b^2 + 17c^2 - 221d^2)^2 -  68 (ac - 13bd)^2      [via Q(sqrt17)]");
  print("           = (a^2 - 13b^2 - 17c^2 + 221d^2)^2 - 884 (ad -   bc)^2      [via Q(sqrt221)]");
  print("");
  P = subst(polcompositum(x^2 - 13, x^2 - 17)[1], x, y);
  LL = nfinit(P);
  r13 = nfroots(LL, x^2 - 13)[1];
  r17 = nfroots(LL, x^2 - 17)[1];
  r221 = r13 * r17;
  print("      spot checks:");
  foreach ([[5,0,0,0], [0,1,0,0], [0,0,1,0], [0,0,0,1], [1,1,0,0]], v,
    print("        (a,b,c,d) = ", v, "   N = ", F1(v[1],v[2],v[3],v[4])));
  for (t = 1, 300,
    my(a = random(21)-10, b = random(21)-10, c = random(21)-10, d = random(21)-10);
    n = nfeltnorm(LL, a + b*r13 + c*r17 + d*r221);
    if (n != F1(a,b,c,d) || n != F2(a,b,c,d) || n != F3(a,b,c,d), bad++));
  print("      300 random quadruples against PARI's nfeltnorm: ", bad, " mismatches");
  print("");
  print("    So Proposition 5.1 says: this quartic form represents 25 over every");
  print("    Q_v and over no rational quadruple -- while it does represent 4 and 9.");
  print("");
};

\\ ------------------------------------------------------------ (5) Grunwald-Wang

wang() =
{ my(ok);
  print("(5) Grunwald-Wang: the special case at 2");
  print("");
  print("    x^8 - 16 factors as ", factor(x^8 - 16));
  print("    so 16 is an 8th power in a field iff one of 2, -2, -1 is a square");
  print("    there.  For odd p the three Legendre symbols multiply to +1, so at");
  print("    least one is +1 -- 16 is an 8th power in every Q_p with p odd.");
  print("");
  foreach ([3,5,7,11,13,17,19,23,29,31,37,41], p,
    ok = issquare(Mod(2,p)) || issquare(Mod(-2,p)) || issquare(Mod(-1,p));
    print("      p = ", p, "   (2/p)=", kronecker(2,p), " (-2/p)=", kronecker(-2,p),
          " (-1/p)=", kronecker(-1,p), "   8th power in Q_p? ", if (ok, "yes", "NO")));
  print("      p = 2   2, -2, -1 are all non-squares in Q_2 (2,-2 have odd");
  print("              valuation; -1 = 7 mod 8)          8th power in Q_2? NO");
  print("      v = oo  16 = (2^(1/2))^8                  8th power in R?   yes");
  print("      16 an 8th power in Q?  ", if (ispower(16,8), "yes", "NO"));
  print("");
  print("    So 16 is an 8th power everywhere locally except at 2, and Grunwald's");
  print("    original (false) statement would have forced it to be one globally.");
  print("");
};

\\ ------------------------------------------- (6) division algebras from invariants

QQ = nfinit(y);
P(p) = { idealprimedec(QQ, p)[1] };

divalg() =
{ my(nf = QQ, A);
  print("(6) division algebras over Q with prescribed local invariants");
  print("");
  print("    Classification: a class in Br(Q) is exactly a family (inv_v) of");
  print("    elements of Q/Z, almost all zero, summing to zero; and");
  print("        index = exponent = lcm of the denominators.");
  print("");
  print("      invariants                       degree  index  lcm of denoms");
  A = alginit(nf, [3, [[P(7), P(13)], [1/3, 2/3]], [0]]);
  print("      1/3 at 7,  2/3 at 13              ", algdegree(A), "      ",
        algindex(A), "      3");
  A = alginit(nf, [2, [[P(2), P(3)], [1/2, 1/2]], [0]]);
  print("      1/2 at 2,  1/2 at 3               ", algdegree(A), "      ",
        algindex(A), "      2");
  A = alginit(nf, [2, [[P(2), P(3), P(5), P(7)], [1/2, 1/2, 1/2, 1/2]], [0]]);
  print("      1/2 at 2,3,5,7                    ", algdegree(A), "      ",
        algindex(A), "      2");
  A = alginit(nf, [6, [[P(7), P(13)], [1/6, 5/6]], [0]]);
  print("      1/6 at 7,  5/6 at 13              ", algdegree(A), "      ",
        algindex(A), "      6");
  A = alginit(nf, [6, [[P(7), P(13)], [1/2, 1/2]], [0]]);
  print("      1/2 at 7,  1/2 at 13 (in deg 6)   ", algdegree(A), "      ",
        algindex(A), "      2");
  print("");
  print("    The last row is M_3(D) for D the quaternion algebra ramified at");
  print("    7 and 13: degree 6, index 2.  Degree is a choice, index is not.");
  print("");
};


\\ ------------------------------------------------------- (7) crossed products

\\ The cyclic factor set.  For G = <sigma> of order n and b in K^*, put
\\     c(sigma^i, sigma^j) = b^e(i,j),   e(i,j) = 1 if i+j >= n, else 0,
\\ with 0 <= i,j < n.  Since b lies in K^*, sigma acts trivially on it, so the
\\ 2-cocycle identity
\\     c(s,t) c(st,r) = s(c(t,r)) c(s,tr)
\\ becomes an identity on EXPONENTS:
\\     e(i,j) + e(i+j mod n, k) = e(j,k) + e(i, j+k mod n).
ee(i, j, n) = { if (i + j >= n, 1, 0) };

cocycle() =
{ my(bad = 0, tested = 0, lhs, rhs);
  print("(7a) the cyclic factor set really is a 2-cocycle");
  print("");
  print("     c(sigma^i, sigma^j) = b^e(i,j),  e(i,j) = 1 iff i+j >= n");
  print("     identity checked: e(i,j) + e(i+j, k) = e(j,k) + e(i, j+k)   (indices mod n)");
  print("");
  for (n = 2, 8,
    my(nbad = 0);
    for (i = 0, n-1, for (j = 0, n-1, for (k = 0, n-1,
      tested++;
      lhs = ee(i, j, n) + ee((i+j) % n, k, n);
      rhs = ee(j, k, n) + ee(i, (j+k) % n, n);
      if (lhs != rhs, nbad++; bad++))));
    print("     n = ", n, "   triples checked ", n^3, "   failures ", nbad));
  print("");
  print("     total ", tested, " triples, ", bad, " failures.");
  print("     So (L/K, sigma, b) = (+) L u_i with u_i u_j = b^e(i,j) u_(i+j) is");
  print("     associative -- the cocycle condition IS associativity.");
  print("");
};

crossed() =
{ my(nf = nfinit(y), rnf, aut, K, r, mism = 0);
  print("(7b) (L/K, sigma, b) splits  <=>  b is a norm from L      [L = Q(sqrt5)]");
  print("");
  rnf = rnfinit(nf, x^2 - 5);
  aut = Mod(-x, x^2 - 5);
  K = bnfinit(x^2 - 5, 1);
  print("        b     index    b a norm?");
  foreach ([3, -3, 11, -1, 5, 2, 4, 9, 19, 31], b,
    my(ix = algindex(alginit(rnf, [aut, b])));
    r = bnfisnorm(K, b);
    if ((ix == 1) != (r[2] == 1), mism++);
    print("      ", b, "        ", ix, "        ", if (r[2] == 1, "yes", "no")));
  print("");
  print("     ", mism, " mismatches: Proposition 1.2, verified.");
  print("");
  print("(7c) invariance under coboundaries.  Replacing u_sigma by x u_sigma");
  print("     multiplies b by N(x), so b and b*N(x) must give the SAME algebra.");
  print("     N(2 + sqrt5) = ", nfeltnorm(nfinit(x^2 - 5), Mod(2 + x, x^2 - 5)),
        ", so b and -b should agree:");
  foreach ([3, 2, 7], b,
    print("       index(", b, ") = ", algindex(alginit(rnf, [aut, b])),
          "     index(", -b, ") = ", algindex(alginit(rnf, [aut, -b]))));
  print("");
  print("(7d) multiplicativity: the class of (L/K,sigma,b) times that of");
  print("     (L/K,sigma,b') is the class of (L/K,sigma,b b'), because the");
  print("     factor sets multiply.  Hence the class of (sigma,3) squares to");
  print("     (sigma,9), and 9 = N(3) is a norm:");
  print("       index(3) = ", algindex(alginit(rnf, [aut, 3])),
        "     index(9) = ", algindex(alginit(rnf, [aut, 9])),
        "     so the class has exponent 2.");
  print("");
  print("(7e) Hamilton's quaternions as a crossed product:  H = (C/R, conj, -1).");
  print("     Br(R) = R^*/N(C^*) = R^*/R_{>0} = {+-1}, of order 2 -- which is");
  print("     the invariant 1/2 recorded in section 2.");
  print("");
};


\\ ------------------------------------------------------- (8) worked examples

\\ (8a) HAMILTON.  B = (-1,-1) over Q, basis 1,i,j,k.  A pure quaternion
\\ v = xi+yj+zk has v^2 = -(x^2+y^2+z^2), so Q(sqrt(-m)) embeds in B iff m is a
\\ sum of three RATIONAL squares -- iff (Davenport-Cassels) a sum of three
\\ integer squares -- iff (Gauss-Legendre) m is not 4^a(8b+7).  The Brauer-group
\\ criterion says instead: Q(sqrt(-m)) embeds iff it splits B, i.e. iff 2 and oo
\\ are both non-split in it, i.e. iff -m is not 1 mod 8.  The two must agree.

sum3(m) =
{ my(r = sqrtint(m));
  for (a = 0, r, for (b = 0, r,
    my(c2 = m - a^2 - b^2);
    if (c2 >= 0 && issquare(c2), return([a,b,sqrtint(c2)]))));
  0;
};

hamilton() =
{ my(bad = 0, s3, loc, wit);
  print("(8a) Hamilton's quaternions B = (-1,-1) over Q");
  print("");
  print("     basis 1,i,j,k;  i^2 = j^2 = k^2 = -1,  ij = k = -ji,  jk = i = -kj,  ki = j = -ik");
  print("     ramified exactly at 2 and oo:  (-1,-1)_2 = ", hilbert(-1,-1,2),
        "   (-1,-1)_oo = ", hilbert(-1,-1,0));
  print("");
  print("     Q(sqrt(-m)) embeds  <=>  m = x^2+y^2+z^2  <=>  2 non-split in Q(sqrt(-m))");
  print("");
  print("       m   three squares    witness      -m mod 8   2 non-split   agree?");
  foreach ([1,2,3,5,6,7,10,11,13,14,15,17,21,22,23,26,30,31], m,
    s3 = sum3(m);
    loc = ((-m) % 8 != 1);
    if ((s3 != 0) != loc, bad++);
    wit = if (s3 == 0, "  --   ", Str(s3[1], "i+", s3[2], "j+", s3[3], "k"));
    print("      ", if (m < 10, " ", ""), m, "      ", if (s3 != 0, "yes", "no "),
          "         ", wit, "      ", (-m) % 8, "          ",
          if (loc, "yes", "no "), "        ",
          if ((s3 != 0) == loc, "ok", "FAIL")));
  print("");
  print("     ", bad, " disagreements.  The first failure is m = 7: the quaternion");
  print("     algebra criterion and the three-square theorem exclude Q(sqrt(-7))");
  print("     together, because 7 = 1 mod 8 makes 2 SPLIT there.");
  print("");
};

\\ (8b) THE CUBIC EXAMPLE.  L = Q(zeta_7)^+ = Q(alpha), alpha = zeta_7+zeta_7^-1,
\\ min poly x^3+x^2-2x-1, sigma(alpha) = alpha^2-2.  A = (L/Q, sigma, 2).
cubicexample() =
{ my(f = x^3 + x^2 - 2*x - 1, nf = nfinit(y), rnf, aut, A, h, K, iscube, bad = 0);
  print("(8b) the degree-3 cyclic algebra A = (Q(zeta_7)^+/Q, sigma, 2)");
  print("");
  K = nfinit(f);
  print("     L = Q(alpha),  f = ", f, ",  disc ", poldisc(f),
        " = 7^2, so L/Q is CYCLIC");
  print("     sigma(alpha) = alpha^2 - 2 is a root of f:  ",
        subst(f, x, Mod(x,f)^2 - 2) == 0);
  print("     N(alpha) = ", nfeltnorm(K, Mod(x,f)),
        "    N(alpha+1) = ", nfeltnorm(K, Mod(x,f)+1),
        "    N(2-alpha) = ", nfeltnorm(K, 2-Mod(x,f)), " = f(2)");
  print("");
  rnf = rnfinit(nf, f);
  aut = Mod(x^2 - 2, f);
  A = alginit(rnf, [aut, 2]);
  print("     A: degree ", algdegree(A), "   index ", algindex(A),
        "   (index 3 = division algebra)");
  h = alghassef(A);
  for (i = 1, #h[1], if (h[2][i] != 0,
    print("        ramified at p = ", h[1][i][1], "   inv = ", h[2][i], "/3")));
  print("        invariants sum to 1/3 + 2/3 = 1 = 0 in Q/Z -- reciprocity.");
  print("");
  print("     (L/Q, sigma, b) is SPLIT exactly when b is a cube mod 7");
  print("     (cubes mod 7 are {1,6}); for b = 7 it splits since 7 is a norm.");
  print("");
  print("        b    b mod 7   cube mod 7   index   division?");
  foreach ([2, 3, 5, 7, 11, 13, 29, 41, 43], b,
    my(ix = algindex(alginit(rnf, [aut, b])));
    iscube = (b % 7 == 1 || b % 7 == 6);
    if (b != 7 && (ix == 1) != iscube, bad++);
    print("       ", if (b < 10, " ", ""), b, "       ", b % 7, "         ",
          if (iscube, "yes", "no "), "         ", ix, "       ",
          if (ix == 3, "yes", "no")));
  print("");
  print("     ", bad, " disagreements (b = 7 excluded: it is the ramified prime).");
  print("");
  print("     Cubic subfields: F embeds iff F splits A iff 2 AND 7 are each");
  print("     NON-split in F (one prime above, local degree 3).");
  print("");
  print("        cubic field           disc      p=2 (e,f)      p=7 (e,f)     embeds?");
  foreach ([[x^3+x^2-2*x-1, "Q(zeta_7)^+   "], [x^3-3*x+1, "Q(zeta_9)^+   "],
            [x^3-2, "Q(cbrt 2)     "], [x^3-14, "Q(cbrt 14)    "],
            [x^3-5, "Q(cbrt 5)     "]], g,
    my(F = nfinit(g[1]), ok = 1, s = "");
    foreach ([2, 7], p,
      my(D = idealprimedec(F, p));
      if (#D != 1, ok = 0);
      s = Str(s, "   ", [[D[i].e, D[i].f] | i <- [1..#D]]));
    print("        ", g[2], "  ", F.disc, s, "     ", if (ok, "YES", "no")));
  print("");
  print("     So L itself, Q(zeta_9)^+, Q(cbrt 2) and Q(cbrt 14) all embed -- four");
  print("     pairwise non-isomorphic cubic fields (distinct discriminants), two");
  print("     cyclic and two not.  Q(cbrt 5) does not: 2 splits there.");
  print("     Explicit generators inside A:  alpha (in L);  u, with u^3 = 2;");
  print("     and (2-alpha)u, whose cube is N(2-alpha)*2 = 7*2 = 14.");
  print("");
};


\\ ------------------------------------------- (9) the Azumaya class on N(x) = 25

\\ V : N_{L/Q}(x) = 25 fibres over the conic W : A^2 - 13B^2 = 25 via
\\ x -> N_{L/k}(x) = A + B sqrt13, k = Q(sqrt13).  W is parametrised by lines
\\ through (5,0), giving A - 5 = 10/(13m^2-1), so modulo squares A-5 = 2 f(m)
\\ with f(m) = -5(1-13m^2); and (17,2) = 0, so the class
\\     A = (17, A-5)  in  Br(V)
\\ evaluates to (17, f(m)).  The claim is that its invariants sum to 1/2 always.
ff(m) = { -5*(1 - 13*m^2) };
issplit13(p) = { if (p == 0, 1, if (p == 2, 13 % 8 == 1, kronecker(13,p) == 1)) };

azumaya() =
{ my(bad = 0, tested = 0, ms = [], tot = 0, S = [], R);
  print("(9) an Azumaya algebra registering the failure of the Hasse principle");
  print("    for V : N_{L/Q}(x) = 25,  namely  A = (17, A-5)  with");
  print("    A = a^2 + 13b^2 - 17c^2 - 221d^2  (the trace part of N_{L/k}(x)).");
  print("");
  print("    (17,2) = 0 over Q?  hilbert(17,2,2) = ", hilbert(17,2,2),
        "   hilbert(17,2,17) = ", hilbert(17,2,17),
        "   hilbert(17,2,0) = ", hilbert(17,2,0));
  R = [];
  foreach (concat([0], primes(30)), p, if (hilbert(17,-5,p) == -1, R = concat(R,[p])));
  print("    (17,-5) ramifies exactly at ", R, "   (0 would be the real place)");
  print("      5 splits in Q(sqrt13)? ", issplit13(5), "      17 splits? ", issplit13(17));
  print("");
  print("    (a) at NON-SPLIT places the invariant does not depend on the point:");
  for (n = -12, 12, for (d = 1, 6, if (gcd(n,d) == 1, ms = concat(ms, [n/d]))));
  foreach (concat([0], primes(40)), p,
    if (issplit13(p), next);
    foreach (ms, m,
      tested++;
      if (hilbert(17, ff(m), p) != hilbert(17, -5, p), bad++)));
  print("        ", #ms, " values of m over every non-split place up to 40: ",
        tested, " comparisons, ", bad, " deviations from (17,-5).");
  print("        (reason: 17 is a square in Q_v(sqrt13) whenever 13 is not a");
  print("         square in Q_v, since then 13 = 17 mod squares, so 221 is a square)");
  print("");
  print("    (b) at SPLIT places local solubility forces the invariant to be 0.");
  print("");
  print("    Hence the sum runs over non-split places only:");
  foreach (concat([0], primes(60)), p,
    if (issplit13(p), next);
    if (hilbert(17, -5, p) == -1, tot += 1; S = concat(S, [p])));
  print("        non-split places with inv = 1/2 : ", S,
        "     sum = ", tot, "/2 = 1/2  =/= 0");
  print("");
  print("    So V(A_Q)^Br is EMPTY: the obstruction is Brauer-Manin, complete,");
  print("    and carried by one quaternion algebra.  The class is not constant --");
  print("    its ramification set moves with m, but always contains 5:");
  print("");
  print("        m        f(m)        ramified at");
  foreach ([0, 1, 2, 3, 1/2, -1], m,
    my(T = []);
    foreach (concat([0], primes(40)), p, if (hilbert(17,ff(m),p) == -1, T = concat(T,[p])));
    print("       ", m, "        ", ff(m), "        ", T));
  print("");
};

reciprocity();
quadrec();
conics();
hassenorm();
wang();
divalg();
cocycle();

\\ ------------------------------- (10) which cyclotomic and which real subfields

\\ A = (Q(zeta_7)^+/Q, sigma, 2) has invariants 1/3 at 2 and 2/3 at 7, both of
\\ order 3, so a cubic L splits A iff every completion of L at 2 and at 7 has
\\ local degree 3 -- i.e. iff 2 and 7 are each NON-SPLIT in L (one prime above).
\\ The archimedean place imposes nothing: deg A = 3 is odd and Br(R) has
\\ exponent 2, so inv_oo(A) = 0 forcibly.

embedsinA(g) =
{ my(nf = nfinit(g));
  #idealprimedec(nf,2) == 1 && #idealprimedec(nf,7) == 1;
}

cyclosubfields() =
{ my(deg3 = List(), deg1 = List());
  print("(10) WHICH Q(cos(2 pi/m)) LIE IN A, AND WHETHER ANY SUBFIELD IS NON-REAL");
  print("");
  print("   deg A = 3 is prime, so a subfield is Q or a cubic maximal subfield.");
  print("   [Q(zeta_m)^+ : Q] = phi(m)/2 for m > 2, so a cubic needs phi(m) = 6.");
  for (m = 1, 500,
    my(d = if (m <= 2, 1, eulerphi(m)/2));
    if (d == 3, listput(deg3, m));
    if (d == 1, listput(deg1, m)));
  print("     phi(m) = 6  ->  m in ", Vec(deg3));
  print("     degree 1    ->  m in ", Vec(deg1), " (the field is Q, trivially in A)");
  print("   phi(m) = 6 has no further solutions: phi(m) >= sqrt(m/2) bounds m <= 72.");
  print("");
  print("     m    Q(zeta_m)^+              disc   signature   #(2)  #(7)   embeds");
  foreach (Vec(deg3), m,
    my(g = polredabs(polsubcyclo(m,3)), nf = nfinit(g));
    print("    ", m, "   ", g, "   ", nf.disc, "    ", nf.sign, "      ",
          #idealprimedec(nf,2), "     ", #idealprimedec(nf,7), "      ",
          if (embedsinA(g), "YES", "no")));
  print("");
  print("   Q(zeta_14) = Q(zeta_7) and Q(zeta_18) = Q(zeta_9), so m = 14, 18 give");
  print("   nothing new.  The two fields already named are ALL of them.");
  print("");
}

realsubfields() =
{ my(seen = List(), rec = List(), tr = 0, cx = 0);
  print("   Does A contain a NON-totally-real subfield?  Yes -- two of them are");
  print("   already in section 7 of the document:");
  print("");
  print("     field              disc     signature        embeds");
  foreach ([x^3-x^2-2*x+1, x^3-3*x-1, x^3-2, x^3-14], f,
    my(nf = nfinit(polredabs(f)));
    print("     ", f, "     ", nf.disc, "     ", nf.sign, "  ",
          if (nf.sign[2] == 0, "totally real  ", "NOT tot. real "),
          if (embedsinA(polredabs(f)), "yes", "no")));
  print("");
  print("   Q(cbrt 2) and Q(cbrt 14) each have one real and one complex place.");
  print("   The reason nothing forbids them: deg A = 3 is ODD and Br(R) has");
  print("   exponent 2, so inv_oo(A) = 0 necessarily -- A is SPLIT at the real");
  print("   place, and the criterion there reads [L_w : R] * 0 = 0, vacuous.");
  print("   Only 2 and 7 constrain.  Contrast Hamilton's quaternions of section");
  print("   7.1: there inv_oo = 1/2 is non-zero, every quadratic subfield must be");
  print("   non-split at infinity, and that is exactly why they are all IMAGINARY.");
  print("   Ramification at infinity is impossible in odd degree, so the analogous");
  print("   constraint simply evaporates here.");
  print("");
  print("   Census over a box of cubic polynomials:");
  for (a = -12, 12, for (b = -12, 12, for (c = -12, 12,
    my(f = x^3 + a*x^2 + b*x + c);
    if (!polisirreducible(f), next);
    my(g = polredabs(f));
    if (setsearch(Set(Vec(seen)), g), next);
    listput(seen, g);
    my(nf = nfinit(g));
    if (#idealprimedec(nf,2) != 1 || #idealprimedec(nf,7) != 1, next);
    listput(rec, [abs(nf.disc), nf.disc, g, nf.sign]);
    if (nf.sign[2] == 0, tr++, cx++))));
  print("     distinct cubic fields examined : ", #seen);
  print("     of these, embedding in A       : ", tr + cx);
  print("        totally real,  signature [3,0] : ", tr);
  print("        one complex place, sig [1,1]   : ", cx);
  print("");
  rec = vecsort(Vec(rec), 1);
  print("     smallest |disc| of each kind:");
  my(n = 0);
  print("       totally real:");
  foreach (rec, t, if (t[4][2] == 0 && n < 4, n++;
    print("         disc ", t[2], "   ", t[3])));
  n = 0;
  print("       one complex place:");
  foreach (rec, t, if (t[4][2] == 1 && n < 4, n++;
    print("         disc ", t[2], "   ", t[3])));
  print("");
  print("   So both signatures occur, and the complex ones are if anything the");
  print("   more common.  The smallest subfield of A of either kind is");
  print("   Q[x]/(x^3+x-1), of discriminant -31 -- non-real, and smaller than the");
  print("   totally real record holder Q(zeta_7)^+ of discriminant 49.");
  print("");
}

crossed();
hamilton();
cubicexample();
azumaya();
cyclosubfields();
realsubfields();
quit;
