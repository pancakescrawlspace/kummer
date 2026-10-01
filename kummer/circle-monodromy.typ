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

#let data = json("circle-monodromy.json")
#let red = rgb("#c0392b")
#let fills = (top: rgb("#d6e4f0"), bottom: rgb("#f6dcc8"))

// zigzag labels -> the names of the six circles
#let names = (A1: $A$, A2: $B$, A3: $C$, B1: $C'$, B2: $B'$, B3: $A'$)
#let lab(s) = names.at(s)

// a configuration of the six-circle family: the strip 0 <= y <= 1, the
// walls x = 0 and x = W dashed, A2 and B2 (the dropped tangency) outlined
// in red.  `window` = (xmin, xmax, ymin, ymax) of the drawing.
#let config(c, unit: 1.6cm, window: none, labels: true) = cetz.canvas(length: unit, {
  import cetz.draw: *
  let W = c.W
  let (x0, x1, y0, y1) = if window == none { (-0.05, W + 0.05, -0.05, 1.05) } else { window }
  line((x0, 0), (x1, 0), stroke: 0.9pt)
  line((x0, 1), (x1, 1), stroke: 0.9pt)
  for xw in (0, W) {
    if xw >= x0 and xw <= x1 {
      line((xw, y0), (xw, y1), stroke: (paint: luma(90), thickness: 0.7pt, dash: "dashed"))
    }
  }
  for k in c.circles {
    let hl = k.label == "A2" or k.label == "B2"
    circle((k.x, k.y), radius: k.r, fill: fills.at(k.row).transparentize(25%),
      stroke: if hl { 1.1pt + red } else { 0.55pt })
    if labels and k.r > 0.06 {
      content((k.x, k.y), text(7.5pt, lab(k.label)))
    }
  }
})

#let fmt(x, d: 4) = str(calc.round(x, digits: d))

// the graph of u(t)
#let graph = cetz.canvas(length: 1cm, {
  import cetz.draw: *
  let (tx0, tx1, uy0, uy1) = (-1.5, 3.5, -6.0, 4.0)
  let sx = 2.6
  let sy = 0.55
  let P(t, u) = ((t - tx0) * sx, (u - uy0) * sy)
  // axes
  line(P(tx0, 0), P(tx1, 0), stroke: 0.5pt + luma(120))
  line(P(0, uy0), P(0, uy1), stroke: 0.5pt + luma(120))
  for tt in (-1, 1, 2, 3) {
    line(P(tt, -0.12), P(tt, 0.12), stroke: 0.5pt + luma(120))
    content(P(tt, -0.45), text(7pt)[#tt])
  }
  for uu in (-4, -2, 2) {
    line(P(-0.05, uu), P(0.05, uu), stroke: 0.5pt + luma(120))
    content(P(-0.2, uu), text(7pt)[#uu])
  }
  content(P(tx1 - 0.1, 0.45), text(8pt)[$t$])
  content(P(0.25, uy1 - 0.3), text(8pt)[$u$])
  // the levels u = -1 (packing) and u = +1 (the other tangency)
  line(P(tx0, -1), P(tx1, -1), stroke: (paint: red, thickness: 0.8pt, dash: "dashed"))
  content(P(tx1 - 0.35, -1.45), text(7.5pt, fill: red)[$u = -1$])
  line(P(tx0, 1), P(tx1, 1), stroke: (paint: luma(140), thickness: 0.6pt, dash: "dotted"))
  content(P(tx1 - 0.35, 1.4), text(7.5pt, fill: luma(100))[$u = +1$])
  // the pole t = 1
  line(P(1, uy0), P(1, uy1), stroke: (paint: luma(170), thickness: 0.5pt, dash: "dotted"))
  // the curve, in pieces between the breaks
  let pieces = ()
  let cur = ()
  for p in data.graph {
    let (tt, uu) = (p.at(0), p.at(1))
    if uu == none or uu < uy0 or uu > uy1 or tt < tx0 or tt > tx1 {
      if cur.len() > 1 { pieces.push(cur) }
      cur = ()
    } else {
      cur.push(P(tt, uu))
    }
  }
  if cur.len() > 1 { pieces.push(cur) }
  for pc in pieces { line(..pc, stroke: 1.1pt + rgb("#2471a3")) }
  // marked points
  let honest = data.packing
  circle(P(honest.t, -1), radius: 0.09, fill: red, stroke: none)
  content(P(honest.t + 0.05, -1.75), text(7.5pt, fill: red)[packing])
  let cr = data.critical.at(2)
  circle(P(cr.points.at(0).at(0), cr.values.at(0).at(0)), radius: 0.08, fill: black, stroke: none)
  content(P(cr.points.at(0).at(0) - 0.05, cr.values.at(0).at(0) + 0.55), text(7.5pt)[$xi_1$])
  circle(P(0.2928932, 1), radius: 0.08, fill: black, stroke: none)
  content(P(0.42, 1.55), text(7.5pt)[$t_0$])
  content(P(2.95, uy0 + 0.5), text(7.5pt)[$xi_2 = 2.947 arrow.b$])
})

// ---------------------------------------------------------------------

#align(center)[
  #text(size: 16pt, weight: "bold")[The six circles as a fibre]
  #v(2mm)
  #text(size: 10pt)[Drop one tangency, and the packing becomes one point of a curve of
  configurations. The angle at the dropped tangency is then a rational function on that
  curve, and its monodromy and critical points explain the Galois group of the packing and
  the prime $73$]
  #v(1mm)
  #text(size: 9pt, style: "italic")[computations in `circle-monodromy.sage`, output in
  `results/circle-monodromy.txt`, figure data in `circle-monodromy.json`; continues
  `circle-packings.typ`]
]

#v(4mm)

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *Results.* For the six circles of the MathOverflow problem, height $1$,
  $K = QQ(sqrt(2))$:
  + Without the tangency $B B'$, the configurations form a curve, and it is the line of the
    parameter $t = sqrt(r(A))$.
  + On that line the inversive distance $delta$ of $B$ and $B'$ satisfies $delta = 2u^2 - 1$
    for a *rational function $u$ of degree $3$* over $K$, the cosine of the half-angle at
    which $B$ and $B'$ cross. The packing is the fibre $u = -1$, and this fibre is exactly
    the cubic $f$ that defines the field of the packing.
  + The monodromy of $u$ is $S_3$. With the constant field $QQ(sqrt(2))$ this gives the
    Galois group $S_3 wreath C_2$.
  + $73$ ramifies because, modulo $73$, a critical value of $u$ becomes $-1$: the packing
    collides with a flexible configuration (@sec-73).

  The same holds for both patterns of degree $8$ at $k = 4$, whose covers turn out to be
  the same up to a Möbius change of $t$, and for the exceptional $k = 6$ pattern, where $u$
  has degree $20$ and monodromy $S_20$ (@sec-more).
]

= Dropping a tangency <sec-family>

Label the six circles as in `circle-packings.typ`: $A, B, C$ along the top and $A', B', C'$
along the bottom, as the zigzag `11 12 22 23 33`. In zigzag labels $A_1 = A$,
$A_2 = B$, $A_3 = C$, $B_1 = C'$, $B_2 = B'$, $B_3 = A'$. Now forget the tangency between
$B$ and $B'$.

Without it the configuration is no longer rigid. It falls apart into a *left chain*
$A, C', B'$ and a *right chain* $C, A', B$. The left chain is built by the recursion of
`circle-packings.typ` (§5) from $t = sqrt(r(A))$, and the right chain by the same recursion
read from the right wall, from $v = sqrt(r(C))$. The two chains are glued by the two
tangencies across the cut, $A$ to $B$ and $B'$ to $A'$. Both gluing conditions involve the
unknown width $W$ linearly. Eliminating $W$ leaves one equation $Phi(t, v) = 0$: the curve
of all configurations with every tangency except $B B'$. For the six circles the component
through the packing is a line, with $v$ a linear function of $t$. So *the parameter $t$ is
a coordinate on the curve*.

@fig-family shows what happens along it. Moving $t$, the circles $B$ and $B'$ (red) pass
from disjoint, through tangent (the packing), to crossing, and at $t = 1\/2$ they coincide.
The pattern keeps its half-turn symmetry all the way.

#figure(
  grid(
    columns: 5, column-gutter: 2.5mm, row-gutter: 2mm, align: center + bottom,
    ..("t=0.60", "t=0.57", "packing", "t=0.53", "t=0.50").map(name => {
      let c = data.at(name)
      stack(dir: ttb, spacing: 1.2mm,
        config(c, unit: 1.08cm, labels: false),
        text(7.5pt)[$t = #fmt(c.t, d: 3)$, $u = #fmt(c.u, d: 2)$])
    }),
  ),
  caption: [The family of configurations without the tangency $B B'$ (the two red
  circles). From the left: $B, B'$ disjoint; disjoint; tangent, which is the packing,
  $t = 0.5507$; crossing; coinciding. The dashed lines are the walls $x = 0$ and $x = W$.],
) <fig-family>

= The half-angle <sec-u>

The natural measure of how far $B$ and $B'$ are from touching is their *inversive distance*
$ delta = (d^2 - r_1^2 - r_2^2) / (2 r_1 r_2), $
with $d$ the distance of the centres and $r_1, r_2$ the radii. It is $1$ for external
tangency, it is $cos theta$ when the circles cross at angle $theta$, and it is larger
than $1$ when they are disjoint. On our line $delta$ is a rational function of $t$ of degree
$6$. It is the square of something simpler:
$ delta = 2 u^2 - 1, quad u(t) = ((-2 sqrt(2) - 2) t^3 + (sqrt(2) - 1) t^2 + (1 - sqrt(2)) t + sqrt(2) \/ 2) / (t - 1)^2 . $
The formula $delta = 2 u^2 - 1 = cos theta$ is the double-angle formula: $plus.minus u$
is the cosine of *half* the crossing angle (the hyperbolic cosine of half the inversive
distance for disjoint circles). The square roots of the radii are spinor-like coordinates,
and in such coordinates angles are naturally halved.

Each value of $u$ is taken $3$ times, counted over $CC$. The two tangent values are:
- $u = -1$: the equation $u(t) = -1$ is, after clearing denominators, exactly
  $ f(t) = t^3 + (sqrt(2)\/2 - 1) t^2 + t\/2 - sqrt(2)\/4 = 0, $
  the minimal polynomial over $K$ of $sqrt(r(A))$ found at the very start. *The packing is
  this fibre.*
- $u = +1$: the fibre is $(t + sqrt(2)\/2)(t + sqrt(2)\/2 - 1)^2 = 0$. Its double point
  $t_0 = 1 - sqrt(2)\/2$ is a degenerate configuration: $C'$ and $C$ have radius $1\/2$ and
  touch top and bottom, and $B$ and $B'$ have become lines.

@fig-graph shows the graph of $u$ over the real $t$-line.

#figure(
  graph,
  caption: [The half-angle function $u(t)$ on the real line. The red dashed line $u = -1$
  meets the graph in exactly one real point, the packing $t = 0.5507$; the other two
  solutions of $u = -1$ are complex conjugate. The black points are critical points of $u$:
  $t_0 = 1 - sqrt(2)\/2$ with critical value $1$, and $xi_1 = -0.240$ with critical value
  $0.584$. The third, $xi_2 = 2.947$, has critical value $-31.79$, off the picture. At
  $t = 1$ (dotted) $u$ has a double pole.],
) <fig-graph>

= Monodromy and the Galois group <sec-monodromy>

Think of $u$ as a map from the $t$-line to the $u$-line, of degree $3$. Over a general value
of $u$ lie three configurations. Following them as $u$ travels around a loop permutes them;
these permutations form the *monodromy group* of $u$. Its critical points are where two of
the three configurations come together, and there are four of them: $t_0$, $xi_1$, $xi_2$
and the double pole $t = 1$. This agrees with Riemann–Hurwitz, $2 dot 3 - 2 = 4$. A
simple critical point gives a transposition, and a transitive group of degree $3$ that
contains a transposition is $S_3$. So the monodromy of $u$ is $S_3$, already over $K$.

The packing is a fibre of this cover. Its field $F = K(t)$, with $t$ a root of $f$, has
Galois group $S_3$ over $K$: the full monodromy group, as expected for a fibre that is not
special. Over $QQ$ there is one more ingredient. The cover is defined over $K = QQ(sqrt(2))$
and not over $QQ$; its conjugate under $sqrt(2) |-> -sqrt(2)$ is a second, different cover.
Together they give
$ "Gal" = S_3 wreath C_2 = (S_3 times S_3) times.r C_2, $
the group found for the six circles in `circle-packings.typ`. The wreath product is
explained: *monodromy $S_3$ of the half-angle, plus the constant field $QQ(sqrt(2))$.*

= Where $73$ comes from <sec-73>

Here is the argument in small steps.

*Step 1: three solutions.* The equation $u(t) = -1$ has three solutions over $CC$, the
roots of $f$. One is real, the packing $t = 0.5507$. The other two are complex conjugate:
they are "packings" with complex radii, solutions of the same tangency equations. In
@fig-graph the line $u = -1$ meets the graph only once, because the other two solutions are
not real.

*Step 2: what ramification means.* A prime $p$ ramifies in $F$ when, modulo $p$, the
equation $f(t) = 0$ acquires a *repeated root*: two of the three solutions become equal.
(Precisely: modulo some prime of $K$ above $p$; for these small fields the index causes no
trouble.) The discriminant of $f$ detects this. Here
$ "disc" f = -9\/4 - sqrt(2)\/2, quad N_(K\/QQ)("disc" f) = 73 \/ 2^4 , $
so the only odd prime is $73$.

*Step 3: a repeated root sits at a critical point.* If $t_*$ is a double root of
$u(t) + 1 = 0$, then both $u(t_*) + 1 = 0$ and $u'(t_*) = 0$. So $t_*$ is a critical point of
$u$, and its critical value is $-1$. Conversely, two solutions of $u = -1$ can only merge at
a critical point whose critical value is $-1$. There is a classical formula for the discriminant of a fibre of a rational function: up
to constants coming from the poles and leading coefficients,
$ "disc" f quad prop quad product_(xi " critical point of " u) (u(xi) + 1). $
So the primes that ramify are the primes at which some critical value of $u$ becomes
congruent to $-1$.

*Step 4: over the real numbers this does not happen.* The finite critical values are
$u(t_0) = 1$, $u(xi_1) = 0.5835$ and $u(xi_2) = -31.79$. None of them is $-1$; in @fig-graph
the line $u = -1$ passes through no turning point of the graph. That is why the packing is a
simple root.

*Step 5: but arithmetically it nearly does.* $xi_1$ and $xi_2$ are the two roots of
$t^2 - (2 + sqrt(2)\/2) t - sqrt(2)\/2$, so they are conjugate. Their contribution to the
product is an element of $K$:
$ (u(xi_1) + 1)(u(xi_2) + 1) = -24 - 35 sqrt(2) \/ 2 approx -48.75, quad
  N_(K\/QQ) = -73 \/ 2 . $
The critical point $t_0$ contributes $u(t_0) + 1 = 2$, and the pole only powers of $2$. So
*$73$ is precisely the prime at which the critical value $u(xi)$ meets the tangent value
$-1$.*

*Step 6: modulo $73$, explicitly.* Since $32^2 = 1024 = 14 dot 73 + 2$, the number $2$ has
the square roots $plus.minus 32$ modulo $73$, and $73$ splits in $K$. Choose $sqrt(2) equiv 32$.
Then
$ f(t) equiv (t + 46)(t + 21)^2, quad t^2 - (2 + sqrt(2)\/2) t - sqrt(2)\/2 equiv (t + 21)(t + 34) quad (mod 73). $
So $f$ has the double root $t equiv -21 equiv 52$, and $52$ is also a root of the
critical-point quadratic. Directly: $u(52) equiv -1$ and $u'(52) equiv 0 (mod 73)$. The
packing and one of its complex conjugates have become the same point, and that point is the
critical configuration $xi$.

*Step 7: only one of the two primes.* With the other square root, $sqrt(2) equiv 41$, the
cubic $f$ stays irreducible modulo $73$. So only one of the two primes of $K$ above $73$
ramifies in $F$, as found in `circle-packings.typ` from the discriminant.

*Step 8: geometric meaning.* At a critical point of $u$ the angle between $B$ and $B'$ is
stationary to first order: one can move along the curve without changing that angle, even
though the configuration then changes. Equivalently, the configuration is a solution of the
*full* six-circle system whose Jacobian is singular: it is *infinitesimally flexible*. So
"$73$ ramifies" means: *modulo $73$, the six circles become infinitesimally flexible*. They
coincide with the flexible configuration $xi$. Over $RR$ that configuration is the one in
@fig-flexible. It is not a packing (some signed square roots of radii are negative, and
circles cross the lines), but it satisfies all the tangencies except $B B'$, and $B, B'$
cross at the angle with $cos(theta\/2) = 0.5835$.

#figure(
  {
    let c = data.at("critical t=-0.2399")
    config(c, unit: 1.1cm, window: (-1.8, 2.2, -2.2, 3.2))
  },
  caption: [The flexible configuration $xi_1$ ($t = -0.240$): all tangencies of the six
  circles except $B B'$ hold, and $u$ has a critical point. Modulo $73$ the six-circle
  packing collides with a configuration of this kind. The dashed lines are the walls
  $x = 0$ and $x = W = 0.232$.],
) <fig-flexible>

An analogy: the field $QQ(sqrt(d))$ ramifies at the primes dividing $d$. The map
$x |-> x^2$ has a single critical point $x = 0$, with critical value $0$, and the fibre over
$d$ is ramified exactly where $d equiv 0$, that is where the critical value meets $d$. The
six circles are the same story with $x |-> x^2$ replaced by the half-angle $u$, and $d$
replaced by the tangent value $-1$.

= Two more patterns <sec-more>

The same computation for other zigzags of `circle-packings.typ`.

- *The two patterns of degree $8$ at $k = 4$*, `11 12 22 32 33 34 44` (dropping
  $A_3 B_2$) and `11 12 13 14 24 34 44` (dropping $A_1 B_4$). In both cases the curve is the
  $t$-line and $u$ has degree $4 = m$. The fibre $u = -1$ is exactly the defining quartic,
  and the monodromy is $S_4$. The ramified primes $7$ and $569$ occur, as in @sec-73, only
  among the critical values of $u$.

  These are the two patterns that `circle-packings.typ` (§4) found to have isomorphic
  fields without explanation. Here is the explanation: *their half-angle covers are the same
  up to a change of coordinate.* Exactly, $u_2 = u_1 compose mu$ with
  $ mu(t) = ((sqrt(2)\/2 - 1\/2) t + 1\/2 - sqrt(2)\/2) / ((sqrt(2)\/2) t + 1\/2 - sqrt(2)\/2). $
  The map $mu$ sends the packing of the second pattern to $t = -0.335$, which is *another*
  point of the fibre $u_1 = -1$ of the first pattern, a real configuration that is not a
  packing. So the two packings are two different points of one and the same fibre, and
  their fields are isomorphic.

- *The exceptional pattern* `11 12 13 14 24 34 44 54 55 56 66` of `circle-packings.typ`
  (§6), dropping $A_5 B_6$. Here $u$ has degree $20 = m$, the fibre $u = -1$ is exactly $f$,
  and a generic fibre has Galois group $S_20$, certified by Frobenius elements as in
  `circle-packings.typ` (§5). So the monodromy is $S_20$, and the involution of the packing
  is *not* a symmetry of the cover: the map $t |-> -a_5(t)$ does not preserve $u$. It is an
  accident of the one fibre $u = -1$, a special value in the sense of Hilbert's
  irreducibility theorem.

Not every dropped tangency gives a curve that is a graph over the $t$-line. For the
exceptional pattern, dropping $A_1 B_4$ or $A_5 B_4$ does not, and neither does the
first choice for the pair of $k = 3$ patterns with isomorphic fields. For those the curve
is more complicated, and this note does not treat them.

= Outlook <sec-outlook>

The emerging statement is: *the field of a rigid packing is a fibre, over the tangent value,
of a half-angle cover with full symmetric monodromy, defined over $QQ(sqrt(2))$*. If that
holds, it would explain:
- the generic Galois group $S_m wreath C_2$;
- the exceptions, as accidental symmetries of the tangent fibre;
- the ramified primes, as collisions with flexible configurations modulo $p$;
- isomorphic fields of different patterns, as one cover seen in two coordinates;
- the degree $m$, as the degree of the half-angle function. This is the place to look for
  a formula for the growth of the degrees.

What is missing is a proof that the relevant component is always rational and that $u$ is
always a rational function on it, and an understanding of which tangency to drop.

#v(4mm)
#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *What the script checks.* `circle-monodromy.sage`, output in
  `results/circle-monodromy.txt`, figure data in `circle-monodromy.json`.
  (1) For the six circles: the curve $Phi(t, v) = 0$ and its component through the packing;
  $u^2 = (delta + 1)\/2$ is a square in $K(t)$; $u$; the fibres $u = plus.minus 1$; that the
  fibre $u = -1$ is the minimal polynomial of the packing; the critical points; Frobenius
  certificates of monodromy $S_3$; and the norms of $"Res"(f, dot)$ against every critical
  point, which locate $73$.
  (2) The same for the two $k = 4$ patterns of degree $8$, and the exact Möbius map
  between their covers.
  (3) The exceptional $k = 6$ pattern: degree $20$, monodromy $S_20$, and that the
  involution does not preserve $u$.
]
