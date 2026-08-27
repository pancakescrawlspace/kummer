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

\\ ------------------------------------- p = 7, the square class [7] (section 4.1)
\\ 7 || d with d/7 a quadratic residue.  Both curves then have additive reduction
\\ of type I_0* at 7 with c_7 = 1, so M = #E(Q_7)/E_1 = 7 and E(Q_7) is
\\ PROCYCLIC: rank 1 on each curve suffices, unlike p = 2.  The class was empty
\\ in the first pass only because both ranks must be positive at once.

\\ An independent density test, valid at additive p where crosscheck() bails out
\\ (it skips p | N).  E_1 = Z_p, so any element of E_1 \ E_2 generates E_1
\\ topologically; hence Gamma is dense as soon as its image in E(Q_p)/E_2 --- a
\\ group of order p*M --- is everything.
{inE2p(Q,p) = (Q == [0]) || (valuation(Q[1],p) <= -4);}
{coverE2(E, p) =
  my(v, Em = ellminimalmodel(E,&v), M = Mval(Em,p),
     P = apply(Q -> ellchangepoint(Q,v), allpts(E)), Ep, PP, S, fr, nw, target);
  if(#P == 0 || M == 0, return([0, 0, p*M]));
  Ep = padiccurve(Em, p);
  PP = apply(Q -> [Q[1]+O(p^PREC), Q[2]+O(p^PREC)], P);
  target = p*M;  S = [[0]];  fr = [[0]];
  while(#fr, nw = List();
    for(i=1,#fr, for(j=1,#PP,
      my(R = elladd(Ep, fr[i], PP[j]), new = 1);
      for(t=1,#S, if(inE2p(ellsub(Ep,R,S[t]),p), new = 0; break));
      if(new, S = concat(S,[R]); listput(nw,R))));
    fr = Vec(nw);
    if(#S > target, break));
  [#S == target, #S, target];}

\\ Corroboration of step (b) of the Proposition in section 4.1.  By Theorem 1 of
\\ Pannekoek, arXiv:1211.5833, E_0(Q_p) = Z_p for additive reduction with all
\\ a_i in pZ_p, EXCEPT (p=7) a_6 = 14 mod 49 -- which needs v_7(a_6) = 1, while
\\ here v_7(a_6) = 3v_7(d).  So E_d(Q_7) = Z_7 and there is no 7-torsion; that
\\ is what this checks.
{has7(E, p, n) =
  my(Em = ellminimalmodel(E), rts = polrootspadic(elldivpol(Em,p), p, n), cnt = 0);
  for(i=1,#rts, my(x = rts[i],
     y2 = x^3 + Em.a2*x^2 + Em.a4*x + Em.a6 + (Em.a1*x/2 + Em.a3/2)^2);
     if(y2 == 0 || issquare(y2), cnt++));
  cnt;}

{notors7(B) = my(bad = 0, n = 0);
  for(a = 1, B, foreach([a,-a], d,
    if(core(abs(d)) != abs(d), next);
    if(sqclass(d,7) != 2, next);
    n++;
    if(has7(Ed(d),7,40) || has7(Epd(d),7,40), bad++;
       printf("  d = %s HAS 7-torsion over Q_7\n", d))));
  printf("  %d twists in class [7] with |d| <= %d : %d with 7-torsion over Q_7\n", n, B, bad);
  printf("  (0 means E_d(Q_7) = Z_7 is procyclic throughout the class)\n");}

{seven(B) = my(cand = 0, both = 0, wit = List());
  print("=== p = 7, square class [7], |d| <= ", B, " ===");
  for(a = 1, B, foreach([a,-a], d,
    if(core(abs(d)) != abs(d), next);
    if(sqclass(d,7) != 2, next);
    cand++;
    my(E = ellminimalmodel(Ed(d)), Ep = ellminimalmodel(Epd(d)), r, rp, a1, b1);
    r = ellrank(E)[1]; rp = ellrank(Ep)[1];
    if(r < 1 || rp < 1, next);
    both++;
    a1 = coverE2(Ed(d), 7);  b1 = coverE2(Epd(d), 7);
    printf("  d = %-7s ranks %d,%d   M = %s,%s   densegroup %d,%d   E/E_2 image %s/%s, %s/%s%s\n",
      d, r, rp, Mval(E,7), Mval(Ep,7), dense(Ed(d),7), dense(Epd(d),7),
      a1[2], a1[3], b1[2], b1[3],
      if(dense(Ed(d),7) && dense(Epd(d),7), "   *** WITNESS ***", ""));
    if(dense(Ed(d),7) && dense(Epd(d),7), listput(wit,d))));
  printf("  %d squarefree d in the class, %d with both ranks positive, %d witnesses: %s\n",
    cand, both, #wit, Vec(wit));
  Vec(wit);}

\\ ------------------------------------- L_q at q | d, and psi_* L'_q = L_q
\\ Section 6.6.2 / 6.6.3 of kummer-example-j0.typ.  Everything here is a check
\\ on identities that are PROVED there; the point is to catch a slip, not to
\\ establish the result by sampling.
\\
\\ A_q = K (x) Q_q with K = Q(u), u^3 = 3.  For q = 2 mod 3 it is Q_q x L with
\\ L = Q_q(zeta_3) unramified quadratic; L is carried as Q_q[t]/(t^2+t+1).

\\ norm, valuation and square test in L = Q_q(zeta_3)
NL(z)  = {my(a = polcoeff(lift(z),0), b = polcoeff(lift(z),1)); a^2 - a*b + b^2;}
vL(z,q) = {my(a = polcoeff(lift(z),0), b = polcoeff(lift(z),1));
           min(valuation(a,q), valuation(b,q));}
{issqL(z,q) = my(v = vL(z,q));
  if(v % 2, return(0)); kronecker(truncate(NL(z)/q^(2*v)) % q, q) == 1;}
{issqQ(a,q) = my(v = valuation(a,q));
  if(v % 2, return(0)); kronecker(truncate(a/q^v) % q, q) == 1;}

\\ q = 2 mod 3: the classes delta_q(T) and psi_* delta'_q(T') in Q_q x L,
\\ the exact-square identity, and the closed form <(3, d(1-zeta_3))>.
{lqsplit(d, q, n) =
  my(c = sqrtn(3 + O(q^n), 3), Z = Mod(t, t^2+t+1), e, ep, A1,A2, B1,B2);
  e = -d*c^2;  ep = 3*d*c;
  if(e^3 + 9*d^3 != 0 || ep^3 - 81*d^3 != 0, error("wrong roots"));
  A1 = 3*e^2;   A2 = e  + d*Z^2*c^2;      \\ delta_q(T)          on E_d
  B1 = 3*ep^2;  B2 = ep - 3*d*Z*c;        \\ psi_* delta'_q(T')  on E'_d
  printf("  d = %-6s q = %-5s v_q(d) = %s\n", d, q, valuation(d,q));
  printf("    identity  delta(T) = (c^-2, zeta/c)^2 . psi_*delta'(T') : %s\n",
         if(A1/B1 - 1/c^4 == 0 && A2/B2 - (Z/c)^2 == 0, "exact", "*** FAILS"));
  printf("    class     delta(T) = (3, d(1-zeta_3)) mod squares       : %s\n",
         if(issqQ(A1/(3+O(q^n)),q) && issqL(A2/(d*(1-Z)+O(q^n)),q), "yes", "*** no"));
  printf("    class     delta(T) = (3, q(1-zeta_3)) mod squares       : %s\n",
         if(issqQ(A1/(3+O(q^n)),q) && issqL(A2/(q*(1-Z)+O(q^n)),q), "yes", "*** no"));
  printf("    non-trivial, and in ker N                               : %s, %s\n",
         if(issqQ(A1,q) && issqL(A2,q), "*** trivial", "yes"),
         if(issqQ(A1*NL(A2),q), "yes", "*** no"));
  \\ every sampled local class lies on the line <delta_q(T)>
  my(cnt = 0, off = 0, odd2 = 0);
  for(x = -300, 300,
    my(fx = x^3 + 9*d^3, d1, d2);
    if(fx == 0 || !issqQ(fx + O(q^n), q), next);
    cnt++;  d1 = x + d*c^2;  d2 = x + d*Z^2*c^2;
    if(vL(d2,q) % 2, odd2++);
    if(!(issqQ(d1,q) && issqL(d2,q)) && !(issqQ(d1/A1,q) && issqL(d2/A2,q)), off++));
  printf("    %s sampled abscissae: %s outside <delta_q(T)>, %s of odd v_w2\n",
         cnt, off, odd2);}

\\ any q != 3 with 3 a cube in Q_q: all nine component ratios are squares.
{lqgeneral(d, q, n) =
  my(c, Z, r, s, bad = 0);
  if(Mod(3,q)^((q-1)/3) != 1, printf("  q = %s : 3 is not a cube, dim W_q = 0\n", q); return);
  c = sqrtn(3 + O(q^n), 3);  Z = (-1 + sqrt(-3 + O(q^n)))/2;
  r = vector(3, i, -d*c^2*Z^(i-1));  s = vector(3, j, 3*d*c*Z^(j-1));
  for(j = 0, 2, my(pj = (2*j) % 3);
    for(k = 0, 2, my(pk = (2*k) % 3, num, den);
      if(k == j, num = 3*r[pj+1]^2;      den = 3*s[j+1]^2,
                 num = r[pj+1]-r[pk+1];  den = s[j+1]-s[k+1]);
      if(!issqQ(num/den, q), bad++)));
  printf("  d = %-6s q = %-5s (q mod 12 = %s) : %s of 9 component ratios non-square\n",
         d, q, q % 12, bad);}

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
print("");
seven(200);
notors7(400);
print("\n=== L_q at q | d, q = 2 mod 3  (section 6.6.2) ===");
lqsplit(-66, 11, 20); lqsplit(94, 47, 20); lqsplit(-5, 5, 20);
lqsplit(2501, 41, 20); lqsplit(-30, 5, 20); lqsplit(10, 5, 20);
print("\n=== all nine component ratios, any q != 3  (section 6.6.3) ===");
lqgeneral(-61, 61, 20); lqgeneral(5105, 1021, 20); lqgeneral(-30, 61, 20);
lqgeneral(67, 67, 20); lqgeneral(-103, 103, 20); lqgeneral(151, 151, 20);
lqgeneral(1, 7, 20); lqgeneral(1, 43, 20);
}
quit
