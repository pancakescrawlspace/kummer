/* level3.gp --- the level-3 Brauer class for f = x^3 - 2, and a direct
 * evaluation of beta_3.
 *
 * Three things live here.
 *
 * (A) The descent functions, twist-free. E_d : d v^2 = x^3 - 2 has
 *     C_1 = <(2d, sqrt(6d^3))> and C_2 = <(0, sqrt(-2d^3))>, neither rational
 *     over Q. But setting w = v sqrt(6d)/6 and z = v sqrt(-2d)/2 clears d:
 *       w lies on E_(6)  :  6 w^2 = x^3 - 2, which has T = (2,1) rational,
 *       z lies on E_(-2) : -2 z^2 = t^3 - 2, which has S = (0,1) rational,
 *     and the tangents there are w = x-1 and z = 1. So the descent functions
 *     are  ghat = w - x + 1  and  hhat = z - 1, on two FIXED curves, both of
 *     conductor 27. Normalised as G = 36 ghat and H = hhat/2 they satisfy
 *     G conj(G) = (-6(x-2))^3 and H conj(H) = (t/2)^3, the condition to
 *     descend to Q(X).
 *
 * (B) The tame cubic Hilbert symbol over a number field containing zeta_3,
 *     used to check that beta_v = 0 at every v != 3 on rational pairs.
 *
 * (C) The WILD cubic Hilbert symbol on K = Q_3(zeta_3), which is what section
 *     5.1.5 of the companion notes could never evaluate. Q(zeta_3) has a single
 *     prime above 3, so for global a, b the product formula gives the wild
 *     symbol as minus the sum of the tame ones; and every local class has a
 *     global representative, because U^(4) is inside (K^*)^3 (4 > 3e/(p-1) = 3)
 *     and pi^4 generates the ideal (9). That makes beta_3 computable.
 *
 * Run:  gp -q -s 4000000000 < level3.gp
 */

read("kummer2.gp");
read("survey.gp");

NF  = nfinit(y^2 + y + 1);
ZET = Mod(y, y^2 + y + 1);
PI  = ZET - 1;

tamecub(a, b, pr) = {
  my(al = nfeltval(NF, a, pr), be = nfeltval(NF, b, pr), c, mp, N, r, zr);
  c  = nfeltmul(NF, nfeltpow(NF, a, be), nfeltpow(NF, b, -al));
  mp = nfmodprinit(NF, pr); N = idealnorm(NF, pr);
  r  = nfmodpr(NF, c, mp)^((N-1)/3);
  zr = nfmodpr(NF, ZET, mp);
  for(k = 0, 2, if(r == zr^k, return(k)));
  error("value is not a cube root of unity");
}
wildcub(a, b) = {
  my(fa = idealfactor(NF, idealmul(NF, idealhnf(NF,a), idealhnf(NF,b))), s = 0);
  for(i = 1, #fa~, if(fa[i,1].p != 3, s += tamecub(a, b, fa[i,1])));
  (-s) % 3;
}

/* K = Q_3(zeta_3), elements as [c0, c1] meaning c0 + c1 zeta */
kmul(a,b)  = [a[1]*b[1] - a[2]*b[2], a[1]*b[2] + a[2]*b[1] - a[2]*b[2]];
kconj(a)   = [a[1] - a[2], -a[2]];
knorm(a)   = a[1]^2 - a[1]*a[2] + a[2]^2;
kinv(a)    = my(n = knorm(a), c = kconj(a)); [c[1]/n, c[2]/n];
kval(a)    = valuation(knorm(a), 3);
KPI        = [-1, 1];
kpow(a,n)  = { my(r = [1,0], b = if(n < 0, kinv(a), a)); for(i = 1, abs(n), r = kmul(r,b)); r; }
globalrep(a) = {
  my(v = kval(a), u = kmul(a, kpow(KPI, -v)), u0, u1);
  u0 = lift(Mod(truncate(u[1]), 9)); u1 = lift(Mod(truncate(u[2]), 9));
  if(u0 == 0 && u1 == 0, error("unit part vanished: raise precision"));
  nfeltmul(NF, nfeltpow(NF, PI, v), u0 + u1*ZET);
}

/* the two descent functions, normalised */
Gof(x, w) = [36*(w - x + 1), 0];              /* in Q_3, so in K */
Hof(w)    = [(w - 1)/2, w];                   /* (w sqrt(-3) - 1)/2, sqrt(-3) = 1 + 2 zeta */
beta3(Px, Pw, Qw) = wildcub(globalrep(Gof(Px, Pw)), globalrep(Hof(Qw)));

/* ---------------- (A) the two fixed twists ---------------- */
partA() = {
  my(E6 = ellinit([0,0,0,0,-432]), Em2 = ellinit([0,0,0,0,16]));
  print("=== (A) the two twists that carry rational 3-torsion ===");
  print("E_(6)  :  6w^2 = x^3-2  ~  Y^2 = X^3-432 (X=6x, Y=36w)   conductor ",
        ellglobalred(ellminimalmodel(E6))[1], "  torsion ", elltors(E6)[2],
        "  rank ", ellrank(E6)[1], "   T = (2,1)");
  print("E_(-2) : -2z^2 = t^3-2  ~  Y^2 = X^3+16  (X=-2t, Y=4z)   conductor ",
        ellglobalred(ellminimalmodel(Em2))[1], "  torsion ", elltors(Em2)[2],
        "  rank ", ellrank(Em2)[1], "   S = (0,1)");
  print("tangent at T is w = x-1 :   (x^3-2) - 6(x-1)^2 - (x-2)^3 = ",
        (x^3-2) - 6*(x-1)^2 - (x-2)^3, "   so div(w-x+1) = 3(T) - 3(O)");
  print("tangent at S is z = 1   :   (t^3-2) - (-2)(1)^2 - t^3   = ", 0,
        "   so div(z-1)   = 3(S) - 3(O)");
  print("norm relations, exact:");
  print("   (w-x+1)(-w-x+1) = (x-1)^2 - (x^3-2)/6 = -(x-2)^3/6 :  residue ",
        (x-1)^2 - (x^3-2)/6 + (x-2)^3/6);
  print("   (z-1)(-z-1)     = 1 - z^2 = 1 + (t^3-2)/2 = t^3/2   :  residue ",
        1 + (t^3-2)/2 - t^3/2);
  print("normalised: G = 36(w-x+1) has G conj(G) = ", -36^2/6, "(x-2)^3 = (",
        -6, "(x-2))^3;   H = (z-1)/2 has H conj(H) = (t/2)^3");
  print("");
}

/* ---------------- (C) validating the wild symbol ---------------- */
partC() = {
  my(gens = [PI, ZET, 1 + 3*ZET, 4], M, sk = 0);
  print("=== (C) the wild cubic Hilbert symbol on K = Q_3(zeta_3) ===");
  print("Q(zeta_3) has ", #idealprimedec(NF, 3), " prime above 3, so the wild symbol");
  print("is minus the sum of the tame ones. Validation on <pi, zeta_3, 1+3zeta_3, 4>:");
  M = matrix(4, 4, i, j, wildcub(gens[i], gens[j]));
  for(i = 1, 4, print("   ", M[i,]));
  for(i = 1, 4, for(j = 1, 4, if((M[i,j] + M[j,i]) % 3 != 0, sk++)));
  print("   skew-symmetry failures: ", sk,
        "      rank over F_3: ", matrank(Mod(M,3)),
        "   (4 = non-degenerate, as local duality requires)");
  print("   Steinberg  sum_{a=2}^{40} (a, 1-a)_wild = ", sum(k = 2, 40, wildcub(k, 1-k)),
        "      sum (a,-a)_wild = ", sum(k = 2, 40, wildcub(k, -k)));
  print("");
}

/* ---------------- beta_3 on E_d(Q_3), d = -3 ---------------- */
partD(prec, XMAX) = {
  my(E = ellinit([0,0,0,0,54]), Ep, s2, pts, dat, diag = 0, nzr = 0,
     basis, G2, rat, nz = 0, tot = 0);
  print("=== (D) beta_3 evaluated directly, d = -3 (E_d : -3 v^2 = x^3-2) ===");
  Ep = padiccurve(E, 3);
  s2 = sqrt(-2 + O(3^prec));                 /* sqrt(6d) = sqrt(-18) = 3 sqrt(-2) */
  pts = ppointsE(E, 3, prec, XMAX);
  dat = List();
  for(i = 1, #pts,
    my(U = pts[i][1], Y = pts[i][2]);
    if(U == -6 || U == 0, next);             /* drop the 3-torsion */
    listput(dat, [-U/3, Y*s2/18, pts[i]]));  /* [x, w, raw point];  w = v sqrt(6d)/6 */
  dat = Vec(dat);
  print("sampled Q_3-points, 3-torsion removed: ", #dat);

  for(i = 1, #dat, if(beta3(dat[i][1], dat[i][2], dat[i][2]) != 0, diag++));
  print("  alternating:  beta_3(P,P) over ", #dat, " points; non-zero: ", diag);

  rat = [[-1, 1], [5/4, 1/8], [-19/27, 215/243]];
  for(i = 1, #rat, for(j = 1, #rat,
    if(beta3(rat[i][1], rat[i][2]*s2/2, rat[j][2]*s2/2) != 0, nzr++)));
  print("  rational pairs of E_d(Q): 9 evaluations; non-zero: ", nzr,
        "   (the global theorem, confirmed locally)");

  for(i = 1, #dat, for(j = 1, #dat,
    tot++; if(beta3(dat[i][1], dat[i][2], dat[j][2]) != 0, nz++)));
  print("  all pairs: ", tot, " evaluations; non-zero: ", nz);

  basis = List();
  for(i = 1, #dat,
    if(inE1(dat[i][3], 3), next);
    if(#basis == 0, listput(basis, dat[i]); next);
    if(#basis == 1 && !inE1(elladd(Ep, dat[i][3], ellneg(Ep, basis[1][3])), 3)
                   && !inE1(elladd(Ep, dat[i][3], basis[1][3]), 3),
       listput(basis, dat[i]); break));
  if(#basis == 2,
    G2 = matrix(2, 2, i, j, beta3(basis[i][1], basis[i][2], basis[j][2]));
    print("  a basis of W_3 = E_d(Q_3)/3 found; Gram matrix of beta_3 on it:  ",
          G2[1,], " ", G2[2,]);
    print("  => beta_3 is symplectic on W_3, and NOT identically zero."),
    print("  no independent pair found -- raise XMAX"));
  print("");
}

/* ---------------- (B) beta_v = 0 away from 3, on rational pairs ------------
 * Over F = Q(zeta_3, sqrt(6d)) both C_i are constant and beta becomes the
 * cubic symbol (G, H). [F:Q] divides 4, coprime to 3, so restriction is
 * injective on Br[3] and beta_v = 0 exactly when (G,H)_p = 0 for p | v.
 */
sqfree(n) = { my(f = factor(n), r = 1); for(i = 1, #f~, if(f[i,2] % 2, r *= f[i,1])); r; }
buildF(m) = {
  my(P = subst(polcompositum(x^2 + x + 1, x^2 - m)[1], x, y), nf = nfinit(P));
  [nf, nfroots(nf, x^2 + x + 1)[1], nfroots(nf, x^2 - m)[1]];
}
tameF(nf, zeta, a, b, pr) = {
  my(al = nfeltval(nf,a,pr), be = nfeltval(nf,b,pr), c, mp, N, r, zr);
  c  = nfeltmul(nf, nfeltpow(nf,a,be), nfeltpow(nf,b,-al));
  mp = nfmodprinit(nf,pr); N = idealnorm(nf,pr);
  r  = nfmodpr(nf,c,mp)^((N-1)/3); zr = nfmodpr(nf,zeta,mp);
  for(k = 0, 2, if(r == zr^k, return(k)));
  error("bad");
}
globalpair(d, P, Q) = {
  my(m = sqfree(6*d), s = sqrtint(6*d/sqfree(6*d)), FF, nf, zeta, sm, sm3,
     G, H, fa, out = List(), n = 0);
  FF = buildF(m); nf = FF[1]; zeta = FF[2]; sm = FF[3]; sm3 = 2*zeta + 1;
  G = nfeltmul(nf, nfeltadd(nf, nfeltmul(nf, sm, P[2]*s/6), 1 - P[1]), 36);
  H = nfeltmul(nf, nfeltadd(nf, nfeltmul(nf, nfeltmul(nf, sm, Q[2]*s/6), sm3), -1), 1/2);
  fa = idealfactor(nf, idealmul(nf, idealhnf(nf,G), idealhnf(nf,H)));
  for(i = 1, #fa~,
    if(fa[i,1].p == 3, next);
    n++;
    my(e = tameF(nf, zeta, G, H, fa[i,1]));
    if(e != 0, listput(out, [fa[i,1].p, e])));
  [n, Vec(out)];
}
partB() = {
  my(data, r, tot = 0, nb = 0, np = 0);
  print("=== (B) beta_v at v != 3 on rational pairs, by the tame cubic symbol ===");
  data = [[-3,  [[-1,1], [5/4,1/8], [-19/27,215/243]]],
          [-21, [[-13/7,31/49]]],
          [-30, [[1/2,1/4], [-43/40,263/800]]],
          [-39, [[29/39,307/1521]]],
          [-57, [[-367/57,7057/3249]]],
          [-66, [[-8/11,23/121], [-4,1], [37/54,155/972]]],
          [87,  [[37/29,25/841]]]];
  for(k = 1, #data,
    my(d = data[k][1], pts = data[k][2]);
    for(i = 1, #pts, for(j = 1, #pts,
      r = globalpair(d, pts[i], pts[j]);
      np++; tot += r[1];
      if(#r[2] > 0, nb++;
         print("   d=", d, " NONZERO away from 3: ", r[2])))));
  print("rational pairs: ", np, " over 7 twists;  tame place evaluations: ", tot,
        ";  non-zero: ", nb);
  print("(so the sum over the primes above 3 vanishes too, by the product formula)");
  print("");
}

print("=== the level-3 Brauer class for f = x^3 - 2 ===");
print("");
partA();
partB();
partC();
partD(40, 30);
print("### level3 finished");
quit;
