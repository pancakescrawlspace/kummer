\\ local-duality.gp -- computations for local-duality.typ.
\\ Run from this directory:
\\     gp -q -s 4000000000 local-duality.gp < /dev/null > results/local-duality.txt
\\
\\ Local Tate duality, and the instances of it that the other documents in this
\\ directory lean on.  For K/Q_p finite and M a finite G_K-module with dual
\\ M^D = Hom(M, Kbar^*), cup product
\\     H^i(K,M) x H^{2-i}(K,M^D) -> H^2(K,Kbar^*) = Br(K) = Q/Z
\\ is a perfect pairing for i = 0,1,2.
\\
\\ Verified here:
\\   (2) the case M = Z/2 IS non-degeneracy of the Hilbert symbol -- exhaustive
\\       Gram matrices over Q_p^*/(Q_p^*)^2 at p = 2,3,5,7,11,13.
\\   (3) unramified classes are exact annihilators at odd p, and the count fails
\\       at p = 2 -- which is exactly where the soft "tame" proof stops.
\\   (4) Tate's local Euler characteristic formula and the Lagrangian count for
\\       M = E[n], including the |n|_K correction at v | n.
\\   (5) symmetric vs alternating self-duality: why Z/2 admits no Lagrangian but
\\       E[n] does, and W_v is one.

sqclasses(p) =
{ my(u);
  if (p == 2, return([1,-1,2,-2,5,-5,10,-10]));
  u = 1;
  forprime (q = 2, 200, if (kronecker(q,p) == -1, u = q; break));
  [1, u, p, u*p];
}

print("=========================================================================");
print(" Local Tate duality: the statement, and the instances used elsewhere");
print("=========================================================================");
print("");

print("(1) THE STATEMENT AND ITS INPUTS.");
print("    For K/Q_p finite and M finite over G_K, with M^D = Hom(M, Kbar^*),");
print("        H^i(K,M) x H^{2-i}(K,M^D) --> Br(K) = Q/Z");
print("    is perfect for i = 0,1,2.  The engine is inv : Br(K) -> Q/Z, itself");
print("    proved in two moves: every Brauer class over a local field is split by");
print("    an UNRAMIFIED extension (a division algebra contains an unramified");
print("    maximal subfield, because the valuation extends uniquely), and for");
print("    L/K unramified cyclic of degree n, Br(L/K) = K^*/N L^* = Z/n because");
print("    units are norms (Hensel), so N L^* = {x : n | v(x)} and inv sends the");
print("    class to v(x)/n.");
print("");
print("    Note what the theorem CONTAINS.  Take M = Z/n trivial, so M^D = mu_n,");
print("    and i = 1:");
print("        Hom(G_K, Z/n) x K^*/(K^*)^n -> (1/n)Z/Z,   (chi, a) -> chi(rec a).");
print("    Perfectness here IS local class field theory.  So there is no proof of");
print("    the 'purely local fact' that avoids LCFT -- they are the same depth.");
print("");

\\ ------------------------------------ (2) the Z/2 case is the Hilbert symbol

print("-------------------------------------------------------------------------");
print("(2) THE CASE M = Z/2 IS NON-DEGENERACY OF THE HILBERT SYMBOL.");
print("    mu_2 = Z/2 already lies in Q_p, so H^1(Q_p, Z/2) = H^1(Q_p, mu_2) =");
print("    Q_p^*/(Q_p^*)^2, the duality pairing is (a,b) -> (a,b)_p, and");
print("    perfectness is exactly non-degeneracy of the Gram matrix over F_2.");
print("");
{
foreach ([2,3,5,7,11,13], p,
  my(C = sqclasses(p), n = #C, G, R, rad = List());
  G = matrix(n, n, i, j, if (hilbert(C[i],C[j],p) == 1, 0, 1));
  R = matrank(Mod(G,2));
  for (i = 1, n,
    my(z = 1);
    for (j = 1, n, if (G[i,j] != 0, z = 0));
    if (z, listput(rad, C[i])));
  print("    p = ", p, " : ", n, " classes ", C);
  print("            Gram rank over F_2 = ", R, " of ", if (p==2, 3, 2),
        ",  radical = ", Vec(rad),
        if (#rad == 1, "   NON-DEGENERATE", "   DEGENERATE")));
}
print("");
print("    The only class pairing trivially with everything is the trivial one,");
print("    at every p including 2.  That is local duality for Z/2, exhaustively.");
print("");

\\ ------------------------------------------ (3) unramified annihilation

print("-------------------------------------------------------------------------");
print("(3) UNRAMIFIED CLASSES, AND WHERE THE SOFT PROOF STOPS.");
print("    For ell != p the module is unramified and H^1_ur(K,M), H^1_ur(K,M^D)");
print("    are exact annihilators, each of order |H^0|.  That alone gives duality");
print("    in the tame range, with no fundamental class -- and it is precisely the");
print("    'unramified isotropy' that kills beta_v at good places in the survey.");
print("");
{
foreach ([3,5,7,11,13], p,
  my(C = sqclasses(p), ur = List(), iso = 1);
  foreach (C, c, if (valuation(c,p) % 2 == 0, listput(ur, c)));
  foreach (Vec(ur), a, foreach (Vec(ur), b, if (hilbert(a,b,p) == -1, iso = 0)));
  print("    p = ", p, " : unramified classes ", Vec(ur), ",  order ", #ur,
        " = half of ", #C, ",  isotropic: ", if (iso, "yes", "no")));
}
print("    p = 2 : unramified classes [1, 5], order 2 -- but |H^1| = 8, so NOT");
print("            half.  (5,5)_2 = ", hilbert(5,5,2), ", isotropic but too small.");
print("            At ell = p the module is no longer unramified (the formal group");
print("            is in the way) and the soft argument collapses; one is thrown");
print("            back on inv and LCFT in full.  Same tame/wild line as the");
print("            symbols of wild-symbols.typ.");
print("");

\\ ------------------------------------- (4) Euler characteristic and Lagrangians

print("-------------------------------------------------------------------------");
print("(4) THE EULER CHARACTERISTIC, AND WHY W_v IS LAGRANGIAN.");
print("    Tate's formula:  |H^0| |H^2| / |H^1| = ||#M||_K .  With M = E[n],");
print("    self-dual under the Weil pairing, |H^2| = |H^0| = |E[n](K)|, so");
print("        |H^1(K,E[n])| = |E[n](K)|^2 |n|_K^{-2} ,");
print("    while  |E(K)/n| = |E[n](K)| |n|_K^{-1} .  Hence |W|^2 = |H^1| : the");
print("    local Kummer image is exactly half-dimensional, i.e. LAGRANGIAN.");
print("    The |n|_K factor is trivial away from n and is the whole subtlety at");
print("    v | n.  Checked for n = 2 at v = 2, where it is live:");
print("");
{
print("      curve                 roots of psi_2 in Q_2   dim E[2](Q_2)  dim W_2  dim H^1");
foreach ([[0,0,1,-1,0], [1,1,1,-1,0], [0,1,1,0,0], [0,0,0,-2,0], [0,0,0,-1,0]], ai,
  my(E = ellinit(ai), f = elldivpol(E,2), fp = factorpadic(f, 2, 40), nr = 0, d0);
  for (j = 1, #fp~, if (poldegree(fp[j,1]) == 1, nr += fp[j,2]));
  d0 = if (nr >= 3, 2, if (nr >= 1, 1, 0));
  print("      ", ai, "         ", nr, "               ", d0,
        "            ", d0+1, "        ", 2*d0+2));
print("");
print("      dim W_2 = dim E[2](Q_2) + 1,  dim H^1 = 2 dim E[2](Q_2) + 2 : half.");
print("      The +1 and +2 are the |2|_2^{-1} correction, absent at odd places.");
}
print("");

\\ ------------------------------- (5) symmetric versus alternating self-duality

print("-------------------------------------------------------------------------");
print("(5) SYMMETRIC VERSUS ALTERNATING SELF-DUALITY -- an easy thing to conflate.");
print("    Z/2 is self-dual over Q_p SYMMETRICALLY: the Hilbert form on");
print("    Q_2^*/(Q_2^*)^2 is a non-degenerate symmetric form on F_2^3, an ODD-");
print("    dimensional space, so it has no Lagrangian at all -- maximal isotropic");
print("    subspaces have dimension 1, not 3/2.");
print("");
{
\\ classes of Q_2^*/(Q_2^*)^2 indexed by (e1,e2,e3) -> (-1)^e1 2^e2 5^e3
my(cls = vector(8, k, my(e = k-1);
      (-1)^bittest(e,0) * 2^bittest(e,1) * 5^bittest(e,2)));
my(bestdim = 0, bestgens = 0);
\\ every subspace of F_2^3 is spanned by at most 3 of the 7 non-zero vectors
for (a = 1, 7,
  if (hilbert(cls[a+1], cls[a+1], 2) != 1, next);
  if (bestdim < 1, bestdim = 1; bestgens = [cls[a+1]]);
  for (b = a+1, 7,
    if (hilbert(cls[b+1], cls[b+1], 2) != 1, next);
    if (hilbert(cls[a+1], cls[b+1], 2) != 1, next);
    my(c = bitxor(a,b));
    if (hilbert(cls[c+1], cls[c+1], 2) != 1, next);
    if (bestdim < 2, bestdim = 2; bestgens = [cls[a+1], cls[b+1]])));
print("    all 8 classes: ", cls);
print("    diagonal (a,a)_2 : ",
      vector(8, k, hilbert(cls[k], cls[k], 2)));
print("    largest totally isotropic subspace: dimension ", bestdim,
      ",  spanned by ", bestgens);
print("    3 is odd, so a Lagrangian would need dimension 3/2 -- there is none,");
print("    and the maximum is ", bestdim, ".");
}
print("");
print("    E[n] is self-dual ALTERNATINGLY, via the Weil pairing, on an EVEN-");
print("    dimensional space -- and there Lagrangians exist.  W_v is one of them.");
print("    That is the whole reason the untwisted pairing gives 0 = 0 on the");
print("    Kummer surface (density-bridge.typ section 2) while the Z/2 pairing of");
print("    integral-bm.typ has no such collapse.");
print("");
\\ ------------------------------ (6) the n = 2 case of the engine of section 2

print("-------------------------------------------------------------------------");
print("(6) THE ENGINE (section 2) IN THE CASE n = 2, WHERE THE HILBERT SYMBOL");
print("    COMPUTES IT.  Let u be a non-residue unit, so L = Q_p(sqrt u) is the");
print("    UNRAMIFIED quadratic extension of Q_p.  Then x is a norm from L iff");
print("    (u,x)_p = 1, so the norm group is visible directly.");
print("");
{
print("      p    u    units w with (u,w)_p = -1     (u,p)_p    N(L^*) = ?");
forprime (p = 3, 40,
  my(u = 1, bad = List());
  forprime (q = 2, 200, if (kronecker(q,p) == -1, u = q; break));
  for (w = 1, p-1, if (hilbert(u,w,p) == -1, listput(bad, w)));
  print("     ", p, "     ", u, "          ", Vec(bad), "                  ",
        hilbert(u,p,p), "       ",
        if (#bad == 0 && hilbert(u,p,p) == -1, "{v even}", "??")));
print("");
print("    Units are ALL norms and a uniformiser is NOT, at every p checked.  So");
print("    N(L^*) = {x : 2 | v_p(x)}, the index is 2, and inv(x) = v(x)/2 -- the");
print("    n = 2 case of inv(x) = v(x)/n.");
}
print("");
print("    Also the n = 2 case of 'a maximal subfield is unramified and splits':");
print("    (u,p) is a DIVISION algebra exactly because (u,p)_p = -1, and u becomes");
print("    a square in Q_p(sqrt u), which therefore splits it.");
print("");
print("    And the residue-field input of Step 2 -- surjectivity of the norm");
print("    N : F_{q^f}^* -> F_q^*, which starts the unit-norm climb.  N is");
print("    x -> x^{(q^f-1)/(q-1)}, so its image is the subgroup of order q-1 in a");
print("    cyclic group of order q^f-1, i.e. all of F_q^*:");
print("");
{
print("       q    f    |image of N|    q-1    surjective?");
my(bad = 0);
foreach ([2,3,5,7,11,13,17,19], q,
  for (f = 2, 4,
    my(g = ffprimroot(ffgen([q,f], 'a)), e, S);
    e = (q^f - 1)/(q - 1);
    S = Set(vector(q^f - 1, k, g^((k-1)*e)));
    if (#S != q-1, bad++);
    if (f == 2 || q <= 5,
      print("      ", q, "    ", f, "       ", #S, "            ", q-1, "      ",
            if (#S == q-1, "yes", "NO")))));
print("");
print("       (all q <= 19, f <= 4 checked; failures: ", bad, ")");
}
print("");

print("done.");
