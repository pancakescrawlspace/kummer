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
  (@sec-controls), and $d(d+1)(d+2) slash 3$ in general (@sec-general). The Pascal route suggested
  in the comments reaches $8$ too, and by a shorter count --- because it is the same polynomial
  (@sec-pascal).
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
lines $L, L_1, L_2, L_3$. The naive chart would have said $3$, off by exactly $t^1$. Since the
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

= References <sec-refs>

#block(inset: (left: 4pt))[
#set enum(numbering: "[1]")
+ #link("https://math.stackexchange.com/questions/5130224/")[Mathematics Stack Exchange 5130224],
  "Given lines $L, L_1, ..., L_6$ in $PP^3$, how many planes $V$ through $L$ intersect the six
  lines $L_i$ in six points lying on a conic?". The question, and the answer this note translates.
+ D. Eisenbud, J. Harris, *3264 and All That: A Second Course in Algebraic Geometry*, CUP 2016.
  Chapter 12 for degeneracy loci and Thom--Porteous --- the genre the answer places the question in
  --- and Chapter 3 for the two transversals to four general lines, the $d = 1$ control of
  @sec-controls.
+ W. Fulton, *Intersection Theory*, 2nd ed., Springer 1998. Chapter 14 for Thom--Porteous in
  general, of which @sec-dict uses only the equal-rank case.
+ H. S. M. Coxeter, *Projective Geometry*, 2nd ed., Springer 1987. Pascal's theorem and its
  converse, the Braikenridge--Maclaurin theorem of @sec-pascal.
+ J. Harris, *Algebraic Geometry: A First Course*, Springer 1992. Lecture 2 for the Veronese, and
  Lecture 6 for the Plücker coordinates and incidence relation used in @sec-chart.
]
