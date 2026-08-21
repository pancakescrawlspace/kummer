/* endo.gp --- from an endomorphism of E[ell] to an explicit algebra.
 *
 * A rank-one phi in End_G(E[ell]) is exactly a pair of Galois-stable lines
 * (K, I) = (ker phi, im phi) together with an isomorphism E[ell]/K -> I.
 * The construction of section 7.1 then reads
 *
 *     A_phi = cor_{L(A)/k(A)} ( p_1^* f_I ,  p_2^* f_K )_ell ^ u
 *
 * where f_C is the function on E with div(f_C) = ell(T_C) - ell(O). At ell = 2
 * with rational 2-torsion, L = k and f_{C_m} = x - e_m, so A_phi = (c_I, c_K),
 * one of the nine quaternion algebras below.
 *
 * This script enumerates the rank-one phi and asks, for each, whether the
 * resulting algebra lies in Br(X) -- the criterion of section 7.4.2.
 *
 * Run:  gp -q < endo.gp
 */

fp(e, m) = prod(k = 1, 3, if(k == m, 1, e[m] - e[k]));
resid(e, i, j, a, b) = {
  my(ao = (a != i && a != 0), bo = (b != j && b != 0));
  if(ao && bo, return(-(e[a] - e[i])*(e[b] - e[j])));
  if(ao && b == j, return(fp(e, j)));
  if(a == i && bo, return(fp(e, i)));
  1;
}
unramQ(e, i, j) = {
  for(a = 0, 3, for(b = 0, 3,
    my(r = resid(e, i, j, a, b));
    if(r != 1 && !issquare(r), return(0))));
  1;
}

/* f split over Q: all three lines are stable, so there are 9 rank-one phi */
nine(name, e) = {
  my(n = 0, keep = List());
  print(name, "    roots ", e, "    3 stable lines, so 3 x 3 = 9 rank-one phi");
  for(i = 1, 3, for(j = 1, 3,
    my(u = unramQ(e, i, j));
    n += u;
    if(u, listput(keep, Str("(c_", i, ", c_", j, ")")));
    print("   im phi = C_", i, ",  ker phi = C_", j, "   ->   A = (c_", i, ", c_", j, ")   ",
          if(u, "in Br(X)", "ramified"))));
  print("   ", n, " of 9 lie in Br(X)", if(n, Str(":  ", Vec(keep)), ""));
  print("");
}

/* f = (u - e1) q(u), q irreducible: exactly ONE stable line, so exactly one
   rank-one phi, and the algebra is forced */
one(name, e1, a1, b1) = {
  my(D = a1^2 - 4*b1, K = nfinit(y^2 - D), q1 = e1^2 + a1*e1 + b1, ok);
  ok = (#nfroots(K, x^2 + 1) > 0) && (#nfroots(K, x^2 - q1) > 0)
       && (#nfroots(K, x^2 + q1) > 0);
  print(name, "    e_1 = ", e1, ",  q = u^2 + ", a1, "u + ", b1,
        ",  disc ", D, "    1 stable line, so exactly 1 rank-one phi");
  print("   im phi = ker phi = C_1   ->   A = (c_1, c_1) = (q(x), q(t))   ",
        if(ok, "in Br(X)", "ramified"));
  print("");
}

main() = {
  print("=== rank-one phi in End_G(E[2]), and the algebras they give ===");
  print("");
  nine("15a1  (x-17)(x-1)(x+8)", [17, 1, -8]);
  nine("x(x-1)(x-4)           ", [0, 1, 4]);
  nine("x(x-9)(x-25)          ", [0, 9, 25]);
  print("=== f with one rational root: the endomorphism is forced ===");
  print("");
  one("x^3 + x    ", 0, 0, 1);
  one("15a4       ", 0, 14, 625);
  one("x^3 + 2x   ", 0, 0, 2);
  print("The count matches section 6.5: E[2] indecomposable => one stable line");
  print("=> one rank-one phi, which is why the twisting endomorphism is");
  print("'essentially unique' there and had to be searched for at 15a1.");
  print("For 15a1 the two survivors (c_1,c_3) and (c_3,c_1) are exactly the two");
  print("rank-one candidates kept by the 16-candidate local search of section 6.1.");
}
main(); quit;
