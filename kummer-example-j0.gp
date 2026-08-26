\\ kummer-example-j0.gp --- computations for kummer-example-j0.typ
\\
\\   E  : y^2 = x^3 + 9      twists  E_d  : y^2 = x^3 + 9 d^3
\\   E' : v^2 = u^3 - 81     twists  E'_d : y^2 = x^3 - 81 d^3
\\
\\ Both have j = 0 (CM by Z[zeta_3]), rank 1, and are not isogenous.
\\ The density tests come from the repository's own kummer2.gp / p2.gp: those
\\ are SINGLE-CURVE tests, so off the diagonal one simply applies them twice.
\\
\\ Run from this directory:   gp -q -s 4000000000 kummer-example-j0.gp

read("p2.gp");

Ed(d)  = ellinit([0,0,0,0,  9*d^3]);
Epd(d) = ellinit([0,0,0,0,-81*d^3]);

{gens(E) = my(r = ellrank(E), P = r[4]);
  if(#P == 0 && r[1] == 1, P = [ellheegner(E)]);
  if(#P == 0, [], ellsaturation(E,P,40));}

\\ all of E(Q): saturated free generators together with the torsion
{allpts(E) = concat(gens(E), elltors(E)[3]);}

\\ is E(Q) dense in E(Q_p)?  (minimal model + the repository's test)
{dense(E,p) = my(v, Em = ellminimalmodel(E,&v),
                 P = apply(Q -> ellchangepoint(Q,v), allpts(E)));
  if(#P == 0, 0, if(p == 2, densegroup2(Em,P), densegroup(Em,P,p)));}

\\ ------------------------------------------------ an independent density test
\\ Section 2.2 of the main notes, literally: closure = E(Q_p) iff Gamma is onto
\\ E(Q_p)/E_1 AND Gamma ∩ E_1 is not inside E_2.  The second clause is checked
\\ by enumerating COMBINATIONS -- the shortcut "some generator has
\\ v_p(x(M P)) = -2" is false when p | #Etilde(F_p), where E_1 sits one level
\\ deeper; that is what made the first version of this check disagree at p = 7.
{indep(E,p) = my(v, Em = ellminimalmodel(E,&v), M = Mval(Em,p));
  my(P = apply(Q -> ellchangepoint(Q,v), allpts(E)), r = 0);
  r = #P; if(r == 0 || M == 0, return(0));
  my(Ep = ellinit([Em.a1,Em.a2,Em.a3,Em.a4,Em.a6], p));
  my(S = Set([[0]]), fr = [[0]], nw,
     red = apply(Q -> if(valuation(Q[1],p) < 0, [0], [Mod(Q[1],p),Mod(Q[2],p)]), P));
  while(#fr, nw = List();
    for(i=1,#fr, for(j=1,#red, my(R = elladd(Ep,fr[i],red[j]));
      if(!setsearch(S,R), S = setunion(S,Set([R])); listput(nw,R))));
    fr = Vec(nw));
  if(#S != ellcard(Ep), return(0));
  forvec(a = vector(r,i,[0,M]),
    my(Q = [0]); for(i=1,r, if(a[i], Q = elladd(Em,Q,ellmul(Em,P[i],a[i]))));
    if(Q != [0] && valuation(Q[1],p) == -2, return(1)));
  0;}

{crosscheck(ds, ps) = my(n = 0, bad = 0, pm = 0);
  foreach(ds, d, foreach(ps, p, foreach([Ed(d), Epd(d)], C,
    if(ellglobalred(C)[1] % p == 0, next);
    n++; if(Mval(ellminimalmodel(C),p) % p == 0, pm++);
    if(dense(C,p) != indep(C,p), bad++;
       printf("  MISMATCH d=%d p=%d %s\n", d, p, C[1..5])))));
  printf("  %d (curve,p) pairs compared, %d mismatches [%d with p | M]\n", n, bad, pm);}

\\ ------------------------------------------- the two factors are independent
\\ (E_d x E'_d)(Q) = E_d(Q) x E'_d(Q) : every cross pair lands on X.
{indeptest(ds) = my(n = 0, bad = 0);
  foreach(ds, d,
    my(E = Ed(d), F = Epd(d), A = List(), B = List());
    my(g1 = allpts(E), g2 = allpts(F));
    if(#g1 == 0 || #g2 == 0, next);
    for(k=1,4, my(Q = ellmul(E,g1[1],k)); if(Q != [0], listput(A,Q)));
    for(k=1,4, my(Q = ellmul(F,g2[1],k)); if(Q != [0], listput(B,Q)));
    foreach(Vec(A), P, foreach(Vec(B), Pp,
      my(u = P[1]/d, v = P[2]/d^2, s = Pp[1]/d, w = Pp[2]/d^2);
      n++;
      if((d*v*w)^2 != (u^3+9)*(s^3-81), bad++))));
  printf("  %d independent cross pairs, %d failed to land on X\n", n, bad);}

\\ ------------------------------------------------ 2-torsion over Q_2, and rank
{tors2(ds) = my(n = 0, bad = 0);
  foreach(ds, d, foreach([9*d^3, -81*d^3], B,
    n++; if(#polrootspadic(x^3+B, 2, 20) == 0, bad++)));
  printf("  %d twists checked, %d WITHOUT a Q_2-rational 2-torsion point\n", n, bad);}

{rank2(ds) = my(viol = 0, n = 0);
  foreach(ds, d, foreach([Ed(d), Epd(d)], C,
    my(r = #gens(C), a = dense(C,2)); n++;
    if(a && r < 2, viol++; printf("  dense but rank %d : d=%d %s\n", r, d, C[1..5]))));
  printf("  %d twists checked, %d dense with rank < 2\n", n, viol);}

\\ ------------------------------------------------------------------ the scan
{scan(B, ps) = my(L = List());
  for(a=1,B, foreach([a,-a], d,
    if(core(abs(d)) != abs(d), next);
    if(ellrank(Ed(d))[1] < 1, next);
    if(ellrank(Epd(d))[1] < 1, next);
    listput(L,d)));
  printf("twists with both ranks positive, |d| <= %d : %d\n", B, #L);
  foreach(ps, p,
    my(nc = if(p==2,8,4), wit = vector(nc));
    printf("\n=== p = %d ===\n", p);
    foreach(Vec(L), d,
      my(k = if(p==2, sqclass2(d), sqclass(d,p)) + 1);
      if(wit[k], next);
      if(dense(Ed(d),p) && dense(Epd(d),p), wit[k] = d));
    for(k=1,nc, printf("  class [%-3s] : %s\n",
       if(p==2, sqclass2name(k-1), sqclassname(k-1,p)),
       if(wit[k], Str("d = ", wit[k]), "none found"))));
  Vec(L);}

\\ ------------------------------------------------------------------- run
{
my(sample = [1,2,-3,-5,-6,-7,10,11,13,15,-17,-19,21,22,23,-29,-30,-31]);
print("=== densegroup / densegroup2 against an independent test ===");
crosscheck(sample, [5,7,11,13]);
print("\n=== the two factors are independent ===");
indeptest([1,2,-3,-5,-6,-7,10,11,13]);
print("\n=== every twist has 2-torsion over Q_2 ===");
tors2(concat(sample, [-61,35,-33,94,130,-66]));
print("\n=== at p = 2, dense implies rank >= 2 ===");
rank2([-61,2,-6,10,-30,-66,94,130,-3,-5,1,13,22,23,35,-33]);
print("\n=== the scan (B = 65 here; the document uses B = 150) ===");
scan(65, [2,3,5,7]);
}
quit
