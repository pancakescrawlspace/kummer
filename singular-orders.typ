#set page(paper: "a4", margin: (x: 2.0cm, y: 2.2cm), numbering: "1")
#set text(font: "New Computer Modern", size: 10.5pt)
#set par(justify: true)
#set heading(numbering: "1.")
#show link: set text(fill: blue.darken(20%))
#show raw.where(block: true): it => block(
  fill: luma(247), inset: 8pt, radius: 3pt, width: 100%, breakable: true,
  text(size: 8pt, it),
)

#align(center)[
  #text(size: 16pt, weight: "bold")[Singular number rings are singular curves]
  #v(2mm)
  #text(size: 10pt)[Nodes, cusps, blow-ups and generalised Jacobians, on the arithmetic side]
  #v(1mm)
  #text(size: 9pt, style: "italic")[a question of René Pannekoek's; checks in `singular-orders.gp`]
]

#v(4mm)

#block(fill: luma(240), inset: 9pt, radius: 3pt, width: 100%)[
  *Summary.* For an order $R subset.neq cal(O)_K$, the inclusion $R arrow.hook cal(O)_K$ is not
  *like* a resolution of singularities --- it *is* one (@sec-same). The conductor cuts out the
  singular locus and $delta$ is the $delta$-invariant. In the quadratic case the dictionary is
  exact: at $p divides f$, the order $cal(O)_f$ has a *node*, a *non-split node* or a *cusp*
  according as $p$ splits, is inert, or ramifies (@sec-nodecusp) --- and in the ramified case the
  value semigroup is literally $⟨2,3⟩$, that of $k[[t^2,t^3]]$. The tower
  $cal(O)_f subset cal(O)_(f slash p) subset dots.c subset cal(O)_K$ *is* the sequence of blow-ups
  (@sec-blowup). The analogy is sharpest at @sec-jacobian: the local factors of the class number
  formula are the point counts $p-1$, $p+1$, $p$ of $bb(G)_m$, a non-split torus and $bb(G)_a$ ---
  the three groups appearing in the generalised Jacobian of a curve acquiring a node, a non-split
  node or a cusp. Which is the same trichotomy as split multiplicative, non-split multiplicative and
  additive reduction of an elliptic curve, verified side by side in check 6.
]

= It is not an analogy <sec-same>

$cal(O)_K$ is by definition the integral closure of $R$ in $K$, so
$ "Spec" cal(O)_K --> "Spec" R $
*is* the normalisation morphism, and both schemes have dimension one, where normalisation is already
resolution. Nothing has to be transported from geometry; the two statements coincide.

What localises the singularity is the *conductor*
$ frak(f) = {x in K : x cal(O)_K subset.eq R} , $
the largest $cal(O)_K$-ideal contained in $R$: the singular points of $"Spec" R$ are exactly the
primes containing $frak(f)$, exactly as the conductor ideal of a curve cuts out its non-normal
locus. The local measure is the same $delta$-invariant,
$ delta_frak(p) = "length"_(R_frak(p)) (tilde(R)_frak(p) slash R_frak(p)) , wide
  [cal(O)_K : R] = product_frak(p) abs(k(frak(p)))^(delta_frak(p)) . $

Check 1 exhibits this for $R = ZZ[alpha]$, where $frak(f) = (f'(alpha)) frak(d)^(-1)$: the index and
the conductor have the same prime support in every case, and $N(frak(f)) = [cal(O)_K : ZZ[alpha]]^2$
--- a Gorenstein statement we return to in @sec-gor. It also confirms Stevenhagen's observation that
$R$ singular above $p$ forces $p^2 divides "disc"(R)$.

= Nodes and cusps <sec-nodecusp>

Let $K$ be quadratic, $R = cal(O)_f = ZZ + f cal(O)_K$, and $p divides.not f slash p$, so
$delta_p = 1$. Then $R_p = ZZ_p + p cal(O)_(K,p)$, and the splitting of $p$ decides the type. Recall
that a node has *two* branches and a cusp *one*; that is the distinction.

#align(center, table(
  columns: 4, align: (left, left, center, left),
  stroke: 0.4pt + luma(170), inset: (x: 9pt, y: 4pt),
  table.header([$p$ in $K$], [$R_p subset cal(O)_(K,p)$], [branches], [type]),
  [split], [${(a,b) in ZZ_p times ZZ_p : a equiv b thin (p)}$], [$2$], [*node* $(A_1)$],
  [inert], [$ZZ_p + p W$, $W$ unram. quadratic], [$2$, conjugate], [*non-split node*],
  [ramified], [$ZZ_p + p ZZ_p [pi]$, $pi^2 = p u$], [$1$], [*cusp* $(A_2)$],
))

#v(2mm)
The split case is two copies of $ZZ_p$ glued along their closed points --- the local ring of a node,
$k[x,y] slash (x y)$. The inert case has one prime above $p$ but two branches conjugate over
$overline(FF)_p$: the arithmetic of $x^2 + y^2 = 0$ over $RR$. Check 2 confirms the dictionary at
$60$ pairs $(D,p)$, matching the branch count against the splitting type in every case.

The ramified case is worth computing, because it comes out on the nose. Normalise $v = v_pi$ so
$v(pi) = 1$. A $ZZ$-basis of $R$ is ${1, p omega}$, and $v(ZZ without 0)$ is even while
$v(p omega ZZ without 0)$ is odd and $>= 3$, so

$ v(R_p without 0) = {0, 2, 3, 4, 5, dots} = ⟨2,3⟩ , $

the value semigroup of $k[[t^2, t^3]]$ --- the cusp, with the single gap at $1$ accounting for
$delta = 1$. Check 3 computes this semigroup directly from `idealval` at nine ramified pairs, and
finds the gap set ${1}$ every time.

#block(fill: rgb("#fff4e6"), inset: 8pt, radius: 3pt, width: 100%)[
  *A trap the script fell into.* Enumerating elements $a + b p omega$ over a small box
  $abs(a), abs(b) <= 12$ produces *spurious* gaps: attaining valuation $2k$ needs $p^k divides a$,
  so at $D = -20$, $p = 5$ the value $4$ requires $a = 25$ and simply never appears. The first run
  reported gaps ${1,4,6,7,8}$ and looked like a refutation. Check 3 now enumerates by $p$-power
  rather than by size.
]

= The tower of orders is the blow-up sequence <sec-blowup>

For a one-dimensional Noetherian local domain with finite normalisation, blowing up the maximal
ideal gives
$ A_1 = union.big_n (frak(m)^(n+1) : frak(m)^n) , $
equal to $A[frak(m) slash x]$ for a minimal reduction $x$, and to $"End"_A (frak(m)) =
(frak(m) : frak(m))$ in the Gorenstein case; $A_1 = A$ iff $A$ is a DVR, and the chain terminates at
$tilde(A)$. So normalisation *is* a finite sequence of blow-ups, as for curves.

For quadratic orders this reproduces the conductor tower. The singular prime of $cal(O)_f$ above
$p divides f$ is $frak(m) = p ZZ + f cal(O)_K$, and check 4 computes
$(frak(m) : frak(m))$ directly, as the largest $f' divides f$ with
$cal(O)_(f') frak(m) subset.eq frak(m)$:

#align(center, table(
  columns: 5, align: (center, center, center, center, center),
  stroke: 0.4pt + luma(170), inset: (x: 9pt, y: 3.5pt),
  table.header([$f$], [$2$], [$4$], [$8$], [$12$]),
  [$(frak(m):frak(m))$ at $2$], [$cal(O)_1$], [$cal(O)_2$], [$cal(O)_4$], [$cal(O)_6$],
  [steps to $cal(O)_K$], [$1$], [$2$], [$3$], [$3$],
))

#v(2mm)
Every blow-up climbs exactly one prime, $cal(O)_f -> cal(O)_(f slash p)$, and iterating reaches
$cal(O)_K$. For $delta = 1$ --- node or cusp --- a single blow-up resolves, as it must: there
$frak(m) = p cal(O)_K$ is already an $cal(O)_K$-module, so $(frak(m):frak(m)) = cal(O)_K$ at once.

= The sharpest point: generalised Jacobians <sec-jacobian>

The Picard sequence is identical on the two sides. For $R subset cal(O)_K$ with conductor $frak(f)$,
$ 1 -> R^times -> cal(O)_K^times -> (cal(O)_K slash frak(f))^times slash (R slash frak(f))^times
  -> "Pic"(R) -> "Pic"(cal(O)_K) -> 1 , $
which is the sequence for a singular curve $C$ with normalisation $tilde(C)$, verbatim. It yields
the class number formula for orders, and the Euler factors are the punchline. For $f = p$ the local
factor is $p - chi(p)$, and

#align(center, table(
  columns: 5, align: (left, center, center, center, left),
  stroke: 0.4pt + luma(170), inset: (x: 9pt, y: 4pt),
  table.header([$p$ in $K$], [type], [$p - chi(p)$], [group], [same group as]),
  [split], [node], [$p - 1$], [$bb(G)_m (FF_p)$], [split multiplicative reduction],
  [inert], [non-split node], [$p + 1$], [non-split torus], [non-split multiplicative reduction],
  [ramified], [cusp], [$p$], [$bb(G)_a (FF_p)$], [additive reduction],
))

#v(2mm)
These are exactly the three affine groups that appear as the extra part of the *generalised
Jacobian* of a curve acquiring a node, a non-split node or a cusp. Check 5 verifies both sides at
$35$ pairs $(D,p)$: the factor equals $abs((cal(O)_K slash p)^times) slash abs((ZZ slash p)^times)$
read off the Picard sequence, *and* the resulting $h(cal(O)_p)$ agrees with `quadclassunit` in every
case.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *The same trichotomy you already work with.* A singular Weierstrass cubic is a nodal or cuspidal
  curve, and $hash tilde(E)^"ns" (FF_p) = p - a_p$ is $p-1$, $p+1$, $p$ for split multiplicative,
  non-split multiplicative and additive reduction. Check 6 finds all three at $p = 5$ --- giving
  $4$, $6$, $5$ --- the same three numbers as check 5's local factors at $p = 5$, for the same three
  group schemes. In `plusminus-beta.typ` the fact that $j = 0$ forces additive reduction is, on the
  curve side, the statement that the singular fibre is a *cusp*.
]

= Gorenstein means plane curve <sec-gor>

A one-dimensional ring is Gorenstein exactly when $"length"(tilde(R) slash frak(f)) = 2 delta$, i.e.
$N(frak(f)) = [cal(O)_K : R]^2$. Now $ZZ[alpha] = ZZ[x] slash (f)$ is a *hypersurface*, so it is
always Gorenstein --- the arithmetic counterpart of a *plane* curve singularity. Non-monogenic
orders are the space curves, and need not be.

The cleanest failure is $R = ZZ + p cal(O)_K$ in degree $n$: the index is $p^(n-1)$ and the
conductor is $p cal(O)_K$ of norm $p^n$, so $R$ is Gorenstein *only* for $n = 2$. In degree $3$ with
$p$ split completely, $R_p = {(a,b,c) in ZZ_p^3 : a equiv b equiv c thin (p)}$ is the arithmetic of
the *three coordinate axes in $3$-space*: $delta = 2$, conductor of length $3 eq.not 4$, not
Gorenstein. (Three *concurrent lines in a plane* is a different singularity --- $delta = 3$, and
Gorenstein.) Check 7 confirms both halves.

= What this connects to in this repository <sec-repo>

`kummer-dedekind.typ` is the smoothness criterion in disguise: Kummer--Dedekind applies to
$ZZ[alpha]$ exactly when $p divides.not [cal(O)_K : ZZ[alpha]]$, i.e. exactly when
$"Spec" ZZ[alpha]$ is *regular* above $p$. The failure of Kummer--Dedekind *is* the singularity, and
@sec-same measures it.

`dirichlet-rank-one.typ` supplies the unit group $R^times$ on the left of the sequence of
@sec-jacobian --- the term whose index in $cal(O)_K^times$ is the only part of the class number
formula not accounted for by a point count.

= What the companion script checks <sec-gp>

`singular-orders.gp`, results in `results/singular-orders.txt`; $0$ failed assertions.

#v(1mm)
- *(1)* Index, conductor and singular locus of $ZZ[alpha]$ for $13$ polynomials of degree $2$ to
  $4$: same prime support, $N(frak(f)) = "index"^2$, and $p^2 divides "disc"$ at every singular $p$.
- *(2)* The node / non-split node / cusp dictionary at $60$ pairs $(D,p)$, branch counts included.
- *(3)* The value semigroup at a ramified $p$ is $⟨2,3⟩$, gap set ${1}$, at nine pairs.
- *(4)* $(frak(m):frak(m))$ computed directly: every blow-up climbs one prime, and the tower reaches
  $cal(O)_K$.
- *(5)* $p - chi(p)$ against the Picard ratio and against `quadclassunit`, at $35$ pairs.
- *(6)* $hash tilde(E)^"ns"(FF_p) = p - a_p$ for all three reduction types at $p = 5$: $4$, $6$, $5$.
- *(7)* Gorenstein $arrow.l.r.double$ $N(frak(f)) = "index"^2$: monogenic orders always; $ZZ + p cal(O)_K$
  only in degree $2$.

= References <sec-refs>

#block(inset: (left: 4pt))[
#set enum(numbering: "[1]")
+ P. Stevenhagen, *The arithmetic of number rings*, in Algorithmic Number Theory, MSRI Publications
  $44$ ($2008$), $209$--$266$. Deliberately avoids assuming integral closure, and uses the language
  "$R$ is singular above $p$"; proves that singularity above $p$ forces $p^2 divides Delta(R)$.
  The closest reference to this note.
+ J. Neukirch, *Algebraic Number Theory*, Ch. I §12 (Orders) and §13 (One-dimensional Schemes).
  Where orders are given their scheme-theoretic treatment.
+ J. Lipman, *Stable ideals and Arf rings*, Amer. J. Math. $93$ ($1971$), $649$--$685$. Blow-ups of
  one-dimensional local rings, multiplicity sequences and the Arf closure --- the general theory
  behind @sec-blowup, going back to Arf ($1948$).
+ J.-P. Serre, *Algebraic Groups and Class Fields*. Generalised Jacobians of singular curves, and
  the $bb(G)_m$ / torus / $bb(G)_a$ trichotomy of @sec-jacobian on the geometric side.
+ D. Cox, *Primes of the Form $x^2 + n y^2$*, §7. Quadratic orders, the conductor, the class number
  formula and ring class fields.
+ G.-M. Greuel, C. Lossen and E. Shustin, *Introduction to Singularities and Deformations*. The
  $delta$-invariant, blow-ups and the classification of curve singularities on the geometric side.
+ V. Barucci, D. Dobbs and M. Fontana, *Maximality properties in numerical semigroups and
  applications to one-dimensional analytically irreducible local domains*, Memoirs AMS $598$
  ($1997$). Value semigroups, symmetry and Gorenstein.
+ `kummer-dedekind.typ` and `dirichlet-rank-one.typ` in this repository --- see @sec-repo.
]
