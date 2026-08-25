/* p-adic density on X : y^2 = f(x) f(t),  f = x^3 + A x + B
   X = Kum(E x E),  E : v^2 = f(u)
   Twist E_d : d v^2 = f(u)  ~  Y^2 = X^3 + A d^2 X + B d^3   (X=du, Y=d^2 v)
   For t0 in Q with f(t0) = d c^2 (d squarefree), E_d has the point (d*t0, d^2*c).
*/

PREC = 80;

/* q rational nonzero -> [d,c] with q = d*c^2, d squarefree integer */
sqfreepart(q) = {
  my(n = numerator(q), m = denominator(q), N = n*m, fa, d = 1, c = 1/m);
  fa = factor(N);
  for(i = 1, #fa~,
    my(pp = fa[i,1], e = fa[i,2]);
    if(e % 2, d *= pp);
    c *= pp^(e \ 2)
  );
  [d, c];
}

/* square class of d in the group Qp-star modulo squares, p odd: returns 0,1,2,3 */
sqclass(d, p) = {
  my(v = valuation(d, p), u = d / p^v);
  2*(v % 2) + if(kronecker(u, p) == 1, 0, 1);
}
sqclassname(k, p) = if(k == 0, "1", k == 1, "u", k == 2, Str(p), Str("u*",p));

/* Is <P> dense in E(Qp)?  Em must ALREADY be a minimal model, Pm on it, p odd. */
densecyclic(Em, Pm, p) = {
  my(ap, lr, M, m, Ep, Pp, dv, Epad, Ppad, Q);
  ap = ellap(Em, p);
  lr = elllocalred(Em, p);
  M  = if(lr[2] == 1, lr[4]*(p + 1 - ap), lr[4]*(p - ap));
  if(M == 0, return(0));
  /* least m>0 with m*P in E_1 : must divide M */
  Epad = ellinit([Em.a1 + O(p^PREC), Em.a2 + O(p^PREC), Em.a3 + O(p^PREC),
                  Em.a4 + O(p^PREC), Em.a6 + O(p^PREC)]);
  Ppad = [Pm[1] + O(p^PREC), Pm[2] + O(p^PREC)];
  if(valuation(Pm[1], p) < 0, return(0));   /* P already in E_1 => cannot surject */
  dv = divisors(M);
  m = 0;
  for(i = 1, #dv,
    Q = ellmul(Epad, Ppad, dv[i]);
    if(Q == [0] || valuation(Q[1], p) < 0, m = dv[i]; break())
  );
  if(m == 0 || m != M, return(0));
  Q = ellmul(Epad, Ppad, M);
  if(Q == [0], return(0));                  /* torsion */
  if(valuation(Q[1], p) != -2, return(0));
  1;
}

/* main scan */
scan(A, B, PMAX, HN, HD, DMAX) = {
  my(disc = -16*(4*A^3 + 27*B^2), prs, res, tlist, good = List());
  if(disc == 0, error("f has a repeated root"));
  prs = primes([3, PMAX]);
  res = Map();
  for(i = 1, #prs, mapput(res, prs[i], vector(4, j, 0)));

  tlist = List();
  for(b = 1, HD, for(a = -HN, HN, if(gcd(a,b) == 1, listput(tlist, a/b))));

  for(i = 1, #tlist,
    my(t0 = tlist[i], q = t0^3 + A*t0 + B);
    if(q == 0, next);
    my(dc = sqfreepart(q), d = dc[1], c = dc[2]);
    if(abs(d) > DMAX, next);
    my(E = ellinit([A*d^2, B*d^3]), P = [d*t0, d^2*c], v, Em, Pm);
    if(!ellisoncurve(E, P), error("point not on curve"));
    Em = ellminimalmodel(E, &v);
    Pm = ellchangepoint(P, v);
    for(j = 1, #prs,
      my(p = prs[j], k = sqclass(d, p), w = mapget(res, p));
      if(w[k+1] != 0, next);
      if(densecyclic(Em, Pm, p), w[k+1] = [t0, d]; mapput(res, p, w))
    )
  );

  print("f(x) = x^3 + ", A, "*x + ", B, "   disc(E) = ", disc);
  for(j = 1, #prs,
    my(p = prs[j], w = mapget(res, p), nf = 0);
    for(k = 1, 4, if(w[k] != 0, nf++));
    if(nf == 4,
      listput(good, p);
      print("  p = ", p, "  ALL 4 classes:  ",
        strjoin(vector(4, k, Str(sqclassname(k-1,p), ": t0=", w[k][1], ",d=", w[k][2])), "   "))
    , print("  p = ", p, "  only ", nf, "/4")
    )
  );
  print("GOOD PRIMES: ", Vec(good));
  Vec(good);
}
