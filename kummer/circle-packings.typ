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

// ---------------------------------------------------------------------
// data and drawing
// ---------------------------------------------------------------------

#let data = json("circle-packings.json")

#let row-fill = (
  top: rgb("#d6e4f0"),
  bottom: rgb("#f6dcc8"),
  mid: rgb("#d5ecd4"),
  new: rgb("#f3d2e4"),
)

// "A1" -> A with subscript 1; anything else as is
#let circle-label(s) = {
  let m = s.match(regex("^([A-Z]'?)(\d+)$"))
  if m == none { math.equation(math.italic(s)) } else {
    math.equation(math.attach(math.italic(m.captures.at(0)), b: m.captures.at(1)))
  }
}

// p: one packing record from circle-packings.json.  `graph` draws the
// contact graph on top: centre-to-centre segments for circle tangencies,
// dashed segments from a centre to its tangency point on a side.
#let packing(p, unit: 2.4cm, graph: false, labels: false, label-size: 8pt, emph-pair: none) = cetz.canvas(length: unit, {
  import cetz.draw: *
  let W = p.W
  let cs = p.circles
  rect((0, 0), (W, 1), stroke: 0.9pt)
  for c in cs {
    circle((c.x, c.y), radius: c.r, fill: row-fill.at(c.row), stroke: 0.55pt)
  }
  if emph-pair != none {
    let a = cs.at(emph-pair.at(0))
    let b = cs.at(emph-pair.at(1))
    let d = calc.sqrt(calc.pow(b.x - a.x, 2) + calc.pow(b.y - a.y, 2))
    let u = ((b.x - a.x) / d, (b.y - a.y) / d)
    if d > a.r + b.r + 1e-6 {
      line((a.x + a.r * u.at(0), a.y + a.r * u.at(1)), (b.x - b.r * u.at(0), b.y - b.r * u.at(1)),
        stroke: 1.2pt + rgb("#c0392b"))
    } else {
      let t = (a.x + a.r * u.at(0), a.y + a.r * u.at(1))
      circle(t, radius: 0.025, fill: rgb("#c0392b"), stroke: none)
    }
    content((a.x, a.y), text(8.5pt, circle-label(a.label)))
    content((b.x, b.y), text(8.5pt, circle-label(b.label)))
  }
  if graph {
    let edge = 0.6pt + rgb("#c0392b")
    for e in p.cc {
      let a = cs.at(e.at(0))
      let b = cs.at(e.at(1))
      line((a.x, a.y), (b.x, b.y), stroke: edge)
    }
    for w in p.walls {
      let c = cs.at(w.at(0))
      let foot = (
        top: (c.x, 1), bottom: (c.x, 0), left: (0, c.y), right: (W, c.y),
      ).at(w.at(1))
      line((c.x, c.y), foot, stroke: (paint: rgb("#c0392b"), thickness: 0.6pt, dash: "dashed"))
      circle(foot, radius: 0.012, fill: rgb("#c0392b"), stroke: none)
    }
    for c in cs {
      circle((c.x, c.y), radius: 0.014, fill: black, stroke: none)
    }
  }
  if labels {
    for c in cs {
      if c.label != "" {
        content((c.x, c.y + if graph { 0.07 } else { 0 }), text(label-size, circle-label(c.label)))
      }
    }
  }
})

#let fmt(x, digits: 6) = str(calc.round(x, digits: digits))
#let path-str(p) = p.path.map(e => str(e.at(0)) + str(e.at(1))).join(" ")

// a small panel: picture, then the cross tangencies and the width
#let zig-panel(p, unit: 1.25cm) = align(center, stack(
  dir: ttb, spacing: 1.2mm,
  packing(p, unit: unit),
  text(7.5pt, raw(path-str(p))),
  text(7.5pt)[$W = #fmt(p.W)$],
))

// ---------------------------------------------------------------------

#align(center)[
  #text(size: 16pt, weight: "bold")[Rigid circle packings in a rectangle]
  #v(2mm)
  #text(size: 10pt)[A packing whose gaps are all triangles is determined by its tangencies;
  the six circles of the MathOverflow problem, every two-row zigzag, circles that touch no
  side, and what happens when one tangency is dropped]
  #v(1mm)
  #text(size: 9pt, style: "italic")[figures and checks in `circle-packings.py`,
  output in `results/circle-packings.txt`; degrees in `circle-degrees.sage`,
  output in `results/circle-degrees.txt`; larger $k$ in `circle-degrees-growth.sage` and
  `circle-galois.sage`, output in `results/circle-degrees-growth.txt` and
  `results/circle-galois.txt`; the search of @sec-graph in
  `circle-graph-search.py`, output in `results/circle-graph-search*.txt`]
]

#v(4mm)

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *Setting.* $n$ circles with disjoint interiors in a rectangle $[0, W] times [0, 1]$. A
  _gap_ is a connected component of the rectangle minus the closed disks. The _pattern_ of the
  packing is the list of its tangencies, circle--circle and circle--side, with the four sides
  labelled.

  *Theorem.* Suppose every gap is a curvilinear triangle: it is bounded by exactly three
  objects (circles or sides) that touch pairwise. In particular each corner gap is bounded by
  two sides and one circle touching both. Then:
  + the pattern determines the packing up to similarity, so the packing is rigid, and it is
    the only packing with that pattern at all;
  + conversely every such pattern occurs: any triangulation of a quadrilateral with corners
    _top_, _right_, _bottom_, _left_, without the chords _top_--_bottom_ and _left_--_right_,
    is the pattern of exactly one packing, and its aspect ratio $W$ is determined;
  + a symmetry of the pattern that maps sides to sides is realised by an isometry of the
    rectangle.
]

#figure(
  grid(
    columns: 2, column-gutter: 6mm,
    packing(data.six, unit: 2.75cm, labels: true, label-size: 9pt),
    packing(data.six, unit: 2.75cm, graph: true, labels: true, label-size: 8pt),
  ),
  caption: [The six circles. Left: the packing, $W = #fmt(data.six.W)$. Right: its contact
  graph, with circle tangencies as solid segments between centres and side tangencies as dashed
  segments to the point of contact. The $19 = 3 dot 6 + 1$ tangencies cut the rectangle into
  triangles only, so the theorem applies: the packing is rigid, and the half-turn symmetry of
  the pattern forces $A tilde.equiv A'$, $B tilde.equiv B'$, $C tilde.equiv C'$.],
) <fig-six>

= Counting <sec-count>

Fix the height to $1$ and one corner at the origin. A packing has $3n + 1$ unknowns: a centre
and a radius per circle, and the width $W$. Every tangency is one equation.

Form the graph with a vertex per circle and per side, an edge per tangency, and the four
corners of the rectangle as edges between adjacent sides. It is planar, with $n + 4$ vertices
and an outer face of length $4$, so Euler's formula gives
$ \#"tangencies" + 4 lt.eq 3(n + 4) - 3 - 4, quad "that is," quad
  \#"tangencies" lt.eq 3n + 1, $
with equality exactly when every bounded face, that is every gap, is a triangle. So a
triangulated packing has exactly as many equations as unknowns, and a packing with a gap of
four or more sides has fewer. In the second case the Jacobian cannot have full rank, and the
packing is not even infinitesimally rigid (@sec-flex shows the generic behaviour). The theorem
says that in the first case nothing goes wrong: the square system has exactly one real
solution that is a packing.

= Why: the rectangle as four circles <sec-why>

On the Riemann sphere the four sides are circles through $infinity$. Opposite sides are
parallel, so they are tangent at $infinity$; adjacent sides meet at right angles. Give every
tangency the intersection angle $Theta = 0$ and every corner of the rectangle
$Theta = pi \/ 2$, and add one edge _top_--_bottom_ for the tangency at $infinity$. The result
is a triangulation of the sphere with angles in $[0, pi\/2]$. The two new faces
(_top_, _bottom_, _left_) and (_top_, _bottom_, _right_) have angle sum exactly $pi$, which is
the case where three circles pass through one point.

The Koebe--Andreev--Thurston theorem with intersection angles (Thurston's notes, ch. 13;
Marden--Rodin) says that such a pattern exists and is unique up to Möbius transformations,
provided (i) every $3$-cycle with angle sum $gt.eq pi$ bounds a face, and (ii) every $4$-cycle
with angle sum $2 pi$ bounds two adjacent faces. Both hold: only the two faces at $infinity$
reach $pi$, and only the cycle of the four sides reaches $2 pi$. Sending the common point of
the four sides to $infinity$ turns them into a rectangle, and the Möbius maps preserving that
are similarities. This gives (1) and (2); (3) follows from (1) applied to the relabelled
packing.

= Two-row zigzags <sec-zigzag>

Put a row $A_1, dots, A_k$ along the top and a row $B_1, dots, B_k$ along the bottom, with
neighbours in a row tangent and the four end circles tangent to the sides. The tangencies
between the rows must triangulate the strip between them, so they are a lattice path of
$2k - 1$ pairs $A_i B_j$ from $(1, 1)$ to $(k, k)$. That gives
$ 2k + 4 + 2(k - 1) + (2k - 1) = 6k + 1 = 3n + 1 $
tangencies for $n = 2k$ circles, so every one of the $binom(2k - 2, k - 1)$ paths is a
triangulated pattern. Every circle touches at least four objects, so none of these arises by
dropping a circle into a gap (@sec-insert).

For $k = 2, 3, 4$ the script solved every pattern from $300$ random starting points. Each
pattern has *exactly one* packing, and the Jacobian has full rank $3n + 1$ there. Mirror images
in the horizontal axis have the same $W$, as they must. The six circles are the alternating
path for $k = 3$.

#figure(
  {
    grid(
      columns: 2, column-gutter: 8mm, row-gutter: 4mm,
      ..data.zigzag.at("2").map(p => zig-panel(p, unit: 1.6cm)),
    )
    v(3mm)
    grid(
      columns: 3, column-gutter: 5mm, row-gutter: 4mm,
      ..data.zigzag.at("3").map(p => zig-panel(p, unit: 1.45cm)),
    )
  },
  kind: image,
  caption: [All two-row zigzags with $k = 2$ (top) and $k = 3$ (bottom). The digits $i j$ list
  the tangencies $A_i B_j$. Both $k = 2$ packings are squares; one radius there is
  $1 - 1\/sqrt(2)$. The six circles are `11 12 22 23 33` and its mirror image `11 21 22 32 33`.],
) <fig-zig23>

#figure(
  grid(
    columns: 4, column-gutter: 3mm, row-gutter: 3.5mm,
    ..data.zigzag.at("4").map(p => zig-panel(p, unit: 1.13cm)),
  ),
  kind: image,
  caption: [All $binom(6, 3) = 20$ two-row zigzags with $k = 4$: eight circles, $25$
  equations, one packing each.],
) <fig-zig4>

= Algebraic degrees <sec-degrees>

Every coordinate of a rigid packing is an algebraic number. For the zigzags,
`circle-degrees.sage` computes the field they generate. The unknowns are the square roots
$a_i = sqrt(r(A_i))$ and $b_j = sqrt(r(B_j))$. With these, the tangencies inside a row are
linear in the horizontal positions, since contact points are $2 sqrt(r r')$ apart, and the
system becomes
$ x(A_i) = a_1^2 + 2 sum_(m < i) a_m a_(m+1), quad a_1 + b_1 = 1, quad a_k + b_k = 1, quad
  (x(A_i) - x(B_j))^2 = 2(a_i^2 + b_j^2) - 1 $
for the remaining cross tangencies $A_i B_j$, together with equal widths for the two rows:
$2k$ equations in $2k$ unknowns.

The minimal polynomials are found by Newton's method to $3000$ digits followed by LLL
(PARI's `algdep`), and accepted only with a wide margin; each is rechecked at $6000$ digits.
They are then *certified exactly*. Every unknown is written as a rational polynomial in a
primitive element $theta$, all equations are verified to vanish identically in the number
field $QQ(theta)$, and the minimal polynomial of $W$ is recomputed there. For $k <= 3$ the
results agree with a direct Gröbner basis computation. For $k = 4$ that route stalls on
spurious components of degenerate circles of radius $0$.

Patterns related by a symmetry of the rectangle (top--bottom, left--right, half-turn) have
the same $W$, so @tab-degrees has one row per orbit. "Field" is
$QQ(text("radii"), text("centres"), W)$; adjoining the square roots of the radii never
makes it larger.

#figure(
  table(
    columns: 7,
    align: (center, center, left, center, center, left, left),
    stroke: none,
    inset: (x: 5pt, y: 3pt),
    table.hline(),
    table.header([$k$], [orbit], [$W$], [$deg W$], [field], [discriminant], [Galois group]),
    table.hline(stroke: 0.5pt),
    [2], [2], [$1$], [1], [4], [$2^11$], [$C_4$],
    table.hline(stroke: 0.3pt + luma(180)),
    [3], [2], [$1.323762$], [6], [6], [$-2^11 dot 167$], [$S_3 wreath C_2$],
    [3], [2], [$1.483358$], [6], [6], [$-2^11 dot 167$], [$S_3 wreath C_2$],
    [3], [2], [$1.525936$], [6], [6], [$2^11 dot 73$], [$S_3 wreath C_2$],
    table.hline(stroke: 0.3pt + luma(180)),
    [4], [4], [$1.887988$], [4], [4], [$2^6 dot 41$], [$D_4$],
    [4], [4], [$1.789019$], [6], [6], [$2^11 dot 7 dot 751$], [$S_3 wreath C_2$],
    [4], [2], [$1.809948$], [6], [6], [$2^13 dot 71$], [$S_3 wreath C_2$],
    [4], [4], [$2.004861$], [6], [6], [$2^13 dot 41 dot 47$], [$S_3 wreath C_2$],
    [4], [2], [$2.059495$], [6], [6], [$-2^13 dot 281$], [$S_3 wreath C_2$],
    [4], [2], [$1.517885$], [8], [8], [$2^18 dot 7 dot 569$], [$S_4 wreath C_2$],
    [4], [2], [$1.969805$], [8], [8], [$2^18 dot 7 dot 569$], [$S_4 wreath C_2$],
    table.hline(),
  ),
  kind: table,
  caption: [Algebraic degrees of the two-row zigzags, height $1$, one row per symmetry orbit
  of patterns. The six circles are the $k = 3$ row with $W = 1.525936$.],
) <tab-degrees>

#let wpoly(p) = text(9pt, p)
Three things stand out.

- *The degrees are small for small $k$.* For $k = 4$ they are $4$, $6$ or $8$, and four of
  the twenty packings have *smaller* degree than the six circles, although the system admits up
  to $2048$ complex solutions by Bézout. Except for $k = 2$, where $W = 1$, the width $W$
  generates the whole field. For larger $k$ the degrees grow quickly (@sec-growth).
- *$sqrt(2)$ lies in every field.* Each zigzag has a bottom-left cluster of three circles: the
  corner circle $B_1$, the circle $A_1$ above it on the left side, and one circle touching both
  ($B_2$ or $A_2$). That cluster alone forces $sqrt(2)$, so every Galois group is a wreath
  product over the quadratic subfield $QQ(sqrt(2))$. The $k = 2$ field, cyclic of discriminant
  $2^11$, looks like $QQ(sqrt(2 + sqrt(2)))$, the real subfield of $QQ(zeta_16)$; this has not
  been checked.
- *Different orbits can give isomorphic fields.* The $k = 3$ orbits with $W = 1.323762$
  (`11 21 31 32 33`) and $W = 1.483358$ (`11 21 22 23 33`) have the same field, and so do the
  two $k = 4$ orbits of degree $8$ (`11 21 31 41 42 43 44` and `11 21 22 23 33 43 44`).
  In each pair a circle touches three or more circles of the other row, at different
  positions. I have no explanation for this.

For example, the minimal polynomials of the two widths of degree $8$ are
$ #wpoly[$W^8 - 5 W^7 + 91/8 W^6 - 241/16 W^5 + 3921/256 W^4 - 965/64 W^3 + 1219/128 W^2
  - 161/64 W + 49/256$], $
$ #wpoly[$W^8 + 1056/289 W^7 + 991/289 W^6 - 2254/289 W^5 - 27411/1156 W^4 - 7449/289 W^3
  - 8091/578 W^2 - 1091/289 W - 463/1156$]. $
All $28$ minimal polynomials are listed in `results/circle-degrees.txt`.

= Larger $k$: degrees and Galois groups <sec-growth>

The Gröbner and LLL methods of @sec-degrees do not scale. A better route comes from the
following observation.

*Lemma.* Suppose $A_i$ and $B_j$ are tangent and the next circle in the path is $A_(i+1)$,
tangent to the top, to $A_i$ and to $B_j$. Then
$ a_i / a_(i+1) = Y_j - X_i + sqrt(2) b_j, quad X_(i+1) = X_i + 2 a_i a_(i+1), $
and symmetrically $b_j \/ b_(j+1) = X_i - Y_j + sqrt(2) a_i$ when the next circle is
$B_(j+1)$. Here $X_i, Y_j$ are the $x$-coordinates of the centres of $A_i, B_j$.

*Proof.* Put $D = X_i - Y_j$, so that $D^2 = 2(a_i^2 + b_j^2) - 1$ by the tangency of $A_i$
and $B_j$. The tangency of $A_(i+1)$ and $B_j$ reads
$(D + 2 a_i a_(i+1))^2 = 2(a_(i+1)^2 + b_j^2) - 1$. Substituting $D^2$ turns this into
$(2 a_i^2 - 1) a_(i+1)^2 + 2 a_i D a_(i+1) + a_i^2 = 0$. Its discriminant is
$4 a_i^2 (D^2 - 2 a_i^2 + 1) = 2 (2 a_i b_j)^2$, and the root belonging to the packing gives
the formula. That this is the right root was checked on all $28$ packings of @sec-zigzag.
$square$

So *no new square root ever appears*. Starting from $t = a_1$, $b_1 = 1 - t$, $X_1 = t^2$,
$Y_1 = (1 - t)^2$, every coordinate is a rational function of $t$ over $K = QQ(sqrt(2))$.
The packing is cut out by one equation: both end circles touch the right side, that is
$X_k + a_k^2 = Y_k + b_k^2$.

*Proposition.* For every two-row zigzag with $k >= 2$ the field of the packing is
$F = QQ(sqrt(2), t)$, where $t = sqrt(r(A_1))$. Hence $deg F = 2m$ is even, where $m$ is the
degree over $K$ of the irreducible factor $f$ of that equation which vanishes at the packing.
The Galois group of the Galois closure of $F$ is a subgroup of $S_m wreath C_2$.

*Proof.* The lemma gives $F subset.eq K(t)$. Conversely, $sqrt(r(A_1)) + sqrt(r(B_1)) = 1$
gives $t = (1 + r(A_1) - r(B_1)) \/ 2 in F$. Moreover $a_(i+1) = (X_(i+1) - X_i) \/ (2 a_i)$, so
all the $a_i, b_j$ lie in $F$, and then the lemma expresses $sqrt(2)$ in $F$. The minimal
polynomial of $t$ over $QQ$ is $f dot f^sigma$, where $sigma$ is $sqrt(2) |-> -sqrt(2)$. Its
roots fall into two blocks of $m$, which gives the bound on the Galois group. $square$

`circle-degrees-growth.sage` computes $f$ exactly for every pattern. It factors the final
equation over $K$ and evaluates the recursion at every real root in $(0, 1)$ of every factor;
exactly one root gives an honest packing. The results for $k <= 7$, one symmetry orbit of
patterns at a time, are in @tab-growth.

#figure(
  table(
    columns: 7,
    align: (left,) + (center,) * 6,
    stroke: none,
    inset: (x: 6pt, y: 3pt),
    table.hline(),
    table.header([$k$], [2], [3], [4], [5], [6], [7]),
    table.hline(stroke: 0.5pt),
    [orbits of patterns], [1], [3], [7], [23], [71], [252],
    [largest $deg F$], [4], [6], [8], [20], [40], [66],
    [smallest $deg F$], [4], [6], [4], [6], [10], [8],
    [alternating path], [4], [6], [6], [10], [12], [16],
    table.hline(),
  ),
  kind: table,
  caption: [Degree of the field of the two-row zigzags. The alternating path continues with
  $20$ and $24$ for $k = 8, 9$.],
) <tab-growth>

- *Linear growth fails in the worst case.* The largest degree goes $8, 20, 40, 66$ for
  $k = 4, dots, 7$. Along the alternating path the degree grows by $4$ per step from $k = 6$
  on, so linear growth is plausible for that family; it is not proved. The easy rigorous
  bound, from the degrees of the rational functions in the recursion, is exponential in $k$.
- *$W$ generates $F$* in all $356$ orbits with $3 <= k <= 7$. This is not proved; for
  $k = 2$ it fails, since $W = 1$.

*Galois groups.* `circle-galois.sage` determines the Galois group for every orbit with
$k <= 7$. For $m <= 5$ it uses PARI's `polgalois` on $f f^sigma$. For larger $m$ it builds a
certificate from Frobenius elements: for a prime $p equiv plus.minus 1 thick (mod 8)$ the
factorisations of $f$ modulo the two primes of $K$ above $p$ give the cycle types of a pair
$(g, h) in S_m times S_m$. The certificate needs three things:
- an $m$-cycle and an $(m-1)$-cycle, so that both projections are primitive;
- a type with exactly one cycle of length divisible by a prime $q$, of length exactly $q$,
  where $q <= m - 3$ or $q <= 3$; a power of it is a $q$-cycle, so by Jordan's theorem both
  projections are $S_m$;
- a pair with $op("sgn") g != op("sgn") h$, and a pair with $g$ an $m$-cycle ($5$-cycle if $m = 6$) and
  $h$ not. By Goursat's lemma these rule out the two proper subdirect products of
  $S_m times S_m$.

Then the group over $K$ is $S_m times S_m$, and over $QQ$ it is the full wreath product.

*In $355$ of the $357$ orbits the Galois group is the full wreath product $S_m wreath C_2$,*
of order $2 (m!)^2$, for every $m$ from $2$ to $33$. There are two exceptions.

- $k = 2$: the group is $C_4$ rather than $D_4 = S_2 wreath C_2$. The field, cyclic of
  discriminant $2^11$, looks like $QQ(sqrt(2 + sqrt(2)))$.
- $k = 6$, pattern `11 12 13 14 24 34 44 54 55 56 66`, the pattern of largest degree for
  $k = 6$ ($m = 20$, $deg F = 40$). Here $f$ has a *second root $t'$ in $F$*: over $F$ it
  factors with degrees $1 + 1 + 18$. So $F$ has an automorphism $tau$ of order $2$ over $K$, and
  a subfield of degree $10$ over $K$. The Galois group preserves the pairing
  $\{"root", tau("root")\}$. Every Frobenius cycle type comes in matched pairs, such as
  $(10, 10)$, $(9, 9, 2)$ and $(18, 2)$, with an even number of fixed points. The norm of
  $"disc" f$ is $2$ times a square, so the two halves of each Frobenius pair always have the
  same sign. The pattern has no geometric symmetry. The conjugate $t' = -0.5479...$ is a real
  solution of the same equations in which some of the signed $sqrt(r)$ and the width are
  negative; the value $t$ itself reappears there as $a_5 = -t$. I have no explanation for this
  hidden involution.

= Circles that touch no side <sec-rows>

The theorem does not care whether a circle touches the boundary. In @fig-rows two circles
$M_1, M_2$ sit between a top row and a bottom row and touch no side; every circle touches at
least five objects. The pattern has the symmetries of the rectangle, so by part (3) of the
theorem so does the packing. The corner circles come out with radius exactly $1\/4$.

#figure(
  grid(
    columns: 2, column-gutter: 6mm,
    packing(data.three_rows, unit: 2.75cm, labels: true, label-size: 9pt),
    packing(data.three_rows, unit: 2.75cm, graph: true, labels: true),
  ),
  caption: [Eight circles, $25$ tangencies, two circles touching no side;
  $W = #fmt(data.three_rows.W)$. One packing, Jacobian of full rank.],
) <fig-rows>

= Dropping circles into gaps <sec-insert>

A circle placed in a triangular gap, tangent to its three sides, adds three unknowns and three
equations and splits the gap into three triangles, so the packing stays triangulated. The old
circles do not move, and the new radius follows from the old ones by Descartes' theorem, a
quadratic equation. Repeating this gives infinitely many rigid packings from any one, but they
are cheap: rigidity of the new circles is just the uniqueness of an inscribed circle. The
interesting patterns are the ones where every circle touches at least four objects, like the
zigzags.

#figure(
  packing(data.inserted, unit: 3.3cm),
  caption: [The six circles with a circle dropped into each of the four central gaps:
  $10$ circles, $31$ tangencies, still triangulated and rigid.],
) <fig-insert>

= Dropping a tangency <sec-flex>

Remove the tangency between $B$ and $B'$ from the six circles. There are now $18$ equations
for $19$ unknowns, and the gap between $A, B, A', B'$ is a quadrilateral. Fixing $r(A) = t$
gives back a square system, and the script follows the solution as $t$ varies. For
$t > r(A)_"rigid" = #fmt(data.six.circles.at(0).r)$ the circles $B$ and $B'$ separate and the
result is a genuine packing; for $t < r(A)_"rigid"$ they overlap. So the packings with this
pattern form a one-parameter family, and the rigid packing sits at its end, at the moment the
gap closes.

#let flex-pick = data.flex.filter(p => p.t in (0.305, 0.32, 0.34))
#figure(
  grid(
    columns: 2, column-gutter: 8mm, row-gutter: 4mm,
    align(center, stack(dir: ttb, spacing: 1.2mm,
      packing(data.six, unit: 2.3cm, emph-pair: (1, 4)),
      text(8.5pt)[$t = #fmt(data.six.circles.at(0).r)$ (rigid)])),
    ..flex-pick.map(p => align(center, stack(dir: ttb, spacing: 1.2mm,
      packing(p, unit: 2.3cm, emph-pair: (1, 4)),
      text(8.5pt)[$t = #fmt(p.t, digits: 3)$, $W = #fmt(p.W, digits: 4)$]))),
  ),
  caption: [The six circles without the tangency $B B'$: the family $r(A) = t$, with the gap
  between $B$ and $B'$ in red. The rigid packing (top left, red dot) is the end of the family,
  where the gap closes.],
) <fig-flex>

= How much of the pattern is needed? <sec-graph>

In the picture of @sec-why the four sides are circles like the others: each passes through
$infinity$, opposite sides are tangent there, and adjacent sides cross at right angles. So
the natural combinatorial datum is the contact graph $G^*$ of all $n + 4$ circles, with its
four side vertices marked as a set. Equivalently, it is a triangulation of the sphere with a
marked vertex $infinity$ of degree $4$. Naming the sides is not needed: calling a side "top"
rather than "left" only turns the picture through $90 degree$, which replaces $W$ by $1\/W$.
The side vertices are part of the configuration, not extra information. One sphere
triangulation can admit several choices of $infinity$, giving different packings.

The question is therefore not whether the side data is needed, but how much of it is
*redundant*. For square tilings half of it is. The squared-rectangle note
(`md/squared-rectangles-adjacency-graph.md`) proves that the adjacency graph of the squares,
together with the sets $T$ and $B$ of squares touching the top and the bottom, determines
the tiling. Its extremal-length argument never looks at the left and right sides: a square
tiling has no gaps, so those contacts are forced. Is the same true for circles?

`circle-graph-search.py` lists every triangulated pattern with $n$ circles. It runs through
the sphere triangulations with $n + 5$ vertices from plantri, together with every
admissible choice of $infinity$. It solves each pattern and compares the packings up to
isomorphism and scale, first by the bare tangency graph $G$ of the circles, then by $G$
together with the circles touching one pair of opposite sides ("$G + T + B$").

#figure(
  {
    let pair = (
      (W: 2.0, circles: (
        (x: 0.5, y: 0.5, r: 0.5, label: "", row: "top"),
        (x: 1.5, y: 0.5, r: 0.5, label: "", row: "top")), cc: ((0, 1),), walls: ()),
      (W: 1.0, circles: (
        (x: 0.5, y: 0.5, r: 0.5, label: "", row: "top"),
        (x: 0.0857864, y: 0.9142136, r: 0.0857864, label: "", row: "bottom")),
        cc: ((0, 1),), walls: ()),
    )
    grid(columns: 2, column-gutter: 10mm, align: horizon,
      packing(pair.at(0), unit: 1.6cm), packing(pair.at(1), unit: 1.6cm))
  },
  caption: [Two triangulated packings whose bare tangency graph is $K_2$. The radii are
  in ratio $1 : 1$ on the left and $1 : 3 - 2 sqrt(2)$ on the right. The full patterns
  $G^*$ differ in which circles touch which sides.],
) <fig-k2>

#figure(
  table(
    columns: 5,
    align: (left, center, center, center, left),
    stroke: none,
    inset: (x: 5pt, y: 3pt),
    table.hline(),
    table.header([patterns], [$n$], [solved], [conflicts, $G$], [conflicts, $G + T + B$]),
    table.hline(stroke: 0.5pt),
    [all triangulated], [$<= 6$], [$1664 \/ 1672$], [from $n = 2$], [first at $n = 5$ (4)],
    [every circle touches $>= 4$ objects], [$<= 7$], [$609 \/ 619$], [from $n = 4$],
      [first at $n = 7$ (7)],
    [no circle touches two opposite sides], [$<= 8$], [$5201 \/ 5210$], [from $n = 5$],
      [first at $n = 8$ (11)],
    [*both restrictions*], [$<= 8$], [$426 \/ 428$], [from $n = 5$], [*none*],
    table.hline(),
  ),
  kind: table,
  caption: [Conflicts are pairs of packings with the same data but different radii (up to
  scale). The number in brackets is the number of conflicting graphs at the first $n$ where
  they occur.],
) <tab-graph>

The results, in @tab-graph:

- *The bare graph $G$ determines nothing.* Already for $n = 2$ the same $G = K_2$ comes from
  two packings with different radii (@fig-k2), and almost every graph that occurs comes from
  several patterns with different radii.
- *$G + T + B$ fails from $n = 5$ on.* In the counterexamples one of two things happens. A
  circle may touch two opposite sides, typically a circle inscribed in a square with the
  other circles in one corner gap. Or circles may be dropped into gaps along an unmarked side
  in different orders. In both cases the left and right contacts carry information that $G$,
  $T$ and $B$ do not see.
- *Excluding both, no conflicts remain* for $n <= 8$: $426$ packings of patterns in which
  every circle touches at least four objects and no circle touches two opposite sides.

*Conjecture.* For triangulated packings in which every circle touches at least four objects
and no circle touches two opposite sides, $G$ together with $T$ and $B$ determines the
packing.

This is evidence, not a proof. The extremal-length argument for squares has no obvious
analogue for circles. The solver also failed on under $1%$ of the patterns in every run ($2$ of the $428$
in the restricted class), and a conflict could in principle hide among them.
Full side data, on the other hand, always suffices, by @sec-why.

= The container matters <sec-disk>

Rigidity comes from the rectangle, not from the triangulation alone. For a triangulated
packing inside a _disk_, with the outer circles touching the boundary circle, the same theorem
gives uniqueness only up to the Möbius maps that preserve the disk. That group is
$3$-dimensional; rotations are harmless, but the other two parameters change the ratios of
the radii. So triangulated packings in a disk are never rigid, and circle-in-circle puzzles are
rigid only because of extra conditions such as equal radii. A container bounded by lines that
all pass through one point $infinity$ of the sphere, such as a rectangle, a strip or a
triangle, leaves only similarities.

#v(4mm)
#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *What the script checks.* `circle-packings.py`, output in `results/circle-packings.txt`,
  figure data in `circle-packings.json`. A solution counts only if it is an honest packing of
  the pattern: all circles inside the rectangle, no overlaps, and no tangency beyond the
  prescribed ones.
  (1) every two-row zigzag with $k = 2, 3, 4$: exactly one packing from $300$ random starts,
  Jacobian of rank $3n + 1$;
  (2) the six circles, with the half-turn symmetry;
  (3) the three-row packing with two interior circles;
  (4) four inserted circles, with the old circles unchanged;
  (5) the one-parameter family after dropping $B B'$, and which side of the rigid packing
  gives honest packings.
  `circle-degrees.sage`, output in `results/circle-degrees.txt`:
  (6) for every two-row zigzag with $k = 2, 3, 4$ the minimal polynomials of $W$ and of
  generators of the field, by LLL at $3000$ digits, rechecked at $6000$, and certified by an
  exact verification of all equations in the number field (@sec-degrees).
  `circle-degrees-growth.sage` and `circle-galois.sage`, output in
  `results/circle-degrees-growth.txt` and `results/circle-galois.txt`:
  (6b) for every two-row zigzag with $k <= 7$ the exact factor $f$ and $deg F$, and the Galois
  group, by `polgalois` for $m <= 5$ and a Frobenius certificate otherwise (@sec-growth).
  `circle-graph-search.py`, output in `results/circle-graph-search*.txt`:
  (7) every triangulated pattern with $n <= 6$ circles, and the two restricted classes up
  to $n = 8$, solved and compared by the bare graph $G$ and by $G + T + B$ (@sec-graph).
]
