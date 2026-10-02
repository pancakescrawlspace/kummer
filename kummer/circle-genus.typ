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

#let data2 = json("circle-genus-g2.json")

// the genus-two family: the quadrilateral gap A2, top, A3, B2.  Red: the
// dropped tangency A2 A3 (segment of centres); blue: B2 and its point of
// contact with the top line.  Solid when touching, dotted otherwise.
#let config2(m, unit: 1.6cm) = cetz.canvas(length: unit, {
  import cetz.draw: *
  rect((0, 0), (m.W, 1), stroke: 0.9pt)
  let get(l) = m.circles.find(c => c.label == l)
  for c in m.circles {
    circle((c.x, c.y), radius: c.r, fill: fills.at(c.label.at(0)), stroke: 0.55pt)
  }
  let a = get("A2")
  let b = get("A3")
  let gap = calc.sqrt(calc.pow(a.x - b.x, 2) + calc.pow(a.y - b.y, 2)) - a.r - b.r
  line((a.x, a.y), (b.x, b.y), stroke: if gap < 1e-9 { 1.0pt + red } else { (paint: red, thickness: 0.7pt, dash: "dotted") })
  let c = get("B2")
  let gt = 1 - c.y - c.r
  line((c.x, c.y), (c.x, 1), stroke: if gt < 1e-9 { 1.0pt + blue } else { (paint: blue, thickness: 0.7pt, dash: "dotted") })
  for c in m.circles {
    content((c.x, c.y), text(7.5pt, lab(c.label)))
  }
})

// the real loci of H (blue) and H^sigma (orange) in the (t, v)-plane
#let hcol = rgb("#1f5fbf")
#let scol = rgb("#e67e22")
#let locus(unit: 1.3cm) = cetz.canvas(length: unit, {
  import cetz.draw: *
  let (lo, hi) = (-1.5, 2.5)
  rect((lo, lo), (hi, hi), stroke: 0.5pt + luma(150))
  line((lo, 0), (hi, 0), stroke: 0.3pt + luma(200))
  line((0, lo), (0, hi), stroke: 0.3pt + luma(200))
  line((lo, lo), (hi, hi), stroke: (paint: luma(170), thickness: 0.4pt, dash: "dashed"))
  for tick in (-1, 1, 2) {
    content((tick, lo - 0.2), text(7pt)[#tick])
    content((lo - 0.2, tick), text(7pt)[#tick])
  }
  content((hi + 0.15, lo - 0.2), text(8pt)[$t$])
  content((lo - 0.2, hi + 0.12), text(8pt)[$v$])
  // all sample points: thinning by index would drop one of the two roots at each t
  for p in data.locus.minus {
    circle((p.at(0), p.at(1)), radius: 0.016, fill: scol, stroke: none)
  }
  for p in data.locus.plus {
    circle((p.at(0), p.at(1)), radius: 0.016, fill: hcol, stroke: none)
  }
  for f in data.fixed {
    circle((f, f), radius: 0.05, fill: white, stroke: 0.7pt)
  }
  // the window of the zoom
  rect((0.42, 0.42), (0.50, 0.50), stroke: 0.9pt + red)
})

// zoom on the honest arc: 0.44 <= t, v <= 0.48
#let zoom(unit: 1.3cm) = cetz.canvas(length: unit, {
  import cetz.draw: *
  let (lo, hi) = (0.44, 0.48)
  let sc = 4.0 / (hi - lo)
  let P(x, y) = ((x - lo) * sc, (y - lo) * sc)
  rect(P(lo, lo), P(hi, hi), stroke: 0.9pt + red)
  line(P(lo, lo), P(hi, hi), stroke: (paint: luma(170), thickness: 0.4pt, dash: "dashed"))
  for tick in (0.45, 0.46, 0.47) {
    content((P(tick, lo).at(0), -0.2), text(7pt)[#tick])
    content((-0.3, P(lo, tick).at(1)), text(7pt)[#tick])
  }
  content((4.15, -0.2), text(8pt)[$t$])
  content((-0.2, 4.12), text(8pt)[$v$])
  let (t0, v0) = (data.packing.at(0), data.packing.at(1))
  for p in data.locus.zoom {
    let inside = p.at(0) >= t0 and p.at(0) <= v0 and p.at(1) >= t0 and p.at(1) <= v0
    circle(P(p.at(0), p.at(1)), radius: if inside { 0.035 } else { 0.018 },
      fill: if inside { red } else { hcol }, stroke: none)
  }
  let m = data.fixed.filter(f => f > lo and f < hi)
  for f in m { circle(P(f, f), radius: 0.07, fill: white, stroke: 0.8pt) }
  circle(P(t0, v0), radius: 0.08, fill: red, stroke: 0.5pt + white)
  circle(P(v0, t0), radius: 0.08, fill: blue, stroke: 0.5pt + white)
  content((P(t0, v0).at(0) + 0.45, P(t0, v0).at(1) + 0.15), text(7.5pt)[packing])
  content((P(v0, t0).at(0) + 0.1, P(v0, t0).at(1) - 0.3), text(7.5pt)[mirror packing])
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
  + Every turn is a flip: the curve of a dropped tangency at a turn also contains the
    packing of the pattern with the other diagonal of the quadrilateral gap, joined to the
    first by an arc of honest packings. In the genus-one example this flip is the local
    monodromy of $H -> H \/ iota$ around a branch point; in general it is not a monodromy
    (@sec-flips).
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

*Chains.* The lemma is a statement about one curvilinear triangle of the strip between the
rows: the triangle bounded by the two touching circles $A_i, B_j$ and the next circle
$A_(i+1)$ (or $B_(j+1)$), which touches both and the line. Each pair $(i, j) -> (i', j')$ of
consecutive entries of the lattice path is one such triangle, and the path lists these
triangles from left to right. So the lemma can be applied *one triangle at a time*, each time
adding one circle, and the circles built so far form a _chain_: a run of consecutive
triangles of the strip. The chain needs a start, two touching circles $A_i, B_j$ with known
coordinates. At the left side the corner relation $a_1 + b_1 = 1$ provides one, with the single
parameter $t$. By the mirror image of the lemma ($x |-> -x$),
$ a_(i+1) / a_i = X_(i+1) - Y_j + sqrt(2) thin b_j, quad X_i = X_(i+1) - 2 a_i a_(i+1), $
a chain can also be extended to the left, and a chain started at the right corner, with
parameter $v = a_k$, grows from right to left. For the rigid packing a single chain from the
left corner runs through every triangle and reaches the right side, where the last tangency
is the only condition left; it fixes $t$.

A step uses four tangencies: the cross tangency $A_i B_j$ it starts from, the new circle's
tangency with the line, with its neighbour in the row, and with the circle across. If one
tangency is dropped, every step that needs it is blocked. A chain then stops at the first
blocked triangle. What is left over must be filled by other means: a chain from the other
corner, or new parameters.

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

= Dropping any tangency of a zigzag <sec-any>

A turn (@sec-family) is the simplest case: exactly one triangle step is blocked, and two
chains, one from each corner, cover everything else. The other tangencies of a zigzag are
the sides, the tangencies of neighbours within a row, and cross tangencies inside a _fan_,
where one circle touches three or more consecutive circles of the other row. For these,
`circle-genus-zigzag.sage` builds the configuration by _propagation_:

+ *Corners.* If $A_1, B_1$ touch each other, the left side, the top and the bottom, they are
  given by one parameter $t$ as in @sec-coords; likewise at the right side with a parameter
  $v$, in coordinates measured from the right side. The width $W$ is always a parameter.
+ *Steps.* Whenever two known circles $A_i, B_j$ touch and a neighbour of one of them
  touches the line and both, the lemma (or its mirror image) adds that neighbour. Its root
  $plus.minus sqrt(2)$ is the one that holds at the packing.
+ *New parameters.* When no step applies, one unknown circle gets new parameters: its
  signed square root $a$ if it touches a line, with its $x$-coordinate then linear if it
  touches a known neighbour in its row or a side, and a free $x$-coordinate otherwise; or
  $(x, y, r)$ for a circle that touches neither line (when its tangency with the top or
  bottom was dropped). Then the steps resume.
+ *Equations.* Every tangency that the construction does not guarantee becomes a polynomial
  equation in the parameters.

The result is a curve in a space of a few parameters (two to five), cut out by a few
equations, instead of the $3n + 1 = 25$ unknowns of the plain system. The ideal is saturated
by the denominators of the construction and the radius parameters, and the prime component
through the packing is kept. Its genus is computed by Singular.

*Birationality.* The parameters $t, v, W$ and the free coordinates are functions of the
configuration ($t = (1 + r(A_1) - r(B_1)) \/ 2$ as in @sec-family). A square-root parameter
$a$ might not be, since the configuration only sees $a^2$. So the parameter curve maps onto
the family, possibly with degree $> 1$, and its genus is an upper bound for the genus of the
family. A lower bound is the genus of the image under the map that replaces each square-root
parameter by its square, since that image is a projection of the family. When the two
agree, they give the genus of the family.

*Row tangencies are fibre products too.* Drop the tangency $A_i A_(i+1)$ of two neighbours
in the top row. The step that adds $A_(i+1)$ goes from $(i, j)$ to $(i + 1, j)$ for some $j$,
and it is the only step that is blocked. So the chain from the left corner runs up to
$(i, j)$, and the chain from the right corner runs back to $(i + 1, j)$. Both chains contain
the circle $B_j$, the left one as a function of $t$ and the right one as a function of $v$.
The two copies of $B_j$ must agree: their radii give
$ f(t) = b_j^"left" (t) = b_j^"right" (v) = h(v), $
and their positions then fix $W$. *The family is the fibre product of the two maps
$t |-> sqrt(r(B_j))$ and $v |-> sqrt(r(B_j))$,* with no quadric needed. The same argument
applies to a cross tangency in the middle of a fan, where the shared circle is the centre of
the fan.

*A family of genus two.* Take the pattern `11 21 22 32 33 34 44` again, and this time drop
the tangency $A_2 A_3$. The shared circle is $B_2$, and
$ f(t) = ((-2 sqrt(2) - 3) t^2 + (7/2 sqrt(2) + 5) t - 3/2 sqrt(2) - 2)
  / ((3 sqrt(2) + 4) t^2 - (6 sqrt(2) + 8) t + 3/2 sqrt(2) + 2) $
has degree $2$, while $h$ has degree $3$. The fibre product $f(t) = h(v)$ is irreducible of
bidegree $(2, 3)$ and has *genus $2$*. Since $f$ has degree $2$, it is a double cover of the
$v$-line: with $f = f_1 \/ f_2$, $h = h_1 \/ h_2$, the discriminant in $t$ of
$f_1(t) h_2(v) - f_2(t) h_1(v)$ is a squarefree sextic $D(v)$ over $K$, and the family is
birational to the hyperelliptic curve $y^2 = D(v)$. Its Igusa--Clebsch absolute invariants
lie in $K$ and not in $QQ$, and the discriminant of the sextic has norm $-2^12 dot 41 dot 53^2$.

The honest packings again form an arc that ends in a flip (@fig-genus2). Dropping $A_2 A_3$
merges the triangle below the two circles with the gap above them into a quadrilateral
bounded by $A_2$, the top line, $A_3$ and $B_2$. Its other diagonal is a tangency of $B_2$
with the top. Along the arc $B_2$ grows until it touches the top line, at $r(B_2) = 1\/2$,
which happens at the root $t_1 = 0.421443 dots$ of
$t^2 - (sqrt(2)\/4 + 3\/2) t + sqrt(2)\/4 + 1\/4$. There the width is $W = 2.611850 dots$.
The pattern at that end is triangulated but not a zigzag: $B_2$ touches both lines.

#figure(
  {
    let ms = data2.members
    grid(
      columns: 2, column-gutter: 6mm, row-gutter: 3mm, align: center + bottom,
      ..ms.map(m => stack(dir: ttb, spacing: 1.2mm,
        config2(m, unit: 3.0cm),
        text(8pt)[$t = #fmt(m.t, d: 5)$, $W = #fmt(m.W, d: 5)$])),
    )
  },
  caption: [The genus-two family: `11 21 22 32 33 34 44` without the tangency $A_2 A_3$. Top
  left: the rigid packing, where $A_2$ and $A_3$ touch (solid red). Then a third and two
  thirds of the way along the honest arc, and its end, where $B_2$ touches the top line (solid
  blue) and the gap $A_2$, top, $A_3$, $B_2$ has flipped to its other diagonal.],
) <fig-genus2>

*Larger $k$.* For $k = 5$ the fibre products of row and fan tangencies give
(`results/circle-genus-shared-k5.txt`)
#align(center, table(
  columns: 7, stroke: none, inset: (x: 7pt, y: 2pt), align: (left,) + (center,) * 6,
  table.hline(),
  [dropped tangency], [classes], [genus 0], [1], [2], [3], [4],
  table.hline(stroke: 0.5pt),
  [within a row], [140], [95], [6], [25], [7], [7],
  [in the middle of a fan], [54], [40], [2], [11], [1], [],
  table.hline(),
))
and for $k = 6$ (`results/circle-genus-shared-k6.txt`):
#align(center, table(
  columns: 14, stroke: none, inset: (x: 4pt, y: 2pt), align: (left,) + (center,) * 13,
  table.hline(),
  [genus], [0], [1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [12], [classes],
  table.hline(stroke: 0.5pt),
  [row], [336], [12], [31], [50], [83], [32], [46], [17], [19], [1], [2], [1], [630],
  [fan], [140], [5], [18], [29], [40], [7], [9], [4], [], [], [], [], [252],
  table.hline(),
))
The genus is $(p - 1)(q - 1)$, with $(p, q)$ the degrees of the two maps, in $190$ of the
$194$ classes for $k = 5$ and in $784$ of the $882$ for $k = 6$. In all the other cases $f$
and $h$ share a branch value, which makes the fibre product singular and lowers the genus.
The shared value is always degenerate: $-sqrt(2)\/2$, where the shared circle has radius
$1\/2$ and spans the strip between the lines ($43$ classes for $k = 6$), or $0$, where its
radius vanishes ($55$ classes, once as a double root).

*Two more elliptic curves.* Dropping $A_3 A_4$ from `11 21 31 32 42 43 44`, or $A_2 A_3$ from
`11 21 22 32 33 43 44`, gives fibre products of two maps of degree $2$, both of genus $1$.
Their $j$-invariants are
$ 701377597\/142832 - 265045911\/71416 sqrt(2) quad "and" quad 50053699\/4112 + 12981553\/2056 sqrt(2), $
neither rational. Their conductors have norms $2 dot 79 dot 113$ and $2 dot 257$, so they have
bad reduction at odd primes, unlike the curve $E$ of @sec-elliptic, and they are not
isogenous to $E$.

#block(fill: luma(247), inset: 8pt, radius: 3pt, width: 100%)[
  *All tangencies of the zigzags with $k = 4$*, one symmetry class at a time:
  #align(center, table(
    columns: 5, stroke: none, inset: (x: 7pt, y: 2pt), align: (left, center, center, center, left),
    table.hline(),
    [dropped tangency], [classes], [genus $0$], [genus $> 0$], [method],
    table.hline(stroke: 0.5pt),
    [between the rows, at a turn], [17], [16], [1 (genus 1)], [$Phi(t, v)$, exact],
    [between the rows, in a fan], [10], [10], [], [fibre product, exact],
    [between the rows, at a corner], [10], [10], [], [propagation],
    [within a row], [30], [27], [2 (genus 1), 1 (genus 2)], [fibre product, exact],
    [with the left or right side], [20], [20], [], [proof below],
    [with the top or bottom line], [40], [], [], [propagation; 40 open],
    table.hline(),
  ))
  Row and fan tangencies are fibre products of a shared circle (`circle-genus-shared.sage`,
  output in `results/circle-genus-shared-k4.txt`); the corner and top/bottom cases use
  propagation over $FF_p$ (`circle-genus-zigzag.sage`, output in
  `results/circle-genus-zigzag.txt`), each case in a fresh process with a limit of $25$
  minutes. *All $40$ top/bottom cases ran out of time*, as did $8$ of the $10$ for $k = 3$:
  without its line, a circle is free in the plane, and its tangencies are genuine Apollonius
  conditions rather than the rational steps of the lemma. These remain open. *Sides
  always give genus $0$*: without the tangency of $A_1$ with the left side, the chain from
  the right corner builds every circle as a function of $v$ and $W$, and the one remaining
  condition, that $B_1$ touches the left side, makes $W$ a rational function of $v$.
]

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

*The locus of one centre.* Does the position of a single circle determine the
configuration, so that the curve traced by its centre is birational to $H$? It depends on the
chain. A circle of the left chain is a function of $t$ alone, because the left side is fixed
at $x = 0$; its centre traces a rational curve, and $H$ maps to it with degree $2$, since
each $t$ has two values of $v$. A circle of the right chain is placed from the right side, at
$x = W - X'$, and $W$ depends on both $t$ and $v$; its centre traces a curve birational to
$H$. Modulo a prime above $p = 1000033$:
#align(center, table(
  columns: 4, stroke: none, inset: (x: 7pt, y: 2pt), align: (left, center, center, center),
  table.hline(),
  [centre of], [degree of the locus], [genus of the locus], [degree of $H ->$ locus],
  table.hline(stroke: 0.5pt),
  [$A_2$ (left chain)], [4], [0], [2],
  [$B_2$ (left chain)], [6], [0], [2],
  [$A_3$ (right chain)], [9], [1], [1],
  table.hline(),
))
On the honest arc $t$ is monotone, so even the centre of $A_2$ determines the configuration
there: the map restricted to the real arc is a homeomorphism onto its image. It is
the algebraic map that has degree $2$, and the second preimage lies off the arc. Which circles
see the whole curve is an artefact of the normalisation $x = 0$ on the left; normalising on
the right exchanges the roles of the two chains. A point of contact with a side lies on a
line, so its locus is never birational to $H$.

#figure(
  grid(columns: 2, column-gutter: 8mm, align: bottom, locus(), zoom()),
  caption: [Left: the real points of $H$ (blue) and of its conjugate $H^sigma$ (orange) in
  the $(t, v)$-plane, $-1.5 <= t, v <= 2.5$; open circles are the four fixed points of
  $iota$ on the diagonal $t = v$ (dashed). Right: the red square enlarged,
  $0.44 <= t, v <= 0.48$. In red, the honest arc, from the packing (red dot) to the mirror
  packing (blue dot), through the symmetric member (open circle).],
) <fig-locus>

= Flips, and the role of monodromy <sec-flips>

*Every turn is a flip.* Let the path turn at $(i_0, j_0)$, entering from $(i_0 - 1, j_0)$
and leaving to $(i_0, j_0 + 1)$; the other kind of turn is symmetric. Dropping
$A_(i_0) B_(j_0)$ merges two triangles into the quadrilateral gap bounded by
$A_(i_0 - 1), A_(i_0), B_(j_0 + 1), B_(j_0)$. Its two diagonals are $A_(i_0) B_(j_0)$ and
$A_(i_0 - 1) B_(j_0 + 1)$. Putting in the second one gives another lattice path, with the
corner $(i_0, j_0)$ replaced by $(i_0 - 1, j_0 + 1)$: the _flip_ of the path at that turn.
Both patterns become the same pattern, the _quadrilateral pattern_, when their diagonal is
dropped. So the curve $H$ of @sec-family is the configuration space of the quadrilateral
pattern, and it contains *both* rigid packings: the one where the first diagonal closes
and the one where the second does.

`circle-genus.sage` checked this for all $72$ turns with $k = 3, 4$. In every case the
packing of the flipped pattern is a point of the same curve $H$, and the real branch of
$H$ from one packing to the other consists of honest packings of the quadrilateral pattern.
So the rigid zigzag packings, with flips as edges, form a graph in which every edge is
realised by a real arc of honest packings, along which the quadrilateral gap turns from one
diagonal to the other. For $k <= 4$ all of these arcs lie on rational curves, except the edge
between `11 21 22 32 33 34 44` and its mirror image (and its reflection in the horizontal
axis), which lies on the elliptic curve $H$.

*Is the flip a monodromy?* In the genus-one example, yes, in the following precise sense.
The flip there is the involution $iota$, and $H$ is a double cover of the rational curve
$H \/ iota$, branched at the images of the four symmetric configurations. The honest arc
$gamma$ runs from the packing $P$ through the symmetric member $F$ to the mirror packing
$iota(P)$. Its image in $H \/ iota$ goes from $[P]$ to the branch point $b = [F]$ and back
to $[P]$. Deform this out-and-back path into a small loop around $b$. The local monodromy of
a double cover at a simple branch point exchanges the two sheets, so the lift of the loop that
starts at $P$ ends at $iota(P)$, and it is homotopic to $gamma$. *The flip is the local
monodromy of $H -> H \/ iota$ around the branch point of the symmetric configuration.*

In general, however, a flip is not a monodromy. Without a symmetry there is no natural cover
in which $P$ and its flip lie in one fibre. What a turn gives in general is one curve with two
special divisors. Let $delta_1, delta_2$ be the inversive distances of the two diagonals of
the quadrilateral, which are $1$ exactly when the diagonal is a tangency. The rigid packing
of one pattern lies in the fibre $delta_1 = 1$, that of the flipped pattern in the fibre
$delta_2 = 1$, and the honest arc is a real path from one fibre to the other along which
both $delta_i >= 1$. Monodromy, in the sense of `circle-monodromy.typ`, acts *within* one
fibre: it permutes the Galois conjugates of a single packing. A flip moves between different
fibres. The symmetric case is the exception, because there $iota$ exchanges $delta_1$ and
$delta_2$, so the two fibres are interchanged by a deck transformation.

= Why this pattern? The two rulings <sec-rulings>

The genus-one example is symmetric, so it is natural to guess that the symmetry is what
makes the genus positive. It is not. The mechanism is a quadric.

*The end pairs lie on a quadric.* For a turn entered by a step in $i$, the left chain ends
with the touching pair $A_(i_0 - 1), B_(j_0)$ and the right chain with $A_(i_0), B_(j_0 + 1)$.
For a touching pair put $D = X - Y$, the horizontal offset of the two centres. By
(\*) of @sec-coords the point $[1 : D : a : b]$ of $PP^3$ lies on
$ Q : quad D^2 + w^2 = 2 a^2 + 2 b^2, quad "that is" quad
  (D - sqrt(2) a)(D + sqrt(2) a) = (sqrt(2) b - w)(sqrt(2) b + w). $
$Q$ is a smooth quadric, and the second form shows its two rulings over $K$. The projections
to the two rulings are
$ pi_1 = (D - sqrt(2) a) / (sqrt(2) b - w), quad pi_2 = (D - sqrt(2) a) / (sqrt(2) b + w), $
and two points of $Q$ lie on a common line of the first (second) ruling exactly when their
$pi_1$ ($pi_2$) agree. Each chain is a rational curve $phi_L, phi_R : PP^1 -> Q$.

*$Phi$ is a polarity.* In these coordinates the gluing equation of @sec-family reads
$ Phi = D_L + D_R + 2 (a_L a_R - b_L b_R) = B_Q (phi_L, g thin phi_R), $
where $B_Q(x, y) = D D' + w w' - 2 a a' - 2 b b'$ is the bilinear form of $Q$ and
$g(w, D, a, b) = (D, w, -a, b)$ is an automorphism of $Q$. For points $x, y$ of $Q$,
$B_Q(x, y) = 0$ says that $y$ lies in the tangent plane at $x$, which meets $Q$ in the two
lines through $x$. Hence
$ {Phi = 0} = {pi_1 compose phi_L (t) = pi_1 compose g phi_R (v)} union
  {pi_2 compose phi_L (t) = pi_2 compose g phi_R (v)} . $
*Every curve of a dropped turn tangency is a component of a fibre product
${f(t) = h(v)}$ of two rational functions $f, h : PP^1 -> PP^1$,* namely the projections of
the two chains to one ruling of $Q$. `circle-genus.sage` (§5 of its output) confirms all
of this for the $95$ symmetry classes of turns with $k <= 5$: both chain ends lie on $Q$,
$Phi$ is the polarity above, and $H$ is a component of one of the two ruling curves.

*The genus.* A fibre product of maps of degrees $p$ and $q$ whose branch values are
disjoint is a smooth curve of bidegree $(p, q)$ on $PP^1 times PP^1$, of genus
$(p - 1)(q - 1)$. In $83$ of the $95$ classes, $H$ is the whole fibre product, with bidegree
$(deg f, deg h)$ and genus $(deg f - 1)(deg h - 1)$. In the other $12$, $f$ and $h$ both have
degree $2$ but $h = f compose mu$ for a Möbius map $mu$, and the fibre product falls apart
into two curves of bidegree $(1, 1)$. For all turns with $k <= 6$ the computed genus equals
$(d_t - 1)(d_v - 1)$, with $(d_t, d_v)$ the bidegree of $H$.

*The genus-one example once more.* Here $H = {f(t) = h(v)}$ with $f$ and $h$ of degree $2$.
The branch values of $f$ and $h$ are four distinct points of $PP^1$, the roots of
$ (z^2 + (54/113 sqrt(2) - 42/113) z + 2/113 sqrt(2) + 11/113)
  (z^2 + (38 - 26 sqrt(2)) z + 43 - 30 sqrt(2)), $
the first pair from $f$, the second from $h$. The fibre product of two double covers
branched over $\{b_1, b_2\}$ and $\{b_3, b_4\}$ is an unramified double cover of
$y^2 = (z - b_1)(z - b_2)(z - b_3)(z - b_4)$. That curve has $j = 2432 + 384 sqrt(2)$,
and it is $2$-isogenous to the Jacobian $E$ of @sec-elliptic. So the arithmetic of $H$ is
governed by the critical values of the two chains.

*Why $k = 4$ and this pattern.* In all cases computed, the degree of the projection of a
chain to a ruling grows with the length of the chain, and degree $2$ needs a chain of at
least three entries of the path. Degree $1$ on either side makes $H$ rational. For $k = 4$ the path has seven entries,
so both chains have three entries only when the turn is the middle entry. All five symmetry
classes of middle turns have $deg f = deg h = 2$. In four of them $h = f compose mu$ and the
fibre product splits; the fifth, `11 21 22 32 33 34 44` without $A_3 B_2$, is the elliptic
curve. The left–right symmetry comes with being in the middle: it is a consequence of the
smallness of $k$, not the cause of the genus.

*Larger $k$.* `circle-genus-flips.sage` computes $H$ and its genus (modulo two primes) for
every turn with $k = 5, 6$; the output is in `results/circle-genus-flips-k5.txt` and
`results/circle-genus-flips-k6.txt`.

#figure(
  table(
    columns: 8, stroke: none, inset: (x: 6pt, y: 2.5pt), align: center,
    table.hline(),
    table.header([$k$], [classes], [genus 0], [1], [2], [3], [4], [5]),
    table.hline(stroke: 0.5pt),
    [4], [17], [16], [1], [], [], [], [],
    [5], [74], [48], [6], [20], [], [], [],
    [6], [323], [156], [0], [10], [74], [71], [12],
    table.hline(),
  ),
  kind: table,
  caption: [Genus of the curve of a dropped turn tangency, one row per symmetry class of
  (pattern, turn). For $k = 5$ the bidegrees are $(2, 2)$ for genus $1$ and $(2, 3)$ or
  $(3, 2)$ for genus $2$. For $k = 6$ genus $1$ does not occur; genus $4$ occurs both as
  $(3, 3)$ and as $(2, 5)$.],
) <tab-larger>

Positive genus is the rule from $k = 5$ on. No turn with $k = 5$ has a symmetric flip (a
symmetric flip of the kind in @sec-flips needs the turn in the exact middle, so $k$ even),
yet six classes have genus $1$ and twenty genus $2$. For $k = 6$ the three classes with a
symmetric flip all have genus $4$, bidegree $(3, 3)$.

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

= Small patterns that are not zigzags <sec-general>

Propagation (@sec-any) relies on the zigzag structure: every circle touches the top or the
bottom line, and the lattice path orders the triangles. For arbitrary triangulated patterns,
with circles that touch neither line, `circle-genus-survey.sage` uses a cruder general
method:

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
  *Status.* All triangulated patterns with $n <= 4$ circles, and $53$ of the $219$ with
  $n = 5$, every tangency dropped in turn, with a time limit per case. $n = 3$: $77$ curves
  of genus $0$, $2$ time-outs, $1$ failure. $n = 4$: $392$ of genus $0$, $68$ time-outs, $34$
  failures. $n = 5$ (partial): $620$ of genus $0$, $158$ time-outs, $36$ failures. *No curve
  of positive genus has appeared with five circles or fewer.* Time-outs and failures are
  undecided, not genus $0$. Most failures come after a time-out in the same process, which
  leaves Singular in a broken state; the run was stopped there, since propagation
  (@sec-any) treats the zigzags much better.
]

= Questions <sec-questions>

- *Ruling degrees.* Is there a formula for the degree of the projection of a chain to a
  ruling of $Q$ in terms of its lattice path? It would give the genus of every turn curve,
  and explain why genus $1$ disappears at $k = 6$ (@tab-larger).
- *Tangencies with the top or bottom line.* These are the only ones left open for $k <= 4$
  (@sec-any). Without its line a circle is free, and an Apollonius-type construction (a
  double cover at each such step) should replace propagation. The eight-circle pattern with
  two circles touching no side is also untreated.
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
