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
  print("\n(C) beta_p =/= 0 : NOT checked here -- a norm residue symbol at v = l.");}

\\ ------------------------------------------------------------------- run
{
print("=== (1) search for 5-congruent non-isogenous pairs ===");
my(S = search(5, 500, 150));
printf("found %d pairs; first three:\n", #S);
for(k=1, min(3,#S), print("   ", S[k][1], "  ~  ", S[k][2], "   (conductor ", S[k][3], ")"));
print("\n=== (2),(3) the conductor 200 pair, ell = 5, p = 5 ===");
report(ellinit([0,-5,0,5,0]), ellinit([0,0,0,5,-10]), 5, 5);
}
quit
