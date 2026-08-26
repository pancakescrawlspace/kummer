\\ j0-wide.gp --- the widened p = 2 search for kummer-example-j0.typ
\\
\\ At p = 2 a twist can only be dense if its rank is >= 2 (section 6 of the
\\ document), so the search is for d with rk E_d >= 2 AND rk E'_d >= 2.
\\ Root numbers are cheap and cut ~3/4 of the candidates before ellrank runs.
\\
\\ Run as:  gp -q -s 8000000000 j0-wide.gp

read("p2.gp");
Ed(d)  = ellinit([0,0,0,0,  9*d^3]);
Epd(d) = ellinit([0,0,0,0,-81*d^3]);
{gens(E) = my(r = ellrank(E), P = r[4]);
  if(#P == 0 && r[1] == 1, P = [ellheegner(E)]);
  if(#P == 0, [], ellsaturation(E,P,40));}
{allpts(E) = concat(gens(E), elltors(E)[3]);}
{dense2(E) = my(v, Em = ellminimalmodel(E,&v),
                P = apply(Q -> ellchangepoint(Q,v), allpts(E)));
  if(#P == 0, 0, densegroup2(Em,P));}

{wide(B) =
  my(nm = ["1","3","5","7","2","6","10","14"], wit = vector(8), cand = 0, r2 = 0);
  print("d with rank >= 2 on both curves, and whether each is dense at 2:");
  for(a = 1, B, foreach([a,-a], d,
    if(core(abs(d)) != abs(d), next);
    my(E = Ed(d), F = Epd(d));
    if(ellrootno(E) != 1 || ellrootno(F) != 1, next);      \\ cheap parity filter
    cand++;
    if(ellrank(E)[1] < 2, next);
    if(ellrank(F)[1] < 2, next);
    r2++;
    my(k = sqclass2(d) + 1, x = dense2(E), y = dense2(F));
    printf("  d = %6d  class [%-2s]  E_d dense %d  E'_d dense %d %s\n",
       d, nm[k], x, y, if(x && y, "   <== WITNESS", ""));
    if(x && y && wit[k] == 0, wit[k] = d)));
  printf("\n|d| <= %d : %d passed the root-number filter, %d had rank >= 2 on both\n",
     B, cand, r2);
  print("witnesses by square class at 2:");
  for(k = 1, 8, printf("  [%-2s] : %s\n", nm[k],
     if(wit[k], Str("d = ", wit[k]), "none")));}

{oddscan(B) =
  my(nm = ["1","3","5","7"], wit = vector(4), cand = 0, r2 = 0);
  print("odd d only (the even classes are blocked by parity, see the note below):");
  for(a = 1, B, foreach([a,-a], d,
    if(d % 2 == 0 || core(abs(d)) != abs(d), next);
    my(E = Ed(d), F = Epd(d));
    if(ellrootno(E) != 1 || ellrootno(F) != 1, next);
    cand++;
    if(ellrank(E)[1] < 2, next);
    if(ellrank(F)[1] < 2, next);
    r2++;
    my(k = sqclass2(d) + 1, x = dense2(E), y = dense2(F));
    if(x && y,
      printf("  d = %6d  class [%-2s]  WITNESS\n", d, nm[k]);
      if(wit[k] == 0, wit[k] = d),
      printf("  d = %6d  class [%-2s]  dense %d / %d\n", d, nm[k], x, y))));
  printf("\n|d| <= %d, odd : %d passed root-number filter, %d rank >= 2 on both\n", B, cand, r2);
  for(k = 1, 4, printf("  [%-2s] : %s\n", nm[k],
     if(wit[k], Str("d = ", wit[k]), "none")));}

oddscan(6000);
quit
