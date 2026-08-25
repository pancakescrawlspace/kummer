read("kummer2.gp");
/* exact rational points on d v^2 = f(u) */
ptsexact(A,B,d,NB) = {
  my(Ec, vv, Em, td, pts, L, a, Q, R);
  Ec = ellinit([A*d^2, B*d^3]); vv=0; Em = ellminimalmodel(Ec,&vv);
  td = twistdata(A,B,d);
  pts = apply(P -> ellchangepointinv(P, vv), td[2]);
  if(#pts == 0, return([]));
  L = List(); Q = [0];
  for(a = 1, NB,
    Q = if(Q==[0], pts[1], elladd(Ec, Q, pts[1]));
    if(Q == [0], next);
    listput(L, [Q[1]/d, Q[2]/d^2]); listput(L, [Q[1]/d, -Q[2]/d^2]);
    if(#pts > 1,
      R = elladd(Ec, Q, pts[2]);
      if(R != [0], listput(L, [R[1]/d, R[2]/d^2]); listput(L, [R[1]/d, -R[2]/d^2]))
    )
  );
  Vec(L);
}
cov2(A,B,k,ds,NB) = {
  my(q=2^k, Q4=2^(k+4), tgt, hit, tot=0, cnt=0, x,t,s,y0,i,a,b,d,S,allpts,region,AA,BB,
     u1,u2,v1,v2,xx,tt,yy,key,q2,q3,ok);
  q2=q*q; q3=q2*q;
  for(region=1,2,
    AA = if(region==1, A, 4*A); BB = if(region==1, B, 8*B);
    tgt = vectorsmall(q3); tot=0;
    for(x=0, Q4-1,
      if(region==2 && x%2==0, next);
      for(t=0, Q4-1,
        if(region==2 && t%2==0, next);
        s = (x^3+AA*x+BB)*(t^3+AA*t+BB);
        if(s%2==0, next);
        if(s%8 != 1, next);
        y0 = truncate(sqrt(s + O(2^(k+2)))) % q;
        for(i=0,1,
          y0 = if(i==0, y0, (q-y0)%q);
          key = (x%q)*q2 + (t%q)*q + y0 + 1;
          if(!tgt[key], tgt[key]=1; tot++))
      )
    );
    hit = vectorsmall(q3); cnt=0;
    for(i=1,#ds,
      d = ds[i]; S = ptsexact(A,B,d,NB);
      allpts = List();
      for(a=1,#S,
        ok = valuation(S[a][1],2);
        if(region==1 && ok>=0, listput(allpts,S[a]));
        if(region==2 && ok==-1, listput(allpts,S[a])));
      allpts = Vec(allpts);
      for(a=1,#allpts, u1=allpts[a][1]; v1=allpts[a][2];
        for(b=1,#allpts, u2=allpts[b][1]; v2=allpts[b][2];
          yy = d*v1*v2;
          if(region==1, xx=u1; tt=u2, xx=2*u1; tt=2*u2; yy=8*yy);
          if(valuation(yy,2)!=0, next);
          if(valuation(xx,2)<0 || valuation(tt,2)<0, next);
          x = lift(Mod(xx,q)); t = lift(Mod(tt,q)); y0 = lift(Mod(yy,q));
          key = x*q2+t*q+y0+1;
          if(tgt[key] && !hit[key], hit[key]=1; cnt++)));
    );
    print("  region ",if(region==1,"x,t in Z_2       ","v_2(x)=v_2(t)=-1 "),
      " mod 2^",k,":  genuine targets = ",tot,",  hit = ",cnt,
      if(cnt==tot,"   COMPLETE","   incomplete"))
  );
}


