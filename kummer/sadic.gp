read("kummer2.gp");

/* =====================================================================
   S-adic density   (document, section 2.2)

   X(Q_S) = prod_{p in S} X(Q_p) with the product topology.

   For one twist E_d, density of E_d(Q) in the PRODUCT prod_p E_d(Q_p) is
   what makes X(Q) dense in the corresponding component of X(Q_S).  Density
   in each factor SEPARATELY is strictly weaker: a closed subgroup can
   surject onto every factor without being the whole product.

   The two agree when the factors have pairwise coprime supernatural order.
   Since E_d(Q_p) = Z_p x T_p has order p^infinity * |T_p| and T_p embeds in
   E_d(Q_p)/E_1, that is implied by

       (*)  the integers p * M_p(d), p in S, are pairwise coprime.

   Counterexample when (*) fails: f = x^3+x+1, d = 1, S = {5,7}.  There
   M_5 = 9 and M_7 = 5, so E(Q_5)/5 x E(Q_7)/5 = F_5 x F_5, onto which the
   cyclic group E(Q) cannot surject -- yet E(Q) is dense in each factor.
   ===================================================================== */

/* the integers p*M_p(d) governing coprimality */
Mstar(Em, S) = vector(#S, i, S[i]*Mval(Em, S[i]));

coprimeS(Em, S) = {
  my(v = Mstar(Em, S), i, j);
  for(i = 1, #v, for(j = i+1, #v, if(gcd(v[i], v[j]) > 1, return(0))));
  1;
}

/* dense in every factor separately */
densefactorwise(Em, pts, S) = {
  my(i);
  for(i = 1, #S, if(!densegroup(Em, pts, S[i]), return(0)));
  1;
}

/* 1  = provably dense in the product (factorwise + coprime)
   0  = provably not (fails in some factor)
  -1  = factorwise dense but (*) fails, so undecided by this test          */
denseS(Em, pts, S) = {
  if(!densefactorwise(Em, pts, S), return(0));
  if(coprimeS(Em, S), return(1));
  -1;
}

/* S-adic square class of d: the tuple of local classes, packed as an index */
sqclassS(d, S) = {
  my(k = 0, i);
  for(i = 1, #S, k = 4*k + sqclass(d, S[i]));
  k;
}

/* For each tuple of square classes, look for a twist witnessing density.
   Sufficiency only needs ONE good d per tuple, so (*) is tested per d.    */
reportS(A, B, S, DMAX) = {
  my(nt = 4^#S, w = vector(nt, i, 0), u = vector(nt, i, 0), d, n, sg, td, k, r, nf, i);
  for(n = 1, DMAX,
    if(!issquarefree(n), next);
    for(sg = 0, 1,
      d = if(sg == 0, n, -n);
      k = sqclassS(d, S) + 1;
      if(w[k] != 0, next);
      td = twistdata(A, B, d);
      if(#td[2] == 0, next);
      r = denseS(td[1], td[2], S);
      if(r == 1, w[k] = d);
      if(r == -1 && u[k] == 0, u[k] = d)
    ));
  nf = 0;
  for(i = 1, nt, if(w[i] != 0, nf++));
  print("  f = x^3+(", A, ")x+(", B, ")   S = ", S);
  print("    tuples of square classes: ", nt, "   witnessed: ", nf);
  for(i = 1, nt,
    if(w[i] != 0,
       print("      tuple ", i-1, " : d = ", w[i])
     , print("      tuple ", i-1, " : none",
             if(u[i] != 0, Str("  (d=", u[i], " is factorwise dense but (*) fails)"), ""))));
  nf == nt;
}
