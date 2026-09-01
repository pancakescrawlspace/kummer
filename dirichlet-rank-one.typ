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
  #text(size: 16pt, weight: "bold")[Where the unit theorem is easy]
  #v(2mm)
  #text(size: 10pt)[Rank one, twice over: real quadratic fields and complex cubic fields,
  and exactly how much the second costs]
  #v(1mm)
  #text(size: 9pt, style: "italic")[a question of René Pannekoek's; companion to
  `dirichlet-mordell-weil.typ`; checks in `dirichlet-rank-one.gp`]
]

#v(4mm)

#block(fill: luma(240), inset: 9pt, radius: 3pt, width: 100%)[
  *Summary.* Yes --- for real quadratic fields there is a genuinely simpler proof, and it is
  simpler for a reason that has nothing to do with the degree being $2$. The unit rank is $1$, and
  *rank $1$ is what makes it easy*: the general theorem has to produce $r$ *independent* units,
  which is what forces Minkowski's convex body theorem, the logarithmic embedding and an induction.
  With $r = 1$ there is nothing to be independent from, and the proof collapses to two steps, both
  elementary:
  #v(1mm)
  #block(stroke: 0.6pt + black, inset: 8pt, radius: 3pt, width: 100%)[
    *(i) Discreteness.* A unit of bounded archimedean size has a monic integer minimal polynomial
    with bounded coefficients, so there are finitely many. Hence the units $> 1$ have a least
    element $epsilon$, and $cal(O)_K^times = ⟨ -1 ⟩ times epsilon^ZZ$.
    #v(1mm)
    *(ii) Existence.* The box principle produces infinitely many algebraic integers of bounded
    norm; two of them are congruent modulo that norm, and their ratio is a unit $eq.not plus.minus 1$.
  ]
  #v(1.5mm)
  *The cubic question.* A cubic field has $r_1 + 2r_2 = 3$, so the unit rank $r_1 + r_2 - 1$ is
  $2$ (totally real) or $1$ (one real place, $d_K < 0$). The rank-one cubics are exactly the
  *complex* ones, and for them *the very same proof runs* --- checks 3 and 4 run both versions and
  they differ only in that the pigeonhole is $2$-dimensional instead of $1$-dimensional.

  #v(1.5mm)
  So the honest answer to "is the cubic case more complicated?" is: *yes, in exactly one structural
  way, and it is forced.* A Galois cubic is cyclic, and complex conjugation would be an element of
  order $2$ in a group of order $3$; so *every* rank-one cubic is non-Galois. In $QQ(sqrt(d))$ the
  conjugate $u'$ lies inside the field, and $"Tr"(u)$, $N(u)$ are visible there --- the whole
  argument happens inside $K$. In a complex cubic the other two conjugates live outside $K$ and one
  must work in the Minkowski embedding. Everything else that differs (@sec-ledger) is a matter of
  what the two cases *support*, not of what the proof costs: continued fractions, the sign of
  $N(epsilon)$, Artin's inequality.
]

= Which fields have unit rank one <sec-which>

Dirichlet's theorem gives $cal(O)_K^times tilde.equiv mu(K) times ZZ^r$ with $r = r_1 + r_2 - 1$.
Rank $1$ in low degree means:

#align(center)[
  #table(columns: 5, stroke: 0.4pt, inset: 6pt, align: (left, center, center, center, left),
    [field], [$(r_1, r_2)$], [$r$], [$mu(K)$], [sign of $d_K$],
    [real quadratic $QQ(sqrt(d))$, $d > 0$], [$(2,0)$], [$1$], [$plus.minus 1$], [$+$],
    [imaginary quadratic], [$(0,1)$], [$0$], [$mu_4$, $mu_6$, $plus.minus 1$], [$-$],
    [totally real cubic], [$(3,0)$], [$2$], [$plus.minus 1$], [$+$],
    [*complex cubic*], [$(1,1)$], [$1$], [$plus.minus 1$], [$-$],
  )
]

Both rank-one families have a real embedding, so $mu(K) = {plus.minus 1}$ and there is nothing to
say about torsion. Check 1 tabulates this.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Every rank-one cubic is non-Galois.* If $K slash QQ$ is a Galois cubic it is cyclic, so
  $"Gal"(K slash QQ) tilde.equiv ZZ slash 3$. Complex conjugation, restricted to $K$ under any
  embedding, would be an element of order dividing $2$, hence trivial --- so all embeddings are
  real, $(r_1,r_2) = (3,0)$ and $r = 2$. Contrapositive: $r = 1$ forces non-Galois.
]

Check 8 confirms this on $403$ complex cubic fields: none is Galois. This is the one difference
between the two cases that is structural rather than cosmetic, and @sec-ledger says what it costs.

= What the general proof costs, and what rank one saves <sec-general>

The standard proof embeds
$ lambda : cal(O)_K^times -> RR^(r_1 + r_2) , wide
  u |-> (n_v log |u|_v)_v , wide n_v = 1 "or" 2 , $
notes that $sum_v n_v log|u|_v = log|N(u)| = 0$ so the image lies in a hyperplane $H tilde.equiv RR^r$,
and proves two things: the image is *discrete* in $H$, and it *spans* $H$. Discreteness is the easy
half (below). Spanning is the whole difficulty: one must produce, for each place $i$, a unit with
$|u|_i > 1$ and $|u|_j < 1$ for $j eq.not i$, which needs Minkowski's convex body theorem applied
along a shrinking family of boxes, and then a determinant argument to turn those into $r$
independent units.

When $r = 1$ the hyperplane is a line. There is no independence to arrange, no induction, and no
determinant: *one* unit of infinite order plus discreteness is the entire theorem. That is the
saving, and it applies verbatim to both families.

= The easy half: discreteness, with no lattice theory <sec-discrete>

*Real quadratic.* Let $u$ be a unit with $1 < u <= T$. Its conjugate $u'$ satisfies $u u' = N(u) =
plus.minus 1$, so $u' = plus.minus u^(-1)$ and
$ u + u' = "Tr"(u) in ZZ , wide |"Tr"(u)| <= T + 1 . $
So $u$ is a root of $X^2 - m X plus.minus 1$ with $|m| <= T+1$: *finitely many possibilities*. No
lattices, no geometry.

*Complex cubic.* Let $sigma_1$ be the real embedding and $sigma_2, overline(sigma_2)$ the complex
pair. For a unit, $1 = |N(u)| = |sigma_1(u)| dot |sigma_2(u)|^2$, so
$ |sigma_2(u)| = |sigma_1(u)|^(-1 slash 2) . $
*One real parameter controls all three conjugates* --- which is precisely what unit rank one means,
and check 2 verifies the identity to ten places. Hence if $|sigma_1(u)| <= T$ then all three
conjugates are bounded, so the three elementary symmetric functions --- integers --- are bounded,
and again there are finitely many such $u$.

In both cases: the units in $(1, T]$ are finite in number, so there is a least one, $epsilon$; and
a standard argument (if $u > 1$ is a unit, take $k$ with $epsilon^k <= u < epsilon^(k+1)$, then
$u epsilon^(-k)$ is a unit in $[1, epsilon)$, hence $1$) gives
$ cal(O)_K^times = ⟨ -1 ⟩ times epsilon^ZZ . $
Check 2 runs the real quadratic version *as stated* --- enumerating the polynomials
$X^2 - m X plus.minus 1$ with $|m| <= T+1$ and counting the units they produce in $(1,T]$ --- and
gets exactly $floor(log T slash log epsilon)$ every time.

= The hard half for real quadratic: Dirichlet approximation <sec-quad>

This is the classical argument, and it uses nothing but the box principle.

Since $sqrt(d)$ is irrational, Dirichlet's approximation theorem gives infinitely many $p slash q$
with $|sqrt(d) - p slash q| < 1 slash q^2$, i.e. $|p - q sqrt(d)| < 1 slash q$. Then
$|p + q sqrt(d)| < 2 q sqrt(d) + 1 slash q$, so
$ |p^2 - d q^2| < 2 sqrt(d) + 1 slash q^2 <= 1 + 2 sqrt(d) . $
*Bounded, uniformly.* So some non-zero $k$ with $|k| <= 1 + 2 sqrt(d)$ arises from infinitely many
pairs; among those, infinitely many share a residue class of $(p, q)$ modulo $|k|$. Take two,
$(p_i, q_i)$ and $(p_j, q_j)$, and set
$ u = (p_j + q_j sqrt(d)) slash (p_i + q_i sqrt(d)) = A + B sqrt(d) , wide
  A = (p_j p_i - d q_j q_i) slash k , wide B = (q_j p_i - p_j q_i) slash k . $
The congruences make $A, B in ZZ$; $N(u) = k slash k = 1$; and $B eq.not 0$ because the two
convergents are distinct. So $u$ is a unit $eq.not plus.minus 1$. #h(2mm) $qed$

Check 3 runs this on the continued-fraction convergents of $sqrt(d)$: every $|p^2 - d q^2|$ does
stay under $1 + 2 sqrt(d)$, the first collision is found within a couple of dozen convergents, and
the unit it produces is a genuine power of $epsilon$ --- $epsilon^6$ for $d = 61$, which is the
famous Pell solution $1766319049 + 226153980 sqrt(61)$.

#block(fill: luma(243), inset: 8pt, radius: 3pt, width: 100%)[
  *A trap worth recording.* The *fundamental unit of $cal(O)_K$* and the *fundamental solution of
  Pell* are not the same thing, and can differ by a large power. For $d = 61$ the fundamental unit
  is $(39 + 5 sqrt(61)) slash 2 approx 39.03$, of norm $-1$; the least solution of $x^2 - 61 y^2 = 1$
  in *integers* is $epsilon^6$. Two effects compound: the ring of integers is $ZZ[(1+sqrt(61))slash 2]$,
  not $ZZ[sqrt(61)]$, and $N(epsilon) = -1$ so the norm-$1$ units are the *even* powers.
]

= The hard half for a complex cubic: the same proof, one dimension up <sec-cubic>

Let $K = QQ(theta)$ with $theta$ the real root, $sigma_1$ the real embedding. Put
$alpha = x + y theta + z theta^2$.

*The box principle, in its linear-form shape.* Among the $(Q+1)^2$ numbers
${y theta + z theta^2}$ for $0 <= y, z <= Q$, two lie in a common bin of width
$1 slash ((Q+1)^2 - 1)$. Subtracting them gives integers $y, z$ with $|y|, |z| <= Q$, not both
zero, and an integer $x$ with
$ |sigma_1(alpha)| <= 1 slash ((Q+1)^2 - 1) tilde.op 1 slash Q^2 . $
Meanwhile the coefficients of $alpha$ are $O(Q)$, so $|sigma_2(alpha)| = O(Q)$, and therefore
$ |N(alpha)| = |sigma_1(alpha)| dot |sigma_2(alpha)|^2 = O(1 slash Q^2) dot O(Q^2) = O(1) . $
*Bounded, uniformly in $Q$* --- the exact analogue of $|p^2 - d q^2| <= 1 + 2 sqrt(d)$, and for the
same reason: one linear form is made small, the others are controlled by the coefficient size, and
the norm is their product.

*The pigeonhole.* Infinitely many $alpha$ with $|N(alpha)| <= B$; finitely many values of
$N(alpha)$ and, for each, finitely many residues modulo it. So two of them, $alpha$ and $beta$,
share both. Now $N(alpha) slash alpha = product_(i eq.not 1) sigma_i (alpha)$ is an algebraic
integer lying in $K$, hence in $cal(O)_K$: that is, $alpha divides N(alpha)$ in $cal(O)_K$. Writing
$beta = alpha + N(alpha) gamma$ gives $beta slash alpha = 1 + (N(alpha) slash alpha) gamma in
cal(O)_K$, and symmetrically $alpha slash beta in cal(O)_K$. So $beta slash alpha$ is a unit; taking
the $alpha$ with $|sigma_1(alpha)|$ strictly decreasing makes it $eq.not plus.minus 1$. #h(2mm) $qed$

Check 4 runs exactly this. For $f = x^3 - x - 1$, $x^3 - 2$, $x^3 - x^2 + x + 1$, $x^3 - 3$ with
$Q$ up to $40$, the observed $max |N(alpha)|$ is $1, 6, 2, 16$ --- bounded, as promised --- and the
first collision produces in each case a genuine unit of infinite order, a power of $epsilon$.

Note what did *not* change: the norm identity, the pigeonhole, the divisibility $alpha divides
N(alpha)$, the conclusion. What changed is that the box has two free coordinates instead of one.

= The ledger: what actually differs <sec-ledger>

Setting the two proofs side by side, here is everything that is genuinely different.

+ *Non-Galois, and it is forced (@sec-which).* In $QQ(sqrt(d))$ the conjugation $u |-> u'$ is a
  field automorphism, so $"Tr"(u)$ and $N(u)$ are computed inside $K$ and @sec-discrete and
  @sec-quad never leave it. In a complex cubic the other two conjugates are not in $K$; one works
  with the embeddings. *This is the one real cost*, and no choice of cubic field avoids it.

+ *The pigeonhole is $2$-dimensional.* Dirichlet's approximation theorem becomes its linear-form
  version in two variables. Conceptually free; notationally heavier.

+ *The sign of $N(epsilon)$ (check 5).* In a quadratic field $N(-1) = +1$, so multiplying by $-1$
  cannot change the norm and $N(epsilon) = plus.minus 1$ is a genuine invariant --- the solubility
  of the negative Pell equation $x^2 - d y^2 = -1$. In a cubic field $N(-1) = -1$, so $epsilon$ and
  $-epsilon$ have opposite norms and the sign is normalisable away: *there is no negative Pell
  problem for complex cubics.* The quadratic invariant is genuinely hard: every prime factor of $d$
  must be $2$ or $equiv 1 space (mod 4)$, but that is not sufficient and no congruence in $d$
  decides it --- check 5 exhibits $d = 34, 146, 194, 205, 221$ passing the test and still failing.

+ *Constructive theory.* This is where real quadratic is genuinely privileged. The continued
  fraction of $sqrt(d)$ is eventually periodic, and its period *produces* the fundamental unit ---
  an algorithm, with a clean termination proof, known for centuries. The cubic substitute is
  Voronoi's algorithm, and it is much harder: there is no periodicity theorem of comparable
  simplicity, and the subject arrives some two hundred years later. If "easier" is read
  algorithmically rather than logically, the gap is wide.

+ *Artin's inequality (check 6).* Complex cubics have a bound with no quadratic analogue: for the
  fundamental unit $epsilon > 1$ at the real place,
  $ |d_K| <= 4 epsilon^3 + 24 , wide "so" wide epsilon >= ((|d_K| - 24) slash 4)^(1 slash 3) . $
  Verified on $403$ fields with $|d_K| <= 3000$, no violations, and essentially sharp --- the ratio
  reaches $0.9936$ at $x^3 + 7x - 1$. So a complex cubic's fundamental unit is bounded *below* by
  its discriminant, which is why its regulator cannot be small.

+ *Size of the regulator (check 7).* For $d <= 1000$ the largest real quadratic regulator is
  $68.80$ at $d = 991$, at the scale of $sqrt(d)$; for $|d_K| <= 1000$ the largest complex cubic
  regulator is $12.51$, at the scale of $log |d_K|$. The lower bound is Artin's theorem; the upper
  contrast is only what is observed here. In both families $h dot R$ grows like $|d_K|^(1 slash 2)$,
  and what differs is how the product splits between $h$ and $R$.

= Verdict <sec-verdict>

*Is there a simplified proof for real quadratic fields?* Yes, and it is short: @sec-discrete plus
@sec-quad, two pages, no Minkowski, no logarithmic embedding, no lattices.

*Is that because the field is quadratic?* No --- it is because the unit rank is $1$. The general
proof's expense is producing *independent* units, and there is nothing to be independent from.

*Is the rank-one cubic case more complicated?* Marginally, and the extra cost is exactly
identifiable: the field is necessarily non-Galois, so the argument must be run in the Minkowski
embedding rather than inside $K$, and the pigeonhole gains a dimension. Both proofs are the same
two steps and the second is no deeper than the first. Where the cubic case really does fall behind
is *algorithmically* --- continued fractions have no easy analogue --- and where it gets something
back is Artin's inequality, which has no quadratic counterpart.

= The checks <sec-gp>

`dirichlet-rank-one.gp`, run from the repository root; output in
`results/dirichlet-rank-one.txt`.

#table(columns: 2, stroke: 0.4pt, inset: 5.5pt, align: (center, left),
  [1], [the two rank-one families: signature, rank, $mu(K)$, and Galois or not],
  [2], [discreteness with no lattice theory --- the polynomials $X^2 - m X plus.minus 1$
       enumerated directly, reproducing $floor(log T slash log epsilon)$; and
       $|sigma_1| dot |sigma_2|^2 = 1$ for complex cubics],
  [3], [the real quadratic existence proof, run on convergents: $|p^2 - d q^2| < 1 + 2 sqrt(d)$,
       the collision, and the unit it yields as a power of $epsilon$],
  [4], [the complex cubic existence proof, run: the $2$-dimensional box principle,
       $max |N(alpha)|$ bounded as $Q -> 40$, the collision, the unit],
  [5], [$N(-1) = (-1)^n$; the negative Pell dichotomy for real quadratics, with the
       congruence condition shown necessary and *not* sufficient; and the cubic
       normalisation $N(-epsilon) = -N(epsilon)$],
  [6], [Artin's inequality $|d_K| <= 4 epsilon^3 + 24$ on $403$ complex cubic fields:
       no violations, sup ratio $0.9936$],
  [7], [largest regulator in each family, $|d_K| <= 1000$],
  [8], [no complex cubic among $403$ is Galois --- the structural difference, verified],
)

= References <sec-refs>

- Dirichlet's original route and the Pell connection: Borevich--Shafarevich, *Number Theory*, Ch. II;
  or Neukirch, *Algebraic Number Theory*, Ch. I for the general theorem via Minkowski.
- Continued fractions and Pell: Hardy--Wright, Ch. X; Cohen, *A Course in Computational Algebraic
  Number Theory*, Ch. 5 for the algorithmic side and Voronoi's algorithm for cubics.
- Artin's inequality for complex cubic fields: Delone--Faddeev, *The Theory of Irrationalities of
  the Third Degree*; also in Cohen's Ch. 6 discussion of unit computation in cubic fields.
- The companion note `dirichlet-mordell-weil.typ` treats the different question of whether Dirichlet
  splits into an arithmetic and a height half the way Mordell--Weil does.
