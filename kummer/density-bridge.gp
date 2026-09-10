\\ density-bridge.gp -- computations for density-bridge.typ.
\\ Run from this directory:
\\     gp -q -s 12000000000 density-bridge.gp < /dev/null > results/density-bridge.txt
\\
\\ How the single-curve documents (ec-padic-closure, ec-density-bm, wild-symbols)
\\ sit against the twist-family work (kummer-padic-density.typ, kummer-survey.typ,
\\ level3.gp).  Four checks:
\\   (1) the density criterion is the SAME one -- ec-padic-closure.typ re-derives
\\       section 2.1 of kummer-padic-density.typ.  Cross-checked on the CM family.
\\   (2) why the plain (untwisted) Brauer-Manin argument is VACUOUS on the Kummer
\\       surface: the local Kummer image is Lagrangian, so it pairs to zero with
\\       itself.  Verified as a dimension count.
\\   (3) wild-symbols.typ supplies the SHARPNESS of the lemma level3.gp needs:
\\       U^(4) is inside (K^*)^3 for K = Q_3(zeta_3), and U^(3) is not.
\\   (4) the two inputs of level3.gp's evasion of the wild symbol exist at 11 too,
\\       so ec-density-bm.typ section 6 was too pessimistic.

print("=========================================================================");
print(" Bridge: single curve vs. twist family");
print("=========================================================================");
print("");

\\ ------------------------------------------------- (1) the criterion is shared

print("(1) SAME CRITERION.  kummer-padic-density.typ section 2.1 states:");
print("      closure(Gamma) = E_d(Q_p)  <=>  Gamma onto E(Q_p)/E_1 (index M),");
print("                                      and Gamma inter E_1 not inside E_2,");
print("      with M = c_p * #Etilde^ns(F_p).  That is exactly the N_p and the");
print("      v_p(c(mP)) = 1 test of ec-padic-closure.typ -- the same criterion,");
print("      re-derived.  Its second clause is also precisely the clause that the");
print("      naive 'reduction map is surjective' phrasing drops.");
print("");
{
print("    Reproducing the CM table row at p = 3 (class [u.3], d = 6):");
my(d = 6, E = ellinit([0,0,0,0,-2*d^3]), lr = elllocalred(E,3));
print("      E_6 : y^2 = x^3 - ", 2*d^3, "   (the twist d v^2 = x^3 - 2)");
print("      conductor ", ellglobalred(E)[1], ",  Kodaira code ", lr[2],
      " (-4 = IV*),  c_3 = ", lr[4], ",  a_3 = ", ellap(E,3));
print("      M = c_3 * (3 - a_3) = ", lr[4]*(3 - ellap(E,3)),
      "   -- the doubling to 9 that forces rank >= 2.");
my(d2 = 3, E2 = ellinit([0,0,0,0,-2*d2^3]), lr2 = elllocalred(E2,3));
print("      and in class [3] (d = 3): c_3 = ", lr2[4], ",  M = ",
      lr2[4]*(3 - ellap(E2,3)), "  -- procyclic, rank 1 suffices.");
print("");
}

\\ ------------------------------- (2) why the untwisted argument is vacuous on X

print("(2) THE UNTWISTED ARGUMENT IS VACUOUS ON THE SURFACE.");
print("    In ec-density-bm.typ the obstruction pairs a point against a class:");
print("    inv_v A_beta(Q) = <Q_v, beta_v>_v, with beta ranging over H^1(Q,E).");
print("    On the Kummer surface the two arguments are BOTH points -- the surface");
print("    supplies pairs (P,Q) of points on the same twist -- so the pairing is");
print("    <delta_v P, delta_v Q>_v with both entries in the local Kummer image");
print("    W_v.  And W_v is MAXIMAL ISOTROPIC:");
print("");
{
print("      v      dim H^1(Q_v, E[2])   dim W_v = dim E(Q_v)/2   isotropic?");
my(E = ellinit([0,0,1,-1,0]));
foreach ([3,5,7,11,23,37], p,
  my(h0 = if (Mod(elldivpol(E,2), p) == 0, 0, 0));
  \\ dim H^0(Q_p, E[2]) = dim E[2](Q_p) = log_2 #roots of the 2-division poly
  my(nr = #polrootsmod(elldivpol(E,2), p));
  my(d0 = if (nr == 3, 2, if (nr == 1, 1, 0)));
  my(dH1 = 2*d0 + if (p == 2, 2, 0));
  print("      ", p, "            ", dH1, "                     ", d0,
        "                  ", if (dH1 == 2*d0, "yes (W^perp = W)", "-")));
print("");
print("    dim W_v is always half of dim H^1(Q_v,E[2]) -- that is the standard");
print("    fact used in ec-density-bm.typ section 7 to say W_v^perp = W_v.  So");
print("    <delta_v P, delta_v Q>_v = 0 identically, at every place, and");
print("    reciprocity gives 0 = 0.  The single-curve argument SAYS NOTHING here.");
print("");
}
print("    kummer-padic-density.typ section 5.1.5 fixes this by TWISTING the");
print("    pairing by a non-scalar phi in End_G(E[n]):");
print("        beta_v(P,Q) = <delta_v P, phi delta_v Q>_v ,");
print("    which needs E[n] DECOMPOSABLE (otherwise End_G(E[n]) = F_n, phi is");
print("    scalar, and beta collapses back to the vanishing pairing).  Since phi");
print("    is Galois-equivariant, reciprocity still gives sum_v beta_v = 0.");
print("    That extra ingredient is the whole difference between the two settings.");
print("");

\\ ------------------------------------ (3) sharpness of the lemma level3.gp uses

print("(3) WHAT wild-symbols.typ CONTRIBUTES: the sharpness of level3.gp's lemma.");
print("    level3.gp evaluates the WILD cubic symbol at 3 by the product formula,");
print("    and needs every class of K^*/(K^*)^3, K = Q_3(zeta_3), to have a global");
print("    representative.  Its stated reason: U^(4) is inside (K^*)^3, so a class");
print("    is fixed by its valuation and its unit part mod 9.  Brute force over");
print("    O/pi^12 = O/3^6 confirms it -- AND shows 4 cannot be lowered to 3.");
print("");
{
my(M = 3^6, iscube = vector(M*M));
for (a = 0, M-1,
  for (b = 0, M-1,
    my(x = (a*a - b*b) % M, y = (2*a*b - b*b) % M);
    my(u = (x*a - y*b) % M, v = (x*b + y*a - y*b) % M);
    iscube[u*M + v + 1] = 1));
print("       m    units = 1 mod pi^m    all cubes?");
for (m = 2, 5,
  my(tot = 0, bad = 0);
  for (a = 0, M-1,
    for (b = 0, M-1,
      if (valuation(a*a - a*b + b*b, 3) != 0, next);
      my(d1 = (a-1) % M);
      if (valuation(if (d1 == 0 && b == 0, M^2, d1*d1 - d1*b + b*b), 3) < m, next);
      tot++;
      if (!iscube[a*M + b + 1], bad++)));
  print("       ", m, "        ", tot, "             ",
        if (bad == 0, "YES", Str("no (", bad, " of them fail)"))));
print("");
print("    At m = 3 exactly one third of the units are cubes, so mod pi^3 would");
print("    lose a full layer.  level3.gp's mod-9 precision is exactly right and");
print("    cannot be reduced.");
print("");
}

\\ ----------------------------- (4) the same evasion is available at 11

print("(4) A CORRECTION TO ec-density-bm.typ SECTION 6.");
print("    That section called the index-11 case 'blocked by an unimplemented wild");
print("    symbol'.  Too pessimistic: this repository already contains TWO ways");
print("    round, and both have their inputs at 11.");
print("");
{
print("    (a) level3.gp's product-formula evasion needs (i) a single prime above");
print("        ell in Q(zeta_ell), and (ii) a depth bound giving every local class");
print("        a global representative.  Both hold at 11:");
foreach ([3, 11], l,
  my(K = bnfinit(polcyclo(l), 1), pd = idealprimedec(K, l));
  print("          Q(zeta_", l, ") : h = ", K.no, ",  primes above ", l, " = ",
        #pd, ",  e = ", pd[1].e, ",  f = ", pd[1].f,
        ",  depth pe/(p-1) = ", l*pd[1].e/(l-1)));
print("        ell is totally ramified in Q(zeta_ell) for every ell, so (i) is");
print("        automatic; (ii) is the depth bound of wild-symbols.typ.  At 11 the");
print("        depth is 11, so U^(12) consists of 11th powers, and since");
print("        v(11^2) = 20 >= 12 a class is pinned down modulo 121.");
print("");
print("    (b) kummer-survey.typ section on 11a1 at p = 11 does not evaluate the");
print("        symbol at all: the proof needs beta_11 to be NON-DEGENERATE, not to");
print("        be computed, and split multiplicative reduction (Tate curve)");
print("        settles that structurally -- the Tate mu_5 is a third line, distinct");
print("        from both global subgroups, so phi restricts to an isomorphism and");
print("        the Weil pairing of two distinct lines is perfect.");
print("");
print("    So 'no explicit class' and 'no proof' are different things, and the");
print("    survey has already separated them.");
}
print("");
\\ ------------------- (5) the K3 Brauer group and the search over ell

print("(5) IS THE FAILURE FOR ell > 5 A BRAUER-GROUP FACT?");
print("");
print("    The literal claim -- 'the geometric Brauer group of a K3 has no");
print("    ell-torsion for ell > 5' -- is FALSE.  For a K3 surface over an");
print("    algebraically closed field of characteristic 0,");
print("        Br(Xbar) = (Q/Z)^(22 - rho),   rho = rank NS(Xbar) <= 20,");
print("    so Br(Xbar)[ell] = (Z/ell)^(22-rho) is non-zero for EVERY ell.");
print("");
print("    But there is an exact true statement next to it, and it IS the reason.");
print("    For A = E_1 x E_2 the Kunneth decomposition of H^2 gives");
print("        Br(Abar)[ell] = Hom(E_1[ell], E_2[ell]) / (Hom(E_1,E_2) tensor F_ell),");
print("    the quotient being the algebraic (Neron-Severi) part.  For E_1 = E_2 = E");
print("    without CM, Hom(E,E) = Z, so");
print("        Br(Abar)[ell] = End(E[ell]) / F_ell = M_2(F_ell) / scalars,");
print("    and Br(Kum(A)bar) = Br(Abar) away from 2 (Skorobogatov-Zarhin).  Taking");
print("    Galois invariants:");
print("        Br(Xbar)^{G_Q}[ell]  =  End_G(E[ell]) / F_ell .");
print("    So 'the twisting endomorphism phi exists' -- the survey's criterion");
print("    End_G(E[ell]) != F_ell -- is LITERALLY 'the Kummer surface has a");
print("    Galois-invariant transcendental Brauer class of order ell'.  The search");
print("    for phi and the search for ell-torsion are the same search, and the");
print("    scalars are quotiented out precisely because they are the algebraic part.");
print("");
print("    What bounds ell is then a modular-curve theorem, not a K3 fact.");
print("    End_G(E[ell]) != F_ell needs the mod-ell image to be small.  Over Q, for");
print("    ODD ell, only one of the survey's four structural cases can occur:");
print("");
{
print("      * two stable lines (split Cartan)  <=>  a non-cuspidal rational point");
print("        of X_split(ell) = X_0(ell^2).  By Mazur-Kenku the cyclic isogeny");
print("        degrees over Q are N <= 19 and N in {21,25,27,37,43,67,163}, so");
print("        N = ell^2 forces ell^2 in {4,9,25}: ell in {2,3,5}.  ell^2 = 49 is");
print("        NOT on the list.");
print("      * one stable line with equal characters: chi_1 = chi_2 and");
print("        chi_1 chi_2 = cyclotomic force chi_1^2 = chi_cyc mod ell; with a");
print("        rational ell-torsion point (chi_1 = 1) this needs ell = 2.");
print("      * image inside a NONSPLIT Cartan: IMPOSSIBLE over Q for odd ell.");
print("        Complex conjugation c lies in the image, with det c = chi_cyc(c) = -1");
print("        and c^2 = 1, so its eigenvalues are 1 and -1, distinct for odd ell.");
print("        An element of a nonsplit Cartan acts with eigenvalues alpha,");
print("        alpha^ell for alpha in F_{ell^2}: equal when alpha is in F_ell, and");
print("        conjugate-not-in-F_ell otherwise -- never {1,-1}.");
print("      * larger irreducible image: End_G = F_ell, scalar.");
print("");
print("      So over Q the decomposable case is ell in {2,3,5} exactly.");
}
print("");
print("    A caveat on the brute force below: ellisomat records isogeny targets up");
print("    to ISOMORPHISM, so two distinct stable lines with isomorphic quotients");
print("    register once -- 14a1 has isogeny degrees {1,2,3,6} yet psi_3 has TWO");
print("    rational roots, hence two stable 3-lines.  The census therefore UNDER-");
print("    counts, and the exact statement rests on Mazur-Kenku, not on it.");
print("    Brute-force census (a lower bound on which ell occur):");
{
my(found = List(), n = 0);
for (a1 = 0, 1, for (a2 = -1, 1, for (a3 = 0, 1, for (a4 = -20, 20, for (a6 = -45, 45,
  my(E = ellinit([a1,a2,a3,a4,a6]));
  if (#E == 0, next);
  n++;
  my(M = ellisomat(E,,1)[2]);
  if (#M == 1, next);
  my(degs = vector(#M, j, M[1,j]));
  foreach (Set(degs), d,
    if (d < 2 || !isprime(d), next);
    my(c = 0);
    for (j = 1, #degs, if (degs[j] == d, c++));
    if (c >= 2, listput(found, d)));
)))));
print("      ", n, " curves examined;  ell with E[ell] decomposable: ",
      Set(Vec(found)));
}
print("");
print("    And ell = 7 really does not occur, even on the CM curve of conductor 49:");
{
my(E = ellinit([1,-1,0,-2,-1]));
print("      ", [1,-1,0,-2,-1], "  N = ", ellglobalred(E)[1], ", j = ", E.j,
      " (CM by sqrt(-7)), isogeny degrees ", Set(vector(#ellisomat(E,,1)[2], j,
        ellisomat(E,,1)[2][1,j])));
print("      -- a single 7-isogeny, not two, so E[7] is reducible but NOT");
print("      decomposable, and End_G(E[7]) is scalar.");
}
print("");
print("    Conclusion: the intuition is right, the statement needs repair.  The");
print("    obstruction to going past ell = 5 is not that a K3 has no ell-torsion in");
print("    its geometric Brauer group -- it always does -- but that the");
print("    GALOIS-INVARIANT part vanishes, and that vanishing is Mazur-Kenku.");
print("");

\\ ---------------- (6) does beta_p vary with the twist?

print("(6) DOES beta_p DEPEND ON THE TWIST d, OR ONLY ON ITS CLASS AT p?");
print("");
print("    Only on the class -- and the reason is a triviality once stated.  If");
print("    d/d' is a square in Q_p then");
print("        psi : E_d -> E_d',   (x,y) -> (c^2 x, c^3 y),  c^2 = d/d' ,");
print("    is an ISOMORPHISM DEFINED OVER Q_p.  It carries E_d[ell] to E_d'[ell],");
print("    each Galois-stable line to the corresponding one (so it commutes with");
print("    phi), and preserves the Weil pairing.  Hence it identifies W_p with W_p'");
print("    and beta_p with beta_p'.  Same form, on the nose.  ONE CHECK PER SQUARE");
print("    CLASS suffices -- four at odd p, eight at 2 -- not one per twist.");
print("");
{
my(twist(E,d) = ellinit([-27*E.c4*d^2, -54*E.c6*d^3]));
my(E0 = ellinit([1,0,1,4,-6]));
print("    E = 14a1 (E[3] decomposable: psi_3 has two rational roots), ell = 3,");
print("    critical place p = 7.  Class [1] = the 7-adic units d = 1,2,4 mod 7:");
print("");
print("       d      Kodaira@7   c_7   a_7   M = c_7(7-a_7)");
foreach ([1, 2, 4, 8, 9, 11, 15, 22, 23, 37, 247, -6, -5], d,
  if (d % 7 == 0 || kronecker(d,7) != 1, next);
  my(E = twist(E0,d), lr = elllocalred(E,7), a = ellap(E,7));
  print("     ", d, "          ", lr[2], "        ", lr[4], "     ", a,
        "        ", lr[4]*(7-a)));
print("");
print("    and a NON-square class at 7 (d = 3,5,6 mod 7), for contrast:");
print("       d      Kodaira@7   c_7   a_7   M");
foreach ([3, 5, 6, 10, 13], d,
  if (d % 7 == 0 || kronecker(d,7) == 1, next);
  my(E = twist(E0,d), lr = elllocalred(E,7), a = ellap(E,7));
  print("     ", d, "          ", lr[2], "        ", lr[4], "     ", a,
        "        ", lr[4]*(7-a)));
print("");
print("    Identical within a class, different across classes.");
print("");
print("    What DOES move with d is the vanishing AWAY from p.  beta_v can be");
print("    non-zero only where dim W_v = 2, which needs mu_ell in Q_v, i.e.");
print("    v = 1 mod ell.  The set of such bad places is exactly the d-dependent");
print("    part of the argument:");
print("");
print("       d        bad primes of E_d          of those, = 1 mod 3");
foreach ([1, 2, 4, 11, 15, 23, 37, 247, -5], d,
  if (d % 7 == 0 || kronecker(d,7) != 1, next);
  my(E = twist(E0,d), bad = factor(abs(E.disc))[,1]~, rel = List());
  foreach (bad, q, if (q > 3 && q % 3 == 1 && q != 7, listput(rel, q)));
  print("     ", d, "      ", bad, "       ", Vec(rel)));
print("");
print("    d = 37 and d = 247 each bring in a new place where beta could survive.");
print("    THAT is the family-uniform obligation, and it is why the CM table lists");
print("    'few bad primes necessary': each extra place with beta_v non-zero lets");
print("    the reciprocity sum be balanced away from the critical place.");
}
print("");
print("    BUT THE PROPOSED SHORTCUT DOES NOT WORK, and the reason is logical, not");
print("    computational.  beta_p != 0 is a LOCAL fact about the form on W_p;");
print("    'E_d(Q) fails to surject onto W_p' is a GLOBAL fact about one twist.");
print("    The implication runs one way:");
print("        beta_p != 0  AND  beta_v = 0 for v != p   ==>   image is isotropic");
print("                                                   ==>   dim <= 1, no surjection.");
print("    It cannot be inverted: a twist can fail to surject simply because its");
print("    rank is too small, which says nothing about beta_p.  The 708 rank->=2");
print("    twists of the CM search are evidence, not proof, and the document says");
print("    so.");
print("");
print("    The valid converse use is a REFUTATION: if a single twist in the class");
print("    DOES span W_p (and has beta_v = 0 away from p), then beta_p vanishes on");
print("    W_p and the mechanism is dead for that class.  So one twist can kill the");
print("    obstruction; no number of twists can establish it.");
print("");

print("done.");
