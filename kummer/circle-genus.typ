#import "@preview/cetz:0.4.2"

#set page(paper: "a4", margin: (x: 2.0cm, y: 2.2cm), numbering: "1")
#set text(font: "New Computer Modern", size: 10.5pt)
#set par(justify: true)
#set heading(numbering: "1.")
#show link: set text(fill: blue.darken(20%))
#show raw.where(block: true): it => block(
  fill: luma(247), inset: 8pt, radius: 3pt, width: 100%, breakable: true,
  text(size: 8pt, it),
)

#let data = json("circle-genus.json")
#let red = rgb("#c0392b")
#let blue = rgb("#1f5fbf")
#let fills = (A: rgb("#d6e4f0"), B: rgb("#f6dcc8"))
#let fmt(x, d: 4) = str(calc.round(x, digits: d))

// "A3" -> A with subscript 3
#let lab(s) = math.equation(math.attach(math.italic(s.at(0)), b: s.slice(1)))

// one configuration: the rectangle [0, W] x [0, 1] and the eight circles.
// The quadrilateral gap A2 A3 B3 B2 is marked by the two diagonals:
// A3 -- B2 in red, A2 -- B3 in blue; a diagonal is drawn solid when the two
// circles touch, dotted otherwise.
#let config(m, unit: 1.6cm, labels: true) = cetz.canvas(length: unit, {
  import cetz.draw: *
  let W = m.W
  rect((0, 0), (W, 1), stroke: 0.9pt)
  let get(l) = m.circles.find(c => c.label == l)
  for c in m.circles {
    circle((c.x, c.y), radius: c.r, fill: fills.at(c.label.at(0)), stroke: 0.55pt)
  }
  for (p, q, col) in (("A3", "B2", red), ("A2", "B3", blue)) {
    let a = get(p)
    let b = get(q)
    let gap = calc.sqrt(calc.pow(a.x - b.x, 2) + calc.pow(a.y - b.y, 2)) - a.r - b.r
    line((a.x, a.y), (b.x, b.y),
      stroke: if gap < 1e-9 { 1.0pt + col } else { (paint: col, thickness: 0.7pt, dash: "dotted") })
  }
  if labels {
    for c in m.circles {
      content((c.x, c.y + if c.label in ("A2", "A3") { 0.1 } else if c.label in ("B2", "B3") { -0.1 } else { 0 }),
        text(7.5pt, lab(c.label)))
    }
  }
})

// the real loci of H (black) and H^sigma (grey) in the (t, v)-plane
#let locus(unit: 1.55cm) = cetz.canvas(length: unit, {
  import cetz.draw: *
  let (lo, hi) = (-1.5, 2.5)
  rect((lo, lo), (hi, hi), stroke: 0.5pt + luma(150))
  line((lo, 0), (hi, 0), stroke: 0.3pt + luma(190))
  line((0, lo), (0, hi), stroke: 0.3pt + luma(190))
  line((lo, lo), (hi, hi), stroke: (paint: luma(170), thickness: 0.4pt, dash: "dashed"))
  for tick in (-1, 1, 2) {
    content((tick, lo - 0.18), text(7pt)[#tick])
    content((lo - 0.18, tick), text(7pt)[#tick])
  }
  content((hi + 0.15, lo - 0.18), text(8pt)[$t$])
  content((lo - 0.18, hi + 0.12), text(8pt)[$v$])
  for (i, p) in data.locus.minus.enumerate() {
    if calc.rem(i, 3) == 0 { circle((p.at(0), p.at(1)), radius: 0.011, fill: luma(175), stroke: none) }
  }
  for (i, p) in data.locus.plus.enumerate() {
    if calc.rem(i, 3) == 0 { circle((p.at(0), p.at(1)), radius: 0.011, fill: black, stroke: none) }
  }
  let (t0, v0) = (data.packing.at(0), data.packing.at(1))
  line((t0, v0), (v0, t0), stroke: 2.2pt + red)
  for f in data.fixed {
    circle((f, f), radius: 0.04, fill: white, stroke: 0.7pt)
  }
  circle((t0, v0), radius: 0.035, fill: red, stroke: none)
  circle((v0, t0), radius: 0.035, fill: blue, stroke: none)
})

#align(center)[
  #text(size: 16pt, weight: "bold")[An elliptic curve of circle configurations]
  #v(2mm)
  #text(size: 10pt)[Drop one tangency from a rigid packing of eight circles in a rectangle,
  and the configurations that remain form a curve of genus $1$ over $QQ(sqrt(2))$, with
  $j = 418576 - 274424 sqrt(2)$]
  #v(1mm)
  #text(size: 9pt, style: "italic")[computations in `circle-genus.sage`, output in
  `results/circle-genus.txt`, figure data in `circle-genus.json`; the survey of small
  patterns in `circle-genus-survey.sage`, output in `results/circle-genus-survey.txt`]
]

#v(4mm)

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *Results.* Circles are packed in a rectangle of height $1$, $K = QQ(sqrt(2))$.
  + A rigid packing whose gaps are all triangles becomes a one-parameter family when one
    tangency is dropped. For the two-row zigzags, dropping a tangency between the rows at a
    turn of the pattern, the family is a plane curve $Phi(t, v) = 0$ over $K$, with
    $t, v$ the square roots of the radii of the two top corner circles (@sec-family).
  + For up to eight circles ($k <= 4$) all these curves are rational except for one
    symmetry class: the pattern `11 21 22 32 33 34 44` without the tangency $A_3 B_2$
    (@sec-survey). Its curve
    $ H : quad t^2 v^2 - 3/2 t^2 v - 3/2 t v^2 + 2 t v + sqrt(2)/4 (t^2 + v^2 - t - v) = 0 $
    has *genus $1$* (@sec-elliptic).
  + Its $j$-invariant is $j = 418576 - 274424 sqrt(2) = -sqrt(2)^7 (2 sqrt(2) - 3) (17 sqrt(2) + 1)^3$,
    which is not rational. The Jacobian has conductor $(sqrt(2))^9$, torsion $ZZ \/ 4$, no
    complex multiplication, and it is not isogenous to its Galois conjugate.
  + The honest packings on $H$ form an arc that joins the packing to its mirror image: along
    it the quadrilateral gap flips from one diagonal to the other (@fig-family). The mirror
    symmetry is the involution $(t, v) |-> (v, t)$ of $H$.
  + The Galois conjugate curve $H^sigma$ is the family of configurations with the same
    tangencies in which every circle sits on the other side of its construction; it contains
    no honest packing (@sec-conjugate).
  + Halfway along the arc the configuration is two reflected copies of the four-circle
    packing of a unit square, side by side, with $W = 2$ exactly.
]

= Setting <sec-setting>

Consider $n$ circles with disjoint interiors in the rectangle $[0, W] times [0, 1]$. A _gap_
is a connected component of the rectangle minus the closed disks. The _pattern_ of a packing
is the list of its tangencies, circle--circle and circle--side, with the four sides named.

*Counting.* With the height fixed, a packing has $3n + 1$ unknowns: a centre and a radius for
each circle, and the width $W$. Each tangency is one equation. Join the circles and the four
sides into a planar graph, with an edge for every tangency and the four corners of the
rectangle as edges between adjacent sides. Euler's formula for this graph, with its outer
face of length $4$, gives
$ \#"tangencies" <= 3n + 1, $
with equality exactly when every gap is a curvilinear triangle. Such a pattern is called
_triangulated_. It has as many equations as unknowns, and by the Koebe--Andreev--Thurston
theorem with intersection angles, applied to the sides as circles through $infinity$, it has
exactly one packing (`circle-packings.typ`, §2). The packing is then _rigid_.

*Dropping a tangency.* Remove one tangency from a triangulated pattern. One triangle merges
with its neighbour into a quadrilateral gap, and there are $3n$ equations in $3n + 1$
unknowns. At the packing the Jacobian of the full system is invertible, so after the removal
the solutions form a smooth curve near the packing. Let $C$ be the irreducible component of
the complex solution set through the packing. This is _the family_ of the dropped pattern,
and the question is its geometric genus.

*Two-row zigzags.* Put circles $A_1, dots, A_k$ along the top and $B_1, dots, B_k$ along the
bottom. Neighbours in a row touch, $A_1, B_1$ touch the left side and $A_k, B_k$ the right
side. The tangencies between the rows must triangulate the strip between the rows, so they
form a lattice path of $2k - 1$ pairs $(i, j)$ from $(1, 1)$ to $(k, k)$, each step raising
$i$ or $j$ by one. A pair $(i, j)$ means that $A_i$ and $B_j$ touch. This gives
$2k + 4 + 2(k - 1) + (2k - 1) = 6k + 1 = 3n + 1$ tangencies, so every lattice path is a
triangulated pattern. A pattern is written as its list of pairs, for example
`11 21 22 32 33 34 44`.

= Square-root coordinates <sec-coords>

Write $a_i = sqrt(r(A_i))$ and $b_j = sqrt(r(B_j))$, and let $X_i$, $Y_j$ be the
$x$-coordinates of the centres. The centre of $A_i$ is $(X_i, 1 - a_i^2)$, and that of $B_j$
is $(Y_j, b_j^2)$.

- *Within a row.* Two circles of radii $r, r'$ touching a line have their points of contact
  $2 sqrt(r r')$ apart. So $X_(i+1) - X_i = 2 a_i a_(i+1)$, and similarly in the bottom row.
- *Across the rows.* $A_i$ and $B_j$ touch when
  $(X_i - Y_j)^2 + (1 - a_i^2 - b_j^2)^2 = (a_i^2 + b_j^2)^2$, that is,
  $ (X_i - Y_j)^2 = 2 (a_i^2 + b_j^2) - 1. quad (\*) $
- *At a corner.* If $A_1$ and $B_1$ both touch the left side, then $X_1 = a_1^2$,
  $Y_1 = b_1^2$, and their points of contact with that side are $2 a_1 b_1$ apart. Since
  they cover the whole side, $a_1^2 + 2 a_1 b_1 + b_1^2 = 1$, so $a_1 + b_1 = 1$.

From now on the $a_i, b_j$ are allowed to be negative or complex. They are coordinates in
which the equations become polynomial; a packing has all of them positive.

*Lemma (one step).* Suppose $A_i$ and $B_j$ touch, and $A_(i+1)$ touches the top, $A_i$ and
$B_j$. Then
$ a_i / a_(i+1) = Y_j - X_i + sqrt(2) thin b_j quad "or" quad a_i / a_(i+1) = Y_j - X_i - sqrt(2) thin b_j. $
Symmetrically, if $B_(j+1)$ touches the bottom, $B_j$ and $A_i$, then
$b_j \/ b_(j+1) = X_i - Y_j plus.minus sqrt(2) thin a_i$. In a packing the sign is $+$.

_Proof._ Put $D = X_i - Y_j$, so $D^2 = 2(a_i^2 + b_j^2) - 1$ by (\*). The tangency
of $A_(i+1)$ with $B_j$ is (\*) with $X_(i+1) = X_i + 2 a_i a_(i+1)$:
$ (D + 2 a_i a_(i+1))^2 = 2(a_(i+1)^2 + b_j^2) - 1. $
Subtracting the equation for $D^2$ and dividing by $a_(i+1)^2$ gives a quadratic equation
for $c = a_i \/ a_(i+1)$:
$ c^2 + 2 D c + 2 a_i^2 - 1 = 0, quad c = -D plus.minus sqrt(D^2 - 2 a_i^2 + 1) = -D plus.minus sqrt(2) thin b_j . $
The two roots are the two circles that touch the top, $A_i$ and $B_j$: one in the gap to the
right of $A_i$, one beyond. For the packing it is the $+$ root, which was checked on every
packing used below. $square$

So *no new square root ever appears*. Starting from $t = a_1$, $b_1 = 1 - t$, $X_1 = t^2$,
$Y_1 = (1 - t)^2$ and following the lattice path, every $a_i, b_j, X_i, Y_j$ becomes a
rational function of $t$ over $K = QQ(sqrt(2))$. The rigid packing is then cut out by one
equation in $t$: both end circles touch the right side, $X_k + a_k^2 = Y_k + b_k^2$. Its
field is $K(t)$, with $t$ a root of an irreducible polynomial $f in K[t]$.

= Dropping a tangency at a turn <sec-family>

Say the path _turns_ at $(i_0, j_0)$ if the step into it raises one index and the step out
raises the other. Drop the tangency $A_(i_0) B_(j_0)$.

*Two chains.* Without that tangency, the recursion of @sec-coords cannot pass $(i_0, j_0)$.
It builds a _left chain_, the circles of the pairs before $(i_0, j_0)$, from $t = a_1$. Read
from the right side, in the coordinate $x' = W - x$ and with the labels reversed, the same
recursion builds a _right chain_, the circles of the pairs after $(i_0, j_0)$, from
$v = a_k$. The circles $A_(i_0)$ and $B_(j_0)$ end up in different chains. The two chains
are joined by two tangencies within the rows across the cut: if the step into
$(i_0, j_0)$ raised $i$, these are $A_(i_0 - 1) A_(i_0)$ and $B_(j_0) B_(j_0 + 1)$. Each
one gives a formula for $W$:
$ W = X_(i_0 - 1) + 2 a_(i_0 - 1) a_(i_0) + X'_(i_0), quad
  W = Y_(j_0) + 2 b_(j_0) b_(j_0 + 1) + Y'_(j_0 + 1), $
where the primes are coordinates in the right chain. Equating them gives one equation
$ Phi(t, v) = 0 $
with $Phi in K(t, v)$. Every tangency of the dropped pattern holds on its zero set.

*Proposition.* Let $H$ be the irreducible factor over $K$ of the numerator of $Phi$ that
vanishes at the packing. Then $H = 0$ is birational to the family $C$ of @sec-setting.

_Proof._ Every centre, radius and $W$ is a rational function of $(t, v)$, which gives a map
from $H = 0$ to $C$. Conversely $t = a_1$ is the rational function
$t = (1 + r(A_1) - r(B_1)) \/ 2$ on $C$, by the corner relation $a_1 + b_1 = 1$, and $v$ is
the same expression at the right side. $square$

So the genus of the family is the geometric genus of the plane curve $H = 0$. Two remarks:

- *Real points.* The packing is one real point of $H$. Moving along the real branch through
  it, the two circles $A_(i_0), B_(j_0)$ separate on one side and overlap on the other. On
  the separating side the configurations are honest packings of the dropped pattern, until
  some other pair of circles touches.
- *Bidegree.* If $H$ is linear in $v$, then $v$ is a rational function of $t$ and $H$ is
  rational; the same holds with $t$ and $v$ exchanged. Genus $> 0$ needs degree at least $2$
  in both.

= Survey of the zigzags up to eight circles <sec-survey>

`circle-genus.sage` computes $H$ and its genus (Singular, over $K$) for every two-row zigzag
with $k <= 4$ and every turn. Patterns and dropped tangencies related by a symmetry of the
rectangle give isomorphic curves; @tab-survey lists one per class.

#figure(
  table(
    columns: 5, stroke: none, inset: (x: 6pt, y: 2.5pt), align: (center, left, center, center, center),
    table.hline(),
    table.header([$k$], [pattern], [dropped], [bidegree of $H$], [genus]),
    table.hline(stroke: 0.5pt),
    [2], [`11 21 22`], [$A_2 B_1$], [$(1, 1)$], [0],
    table.hline(stroke: 0.3pt + luma(180)),
    [3], [`11 21 31 32 33`], [$A_3 B_1$], [$(1, 1)$], [0],
    [3], [`11 21 22 32 33`], [$A_2 B_2$], [$(1, 1)$], [0],
    [3], [`11 21 22 32 33`], [$A_2 B_1$], [$(1, 2)$], [0],
    [3], [`11 21 22 23 33`], [$A_2 B_1$], [$(1, 2)$], [0],
    table.hline(stroke: 0.3pt + luma(180)),
    [4], [16 classes], [], [$(1,1)$, $(1,2)$, $(1,3)$, $(2,1)$, $(3,1)$], [0],
    [4], [`11 21 22 32 33 34 44`], [$A_3 B_2$], [$(2, 2)$], [*1*],
    table.hline(),
  ),
  kind: table,
  caption: [Dropping a tangency at a turn, for all two-row zigzags with $k <= 4$; one row per
  symmetry class of (pattern, dropped tangency). The $16$ rational classes for $k = 4$ are
  listed in `results/circle-genus.txt`. The six circles of the MathOverflow problem are
  `11 12 22 23 33`, which is in the class of `11 21 22 32 33`.],
) <tab-survey>

Every curve but one is a graph over one of the two coordinates. The exception is the only
curve of bidegree $(2, 2)$, and it has genus $1$. Its symmetry class consists of four
patterns: `11 21 22 32 33 34 44` without $A_3 B_2$, its mirror image `11 21 22 23 33 34 44`
without $A_2 B_3$, and their reflections in the horizontal axis.

= The genus-one family <sec-elliptic>

Take the pattern `11 21 22 32 33 34 44` and drop $A_3 B_2$. The left chain is
$A_1, A_2, B_1, B_2$ with the tangencies `11 21 22`; the right chain is
$A_3, A_4, B_3, B_4$ with `33 34 44`; they are glued by $A_2 A_3$ along the top and
$B_2 B_3$ along the bottom. The gap bounded by $A_2, A_3, B_3, B_2$ is now a quadrilateral.

*The two chains are mirror images.* Under the reflection $x |-> W - x$ the right chain
`33 34 44` becomes `11 21 22`, the left chain. So the dropped pattern is symmetric under
the reflection, although the full pattern is not: the reflection takes the tangency
$A_3 B_2$ to $A_2 B_3$. The full pattern with $A_2 B_3$ instead is the mirror pattern
`11 21 22 23 33 34 44`. On the curve the reflection is the involution
$ iota : (t, v) |-> (v, t), $
and indeed the computation gives
$ H(t, v) = t^2 v^2 - 3/2 t^2 v - 3/2 t v^2 + 2 t v + sqrt(2)/4 (t^2 + v^2 - t - v), $
symmetric in $t$ and $v$. The mirror pattern gives the same curve.

*The honest arc is a flip.* The packing is the point
$(t_0, v_0) = (0.450498 dots, 0.467287 dots)$ of $H$, where $t_0$ is a root of
$ f(t) = t^3 - sqrt(2)/2 t^2 + (3 sqrt(2)/4 - 3/2) t + 1/4, $
so the packing has degree $6$ over $QQ$. Its mirror image, the packing of the mirror pattern,
is the point $(v_0, t_0)$. Along the real branch from $(t_0, v_0)$ to $(v_0, t_0)$ every
configuration is an honest packing of the dropped pattern; just beyond either end it is not
(checked at $200$ points, and on a grid of step $10^(-3)$ along the whole real locus). At one
end $A_3$ touches $B_2$, at the other end $A_2$ touches $B_3$. The family is the continuous
flip of the quadrilateral gap from one diagonal to the other, @fig-family. Halfway, at a
fixed point of $iota$, the configuration is symmetric:
$ t = v = 1 - sqrt(1 - sqrt(2) \/ 2) = 0.458804 dots . $
This member is exactly two copies of the four-circle packing `11 21 22`, the zigzag with
$k = 2$, which fills a unit square. The second copy is reflected and placed next to the
first. So $W = 2$, the circles $A_2, A_3$ touch each other on the line $x = 1$, and so do
$B_2, B_3$. The radii are $1 - sqrt(2)\/2$ for $A_2, A_3, B_1, B_4$ and
$t^2 = 0.210501 dots$ for $A_1, A_4, B_2, B_3$. In fact, on the diagonal of $H$ the width is
$W = 2 t^2 (t - 1)^2 \/ (t - sqrt(2)\/2)^2$, which equals $2$ exactly at the two fixed points
$1 plus.minus sqrt(1 - sqrt(2)\/2)$.

#figure(
  {
    let ms = data.members
    grid(
      columns: 2, column-gutter: 6mm, row-gutter: 3mm, align: center + bottom,
      ..ms.slice(0, 4).map(m => stack(dir: ttb, spacing: 1.2mm,
        config(m, unit: 3.4cm),
        text(8pt)[$t = #fmt(m.t, d: 5)$, $v = #fmt(m.v, d: 5)$, $W = #fmt(m.W, d: 5)$])),
    )
    v(2mm)
    let m = ms.at(4)
    stack(dir: ttb, spacing: 1.2mm,
      config(m, unit: 3.4cm),
      text(8pt)[$t = #fmt(m.t, d: 5)$, $v = #fmt(m.v, d: 5)$, $W = #fmt(m.W, d: 5)$])
  },
  caption: [The honest arc of the genus-one family. Top left: the rigid packing of
  `11 21 22 32 33 34 44`, where $A_3$ and $B_2$ touch (solid red). Then a quarter of the way
  along the arc, the symmetric member at the fixed point of $iota$, three quarters of the
  way, and the rigid packing of the mirror pattern `11 21 22 23 33 34 44`, where $A_2$ and
  $B_3$ touch (solid blue). In between, neither diagonal of the quadrilateral gap
  $A_2 A_3 B_3 B_2$ is a tangency (dotted). The width is $2.00486$ at both ends and
  exactly $2$ in the middle, where the configuration is two reflected copies of the
  four-circle square packing.],
) <fig-family>

*Genus.* As a quadratic in $v$, $H = alpha(t) v^2 + beta(t) v + gamma(t)$ with
$alpha = t^2 - 3/2 t + sqrt(2)/4$. Completing the square, $H = 0$ is birational over
$K$ to
$ w^2 = Delta(t) = beta^2 - 4 alpha gamma
  = (9/4 - sqrt(2)) t^4 + (5/2 sqrt(2) - 6) t^3 + (7/2 - 3/4 sqrt(2)) t^2
    + (1/2 - sqrt(2)) t + 1/8 . $
The quartic $Delta$ is squarefree, so this is a curve of genus $1$. It has the $K$-rational
point $(t, v) = (0, 0)$, a degenerate configuration in which $A_1$ has radius $0$. So $H$ is an
elliptic curve over $K$.

*The $j$-invariant.* For a quartic $a t^4 + b t^3 + c t^2 + d t + e$ put
$I = 12 a e - 3 b d + c^2$ and $J = 72 a c e + 9 b c d - 27 a d^2 - 27 b^2 e - 2 c^3$. The
Jacobian of $w^2 = Delta(t)$ is $y^2 = x^3 - 27 I x - 27 J$, with
$j = 6912 I^3 \/ (4 I^3 - J^2)$. Here $I = 163\/4 - 57\/2 sqrt(2)$,
$J = 2061\/4 sqrt(2) - 2917\/4$, and
$ j = 418576 - 274424 sqrt(2) = -sqrt(2)^7 thin (2 sqrt(2) - 3) thin (17 sqrt(2) + 1)^3
  approx 30486.4, $
with minimal polynomial $j^2 - 837152 j + 24588804224$ over $QQ$. A minimal model of the
Jacobian is
$ E : quad y^2 = x^3 - sqrt(2) thin x^2 - (6 sqrt(2) + 11) x + 15 sqrt(2) + 22 . $

*Arithmetic of $E$.*
- The conductor is $(sqrt(2))^9$, of norm $2^9$; the minimal discriminant has norm $2^17$.
  So $E$ has good reduction at every odd prime. The model $w^2 = Delta(t)$ does too: the
  discriminant of $Delta$ is a unit, $239 - 169 sqrt(2)$, times a power of $sqrt(2)$.
- The torsion subgroup of $E(K)$ is $ZZ \/ 4$. $E$ has no complex multiplication.
- $E$ is not a $QQ$-curve. At the two primes of $K$ above $p = 7$ the traces of Frobenius are
  $a_frak(p)(E) = 0$ and $-4$, while for the conjugate curve $E^sigma$ they are $-4$ and $0$.
  So $E$ and $E^sigma$ are not isogenous, and $j$ cannot be moved into $QQ$ by any choice of
  model. The same happens at $17, 23, 31, 41, 47$.
- The rank of $E(K)$ has not been determined: Simon's $2$-descent in Sage failed on this
  curve.

*Reduction modulo primes.* For every prime $frak(p)$ of $K$ not above $2$ the reduction of
$H$ is a curve of genus $1$ over the residue field, with $j$-invariant $j mod frak(p)$.
For the primes of degree one:
#align(center, table(
  columns: 7, stroke: none, inset: (x: 7pt, y: 2pt), align: center,
  table.hline(),
  [$p$], [7], [17], [23], [31], [41], [47],
  table.hline(stroke: 0.5pt),
  [$frak(p)$], [$2 sqrt(2) - 1$], [$3 sqrt(2) + 1$], [$sqrt(2) + 5$], [$4 sqrt(2) + 1$], [$2 sqrt(2) - 7$], [$sqrt(2) + 7$],
  [$j mod frak(p)$], [6], [11], [8], [17], [30], [25],
  [$j mod frak(p)^sigma$], [2], [10], [13], [11], [25], [10],
  table.hline(),
))
The inert primes give $j in FF_(p^2)$; for example $j equiv 1 + sqrt(2)$ modulo $3$ and
modulo $5$. The full list is in `results/circle-genus.txt`.

*The quotient by $iota$.* The fixed points of $iota$ on $H$ are the points with $t = v$,
the roots of $H(t, t) = t (t - 1)(t^2 - 2 t + sqrt(2) \/ 2)$:
$ t = v in {0, quad 1, quad 1 plus.minus sqrt(1 - sqrt(2) \/ 2)}. $
None lies at infinity, since the coefficient of $t^2 v^2$ is $1$. An involution of a genus-one
curve with $4$ fixed points has quotient of genus $0$ by Riemann--Hurwitz,
$0 = 2(2 g' - 2) + 4$. So $H \/ iota$ is a rational curve, and $H$ is a double cover of it
branched over the images of these four symmetric configurations. One of them is the
symmetric honest packing of @fig-family.

#figure(
  locus(),
  caption: [The real points of $H$ (black) and of its conjugate $H^sigma$ (grey) in the
  $(t, v)$-plane, $-1.5 <= t, v <= 2.5$. Red: the honest arc, from the packing (red dot)
  to the mirror packing (blue dot); at this scale it is very short, since $t$ only runs from
  $0.4505$ to $0.4673$. Open circles: the four fixed points of $iota$ on the
  diagonal $t = v$ (dashed).],
) <fig-locus>

= The conjugate curve <sec-conjugate>

$H$ is defined over $K$ and not over $QQ$. Its conjugate $H^sigma$, with
$sqrt(2) |-> -sqrt(2)$, is also a family of configurations of the dropped pattern. The
equations of @sec-setting in the coordinates $(x, y, r, W)$ have rational coefficients, so
$sigma$ permutes the components of their solution set. $H^sigma$ is the component through the
conjugate rigid configurations, the real roots of $f^sigma$:
$t = -2.0295, 0.1008, 1.2216$.

Concretely, $H^sigma$ is what the recursion gives with $-sqrt(2)$ in every step. By the lemma
of @sec-coords, the root $-sqrt(2)$ places the new circle on the other side: of the two
circles touching the top, $A_i$ and $B_j$, it takes the one beyond $A_i$ rather than the one
in the gap. In the conjugate configuration at $t = 0.1008$, for example, $A_2$ lies to the
left of $A_1$, the width comes out negative ($W = -0.690$), and $A_3, A_4$ have radii larger
than $1$. All the tangencies of the pattern hold, but the circles are folded over each other.
Of $14974$ real points of $H^sigma$ with $-4 <= t <= 4$, sampled with step $10^(-3)$, none
is an honest packing; of the $16002$ sampled real points of $H$, the $17$ honest ones all lie
on the arc of @fig-family.

Since $E$ is not isogenous to $E^sigma$, the two families are not even isogenous: the
honest family and its folded twin are different elliptic curves, with $j$-invariants
$418576 minus.plus 274424 sqrt(2)$.

= Other tangencies and smaller patterns <sec-general>

The two-chain construction of @sec-family needs the dropped tangency to lie between the rows
at a turn. For the other tangencies (a circle and a side, two neighbours in a row, or a
tangency inside a fan, where one circle touches three or more consecutive circles of the
other row) `circle-genus-survey.sage` uses a general method:

+ Coordinates $(sqrt(r), x)$ for each circle touching the top or the bottom, with $y$
  determined, and $(x, y, r)$ for the others, and $W$. A tangency of two circles on the same
  line is linear in the $x$'s, as in @sec-coords; all other tangencies are the plain
  quadratic equations.
+ The ideal of the dropped pattern over $K$ is saturated by the radii, decomposed into
  minimal primes, and the prime through the packing (located numerically to $110$ digits)
  is kept.
+ Its image in the geometric coordinates $(x, y, r, W)$, obtained by eliminating the
  square roots, is the family $C$. Its geometric genus is computed by Singular
  (`normal.lib`).

#block(fill: luma(247), inset: 8pt, radius: 3pt, width: 100%)[
  *Status (run still in progress).* All triangulated patterns with $n <= 5$ circles, every
  tangency dropped in turn, $3$ minutes per case. So far: $n = 3$, all $8$ patterns: $77$
  curves of genus $0$, $2$ time-outs, $1$ failure. $n = 4$: $30$ of $38$ patterns done,
  $311$ curves of genus $0$, $26$ time-outs, $13$ failures in Singular. $n = 5$: $16$ of
  $219$ patterns done, $175$ curves of genus $0$, $7$ time-outs, $2$ failures. *No curve of
  positive genus has appeared with five circles or fewer.* The time-outs and failures are
  undecided, not genus $0$.
]

= Questions <sec-questions>

- *Why this pattern?* It is the only one up to eight circles in which the two chains of a
  dropped tangency are mirror images of each other. Is that the mechanism? The analogous
  symmetric patterns for larger $k$, two copies of one chain glued across a quadrilateral,
  are the natural next candidates.
- *Other tangencies for $k = 4$.* Only the tangencies at turns have been treated for eight
  circles. Tangencies with the sides, within the rows and inside fans remain, as do the
  eight-circle pattern with two circles touching no side and the larger zigzags.
- *Rank.* Is $E(K)$ of positive rank? A point of infinite order would give infinitely many
  configurations of the dropped pattern with all coordinates in $QQ(sqrt(2))$.
- *Reduction at $2$.* The conductor exponent $9$ at $(sqrt(2))$ is large. How does it relate
  to the $sqrt(2)$ that the corner relation and the lemma put into every coordinate?

#v(4mm)
#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *What the scripts check.* `circle-genus.sage`, output in `results/circle-genus.txt`, figure
  data in `circle-genus.json`:
  (1) for every two-row zigzag with $k <= 4$ and every tangency at a turn, the curve $H$,
  its bidegree and its genus (Singular over $K$), one line per symmetry class;
  (2) for `11 21 22 32 33 34 44` without $A_3 B_2$: $H$, its symmetry, that the mirror pattern
  gives the same curve with the packing at $(v_0, t_0)$, $Delta$, $I$, $J$, $j$, the minimal
  model, conductor, discriminant, torsion, CM, the traces of Frobenius of $E$ and
  $E^sigma$, $j$ modulo primes, the fixed points of $iota$, the honest arc, and the real
  points of $H$ and $H^sigma$.
  `circle-genus-survey.sage`, output in `results/circle-genus-survey.txt`:
  (3) every triangulated pattern with $n <= 5$ and every dropped tangency, by the general
  method of @sec-general.
]
