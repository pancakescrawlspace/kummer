\\ kummer-j0-exceptional.gp -- residues of A along the sixteen exceptional curves
\\
\\ Run from this directory:
\\     gp -q -s 4000000000 kummer-j0-exceptional.gp < /dev/null \
\\         > results/kummer-j0-exceptional.txt
\\
\\ Companion to section 7.4 of kummer-example-j0.typ.  X = Kum(E x E') is the
\\ minimal resolution of Y = (E x E')/(-1,-1); the sixteen A_1 points of Y are
\\ the pairs (T_a, T'_b) of 2-torsion, and F_(ab) is the exceptional curve over
\\ (T_a, T'_b).  Section 7.4 disposes of every OTHER prime divisor (E x E' -> Y
\\ is etale in codimension one and both entries have 2-divisible divisor there);
\\ what is left is these sixteen, and this script does them.
\\
\\ Method: the stage-2 local computation of kummer-survey.typ section 7.11.2,
\\ which is per-factor and so applies verbatim to two DIFFERENT curves.  With
\\ anti-invariant uniformisers s, u at the fixed point, v_F = ord/2 on invariant
\\ functions, and for g_1 = prod_{k != i}(x - r_k):
\\
\\     a = oo      : alpha = -2, C_1 = 1
\\     a = i       : alpha =  0, C_1 = f'(r_i)
\\     otherwise   : alpha =  1, C_1 = 1/(r_a - r_i)
\\
\\ and likewise (b, j) on the second factor; then
\\     d_F (g_1, g_2) = (-1)^(alpha beta) C_1^beta C_2^alpha   in kappa(F)^*/sq.
\\
\\ A itself is a corestriction, so the residue on X over Q is
\\     d_D (A) = prod_{D' | D} N_{k(D')/k(D)} ( d_{D'} (g,h) ) ,
\\ D' running over the primes of X_K above D (residues.typ section 9).  That
\\ last step is the whole point: (g,h) over K IS ramified on six of the sixteen
\\ curves, and the corestriction kills it.

P  = subst(polcompositum(x^3 - 3, x^2 + x + 1)[1], x, y);
L  = nfinit(P);                       \\ L = Q(u, zeta_3), the 2-division field
uu = nfroots(L, x^3 - 3)[1];
zz = nfroots(L, x^2 + x + 1)[1];

r(i) = -uu^2 * zz^(i % 3);            \\ roots of x^3 + 9
s(j) =  3*uu * zz^(j % 3);            \\ roots of t^3 - 81

G  = nfgaloisconj(L);
ap(g, v) = nfgaloisapply(L, g, v);

\\ the element of Gal(L/Q) fixing u: it generates Gal(L/K), K = Q(u)
{tau = 0;
 for (g = 1, #G,
   if (ap(G[g], uu) == uu && ap(G[g], zz) != zz, tau = G[g]));}

\\ index bookkeeping.  a, b in {-1, 0, 1, 2}, with -1 standing for the point O.
ridx(v) = {for (i = 0, 2, if (v == r(i), return(i))); -9;}
sidx(v) = {for (j = 0, 2, if (v == s(j), return(j))); -9;}
actE(g, a) = if (a == -1, -1, ridx(ap(g, r(a))));
actEp(g, b) = if (b == -1, -1, sidx(ap(g, s(b))));
act(g, P) = [actE(g, P[1]), actEp(g, P[2])];

\\ ------------------------------------------------------- the local invariants

sideE(a, i)  = if (a == -1, [-2, 1], a == i, [0, 3*r(i)^2], [1, 1/(r(a) - r(i))]);
sideEp(b, j) = if (b == -1, [-2, 1], b == j, [0, 3*s(j)^2], [1, 1/(s(b) - s(j))]);

\\ residue of the symbol ( prod_{k!=i}(x-r_k), prod_{l!=j}(t-s_l) ) along F_(ab)
{resgeom(i, j, a, b) =
  my(A = sideE(a, i), B = sideEp(b, j), al = A[1], be = B[1]);
  (-1)^(al*be) * A[2]^be * B[2]^al;}

\\ ------------------------------------------------------------- orbits, fields

\\ orbit of a point under a list of automorphisms
{orbit(gs, P) = my(O = [P], done = 0);
  while (!done, done = 1;
    for (k = 1, #O, for (g = 1, #gs,
      my(Q = act(gs[g], O[k]));
      if (!setsearch(Set(O), Q), O = concat(O, [Q]); done = 0))));
  vecsort(O);}

\\ stabiliser of P inside a list of automorphisms
{stab(gs, P) = my(S = List());
  for (g = 1, #gs, if (act(gs[g], P) == P, listput(S, gs[g])));
  Vec(S);}

\\ is w a square in the field L^A, A a subgroup given as a list of automorphisms?
{issqfix(w, A) = my(rt);
  if (!nfeltispower(L, w, 2, &rt), return(0));
  for (e = 1, 2, my(c = if (e == 1, rt, -rt), ok = 1);
    for (g = 1, #A, if (ap(A[g], c) != c, ok = 0; break));
    if (ok, return(1)));
  0;}

\\ norm from L^{stab_H(P)} down to L^{stab_G(P)}: product over coset reps
{normdown(w, P, H) =
  my(SG = stab(G, P), SH = stab(H, P), reps = List(), n = 1);
  for (g = 1, #SG,
    my(new = 1);
    for (k = 1, #reps,
      for (h = 1, #SH,
        if (nfgaloisapply(L, SG[g], y) == nfgaloisapply(L,
              subst(nfgaloisapply(L, reps[k], y), y, nfgaloisapply(L, SH[h], y)), y),
            new = 0; break(2))));
    if (new, listput(reps, SG[g])));
  for (k = 1, #reps, n *= ap(reps[k], w));
  n;}

\\ ------------------------------------------------------------------- the runs

{
print("======================================================================");
print("kummer-j0-exceptional.gp -- the sixteen exceptional curves");
print("");
print("L = Q(u, zeta_3), u^3 = 3 : ", P, "   disc ", L.disc);
print("Gal(L/Q) has order ", #G, "; tau (fixing u) generates Gal(L/K)");
print("");

\\ all sixteen fixed points
my(PTS = List());
for (a = -1, 2, for (b = -1, 2, listput(PTS, [a,b])));
PTS = Vec(PTS);

\\ --- Q-orbits and K-orbits
my(H = [], QO = List(), seen = []);
for (g = 1, #G, if (ap(G[g], uu) == uu, H = concat(H, [G[g]])));
print("  Gal(L/K) has order ", #H);
print("");
print("The sixteen curves F_(a,b), a from E[2] and b from E'[2] (-1 = the point O):");
print("");
for (k = 1, #PTS,
  my(Pt = PTS[k]);
  if (setsearch(Set(seen), Pt), next);
  my(O = orbit(G, Pt), dq = #stab(G, Pt));
  seen = setunion(Set(seen), Set(O));
  listput(QO, [Pt, O]);
  printf("  Q-orbit of %s : %d curves, k(D) has degree %d over Q\n",
         Pt, #O, 6/dq));
QO = Vec(QO);
print("");

print("Residues of A = cor_{K/Q}(g,h) along them.  A_K = (g,h) is the symbol");
print("with i = j = 0, i.e. the linear factors are x + u^2 and t - 3u.");
print("");
my(allsq = 1, ram = 0);
for (m = 1, #QO,
  my(Pt = QO[m][1], O = QO[m][2], KO = List(), sn = [], tot = 1);
  \\ the K-divisors above this Q-divisor: the Gal(L/K)-orbits inside O
  for (k = 1, #O,
    if (setsearch(Set(sn), O[k]), next);
    my(o2 = orbit(H, O[k]));
    sn = setunion(Set(sn), Set(o2));
    listput(KO, O[k]));
  KO = Vec(KO);
  printf("  D = Q-orbit of %s  (%d curves, k(D) degree %d):\n", Pt, #O, 6/#stab(G,Pt));
  for (k = 1, #KO,
    my(Q = KO[k], d = resgeom(0, 0, Q[1], Q[2]), nd);
    nd = normdown(d, Pt, H);
    tot *= nd;
    printf("      D' over F_%s : d_{D'}(g,h) square in L? %s ;  after cor : %s\n",
           Q, if (nfeltispower(L, d, 2), "yes", "NO  <- (g,h) is ramified here"),
           if (issqfix(nd, stab(G,Pt)), "square", "not a square"));
    if (!nfeltispower(L, d, 2), ram++));
  my(ok = issqfix(tot, stab(G, Pt)));
  printf("      ==> d_D(A) is a square in k(D) : %s\n", if (ok, "YES", "NO"));
  print("");
  if (!ok, allsq = 0));

printf("  the symbol (g,h) over K is ramified along %d of the K-divisors,\n", ram);
printf("  and the corestriction A is unramified along ALL sixteen curves : %s\n",
       if (allsq, "YES", "NO"));
print("");

\\ --- the four non-trivial residues in closed form, as the document tabulates them
print("The residues of (g,h) in closed form, checked against the hand values:");
print("");
my(cl = [[[1,2], 27,            "-(r_1-r_0)(s_2-s_0) = 27"],
         [[0,1], 9*uu,          "f'(r_0) = 3 r_0^2 = 9u"],
         [[1,0], 27*uu^2,       "f~'(s_0) = 3 s_0^2 = 27u^2"],
         [[1,1], 9*(1-zz)^2,    "-(r_1-r_0)(s_1-s_0) = 9(1-z)^2"]], wrong = 0);
for (k = 1, #cl,
  my(Q = cl[k][1], val = cl[k][2], nm = cl[k][3], d = resgeom(0,0,Q[1],Q[2]));
  \\ compare modulo squares, which is all a residue means
  my(ok = nfeltispower(L, d/val, 2));
  if (!ok, wrong++);
  printf("      F_%s : %-32s  %s\n", Q, nm, if (ok, "agrees", "DISAGREES")));
printf("  %d of %d closed forms wrong\n", wrong, #cl);
print("");
print("  so the two Q-divisors that carry ramification are cleared differently:");
print("    D = orbit of (0,0), k(D) = K : residues 1 and 27, and the second is");
print("        corestricted by N_{L/K}, giving 27^2 = 729 -- a NORM kills it;");
print("    D = orbit of (0,1), k(D) = L : residues 9u, 27u^2, 9(1-z)^2 with");
print("        k(D') = k(D) so cor is the identity, and the PRODUCT is");
print("        9*27*9*u^3*(1-z)^2 = 6561(1-z)^2 = (81(1-z))^2 -- cancellation.");
print("");

\\ --- independent cross-check: over L, res_L(A) = sum of the three conjugates
print("Cross-check.  Over L the corestriction becomes the sum of the three");
print("conjugate symbols, A^(2k,k) for k = 0,1,2 -- the three psi-matched pairs,");
print("which are exactly the (i,j) with i + j = 0 mod 3.  Their product must be");
print("a square in L along every one of the sixteen curves:");
print("");
my(bad = 0);
for (k = 1, #PTS,
  my(Pt = PTS[k], p = 1);
  for (n = 0, 2, p *= resgeom((2*n) % 3, n, Pt[1], Pt[2]));
  if (!nfeltispower(L, p, 2), bad++; printf("      F_%s : NOT a square\n", Pt)));
printf("  %d of 16 fail over L\n", bad);
print("");
print("Both routes agree.  The point is that (g,h) alone does NOT work: it is");
print("ramified on six of the sixteen curves, and what removes the ramification");
print("is the corestriction -- by a norm from a quadratic extension on one");
print("Q-divisor, and by cancellation among the three conjugates on the other.");
}
quit;
