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
  #text(size: 16pt, weight: "bold")[Eight, not twelve]
  #v(2mm)
  #text(size: 10pt)[How many planes of a pencil cut six lines in six points on a conic ---
  an elementary count, and a dictionary to the Chern class answer]
  #v(1mm)
  #text(size: 9pt, style: "italic")[#link("https://math.stackexchange.com/questions/5130224/")[Mathematics
  Stack Exchange 5130224], a question of René Pannekoek's, answered there by Anthony Mäkelä;
  checks in `pencil-conic-count.gp`]
]

#v(4mm)

#block(fill: luma(240), inset: 9pt, radius: 3pt, width: 100%)[
  *The one-line answer.* Eight. The naive count of $12$ is what you get from a coordinate system on
  the moving plane that *degenerates at one member of the pencil*; in a chart valid on the whole
  pencil the moving point reads $(#[_linear_] : #[_constant_] : #[_linear_])$ rather than
  $(#[_linear_] : #[_linear_] : #[_linear_])$, three of the six Veronese columns drop degree, and
  the determinant has degree
  $ 2 + 0 + 2 + 1 + 2 + 1 = 8 . $
  The two counts differ by an exact factor $t^4$ (@sec-missing): the four phantom planes are the
  single plane ${y = 0}$ counted four times, where the naive chart collapses to a line. That $t^4$
  is $c_1("Sym"^2 cal(G)^or) = 4$ in the bundle answer, and the naive $12$ is $c_1(cal(F))$
  (@sec-dict). The same bookkeeping gives $2$ for the linear case the question already knew
  (@sec-controls) --- the two transversals to four general lines, which @sec-transversals proves
  four ways and identifies with a single binary quadratic form --- and $d(d+1)(d+2) slash 3$ in
  general (@sec-general). The Pascal route suggested
  in the comments reaches $8$ too, and by a shorter count --- because it is the same polynomial
  (@sec-pascal). Turned around and applied to *equations* rather than points, the same chart
  counts the five planes through a line on a smooth cubic surface (@sec-cubic): there the $q$-slot
  *gains* a degree instead of losing one, $3 + 1 + 1 = 5$, and the naive chart overcounts by the
  same $t^4$.
]

= The question, and where the twelve comes from <sec-question>

Fix lines $L, L_1, ..., L_6$ in $PP^3$, general. The planes containing $L$ form a pencil
$V_lambda$, $lambda in PP^1$, and each $V_lambda$ meets $L_i$ in a single point $P_i (lambda)$. For
how many $lambda$ do $P_1 (lambda), ..., P_6 (lambda)$ lie on a conic?

Six points of a plane lie on a conic exactly when their six Veronese vectors
$(x^2, y^2, z^2, x y, x z, y z)$ are linearly dependent, i.e. when a $6 times 6$ determinant
$Delta$ vanishes. Each $P_i$ moves linearly in $lambda$, each Veronese entry is therefore
quadratic, and the determinant --- one entry from each column --- looks like it should have degree
$6 times 2 = 12$.

The flaw is not in the determinant criterion, which is exactly right (@sec-subq). It is that
writing the matrix at all requires a *coordinate system on $V_lambda$ that varies with $lambda$*,
and the count of $12$ silently assumes one in which all three coordinates are linear in $lambda$.
No such system exists on the whole pencil.

= The chart that does not degenerate <sec-chart>

Normalise $L = {y = z = 0}$, so that the pencil is
$ V_([s : t]) = {s y + t z = 0} , wide [s : t] in PP^1 . $
A point of $V_([s:t])$ satisfies $s y = - t z$, so $(y, z) = (-t q, s q)$ for a scalar $q$. This
gives an isomorphism, valid for *every* $[s : t]$ with no exceptions:

$ phi_lambda : PP^2 --> V_lambda , wide (x : q : w) |-> (x : -t q : s q : w) . $

Now intersect with $L_i = "span"(A_i, B_i)$. Solving $s y + t z = 0$ along $L_i$ gives
$P_i (lambda) = alpha A_i + beta B_i$ with $alpha = s B_(i,y) + t B_(i,z)$ and
$beta = -(s A_(i,y) + t A_(i,z))$, and multiplying out, the middle two coordinates collapse:

#block(fill: luma(240), inset: 9pt, radius: 3pt, width: 100%)[
  $ y "-coordinate of" P_i = m_i t , wide z "-coordinate of" P_i = - m_i s , wide
    m_i = A_(i,y) B_(i,z) - A_(i,z) B_(i,y) . $

  #v(1.5mm)
  Here $m_i$ is the Plücker coordinate $p_(23)$ of $L_i$. Since $L = {y = z = 0}$ has $p_(14)$ as
  its only nonzero Plücker coordinate, the incidence relation between the two lines reduces to
  $p_(23) = 0$: so $m_i eq.not 0$ is exactly the condition $L_i inter L = nothing$.
]

Since $y = -t q$ we get $q = -m_i$, a *constant*, while the $x$- and $w$-coordinates are linear
forms in $(s,t)$. In the chart, therefore,

$ P_i (s, t) = ( ell_i (s,t) : -m_i : n_i (s,t) ) $

with $ell_i$ and $n_i$ linear forms and $m_i$ a nonzero constant.

That single degree-$0$ slot is the whole story. The six Veronese columns now have the degrees

#align(center, table(
  columns: 7, align: (left,) + (center,)*6,
  stroke: 0.4pt + luma(170), inset: (x: 12pt, y: 3.5pt),
  table.header([column], [$x^2$], [$q^2$], [$w^2$], [$x q$], [$x w$], [$q w$]),
  [degree in $(s,t)$], [$2$], [$0$], [$2$], [$1$], [$2$], [$1$],
))

#v(2mm)
and every term of the determinant takes one entry from each column, so $Delta$ is homogeneous of
degree $2 + 0 + 2 + 1 + 2 + 1 = 8$. *Eight planes.* No Chern classes, and nothing beyond the
observation that one coordinate stopped moving.

= The four missing planes, and what they are <sec-missing>

The count of $12$ comes from the chart $(x : y : w)$ --- three coordinates, each linear in
$(s,t)$. That chart is a genuine isomorphism $V_lambda tilde.equiv PP^2$ *only where $t eq.not 0$*.
At $[s : t] = [1 : 0]$ the plane is ${y = 0}$, and $(x : y : w)$ collapses onto the line
${y = 0} subset PP^2$: all six image points automatically lie on a (degenerate) conic, for a reason
that has nothing to do with the six points of $PP^3$.

The bookkeeping is exact. In that chart $P_i = (ell_i : m_i t : n_i)$, so the column $y^2$ is
divisible by $t^2$ and the columns $x y$ and $y w$ by $t$, whence

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  $ Delta_"naive" = t^4 dot Delta , wide 12 = 4 + 8 , $
  an identity of polynomials, not merely a divisibility --- verified in check 2 on forty random
  configurations. The four phantom roots are one plane with multiplicity four.
]

= Two controls <sec-controls>

*The linear case, which the question already answers.* Take three lines and ask when
$P_1, P_2, P_3$ are collinear. The rows are $(x, q, w)$ of degrees $(1, 0, 1)$, so the $3 times 3$
determinant has degree $2$ --- and $2$ is the classical number of transversals to the four general
lines $L, L_1, L_2, L_3$, proved in @sec-transversals. The naive chart would have said $3$, off by exactly $t^1$. Since the
answer here is known independently, this is a real test of the degree bookkeeping rather than a
restatement of it; check 4 confirms $Delta_"naive" = -t dot Delta$ on forty configurations.

*The eight roots, verified off-chart.* A degree count could in principle be right for the wrong
reason, so check 3 abandons the chart entirely. For a random configuration it takes each of the
eight complex roots $s_0$, computes the six points in $PP^3$ directly, extracts a basis of the
plane from $ker(0, s_0, 1, 0)$ --- chosen with no reference to $(x : q : w)$ --- and evaluates the
$6 times 6$ Veronese determinant in that basis, with rows normalised to sup-norm $1$:

#align(center, table(
  columns: 4, align: (center, right, center, right),
  stroke: 0.4pt + luma(170), inset: (x: 9pt, y: 3.5pt),
  table.header([root], [$s_0$], [root], [$abs(Delta)$ in an independent basis]),
  [$1$], [$-4.40528945$], [$5, 6$], [$5.5 times 10^(-42)$],
  [$2$], [$0.37610778$], [$7, 8$], [$1.8 times 10^(-39)$],
  [$3$], [$0.55289407$], [largest at a root], [$4.9 times 10^(-39)$],
  [$4$], [$10.30387733$], [control at $s = 7 slash 3$], [$8.3 times 10^(-5)$],
))

#v(2mm)
Four real roots and two conjugate pairs in this draw; the separation between a root and a
non-root is thirty-four orders of magnitude at $38$ digits of working precision. The eight are
real configurations, not artefacts of the coordinates that found them.

= Two transversals to four lines <sec-transversals>

@sec-controls leaned on the classical count as an independent test: four general lines in $PP^3$
are met by exactly two lines. It is worth proving, because the proofs are short, because the
hypothesis "general" is doing real work, and because the simplest proof and the most illuminating
one turn out to be the same computation written twice.

#block(fill: luma(240), inset: 9pt, radius: 3pt, width: 100%)[
  *The statement.* Let $L_1, ..., L_4 subset PP^3$ be pairwise disjoint lines over an
  algebraically closed field. Then $L_1, L_2, L_3$ lie on a unique quadric surface $Q$; it is
  smooth, and they belong to one of its two rulings. Exactly one of the following holds.

  #v(1mm)
  - $L_4 subset Q$. Then $L_4$ lies in the same ruling, and the transversals form a $PP^1$ ---
    one through each point of $L_1$.
  - $L_4 subset.not Q$. Then there are exactly *two* transversals counted with multiplicity:
    two distinct lines, or one doubled when $L_4$ is tangent to $Q$.

  #v(1.5mm)
  So "pairwise disjoint" is not enough: the first case is a genuine configuration of four
  pairwise non-intersecting lines with infinitely many transversals, and it is what the word
  *general* excludes. Over a non-closed field the two transversals may be conjugate rather than
  rational; over $RR$ the count is $2$ or $0$.
]

== The simplest proof: two eigenvectors

Write $V = k^4$ and $L_i = PP(W_i)$ with $dim W_i = 2$. Two facts of linear algebra set up the
whole problem.

#v(1mm)
- $L_1 inter L_2 = nothing$ says exactly $V = W_1 xor W_2$.
- A line disjoint from both is a *graph*. If $W inter W_1 = W inter W_2 = 0$, the projection
  $W --> W_1$ along $W_2$ is injective, hence an isomorphism; composing its inverse with the
  projection to $W_2$ gives $phi : W_1 --> W_2$, injective because $W inter W_1 = 0$, and
  $W = {w + phi(w) : w in W_1}$. Write $L_3 = "graph"(phi)$ and $L_4 = "graph"(psi)$.

#v(2mm)
*Step 1: the transversals to the first three lines.* A line meeting $L_1$ and $L_2$ meets them in
two distinct points and is their span, $PP("span"(p, q))$ with $0 eq.not p in W_1$ and
$0 eq.not q in W_2$. It meets $"graph"(phi)$ iff $a p + b q = w + phi(w)$ for some $w$ and some
$(a,b) eq.not (0,0)$; comparing $W_1$- and $W_2$-components gives $w = a p$ and $b q = a phi(p)$,
and $a = 0$ would force $b = 0$. So the condition is $q in k dot phi(p)$, and conversely
$p + phi(p) in "span"(p, phi(p))$. Hence the transversals to $L_1, L_2, L_3$ are exactly the lines

$ M_p = PP("span"(p, phi(p))) , wide [p] in PP(W_1) tilde.equiv PP^1 , $

one through each point of $L_1$: a $PP^1$ of them, and no others.

*Step 2: the fourth line.* The same computation with $psi$ in place of $phi$ says that $M_p$ meets
$L_4$ iff $psi(p) in k dot phi(p)$, that is, iff

$ p " is an eigenvector of " A := phi^(-1) psi in "End"(W_1) . $

*Step 3: a $2 times 2$ matrix has two eigenvectors.* Fix a nonzero alternating form $omega$ on
$W_1$; then $p$ is an eigenvector of $A$ iff $omega(p, A p) = 0$. In a basis where
$A = mat(a, b; c, d)$ and $p = (X, Y)$,

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  $ q_A (X, Y) = omega(p, A p) = c X^2 + (d - a) X Y - b Y^2 , wide
    "disc"(q_A) = (a - d)^2 + 4 b c = "tr"(A)^2 - 4 det(A) . $
  #v(1.5mm)
  $q_A equiv 0$ iff $A$ is a scalar matrix; otherwise a nonzero binary quadratic form has exactly
  two roots in $PP^1$, counted with multiplicity. #h(1fr) $square$
]

#v(2mm)
*The two is the degree of the characteristic polynomial* --- that is the entire content. The
argument uses no algebraic geometry, no closed field and no hypothesis on the characteristic: over
any field it identifies the transversals with the eigendirections of a $2 times 2$ matrix, so they
are defined over the splitting field of the characteristic polynomial and are conjugate over it.
Over $RR$ the sign of $"tr"^2 - 4 det$ decides between two real transversals and none; check 7f
draws a thousand integer configurations and finds $860$ of the first kind, $140$ of the second ---
a fact about that crude model rather than a theorem, but a reminder that neither case is exotic.

== The best proof: the quadric and its two rulings

The eigenvector proof is a bookkeeping device; it never says what the two lines *are*. This one
does. It needs three standard facts:

#v(1mm)
+ a smooth quadric surface is $PP^1 times PP^1$, carrying two rulings; two lines of the same
  ruling are disjoint, two lines of opposite rulings meet in one point;
+ a line meeting a quadric in three points lies on it --- the restriction of the quadratic form is
  a binary quadratic form with three roots, hence zero;
+ three pairwise disjoint lines lie on a unique quadric surface, and it is smooth.

#v(2mm)
Granting these: $L_1, L_2, L_3$ are pairwise disjoint lines on $Q$, so they lie in one ruling. A
transversal $M$ meets them in three distinct points of $Q$, so $M subset Q$ by (2), and $M$ meets
three lines of one ruling, so $M$ belongs to the other; conversely every line of the second ruling
meets all three. *The transversals to $L_1, L_2, L_3$ are precisely the second ruling of $Q$.* If
$L_4 subset.not Q$ then $L_4 inter Q$ is a subscheme of length $2$, and through each of its points
passes exactly one line of the second ruling. Two transversals, distinct unless $L_4$ is tangent. $square$

#v(2mm)
Here the number $2$ is the degree of $Q$: *a line meets a quadric surface twice*. Every
degeneration is visible in the same picture --- tangency merges the two, and a fourth line lying
on $Q$ loses the intersection altogether and returns the whole ruling.

Fact (3) is the one that is not free, and the first proof supplies it outright.

#block(inset: (left: 12pt, y: 2pt), stroke: (left: 2pt + luma(190)))[
  *The quadric, written down.* Let $omega$ be a nonzero alternating form on $W_2$ and put
  $ Q = { (u, v) in W_1 xor W_2 : omega(phi(u), v) = 0 } . $
  It is a quadratic form of rank $4$, and it vanishes on $W_1$ (where $v = 0$), on $W_2$ (where
  $u = 0$) and on $"graph"(phi)$ (where the form reads $omega(phi w, phi w) = 0$): existence, by
  exhibition. Each $M_p$ lies on it, since $omega(phi(a p), b phi(p)) = a b dot omega(phi p, phi p)
  = 0$, and every point of $Q$ lies on some $M_p$, so $Q = union.big_p M_p$. *Uniqueness:* a
  quadric containing $L_1, L_2, L_3$ meets each $M_p$ in three points, hence contains $M_p$, hence
  contains $union.big_p M_p = Q$, hence equals $Q$. Check 7b solves for the quadric by linear
  algebra from the three lines alone and confirms all of this: kernel of dimension $1$, rank $4$,
  the three lines and every $M_p$ on it, and agreement with the closed form above.
]

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *The two proofs are the same quadratic form.* Restrict $Q$ to $L_4 = {w + psi(w)}$, and use
  $psi = phi A$:
  $ Q(w + psi(w)) = omega(phi(w), psi(w)) = omega(phi(w), phi(A w)) = (phi^* omega)(w, A w) . $
  Now $phi^* omega$ is a nonzero alternating form on $W_1$, and the alternating forms on a plane
  make up a one-dimensional space, so this is a nonzero constant times $omega(w, A w) = q_A (w)$.
  So "$L_4$ meets $Q$ twice" and "$A$ has two eigendirections" are one and the same binary
  quadratic form up to scale --- and $q_A$ was only ever defined up to scale, for the same reason.
  Check 7b verifies the proportionality exactly on forty configurations.
]

== The shortest proof, if you already have the Grassmannian <sec-klein>

$G = G(1,3) subset PP^5$ is the Klein quadric $p_(12) p_(34) - p_(13) p_(24) + p_(14) p_(23) = 0$,
a smooth quadric fourfold, and "meets $L_i$" is a single *linear* condition on Plücker
coordinates. So the transversals are $G inter H_1 inter H_2 inter H_3 inter H_4$: when the four
linear forms are independent they cut out a line $Lambda subset PP^5$, and $Lambda inter G$ is two
points. Bézout --- or again, in four words, a line meets a quadric twice. The count is once more
the degree of a quadric, this time in $PP^5$.

Two remarks keep this honest.

#v(1mm)
- *The four hyperplanes are not general.* A line meets itself, so $[L_i] in H_(L_i)$; in fact
  $H_(L_i)$ is the tangent hyperplane to $G$ at $[L_i]$, and each $G inter H_i$ is a singular
  hyperplane section, a cone with vertex $[L_i]$. Bézout does not mind: what it needs is that the
  intersection be proper, i.e. finite, which is exactly the general-position hypothesis. Check 7c
  confirms on every configuration that $[L_i]$ lies both on $G$ and on its own $H_i$.
- *The degenerate case is a rank drop.* For four lines in one ruling the four linear forms have
  rank $3$, so $Lambda$ is a plane, and a plane section of $G$ is a conic --- the $PP^1$ of
  transversals, embedded by $p |-> p and phi(p)$, which is quadratic in $p$. Check 7d builds that
  configuration and finds rank exactly $3$.

#v(2mm)
In the Schubert calculus the same count is
$sigma_1^4 = (sigma_2 + sigma_(1,1))^2 = 2 sigma_(2,2)$. That packaging is the only one of the
three routes that generalises --- but for four lines it is computing what the Klein quadric has
already said.

Is this the same $2$ yet again? Yes. Check 7c takes the Plücker vector $pi(p) = p and phi(p)$ of
$M_p$, quadratic in $p$, and verifies that every $3 times 3$ minor of the $3 times 6$ matrix
with rows $k_1, k_2, pi(p)$ --- where $k_1, k_2$ span $Lambda$ --- is a constant multiple of $q_A$.
The line $Lambda$ meets the conic ${M_p}$ exactly at the roots of $q_A$: all twenty minors, forty
configurations, no exception.

== A fourth proof: specialisation <sec-special>

This is the argument Schubert would have given, and the one Kleiman and Laksov set out in a few
lines of their expository article. The picture is the best of the four. The work is in what the
picture leaves out --- and the honest question is how much machinery it takes to put back.

*The special position.* Move the four lines until $L_1$ and $L_2$ meet, at a point $P$, spanning a
plane $Pi$; and $L_3$ and $L_4$ meet, at a point $Q$, spanning a plane $Sigma$; with
$P in.not Sigma$ and $Q in.not Pi$. Then:

#block(fill: luma(240), inset: 9pt, radius: 3pt, width: 100%)[
  A line $M$ meets two incident lines iff it passes through their common point or lies in their
  common plane. (If $M$ meets $L_1$ and $L_2$ in the same point, that point is $L_1 inter L_2 = P$;
  if in two distinct points, both lie in $Pi$ and so does $M$.)
]

#v(2mm)
So there are four cases, and the two mixed ones are empty: a line through $P$ lying in $Sigma$
would put $P$ on $Sigma$, and a line in $Pi$ through $Q$ would put $Q$ on $Pi$. What is left is

#align(center, table(
  columns: 3, align: (left, center, left),
  stroke: 0.4pt + luma(170), inset: (x: 10pt, y: 4pt),
  table.header([case], [Schubert class], [the transversal]),
  [through $P$, through $Q$], [$sigma_2 dot sigma_2 = sigma_(2,2)$],
    [$overline(P Q)$: the one line through two points],
  [through $P$, inside $Sigma$], [$sigma_2 dot sigma_(1,1) = 0$], [none: $P in.not Sigma$],
  [inside $Pi$, through $Q$], [$sigma_(1,1) dot sigma_2 = 0$], [none: $Q in.not Pi$],
  [inside $Pi$, inside $Sigma$], [$sigma_(1,1) dot sigma_(1,1) = sigma_(2,2)$],
    [$Pi inter Sigma$: the one line in two planes],
))

#v(2mm)
Two transversals, and you can point at them. The table is also the computation
$sigma_1^4 = (sigma_2 + sigma_(1,1))^2 = 2 sigma_(2,2)$ of @sec-klein read off a picture: the
splitting $sigma_1^2 = sigma_2 + sigma_(1,1)$ is the dichotomy in the grey box, and the vanishing
cross terms are the two impossible cases. Degenerating one pair only is the same argument stopped
halfway --- $L_1, L_2$ incident, $L_3, L_4$ general --- and gives the two transversals
$"span"(P, L_3) inter "span"(P, L_4)$ and
$overline((Pi inter L_3) (Pi inter L_4))$, one from each class; check 8e verifies both, forty
configurations.

#v(2mm)
*What the picture does not prove.* Three things, and each of them fails for some specialisation of
this very problem:

#v(1mm)
+ that the special configuration has *finitely many* solutions at all;
+ that each special solution counts *once*;
+ that the special count *transports* back to the general configuration.

#v(2mm)
=== How much machinery this needs

Less than one fears, if the count is set up as a family of binary quadratic forms rather than as a
number to be conserved. Everything the specialisation argument needs is already in @sec-klein.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Proposition.* Let $L_1, ..., L_4$ be any four lines in $PP^3$, let $R$ be the $4 times 6$ matrix
  of their incidence conditions on Plücker coordinates, and let $Lambda = ker R$.

  #v(1mm)
  - If $"rank" R <= 3$, then $PP(Lambda)$ is a plane or larger, and $G inter PP(Lambda)$ is a conic
    or larger: infinitely many transversals.
  - If $"rank" R = 4$ and the Klein form vanishes on $Lambda$: again infinitely many.
  - If $"rank" R = 4$ and it does not: the transversals are the roots of the nonzero binary
    quadratic form $K|_Lambda$, so there are exactly *two*, counted with multiplicity.

  #v(1.5mm)
  The proof is the linear algebra of the previous paragraph together with the fact that a nonzero
  binary quadratic form has two roots. No Bézout, no degree of a Grassmannian, no conservation of
  number.
]

#v(2mm)
With that in hand the special configuration is not being used to *transport a count*. It is being
used as a *witness*: check 8a exhibits a configuration with $"rank" R = 4$, with
$K|_Lambda eq.not 0$, and with $"disc"(K|_Lambda) eq.not 0$. Both are open conditions on the
parameter space $G(1,3)^4$, which is irreducible --- rank $>= 4$ visibly so, and on the open set
where the rank is $4$ one may choose a basis of $Lambda$ by Cramer's rule, which makes the
discriminant a regular function there up to a nonvanishing square. A nonempty open subset of an
irreducible variety is dense. So one witness gives: for general $L_1, ..., L_4$ there are exactly
two transversals, and they are distinct.

#v(1mm)
Total cost: a matrix rank, a binary quadratic form, and one sentence of topology.

#v(2mm)
*The expensive version, and when it is the one you need.* If instead you insist on the
count-transport formulation --- "the number of solutions is constant in a family" --- here is what
it takes. Put

$ cal(Z) = { (M, L_1, ..., L_4) in G times G^4 : M inter L_i eq.not nothing "for all" i } . $

Each condition is one bilinear equation in Plücker coordinates, so $cal(Z)$ is cut out by four
equations in the smooth $20$-fold $G times G^4$. Projecting to the first factor exhibits $cal(Z)$
as a fibration whose fibre over $M$ is $Sigma_M^4$, with $Sigma_M = G inter H_M$ irreducible of
dimension $3$; the fibres are all isomorphic because $"PGL"_4$ acts transitively on $G$, so
$cal(Z)$ is irreducible of dimension $4 + 12 = 16 = 20 - 4$. Being cut out by exactly its
codimension many equations, $cal(Z)$ is a complete intersection, hence Cohen--Macaulay. The base
$T = G^4$ is smooth of dimension $16$, and over the open set $T^circle$ where the fibres of
$pi : cal(Z) --> T$ are finite, all fibres have dimension $dim cal(Z) - dim T = 0$; miracle
flatness then makes $pi$ flat over $T^circle$, so the *length* of the fibre is locally constant,
hence constant on the connected $T^circle$. Evaluating at the special configuration --- two
reduced points, by the transversality computation below --- gives length $2$ everywhere on
$T^circle$.

That is not deep, but it is more than this problem needs, and it is worth knowing which parts are
load-bearing: properness (so that solutions cannot escape --- automatic here, $G$ is projective),
Cohen--Macaulayness of the total space, regularity of the base, and finiteness of the fibre. Drop
the last and the conclusion is false, as the ruling configuration of @sec-degen shows. The general
principle, for arbitrary enumerative problems, is Schubert's *principle of conservation of
number*, and the demand for a rigorous foundation for it is Hilbert's fifteenth problem.

=== The step the sketches leave out: transversality

Both routes need to know that the two special solutions are *reduced* points of the intersection
$G inter H_1 inter H_2 inter H_3 inter H_4$, and that is a computation, not an observation. It is
short.

The tangent space to the Grassmannian at $[M]$ is $"Hom"(W, V slash W)$, $W$ the plane of $M$.
Deform a spanning pair, $m_j |-> m_j + t u_j$; the condition that $M$ meets $L = "span"(l_1, l_2)$
is $det(m_1, m_2, l_1, l_2) = 0$, and

$ dif / (dif t) bar.v_(t=0) det(m_1 + t u_1, m_2 + t u_2, l_1, l_2)
  = det(u_1, m_2, l_1, l_2) + det(m_1, u_2, l_1, l_2) . $

For $u_j in W$ every term repeats a column of a determinant that already vanishes, so this kills
$"Hom"(W, W)$ and descends to a linear form on $"Hom"(W, V slash W)$. Taking $m_1 = l_1 = x$ to
span $M inter L$, it reduces to $det(phi(x), m_2, l_1, l_2)$, that is, to the single condition

$ phi(x) in (W + W_L) slash W subset V slash W , $

one nontrivial linear form, since $(W + W_L) slash W$ is a line in the plane $V slash W$. Now
evaluate at the two special transversals.

#block(inset: (left: 12pt, y: 2pt), stroke: (left: 2pt + luma(190)))[
  *At $M = overline(P Q)$.* Here $W = "span"(P, Q)$ and $M$ meets $L_1, L_2$ at $P$ and
  $L_3, L_4$ at $Q$, so the four conditions are
  $phi(P) in "span"(L_1, Q) slash W$, $phi(P) in "span"(L_2, Q) slash W$, and the
  same two with $Q$ and $L_3, L_4$. The first two lines are distinct: a plane containing both $L_1$
  and $L_2$ is $Pi$, and $Q in.not Pi$. So they force $phi(P) = 0$, two independent conditions;
  symmetrically $phi(Q) = 0$. Four independent conditions on a four-dimensional space.
]

#block(inset: (left: 12pt, y: 2pt), stroke: (left: 2pt + luma(190)))[
  *At $M = Pi inter Sigma$.* Write $x_i = M inter L_i$. Since $L_1$ and $M$ both lie in $Pi$, the
  line $(W + W_(L_1)) slash W$ is $Pi slash W$, and likewise for $L_2$; for $L_3, L_4$ it is
  $Sigma slash W$. The points $x_1, x_2$ are distinct --- they would coincide only at $P$, which is
  not on $M subset Sigma$ --- so they form a basis of $W$, and the first two conditions say
  $phi(W) subset.eq Pi slash W$ while the last two say $phi(W) subset.eq Sigma slash W$. As
  $Pi eq.not Sigma$ these two lines meet in $0$, so $phi = 0$: four independent conditions again.
]

#v(2mm)
Check 8b does this in coordinates --- the $4 times 8$ matrix of the forms above in
$(phi(m_1), phi(m_2))$, verified to have rank $4$ with $"Hom"(W,W)$ in its kernel --- at both
solutions, on forty configurations, with no exception.

=== Two specialisations that lie

The hypotheses are not decoration. Both failures occur inside this same problem.

#v(1mm)
- *A double solution.* Specialise so that $L_4$ becomes tangent to the quadric through
  $L_1, L_2, L_3$. There is then exactly one transversal, and a specialisation chosen for
  convenience would report "one". The fibre still has length $2$: the tangent rank at that solution
  is $3$, not $4$. Check 8d builds this configuration --- $L_4$ inside the tangent plane to $Q$ at
  a point $R in Q$ --- and finds the Klein quadratic a perfect square, the double root the ruling
  line through $R$, and the tangent rank $3$.
- *Infinitely many.* Specialise to four lines in one ruling: $"rank" R = 3$, and the solutions are
  a conic in $PP^5$ rather than two points (check 7d). Here conservation of number simply does not
  apply, since $T^circle$ has been left.

#v(2mm)
=== Conservation, watched

Check 8c follows the binary quadratic form $K|_Lambda$ along a path $L_i (epsilon)$ from the
special configuration to a general one. Nothing degenerates and nothing jumps:

#align(center, table(
  columns: 5, align: (right, center, center, center, right),
  stroke: 0.4pt + luma(170), inset: (x: 10pt, y: 3.5pt),
  table.header([$epsilon$], [$dim Lambda$], [$deg K|_Lambda$], [$"disc" = 0$?],
    [distance to the special pair]),
  [$0$], [$2$], [$2$], [no], [--- (the special pair)],
  [$1 slash 1000$], [$2$], [$2$], [no], [$3.4 times 10^(-3)$],
  [$1 slash 100$], [$2$], [$2$], [no], [$3.5 times 10^(-2)$],
  [$1 slash 8$], [$2$], [$2$], [no], [$3.3 times 10^(-1)$],
  [$1 slash 2$], [$2$], [$2$], [no], [$1.6$],
  [$1$], [$2$], [$2$], [no], [$1.6$],
))

#v(2mm)
The last column is the sup-norm distance between the normalised Plücker vectors of the two moving
transversals and the two special ones; the point of the table is the three columns before it,
which never move. That constancy *is* the conservation of number in this problem, and by the
Proposition above it is not a theorem to be invoked but a consequence of $K|_Lambda$ being a
binary quadratic form of degree $2$ all along the path.

=== Where this proof sits

It needs the most care of the four and, for four lines, adds the least: made rigorous by the cheap
route it is @sec-klein with a witness attached, and made rigorous by the expensive route it is
@sec-klein with a great deal more. What it has that the others do not is *method*. The eigenvector,
quadric and Klein proofs all exploit a structure special to this problem --- a $2 times 2$ matrix, a
quadric surface, a quadric fourfold. Specialisation exploits nothing: it degenerates until the
answer is visible and then argues that the degeneration was harmless. That is Schubert's calculus
in one sentence, and it is why the two classes $sigma_2$ and $sigma_(1,1)$ --- lines through a
point, lines in a plane --- appear here as the two halves of a picture rather than as symbols.

== Every degeneration in one discriminant <sec-degen>

#align(center, table(
  columns: 3, align: (left, left, left),
  stroke: 0.4pt + luma(170), inset: (x: 10pt, y: 4pt),
  table.header([$A = phi^(-1) psi$], [the configuration], [transversals]),
  [scalar, $q_A equiv 0$], [$L_4$ in the ruling of $L_1, L_2, L_3$, so $L_4 subset Q$],
    [a $PP^1$ of them],
  [$"disc" eq.not 0$], [general: $L_4$ crosses $Q$ at two points], [$2$, distinct],
  [$"disc" = 0$, $A$ non-scalar], [$L_4$ tangent to $Q$], [$1$, doubled],
  [$"disc"$ a non-square in $k$], [general, but the two are conjugate], [$2$, not rational],
))

#v(1mm)
In the last row the two transversals are defined over $k(sqrt(d))$, $d = "disc"(q_A)$, and
conjugate over $k$ --- which over $RR$ is the difference between seeing two of them and seeing
none.

#v(2mm)
Check 7d builds the first two rows by hand rather than hoping to draw them: $psi = 2 phi$ gives
$q_A equiv 0$, a fourth line lying on $Q$ and meeting every $M_p$; and
$psi = phi dot mat(1, 1; 0, 1)$ gives $q_A = -Y^2$, a double root, with $L_4$ tangent to $Q$ --- in
both cases the same quadratic form reports the degeneration from all three sides at once.

== Which proof is best

#align(center, table(
  columns: 2, align: (left, left),
  stroke: 0.4pt + luma(170), inset: (x: 10pt, y: 4pt),
  table.header([route], [where the $2$ comes from]),
  [eigenvectors of $A = phi^(-1) psi$], [a characteristic polynomial has degree $2$],
  [the quadric $Q subset PP^3$], [a line meets a quadric surface twice],
  [the Klein quadric $G subset PP^5$], [a line meets a quadric fourfold twice],
  [specialisation to two incident pairs], [$sigma_2^2 + sigma_(1,1)^2$: one line, and one more],
  [the pencil determinant of @sec-controls], [a binary quadratic form has two roots],
))

#v(2mm)
The *simplest* is the eigenvector proof: ten lines of linear algebra over an arbitrary field, no
geometry at all, and it delivers the transversals explicitly and every degeneration in a single
discriminant. The *best* is the quadric proof, because it names the two lines --- they are the two
members of the second ruling through the two points where $L_4$ crosses $Q$ --- and because the
whole classification is then one picture. The Klein-quadric proof is the shortest to state, and it
carries the least special structure --- but it buys its brevity with the Plücker embedding, and the
$2$ it produces is the degree of a quadric, exactly as in the other two. The specialisation proof
has the best picture and the worst small print: it is the only one that has to argue that its own
degeneration was harmless, and @sec-special is mostly that argument. It earns its place because its
*method* is the one that outlives the problem.

And they are not five proofs of one number. The first two are literally the same binary quadratic
form up to a nonzero constant; the third and fifth have the same two roots after the evident change
of parameter, as checks 7c and 7e verify; and the fourth, made rigorous, watches that same form
along a path and finds it never degenerates (check 8c).

== Back to the pencil <sec-back>

The fourth line of that table is @sec-controls itself, and the coincidence of degrees is not a
coincidence. Take $L, L_1, L_2, L_3$ with $L = {y = z = 0}$ as in @sec-chart. If
$P_1 (lambda), P_2 (lambda), P_3 (lambda)$ are collinear, the line they span lies in $V_lambda$,
which contains $L$; two coplanar lines meet; so that line is a transversal to all four. Conversely
a transversal $M$ meets $L$, so $M$ and $L$ span a plane $V_lambda$ of the pencil, and the three
points cut on $M$ are $P_i (lambda)$. *The two roots of the degree-$2$ determinant $Delta$ of
@sec-controls are the two transversals*, and --- once one knows $Delta eq.not 0$, which the
eigenvector form supplies --- the column-degree bookkeeping of @sec-chart is a fourth proof of the
classical count.

Check 7e turns this into an identity of polynomials: sending $[p]$ to the plane spanned by $M_p$
and $L$ pulls $Delta$ back to a constant multiple of $q_A$, on forty configurations without
exception.

One word on circularity, since @sec-controls used the classical $2$ as a *test* of that
bookkeeping. It remains one: the count is proved above by three arguments that never mention the
pencil. What the identity adds is that the two statements concern the same two lines, and not
merely the same number.

= The Pascal route <sec-pascal>

A comment on the question proposes Pascal's theorem and its converse --- the Braikenridge--Maclaurin
theorem --- as the criterion for six points to be conconic. It is a viable route, and it reaches
$8$ by a shorter piece of bookkeeping than @sec-chart. The criterion is that the three points

$ X = P_1 P_2 inter P_4 P_5 , quad Y = P_2 P_3 inter P_5 P_6 , quad Z = P_3 P_4 inter P_6 P_1 $

are collinear. Joining two points and meeting two lines are both cross products, so the degrees
propagate with no further thought:

#align(center, table(
  columns: 2, align: (left, center),
  stroke: 0.4pt + luma(170), inset: (x: 12pt, y: 3.5pt),
  table.header([step], [degrees in $(s,t)$]),
  [point $P_i$], [$(1, 0, 1)$],
  [line $P_i P_j = P_i times P_j$], [$(1, 2, 1)$],
  [Pascal point $(P_1 P_2) inter (P_4 P_5)$], [$(3, 2, 3)$],
  [$3 times 3$ determinant of $X, Y, Z$], [$3 + 2 + 3 = 8$],
))

#v(2mm)
Two cross products and a $3 times 3$ determinant --- no Veronese, no $6 times 6$ matrix, no bundles.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *It is not another route to the same number --- it is the same polynomial.*
  $ Delta_"Pascal" = plus.minus Delta , $
  the sign depending on which of the hexagon labellings is used. Check 6 finds no exception in $40$
  pencil configurations, in $120$ random relabellings of them, or in $300$ sextuples of *unrelated*
  points of $PP^2$ carrying no pencil structure at all.

  #v(1.5mm)
  The reason is a multidegree count. Both expressions are multihomogeneous of multidegree
  $(2, 2, 2, 2, 2, 2)$ in the six points --- the Veronese determinant because each row is quadratic
  in its own point, the Pascal determinant because each $P_i$ occurs in exactly two of $X, Y, Z$ ---
  and both vanish precisely on the conconic hypersurface, which is irreducible. So they are
  proportional, and the trials fix the constant at $plus.minus 1$.
]

#v(2mm)
That disposes of the one delicate point in the route. The synthetic converse wants care in
degenerate configurations --- three points collinear, or a coincidence leaving $X$ undefined --- but
if the two expressions are the *same polynomial*, whatever the Veronese criterion does in a
degenerate case the Pascal expression does too: the necessity of @sec-subq is inherited, not
re-proved.

The explanation of @sec-missing survives as well, as it must: in the naive chart the same
bookkeeping reads $(1,1,1) --> (2,2,2) --> (4,4,4) --> 12$, and
$Delta_"Pascal, naive" = t^4 dot Delta_"Pascal"$. The two charts differ by the linear map
$"diag"(1, -t, 1)$, so the phantom plane appears in the same place for the same reason.

#block(fill: rgb("#fff4e6"), inset: 8pt, radius: 3pt, width: 100%)[
  *Two costs.* First, a *labelling to justify*: there are $60$ essentially distinct hexagons on six
  points, hence $60$ Pascal determinants. They all work, but why the count does not depend on the
  choice is a fair question, and answering it honestly means saying that they are all
  $plus.minus$ the same polynomial --- which is the Veronese determinant. @sec-chart makes no such
  choice. Second, *it stops at conics*: there is no Pascal theorem for ten points on a cubic, so
  @sec-general is unreachable this way, whereas the column-degree argument generalises in one line
  because it says only that $x^a q^b w^c$ has degree $d - b$.

  #v(1.5mm)
  So: correct, and the most elementary form the criterion takes --- but the same arithmetic in
  disguise, and a dead end past $d = 2$.
]

= The question's two sub-questions <sec-subq>

*Is the determinant condition necessary as well as sufficient?* Yes, with no caveat. Six points of
$PP^2$ lie on a common conic if and only if their Veronese vectors are dependent if and only if
$Delta = 0$ --- provided "conic" means any nonzero quadratic form, so that line pairs and double
lines count as conics. There is no gap between the two directions.

*Do all the roots count, and are they simple?* The twelve do not all count: four are the chart
artefact of @sec-missing. The eight that remain are simple for general lines --- check 2 finds
$Delta$ squarefree in all forty configurations at coefficient height $10^3$. At height $10$ about
one draw in twenty is accidentally non-generic, a property of the draw and not of the geometry.

= Any degree, for free <sec-general>

Ask instead for the $N = (d+1)(d+2) slash 2$ points cut on $N$ general lines to lie on a curve of
degree $d$. In the chart the monomial $x^a q^b w^c$ of degree $d$ has degree $d - b$ in $(s,t)$, so

$ deg Delta = sum_(a + b + c = d) (d - b) = N d - d(d+1)(d+2) slash 6 = d(d+1)(d+2) slash 3 . $

#align(center, table(
  columns: 6, align: (center, center, center, center, center, center),
  stroke: 0.4pt + luma(170), inset: (x: 10pt, y: 3.5pt),
  table.header([$d$], [$N$], [naive $N d$], [excess], [observed], [$d(d+1)(d+2) slash 3$]),
  [$1$], [$3$], [$3$], [$1$], [$2$], [$2$],
  [$2$], [$6$], [$12$], [$4$], [$8$], [$8$],
  [$3$], [$10$], [$30$], [$10$], [$20$], [$20$],
))

#v(2mm)
The $d = 1$ row is the classical $2$; the $d = 2$ row is the question; the $d = 3$ row says ten
general lines and a cubic give $20$. Check 5 computes all three determinants directly.

= Five planes through a line on a cubic surface <sec-cubic>

A second classical count in the same style, and the sharpest test of what the chart of
@sec-chart is really doing. Let $S subset PP^3$ be a smooth cubic surface and $L subset S$ a
line. Every plane $V$ containing $L$ cuts $S$ in a plane cubic curve containing $L$, hence in
$L$ together with a residual conic; for how many planes of the pencil does that conic degenerate
into two lines?

#block(fill: luma(240), inset: 9pt, radius: 3pt, width: 100%)[
  *The one-line answer.* Five. The matrix of the residual conic has entries of degree
  $1 + [i = q] + [j = q]$ in $(s,t)$, so its determinant has degree
  $ 3 + 1 + 1 = 5 : $
  one from each row and column, plus one for the $q$-row and one for the $q$-column.

  #v(1.5mm)
  And yes --- the naive chart overcounts here too, by the *identical* factor $t^4$: it says
  nine. What differs is the temptation. Nobody reaches for that chart here, because writing the
  residual conic down at all forces you to parametrise the moving plane, and the honest
  parametrisation is the obvious one. The error this problem invites is the opposite one: the
  residual conics form a pencil, linear in $(s,t)$, so *surely* the discriminant is a cubic ---
  three. The truth is bracketed on both sides, $3 < 5 < 9$, and both errors are the same error:
  forgetting that the chart moves.
]

== Points lose degree, forms gain it

Everything in this note comes from one chart,
$phi_lambda (x : q : w) = (x : -t q : s q : w)$, and from the fact that its middle slot carries
the pencil parameter while the outer two do not. Which way the degree moves depends on what is
being transported.

#v(1mm)
- *A point.* $P_i (lambda)$ has coordinates linear in $(s,t)$ as a point of $PP^3$, but the
  chart reads it as $phi_lambda^(-1)(P_i)$, and the $q$-slot divides a factor out:
  $(#[_linear_] : #[_constant_] : #[_linear_])$. Degree $1 - 1 = 0$ in the middle.
  Contravariant.
- *A form.* A form $F$ on $PP^3$ with constant coefficients is transported the other way, as
  the pullback $phi_lambda^* F$, and the $q$-slot multiplies a factor in: the coefficient of
  $x^a q^b w^c$ has degree $b$. Covariant.

#v(2mm)
@sec-general is the first rule: the Veronese monomial $x^a q^b w^c$ of degree $d$ contributes
$d - b$, and summing gives $d(d+1)(d+2) slash 3$. What follows is the second rule, with the sign
the other way.

== The residual conic, and its five degenerations

Keep $L = {y = z = 0}$ and $V_([s:t]) = {s y + t z = 0}$. A cubic form vanishes on $L$ exactly
when it lies in the ideal $(y, z)$, so

$ F = y G + z H , wide G, H " quadratic forms on " PP^3 . $

The pair $(G,H)$ is not unique --- $(G + z K, H - y K)$ does as well --- but nothing below
depends on the choice. Pull back along the chart:

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  $ F(x, -t q, s q, w) = (-t q) dot G(phi) + (s q) dot H(phi)
    = q dot underbrace([-t dot G(phi) + s dot H(phi)], C_([s:t])) . $
  #v(1.5mm)
  The factor $q$ is $L$ itself, which is ${q = 0}$ in the chart; $C_([s:t])$ is the residual
  conic. This is an identity of polynomials in $(x, q, w, s, t)$, so it holds for every member
  of the pencil at once, with no exceptional plane --- check 9a.
]

#v(2mm)
Now the degrees. In $G(phi)$ the coefficient of $x^a q^b w^c$ has degree exactly $b$, because
each $q$ carries one factor of $s$ or $t$; the outer $-t$ or $s$ adds one more. So the symmetric
matrix $M(s,t)$ of the conic has $deg M_(i j) = 1 + [i = q] + [j = q]$, that is

#align(center, table(
  columns: 4, align: (left,) + (center,)*3,
  stroke: 0.4pt + luma(170), inset: (x: 12pt, y: 3.5pt),
  table.header([degree of $M_(i j)$], [$x$], [$q$], [$w$]),
  [$x$], [$1$], [$2$], [$1$],
  [$q$], [$2$], [$3$], [$2$],
  [$w$], [$1$], [$2$], [$1$],
))

#v(2mm)
Every term of the determinant takes one entry from each row and one from each column, so it
collects $1$ three times, plus $1$ for the $q$-row and $1$ for the $q$-column, whatever the
permutation: $Delta = det M$ is homogeneous of degree $5$. A conic is a pair of lines (or a
double line) exactly when its determinant vanishes, so:

#block(fill: luma(240), inset: 9pt, radius: 3pt, width: 100%)[
  *Five planes*, counted with multiplicity, over any field. Check 9a verifies the degree of
  every entry and the bidegree $(5,5)$ of $Delta$ on forty random surfaces.
]

== Nine, not five: the same phantom plane

Insist instead on the coordinates $(x : y : w)$ of @sec-missing. The parametrisation of
$V_([s:t])$ is then $psi(x : y : w) = (t x : t y : -s y : t w)$, and now *no slot is special*:
every coefficient of the residual conic has degree $3$, and the determinant has degree $9$. The
relation is exact:

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  $ Delta_"naive" = -t^4 dot Delta , wide 9 = 4 + 5 , $
  an identity of polynomials, verified in check 9b on forty surfaces. Same exponent, same
  plane ${y = 0}$, same reason as @sec-missing: at $[s:t] = [1:0]$ the map $psi$ drops from
  rank $3$ to rank $1$ --- the whole of $PP^2$ collapses to the single point $(0:0:1:0)$ ---
  while $phi$ has rank $3$ for every $[s:t]$, checked at both ends of the pencil.
]

#v(2mm)
The bookkeeping is not the same as in @sec-chart: there three of six Veronese columns *dropped*
degree, here one row and one column *gained* it. The phantom factor is nevertheless the same
$t^4$, because it measures the same collapse of the same chart and not the problem being asked.

== Three, not five: the undercount this problem invites

Set $R_([s:t]) = -t G + s H$, a *pencil of quadrics* in $PP^3$, linear in the parameter. The
residual conic is the restriction of $R_([s:t])$ to $V_([s:t])$. Since $R$ is linear in $(s,t)$
and a conic has a $3 times 3$ determinant, the discriminant is a cubic --- three planes.

The reasoning is exactly right for a *fixed* plane and exactly wrong here, and the two missing
degrees have an address: the $q$-row and the $q$-column, one factor of $(s,t)$ for each $q$
substituted for $y$ or $z$. Check 9c computes the fixed-plane cubic and finds that its three
roots share nothing with the five: the resultant of the cubic and the quintic is nonzero in
every draw. It is not an undercount of the five planes but a count of something else.

== Why the five are distinct: smoothness, used once

Everything so far is a degree count, valid for any cubic containing a line, singular or not. It
gives five roots with multiplicity. Smoothness enters exactly once, and it is worth isolating
where.

Differentiate the identity $F(phi) = q C$ along the pencil, in a direction $(dot(s), dot(t))$ of
the parameters. Since $partial phi slash partial s = (0,0,q,0)$ and $partial phi slash partial t =
(0,-q,0,0)$, the factor $q$ cancels and

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  $ (dot(s) F_z - dot(t) F_y) compose phi = dot(C) , $
  #v(1.5mm)
  again an identity of polynomials in $(x,q,w,s,t)$. Differentiating in the *space* directions
  instead gives $(F_x, -t F_y + s F_z, F_w) compose phi = nabla(q C) = (q C_x, C + q C_q, q C_w)$.
]

#v(2mm)
Let $[s_0 : t_0]$ be a root of $Delta$, let $C_0$ be the conic there and $v$ a singular point of
it, and put $p = phi(v) in PP^3$. At a singular point of a conic both $C_0$ and its gradient
vanish, so the right-hand side of the second identity is zero at $v$, whence

$ F_x (p) = F_w (p) = 0 , wide t_0 F_y (p) = s_0 F_z (p) , wide "so" wide
  nabla F(p) = kappa dot (0, s_0, t_0, 0) $

for a scalar $kappa$. Read geometrically: if $S$ is smooth at $p$ then its tangent plane there
*is* the plane of the section --- which is why these five planes are classically called
*tritangent*. Read through the first identity: $dot(C)(v) = kappa dot (dot(s) t_0 - dot(t) s_0)$,
so along any direction transverse to $[s_0 : t_0]$,

$ dot(C)(v) eq.not 0 quad <==> quad kappa eq.not 0 quad <==> quad nabla F(p) eq.not 0 . $

And $dot(C)(v)$ is exactly what decides the multiplicity of the root. If $C_0$ has rank $2$ with
kernel $v$, then $"adj"(M_0) = c dot v^tack.b v$ with $c eq.not 0$, and

$ d Delta = "tr"("adj"(M_0) dot dot(M)) = c dot v dot(M) v^tack.b = c dot dot(C)(v) . $

If $C_0$ has rank $1$ the adjugate vanishes identically and the root is automatically at least
double. (And if $Delta equiv 0$, then $d Delta = 0$ everywhere, so the same line applies
at any plane whose conic has rank $2$, and step (1) below at any whose conic has rank $1$: either
way $S$ is singular.)

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Theorem.* Let $S = {F = 0} subset PP^3$ be a cubic surface containing the line $L$, over an
  algebraically closed field of characteristic $eq.not 2$, and let $Delta$ be the binary quintic
  above.

  #v(1mm)
  - If $S$ is singular at a point $p in.not L$, then $Delta$ vanishes to order $gt.eq 2$ at the
    plane spanned by $L$ and $p$ (or vanishes identically).
  - If $S$ is smooth, then $Delta eq.not 0$ and its five roots are distinct; at each of them the
    residual conic has rank exactly $2$, so it is a pair of *distinct* lines, neither of them $L$.

  #v(1.5mm)
  Hence a line on a smooth cubic surface lies in exactly five tritangent planes, and meets
  exactly ten other lines of the surface. #h(1fr) $square$
]

#v(2mm)
Three short steps finish it, and each is where some hypothesis is spent.

#v(1mm)
+ *A double line forces a singularity.* If $C_0$ has rank $1$, its singular locus is a whole
  line $M$, and the displayed computation applies at every $v in M$. As a function of $v$,
  $kappa$ is $F_y compose phi$ divided by $s_0$ --- or $F_z compose phi$ divided by $t_0$,
  whichever is nonzero --- hence the restriction of a quadratic form, so $kappa|_M$ is a binary
  quadratic form, and over an algebraically closed field it has a root. At that root
  $nabla F = 0$. So a plane section $L + 2M$ is impossible on a smooth surface. Check 9f builds
  such a section by hand, $F|_{z = 0} = y x^2$, and finds the singular point where the theory
  says it must be.
+ *The conic never contains $L$.* Restricting $C$ to ${q = 0}$ gives
  $C|_L = -t dot G|_L + s dot H|_L$, the pencil of binary quadratic forms spanned by the
  restrictions of $G$ and $H$ to $L$. On the other hand $nabla F|_L = (0, G|_L, H|_L, 0)$, since
  the $x$- and $w$-derivatives of $y G + z H$ vanish on ${y = z = 0}$. So $S$ is smooth along
  $L$ exactly when $G|_L$ and $H|_L$ have no common zero, and then no member of the pencil is
  the zero form: $C_0$ never vanishes on $L$. As a by-product, the two residual lines meet $L$
  at the two roots of $-t_0 G|_L + s_0 H|_L$.
+ *The ten lines are distinct.* Any line $M eq.not L$ of $S$ meeting $L$ spans a plane with it,
  necessarily a member of the pencil, and $M subset S inter V = L union C$ makes $M$ a component
  of $C$. Two distinct planes of the pencil meet in $L$ alone, so lines from different planes
  cannot coincide, and by (2) none of them is $L$.

#v(2mm)
What smoothness does *not* exclude is worth naming. The two residual lines may meet $L$ at the
same point, so that $L$ and the two lines are concurrent: an *Eckardt point*. The Fermat cubic
has eighteen of them, two on every line, and its five planes are still distinct. The theorem
controls the multiplicity of a root, not the position of the vertex.

#block(inset: (left: 12pt, y: 2pt), stroke: (left: 2pt + luma(190)))[
  *A cheap smoothness test.* The theorem is an equivalence, and it buys something practical.
  $S$ is singular at a point of $L$ iff $G|_L$ and $H|_L$ share a zero, and singular off $L$ iff
  $Delta$ has a repeated root. So
  $ S " is smooth" quad <==> quad "Res"(G|_L, H|_L) eq.not 0 " and " "disc"(Delta) eq.not 0 : $
  a resultant of two binary quadratics and the discriminant of a binary quintic, with no
  elimination in four variables anywhere. Check 9d certifies all forty random surfaces this way,
  and check 9e then goes to $PP^3$ and finds the ten lines: at each of the five roots it splits
  the conic, maps the two lines back through the chart, and evaluates $F$ along them --- worst
  value $2.4 times 10^(-35)$ against $5.6 times 10^(2)$ for the same construction at a plane that
  is not one of the five, a separation of thirty-seven orders of magnitude. The ten lines come
  out pairwise distinct and none of them is $L$.
]

== A topological control, and any degree

The five can be had a second time with no coordinates at all. By step (2) the pencil of residual
conics has no base point, so it is a morphism $pi : S --> PP^1$ --- the classical conic bundle
structure --- whose fibres are the conics $C_lambda$. Over $CC$ the topological Euler
characteristic $chi$ is additive over the base; a smooth conic has $chi = 2$ and a pair of
distinct lines has $chi = 2 + 2 - 1 = 3$, so if $n$ is the number of degenerate fibres,

$ chi(S) = chi(PP^1) dot 2 + n dot (3 - 2) = 4 + n . $

A smooth cubic surface is $PP^2$ blown up at six points, so $chi(S) = 3 + 6 = 9$, and $n = 5$.
Not a whisper of a chart.

Both computations survive to a smooth surface $S$ of degree $d$ containing a line, where the
residual curve has degree $e = d - 1$.

#v(1mm)
- *The weights.* The discriminant of a ternary form of degree $e$ is a polynomial of degree
  $3(e-1)^2$ in its coefficients, and $"Disc"(f compose g) = det(g)^(e(e-1)^2) dot "Disc"(f)$ for
  $g in "GL"_3$. Up to those two operations the residual curve is a form with constant
  coefficients: the coefficient of $x^a q^b w^c$ has degree $1 + b$, which is what scaling $q$ by
  a parameter of degree $1$ and then multiplying the whole form by one more produces. So the
  discriminant picks up $3(e-1)^2$ from the overall factor and $e(e-1)^2$ from the substitution:
  $ deg Delta = 3(e-1)^2 + e(e-1)^2 = (e-1)^2 (e+3) = (d-2)^2 (d+2) . $
- *Euler.* Adjunction gives $L^2 = 2 - d$, so $(H - L)^2 = d - 2 + (2 - d) = 0$ and the residual
  curves again form a base-point-free pencil, now of genus $(e-1)(e-2) slash 2$; its smooth fibre
  has $chi = 2 - (e-1)(e-2)$, while $chi(S) = c_2 = d^3 - 4d^2 + 6 d$. A one-nodal fibre costs
  exactly one, so
  $ n = (d^3 - 4d^2 + 6d) - 2(2 - (d-2)(d-3)) = d^3 - 2d^2 - 4d + 8 . $

#v(2mm)
The two polynomials in $d$ are equal --- check 9g prints them side by side for $d = 2, ..., 6$
and confirms the identity, together with the weighted homogeneity
$C(x, q slash lambda, w; lambda s, lambda t) = lambda C(x, q, w; s, t)$ that is the whole
content of the chart bookkeeping at any degree.

#align(center, table(
  columns: 5, align: (center,)*5,
  stroke: 0.4pt + luma(170), inset: (x: 11pt, y: 3.5pt),
  table.header([$d$], [residual curve], [$(d-2)^2 (d+2)$], [$c_2 (S)$], [what the count is]),
  [$2$], [a line], [$0$], [$4$], [nothing to degenerate],
  [$3$], [a conic], [$5$], [$9$], [the five tritangent planes],
  [$4$], [a plane cubic], [$24$], [$24$], [the nodal fibres of an elliptic K3],
))

#v(2mm)
The $d = 4$ row is a pleasant coincidence that is not one: on a quartic surface containing a
line the residual pencil is an elliptic fibration on a K3, its nodal fibres are counted by
$chi("K3") = 24$, and the weight count agrees. Past $d = 3$ the reading changes --- a singular
residual curve is no longer the same thing as one that splits off further lines --- but the
degree is the degree.

== What the two problems share

@sec-question and this one are one chart used twice: once on points, where the $q$-slot loses a
degree and the count falls from $12$ to $8$; once on forms, where it gains one and the count
rises from $3$ to $5$. In both the naive chart $(x : y : w)$ is off by the factor $t^4$ of
@sec-missing, always the plane ${y = 0}$ counted four times over, and always for the reason that
this chart, and not the geometry, degenerates at one member of the pencil.

= Dictionary to the bundle answer <sec-dict>

The answer on the site does exactly this computation in the language of vector bundles on $PP^1$.
It is worth having the translation, because every object in it corresponds to something already
written down above.

#block(inset: (left: 12pt, y: 2pt), stroke: (left: 2pt + luma(190)))[
  *The incidence variety.* $cal(V) = {([x : y : z : w], [s : t]) : s y + t z = 0} subset
  PP^3 times PP^1$ with $pi : cal(V) --> PP^1$ is the total space of the pencil: the planes glued
  into one $3$-fold so that all of them can be spoken of at once. Its fibres are the $V_lambda$.
]

#block(inset: (left: 12pt, y: 2pt), stroke: (left: 2pt + luma(190)))[
  *$cal(V) = PP(cal(G)^or)$ with $cal(G) = cal(O) xor cal(O)(-1) xor cal(O)$.*
  This *is* the chart $phi_lambda$. The fibre $cal(G)_([s:t]) = {(x, -t q, s q, w)}$ is spanned by
  $(1,0,0,0)$, $(0,-t,s,0)$, $(0,0,0,1)$: the outer two are constant vectors, giving trivial
  summands, and the middle one spans the tautological sub-line-bundle of $cal(O)_(PP^1)^(xor 2)$
  in the coordinates $(y, z)$, which is $cal(O)(-1)$. The twist in the middle slot is precisely
  @sec-chart's statement that $q$ is constant while $x$ and $w$ are linear.
]

#block(inset: (left: 12pt, y: 2pt), stroke: (left: 2pt + luma(190)))[
  *$cal(E) = pi_* cal(O)_cal(V)(2H) tilde.equiv "Sym"^2 (cal(G)^or)$, with $c_1(cal(E)) = 4$.* This
  is the rank-$6$ bundle whose fibre is the space of conics on $V_lambda$. Splitting it,
  $ "Sym"^2 (cal(O) xor cal(O)(1) xor cal(O)) = cal(O) xor cal(O)(2)
    xor cal(O) xor cal(O)(1) xor cal(O) xor cal(O)(1) , wide
    c_1 = 0 + 2 + 0 + 1 + 0 + 1 = 4 . $
  Those six summands are the six *columns* of @sec-chart's matrix, and their degrees
  $0, 2, 0, 1, 0, 1$ are exactly the amounts by which the column degrees $2, 0, 2, 1, 2, 1$ fall
  short of the naive $2$. *$c_1(cal(E)) = 4$ is literally the $t^4$ of @sec-missing.*
]

#block(inset: (left: 12pt, y: 2pt), stroke: (left: 2pt + luma(190)))[
  *$cal(F) = xor.big_(i=1)^6 s_i^* cal(O)_cal(V)(2H) tilde.equiv cal(O)(2)^(xor 6)$,
  with $c_1(cal(F)) = 12$.* Each $L_i$ meets each plane once, so it defines a section
  $s_i : PP^1 --> cal(V)$; composing with $cal(V) --> PP^3$ carries $PP^1$ isomorphically onto the
  *line* $L_i$, so $s_i^* cal(O)_(PP^3)(1) = cal(O)_(PP^1)(1)$ and $s_i^* cal(O)(2H) =
  cal(O)_(PP^1)(2)$. Six of them give $12$. *$c_1(cal(F)) = 12$ is the naive count* --- the correct
  statement that each point moves linearly, so each Veronese entry is a quadric.
]

#block(inset: (left: 12pt, y: 2pt), stroke: (left: 2pt + luma(190)))[
  *The evaluation map and Thom--Porteous.* $"ev" : cal(E) --> cal(F)$ is "restrict a conic to the
  six points", a map of rank-$6$ bundles over $PP^1$, and the six points lie on a conic exactly
  where it drops rank. In the *equal rank* case the Thom--Porteous formula degenerates to a
  triviality: taking determinants,
  $ det("ev") in H^0 (PP^1, "Hom"(det cal(E), det cal(F))) = H^0 (PP^1, det cal(E)^or ⊗
    det cal(F)) , $
  a section of a line bundle of degree $c_1(cal(F)) - c_1(cal(E))$, and a section of a degree-$n$
  line bundle on $PP^1$ has $n$ zeros. So $[D_5("ev")] = c_1(cal(F)) - c_1(cal(E)) = 12 - 4 = 8$ is
  no more than *count the zeros of the determinant, remembering which line bundle it lives in*. The
  general formula --- a determinant in the Chern classes, for rank dropping by more than one
  between bundles of unequal rank --- is only needed when the ranks differ.
]

#v(2mm)
And the phrase in the answer that carries the whole objection, "you are treating the space of
conics as a trivial bundle", says in the elementary language: *you chose a chart that looks
degree-$1$-in-$lambda$ in all three coordinates.* No such chart exists; the obstruction is the
$cal(O)(1)$ summand, of degree $1$, and $"Sym"^2$ turns that into the discrepancy $4$.

#align(center, table(
  columns: 2, align: (left, left),
  stroke: 0.4pt + luma(170), inset: (x: 10pt, y: 4pt),
  table.header([the answer as written], [the elementary version]),
  [$cal(G) = cal(O) xor cal(O)(-1) xor cal(O)$],
    [$P_i (lambda) = (#[_linear_] : #[_constant_] : #[_linear_])$],
  [$c_1(cal(F)) = 12$], [the naive count: six points, degree-$2$ Veronese],
  [$c_1(cal(E)) = c_1("Sym"^2 cal(G)^or) = 4$], [the spurious factor $t^4$],
  [degeneracy locus of $"ev"$], [the roots of $Delta$],
  [Thom--Porteous, equal rank], [$det$ is a section of a line bundle of degree $c_1 cal(F) - c_1 cal(E)$],
  [$8$], [$8$],
))

= What the companion script checks <sec-gp>

`pencil-conic-count.gp`, results in `results/pencil-conic-count.txt`. Random lines are drawn with
integer coordinates of height $10^3$; forty configurations per check unless stated.

#v(1mm)
- *(1)* The structural fact of @sec-chart: the $y$- and $z$-coordinates of $P_i$ are $m_i t$ and
  $-m_i s$ with $m_i = p_(23)(L_i)$ constant, the chart coordinate $q$ is constant, and $x, w$ are
  linear --- exactly linear at all $240$ moving points tested. With the control that $p_(23) = 0$
  for a line inside ${y = z = 0}$.
- *(2)* $Delta$ has bidegree $(8,8)$, $Delta_"naive" = t^4 Delta$ identically, and $Delta$ is
  squarefree: zero exceptions in forty configurations.
- *(3)* The off-chart verification of @sec-controls: at all eight roots the Veronese determinant in
  an independently chosen basis of the plane is below $5 times 10^(-39)$, against $8.3 times
  10^(-5)$ at a non-root.
- *(4)* The linear control: bidegree $(2,2)$ and $Delta_"naive" = -t Delta$, forty configurations.
- *(5)* The table of @sec-general: the determinants computed directly for $d = 1, 2, 3$, matching
  $d(d+1)(d+2) slash 3 = 2, 8, 20$.
- *(6)* The Pascal route of @sec-pascal: $Delta_"Pascal" = Delta$ on the pencil and on $300$
  unrelated sextuples in $PP^2$, $plus.minus Delta$ under $120$ random relabellings,
  $Delta_"Pascal, naive" = t^4 Delta_"Pascal"$, and the two degree chains
  $(1,0,1) --> (1,2,1) --> (3,2,3) --> 8$ and $(1,1,1) --> (2,2,2) --> (4,4,4) --> 12$.
- *(7)* The four-line count of @sec-transversals, in seven parts. *(7a)* The family
  $M_p = "span"(p, phi(p))$ meets $L_1, L_2, L_3$ identically in $(X,Y)$, meets $L_4$ exactly on
  $q_A$, and $"disc"(q_A) = "tr"(A)^2 - 4 det(A)$. *(7b)* The quadric through $L_1, L_2, L_3$,
  solved for by linear algebra: unique, of rank $4$, containing the three lines and every $M_p$,
  equal to ${omega(phi u, v) = 0}$, and cutting $L_4$ in a multiple of $q_A$. *(7c)* The Klein
  quadric: $[L_i]$ on $G$ and on its own tangent hyperplane, the four hyperplanes cutting a line
  $Lambda subset PP^5$, and all twenty $3 times 3$ minors expressing
  $pi(p) in Lambda$ proportional to $q_A$ --- $800$ minors, no exception. *(7d)* The two
  degenerate configurations, built by hand. *(7e)* $Delta$ of @sec-controls pulled back along
  $p |-> "plane"(M_p, L)$ is a constant multiple of $q_A$. *(7f)* $860$ of $1000$ random integer
  configurations have two real transversals. *(7g)* Two worked configurations, one with each sign
  of the discriminant, with the transversals verified back in $PP^3$ against all four lines to a
  relative $10^(-38)$.

#v(1mm)
- *(8)* The specialisation proof of @sec-special. *(8a)* In the special position the four
  incidence conditions have rank $4$, the Klein form on $Lambda$ is a binary quadratic with
  distinct roots, and $overline(P Q)$ and $Pi inter Sigma$ are those roots. *(8b)* At both, the
  four tangent conditions of @sec-special have rank $4$ on $"Hom"(W, V slash W)$: reduced points,
  the step the sketches omit. *(8c)* Along a path from the special configuration to a general one
  the solution space stays a line in $PP^5$ and $K|_Lambda$ stays a binary quadratic of nonzero
  discriminant. *(8d)* The lying specialisation: $L_4$ tangent to the quadric through
  $L_1, L_2, L_3$, where the Klein quadratic is a perfect square and the tangent rank drops to $3$
  --- one solution of multiplicity two, not one solution. *(8e)* The half-degeneration
  $sigma_1^2 = sigma_2 + sigma_(1,1)$, with both transversals identified.

#v(1mm)
- *(9)* The cubic surface of @sec-cubic, in seven parts. *(9a)* $F(phi) = q C$ identically, every
  entry of the conic matrix of degree exactly $1 + [i=q] + [j=q]$ --- $360$ entries --- and
  $Delta$ of bidegree $(5,5)$. *(9b)* $Delta_"naive" = -t^4 Delta$ identically, degree $9$, with
  the naive chart of rank $1$ at $t = 0$ against rank $3$ for the honest one at both ends of the
  pencil. *(9c)* The undercount: the pencil of quadrics restricted to a *fixed* plane does have a
  cubic determinant, whose roots have nothing to do with the five (nonzero resultant every time).
  *(9d)* The smoothness certificate $"Res"(G|_L, H|_L) eq.not 0$, $"disc"(Delta) eq.not 0$.
  *(9e)* The five planes and the ten lines, computed back in $PP^3$: worst $abs(F)$ on a residual
  line $2.4 times 10^(-35)$ against $5.6 times 10^2$ for the same construction at a plane that is
  not one of the five, ten lines pairwise distinct, none of them $L$. *(9f)* A node imposed at a
  chosen point off $L$: the corresponding linear form divides $Delta$ exactly twice, the vertex of
  the conic there is the node to $3 times 10^(-39)$, and the other three planes stay simple; then
  the other degeneration, a plane section $L + 2M$, with the singularity found on $M$ where the
  binary quadratic $kappa|_M$ vanishes. *(9g)* The weighted homogeneity at $d = 2, ..., 6$, and
  the two formulas for $(d-2)^2 (d+2)$ side by side.

= References <sec-refs>

#block(inset: (left: 4pt))[
#set enum(numbering: "[1]")
+ #link("https://math.stackexchange.com/questions/5130224/")[Mathematics Stack Exchange 5130224],
  "Given lines $L, L_1, ..., L_6$ in $PP^3$, how many planes $V$ through $L$ intersect the six
  lines $L_i$ in six points lying on a conic?". The question, and the answer this note translates.
+ D. Eisenbud, J. Harris, *3264 and All That: A Second Course in Algebraic Geometry*, CUP 2016.
  Chapter 12 for degeneracy loci and Thom--Porteous --- the genre the answer places the question in
  --- and Chapter 3 for the Grassmannian $G(1,3)$, the Schubert class $sigma_1$, and the two
  transversals to four general lines, specialisation included: the $d = 1$ control of
  @sec-controls and the subject of @sec-transversals.
+ W. Fulton, *Intersection Theory*, 2nd ed., Springer 1998. Chapter 14 for Thom--Porteous in
  general, of which @sec-dict uses only the equal-rank case; Chapter 10 for the degeneration point
  of view behind @sec-special.
+ H. S. M. Coxeter, *Projective Geometry*, 2nd ed., Springer 1987. Pascal's theorem and its
  converse, the Braikenridge--Maclaurin theorem of @sec-pascal.
+ J. Harris, *Algebraic Geometry: A First Course*, Springer 1992. Lecture 2 for the Veronese, and
  Lecture 6 for the Plücker coordinates, the incidence relation used in @sec-chart, and the Klein
  quadric of @sec-transversals.
+ P. Griffiths, J. Harris, *Principles of Algebraic Geometry*, Wiley 1978. Chapter 1, on
  Grassmannians and the Schubert calculus, for the $sigma_1^4 = 2 sigma_(2,2)$ of
  @sec-transversals.
+ S. L. Kleiman, D. Laksov, "Schubert calculus", #emph[Amer. Math. Monthly] *79* (1972),
  1061--1082. The expository source for @sec-special, where the specialisation argument is given
  in outline.
+ M. Reid, *Undergraduate Algebraic Geometry*, CUP 1988. The cubic surface and its $27$ lines,
  counted through exactly the pencil of residual conics of @sec-cubic.
+ R. Hartshorne, *Algebraic Geometry*, Springer 1977. Chapter V.4, the cubic surface as $PP^2$
  blown up at six points --- where @sec-cubic gets $chi(S) = 9$ --- and Chapter V.1 for
  adjunction and $L^2 = 2 - d$.
+ I. M. Gelfand, M. M. Kapranov, A. V. Zelevinsky, *Discriminants, Resultants and
  Multidimensional Determinants*, Birkhäuser 1994. The degree $3(e-1)^2$ of the discriminant of a
  plane curve of degree $e$ and its weight under $"GL"_3$, used for the any-degree count of
  @sec-cubic.
+ S. L. Kleiman, "Problem 15: rigorous foundation of Schubert's enumerative calculus", in
  *Mathematical Developments Arising from Hilbert Problems*, Proc. Sympos. Pure Math. 28, AMS
  1976, pp. 445--482. What the principle of conservation of number costs, and why it needed a
  foundation.
]
