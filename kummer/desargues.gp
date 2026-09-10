\\ desargues.gp --- computations for desargues.typ
\\
\\ Desargues' theorem: if the lines AA', BB', CC' meet in a point O, then
\\
\\    X = AB ^ A'B',   Y = BC ^ B'C',   Z = CA ^ C'A'
\\
\\ are collinear.  Everything here is exact.  The whole proof is the identity
\\
\\    (a - b) + (b - c) + (c - a) = 0
\\
\\ once the representative vectors have been normalised so that a' = a - o,
\\ b' = b - o, c' = c - o; sections (1) and (2) are that sentence, symbolically
\\ and then on a rational configuration.  Section (5) redoes it over Hamilton's
\\ quaternions, where Desargues survives and Pappus does not, and section (6)
\\ exhibits a plane -- Moulton's -- where Desargues itself fails.
\\
\\ ("O" is PARI's big-oh, so the points are called vO, vA, ... throughout.)
\\
\\ Run from this directory:   gp -q desargues.gp > ../results/desargues.txt

cross(u,v) = [u[2]*v[3]-u[3]*v[2], u[3]*v[1]-u[1]*v[3], u[1]*v[2]-u[2]*v[1]];
det3(P,Q,R) = matdet(matrix(3,3,i,j, [P,Q,R][i][j]));
norml(v) = my(w = v); for(i=1,3, if(w[i] != 0, return(w/w[i]))); w;
coll(P,Q,R) = det3(P,Q,R) == 0;
meet(P,Q,R,S) = cross(cross(P,Q), cross(R,S));
aff(P) = [P[1]/P[3], P[2]/P[3]];
hom(p) = [p[1], p[2], 1];
fmt(x) = strprintf("%.5f", x*1.0);
pt2(p) = Str("(", fmt(p[1]), ", ", fmt(p[2]), ")");

bar() = print("=========================================================================");
sec(s) = print(""); bar(); print(" ", s); bar(); print("");

bar();
print(" Desargues' theorem: the identity, the figure, the converse,");
print(" the 10_3 configuration, and two planes -- one where it survives");
print(" without commutativity, one where it fails outright");
bar();

\\ ------------------------------------------------- (1) the symbolic identity
sec("(1) THE IDENTITY, IN Z[o1,o2,o3, a1,...,c3].");
print("    Take representatives o, a, b, c for O, A, B, C.  A' lies on the line");
print("    OA, so a' = lambda a + mu o with lambda, mu nonzero; rescaling a and");
print("    a' we may assume a' = a - o, and likewise b' = b - o, c' = c - o.");
print("    That normalisation is the entire content of the proof:");
print("");
vO = [o1,o2,o3]; vA = [a1,a2,a3]; vB = [b1,b2,b3]; vC = [c1,c2,c3];
vAp = vA - vO; vBp = vB - vO; vCp = vC - vO;
print("      a' - b'  =  ", vAp - vBp, "   =  a - b");
print("");
print("    so the vector a - b represents a point of AB and a point of A'B' at");
print("    once, which is to say it represents X.  Likewise Y = [b - c] and");
print("    Z = [c - a], and the three add up to zero, so they are dependent:");
print("");
vX = vA - vB; vY = vB - vC; vZ = vC - vA;
print("      X + Y + Z        =  ", vX + vY + vZ);
{ print("      det[X; Y; Z]     =  ", det3(vX,vY,vZ), "        identically zero: ", det3(vX,vY,vZ) == 0); }
print("");
print("    and the two incidences that make X the meet of AB and A'B':");
print("      det[a;  b;  X]   =  ", det3(vA, vB, vX));
print("      det[a'; b'; X]   =  ", det3(vAp, vBp, vX));
print("");
print("    No genericity is needed for the identity itself; the hypotheses");
print("    (distinct points, honest triangles) enter only to make the three");
print("    vectors nonzero, so that they name actual points.  Note that nothing");
print("    was ever commuted -- see section (5).");

\\ ------------------------------------------------------------ (2) the figure
sec("(2) THE FIGURE OF SECTION 1, EXACTLY.");
fO = [-301/100, 148/100];
fA = [-15/100, -269/100]; fB = [261/100, -149/100]; fC = [124/100, 203/100];
tA = 69/100; tB = 55/100; tC = 36/100;
fAp = fO + tA*(fA - fO); fBp = fO + tB*(fB - fO); fCp = fO + tC*(fC - fO);
hO = hom(fO); hA = hom(fA); hB = hom(fB); hC = hom(fC);
hAp = hom(fAp); hBp = hom(fBp); hCp = hom(fCp);
hX = meet(hA,hB, hAp,hBp);
hY = meet(hB,hC, hBp,hCp);
hZ = meet(hC,hA, hCp,hAp);
print("    A' = O + (69/100)(A - O),  B' = O + (55/100)(B - O),");
print("    C' = O + (36/100)(C - O), so AA', BB', CC' concur at O by construction.");
print("");
print("      O  = ", pt2(fO));
print("      A  = ", pt2(fA),  "     A' = ", pt2(fAp));
print("      B  = ", pt2(fB),  "     B' = ", pt2(fBp));
print("      C  = ", pt2(fC),  "     C' = ", pt2(fCp));
print("      X  = AB ^ A'B'  = ", pt2(aff(hX)), "   exactly ", aff(hX));
print("      Y  = BC ^ B'C'  = ", pt2(aff(hY)), "   exactly ", aff(hY));
print("      Z  = CA ^ C'A'  = ", pt2(aff(hZ)), "   exactly ", aff(hZ));
print("");
print("    perspective from the point O:");
{ print("      det[O;A;A'] = ", det3(hO,hA,hAp), "   det[O;B;B'] = ", det3(hO,hB,hBp), "   det[O;C;C'] = ", det3(hO,hC,hCp)); }
print("    perspective from a line:");
print("      det[X;Y;Z]  = ", det3(hX,hY,hZ), "        collinear: ", coll(hX,hY,hZ));
print("      the axis is [l1:l2:l3] = ", norml(cross(hX,hY)));
print("");
print("    Order along the axis is X, Z, Y; all ten points lie in the box");
print("    [-3.6, 3.8] x [-4.5, 2.1], which is what the figure draws.");

\\ --------------------------------------------- (2b) the same theorem in space
sec("(2b) THE SPATIAL CASE, EXACTLY -- AND THE FIGURE FOR IT.");
print("    Two planes of P^3 meet in a line.  Put");
print("      pi  = {z = 0},   pi' = {y = 0},   l = pi ^ pi' = the x-axis,");
print("    the triangle ABC in pi and A'B'C' in pi'.  If O, A, A' are collinear");
print("    then AB and A'B' lie in the single plane OAB, so they MEET; the meet");
print("    lies in pi and in pi', hence on l.  Three times over, and the axis is");
print("    forced -- no computation at all.  Here it is anyway.");
print("");
kO = [9/10, -12/10, 2]; kA = [25/10, 28/10, 0]; kB = [38/10, -33/10, 0]; kC = [-44/10, 7/10, 0];
\\ A' = the point where the line OA crosses pi' = {y = 0}
onpi(P, Q) = my(t = P[2]/(P[2] - Q[2])); P + t*(Q - P);
kAp = onpi(kO, kA); kBp = onpi(kO, kB); kCp = onpi(kO, kC);
\\ X = the point where the line AB crosses l, computed inside pi
onl(P, Q) = my(t = P[2]/(P[2] - Q[2])); P + t*(Q - P);
kX = onl(kA, kB); kY = onl(kB, kC); kZ = onl(kC, kA);
lin3(P,Q,R) = cross(Q - P, R - P) == [0,0,0];
{ print("      O  = ", kO);
  print("      A  = ", kA, "   A' = ", kAp);
  print("      B  = ", kB, "   B' = ", kBp);
  print("      C  = ", kC, "   C' = ", kCp); }
{ print("      A, B, C lie in pi (z = 0)    : ", kA[3] == 0 && kB[3] == 0 && kC[3] == 0);
  print("      A', B', C' lie in pi' (y = 0): ", kAp[2] == 0 && kBp[2] == 0 && kCp[2] == 0);
  print("      the two planes are distinct, so pi ^ pi' is the single line l."); }
{ print("      perspective from O: ", lin3(kO,kA,kAp) && lin3(kO,kB,kBp) && lin3(kO,kC,kCp)); }
print("");
{ print("      X = AB ^ l = ", kX, "   on A'B' too: ", lin3(kAp, kBp, kX));
  print("      Y = BC ^ l = ", kY, "   on B'C' too: ", lin3(kBp, kCp, kY));
  print("      Z = CA ^ l = ", kZ, "   on C'A' too: ", lin3(kCp, kAp, kZ)); }
print("");
print("    All three sit on l = {y = z = 0} by construction, and each is a point");
print("    of the corresponding primed side as well -- which is the theorem.");
print("");
print("    The figure projects along (x,y,z) |-> (x + 3y/5 - 3z/5, 3y/5 + 7z/5),");
print("    which flattens l onto the horizontal axis and tilts the two planes");
print("    away from it in opposite directions:");
prj(P) = [P[1] + 3*P[2]/5 - 3*P[3]/5, 3*P[2]/5 + 7*P[3]/5];
{ my(nm = ["O ","A ","B ","C ","A'","B'","C'","X ","Y ","Z "],
     pt = [kO, kA, kB, kC, kAp, kBp, kCp, kX, kY, kZ]);
  for(i = 1, 10, print("      ", nm[i], "  ", pt2(prj(pt[i])))); }

\\ ------------------------------------------------------- (3) the converse
sec("(3) THE CONVERSE IS THE THEOREM, RELABELLED.");
print("    The converse asks: if X, Y, Z are collinear, do AA', BB', CC' concur?");
print("    It needs no new proof.  Apply the forward theorem to the triangles");
print("");
print("        A A' Z    and    B B' Y,");
print("");
print("    which are perspective from X, because the three lines joining");
print("    corresponding vertices are AB, A'B' and the axis ZY -- and those");
print("    three do pass through X:");
{ print("      X on AB   : ", coll(hX,hA,hB), "     X on A'B' : ", coll(hX,hAp,hBp),
        "     X on ZY : ", coll(hX,hZ,hY)); }
print("");
print("    The forward theorem then puts the three points");
print("      AA' ^ BB',    A'Z ^ B'Y,    ZA ^ YB");
print("    on a line.  But the last two are C' and C:");
{ my(u = meet(hAp,hZ, hBp,hY), v = meet(hZ,hA, hY,hB), w = meet(hA,hAp, hB,hBp));
  print("      A'Z ^ B'Y  = ", pt2(aff(u)), "   equals C' : ", norml(u) == norml(hCp));
  print("      ZA  ^ YB   = ", pt2(aff(v)), "   equals C  : ", norml(v) == norml(hC));
  print("      AA' ^ BB'  = ", pt2(aff(w)), "   equals O  : ", norml(w) == norml(hO));
  print("");
  print("    so O, C, C' are collinear -- which is the concurrence asked for:");
  print("      det[AA'^BB'; C; C'] = ", det3(w, hC, hCp)); }
print("");
print("    Section (4) explains why this relabelling exists at all.");

\\ ------------------------------- (4) the configuration from 5 points in P^3
sec("(4) TEN POINTS, TEN LINES: FIVE POINTS OF P^3 CUT BY A PLANE.");
print("    Take P1,...,P5 in general position in P^3, and a plane H meeting none");
print("    of them.  The 10 lines PiPj cut H in 10 points p_ij, and the 10 planes");
print("    PiPjPk cut H in 10 lines l_ijk.  Then");
print("");
print("        p_ij lies on l_klm   <=>   {i,j} is contained in {k,l,m},");
print("");
print("    because a line lies in a plane exactly when it is spanned inside it.");
print("    So the incidences are pure combinatorics of subsets of {1,...,5}.");
print("");
P5 = [[1,0,0,0], [0,1,0,0], [0,0,1,0], [0,0,0,1], [1,1,1,1]];
hh = [1, 2, 3, -7];                      \\ the plane H: sum hh[i] x_i = 0
dot4(u,v) = sum(i = 1, 4, u[i]*v[i]);
\\ H has basis (2,-1,0,0), (3,0,-1,0), (-7,0,0,-1); on H the last three
\\ coordinates are free, so v |-> [v2,v3,v4] is a linear chart H --> A^3.
chart(v) = [v[2], v[3], v[4]];
{ print("    P5 = ", P5, ",   H = {", hh[1], "x1 + ", hh[2], "x2 + ", hh[3],
        "x3 - ", -hh[4], "x4 = 0}"); }
{ print("    h.Pi = ", vector(5, i, dot4(hh, P5[i])), " -- none zero, so H misses every Pi."); }
print("");
\\ p_ij = (h.Pj) Pi - (h.Pi) Pj  lies on H and on the line PiPj
pij(i,j) = chart(dot4(hh,P5[j])*P5[i] - dot4(hh,P5[i])*P5[j]);
prs = List(); for(i = 1, 5, for(j = i+1, 5, listput(prs, [i,j])));
prs = Vec(prs);
tri = List(); for(i = 1, 5, for(j = i+1, 5, for(k = j+1, 5, listput(tri, [i,j,k]))));
tri = Vec(tri);
PT = vector(10, n, pij(prs[n][1], prs[n][2]));
\\ l_ijk is the line through p_ij, p_ik, p_jk
LN = vector(10, n, my(t = tri[n]); cross(pij(t[1],t[2]), pij(t[1],t[3])));
print("    the ten points p_ij in the chart:");
{ for(n = 1, 10, print("      p_", prs[n][1], prs[n][2], " = ", norml(PT[n]))); }
print("");
print("    the ten lines l_ijk (as [l1:l2:l3]):");
{ for(n = 1, 10, print("      l_", tri[n][1], tri[n][2], tri[n][3], " = ", norml(LN[n]))); }
print("");
{ my(bad = 0, deg = 0, cnt = 0);
  for(n = 1, 10, if(!coll(pij(tri[n][1],tri[n][2]), pij(tri[n][1],tri[n][3]),
                          pij(tri[n][2],tri[n][3])), deg++));
  print("    the three points of each triple really are collinear: ", deg == 0);
  print("    the ten points are distinct: ", #Set(vector(10, n, norml(PT[n]))) == 10);
  print("    the ten lines  are distinct: ", #Set(vector(10, n, norml(LN[n]))) == 10);
  for(a = 1, 10, for(b = 1, 10,
    my(inc = sum(i = 1, 3, sum(j = 1, 2, prs[a][j] == tri[b][i])) == 2,
       geo = (sum(i = 1, 3, LN[b][i]*PT[a][i]) == 0));
    if(inc != geo, bad++); if(geo, cnt++)));
  print("    incidence = containment, in all 100 cases: ", bad == 0);
  print("    total incidences: ", cnt, "  = 10 points x 3 lines = 10 lines x 3 points"); }
print("");
print("    An aside on symmetry.  The 120 automorphisms are combinatorial, and most");
print("    of them cannot be drawn: the configuration has NO realisation in the real");
print("    plane with a 5-fold rotation.  A rotation of order 5 permutes the labels");
print("    as a 5-cycle, so after relabelling it is i |-> i+1, and the two point");
print("    orbits are the adjacent pairs {k,k+1} and the skip pairs {k,k+2} -- each");
print("    a regular pentagon, say at radius 1 and angles 72k, and at radius r and");
print("    angles 72k + b.  The line {0,1,2} forces  r cos(b - 36) = cos 36, and the");
print("    line {0,1,3} forces  cos(144 + b) = r cos 72.  Eliminating r:");
print("");
print("       cos(144 + b) cos(b - 36) = cos 36 cos 72,");
print("");
print("    whose left side is (cos(2b + 108) - 1)/2.  So cos(2b + 108) would have to");
print("    equal 1 + 2 cos 36 cos 72, and that number is exactly 3/2:");
{ my(t = quadgen(20), c36 = (1 + t)/4, c72 = (t - 1)/4);
  print("      sqrt(5) = ", t, ",  cos 36 = ", c36, ",  cos 72 = ", c72);
  print("      cos 36 cos 72        = ", c36*c72, "        (exactly 1/4: ", c36*c72 == 1/4, ")");
  print("      1 + 2 cos 36 cos 72  = ", 1 + 2*c36*c72, "        no cosine takes that value.");
  print("      so there is no such b, and no 5-fold symmetric drawing."); }
print("");
print("    One more reading of the same combinatorics.  Join two of the ten points");
print("    when they do NOT share a line.  Since p_ij and p_kl share a line exactly");
print("    when {i,j} and {k,l} meet, that graph joins DISJOINT pairs -- which is");
print("    the Petersen graph, and it is what the Levi graph of the configuration");
print("    double-covers:");
{ my(deg = vector(10), edges = 0, g5 = 0, adj = matrix(10,10));
  for(a = 1, 10, for(b = a+1, 10,
    my(shared = #setintersect(Set(prs[a]), Set(prs[b])));
    if(shared == 0,
       edges++; deg[a]++; deg[b]++; adj[a,b] = 1; adj[b,a] = 1)));
  print("      vertices ", 10, ", edges ", edges, ", every degree 3: ",
        vecmin(deg) == 3 && vecmax(deg) == 3);
  \\ girth 5: no triangles, no quadrilaterals
  my(A2 = adj^2, A3 = adj^3, tri = 0, sq = 0);
  for(i = 1, 10, tri += A3[i,i]);
  for(i = 1, 10, for(j = 1, 10, if(i != j && adj[i,j] == 0, sq += binomial(A2[i,j], 2))));
  print("      triangles: ", tri/6, "     4-cycles: ", sq/4,
        "     so the girth is 5: ", tri == 0 && sq == 0);
  print("      (3-regular, 10 vertices, girth 5 -- that pins it down to Petersen,");
  print("      whose automorphism group is the same S5 acting on {1,...,5}.)"); }
print("");
print("    So the figure is the configuration 10_3, and it carries an action of");
print("    S5 (order 120) permuting the labels.  Reading Desargues out of it:");
print("    take any p_ij as the centre O.  The three lines through it are the");
print("    l_ijm, m not in {i,j}; the six remaining points off those lines split");
print("    into the two triangles, and the axis is l_klm, {k,l,m} the complement");
print("    of {i,j}.  Ten points, so ten readings of the theorem in one figure.");
print("");
print("    In section (2)'s labelling:  O = p_45,  and");
print("      A = p_14, B = p_24, C = p_34,   A' = p_15, B' = p_25, C' = p_35,");
print("      X = p_12, Y = p_23, Z = p_13,   axis = l_123 = complement of {4,5}.");
print("    The relabelling of section (3) was: read the theorem at the centre");
print("    p_12 = X instead, whose axis l_345 is the line OCC'.");
print("");
print("    Self-duality: {i,j} |-> complement {i,j}^c sends points to lines and");
print("    reverses containment, so it is a duality of the configuration --");
print("    and it exchanges the centre p_45 with the axis l_123.  That is the");
print("    converse of section (3) again, seen a third way.");
{ my(bad = 0);
  for(a = 1, 10, for(b = 1, 10,
    my(inc = sum(i = 1, 3, sum(j = 1, 2, prs[a][j] == tri[b][i])) == 2,
       ca = select(x -> !setsearch(Set(prs[a]), x), [1,2,3,4,5]),
       cb = select(x -> !setsearch(Set(tri[b]), x), [1,2,3,4,5]),
       dual = sum(i = 1, 3, sum(j = 1, 2, cb[j] == ca[i])) == 2);
    if(inc != dual, bad++)));
  print("      complementation reverses every incidence: ", bad == 0); }

\\ ------------------------------ (5) over Hamilton's quaternions: D yes, P no
sec("(5) A NONCOMMUTATIVE PLANE: DESARGUES SURVIVES, PAPPUS DOES NOT.");
print("    The proof of section (1) never multiplied two scalars in the wrong");
print("    order, so it runs over any division ring D, with P^2(D) the right");
print("    D-lines in D^3.  Pappus' theorem does not: it is equivalent to");
print("    commutativity.  Here is the difference, exactly, over H = Q<i,j,k>.");
print("");
print("    H is embedded in M_2(C) by  q0+q1 i+q2 j+q3 k  |-->");
print("        [q0 + q1 I ,  q2 + q3 I ;  -q2 + q3 I ,  q0 - q1 I],");
print("    so a point of P^2(H) -- a right H-line in H^3 -- becomes the column");
print("    span of a 6x2 complex matrix, a line of P^2(H) the span of a 6x4 one,");
print("    and three points are collinear exactly when the 6x6 matrix they");
print("    build has rank at most 4.  All arithmetic below is in Q(I).");
print("");
qm(p,q) = [p[1]*q[1] - p[2]*q[2] - p[3]*q[3] - p[4]*q[4], p[1]*q[2] + p[2]*q[1] + p[3]*q[4] - p[4]*q[3], p[1]*q[3] - p[2]*q[4] + p[3]*q[1] + p[4]*q[2], p[1]*q[4] + p[2]*q[3] - p[3]*q[2] + p[4]*q[1]];
qmat(q) = [q[1] + q[2]*I, q[3] + q[4]*I; -q[3] + q[4]*I, q[1] - q[2]*I];
\\ a point u in H^3 as a 6x2 complex matrix; right scalars act on the right
hpt(u) = matconcat([qmat(u[1]); qmat(u[2]); qmat(u[3])]);
hline(u,v) = matconcat([hpt(u), hpt(v)]);
hcoll(u,v,w) = matrank(matconcat([hpt(u), hpt(v), hpt(w)])) <= 4;
hsame(u,v) = matrank(matconcat([hpt(u), hpt(v)])) == 2;
\\ scale a point on the right by a quaternion, and add points coordinatewise
hsc(u,s) = vector(3, i, qm(u[i], s));
hadd(u,v) = vector(3, i, u[i] + v[i]);
\\ the meet of the lines uv and u'v', as a point of P^2(H)
{ hmeet(u,v,up,vp) =
    my(L = hline(u,v), M = hline(up,vp), K = matker(matconcat([L, -M])), c, w);
    if(matsize(K)[2] != 2, error("lines do not meet in a point"));
    c = K[,1]; w = L * c[1..4];            \\ a 6x1 vector in both column spans
    \\ read the 6x1 complex vector back as a quaternion triple via its blocks
    vector(3, i, my(z1 = w[2*i-1], z2 = w[2*i]);
      [real(z1), imag(z1), -real(z2), imag(z2)]); }
{ print("    homomorphism check:  q(i)q(j) = q(k) : ",
        qmat([0,1,0,0])*qmat([0,0,1,0]) == qmat([0,0,0,1]),
        "     ji = -k : ", qmat([0,0,1,0])*qmat([0,1,0,0]) == qmat([0,0,0,-1])); }
print("");
one = [1,0,0,0]; qi = [0,1,0,0]; qj = [0,0,1,0]; qk = [0,0,0,1]; nul = [0,0,0,0];
print("    (5a) DESARGUES, over H.");
print("");
uO = [one, qi, qj];
uA = [qj, one, qk];  uB = [qi, qk, one];  uC = [one, one, qi];
\\ A' = A.alpha + O.beta with genuinely noncommutative scalars, so that
\\ O, A, A' are collinear by construction -- and likewise for B and C.
al = [1,1,0,0]; be = [0,1,1,0];
al2 = [1,0,1,0]; be2 = [1,0,0,1];
al3 = [0,1,0,1]; be3 = [1,1,0,0];
uAp = hadd(hsc(uA, al ), hsc(uO, be ));
uBp = hadd(hsc(uB, al2), hsc(uO, be2));
uCp = hadd(hsc(uC, al3), hsc(uO, be3));
{ print("      O  = ", uO);
  print("      A  = ", uA, "   A' = A(1+i) + O(i+j)  = ", uAp);
  print("      B  = ", uB, "   B' = B(1+j) + O(1+k)  = ", uBp);
  print("      C  = ", uC, "   C' = C(i+k) + O(1+i)  = ", uCp); }
{ print("      AA', BB', CC' concur at O, by construction: ",
        hcoll(uO,uA,uAp) && hcoll(uO,uB,uBp) && hcoll(uO,uC,uCp)); }
{ my(qX = hmeet(uA,uB, uAp,uBp), qY = hmeet(uB,uC, uBp,uCp), qZ = hmeet(uC,uA, uCp,uAp));
  print("      X = AB ^ A'B' = ", qX);
  print("      Y = BC ^ B'C' = ", qY);
  print("      Z = CA ^ C'A' = ", qZ);
  print("      rank of [X | Y | Z] over C = ",
        matrank(matconcat([hpt(qX), hpt(qY), hpt(qZ)])), "  (6 would mean non-collinear)");
  print("      X, Y, Z COLLINEAR: ", hcoll(qX,qY,qZ)); }
print("");
print("    (5b) PAPPUS, over the same H.");
print("");
print("      Two lines, three points on each, alternating joins -- the exact");
print("      hypothesis of Pappus, and the conclusion fails:");
uP = [one, nul, nul]; uQ = [nul, one, nul]; uR = [nul, nul, one];
online(base, dir, s) = vector(3, i, base[i] + qm(dir[i], s));
\\ A1, A3, A5 on the line PQ;  A2, A4, A6 on the line PR
A1 = online(uP, uQ, one); A3 = online(uP, uQ, qi); A5 = online(uP, uQ, qj);
A2 = online(uP, uR, one); A4 = online(uP, uR, qi); A6 = online(uP, uR, qk);
{ print("      P = ", uP, "   Q = ", uQ, "   R = ", uR);
  print("      A1 = P + Q,   A3 = P + Q i,   A5 = P + Q j     (on the line PQ)");
  print("      A2 = P + R,   A4 = P + R i,   A6 = P + R k     (on the line PR)");
  print("      the two lines are distinct: ", !hcoll(uP, uQ, uR)); }
{ my(qX = online(uP,uQ,one), qY, qZ);
  qX = hmeet(A1,A2, A4,A5); qY = hmeet(A2,A3, A5,A6); qZ = hmeet(A3,A4, A6,A1);
  print("      X = A1A2 ^ A4A5 = ", qX);
  print("      Y = A2A3 ^ A5A6 = ", qY);
  print("      Z = A3A4 ^ A6A1 = ", qZ);
  print("      X, Y, Z pairwise distinct: ",
        !hsame(qX,qY) && !hsame(qY,qZ) && !hsame(qX,qZ),
        "     none of them one of the six A_i: ",
        !hsame(qX,A1) && !hsame(qX,A2) && !hsame(qX,A3) && !hsame(qX,A4) && !hsame(qX,A5) && !hsame(qX,A6));
  print("      rank of [X | Y | Z] over C = ",
        matrank(matconcat([hpt(qX), hpt(qY), hpt(qZ)])), "   -- rank 6, not 4");
  print("      X, Y, Z COLLINEAR: ", hcoll(qX,qY,qZ), "        <-- Pappus FAILS over H"); }
print("");
print("    In P^2(K) with K commutative this configuration would be forced onto");
print("    a line; over H it is not, and the obstruction is exactly that i and j");
print("    do not commute.  This is Hilbert's");
print("    dictionary: a projective plane is Desarguesian iff it is P^2(D) for a");
print("    division ring D, and Pappian iff D is a field.");

\\ -------------------------------------------- (6) the Moulton plane: failure
sec("(6) A PLANE WHERE DESARGUES IS FALSE: MOULTON'S.");
print("    Points: the affine plane over Q (completed by a line at infinity).");
print("    Lines:  the verticals x = c; the ordinary y = mx + b with m >= 0;");
print("    and, for m < 0, the BENT line");
print("");
print("        y = m x + b   for x <= 0,        y = (m/2) x + b   for x >= 0,");
print("");
print("    which is continuous at the y-axis.  Two points still lie on exactly");
print("    one line and two lines still meet at most once, so this is a genuine");
print("    projective plane -- but not one of the form P^2(D).");
print("");
mrs(m) = if(m < 0, m/2, m);
mval(L, x) = L[3] + if(x <= 0, L[2]*x, mrs(L[2])*x);
mon(L, P) = if(L[1] == 0, P[1] == L[2], mval(L, P[1]) == P[2]);
{ mjoin(P, Q) =
    my(x1 = P[1], y1 = P[2], x2 = Q[1], y2 = Q[2], m);
    if(x1 == x2, return([0, x1]));
    if(x1 > x2, [x1,y1,x2,y2] = [x2,y2,x1,y1]);
    if(x2 <= 0,                                  \\ both points on the left
       m = (y2 - y1)/(x2 - x1);
       return([1, m, y1 - m*x1]));
    if(x1 >= 0,                                  \\ both points on the right
       m = (y2 - y1)/(x2 - x1);
       if(m < 0, m = 2*m);                       \\ recover the left slope
       return([1, m, y1 - mrs(m)*x1]));
    \\ x1 < 0 < x2 : ordinary if the point on the right is not lower
    if(y2 >= y1, m = (y2 - y1)/(x2 - x1), m = (y1 - y2)/(x1 - x2/2));
    [1, m, y1 - m*x1]; }
{ mmeet(L, M) =
    my(x);
    if(L[1] == 0 && M[1] == 0, return(0));
    if(L[1] == 0, return([L[2], mval(M, L[2])]));
    if(M[1] == 0, return([M[2], mval(L, M[2])]));
    if(L[2] != M[2], x = (M[3] - L[3])/(L[2] - M[2]); if(x <= 0, return([x, mval(L,x)])));
    if(mrs(L[2]) != mrs(M[2]),
       x = (M[3] - L[3])/(mrs(L[2]) - mrs(M[2])); if(x >= 0, return([x, mval(L,x)])));
    if(L[3] == M[3], return([0, L[3]]));
    0; }
lname(L) = if(L[1] == 0, Str("x = ", L[2]), Str("slope ", L[2], if(L[2] < 0, "  BENT", "")));
\\ spot-check the two plane axioms on random rational points and lines
{ my(N = 4000, badj = 0, badm = 0, par = 0);
  setrand(1);
  for(n = 1, N,
    my(P = [random(41)/4 - 5, random(41)/4 - 5], Q = [random(41)/4 - 5, random(41)/4 - 5], L, M, R);
    if(P == Q, next);
    L = mjoin(P, Q);
    if(!mon(L, P) || !mon(L, Q), badj++);
    M = mjoin([random(41)/4 - 5, random(41)/4 - 5], [random(41)/4 - 5, random(41)/4 - 5]);
    if(M == L, next);
    R = mmeet(L, M);
    if(R == 0, par++, if(!mon(L, R) || !mon(M, R), badm++)));
  print("    axiom check on ", N, " random rational pairs:");
  print("      join of two points contains both, every time : ", badj == 0);
  print("      meet of two lines lies on both, every time   : ", badm == 0,
        "   (", par, " parallel pairs, meeting at infinity)");
  print(""); }
\\ the configuration
gO = [-27/10, 15/10]; gA = [33/10, 2]; gB = [-4, -11/10]; gC = [39/10, -11/10];
sA = 6/10; sB = 13/10; sC = 8/10;
\\ A' is the point of the Moulton line OA whose x-coordinate divides in ratio sA
{ mslide(P, Q, s) = my(L = mjoin(P,Q), x); if(L[1] == 0, return([P[1], P[2] + s*(Q[2]-P[2])])); x = P[1] + s*(Q[1] - P[1]); [x, mval(L, x)]; }
gAp = mslide(gO, gA, sA); gBp = mslide(gO, gB, sB); gCp = mslide(gO, gC, sC);
{ print("      O  = ", gO);
  print("      A  = ", gA,  "     A' = ", gAp, "   (on the Moulton line OA)");
  print("      B  = ", gB,  "     B' = ", gBp, "   (on the Moulton line OB)");
  print("      C  = ", gC,  "     C' = ", gCp, "   (on the Moulton line OC)"); }
{ print("      the three joins really do pass through O and the primed points: ",
        mon(mjoin(gO,gA), gAp) && mon(mjoin(gO,gB), gBp) && mon(mjoin(gO,gC), gCp)); }
print("");
print("    so AA', BB', CC' concur at O -- the hypothesis of Desargues holds.");
print("    Now the three points of the would-be axis, all Moulton meets:");
print("");
gX = mmeet(mjoin(gA,gB), mjoin(gAp,gBp));
gY = mmeet(mjoin(gB,gC), mjoin(gBp,gCp));
gZ = mmeet(mjoin(gC,gA), mjoin(gCp,gAp));
{ print("      X = AB ^ A'B'  = ", gX, "  = ", pt2(gX));
  print("      Y = BC ^ B'C'  = ", gY, "  = ", pt2(gY));
  print("      Z = CA ^ C'A'  = ", gZ, "  = ", pt2(gZ)); }
print("");
{ my(L = mjoin(gX, gY));
  print("      the Moulton line XY is ", lname(L), ", intercept ", L[3]);
  print("      does it contain Z?   ", mon(L, gZ), "        <-- DESARGUES FAILS");
  print("      it passes through x = ", gZ[1], " at height ", mval(L, gZ[1]));
  print("      while Z sits at height ", gZ[2], ",  a gap of ", mval(L,gZ[1]) - gZ[2]);
  print("      (about ", strprintf("%.3f", 1.0*(mval(L,gZ[1]) - gZ[2])), " units -- plainly visible in the figure)"); }
print("");
print("    Which of the ten lines are bent, and which actually use their bend");
print("    between the two points they join?");
{ my(nm = ["OA","OB","OC","AB","A'B'","BC","B'C'","CA","C'A'","XY"],
     sg = [[gO,gA],[gO,gB],[gO,gC],[gA,gB],[gAp,gBp],[gB,gC],[gBp,gCp],[gC,gA],[gCp,gAp],[gX,gY]]);
  for(n = 1, 10,
    my(L = mjoin(sg[n][1], sg[n][2]), xs = [sg[n][1][1], sg[n][2][1]],
       crosses = (vecmin(xs) < 0) && (vecmax(xs) > 0), tag);
    tag = if(L[1] == 1 && L[2] < 0, if(crosses, "  BENT, and it bends between them", "  bent, but only off to the left"), "  straight");
    print(strprintf("      %-5s left slope %-12s%s", nm[n], if(L[1]==0, "vertical", L[2]), tag))); }
print("");
print("    So the join OC bends between O and C, and so does the axis XY between");
print("    X and Y.  That is where the theorem leaks.");
print("");
print("    THE CONTROL.  Run the same recipe with straight lines: same O, A, B, C");
print("    and the same three ratios along the joins.  Only C' moves -- OC is the");
print("    one join that bends -- and collinearity comes straight back:");
{ my(eA = [1, (gA[2]-gO[2])/(gA[1]-gO[1]), 0], p, q, r, u, v, w, hx, hy, hz);
  p = gO + sA*(gA - gO); q = gO + sB*(gB - gO); r = gO + sC*(gC - gO);
  u = hom(gA); v = hom(gB); w = hom(gC);
  hx = meet(u, v, hom(p), hom(q));
  hy = meet(v, w, hom(q), hom(r));
  hz = meet(w, u, hom(r), hom(p));
  print("      A' = ", p, "   B' = ", q, "   C' = ", r);
  print("      X  = ", pt2(aff(hx)), "   Y = ", pt2(aff(hy)), "   Z = ", pt2(aff(hz)));
  print("      det[X;Y;Z] = ", det3(hx,hy,hz), "     collinear: ", coll(hx,hy,hz)); }
print("");
print("    Nothing changed but which curves are called lines.  Desargues is");
print("    therefore NOT a consequence of the incidence axioms: it is");
print("    an extra hypothesis, and by Hilbert's theorem it is exactly the one that");
print("    buys coordinates in a division ring.  The reason the proof of section (4)");
print("    cannot be repeated here is that the Moulton plane embeds in no P^3.");
print("");
bar();
print(" done.");
bar();
