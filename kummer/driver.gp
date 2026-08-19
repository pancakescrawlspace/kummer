read("kummer2.gp");

/* precompute MW data for all squarefree d with |d| <= D */
build(A, B, D) = {
  my(L = List(), d, td);
  for(n = 1, D,
    if(!issquarefree(n), next);
    for(sg = 0, 1,
      d = if(sg == 0, n, -n);
      td = twistdata(A, B, d);
      listput(L, [d, td[1], td[2], td[3], td[4]])
    )
  );
  Vec(L);
}

report(A, B, data, PMAX) = {
  my(prs = primes([3,PMAX]), good = List(), p, w, k, nf, i, j);
  print("f(x) = x^3 + (", A, ")x + (", B, ")");
  for(j = 1, #prs,
    p = prs[j];
    w = vector(4, i, 0);
    for(i = 1, #data,
      k = sqclass(data[i][1], p);
      if(w[k+1] != 0, next);
      if(densegroup(data[i][2], data[i][3], p), w[k+1] = data[i][1])
    );
    nf = 0; for(k = 1, 4, if(w[k] != 0, nf++));
    if(nf == 4,
      listput(good, p);
      print("  p=", p, "  OK   d: [1]=", w[1], "  [u]=", w[2], "  [", p, "]=", w[3], "  [u", p, "]=", w[4])
    ,
      print("  p=", p, "  ", nf, "/4   ", w)
    )
  );
  print("GOOD PRIMES: ", Vec(good));
  print("count = ", #good, " out of ", #prs);
  Vec(good);
}

/* targeted search: one square class at a time, used for the stubborn cases
   (e.g. f=x^3+x+1 at p=131,149; f=x^3-2 at p=3).  target = 0,1,2,3 as in sqclass. */
hunt(A, B, p, target, DMAX) = {
  my(d, td, n, sg);
  for(n = 1, DMAX,
    if(!issquarefree(n), next);
    for(sg = 0, 1,
      d = if(sg == 0, n, -n);
      if(sqclass(d, p) != target, next);
      td = twistdata(A, B, d);
      if(#td[2] == 0, next);
      if(densegroup(td[1], td[2], p),
        print("  p=", p, " class ", sqclassname(target,p), ": d=", d,
              "  rank in [", td[3], ",", td[4], "]  gens=", td[2]);
        return(d))
    )
  );
  print("  p=", p, " class ", sqclassname(target,p), ": NOT FOUND up to |d|=", DMAX);
  0;
}
