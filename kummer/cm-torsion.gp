read("kummer2.gp");

/* =====================================================================
   The CM mechanism at p = 3 for f = x^3 - 2   (document, section 5.2.1)

   E_d : y^2 = x^3 + k with k = -2 d^3.  Its 3-division polynomial is
       psi_3 = 3x^4 + 12 k x = 3 x (x^3 + 4k).
   The linear factor is the j=0 / CM signature: Z[zeta_3] contains
   sqrt(-3) of norm 3 and (3) = (sqrt(-3))^2 is ramified, so every such
   curve has a rational 3-isogeny with kernel {x = 0}.
   In THIS family -4k = 8d^3 = (2d)^3 is a perfect cube, so the quartic
   also splits off x = 2d, giving a second order-3 Galois-stable subgroup
       T_d = (2d, sqrt(6 d^3)),   defined over Q(sqrt(6d)).

   T_d lies in E_d(Q_3)  <=>  6d is a square in Q_3
                         <=>  v_3(d) odd and unit part = 2 mod 3
                         <=>  d is in the square class [u*3].
   That is exactly the class in which no witness is found.
   ===================================================================== */

PREC = 60;

inE1(P, p) = (P == [0]) || (valuation(P[1], p) < 0);

/* is the 3-torsion point T_d = (2d, sqrt(6d^3)) defined over Q_3 ? */
torsionQ3(d) = {
  my(s = 6*d^3, v);
  if(s == 0, return(0));
  v = valuation(s, 3);
  (v % 2 == 0) && (kronecker(s / 3^v, 3) == 1);
}

/* one row of the correlation table */
row(d) = {
  my(td = twistdata(0, -2, d), sq = torsionQ3(d));
  print("  d=", d, "\tclass [", sqclassname(sqclass(d,3), 3), "]",
        "\t6d^3=", 6*d^3,
        "\tsquare in Q_3? ", if(sq, "YES", "no "),
        "\tc_3=", elllocalred(td[1], 3)[4],
        "\tM=", Mval(td[1], 3),
        "\tE_d(Q_3) torsion: ", if(sq, "Z/3", "trivial"));
}

/* verify the claim on every squarefree |d| <= D lying in class [3] or [u*3] */
correlate(D) = {
  my(d, n, sg, cl, bad = 0, tot = 0);
  for(n = 1, D,
    if(!issquarefree(n), next);
    for(sg = 0, 1,
      d = if(sg == 0, n, -n);
      cl = sqclass(d, 3);
      if(cl < 2, next);                       /* only the two ramified classes */
      tot++;
      if(torsionQ3(d) != (cl == 3), bad++;
         print("  MISMATCH at d=", d, " class ", cl))
    )
  );
  print("  checked ", tot, " twists in classes [3] and [u*3]: ",
        bad, " mismatches with the prediction");
}

/* structure of E_d(Q_3)/E_1 read off from Q_3-points (not rational ones) */
structure(d) = {
  my(k = -2*d^3, Ep, L, R, Q, new, s, y, ords);
  Ep = ellinit([0, k + O(3^PREC)]);
  L = List();
  for(x0 = -600, 600,
    s = x0^3 + k;
    if(s == 0 || valuation(s,3) % 2, next);
    if(kronecker(s / 3^valuation(s,3), 3) != 1, next);
    y = sqrt(s + O(3^PREC));
    listput(L, [x0 + O(3^PREC), y]); listput(L, [x0 + O(3^PREC), -y])
  );
  R = List();
  for(i = 1, #L,
    new = 1;
    for(j = 1, #R,
      Q = ellsub(Ep, L[i], R[j]);
      if(inE1(Q,3), new = 0; break()));
    if(new, listput(R, L[i]))
  );
  ords = vector(#R, i,
    my(P = R[i], Q = R[i], o = 0);
    for(n = 1, 20, if(inE1(Q,3), o = n; break()); Q = elladd(Ep, Q, P)); o);
  print("  d=", d, ": E_d(Q_3)/E_1 has ", #R + 1, " elements, orders of the ",
        #R, " non-trivial cosets = ", vecsort(ords),
        if(vecmax(ords) == #R + 1, Str("  => cyclic Z/", #R + 1), "  => (Z/3)^2"));
}
