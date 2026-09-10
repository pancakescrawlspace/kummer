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
  #text(size: 16pt, weight: "bold")[Integral points on elliptic curves]
  #v(2mm)
  #text(size: 10pt)[Siegel, the elliptic logarithm method, and why the $p$-adic logarithm
  is the same argument in a different topology]
  #v(1mm)
  #text(size: 9pt, style: "italic")[checks in `integral-points.gp`]
]

#v(4mm)

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *The shape of the method.* Let $E slash QQ$ have Mordell--Weil generators $P_1, dots, P_r$ and
  write a point as $P = sum n_i P_i + T$. Two facts collide.

  #v(2mm)
  *From below:* the canonical height is a *quadratic form*, $hat(h)(P) = Q(n) asymp |n|^2$, and
  $h(x(P)) = hat(h)(P) + O(1)$. So a point with large coefficients is *enormous*, and if it is
  integral the size has nowhere to go but the numerator.

  #v(2mm)
  *From above:* "enormous" means "close to $cal(O)$", and the logarithm of the group law turns
  closeness to $cal(O)$ into a *linear form in logarithms* being small. Baker's theory says a
  non-zero linear form in logarithms cannot be that small.

  #v(2mm)
  The two estimates are incompatible once $|n|$ is large, which bounds $|n|$ --- effectively.
  *And this happens in every topology at once.* Over $RR$ the logarithm is the elliptic integral
  $psi(P) = integral_(x(P))^infinity (d t) slash (2 y)$ and "small" means small in absolute value;
  over $QQ_p$ it is the formal group logarithm and "small" means *divisible by a large power of
  $p$*. @sec-padic is that second half, and it is
  exactly what the $S$-integral case needs.
]

= Siegel's theorem, and why it is not enough <sec-siegel>

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Theorem (Siegel, 1929).* Let $E : y^2 = x^3 + A x + B$ with $A, B in ZZ$ and non-zero
  discriminant. Then $E$ has only finitely many points with $x in ZZ$. More generally, for a finite
  set $S$ of primes, only finitely many with $x in ZZ[1 slash S]$.
]

There are two proofs and neither produces a bound. The first runs through Diophantine
approximation: an infinite family of integral points would make $x(P)^(1 slash 2)$ approximate an
algebraic number too well, contradicting Thue--Siegel--Roth --- and Roth's theorem is *ineffective*,
it bounds the number of good approximations without locating them. The second reduces to unit
equations in a number field via Siegel's identity, and inherits ineffectivity from the same source.

So Siegel says the list is finite and gives no way to know when the list is complete. Everything
below is about repairing that.

= Heights: why integral points are gigantic <sec-heights>

Let $h(x) = log max(|"num"|, |"den"|)$ be the naive height and $hat(h)$ the canonical height,
normalised as $hat(h)(P) = lim_N h(x([2^N] P)) slash 4^N$, so that

$ hat(h)(P) = h(x(P)) + O(1) , quad quad hat(h)(sum n_i P_i + T) = Q(n) $

with $Q$ a positive-definite quadratic form on $ZZ^r$ (the Néron--Tate pairing). Two consequences,
and they are the whole reason the method exists.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  + $hat(h)$ *is exactly quadratic*: $hat(h)(n P) = n^2 hat(h)(P)$, with no error term. Checked to
    $30$ decimal places for $n <= 30$ in @sec-gp.
  + For an *integral* point $"den"(x(P)) = 1$, so $log |x(P)| = h(x(P)) = Q(n) + O(1)$. An integral
    point whose coefficients have size $N$ has $|x| approx e^(c N^2)$.
]

On the running example $E : y^2 = x^3 - 16 x + 16$ (a model of `37a1`, the one whose formal group
is computed in `analytic-local.typ` §8), $E(QQ) = ZZ P_0$ with $P_0 = (0,4)$ and
$hat(h)(P_0) = 0.05111$. So an integral point $n P_0$ would need
$ log|x| approx 0.0511 space n^2 , quad "i.e." quad n = 20 ==> |x| approx 10^9 , quad
  n = 40 ==> |x| approx 10^(35) . $
A search over $|x| <= 10^6$ finds *twelve* integral points, and every one is $n P_0$ with
$|n| <= 6$:

#align(center, table(
  columns: 7, align: (center,)*7,
  stroke: 0.4pt + luma(170), inset: (x: 8pt, y: 3.5pt),
  table.header([$x$], [$-4$], [$0$], [$1$], [$4$], [$8$], [$24$]),
  [$P$], [$-3P_0$], [$P_0$], [$-5P_0$], [$2P_0$], [$-4P_0$], [$6P_0$],
))

#v(2mm)
That is the phenomenon to be *proved*, not merely observed: the coefficients stop at $6$.

= The archimedean half <sec-arch>

$E(RR)$ is a real Lie group, $E(RR)^0 tilde.equiv RR slash omega ZZ$, and the isomorphism is the
*elliptic logarithm*
$ psi(P) = integral_(x(P))^infinity (d t) / (2 sqrt(t^3 + A t + B)) quad (mod omega) . $
It is a homomorphism, so $psi(P) equiv sum n_i psi(P_i) space (mod omega)$ --- a linear form in
elliptic logarithms with integer coefficients.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Large $x$ means small logarithm.* For $x(P) --> + infinity$,
  $ psi(P) = integral_(x(P))^infinity (d t) / (2 sqrt(t^3 (1 + O(1 slash t))))
    = x(P)^(-1 slash 2) (1 + O(1 slash x(P))) . $
  Combined with @sec-heights: an integral point with coefficients of size $N$ has
  $ |psi(P)| approx exp(- 1/2 Q(n)) approx exp(-c N^2) . $
]

Verified numerically in @sec-gp: at $n = 16$, $x = 454.54$ and $|psi| = 4.690489 times 10^(-2)$
against the prediction $x^(-1 slash 2) = 4.690453 times 10^(-2)$ --- five figures.

Now the lower bound. S. David's theorem on linear forms in elliptic logarithms gives, for a
non-vanishing form,
$ |sum n_i psi(P_i) + m omega| >= exp(-C (log N + 1)(log log N + 1)^(r+2)) $
with $C$ explicit in the curve data. Against $exp(-c N^2)$ this forces
$c N^2 <= C (log N)(log log N)^(r+2)$, hence $N <= N_0$ --- *effective*, and typically
$N_0 approx 10^(20)$ to $10^(40)$.

= The $p$-adic half <sec-padic>

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *Why one needs it at all.* Write $h(x(P)) = sum_v log^+ |x(P)|_v$. For an $S$-integral point the
  finite places contributing are exactly those in $S$, so
  $ hat(h)(P) + O(1) = log^+|x(P)|_infinity + sum_(p in S) (-v_p (x(P)))^+ log p . $
  That is $|S| + 1$ terms summing to something of size $Q(n)$, so *one of them* is at least
  $Q(n) slash (|S|+1)$. Either the archimedean term is huge --- and @sec-arch applies --- or some
  $p in S$ carries the size in the *denominator*, where the archimedean argument sees nothing at
  all. For plain integral points only the first case occurs; for $S$-integral points the second is
  unavoidable, and it needs a $p$-adic logarithm.
]

== The formal group, and the dictionary <sec-formal>

Let $p$ be odd, of good reduction. In the chart at infinity $z = -x slash y$, $w = -1 slash y$
(the coordinates of `analytic-local.typ` §8), the kernel of reduction is
$ E_1 (QQ_p) = { P : v_p (z(P)) >= 1 } tilde.equiv hat(E)(p ZZ_p) , $
and the formal logarithm
$ log_E (z) = integral omega = z + sum_(k >= 2) c_k z^k / k , quad c_k in ZZ_p , $
converges on $p ZZ_p$ and is an isomorphism $E_n (QQ_p) tilde.equiv p^n ZZ_p$ of groups.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *The dictionary.* For $P in E_1 (QQ_p)$, $p$ odd,
  $ v_p (log_E P) = v_p (z(P)) = - v_p (x(P)) slash 2 . $
  #v(2mm)
  _Proof._ The valuations $v_p (z) = n$, $v_p (x) = -2n$, $v_p (y) = -3n$ are equivalent by
  $z = -x slash y$ and the Weierstrass equation. For the first equality, the $k$-th term of the
  series has $v_p (c_k z^k slash k) >= k n - v_p (k)$, and $k n - v_p (k) > n$ for every $k >= 2$
  once $p >= 3$ and $n >= 1$ --- because $(k-1) n >= k - 1 > log_p k >= v_p (k)$. So the linear
  term strictly dominates. $qed$
]

So the two statements

#align(center)[
  *"$x(P)$ has $p^(2m)$ in its denominator"* #h(8mm) and #h(8mm)
  *"$log_p (P) equiv 0$ mod $p^m$"*
]

#v(1mm)
are *the same statement*. Checked on $214$ instances across five curves in @sec-gp, with no
exception. ($p = 2$ needs $v_2 (z) >= 2$ for the proof above, the $k = 2$ term being the culprit;
in the instances tested it holds anyway.)

Since $log_p$ is a homomorphism on $E_1 (QQ_p)$, and $c P in E_1 (QQ_p)$ for $c$ killing the
reduction, the quantity
$ log_p (c P) = sum_i n_i space log_p (c P_i) $
is a *linear form in $p$-adic elliptic logarithms* --- and $S$-integrality with a large $p$-power
denominator says precisely that this linear form is divisible by a large power of $p$. That is the
$p$-adic mirror of "$|psi|$ is tiny", and the bound that contradicts it is the $p$-adic theory of
linear forms in logarithms (Yu Kunrui in the multiplicative case; the elliptic analogue in the work
of Rémond--Urfels and, for the algorithm, Smart).

== Where the denominators actually come from <sec-denom>

The dictionary makes a concrete prediction that is worth seeing, because it explains the pattern of
$S$-integral points completely.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  $n P_0$ first acquires $p$ in its denominator exactly when $n$ reaches the *order of
  $tilde(P)_0$ in $tilde(E)(bb(F)_p)$* --- that being when $n P_0$ first lands in the kernel of
  reduction --- and thereafter
  $ v_p ("den" space x(n P_0)) = 2 (1 + v_p (n slash n_0)) , quad n_0 = "ord"(tilde(P)_0) . $
]

Both halves check out exactly on the running example (@sec-gp, check 4):

#align(center, table(
  columns: 12, align: (center,)*12,
  stroke: 0.4pt + luma(170), inset: (x: 5pt, y: 3.5pt),
  table.header([$p$], [$3$], [$5$], [$7$], [$11$], [$13$], [$17$], [$23$], [$29$], [$31$], [$43$],
    [$59$]),
  [first $n$], [$7$], [$8$], [$9$], [$17$], [$16$], [$18$], [$11$], [$12$], [$18$], [$14$], [$13$],
  [$"ord" tilde(P)_0$], [$7$], [$8$], [$9$], [$17$], [$16$], [$18$], [$11$], [$12$], [$18$],
    [$14$], [$13$],
))

#v(2mm)
Note $p = 23$: the order is $11$, not $\#tilde(E)(bb(F)_(23)) = 22$. It really is the order of the
point, not the size of the group.

== $S$-integral points, listed <sec-sint>

Everything above now reads off. Enlarging $S$ admits exactly the multiples whose denominator is
supported on $S$, and it does so one at a time:

#align(center, table(
  columns: 2, align: (left, left),
  stroke: 0.4pt + luma(170), inset: (x: 8pt, y: 3.5pt),
  table.header([$S$], [$n$ with $n P_0$ $S$-integral, $1 <= n <= 60$]),
  [$emptyset$], [$1, 2, 3, 4, 5, 6$],
  [${2}$], [$1, dots, 6, space 10$],
  [${3}$], [$1, dots, 6, space 7$],
  [${5}$], [$1, dots, 6, space 8$],
  [${2,3}$], [$1, dots, 6, space 7, 10$],
  [${2,3,5}$], [$1, dots, 6, space 7, 8, 10$],
  [${2,3,5,7}$], [$1, dots, 10$],
  [${2,3,5,7,11,13,17,23,29}$], [$1, dots, 12, space 16$],
))

#v(2mm)
The new arrivals are exactly the $n_0$ of @sec-denom: $3$ brings in $n = 7$, $5$ brings in $n = 8$,
$7$ brings in $n = 9$, $2$ brings in $n = 10$. Siegel's theorem for $S$-integral points is the
statement that this list stays finite however large $S$ gets --- and the $p$-adic method is what
bounds it.

== Rank two, where it is genuinely a linear form <sec-rank2>

In rank $1$ the "linear form" is a single term and the lattice picture is invisible. On `389a1`
($y^2 + y = x^3 + x^2 - 2x$, rank $2$) with $lambda_i = log_5 (c P_i)$, the condition
$v_5 (n_1 lambda_1 + n_2 lambda_2) >= m$ cuts $ZZ^2$ down to a *sublattice of index $5^(m-1)$*:

#align(center, table(
  columns: 5, align: (left, center, center, center, center),
  stroke: 0.4pt + luma(170), inset: (x: 8pt, y: 3.5pt),
  table.header([$m$], [$2$], [$3$], [$4$], [$5$]),
  [pairs with $|n_i| <= 12$], [$124$], [$24$], [$6$], [$2$],
  [predicted $624 slash 5^(m-1)$], [$124.8$], [$25.0$], [$5.0$], [$1.0$],
))

#v(2mm)
Each extra power of $p$ in the denominator thins the candidates by a factor of $p$. That is why the
final step of the algorithm is *lattice reduction*: David's bound leaves $N_0 approx 10^(30)$,
which is hopeless to enumerate, but LLL applied to the lattice of near-solutions (de Weger's
reduction) cuts $N_0$ to something like $10$ in two or three passes, after which one simply lists
the points. The archimedean and $p$-adic steps are reduced by the same machinery.

= What the method needs, and what it does not give <sec-limits>

#block(fill: rgb("#fff4e6"), inset: 8pt, radius: 3pt, width: 100%)[
  - *It needs Mordell--Weil generators.* A basis of $E(QQ) slash "tors"$, saturated. Computing rank
    is not unconditional in general --- descent gives it modulo finiteness of Ш --- so in practice
    the output is "complete, assuming the generators are". This is the real limitation, not the
    Baker bound.
  - *Baker's constants are astronomical.* $N_0 approx 10^(30)$ is useless on its own. The method
    works because LLL reduces it, and the reduction step is where the actual computing happens.
  - *It is specific to genus $1$.* For genus $>= 2$ one wants Chabauty--Coleman when
    $r < g$, and quadratic Chabauty beyond that --- which use $p$-adic integration on the curve
    rather than on its Jacobian's formal group, but rest on the same idea that a $p$-adic analytic
    function with too many zeros must vanish.
]

= What the companion script checks <sec-gp>

`integral-points.gp`, results in `results/integral-points.txt`. All counts zero.

#v(1mm)
- *(1)* $hat(h)(n P_0) = n^2 hat(h)(P_0)$ for $n <= 30$, to $30$ digits.
- *(2)* The twelve integral points with $|x| <= 10^6$, each identified as $n P_0$; the largest
  $|n|$ is $6$.
- *(3)* The dictionary $v_p (log_E P) = -v_p (x(P)) slash 2$ on $214$ instances --- five curves,
  all odd primes of good reduction dividing a denominator, multiples up to $12$.
- *(4)* First $n$ with $p$ in the denominator $=$ order of $tilde(P)_0$ in $tilde(E)(bb(F)_p)$,
  eleven primes; and the growth law $v_p("den") = 2(1 + v_p (n slash n_0))$ for every $n <= 60$
  divisible by $n_0$.
- *(5)* The $S$-integral table of @sec-sint.
- *(6)* $|psi(P)| = x(P)^(-1 slash 2)(1 + O(1 slash x))$, worst relative error $0.006$ over the
  sampled points with $x > 10$.
- *(7)* The rank-$2$ sublattice counts of @sec-rank2.

= References <sec-refs>

#block(inset: (left: 4pt))[
#set enum(numbering: "[1]")
+ J. H. Silverman, *The Arithmetic of Elliptic Curves*, 2nd ed., GTM 106. Ch. IV and VII for formal
  groups and the filtration $E_n (K)$ --- the source of @sec-formal; Ch. IX for Siegel's theorem,
  both proofs. The standard reference for everything in @sec-siegel and @sec-formal.
+ N. P. Smart, *The Algorithmic Resolution of Diophantine Equations*, LMS Student Texts 41, CUP
  1998. *The reference for this note*: Ch. XII--XIII give the elliptic logarithm method for
  integral points and the $p$-adic version for $S$-integral points, algorithmically and with
  worked examples.
+ R. J. Stroeker, N. Tzanakis, #link("https://doi.org/10.4064/aa-67-2-177-196")[*Solving elliptic
  Diophantine equations by estimating linear forms in elliptic logarithms*], Acta Arith. *67*
  (1994), 177--196; and J. Gebel, A. Pethő, H. G. Zimmer, *Computing integral points on elliptic
  curves*, Acta Arith. *68* (1994), 171--192. The two independent papers that made the method
  practical.
+ J. Gebel, A. Pethő, H. G. Zimmer, *Computing $S$-integral points on elliptic curves*, in ANTS-II,
  LNCS 1122 (1996), 157--171. The $S$-integral case --- @sec-padic --- worked out.
+ S. David, *Minorations de formes linéaires de logarithmes elliptiques*, Mém. Soc. Math. France
  *62* (1995). The lower bound used in @sec-arch.
+ K. Yu, *$p$-adic logarithmic forms and group varieties I--III*, J. reine angew. Math. *502*
  (1998) and later. The $p$-adic lower bounds.
+ B. M. M. de Weger, *Algorithms for Diophantine Equations*, CWI Tract 65, Amsterdam 1989. The LLL
  reduction step of @sec-rank2, without which none of it terminates in practice.
+ A. Baker, J. Coates, *Integer points on curves of genus 1*, Proc. Camb. Phil. Soc. *67* (1970),
  595--602. The first effective bound.
+ J. S. Balakrishnan, A. Besser, J. S. Müller, *Quadratic Chabauty: $p$-adic heights and integral
  points on hyperelliptic curves*, J. reine angew. Math. *720* (2016), 51--79. Where the genus
  $>= 2$ remark of @sec-limits leads.
]

= Where this touches the repository <sec-uses>

#align(center, table(
  columns: 2, align: (left, left),
  stroke: 0.4pt + luma(170), inset: (x: 7pt, y: 4pt),
  table.header([note], [relation]),
  [`analytic-local.typ` §8], [the same formal group on the same curve, and the theorem that makes
    $w(z)$ converge --- the licence for @sec-formal],
  [`integral-bm.typ`], [the *other* obstruction to integral points: Brauer--Manin rather than
    Baker. That note's $X$ has integral points ruled out by a reciprocity argument, not by a
    height bound],
  [`ec-padic-closure.typ`], [the structure of $E(QQ_p)$ and its filtration, which is what
    @sec-denom counts with],
  [`hensel-different.typ`], [the lifting threshold in the formal group, the same $p$-adic
    analyticity],
))
