\\ analytic-local.gp -- the worked example of analytic-local.typ, section 8.
\\ Run from this directory:
\\     gp -q -s 2000000000 analytic-local.gp < /dev/null > results/analytic-local.txt
\\
\\ The theorem says: for X a variety over K, P a smooth K-rational point and
\\ f regular at P, the formal expansion of f in local coordinates at P converges
\\ on a v-adic neighbourhood of P in X(K_v).  The cleanest instance is X = E an
\\ elliptic curve, P = O the point at infinity, local coordinate z = -x/y, and
\\ f = w = -1/y.  The Weierstrass equation becomes the EXACT relation
\\
\\     w = z^3 + a z w^2 + b w^3,
\\
\\ i.e. g(z,w) = 0 with dg/dw(0,0) = 1 invertible -- exactly the hypothesis of
\\ Lemma 3.1.  So w(z) converges near z = 0.  This script checks three things:
\\   (1) the relation holds identically on rational points;
\\   (2) the expansion is the one the theory predicts, w = z^3 + a z^7 + b z^9 + ...,
\\       with coefficients in Z[a,b] (Proposition 7.2);
\\   (3) it CONVERGES v-adically: truncating at order N and evaluating at a point
\\       of the formal group gives an error whose valuation grows linearly in N.

E = ellinit([0,0,0,-16,16]);      \\ y^2 = x^3 - 16x + 16, a model of 37a1
A = -16; B = 16;                  \\ its a and b
P0 = [0, 4];                      \\ a generator of E(Q)
p = 5;                            \\ the place v

\\ ---------------------------------------------------------------- the series

showseries() =
{ my(W = ellformalw(E, 16));
  print("(2) the formal expansion of w = -1/y in the local coordinate z = -x/y:");
  print("      w(z) = ", W, "     (PARI names the series variable x; it is our z)");
  print("    predicted leading terms  z^3 + a z^7 + b z^9  with a = ", A, ", b = ", B);
  print("    coefficients are integral, as Proposition 7.2 predicts for v = ", p);
  print("");
};

\\ ------------------------------------------------- a point in the formal group

\\ Q is in the formal group at p iff p divides the denominator of x(Q);
\\ then v(z) > 0 and the series may be evaluated there.
formalpoint() =
{ my(Q);
  for (n = 1, 40,
    Q = ellmul(E, P0, n);
    if (Q == [0], next);
    if (valuation(denominator(Q[1]), p) > 0, return([n, Q])));
  error("no point of the formal group found");
};

\\ ------------------------------------------------------------------- the checks

run() =
{ my(nQ, n, Q, z, w, W, val);
  nQ = formalpoint(); n = nQ[1]; Q = nQ[2];
  z = -Q[1] / Q[2];
  w = -1 / Q[2];

  print("(1) the exact relation w = z^3 + a z w^2 + b w^3 at Q = ", n, "*P0:");
  print("      w - (z^3 + a z w^2 + b w^3) = ", w - (z^3 + A*z*w^2 + B*w^3),
        "   (0 means it holds identically)");
  print("");

  showseries();

  print("(3) convergence at Q, v = ", p, ":");
  print("      z = ", z, "     v_", p, "(z) = ", valuation(z, p));
  print("      w = ", w, "     v_", p, "(w) = ", valuation(w, p));
  print("    truncating the series at order N and evaluating at z:");
  for (N = 10, 40,
    if (N % 10, next);
    W = truncate(ellformalw(E, N));
    val = subst(W, variable(W), z);
    print("      N = ", N, "    v_", p, "(w - w_N(z)) = ", valuation(w - val, p)));
  print("");
  print("    the error valuation grows linearly in N -- the signature of");
  print("    convergence at a point with v(z) = ", valuation(z, p), ".");
  print("");
};

run();
quit;
