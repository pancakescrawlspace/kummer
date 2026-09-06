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

#align(center)[
  #text(size: 16pt, weight: "bold")[Pascal's theorem]
  #v(2mm)
  #text(size: 10pt)[Six points on a conic and the line that appears: a proof by a pencil
  of cubics, a synthetic proof after Steiner, the one identity all the degenerations come
  from, and what the figure turns into when the conic breaks]
  #v(1mm)
  #text(size: 9pt, style: "italic")[figures and checks in `pascal.gp`,
  output in `results/pascal.txt`]
]

#v(4mm)

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *The theorem.* If $A_1, ..., A_6$ lie on a conic, the three points
  $ X = A_1 A_2 inter A_4 A_5, wide Y = A_2 A_3 inter A_5 A_6, wide
    Z = A_3 A_4 inter A_6 A_1 $
  are collinear.

  *The proof, in three sentences.* The alternate sides split the hexagon into two
  triangles of lines, and each triangle is a *cubic curve*: $F = ell_12 ell_34 ell_56$ and
  $G = ell_23 ell_45 ell_61$. Both vanish at nine points --- the six vertices and $X, Y, Z$ ---
  so every member of the pencil $lambda F + mu G$ does. Choose the member through a seventh
  point of the conic: it then meets the conic too often, so it *contains* the conic, and being a
  cubic it is the conic together with a line --- a line which must therefore carry $X, Y, Z$.

  Only one lemma is needed (@sec-lemma), and it is proved by dividing by $x z - y^2$; no Bézout,
  no Nullstellensatz.

  Two further proofs follow. @sec-steiner is Steiner's: no coordinates at all, the Pascal line
  arriving as the *axis of a perspectivity* between two ranges cut on a pair of chords.
  @sec-identity is computational, and its virtue is that every degenerate form of the theorem ---
  tangents in place of sides, Pappus --- is a *specialization of a single polynomial identity*
  rather than a separate limiting argument.
]

= The statement <sec-statement>

Throughout, $PP^2 = PP^2 (k)$ is the projective plane over a field $k$. A *conic* is the zero
locus $Q = V(q)$ of a nonzero quadratic form; it is *smooth* if $q$ is irreducible over
$overline(k)$. By a *hexagon* inscribed in $Q$ we mean simply an ordered six-tuple
$(A_1, ..., A_6)$ of distinct points of $Q$ --- no convexity, and no assumption that the sides
avoid one another. Its *sides* are the six lines $A_1 A_2, A_2 A_3, ..., A_6 A_1$, and two sides
are *opposite* when their indices differ by three.

#block(inset: (left: 6pt))[
  *Theorem 1 (Pascal, 1640).* Let $A_1, ..., A_6$ be six distinct points on a smooth conic $Q$.
  Then the three intersection points of opposite sides,
  $ X = A_1 A_2 inter A_4 A_5, wide Y = A_2 A_3 inter A_5 A_6, wide Z = A_3 A_4 inter A_6 A_1, $
  are well defined and lie on a single line --- the *Pascal line* of the hexagon.
]

#figure(
  cetz.canvas(length: 1cm, {
  import cetz.draw: *
  circle((0,0), radius: (3.4, 2.2), stroke: 0.9pt + black)
  line((-3.371, 2.687), (5.125, -2.432), stroke: 1.7pt + luma(115))
  line((-2.823, -1.537), (-2.675, 2.574), stroke: 0.9pt + rgb("#c0392b"))
  line((-3.013, 1.383), (3.693, -0.063), stroke: 0.9pt + rgb("#2471a3"))
  line((2.583, 1.587), (4.577, -2.286), stroke: 0.9pt + rgb("#1e8449"))
  line((3.015, 1.268), (-2.981, 2.326), stroke: 0.9pt + rgb("#c0392b"))
  line((-1.506, 2.256), (2.239, -1.985), stroke: 0.9pt + rgb("#2471a3"))
  line((4.738, -2.051), (-3.110, -1.205), stroke: 0.9pt + rgb("#1e8449"))
  circle((-2.812, -1.237), radius: 0.075, fill: black, stroke: none)
  circle((-2.720, 1.320), radius: 0.075, fill: black, stroke: none)
  circle((3.400, 0.000), radius: 0.075, fill: black, stroke: none)
  circle((2.720, 1.320), radius: 0.075, fill: black, stroke: none)
  circle((-1.308, 2.031), radius: 0.075, fill: black, stroke: none)
  circle((2.040, -1.760), radius: 0.075, fill: black, stroke: none)
  circle((-2.686, 2.274), radius: 0.095, fill: white, stroke: 1.0pt + black)
  circle((-0.200, 0.776), radius: 0.095, fill: white, stroke: 1.0pt + black)
  circle((4.440, -2.019), radius: 0.095, fill: white, stroke: 1.0pt + black)
  content((-3.153, -1.578), text(9pt)[$A_1$])
  content((-3.062, 1.662), text(9pt)[$A_2$])
  content((3.742, 0.342), text(9pt)[$A_3$])
  content((2.962, 1.738), text(9pt)[$A_4$])
  content((-1.183, 2.497), text(9pt)[$A_5$])
  content((1.915, -2.227), text(9pt)[$A_6$])
  content((-2.344, 2.615), text(9pt)[$X$])
  content((0.042, 1.195), text(9pt)[$Y$])
  content((4.682, -1.601), text(9pt)[$Z$])
  }),
  caption: [A hexagon $A_1 ... A_6$ inscribed in a conic. Opposite sides carry the same colour; each pair meets in one of $X, Y, Z$, and the three lie on the grey Pascal line. The configuration drawn is exact: the six points are rational points of the ellipse, and the collinearity determinant of $X, Y, Z$ is $0$.],
) <fig-pascal>


Two remarks before the proof. First, the projective setting is not decoration: over the affine
plane the theorem would need a case distinction for parallel opposite sides, and here that case
is simply a point of the Pascal line lying on the line at infinity. Second, the labelling matters
and the ordering is arbitrary: the same six points arranged into a different hexagon have a
different Pascal line, and @sec-mysticum counts what happens when one takes all of them at once.

= Conventions, and the one fact about lines and conics <sec-conventions>

Points and lines of $PP^2$ are both given by nonzero triples up to scalar, a point
$P = (p_1 : p_2 : p_3)$ lying on a line $ell = [l_1 : l_2 : l_3]$ when $sum l_i p_i = 0$. The line
through two distinct points, and the intersection point of two distinct lines, are both given by
the cross product; three points are collinear exactly when the determinant of their coordinate
triples vanishes. This is what the companion script computes.

#block(inset: (left: 6pt))[
  *Fact 2.* A line meets a smooth conic in at most two points.
]

#v(1mm)
Indeed, parametrize the line as $s P + t P'$ and substitute: $q(s P + t P')$ is a binary quadratic
form in $(s : t)$, so it either has at most two zeros or vanishes identically; in the latter case
the line lies inside $Q$, and then its linear form divides $q$, contradicting irreducibility.

Fact 2 already makes Theorem 1 meaningful. The six chords in the statement are pairwise distinct:
if, say, $A_1 A_2 = A_4 A_5$ then four distinct points of $Q$ would lie on one line, and if
$A_1 A_2 = A_2 A_3$ then three would. So opposite sides are distinct lines and meet in exactly one
point, and $X, Y, Z$ are well defined. The same fact shows

$ X, Y, Z in.not Q : $ for $X in A_1 A_2 inter A_4 A_5$ and $Q inter A_1 A_2 subset.eq {A_1, A_2}$,
$Q inter A_4 A_5 subset.eq {A_4, A_5}$, and those two sets are disjoint. This innocuous point is
exactly what the proof needs at its last step.

= A lemma on cubics through seven points of a conic <sec-lemma>

Everything rests on one statement, a hand-made special case of Bézout's theorem.

#block(inset: (left: 6pt))[
  *Lemma 3.* Let $Q$ be a smooth conic with a $k$-rational point, and let $C$ be a form of
  degree $d$ vanishing at more than $2d$ distinct points of $Q$. Then $q divides C$.
]

#v(1mm)
*Proof.* Projection from a point of $Q$ identifies $Q$ with $PP^1$; concretely, choose
coordinates in which
$ q = x z - y^2 , wide nu : PP^1 --> Q, wide nu(s : t) = (s^2 : s t : t^2) , $
a bijection onto $Q$. Then $C compose nu$ is a binary form of degree $2d$. It vanishes at the more
than $2d$ distinct parameters corresponding to the given points, so $C compose nu = 0$: the form
$C$ vanishes at *every* point of $Q$.

Now divide. Viewed as a polynomial in $y$, $q = -(y^2 - x z)$ has leading coefficient $-1$, a
unit, so Euclidean division by $q$ is available over any ring of coefficients:
$ C = q A + B y + D , wide A, B, D #[forms in] x, z #[alone,] $
with $B$ of degree $d - 1$ and $D$ of degree $d$ by homogeneity. Substituting $nu$ and using
$q(nu) = 0$,
$ 0 = C(nu) = B(s^2, t^2) thin s t + D(s^2, t^2) . $
Every monomial of $B(s^2, t^2) s t$ has *odd* exponents in both $s$ and $t$; every monomial of
$D(s^2, t^2)$ has *even* ones. The two families are disjoint, so both terms vanish identically,
and since $B mapsto B(s^2,t^2)$ merely doubles exponents, $B = D = 0$. Hence $C = q A$. $qed$

#v(1mm)
The case we use is $d = 3$: *a cubic through seven distinct points of a smooth conic contains the
conic*, and is then $q$ times a linear form. Note the proof is characteristic-free, and uses
neither Bézout nor the Nullstellensatz.

= Proof of Pascal's theorem <sec-proof>

Choose linear forms $ell_(i j)$ cutting out the chords $A_i A_j$, and set
$ F = ell_12 thin ell_34 thin ell_56 , wide G = ell_23 thin ell_45 thin ell_61 . $
These are cubic forms: each is a *triangle of lines*, the two triangles being the alternate sides
of the hexagon (@fig-cubics).

#figure(
  cetz.canvas(length: 1cm, {
  import cetz.draw: *
  circle((0,0), radius: (3.4, 2.2), stroke: 0.8pt + luma(160))
  line((-2.823, -1.537), (-2.675, 2.574), stroke: 1.0pt + rgb("#c0392b"))
  line((2.583, 1.587), (4.577, -2.286), stroke: 1.0pt + rgb("#c0392b"))
  line((-1.506, 2.256), (2.239, -1.985), stroke: 1.0pt + rgb("#c0392b"))
  line((-3.013, 1.383), (3.693, -0.063), stroke: 1.0pt + rgb("#2471a3"))
  line((3.015, 1.268), (-2.981, 2.326), stroke: 1.0pt + rgb("#2471a3"))
  line((4.738, -2.051), (-3.110, -1.205), stroke: 1.0pt + rgb("#2471a3"))
  circle((-2.812, -1.237), radius: 0.075, fill: black, stroke: none)
  circle((-2.720, 1.320), radius: 0.075, fill: black, stroke: none)
  circle((3.400, 0.000), radius: 0.075, fill: black, stroke: none)
  circle((2.720, 1.320), radius: 0.075, fill: black, stroke: none)
  circle((-1.308, 2.031), radius: 0.075, fill: black, stroke: none)
  circle((2.040, -1.760), radius: 0.075, fill: black, stroke: none)
  circle((-2.686, 2.274), radius: 0.095, fill: white, stroke: 1.0pt + black)
  circle((-0.200, 0.776), radius: 0.095, fill: white, stroke: 1.0pt + black)
  circle((4.440, -2.019), radius: 0.095, fill: white, stroke: 1.0pt + black)
  content((-3.153, -1.578), text(8pt)[$A_1$])
  content((-3.062, 1.662), text(8pt)[$A_2$])
  content((3.742, 0.342), text(8pt)[$A_3$])
  content((2.962, 1.738), text(8pt)[$A_4$])
  content((-1.183, 2.497), text(8pt)[$A_5$])
  content((1.915, -2.227), text(8pt)[$A_6$])
  content((-2.344, 2.615), text(8pt)[$X$])
  content((0.042, 1.195), text(8pt)[$Y$])
  content((4.682, -1.601), text(8pt)[$Z$])
  }),
  caption: [The same six points, with the two triangles of lines used in the proof: the cubic $F = ell_12 ell_34 ell_56$ in red and $G = ell_23 ell_45 ell_61$ in blue. They meet in nine points --- the six vertices (solid) and $X, Y, Z$ (hollow) --- and every cubic in the pencil they span passes through all nine.],
) <fig-cubics>


*Step 1: nine common zeros.* Each vertex lies on one factor of $F$ and one of $G$ --- $A_3$, for
instance, lies on $ell_34$ and on $ell_23$ --- so all six vertices are zeros of both. So are the
three points of the theorem: $X$ lies on $ell_12$ (a factor of $F$) and on $ell_45$ (a factor of
$G$), and likewise $Y$ on $ell_56, ell_23$ and $Z$ on $ell_34, ell_61$. Hence every member of the
pencil
$ C_(lambda, mu) = lambda F + mu G $
vanishes at these nine points.

*Step 2: $F$ and $G$ are not proportional.* No factor of $F$ equals a factor of $G$: an equality
such as $ell_12 = ell_23$ would put $A_1, A_2, A_3$ on a line, and $ell_12 = ell_45$ would put
four of the vertices on one, both impossible by Fact 2. As $k[x,y,z]$ is a unique factorization
domain, $F$ and $G$ are coprime; in particular $lambda F + mu G eq.not 0$ whenever
$(lambda, mu) eq.not (0,0)$.

*Step 3: pin down a member of the pencil.* Suppose first that $Q(k)$ has a seventh point $P$,
distinct from $A_1, ..., A_6$. The condition $lambda F(P) + mu G(P) = 0$ is one linear condition on
$(lambda : mu)$, so it has a solution $(lambda : mu) eq.not (0,0)$; let $C = C_(lambda, mu)$, a
nonzero cubic by Step 2. Then $C$ vanishes at $A_1, ..., A_6$ and at $P$: seven distinct points of
$Q$. By Lemma 3, $C = q thin ell$ for some linear form $ell$, necessarily nonzero.

*Step 4: conclude.* By Step 1, $C(X) = C(Y) = C(Z) = 0$, that is, $q(X) ell(X) = 0$ and likewise
for $Y, Z$. But none of $X, Y, Z$ lies on $Q$ (@sec-conventions), so $q$ does not vanish at any of
them, and therefore $ell(X) = ell(Y) = ell(Z) = 0$. The three points lie on the line
$V(ell)$. $qed$

#v(1mm)
*The seventh point.* Step 3 needs $Q(k)$ to have at least seven points. A smooth conic with a
rational point has exactly $\#k + 1$ of them, so this can fail only for $k = FF_2, FF_3, FF_4,
FF_5$. That is not a real restriction: collinearity of $X, Y, Z$ is the vanishing of a determinant
in the coordinates of the $A_i$, and a determinant that vanishes over an extension field vanishes
over $k$. So one proves the statement over $overline(k)$, or over any large enough extension, and
reads it back.

*What the proof is an instance of.* Steps 1--4 are the classical Cayley--Bacharach argument: two
cubics meeting in nine points, and any cubic through eight of them passes through the ninth. Here
the ninth point is delivered by a *reducible* cubic, the conic plus the Pascal line, and Pascal's
theorem is what that degeneracy says.

= A synthetic proof, after Steiner <sec-steiner>

The proof just given computes with forms. Steiner's projective geometry proves the theorem with no
coordinates at all, from two facts about projectivities, and it sees the Pascal line differently:
not as the leftover component of a degenerate cubic, but as the *axis of a perspectivity*. The
conic enters only through the correspondence it sets up between two pencils of lines.

#block(inset: (left: 6pt))[
  *(S1) (Steiner, Chasles).* Let $P$ be a point of a conic $Q$. As $T$ runs over $Q$, the line
  $P T$ runs over the pencil of lines at $P$, and this identification is *projective*: the
  cross-ratio of four lines $P T_1, ..., P T_4$ does not depend on which $P in Q$ is used. Hence
  for $P, P' in Q$ the correspondence $P T mapsto P' T$ is a projectivity between the two pencils.
]

#block(inset: (left: 6pt))[
  *(S2).* A projectivity between two distinct lines which fixes their point of intersection is a
  *perspectivity*: the joins of corresponding points all pass through one point.
]

#v(1mm)
(S1) is Steiner's own *definition* of a conic, read backwards --- for him a conic is what two
projectively related pencils generate, and the substance is his theorem that these loci are
exactly the conics. A reader who prefers the algebraic definition gets (S1) in one line from the
chord formula of @sec-identity: the lines of the pencil at $nu(u)$ are
$ "chord"(u, t) = [1 : -u : 0] + t dot [0 : -1 : u] , $
an affine-linear --- hence projective --- parametrization of the pencil by $t$, so the cross-ratio
of four of those lines *is* the cross-ratio of the four parameters, whatever $u$ is. (S2) is the
standard consequence of the fundamental theorem of projective geometry.

*The proof.* Take the hexagon $A_1 ... A_6$ on $Q$ and put
$ m = A_4 A_5 , wide p = A_5 A_6 . $
These are distinct lines --- otherwise $A_4, A_5, A_6$ would be collinear, which Fact 2 forbids ---
so they meet in exactly the point $A_5$. Note also $A_1 in.not m$ and $A_3 in.not p$, for the same
reason, so cutting the pencil at $A_1$ by $m$, and the pencil at $A_3$ by $p$, are legitimate
sections.

By (S1) the pencils at $A_1$ and $A_3$ correspond projectively, $A_1 T mapsto A_3 T$. Composing
with the two sections gives a projectivity
$ sigma : m --> p , $
and following $T = A_2, A_4, A_5, A_6$ around the conic reads off four of its values:

#align(center, table(
  columns: 4, align: (center, left, left, left),
  stroke: 0.4pt + luma(170), inset: (x: 9pt, y: 3.5pt),
  table.header([$T$], [line at $A_1$, cut by $m$], [line at $A_3$, cut by $p$], [$sigma$]),
  [$A_2$], [$A_1A_2 inter m = X$], [$A_3A_2 inter p = Y$], [$X mapsto Y$],
  [$A_4$], [$A_1A_4 inter m = A_4$], [$A_3A_4 inter p = V$], [$A_4 mapsto V$],
  [$A_5$], [$A_1A_5 inter m = A_5$], [$A_3A_5 inter p = A_5$], [$A_5 mapsto A_5$],
  [$A_6$], [$A_1A_6 inter m = U$], [$A_3A_6 inter p = A_6$], [$U mapsto A_6$],
))

#v(2mm)
Here $U = A_6A_1 inter A_4A_5$ and $V = A_3A_4 inter A_5A_6$ are two auxiliary points; $X$ and $Y$
are two of the three points of the theorem, and they have appeared without being asked for.

The third row is the crux: $sigma$ *fixes* $A_5 = m inter p$. By (S2), $sigma$ is therefore a
perspectivity, so the three joins
$ X Y , wide A_4 V , wide U A_6 $
pass through a single point $O$. It remains only to recognize them. Since $V$ lies on $A_3A_4$ and
so does $A_4$, the join $A_4 V$ *is* the line $A_3A_4$; since $U$ lies on $A_6A_1$ and so does
$A_6$, the join $U A_6$ *is* the line $A_6A_1$. Hence
$ O = A_3A_4 inter A_6A_1 = Z , $
and the remaining join $X Y$ passes through $O = Z$ as well. So $X$, $Y$, $Z$ are collinear. $qed$

#v(1mm)
The two degeneracies the argument needs are harmless: $A_4 eq.not V$ and $U eq.not A_6$, since
either equality would put three points of $Q$ on a line; and if $X = Y$ the conclusion is trivial.
The companion script confirms each step of the argument as an identity in $ZZ[t_1, ..., t_6]$: that
the join $A_4V$ is the line $A_3A_4$, that $U A_6$ is $A_6A_1$, that the three joins are
concurrent, and that their common point is $Z$.

#figure(
  cetz.canvas(length: 1cm, {
  import cetz.draw: *
  circle((0,0), radius: (3.4, 2.2), stroke: 0.9pt + luma(110))
  line((3.131, -1.502), (-3.298, 1.344), stroke: 1.0pt + black)
  line((-3.337, 1.150), (4.550, 1.371), stroke: 1.0pt + black)
  line((-2.414, -1.833), (-1.239, 2.271), stroke: 0.75pt + rgb("#cd6155"))
  line((-2.594, -1.607), (2.970, -1.307), stroke: 0.75pt + rgb("#cd6155"))
  line((-2.297, -1.838), (-2.935, 1.408), stroke: 0.75pt + rgb("#cd6155"))
  line((3.630, -0.099), (-1.537, 2.130), stroke: 0.75pt + rgb("#5499c7"))
  line((3.646, -0.045), (-3.133, 1.208), stroke: 0.75pt + rgb("#5499c7"))
  line((3.514, -0.222), (2.606, 1.542), stroke: 0.75pt + rgb("#5499c7"))
  line((2.537, -1.676), (4.836, 2.787), stroke: 1.4pt + rgb("#1e8449"))
  line((-2.692, -1.793), (4.999, 2.631), stroke: 1.4pt + rgb("#1e8449"))
  line((-2.235, 0.490), (5.182, 2.581), stroke: 1.4pt + rgb("#1e8449"))
  circle((-2.345, -1.593), radius: 0.075, fill: black, stroke: none)
  circle((-1.308, 2.031), radius: 0.075, fill: black, stroke: none)
  circle((3.400, 0.000), radius: 0.075, fill: black, stroke: none)
  circle((2.720, -1.320), radius: 0.075, fill: black, stroke: none)
  circle((-2.887, 1.162), radius: 0.075, fill: black, stroke: none)
  circle((2.720, 1.320), radius: 0.075, fill: black, stroke: none)
  circle((-1.706, 0.639), radius: 0.095, fill: white, stroke: 1.0pt + black)
  circle((0.486, 1.257), radius: 0.095, fill: white, stroke: 1.0pt + black)
  circle((0.126, -0.172), radius: 0.095, fill: white, stroke: 1.0pt + black)
  circle((4.100, 1.359), radius: 0.095, fill: white, stroke: 1.0pt + black)
  circle((4.653, 2.432), radius: 0.095, fill: white, stroke: 1.0pt + black)
  content((-2.345, -2.414), text(9pt)[$A_1$])
  content((-1.622, 2.789), text(9pt)[$A_2$])
  content((4.205, 0.160), text(9pt)[$A_3$])
  content((3.034, -2.079), text(9pt)[$A_4$])
  content((-3.201, 1.921), text(9pt)[$A_5$])
  content((2.626, 0.846), text(9pt)[$A_6$])
  content((-1.392, -0.119), text(9pt)[$X$])
  content((0.486, 1.740), text(9pt)[$Y$])
  content((4.196, 3.114), text(9pt)[$Z$])
  content((0.126, -0.824), text(9pt)[$U$])
  content((4.783, 0.903), text(9pt)[$V$])
  }),
  caption: [The synthetic proof. The pencil at $A_1$ (red) is cut by $m = A_4A_5$, the pencil at $A_3$ (blue) by $p = A_5A_6$; both are drawn in black. The resulting projectivity $m -> p$ sends $X mapsto Y$, $A_4 mapsto V$, $U mapsto A_6$ and *fixes* $A_5 = m inter p$, so it is a perspectivity: the three joins (green) are concurrent. Two of them are the chords $A_3A_4$ and $A_6A_1$, whose intersection is $Z$ --- so the third join, $X Y$, passes through $Z$.],
) <fig-steiner>


*What the two proofs see.* @sec-proof produces the Pascal line as the residual component of a
cubic that was forced to contain the conic; @sec-steiner produces it as the axis of a
perspectivity between two ranges cut out on a pair of chords. Neither is a translation of the
other: the first is a statement about linear systems of curves, the second about the projective
self-correspondences of a conic, and only the second survives into synthetic axiomatics, where
there are no polynomials to factor.

= The identity behind the theorem, and all of its degenerations <sec-identity>

The proof above assumes the six points distinct. There is a second proof which does not, and
which explains why the many classical "degenerate Pascal" statements are not separate theorems.

Take $q = x z - y^2$ and parametrize as in Lemma 3, $t mapsto (t^2 : t : 1)$. A direct computation
gives the chord through the points with parameters $a$ and $b$:
$ "chord" (a, b) = [1 : -(a+b) : a b] , wide #[i.e.] wide x - (a+b) y + a b z = 0 . $
The point of this formula is what happens when the two parameters collide:
$ "chord" (a,a) = [1 : -2a : a^2] = #[the *tangent* to] Q #[at] (a^2 : a : 1) . $
Writing $s_i = "chord"(t_i, t_(i+1))$ for the six sides and forming
$X = s_1 inter s_4$, $Y = s_2 inter s_5$, $Z = s_3 inter s_6$ by cross products, one obtains three
points with coordinates in $ZZ[t_1, ..., t_6]$, for instance
$ X = ( (t_4 + t_5) t_2 t_1 - t_4 t_5 (t_1 + t_2) thin : thin t_1 t_2 - t_4 t_5 thin : thin
       t_1 + t_2 - t_4 - t_5 ) , $
and the companion script verifies, by expansion in $ZZ[t_1, ..., t_6]$, that
$ det mat(X; Y; Z) = 0 #[identically.] $
That is Pascal's theorem again --- and rather more, because *no hypothesis of distinctness went
into it*. Letting parameters collide is now legitimate, and each collision replaces a side by a
tangent:

#align(center, table(
  columns: 3, align: (left, left, left),
  stroke: 0.4pt + luma(170), inset: (x: 8pt, y: 3.5pt),
  table.header([specialization], [the hexagon becomes], [the statement]),
  [$t_6 = t_1$], [a pentagon, side $A_6 A_1$ a tangent],
    [$A_1A_2 inter A_4A_5$, $A_2A_3 inter A_5A_1$, $A_3A_4 inter$ tangent at $A_1$],
  [$t_6 = t_1, thin t_3 = t_2$], [a quadrilateral, two tangents],
    [$A_1A_2 inter A_4A_5$, #h(2pt) (tangent at $A_2$) $inter A_5A_1$, #h(2pt) $A_2A_4 inter$ tangent at $A_1$],
  [$t_6 = t_1, t_3 = t_2, t_5 = t_4$], [a triangle, three tangents],
    [each side meets the tangent at the opposite vertex in three collinear points: the
     triangle and its tangent triangle are in perspective],
))

#v(2mm)
All of these are the *same* identity evaluated at a point of $ZZ^6$, which is why they need no
separate limiting argument. @fig-pentagon shows the first.

#figure(
  cetz.canvas(length: 1cm, {
  import cetz.draw: *
  circle((0,0), radius: (3.4, 2.2), stroke: 0.9pt + black)
  line((-4.700, 2.373), (4.972, -0.965), stroke: 1.7pt + luma(115))
  line((2.292, -1.923), (-4.196, 2.275), stroke: 0.9pt + rgb("#c0392b"))
  line((1.252, 2.112), (-4.244, 2.112), stroke: 0.9pt + rgb("#c0392b"))
  line((-3.013, 1.383), (3.693, -0.063), stroke: 0.9pt + rgb("#2471a3"))
  line((-1.135, 2.349), (2.223, -1.997), stroke: 0.9pt + rgb("#2471a3"))
  line((4.443, -0.900), (0.725, 2.308), stroke: 0.9pt + rgb("#1e8449"))
  line((1.635, -1.956), (4.621, -0.508), stroke: 0.9pt + rgb("#1e8449"))
  circle((2.040, -1.760), radius: 0.075, fill: black, stroke: none)
  circle((-2.720, 1.320), radius: 0.075, fill: black, stroke: none)
  circle((3.400, 0.000), radius: 0.075, fill: black, stroke: none)
  circle((0.952, 2.112), radius: 0.075, fill: black, stroke: none)
  circle((-0.952, 2.112), radius: 0.075, fill: black, stroke: none)
  circle((-3.944, 2.112), radius: 0.095, fill: white, stroke: 1.0pt + black)
  circle((0.136, 0.704), radius: 0.095, fill: white, stroke: 1.0pt + black)
  circle((4.216, -0.704), radius: 0.095, fill: white, stroke: 1.0pt + black)
  content((1.915, -2.227), text(9pt)[$A_1$])
  content((-2.720, 0.837), text(9pt)[$A_2$])
  content((3.742, 0.342), text(9pt)[$A_3$])
  content((1.077, 2.579), text(9pt)[$A_4$])
  content((-1.077, 1.645), text(9pt)[$A_5$])
  content((-3.819, 2.579), text(9pt)[$X$])
  content((-0.106, 0.286), text(9pt)[$Y$])
  content((4.216, -1.187), text(9pt)[$Z$])
  content((3.78, -1.92), text(8pt, fill: rgb("#1e8449"))[tangent at $A_1$])
  }),
  caption: [The pentagon degeneration, $t_6 = t_1$: the side $A_6A_1$ has become the tangent to the conic at $A_1$ (green, meeting $A_3A_4$ at $Z$). The three points are still collinear, and this is one evaluation of the identity of @sec-identity, not a separate theorem.],
) <fig-pentagon>


= When the conic breaks: Pappus <sec-pappus>

A conic need not be smooth: $q$ may factor, and then $Q$ is a pair of lines. Take the six points
alternately on the two lines --- $A_1, A_3, A_5$ on one and $A_2, A_4, A_6$ on the other --- and
Pascal's statement becomes Pappus' theorem, older than Pascal's by thirteen centuries.

#figure(
  cetz.canvas(length: 1cm, {
  import cetz.draw: *
  line((-4.899, 1.005), (1.899, 1.345), stroke: 1.1pt + black)
  line((-4.873, -0.032), (4.873, -2.468), stroke: 1.1pt + black)
  line((-4.520, -2.725), (0.484, 3.134), stroke: 1.7pt + luma(115))
  line((-4.000, 1.350), (-4.000, -2.417), stroke: 0.85pt + rgb("#c0392b"))
  line((-4.246, -0.422), (0.210, 2.697), stroke: 0.85pt + rgb("#2471a3"))
  line((-2.000, 1.450), (-2.000, -1.050), stroke: 0.85pt + rgb("#1e8449"))
  line((-4.248, -2.286), (1.248, 1.469), stroke: 0.85pt + rgb("#c0392b"))
  line((-0.229, 2.754), (4.194, -2.479), stroke: 0.85pt + rgb("#2471a3"))
  line((4.277, -2.364), (-4.277, 1.164), stroke: 0.85pt + rgb("#1e8449"))
  circle((-4.000, 1.050), radius: 0.075, fill: black, stroke: none)
  circle((-4.000, -0.250), radius: 0.075, fill: black, stroke: none)
  circle((-2.000, 1.150), radius: 0.075, fill: black, stroke: none)
  circle((-2.000, -0.750), radius: 0.075, fill: black, stroke: none)
  circle((1.000, 1.300), radius: 0.075, fill: black, stroke: none)
  circle((4.000, -2.250), radius: 0.075, fill: black, stroke: none)
  circle((-4.000, -2.117), radius: 0.095, fill: white, stroke: 1.0pt + black)
  circle((-0.035, 2.525), radius: 0.095, fill: white, stroke: 1.0pt + black)
  circle((-2.000, 0.225), radius: 0.095, fill: white, stroke: 1.0pt + black)
  content((-3.658, 1.392), text(9pt)[$A_1$])
  content((-4.342, 0.092), text(9pt)[$A_2$])
  content((-2.342, 1.492), text(9pt)[$A_3$])
  content((-1.758, -1.168), text(9pt)[$A_4$])
  content((1.125, 1.767), text(9pt)[$A_5$])
  content((4.242, -1.832), text(9pt)[$A_6$])
  content((-4.418, -1.875), text(9pt)[$X$])
  content((-0.035, 3.008), text(9pt)[$Y$])
  content((-1.533, 0.350), text(9pt)[$Z$])
  }),
  caption: [Pascal for a *degenerate* conic --- a pair of lines --- is Pappus' theorem: $A_1, A_3, A_5$ on one line and $A_2, A_4, A_6$ on the other, with the three points of opposite sides again collinear.],
) <fig-pappus>


The proof of @sec-proof does *not* cover this case: Lemma 3 used the irreducibility of $q$, and
indeed a line of the degenerate conic could well be a component of the cubic. But the identity of
@sec-identity does cover it, once the parametrization is changed: putting $A_1, A_3, A_5$ on
$y = 0$ and $A_2, A_4, A_6$ on $x = 0$ and expanding the same determinant in
$ZZ[a_1,a_2,a_3,b_1,b_2,b_3]$ gives $0$ identically, which the script checks. So the two theorems
are two evaluations of one piece of algebra, not an analogy.

= The converse, and how to draw a conic with a ruler <sec-converse>

#block(inset: (left: 6pt))[
  *Theorem 4 (Braikenridge--Maclaurin).* Let $A_1, ..., A_5$ be five points, no three collinear,
  let $X = A_1A_2 inter A_4A_5$, and let $ell$ be any line through $X$. Put
  $Y = ell inter A_2A_3$, $Z = ell inter A_3A_4$, and $A_6 = A_5 Y inter A_1 Z$. Then $A_6$ lies on
  the conic through $A_1, ..., A_5$.
]

#v(1mm)
*Proof.* Five points with no three collinear lie on a unique conic $Q$, and it is smooth. Let
$A'_6$ be the second point in which the line $A_5 Y$ meets $Q$ --- if that line is tangent at $A_5$, take
$A'_6 = A_5$ and use the degenerate form of the identity of @sec-identity in place of Theorem 1.
Since $A'_6 in A_5 Y$, the chord
$A_5 A'_6$ *is* the line $A_5 Y$, so $A_2A_3 inter A_5A'_6 = A_2 A_3 inter A_5 Y = Y$. Apply
Theorem 1 to the hexagon $A_1 A_2 A_3 A_4 A_5 A'_6$ on $Q$: the points $X$, $Y$ and
$Z' = A_3A_4 inter A'_6A_1$ are collinear, so $Z'$ lies on the line $X Y = ell$, and also on
$A_3 A_4$; hence $Z' = ell inter A_3A_4 = Z$. Therefore $A'_6$ lies on $A_1 Z' = A_1 Z$ and on
$A_5 Y$, which meet in the single point $A_6$. So $A_6 = A'_6 in Q$. $qed$

#v(1mm)
Read as a construction rather than a theorem, this is a straightedge-only machine for the conic
through five given points: sweep $ell$ through the pencil of lines at $X$ and the resulting $A_6$
sweeps out $Q$. It is the reason Pascal's theorem was, for a century, the practical way to draw
conics.

= The hexagrammum mysticum <sec-mysticum>

Six points on a conic can be ordered into $6! slash (6 dot 2) = 60$ hexagons --- rotations and
the reflection give the same hexagon --- so they carry *sixty* Pascal lines. The classical
structure of that configuration is remarkably rich, and the script verifies the part that is a
finite computation. With six rational points on $x z = y^2$ it finds:

#align(center, table(
  columns: 2, align: (left, right),
  stroke: 0.4pt + luma(170), inset: (x: 8pt, y: 3.5pt),
  table.header([], [count]),
  [hexagons, and distinct Pascal lines], [$60$],
  [hexagons whose three points fail to be collinear], [$0$],
  [crossings lying on exactly two Pascal lines], [$1260$],
  [points lying on exactly three Pascal lines], [$80$],
  [points lying on exactly four Pascal lines], [$45$],
))

#v(2mm)
The three counts are consistent, $1260 + 3 dot 80 + 6 dot 45 = 1770 = binom(60, 2)$, so they
account for every pair of Pascal lines. The $80$ triple points are classically the $20$ Steiner
and $60$ Kirkman points. The $45$ quadruple points are identified by the script: they are exactly
the *diagonal points* of the six-point configuration, the intersections of pairs of disjoint
chords, of which there are $binom(6,4) dot 3 = 45$.

= What the companion script checks <sec-gp>

`pascal.gp`, output in `results/pascal.txt`. Everything is exact --- the figures too, whose points
are rational points of the ellipse $x^2 slash a^2 + y^2 slash b^2 = 1$, $a = 17 slash 5$,
$b = 11 slash 5$, obtained from the rational parametrization
$s mapsto (a(1-s^2) slash (1+s^2), thin 2 b s slash (1+s^2))$. The collinearity determinants of the
drawn configurations are therefore $0$ on the nose, not merely small.

#v(1mm)
- *(1)* The identity $det[X; Y; Z] = 0$ in $ZZ[t_1, ..., t_6]$ (@sec-identity), with the three
  points printed.
- *(2)* Its specializations: pentagon, quadrilateral, triangle, and the totally degenerate case.
- *(3)* Pappus, symbolically in $ZZ[a_1, a_2, a_3, b_1, b_2, b_3]$ (@sec-pappus).
- *(4)* The exact coordinates of the four figures, with collinearity determinant $0$, and the
  collinearity of the two triples in the Pappus figure.
- *(5)* Every step of the synthetic proof of @sec-steiner as an identity in $ZZ[t_1, ..., t_6]$:
  the parametrization of the pencil behind (S1), the identification of the joins $A_4V$ and
  $U A_6$ with the chords $A_3A_4$ and $A_6A_1$, their concurrency, and that the centre is $Z$ ---
  together with the exact coordinates of @fig-steiner.
- *(6)* The hexagrammum mysticum counts of @sec-mysticum, including the identification of the
  $45$ quadruple points with the diagonal points.

= References <sec-refs>

#block(inset: (left: 4pt))[
#set enum(numbering: "[1]")
+ J. Steiner, *Systematische Entwickelung der Abhängigkeit geometrischer Gestalten von
  einander*, Berlin 1832 --- conics defined by projectively related pencils, which is (S1) of
  @sec-steiner taken as a definition.
+ H. S. M. Coxeter, *Projective Geometry*, 2nd ed., Springer 1987. Chapter 3 for projectivities
  and perspectivities, including (S2); Chapters 6 and 8 for conics, Steiner's theorem, Pascal and
  Braikenridge--Maclaurin.
+ J. Harris, *Algebraic Geometry: A First Course*, GTM 133, Lecture 18 for the pencil-of-cubics
  argument and the Cayley--Bacharach theorem in the form used in @sec-proof.
+ D. Eisenbud, M. Green, J. Harris, *Cayley--Bacharach theorems and conjectures*, Bull. Amer.
  Math. Soc. *33* (1996), 295--324. The general statement behind @sec-proof, and its history.
+ W. Fulton, *Algebraic Curves*, chapter 5, for Bézout and the divisibility argument of Lemma 3
  in its usual form.
+ J. H. Conway, A. Ryba, *The Pascal mysticum demystified*, Math. Intelligencer *34* (2012),
  no. 3, 4--8, for the structure counted in @sec-mysticum.
+ Companion notes in this repository: `pencil-conic-count.typ` for another pencil-of-conics count.
]
