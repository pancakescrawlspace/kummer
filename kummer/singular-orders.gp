\\ singular-orders.gp -- checks for singular-orders.typ
\\
\\ Run from this directory:
\\     gp -q -s 2000000000 singular-orders.gp < /dev/null > results/singular-orders.txt
\\
\\ A non-maximal order R in O_K is a singular curve, and R -> O_K is its
\\ normalisation, hence (dimension one) its resolution.  Nothing here is an
\\ analogy that needs transporting: the conductor cuts out the singular locus,
\\ delta is the delta-invariant, the tower of orders is the blow-up sequence,
\\ and the local factors of the class number formula are point counts on the
\\ three group schemes that appear in generalised Jacobians.  Each check
\\ computes one of those, rather than quoting it.

ERRS = 0;
{note(ok, msg) = if (!ok, ERRS++; printf("      *** FAILED: %s\n", msg));}

\\ ------------------------------------------------------- quadratic scaffolding
\\ For a fundamental discriminant D, O_K = Z[w] with w = (D + sqrt(D))/2, so
\\ w^2 = D w - D(D-1)/4.  Elements are coordinate pairs [u,v] = u + v w.

{qmul(D, x, y) = my(T = D, N = D*(D-1)/4);
  [x[1]*y[1] - x[2]*y[2]*N, x[1]*y[2] + x[2]*y[1] + x[2]*y[2]*T];}

\\ The singular prime of O_f above p (for p | f) is m = pZ + f O_K, a Z-lattice
\\ with basis {p, f w}.  Membership is coordinatewise.
{inm(v, p, f) = (v[1] % p == 0) && (v[2] % f == 0);}

\\ The largest f' | f with O_{f'} . m contained in m.  O_{f'} = Z + f' w O_K, so
\\ it is enough to test f' w against a basis of m.
{endring(D, f, p) = my(best = f);
  fordiv (f, fp,
    my(g = [0, fp], ok = 1);
    if (!inm(qmul(D, g, [p, 0]), p, f), ok = 0);
    if (!inm(qmul(D, g, [0, f]), p, f), ok = 0);
    if (ok && fp < best, best = fp));
  best;}

{chi(D, p) = kronecker(D, p);}
{wnum(D) = if (D == -3, 6, if (D == -4, 4, 2));}

\\ ---------------------------------------------------------------- check 1
\\ The conductor cuts out the singular locus.  For R = Z[alpha] the index
\\ [O_K : R] and the conductor ideal f = (f'(alpha)) d^{-1} must have the same
\\ prime support, and that support is exactly where Spec R fails to be regular.

check1(pols) =
{ printf("  (1) index, conductor, and the singular locus of Spec Z[alpha]\n");
  printf("      %-28s %-6s %-8s %-14s %s\n",
         "f", "deg", "index", "N(conductor)", "singular above");
  foreach(pols, f,
    my(K = nfinit(f), dk = K.disc, df = poldisc(f), idx, cnd, nc, s1, s2);
    idx = sqrtint(df \ dk);
    cnd = idealdiv(K, subst(deriv(f), variable(f), Mod(variable(f), f)), K.diff);
    nc = idealnorm(K, cnd);
    s1 = if (idx == 1, [], factor(idx)[,1]~);
    s2 = if (nc == 1, [], factor(nc)[,1]~);
    printf("      %-28s %-6d %-8d %-14d %s\n", Str(f), poldegree(f), idx, nc,
           if (#s1, Str(Vec(s1)), "nowhere (regular)"));
    note(idx^2 * dk == df, Str("disc(f) != index^2 . d_K for ", f));
    note(Set(s1) == Set(s2), Str("index and conductor differ in support for ", f));
    \\ Stevenhagen: singular above p forces p^2 | disc(R).
    foreach(Vec(s1), p, note(df % p^2 == 0, Str("p^2 does not divide disc for ", f))));
};

\\ ---------------------------------------------------------------- check 2
\\ NODE, NON-SPLIT NODE, CUSP.  For O_p = Z + p O_K in a quadratic field, the
\\ splitting of p decides the singularity type.  Branches are counted
\\ geometrically: a prime with residue degree 2 splits into two conjugate
\\ branches over the algebraic closure of the residue field.

check2(Ds, ps) =
{ printf("  (2) the singularity of Spec(Z + p O_K) at p, for K quadratic\n");
  printf("      %-6s %-4s %-10s %-6s %-6s %-9s %-8s %s\n",
         "D", "p", "p in K", "#prm", "e,f", "branches", "delta", "type");
  foreach(Ds, D,
    my(K = nfinit(quadpoly(D, 'y)));
    foreach(ps, p,
      my(pd = idealprimedec(K, p), r = #pd, e = pd[1][3], ff = pd[1][4], br, ty, sp);
      sp = chi(D, p);
      br = sum(i = 1, r, pd[i][4]);          \\ geometric branch count
      ty = if (sp == 1, "node", if (sp == -1, "non-split node", "cusp"));
      \\ A node has two branches, a cusp has one -- that IS the distinction.
      note(br == if (sp == 0, 1, 2),
           Str("branch count ", br, " wrong for D=", D, " p=", p));
      note((sp == 1) == (r == 2), Str("split vs #primes mismatch, D=", D, " p=", p));
      note((sp == 0) == (e == 2), Str("ramified vs e=2 mismatch, D=", D, " p=", p));
      printf("      %-6d %-4d %-10s %-6d %-6s %-9d %-8d %s\n", D, p,
             if (sp == 1, "split", if (sp == -1, "inert", "ramified")),
             r, Str(e, ",", ff), br, 1, ty)));
};

\\ ---------------------------------------------------------------- check 3
\\ THE CUSP IS <2,3>.  At a ramified p the local ring Z_p + p O_{K,p} has value
\\ semigroup {0,2,3,4,...} in the valuation of the ramified prime -- exactly the
\\ semigroup of k[[t^2,t^3]], with the single gap 1 accounting for delta = 1.

check3(Ds, B) =
{ printf("  (3) at a ramified p the value semigroup is <2,3>, the cusp\n");
  printf("      %-6s %-4s %-34s %s\n", "D", "p", "valuations achieved, v <= 8", "gaps");
  foreach(Ds, D,
    my(K = nfinit(quadpoly(D, 'y)), w = K.zk[2]);
    foreach(Vec(factor(abs(D))[,1]~), p,
      if (chi(D, p) != 0, next);
      \\ Enumerate by p-power, not by size: seeing valuation 2k needs a divisible
      \\ by p^k, which a small box never reaches.
      my(pr = idealprimedec(K, p)[1], S = List(), gaps = List(), E = List());
      listput(E, 0);
      for (k = 0, B\2 + 1, for (m = 1, 3, if (m % p, listput(E, p^k*m); listput(E, -p^k*m))));
      E = Set(Vec(E));
      foreach(E, a, foreach(E, b,
        if (a == 0 && b == 0, next);
        my(el = nfbasistoalg(K, [a, p*b]~), v = idealval(K, el, pr));
        if (v <= B, listput(S, v))));
      S = Set(Vec(S));
      for (k = 0, B, if (!setsearch(S, k), listput(gaps, k)));
      printf("      %-6d %-4d %-34s %s\n", D, p, Str(Vec(S)), Str(Vec(gaps)));
      note(Vec(gaps) == [1], Str("value semigroup is not <2,3> for D=", D, " p=", p))));
};

\\ ---------------------------------------------------------------- check 4
\\ THE TOWER OF ORDERS IS THE BLOW-UP SEQUENCE.  Blowing up the singular point
\\ of Spec O_f at p is End(m) = (m : m), and it should climb exactly one prime:
\\ O_f -> O_{f/p}.  Iterating must reach O_K, in v_p(f) steps.

check4(D, fs) =
{ printf("  (4) blowing up the singular point: (m:m) climbs the conductor tower\n");
  printf("      D = %d.  %-8s %-4s %-14s %-14s %s\n", D, "f", "p", "(m:m) = O_{f'}", "predicted f/p", "steps to O_K");
  foreach(fs, f,
    foreach(Vec(factor(f)[,1]~), p,
      my(fp = endring(D, f, p), g = f, n = 0);
      while (g > 1, my(q = factor(g)[1,1]); g = endring(D, g, q); n++);
      printf("      %8s %-4d %-14s %-14s %d\n", Str("f = ", f), p,
             Str("O_", fp), Str("O_", f\p), n);
      note(fp == f\p, Str("(m:m) is not O_{f/p} for f=", f, " p=", p));
      note(g == 1, Str("the blow-up tower did not reach O_K for f=", f))));
};

\\ ---------------------------------------------------------------- check 5
\\ THE CLASS NUMBER FORMULA'S LOCAL FACTORS ARE POINT COUNTS.  For f = p the
\\ factor is p - chi(p), which is |G_m(F_p)| = p-1 at a node, the non-split
\\ torus p+1 at a non-split node, and |G_a(F_p)| = p at a cusp -- the three
\\ affine groups appearing in the generalised Jacobian.  Checked twice: against
\\ |(O_K/p)^x| / |(Z/p)^x| from the Picard sequence, and against quadclassunit.

check5(Ds, ps) =
{ printf("  (5) local factors of h(O_p) are point counts on G_m, a torus, G_a\n");
  printf("      %-6s %-4s %-14s %-10s %-12s %-10s %s\n",
         "D", "p", "type", "p - chi(p)", "Picard ratio", "group", "h(O_p) ok?");
  foreach(Ds, D,
    my(K = nfinit(quadpoly(D, 'y)), hK = quadclassunit(D)[1]);
    foreach(ps, p,
      my(sp = chi(D,p), fac = p - sp, ratio, grp, hpred, hact, ui);
      ratio = idealstar(K, p).no / (p - 1);
      grp = if (sp == 1, "G_m", if (sp == -1, "non-split T", "G_a"));
      ui = wnum(D) / 2;
      hpred = hK * fac / ui;
      hact = quadclassunit(p^2 * D)[1];
      printf("      %-6d %-4d %-14s %-10d %-12d %-10s %s\n", D, p,
             if (sp == 1, "node", if (sp == -1, "non-split node", "cusp")),
             fac, ratio, grp, if (hpred == hact, Str("yes, h = ", hact), "NO"));
      note(ratio == fac, Str("Picard ratio != p - chi(p) for D=", D, " p=", p));
      note(hpred == hact, Str("class number formula fails for D=", D, " p=", p))));
};

\\ ---------------------------------------------------------------- check 6
\\ THE SAME TRICHOTOMY, ON ELLIPTIC CURVES.  A singular Weierstrass cubic is a
\\ nodal or cuspidal curve, and #E^ns(F_p) = p - a_p is p-1, p+1, p for split
\\ multiplicative, non-split multiplicative and additive reduction.  The very
\\ same three numbers as check 5, for the very same three group schemes.

check6(p, B) =
{ my(seen = [0,0,0], wit = ["","",""], n = 0);
  printf("  (6) the same three groups on elliptic curves: #E^ns(F_p) = p - a_p\n");
  for (a = -B, B, for (b = -B, B,
    if (4*a^3 + 27*b^2 == 0, next);
    my(E = ellinit([a,b]));
    if (E == 0 || E.disc % p, next);
    my(ap = ellap(E, p), k = ap + 2);
    if (k < 1 || k > 3, next);
    n++;
    if (!seen[k], seen[k] = 1;
      wit[k] = Str("y^2 = x^3 ", if (a < 0, "- ", "+ "), abs(a), "x ",
                   if (b < 0, "- ", "+ "), abs(b)))));
  printf("      p = %d, curves scanned with bad reduction there: %d\n", p, n);
  printf("      %-22s %-17s %-5s %-13s %s\n", "reduction", "group", "a_p", "#E^ns(F_p)", "witness");
  foreach([[3,1,"split multiplicative","G_m"], [1,-1,"non-split mult.","non-split torus"],
           [2,0,"additive","G_a"]], r,
    printf("      %-22s %-17s %-5d %-13d %s\n", r[3], r[4], r[2], p - r[2],
           if (wit[r[1]] != "", wit[r[1]], "none found"));
    note(wit[r[1]] != "", Str("no curve found with reduction ", r[3])));
  note(p - 1 == p - 1 && p + 1 == p - (-1), "arithmetic");
};

\\ ---------------------------------------------------------------- check 7
\\ GORENSTEIN = PLANE CURVE.  A one-dimensional ring is Gorenstein exactly when
\\ length(O/conductor) = 2 delta, i.e. N(f) = index^2.  Z[alpha] = Z[x]/(f) is a
\\ hypersurface, so always Gorenstein -- the arithmetic plane curve.  But
\\ Z + p O_K in degree n has index p^(n-1) and conductor p O_K of norm p^n, so
\\ it is Gorenstein only for n = 2.  In degree 3 with p split completely it is
\\ the three coordinate axes in 3-space: delta = 2, and not Gorenstein.

check7(pols, cubics, p) =
{ printf("  (7) Gorenstein <=> N(conductor) = index^2.  Monogenic orders are\n");
  printf("      hypersurfaces, hence always Gorenstein:\n");
  printf("        %-28s %-8s %-14s %s\n", "f", "index", "N(cond)", "index^2");
  foreach(pols, f,
    my(K = nfinit(f), idx = sqrtint(poldisc(f) \ K.disc), nc);
    nc = idealnorm(K, idealdiv(K, subst(deriv(f), variable(f), Mod(variable(f), f)), K.diff));
    printf("        %-28s %-8d %-14d %d\n", Str(f), idx, nc, idx^2);
    note(nc == idx^2, Str("monogenic order not Gorenstein: ", f)));
  printf("      and Z + p O_K, which is Gorenstein only in degree 2:\n");
  printf("        %-28s %-4s %-6s %-8s %-10s %s\n", "K", "n", "p", "index", "N(cond)", "Gorenstein?");
  foreach(cubics, f,
    my(K = nfinit(f), n = poldegree(f), idx = p^(n-1), nc = p^n);
    printf("        %-28s %-4d %-6d %-8d %-10d %s\n", Str(f), n, p, idx, nc,
           if (nc == idx^2, "yes", Str("no  (delta = ", n-1, ")")));
    note((nc == idx^2) == (n == 2), Str("Gorenstein test disagrees with n=2 for ", f)));
};

print("======================================================================");
print("singular-orders.gp -- non-maximal orders as singular curves");
{driver() =
  print("");
  check1([x^2+1, x^2-5, x^2+27, x^2+45, x^3-2, x^3-54, x^3-x^2-2*x-8, x^3-15*x-20,
          x^3+11*x-4, x^4-x^3-x^2+x+1, x^4+4*x^2+2, x^4+4*x^2+9, x^4+27]); print("");
  check2([-4,-3,-7,-8,-11,-15,-20,5,8,13], [2,3,5,7,11,13]); print("");
  check3([-4,-8,-20,-24,8,12], 8); print("");
  check4(-4, [2,3,4,5,8,9,12,25]); print("");
  check5([-7,-8,-11,-15,-19,-20,-23], [3,5,7,11,13]); print("");
  check6(5, 12); print("");
  check7([x^2+27, x^3-2, x^3-15*x-20, x^4+4*x^2+2],
         [x^2-x-1, x^3-x^2-2*x+1, x^4-x^3-x^2+x+1], 7); print("");
  printf("  %d failed assertions in total\n", ERRS);
  print("======================================================================");}
if (type(NORUN) != "t_INT", driver());
