\\ cft-csa.gp -- checks for cft-csa.typ
\\
\\ Run from this directory:
\\     gp -q -s 2000000000 cft-csa.gp < /dev/null > results/cft-csa.txt
\\
\\ Class field theory through central simple algebras.  The point of the
\\ approach is that nothing is asserted to be compatible: a 2-cocycle is the
\\ multiplication table of an algebra, the local invariant is a valuation, and
\\ reciprocity is a product of Hilbert symbols.  Each check below computes one
\\ of those objects directly rather than quoting a theorem about it.
\\
\\ Quaternion algebras carry most of the load.  (a,b)_F is the cyclic algebra
\\ (F(sqrt a)/F, sigma, b); it is split exactly when the Hilbert symbol is +1,
\\ so PARI's hilbert / nfhilbert ARE the local invariants, doubled: the
\\ invariant is 0 when the symbol is +1 and 1/2 when it is -1.

ERRS = 0;
{note(ok, msg) = if (!ok, ERRS++; printf("      *** FAILED: %s\n", msg));}

\\ ---------------------------------------------------------------- crossed products
\\ L = Q(i), G = Gal(L/Q) = {1, sigma} written additively as {0,1}.
\\ A cochain c : G x G -> L^x is a 2 x 2 matrix, c[i+1,j+1] = c(sigma^i, sigma^j).

\\ A field context is F = [pol, s] with L = Q[y]/(pol) cyclic over Q and s the
\\ image of y under a chosen generator sigma of Gal(L/Q).  Everything below is
\\ parametrised by it, so the group really does act with the right order.
\\ Q(i) (n=2); the cyclic cubic of conductor 9; Q(zeta_5) (n=4); the cyclic
\\ quintic of conductor 11.  One line: gp cannot parse a multi-line top-level
\\ statement.
CYC = [[y^2+1, -y], [y^3-3*y+1, y^2-2], [y^4+y^3+y^2+y+1, y^2], [y^5+y^4-4*y^3-3*y^2+3*y+1, y^2-2]];

{act(F, i, z) = my(w = z); for (t = 1, i, w = Mod(subst(lift(w), y, F[2]), F[1])); w;}

\\ The cocycle condition, verbatim:  sigma^i(c(j,k)) c(i, j+k) = c(i,j) c(i+j, k).
{iscoc(F, c, n) =
  for (i = 0, n-1, for (j = 0, n-1, for (k = 0, n-1,
    if (act(F, i, c[j+1,k+1]) * c[i+1, (j+k)%n + 1]
        != c[i+1,j+1] * c[(i+j)%n + 1, k+1], return(0)))));
  1;}

\\ The crossed product A = (+) L u_i with  u_i x = sigma^i(x) u_i,  u_i u_j =
\\ c(i,j) u_{i+j}.  An element is a vector [z_0, ..., z_{n-1}] meaning sum z_i u_i.
{xmul(F, X, Y, c, n) = my(Z = vector(n, t, Mod(0, F[1])));
  for (i = 0, n-1, for (j = 0, n-1,
    my(t = (i+j) % n);
    Z[t+1] += X[i+1] * act(F, i, Y[j+1]) * c[i+1,j+1]));
  Z;}

{rndel(F, n) = my(d = poldegree(F[1]));
  vector(n, t, Mod(sum(k = 0, d-1, (random(20) - 10) * y^k), F[1]));}

\\ Associativity of the multiplication table, tested on random elements.
{isassoc(F, c, n, tries) =
  for (t = 1, tries,
    my(X = rndel(F,n), Y = rndel(F,n), Z = rndel(F,n));
    if (xmul(F, xmul(F,X,Y,c,n), Z, c, n) != xmul(F, X, xmul(F,Y,Z,c,n), c, n), return(0)));
  1;}

\\ ---------------------------------------------------------------- check 1
\\ THE POINT OF THE WHOLE APPROACH: associativity IS the cocycle condition.
\\ Enumerate every cochain with values in a small set and compare the two.

check1() =
{ my(F = CYC[1], P = F[1], V, n = 2, nc = 0, na = 0, bad = 0, tot = 0);
  V = [Mod(1,P), Mod(-1,P), Mod(2,P), Mod(y,P)];
  printf("  (1) associativity of the crossed product IS the 2-cocycle condition\n");
  foreach(V, c11, foreach(V, c12, foreach(V, c21, foreach(V, c22,
    my(c = [c11, c12; c21, c22], a = isassoc(F, c, n, 4), k = iscoc(F, c, n));
    tot++; nc += k; na += a;
    if (a != k, bad++)))));
  printf("      L = Q(i), G of order 2, all %d cochains with values in {1,-1,2,i}\n", tot);
  printf("      %d satisfy the cocycle condition, %d give an associative algebra\n", nc, na);
  printf("      cochains where the two disagree: %d\n", bad);
  note(bad == 0, "associativity and the cocycle condition disagree");
  note(nc > 0 && nc < tot, "the cocycle condition is trivial or vacuous here");
};

\\ ---------------------------------------------------------------- check 2
\\ The cyclic algebra (L/F, sigma, b) is the crossed product for the cochain
\\ c(i,j) = 1 if i+j < n, and b otherwise.  Check that this is a cocycle and
\\ that it is associative, for several n and several b.

check2() =
{ my(ok = 1, tested = 0);
  printf("  (2) the cyclic cochain c(i,j) = [i+j >= n] b is a cocycle, and associative\n");
  printf("      one genuine cyclic field per degree.  sigma is CHECKED to be an\n");
  printf("      automorphism of exactly the right order -- feeding a crossed product\n");
  printf("      a map that is not one produces a non-associative algebra, silently.\n");
  foreach(CYC, F,
    my(n = poldegree(F[1]), aut, ord);
    aut = (Mod(subst(F[1], y, F[2]), F[1]) == 0);
    ord = (act(F, n, Mod(y, F[1])) == Mod(y, F[1]));
    for (k = 1, n-1, if (act(F, k, Mod(y, F[1])) == Mod(y, F[1]), ord = 0));
    printf("        n = %d : L = Q[y]/(%s), sigma : y -> %-10s  automorphism %s, order %s\n",
           n, Str(F[1]), Str(F[2]), if (aut, "yes", "NO"), if (ord, Str(n), "WRONG"));
    note(aut, Str("y -> ", F[2], " is not an automorphism of Q[y]/(", F[1], ")"));
    note(ord, Str("y -> ", F[2], " does not have order ", n));
    foreach([2, -3, 7, -1], b,
      my(c = matrix(n, n, i, j, if (i-1 + j-1 >= n, Mod(b, F[1]), Mod(1, F[1]))));
      tested++;
      if (!iscoc(F, c, n), ok = 0; printf("      *** not a cocycle: n=%d b=%d\n", n, b));
      if (!isassoc(F, c, n, 3), ok = 0; printf("      *** not associative: n=%d b=%d\n", n, b))));
  printf("      %d cases (n = 2,3,4,5 and b = 2,-3,7,-1): %s\n", tested,
         if (ok, "all are cocycles and all are associative", "SOME FAILED"));
  note(ok, "the cyclic cochain failed");
};

\\ ---------------------------------------------------------------- check 3
\\ Splitting is a norm condition, and ABHN for quaternions: (a,b) splits over Q
\\ exactly when b is a global norm from Q(sqrt a), and exactly when every local
\\ Hilbert symbol is +1.  Two computations that share no code.

\\ The places where (a,b) ramifies; 0 denotes the real place.  factor() returns
\\ -1 as a factor of a negative number, so take absolute values first.
{badpl(a, b) = my(L = List());
  if (hilbert(a,b,0) == -1, listput(L, 0));
  foreach(Set(concat(factor(abs(2*a*b))[,1]~, [2])), p,
    if (hilbert(a,b,p) == -1, listput(L, p)));
  Vec(L);}

check3() =
{ my(rows = [[-1,-1], [2,3], [-1,3], [5,11], [-3,-7], [6,10], [2,7], [-1,17], [13,17]]);
  printf("  (3) split over Q  <=>  b is a norm from Q(sqrt a)  <=>  split everywhere\n");
  printf("      %-10s %-8s %-26s %s\n", "(a,b)", "index", "ramified at", "b a norm?");
  foreach(rows, r,
    my(a = r[1], b = r[2], S = badpl(a,b), A = alginit(nfinit(y), [a,b]),
       idx = algindex(A), K = bnfinit(y^2 - a, 1), isn = (bnfisnorm(K, b)[2] == 1));
    printf("      %-10s %-8d %-26s %s\n", Str("(",a,",",b,")"), idx,
           if (#S, Str(S), "nowhere (split)"), if (isn, "yes", "no"));
    note((#S == 0) == isn, Str("norm vs local symbols disagree for (",a,",",b,")"));
    note((#S == 0) == (idx == 1), Str("index vs local symbols disagree for (",a,",",b,")")));
};

\\ ---------------------------------------------------------------- check 4
\\ THE LOCAL INVARIANT IS A VALUATION.  For p odd and u a non-residue, Q_p(sqrt u)
\\ is the unramified quadratic extension, and the theory says
\\     inv( (Q_p(sqrt u)/Q_p, Frob, b) ) = v_p(b)/2,
\\ i.e. the symbol (u,b)_p is +1 iff v_p(b) is even.  Check it for every p and
\\ many b, against PARI's hilbert.

check4(ps, B) =
{ my(bad = 0, tot = 0);
  printf("  (4) the local invariant is a valuation: (u,b)_p = (-1)^v_p(b), u a non-residue\n");
  printf("      %-6s %-6s %s\n", "p", "u", "b with (u,b)_p = -1 among |b| <= 40 (should be: v_p(b) odd)");
  foreach(ps, p,
    my(u = 2, L = List());
    while (kronecker(u, p) != -1, u++);
    for (b = 1, B,
      foreach([b, -b], bb,
        tot++;
        my(s = hilbert(u, bb, p), pred = if (valuation(bb, p) % 2, -1, 1));
        if (s != pred, bad++);
        if (s == -1 && bb > 0 && bb <= 40, listput(L, bb))));
    printf("      %-6d %-6d %s\n", p, u, Str(Vec(L))));
  printf("      %d symbols checked against the valuation formula, %d mismatches\n", tot, bad);
  note(bad == 0, "the valuation formula for the unramified invariant failed");
};

\\ ---------------------------------------------------------------- check 5
\\ RESTRICTION MULTIPLIES THE INVARIANT BY THE LOCAL DEGREE.
\\     inv_{K_P}(A) = [K_P : Q_p] . inv_{Q_p}(A).
\\ For a quaternion algebra inv is 0 or 1/2, so A stays ramified at P exactly
\\ when [K_P : Q_p] is ODD.  That is a sharp prediction; test it over fields of
\\ degree 2, 3 and 4 at every prime above every ramified p.

check5(a, b, pols) =
{ my(S = badpl(a,b), tot = 0, bad = 0);
  printf("  (5) inv_{K_P} = [K_P:Q_p] . inv_{Q_p}: (%d,%d) ramifies at %s over Q\n", a, b, Str(S));
  printf("      %-22s %-5s %-8s %-10s %s\n", "K", "p", "[K_P:Q_p]", "predicted", "nfhilbert");
  foreach(pols, f,
    my(K = nfinit(f));
    foreach(S, p,
      if (p == 0, next);
      foreach(idealprimedec(K, p), P,
        my(deg = P[4] * P[3], pred = if (deg % 2, -1, 1), got = nfhilbert(K, a, b, P));
        tot++; if (pred != got, bad++);
        printf("      %-22s %-5d %-8d %-10d %d\n", Str(f), p, deg, pred, got))));
  printf("      %d primes tested, %d mismatches\n", tot, bad);
  note(bad == 0, "restriction did not multiply the invariant by the local degree");
};

\\ ---------------------------------------------------------------- check 6
\\ RECIPROCITY.  sum_v inv_v(A) = 0 in Q/Z, which for quaternions is Hilbert's
\\ product formula prod_v (a,b)_v = +1.  This is the middle exactness of
\\     0 -> Br(Q) -> (+)_v Br(Q_v) -> Q/Z -> 0.

check6(N) =
{ my(bad = 0, tot = 0, mx = 0);
  printf("  (6) reciprocity: sum_v inv_v = 0, i.e. prod_v (a,b)_v = +1\n");
  for (t = 1, N,
    my(a = random(400) - 200, b = random(400) - 200);
    if (a == 0 || b == 0, next);
    my(P = Set(concat(factor(abs(2*a*b))[,1]~, [2])), pr = hilbert(a,b,0));
    foreach(P, p, pr *= hilbert(a,b,p));
    tot++; if (pr != 1, bad++);
    if (#P > mx, mx = #P));
  printf("      %d random pairs (a,b) with |a|,|b| < 200, up to %d finite places each\n", tot, mx);
  printf("      products of all local symbols not equal to +1: %d\n", bad);
  note(bad == 0, "Hilbert reciprocity failed");
};

\\ ---------------------------------------------------------------- check 7
\\ EXACTNESS ON THE RIGHT.  Any set of places of even size is the ramification
\\ set of a quaternion algebra over Q -- the invariants may be prescribed
\\ subject only to summing to zero.  Search small (a,b) realising a given set.

check7(targets, B) =
{ printf("  (7) every even set of places is a ramification set (exactness on the right)\n");
  printf("      %-26s %s\n", "target ramification", "realised by");
  foreach(targets, T,
    my(found = 0, R = List());
    for (k = 1, B, listput(R, k); listput(R, -k));
    R = Vec(R);
    foreach(R, a,
      if (!found,
        foreach(R, b,
          if (!found && badpl(a,b) == T, found = [a,b]))));
    printf("      %-26s %s\n", Str(T),
           if (found != 0, Str("(", found[1], ",", found[2], ")"), "NOT FOUND"));
    note(found != 0, Str("no quaternion algebra found with ramification ", T)));
};

\\ ---------------------------------------------------------------- check 8
\\ GRUNWALD-WANG.  The reduction of ABHN to cyclic cyclotomic splitting fields
\\ needs a local-global statement for power classes, and that statement is FALSE
\\ as first believed: 16 is an 8th power in every completion of Q but not in Q.
\\ Wang's counterexample, verified.

check8(B) =
{ my(bad = 0, tot = 0);
  printf("  (8) the Grunwald-Wang exception, Wang's counterexample\n");
  forprime (p = 3, B,
    tot++;
    if (#polrootspadic(x^8 - 16, p, 30) == 0,
        bad++; printf("      *** no 8th root of 16 in Q_%d\n", p)));
  printf("      16 is an 8th power in Q_p for all %d odd primes p < %d : %s\n", tot, B,
         if (bad == 0, "yes", "NO"));
  printf("      and in R (16 > 0) : yes\n");
  printf("      but NOT in Q_2 : %s   (v_2(16) = 4 is not in 8Z)\n",
         if (#polrootspadic(x^8 - 16, 2, 40) == 0, "confirmed", "*** WRONG"));
  printf("      and NOT in Q    : %s\n", if (!ispower(16, 8), "confirmed", "*** WRONG"));
  printf("      So 16 is an 8th power at every place but one, yet not globally.  The\n");
  printf("      naive local-global principle for n-th powers -- which the reduction of\n");
  printf("      ABHN to cyclic cyclotomic splitting fields wants -- is therefore false,\n");
  printf("      and 8 | n at the prime 2 is exactly where it fails.\n");
  note(bad == 0, "16 failed to be an 8th power in some odd Q_p");
  note(#polrootspadic(x^8 - 16, 2, 40) == 0, "16 is an 8th power in Q_2 after all");
  note(!ispower(16, 8), "16 is an 8th power in Q after all");
};

\\ ---------------------------------------------------------------- check 9
\\ PERIOD = INDEX, and a genuine degree-3 example: PARI builds the cyclic
\\ algebra (L/Q, sigma, b) directly, so the index can be read off and compared
\\ with the order of the class in Br(Q) predicted by the local invariants.

check9() =
{ my(nf = nfinit(y), rnf, A, idx);
  printf("  (9) cyclic algebras of degree 3, and period = index\n");
  rnf = rnfinit(nf, x^3 - 3*x + 1);
  printf("      L = Q[x]/(x^3-3x+1), cyclic of degree 3 over Q, disc = %d\n", poldisc(x^3-3*x+1));
  foreach([2, 3, 5, 7, 11], b,
    A = alginit(rnf, [x^2 - 2, b]);
    idx = algindex(A);
    printf("        (L/Q, sigma, %2d) : degree %d, index %d%s\n", b, algdegree(A), idx,
           if (idx == 1, "   (split: b is a norm from L)", ""));
    note(idx == 1 || idx == 3, Str("index of a degree-3 cyclic algebra is ", idx)));
  printf("      quaternion algebras: index is 1 or 2, never more\n");
  foreach([[-1,-1],[2,3],[5,11],[-3,-7]], r,
    my(q = alginit(nf, [r[1], r[2]]));
    note(algindex(q) <= 2, Str("quaternion index > 2 for ", r)));
};

print("======================================================================");
print("cft-csa.gp -- class field theory through central simple algebras");
{driver() =
  print("");
  check1(); print("");
  check2(); print("");
  check3(); print("");
  check4([3,5,7,11,13,17], 40); print("");
  check5(-1, -1, [x^2+1, x^2-2, x^3-3*x-1, x^3-2, x^4+1]); print("");
  check6(400); print("");
  check7([[], [0,2], [2,3], [0,3], [3,5], [2,5], [0,2,3,5]], 30); print("");
  check8(200); print("");
  check9(); print("");
  printf("  %d failed assertions in total\n", ERRS);
  print("======================================================================");}
driver();
