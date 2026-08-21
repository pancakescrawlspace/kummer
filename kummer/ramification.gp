/* ramification.gp --- is A unramified on the Kummer surface?
 *
 * X = Kum(E x E) is the minimal resolution of Y = (E x E)/iota, iota = (-1,-1),
 * with sixteen exceptional curves F_ab over the fixed points (T_a, T_b),
 * a, b in {0,1,2,3} indexing E[2] (T_0 = O, T_m = (e_m, 0)).
 *
 * NON-EXCEPTIONAL DIVISORS are free at both levels: E x E -> Y is etale in
 * codimension one, so v_D(g) = v_{D'}(g) for D' above D, and div(g) on E x E is
 * ell-divisible for every entry g of A.
 *
 * EXCEPTIONAL CURVES at level 3 are free too: blow up the sixteen points first,
 * so F becomes a divisor of the double cover with e = 2, and
 * d_{Ftilde}(rho^* A) = 2 d_F(A). Since 2 is invertible mod 3, and the pullback
 * is unramified (its valuations are 0 or -3), d_F(A) = 0. At level 2 that
 * argument dies -- 2 = 0 in Z/2 -- and the residue has to be computed.
 *
 * THE LEVEL-2 RESIDUE. Take anti-invariant uniformisers s, u at (T_a, T_b)
 * (s = y at T_a != O, s = -x/y at O). Both entries expand in even powers,
 *      g_1 = C_1 s^(2al)(1 + O(s^2)),   g_2 = C_2 u^(2be)(1 + O(u^2)),
 * the A_1 resolution has v_F = ord/2 with kappa(F) = k(lambda), lambda = u/s, so
 *      d_F(g_1, g_2) = (-1)^(al be) C_1^be C_2^(-al) lambda^(-2 al be)
 *                    = (-1)^(al be) C_1^be C_2^al          mod squares,
 * a CONSTANT. With A_ij = (prod_{k!=i}(x-e_k), prod_{l!=j}(t-e_l)), al is odd
 * exactly when a is neither i nor 0, and likewise be, giving
 *      a, b both odd :   -(e_a - e_i)(e_b - e_j)
 *      a odd, b = j  :    f'(e_j)
 *      a = i, b odd  :    f'(e_i)
 *      otherwise     :    1
 * and A is unramified along F_ab iff that is a square in k_ab = Q(e_a, e_b).
 * The twist d cancels out of every entry, as it must.
 *
 * Run:  gp -q < ramification.gp
 */

fp(e, m) = prod(k = 1, 3, if(k == m, 1, e[m] - e[k]));

resid(e, i, j, a, b) = {
  my(ao = (a != i && a != 0), bo = (b != j && b != 0));
  if(ao && bo, return(-(e[a] - e[i])*(e[b] - e[j])));
  if(ao && b == j, return(fp(e, j)));
  if(a == i && bo, return(fp(e, i)));
  1;
}

/* --- f split over Q: every k_ab is Q --- */
splitcase(name, e, i, j) = {
  my(bad = List());
  for(a = 0, 3, for(b = 0, 3,
    my(r = resid(e, i, j, a, b));
    if(r != 1 && !issquare(r), listput(bad, Str("(", a, ",", b, "):", r)))));
  print("  ", name, "  A_", i, j, ":  ",
        if(#bad == 0, "UNRAMIFIED",
           Str("ramified on ", #bad, " of 16 -- ", Vec(bad))));
}

/* --- f = (x - e1) q(x), q irreducible: k_ab = K = Q(sqrt(disc q)) when a or b
       is 2 or 3, and Q otherwise.  A = (q(x), q(t)), so i = j = 1. --- */
issq(K, c) = #nfroots(K, x^2 - c) > 0;
quadcase(name, e1, a1, b1) = {
  my(D = a1^2 - 4*b1, K = nfinit(y^2 - D), bad = List(), q1);
  q1 = e1^2 + a1*e1 + b1;         /* q(e1) = f'(e1) */
  /* residues, written in terms of e1 and the coefficients of q:
       (a,b) both in {2,3}, a = b :  -(e_a - e1)^2          -> need -1 a square in K
       (a,b) both in {2,3}, a != b:  -(e_2-e1)(e_3-e1) = -q(e1)
       a in {2,3}, b = 1, or a = 1, b in {2,3}:  f'(e1) = q(e1)          */
  if(!issq(K, -1),  listput(bad, "(a,a): -1 is not a square in K"));
  if(!issq(K, -q1),  listput(bad, Str("(2,3): -q(e1) = ", -q1)));
  if(!issq(K, q1),   listput(bad, Str("(a,1): q(e1) = ", q1)));
  print("  ", name, "   K = Q(sqrt(", D, "))",
        if(issq(K, -1), " = Q(i)", "        "), " :  ",
        if(#bad == 0, "UNRAMIFIED", Str("RAMIFIED -- ", Vec(bad))));
}

main() = {
  print("=== level 2, f split over Q (residues must be squares in Q) ===");
  splitcase("15a1  (x-17)(x-1)(x+8), the twist that works ", [17, 1, -8], 1, 3);
  splitcase("15a1  its transpose                          ", [17, 1, -8], 3, 1);
  splitcase("15a1  a rejected candidate, n = E_12         ", [17, 1, -8], 1, 2);
  splitcase("x(x-1)(x-4)                                  ", [0, 1, 4], 1, 3);
  splitcase("x(x-1)(x+8)                                  ", [0, 1, -8], 1, 1);
  print("");
  print("=== level 2, f = (x-e1) q(x) with q irreducible ===");
  quadcase("x^3 + x        q = x^2+1,      e1 = 0", 0, 0, 1);
  quadcase("15a4           q = x^2+14x+625, e1 = 0", 0, 14, 625);
  quadcase("x^3 + 2x       q = x^2+2,      e1 = 0", 0, 0, 2);
  quadcase("x(x^2+2x+2)    q = x^2+2x+2,   e1 = 0", 0, 2, 2);
  quadcase("x^3 - 2x       q = x^2-2,      e1 = 0", 0, 0, -2);
  print("");
  print("=== level 3 ===");
  print("  Unramified with no condition. On E_(6) x E_(-2) the two entries have");
  print("  div(G) = 3(T) - 3(O) and div(H) = 3(S) - 3(O), so after blowing up the");
  print("  sixteen fixed points every valuation of G and of H is 0 or -3, hence");
  print("  3-divisible, and the pullback of A is unramified. Restriction along a");
  print("  degree-4 map is injective on Br[3], so A itself is unramified.");
}
main(); quit;
