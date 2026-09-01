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
  #text(size: 10pt)[Rank one, three times over --- real quadratic, complex cubic, totally
  imaginary quartic, and nothing else --- and exactly what each costs]
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
  *Which fields these are.* Rank $1$ says $r_1 + r_2 = 2$: *exactly two archimedean places.* Then
  $n = r_1 + 2r_2 = 2 + r_2 <= 4$, so the rank-one fields are confined to degrees $2, 3, 4$ with
  signatures $(2,0)$, $(1,1)$, $(0,2)$ --- real quadratic, complex cubic, *totally imaginary
  quartic* --- and there are no others in any degree (check 9). For all three *the very same proof
  runs*: checks 3, 4 and 12 run the three versions and they differ only in the dimension of the
  pigeonhole.

  #v(1.5mm)
  So the honest answer to "is the cubic case more complicated?" is: *yes, in exactly one structural
  way, and it is forced.* A Galois cubic is cyclic, and complex conjugation would be an element of
  order $2$ in a group of order $3$; so *every* rank-one cubic is non-Galois. In $QQ(sqrt(d))$ the
  conjugate $u'$ lies inside the field, and $"Tr"(u)$, $N(u)$ are visible there --- the whole
  argument happens inside $K$. In a complex cubic the other two conjugates live outside $K$ and one
  must work in the Minkowski embedding.

  #v(1.5mm)
  *The quartics add one genuinely new feature and one shortcut* (@sec-quartic). New: with no real
  embedding, $mu(K)$ is no longer $plus.minus 1$ --- $mu_4, mu_6, mu_8, mu_10, mu_12$ all occur, so
  $epsilon$ is only defined modulo torsion and "not a root of unity" must be tested as
  $|sigma_1(u)| eq.not 1$. Shortcut: if $K$ is *CM* its maximal real subfield is real quadratic and
  *also* of rank $1$, so by Hasse's unit index the whole question reduces to @sec-quad. The
  genuinely new quartics are the non-CM ones. Everything else that differs (@sec-ledger) is a matter
  of what the cases *support*, not of what the proof costs.
]

= Which fields have unit rank one <sec-which>

Dirichlet's theorem gives $cal(O)_K^times tilde.equiv mu(K) times ZZ^r$ with $r = r_1 + r_2 - 1$.
So $r = 1$ says $r_1 + r_2 = 2$: the field has *exactly two archimedean places*. Since
$n = r_1 + 2 r_2 = (r_1 + r_2) + r_2 = 2 + r_2$ and $r_2 <= 2$, this pins the degree:

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *The rank-one fields are exactly these three families, in these three degrees:*
  $ (r_1, r_2) = (2,0) : "real quadratic" , wide (1,1) : "complex cubic" , wide
    (0,2) : "totally imaginary quartic" . $
  There are none of unit rank $1$ in any degree $>= 5$.
]

Check 9 tabulates the signatures degree by degree and confirms this. The same computation explains
why all three proofs coincide: with $r_1 + r_2 = 2$ the logarithmic image sits in $RR^2$ and the
trace-zero condition $sum_v n_v log|u|_v = 0$ cuts out a *line*, so discreteness alone already gives
rank $<= 1$ and only existence is left to prove. In low degree:

#align(center)[
  #table(columns: 5, stroke: 0.4pt, inset: 6pt, align: (left, center, center, center, left),
    [field], [$(r_1, r_2)$], [$r$], [$mu(K)$], [sign of $d_K$],
    [real quadratic $QQ(sqrt(d))$, $d > 0$], [$(2,0)$], [$1$], [$plus.minus 1$], [$+$],
    [imaginary quadratic], [$(0,1)$], [$0$], [$mu_4$, $mu_6$, $plus.minus 1$], [$-$],
    [totally real cubic], [$(3,0)$], [$2$], [$plus.minus 1$], [$+$],
    [*complex cubic*], [$(1,1)$], [$1$], [$plus.minus 1$], [$-$],
    [totally real quartic], [$(4,0)$], [$3$], [$plus.minus 1$], [$+$],
    [quartic, one complex place], [$(2,1)$], [$2$], [$plus.minus 1$], [$-$],
    [*totally imaginary quartic*], [$(0,2)$], [$1$], [up to $mu_12$], [$+$],
  )
]

The first two rank-one families have a real embedding, so $mu(K) = {plus.minus 1}$ and there is
nothing to say about torsion. The third does not, and torsion becomes a genuine feature
(@sec-quartic). Check 1 tabulates the first two, check 10 the third.

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

= Rank one a third time: totally imaginary quartics <sec-quartic>

Signature $(0,2)$, $d_K > 0$, degree $4$. Everything above runs again, and two things are new.

*Torsion is no longer $plus.minus 1$.* This is the first place in the rank-one story where $mu(K)$
matters, and it is forced by the absence of a real embedding. $mu_m subset K$ needs $phi(m)
divides 4$; if $phi(m) = 4$ then $K = QQ(zeta_m)$ itself ($m = 5, 8, 10, 12$), and if $phi(m) = 2$
then $QQ(zeta_m)$ is an imaginary quadratic subfield ($m = 3, 4, 6$). Check 10 exhibits
$mu_4, mu_6, mu_8, mu_10, mu_12$. The conclusion $cal(O)_K^times = mu(K) times epsilon^ZZ$ is
unchanged, but $epsilon$ is only defined modulo torsion, and in the existence proof "not a root of
unity" has to be tested as $|sigma_1(u)| eq.not 1$ rather than $u eq.not plus.minus 1$.

*Discreteness is unchanged.* With two complex places, $1 = |N(u)| = |sigma_1(u)|^2 |sigma_2(u)|^2$,
so $|sigma_2(u)| = |sigma_1(u)|^(-1)$: one real parameter controls all four conjugates, exactly as
before, and bounded conjugates again mean bounded integer symmetric functions.

*Existence: the box principle a third time, now with a complex target.* There is no real embedding,
so the linear form we make small is *complex* and the pigeonhole target is two-dimensional. Among
the $(Q+1)^4$ values $sigma_1(alpha)$, $alpha = x_0 + x_1 theta + x_2 theta^2 + x_3 theta^3$ with
$0 <= x_i <= Q$, which lie in a disc of radius $O(Q)$, bucket by squares of side $delta = C slash Q$:
there are $O(Q^4 slash C^2)$ buckets against $(Q+1)^4$ points, so for $C$ large enough a collision
exists. Subtracting gives coefficients $O(Q)$ and
$ |sigma_1(alpha)| <= delta sqrt(2) = O(1 slash Q) , wide "hence" wide
  |N(alpha)| = |sigma_1(alpha)|^2 |sigma_2(alpha)|^2 = O(1 slash Q^2) dot O(Q^2) = O(1) . $
Then the same pigeonhole on $(N(alpha), alpha mod N(alpha))$, and the same divisibility
$alpha divides N(alpha)$ in $cal(O)_K$. Check 12 runs it for $Q <= 14$ and finds a unit of infinite
order in every case, with $max |N(alpha)|$ bounded throughout.

#block(fill: luma(243), inset: 9pt, radius: 3pt, width: 100%)[
  *The CM shortcut.* $K$ is *CM* iff it is totally imaginary with a totally real subfield $K^+$ of
  index $2$ --- for a quartic, $K^+$ is *real quadratic*, hence *also of unit rank $1$*. Then
  $cal(O)_(K^+)^times subset cal(O)_K^times$ with finite index, and Hasse's theorem says
  $ [thin cal(O)_K^times : mu(K) dot cal(O)_(K^+)^times thin] = Q in {1, 2} . $
  So for CM quartics the unit theorem *reduces to the real quadratic case of @sec-quad*, with
  nothing new to prove. Check 11 confirms $Q in {1,2}$, with $Q = 2$ realised at $QQ(zeta_12)$.

  #v(1mm)
  Check 12 sees this without being told: for $QQ(zeta_5)$ the unit its pigeonhole produces has
  $|sigma_1| = 1.618 dots$, the golden ratio; for $QQ(zeta_8)$ it is $2.414 dots = 1 + sqrt(2)$ ---
  the fundamental units of $QQ(sqrt(5))$ and $QQ(sqrt(2))$.
]

*So the genuinely new quartics are the non-CM ones.* A totally imaginary quartic fails to be CM
exactly when it has no real quadratic subfield --- either none at all (a *primitive* quartic, Galois
group $S_4$ or $A_4$) or only an imaginary one, whose units are finite and give nothing. Check 10
exhibits both: $x^4 + x + 1$ has group $S_4$ and $mu(K) = plus.minus 1$; $x^4 + 2x^2 + 2$ and
$x^4 - x^3 + 2x + 1$ have group $D_4$ with $mu_4$ and $mu_6$, so they contain $QQ(i)$ and
$QQ(zeta_3)$ respectively but no real quadratic subfield. On those fields the box principle of
check 12 is doing real work.

Note also that complex conjugation is an automorphism of $K$ precisely in the CM case. So the
non-Galois difficulty diagnosed for cubics in @sec-ledger recurs here, and in the same shape: the
fields where the argument can be run inside $K$ are exactly the ones where it does not need to be.

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

+ *Torsion, in the quartic case only (check 10).* A real embedding forces $mu(K) = plus.minus 1$,
  which is why the quadratic and cubic cases never mention it. Totally imaginary quartics realise
  $mu_4, mu_6, mu_8, mu_10, mu_12$, and $epsilon$ becomes well defined only modulo $mu(K)$.

+ *The CM reduction (check 11).* Unique to degree $4$: a CM quartic has a real quadratic subfield
  of unit rank $1$, and Hasse's index $Q in {1,2}$ makes its unit group that of $QQ(sqrt(d))$ up to
  torsion and a square root. Nothing analogous happens for cubics, which have no proper subfield
  at all.

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

*And the quartics?* Same again, with the pigeonhole target now two-dimensional. The one genuinely
new ingredient is torsion, which the two smaller cases are spared by having a real embedding; and
the CM half of the family is not new at all, since Hasse's index hands it back to @sec-quad. The
non-CM totally imaginary quartics are the only rank-one fields where the argument has to be run in
full, with no automorphism to lean on and no smaller field to descend to --- and even there it is
the same two steps.

*The general shape.* All three cases are: *two archimedean places, so the log image lies on a line;
discreteness is free; one unit of infinite order finishes it.* The degree only sets the dimension of
the box. That is the whole reason the theorem is easy here, and it stops at degree $4$ because
$r_1 + r_2 = 2$ cannot hold any higher.

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
  [9], [the rank-one classification, degree by degree: $(2,0)$, $(1,1)$, $(0,2)$ and nothing
       in any degree $>= 5$],
  [10], [totally imaginary quartics: $d_K$, $mu(K)$, Galois group, real quadratic subfield or
        not, CM or not --- $mu_4, mu_6, mu_8, mu_10, mu_12$ all realised],
  [11], [Hasse's unit index for the CM quartics: $Q in {1,2}$ in every case, $Q = 2$ at
        $QQ(zeta_12)$],
  [12], [the quartic existence proof, run: the $2$-dimensional bucket collision,
        $max|N(alpha)|$ bounded for $Q <= 14$, and a unit of infinite order in every case],
)

= References <sec-refs>

- Dirichlet's original route and the Pell connection: Borevich--Shafarevich, *Number Theory*, Ch. II;
  or Neukirch, *Algebraic Number Theory*, Ch. I for the general theorem via Minkowski.
- Continued fractions and Pell: Hardy--Wright, Ch. X; Cohen, *A Course in Computational Algebraic
  Number Theory*, Ch. 5 for the algorithmic side and Voronoi's algorithm for cubics.
- Artin's inequality for complex cubic fields: Delone--Faddeev, *The Theory of Irrationalities of
  the Third Degree*; also in Cohen's Ch. 6 discussion of unit computation in cubic fields.
- CM fields and Hasse's unit index $Q$: Washington, *Introduction to Cyclotomic Fields*, Ch. 4
  (where $Q$ is computed for cyclotomic fields), and Shimura for the general CM theory.
- The companion note `dirichlet-mordell-weil.typ` treats the different question of whether Dirichlet
  splits into an arithmetic and a height half the way Mordell--Weil does.
