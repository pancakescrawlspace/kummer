\\ coupling.gp -- does the l-primary reduction of section 3.5.1 survive in the
\\ S-adic case, where a square class may need SEVERAL twists?  Run from here:
\\     gp -q -s 2000000000 coupling.gp < /dev/null > results/coupling.txt
\\
\\ THE QUESTION.  Section 3.5.1 decides density at one place by
\\        R = G   <=>   R --> G/lG onto for every l,
\\ one l at a time.  In the S-adic case the object to be exhausted is not a
\\ single reach but a UNION,  U = union_d R(d) x R(d)  inside G x G, and a union
\\ of subgroups is not a subgroup.  Does the l-by-l reduction still decide it?
\\
\\ ANSWER: no, and for TWO independent reasons.  What survives is stated at the
\\ end.  Both failures are exhibited below on groups small enough to check by
\\ hand, because both are about the shape of the argument and not about size.
\\
\\ WHAT IS STILL VALID, and is worth separating off first.  A closed subgroup of
\\ a profinite abelian group is the product of its l-primary parts:
\\ G = prod_l G_l with G_l the pro-l Sylow, and any closed R is itself profinite
\\ abelian, so R = prod_l R_l with R_l = R cap G_l.  Hence for a FIXED R,
\\        <a,b> subset R   <=>   <a_l,b_l> subset R_l  for every l,
\\ exactly.  So the decomposition of each individual CONTAINMENT is sound; it is
\\ the two steps beyond that which fail.

subgrp(gens, G) =
{ my(S = Set([0]));
  for (i = 1, 2*G,
    my(T = List(Vec(S)));
    foreach (Vec(S), x, foreach (gens, g, listput(T, (x+g) % G)));
    my(S2 = Set(Vec(T))); if (S2 == S, break); S = S2);
  S;
}
print("=========================================================================");
print(" Does the l-primary reduction survive a UNION of reaches?");
print("=========================================================================");
print("");
print("-------------------------------------------------------------------------");
print(" Failure 1.  MEMBERSHIP is not a mod-l condition.");
print("-------------------------------------------------------------------------");
print(" Frattini decides whether a subgroup is EVERYTHING.  Coverage asks");
print(" whether particular ELEMENTS lie in it, and mod l one sees only R + lG:");
print("        abar in Rbar  in G/lG   <=>   a in R + lG,");
print(" which is in general strictly bigger than R.  Take G = Z/4, R = 0, a = 2.");
{
my(G = 4, R = Set([0]), a = 2, l = 2, RlG = List());
foreach (Vec(R), x, for (k = 0, G-1, listput(RlG, (x + l*k) % G)));
print("   a in R ?                      ", setsearch(R, a) > 0);
print("   a mod l                       ", a % l);
print("   image of R in G/lG            ", Set([x % l | x <- Vec(R)]));
print("   R + lG                        ", Set(Vec(RlG)));
print("   => the mod-l test PASSES on an a that is not in R.");
}
print("");
print(" This one already rules out transplanting section 3.5.1 verbatim: there");
print(" the mod-l quotient was enough because the question was 'is R all of G',");
print(" and Frattini answers exactly that.  Coverage is a different question.");
print("");
print("-------------------------------------------------------------------------");
print(" Failure 2.  The EXISTENTIAL does not commute with the layers.");
print("-------------------------------------------------------------------------");
print(" Coverage is    for all (a,b),  EXISTS R,  for all l : <a_l,b_l> in R_l.");
print(" Checking layer by layer proves the weaker");
print("                for all (a,b),  for all l,  EXISTS R : <a_l,b_l> in R_l,");
print(" and the entry that works may DIFFER from layer to layer.  Smallest");
print(" instance: G = Z/6 with the two entries <3> and <2>.");
{
my(G = 6, L = [subgrp([3],G), subgrp([2],G)], bad = List());
print("   R_1 = ", L[1], "   R_2 = ", L[2]);
for (a = 0, G-1, for (b = 0, G-1,
  my(H = subgrp([a,b], G), ok = 0);
  foreach (L, R, if (#setminus(H, R) == 0, ok = 1; break));
  if (!ok, listput(bad, [a,b]))));
print("   ordered pairs covered by no single entry : ", #Vec(bad),
      " of ", G^2, ",  e.g. ", Vec(bad)[1], " and ", Vec(bad)[2]);
foreach ([2,3], l,
  my(c = G / l^valuation(G,l), Gl = Set([(c*x) % G | x <- [0..G-1]]), okall = 1, wit = 0);
  foreach (Vec(Gl), a, foreach (Vec(Gl), b,
    my(H = subgrp([a,b], G), ok = 0);
    for (i = 1, #L, if (#setminus(H, setintersect(L[i], Gl)) == 0, ok = 1; wit = i; break));
    if (!ok, okall = 0)));
  print("   layer l = ", l, " : G_l = ", Vec(Gl), "   covered layerwise: ", okall,
        "   (always by R_", wit, ")"));
print("   => EVERY layer is covered and the group is NOT.  Layer 2 is covered");
print("      only by R_1 and layer 3 only by R_2, so no single entry does both.");
}
print("");
print("-------------------------------------------------------------------------");
print(" What survives, and what the ledger actually does");
print("-------------------------------------------------------------------------");
print(" The repair is not to drop the decomposition but to stop quantifying");
print(" inside it.  For each layer l and each subgroup H of G_l on at most two");
print(" generators put the MASK  m_l(H) = { R in L : H subset R_l }, a subset of");
print(" the ledger.  Then, by the exactness of the primary decomposition,");
print("        (a,b) is covered  <=>  intersection over l of m_l(<a_l,b_l>) is");
print("                                nonempty,");
print(" so coverage holds iff no choice of one mask per layer has empty");
print(" intersection.  The layers are still used -- containment is tested in");
print(" them -- but the existential is resolved once, at the end, over the small");
print(" finite set L.  That is the star test of section 2.3.4.");
print("");
print(" On Failure 2 the mask test gives the right answer:");
{
my(G = 6, L = [subgrp([3],G), subgrp([2],G)], masks = List());
foreach ([2,3], l,
  my(c = G / l^valuation(G,l), Gl = Set([(c*x) % G | x <- [0..G-1]]), ml = List());
  foreach (Vec(Gl), a, foreach (Vec(Gl), b,
    my(H = subgrp([a,b], G), m = List());
    for (i = 1, #L, if (#setminus(H, setintersect(L[i], Gl)) == 0, listput(m, i)));
    listput(ml, Set(Vec(m)))));
  listput(masks, Set(Vec(ml))));
masks = Vec(masks);
print("   masks at l = 2 : ", Vec(masks[1]));
print("   masks at l = 3 : ", Vec(masks[2]));
my(bad = 0);
foreach (Vec(masks[1]), m1, foreach (Vec(masks[2]), m2,
  if (#setintersect(m1, m2) == 0, bad++)));
print("   mask pairs with empty intersection : ", bad,
      "   => NOT covered, correctly");
}
print("");
print("-------------------------------------------------------------------------");
print(" Why the coupling has never yet bitten, which is data and not a theorem");
print("-------------------------------------------------------------------------");
print(" Every reach in every ledger computed in this document has index 1 or 2");
print(" in its arena (66 of index 2, 14 of index 1, none other).  An index-2");
print(" reach is full at every layer except l = 2, so all layers l != 2 return");
print(" the single full mask and cannot constrain the intersection: the whole");
print(" question collapses onto l = 2 and the coupling is vacuous.  That is why");
print(" the prototype in section 2.3.4 reproduced the flat verdict exactly.");
print(" It would stop being vacuous the moment one tuple carried, say, an");
print(" index-2 reach alongside an index-3 one -- precisely the shape of");
print(" Failure 2.  Nothing forbids that; it just has not occurred yet.");
print("");
print("done.");
