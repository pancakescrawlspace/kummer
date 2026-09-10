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
  #text(size: 16pt, weight: "bold")[A worked non-diagonal example at $p = 13$ and $p = 2$]
  #v(2mm)
  #text(size: 10pt)[The Kummer surface of $E times E'$ for
  $y^2 = x(x-5)(x-7)$ and $v^2 = u(u-1)(u-2)$: covering certificates for every square class at a
  prime of good reduction and at a prime of bad reduction, and one genuine three-twist pencil]
  #v(1mm)
  #text(size: 9pt, style: "italic")[worked from scratch in `kummer-example-p13.gp`;
  companion to `openness-covering.typ`]
]

#v(4mm)

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *Summary.* At $p = 13$ a *single* twist suffices in every square class:
  $d = 30, 6, 13, -78$ for the classes $[1], [2], [13], [26]$. The structural reason is that both
  curves carry full rational $2$-torsion, so the image $S_d$ of $E_d (QQ)$ in the torsion $T$ of
  $E_delta (QQ_13)$ always contains $V = T[2]$, and
  $T slash V$ is cyclic in every class but one. The exception is class $[2]$, where
  $T tilde.equiv (ZZ slash 4)^2$ and $T slash V tilde.equiv (ZZ slash 2)^2$: there a rank-$1$
  twist can only reach an index-$2$ subgroup, and three of them are needed --- the Bose--Burton
  pencil of $section 8.2$ of the companion, realised arithmetically.

  #v(1.5mm)
  At the bad prime $p = 2$ (@sec-p2) there are *eight* classes and every twist is additive, which
  makes $G$ pro-$2$ and the test *exact*: $H_d = G$ if and only if $E_d (QQ)$ surjects onto
  $G slash 2G tilde.equiv (ZZ slash 2)^3$. A single twist again suffices in every class ---
  $d = -15, -21, 29, 39, -78, 6, -6, 30$ --- but only $25$ of the $64$ available twists certify,
  against almost all of them at $13$.
]

= The two curves <sec-curves>

$ E : y^2 = x(x-5)(x-7), quad N_E = 1120 ; wide
  E' : v^2 = u(u-1)(u-2), quad N_(E') = 32 . $
Both have rank $0$ over $QQ$ and torsion $(ZZ slash 2)^2$. Two features shape everything that
follows.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *(a) $E'$ is the congruent-number curve.* The shift $u |-> u+1$ turns $E'$ into
  $y^2 = x^3 - x$, so $j_(E') = 1728$ and
  $ E'_d tilde.equiv y^2 = x^3 - d^2 x . $
  Hence $E'_d$ has positive rank if and only if $|d|$ is a congruent number, and
  $E'_d tilde.equiv E'_(-d)$ --- the $(-1)$-twist is trivial for $j = 1728$.

  #v(1.5mm)
  *(b) Every twist has full rational $2$-torsion.*
  $E_d : y^2 = x(x-5d)(x-7d)$ and $E'_d : y^2 = x(x-d)(x-2d)$, with $2$-torsion
  $(0,0), (5d, 0), (7d, 0)$ and $(0,0), (d,0), (2d,0)$.
]

Feature (b) is what makes the example easy and, in one class, interesting: it puts a fixed
subgroup $V$ inside every $S_d$, so the whole question is about $T slash V$.

A search over squarefree $|d| <= 160$ found $64$ twists with $E_d$ and $E'_d$ both of positive
rank --- ample supply in each of the four classes.

= The prime, and the local groups <sec-local>

The bad primes are $2, 5, 7$ for $E$ and $2$ for $E'$, so $p = 13$ has good reduction for both.
For odd $p$ there are four classes in $QQ_p^times slash (QQ_p^times)^2$; take representatives
$1, 2, 13, 26$ ($2$ is a non-residue mod $13$).

#v(2mm)
#align(center)[
#table(columns: 4, align: (left, left, left, left), stroke: 0.4pt + luma(170),
  inset: (x: 8pt, y: 4pt),
  table.header([class], [$G = E_delta (QQ_13)$], [$G' = E'_delta (QQ_13)$], [reduction]),
  [$[1]$],  [$ZZ_13 times (ZZ slash 6 times ZZ slash 2)$],
            [$ZZ_13 times (ZZ slash 4 times ZZ slash 2)$], [good],
  [$[2]$],  [$ZZ_13 times (ZZ slash 4 times ZZ slash 4)$],
            [$ZZ_13 times (ZZ slash 10 times ZZ slash 2)$], [good],
  [$[13]$], [$ZZ_13 times (ZZ slash 2)^2$], [$ZZ_13 times (ZZ slash 2)^2$], [additive $I_0^ast$],
  [$[26]$], [$ZZ_13 times (ZZ slash 2)^2$], [$ZZ_13 times (ZZ slash 2)^2$], [additive $I_0^ast$],
)]

#v(2mm)

For the ramified classes the local type is $I_0^ast$ with $c_13 = 4$ and $v_13 (Delta) = 6$, and
there is no $13$-torsion over $QQ_13$ (checked: the $13$-division polynomial has no $QQ_13$-root).
So $E_0$ is torsion-free pro-$13$, $T tilde.equiv Phi tilde.equiv (ZZ slash 2)^2$, and $T$ is
exactly the image of the rational $2$-torsion.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Notation.* Write $T subset.eq G$ and $T' subset.eq G'$ for the torsion subgroups --- the finite
  factors tabulated above --- and
  $ H_d = overline(E_d (QQ)) subset.eq G , wide H'_d = overline(E'_d (QQ)) subset.eq G' $
  for the closures of the rational points, transported to the reference twist by the isomorphism
  recalled at the end of this section.

  #v(1.5mm)
  Since $13 divides.not |T|$ in every class, each of these closed subgroups splits into its
  pro-$13$ and prime-to-$13$ parts,
  $ H_d = 13^a ZZ_13 times S_d , wide S_d := H_d inter T , $
  and $S_d$ is the *image of $E_d (QQ)$ in $T$* under the reduction map $G ->> G slash E_1
  tilde.equiv T$ --- literally reduction modulo $13$ at the good places, and the component-group
  map at the additive ones. (Passing to the closure does not change an image in a finite quotient,
  so $H_d$ and $E_d (QQ)$ have the same image.) Since the $2$-torsion is rational for every twist,
  $S_d$ always contains its image
  $ V := T[2] , $
  and likewise $S'_d supset.eq V' := T'[2]$ on the second factor.

  #v(1.5mm)
  A cover requires $a = 0$ on both factors; when that holds,
  $H_d times H'_d = ZZ_13^2 times S_d times S'_d$, so what has to be checked is that the
  $S_d times S'_d$ cover $T times T'$.
]

Concretely, with $M = |T|$ and $P$ a free generator, $4 P$ kills the torsion component and

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *The two tests.* The pro-$13$ part is full if and only if
  $ v_13 (x(4P)) = -2 quad "(good reduction)", wide v_13 (x(4P)) = 0 quad (I_0^ast) . $
  In the additive case $v_13 (x) = 0$ says exactly that $4P$ reduces to a non-singular affine
  point, i.e. $4P in E_0 without E_1$.
]

To compare twists within one class, transport everything to the reference curve: for
$d = d_0 lambda^2$ the isomorphism $E_d --> E_(d_0)$ over $QQ_13$ is
$(x, y) |-> (x slash lambda^2, y slash lambda^3)$, well defined up to $lambda |-> -lambda$, which
does not change the subgroup generated. The $2$-torsion always transports to
$(0,0), (5 d_0, 0), (7 d_0, 0)$, which is the point of feature (b).

= Certificates, class by class <sec-cert>

== Class $[1]$: the single twist $d = 30$ <sec-c1>

#v(1mm)
#align(center)[
#table(columns: 5, align: (left, left, center, left, left), stroke: 0.4pt + luma(170),
  inset: (x: 7pt, y: 3pt),
  table.header([curve], [model], [rk], [generator], [$2$-torsion]),
  [$E_30$],  [$y^2 = x(x-150)(x-210)$], [$1$], [$(60, 900)$], [$(0,0), (150,0), (210,0)$],
  [$E'_30$], [$y^2 = x(x-30)(x-60)$],   [$1$], [$(10, 100)$], [$(0,0), (30,0), (60,0)$],
)]

#v(2mm)

Transport by $lambda = 2$ (so $lambda^2 = 30$ in $ZZ_13^times$). The generators land on
$(2,2) in tilde(E)(bb(F)_13)$ and $(9,6) in tilde(E)' (bb(F)_13)$, the $2$-torsion on
$(0,0), (5,0), (7,0)$ and $(0,0), (1,0), (2,0)$. Both levels are $1$, and
$ S_30 = T quad (12 "elements"), wide S'_30 = T' quad (8 "elements") . $
So $H_30 times H'_30 = G times G'$: the union has $96$ of $96$ elements.

== Class $[2]$: the single twist $d = 6$ <sec-c2a>

#v(1mm)
#align(center)[
#table(columns: 5, align: (left, left, center, left, left), stroke: 0.4pt + luma(170),
  inset: (x: 7pt, y: 3pt),
  table.header([curve], [model], [rk], [generators], [image in $T$, $T'$]),
  [$E_6$],  [$y^2 = x(x-30)(x-42)$], [$2$], [$(60, 180), thin (6, -72)$], [$(7,2), thin (2,7)$],
  [$E'_6$], [$y^2 = x(x-6)(x-12)$],  [$1$], [$(3, 9)$], [$(1,4)$],
)]

#v(2mm)

Transport by $lambda = 4$. Here $S_6 = T$ and $S'_6 = T'$, so one twist again suffices: the union
has $320$ of $320$ elements. Note it is the *rank $2$* of $E_6$ that does the work --- see
@sec-why.

== Class $[2]$: the three-twist pencil <sec-pencil>

Restricting to twists of rank $1$ on the $E$-side turns this class into the interesting case.

#v(1mm)
#align(center)[
#table(columns: 5, align: (right, left, left, center, center), stroke: 0.4pt + luma(170),
  inset: (x: 7pt, y: 3pt),
  table.header([$d$], [generator of $E_d (QQ)$], [generator of $E'_d (QQ)$],
               [image in $T$], [$[T : S_d]$]),
  [$-31$], [$(7, 504)$],    [$(162 slash 49, thin 29520 slash 343)$], [$(5,11)$],  [$2$],
  [$-6$],  [$(-36, 36)$],   [$(-9, 9)$],                              [$(12,11)$], [$2$],
  [$41$],  [$(45, 1320)$],  [$(32,120), thin (882, 24360)$],          [$(6,7)$],   [$2$],
)]

#v(2mm)

Each has $S'_d = T'$ full and both levels equal to $1$. The three $S_d$ are *three distinct
index-$2$ subgroups of $T tilde.equiv (ZZ slash 4)^2$*, each containing $V = T[2]$, and

$ S_(-31) union S_(-6) union S_41 = T , wide "so" quad
  union.big_(i) S_(d_i) times S'_(d_i) = T times T' quad (320 "of" 320) . $

Dropping any one of the three fails, so the cover is irredundant. This is exactly the pencil of
$section 8.2$ of the companion: three index-$2$ subgroups through a common index-$4$ subgroup,
which here is $V$ itself.

== Classes $[13]$ and $[26]$ <sec-ram>

#v(1mm)
#align(center)[
#table(columns: 5, align: (left, right, left, left, center), stroke: 0.4pt + luma(170),
  inset: (x: 7pt, y: 3pt),
  table.header([class], [$d$], [generator of $E_d (QQ)$], [generator of $E'_d (QQ)$],
               [$v_13 (x(4P))$]),
  [$[13]$], [$13$],  [$(315, 4200)$],  [$(289 slash 25, thin 1938 slash 125)$], [$0, thin 0$],
  [$[26]$], [$-78$], [$(-507, 1521)$], [$(-81, 135)$],                          [$0, thin 0$],
)]

#v(2mm)

Both twists have $I_0^ast$ reduction with $c_13 = 4$ on each factor. Since $T$ is the image of
the rational $2$-torsion, $S_d = T$ and $S'_d = T'$ automatically, and the only thing to check is
the level --- which passes. One twist per class.

= Why the lists are so short <sec-why>

$S_d$ always contains $V$, the image of the rational $2$-torsion, so the entire question is
whether $S_d slash V$ fills $T slash V$. Tabulating:

#v(2mm)
#align(center)[
#table(columns: 5, align: (left, left, left, left, left), stroke: 0.4pt + luma(170),
  inset: (x: 8pt, y: 3pt),
  table.header([class], [$T$], [$T slash V$], [$T'$], [$T' slash V'$]),
  [$[1]$],  [$ZZ slash 6 times ZZ slash 2$],  [$ZZ slash 3$],
            [$ZZ slash 4 times ZZ slash 2$],  [$ZZ slash 2$],
  [$[2]$],  [$(ZZ slash 4)^2$],               [$(ZZ slash 2)^2$],
            [$ZZ slash 10 times ZZ slash 2$], [$ZZ slash 5$],
  [$[13]$, $[26]$], [$(ZZ slash 2)^2$], [$0$], [$(ZZ slash 2)^2$], [$0$],
)]

#v(2mm)

A twist of rank $r$ contributes at most $r$ generators to $S_d slash V$. So a single rank-$1$
twist can fill $T slash V$ exactly when that quotient is *cyclic* --- which it is in every entry
above except one: $T slash V tilde.equiv (ZZ slash 2)^2$ in class $[2]$. There a rank-$1$ twist
reaches only an index-$2$ subgroup, and three are needed; a rank-$2$ twist such as $d = 6$
escapes by supplying two generators at once.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *Consistent with the general theory.* Here
  $frak(g) = G times G' tilde.equiv ZZ_13^2 times T times T'$ has
  $dim_(bb(F)_2) frak(g) slash 2 frak(g) >= 4$, so $q = 2$ and $sigma(frak(g)) = 3$: three
  proper subgroups is the most that could ever be needed, and the pencil of @sec-pencil attains
  it. The *minimum* over the available family is nevertheless $1$, so the pencil is irredundant
  but not minimum --- the non-uniqueness that $section 8.4$ of the companion warns about, in a
  concrete instance.
]

= Bad reduction: the same surfaces at $p = 2$ <sec-p2>

$2$ is a bad prime for both curves ($N_E = 2^5 dot 5 dot 7$, $N_(E') = 2^5$), and there are now
*eight* square classes, with representatives $1, 3, 5, 7, 2, 6, 10, 14$ --- a squarefree $d$ lies
in the class of $2^(v_2 (d)) dot (d slash 2^(v_2 (d)) mod 8)$.

== Every twist is additive, so $G$ is pro-$2$ <sec-p2-local>

The computation is *easier* here than at $13$, for a reason worth isolating.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Local types.* For odd $d$ both $E_d$ and $E'_d$ have type $I I I$ with $c_2 = 2$; for even $d$
  both have type $I_2^ast$ with $c_2 = 4$. Either way the reduction is *additive*, so
  $tilde(E)^"ns" (bb(F)_2) tilde.equiv bb(F)_2^+$ has order $2$ and
  $ |E_d (QQ_2) slash E_1 (QQ_2)| = c_2 dot 2 in \{4, 8\} , $
  a $2$-group. Since $E_1 (QQ_2)$ is pro-$2$, *$G = E_delta (QQ_2)$ is a pro-$2$ group* --- there
  is no prime-to-$2$ part at all.
]

At $p = 13$ what made the analysis tractable was the splitting $H_d = 13^a ZZ_13 times S_d$ into
pro-$13$ and prime-to-$13$ parts. Here that splitting is vacuous, and something better takes its
place: for an abelian pro-$2$ group $Phi(G) = 2 G$, so the Frattini property gives an *exact*
criterion with no filtration levels to compute.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *The test at $2$.*
  $ H_d = G quad <==> quad E_d (QQ) --> G slash 2 G "is surjective" . $
  And $|G slash 2G| = |E_d [2](QQ_2)| dot |2|_2^(-1) = 4 dot 2 = 8$, so
  $G slash 2G tilde.equiv (ZZ slash 2)^3$.
]

Note in passing what that says: $G$ needs *three* topological generators. This is exactly the
configuration the grey box of $section 2$ of the main notes flags --- $f = x(x-5)(x-7)$ splits
completely over $QQ_2$ --- so at $p = 2$ these groups are as far from procyclic as they get, and
by $section 2.1.1$ necessity fails comprehensively. Only sufficiency is in question below.

== The computable model <sec-p2-mu>

$G slash 2G$ is computed by the local $2$-descent map. For $E_d : y^2 = (x-e_1)(x-e_2)(x-e_3)$
with $e = (0, 5d, 7d)$ put
$ mu(P) = (x - e_1, thin x - e_2) in (QQ_2^times slash (QQ_2^times)^2)^2 tilde.equiv bb(F)_2^6 , $
with the usual convention at the $2$-torsion: the vanishing coordinate is replaced by the product
of the other two differences, so
$ mu(e_1,0) = ((e_1 - e_2)(e_1 - e_3), thin e_1 - e_2), quad
  mu(e_2,0) = (e_2 - e_1, thin (e_2 - e_1)(e_2 - e_3)), $
and similarly at $e_3$. This $mu$ is injective on $G slash 2 G$. Represent
$QQ_2^times slash (QQ_2^times)^2 tilde.equiv (ZZ slash 2)^3$ by
$a = 2^v u |-> (v mod 2, thin u mod 8)$.

The rational image is then the span of $mu$ on the three $2$-torsion points together with
saturated Mordell--Weil generators; the local image is obtained by sampling $x in QQ$ of small
height with $(x-e_1)(x-e_2)(x-e_3)$ a square in $QQ_2$. Two checks: $mu$ is additive on the
torsion (all nine pairs), and for $d = 1$ the sampled local image has dimension exactly $3$ over
$873$ points --- the value the formula predicts.

== The eight certificates <sec-p2-cert>

In every class a single twist suffices. Here $"rk"$ is the Mordell--Weil rank and the last column
is $dim$ (rational image) of $dim$ (local image) in $G slash 2G$.

#v(2mm)
#align(center)[
#set text(size: 9pt)
#table(columns: 8, align: (center, right, center, center, left, center, center, center),
  stroke: 0.4pt + luma(170), inset: (x: 5pt, y: 3pt),
  table.header([class], [$d$], [type], [$c_2$], [generators of $E_d (QQ)$], [$dim$],
               [generators of $E'_d (QQ)$], [$dim$]),
  [$[1]$],  [$-15$], [$I I I$],     [$2$], [$(-84,126), thin (21,504)$],  [$3 slash 3$],
            [$(-24,36)$],           [$3 slash 3$],
  [$[3]$],  [$-21$], [$I I I$],     [$2$], [$(15,540)$],                 [$3 slash 3$],
            [$(-24,36)$],           [$3 slash 3$],
  [$[5]$],  [$29$],  [$I I I$],     [$2$], [$(140,210)$],                [$3 slash 3$],
            [$(1 slash 169, thin 6930 slash 2197)$], [$3 slash 3$],
  [$[7]$],  [$39$],  [$I I I$],     [$2$], [$(105,1260), thin (315,1260)$], [$3 slash 3$],
            [$(3,90)$],             [$3 slash 3$],
  [$[2]$],  [$-78$], [$I_2^ast$],   [$4$], [$(-507,1521)$],              [$3 slash 3$],
            [$(-81,135)$],          [$3 slash 3$],
  [$[6]$],  [$6$],   [$I_2^ast$],   [$4$], [$(60,180), thin (6,-72)$],   [$3 slash 3$],
            [$(3,9)$],              [$3 slash 3$],
  [$[10]$], [$-6$],  [$I_2^ast$],   [$4$], [$(-36,36)$],                 [$3 slash 3$],
            [$(-9,9)$],             [$3 slash 3$],
  [$[14]$], [$30$],  [$I_2^ast$],   [$4$], [$(60,900)$],                 [$3 slash 3$],
            [$(10,100)$],           [$3 slash 3$],
)]

#v(2mm)

In each row both rational images fill $G slash 2G$ and $G' slash 2G'$, so $H_d = G$ and
$H'_d = G'$ by Frattini, and $H_d times H'_d$ is the whole of $frak(g)$.

== $p = 2$ is genuinely tighter <sec-p2-tight>

The single-twist answer should not suggest the condition is cheap. Of the $64$ twists with both
ranks positive, only *$25$* certify --- the other $39$ have a rational image of dimension $2$ out
of $3$ on one side or the other. By class:

#v(2mm)
#align(center)[
#table(columns: 9, align: center, stroke: 0.4pt + luma(170), inset: (x: 7pt, y: 3pt),
  table.header([class], [$[1]$], [$[3]$], [$[5]$], [$[7]$], [$[2]$], [$[6]$], [$[10]$], [$[14]$]),
  [twists available], [$12$], [$8$], [$10$], [$12$], [$8$], [$7$], [$4$], [$3$],
  [of which certify], [$4$],  [$5$], [$5$],  [$4$],  [$1$], [$3$], [$2$],  [$1$],
)]

#v(2mm)

Classes $[2]$ and $[14]$ come down to a single usable twist each out of eight and three. Compare
$p = 13$, where the failures were rare and confined to the level test. Two effects compound: there
are eight classes rather than four, and the target $G slash 2G$ is three-dimensional rather than
--- as the prime-to-$p$ quotient at $13$ effectively was --- a group the rational $2$-torsion
already fills most of.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *What is not done here.* The certificates above are exact: surjectivity onto $G slash Phi(G)$
  plus Frattini gives $H_d = G$ outright. But the failing twists cannot be assembled into a
  multi-twist cover on this data alone. Covering $frak(g)$ is decided in $frak(g) slash 2 frak(g)$
  only when every $H_d$ has index $2$, and a twist whose image is a hyperplane of $G slash 2G$
  need not itself have index $2$ in $G$ --- it need not contain $2G$. Establishing a genuine
  pencil at $p = 2$, in the style of @sec-pencil, would need control of $H_d$ deeper than its
  Frattini image.
]

= What is and is not proved <sec-rigour>

The covering claims are *unconditional*. Actual rational points are exhibited, their images
computed, and a subgroup of $H_d$ covering implies $H_d$ covers; failing to saturate could only
make $S_d$ larger, never smaller. The ranks quoted are `ellrank` lower bounds, which is the
direction that matters here. At $p = 2$ the certificates are exact in a stronger sense: they
establish $H_d = G$ outright, by surjectivity onto $G slash Phi(G)$ and the Frattini property, so
no filtration level has to be measured at all.

Two claims do depend on more. That the pencil twists have $[T : S_d] = 2$ *exactly* uses
`ellsaturation` at primes $<= 40$; and the assertion in @sec-why that no rank-$1$ twist in class
$[2]$ can do better is a statement about the rank-$1$ twists *found*, not a theorem about all of
them --- though the $S_d slash V$ argument does show it for every twist of rank $1$.
