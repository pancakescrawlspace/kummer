\\ nondiagonal-obstruction.gp --- checks for nondiagonal-obstruction.typ
\\
\\ The twisted-pairing obstruction on Kum(E x E') needs a Galois-equivariant
\\ psi in Hom(E'[l], E[l]) not induced by an isogeny.  For non-isogenous
\\ curves that is exactly an l-congruence.  This script
\\   (1) searches for l-congruent non-isogenous pairs,
\\   (2) verifies one such pair to a high bound, and
\\   (3) checks the local conditions (B), (D), (E) of the criterion.
\\
\\ Run as:   gp -q nondiagonal-obstruction.gp

\\ ---------------------------------------------------------------- helpers
\\ do a_q and a'_q agree mod l at every prime of good reduction up to B?
\\ returns the number of primes tested, or -1 at the first disagreement.
{agree(E,F,l,B) = my(N=ellglobalred(E)[1], M=ellglobalred(F)[1], n=0);
  forprime(q=2,B, if(N%q==0 || M%q==0, next);
    if(Mod(ellap(E,q)-ellap(F,q),l) != 0, return(-1)); n++);
  n;}

\\ do a_q and a'_q differ over Z somewhere?  (then not isogenous, by Faltings)
{differ(E,F,B) = my(N=ellglobalred(E)[1], M=ellglobalred(F)[1]);
  forprime(q=2,B, if(N%q==0 || M%q==0, next);
    if(ellap(E,q) != ellap(F,q), return(1)));
  0;}

\\ dim_{F_l} E[l](Q_q), by counting Q_q-points of the l-division polynomial
{ltors(E,l,q,prec) = my(P=elldivpol(E,l), r=polrootspadic(P,q,prec), n=0);
  for(i=1,#r, my(x=r[i]);
    if(issquare(x^3 + E.a2*x^2 + E.a4*x + E.a6 + O(q^prec)), n++));
  if(n==0, 0, if(n<=1, 1, 2));}

\\ dim W_v = dim E(Q_v)/l = dim E[l](Q_v) + [Q_v:Q_l] : the +1 only at v = l
{dimW(E,l,q,prec) = ltors(E,l,q,prec) + if(q==l, 1, 0);}

\\ ------------------------------------------------------------ (1) search
{search(l, Nmax, B) = my(L=List(), seen=Set(), out=List());
  for(a=-6,6, for(b=-12,12, for(c=-12,12,
    my(E=ellinit([0,a,0,b,c]));
    if(type(E)!="t_VEC" || #E==0, next);
    my(N=ellglobalred(E)[1]); if(N>Nmax, next);
    my(k=[N,E.j]); if(setsearch(seen,k), next);
    seen=setunion(seen,Set([k])); listput(L,E))));
  printf("pool: %d curves of conductor <= %d\n", #L, Nmax);
  for(i=1,#L, for(j=i+1,#L,
    if(differ(L[i],L[j],80)==0, next);
    if(agree(L[i],L[j],l,B) >= 25,
       listput(out, [L[i][1..5], L[j][1..5], ellglobalred(L[i])[1]]))));
  Vec(out);}

\\ ------------------------------------------------- (2),(3) verify one pair
{report(E, F, l, p) =
  printf("\nE  = %s   N = %d  j = %s  rank %d  tors %s\n",
     E[1..5], ellglobalred(E)[1], E.j, ellrank(E)[1], elltors(E)[2]);
  printf("E' = %s   N = %d  j = %s  rank %d  tors %s\n",
     F[1..5], ellglobalred(F)[1], F.j, ellrank(F)[1], elltors(F)[2]);
  my(n=agree(E,F,l,3000), d=0, N=ellglobalred(E)[1], M=ellglobalred(F)[1]);
  forprime(q=2,3000, if(N%q==0 || M%q==0, next); if(ellap(E,q)!=ellap(F,q), d++));
  printf("\n(A) a_q = a'_q mod %d at all %d good primes q <= 3000 : %s\n",
     l, n, if(n>=0,"YES","NO"));
  printf("    a_q != a'_q over Z at %d of them  -> not isogenous\n", d);
  printf("    isogeny class sizes %d and %d ; isogeny degrees %s and %s\n",
     #ellisomat(E)[1], #ellisomat(F)[1], ellisomat(E)[2], ellisomat(F)[2]);
  print("\n(D) dangerous primes need v_q(j) < 0, q = 1 mod l, l | v_q(j):");
  foreach(factor(N*M)[,1]~, q,
    printf("    q = %d : v_q(j_E) = %d , v_q(j_E') = %d , q mod %d = %d\n",
       q, valuation(E.j,q), valuation(F.j,q), l, q%l));
  print("\n(B),(E) local dimensions:");
  foreach(factor(N*M)[,1]~, q,
    printf("    q = %d : dim W_%d = %d , dim W'_%d = %d%s\n",
       q, q, dimW(E,l,q,12), q, dimW(F,l,q,12),
       if(q==p, "   <- critical place", if(dimW(E,l,q,12)==0 || dimW(F,l,q,12)==0,
          "   beta_q = 0", "   NEEDS CHECKING"))));
  print("\n(C) beta_p =/= 0 : see sweep5 below -- refuted on the ramified classes.");}


\\ ============================================ (4) pursuing beta_5, section 9
\\ Reciprocity runs backwards: a twist on which BOTH local images are full
\\ proves beta_5 = 0 on that square class.  No psi is needed.
\\
\\ At 5 every twist of this pair is additive, so E_d(Q_5) = Z_5 x T with |T|
\\ dividing c_5, and E_0 is torsion-free pro-5 (no 5-torsion over Q_5), so
\\ E_1 = 5 E_0.  Hence the image of E_d(Q) in W_5 = E_d(Q_5)/5 is non-zero iff
\\ v_5(x(c_5 * P)) >= 0 for some generator P.

\\ saturated Mordell-Weil generators
{gens(E) = my(r = ellrank(E), P = r[4]);
  if(#P == 0 && r[1] == 1, P = [ellheegner(E)]);
  if(#P == 0, [], ellsaturation(E,P,40));}

Etw(d)  = ellinit([0,-5*d,0,5*d^2,0]);        \\ twist of E  by d
Eptw(d) = ellinit([0,0,0,5*d^2,-10*d^3]);     \\ twist of E' by d

{cls5(d) = if(d%5==0, if(kronecker(d/5,5)==1, "[5]", "[5u]"),
                      if(kronecker(d,5)==1,   "[1]", "[u]"));}

\\ is the image of E(Q) in W_5 non-zero?
{nonzeroW5(E,g) = my(c = elllocalred(E,5)[4]);
  for(i=1,#g, my(Q = ellmul(E,g[i],c));
    if(Q != [0] && valuation(Q[1],5) >= 0, return(1)));
  0;}

\\ no twist of either curve is ever multiplicative (j is integral and
\\ twist-invariant): the check behind section 9.2
{nomult(ds) = my(n=0, bad=0);
  foreach(ds, d, foreach([Etw(d), Eptw(d)], C,
    foreach(factor(ellglobalred(C)[1])[,1]~, q,
      n++; if(elllocalred(C,q)[2] > 4, bad++))));
  printf("  %d local reductions inspected, %d multiplicative\n", n, bad);}

\\ sweep the four square classes at 5
{sweep5(B) =
  my(names = ["[1]","[u]","[5]","[5u]"], cnt = matrix(4,4), wit = List());
  for(a=1,B, foreach([a,-a], d,
    if(core(abs(d)) != abs(d), next);
    my(E = Etw(d), F = Eptw(d));
    if(ellrank(E)[1] < 1, next);
    if(ellrank(F)[1] < 1, next);
    my(g1 = gens(E), g2 = gens(F));
    if(#g1 == 0 || #g2 == 0, next);
    my(c = cls5(d), k = if(c=="[1]",1, if(c=="[u]",2, if(c=="[5]",3,4))));
    my(r1 = nonzeroW5(E,g1), r2 = nonzeroW5(F,g2));
    cnt[k,1]++; if(r1, cnt[k,2]++); if(r2, cnt[k,3]++);
    if(r1 && r2, cnt[k,4]++; listput(wit,[d,c]))));
  printf("\n|d| <= %d, twists with both ranks positive:\n", B);
  printf("%-5s %7s %10s %11s %7s %9s\n",
     "class","twists","R_d != 0","R'_d != 0","both","neither");
  for(k=1,4, printf("%-5s %7d %10d %11d %7d %9d\n", names[k],
     cnt[k,1], cnt[k,2], cnt[k,3], cnt[k,4],
     cnt[k,1]-cnt[k,2]-cnt[k,3]+cnt[k,4]));
  printf("\nwitnesses with both non-zero (these PROVE beta_5 = 0 on their class):\n  %s\n",
     Vec(wit));}


\\ Independent check of the test above: instead of the valuation criterion, ask
\\ directly whether P is 5-divisible in E_d(Q_5), by solving x([5]Q) = x(P) with
\\ ellxn and testing for a Q_5-point.  The two must disagree (R != 0 iff NOT
\\ 5-divisible).
{div5(E,P,prec) = my(AB = ellxn(E,5), f = AB[1] - P[1]*AB[2]);
  my(r = polrootspadic(f,5,prec));
  for(i=1,#r, my(xq = r[i]);
    if(issquare(xq^3 + E.a2*xq^2 + E.a4*xq + E.a6 + O(5^prec)), return(1)));
  0;}

{crosscheck(ds) = my(bad = 0, n = 0);
  foreach(ds, d, foreach([Etw(d), Eptw(d)], E,
    my(g = gens(E)); if(#g == 0, next);
    my(c = elllocalred(E,5)[4], P = g[1]);
    my(says = (valuation(ellmul(E,P,c)[1],5) >= 0), dv = div5(E,P,14));
    n++; if(says != (1-dv), bad++)));
  printf("  %d curve/twist pairs cross-checked against 5-divisibility, %d disagreements\n",
     n, bad);}

\\ ------------------------------------------------------------------- run
{
print("=== (1) search for 5-congruent non-isogenous pairs ===");
my(S = search(5, 500, 150));
printf("found %d pairs; first three:\n", #S);
for(k=1, min(3,#S), print("   ", S[k][1], "  ~  ", S[k][2], "   (conductor ", S[k][3], ")"));
print("\n=== (2),(3) the conductor 200 pair, ell = 5, p = 5 ===");
report(ellinit([0,-5,0,5,0]), ellinit([0,0,0,5,-10]), 5, 5);

print("\n=== (4) pursuing beta_5 : no twist of either curve is multiplicative ===");
nomult([-10,15,-30,-35,55,22,23,-41,-42,43,58,59,-6,7,-11,13]);
print("\n=== (4) the four square classes at 5 ===");
print("(the document reports |d| <= 220; that takes a few minutes, so 60 here)");
sweep5(60);
print("\ncross-check of the W_5 test against direct 5-divisibility:");
crosscheck([-10,-30,35,22,23]);
}
quit
