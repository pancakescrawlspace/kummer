/*  dirichlet-rank-one.gp
 *
 *  The unit theorem in the two cases of rank one:
 *
 *      real quadratic     signature (2,0)      O^x = <-1> x <eps>
 *      complex cubic      signature (1,1)      O^x = <-1> x <eps>
 *
 *  A cubic field has r_1 + r_2 - 1 = 1 iff (r_1,r_2) = (1,1), i.e. iff it has
 *  a complex place, i.e. iff d_K < 0.  Both proofs below avoid Minkowski's
 *  convex body theorem and the logarithmic embedding entirely: discreteness
 *  comes from bounded symmetric functions, existence from the box principle.
 */

\\ ---------------------------------------------------------------- check 1 --
{check1(ds, fs) =
  print("  (1) the two families of unit rank one");
  print("      field                     disc      sig     rank  mu(K)  Galois?");
  foreach(ds, d, my(K = bnfinit(x^2-d));
    printf("      Q(sqrt %-4d)             %-9d %-7s %-5d %-6d %s\n", d, K.disc,
           K.sign, K.sign[1]+K.sign[2]-1, nfrootsof1(K)[1], "yes"));
  foreach(fs, f, my(K = bnfinit(f));
    printf("      Q[x]/(%-18s) %-9d %-7s %-5d %-6d %s\n", f, K.disc,
           K.sign, K.sign[1]+K.sign[2]-1, nfrootsof1(K)[1],
           if (#nfgaloisconj(K) == 3, "yes", "no")));
  print("      A Galois cubic is CYCLIC, and complex conjugation would be an");
  print("      automorphism of order 2 in a group of order 3, hence trivial: so a");
  print("      Galois cubic is TOTALLY REAL and has unit rank 2.  Every rank-one");
  print("      cubic is therefore non-Galois -- the conjugates do not lie in K.");
  1;}

\\ ---------------------------------------------------------------- check 2 --
/* Discreteness, with no lattice theory.  If u is a unit of a real quadratic
   field with 1 < u <= T then u + u' = Tr(u) in Z and u u' = +-1, so u is a root
   of X^2 - mX +- 1 with |m| <= T + 1: finitely many.  In a complex cubic, a
   unit with sigma_1(u) = t > 0 has |sigma_2(u)| = t^(-1/2) since
   |N(u)| = t |sigma_2(u)|^2 = 1, so all three elementary symmetric functions
   are bounded by a function of t alone -- again finitely many.               */
{fu(K) =                                  \\ fundamental unit, real embedding > 1
  my(e = K.fu[1], t = nfeltembed(K, e)[1]);
  if (abs(t) < 1, e = nfeltpow(K, e, -1));
  e;}

{check2(ds, fs, T) =
  my(ok = 1);
  print("  (2) discreteness with no lattice theory: units in a bounded range");
  print("      real quadratic: u > 1 a unit ==> u + u' = Tr(u) in Z and u u' = +-1,");
  print("      so u is a root of X^2 - m X + s, s = +-1, |m| <= T + 1.  Enumerating");
  print("      those polynomials directly must reproduce the powers of eps:");
  print("      d       eps                #units in (1,T] by bounded m   = floor(log T / log eps)?");
  foreach(ds, d,
    my(K = bnfinit(x^2-d), e = abs(nfeltembed(K, fu(K))[1]), brute = 0, pred);
    pred = floor(log(T)/log(e));
    for (m = -floor(T)-2, floor(T)+2, foreach([1,-1], sg,
      my(D = m^2 - 4*sg);
      if (D > 0 && !issquare(D) && core(D) == core(d),
        my(u = (m + sqrt(D))/2);
        if (u > 1 && u <= T, brute++))));
    if (brute != pred, ok = 0);
    printf("      %-7d %-18.10f %-29d %d\n", d, e, brute, pred));
  print("      complex cubic: |N(u)| = sigma_1(u).|sigma_2(u)|^2 = 1 pins");
  print("      |sigma_2(u)| = sigma_1(u)^(-1/2), so ONE real parameter controls all");
  print("      three conjugates -- which is what unit rank one means.  The three");
  print("      elementary symmetric functions are then bounded, so again finitely many.");
  print("      f                    eps at the real place  |sigma_2(eps)|   product");
  foreach(fs, f,
    my(K = bnfinit(f), e = fu(K), em = nfeltembed(K, e),
       t = abs(real(em[1])), sg = abs(em[2]));
    printf("      %-20s %-22.10f %-16.10f %.10f\n", f, t, sg, t*sg^2);
    if (abs(t*sg^2 - 1) > 1e-8, ok = 0));
  ok;}

\\ ---------------------------------------------------------------- check 3 --
/* Existence for real quadratic, the classical way, with no geometry of numbers.
   Dirichlet's approximation theorem gives infinitely many p/q with
   |p - q sqrt d| < 1/q, hence |p^2 - d q^2| < 1 + 2 sqrt d: BOUNDED.  Pigeonhole
   on the value k and on (p,q) mod |k| gives two solutions whose ratio is a unit.
   The convergents of the continued fraction of sqrt d are such p/q.           */
{convs(d, n) =                            \\ exact CF convergents of sqrt(d)
  my(a0 = sqrtint(d), m = 0, q = 1, a = a0, P = [1, a0], Q = [0, 1], out = List());
  listput(out, [a0, 1]);
  for (i = 1, n,
    m = q*a - m; q = (d - m^2)/q; a = (a0 + m)\q;
    P = [P[2], a*P[2] + P[1]]; Q = [Q[2], a*Q[2] + Q[1]];
    listput(out, [P[2], Q[2]]));
  Vec(out);}

{check3(ds, n) =
  my(ok = 1);
  print("  (3) existence for real quadratic: Dirichlet approximation + pigeonhole");
  print("      d      max |p^2-dq^2|  bound 1+2 sqrt d   collision   unit found   = eps^j");
  foreach(ds, d,
    my(C = convs(d, n), B = 1 + 2*sqrt(d), mx = 0, hit = 0, u = 0, A, Bc, j = 0);
    foreach(C, c, mx = max(mx, abs(c[1]^2 - d*c[2]^2)));
    for (i = 1, #C, for (jj = i+1, #C,
      if (!hit,
        my(pi = C[i][1], qi = C[i][2], pj = C[jj][1], qj = C[jj][2],
           k = pi^2 - d*qi^2);
        if (k != 0 && k == pj^2 - d*qj^2 && (pj-pi) % abs(k) == 0 && (qj-qi) % abs(k) == 0,
          A  = (pj*pi - d*qj*qi)/k;
          Bc = (qj*pi - pj*qi)/k;
          if (Bc != 0, hit = [i,jj]; u = abs(A + Bc*sqrt(d)))))));
    if (!hit, ok = 0; printf("      %-6d no collision in %d convergents\n", d, n),
      my(K = bnfinit(x^2-d), e = abs(nfeltembed(K, fu(K))[1]));
      j = round(log(u)/log(e));
      if (mx >= B || abs(u - e^j) > 1e-6*u, ok = 0);
      printf("      %-6d %-15d %-18.6f (%d,%d)%s %-12.6f eps^%d\n",
             d, mx, B, hit[1], hit[2], if(hit[2]<10,"      ","     "), u, j)));
  print("      Every |p^2 - d q^2| stays under 1 + 2 sqrt d, so the box principle");
  print("      alone -- no Minkowski, no logarithmic embedding -- produces a unit");
  print("      of infinite order.  With (2) that IS the unit theorem here.");
  ok;}

\\ ---------------------------------------------------------------- check 4 --
/* Existence for a complex cubic, by exactly the same two steps one dimension up.
   The box principle in its LINEAR FORM shape: among the (Q+1)^2 numbers
   {y theta + z theta^2}, 0 <= y,z <= Q, two lie in a common bin of width
   1/((Q+1)^2 - 1); subtracting gives |y|,|z| <= Q and an integer x with
       |sigma_1(alpha)| <= 1/((Q+1)^2 - 1),   alpha = x + y theta + z theta^2.
   Meanwhile |sigma_2(alpha)| = O(Q), so |N(alpha)| = |sigma_1| |sigma_2|^2 = O(1)
   -- bounded, uniformly in Q.  Then pigeonhole on (N(alpha), alpha mod N) as
   before: alpha | N(alpha) in O_K, so a collision makes alpha/beta a unit.   */
{smallform(th, th2, Q) =                  \\ the box principle, run
  my(M = (Q+1)^2 - 1, V = vector((Q+1)^2), c = 0, S);
  for (y = 0, Q, for (z = 0, Q, c++; V[c] = [frac(y*th + z*th2), y, z]));
  S = vecsort(V, 1);
  for (i = 1, #S - 1,
    if (S[i+1][1] - S[i][1] <= 1.0/M,
      my(y = S[i+1][2] - S[i][2], z = S[i+1][3] - S[i][3]);
      if (y || z, return([-round(y*th + z*th2), y, z]))));
  0;}

{check4(fs, QMAX) =
  my(ok = 1);
  print("  (4) existence for a complex cubic: the same proof, one dimension up");
  print("      f                    Q range   max |N(alpha)|  collision   unit found      |N(u)|  = eps^j");
  foreach(fs, f,
    my(K = bnfinit(f), th = polrootsreal(f)[1], th2 = th^2,
       A = List(), key = List(), mx = 0, hit = 0, u = 0, j);
    for (Q = 2, QMAX,
      my(t = smallform(th, th2, Q));
      if (t != 0,
        my(al = t[1] + t[2]*x + t[3]*x^2, nm = norm(Mod(al, f)));
        if (nm != 0,
          mx = max(mx, abs(nm));
          listput(A, al);
          listput(key, [nm, lift(Mod(nfalgtobasis(K, Mod(al,f)), abs(nm)))]))));
    for (i = 1, #A, for (jj = i+1, #A,
      if (!hit && key[i] == key[jj] && A[i] != A[jj],
        my(v = nfeltdiv(K, Mod(A[jj],f), Mod(A[i],f)));
        if (denominator(v) == 1 && abs(nfeltnorm(K,v)) == 1
            && abs(abs(nfeltembed(K,v)[1]) - 1) > 1e-9,
          hit = [i,jj]; u = v))));
    if (!hit, ok = 0; printf("      %-20s no collision up to Q = %d\n", f, QMAX),
      my(e = abs(nfeltembed(K, fu(K))[1]), t = abs(nfeltembed(K, u)[1]));
      j = round(log(t)/log(e));
      if (abs(t - e^j) > 1e-6*t, ok = 0);
      printf("      %-20s 2..%-6d %-15d (%d,%d)%s %-15.8f %-7d eps^%d\n",
             f, QMAX, mx, hit[1], hit[2], if(hit[2]<10,"       ","      "),
             t, abs(nfeltnorm(K,u)), j)));
  print("      |N(alpha)| stays bounded as Q grows -- that is the whole content --");
  print("      and the collision produces a unit of infinite order.  Nothing here is");
  print("      harder than (3) except that the pigeonhole is 2-dimensional.");
  ok;}

\\ ---------------------------------------------------------------- check 5 --
/* The sign of N(eps).  In a QUADRATIC field N(-1) = +1, so multiplying by -1
   cannot change the norm and N(eps) = +-1 is a genuine invariant of the field
   (the negative Pell equation).  In a CUBIC field N(-1) = -1, so eps and -eps
   have opposite norms and the sign is normalisable away.                     */
{check5(ds, fs, dd) =
  my(ok = 1, neg = 0, pos = 0);
  print("  (5) the sign of N(eps): an invariant in one case, not in the other");
  printf("      N(-1) = (-1)^n : quadratic %d, cubic %d\n", (-1)^2, (-1)^3);
  print("      d with N(eps) = -1 (negative Pell soluble) vs N(eps) = +1:");
  my(L = List(), M = List());
  foreach(ds, d, my(K = bnfinit(x^2-d), s = nfeltnorm(K, K.fu[1]));
    if (s == -1, neg++; listput(L,d), pos++; listput(M,d)));
  printf("        N = -1 : %s\n", Vec(L));
  printf("        N = +1 : %s\n", Vec(M));
  if (!neg || !pos, ok = 0);
  print("      Necessary: every prime factor of d is 2 or = 1 (mod 4) -- else -1 is a");
  print("      non-residue mod some p | d.  NOT sufficient, and no congruence in d can");
  print("      decide it; the smallest counterexamples pass the test and still fail:");
  my(cx = List());
  foreach(dd, d2, my(K = bnfinit(x^2-d2), okp = 1);
    foreach(factor(d2)[,1]~, q, if (q != 2 && q % 4 != 1, okp = 0));
    if (okp && nfeltnorm(K, K.fu[1]) == 1, listput(cx, d2)));
  printf("        all factors 2 or 1 mod 4, yet N(eps) = +1 : %s\n", Vec(cx));
  if (#cx == 0, ok = 0);
  print("      complex cubic: eps and -eps have opposite norms, so +1 is always");
  print("      available.  Both signs realised on the same field:");
  print("      f                    N(eps)   N(-eps)");
  foreach(fs, f, my(K = bnfinit(f), e = fu(K));
    printf("      %-20s %-8d %d\n", f, nfeltnorm(K,e), nfeltnorm(K, nfeltmul(K,e,-1)));
    if (nfeltnorm(K,e) * nfeltnorm(K, nfeltmul(K,e,-1)) != -1, ok = 0));
  ok;}

\\ ---------------------------------------------------------------- check 6 --
{ccubics(B, R) =                          \\ complex cubic fields, |d_K| <= B
  my(seen = List(), out = List());
  for (a = -R, R, for (b = -R, R, for (c = -R, R,
    my(f = x^3 + a*x^2 + b*x + c);
    if (polisirreducible(f) && poldisc(f) < 0,
      my(g = polredabs(f));
      if (!setsearch(Set(Vec(seen)), g),
        listput(seen, g);
        my(K = bnfinit(g)); if (abs(K.disc) <= B, listput(out, K)))))));
  Vec(out);}

{check6(B, R) =
  my(L = ccubics(B,R), worst = 0, wf = 0, bad = 0);
  print("  (6) Artin's inequality for complex cubics:  |d_K| <= 4 eps^3 + 24");
  foreach(L, K, my(e = abs(nfeltembed(K, fu(K))[1]), r = 4*e^3 + 24, d = abs(K.disc));
    if (d > r, bad++);
    if (d/r > worst, worst = d/r; wf = K.pol));
  printf("      %d complex cubic fields with |d_K| <= %d: %d violations\n", #L, B, bad);
  printf("      sup |d_K|/(4 eps^3 + 24) = %.6f, attained at %s -- essentially sharp\n",
         worst, wf);
  print("      So eps >= ((|d_K| - 24)/4)^(1/3): the fundamental unit of a complex");
  print("      cubic is bounded BELOW by the discriminant.  No such bound holds for");
  print("      real quadratics, where eps is bounded below only by ~ sqrt d.");
  bad == 0;}

\\ ---------------------------------------------------------------- check 7 --
{check7(B, R) =
  print("  (7) how big the regulator gets, in the two families");
  my(mq = 0, mqd = 0, mc = 0, mcd = 0, nq = 0);
  for (d = 2, B, if (core(d) == d,
    my(K = bnfinit(x^2-d)); nq++;
    if (K.reg > mq, mq = K.reg; mqd = d)));
  foreach(ccubics(B,R), K, if (K.reg > mc, mc = K.reg; mcd = K.disc));
  printf("      real quadratic, d <= %-6d : max R = %8.4f at d = %-8d (R/sqrt d = %.4f)\n",
         B, mq, mqd, mq/sqrt(mqd));
  printf("      complex cubic, |d_K| <= %-6d: max R = %8.4f at d = %-8d (R/log|d| = %.4f)\n",
         B, mc, mcd, mc/log(abs(mcd)));
  print("      In this range the real quadratic regulator runs away at the scale of");
  print("      sqrt d, the complex cubic one at the scale of log |d|.  The lower bound");
  print("      is a theorem (Artin, check 6); the upper contrast is only what is");
  print("      observed here -- h.R grows like |d|^(1/2) in both families, and it is");
  print("      how the product splits between h and R that differs.");
  1;}

\\ ---------------------------------------------------------------- check 8 --
{check8(B, R) =
  my(L = ccubics(B,R), g = 0);
  print("  (8) no rank-one cubic is Galois -- the structural difference");
  foreach(L, K, if (#nfgaloisconj(K) == 3, g++));
  printf("      %d complex cubic fields with |d_K| <= %d; Galois ones: %d\n", #L, B, g);
  print("      A cubic Galois over Q is cyclic; complex conjugation would then be an");
  print("      element of order 2 in a group of order 3, hence trivial -- so a Galois");
  print("      cubic is totally real, with unit rank 2.  Consequence for the proof:");
  print("      in Q(sqrt d) the conjugate u' lies IN the field, so Tr(u) and N(u) are");
  print("      visible inside K and the whole argument of (2)-(3) happens there.  In a");
  print("      complex cubic the other two conjugates live outside K and one must work");
  print("      in the Minkowski embedding.  That, and the 2-dimensional pigeonhole, is");
  print("      the entire extra cost.");
  g == 0;}

\\ ===========================================================================
print("======================================================================");
print("dirichlet-rank-one.gp -- the unit theorem where the rank is one");
print();
check1([2,3,5,61], [x^3-x-1, x^3-2, x^3-x^2+x+1]); print();
check2([2,3,5,13,61], [x^3-x-1, x^3-2, x^3-x^2+x+1], 1000); print();
check3([2,3,5,7,13,61,94], 24); print();
check4([x^3-x-1, x^3-2, x^3-x^2+x+1, x^3-3], 40); print();
check5([2,3,5,6,7,10,11,13,15,17,19,26,29,46], [x^3-x-1, x^3-2, x^3-3], [2,5,10,13,17,26,29,34,41,58,65,74,85,89,106,130,145,146,170,185,194,205,221,226]); print();
check6(3000, 12); print();
check7(1000, 10); print();
check8(3000, 12); print();
print("======================================================================");
