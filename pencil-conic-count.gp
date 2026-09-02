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
\\ Check 7 proves the classical count that check 4 leans on: four pairwise
\\ disjoint lines in P^3 have exactly two transversals.  Check 8 is the
\\ specialisation proof of the same count, including the transversality
\\ computation that makes it rigorous.
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

\\ ---------------------------------------------------------------- check 7
\\ The classical count that check 4 leans on: four pairwise disjoint lines in
\\ P^3 have exactly two transversals.  Write V = k^4 and L_i = P(W_i).  Then
\\ L_1 ^ L_2 = 0 says V = W_1 (+) W_2, and a line disjoint from both is the
\\ graph of an isomorphism W_1 -> W_2; so L_3 = graph(phi), L_4 = graph(psi).
\\ The transversals to L_1, L_2, L_3 are exactly
\\
\\        M_p = span(p, phi(p)) ,     [p] in P(W_1) = P^1 ,
\\
\\ and M_p meets L_4 iff psi(p) is proportional to phi(p), i.e. iff p is an
\\ EIGENVECTOR of A = phi^-1 psi.  A 2x2 matrix has two: the roots of the
\\ binary quadratic form
\\
\\        q_A(X,Y) = c X^2 + (d-a) X Y - b Y^2 ,    A = [a,b ; c,d] ,
\\
\\ whose discriminant is tr(A)^2 - 4 det(A).  Everything below is that one
\\ quadratic form seen from four sides: the eigenvector count, the quadric
\\ surface through L_1, L_2, L_3, the Klein quadric in P^5, and the pencil
\\ determinant of check 4.

rline(H) = [pt(H), pt(H)];

\\ the ten symmetric 4x4 matrices, a basis for quadratic forms on P^3
symbasis() =
{ my(L = List());
  for (i = 1, 4, for (j = i, 4,
    my(E = matrix(4, 4, k, l, 0));
    E[i,j] = E[i,j] + 1; E[j,i] = E[j,i] + 1;
    listput(L, E)));
  Vec(L);
};
SYM = symbasis();
qbil(G, u, w) = u * G * w~;

\\ V = W_1 (+) W_2 from the first two lines, the last two as graphs.
\\ Returns [BAS, phi, psi]; 0 if the four lines are not pairwise disjoint.
graphs(LL) =
{ my(BAS, C, U, W, g = vector(2));
  BAS = Mat([LL[1][1]~, LL[1][2]~, LL[2][1]~, LL[2][2]~]);
  if (matdet(BAS) == 0, return(0));
  for (k = 3, 4,
    C = BAS^(-1) * Mat([LL[k][1]~, LL[k][2]~]);
    U = matrix(2, 2, i, j, C[i,j]);
    W = matrix(2, 2, i, j, C[i+2,j]);
    if (matdet(U) == 0 || matdet(W) == 0, return(0));
    g[k-2] = W * U^(-1));
  [BAS, g[1], g[2]];
};

\\ omega(p, A p), the form whose roots are the eigendirections of A
qform(A) = A[2,1]*X^2 + (A[2,2] - A[1,1])*X*Y - A[1,2]*Y^2;
bqv(f) = vector(3, k, polcoef(polcoef(f, 3-k, X), k-1, Y));
prop(f, g) =
{ my(a = bqv(f), b = bqv(g));
  matrank(matrix(2, 3, i, j, if (i == 1, a[j], b[j]))) <= 1;
};
disc(f) = my(c = bqv(f)); c[2]^2 - 4*c[1]*c[3];

\\ the transversal M_p for p = (X,Y): two points of P^3, entries linear in (X,Y)
mline(BAS, phi) =
{ my(p = [X, Y]~, q = phi * p);
  [(BAS * [p[1], p[2], 0, 0]~)~, (BAS * [0, 0, q[1], q[2]]~)~];
};
\\ M meets span(A,B) iff this 4x4 determinant vanishes
inc(M, A, B) = matdet(Mat([M[1]~, M[2]~, A~, B~]));

\\ the point w + psi(w) of graph(psi), in P^3 coordinates
grpoint(BAS, psi, w) =
{ my(q = psi * w~);
  (BAS * [w[1], w[2], q[1], q[2]]~)~;
};
grline(BAS, psi) = [grpoint(BAS, psi, [1,0]), grpoint(BAS, psi, [0,1])];

\\ the unique quadric through three pairwise disjoint lines, as a symmetric
\\ 4x4 matrix; 0 if the space of such quadrics is not one-dimensional
quadric3(LL) =
{ my(R = List(), K);
  for (i = 1, 3,
    my(A = LL[i][1], B = LL[i][2]);
    listput(R, vector(10, k, qbil(SYM[k], A, A)));
    listput(R, vector(10, k, qbil(SYM[k], A, B)));
    listput(R, vector(10, k, qbil(SYM[k], B, B))));
  K = matker(matrix(9, 10, i, j, R[i][j]));
  if (matsize(K)[2] != 1, return(0));
  sum(k = 1, 10, K[k,1] * SYM[k]);
};

\\ Pluecker coordinates (p12,p13,p14,p23,p24,p34), the Klein quadratic form,
\\ and its polarisation: two lines meet iff kpair of their Pluecker vectors is 0
PIDX = [[1,2],[1,3],[1,4],[2,3],[2,4],[3,4]];
pl(A, B) = vector(6, k, A[PIDX[k][1]]*B[PIDX[k][2]] - A[PIDX[k][2]]*B[PIDX[k][1]]);
kform(p) = p[1]*p[6] - p[2]*p[5] + p[3]*p[4];
kpair(p, q) = p[1]*q[6] - p[2]*q[5] + p[3]*q[4] + p[4]*q[3] - p[5]*q[2] + p[6]*q[1];

\\ (a) the family of transversals to L_1, L_2, L_3, and the eigenvector form
check7a() =
{ my(tot = 0, b123 = 0, bq = 0, bdisc = 0, bskew = 0);
  printf("  (7a) the transversals to L_1, L_2, L_3, and the eigenvector form\n");
  for (trial = 1, TRIALS,
    my(LL = vector(4, i, rline(HGT)), G = graphs(LL), A, qA, M, f);
    if (G == 0, bskew++; next);
    tot++;
    A = G[2]^(-1) * G[3];
    qA = qform(A);
    M = mline(G[1], G[2]);
    for (i = 1, 3, if (inc(M, LL[i][1], LL[i][2]) != 0, b123++));
    f = inc(M, LL[4][1], LL[4][2]);
    if (f == 0 || !prop(f, qA), bq++);
    if (disc(qA) != trace(A)^2 - 4*matdet(A), bdisc++));
  printf("      configurations : %d   (%d rejected as not pairwise disjoint)\n", tot, bskew);
  printf("      some M_p failing to meet L_1, L_2 or L_3 identically : %d\n", b123);
  printf("      det(M_p, L_4) not a nonzero multiple of q_A          : %d\n", bq);
  printf("      disc(q_A) != tr(A)^2 - 4 det(A)                      : %d\n", bdisc);
};

\\ (b) the unique smooth quadric through L_1, L_2, L_3, and its section by L_4
check7b() =
{ my(tot = 0, bquad = 0, brk = 0, bres = 0, bclosed = 0, bon = 0, bswp = 0);
  printf("  (7b) the quadric surface through L_1, L_2, L_3\n");
  for (trial = 1, TRIALS,
    my(LL = vector(4, i, rline(HGT)), G = graphs(LL), BAS, phi, qA, Q, M, p4, g, S, T);
    if (G == 0, next);
    tot++;
    BAS = G[1]; phi = G[2];
    qA = qform(phi^(-1) * G[3]);
    Q = quadric3(LL);
    if (Q == 0, bquad++; next);
    if (matrank(Q) != 4, brk++);
    for (i = 1, 3,
      my(A = LL[i][1], B = LL[i][2]);
      if (qbil(Q,A,A) != 0 || qbil(Q,A,B) != 0 || qbil(Q,B,B) != 0, bon++));
    M = mline(BAS, phi);
    if (qbil(Q,M[1],M[1]) != 0 || qbil(Q,M[1],M[2]) != 0 || qbil(Q,M[2],M[2]) != 0, bswp++);
    p4 = grpoint(BAS, G[3], [X, Y]);
    g = p4 * Q * p4~;
    if (g == 0 || !prop(g, qA), bres++);
    S = matrix(4, 4, i, j, 0);
    S[1,4] = phi[1,1];  S[4,1] = phi[1,1];
    S[2,4] = phi[1,2];  S[4,2] = phi[1,2];
    S[1,3] = -phi[2,1]; S[3,1] = -phi[2,1];
    S[2,3] = -phi[2,2]; S[3,2] = -phi[2,2];
    T = BAS~ * Q * BAS;
    if (matrank(matrix(2, 16, i, j,
          if (i == 1, S[(j-1)\4+1, (j-1)%4+1], T[(j-1)\4+1, (j-1)%4+1]))) != 1, bclosed++));
  printf("      configurations : %d\n", tot);
  printf("      quadrics through the three lines other than one     : %d\n", bquad);
  printf("      that quadric not of rank 4, i.e. not smooth         : %d\n", brk);
  printf("      L_1, L_2 or L_3 not lying on it                     : %d\n", bon);
  printf("      the transversal M_p not lying on it (the ruling)    : %d\n", bswp);
  printf("      its restriction to L_4 not a multiple of q_A        : %d\n", bres);
  printf("      not equal to {omega(phi u, v) = 0} in basis coords  : %d\n", bclosed);
};

\\ (c) the Klein quadric: four hyperplanes cut a line, and it meets G twice
minors3(k1, k2, PP) =
{ my(L = List());
  for (c1 = 1, 4, for (c2 = c1+1, 5, for (c3 = c2+1, 6,
    listput(L, matdet(matrix(3, 3, i, j,
      my(c = [c1,c2,c3][j]); if (i == 1, k1[c], if (i == 2, k2[c], PP[c]))))))));
  Vec(L);
};

check7c() =
{ my(tot = 0, bker = 0, bdeg = 0, bmin = 0, bzero = 0, btang = 0);
  printf("  (7c) the Klein quadric: a line in P^5 meets it twice\n");
  for (trial = 1, TRIALS,
    my(LL = vector(4, i, rline(HGT)), G = graphs(LL), qA, M, PIs, R, K, kb, M3, nz = 0);
    if (G == 0, next);
    tot++;
    qA = qform(G[2]^(-1) * G[3]);
    M = mline(G[1], G[2]);
    PIs = vector(4, i, pl(LL[i][1], LL[i][2]));
    for (i = 1, 4, if (kform(PIs[i]) != 0 || kpair(PIs[i], PIs[i]) != 0, btang++));
    R = matrix(4, 6, i, j,
      [PIs[i][6], -PIs[i][5], PIs[i][4], PIs[i][3], -PIs[i][2], PIs[i][1]][j]);
    K = matker(R);
    if (matsize(K)[2] != 2, bker++; next);
    kb = kform(X*K[,1] + Y*K[,2]);
    if (kb == 0 || poldegree(subst(kb, Y, 1), X) < 1, bdeg++);
    M3 = minors3(K[,1], K[,2], pl(M[1], M[2]));
    for (k = 1, #M3,
      if (M3[k] != 0, nz++);
      if (!prop(M3[k], qA), bmin++));
    if (nz == 0, bzero++));
  printf("      configurations : %d\n", tot);
  printf("      [L_i] not on the Klein quadric, or off its own hyperplane : %d\n", btang);
  printf("      the four hyperplanes not cutting a line in P^5            : %d\n", bker);
  printf("      the Klein form on that line not a binary quadratic        : %d\n", bdeg);
  printf("      a 3x3 minor not proportional to q_A                       : %d of %d\n", bmin, 20*tot);
  printf("      all twenty minors vanishing identically                   : %d\n", bzero);
};

check7d() =
{ my(LL, G, BAS, phi, psi, A, M, Q, L4, PIs, R);
  printf("  (7d) the two degenerate configurations\n");
  LL = vector(4, i, rline(HGT));
  G = graphs(LL); if (G == 0, printf("      degenerate draw\n"); return);
  BAS = G[1]; phi = G[2];
  \\ L_4 = graph(2 phi): the fourth line in the SAME RULING
  L4 = grline(BAS, 2*phi);
  M = mline(BAS, phi);
  Q = quadric3(LL);
  PIs = vector(4, i, if (i < 4, pl(LL[i][1], LL[i][2]), pl(L4[1], L4[2])));
  R = matrix(4, 6, i, j, [PIs[i][6], -PIs[i][5], PIs[i][4], PIs[i][3], -PIs[i][2], PIs[i][1]][j]);
  printf("      same ruling, L_4 = graph(2 phi):  q_A = %s,  every M_p meets L_4 : %d\n",
         qform(phi^(-1)*(2*phi)), inc(M, L4[1], L4[2]) == 0);
  printf("           L_4 lies on the quadric : %d;  rank of the Klein system : %d (kernel %d, a plane in P^5)\n",
         (grpoint(BAS,2*phi,[X,Y]) * Q * grpoint(BAS,2*phi,[X,Y])~) == 0, matrank(R), matsize(matker(R))[2]);
  \\ psi = phi A with A = [1,1;0,1]: a repeated eigenvalue, L_4 tangent to Q
  A = [1,1;0,1];
  L4 = grline(BAS, phi*A);
  printf("      tangency, A = [1,1;0,1]:  q_A = %s,  disc = %d\n", qform(A), disc(qform(A)));
  printf("           det(M_p, L_4) proportional to q_A : %d;  Q|_{L_4} proportional to q_A : %d\n",
         prop(inc(M, L4[1], L4[2]), qform(A)),
         prop(grpoint(BAS,phi*A,[X,Y]) * Q * grpoint(BAS,phi*A,[X,Y])~, qform(A)));
};

check7e() =
{ my(bad = 0, tot = 0);
  printf("  (7e) the pencil determinant of check 4 is the same quadratic\n");
  for (trial = 1, TRIALS,
    my(LL, G, BAS, phi, psi, A, qA, M, D, P, Qp, pb);
    LL = concat([[[1,0,0,0], [0,0,0,1]]], vector(3, i, rline(HGT)));
    G = graphs(LL); if (G == 0, next);
    tot++;
    BAS = G[1]; phi = G[2];
    A = phi^(-1) * G[3];
    qA = qform(A);
    \\ Delta: three points on the moving plane, collinear (check 4, d = 1)
    P = vector(3, i, meet(LL[i+1][1], LL[i+1][2]));
    D = matdet(matrix(3, 3, i, j, monos([P[i][1], P[i][3]/s, P[i][4]], 1)[j]));
    \\ M_p meets L = {y=z=0}, so it spans with L the plane [s:t] = [z : -y]
    \\ of any of its points off L; take the point on L_1.
    Qp = mline(BAS, phi)[2];
    pb = subst(subst(D, s, Qp[3]), t, -Qp[2]);
    if (pb == 0 || !prop(pb, qA), bad++));
  printf("      Delta pulled back along p -> plane(M_p, L) not proportional to q_A : %d of %d\n", bad, tot);
};

check7f() =
{ my(pos = 0, neg = 0, zer = 0, N = 1000);
  printf("  (7f) over the reals: two transversals, or none\n");
  for (trial = 1, N,
    my(LL = vector(4, i, rline(HGT)), G = graphs(LL), d);
    if (G == 0, next);
    d = trace(G[2]^(-1)*G[3])^2 - 4*matdet(G[2]^(-1)*G[3]);
    if (d > 0, pos++, if (d < 0, neg++, zer++)));
  printf("      of %d random integer configurations: %d with two real transversals, %d with none, %d tangent\n",
         N, pos, neg, zer);
};

\\ clear a rational 2x2 matrix to a primitive integer one; eigendirections,
\\ being the roots of omega(p, A p), are unchanged by scaling
intmat(A) =
{ my(e = concat(Vec(A[1,]), Vec(A[2,])), c);
  c = lcm(vector(4, k, denominator(e[k])));
  A = A * c;
  A / gcd(concat(Vec(A[1,]), Vec(A[2,])));
};

\\ one real and one complex example, small enough to print, verified back in
\\ P^3: at each eigendirection the line M_p really does meet all four L_i.
example7(want) =
{ my(LL, G, BAS, phi, A, qA, rts, M, mx = 0, found = 0);
  for (trial = 1, 400,
    LL = vector(4, i, rline(6));
    G = graphs(LL);
    if (G == 0, next);
    A = G[2]^(-1) * G[3];
    if (sign(trace(A)^2 - 4*matdet(A)) != want, next);
    A = intmat(A);
    if (vecmax(vector(4, k, abs(concat(Vec(A[1,]), Vec(A[2,]))[k]))) > 10^4, next);
    found = 1; break);
  if (!found, printf("      no small example found\n"); return);
  BAS = G[1]; phi = G[2];
  qA = qform(A);
  M = mline(BAS, phi);
  printf("      A = phi^-1 psi (cleared to a primitive integer matrix; eigendirections\n");
  printf("          are unchanged by scaling) = %s\n", A);
  printf("      q_A = %s,   disc = tr^2 - 4 det = %s\n", qA, disc(qA));
  rts = polroots(subst(qA, Y, 1));
  for (k = 1, #rts,
    my(x0 = rts[k], P1 = subst(subst(M[1], X, x0), Y, 1),
       P2 = subst(subst(M[2], X, x0), Y, 1), r = 0);
    for (i = 1, 4,
      my(v = abs(matdet(Mat([P1~, P2~, LL[i][1]~, LL[i][2]~]))),
         nrm = vecmax(vector(4, j, abs(P1[j]))) * vecmax(vector(4, j, abs(P2[j])))
               * vecmax(vector(4, j, abs(LL[i][1][j]))) * vecmax(vector(4, j, abs(LL[i][2][j]))));
      r = max(r, v/nrm));
    if (r > mx, mx = r);
    printf("      p = (%-26s : 1)   max relative incidence with the four L_i : %.3e\n",
           strprintf("%.8f %s %.8fi", real(x0), if (imag(x0) < 0, "-", "+"), abs(imag(x0))), r));
};

check7g() =
{ printf("  (7g) two configurations in detail, checked back in P^3\n");
  printf("      -- positive discriminant --\n");
  example7(1);
  printf("      -- negative discriminant --\n");
  example7(-1);
};

\\ ---------------------------------------------------------------- check 8
\\ The specialisation proof.  Move the four lines into the position
\\
\\     L_1 ^ L_2 = {P},  spanning a plane Pi ;
\\     L_3 ^ L_4 = {Q},  spanning a plane Sigma ,
\\
\\ with P not on Sigma and Q not on Pi.  A line meets L_1 and L_2 iff it
\\ passes through P or lies in Pi, and likewise for the other pair, so there
\\ are four cases and only two survive: the join PQ, and the line Pi ^ Sigma.
\\ Conservation of number then transports the count back to the general
\\ configuration -- provided the two special solutions are counted correctly,
\\ i.e. that the intersection is TRANSVERSE at each.  That is the step brief
\\ treatments leave out, and (8b) is it: at each of the two lines the four
\\ tangent conditions are independent on T_[M] G = Hom(W, V/W).
\\
\\ (8c) follows the Klein binary quadratic along a path from the special
\\ configuration to a general one -- conservation of number made explicit.
\\ (8d) is the warning: a specialisation with a DOUBLE solution, where the
\\ naive count reads 1 and the correct count is still 2.

\\ the plane through three points, as a linear form
plane3(P1, P2, P3) =
{ my(K = matker(matrix(3, 4, i, j, [P1,P2,P3][i][j])));
  if (matsize(K)[2] != 1, return(0));
  Vec(K[,1]);
};
\\ the point where span(A,B) meets the plane H
linehit(A, B, H) = my(a = H*A~, b = H*B~); vector(4, k, b*A[k] - a*B[k]);
\\ the line where two planes meet, as a pair of spanning points
planeline(H1, H2) =
{ my(K = matker(matrix(2, 4, i, j, [H1,H2][i][j])));
  if (matsize(K)[2] != 2, return(0));
  [Vec(K[,1]), Vec(K[,2])];
};

\\ the four incidence conditions, as a 4x6 matrix in Pluecker coordinates
kleinsys(LL) =
{ my(PIs = vector(4, i, pl(LL[i][1], LL[i][2])));
  matrix(4, 6, i, j, [PIs[i][6], -PIs[i][5], PIs[i][4], PIs[i][3], -PIs[i][2], PIs[i][1]][j]);
};
\\ [basis of the solution space, Klein form restricted to it]
transq(LL) =
{ my(K = matker(kleinsys(LL)));
  if (matsize(K)[2] != 2, return([K, 0]));
  [K, kform(X*K[,1] + Y*K[,2])];
};
\\ coordinates of a line in that basis, or 0 if it is not a solution
coords(K, N) =
{ my(c = matinverseimage(K, pl(N[1], N[2])~));
  if (type(c) != "t_COL" || #c != 2, return(0));
  Vec(c);
};
\\ is N a root of the binary quadratic?
isroot(K, kb, N) =
{ my(c = coords(K, N));
  if (c == 0, return(0));
  subst(subst(kb, X, c[1]), Y, c[2]) == 0;
};

\\ the special configuration, and the two lines it makes visible
special4(H) =
{ my(P, Q, a1, a2, b1, b2, Pi, Sig);
  P = pt(H); Q = pt(H); a1 = pt(H); a2 = pt(H); b1 = pt(H); b2 = pt(H);
  Pi = plane3(P, a1, a2); Sig = plane3(Q, b1, b2);
  if (Pi == 0 || Sig == 0, return(0));
  if (Pi*Q~ == 0 || Sig*P~ == 0, return(0));
  [[[P,a1], [P,a2], [Q,b1], [Q,b2]], [P, Q], planeline(Pi, Sig), Pi, Sig];
};

check8a() =
{ my(tot = 0, bker = 0, bdeg = 0, bdisc = 0, broot = 0, bdist = 0);
  printf("  (8a) the special position: two pairs of incident lines\n");
  for (trial = 1, TRIALS,
    my(S = special4(HGT), LL, T, K, kb, c1, c2);
    if (S == 0, next);
    tot++;
    LL = S[1]; T = transq(LL); K = T[1]; kb = T[2];
    if (matsize(K)[2] != 2, bker++; next);
    if (kb == 0 || poldegree(subst(kb, Y, 1), X) < 1, bdeg++);
    if (disc(kb) == 0, bdisc++);
    if (!isroot(K, kb, S[2]) || !isroot(K, kb, S[3]), broot++);
    c1 = coords(K, S[2]); c2 = coords(K, S[3]);
    if (c1 == 0 || c2 == 0 || c1[1]*c2[2] - c1[2]*c2[1] == 0, bdist++));
  printf("      configurations : %d\n", tot);
  printf("      the four conditions not cutting a line in P^5 : %d\n", bker);
  printf("      the Klein form on it not a binary quadratic   : %d\n", bdeg);
  printf("      that quadratic with a repeated root           : %d\n", bdisc);
  printf("      PQ or Pi ^ Sigma failing to be a root         : %d\n", broot);
  printf("      the two roots not distinct                    : %d\n", bdist);
};

\\ the four conditions on T_[M] G = Hom(W, V/W), as a 4 x 8 matrix in
\\ (phi(m_1), phi(m_2)):  d/dt det(m_1 + t u, m_2 + t v, l_1, l_2)
tangentmat(M, LL) =
{ my(m1 = M[1], m2 = M[2]);
  matrix(4, 8, i, j,
    my(l1 = LL[i][1], l2 = LL[i][2], e = vector(4, k, if (k == (j-1)%4+1, 1, 0)));
    if (j <= 4, matdet(Mat([e~, m2~, l1~, l2~])), matdet(Mat([m1~, e~, l1~, l2~]))));
};
\\ transverse iff rank 4 with Hom(W,W) -- spanned by (m_i, 0), (0, m_i) -- in
\\ the kernel; then the four forms are independent on the 4-dimensional
\\ quotient Hom(W, V/W), so the solution is a reduced point
transverse(M, LL) =
{ my(T = tangentmat(M, LL), Z = [concat(M[1], [0,0,0,0]), concat(M[2], [0,0,0,0]),
                                 concat([0,0,0,0], M[1]), concat([0,0,0,0], M[2])]);
  for (k = 1, 4, if (T * Z[k]~ != 0, return(-1)));
  matrank(T);
};

check8b() =
{ my(tot = 0, bad1 = 0, bad2 = 0);
  printf("  (8b) both special solutions are transverse, hence reduced\n");
  for (trial = 1, TRIALS,
    my(S = special4(HGT));
    if (S == 0, next);
    tot++;
    if (transverse(S[2], S[1]) != 4, bad1++);
    if (transverse(S[3], S[1]) != 4, bad2++));
  printf("      configurations : %d\n", tot);
  printf("      rank of the four tangent conditions at PQ         not 4 : %d\n", bad1);
  printf("      rank of the four tangent conditions at Pi ^ Sigma not 4 : %d\n", bad2);
  printf("      (rank 4 on a 4-dimensional tangent space = multiplicity 1)\n");
};

\\ Pluecker vector of a root, normalised, for comparison across the family
rootlines(K, kb) =
{ my(rts = polroots(subst(kb, Y, 1)));
  vector(#rts, k,
    my(v = Vec(rts[k]*K[,1] + K[,2]), m = 0, i0 = 1);
    for (i = 1, 6, if (abs(v[i]) > m, m = abs(v[i]); i0 = i));
    vector(6, i, v[i]/v[i0]));
};
sep(u, w) = vecmax(vector(6, i, abs(u[i] - w[i])));

check8c() =
{ my(S, LL0, LL1, base, tab = List());
  printf("  (8c) conservation of number along a path to a general configuration\n");
  S = 0; while (S == 0, S = special4(HGT));
  LL0 = S[1];
  LL1 = vector(4, i, rline(HGT));
  printf("      %-10s %-8s %-8s %-14s %s\n", "epsilon", "ker dim", "deg", "disc = 0?",
         "distance to the special pair");
  base = 0;
  for (k = 0, 5,
    my(ep = [0, 1/1000, 1/100, 1/8, 1/2, 1][k+1],
       LL = vector(4, i, vector(2, j, vector(4, m, LL0[i][j][m] + ep*(LL1[i][j][m] - LL0[i][j][m])))),
       T = transq(LL), K = T[1], kb = T[2], d, RL, dist = "");
    d = if (matsize(K)[2] == 2, poldegree(subst(kb, Y, 1), X), -1);
    if (matsize(K)[2] == 2 && kb != 0,
      RL = rootlines(K, kb);
      if (k == 0, base = RL; dist = "0 (the special pair)",
        dist = strprintf("%.3e", min(max(sep(RL[1], base[1]), sep(RL[2], base[2])),
                                     max(sep(RL[1], base[2]), sep(RL[2], base[1]))))));
    printf("      %-10s %-8d %-8d %-14s %s\n", ep, matsize(K)[2], d,
           if (disc(kb) == 0, "yes", "no"), dist));
  printf("      the length of the fibre never drops: two roots throughout\n");
};

check8d() =
{ my(LL, G, BAS, phi, Q, R, H, K, S, L4, T, kb, M);
  printf("  (8d) a specialisation with a double solution\n");
  G = 0;
  while (G == 0,
    LL = vector(4, i, rline(HGT));
    G = graphs(LL));
  BAS = G[1]; phi = G[2];
  Q = quadric3(LL);
  R = grpoint(BAS, 2*phi, [1, 0]);          \\ a point of Q, on none of L_1, L_2, L_3
  H = Vec(R * Q);                            \\ the tangent plane to Q at R
  K = matker(Mat(H~)~);
  S = vector(4, k, Vec(K[,1])[k] + 3*Vec(K[,2])[k] + 7*Vec(K[,3])[k]);
  L4 = [R, S];
  printf("      R on Q : %d;  L_4 = span(R,S) inside the tangent plane at R : %d\n",
         qbil(Q, R, R) == 0, H*R~ == 0 && H*S~ == 0);
  my(p = vector(4, k, X*R[k] + Y*S[k]), g = p * Q * p~, c = bqv(g));
  printf("      Q restricted to L_4, coefficients up to scale : %s   (a perfect square:\n", c/content(c));
  printf("           L_4 meets Q only at R, doubly -- it is tangent there)\n");
  T = transq(concat(vector(3, i, LL[i]), [L4])); kb = T[2];
  printf("      the Klein quadratic for L_1,L_2,L_3,L_4 : disc = %d\n", disc(kb));
  M = mline(BAS, phi);
  M = [subst(subst(M[1], X, 1), Y, 0), subst(subst(M[2], X, 1), Y, 0)];
  printf("      the ruling line through R is the double root : %d\n",
         isroot(T[1], kb, M));
  printf("      rank of the four tangent conditions there : %d  (not 4: not transverse)\n",
         transverse(M, concat(vector(3, i, LL[i]), [L4])));
  printf("      so the special fibre is ONE point of multiplicity 2, not one solution\n");
};

check8e() =
{ my(tot = 0, broot = 0, bdist = 0);
  printf("  (8e) degenerating one pair only: sigma_1^2 = sigma_2 + sigma_(1,1)\n");
  for (trial = 1, TRIALS,
    my(P = pt(HGT), a1 = pt(HGT), a2 = pt(HGT), L3 = rline(HGT), L4 = rline(HGT),
       Pi, LL, T, K, kb, N1, N2, c1, c2);
    Pi = plane3(P, a1, a2);
    if (Pi == 0, next);
    LL = [[P,a1], [P,a2], L3, L4];
    T = transq(LL); K = T[1]; kb = T[2];
    if (matsize(K)[2] != 2 || kb == 0, next);
    tot++;
    \\ through P: the two planes <P,L_3>, <P,L_4> meet in a line
    N1 = planeline(plane3(P, L3[1], L3[2]), plane3(P, L4[1], L4[2]));
    \\ inside Pi: join the two points where L_3, L_4 cross Pi
    N2 = [linehit(L3[1], L3[2], Pi), linehit(L4[1], L4[2], Pi)];
    if (!isroot(K, kb, N1) || !isroot(K, kb, N2), broot++);
    c1 = coords(K, N1); c2 = coords(K, N2);
    if (c1 == 0 || c2 == 0 || c1[1]*c2[2] - c1[2]*c2[1] == 0, bdist++));
  printf("      configurations : %d\n", tot);
  printf("      the line through P, or the line in Pi, failing to be a root : %d\n", broot);
  printf("      the two not distinct                                       : %d\n", bdist);
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
check7a(); print("");
check7b(); print("");
check7c(); print("");
check7d(); print("");
check7e(); print("");
check7f(); print("");
check7g(); print("");
check8a(); print("");
check8b(); print("");
check8c(); print("");
check8d(); print("");
check8e(); print("");
print("======================================================================");
