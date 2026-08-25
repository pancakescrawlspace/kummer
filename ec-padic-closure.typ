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
  #text(size: 16pt, weight: "bold")[When $E(QQ)$ is not dense in $E(QQ_p)$]
  #v(2mm)
  #text(size: 10pt)[Six worked examples, one at each layer of the filtration
  $E(QQ_p) supset E_0 supset E_1 supset E_2$ --- including a curve where the
  reduction map $E(QQ) -> E(FF_p)$ is *surjective* and the image is still not dense]
  #v(1mm)
  #text(size: 9pt, style: "italic")[on a question of Rene Pannekoek;
  everything checked in `ec-padic-closure.gp`, output in `results/ec-padic-closure.txt`]
]

#v(4mm)

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *The shortest answer.* Let $E : y^2 + y = x^3 - x$ (conductor $37$), of rank $1$ with
  generator $P = (0,0)$ and no torsion, and let $p = 23$. Then $E(FF_23) tilde.equiv ZZ slash 22$
  while $overline(P)$ has order $11$, so the closure of $E(QQ)$ in $E(QQ_23)$ has index $2$.
  For a prime of *bad* reduction take $E : y^2 + y = x^3 + x^2$ (conductor $43$) and $p = 43$:
  the reduction is non-split multiplicative, $E(QQ_43) slash E_1(QQ_43)$ is cyclic of order
  $p+1 = 44$, and $overline(P)$ generates only the subgroup of order $22$ --- index $2$ again.
]

= The shape of the answer <sec-shape>

For $p >= 3$ the group $E(QQ_p)$ is a compact $p$-adic Lie group of dimension $1$, and
$ E(QQ_p) tilde.equiv ZZ_p times T , quad T "finite abelian" . $
Let $Gamma subset.eq E(QQ_p)$ be the closure of the image of $E(QQ)$. It is a closed subgroup, so:

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *$Gamma$ is open if and only if $"rank" E(QQ) >= 1$.* If the rank is $0$ then $E(QQ)$ is finite
  and $Gamma$ is finite, hence nowhere dense in the uncountable group $E(QQ_p)$ --- at *every*
  $p$, for trivial reasons. If the rank is $>= 1$ then $Gamma$ is infinite; $Gamma inter (ZZ_p
  times 0)$ has finite index in $Gamma$, hence is an infinite closed subgroup $p^k ZZ_p$ of
  $ZZ_p$, which is open. So $Gamma$ is open and $[E(QQ_p) : Gamma]$ is *finite*.
]

Density is therefore not a delicate analytic condition but the vanishing of a computable
finite index, and the interesting examples all have rank $>= 1$. Every curve below has rank
exactly $1$ and trivial torsion, so $E(QQ) = ⟨ P ⟩$ and $Gamma = overline(⟨ P ⟩)$.

== The filtration

Write $cal(E)$ for the Néron model over $ZZ_p$ and
$ E(QQ_p) supset.eq E_0(QQ_p) supset.eq E_1(QQ_p) supset.eq E_2(QQ_p) supset.eq dots , $
where $E_0$ is the set of points with non-singular reduction and $E_n$ the set of points
reducing to $O$ modulo $p^n$. The three layers are:

#align(center)[
#table(columns: 3, align: (left, left, left), stroke: 0.4pt, inset: 6pt,
  [layer], [what it is], [order],
  [$E slash E_0$], [the component group $Phi(FF_p)$], [$c_p$, the Tamagawa number],
  [$E_0 slash E_1$], [$tilde(E)^"ns" (FF_p)$, the smooth part of the special fibre],
    [$p + 1 - a_p$ (good); $p - a_p$ (bad)],
  [$E_1$], [the formal group, $tilde.equiv (ZZ_p, +)$ for $p >= 3$, with $E_n <-> p^(n-1) ZZ_p$],
    [$E_1 slash E_2 tilde.equiv FF_p$],
)]

For bad $p$ the middle row is $FF_p^times$ (split multiplicative, $a_p = 1$), the norm-one
torus of $FF_(p^2) slash FF_p$ (non-split, $a_p = -1$), or $GG_a (FF_p)$ (additive, $a_p = 0$);
in all cases at once its order is $p - a_p$ for bad $p$ and $p+1-a_p$ for good $p$.

The one computational fact needed: for a rational point $Q$ with $x(Q) = a slash c^2$ in lowest
terms, the formal parameter is $z = -x slash y$ and
$ v_p (z(Q)) = v_p (c) , quad "so" quad Q in E_n (QQ_p) quad <==> quad p^n | c . $

== The index, and the criterion

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Proposition (rank $1$, trivial torsion, $p >= 3$).* Put $N_p = |E(QQ_p) slash E_1(QQ_p)|$,
  let $m$ be the order of $overline(P)$ in that finite group --- equivalently the least $m >= 1$
  with $p | c(m P)$ --- and let $v = v_p (c(m P))$. Then
  $ [E(QQ_p) : Gamma] = (N_p slash m) dot p^(v-1) . $

  #v(2mm)
  _Proof._ $Gamma inter E_1 = overline(⟨ m P ⟩) = ZZ_p dot (m P) = E_v (QQ_p)$, using
  $E_1 tilde.equiv ZZ_p$ and $E_n <-> p^(n-1) ZZ_p$; and $Gamma slash (Gamma inter E_1) =
  ⟨ overline(P) ⟩$ has index $N_p slash m$ in $E(QQ_p) slash E_1$. Multiply the two
  indices, using $[E_1 : E_v] = p^(v-1)$. $qed$
]

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *The criterion in its clean form.* For $p >= 3$ and any rank,
  $ Gamma = E(QQ_p) quad <==> quad E(QQ) --> E(QQ_p) slash E_2 (QQ_p) " is surjective" , $
  a finite check on a group of order $p dot N_p$.

  #v(2mm)
  _Proof._ ($arrow.l.double$) Suppose the map is onto. If $Gamma inter E_1 subset.eq E_2$ then
  $Gamma inter E_2 = Gamma inter E_1$, so the image of $Gamma$ in $E slash E_2$ has order
  $|Gamma slash (Gamma inter E_1)| <= N_p < p N_p$ --- not onto. Hence $Gamma inter E_1 = E_1$,
  i.e. $Gamma supset.eq E_1$, and then surjectivity onto $E slash E_2$ forces
  $Gamma slash E_1 = E slash E_1$. ($arrow.r.double$) is clear. $qed$
]

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *A caveat worth stating.* For $p$ of good reduction, surjectivity of the reduction map
  $E(QQ) -> E(FF_p)$ is *necessary* for density but it is *not sufficient*: it only controls
  the top two layers, and says nothing about $E_1 slash E_2$. @sec-89 gives a curve of conductor
  $89$ and two primes, $p = 11$ and $p = 13$, where $E(QQ) -> E(FF_p)$ is onto and the closure
  still has index $p$. The correct statement is the boxed criterion above: one needs surjectivity
  modulo $p^2$, not modulo $p$.

  (For $p = 2$ the formal group need not be $tilde.equiv ZZ_2$ --- $E_1(QQ_2)$ can have
  $2$-torsion, only $E_2(QQ_2) tilde.equiv ZZ_2$ is automatic --- so everything below takes
  $p$ odd.)
]

= Good reduction <sec-good>

== The reduction map is not surjective: conductor $37$, $p = 23$ <sec-37>

$ E : y^2 + y = x^3 - x , quad Delta = 37 , quad "rank" = 1 , quad E(QQ)_"tors" = 0 , quad
P = (0,0) . $
PARI's `ellrank` returns this generator and `ellsaturation` confirms it is saturated. At
$p = 23$ the reduction is good, $a_23 = 2$, and
$ E(FF_23) tilde.equiv ZZ slash 22 , quad "ord"(overline(P)) = 11 , quad
[E(FF_23) : ⟨ overline(P) ⟩] = 2 . $
Then $11 P = (116 slash 529, -8555 slash 12167)$ has $c = 23$, so $v = 1$ and $11P in E_1 without E_2$:
the formal layer is full. The index is $2 dot 23^0 = 2$.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  The closure of $E(QQ)$ in $E(QQ_23)$ is an open subgroup of index $2$. Concretely,
  $E(QQ_23) tilde.equiv ZZ_23 times ZZ slash 22$ and $Gamma tilde.equiv ZZ_23 times 2 ZZ slash 22$:
  no rational point is $23$-adically close to a point whose reduction is a generator of
  $E(FF_23)$.
]

Here is the index at every good $p < 100$ for this curve. It is $1$ exactly when $overline(P)$
generates $E(FF_p)$, which fails often:

#align(center)[
#table(columns: 12, align: center, stroke: 0.4pt, inset: 4pt,
  [$p$], [3], [5], [7], [11], [13], [17], [19], [*23*], [*29*], [*31*], [41],
  [index], [1], [1], [1], [1], [1], [1], [1], [*2*], [*2*], [*2*], [1],
)
#v(1mm)
#table(columns: 12, align: center, stroke: 0.4pt, inset: 4pt,
  [$p$], [*43*], [47], [53], [*59*], [*61*], [*67*], [71], [73], [79], [*83*], [89],
  [index], [*3*], [1], [1], [*4*], [*2*], [*2*], [1], [1], [1], [*3*], [1],
)]

== A structural reason: $E(FF_p)$ non-cyclic, conductor $37$, $p = 67$ <sec-67>

If $E(QQ)$ has rank $1$ and no torsion then its image in $E(FF_p)$ is *cyclic*, so surjectivity
is impossible as soon as $E(FF_p)$ is not. At $p = 67$,
$ E(FF_67) tilde.equiv ZZ slash 30 times ZZ slash 2 , $
so the image can never be everything, whatever the generator is. The index is $2$. For this curve
the good $p < 400$ with $E(FF_p)$ non-cyclic are
$ p = 67, 107, 137, 139, 151, 233, 269, 293, 317, 349, 367 , $
and over all $667$ good $p < 5000$, $E(FF_p)$ is non-cyclic for $113$ of them ($16.9%$) --- so
this reason alone already forces non-density at a positive proportion of primes.

== Surjective reduction, still not dense: conductor $89$, $p = 11$ and $13$ <sec-89>

This is the example that separates the two criteria.
$ E : y^2 + x y + y = x^3 + x^2 - x , quad Delta = -89 , quad "rank" = 1 , quad
E(QQ)_"tors" = 0 , quad P = (0,0) . $

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *At $p = 11$*: $a_11 = -2$, $E(FF_11) tilde.equiv ZZ slash 14$, and $overline(P)$ has order
  $14$. *The reduction map $E(QQ) -> E(FF_11)$ is surjective.* Nevertheless
  $ 14 P = (2541600351 slash 1274133025, thin 90518784046991 slash 45480178327375) , $
  whose $x$-denominator is $c^2$ with
  $ c = 35695 = 5 dot 11^2 dot 59 , quad "so" quad v_11 (c) = 2 quad "and" quad 14 P in E_2 (QQ_11) . $
  Hence $Gamma inter E_1 = E_2(QQ_11)$ and $[E(QQ_11) : Gamma] = 1 dot 11^1 = 11$.
]

The same curve does it again at $p = 13$: $E(FF_13) tilde.equiv ZZ slash 12$ is generated by
$overline(P)$, and $12 P = (-8703421 slash 5597956, thin -3467599409 slash 13244763896)$ has
$c = 2366 = 2 dot 7 dot 13^2$, so $12 P in E_2(QQ_13)$ and the index is $13$.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *What is going on.* $E(QQ) -> E(FF_p)$ being onto says the closure surjects onto the top two
  layers. It says nothing about $E_1 slash E_2 tilde.equiv FF_p$. Here the whole group
  $E(QQ) inter E_1(QQ_p) = ⟨ 14 P ⟩$ already lies in $E_2$, so its closure is
  $E_2(QQ_p) = p ZZ_p$ and misses an index-$p$ amount of the formal group. The rational points
  surject onto $E(FF_11)$ but not onto $E(QQ_11) slash E_2 (QQ_11)$, which is the group of
  order $11 dot 14 = 154$ that actually decides density.

  Heuristically $v_p (c(m P)) >= 2$ has "probability" $1 slash p$, so this is rare but not at all
  exceptional --- and it happens twice on this one curve, at the two smallest primes where it
  could.
]

= Bad reduction <sec-bad>

== The torus layer: conductor $43$, $p = 43$ <sec-43>

$ E : y^2 + y = x^3 + x^2 , quad Delta = -43 , quad "rank" = 1 , quad E(QQ)_"tors" = 0 ,
quad P = (0,0) . $
At $p = 43$ the reduction is multiplicative of type $I_1$, so $c_43 = 1$ and the component group
is trivial; $a_43 = -1$, so the reduction is *non-split* and
$ E_0(QQ_43) slash E_1(QQ_43) tilde.equiv ker(N : FF_(43^2)^times -> FF_43^times) tilde.equiv
ZZ slash 44 . $
The singular point of the reduction is $(28, 21)$ and $P = (0,0)$ does not meet it, so
$P in E_0(QQ_43)$. Its order in $E(QQ_43) slash E_1$ is $22$, exactly half of $44$; and
$22 P$ has $c = 3033521 = 19 dot 43 dot 47 dot 79$, so $v = 1$ and the formal layer is full.
The index is $2$.

This is the bad-reduction twin of @sec-37: the finite layer is a *torus* rather than
$E(FF_p)$, but the mechanism --- a generator landing in an index-$2$ subgroup of a cyclic
group of even order --- is identical.

== The formal layer: conductor $77$, $p = 11$ <sec-77>

$ E : y^2 + y = x^3 + 2 x , quad Delta = -539 = -7^2 dot 11 , quad "rank" = 1 , quad
E(QQ)_"tors" = 0 , quad P = (2,-4) . $
At $p = 11$: type $I_1$, $c_11 = 1$, $a_11 = -1$, so $E(QQ_11) slash E_1(QQ_11)$ is cyclic of
order $12$ --- and $overline(P)$ *generates all of it*. But
$ 12 P = (-89535 slash 937024, thin -235033185 slash 907039232) , quad
c = 968 = 2^3 dot 11^2 , $
so $12 P in E_2 (QQ_11)$ and the index is $11$. This is the bad-reduction twin of @sec-89.

== The component layer: conductor $11289$, $p = 3$ <sec-comp>

The one mechanism with no good-reduction analogue: missing a whole component of the Néron model.
$ E : y^2 + x y = x^3 + x^2 - 9 , quad Delta = -33867 = -3^2 dot 53 dot 71 , quad "rank" = 1 ,
quad E(QQ)_"tors" = 0 , quad P = (2,1) . $
At $p = 3$ the reduction is of type $I_2$, non-split, with
$ c_3 = 2 , quad Phi(FF_3) tilde.equiv ZZ slash 2 , quad
E_0 slash E_1 tilde.equiv ZZ slash 4 , quad |E(QQ_3) slash E_1(QQ_3)| = 2 dot 4 = 8 . $

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  The singular point of the reduction mod $3$ is $(0,0)$, and $P = (2,1)$ reduces to $(2,1) != (0,0)$.
  So $P in E_0(QQ_3)$, and since $E_0(QQ_3)$ is open *and closed*,
  $ Gamma subset.eq E_0(QQ_3) . $
  The image of $E(QQ)$ in the component group $Phi(FF_3) tilde.equiv ZZ slash 2$ is *trivial*: no
  rational point at all lies on the non-identity component of the special fibre. The order of
  $overline(P)$ in $E(QQ_3) slash E_1$ is $4 = |E_0 slash E_1|$, confirming that the whole loss
  at that stage is the component group; and $4 P$ has $c = 24552 = 2^3 dot 3^2 dot 11 dot 31$,
  so $v = 2$ and the formal group contributes another factor $3$. Total index $2 dot 3 = 6$.
]

== How common is the component layer, really <sec-common>

An earlier draft of these notes called this mechanism rare. That was wrong, and the way it was
wrong is worth recording: the claim rested on a listing that had been truncated to its first
$28$ rows, and on a sweep that excluded $p = 2$. A proper sweep of $156450$ curves in reduced
minimal form ($a_1, a_3 in {0,1}$, $a_2 in {-1,0,1}$, $|a_4| <= 40$, $|a_6| <= 80$) turns up
$5249$ confirmed pairs $(E, p)$ with certified rank $>= 1$ and *proper* image in $Phi(FF_p)$,
against $60022$ pairs with $c_p >= 2$ in the same box. (That denominator counts rank-$0$
curves too, which are excluded from the numerator, so the rate among rank-$>= 1$ curves is
higher than the $8.7%$ this ratio suggests.) The mechanism is ordinary, not exceptional.

Two things had hidden it. First, $3060$ of the $5249$ sit at $p = 2$, which the sweeps behind
the earlier draft skipped --- and $p = 2$ is perfectly legitimate here: the component argument
needs only that $E_0(QQ_p)$ is open *and closed*, so unlike the formal-group layer of
@sec-shape it has no $p = 2$ caveat at all. Second, the surviving examples were sorted by
conductor and then read off the top of a truncated list.

The smallest conductors found, over all minimal models of conductor $<= 600$ in a box with
$|a_4| <= 150$, $|a_6| <= 350$:

#align(center)[
#table(columns: 7, align: (right, left, center, center, center, center, center), stroke: 0.4pt,
  inset: 5pt,
  [cond.], [curve], [$p$], [type], [$c_p$], [$|"image"|$], [rank, tors.],
  [$438$], [$y^2 + x y = x^3 + x^2 - 65 x - 231$], [$2$], [$I_2$], [$2$], [$1$], [$1$, $ZZ slash 2$],
  [$446$], [$y^2 + x y + y = x^3 + x^2 - 39 x - 35$], [$2$], [$I_14$], [$14$], [$7$], [$1$, $0$],
)]

The second is the more striking of the two. It has *split* multiplicative reduction of type
$I_14$ at $p = 2$, so $Phi(FF_2) tilde.equiv ZZ slash 14$ --- fourteen components --- and rank
$1$ with trivial torsion and saturated generator $P = (-5, 10)$. The singular point of the
reduction mod $2$ is $(1,0)$, and $k P$ avoids it exactly for $k = 7$ and $k = 14$:
$ 7 P = (-25 slash 4, thin 47 slash 8) in E_1(QQ_2) , quad 14 P = (1139761 slash 10816,
thin -1281713061 slash 1124864) in E_1 (QQ_2) , $
while $k P$ reduces to $(1,0)$ for every other $k <= 15$. So the image of $P$ in $ZZ slash 14$
has order $7$: *$E(QQ)$ lands in the even part $2 ZZ slash 14 ZZ$ and misses all seven odd
components of the Néron model outright.* The closure has index divisible by $2$.

= How often, and the degenerate case <sec-often>

For the conductor-$37$ curve, over the $667$ primes of good reduction below $5000$:

#align(center)[
#table(columns: 2, align: (left, right), stroke: 0.4pt, inset: 6pt,
  [$E(QQ) -> E(FF_p)$ *not* surjective], [$357$ primes, $53.5%$],
  [of which forced, $E(FF_p)$ non-cyclic], [$113$ primes, $16.9%$],
  [$E(QQ) -> E(FF_p)$ surjective], [$310$ primes, $46.5%$],
)]

So non-density is the *typical* behaviour, not a curiosity: it happens for more than half the
primes. The density of $p$ for which a fixed point of infinite order generates $E(FF_p)$ is the
elliptic analogue of Artin's primitive-root problem, studied by Lang and Trotter; the $46.5%$
above is an observed value of that density, not a theorem.

And the degenerate case, worth naming so it is not mistaken for the phenomenon: if
$"rank" E(QQ) = 0$ --- for instance $y^2 + y = x^3 - x^2 - 10x - 20$ of conductor $11$, with
$E(QQ) tilde.equiv ZZ slash 5$ --- then $E(QQ)$ is finite and $E(QQ_p)$ contains
$E_1(QQ_p) tilde.equiv ZZ_p$, so the image is nowhere dense at every single prime. Every example
above has rank exactly $1$ precisely to avoid this.

= Summary <sec-summary>

#align(center)[
#table(columns: 6, align: (left, center, left, center, center, center), stroke: 0.4pt,
  inset: 5pt,
  [curve (conductor)], [$p$], [reduction], [layer that fails], [$E(QQ) -> E(FF_p)$ onto?], [index],
  [$y^2+y=x^3-x$ (37)], [$23$], [good], [$E_0 slash E_1$], [no], [$2$],
  [$y^2+y=x^3-x$ (37)], [$67$], [good, $E(FF_p)$ non-cyclic], [$E_0 slash E_1$], [impossible], [$2$],
  [$y^2+x y+y=x^3+x^2-x$ (89)], [$11$], [good], [$E_1 slash E_2$], [*yes*], [$11$],
  [$y^2+x y+y=x^3+x^2-x$ (89)], [$13$], [good], [$E_1 slash E_2$], [*yes*], [$13$],
  [$y^2+y=x^3+x^2$ (43)], [$43$], [non-split mult. $I_1$], [$E_0 slash E_1$], [---], [$2$],
  [$y^2+y=x^3+2x$ (77)], [$11$], [non-split mult. $I_1$], [$E_1 slash E_2$], [---], [$11$],
  [$y^2+x y=x^3+x^2-9$ (11289)], [$3$], [non-split mult. $I_2$], [$E slash E_0$ and $E_1 slash E_2$], [---], [$6$],
)]

#v(2mm)

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  The closure of $E(QQ)$ in $E(QQ_p)$ is a closed subgroup, open of finite index as soon as the
  rank is positive, so "dense" is a finite computation. It fails whenever the image misses any
  layer of $E(QQ_p) supset E_0 supset E_1 supset E_2$: a component of the Néron model, part of
  the reduction $tilde(E)^"ns" (FF_p)$, or a step of the formal group. The first is rare, the
  second is the usual reason and happens for over half of all $p$, and the third is the one that
  the criterion "$E(QQ) -> E(FF_p)$ is surjective" does not see --- which is why the correct
  statement is surjectivity onto $E(QQ_p) slash E_2 (QQ_p)$, i.e. modulo $p^2$.
]

#v(3mm)

_Companion file:_ `ec-padic-closure.gp`, run as

```sh
gp -q -s 4000000000 ec-padic-closure.gp < /dev/null > results/ec-padic-closure.txt
```

It recomputes every number above: the ranks and saturated generators via `ellrank` and
`ellsaturation`, the group structures via `ellgroup`, the local data via `elllocalred` and
`ellap`, the singular points of the bad reductions by brute force, the exact multiples $m P$ over
$QQ$, and the index $(N_p slash m) p^(v-1)$ at each place --- together with the two sweeps of
@sec-37 and @sec-often.
