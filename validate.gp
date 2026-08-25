read("kummer.gp");
read("kummer2.gp");
PREC = 100;
chk(A,B,HN,HD,DMAX,PMAX) = {
  my(tot=0, bad=0, prs=primes([3,PMAX]), t0,q,dc,d,c,Ec,P,v,Em,Pm,p,r1,r2);
  for(b=1,HD, for(a=-HN,HN,
    if(gcd(a,b)!=1, next);
    t0=a/b; q=t0^3+A*t0+B;
    if(q==0, next);
    dc=sqfreepart(q); d=dc[1]; c=dc[2];
    if(abs(d)>DMAX, next);
    Ec=ellinit([A*d^2,B*d^3]); P=[d*t0,d^2*c]; v=0;
    Em=ellminimalmodel(Ec,&v); Pm=ellchangepoint(P,v);
    for(j=1,#prs,
      p=prs[j]; r1=densecyclic(Em,Pm,p); r2=densegroup(Em,[Pm],p);
      tot++;
      if(r1!=r2, bad++; print("MISMATCH t0=",t0," d=",d," p=",p," cyc=",r1," grp=",r2)))
  ));
  print("single-point agreement: ",tot," cases, ",bad," mismatches");
}
chk(1,1,15,4,200000,37);
chk(0,-2,15,4,200000,37);
print("");
td = twistdata(1,1,-11);
print("d=-11 pts: ", td[2], "  rank in [",td[3],",",td[4],"]");
show(td) = { my(p); foreach([3,5,7,11,13,17,19,23,29,31,37,41,43,47,59,67], p,
   print("  p=",p," M=",Mval(td[1],p)," dense(all)=",densegroup(td[1],td[2],p),
         "  dense(P1)=",densegroup(td[1],[td[2][1]],p))); }
show(td);
quit
