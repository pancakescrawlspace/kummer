#set page(paper: "a4", margin: (x: 2.0cm, y: 2.2cm), numbering: "1")
#set text(font: "New Computer Modern", size: 10.5pt)
#set par(justify: true)
#set heading(numbering: "1.")
#show raw.where(block: true): it => block(
  fill: luma(247), inset: 8pt, radius: 3pt, width: 100%, breakable: true,
  text(size: 8pt, it),
)

#align(center)[
  #text(size: 16pt, weight: "bold")[Why the 2-Selmer ranks agree]
  #v(2mm)
  #text(size: 10pt)[$y^2 = x^3 + a$ and $y^2 = x^3 - a^(-1)$ share their mod-2
  Galois module; what that explains, and what it leaves to check]
  #v(1mm)
  #text(size: 9pt, style: "italic")[on a question of Rene Pannekoek, MathOverflow 227987 (2015)]
]

#v(4mm)

= The question <sec-q>

Numerically, the Mordell--Weil ranks of $y^2 = x^3 + p^3$ and $y^2 = x^3 - p^3$ almost always
agree, the first exceptions being $p = 37, 61, 157, 193$. The curves are *not isogenous*, so the
correlation is puzzling. Looking instead at 2-Selmer ranks makes the pattern exact: they appear to
agree for *every* prime $p > 2$ --- including at $p = 37$, where the ranks are 0 and 2 but both
2-Selmer ranks are 3. The general form conjectured is:

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Conjecture.* For $a$ an *odd* integer, the elliptic curves
  $ E_a : y^2 = x^3 + a quad "and" quad E_(-1 slash a) : y^2 = x^3 - a^(-1) tilde.equiv y^2 = x^3 - a^5 $
  have equal 2-Selmer ranks.
]

The original statement is the case $a = p^3$; the variants with $x^3 plus.minus p$ against
$x^3 minus.plus p^5$, and $x^3 plus.minus p^2$ against $x^3 minus.plus p^4$, are $a = plus.minus p$
and $a = plus.minus p^2$.

Note that $a |-> -1 slash a$ is an *involution*, and that it is the natural one: the curves
$y^2 = x^3 + a$ are the sextic twists of one another, the twisting parameter lives in
$QQ^times slash (QQ^times)^6$, and $-1 slash a equiv -a^5$ there.

= The answer to "why are they correlated" <sec-module>

The 2-Selmer group of $E$ is cut out of $H^1(QQ, E[2])$ by local conditions. So two curves with
*isomorphic mod-2 Galois modules* have their 2-Selmer groups inside the *same* group, and their
ranks are constrained to be close whether or not the curves are isogenous. That is exactly what
happens here, and it is visible in one line.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Theorem A.* Let $a in QQ^times$ and let $A_b = QQ[t] slash (t^3 + b)$. Then
  $ theta |-> -1 slash theta $
  is an isomorphism of $QQ$-algebras $A_a -> A_(-1 slash a)$. Consequently
  $ E_a [2] tilde.equiv E_(-1 slash a) [2] $
  as $G_QQ$-modules, and the two 2-Selmer groups are subgroups of one and the same
  $H^1 (QQ, M)$.

  #v(2mm)
  _Proof._ If $theta^3 = -a$ then $(-1 slash theta)^3 = -1 slash theta^3 = 1 slash a$, so
  $-1 slash theta$ is a root of $t^3 - 1 slash a$; the map is a $QQ$-algebra map between
  3-dimensional algebras sending a generator to a generator, hence an isomorphism. For an elliptic
  curve $y^2 = f(x)$ with $f$ cubic, $E[2]$ *is* the $G_QQ$-set of roots of $f$ --- the non-zero
  points are $(theta_i, 0)$ --- with its induced $bb(F)_2$-structure. An isomorphism of the étale
  algebras is an isomorphism of the root sets as $G_QQ$-sets, hence of the modules. $qed$
]

So the curves, though non-isogenous, have the same 2-division field
$QQ(root(3, a), zeta_3)$ and the same mod-2 representation. Checked numerically on
$a = 3, 5, 7, 9, 11, 13, 15, 25, 27, -5, -7, 49, 121$: the factorisation types of $x^3 + a$ and
$x^3 - a^5$ agree at every good prime up to 300, and the 2-division fields are isomorphic.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *This already answers the question as asked.* "Why would the ranks of non-isogenous curves be
  correlated?" --- because rank correlation is not what is happening. The 2-*Selmer* ranks are
  correlated because the two curves share the object that 2-Selmer ranks are computed from. The
  Mordell--Weil ranks then agree whenever $Sha[2]$ does not intervene, and $p = 37$ is precisely
  a case where it does: the ranks are 0 and 2, the 2-Selmer ranks both 3, the difference being
  $dim Sha[2] = 2$ on one side and $0$ on the other.
]

= What remains: a purely local statement <sec-local>

Fix $M = E_a [2] = E_(-1 slash a) [2]$ and write $L_v (E) subset.eq H^1 (QQ_v, M)$ for the image of
$E(QQ_v) slash 2$ under the Kummer map $delta_v$. The first thing to record is that the *dimension*
of $L_v$ is not a property of the curve at all --- it depends only on $M$ and on $v$.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Lemma B$'$.* For every place $v$,
  $ dim_(bb(F)_2) L_v = cases(
    dim M^(G_v) & v "finite", v divides.not 2,
    dim M^(G_2) + 1 & v = 2,
    dim M^(G_infinity) - 1 & v = infinity.
  ) $
]

Since the two curves have the same $M$ by Theorem A, this already gives $dim L_v (E_a) = dim L_v
(E_(-1 slash a))$ at every place. Here are two proofs, because the second explains *why* the
answer is curve-independent.

=== First proof: the structure of $E(QQ_v)$ <sec-dimL-1>

The Kummer sequence
$ 0 -> E(QQ_v) slash 2 E(QQ_v) -->^(delta_v) H^1 (QQ_v, M) -> H^1 (QQ_v, E)[2] -> 0 $
makes $delta_v$ *injective*, so $dim L_v = dim_(bb(F)_2) E(QQ_v) slash 2 E(QQ_v)$, and it is that
group we must count.

For $K$ a finite extension of $QQ_p$, the formal group gives a finite-index subgroup of $E(K)$
isomorphic to $(frak(m)_K, +) tilde.equiv ZZ_p^([K : QQ_p])$, whence an isomorphism of topological
groups
$ E(K) tilde.equiv ZZ_p^([K : QQ_p]) times T, quad T "finite" . $
Now divide by 2. The finite part contributes $dim T slash 2T = dim T[2] = dim E(K)[2] = dim
M^(G_K)$, a finite abelian group having equal 2-rank in $T slash 2T$ and $T[2]$. The free part
contributes $dim ZZ_p^([K:QQ_p]) slash 2 = 0$ when $p$ is *odd*, since 2 is then invertible in
$ZZ_p$, and $[K : QQ_p]$ when $p = 2$. For $K = QQ_v$ this is the first two lines.

For $v = infinity$: $E(RR)$ is a compact real Lie group of dimension 1, so
$E(RR) tilde.equiv RR slash ZZ$ or $RR slash ZZ times ZZ slash 2$ according as the real locus has
one or two components. In the first case $E(RR)$ is 2-divisible and $E(RR) slash 2 = 0$, while
$E(RR)[2] = ZZ slash 2$; in the second $E(RR) slash 2 = ZZ slash 2$ and $E(RR)[2] = (ZZ slash 2)^2$.
Both times $dim E(RR) slash 2 = dim M^(G_infinity) - 1$, the point being that a real cubic always
has at least one real root, so $M^(G_infinity) != 0$.

=== Second proof: maximal isotropy and the Euler characteristic <sec-dimL-2>

This one is shorter and shows the shape of the answer. By Tate local duality, the Weil pairing
makes $M$ self-dual and the local condition $L_v$ is *its own annihilator* under the induced
pairing on $H^1 (QQ_v, M)$ --- the classical fact that the image of the Kummer map is maximal
isotropic. Hence
$ dim L_v = 1/2 dim H^1 (QQ_v, M) . $
For finite $v$ the local Euler characteristic formula gives
$ h^0 - h^1 + h^2 = -[QQ_v : QQ_2] dim M , $
with the convention $[QQ_v : QQ_2] = 0$ for $v divides.not 2$; and local duality together with
self-duality of $M$ gives $h^2 = h^0$. So
$ h^1 = 2 h^0 + [QQ_v : QQ_2] dim M = 2 dim M^(G_v) + 2 [QQ_v : QQ_2] , $
using $dim M = 2$, and halving returns $dim L_v = dim M^(G_v) + [QQ_v : QQ_2]$ --- the first two
lines at once. The archimedean place is not covered by that formula, and is the one place where the
count has to be done by hand, as above.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  Every quantity on the right-hand side --- $M^(G_v)$, $[QQ_v : QQ_2]$, $dim M$ --- is an invariant
  of the *Galois module*, not of the curve. That is the structural reason two curves with the same
  $M$ have local conditions of the same dimension at every place, and it is why the comparison in
  (#sym.star) is about which subspace, never about how big. A worked instance: at $v = 2$ we shall
  find $dim M^(G_2) = 1$, so $dim L_2 = 2$ and $|L_2| = 4$ --- which is exactly what the computation
  of @sec-pf-2 returns, for both curves and all four classes of $a$.
]

Both $L_v (E_a)$ and $L_v (E_(-1 slash a))$ are therefore maximal isotropic subspaces of the same
dimension in the same $H^1 (QQ_v, M)$. So the conjecture would follow at once from

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *(#sym.star)* $L_v (E_a) = L_v (E_(-1 slash a))$ for every place $v$.
]

and (#sym.star) is automatic at all but finitely many places:

- *good $v$*: both conditions are the unramified subgroup $H^1_"ur" (QQ_v, M)$, which depends only
  on $M$;
- *$v = infinity$*: $Delta(y^2 = x^3 + k) = -432 k^2 < 0$ for both curves, so both real loci are
  connected, $E(RR)$ is divisible by 2, and $L_infinity = 0$ on both sides.

The bad places are the same for both curves --- $2$, $3$ and the primes dividing $a$ --- so
everything reduces to a finite check there.

= The two descent maps differ by $-1$ <sec-lambda>

There is one more piece of structure, and it says the two descents are not merely parallel but
*aligned*.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Theorem B.* Under the identification of Theorem A, the $overline(QQ)$-isomorphism between the
  two curves carries the descent map of $E_a$ to $lambda$ times that of $E_(-1 slash a)$, where
  $ lambda = -1 slash theta^2 = -(1 slash theta)^2 equiv -1 quad "in" A_a^times slash (A_a^times)^2 . $

  #v(2mm)
  _Proof._ $x^3 - a^(-1) = x^3 + a u$ with $u = -a^(-2)$, so $E_(-1 slash a)$ is the sextic twist
  of $E_a$ by $u$ and the isomorphism over $overline(QQ)$ is $(x,y) |-> (u^(1 slash 3) x,
  u^(1 slash 2) y)$. It carries roots to roots, so $theta' = u^(1 slash 3) theta$, whence
  $u^(1 slash 3) = theta' slash theta = -1 slash theta^2$; and then
  $X - theta' = u^(1 slash 3)(x - theta)$. Finally $-1 slash theta^2$ is $-1$ times a square. $qed$
]

Two readings. First, the quadratic part of the twist is by $u^(1 slash 2) = a^(-1) sqrt(-1)$: the
involution $a |-> -1 slash a$ is *the quadratic twist by $-1$, composed with a cubic twist* --- and
for $a = p^3$ the cubic part is trivial, so the original question is exactly about the quadratic
twist by $-1$. Second, $chi_(-1)$ is ramified only at 2 and $infinity$, which is why the two curves
are so tightly coupled: at every odd place the twist is *unramified*.

= Where the hypothesis "$a$ odd" lives <sec-odd>

The conjecture is stated for odd $a$, and the computations say the restriction is not cosmetic. For
odd $a$ --- positive and negative, prime, prime power and composite --- the 2-Selmer ranks agree in
every case tested. For even $a$ they usually do *not*, and the failure is always by exactly one:

#align(center, table(
  columns: 4, align: (center, center, center, left),
  stroke: 0.4pt + luma(170), inset: (x: 7pt, y: 3.5pt),
  table.header([$a$], [$dim "Sel"_2 (x^3+a)$], [$dim "Sel"_2 (x^3-a^5)$], [ ]),
  [2],  [1], [0], [differ by 1],
  [6],  [0], [1], [differ by 1],
  [8],  [2], [1], [differ by 1],
  [10], [1], [0], [differ by 1],
  [12], [1], [0], [differ by 1],
  [14], [0], [1], [differ by 1],
  [16], [0], [1], [differ by 1],
  [18], [1], [0], [differ by 1],
))

#v(2mm)

Fourteen of the sixteen even $a$ tested disagree, every time by exactly 1. Since the local
conditions agree at every good place and at $infinity$ regardless of parity, and since 2 is the
only place where the quadratic part of the twist is ramified, this locates the whole content of the
conjecture at $v = 2$: *oddness of $a$ is what makes $L_2 (E_a) = L_2 (E_(-1 slash a))$.* A
discrepancy of exactly 1 is what one expects from a single place where two maximal isotropic
subspaces of a common $H^1 (QQ_2, M)$ meet in a hyperplane.

= Numerical verification <sec-num>

Sage's `selmer_rank` is $dim_(bb(F)_2) "Sel"_2$; in PARI, `ellrank` returns $[r_1, r_2, s, L]$ with
$C = T + r_2 + s$, where $T = dim E(QQ)[2]$ is 1 when $x^3 + a$ has a rational root and 0 otherwise.

```gp
dimtors2(E) = { my(f = factor(x^3 + E.a6));
  sum(i = 1, #f~, if(poldegree(f[i,1]) == 1, 1, 0)); }
C2(k) = { my(E = ellinit([0,0,0,0,k]), r);
  r = ellrank(E);
  if(dimtors2(E) > 0, 1, 0) + r[2] + r[3]; }
```

#align(center, table(
  columns: 3, align: (left, center, left),
  stroke: 0.4pt + luma(170), inset: (x: 7pt, y: 3.5pt),
  table.header([family], [agree / total], [comment]),
  [odd $a$, $|a| <= 25$], [26 / 26], [reproduces the original table],
  [odd $a$, mixed prime powers and composites], [19 / 19],
    [$3, 5, dots, 81, 99, 121, 125$],
  [odd $a < 0$], [12 / 12], [$-3, dots, -49$],
  [*even $a$*], [*2 / 16*], [always off by exactly 1],
))

= Completing the proof <sec-proof>

Everything now rests on (#sym.star), and the engine is the following, which is proved outright.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Lemma C.* Under the identification $theta |-> theta' = -1 slash theta$ of Theorem A, the two
  descent maps *agree on 2-torsion*: for every $i$,
  $ delta'(T'_i) = delta(T_i) quad "in" A^times slash (A^times)^2 . $

  #v(2mm)
  _Proof._ On the $i$-th coordinate the value is the derivative: $g'(theta'_i) = 3 theta_i'^2$
  against $f'(theta_i) = 3 theta_i^2$, and their ratio is $(theta'_i slash theta_i)^2$, a square.
  On the $j$-th coordinate, $j != i$,
  $ theta'_i - theta'_j = (-1 slash theta_i) + (1 slash theta_j)
    = (theta_i - theta_j) slash (theta_i theta_j) , $
  and $theta_i theta_j = theta_i^2 zeta$ for a cube root of unity $zeta$, because the three roots
  of $t^3 + a$ are $theta_i$ times the cube roots of unity. Now $theta_i^2$ is a square and
  $zeta = (zeta^2)^2$ is a square, $zeta$ having *odd* order 3. So the ratio is a square and the
  two coordinates agree. $qed$
]

That gives (#sym.star) wherever $L_v$ is spanned by the image of the 2-torsion, and it settles
three of the four ranges of places.

== The archimedean place, and the good places <sec-pf-good>

At a good $v$ both conditions are $H^1_"ur" (QQ_v, M)$, which depends only on $M$. At $v = infinity$
there is nothing to check at all: with $G = "Gal"(CC slash RR)$ acting on $M = {0, A, B, C}$ by
fixing $A$ and swapping $B, C$, one has $M^G = {0, A}$, $(sigma - 1)M = {0, B + C} = {0, A}$ and
$ker N = {0, A}$, so $H^1 (RR, M) = 0$.

== The place $v = 3$ <sec-pf-3>

Here $dim L_3 = dim E[2](QQ_3) <= 1$, since two independent rational 2-torsion points would force
$zeta_3 in QQ_3$, which is false. If the dimension is 0 both conditions vanish. If it is 1, then
$L_3$ is the line spanned by $delta(T)$ *provided* $delta(T) != 1$ --- and it is, because the
$QQ_3$-component of $delta(T)$ is
$ f'(theta_1) = 3 theta_1^2 equiv 3 , $
and 3 is a uniformiser at 3, hence not a square. So $L_3 = ⟨delta(T)⟩ = ⟨delta'(T')⟩ = L'_3$ by
Lemma C.

== The place $v = 2$: a finite, exhaustive check <sec-pf-2>

This is where the hypothesis "$a$ odd" lives, and where the argument becomes a computation --- but a
*complete* one, not a sample.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  Over $QQ_2$ every unit is a cube, since cubing is bijective on $ZZ_2^times$. So the cubic part of
  any sextic twist by a unit is trivial, and for $a$ odd the curve $E_a$ over $QQ_2$ depends only on
  the class of $a$ in $QQ_2^times slash (QQ_2^times)^2$ --- that is, only on $a bold("mod") 8$.
  *Four classes, and checking all four settles every odd $a$.*
]

`selmer-local2.gp` computes both conditions inside the single algebra
$A_2 = QQ_2 times K$, $K = QQ_2(zeta)$ unramified quadratic, using the identification
$theta' = -1 slash theta$: the descent value of $E'$ at $X$ is $X + 1 slash theta$ in the
$QQ_2$-component and $(X - 1 slash theta) - (1 slash theta) zeta$ in the $K$-component. Both come
out as groups of order 4 --- which is $dim L_2 = dim M^(G_2) + 1 = 2$, as it must be --- and they
*coincide*, for $a equiv 1, 3, 5, 7$ modulo 8.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *(#sym.star) holds at $v = 2$ for every odd $a$.*
]

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *Two wrong turns, both caught by parity.* Comparing $L_2 (y^2 = x^3 + a)$ with
  $L_2 (y^2 = x^3 - a)$ under the *naive* identification --- cube root against cube root --- reports
  a disagreement, but it is meaningless: that identification differs from $theta |-> -1 slash theta$
  by an automorphism of $E[2]$, so it compares subspaces of two different copies of $H^1$. And a
  slip in the 2-torsion entry for $E'$, where
  $theta'_1 - theta'_2 = (zeta^2 - 1) slash theta = (-2 - zeta) slash theta$, inflated the group to
  order 8 --- impossible, since $dim L_2 = 2$. Both were exposed by the parity constraint: the
  comparison formula of @sec-status forces the Selmer ranks to differ by an odd number if 2 is the
  *only* place of discrepancy, and the ranks are equal.
]

== The primes dividing $a$ <sec-pf-a>

The last range. Everything is decided by two valuations.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Proposition E.* Let $v$ be an odd prime, $v != 3$, with $v divides a$. Then
  $L_v (E_a) = L_v (E_(-1 slash a))$.

  #v(2mm)
  _Proof._ Sixth powers change neither curve, so we may take $m = v(a)$ with $1 <= m <= 5$.

  #v(1.5mm)
  *(i)* If $3 divides.not m$, a root of $t^3 + a$ would have valuation $m slash 3 in.not ZZ$, so
  $E[2](QQ_v) = 0$ and $dim L_v = dim E[2](QQ_v) = 0$. Both conditions vanish.

  #v(1.5mm)
  *(ii)* So $m = 3$; write $a = v^3 a_0$ with $v divides.not a_0$. A root lies in $QQ_v$ only if
  $a_0$ is a cube in $ZZ_v^times$; if it is not, again $L_v = 0 = L'_v$.

  #v(1.5mm)
  *(iii)* Otherwise let $theta_1 in QQ_v$ be that root, so $v(theta_1) = 1$, the others being
  $theta_1 zeta$ and $theta_1 zeta^2$. Two valuations decide everything:
  $ v(f'(theta_i)) = v(3 theta_i^2) = 2 quad "is EVEN" quad (v != 3), $
  $ v(theta_i - theta_j) = v(theta_1 (zeta^r - zeta^s)) = 1 quad "is ODD" quad (i != j), $
  the second because $N(1 - zeta) = (1-zeta)(1-zeta^2) = 3$ is a *unit* at $v$, so $zeta^r - zeta^s$
  is a unit. Now split on $v$ modulo 3.

  #v(1.5mm)
  If $v equiv 2$ $(mod 3)$ then $zeta in.not QQ_v$, $t := dim L_v = 1$, and
  $A_v = QQ_v times F$ with $F = QQ_v (zeta)$ unramified quadratic. The $F$-component of
  $delta(T_1)$ is $theta_1 (1 - zeta)$, of *odd* valuation, hence not a square; so
  $delta(T_1) != 1$ and it spans the line $L_v$.

  #v(1.5mm)
  If $v equiv 1$ $(mod 3)$ then $zeta in QQ_v$, $t = 2$, and $A_v = QQ_v^3$. Reading off
  valuation parities coordinate by coordinate,
  $ delta(T_1) |-> (0, 1, 1), quad delta(T_2) |-> (1, 0, 1) , $
  which are independent over $bb(F)_2$; so $delta(T_1), delta(T_2)$ span the 2-dimensional $L_v$.

  #v(1.5mm)
  In both cases the image of the 2-torsion is all of $L_v$, and Lemma C identifies it with the image
  of the 2-torsion of $E'$, which is all of $L'_v$. Hence $L_v = L'_v$. $qed$
]

The same valuation argument is what settled $v = 3$ in @sec-pf-3, there in the simpler form that
$3$ is a uniformiser, so that $v_3 (3 theta_1^2)$ is *odd* and $delta(T)$ cannot be trivial. Note
that the two cases of (iii) are exactly the fibres of type $"I"_0^*$ with $c_v = 2$ and $c_v = 4$:
the local image is the 2-torsion of the component group, and it is spanned by the 2-torsion of the
curve --- the situation Proposition 9 of the companion survey describes in general.

= Status <sec-status>

*Proved here.* Theorem A --- the two curves have isomorphic mod-2 Galois modules, by the explicit
algebra isomorphism $theta |-> -1 slash theta$. This is what makes the correlation structural
rather than accidental, and it is what the question was asking for. Theorem B --- the descent maps
differ by $-1$ modulo squares, and the involution is the quadratic twist by $-1$ composed with a
cubic twist, so that at every *odd* place the twist is unramified. The reduction of the conjecture
to the local statement (#sym.star), together with its verification at the good places and at
$infinity$.

*Also proved (@sec-proof).* Lemma C: the two descent maps agree on 2-torsion, by an explicit
computation with $theta_i theta_j = theta_i^2 zeta$ and the fact that $zeta$ has odd order. With it,
(#sym.star) holds at every good place, at $infinity$ (where $H^1 (RR, M) = 0$), at $v = 3$ (where
$dim L_3 <= 1$ and $delta(T)$ has $QQ_3$-component the class of the uniformiser 3, hence is
non-trivial), and --- by a finite and *exhaustive* computation, four classes covering every odd $a$
--- at $v = 2$.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Theorem.* Let $a$ be an odd integer. Then
  $ "Sel"_2 (y^2 = x^3 + a) = "Sel"_2 (y^2 = x^3 - a^(-1)) $
  *as subgroups of $H^1 (QQ, M)$*; in particular the two 2-Selmer ranks are equal.

  #v(2mm)
  _Proof._ Theorem A identifies the two mod-2 modules, so both Selmer groups are cut out of the same
  $H^1 (QQ, M)$ by local conditions. Those conditions agree at every place: at $infinity$ because
  $H^1 (RR, M) = 0$; at every good place because both are $H^1_"ur"$; at $v = 3$ by @sec-pf-3; at
  the odd $v divides a$ by Proposition E; and at $v = 2$ by the exhaustive computation of
  @sec-pf-2, four square classes covering every odd $a$. Equal local conditions cut out equal
  Selmer groups. $qed$
]

*The one computational input* is @sec-pf-2, and it is finite and exhaustive rather than a sample:
over $QQ_2$ the curve depends only on $a$ modulo 8. A hand proof there would make the argument
entirely free of machine computation, and is the only thing still worth doing.

*Where the hypothesis is used.* Oddness of $a$ enters exactly once, at $v = 2$: it is what makes the
sextic twist parameter a *unit*, hence a cube, hence reduces $E_a slash QQ_2$ to a quadratic twist
class depending only on $a bold("mod") 8$. For even $a$ that fails, and so does the conclusion ---
14 of the 16 even $a$ tested have Selmer ranks differing by exactly 1.

*A remark on what "equal" costs.* Comparing two Selmer structures on a self-dual module, the
Greenberg--Wiles formula gives only
$ dim "Sel"(L) equiv dim "Sel"(L') + sum_v dim (L_v slash (L_v inter L'_v)) quad (mod 2) . $
So parity agreement already requires the local discrepancies to cancel modulo 2, and the observed
*equality* is the stronger statement that they vanish one by one. That is why (#sym.star), and not
a parity argument, is the right target.
