read("kummer2.gp");
PR = 200;

/* rational points (u,v) on d*v^2=f(u), as p-adics; combinations a*P1+b*P2 */
twistpoints(A, B, d, p, NB) = {
  my(Ec, vv, Em, td, pts, Ep, P, L, a, b, Q, R, u, v, r);
  Ec = ellinit([A*d^2, B*d^3]);
  vv = 0; Em = ellminimalmodel(Ec, &vv);
  td = twistdata(A, B, d);
  pts = apply(P -> ellchangepointinv(P, vv), td[2]);
  r = #pts;
  if(r == 0, return([]));
  Ep = ellinit([Ec.a4 + O(p^PR), Ec.a6 + O(p^PR)]);
  P = apply(Q -> [Q[1] + O(p^PR), Q[2] + O(p^PR)], pts);
  L = List();
  if(r == 1,
    Q = [0];
    for(a = 1, NB,
      Q = if(Q == [0], P[1], elladd(Ep, Q, P[1]));
      if(Q == [0], next);
      listput(L, [Q[1]/d, Q[2]/d^2]);
      listput(L, [Q[1]/d, -Q[2]/d^2])
    )
  ,
    for(a = -NB, NB,
      R = if(a == 0, [0], ellmul(Ep, P[1], a));
      Q = R;
      for(b = 0, NB,
        if(b > 0, Q = if(Q == [0], P[2], elladd(Ep, Q, P[2])));
        if(Q == [0], next);
        listput(L, [Q[1]/d, Q[2]/d^2])
      )
    )
  );
  Vec(L);
}

coverage(A, B, p, k, ds, NB) = {
  my(q, tgt, hit, tot, cnt, i, a, b, x, t, y, s, rr, d, S, allpts, region, AA, BB,
     u1, u2, v1, v2, xx, tt, yy, key, q2, q3);
  q = p^k; q2 = q*q; q3 = q2*q;
  for(region = 1, 2,
    AA = if(region == 1, A, A*p^2);
    BB = if(region == 1, B, B*p^3);
    tgt = vectorsmall(q3); tot = 0;
    for(x = 0, q-1,
      if(region == 2 && x % p == 0, next);
      for(t = 0, q-1,
        if(region == 2 && t % p == 0, next);
        s = ((x^3 + AA*x + BB) * (t^3 + AA*t + BB)) % q;
        if(s % p == 0, next);
        if(kronecker(s, p) != 1, next);
        rr = truncate(sqrt(s + O(p^k))) % q;
        tgt[x*q2 + t*q + rr + 1] = 1; tot++;
        tgt[x*q2 + t*q + (q-rr)%q + 1] = 1; tot++
      )
    );
    hit = vectorsmall(q3); cnt = 0;
    for(i = 1, #ds,
      d = ds[i];
      S = twistpoints(A, B, d, p, NB);
      allpts = List();
      for(a = 1, #S,
        if(region == 1 && valuation(S[a][1], p) >= 0, listput(allpts, S[a]));
        if(region == 2 && valuation(S[a][1], p) == -1, listput(allpts, S[a]))
      );
      allpts = Vec(allpts);
      for(a = 1, #allpts,
        u1 = allpts[a][1]; v1 = allpts[a][2];
        for(b = 1, #allpts,
          u2 = allpts[b][1]; v2 = allpts[b][2];
          yy = d*v1*v2;
          if(region == 1, xx = u1; tt = u2, xx = p*u1; tt = p*u2; yy = p^3*yy);
          if(valuation(yy, p) != 0, next);
          x = truncate(xx + O(p^k)) % q;
          t = truncate(tt + O(p^k)) % q;
          y = truncate(yy + O(p^k)) % q;
          key = x*q2 + t*q + y + 1;
          if(tgt[key] && !hit[key], hit[key] = 1; cnt++)
        )
      )
    );
    print("  region ", if(region==1, "x,t in Z_p       ", "v_p(x)=v_p(t)=-1 "),
          " mod ", p, "^", k, ":  targets = ", tot, ",  hit = ", cnt,
          if(cnt == tot, "   COMPLETE", "   incomplete (undersampled)"))
  );
}
