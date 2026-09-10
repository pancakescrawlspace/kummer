\\ pascal.gp --- computations for pascal.typ
\\
\\ Pascal's theorem: if A1..A6 lie on a conic, the three points
\\
\\    X = A1A2 ^ A4A5,   Y = A2A3 ^ A5A6,   Z = A3A4 ^ A6A1
\\
\\ are collinear.  Everything here is exact.  The conic is xz = y^2, parametrized
\\ by  t |-> (t^2 : t : 1);  the chord through the points with parameters a, b is
\\
\\    chord(a,b) = [1, -(a+b), a*b],     i.e.   x - (a+b) y + ab z = 0,
\\
\\ and chord(a,a) = [1, -2a, a^2] is the TANGENT at a -- which is why every
\\ degenerate form of the theorem below is a specialization of one identity,
\\ not a separate limiting argument.
\\
\\ Run from this directory:   gp -q pascal.gp > ../results/pascal.txt

cross(u,v) = [u[2]*v[3]-u[3]*v[2], u[3]*v[1]-u[1]*v[3], u[1]*v[2]-u[2]*v[1]];
chord(a,b) = [1, -(a+b), a*b];
det3(A,B,C) = matdet(matrix(3,3,i,j, [A,B,C][i][j]));
norml(v) = my(w = v); for(i=1,3, if(w[i] != 0, return(w/w[i]))); w;

\\ the three Pascal points of the hexagon with parameters u = [t1..t6]
{ pasc(u) = my(s = vector(6, i, chord(u[i], u[i%6+1])));
            [cross(s[1],s[4]), cross(s[2],s[5]), cross(s[3],s[6])]; }

bar() = print("=========================================================================");

bar();
print(" Pascal's theorem: one polynomial identity, and what it specializes to");
bar();
print("");

\\ ------------------------------------------------------- (1) the identity
print("(1) THE IDENTITY, IN Z[t1,...,t6].");
print("");
V = pasc([t1,t2,t3,t4,t5,t6]);
print("    X = A1A2 ^ A4A5 = ", V[1]);
print("    Y = A2A3 ^ A5A6 = ", V[2]);
print("    Z = A3A4 ^ A6A1 = ", V[3]);
print("");
D = det3(V[1], V[2], V[3]);
print("    det[X;Y;Z] = ", D, "     identically zero: ", D == 0);
print("");
print("    So the three points are collinear for EVERY choice of the six");
print("    parameters, over any field: no genericity hypothesis is needed for");
print("    the identity itself, only for the points to be distinct.");
print("");

\\ --------------------------------------------------- (2) the degenerations
print("(2) DEGENERATIONS, AS SPECIALIZATIONS OF THAT ONE IDENTITY.");
print("");
print("    chord(a,a) is the tangent at a, so letting parameters collide turns");
print("    sides into tangents.  Each line below is the same identity, evaluated.");
print("");
{ tests = [["pentagon   (t6 = t1: side A6A1 -> tangent at A1)      ", [t1,t2,t3,t4,t5,t1]],
           ["quadrilateral (t6 = t1, t3 = t2: two tangents)        ", [t1,t2,t2,t4,t5,t1]],
           ["triangle   (t6=t1, t3=t2, t5=t4: three tangents)      ", [t1,t2,t2,t4,t4,t1]],
           ["all six equal (everything degenerates)                ", [t1,t1,t1,t1,t1,t1]]];
  for(i = 1, #tests,
    my(W = pasc(tests[i][2]));
    print("    ", tests[i][1], " det = ", det3(W[1],W[2],W[3]))); }
print("");
print("    The pentagon case reads: for A1..A5 on a conic, the points");
print("      A1A2 ^ A4A5,   A2A3 ^ A5A1,   A3A4 ^ (tangent at A1)");
print("    are collinear.  The triangle case is the classical statement that a");
print("    triangle inscribed in a conic is in perspective with the triangle of");
print("    tangents at its vertices.");
print("");

\\ --------------------------------------------------------- (3) Pappus
print("(3) PAPPUS = PASCAL FOR A DEGENERATE CONIC (two lines).");
print("");
print("    A1,A3,A5 on the line y = 0 and A2,A4,A6 on x = 0, symbolically:");
{ P = [[a1,0,1], [0,b1,1], [a2,0,1], [0,b2,1], [a3,0,1], [0,b3,1]];
  my(s = vector(6, i, cross(P[i], P[i%6+1])));
  my(X = cross(s[1],s[4]), Y = cross(s[2],s[5]), Z = cross(s[3],s[6]));
  print("      X = ", X);
  print("      det[X;Y;Z] = ", det3(X,Y,Z), "    identically zero: ",
        det3(X,Y,Z) == 0); }
print("");

\\ ------------------------------------------- (4) the configurations drawn
print("(4) THE CONFIGURATIONS IN THE FIGURES  (exact rational points).");
print("");
print("    The ellipse x^2/(17/5)^2 + y^2/(11/5)^2 = 1 is parametrized rationally");
print("    by  s |-> ( a(1-s^2)/(1+s^2), 2bs/(1+s^2) ),  a = 17/5, b = 11/5, so");
print("    the drawn points and their three Pascal points are exact rationals and");
print("    the collinearity determinant below is exactly 0, not merely small.");
print("");
ell(s) = my(a = 17/5, b = 11/5, d = 1+s^2); [a*(1-s^2)/d, b*2*s/d];
lin2(p,q) = cross([p[1],p[2],1], [q[1],q[2],1]);
mt(l,m) = my(w = cross(l,m)); if(w[3] == 0, [], [w[1]/w[3], w[2]/w[3]]);
{ S = [-13/4, 3, 0, 1/3, 3/2, -1/2];
  my(A = vector(6, i, ell(S[i])));
  my(sd = vector(6, i, lin2(A[i], A[i%6+1])));
  my(X = mt(sd[1],sd[4]), Y = mt(sd[2],sd[5]), Z = mt(sd[3],sd[6]));
  print("    figure 1 and 2, hexagon parameters s = ", S);
  for(i = 1, 6, print("      A", i, " = ", A[i]));
  print("      X  = ", X);
  print("      Y  = ", Y);
  print("      Z  = ", Z);
  print("      collinearity determinant = ",
        det3(concat(X,[1]), concat(Y,[1]), concat(Z,[1]))); }
print("");
{ S = [-1/2, 3, 0, 3/4, 4/3];
  my(A = vector(5, i, ell(S[i])), a = 17/5, b = 11/5);
  my(tg = [A[1][1]/a^2, A[1][2]/b^2, -1]);
  my(X = mt(lin2(A[1],A[2]), lin2(A[4],A[5])),
     Y = mt(lin2(A[2],A[3]), lin2(A[5],A[1])),
     Z = mt(lin2(A[3],A[4]), tg));
  print("    figure 3, pentagon parameters s = ", S, "  (tangent at A1)");
  for(i = 1, 5, print("      A", i, " = ", A[i]));
  print("      X  = ", X, "   Y = ", Y, "   Z = ", Z);
  print("      collinearity determinant = ",
        det3(concat(X,[1]), concat(Y,[1]), concat(Z,[1]))); }
print("");
{ A = [[-4, 21/20], [-4, -1/4], [-2, 23/20], [-2, -3/4], [1, 13/10], [4, -9/4]];
  my(sd = vector(6, i, lin2(A[i], A[i%6+1])));
  my(X = mt(sd[1],sd[4]), Y = mt(sd[2],sd[5]), Z = mt(sd[3],sd[6]));
  print("    figure 4, Pappus: A1,A3,A5 on one line, A2,A4,A6 on another");
  for(i = 1, 6, print("      A", i, " = ", A[i]));
  print("      X  = ", X, "   Y = ", Y, "   Z = ", Z);
  print("      A1,A3,A5 collinear: ",
        det3(concat(A[1],[1]), concat(A[3],[1]), concat(A[5],[1])) == 0,
        "     A2,A4,A6 collinear: ",
        det3(concat(A[2],[1]), concat(A[4],[1]), concat(A[6],[1])) == 0);
  print("      collinearity determinant = ",
        det3(concat(X,[1]), concat(Y,[1]), concat(Z,[1]))); }
print("");

\\ ----------------------------------------- (5) the synthetic proof, checked
print("(5) THE SYNTHETIC PROOF OF SECTION 5 OF THE NOTE, STEP BY STEP.");
print("");
print("    (S1) The pencil of lines at the point with parameter u is");
print("         chord(u,t) = [1,-u,0] + t*[0,-1,u],  affine-linear in t, hence a");
print("         projective parametrization of the pencil by t.  Difference:");
{ print("           chord(u,t) - ([1,-u,0] + t*[0,-1,u]) = ",
        chord(u,t) - ([1,-u,0] + t*[0,-1,u])); }
print("         So the cross-ratio of four such lines is that of the four");
print("         parameters, INDEPENDENT of u: that is Chasles' theorem, and it is");
print("         what makes the two pencils correspond projectively.");
print("");
pt3(t) = [t^2, t, 1];
{ my(X = cross(chord(t1,t2), chord(t4,t5)),
     Y = cross(chord(t2,t3), chord(t5,t6)),
     Z = cross(chord(t3,t4), chord(t6,t1)),
     U = cross(chord(t6,t1), chord(t4,t5)),
     V = cross(chord(t3,t4), chord(t5,t6)));
  my(j1 = cross(X,Y), j2 = cross(pt3(t4), V), j3 = cross(U, pt3(t6)));
  print("    The projectivity m -> p sends  X|->Y,  A4|->V,  A5|->A5,  U|->A6,");
  print("    so by (S2) the three joins are concurrent.  Symbolically:");
  print("      join(A4,V) is the line A3A4      : ", cross(j2, chord(t3,t4)) == [0,0,0]);
  print("      join(U,A6) is the line A6A1      : ", cross(j3, chord(t6,t1)) == [0,0,0]);
  print("      the three joins are concurrent   : ", det3(j1,j2,j3) == 0);
  print("      and their common point is Z      : ", cross(cross(j2,j3), Z) == [0,0,0]);
  print("    The last two lines are the theorem: the centre of the perspectivity is");
  print("    Z = A3A4 ^ A6A1, and the join of X and Y passes through it."); }
print("");
{ S = [-7/3, 3/2, 0, -1/3, 7/2, 1/3];
  my(A = vector(6, i, ell(S[i])));
  my(sd = vector(6, i, lin2(A[i], A[i%6+1])));
  my(X = mt(sd[1],sd[4]), Y = mt(sd[2],sd[5]), Z = mt(sd[3],sd[6]));
  my(U = mt(lin2(A[1],A[6]), lin2(A[4],A[5])),
     V = mt(lin2(A[3],A[4]), lin2(A[5],A[6])));
  print("    The configuration drawn in the figure, exactly:");
  for(i = 1, 6, print("      A", i, " = ", A[i]));
  print("      X = ", X, "   Y = ", Y, "   Z = ", Z);
  print("      U = A1A6 ^ A4A5 = ", U);
  print("      V = A3A4 ^ A5A6 = ", V);
  my(cl(P,Q,R) = det3(concat(P,[1]), concat(Q,[1]), concat(R,[1])) == 0);
  print("      X, Y, Z collinear   : ", cl(X,Y,Z));
  print("      A4, V, Z collinear  : ", cl(A[4],V,Z));
  print("      U, A6, Z collinear  : ", cl(U,A[6],Z));
  print("      -- the three joins of corresponding points all pass through Z."); }
print("");

\\ ------------------------------------------- (6) the hexagrammum mysticum
print("(6) THE HEXAGRAMMUM MYSTICUM.");
print("");
print("    Six points carry 6!/(6*2) = 60 hexagons, hence 60 Pascal lines.");
print("    Taking t = [1/2, -3, 5/3, -1/4, 4, -2/5] on the conic xz = y^2:");
print("");
{ T = [1/2, -3, 5/3, -1/4, 4, -2/5];
  my(lines = List(), bad = 0);
  for(k = 1, 120,
    my(p = numtoperm(5, k-1), o, W);
    o = concat([1], vector(5, i, p[i]+1));
    if(o[2] > o[6], next);                       \\ discard the reflected copy
    W = pasc(vector(6, i, T[o[i]]));
    if(det3(W[1],W[2],W[3]) != 0, bad++);
    listput(lines, norml(cross(W[1], W[2]))));
  print("      hexagons                     : ", #lines);
  print("      with non-collinear triple    : ", bad);
  print("      distinct Pascal lines        : ", #Set(Vec(lines)));
  my(L = Vec(Set(Vec(lines))), pts = List());
  for(i = 1, #L, for(j = i+1, #L,
    my(Q = cross(L[i], L[j])); if(Q != [0,0,0], listput(pts, norml(Q)))));
  my(S = Set(Vec(pts)), cnt = vector(#S), quad = List(), tri = 0);
  for(i = 1, #pts, cnt[setsearch(S, pts[i])]++);
  my(simple = 0);
  for(i = 1, #S,
    if(cnt[i] == 1, simple++);
    if(cnt[i] == 3, tri++);
    if(cnt[i] == 6, listput(quad, S[i])));
  print("      crossings of exactly 2 lines : ", simple);
  print("      points on exactly 3 lines    : ", tri,
        "    (classically 20 Steiner + 60 Kirkman)");
  print("      points on exactly 4 lines    : ", #quad);
  print("      check  ", simple, " + 3*", tri, " + 6*", #quad, " = ",
        simple + 3*tri + 6*#quad, " = binomial(60,2) = ", binomial(60,2));
  \\ the 4-fold points are the diagonal points of the six-point configuration
  my(diag = List());
  forvec(v = [[1,6],[1,6],[1,6],[1,6]],
    if(v[1]<v[2] && v[3]<v[4] && v[1]<v[3] && #Set(v)==4,
       listput(diag, norml(cross(chord(T[v[1]],T[v[2]]), chord(T[v[3]],T[v[4]]))))));
  print("      pairs of disjoint chords     : ", #Set(Vec(diag)));
  print("      those ARE the 4-fold points  : ", Set(Vec(quad)) == Set(Vec(diag))); }
print("");
bar();
print(" done.");
bar();
