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
  #text(size: 16pt, weight: "bold")[Non-density as a Brauer--Manin obstruction]
  #v(2mm)
  #text(size: 10pt)[Why $E(QQ)$ misses an open set of $E(QQ_p)$: the local Tate
  pairing and reciprocity, carried by an explicit quaternion algebra on $E$ ---
  and the exact point where quaternion algebras run out]
  #v(1mm)
  #text(size: 9pt, style: "italic")[companion to `ec-padic-closure.typ` and `integral-bm.typ`;
  checked in `ec-density-bm.gp`, output in `results/ec-density-bm.txt`]
]

#v(4mm)

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *Yes --- and the two are one argument.* On an elliptic curve the Brauer--Manin pairing *is* the
  sum over places of the local Tate duality pairing, and reciprocity is global duality. Made
  explicit through a $2$-isogeny it becomes a Hilbert symbol. On
  $ E : y^2 = x^3 - 2 x^2 + 2 x quad ("conductor" 128, "rank" 1) , $
  the quaternion algebra $cal(A) = (7, x) in "Br"(E)$ has $"inv"_v cal(A) = 0$ at every place
  $v != 7$ and every local point; Hilbert reciprocity then forces $"inv"_7 cal(A) = 0$ at every
  *rational* point. But $"inv"_7 cal(A) = 1 slash 2$ at the point of $E(QQ_7)$ with $x = 3$. That
  open set contains no rational point --- which is exactly the index-$2$ non-density at $p = 7$.
]

= The general statement <sec-general>

Let $E slash QQ$ be an elliptic curve. Because $E$ has a rational point,
$ "Br"_1 (E) slash "Br"_0 (E) tilde.equiv H^1 (QQ, "Pic" overline(E)) tilde.equiv H^1 (QQ, E) , $
the Weil--Châtelet group. For $beta in H^1(QQ, E)$ with associated Brauer class $cal(A)_beta$,
the invariant at a local point is the *local Tate duality pairing*
$ "inv"_v cal(A)_beta (Q_v) = ⟨Q_v, beta_v⟩_v , quad
  ⟨ , ⟩_v : E(QQ_v) times H^1 (QQ_v, E) --> QQ slash ZZ , $
a perfect pairing of a profinite group with a discrete torsion one. The Brauer--Manin condition
$sum_v "inv"_v = 0$ is then literally
$ sum_v ⟨Q_v, beta_v⟩_v = 0 , $
which for a *global* point is the Poitou--Tate/Cassels global duality relation. So the two
phrasings in the question are the same argument in two notations.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Manin's theorem.* If $Ш(E)$ is finite, then the Brauer--Manin set of $E$ is *exactly* the
  closure of $E(QQ)$ in the adelic points:
  $ E(bold(A)_QQ)_bullet^"Br" = overline(E(QQ)) . $
  So every failure of density --- at one place or adelically --- is a Brauer--Manin obstruction,
  and nothing else is. Both curves below have analytic rank $1$ (checked with
  `ellanalyticrank`), so Gross--Zagier and Kolyvagin make $Ш$ finite and the theorem applies to
  them unconditionally.
]

That settles the question in principle. The content is in *exhibiting the class*, and for that
one wants an isogeny.

== The pairing as a Hilbert symbol <sec-hilbert>

Take $E : y^2 = x(x^2 + a x + b)$ with the rational $2$-torsion point $T = (0,0)$, and let
$phi : E -> E'$ be the $2$-isogeny with kernel $⟨T⟩$. The descent map
$ E(QQ_v) slash hat(phi) E'(QQ_v) arrow.r.hook QQ_v^times slash (QQ_v^times)^2 , quad
  Q |-> x(Q) quad (T |-> b, O |-> 1) $
is injective, and the Tate pairing against the dual class $d in QQ_v^times slash (QQ_v^times)^2$
is the Hilbert symbol:
$ ⟨Q, d⟩_v = 1/2 (d, x(Q))_v . $

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *The Brauer class.* $cal(A)_d = (d, x)$, a quaternion algebra over $QQ(E)$. It is
  *unramified* on $E$: for a constant $d$ the tame symbol is
  $partial_Q (d, f) = overline(d)^(v_Q (f))$, and
  $ "div"(x) = 2 (T) - 2 (O) $
  has even multiplicities everywhere --- $x$ has a double zero at the $2$-torsion point $T$ and a
  double pole at $O$. So every residue is trivial and $cal(A)_d in "Br"(E)$.
]

Reciprocity for this class is Hilbert reciprocity, $product_v (d, x(Q))_v = 1$. The recipe is
therefore: *find $d$ such that $(d, x)_v$ is identically $+1$ on $E(QQ_v)$ for every $v != p$,
and not identically $+1$ on $E(QQ_p)$.*

Two of the places are free, for reasons visible in the equation:

- *The real place.* If $a^2 - 4 b < 0$ then $x^2 + a x + b > 0$, so $y^2 = x dot ("positive")$
  forces $x >= 0$ at every real point. Then $(d, x)_infinity = +1$ for *every* $d$.
- *Odd $v$ of good reduction.* Every point has $v_v (x)$ even: if $v_v (x) > 0$ then
  $x^2 + a x + b equiv b$ is a unit (good reduction at an odd $v$ forces $v divides.not b$, since
  $v divides b$ would divide the discriminant $16 b^2 (a^2 - 4b)$), so $v_v (y^2) = v_v (x)$; and
  $v_v (x) < 0$ gives $x = A slash C^2$. So the local image consists of *unit* classes, and the
  Hilbert symbol of two units at an odd place is trivial whenever $d$ is a $v$-adic unit.

What is left is $v = 2$, the odd bad primes, and the primes dividing $d$ --- a finite check.

= Case 1: good reduction, conductor $128$ at $p = 7$ <sec-128>

$ E : y^2 = x^3 - 2 x^2 + 2 x , quad Delta = -256 , quad "rank" 1 , quad
E(QQ) = ⟨(1,1)⟩ ⊕ ⟨(0,0)⟩ tilde.equiv ZZ ⊕ ZZ slash 2 . $
At $p = 7$ the reduction is good with $E(FF_7) tilde.equiv ZZ slash 12$, and the filtration
method of `ec-padic-closure.typ` gives closure index $2$. Take $d = 7$, so $cal(A) = (7, x)$.

#align(center)[
#table(columns: 3, align: (left, center, left), stroke: 0.4pt, inset: 6pt,
  [place], [$"inv"_v cal(A)$], [why],
  [$v = infinity$], [$0$], [$x^2 - 2x + 2 = (x-1)^2 + 1 > 0$, so $x >= 0$ on $E(RR)$],
  [odd $v != 7$], [$0$], [$v_v (x)$ even, and $7$ is a $v$-adic unit],
  [$v = 2$], [$0$], [checked on $61$ representatives of the local image],
  [$v = 7$], [*varies*], [$(7, x)_7 = (x/7)$, and the image contains non-residues],
)]

So for $Q in E(QQ)$ all terms but $v = 7$ vanish, and $product_v (7, x(Q))_v = 1$ forces
$(7, x(Q))_7 = +1$. Verified directly on $n G$ and $n G + T$ for $n <= 8$: the invariant is $0$
at every place and the product is $1$, as it must be.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *And the class is not constant at $7$.* Take $x = 3$: then
  $x (x^2 - 2x + 2) = 3 dot 5 = 15$, which is a square in $QQ_7$ (it is a unit and
  $15 equiv 1 mod 7$). So $E(QQ_7)$ contains a point with $x = 3$, and
  $ (7, 3)_7 = (3/7) = -1 quad "since" 3 "is a non-residue mod" 7 . $
  Its $7$-adic neighbourhood contains no rational point at all. Since $Q |-> (7, x(Q))_7$ is a
  homomorphism $E(QQ_7) -> {plus.minus 1}$ and is onto, its kernel has index exactly $2$ ---
  matching the index computed from the filtration. *The Brauer class explains the whole failure.*
]

= Case 2: bad reduction, conductor $960$ at $p = 3$ <sec-960>

$ E : y^2 = x^3 - 4 x^2 + 9 x , quad Delta = -25920 = -2^6 dot 3^4 dot 5 , quad
"rank" 1 , quad E(QQ) = ⟨(4,6)⟩ ⊕ ⟨(0,0)⟩ . $
At $p = 3$ the reduction is *bad*, of type $I_4$, non-split ($a_3 = -1$), with $c_3 = 2$ and
$|E(QQ_3) slash E_1 (QQ_3)| = c_3 (p - a_p) = 8$; the closure has index $2$. The singular point
of the reduction mod $3$ is $(0,0)$, which is the $2$-torsion point --- so here $T in.not E_0(QQ_3)$,
the image in the component group is full, and the failure sits in the torus layer
$E_0 slash E_1$.

Take $d = 3$, so $cal(A) = (3, x)$. The same four lines run: $x^2 - 4x + 9$ has discriminant
$-20 < 0$ so $x >= 0$ on $E(RR)$; odd $v != 3$ contribute nothing; $v = 2$ is checked directly;
and at $v = 3$ the symbol $(3, x)_3 = (x/3)$ varies. The point of $E(QQ_3)$ with $x = 2$
has $x(x^2 - 4x + 9) = 10$, a square in $QQ_3$, and $(3, 2)_3 = -1$.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  Nothing in the argument cared whether $p$ was a prime of good or of bad reduction. The Hilbert
  symbol does not know about Kodaira types; it only sees $x(Q)$ modulo squares. The filtration
  picture of `ec-padic-closure.typ` tells you *which layer* fails; the Brauer class tells you
  *why no rational point can be there*, and it is the same class in both cases.
]

= Where quaternion algebras stop <sec-limits>

A class of order $2$ in $"Br"(E)$ cuts out a subgroup of index at most $2$. So the explicit
quaternion story reaches exactly the index-$2$ failures --- and no further:

#align(center)[
#table(columns: 4, align: (left, center, center, left), stroke: 0.4pt, inset: 5pt,
  [curve (conductor)], [$p$], [index], [reachable by a quaternion class?],
  [$y^2+y=x^3-x$ (37)], [$23$], [$2$], [yes],
  [$y^2+y=x^3+x^2$ (43)], [$43$], [$2$], [yes],
  [$y^2+y=x^3-x$ (37)], [$59$], [$4$], [no --- needs order $4$],
  [$y^2+x y+y=x^3+x^2-x$ (89)], [$11$], [$11$], [no --- needs order $11$],
)]

The conductor-$89$ example at $p = 11$ is the sharpest case: there the reduction map
$E(QQ) -> E(FF_11)$ is *surjective* and the failure is one layer deeper, in
$E_1 slash E_2 tilde.equiv FF_11$, with index $11$. No quaternion algebra can see it. Manin's
theorem still applies --- $Ш$ is finite there --- so a Brauer class of order $11$ does the job,
but it is not an algebra one writes down by hand.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *The moral.* Brauer--Manin explains all of it, by Manin's theorem. What the *explicit*
  quaternion construction reaches is the index-$2$ part, which is the reduction layer --- and
  that is no accident: the pairing $⟨Q, d⟩_v = 1/2 (d, x(Q))_v$ is exactly the local pairing of
  $2$-descent, so the classes one can write down are precisely those that $2$-descent already
  sees. Deeper layers need deeper descent.
]

= Does an index-$2$ failure need a $2$-isogeny? No <sec-noisogeny>

@sec-128 and @sec-960 both used a rational $2$-torsion point, and it would be easy to read that
as a hypothesis. It is not one --- and the reading has a clean counterexample, namely the very
first curve of `ec-padic-closure.typ`.

First, the terminology: a $2$-isogeny *defined over $QQ$* is one with Galois-stable kernel of
order $2$, i.e. exactly a rational point of order $2$, i.e. a rational root of the cubic. So the
question is whether an index-$2$ failure forces $E[2](QQ) != 0$.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *What is actually needed* is a class of order $2$ in $"Br"(E)$, equivalently a class in
  $H^1(QQ, E[2])$ --- and full $2$-descent on $E[2]$ exists for *every* elliptic curve. The
  isogeny in @sec-128 was a convenience, not a hypothesis: a rational $2$-torsion point puts the
  descent map into $QQ^times slash (QQ^times)^2$, so the pairing is a Hilbert symbol over $QQ$
  and the Brauer class is a *single quaternion algebra with constant entries*, $(d, x)$.

  With $E[2]$ irreducible one works instead over the cubic étale algebra
  $L = QQ[t] slash (f(t))$, where $E : Y^2 = f(X)$. The descent map is
  $ E(QQ_v) slash 2 arrow.r.hook (L ⊗ QQ_v)^times slash "squares" , quad Q |-> X(Q) - theta , $
  the group of classes is $H^1(QQ, E[2]) = ker(N_(L slash QQ) : L^times slash "sq" -> QQ^times slash "sq")$,
  the local pairing is a product of Hilbert symbols over the places of $L$,
  $ ⟨Q, d⟩_v = 1/2 product_(w | v) (X(Q) - theta, d)_w , $
  and the Brauer class is a *corestriction*,
  $ cal(A)_d = "cor"_(L(E) slash QQ(E)) thin (d, X - theta) . $
  It is still unramified --- $"div"(X - theta) = 2 (T_theta) - 2 (O)$ over $L$ has even
  multiplicities, and corestriction preserves that --- and still of order $2$. It is simply not a
  quaternion algebra over $QQ(E)$ with constant slots.
]

== The counterexample, worked <sec-37bm>

Take the conductor-$37$ curve in short form,
$ E : Y^2 = X^3 - 16 X + 16 , quad (X, Y) = (4x, 8y+4) "on" y^2 + y = x^3 - x . $
Its cubic $t^3 - 16 t + 16$ is irreducible, so $E[2]$ is irreducible with Galois group $S_3$ and
$E$ has no rational $2$-torsion; PARI's `ellisomat` gives isogeny class size $1$, so $E$ admits
*no rational isogeny of any degree*. And yet the closure of $E(QQ)$ in $E(QQ_23)$ has index $2$.

Let $L = QQ(theta)$ with $theta^3 = 16 theta - 16$: totally real, discriminant $148$, class
number $1$. Take
$ d = 1/4 theta^2 - 2 theta - 11 , quad N_(L slash QQ) (d) = 529 = 23^2 . $
The square norm is exactly the condition for $d$ to define a class in $H^1(QQ, E[2])$, and the
ideal $(d)$ is the single prime above $23$ of residue degree $2$ --- so $d$ is a unit away from
$23$, which is what makes all the other places free.

#align(center)[
#table(columns: 3, align: (left, center, left), stroke: 0.4pt, inset: 6pt,
  [place], [$product_(w|v)$], [why],
  [$v = infinity$], [$+1$], [checked on every real point],
  [$v = 2$, $v = 37$], [$+1$], [checked on every local point by scanning $X$],
  [other $v != 23$], [$+1$], [$v_w (X(Q) - theta)$ even and $d$ a unit there],
  [$v = 23$], [*varies*], [$d$ has odd valuation at the degree-$2$ prime],
)]

Reciprocity over $L$ then forces the $v = 23$ factor to be $+1$ at every *rational* point ---
verified on $n P$ for $n <= 8$, $P = (0,4)$ the saturated generator, where all four columns and
the product are $+1$. But at $X = -1$ we get $X^3 - 16 X + 16 = 31 equiv 8 mod 23$, a residue, so
$E(QQ_23)$ has a point with $X = -1$, and there
$ product_(w | 23) (X - theta, d)_w = -1 . $

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  No $2$-isogeny, no rational $2$-torsion, no isogeny at all --- and still an index-$2$
  Brauer--Manin obstruction. The implication that *does* hold runs the other way: a rational
  $2$-isogeny makes the class a single quaternion algebra with constant entries, which is the
  only reason @sec-128 and @sec-960 look as simple as they do. What governs the index-$2$ case is
  $2$-descent, and every curve has that.
]

= Index $4$ and index $11$: what is actually harder <sec-harder>

Every elliptic curve has $n$-descent for every $n$, and the framework is uniform in $n$: the local
conditions $W_v = "im"(E(QQ_v) slash n)$ are maximal isotropic for the cup product
$H^1(QQ_v, E[n])^(times 2) -> H^2(QQ_v, mu_n) = 1/n ZZ slash ZZ$, and reciprocity holds. Manin's
theorem guarantees the classes exist. So *yes, in principle* --- nothing distinguishes $n = 2$
structurally. What separates the cases is explicitness, and it separates them in three stages.

== The order of the class is forced <sec-order>

Both local quotients are *cyclic*:
$ E(QQ_59) slash Gamma tilde.equiv ZZ slash 4 , quad E(QQ_11) slash Gamma tilde.equiv ZZ slash 11 . $
For conductor $37$ at $p = 59$: $E(FF_59) tilde.equiv ZZ slash 52$ is cyclic, $overline(P)$ has
order $13$, and $13 P in E_1 without E_2$, so $Gamma supset.eq E_1$ and the quotient is
$ZZ slash 52$ modulo $ZZ slash 13$. For conductor $89$ at $p = 11$ the quotient is
$E_1 slash E_2$.

A family of classes of order $2$ cuts out a quotient of *exponent* $2$, so it can never produce
$ZZ slash 4$. So index $4$ needs a class of order $4$ and index $11$ one of order $11$ --- you
cannot assemble either from quaternion algebras.

You can, though, get *part* of the index $4$. Since $overline(P)$ has odd order $13$ it lies in
$2 E(FF_59)$, so $2$-descent sees a factor $2$:

#align(center)[
#table(columns: 4, align: (center, center, center, center), stroke: 0.4pt, inset: 5pt,
  [$n$], [$E(FF_59) slash n$], [image of $E(QQ)$], [index seen],
  [$2$], [$ZZ slash 2$], [trivial], [$2$],
  [$4$], [$ZZ slash 4$], [trivial], [$4$],
  [$13, 26, 52$], [$ZZ slash n$], [non-trivial], [$1$],
)]

A quaternion class gets you halfway; the last factor $2$ needs $4$-descent.

== The descent algebra grows <sec-grows>

For $n = 2$ the descent algebra is the *cubic* étale algebra $L = QQ[t] slash (f)$ --- which is
why @sec-37bm fits on a page and could be done with `bnfinit` on a cubic field. For $n = 11$ on
conductor $89$ the $11$-division polynomial has degree $(11^2-1) slash 2 = 60$ and is
*irreducible over $QQ$*, so nothing collapses; $[QQ(E[11]) : QQ]$ is bounded by
$|"GL"_2 (FF_11)| = 13200$. Explicit $n$-descent is practical only for small $n$.

There is also the roots-of-unity bookkeeping: a degree-$n$ cyclic algebra needs $mu_n$, and
$mu_n subset QQ$ only for $n = 2$. For $n > 2$ one builds the class over $QQ(mu_n)$ and
corestricts. Tedious, but not an obstruction.

== Wildness at the place where detection happens <sec-wild>

This is the real wall. The $n$-th norm residue symbol at $v$ is *tame* exactly when
$v divides.not n$.

#align(center)[
#table(columns: 4, align: (center, center, center, left), stroke: 0.4pt, inset: 5pt,
  [case], [$n$], [detection place], [symbol there],
  [@sec-128, @sec-37bm], [$2$], [$7$, $23$], [tame],
  [conductor 37, index 4], [$4$], [$59$], [tame ($59 divides.not 4$)],
  [conductor 89, index 11], [$11$], [$11$], [*wild* --- $n = p$],
)]

For index $4$ the symbol is tame *where the class has to be non-trivial*. It is wild at $v = 2$,
but there one only needs *vanishing*, and that wildness is the classical mod-$8$ kind that every
system implements. For index $11$ the detection place is $11$ and $n = 11$: wild exactly where
the work has to be done.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *And that is structural, not bad luck.* $E_1(QQ_p) tilde.equiv ZZ_p$ is pro-$p$, so *every*
  finite quotient of the formal group is a $p$-group. Cutting $E_1 slash E_2 tilde.equiv ZZ slash p$
  therefore always demands a class of order $p$, evaluated at the place $p$ --- the wild case,
  every time. By contrast $E_0 slash E_1$ has order $p + 1 - a_p$ (good reduction) or
  $p minus.plus 1$ (multiplicative), prime to $p$ except at anomalous primes, so the reduction
  layer lives in the tame world.

  So the filtration $E supset E_0 supset E_1 supset E_2$ of `ec-padic-closure.typ` is *also a
  tame/wild filtration*: the top layers are tame and explicitly reachable, and the formal-group
  layer --- the one whose failure the naive criterion misses --- is exactly the wild one.
]

== The tooling gap, already met in these notes <sec-tooling>

PARI's `nfhilbert` is literally "does $X^2 - a Y^2 - b Z^2 = 0$ have a solution": quadratic only,
no exponent argument. Sage's `hilbert_symbol` is the same. Neither has an $n$-th norm residue
symbol for $n > 2$. `descent-s3.typ` in this directory already hit precisely this wall --- it
needed a *cubic* norm-residue symbol at the wild place $v = 3$, and recorded that neither system
provides one. The index-$11$ case is the same gap one prime up.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Summary.* Index $4$ is harder than index $2$ only in bookkeeping: the class exists, the symbol
  is tame where it matters, and $4$-descent is implemented in practice. Index $11$ is harder in
  kind: it needs an order-$11$ class over a torsion field of degree up to $13200$, and the symbol
  that must be non-trivial is the wild $11$-th norm residue symbol at $11$. Neither case is
  blocked by mathematics --- both are blocked by explicitness, and only the second is blocked by
  something no system here can compute.
]

= Is Brauer--Manin then just descent, repackaged? <sec-repackaging>

For an elliptic curve: essentially yes, and the identification is exact. Three qualifications
keep it from being *only* a repackaging.

== Why the identification is exact here <sec-exact>

$overline(E)$ is a curve over an algebraically closed field, so $"Br"(overline(E)) = 0$ by Tsen's
theorem: an elliptic curve has *no transcendental Brauer group at all*. Hence
$ "Br"(E) = "Br"_1 (E) , quad "Br"(E) slash "Br"_0 (E) tilde.equiv H^1 (QQ, E) =
  union.big_n H^1 (QQ, E)[n] , $
and $H^1(QQ, E)[n] = "coker"(E(QQ) slash n --> H^1(QQ, E[n]))$ is precisely the output of
$n$-descent. Pairing against it is precisely the local pairing of $n$-descent. So the
Brauer--Manin condition on $E$ *is* the intersection over all $n$ of the $n$-descent reciprocity
conditions --- there is no class left over, and no obstruction that descent cannot see.

For a fixed $(E, p)$ a single $n$ suffices: $E(QQ_p) slash Gamma$ is a finite abelian group, and
$n$ its exponent. Across all $p$ at once you need $n -> infinity$ along $p$-powers, because the
formal group is $ZZ_p$ and only $p$-power descent reaches its deeper layers.

== Qualification 1: it is a duality, not a restatement <sec-duality>

Descent and Brauer--Manin use the same perfect pairing, but read it in opposite directions:

#align(center)[
#table(columns: 3, align: (left, left, left), stroke: 0.4pt, inset: 6pt,
  [], [descent], [Brauer--Manin],
  [what is cut down], [$H^1(QQ, E[n])$], [$product_v E(QQ_v)$],
  [what does the cutting], [the local conditions $W_v$], [classes $beta in H^1(QQ, E)$],
  [what you learn], [a bound on $E(QQ) slash n$, i.e. on the *group*],
    [a bound on $overline(E(QQ))$, i.e. on the *closure*],
)]

The sharpening this gives is worth stating, because it says exactly which classes can obstruct at
a given place. For $cal(A)_beta$ to vanish at every $v != p$ and every local point means
$beta_v in W_v^perp = W_v$ for all $v != p$, and to detect at $p$ means $beta_p in.not W_p$. That
is:

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  The classes that obstruct density at $p$ are exactly the non-trivial elements of
  $ "Sel"_n^((p)) slash "Sel"_n , $
  the Selmer group with its condition at $p$ *relaxed*, modulo the honest Selmer group. The
  element $d = 1/4 theta^2 - 2 theta - 11$ of @sec-37bm is a generator of this quotient for
  $n = 2$, $p = 23$ on the conductor-$37$ curve: it satisfies the local conditions at every
  $v != 23$, and it is not in $"Sel"_2$ because $W_23$ is maximal isotropic, so
  $W_23^perp = W_23$ and pairing non-trivially with $W_23$ puts it outside. There
  $dim "Sel"_2 = 1$ (rank $1$, no rational $2$-torsion, $Ш[2] = 0$) while
  $dim "Sel"_2^((23)) >= 2$.
]

Whether such a class exists is governed by the Greenberg--Wiles comparison formula --- the
subject of `selmer-local-conditions.typ` in this directory. So "does the obstruction exist" is
not a formality; it is a Selmer-rank computation.

== Qualification 2: that descent sees *everything* is a theorem <sec-theorem>

The inclusion $overline(E(QQ)) subset.eq E(bold(A))^"Br"$ is formal --- reciprocity plus
continuity. The reverse inclusion, which is what licenses "the obstruction explains all of it",
is Manin's theorem and needs $Ш(E)$ finite; its proof is Poitou--Tate exactness and the
Cassels--Tate pairing. Without finiteness of $Ш$ you do not know that the $n$-descents, however
many you run, detect every adelic point outside the closure. So the completeness of the
repackaging rests on an open conjecture in general, and on Gross--Zagier and Kolyvagin for the
analytic-rank-$<= 1$ curves treated here.

== Qualification 3: the equivalence is special to $E$ <sec-special>

Off an abelian variety there is no group law, no isogeny, and no $n$-descent --- but there is
still a Brauer group and still $sum_v "inv"_v = 0$. That is exactly the situation of the other
two documents in this directory: the class $(2, x+4)$ on the negative Pell conic of
`integral-bm.typ` is not an $n$-descent class of anything. The Brauer formulation buys
*portability*, and on $E$ specifically it buys nothing new --- which is the observation you
started from.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *So:* on an elliptic curve, Brauer--Manin $=$ all the $n$-descents together, exactly and with
  nothing left over, because $"Br"(overline(E)) = 0$. It is a repackaging --- but a dual one,
  which turns "bound the Mordell--Weil group" into "bound its closure"; its completeness is
  Manin's theorem, not bookkeeping; and the packaging is what lets the same argument run on
  varieties that are not groups.
]

= Relation to the other two documents <sec-relation>

- `ec-padic-closure.typ` computes *that* the closure is a proper open subgroup, and *which* layer
  of $E supset E_0 supset E_1 supset E_2$ fails, by a filtration index $(N_p slash m) p^(v-1)$.
  It is a statement about $E(QQ_p)$ and needs no global input.
- This document explains *why*, globally: reciprocity applied to one class, exactly as in
  `integral-bm.typ`. The two obstructions even have the same shape --- there $(2, x+4)$ on the
  negative Pell conic, here $(d, x)$ on an elliptic curve, both unramified because the relevant
  function has even divisor, both evaluated by Hilbert symbols, both concluded by
  $sum_v "inv"_v = 0$.
- The difference is what is being obstructed. In `integral-bm.typ` the obstruction empties an
  *entire* adelic space and proves $cal(X)(ZZ) = nothing$. Here it empties an open *subset* of
  $E(QQ_p)$, which is a weaker conclusion --- $E(QQ)$ is large --- but the same mechanism.

#v(3mm)

_Companion file:_ `ec-density-bm.gp`, run as

```sh
gp -q -s 4000000000 ec-density-bm.gp < /dev/null > results/ec-density-bm.txt
```

It verifies the ranks and analytic ranks, the local images $S_v$ at $v = 2$ (by scanning
rational $x$ with $x(x^2+a x+b)$ a $2$-adic square), the invariant of $cal(A)_d$ at every place
on many rational points together with the reciprocity product, the local point at $p$ where the
invariant is $1 slash 2$, and the index table of @sec-limits.
