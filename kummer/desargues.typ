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
  #text(size: 16pt, weight: "bold")[Desargues' theorem]
  #v(2mm)
  #text(size: 10pt)[Two triangles in perspective; a proof that is one vector identity,
  a proof that is one sentence about two planes in space, the configuration of ten points
  that contains ten copies of the theorem, and the plane where it is false]
  #v(1mm)
  #text(size: 9pt, style: "italic")[figures and checks in `desargues.gp`,
  output in `results/desargues.txt`]
]

#v(4mm)

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *The theorem.* If the three lines $A A'$, $B B'$, $C C'$ meet in a point $O$, then the
  three points
  $ X = A B inter A' B', wide Y = B C inter B' C', wide Z = C A inter C' A' $
  are collinear.

  *The proof, in three sentences.* Pick representative vectors $o, a, b, c$; since $A'$ lies
  on the line $O A$ we may rescale so that $a' = a - o$, and likewise $b' = b - o$ and
  $c' = c - o$. Then $a' - b' = a - b$, so the single vector $a - b$ represents a point of
  $A B$ and a point of $A' B'$ at once --- it *is* $X$; and $Y = [b - c]$, $Z = [c - a]$.
  Finally
  $ (a - b) + (b - c) + (c - a) = 0, $
  a linear dependence among the three, which is exactly what collinearity means.

  That is the whole argument (@sec-vector), and it never multiplies two scalars in the wrong
  order --- so it survives over a noncommutative division ring, where Pappus' theorem does
  not (@sec-coords).

  Three further readings follow. @sec-space proves it *without coordinates*, from the fact
  that two planes of $PP^3$ meet in a line; the plane case reduces to the spatial one, and
  the reduction is the reason the theorem can fail in a plane that lies in no space
  (@sec-moulton). @sec-converse gets the converse for free by relabelling the same picture.
  @sec-config exhibits the ten points and ten lines as the pairs and triples from a set of
  five, which explains at once the $S_5$ symmetry, the self-duality, and why there are ten
  theorems in the figure and not one.
]

= The statement <sec-statement>

Throughout, $PP^2 = PP^2 (k)$ is the projective plane over a field $k$ --- until @sec-coords,
where $k$ is allowed to be a division ring, and @sec-moulton, where the plane is not of this
form at all. A *triangle* is an ordered triple of points, no two equal and not collinear; its
*sides* are the three lines joining them in pairs.

#block(inset: (left: 6pt))[
  *Definition.* Two triangles $A B C$ and $A' B' C'$ are *perspective from a point* $O$ if the
  three lines $A A'$, $B B'$, $C C'$ are distinct and all pass through $O$. They are
  *perspective from a line* $ell$ if the three points
  $ X = A B inter A' B', wide Y = B C inter B' C', wide Z = C A inter C' A' $
  are defined --- that is, corresponding sides are distinct lines --- and all lie on $ell$.
]

#v(1mm)
#block(inset: (left: 6pt))[
  *Theorem 1 (Desargues).* Two triangles perspective from a point are perspective from a
  line. Conversely, two triangles perspective from a line are perspective from a point.
]

@fig-desargues is the picture. Note that the two halves of Theorem 1 are not two theorems: in
@sec-converse the converse is deduced from the forward statement by reading the *same figure*
with different letters, and in @sec-config the reason that is possible turns out to be that
the configuration is self-dual.

#figure(
  cetz.canvas(length: 1.02cm, {
  import cetz.draw: *
line((-3.095,1.604), (0.105,-3.061), stroke: 0.7pt + luma(168))
  line((-3.143,1.550), (3.008,-1.700), stroke: 0.7pt + luma(168))
  line((-3.159,1.461), (1.686,2.088), stroke: 0.7pt + luma(168))
  line((-3.832,-4.291), (2.931,-1.350), stroke: 0.9pt + rgb("#c0392b"))
  line((-3.511,-4.151), (0.315,0.107), stroke: (paint: rgb("#c0392b"), thickness: 1.0pt, dash: "dashed"))
  line((3.905,-4.817), (1.113,2.356), stroke: 0.9pt + rgb("#2471a3"))
  line((3.778,-4.491), (-1.707,1.944), stroke: (paint: rgb("#2471a3"), thickness: 1.0pt, dash: "dashed"))
  line((-0.719,-4.622), (1.339,2.366), stroke: 0.9pt + rgb("#1e8449"))
  line((-0.620,-4.286), (-1.530,2.024), stroke: (paint: rgb("#1e8449"), thickness: 1.0pt, dash: "dashed"))
  line((-4.061,-4.126), (4.328,-4.517), stroke: 1.7pt + luma(115))
  circle((-3.010,1.480), radius: 0.075, fill: black, stroke: none)
  circle((-0.150,-2.690), radius: 0.075, fill: black, stroke: none)
  circle((2.610,-1.490), radius: 0.075, fill: black, stroke: none)
  circle((1.240,2.030), radius: 0.075, fill: black, stroke: none)
  circle((-1.037,-1.397), radius: 0.075, fill: black, stroke: none)
  circle((0.081,-0.153), radius: 0.075, fill: black, stroke: none)
  circle((-1.480,1.678), radius: 0.075, fill: black, stroke: none)
  circle((-3.511,-4.151), radius: 0.095, fill: white, stroke: 1.0pt + black)
  circle((3.778,-4.491), radius: 0.095, fill: white, stroke: 1.0pt + black)
  circle((-0.620,-4.286), radius: 0.095, fill: white, stroke: 1.0pt + black)
  content((-3.350,1.580), text(9pt)[$O$])
  content((0.130,-2.950), text(9pt)[$A$])
  content((2.910,-1.350), text(9pt)[$B$])
  content((1.400,2.330), text(9pt)[$C$])
  content((-1.437,-1.457), text(9pt)[$A'$])
  content((0.381,0.047), text(9pt)[$B'$])
  content((-1.900,1.938), text(9pt)[$C'$])
  content((-3.811,-3.891), text(9pt)[$X$])
  content((4.078,-4.271), text(9pt)[$Y$])
  content((-0.340,-4.566), text(9pt)[$Z$])
  }),
  placement: auto,
  caption: [Two triangles perspective from $O$: $A B C$ solid, $A' B' C'$ dashed, with corresponding sides sharing a colour. Each coloured pair meets in one of $X$, $Y$, $Z$, and the three lie on the grey axis. The three light rays are $O A A'$, $O B B'$, $O C C'$. The configuration is exact: $O, A, B, C$ have two-digit rational coordinates, $A' = O + 69/100 (A - O)$ and likewise $B'$, $C'$ with ratios $55/100$ and $36/100$, and the collinearity determinant of $X, Y, Z$ is $0$.],
) <fig-desargues>


Two remarks on the hypotheses before the proofs. First, the projective setting is not
decoration. Over the affine plane, "$A B$ and $A' B'$ meet" is false when the two are
parallel, and the theorem would need a separate statement for each way that can happen; here
those cases are simply configurations in which one of $X$, $Y$, $Z$ lies on the line at
infinity, and nothing at all changes. Second, the nondegeneracy assumptions really are needed
--- but only to make the objects in the statement exist. If $A = A'$ the line $A A'$ is not
defined; if $A B = A' B'$ then $X$ is not a point but a whole line. The proof in @sec-vector
makes this precise: the underlying identity holds unconditionally, and the hypotheses are
spent entirely on making its three terms nonzero.

= The proof is one identity <sec-vector>

Points of $PP^2$ are nonzero vectors of $k^3$ up to scalar; write $[v]$ for the point
represented by $v$. Three points are collinear exactly when any three representing vectors are
linearly dependent, and a point lies on the line through $[u]$ and $[v]$ exactly when it is
represented by a combination of $u$ and $v$. That is all the machinery there is.

The proof turns on a normalisation, and the normalisation is available because a
representative vector is only defined up to scale.

#block(inset: (left: 6pt))[
  *Lemma 2.* Let $O, A, B, C$ be points with $O$ distinct from each of $A, B, C$, and let $A'$,
  $B'$, $C'$ be points with $A' in O A$, $B' in O B$, $C' in O C$, none of them equal to $O$ or
  to the corresponding unprimed point. Then representatives may be chosen so that
  $ a' = a - o, wide b' = b - o, wide c' = c - o $
  simultaneously.
]

#v(1mm)
Fix any representative $o$ of $O$. Since $A'$ lies on the line $O A$, some representative
satisfies $a' = lambda a + mu o$. Here $mu != 0$, or else $A' = A$; and $lambda != 0$, or else
$A' = O$. Divide by $-mu$: the vector $-a' \/ mu$ represents $A'$ and equals
$(-lambda\/mu) a - o$. Now $(-lambda\/mu) a$ is another representative of $A$, since
$-lambda\/mu != 0$. Renaming these two vectors $a'$ and $a$ gives $a' = a - o$. The choice of
$o$ was made once and never touched again, so the same is done independently for $B$ and $C$.
#h(1fr) $qed$

#block(inset: (left: 6pt))[
  *Proof of the forward half of Theorem 1.* Normalise as in Lemma 2. Subtracting,
  $ a' - b' = (a - o) - (b - o) = a - b. $
  The vector $a - b$ is a combination of $a$ and $b$, so $[a - b]$ lies on $A B$; it is equally
  a combination of $a'$ and $b'$, so it lies on $A' B'$. It is nonzero, because $A != B$ makes
  $a$ and $b$ independent. Since $A B$ and $A' B'$ are distinct lines they meet in exactly one
  point, and therefore
  $ X = [a - b], wide "and likewise" wide Y = [b - c], wide Z = [c - a]. $
  These three vectors sum to zero. A vanishing sum of three nonzero vectors is a nontrivial
  linear dependence, so they span a subspace of dimension at most two --- and three points
  spanning at most a plane in $k^3$ are three points on a line of $PP^2$. #h(1fr) $qed$
]

Section (1) of `desargues.gp` runs this over $ZZ[o_1, ..., c_3]$ and prints the determinant of
the three vectors as the polynomial $0$. Nothing was assumed about the six points beyond what
Lemma 2 needs; in particular no genericity, and no case distinctions. Section (2) instantiates
it at the rational configuration of @fig-desargues, where every coordinate is a fraction with
a two-digit numerator and the collinearity determinant is exactly zero.

It is worth saying what this proof does *not* use. There is no metric, no ordering, no
continuity, no characteristic assumption --- and, crucially, no commutativity: read
$a' = a lambda + o mu$ with the scalars on the right and every step above goes through
verbatim. @sec-coords takes that seriously.

= The proof is one sentence about space <sec-space>

The coordinate proof is short but it explains nothing. Here is the reason the theorem is true,
which was very likely Desargues' own: *it is a statement about two planes, flattened.*

== Two triangles in different planes <sec-space-easy>

Suppose first that $A B C$ and $A' B' C'$ do not lie in a common plane of $PP^3$. Let
$pi = chevron.l A, B, C chevron.r$ and $pi' = chevron.l A', B', C' chevron.r$; these are distinct
planes, so they meet in a line $ell$.

#block(inset: (left: 6pt))[
  *Proof.* The points $O, A, B$ are not collinear, so they span a plane $sigma$. Since $A'$
  lies on $O A$ and $B'$ on $O B$, both lie in $sigma$ too. So the lines $A B$ and $A' B'$ both
  lie in the single plane $sigma$ --- and two distinct lines in a plane meet. Their meeting
  point $X$ lies on $A B subset pi$ and on $A' B' subset pi'$, hence
  $ X in pi inter pi' = ell. $
  The same argument, with $sigma$ replaced by $chevron.l O, B, C chevron.r$ and
  $chevron.l O, C, A chevron.r$, puts $Y$ and $Z$ on $ell$. #h(1fr) $qed$
]

That is the entire proof: three applications of "two coplanar lines meet", and the conclusion
is not that three points happen to be collinear but that they have nowhere else to be.

#figure(
  cetz.canvas(length: 1.00cm, {
  import cetz.draw: *
line((-7.740,-2.340), (2.260,-2.340), (6.640,2.040), (-3.360,2.040), close: true, stroke: 0.5pt + luma(120), fill: luma(96).transparentize(88%))
  line((-3.300,0.000), (2.200,0.000), (0.040,5.040), (-5.460,5.040), close: true, stroke: 0.5pt + luma(120), fill: luma(96).transparentize(88%))
  content((-7.10,-2.10), text(10pt, fill: luma(90))[$pi$])
  content((-4.98,4.62), text(10pt, fill: luma(90))[$pi'$])
  line((-7.400,0.000), (3.797,0.000), stroke: 1.7pt + luma(115))
  line((-1.319,2.103), (4.579,1.649), stroke: 0.7pt + luma(168))
  line((-2.843,4.687), (2.049,-2.308), stroke: 0.7pt + luma(168))
  line((-0.758,2.227), (-4.329,0.224), stroke: 0.7pt + luma(168))
  line((4.397,2.016), (1.603,-2.316), stroke: 0.9pt + rgb("#c0392b"))
  line((-2.960,4.643), (3.335,-0.183), stroke: 0.9pt + rgb("#c0392b"))
  line((2.190,-2.133), (-4.350,0.573), stroke: 0.9pt + rgb("#2471a3"))
  line((-2.621,4.699), (-2.987,-0.299), stroke: 0.9pt + rgb("#2471a3"))
  line((4.575,1.741), (-6.996,-0.046), stroke: 0.9pt + rgb("#1e8449"))
  line((0.926,2.065), (-6.990,-0.078), stroke: 0.9pt + rgb("#1e8449"))
  circle((-1.020,2.080), radius: 0.075, fill: black, stroke: none)
  circle((4.180,1.680), radius: 0.075, fill: black, stroke: none)
  circle((1.820,-1.980), radius: 0.075, fill: black, stroke: none)
  circle((-3.980,0.420), radius: 0.075, fill: black, stroke: none)
  circle((0.540,1.960), radius: 0.075, fill: black, stroke: none)
  circle((-2.643,4.400), radius: 0.075, fill: black, stroke: none)
  circle((-2.889,1.032), radius: 0.075, fill: black, stroke: none)
  circle((3.097,0.000), radius: 0.095, fill: white, stroke: 1.0pt + black)
  circle((-2.965,0.000), radius: 0.095, fill: white, stroke: 1.0pt + black)
  circle((-6.700,0.000), radius: 0.095, fill: white, stroke: 1.0pt + black)
  content((-1.120,2.420), text(9pt)[$O$])
  content((4.460,1.900), text(9pt)[$A$])
  content((2.120,-2.140), text(9pt)[$B$])
  content((-4.180,0.060), text(9pt)[$C$])
  content((0.840,1.780), text(9pt)[$A'$])
  content((-2.763,4.760), text(9pt)[$B'$])
  content((-2.589,1.232), text(9pt)[$C'$])
  content((3.337,0.300), text(9pt)[$X$])
  content((-3.105,-0.400), text(9pt)[$Y$])
  content((-6.800,0.340), text(9pt)[$Z$])
  }),
  placement: auto,
  caption: [The spatial case, which needs no computation. The planes $pi$ and $pi'$ meet in the thick grey line $ell$; $A B C$ lies in $pi$ and $A' B' C'$ in $pi'$, and the light rays through $O$ make them perspective. Corresponding sides are coplanar with $O$, so each pair meets --- and each meet lies in both planes, so it has nowhere to be but $ell$. Drawn from exact rational points of $PP^3$ under the projection $(x, y, z) |-> (x + 3 y \/ 5 - 3 z \/ 5, 3 y \/ 5 + 7 z \/ 5)$, which flattens $ell$ onto the horizontal.],
) <fig-space>


== The planar case, lifted

The theorem as stated in @sec-statement is about a plane, where the argument above has no
room to run. It is recovered by manufacturing the third dimension.

#block(inset: (left: 6pt))[
  *Proposition 3.* Let $pi$ be a plane inside a projective space of dimension at least $3$.
  Then Desargues' theorem holds in $pi$.
]

#v(1mm)
Let $A B C$ and $A' B' C'$ be coplanar in $pi$, perspective from $O in pi$. Choose a point $P$
outside $pi$, and a point $Q$ on the line $O P$ with $Q != O$ and $Q != P$. Note $Q in.not pi$:
the line $O P$ meets $pi$ only at $O$.

For each vertex set
$ A^* = P A inter Q A', wide B^* = P B inter Q B', wide C^* = P C inter Q C'. $
These meets exist. Indeed $P, Q, O$ are collinear and $O, A, A'$ are collinear, and both lines
pass through $O$, so they span a plane containing all of $P, Q, A, A'$; the lines $P A$ and
$Q A'$ lie in it and therefore meet. Moreover $A^* != A$, for otherwise $A$ would lie on
$Q A'$, forcing $Q$ onto the line $A A' subset pi$, which it is not. Hence $A^*$ lies on the
line $P A$ but is not its point $A$ of $pi$, so $A^* in.not pi$; and the same for $B^*$,
$C^*$. Write $pi^*$ for the plane of the triangle $A^* B^* C^*$, so $pi^* != pi$, and put
$m = pi inter pi^*$, a line.

Now $A B C$ and $A^* B^* C^*$ are perspective from $P$, and they lie in the distinct planes
$pi$ and $pi^*$, so @sec-space-easy applies: the sides $A B$ and $A^* B^*$ meet on $m$.
Equally, $A' B' C'$ and $A^* B^* C^*$ are perspective from $Q$ and lie in the same two planes,
so $A' B'$ and $A^* B^*$ meet on $m$. But those two meeting points are both the point where
the line $A^* B^*$ crosses the line $m$ --- and $A^* B^*$ is not $m$, since it does not lie in
$pi$, so two distinct lines meet at most once and there is only one such point. They are
*the same point*. Being on $A B$ and on $A' B'$, that point is $X$. So
$X in m$, and likewise $Y, Z in m$. Three points on the line $m$. #h(1fr) $qed$

The hypothesis of Proposition 3 is doing real work, and it is exactly what @sec-moulton
removes. A projective plane given abstractly --- as a set of points and lines obeying the
incidence axioms --- need not sit inside any projective space of dimension $3$, and when it
does not, the construction above has nowhere to put $P$.

= The converse, for free <sec-converse>

The converse of Theorem 1 needs no new idea and no new computation: it is the forward theorem
applied to two other triangles of the same figure.

#block(inset: (left: 6pt))[
  *Proof of the converse.* Suppose $X$, $Y$, $Z$ are collinear, on a line $ell$. Consider the
  two triangles
  $ A A' Z wide "and" wide B B' Y. $
  The lines joining their corresponding vertices are $A B$, $A' B'$ and $Z Y = ell$ --- and all
  three pass through $X$, the first two by the definition of $X$ and the third by hypothesis.
  So these triangles are perspective from the point $X$, and the forward theorem says their
  corresponding sides meet in three collinear points. Those three points are
  $
    A A' inter B B', wide
    A' Z inter B' Y = C' A' inter B' C' = C', wide
    Z A inter Y B = C A inter B C = C,
  $
  using only that $Z$ lies on $C' A'$ and on $C A$, and that $Y$ lies on $B' C'$ and on $B C$.
  So $A A' inter B B'$ is collinear with $C$ and $C'$, which is to say it lies on the line
  $C C'$: the three lines $A A'$, $B B'$, $C C'$ pass through a common point. #h(1fr) $qed$
]

Section (3) of the script carries this out on the configuration of @fig-desargues and confirms
that the two auxiliary meets really are $C'$ and $C$ on the nose, and that
$A A' inter B B'$ comes back as $O$.

There is a second proof, which is to observe that the converse is the *plane dual* of the
forward statement --- exchange "point" and "line", "lies on" and "passes through" --- and that
the plane dual of a true theorem in $PP^2 (k)$ is true. Both proofs are really the same
observation, and @sec-config says what it is.

= Ten points, ten lines, five letters <sec-config>

Count the figure: $O$, the six vertices and $X, Y, Z$ make ten points; the three lines through
$O$, the six sides and the axis make ten lines. Each line carries exactly three of the points
and each point lies on exactly three of the lines --- a *configuration* $10_3$. It has a
description that makes every symmetry of the picture obvious.

#block(inset: (left: 6pt))[
  *Proposition 4.* Let $P_1, ..., P_5$ be five points in general position in $PP^3$ and let $H$
  be a plane through none of them. The ten lines $P_i P_j$ cut $H$ in ten points $p_(i j)$, and
  the ten planes $P_i P_j P_k$ cut $H$ in ten lines $ell_(i j k)$. Then
  $ p_(i j) in ell_(k l m) wide <==> wide {i, j} subset {k, l, m}, $
  and the resulting configuration is the Desargues configuration.
]

#v(1mm)
The equivalence is immediate --- a line lies in a plane exactly when the two points spanning it
do --- and everything else is bookkeeping with subsets of $\{1, ..., 5\}$: there are
$binom(5,2) = 10$ pairs and $binom(5,3) = 10$ triples, each triple contains three pairs and
each pair sits in three triples. Section (4) of the script builds an explicit instance, prints
the twenty objects, and checks all $100$ incidences against the subset condition.

#figure(
  cetz.canvas(length: 1.02cm, {
  import cetz.draw: *
line((-3.095,1.604), (0.105,-3.061), stroke: 0.7pt + luma(168))
  line((-3.143,1.550), (3.008,-1.700), stroke: 0.7pt + luma(168))
  line((-3.159,1.461), (1.686,2.088), stroke: 0.7pt + luma(168))
  line((-3.832,-4.291), (2.931,-1.350), stroke: 0.9pt + rgb("#c0392b"))
  line((-3.511,-4.151), (0.315,0.107), stroke: (paint: rgb("#c0392b"), thickness: 1.0pt, dash: "dashed"))
  line((3.905,-4.817), (1.113,2.356), stroke: 0.9pt + rgb("#2471a3"))
  line((3.778,-4.491), (-1.707,1.944), stroke: (paint: rgb("#2471a3"), thickness: 1.0pt, dash: "dashed"))
  line((-0.719,-4.622), (1.339,2.366), stroke: 0.9pt + rgb("#1e8449"))
  line((-0.620,-4.286), (-1.530,2.024), stroke: (paint: rgb("#1e8449"), thickness: 1.0pt, dash: "dashed"))
  line((-4.061,-4.126), (4.328,-4.517), stroke: 1.7pt + luma(115))
  circle((-3.010,1.480), radius: 0.075, fill: black, stroke: none)
  circle((-0.150,-2.690), radius: 0.075, fill: black, stroke: none)
  circle((2.610,-1.490), radius: 0.075, fill: black, stroke: none)
  circle((1.240,2.030), radius: 0.075, fill: black, stroke: none)
  circle((-1.037,-1.397), radius: 0.075, fill: black, stroke: none)
  circle((0.081,-0.153), radius: 0.075, fill: black, stroke: none)
  circle((-1.480,1.678), radius: 0.075, fill: black, stroke: none)
  circle((-3.511,-4.151), radius: 0.095, fill: white, stroke: 1.0pt + black)
  circle((3.778,-4.491), radius: 0.095, fill: white, stroke: 1.0pt + black)
  circle((-0.620,-4.286), radius: 0.095, fill: white, stroke: 1.0pt + black)
  content((-3.470,1.620), text(8.5pt, fill: rgb("#7d3c98"))[$p_(45)$])
  content((0.350,-2.950), text(8.5pt, fill: rgb("#7d3c98"))[$p_(14)$])
  content((3.050,-1.330), text(8.5pt, fill: rgb("#7d3c98"))[$p_(24)$])
  content((1.500,2.370), text(8.5pt, fill: rgb("#7d3c98"))[$p_(34)$])
  content((-1.557,-1.457), text(8.5pt, fill: rgb("#7d3c98"))[$p_(15)$])
  content((0.681,0.047), text(8.5pt, fill: rgb("#7d3c98"))[$p_(25)$])
  content((-2.020,1.958), text(8.5pt, fill: rgb("#7d3c98"))[$p_(35)$])
  content((-3.911,-3.851), text(8.5pt, fill: rgb("#7d3c98"))[$p_(12)$])
  content((4.198,-4.251), text(8.5pt, fill: rgb("#7d3c98"))[$p_(23)$])
  content((-0.220,-4.566), text(8.5pt, fill: rgb("#7d3c98"))[$p_(13)$])
  content((4.60,-4.86), text(8.5pt, fill: luma(90))[$ell_(123)$])
  content((2.05,2.36), text(8.5pt, fill: luma(120))[$ell_(345)$])
  }),
  placement: auto,
  caption: [The figure of @fig-desargues relabelled by the pairs from ${1, ..., 5}$. Three points lie on a common line exactly when their three pairs lie in a common triple, so the ten lines are indexed by the ten triples. Reading the theorem at the centre $p_(45)$ gives the axis $ell_(123)$, indexed by the complementary triple; each of the other nine points is the centre of another reading of the same theorem.],
) <fig-config>


Reading Theorem 1 out of Proposition 4 is a matter of choosing which point is the centre. Take
$O = p_(45)$. The three lines through it are $ell_(45m)$ for $m = 1, 2, 3$; those are the three
lines of the perspectivity. The axis is $ell_(123)$, indexed by the *complement* of $\{4, 5\}$.
In the labelling of @fig-config,

#align(center)[
  #table(columns: 4, stroke: none, align: (right, left, right, left),
    inset: (x: 7pt, y: 3pt),
    [$O$], [$= p_(45)$], [$A B$], [$= ell_(124)$],
    [$A, B, C$], [$= p_(14), p_(24), p_(34)$], [$A' B'$], [$= ell_(125)$],
    [$A', B', C'$], [$= p_(15), p_(25), p_(35)$], [$B C, B' C'$], [$= ell_(234), ell_(235)$],
    [$X, Y, Z$], [$= p_(12), p_(23), p_(13)$], [$C A, C' A'$], [$= ell_(134), ell_(135)$],
    [axis], [$= ell_(123)$], [$O A A', O B B', O C C'$], [$= ell_(145), ell_(245), ell_(345)$],
  )
]

and one checks the theorem's conclusion by pure counting: $A B = ell_(124)$ and
$A' B' = ell_(125)$ share the pair $\{1,2\}$, so they meet at $p_(12)$; similarly the other two
meets are $p_(23)$ and $p_(13)$; and $\{1,2\}, \{2,3\}, \{1,3\}$ all sit inside $\{1,2,3\}$,
so all three lie on $ell_(123)$. The theorem has become a remark about subsets.

Three consequences fall out at once.

*Ten theorems, one figure.* Nothing distinguished $p_(45)$. Any of the ten points may be taken
as the centre, with the complementary triple as its axis, and each choice reads the figure as
an instance of Desargues' theorem. The relabelling used in @sec-converse was the choice
$O = p_(12) = X$, whose axis $ell_(345)$ is the line $O C C'$ of the original reading --- which
is why the converse came out of the forward theorem.

*The symmetry group is $S_5$.* Any permutation of $\{1, ..., 5\}$ permutes pairs and triples
compatibly, so the configuration admits $120$ automorphisms. No drawing exhibits them --- they are
combinatorial, not metric --- and the $5$-fold ones cannot be exhibited even in principle:
the configuration has *no* realisation in the real plane with a $5$-fold rotational symmetry. A rotation of order $5$ permutes the labels as a $5$-cycle, so
after relabelling it is $i |-> i + 1$, and the two point-orbits are the adjacent pairs
$\{k, k+1\}$ and the skip pairs $\{k, k+2\}$ --- each a regular pentagon, say at radius $1$
and angles $72 k$, and at radius $r$ and angles $72 k + b$. Collinearity along the line
$\{0,1,2\}$ forces $r cos(b - 36 degree) = cos 36 degree$, and along $\{0,1,3\}$ it forces
$cos(144 degree + b) = r cos 72 degree$. Eliminating $r$,
$ cos(144 degree + b) cos(b - 36 degree) = cos 36 degree cos 72 degree = 1/4, $
and the left-hand side is $(cos(2 b + 108 degree) - 1) \/ 2$, so $cos(2 b + 108 degree)$ would
have to be $3\/2$. It cannot. What is customarily drawn with five-fold symmetry is the Levi
graph, which is a different object.

*The configuration is self-dual.* Send the point $p_(i j)$ to the line
$ell_({i, j}^c)$ and the line $ell_(k l m)$ to the point $p_({k, l, m}^c)$. Since
$\{i,j\} subset \{k,l,m\}$ if and only if $\{k,l,m\}^c subset \{i,j\}^c$, this exchanges points
with lines and reverses incidence: a duality of the configuration with itself. It carries the
centre $p_(45)$ to the axis $ell_(123)$ and back. That is the structural reason Theorem 1 has a
converse that is not a separate fact, and the script checks the incidence reversal in all $100$
cases.

One further remark, since it identifies the figure completely. Join two of the ten points when
they do *not* share a line. Since $p_(i j)$ and $p_(k l)$ share a line exactly when
$\{i,j\}$ and $\{k,l\}$ overlap, this joins the *disjoint* pairs --- and a $3$-regular graph on
ten vertices of girth $5$ is the Petersen graph. Its automorphism group is the same $S_5$. The
script verifies the degrees and the absence of triangles and quadrilaterals.

= What Desargues' theorem is worth <sec-coords>

So far the plane has been $PP^2 (k)$ and the theorem has been proved twice. The interesting
question runs the other way. Given a projective plane defined only by its incidence axioms ---

#block(inset: (left: 6pt))[
  any two distinct points lie on exactly one common line; any two distinct lines meet in
  exactly one common point; there exist four points, no three collinear
]

#v(1mm)
--- must Desargues' theorem hold? It must not, and the precise measure of the gap is one of the
cleanest theorems in the subject.

#block(inset: (left: 6pt))[
  *Theorem 5 (Hilbert).* A projective plane is isomorphic to $PP^2 (D)$ for some division ring
  $D$ if and only if Desargues' theorem holds in it. Moreover $PP^2 (D)$ satisfies Pappus'
  theorem if and only if $D$ is commutative.
]

#v(1mm)
So Desargues' theorem *is* the existence of coordinates, and Pappus' theorem is the
commutativity of those coordinates. This is why the proof in @sec-vector had to be checked for
stray commutations: the fact that it needs none is the "if" direction of the first sentence,
in miniature.

The two halves of Theorem 5 are not independent. Hessenberg proved in 1905 that Pappus implies
Desargues --- a purely synthetic argument, and one that no one would guess from the statements.
In the other direction the implication fails, and the cleanest witness is Hamilton's
quaternions.

#block(inset: (left: 6pt))[
  *In $PP^2 (HH)$, Desargues' theorem holds and Pappus' theorem fails.*
]

#v(1mm)
Section (5) of the script does both, exactly. Points of $PP^2 (HH)$ are right
$HH$-lines in $HH^3$; embedding $HH arrow.hook M_2 (CC)$ by
$ q_0 + q_1 i + q_2 j + q_3 k arrow.r.bar mat(q_0 + q_1 I, q_2 + q_3 I; -q_2 + q_3 I, q_0 - q_1 I) $
turns a point into the column span of a $6 times 2$ complex matrix and a line into the span of
a $6 times 4$ one, so that three points are collinear precisely when the $6 times 6$ matrix
they assemble has rank at most $4$. All the arithmetic is then in $QQ(I)$ and exact.

For Desargues the script takes a centre $O$ and a triangle $A B C$ with quaternionic
coordinates, forms $A' = A(1+i) + O(i+j)$ and two more like it --- genuinely noncommutative
scalars --- computes the three meets as honest intersections of $4$-dimensional column spaces,
and finds the resulting $6 times 6$ matrix has rank $4$: collinear, as @sec-vector promised.

For Pappus the simplest counterexample uses nothing but the basic quaternions. Take
$P, Q, R$ the standard frame, and on the two lines $P Q$ and $P R$ the triples
$ A_1 = P + Q, wide A_3 = P + Q i, wide A_5 = P + Q j $
$ A_2 = P + R, wide A_4 = P + R i, wide A_6 = P + R k. $
The three points $A_1 A_2 inter A_4 A_5$, $A_2 A_3 inter A_5 A_6$, $A_3 A_4 inter A_6 A_1$ are
pairwise distinct, none of them one of the $A_m$, and the matrix they assemble has rank $6$:
they are *not* collinear. Over any commutative field the same configuration would be forced
onto a line. Only the failure of $i j = j i$ stands between the two.

Two more facts close the circle. Wedderburn's theorem says a finite division ring is a field,
so a finite Desarguesian plane is automatically Pappian and, for finite planes, the two
conditions coincide. And Proposition 3 says that a plane sitting inside a projective space of
dimension at least $3$ is Desarguesian --- so by Theorem 5 such a plane is coordinatised by a
division ring, and any plane that is not must fail to embed in any space at all. The next
section exhibits one.

= A plane where it is false <sec-moulton>

#block(inset: (left: 6pt))[
  *The Moulton plane.* Points are those of the affine plane over $QQ$ (completed, as usual, by
  a line at infinity). Lines are the verticals $x = c$; the ordinary lines $y = m x + b$ with
  $m >= 0$; and, for $m < 0$, the *bent* line
  $ y = m x + b " for " x <= 0, wide y = (m\/2) x + b " for " x >= 0. $
]

#v(1mm)
A line of negative slope is straightened out as it crosses into $x > 0$; every other line is
left alone. The two branches agree at $x = 0$, so a bent line is a connected curve, and the
verification that this is a projective plane is a short case check on which side of the $y$-axis
the two given points lie. Section (6) of the script does that check on four thousand random
rational pairs --- every join contains the two points that made it, and every meet lies on both
lines that made it.

#figure(
  cetz.canvas(length: 1.10cm, {
  import cetz.draw: *
line((0,-3.75), (0,2.45), stroke: (paint: luma(160), thickness: 0.6pt, dash: "dashed"))
  content((0.0,2.75), text(8pt, fill: luma(110))[the bend line $x = 0$])
  line((-3.050,1.471), (0.000,1.725), (3.650,2.029), stroke: 0.7pt + luma(168))
  line((-4.750,-2.600), (-2.350,2.200), stroke: 0.7pt + luma(168))
  line((-3.050,1.696), (0.000,-0.010), (4.250,-1.198), stroke: 0.7pt + luma(168))
  line((-4.350,-1.249), (0.000,0.599), (3.650,2.149), stroke: 0.9pt + rgb("#c0392b"))
  line((-4.750,-2.130), (0.000,1.174), (1.250,2.043), stroke: 0.9pt + rgb("#c0392b"))
  line((-4.350,-1.100), (0.000,-1.100), (4.250,-1.100), stroke: 0.9pt + rgb("#2471a3"))
  line((-4.750,-1.939), (0.000,-1.156), (2.950,-0.670), stroke: 0.9pt + rgb("#2471a3"))
  line((3.220,2.413), (4.550,-4.458), stroke: 0.9pt + rgb("#1e8449"))
  line((0.720,2.071), (4.550,-3.699), stroke: 0.9pt + rgb("#1e8449"))
  line((-3.350,0.124), (0.000,-1.041), (5.350,-1.970), stroke: 1.7pt + luma(115))
  line((4.342,-3.386), (4.342,-1.795), stroke: (paint: rgb("#c0392b"), thickness: 0.8pt, dash: "dotted"))
  content((5.202,-2.591), text(8pt, fill: rgb("#c0392b"))[gap $1.59$])
  circle((-2.700,1.500), radius: 0.075, fill: black, stroke: none)
  circle((3.300,2.000), radius: 0.075, fill: black, stroke: none)
  circle((-4.000,-1.100), radius: 0.075, fill: black, stroke: none)
  circle((3.900,-1.100), radius: 0.075, fill: black, stroke: none)
  circle((0.900,1.800), radius: 0.075, fill: black, stroke: none)
  circle((-4.390,-1.880), radius: 0.075, fill: black, stroke: none)
  circle((2.580,-0.731), radius: 0.075, fill: black, stroke: none)
  circle((-2.123,-0.303), radius: 0.095, fill: white, stroke: 1.0pt + black)
  circle((0.341,-1.100), radius: 0.095, fill: white, stroke: 1.0pt + black)
  circle((4.342,-3.386), radius: 0.095, fill: white, stroke: 1.0pt + black)
  content((-3.000,1.740), text(9pt)[$O$])
  content((3.500,2.260), text(9pt)[$A$])
  content((-4.280,-0.880), text(9pt)[$B$])
  content((4.000,-0.800), text(9pt)[$C$])
  content((0.780,2.120), text(9pt)[$A'$])
  content((-4.530,-2.220), text(9pt)[$B'$])
  content((2.880,-0.531), text(9pt)[$C'$])
  content((-2.423,-0.063), text(9pt)[$X$])
  content((0.201,-0.780), text(9pt)[$Y$])
  content((4.622,-3.526), text(9pt)[$Z$])
  }),
  placement: auto,
  caption: [Desargues' theorem failing in the Moulton plane, exactly. Lines of negative slope are straightened as they cross the dashed bend line $x = 0$; every other line is ordinary. $A A'$, $B B'$, $C C'$ are Moulton lines through $O$, so the hypothesis holds, and $X$, $Y$, $Z$ are the Moulton meets of corresponding sides. The thick grey curve is the Moulton line through $X$ and $Y$ --- itself bent --- and it misses $Z$ by $1.59$. Only two lines in the picture use their bend: the join $O C$ and the axis itself.],
) <fig-moulton>


Now run the construction of Theorem 1 inside this plane. The script takes
$ O = (-27\/10, 3\/2), wide A = (33\/10, 2), wide B = (-4, -11\/10), wide C = (39\/10, -11\/10), $
puts $A'$, $B'$, $C'$ on the Moulton lines $O A$, $O B$, $O C$, and forms the three meets of
corresponding sides. Every number is rational and every step exact. The hypothesis of the
theorem holds by construction: $A A'$, $B B'$, $C C'$ are Moulton lines through $O$. The
conclusion does not. The three points come out as
$ X = (-743/350, -53/175), wide Y = (2339/6850, -11/10), wide Z = (15329/3530, -3586/1059), $
and the Moulton line through $X$ and $Y$ --- which is itself bent, with left slope
$-76446\/219955$ --- passes the abscissa of $Z$ at height $-6969667067\/3882205750$, while $Z$
sits at $-3586\/1059$. It misses by $18528930299\/11646617250$, about $1.59$; that is the gap
drawn in @fig-moulton.

Of the ten lines in the figure exactly two use their bend between the points they join: the
join $O C$, and the axis $X Y$ itself. Everything else in the picture is straight. As a
control, the script reruns the identical recipe --- same $O, A, B, C$, same three ratios along
the joins --- with ordinary straight lines. Only $C'$ moves, since $O C$ was the one join that
bent, and the three meets become collinear again, determinant exactly zero.

So Desargues' theorem is not a consequence of the incidence axioms. By Theorem 5 the Moulton
plane is not $PP^2 (D)$ for any division ring, and by Proposition 3 it does not embed as a
plane in any projective space of dimension $3$ or more --- there is simply no room above it in
which to build the auxiliary triangle $A^* B^* C^*$.

Three remarks to place the example.

- *Smallness does not help.* Moulton's plane is infinite, but finite non-Desarguesian planes
  exist too. The smallest have order $9$: there are four projective planes of order $9$, of
  which three are non-Desarguesian. Every projective plane of order $8$ or less is
  Desarguesian.

- *There is a weaker axiom in between.* Requiring Desargues' theorem only when the centre $O$
  lies on the axis --- "little Desargues" --- characterises the *Moufang* planes, which are
  exactly those coordinatised by an alternative division ring. The projective plane over the
  octonions is Moufang and not Desarguesian, so this is a strictly intermediate condition.

- *The bend is not the point.* Nothing depends on the factor $1\/2$; any construction that
  distorts the lines of negative slope on one side of an axis, monotonically enough to keep the
  incidence axioms, does the same damage. What Moulton's example shows is that the incidence
  axioms constrain a plane far less than the picture of $PP^2 (RR)$ suggests.

= Notes <sec-notes>

The theorem is Girard Desargues'; it appears in print in Abraham Bosse's #emph[Manière
universelle de M. Desargues pour pratiquer la perspective] (Paris, 1648), where it is given
with the spatial proof of @sec-space, rather than in Desargues' own #emph[Brouillon projet]
of 1639, which is about conics. That the natural proof is the three-dimensional one, and that
the plane statement is the awkward case, is visible from the start.

Hilbert's Theorem 5 is the substance of chapter V of the #emph[Grundlagen der Geometrie]
(1899), where the coordinatising division ring is built out of the configuration itself.
Moulton's plane is from #emph[A simple non-desarguesian plane geometry], Trans. AMS *3*
(1902), 192--195. Hessenberg's implication is #emph[Beweis des Desarguesschen Satzes aus dem
Pascalschen], Math. Ann. *61* (1905), 161--172; the original argument has a gap in some
degenerate configurations, repaired in the later literature. Hartshorne's #emph[Foundations of
Projective Geometry] and Coxeter's #emph[Projective Geometry] both give the coordinatisation
carefully; Veblen and Young's #emph[Projective Geometry] is the classical source for the
$n$-dimensional statement.

The identification of the configuration with the pairs and triples from a $5$-set
(@sec-config) is old and keeps being rediscovered; it is the reason the Levi graph of the
configuration is the Desargues graph, the bipartite double cover of the Petersen graph.

#v(4mm)
#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *What the script checks.* `desargues.gp`, output in `results/desargues.txt`.
  (1) the identity of @sec-vector as a polynomial identity over $ZZ$;
  (2) the rational configuration of @fig-desargues, and (2b) the spatial one of
  @fig-space, both exactly;
  (3) the converse by relabelling;
  (4) the $10_3$ configuration from five points of $PP^3$ --- all $100$ incidences, the
  self-duality by complementation, the Petersen graph, and the exact obstruction
  $1 + 2 cos 36 degree cos 72 degree = 3\/2$ to a $5$-fold symmetric drawing;
  (5) $PP^2 (HH)$, where Desargues holds and Pappus fails, by exact rank computations over
  $QQ(I)$;
  (6) the Moulton plane --- the incidence axioms on random rational input, the exact failure of
  Desargues, and the straight-line control.
]
