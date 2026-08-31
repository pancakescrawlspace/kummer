\\ pencil-conic-count.gp -- checks for pencil-conic-count.typ
\\
\\ Run from this directory:
\\     gp -q -s 4000000000 pencil-conic-count.gp < /dev/null \
\\         > results/pencil-conic-count.txt
\\
\\ Mathematics Stack Exchange 5130224.  L, L_1, ..., L_6 are lines in P^3;
\\ the planes V through L form a pencil, and each cuts the L_i in six points.
\\ For how many V do those six points lie on a conic?  The naive count is 12
\\ (a 6x6 determinant whose entries are quadratic in a parameter moving
\\ linearly).  The answer is 8.  These checks confirm the degree, exhibit the
\\ missing 4 as a spurious factor t^4 coming from a chart that degenerates,
\\ and verify geometrically -- in coordinates chosen independently of that
\\ chart -- that the eight roots really are conconic configurations.
\\
\\ Coordinates: L = {y = z = 0}, and V_[s:t] = {s y + t z = 0}.

default(realprecision, 38);

\\ Random lines are drawn with coordinates in [-HGT, HGT].  HGT must not be
\\ small: with HGT = 10 roughly one configuration in twenty is accidentally
\\ non-generic (a degree drop, or two of the eight planes coinciding), which
\\ is a property of the draw and not of the geometry.  At HGT = 1000 none of
\\ forty draws was degenerate.
HGT = 1000;
TRIALS = 40;

rnd(H) = random(2*H + 1) - H;
pt(H) = [rnd(H), rnd(H), rnd(H), rnd(H)];

\\ L_i = span(A,B) meets V_[s:t] in one point; its four coordinates are
\\ linear forms in (s,t).
meet(A, B) =
{ my(al = s*B[2] + t*B[3], be = -(s*A[2] + t*A[3]));
  vector(4, k, al*A[k] + be*B[k]);
};

\\ the Pluecker coordinate p_23 of span(A,B).  L = {y=z=0} has only p_14 = 1,
\\ so the incidence relation reduces to p_23 = 0: L_i meets L iff p_23 = 0.
p23(A, B) = A[2]*B[3] - A[3]*B[2];

\\ monomials of degree d in three chart coordinates, in a fixed order
monos(v, d) =
{ my(L = List());
  for (a = 0, d, for (b = 0, d - a, listput(L, v[1]^a * v[2]^b * v[3]^(d-a-b))));
  Vec(L);
};

\\ the two determinants for one random configuration of n lines, degree d.
\\   D1 : honest chart (x : q : w),  where (y,z) = (-t q, s q)
\\   D2 : naive  chart (x : y : w),  valid only where t != 0
config(n, d, H) =
{ my(A = vector(n, i, pt(H)), B = vector(n, i, pt(H)), P, D1, D2, qcst = 1);
  P = vector(n, i, meet(A[i], B[i]));
  for (i = 1, n, if (P[i][3] % s != 0 || poldegree(P[i][3]/s, s) > 0 ||
                     poldegree(P[i][3]/s, t) > 0, qcst = 0));
  D1 = matdet(matrix(n, n, i, j, monos([P[i][1], P[i][3]/s, P[i][4]], d)[j]));
  D2 = matdet(matrix(n, n, i, j, monos([P[i][1], P[i][2], P[i][4]], d)[j]));
  [A, B, P, D1, D2, qcst];
};

\\ ---------------------------------------------------------------- check 1
\\ The one structural fact the whole count rests on.  Solving s y + t z = 0
\\ along L_i gives a point whose y- and z-coordinates are m t and -m s with
\\ m = p_23(L_i) CONSTANT.  So in the chart (x : q : w) with (y,z) =
\\ (-t q, s q), the moving point is
\\
\\        P_i(s,t)  =  ( linear : constant : linear ) ,
\\
\\ and it is that one degree-0 slot -- not degree 1 -- that costs the naive
\\ count its four planes.

check1() =
{ my(bad = 0, tot = 0, hi = 0, ex = 0);
  printf("  (1) the middle chart coordinate is constant in (s,t)\n");
  for (trial = 1, TRIALS,
    my(c = config(6, 2, HGT), P = c[3], A = c[1], B = c[2]);
    if (c[6] == 0, bad++);
    for (i = 1, 6,
      tot++;
      if (P[i][2] != t*p23(A[i], B[i]), bad++);
      if (P[i][3] != -s*p23(A[i], B[i]), bad++);
      if (poldegree(P[i][1]) > 1 || poldegree(P[i][4]) > 1, hi++);
      if (poldegree(P[i][1]) == 1 && poldegree(P[i][4]) == 1, ex++)));
  printf("      y-coord != m t, or z-coord != -m s, or q not constant : %d\n", bad);
  printf("      x- or w-coord of degree > 1 in (s,t)                  : %d\n", hi);
  printf("      both of degree exactly 1 : %d of %d moving points\n", ex, tot);
  \\ the degenerate case, as a control: a line meeting L has p_23 = 0
  my(A = [1,0,0,0], B = [0,0,0,1], C = pt(HGT), D = pt(HGT));
  printf("      control: p_23 of a line inside {y=z=0} is %d;  of a random line, %d\n",
         p23(A, B), p23(C, D));
};

\\ ---------------------------------------------------------------- check 2
\\ The degree, and the missing four.  In the honest chart the six columns
\\ (x^2, q^2, w^2, xq, xw, qw) have degrees (2,0,2,1,2,1), so the determinant
\\ is homogeneous of degree 8.  In the naive chart every column has degree 2,
\\ giving 12 -- but the q-columns pick up a factor of t, and
\\
\\                        D2  =  t^4 . D1
\\
\\ IDENTICALLY.  The four extra roots are one plane, {y = 0}, counted four
\\ times, where the chart (x:y:w) collapses to a line.

check2() =
{ my(bad = 0, badd = 0, badsq = 0, tot = 0);
  printf("  (2) deg D1 = 8, deg D2 = 12, and D2 = t^4 D1 identically\n");
  for (trial = 1, TRIALS,
    my(c = config(6, 2, HGT), D1 = c[4], D2 = c[5]);
    tot++;
    if (poldegree(subst(D1, t, 1), s) != 8 || poldegree(subst(D1, s, 1), t) != 8, badd++);
    if (D2 != t^4 * D1, bad++);
    if (poldisc(subst(D1, t, 1)) == 0, badsq++));
  printf("      D1 not of bidegree (8,8) : %d\n", badd);
  printf("      D2 != t^4 D1             : %d\n", bad);
  printf("      D1 not squarefree, i.e. two of the eight planes coincident : %d   (over %d)\n", badsq, tot);
};

\\ ---------------------------------------------------------------- check 3
\\ The eight roots, verified GEOMETRICALLY and without the chart.  At a root
\\ lambda_0 the six points are computed in P^3, a basis of the plane is taken
\\ from the kernel of (0, s_0, 1, 0) -- nothing to do with (x:q:w) -- and the
\\ 6x6 Veronese determinant in that basis is evaluated.  Rows are normalised
\\ to sup-norm 1 first, so the scale is meaningful.  A random non-root is the
\\ negative control.

vdet(P4, s0) =
{ my(K = matker(Mat([0, s0, 1, 0])), M, C);
  C = vector(6, i,
    my(v = matsolve(K, P4[i]~), m = vecmax(vector(3, k, abs(v[k]))));
    vector(3, k, v[k]/m));
  M = matrix(6, 6, i, j, monos(C[i], 2)[j]);
  abs(matdet(M));
};

check3() =
{ my(c = config(6, 2, HGT), D1 = c[4], A = c[1], B = c[2], f, rts, mx = 0, ctrl);
  printf("  (3) the eight roots are genuine: conconic in an independent basis\n");
  f = subst(D1, t, 1);
  rts = polroots(f);
  printf("      %d roots of the degree-%d form\n", #rts, poldegree(f));
  for (k = 1, #rts,
    my(s0 = rts[k], P4 = vector(6, i, subst(subst(meet(A[i], B[i]), t, 1), s, s0)), v);
    v = vdet(P4, s0);
    if (v > mx, mx = v);
    printf("      root %d : s = %-34s |Veronese det| = %.3e\n", k,
           strprintf("%.8f %s %.8fi", real(s0), if (imag(s0) < 0, "-", "+"), abs(imag(s0))), v));
  ctrl = vdet(vector(6, i, subst(subst(meet(A[i], B[i]), t, 1), s, 7/3)), 7/3);
  printf("      largest at a root : %.3e\n", mx);
  printf("      negative control, s = 7/3 (not a root) : %.3e\n", ctrl);
  printf("      separation : %d orders of magnitude\n", round(log(ctrl/mx)/log(10)));
};

\\ ---------------------------------------------------------------- check 4
\\ The linear case is the control the question itself supplies: three lines,
\\ three collinear points.  Rows (x, q, w) of degrees (1,0,1), determinant of
\\ degree 2 -- the two transversals to the four lines L, L_1, L_2, L_3.  The
\\ naive chart gives 3, off by exactly t^1.

check4() =
{ my(bad = 0, bad2 = 0);
  printf("  (4) the linear control: three lines, three collinear points\n");
  for (trial = 1, TRIALS,
    my(c = config(3, 1, HGT), D1 = c[4], D2 = c[5]);
    if (poldegree(subst(D1, t, 1), s) != 2 || poldegree(subst(D1, s, 1), t) != 2, bad++);
    if (D2 != -t * D1, bad2++));
  printf("      D1 not of bidegree (2,2) : %d;  D2 != -t D1 : %d   (over %d)\n", bad, bad2, TRIALS);
  printf("      2 is the classical count of transversals to four general lines\n");
};

\\ ---------------------------------------------------------------- check 5
\\ The general formula.  A monomial x^a q^b w^c of degree d has degree d - b
\\ in (s,t), so the N x N determinant, N = (d+1)(d+2)/2, has degree
\\
\\        N d - sum_b  =  N d - d(d+1)(d+2)/6  =  d(d+1)(d+2)/3 .
\\
\\ Checked directly for d = 1, 2, 3: 2, 8, 20.

check5() =
{ printf("  (5) points on a curve of degree d: the count d(d+1)(d+2)/3\n");
  printf("      %-4s %-8s %-10s %-10s %-10s %s\n", "d", "N", "naive Nd", "excess", "observed", "predicted");
  for (d = 1, 3,
    my(N = binomial(d+2, 2), c = config(N, d, 20), D1 = c[4], D2 = c[5],
       ex = d*(d+1)*(d+2)/6, obs, pred = d*(d+1)*(d+2)/3);
    obs = poldegree(subst(D1, t, 1), s);
    printf("      %-4d %-8d %-10d %-10d %-10d %d%s\n", d, N, N*d, ex, obs, pred,
           if (obs == pred && D2 == (-1)^ex * t^ex * D1, "", "   MISMATCH")));
};


\\ ---------------------------------------------------------------- check 6
\\ The Pascal / Braikenridge-Maclaurin route suggested in the comments on the
\\ question.  Six points lie on a conic iff the three points
\\
\\    X = P1P2 ^ P4P5 ,   Y = P2P3 ^ P5P6 ,   Z = P3P4 ^ P6P1
\\
\\ are collinear.  Joining and meeting are both cross products, so the degrees
\\ propagate  (1,0,1) -> (1,2,1) -> (3,2,3),  and the 3x3 determinant has
\\ degree 3+2+3 = 8 with no Veronese in sight.  In fact the Pascal determinant
\\ IS the Veronese determinant: both are multihomogeneous of multidegree
\\ (2,...,2) in the six points and vanish on the same irreducible hypersurface,
\\ so they are proportional, and the constant is +-1 according to the hexagon
\\ labelling.  Checked below on the pencil AND on unstructured points of P^2.

cross(a, b) = [a[2]*b[3] - a[3]*b[2], a[3]*b[1] - a[1]*b[3], a[1]*b[2] - a[2]*b[1]];

pascal(Q, p) =
{ my(R = vector(6, i, Q[p[i]]), X, Y, Z);
  X = cross(cross(R[1],R[2]), cross(R[4],R[5]));
  Y = cross(cross(R[2],R[3]), cross(R[5],R[6]));
  Z = cross(cross(R[3],R[4]), cross(R[6],R[1]));
  matdet(Mat([X~, Y~, Z~])~);
};

\\ total degree of a form in (s,t)
tdeg(f) =
{ if (f == 0, return(-1));
  my(m = -1);
  for (i = 0, poldegree(f, s),
    my(c = polcoef(f, i, s));
    if (c != 0, m = max(m, i + poldegree(c, t))));
  m;
};
degs(V) = vector(#V, i, tdeg(V[i]));

check6() =
{ my(bad = 0, bad2 = 0, bad3 = 0, badlab = 0, badpl = 0, npl = 0, Qh, Qn);
  printf("  (6) the Pascal / Braikenridge-Maclaurin route\n");
  for (trial = 1, TRIALS,
    my(A = vector(6,i,pt(HGT)), B = vector(6,i,pt(HGT)), P, Qa, Qb, Pa, Pb, Va);
    P = vector(6, i, meet(A[i], B[i]));
    Qa = vector(6, i, [P[i][1], P[i][3]/s, P[i][4]]);
    Qb = vector(6, i, [P[i][1], P[i][2],   P[i][4]]);
    Pa = pascal(Qa, [1,2,3,4,5,6]); Pb = pascal(Qb, [1,2,3,4,5,6]);
    Va = matdet(matrix(6, 6, i, j, monos(Qa[i], 2)[j]));
    if (Pa != Va, bad++);
    if (tdeg(Pa) != 8, bad2++);
    if (Pb != t^4 * Pa, bad3++);
    for (k = 1, 3,
      my(r = pascal(Qa, Vec(numtoperm(6, random(720)))));
      if (r != Va && r != -Va, badlab++));
    if (trial == 1, Qh = Qa; Qn = Qb));
  printf("      Pascal det != Veronese det (honest chart)      : %d of %d\n", bad, TRIALS);
  printf("      Pascal det not of total degree 8               : %d\n", bad2);
  printf("      Pascal_naive != t^4 . Pascal_honest            : %d\n", bad3);
  printf("      some hexagon labelling giving other than +-Ver : %d of %d\n", badlab, 3*TRIALS);
  \\ and with no pencil structure at all: six unrelated points of P^2
  for (k = 1, 300,
    my(Q = vector(6, i, [rnd(HGT), rnd(HGT), rnd(HGT)]), V);
    V = matdet(matrix(6, 6, i, j, monos(Q[i], 2)[j]));
    if (V == 0, next);
    npl++;
    if (pascal(Q, [1,2,3,4,5,6]) != V, badpl++));
  printf("      six unrelated points of P^2: Pascal != Veronese : %d of %d\n", badpl, npl);
  printf("      degree bookkeeping, honest chart (x:q:w): %s -> %s -> %s -> %d\n",
         degs(Qh[1]), degs(cross(Qh[1],Qh[2])),
         degs(cross(cross(Qh[1],Qh[2]), cross(Qh[4],Qh[5]))), tdeg(pascal(Qh, [1,2,3,4,5,6])));
  printf("      degree bookkeeping, naive  chart (x:y:w): %s -> %s -> %s -> %d\n",
         degs(Qn[1]), degs(cross(Qn[1],Qn[2])),
         degs(cross(cross(Qn[1],Qn[2]), cross(Qn[4],Qn[5]))), tdeg(pascal(Qn, [1,2,3,4,5,6])));
};

print("======================================================================");
print("pencil-conic-count.gp -- eight planes, not twelve (MSE 5130224)");
print("");
check1(); print("");
check2(); print("");
check3(); print("");
check4(); print("");
check5(); print("");
check6(); print("");
print("======================================================================");
