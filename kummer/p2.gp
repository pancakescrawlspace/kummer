read("kummer2.gp");

/* ---- p = 2 :  E_2(Q_2) = hat E(4 Z_2) is the safe procyclic level ----
   M2 = # E(Q2)/E_2(Q2) = 2 * c_2 * #Ens(F_2).
   Q in E_2  <=>  Q = O  or  v_2(x(Q)) <= -4 ;   generates E_2 <=> v_2(x)= -4. */

sqclass2(d) = {
  my(v = valuation(d,2), u = (d/2^v) % 8);
  if(u < 0, u += 8);
  4*(v%2) + (u-1)/2;
}
sqclass2name(k) = {
  my(nm = ["1","3","5","7","2","6","10","14"]);
  nm[k+1];
}

M2val(Em) = {
  my(ap = ellap(Em,2), lr = elllocalred(Em,2));
  2 * if(lr[2] == 1, lr[4]*(3-ap), lr[4]*(2-ap));
}

inE2(Q) = (Q == [0]) || (valuation(Q[1],2) <= -4);

densegroup2(Em, pts) = {
  my(M, r, Ep, P, S, coefs, basis, idx, rem, dv, mi, bvec, k, kP, Q, S2, C2, jP, cc, b, T);
  M = M2val(Em);
  r = #pts;
  if(M == 0 || r == 0, return(0));
  Ep = padiccurve(Em, 2);
  P = vector(r, i, [pts[i][1]+O(2^PREC), pts[i][2]+O(2^PREC)]);
  S = [[0]]; coefs = [vector(r, j, 0)]; basis = List(); idx = 1;
  for(i = 1, r,
    rem = M \ idx;
    dv = divisors(rem); mi = 0; bvec = 0;
    for(t = 1, #dv,
      k = dv[t]; kP = ellmul(Ep, P[i], k);
      for(s = 1, #S,
        Q = if(S[s] == [0], kP, elladd(Ep, kP, S[s]));
        if(inE2(Q), mi = k; bvec = coefs[s]; bvec[i] += k; break(2))
      )
    );
    if(mi == 0, next);
    listput(basis, bvec);
    S2 = List(); C2 = List();
    for(j = 0, mi-1,
      jP = if(j == 0, [0], ellmul(Ep, P[i], j));
      for(s = 1, #S,
        Q = if(j == 0, S[s], if(S[s] == [0], jP, elladd(Ep, jP, S[s])));
        cc = coefs[s]; cc[i] += j;
        listput(S2, Q); listput(C2, cc)
      )
    );
    S = Vec(S2); coefs = Vec(C2); idx *= mi
  );
  if(idx != M, return(0));
  for(i = 1, #basis,
    b = basis[i]; Q = [0];
    for(j = 1, r,
      if(b[j] != 0, T = ellmul(Ep, P[j], b[j]); Q = if(Q == [0], T, elladd(Ep, Q, T)))
    );
    if(Q != [0] && valuation(Q[1],2) == -4, return(1))
  );
  0;
}

report2(A, B, D) = {
  my(w = vector(8, i, 0), d, td, k, nf, n, sg);
  for(n = 1, D,
    if(!issquarefree(n), next);
    for(sg = 0, 1,
      d = if(sg == 0, n, -n);
      k = sqclass2(d);
      if(w[k+1] != 0, next);
      td = twistdata(A, B, d);
      if(#td[2] == 0, next);
      if(densegroup2(td[1], td[2]),
         w[k+1] = d;
         print("  class [", sqclass2name(k), "] : d = ", d, "   rank in [",td[3],",",td[4],"]",
               "   M2 = ", M2val(td[1])))
    )
  );
  nf = 0; for(k = 1, 8, if(w[k] != 0, nf++));
  print("  p=2 : ", nf, "/8 classes covered   ", w);
}
