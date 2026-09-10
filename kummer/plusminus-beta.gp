/*  plusminus-beta.gp
 *
 *  Self-contained beta-pairing analysis for the pair
 *
 *      E_d  : y^2 = x^3 - a^3 d^3        E'_d : y^2 = x^3 + a^3 d^3
 *
 *  Nothing here is imported from the other notes.  The set-up:
 *
 *    A  = Q[t]/(t^3-1) = Q x K,  K = Q(zeta_3) = Q[y]/(y^2+y+1),  zeta_3 = y.
 *    The roots of x^3 - (ad)^3 are  ad*t,  those of x^3 + (ad)^3 are -ad*t,
 *    so BOTH cubic algebras are identified with A, and
 *
 *        delta (x,y)  = [ x - ad , x - ad*y ]        (E_d)
 *        delta'(x',y')= [ x'+ ad , x'+ ad*y ]        (E'_d)
 *
 *    H^1(Q_v,E[2]) = ker( N : A_v^x/2 -> Q_v^x/2 ),  and the cup product
 *    induced by the Weil pairing is the sum of Hilbert symbols over the
 *    factors of A (the Weil pairing is the restriction to E[2] of the
 *    standard diagonal form on F_2[roots]).
 *
 *    E[2] = E'[2] = F_2[C_2] has exactly two G-automorphisms, so exactly two
 *    isomorphisms psi : E[2] -> E'[2].  On A they are
 *        psi_1 = identity            (ad*t  |-> -ad*t)
 *        psi_2 = conjugation on K    (ad*t  |-> -ad*t^2)
 */

K = nfinit(y^2+y+1);

\\ ---------- generalities on A_v^x / squares ---------------------------------

{nv(v) = if(v == 0, 1, v == 2, 7, v == 3, 4, v % 3 == 1, 6, 4);}   \\ dim_F2 A_v^x/2
{dimL(v) = if(v == 0, 0, v == 2, 2, v % 3 == 1, 2, 1);}            \\ dim_F2 E_d(Q_v)/2

{cnj(k) = my(p = lift(Mod(k, y^2+y+1))); subst(p, y, -1-y);}       \\ y |-> y^2 on K
{pmap(al, w) = if(w == 1, al, [al[1], cnj(al[2])]);}                \\ psi_w^{-1} on A

{apair(al, be, v) =                                   \\ the cup product at v
  my(s = hilbert(al[1], be[1], v));
  if (v != 0, foreach(idealprimedec(K,v), pr, s *= nfhilbert(K, al[2], be[2], pr)));
  s;}

{rnd(v) = my(r = 0, k = 0, m = max(v,2));
  while (r == 0, r = random(41) - 20); if (random(2), r *= m);
  while (k == 0, k = (random(21)-10) + (random(21)-10)*y);
  if (random(2), k *= m); [r, k];}

{gramrk(T, v) = matrank(Mod(matrix(#T,#T,i,j,if(apair(T[i],T[j],v)==1,0,1)),2));}

{tspan(v) = my(T = List(), d = nv(v), tries = 0, m = max(v,2));    \\ a spanning test set
  foreach([[-1,1],[2,1],[5,1],[1,-1],[1,2],[1,y],[1,1+2*y],[1,3],[m,1],[1,m]], t, listput(T,t));
  while (gramrk(Vec(T), v) < d && tries < 500, tries++; listput(T, rnd(v)));
  if (gramrk(Vec(T), v) < d, error("test set failed to span at v = ", v));
  Vec(T);}

TS = Map();                                          \\ cache of test sets
{ts(v) = if (!mapisdefined(TS, v), mapput(TS, v, tspan(v))); mapget(TS, v);}
{coord(al, v) = my(T = ts(v)); vector(#T, j, if(apair(al,T[j],v)==1,0,1));}

\\ ---------- local points ----------------------------------------------------

{issqQ(r, p) =                                        \\ is the rational r a square in Q_p ?
  if (r == 0, return(0));
  if (p == 0, return(r > 0));
  my(e = valuation(r,p)); if (e % 2, return(0));
  my(u = r/p^e, n = numerator(u)*denominator(u));
  if (p == 2, n % 8 == 1, kronecker(n, p) == 1);}

/* Kummer image of E_c : y^2 = x^3 - c^3 at v, as a list of A-classes.
   c = ad for E_d, c = -ad for E'_d (since x^3 + (ad)^3 = x^3 - (-ad)^3).
   delta(x) = [x-c, x-c*y];  delta(T_0) = [3c^2, c*(1-y)]  (T_0 = (c,0)).
   Rational x are dense in the x-line and delta is locally constant, so
   rational x suffice; the rank check below certifies that we have all of L_v. */
{cands(c, v, E, N) = my(C = List([[3*c^2, c*(1-y)]]), q = max(v,2), x);
  for (e = -E, E, my(w = q^e);
       for (n = -N, N, if (n,
            x = n*w;   if (issqQ(x^3-c^3, v), listput(C, [x-c, x-c*y]));
            x = c+n*w; if (issqQ(x^3-c^3, v), listput(C, [x-c, x-c*y])))));
  Vec(C);}

{kimage(c, v) =
  my(G, R, n = #ts(v), d = dimL(v), rk);
  if (d == 0, return([[], 0]));
  foreach([[4,40],[6,120],[8,400],[10,1500]], lev,
    G = List(); R = List(); rk = 0;
    foreach(cands(c, v, lev[1], lev[2]), al,
      if (rk < d,
        listput(R, coord(al,v));
        if (matrank(Mod(matrix(#R, n, i, j, R[i][j]), 2)) > rk, rk++; listput(G, al),
            listpop(R))));
    if (rk == d, return([Vec(G), rk])));
  [Vec(G), rk];}

\\ ---------- the pairing -----------------------------------------------------

/* beta_v on L_v x psi_w^{-1}L'_v, for both w at once.
   Returns [nonzero for psi_1?, nonzero for psi_2?, both images full-dimensional?] */
{betaboth(a, d, v) =
  my(c = a*d, L = kimage(c, v), Lp = kimage(-c, v), b1 = 0, b2 = 0);
  foreach(L[1], g, foreach(Lp[1], h,
     if (apair(g, h,          v) == -1, b1 = 1);
     if (apair(g, pmap(h, 2), v) == -1, b2 = 1)));
  [b1, b2, (L[2] == dimL(v)) && (Lp[2] == dimL(v))];}

{betav(a, d, v, w) = my(r = betaboth(a,d,v)); [r[w], r[3]];}

/* Sigma_w = { v : beta_v^{psi_w} not identically zero }.  Tested at 0, 2, 3,
   a, every p | d, and a control range of good primes.                        */
CTRL = [5,7,11,13,17,19,23,29,31,37,41,43];
{places(a, d) = Set(concat(concat([0,2,3,a], factor(abs(d))[,1]~), CTRL));}
{sigmas(a, d) = my(S1 = List(), S2 = List());
  foreach(places(a,d), v, my(r = betaboth(a,d,v));
     if (!r[3], error("Kummer image short of predicted dimension at v = ", v));
     if (r[1], listput(S1, v)); if (r[2], listput(S2, v)));
  [Vec(S1), Vec(S2)];}

\\ ===========================================================================
\\  numbered checks
\\ ===========================================================================

{kodname(k) = if(k == 1, "I0", k == 2, "II", k == 3, "III", k == 4, "IV",
                 k == -1, "I0*", k == -2, "II*", k == -3, "III*", k == -4, "IV*",
                 k > 4, Str("I", k-4), Str("I", -k-4, "*"));}

Emin(c) = ellinit([0,0,0,0,-c^3]);
Epls(c) = ellinit([0,0,0,0, c^3]);

\\ ---------------------------------------------------------------- check 1 --
{check1(cs) =
  print("  (1) the configuration");
  print("      c       N(E)      N(E')     E[2](Q)  E'[2](Q)  Q(E[2])                Q(E'[2])               isog?");
  foreach(cs, c, my(E = Emin(c), F = Epls(c), sep = 0);
    forprime(p = 5, 300, if (ellap(E,p) != ellap(F,p), sep = 1; break));
    printf("      %-7d %-9d %-9d %-8s %-9s %-22s %-22s %s\n", c,
           ellglobalred(E)[1], ellglobalred(F)[1], elltors(E)[2], elltors(F)[2],
           polredbest(nfsplitting(x^3-c^3)), polredbest(nfsplitting(x^3+c^3)),
           if (sep, "no", "?")));
  print("      both cubics factor as (linear)(quadratic) with quadratic discriminant -3c^2,");
  print("      so both 2-division fields are Q(zeta_3) and E[2] = E'[2] = F_2[C_2].");
  print("      Aut_G(F_2[C_2]) = (F_2[C_2])^x = {1, sigma} has order 2:");
  print("      exactly TWO isomorphisms psi : E[2] -> E'[2].");
  1;}

\\ ---------------------------------------------------------------- check 2 --
/* delta(T_0)  = [3c^2,  c(1-zeta)]      T_0  = ( c,0) on E
   delta'(T'_0)= [3c^2, -c(1-zeta)]      T'_0 = (-c,0) on E'
   psi_2 conjugates the K-slot, psi_1 does not.                                */
{check2(cs, vs) =
  my(ok = 1);
  print("  (2) the two psi on the rational 2-torsion");
  print("      T_0 = (c,0) on E and T'_0 = (-c,0) on E' are the rational 2-torsion,");
  print("      delta(T_0) = [3c^2, c(1-zeta)],  delta'(T'_0) = [3c^2, -c(1-zeta)].");
  foreach(cs, c,
    my(A = [3*c^2, c*(1-y)], B = [3*c^2, -c*(1-y)],
       r2 = lift(Mod(A[2]/cnj(B[2]), y^2+y+1)),
       r1 = lift(Mod(A[2]/B[2],      y^2+y+1)));
    printf("      c = %-5d  delta(T_0) / psi_2^-1 delta'(T'_0) = %-8s", c, r2);
    printf("   / psi_1^-1 delta'(T'_0) = %s\n", r1);
    if (r2 != y, ok = 0));
  print("      zeta_3 = (zeta_3^2)^2 is a GLOBAL square in K, so psi_2 matches the");
  print("      rational 2-torsion classes EXACTLY, at every place at once.");
  print("      psi_1 misses by the class [1,-1], so wherever L_v = <delta(T_0)> is");
  print("      one-dimensional the whole of beta_v^{psi_1} is the single symbol");
  print("        <delta(T_0), [1,-1]>_v = prod_{w|v} ( c(1-zeta), -1 )_{K_w},");
  print("      the Legendre symbol of -1 in the residue field of K_w:");
  print("      v      K (x) Q_v            residue field   (c(1-zeta),-1)   dim L_v");
  foreach(vs, v,
    my(sym = 1, desc);
    foreach(idealprimedec(K,v), pr, sym *= nfhilbert(K, 21*(1-y), -1, pr));
    desc = if (v == 3, "ramified          F_3        ",
               v % 3 == 1, "split             F_v x F_v  ",
                           "inert             F_(v^2)    ");
    printf("      %-6d %s     %-14s %-2d\n", v, desc, sym, dimL(v)));
  print("      -1 is a square in F_(v^2) for every v, and in F_v iff v = 1 mod 4;");
  print("      it is a non-square in F_3.  So among the places with dim L_v = 1 the");
  print("      symbol is -1 at v = 3 ALONE.  The places v = 1 mod 3 have dim L_v = 2");
  print("      and need the full 2 x 2 test -- that is where v = 7 mod 12 enters.");
  ok;}

\\ ---------------------------------------------------------------- check 3 --
{check3(c, vs) =
  my(ok = 1);
  print("  (3) local structure of A_v^x/2 and of the Kummer images  (c = ", c, ")");
  print("      v     dim A_v^x/2  Gram rank   dim L_v  dim L'_v  predicted  L_v isotropic?");
  foreach(vs, v,
    my(T = ts(v), gr = gramrk(T,v), L = kimage(c,v), Lp = kimage(-c,v), iso = 1);
    foreach(L[1], g, foreach(L[1], h, if (apair(g,h,v) == -1, iso = 0)));
    foreach(Lp[1], g, foreach(Lp[1], h, if (apair(g,h,v) == -1, iso = 0)));
    if (gr != nv(v) || L[2] != dimL(v) || Lp[2] != dimL(v) || !iso, ok = 0);
    printf("      %-5d %-12d %-11d %-8d %-9d %-10d %s\n",
           v, nv(v), gr, L[2], Lp[2], dimL(v), if(iso,"yes","NO")));
  print("      dim L_v = dim E[2](Q_v) for v odd, one more at v = 2, zero at v = oo");
  print("      (E(R) is connected: x^3 - c^3 has one real root), and L_v is a");
  print("      Lagrangian for the cup product -- so beta_v = 0 iff psi_* L_v = L'_v.");
  ok;}

\\ ---------------------------------------------------------------- check 4 --
{check4(cs, vs) =
  my(ok = 1);
  print("  (4) reduction at odd primes: j = 0, so never multiplicative");
  print("      c      v     type   c_v   Phi_v            order-4 point?");
  foreach(cs, c,
    foreach(vs, v,
      if (v > 2,
        my(r = elllocalred(Emin(c), v), k = r[2], tam = r[4], nm);
        if (k != 1,
          if (k >= 5 || k <= -5, ok = 0);
          nm = if (k == -1, "exponent 2", tam == 3, "Z/3", tam == 2, "Z/2", "trivial");
          printf("      %-6d %-5d %-6s %-5d %-16s %s\n", c, v, kodname(k), tam, nm, "no")))));
  print("      Every type occurring is potentially good (never I_n or I_n*, n >= 1),");
  print("      so Phi_v has exponent 2 or order 3 and no element of order 4.");
  print("      E_0(Q_v) is uniquely 2-divisible for v odd (E_1 = Z_v, E_0/E_1 of odd");
  print("      order), hence E(Q_v)[2] = Phi_v[2] and E(Q_v) has NO point of order 4;");
  print("      with |E(Q_v)/2| = |E[2](Q_v)| this gives L_v = delta(E[2](Q_v)).");
  ok;}

\\ ---------------------------------------------------------------- check 5 --
/* beta_v depends only on the square class of c in Q_v^x: replacing c by c t^2
   is the isomorphism (x,y) -> (t^2 x, t^3 y), under which delta(x) is scaled
   by the square t^2 in every slot.  So running over representatives of
   Q_v^x/(Q_v^x)^2 is a COMPLETE case check at v, not a sample.              */
{sqreps(v) = if (v == 2, [1,3,5,7,2,6,10,14],
   my(n = 2); while (kronecker(n,v) != -1, n++); [1, n, v, v*n]);}

{bpair(c, v) = my(L = kimage(c,v), Lp = kimage(-c,v), b1 = 0, b2 = 0);
  if (L[2] != dimL(v) || Lp[2] != dimL(v),
      error("Kummer image short of predicted dimension: v = ", v, ", c = ", c));
  foreach(L[1], g, foreach(Lp[1], h,
     if (apair(g, h,          v) == -1, b1 = 1);
     if (apair(g, pmap(h, 2), v) == -1, b2 = 1)));
  [b1, b2];}

{check5(vs) =
  my(ok = 1);
  print("  (5) beta_v over ALL square classes of c -- a complete check at each v");
  print("      v      c      v_v(c)   beta_v(psi_1)   beta_v(psi_2)");
  foreach(vs, v,
    foreach(sqreps(v), c,
      my(b = bpair(c,v),
         p1 = (v == 2 || v == 3 || (v % 12 == 7 && valuation(c,v) % 2)),
         p2 = (v == 2 && valuation(c,2) % 2));
      if (b[1] != !!p1 || b[2] != !!p2, ok = 0);
      printf("      %-6d %-6d %-8d %-15s %s\n", v, c, valuation(c,v),
             if(b[1],"NONZERO","zero"), if(b[2],"NONZERO","zero"))));
  print("      Reading off:   beta_v^{psi_2} =/= 0  <=>  v = 2 and v_2(c) odd");
  print("                     beta_v^{psi_1} =/= 0  <=>  v = 2, or v = 3, or");
  print("                                              v = 7 mod 12 with v_v(c) odd");
  print("      predictions matched at every class: ", if(ok,"YES","NO"));
  ok;}

\\ ---------------------------------------------------------------- check 6 --
CTRL = [5,7,11,13,17,19,23,29,31,37,41,43];
{places(c) = Set(concat(concat([0,2,3], factor(abs(c))[,1]~), CTRL));}
{sigmas(c) = my(S1 = List(), S2 = List());
  foreach(places(c), v, my(b = bpair(c,v));
     if (b[1], listput(S1,v)); if (b[2], listput(S2,v)));
  [Vec(S1), Vec(S2)];}
{rule1(c) = my(S = List([2,3]));
  foreach(factor(abs(c))[,1]~, q, if (q % 12 == 7 && valuation(c,q) % 2, listput(S,q)));
  Vec(Set(S));}
{rule2(c) = if (valuation(c,2) % 2, [2], []);}

{check6(as, B) =
  my(n = 0, m1 = 0, m2 = 0);
  print("  (6) Sigma over the twist family, a = odd prime, d squarefree, c = a d");
  print("      Sigma_w = { v : beta_v^{psi_w} =/= 0 }, tested at 0, 2, 3, p | c and ", CTRL);
  foreach(as, a,
    for (k = 1, B, foreach([k,-k], d,
      if (core(abs(d)) == abs(d),
        my(c = a*d, s = sigmas(c));
        n++;
        if (s[1] != rule1(c), m1++;
            printf("      MISMATCH psi_1: a=%d d=%d got %s want %s\n",a,d,s[1],rule1(c)));
        if (s[2] != rule2(c), m2++;
            printf("      MISMATCH psi_2: a=%d d=%d got %s want %s\n",a,d,s[2],rule2(c)))))));
  printf("      %d twists;  psi_1 rule: %d mismatches;  psi_2 rule: %d mismatches\n", n, m1, m2);
  printf("      so for d EVEN, Sigma_2 = {2} exactly -- a one-place obstruction;\n");
  printf("      for every d, Sigma_1 contains {2,3} -- a two-place obstruction.\n");
  m1 == 0 && m2 == 0;}

\\ ---------------------------------------------------------------- check 7 --
/* If Sigma is what check 5/6 say it is, then for GLOBAL points the local
   invariants must cancel.  This tests the whole apparatus at once -- the
   identification of H^1 with ker N, the Weil pairing = diagonal form, and
   every Hilbert-symbol convention -- against Hilbert reciprocity.          */
{relplaces(c, P, Q) =
  my(x = P[1], u = Q[1],
     m = 6*c * numerator(x-c)*denominator(x-c)
             * numerator(x^2+c*x+c^2)*denominator(x^2+c*x+c^2)
             * numerator(u+c)*denominator(u+c)
             * numerator(u^2-c*u+c^2)*denominator(u^2-c*u+c^2));
  concat([0], factor(abs(m))[,1]~);}

{check7(cases) =
  my(ok = 1);
  print("  (7) reciprocity on genuine global points:  prod_v beta_v(P,P') = 1");
  foreach(cases, cs,
    my(c = cs[1], P = cs[2], Q = cs[3],
       dP = [P[1]-c, P[1]-c*y], dQ = [Q[1]+c, Q[1]+c*y],
       p1 = 1, p2 = 1, S1 = List(), S2 = List());
    foreach(relplaces(c,P,Q), v,
      my(b1 = apair(dP, dQ, v), b2 = apair(dP, pmap(dQ,2), v));
      p1 *= b1; p2 *= b2;
      if (b1 == -1, listput(S1,v)); if (b2 == -1, listput(S2,v)));
    if (p1 != 1 || p2 != 1, ok = 0);
    printf("      c = %-5d v_2(c) = %d   P = %-24s P' = %s\n", c, valuation(c,2), P, Q);
    printf("        psi_1: beta_v =/= 0 at v in %-14s product = %+d\n", Vec(S1), p1);
    printf("        psi_2: beta_v =/= 0 at v in %-14s product = %+d\n", Vec(S2), p2));
  print("      Every product is +1.  Note what this MEANS for v_2(c) odd: Sigma_2 = {2},");
  print("      so beta_2(P,P') = 0 is forced for global points, while beta_2 is a");
  print("      non-trivial pairing on E(Q_2)/2 x E'(Q_2)/2 -- see check (8).");
  ok;}

\\ ---------------------------------------------------------------- check 8 --
{check8(cs) =
  my(ok = 1);
  print("  (8) the 2-adic obstruction, exhibited");
  foreach(cs, c,
    my(L = kimage(c,2), Lp = kimage(-c,2), found = 0);
    foreach(L[1], g, foreach(Lp[1], h,
      if (!found && apair(g, pmap(h,2), 2) == -1,
        found = 1;
        printf("      c = %-6d v_2(c) = %d :  <g, psi_2^-1 h>_2 = -1\n", c, valuation(c,2));
        printf("                    g = %-26s in L_2\n", g);
        printf("                    h = %-26s in L'_2\n", h))));
    if (!found, printf("      c = %-6d v_2(c) = %d :  beta_2 vanishes identically\n",
                       c, valuation(c,2)));
    if (found != (valuation(c,2) % 2 == 1), ok = 0));
  print("      For v_2(c) odd the open set { beta_2 = 1 } in E(Q_2) x E'(Q_2) is");
  print("      non-empty and contains no rational point: (E x E')(Q) is NOT dense.");
  ok;}

\\ ---------------------------------------------------------------- check 9 --
/* WHY THE LEMMA IS NOT FORMAL.  delta restricted to E[2](F) is the connecting
   map of 0 -> E[2] -> E[4] -> E[2] -> 0, so it is a function of E[4], not of
   E[2].  In coordinates: the slot of delta(T_i) indexed by the root e_k is
   e_i - e_k, so psi_* delta(T_i) = delta'(T'_{psi i}) iff every ratio
   (e_i - e_k) / (e'_{psi i} - e'_{psi k}) is a square.  All three roots
   e_j = c zeta^j and e'_j = -c zeta^j lie in K, so this is checkable in K. */
issqK(r) = #nfroots(K, x^2 - r) > 0;

{ratios(c, w) =
  my(z = Mod(y, y^2+y+1), e = vector(3, j, c*z^(j-1)), ep = vector(3, j, -c*z^(j-1)),
     out = List());
  for (i = 0, 2, for (k = 0, 2, if (i != k,
    my(pi = if (w == 1, i, (3-i)%3), pk = if (w == 1, k, (3-k)%3),
       r = (e[i+1] - e[k+1]) / (ep[pi+1] - ep[pk+1]));
    listput(out, [i, k, lift(r), issqK(r)]))));
  Vec(out);}

/* T_0 = (c,0) is halved in E(Q_v) iff the quartic below -- from the duplication
   formula x(2P) = (x^4 - 8Bx)/(4(x^3+B)) with B = -c^3, set equal to c -- has a
   root x_0 in Q_v with x_0^3 - c^3 a square.                                  */
{halvable(c, v) =
  my(F = factorpadic(x^4 - 4*c*x^3 + 8*c^3*x + 4*c^4, v, 80), ok = 0);
  for (i = 1, matsize(F)[1],
    if (poldegree(F[i,1]) == 1,
      my(x0 = -polcoef(F[i,1],0)/polcoef(F[i,1],1));
      if (issquare(x0^3 - c^3), ok = 1)));
  ok;}
{dtriv(c, v) = my(t = 1); foreach(coord([3*c^2, c*(1-y)], v), b, if (b, t = 0)); t;}

{check9(cs, vs) =
  my(ok = 1, bad = 0);
  print("  (9) what the Lemma really needs");
  print("      (a) the ratios (e_i - e_k)/(e'_{psi i} - e'_{psi k}) -- the ONLY data");
  print("          delta sees on the 2-torsion.  c cancels in both cases:");
  foreach(cs, c,
    foreach([1,2], w,
      my(R = ratios(c,w), all = 1);
      foreach(R, t, if (!t[4], all = 0));
      printf("          c = %-5d psi_%d : ", c, w);
      foreach(R, t, printf("(%d,%d)->%-9s", t[1], t[2], t[3]));
      printf(" all squares in K? %s\n", if(all,"YES","no"));
      if (w == 2 && !all, ok = 0); if (w == 1 && all, ok = 0)));
  print("          psi_2 leaves zeta_3^(i+k), of ODD order hence a square: the Lemma.");
  print("          psi_1 leaves -1, a square only where -1 is: the Lemma FAILS for it.");
  print("          Both are G-isomorphisms E[2] -> E'[2], so the Lemma is NOT formal.");
  print("      (b) delta(T_0) is exactly the 4-divisibility datum:");
  print("          c      v     T_0 in 2E(Q_v)?   delta(T_0) trivial?   agree?");
  foreach(cs, c, foreach(vs, v,
    my(h = halvable(c,v), d = dtriv(c,v));
    if (h != d, bad++; ok = 0);
    printf("          %-6d %-5d %-17s %-21s %s\n", c, v,
           if(h,"yes","no"), if(d,"yes","no"), if(h==d,"ok","MISMATCH"))));
  printf("          %d comparisons, %d mismatches -- delta|E[2] is the connecting map\n",
         #cs * #vs, bad);
  print("          of 0 -> E[2] -> E[4] -> E[2] -> 0, so it remembers E[4], not E[2].");
  ok;}

\\ ===========================================================================
print("======================================================================");
print("plusminus-beta.gp -- the pairing beta for y^2 = x^3 -+ c^3");
print();
check1([1,3,5,7,21,26,30]); print();
check2([1,3,21,26], [3,5,7,11,13,17,19,23,31,37,43]); print();
check3(21, [0,2,3,5,7,11,13,19,31]); print();
check4([3,21,26,30,42], [3,5,7,11,13]); print();
check5([2,3,5,7,11,13,17,19,23,29,31,37,41,43]); print();
check6([3,5,7,11], 25); print();
check7([[26,[65,507],[22,168]], [-26,[22,168],[65,507]], [38,[57,361],[1178,40432]], [78,[20238/121,2729160/1331],[-26,676]], [33,[55977/1369,9121140/50653],[-6,189]], [-33,[-6,189],[55977/1369,9121140/50653]]]); print();
check8([1,3,21,33,2,6,26,38,78,28,44]); print();
check9([1,3,21,26], [5,7,11,13,19,31,37,43]); print();
print("======================================================================");
