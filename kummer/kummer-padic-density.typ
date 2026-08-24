#set page(paper: "a4", margin: (x: 2.2cm, y: 2.4cm), numbering: "1")
#set text(font: "New Computer Modern", size: 10.5pt)
#set par(justify: true)
#set heading(numbering: "1.")
#show raw.where(block: true): it => block(
  fill: luma(247), inset: 8pt, radius: 3pt, width: 100%, breakable: true,
  text(size: 8pt, it),
)
#show link: set text(fill: blue.darken(20%))

#align(center)[
  #text(size: 16pt, weight: "bold")[
    $p$-adic density of rational points on the Kummer surface
    $y^2 = f(x) f(t)$
  ]
  #v(2mm)
  #text(size: 10pt)[Computational notes --- witnesses for every prime $p <= 200$]
  #v(1mm)
  #text(size: 9pt, style: "italic")[computations in PARI/GP 2.18]
]

#v(4mm)

= Setup and the basic reformulation <sec-setup>

Let $f in QQ[x]$ be a cubic with no repeated root, let
$ E : v^2 = f(u) $
and let $X$ be the affine surface $y^2 = f(x) f(t)$. The map
$ ((u_1, v_1), (u_2, v_2)) |-> (x, t, y) = (u_1, u_2, v_1 v_2) $
identifies $X$ with the Kummer surface $(E times E) slash {plus.minus 1}$; resolving the
nine affine nodes $(e_i, e_j, 0)$ (with $f(e_i) = f(e_j) = 0$) gives a K3 surface.
Each exceptional curve is a conic with a rational point, hence a $PP^1$, so density on the
resolution is equivalent to density on $X$.

Because $-1$ acts *diagonally*, a $k$-point of $X$ lifts to a $k$-point of
$E_d times E_d$ for a *single* class $d$, where $E_d : d v^2 = f(u)$ is the quadratic twist.
Thus for any field $k$ of characteristic $!= 2$,
$ X(k) = union.sq.big_(d in k^times slash (k^times)^2) (E_d times E_d)(k) slash plus.minus. $

Concretely, two points $P = (u_1, v_1)$ and $Q = (u_2, v_2)$ on the *same* twist $E_d$ produce
the rational point
$ (x, t, y) = (u_1, u_2, d v_1 v_2) in X. $

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *Remark (the family of usable twists is complete).* A twist $E_d$ has an affine rational
  point $(u_0, v_0)$ exactly when $d$ is the squarefree part of $f(u_0)$. So
  $ {d : E_d (QQ) != {O}} = {"sqfreepart"(f(t_0)) : t_0 in QQ}, $
  which is precisely the family obtained from the canonical point $(t_0, 1) in E_(f(t_0))$.
  Nothing is lost by restricting to it.
]

= The density criterion <sec-criterion>

Write $H_d = overline(E_d (QQ)) subset.eq E_delta (QQ_p)$ for the closure of the rational points,
where $delta$ is the class of $d$ in $QQ_p^times slash (QQ_p^times)^2$.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Criterion.* $X(QQ)$ is dense in $X(QQ_p)$ if and only if for every
  $delta in QQ_p^times slash (QQ_p^times)^2$ the set
  $ union.big_(d |-> delta) H_d times H_d $
  is dense in $E_delta (QQ_p) times E_delta (QQ_p)$.

  #v(2mm)
  *Single-twist form.* If for each $delta$ there exists a single rational
  $d in delta dot (QQ_p^times)^2$ with $E_d (QQ)$ *dense in* $E_d (QQ_p)$, then $X(QQ)$ is dense
  in $X(QQ_p)$. For $p > 2$ this is *also necessary*, so the two forms agree.
]

For odd $p$ there are 4 classes, for $p = 2$ there are 8. So the whole problem reduces to
exhibiting 4 (resp. 8) elliptic curves per prime --- and for $p > 2$ nothing is lost in doing so.

_Proof of the sufficient form._ Let $(x_1, t_1, y_1) in X(QQ_p)$ with $y_1 != 0$, and let
$delta$ be the class of $f(x_1)$ (equivalently of $f(t_1)$). Choose $d$ as in the statement and
$c in QQ_p^times$ with $f(t_1) = d c^2$. The target lifts to the pair
$A = (x_1, y_1 c slash f(t_1))$, $B = (t_1, c)$ in $E_d (QQ_p)^2$. Approximate $A, B$ by rational
points $A', B' in E_d (QQ)$; then $(u(A'), u(B'), d v(A') v(B'))$ is a rational point of $X$ close
to $(x_1, t_1, y_1)$. Points with $y_1 = 0$ and the nodes are limits of such points. $qed$

Since $y |-> -y$ is an automorphism of $X$ defined over $QQ$, both sheets over a given $(x, t)$
are reached, so density of the image in the $(x, t)$-plane already suffices.

_Proof of necessity for $p > 2$._ Put $G = E_delta (QQ_p) tilde.equiv ZZ_p times T$ with $T$
finite. Since $p > 2$ we have $mu_p subset.not QQ_p$, so by the Weil pairing $E[p](QQ_p)$ is
cyclic; hence the $p$-part of $T$ is cyclic and *$G$ has at most two topological generators*.
Choose topological generators $P, Q$ of $G$. As $G$ is infinite they are not both 2-torsion, so
$(P,Q) != (-P,-Q)$ and $E_delta times E_delta -> X$ is a local homeomorphism near $(P,Q)$.

If $X(QQ)$ is dense there are rational points arbitrarily close to the image of $(P,Q)$. Being in
the square class $delta$ is an open condition, so such a point lies in the $delta$-part and lifts
to a pair $(P', Q') in E_d (QQ)^2$ for some rational $d$ in the class $delta$, with $(P',Q')$
close to $(P,Q)$. The Frattini subgroup $Phi(G)$ is open and $G slash Phi(G)$ finite discrete, so
once $(P',Q')$ is close enough, $P' equiv P$ and $Q' equiv Q$ modulo $Phi(G)$ and hence $P', Q'$
topologically generate. Therefore
$overline(E_d (QQ)) supset.eq overline(⟨P', Q'⟩) = G$. $qed$

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *Why $p > 2$.* At $p = 2$ one has $mu_2 subset QQ_2$, full 2-torsion can be rational, and
  $G tilde.equiv ZZ_2 times (ZZ slash 2)^2$ needs *three* topological generators --- while the
  Kummer surface only ever supplies *pairs* of points, so the argument breaks. This is not vacuous:
  it happens exactly when $f$ splits completely over $QQ_2$, as for $f = x^3 - x$. For both curves
  studied here it does not: $x^3 + x + 1$ and $x^3 - 2$ are irreducible over $QQ_2$, so there is no
  rational 2-torsion, $T$ has odd order, and $G$ again needs at most two generators. The criterion
  is thus an equivalence at *every* prime for these two surfaces.
]

Two consequences. Every positive result below is sharp --- exhibiting the four (or eight) twists
does not merely suffice for density, it is what density means. And a *failure* to find one twist
in some class is then evidence for genuine non-density, not merely a failure of the method; this
is what @sec-cm-resid exploits at $p = 3$.

== Local structure: testing "$Gamma$ dense in $E_d (QQ_p)$" <sec-local>

Work on a *minimal* Weierstrass model. Let $E_n (QQ_p)$ be the standard filtration
($E_1$ = kernel of reduction). Two standard facts:

- $E_1 (QQ_p) tilde.equiv hat(E)(p ZZ_p) tilde.equiv ZZ_p$ for $p >= 3$; at $p = 2$ one must go
  one step down and use $E_2 (QQ_2) tilde.equiv hat(E)(4 ZZ_2) tilde.equiv ZZ_2$.
- $M := \#(E(QQ_p) slash E_1 (QQ_p)) = c_p dot \#tilde(E)^"ns" (bb(F)_p)$, where $c_p$ is the
  Tamagawa number and $\#tilde(E)^"ns" (bb(F)_p) = p + 1 - a_p$ (good reduction) or $p - a_p$
  (bad reduction, with $a_p in {0, plus.minus 1}$ recording additive / split / non-split).

Hence, for a subgroup $Gamma subset.eq E_d (QQ)$:

$ overline(Gamma) = E_d (QQ_p) quad <==> quad
  cases(
    Gamma arrow.r.twohead E(QQ_p) slash E_1 (QQ_p) quad "(index" = M")",
    Gamma inter E_1 subset.eq.not E_2 .
  ) $

The second condition is checked pointwise: for $Q in E_1$ one has $v_p (x(Q)) = -2 n$ where
$n = v_p (z(Q))$ for the formal parameter $z = -x slash y$, so $Q$ topologically generates $E_1$
iff $v_p (x(Q)) = -2$ exactly. Both conditions are finite exact computations.

*Consequence used later.* If $tilde(E)_delta (bb(F)_p)$ is *non-cyclic* then $E_delta (QQ_p)$ is
not procyclic and no single point can generate: a twist of rank $>= 2$ (or with torsion) is
forced. This really happens --- see $p = 47, 67$ in @tab-primes.

== $S$-adic density <sec-sadic>

Let $S$ be a finite set of places and $X(QQ_S) = product_(p in S) X(QQ_p)$ with the product
topology; likewise $E_d (QQ_S) = product_(p in S) E_d (QQ_p)$. Square classes now come in tuples,
$arrow(delta) = (delta_p)_(p in S) in product_(p in S) QQ_p^times slash (QQ_p^times)^2$, and by
weak approximation every tuple is the class of some rational $d$. Write
$H_d^S = overline(E_d (QQ)) subset.eq E_d (QQ_S)$.

A rational point of $X$ still lies in a single global $d$-part, so its image in $X(QQ_S)$ lies in
the component indexed by the tuple of classes of $d$. The components are open, so density may be
tested one tuple at a time, and the argument of this section goes through verbatim:

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Criterion.* $X(QQ)$ is dense in $X(QQ_S)$ if and only if for every tuple $arrow(delta)$ the set
  $ union.big_(d |-> arrow(delta)) H_d^S times H_d^S $
  is dense in $E_(arrow(delta)) (QQ_S) times E_(arrow(delta)) (QQ_S)$.
]

Three progressively simpler conditions sit underneath it, and it is worth separating them because
they are *not* equivalent:

#table(
  columns: (auto, 1fr), align: (left, left), stroke: 0.4pt + luma(150),
  table.header([condition], [status]),
  [(P) for each $arrow(delta)$, some $d$ has $E_d (QQ)$ dense in the *product* $E_d (QQ_S)$],
    [always *sufficient*; necessary iff $E_(arrow(delta))(QQ_S)$ is topologically 2-generated],
  [(F) for each $arrow(delta)$, some $d$ has $E_d (QQ)$ dense in *each* $E_d (QQ_p)$ separately],
    [weaker than (P) in general; equivalent to it under coprimality],
)

(P) is sufficient for the same one-line reason as at a single place: approximate the two
coordinates of a target pair separately. (F) is genuinely weaker --- a closed subgroup of a product
can surject onto every factor without being the whole product.

#block(fill: rgb("#fff4e6"), inset: 8pt, radius: 3pt, width: 100%)[
  *(F) does not imply (P).* Take $f = x^3 + x + 1$, $d = 1$ (curve 496a: rank 1, trivial torsion,
  generator $(0,1)$) and $S = {5, 7}$. Here $M_5 = 9$ and $M_7 = 5$, so
  $E(QQ_5) tilde.equiv ZZ_5 times T_5$ with $|T_5|$ dividing 9, and
  $E(QQ_7) tilde.equiv ZZ_7 times ZZ slash 5$. Then
  $ E(QQ_5) slash 5 times E(QQ_7) slash 5 tilde.equiv bb(F)_5 times bb(F)_5, $
  because $ZZ_7$ is 5-divisible while $T_7 tilde.equiv ZZ slash 5$ survives. A *cyclic* group
  cannot surject onto $bb(F)_5^2$, so $overline(E(QQ))$ is a proper subgroup of the product ---
  even though $E(QQ)$ is dense in $E(QQ_5)$ and in $E(QQ_7)$ separately.
]

The obstruction is visibly one of shared torsion, and that is all it is:

*Lemma (Goursat).* If the profinite groups $E_d (QQ_p)$, $p in S$, have pairwise coprime
supernatural order, then a closed subgroup of $product_p E_d (QQ_p)$ surjecting onto every factor
is the whole product. Since $E_d (QQ_p) tilde.equiv ZZ_p times T_p$ has supernatural order
$p^infinity dot |T_p|$ and $T_p$ embeds in $E_d (QQ_p) slash E_1$, coprimality is implied by

$ (star) quad "the integers" p dot M_p (d), quad p in S, quad "are pairwise coprime." $

_Proof._ For two factors, let $N_i = H inter G_i$. Then $G_1 slash N_1 tilde.equiv G_2 slash N_2$
is a common quotient, hence trivial by coprimality, so $H = G_1 times G_2$; induct. $qed$

*Lemma (two generators).* $G_S = product_(p in S) E_d (QQ_p)$ is topologically generated by two
elements if and only if for every prime $ell$
$ [ell in S] + sum_(p in S) dim_(bb(F)_ell) E_d (QQ_p)[ell] <= 2 . $
This holds whenever $(star)$ does, together with the condition that $f$ does not split completely
over $QQ_2$ if $2 in S$ --- in particular whenever $2 in.not S$.

_Proof._ $G_S tilde.equiv (product_p ZZ_p) times product_p T_p$, and the displayed quantity is the
$ell$-rank of its Frattini quotient: $product_p ZZ_p$ contributes $bb(F)_ell$ exactly when
$ell in S$, and $T_p$ contributes $dim T_p [ell]$. Given $(star)$, at most one $p in S$ has
$ell divides p M_p$. If $ell in S$ that $p$ must be $ell$ itself, so the sum reduces to
$1 + dim E_d (QQ_ell)[ell]$, and $dim E_d (QQ_ell)[ell] <= 1$ for odd $ell$ because full
$ell$-torsion would force $mu_ell subset QQ_ell$; the excluded case $ell = 2 in S$ is exactly
$f$ splitting over $QQ_2$. If $ell in.not S$ the sum is a single $dim T_p [ell] <= 2$. $qed$

Putting the two lemmas together with the argument of @sec-criterion:

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Theorem.* Suppose $2 in.not S$ (or merely that $f$ does not split completely over $QQ_2$) and
  that $(star)$ holds for every $d$. Then
  $ X(QQ) " dense in " X(QQ_S) quad <==> quad
    forall arrow(delta) med exists d |-> arrow(delta) : E_d (QQ) " is dense in " E_d (QQ_p)
    " for every " p in S . $
]

_Proof._ ($arrow.l.double$) By $(star)$ and Goursat, factorwise density upgrades to density in
$E_d (QQ_S)$, which is (P), which is sufficient. ($arrow.r.double$) By the second lemma
$G = E_(arrow(delta))(QQ_S)$ has topological generators $P, Q$; they are not both 2-torsion at any
place, since each $E_d (QQ_p)$ is infinite, so $E_(arrow(delta))^2 -> X$ is a local homeomorphism
at $(P,Q)$ placewise. Density supplies rational points of $X$ near the image of $(P,Q)$; each lies
in the $arrow(delta)$-component, so lifts to a pair $(P', Q') in E_d (QQ)^2$ for some
$d |-> arrow(delta)$. The lift is only defined up to the *diagonal* sign at each place, so
$(P', Q')$ is close to $(epsilon P, epsilon Q)$ for some $epsilon in {plus.minus 1}^S$ acting
coordinatewise; but that is an automorphism of $G$, so $epsilon P, epsilon Q$ again generate
topologically, and closeness modulo the open subgroup $Phi(G)$ transfers this to $P', Q'$. Hence
$overline(E_d (QQ)) = G$, which gives factorwise density. $qed$

So under $(star)$ the $S$-adic question reduces to $|S|$ independent local questions, each of the
kind already solved in @sec-local. Without $(star)$ it does not: the example above shows the
places can interfere, and then one must control the joint closure $H_d^S$, not just its
projections.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *How restrictive is $(star)$?* It can fail identically on whole tuples, for a structural reason
  rather than a numerical accident. For $f = x^3 + x + 1$ and $S = {5, 7}$: in any tuple whose
  class at 7 is trivial one has $M_7 = 5$, so $7 M_7 = 35$ is divisible by 5, while $5 M_5$ is
  divisible by 5 for *every* $d$. Thus $(star)$ fails for all $d$ in those tuples --- 4 of the 16
  --- and `reportS` witnesses the other 12 but must return "undecided" there. Nothing is claimed
  about density in those components: a twist of rank $>= 2$ could still generate the product
  without $(star)$, since the coprimality hypothesis is only what makes *one* generator per factor
  suffice. Deciding them needs the joint closure.

  #v(1mm)
  In general $(star)$ asks that no $p in S$ divide $M_q (d)$ for another $q in S$, on top of the
  $M_p (d)$ being pairwise coprime; the first clause is the one that bites, since $M_q$ counts
  points on a reduction and is not under our control.
]

=== A criterion at finite level <sec-sadic-level>

For an actual computation one wants the criterion phrased in terms of congruences, and then one
wants the congruence level bounded. Let $E^d_n (QQ_p)$ be the $n$-th kernel of reduction, the
points reducing to the identity modulo $p^n$; these form a neighbourhood basis of $O$.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Criterion at level $n$.* $X(QQ)$ is dense in $X(QQ_S)$ if and only if for every $n >= 1$, every
  tuple $arrow(delta)$ and every $(P'_1, P'_2) in E_(arrow(delta))(QQ_S)^2$ there are a rational
  $d |-> arrow(delta)$, a sign tuple $epsilon in {plus.minus 1}^S$, and $P_1, P_2 in E^d (QQ)$
  with
  $ P_i - epsilon P'_i in product_(p in S) E^d_n (QQ_p) quad (i = 1, 2). $
]

The sign tuple is not decoration. A point of $X(QQ_p)$ is an orbit ${(P_1,P_2), (-P_1,-P_2)}$, and
the sign is chosen *independently at each place*, so a point of $X(QQ_S)$ determines a lift to
$E_(arrow(delta))(QQ_S)^2$ only up to $epsilon$. Demanding $P_i approx P'_i$ on the nose would be
strictly stronger than density, because the closures $H_d^S$ are stable under the *global* $-1$
but not under placewise sign changes.

*Can $n$ be bounded?* For a *single* twist, yes, and $n = 2$ is exactly right:

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Lemma.* $E^d (QQ)$ is dense in $E^d (QQ_S)$ if and only if it surjects onto the *finite* group
  $ B_d = product_(p in S) E^d (QQ_p) slash E^d_2 (QQ_p), quad
    \#B_d = product_(p in S) p dot M_p (d) $
  (with $E_3$ in place of $E_2$ at $p = 2$).
]

_Proof._ $E_2 = p E_1 subset.eq p G_p subset.eq Phi(G_p)$ for odd $p$, and Frattini subgroups
multiply over finite products, so $product_p E_2^((p)) subset.eq Phi(G_S)$. A subgroup surjecting
onto $G_S slash Phi(G_S)$ is dense; conversely a dense subgroup surjects onto every finite
quotient. $qed$

For the criterion as stated, which quantifies over $d$ *inside* the quantifier over targets, level
2 does not visibly suffice: knowing that $a$ and $b$ both lie in the image of $E^d (QQ)$ in $B_d$
does not put a deeper target inside $overline(E^d (QQ))$. It does suffice under one extra
hypothesis, and that hypothesis is checkable locally:

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Theorem.* Suppose $E_(arrow(delta))(QQ_S)$ is topologically 2-generated for every
  $arrow(delta)$ --- equivalently, for every prime $ell$ and every $arrow(delta)$,
  $ [ell in S] + sum_(p in S) dim_(bb(F)_ell) E_(delta_p) (QQ_p)[ell] <= 2 . $
  Then the following are equivalent: (i) $X(QQ)$ is dense in $X(QQ_S)$; (ii) the criterion at
  every level $n$; (iii) the criterion at level $n = 2$; (iv) for every $arrow(delta)$ some
  $d |-> arrow(delta)$ has $E^d (QQ)$ surjecting onto $B_d$.
]

_Proof._ (iv) $=>$ (i) is the sufficiency of (P), and (i) $=>$ (ii) $=>$ (iii) are immediate. For
(iii) $=>$ (iv), apply the level-2 criterion to a pair $(P'_1, P'_2)$ of topological generators of
$E_(arrow(delta))(QQ_S)$. The resulting $P_1, P_2 in E^d (QQ)$ satisfy
$P_i equiv epsilon P'_i$ modulo $product_p E_2^((p)) subset.eq Phi$; since $epsilon$ acts as an
automorphism, $epsilon P'_1, epsilon P'_2$ still generate topologically, so $P_1, P_2$ do too, and
$overline(E^d (QQ)) = E_(arrow(delta))(QQ_S)$. $qed$

Two remarks. First, 2-generation is *strictly weaker* than $(star)$, so this supersedes the
previous theorem: for $f = x^3+x+1$ and $S = {5,7}$ one has $ell$-ranks $2, 1, <= 2$ at
$ell = 5, 7, 3$, so $E(QQ_S)$ is 2-generated even though $(star)$ fails. Second, and importantly,
*the sufficient direction needs no hypothesis at all*: exhibiting one $d$ per tuple with
$E^d (QQ)$ surjecting onto $B_d$ proves density outright. Only the converse --- reading a failed
search as a genuine failure --- needs 2-generation.

*The computation.* `denseprod` in `sadic.gp` implements the lemma by the same triangular reduction
as `densegroup`, with the membership test taken at all places simultaneously; it was checked
against the provable coprimality test on 312 twists with no disagreement, and decides the 51 cases
that test left open. Searching by tuple:

#table(
  columns: 5, align: (center, center, center, center, left), stroke: 0.4pt + luma(150),
  table.header([$S$ (for $f = x^3+x+1$)], [tuples], [enumeration], [witnessed], [outcome]),
  [${5, 7}$],    [16], [$|d| <= 4000$],         [16], [*$X(QQ)$ is dense in $X(QQ_S)$*, 0.4 s],
  [${3, 5, 7}$], [64], [$|d| <= 6000$],         [46], [inconclusive],
  [${5, 7}$],    [16], [by tuple, $m <= 20000$], [16], [*$X(QQ)$ is dense in $X(QQ_S)$*, 0.3 s],
  [${3, 5, 7}$], [64], [by tuple, $m <= 20000$], [64], [*$X(QQ)$ is dense in $X(QQ_S)$*, 17 s],
)

The second row is not a failure but a starved search, and the fault is in the *enumeration*, not
in the surface. A tuple fixes the parity of $v_p (d)$ at each place, so the places of odd
valuation force a divisor $P_(arrow(delta)) = product {p : v_p (d) "odd"}$ of $d$; for
$S = {3,5,7}$ the eight all-odd tuples need $105 | d$, and a uniform sweep of $|d| <= 6000$ offers
those eight tuples 38 candidates in total --- four to six apiece --- while the tuple
$arrow(delta) = (1,1,1)$ gets the whole squarefree range. Every one of the eighteen tuples the
uniform sweep missed has $P_(arrow(delta)) > 1$.

Walking the same squarefree $d$ ordered by the *cofactor* instead --- $d = plus.minus
P_(arrow(delta)) m$ with $m$ squarefree and coprime to $S$ --- gives every tuple a comparable
supply, and all 64 fall, the hardest of them at $d = 31290$. This is `reportSprodtuples`; each
witness is a single full twist, so by the remark above the conclusion needs no hypothesis. Two
cheap filters keep it to 17 seconds: a twist with fewer than $g(arrow(delta))$ independent points
cannot surject onto $B_d$ --- $g$ is the minimal number of topological generators of the arena,
@sec-ledger, and it is a local computation needing no point search --- and density in the product
implies density in each factor, so three `densegroup` calls screen for each expensive
`denseprod`. Re-verified through the unfiltered
`twistdata` path, all 64 witnesses stand, and 24 of them are confirmed independently by the
coprimality criterion $(star)$.

*The witnesses.* One full twist per tuple, each certifying density in its own component of
$X(QQ_S)$ on its own; $u$ denotes any non-residue. For $S = {5,7}$, with the tuple read as
$(delta_5, delta_7)$ --- the same 16 components as the first row of the table above, now settled
in 0.3 s rather than 0.4:

#table(
  columns: 4, align: (left, right, left, right), stroke: 0.4pt + luma(150),
  table.header([tuple], [witness $d$], [tuple], [witness $d$]),
  [$(1, 1)$], [$51$], [$(5, 1)$], [$1730$],
  [$(1, u)$], [$-1$], [$(5, u)$], [$5$],
  [$(1, 7)$], [$-21$], [$(5, 7)$], [$595$],
  [$(1, u dot 7)$], [$91$], [$(5, u dot 7)$], [$770$],
  [$(u, 1)$], [$53$], [$(u dot 5, 1)$], [$-185$],
  [$(u, u)$], [$3$], [$(u dot 5, u)$], [$-85$],
  [$(u, 7)$], [$7$], [$(u dot 5, 7)$], [$-35$],
  [$(u, u dot 7)$], [$42$], [$(u dot 5, u dot 7)$], [$-210$],
)

And for $S = {3,5,7}$, the tuple read as $(delta_3, delta_5, delta_7)$:

#table(
  columns: 4, align: (left, right, left, right), stroke: 0.4pt + luma(150),
  table.header([tuple], [witness $d$], [tuple], [witness $d$]),
  [$(1, 1, 1)$], [$781$], [$(3, 1, 1)$], [$-789$],
  [$(1, 1, u)$], [$-11$], [$(3, 1, u)$], [$-519$],
  [$(1, 1, 7)$], [$-1169$], [$(3, 1, 7)$], [$3486$],
  [$(1, 1, u dot 7)$], [$3451$], [$(3, 1, u dot 7)$], [$1659$],
  [$(1, u, 1)$], [$3343$], [$(3, u, 1)$], [$16158$],
  [$(1, u, u)$], [$223$], [$(3, u, u)$], [$957$],
  [$(1, u, 7)$], [$-1883$], [$(3, u, 7)$], [$25977$],
  [$(1, u, u dot 7)$], [$1687$], [$(3, u, u dot 7)$], [$-987$],
  [$(1, 5, 1)$], [$3355$], [$(3, 5, 1)$], [$-20445$],
  [$(1, 5, u)$], [$55$], [$(3, 5, u)$], [$255$],
  [$(1, 5, 7)$], [$-2345$], [$(3, 5, 7)$], [$-6405$],
  [$(1, 5, u dot 7)$], [$25795$], [$(3, 5, u dot 7)$], [$-22470$],
  [$(1, u dot 5, 1)$], [$-185$], [$(3, u dot 5, 1)$], [$18615$],
  [$(1, u dot 5, u)$], [$-365$], [$(3, u dot 5, u)$], [$1335$],
  [$(1, u dot 5, 7)$], [$7315$], [$(3, u dot 5, 7)$], [$2415$],
  [$(1, u dot 5, u dot 7)$], [$-1085$], [$(3, u dot 5, u dot 7)$], [$1785$],
  [$(u, 1, 1)$], [$-451$], [$(u dot 3, 1, 1)$], [$366$],
  [$(u, 1, u)$], [$131$], [$(u dot 3, 1, u)$], [$-561$],
  [$(u, 1, 7)$], [$-511$], [$(u dot 3, 1, 7)$], [$15414$],
  [$(u, 1, u dot 7)$], [$581$], [$(u dot 3, 1, u dot 7)$], [$-714$],
  [$(u, u, 1)$], [$53$], [$(u dot 3, u, 1)$], [$5343$],
  [$(u, u, u)$], [$-127$], [$(u dot 3, u, u)$], [$-498$],
  [$(u, u, 7)$], [$15743$], [$(u dot 3, u, 7)$], [$21147$],
  [$(u, u, u dot 7)$], [$7973$], [$(u dot 3, u, u dot 7)$], [$9933$],
  [$(u, 5, 1)$], [$1730$], [$(u dot 3, 5, 1)$], [$-8805$],
  [$(u, 5, u)$], [$5$], [$(u dot 3, 5, u)$], [$-30$],
  [$(u, 5, 7)$], [$-6895$], [$(u dot 3, 5, 7)$], [$8295$],
  [$(u, 5, u dot 7)$], [$770$], [$(u dot 3, 5, u dot 7)$], [$-15645$],
  [$(u, u dot 5, 1)$], [$-985$], [$(u dot 3, u dot 5, 1)$], [$4785$],
  [$(u, u dot 5, u)$], [$290$], [$(u dot 3, u dot 5, u)$], [$510$],
  [$(u, u dot 5, 7)$], [$665$], [$(u dot 3, u dot 5, 7)$], [$31290$],
  [$(u, u dot 5, u dot 7)$], [$-4585$], [$(u dot 3, u dot 5, u dot 7)$], [$-210$],
)

Raw size is the wrong scale to read that table by. The median witness is $|d| = 1335$, but the
median *cofactor* $|d| slash P_(arrow(delta))$ is $131$ over the eight unramified tuples and $166$
over the other 56 --- indistinguishable. The spread in $|d|$ is the forced divisor and nothing
else, which is the whole point: once each tuple is searched on its own progression, no tuple is
harder than any other.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *Which surface.* All of §2.2 is computed for the *non-CM* curve $f = x^3 + x + 1$, which is
  dense at every prime $p <= 200$ (@tab-primes) and so has a chance at every $S$. The CM surface
  $f = x^3 - 2$ is a poor test case here: projection $X(QQ_S) -> X(QQ_p)$ is continuous and open,
  so density in the product forces density in each factor, and @sec-cm-resid says that fails at
  $p = 3$. Hence for $x^3 - 2$ every $S$ containing 3 fails immediately, and only $S$ avoiding 3
  is worth computing --- where, by @sec-cm, each factor is individually fine.
]

*What is left open.* Whether level 2 suffices *without* 2-generation. The obstruction is clear
enough --- the criterion allows a different $d$ for each target, so a $d$ that captures a target
modulo $E_2$ need not capture its refinements --- but I have neither a proof nor a
counterexample.

== Bookkeeping: covering $X(QQ_S)$ by twists <sec-ledger>

Once no single twist can do the job, verifying density becomes an accounting problem: each twist
contributes a piece of $X(QQ_S)$, and one must decide when the pieces exhaust it. What follows
fixes vocabulary for that. The one picture to hold on to is:

#align(center)[
  _for each tuple of square classes there is one fixed arena; every twist paints a subgroup into
  it; you win when the painted subgroups cover the arena pairwise._
]

*The arena.* For $arrow(delta) in Delta_S := product_(p in S) QQ_p^times slash (QQ_p^times)^2$
write
$ cal(G)_(arrow(delta)) := product_(p in S) E^(delta_p) (QQ_p), $
the *local group* at $arrow(delta)$. It depends only on $arrow(delta)$, not on any twist: all
rational $d$ with $[d]_S = arrow(delta)$ give canonically isomorphic $cal(G)$. This is the fixed
stage. Write $cal(G)_(arrow(delta))(n)$ for its level-$n$ truncation
$cal(G)_(arrow(delta)) slash product_p E_n (QQ_p)$, a *finite* abelian group of order
$product_p p^(n-1) M_p$.

*The reach.* For a rational $d$ with $[d]_S = arrow(delta)$,
$ R(d) := overline(E^d (QQ)) subset.eq cal(G)_(arrow(delta)) $
is the *reach* of $d$: how far the global points of that twist reach into the arena. It is a
closed subgroup. Call $d$ *full* if $R(d) = cal(G)_(arrow(delta))$ and *partial* otherwise;
@sec-sadic-level detects fullness at level 2.

*The patch.* A point of $X(QQ_S)$ over $arrow(delta)$ is a pair in $cal(G)^2$ modulo the *sign
group* $Sigma := {plus.minus 1}^S$, acting diagonally, $epsilon dot (a,b) = (epsilon a, epsilon b)$.
The twist $d$ contributes the *patch*
$ P(d) := "image of " R(d) times R(d) " in " X(QQ_S) . $
Since $epsilon$ acts on subgroups by $R |-> epsilon R$ and the global $-1$ fixes every reach, the
sign group acts through $Sigma slash {plus.minus 1}$, of order $2^(|S| - 1)$.

*The ledger.* Fix $arrow(delta)$ and a level $n$. As twists are examined, record their reaches:
$ cal(L) := {epsilon R_n (d) : d "examined", epsilon in Sigma}, $
closed under the sign group and pruned to its maximal members --- an antichain of subgroups of
the finite group $cal(G)(n)$. Closing under $Sigma$ is exactly what lets one forget the sign
ambiguity afterwards, since $epsilon a, epsilon b in R$ iff $a, b in epsilon^(-1) R$.

*Covered.* A pair $(a,b) in cal(G)(n)^2$ is *covered* by $cal(L)$ if some single $R in cal(L)$
contains both --- equivalently if $⟨a, b⟩ subset.eq R$ for some $R$. Then
$ X(QQ) " is dense in " X(QQ_S) quad <==> quad
  forall arrow(delta), forall n : "the full ledger covers every pair in " cal(G)_(arrow(delta))(n)^2 . $

Three things make this workable.

*The star test.* Checking all pairs is quadratic; checking stars is not. For $a in cal(G)(n)$ put
$ "St"(a) := union.big_(R in cal(L), space a in R) R . $
Then $cal(L)$ covers every pair if and only if $"St"(a) = cal(G)(n)$ for every $a$. The
*deficiency* $sum_a |cal(G)(n) without "St"(a)|$ is a progress meter that decreases as twists are
added, and is zero exactly on completion.

*The rank dichotomy.* Let $g(arrow(delta))$ be the minimal number of topological generators of
$cal(G)_(arrow(delta))$, computed locally as $max_ell ([ell in S] + sum_p dim E^(delta_p) (QQ_p)[ell])$.

#table(
  columns: 2, align: (left, left), stroke: 0.4pt + luma(150),
  table.header([$g(arrow(delta))$], [what the ledger can do]),
  [$<= 2$], [Covering forces some $R = cal(G)$: take $(a,b)$ a generating pair; it must lie in a
             single $R$, which is then dense. *Partial twists are useless* --- either a full twist
             exists or the class fails.],
  [$>= 3$], [A full twist still *suffices*, but now requires a twist of Mordell--Weil rank $>= 3$
             (or rank 2 with torsion) --- and it is no longer *necessary*, since partial patches
             may combine. This is the only regime in which the ledger does real work.],
)

So the bookkeeping is trivial exactly when $g <= 2$, and that is decidable locally before any point
search. Note carefully that $g >= 3$ does *not* mean no full twist exists: it only means one is no
longer forced. For $f = x^3+x+1$ and $S = {5,7}$ all sixteen tuples have $g <= 2$, and for
$S = {3,5,7}$ all 64 do (24 with $g = 1$, 40 with $g = 2$) --- consistent with @sec-sadic-level
finding a full twist for every tuple of both. For $S = {11,13,17}$, by contrast, all 64 tuples
have $g = 3$, since the cubic has a root in each of $QQ_11, QQ_13, QQ_17$; that is where the
ledger first does real work.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *Compute $g$ exactly, not from $M_p$.* The tempting shortcut is to read $ell | M_p$ as
  $ell$-torsion in $E^(delta_p)(QQ_p)$. It is not: $M_p = \#E(QQ_p) slash E_1$ counts a
  *quotient*, and $E(QQ_p) = ZZ_p$ with no torsion at all already has $M_p = 9$. Bounding
  $dim E[ell]$ by $v_ell (M_p)$ inflates $g$ --- it reports $g = 3$ for two tuples of ${5,7}$ and
  24 tuples of ${3,5,7}$ that in truth have $g <= 2$. `gexactS` computes $dim E^(delta_p)(QQ_p)
  [ell]$ properly and is still a purely local calculation: at good reduction with $ell != p$
  reduction is an isomorphism on $ell$-torsion, so `ellgroup` settles it; only $ell = p$, or
  $ell$ dividing the component group at additive reduction, needs a division polynomial.
]

*Monotonicity.* Truncation $cal(G)(n+1) -> cal(G)(n)$ is surjective and carries reaches onto
reaches, so coverage at level $n+1$ implies coverage at level $n$. Deficiency is therefore
monotone in $n$: work at the lowest level, refine only after it closes. A full twist is full at
every level, so once one is found the class is finished for good.

=== A worked ledger: $S = {11, 13, 17}$ <sec-ledger-worked>

At level 1 the arena is $cal(G)(1) = product_(p in S) E_(d_0)(QQ_p) slash E_1 (QQ_p)$, a finite
group of order $N = product_p M_p$. At a place of *good* reduction this is just
$tilde(E)_(d_0)(bb(F)_p)$ and the whole computation is finite-field arithmetic; but a place
$p in S$ with $p divides d_0$ is *additive* for $E_(d_0)$, and there $tilde(E)(bb(F)_p)$ is the
wrong group --- $M_p = c_p dot p$ counts components as well. Since 56 of the 64 tuples for
$S = {11,13,17}$ have $p divides d_0$ at some place, the arena must be built without assuming good
reduction. It is, by exhibiting explicit $QQ_p$-points and deduping them by $E_1$-membership
(@sec-arena-bad). Either way the bookkeeping on top is the same, and all elementary:

#table(
  columns: 2, align: (left, left), stroke: 0.4pt + luma(150),
  table.header([object], [data type]),
  [arena element], [an integer in $[0, N)$, $N = product_p M_p$, by mixed-radix packing of one
                    point-index per place],
  [reach], [a $0 slash 1$ vector of length $N$ --- the subgroup as a bitmap],
  [ledger], [a list of such bitmaps, closed under the sign group and pruned to an antichain],
  [membership mask], [for each arena element, the set of ledger indices containing it, packed as
                      one integer bitmask],
  [coverage], [the distinct masks pairwise AND to something non-zero],
)

Twists in one tuple give $QQ_p$-isomorphic curves, so the arena is fixed; a twist is transported
to the chosen representative by $(x,y) |-> (lambda^2 x, lambda^3 y)$ with
$lambda^2 = d_0 slash d$, which lies in $QQ_p$ *exactly because* $d$ and $d_0$ share the tuple.
Either square root serves --- the two differ by the sign action, which the ledger quotients by
anyway --- but the same one must be used for every point of a given twist, or the image is not a
subgroup. Running this for $f = x^3+x+1$, $d_0 = 1$, $S = {11,13,17}$:

#table(
  columns: 5, align: (right, right, right, right, right), stroke: 0.4pt + luma(150),
  table.header([twists used], [last reach], [ledger], [masks], [deficiency]),
  [5],   [2268], [4], [10], [74.8%],
  [30],  [9],    [9], [28], [55.9%],
  [40],  [126],  [4], [8],  [28.1%],
  [110], [---],  [4], [8],  [28.1%],
  [115], [2268], [7], [8],  [*0%*],
)

The arena has order $14 dot 18 dot 18 = 4536$ and $g = 3$: every $M_p$ is even, so its 2-part is
$(ZZ slash 2)^3$. *No twist encountered is full* --- the reaches are cyclic of order dividing
$"lcm"(14,18,18) = 126$ when the twist has rank 1, and of index 2 when it has rank 2 --- and yet
the ledger closes. It stabilises at exactly *seven* maximal reaches, each of index 2, which is
exactly the number of index-2 subgroups of $(ZZ slash 2)^3$.

That is the whole mechanism in miniature: a pair of arena elements generates a subgroup of
2-rank at most 2, hence lies in some hyperplane of the 2-part; so once all seven hyperplanes are
realised as reaches, every pair is covered. Partial patches do together what no single twist can,
which is exactly the regime the ledger was introduced for. Note also that the ledger *shrinks* at
several points (9 members down to 3) as a large new reach absorbs smaller ones --- pruning to the
antichain is doing real work --- and that the deficiency sits at $28.125% = 9 slash 32$ for
seventy twists before the last missing hyperplanes appear.

=== Grading the ledger, and why the flat one cannot prove anything <sec-ledger-graded>

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *The key point.* A flat ledger stores, for each twist, the image $overline(R)_n (d)$ at one fixed
  level. Its preimage $hat(R)_n (d)$ is an *over*-approximation of the reach, with
  $R(d) subset.eq hat(R)_n (d)$ and equality only when $R(d)$ happens to contain
  $ker_n := product_p E_n (QQ_p)$. Coverage computed from over-approximations is therefore only
  ever a *necessary* condition. That is why the refinement never terminates: passing to level
  $n+1$ can always destroy what level $n$ certified. *No amount of computing at a fixed level, or
  at every level in turn, can produce a proof.*
]

The repair is to make the level part of the datum, one level *per entry*.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Graded ledger.* An entry is a triple $(d, n_d, overline(R))$ with
  $ R(d) supset.eq ker_(n_d), quad quad overline(R) = "image of " R(d) " in " cal(G)(n_d) . $
  The first condition is the *certificate of exactness*: once the reach contains $ker_(n_d)$ it
  *equals* the preimage of $overline(R)$, so the finite datum determines $R(d)$ outright. Call
  $n_d$ the *granularity* of the entry.
]

Granularity is detectable: the index $[cal(G)(n) : overline(R)_n]$ is non-decreasing in $n$ and
equals $[cal(G) : R(d)]$ from the first $n$ with $R(d) supset.eq ker_n$ onwards. So compute indices
at successive levels and stop when the index repeats; that repetition *is* the certificate. A reach
of infinite index never stabilises and has no finite granularity; such entries are inadmissible.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Termination theorem.* Let $cal(L)$ be a *finite* graded ledger and $N = max_d n_d$. If
  $ union.big_((d, n_d, overline(R)) in cal(L)) overline(R)^((N)) times overline(R)^((N))
    = cal(G)(N)^2 , $
  then $union_d R(d) times R(d) = cal(G)^2$ exactly, and $X(QQ)$ is dense in $X(QQ_S)$.
]

_Proof._ Each entry has $R(d) supset.eq ker_(n_d) supset.eq ker_N$, so $R(d)$ is the full preimage
of $overline(R)^((N))$, and $R(d) times R(d)$ the full preimage of
$overline(R)^((N)) times overline(R)^((N))$. A union of full preimages is the full preimage of the
union, so covering at level $N$ pulls back on the nose. $qed$

So a *successful* search now stops, with a finite certificate: the twists, their granularities, and
their level-$N$ images. Failure still says nothing, exactly as before.

*Pruning across grades.* Inclusion is tested by inflating both entries to the finer level. Note the
direction: a *coarser* entry is a *larger* subgroup, since $hat(R)_m supset.eq hat(R)_n$ for
$m <= n$. So coarse entries absorb fine ones and never the reverse, and the antichain genuinely
improves as coarse twists are found. The pruning seen in @sec-ledger-worked, nine members falling
to three, is the flat shadow of this.

=== Places and layers: the $ell$-primary rewrite <sec-layers>

Two families of primes are now in play and must not be conflated. The *places* $p in S$ are where
we localise; the *layer primes* $ell$ are those dividing $\#cal(G)$. Picture the arena as a grid,
places indexing columns and layer primes rows, with cell $(p, ell)$ the $ell$-primary part of
$E^(delta_p) (QQ_p)$:

$ cal(G) = plus.big_ell cal(G)_ell, quad quad
  cal(G)_ell = plus.big_(p in S) cal(G)_(p, ell) . $

The grid is almost entirely finite. For $ell != p$ the cell is $T_p [ell^infinity]$, *finite*; only
the *diagonal* cells $ell = p$ are infinite, $cal(G)_(p,p) tilde.equiv ZZ_p times T_p [p^infinity]$.
And $ker_n = product_p E_n (QQ_p)$ is pro-$p$ at each place, so it lies *entirely on the diagonal*.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Granularity is diagonal.* Refinement in $n$ touches only the diagonal cells. Hence the
  granularity of an entry is a *vector* $(n_p)_(p in S)$, one per place, and off-diagonal data is
  exact from the outset --- there is nothing to refine there. In particular $n_p = 1$ exactly when
  the reach's $p$-layer is the whole of $cal(G)_(p,p)$.
]

When no place of $S$ divides $M_q$ for another place $q$, and $p tilde.not M_p$, the $p$-layer
collapses to $cal(G)_(p,p) = E_1 (QQ_p)$, and "$n_p = 1$" becomes exactly *condition (ii)* of
@sec-local: the subgroup meets $E_1 without E_2$ at $p$. That is already implemented. For
$S = {11,13,17}$ the hypothesis holds --- $M = (14, 18, 18)$ and none of $11, 13, 17$ divides any
of these --- so granularity 1 is testable directly.

*And it closes.* Re-running the ledger of @sec-ledger-worked while admitting *only* granularity-1
twists: of 119 twists inspected, 102 are admitted, and the ledger again stabilises at seven
maximal reaches of index 2 with deficiency $0$. Every admitted reach contains $ker_1$, so the
termination theorem applies with $N = 1$:

#block(fill: rgb("#eef4ff"), inset: 9pt, radius: 3pt, width: 100%)[
  For $f = x^3+x+1$, $S = {11,13,17}$ and the square-class tuple of $d_0 = 1$, the rational points
  of $X$ are *dense* in that component of $X(QQ_S)$ --- proved, from a finite certificate, with no
  full twist anywhere in sight.
]

Only $d = 1$ itself failed the granularity test among those checked; the rank-2 twists supplying
the seven hyperplanes all pass. The remaining 63 tuples for this $S$ are untouched, so density in
all of $X(QQ_S)$ is not claimed --- but the method now terminates when it succeeds, which is what
the flat ledger could never do.

*Representation.* Bitmaps over the arena die at once: at level 2 the arena for $S = {11,13,17}$
already has $11 dot 13 dot 17 dot 4536 approx 1.1 dot 10^7$ elements, at level 3 about
$2.7 dot 10^10$. But closures in a profinite abelian group decompose over primes,
$R = product_ell R_ell$ with $R_ell$ the $ZZ_ell$-span of the $ell$-components, and $ker_n$ is
pro-$p$ at each place, so contributes only at $ell = p$. An entry should therefore be a *tuple of
subgroups of the small $ell$-primary pieces*, with granularity recorded per place and membership
masks intersected prime by prime. The star test is unchanged; only the data type for a reach is.

#block(fill: rgb("#fff4e6"), inset: 8pt, radius: 3pt, width: 100%)[
  *Status.* The graded ledger is specified here, not implemented. The obstacle is not the
  bookkeeping but the index computation: the triangular method used throughout costs $O(N)$ in the
  size of the level-$n$ arena, already impractical at level 2 for three places and hopeless at
  level 3 --- a direct attempt timed out. Determining granularities needs the $ell$-primary
  rewrite first.
]

#block(fill: rgb("#fff4e6"), inset: 8pt, radius: 3pt, width: 100%)[
  *What this does and does not show.* Coverage here is at *level 1 only*. By monotonicity that is
  a necessary condition, so it is a real check, and the failure of any level would be decisive ---
  but it is not sufficient for density. Level 2 multiplies the arena by
  $11 dot 13 dot 17 = 2431$, to about $1.1 dot 10^7$ elements, well past bitmap range; there one
  must switch to the $ell$-primary representation, storing each reach as a tuple of subgroups of
  the small groups $cal(G)(2)_ell$ and intersecting membership masks prime by prime. The
  bookkeeping is identical; only the data type for a reach changes.
]

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *Two cautions.* (i) In practice one knows only a finite-index subgroup of $E^d (QQ)$, so the
  computed reach may be *smaller* than $R(d)$. The error is one-sided: coverage verdicts stay
  sound, non-coverage verdicts do not. (ii) The arena is large --- $|cal(G)(2)| = product_p p M_p$
  is already in the millions for three places --- so the ledger must store reaches by *generators*,
  with containment tested by linear algebra in the $ell$-primary pieces, never by listing
  elements. The star test is then run prime by prime.
]

=== Building the arena at bad reduction <sec-arena-bad>

Sweeping all 64 tuples for $S = {11,13,17}$ forces the issue the $d_0 = 1$ run could ignore. A
tuple is a choice of local square class $delta_p in QQ_p^times slash (QQ_p^times)^2$ at each
place, and $delta_p$ has odd valuation for 56 of the 64 --- meaning $p divides d_0$, so
$E_(d_0) : y^2 = x^3 + A d_0^2 x + B d_0^3$ is *additive* at $p$. Then
$tilde(E)_(d_0)(bb(F)_p)$ is not $cal(G)_p (1)$: the identity component contributes only
$tilde(E)^"ns" (bb(F)_p) tilde.eq bb(G)_a (bb(F)_p)$ of order $p$, and the component group
contributes the Tamagawa factor, giving $M_p = c_p dot p$.

So the arena is built from honest $QQ_p$-points instead:

+ Work on the *short* model $y^2 = x^3 + A d^2 x + B d^3$. For $d$ squarefree and $p >= 5$ it is
  already minimal at $p$, since $v_p (c_4) = v_p (-48 A d^2) <= 2 < 4$; hence the test
  $Q in E_1 <=> v_p (x(Q)) < 0$ is valid on it and no change of model is needed.
+ Every point outside $E_1$ has integral $x$, so sweep $x$ over $ZZ_p$ and solve the Weierstrass
  quadratic for $y$, keeping a new point whenever its difference from all reps so far lies in
  $E_1$. Stop at $M_p$ representatives.
+ Close the resulting set under the group law.

Both of the last two steps earn their place, and neither was obvious in advance.

*Depth.* A short range of integral $x$ does not suffice. At good reduction a coset is a residue
disc mod $p$ and $x in {0, ..., p-1}$ finds everything; at additive reduction the deep components
are cut out by congruences modulo $p^2$ or $p^3$, and sampling $|x| <= 200$ found only 21 of the
34 cosets for $d = 17$, $p = 17$. Sweeping residues mod $p^k$ with $k$ increasing, and stopping as
soon as $M_p$ cosets are in hand, costs nothing at good reduction ($k = 1$ suffices) and walks up
only as far as a bad place demands. Random sampling from $ZZ_p$ works too but makes the
representatives irreproducible, which is unacceptable in a certificate.

*The last coset.* Even sweeping to $k = 3$ the search stalls, always at exactly $M_p - 1$: the
missing coset sits near a root of the Weierstrass cubic, where $v_p (f(x_0))$ is large and its
parity, or the quadratic residue symbol of its unit part, can fail at every depth swept. Rather
than sweep deeper --- $17^5$ residues is already $1.4 dot 10^6$ --- note that the cosets found
still *generate*: closing under the group law recovers the remainder immediately. With both steps
all 64 arenas build to full size $M_p$ at every place.

The construction is validated against the old one where both apply: on the good-reduction tuple of
$d_0 = 1$ it reproduces @sec-layers exactly --- 119 twists inspected, 102 admitted, seven maximal
reaches of index 2, deficiency $0$.

*A caveat the $d_0 = 1$ tuple hides.* At an additive place $p divides M_p = c_p dot p$, so the
hypothesis "$p tilde.not M_p$" of the layer-collapse remark in @sec-layers fails there, and
$cal(G)_(p,p)$ is strictly larger than $E_1 (QQ_p)$ --- an extension of $ZZ slash p$ by $ZZ_p$.
This costs nothing, because the termination theorem is stated in *levels*, not layers: granularity
$1$ means the reach contains $ker_1 = product_p E_1 (QQ_p)$, and that is exactly condition (ii) of
@sec-local at every place, since a subgroup of $E_1 tilde.eq ZZ_p$ not contained in $E_2 = p E_1$
is all of $E_1$. No hypothesis on $M_p$ enters. The layer hypothesis governs how a reach is
*represented*, not whether the granularity test is valid.

=== Provenance, and the certificate <sec-cert>

A ledger entry is not just a reach but a triple $(overline(R), d, epsilon)$, recording which twist
$d$ and which sign $epsilon in Sigma = {plus.minus 1}^S$ produced it. The reason is that a closed
ledger is supposed to be a *finite certificate*, and a bitmap over the arena is not one: it asserts
coverage without saying what is covering. With provenance, a tuple that closes yields a short
explicit list --- for $d_0 = 1$, the seven hyperplanes come from the seven twists

$ d in {-1590, -519, -127, 53, 586, 1730, 1923}, $

each of rank 2, each with $epsilon = (+,+,+)$, each of index 2 in the arena of order $4536$. That
list, together with generators of $E^d (QQ)$ for those seven $d$, is checkable independently of the
search that produced it.

=== The sweep over all 64 tuples <sec-sweep64>

With the arena valid everywhere, the ledger can be run on every square class tuple at once. Each
twist is dispatched to the ledger of its own tuple; a tuple whose ledger closes is proved dense by
the termination theorem at $N = 1$. Sweeping squarefree $|d| <= 5000$ for $f = x^3+x+1$,
$S = {11,13,17}$:

#table(
  columns: 6, align: (left, right, right, right, right, left), stroke: 0.4pt + luma(150),
  table.header([tuple], [$d_0$], [$N$], [twists], [ledger], [outcome]),
  [$(1,1,1)$],   [$1$],  [$4536$], [222], [7], [*covered* --- seven hyperplanes],
  [$(1,1,u)$],   [$3$],  [$4536$], [206], [1], [*covered* --- one full twist, $d = 335$],
  [$(u,1,1)$],   [$-1$], [$3240$], [177], [7], [*covered* --- seven hyperplanes],
  [$(u,1,u)$],   [$74$], [$3240$], [185], [7], [*covered* --- seven hyperplanes],
  [$(11,u,u)$],  [$11$], [$3960$], [19],  [1], [*covered* --- one full twist, $d = 4279$],
  [49 others],   [---],  [---],    [1--149], [0--13], [not covered],
)

Two mechanisms appear, and both are certified. Tuples $(1,1,u)$ and $(11,u,u)$ close because a
*single full twist* exists --- a ledger of one member of index 1. Tuples $(1,1,1)$, $(u,1,1)$ and
$(u,1,u)$ close the hard way, by seven index-2 reaches; for $(u,1,1)$ the witnesses are
$d in {-511, 94, 134, 1154, 1821, 2994, 3714}$ and for $(u,1,u)$ they are
$d in {-3441, -1213, -641, -367, -199, 131, 2859}$, each of index 2 in an arena of order $3240$.
That $(11,u,u)$ is among the successes matters for its own sake: $11 divides d_0$, so this is a
tuple where $E_(d_0)$ is additive at $11$ and the old $bb(F)_p$ arena did not exist at all.

*The 49 failures are a matter of supply, not of obstruction.* That is worth establishing rather
than assuming, and it splits into two parts.

*Starvation.* Ten tuples were not realised at all, and 45 of the 49 saw fewer than 50 twists ---
against the 177 to 222 that the three covered non-full tuples needed. The cause is structural: a
tuple fixes the parity of $v_p (d)$ at each place, so the places of odd valuation force a divisor
$P = product {p : v_p (d) "odd"}$ of $d$. For $S = {11,13,17}$ the tuple
$(u dot 11, u dot 13, u dot 17)$ needs $2431 divides d$, so a uniform sweep of $|d| <= 5000$ offers
it *two* candidates. Uniform search in $|d|$ is simply the wrong enumeration here; it must be
replaced by $d = plus.minus P m$ with $m$ squarefree and coprime to $S$, so that every tuple gets a
comparable supply. The price is that the ramified tuples then work with much larger $d$ --- $|d|$
of order $10^6$ for the all-odd tuple --- where the rank computation, not the ledger, becomes the
bottleneck.

*The four well-supplied failures.* Tuples $(1,u,1)$, $(1,u,u)$, $(u,u,1)$ and $(u,u,u)$ saw 116 to
149 twists, comparable to the successes, and still did not close. These are the ones that could
have been a real obstruction, so they were probed directly. First, nothing distinguishes their
arenas: at every one of the seven tuples examined the local groups $tilde(E)(bb(F)_p)$ are
*cyclic*, so the arena is a product of three cyclic groups with $2$-rank exactly $3$. An index-2
reach then contains the entire odd part together with a hyperplane of $(ZZ slash 2)^3$, so seven
index-2 reaches suffice to cover --- in every tuple alike, whatever the odd part looks like
($(ZZ slash 5)^2 times ZZ slash 9$ at $(u,u,u)$, $ZZ slash 3 times ZZ slash 5 times ZZ slash 7$ at
$(1,u,1)$, and so on).

Second, listing the reaches shows exactly what is missing. Both probed tuples have found *five* of
the seven hyperplanes and no more:

#table(
  columns: 3, align: (left, left, left), stroke: 0.4pt + luma(150),
  table.header([tuple], [reaches found], [witnesses]),
  [$(u,u,u)$, $d_0 = 6$],  [five of index 2, two of index 10],
    [$241, -889, -938, 1047, 4886$],
  [$(1,u,1)$, $d_0 = -19$], [five of index 2],
    [$-149, -349, -1086, 2546, 3391$],
)

So the mechanism is the same one that closes the successful tuples, stopped two hyperplanes short.
Since $(1,1,1)$ needed 222 twists to collect all seven, five out of seven after 148 is unremarkable
--- these tuples want more twists, not a different theory. Nothing in this sweep is evidence of an
obstruction anywhere.

*A cross-check for free.* Re-running the $(1,1,1)$ tuple under the per-tuple enumeration
$d = plus.minus P m$ --- a different search order over a different set of candidates --- returns
the *same seven* maximal reaches $d in {-1590, -519, -127, 53, 586, 1730, 1923}$. The certificate
is a property of the curve, not of the search.

*The per-tuple sweep.* Run with $m <= 2000$ and a cap of 250 candidates per tuple, the per-tuple
enumeration proves *13 of the 64* tuples dense, against 5 for the uniform sweep:

#table(
  columns: 5, align: (left, right, right, left, right), stroke: 0.4pt + luma(150),
  table.header([tuple], [$d_0$], [$N$], [mechanism], [witness $d$]),
  [$(1,1,1)$],            [$1$],     [$4536$],  [seven hyperplanes], [see below],
  [$(1,13,u dot 17)$],    [$663$],   [$12376$], [seven hyperplanes], [see below],
  [$(1,1,u)$],            [$3$],     [$4536$],  [full twist], [$335$],
  [$(1,u,17)$],           [$34$],    [$4760$],  [full twist], [$21981$],
  [$(1,13,1)$],           [$-13$],   [$6552$],  [full twist], [$23673$],
  [$(1,13,17)$],          [$221$],   [$12376$], [full twist], [$214591$],
  [$(u,u dot 13,u dot 17)$], [$-1105$], [$8840$],  [full twist], [$-12818$],
  [$(11,u,u)$],           [$11$],    [$3960$],  [full twist], [$4279$],
  [$(11,u dot 13,u)$],    [$-143$],  [$10296$], [full twist], [$52195$],
  [$(u dot 11,1,1)$],     [$-55$],   [$7128$],  [full twist], [$-13354$],
  [$(u dot 11,1,u dot 17)$], [$-374$], [$13464$], [full twist], [$17391$],
  [$(u dot 11,u,1)$],     [$-33$],   [$3960$],  [full twist], [$17633$],
  [$(u dot 11,13,1)$],    [$715$],   [$10296$], [full twist], [$-188045$],
)

Note that $d_0$ is only the first candidate in the tuple's progression, present to name the arena;
the witness is the last column. The two hyperplane certificates are
$d in {-1590, -519, -127, 53, 586, 1730, 1923}$ for $(1,1,1)$, each of index 2 in an arena of
order $4536$, and
$d in {-323765, -303654, -189397, -72709, -6409, 40001, 384319}$ for $(1,13,u dot 17)$, each of
index 2 in an arena of order $12376$.

Eleven of the thirteen close on a *single full twist* --- a ledger with one member of index 1 ---
and only $(1,1,1)$ and $(1,13,u dot 17)$ need the hyperplane mechanism. All eleven full twists have
Mordell--Weil rank *exactly* 3, which is the least $g = 3$ permits and worth recording, since it
says the mechanism is not "these tuples happen to sit under twists of unusually large rank". Ten
of the eleven are ramified at some place of $S$, but so are 56 of the 64 tuples, so the rate is
about the same either way; and $d = 335$ shows that a rank-3 twist can turn up at small $|d|$
in an unramified tuple too. What separates the eleven from the rest is that the search met a
rank-3 twist, not that their arenas demanded one.

*The two enumerations are complementary, not nested.* The uniform sweep still proves $(u,1,1)$ and
$(u,1,u)$, which the per-tuple run misses: capped at 250 candidates it drew only 102 and 98 twists
with points, where the uniform sweep, unbounded within $|d| <= 5000$, found 177 and 185. Together
the two settle *15 of the 64 tuples*. None of the 49 remaining is obstructed as far as this can
tell --- their ledgers hold between 3 and 8 maximal reaches, concentrated at 4 and 5, which is the
same "short of the seven hyperplanes" position diagnosed above. Even the worst tuple,
$(u dot 11, u dot 13, u dot 17)$, which needs $2431 divides d$ and saw two candidates under the
uniform sweep, now draws 22 twists with points and reaches a ledger of 5.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *Where the time goes.* Of 14134 candidates tried, only 2928 --- $21%$ --- have a rational point
  at all; 88% of those are then admitted. So roughly four fifths of the computation is spent on a
  rank computation whose answer is "rank $0$, no torsion, nothing to contribute". The graded
  ledger is not the bottleneck and neither is the star test: *finding points is*. The fix is the
  $t_0$-bucketing of @sec-strategy --- enumerate $t_0$ and group by the squarefree part of
  $f(t_0)$, so that every candidate carries a rational point by construction. Landing in a
  prescribed tuple then becomes a congruence condition on $t_0$, namely $P divides f(t_0)$,
  rather than a rank computation. That would raise the yield from $21%$ to essentially $100%$ and
  is the obvious next step for pushing past 15 tuples.
]


=== An extended certificate for the ledger <sec-cert-ledger>

@sec-cert-extended does for the single-place table of @tab-primes what this section now does for
the ledger: repeat the witnesses with the local half written out. Two things change.

+ *Several lines per class.* At a single place one twist sufficed a priori, so a class got one
  line. Here a tuple is covered by several twists --- seven, in three of the five covered tuples
  --- so a tuple gets several lines.
+ *The image is a triple.* A line records where one generator sits in
  $ E^d (QQ_S) = product_(p in S) E^d (QQ_p) = product_p (ZZ_p times T_p) , $
  one coordinate $(alpha_p ; t_p)$ per place, in the conventions of @sec-cert-conv. So there is
  *one line per (twist, generator)*: a rank-$2$ twist occupies two lines.

The arena $cal(G)_(arrow(delta))$ depends only on the tuple, not on the twist, so the group
$E^d (QQ_p)$ is stated once per tuple rather than once per line.

*The column a ledger line needs and a single-place line does not* is the *index of the reach* in
the arena $cal(G)(1)$ of order $N = product_p M_p$. Index $1$ is a full twist; index $2$ is one of
the hyperplanes the ledger stacks up. It is computed here rather than quoted from @sec-sweep64.

#block(fill: rgb("#fff4e6"), inset: 8pt, radius: 3pt, width: 100%)[
  *A trap worth recording, since it produced a wrong answer first.* The natural way to get the
  index is to write each generator's image as a discrete logarithm in $E^d (FF_p)$ and take the
  determinant of the Hermite form of the resulting lattice. But `ellgroup(E,p,1)` returns a
  generator chosen *at random on each call* --- five successive calls at $p = 11$ for $d = 3714$
  return $(5,3)$, $(2,8)$, $(2,8)$, $(5,3)$, $(2,8)$. Computing the base inside the discrete-log
  routine therefore expresses different generators of the same twist against *different* bases,
  and the lattice they span is meaningless. It reported index $6$ for $d = 3714$, which would have
  broken the covering at $(u,1,1)$ and looked exactly like an error in @sec-sweep64.

  The fix has two halves. For the *index*, fix one base per (curve, prime) --- and guard it by
  computing the index a second way, directly on points of $product_p E^d (FF_p)$ with no discrete
  logarithms at all, and comparing. `cert-ledger.gp` does both on every line: *$32$ comparisons,
  $0$ disagreements*, and the indices reproduce @sec-sweep64 exactly.

  For the *class column* that is not enough, and the same defect that @sec-cert-extended records
  applies here: a base fixed per run is still whichever generator `ellgroup` happened to return,
  so the classes are consistent within a run but not reproducible across runs, and a reader cannot
  check them. So the base is the *canonical* one of @tab-primes-extended --- first affine point of
  maximal order in lexicographic order --- and it is printed, in the *bases $g$* column, one point
  per place. The two certificates now use the same convention.
]

=== The tables <tab-ledger-extended>

Only $x(P)$ is listed, for the reason of @tab-primes-extended. Unlike there, the $ZZ_p$-coordinate
is *not* always a unit: a partial reach may fail the formal-group condition at a place, and
$11^1 u$ in the $(1,1,1)$ block is such a line. That column carries information here.

#block(breakable: true)[
  *Tuple (1,1,1)*, $d_0 = 1$, arena of order $4536$ --- $E^d (QQ_p) = $ $ZZ_11 times C_14$, $ZZ_13 times C_18$, $ZZ_17 times C_18$ for $p = 11, 13, 17$.

  #set text(size: 7.4pt)
  #table(columns: 7, align: (right, center, center, left, left, left, left),
    stroke: 0.35pt + luma(175), inset: (x: 4pt, y: 2.5pt),
    table.header([$d$], [index], [bases $g$], [$x(P)$], [at $11$], [at $13$], [at $17$]),
    [$-1590$], [$2$], [$(5,1),(4,5),(0,6)$], [$1749$], [$u$; $8$], [$u$; $8$], [$u$; $15$],
    [], [], [], [$68125642147396531461 slash 58280778783859129$], [$u$; $9$], [$u$; $13$], [$u$; $14$],
    [$-519$], [$2$], [$(3,3),(1,4),(0,6)$], [$4152$], [$11^1 u$; $8$], [$u$; $5$], [$u$; $14$],
    [], [], [], [$6050848 slash 16641$], [$u$; $8$], [$u$; $4$], [$u$; $3$],
    [$-127$], [$2$], [$(5,1),(2,1),(0,7)$], [$88$], [$u$; $8$], [$u$; $5$], [$u$; $7$],
    [], [], [], [$3122041 slash 25600$], [$11^1 u$; $11$], [$u$; $15$], [$u$; $4$],
    [$53$], [$2$], [$(3,3),(1,4),(0,5)$], [$148$], [$u$; $8$], [$u$; $5$], [$u$; $7$],
    [], [], [], [$-10388 slash 289$], [$11^1 u$; $5$], [$u$; $10$], [$u$; $0$],
    [$586$], [$2$], [$(1,2),(1,4),(0,6)$], [$-879 slash 4$], [$u$; $11$], [$13^1 u$; $4$], [$u$; $7$],
    [], [], [], [$21150205 slash 4761$], [$u$; $7$], [$u$; $2$], [$u$; $12$],
    [$1730$], [$2$], [$(1,2),(1,4),(0,2)$], [$13321 slash 4$], [$u$; $10$], [$u$; $11$], [$u$; $6$],
    [], [], [], [$1987150919816948629 slash 5510562785917225$], [$u$; $7$], [$u$; $7$], [$u$; $7$],
    [$1923$], [$2$], [$(3,3),(1,1),(0,5)$], [$18439647 slash 529$], [$u$; $5$], [$u$; $16$], [$u$; $4$],
    [], [], [], [$33387 slash 49$], [$u$; $7$], [$u$; $13$], [$u$; $2$],
  )
  #set text(size: 10.5pt)
]

#block(breakable: true)[
  *Tuple (1,1,u)*, $d_0 = 3$, arena of order $4536$ --- $E^d (QQ_p) = $ $ZZ_11 times C_14$, $ZZ_13 times C_18$, $ZZ_17 times C_18$ for $p = 11, 13, 17$.

  #set text(size: 7.4pt)
  #table(columns: 7, align: (right, center, center, left, left, left, left),
    stroke: 0.35pt + luma(175), inset: (x: 4pt, y: 2.5pt),
    table.header([$d$], [index], [bases $g$], [$x(P)$], [at $11$], [at $13$], [at $17$]),
    [$335$], [$1$], [$(5,1),(3,1),(7,6)$], [$-134$], [$u$; $9$], [$u$; $6$], [$u$; $3$],
    [], [], [], [$1474$], [$u$; $6$], [$u$; $9$], [$u$; $2$],
    [], [], [], [$31289$], [$u$; $1$], [$u$; $11$], [$u$; $4$],
  )
  #set text(size: 10.5pt)
]

#block(breakable: true)[
  *Tuple (u,1,1)*, $d_0 = -1$, arena of order $3240$ --- $E^d (QQ_p) = $ $ZZ_11 times C_10$, $ZZ_13 times C_18$, $ZZ_17 times C_18$ for $p = 11, 13, 17$.

  #set text(size: 7.4pt)
  #table(columns: 7, align: (right, center, center, left, left, left, left),
    stroke: 0.35pt + luma(175), inset: (x: 4pt, y: 2.5pt),
    table.header([$d$], [index], [bases $g$], [$x(P)$], [at $11$], [at $13$], [at $17$]),
    [$-511$], [$2$], [$(8,2),(4,5),(0,4)$], [$1072$], [$11^1 u$; $6$], [$u$; $11$], [$17^1 u$; $5$],
    [], [], [], [$90605848 slash 53361$], [$u$; $0$], [$u$; $9$], [$u$; $8$],
    [$94$], [$2$], [$(8,2),(2,1),(0,7)$], [$141$], [$u$; $7$], [$u$; $4$], [$u$; $6$],
    [], [], [], [$1833 slash 16$], [$u$; $9$], [$u$; $3$], [$u$; $11$],
    [$134$], [$2$], [$(3,5),(4,6),(0,3)$], [$-335 slash 4$], [$u$; $4$], [$u$; $17$], [$u$; $12$],
    [], [], [], [$94537 slash 196$], [$u$; $5$], [$13^2 u$; $12$], [$u$; $1$],
    [$1154$], [$2$], [$(4,1),(3,1),(0,3)$], [$577 slash 4$], [$u$; $9$], [$u$; $7$], [$u$; $10$],
    [], [], [], [$162802870117 slash 95277121$], [$u$; $7$], [$13^1 u$; $4$], [$u$; $11$],
    [$1821$], [$2$], [$(8,2),(1,4),(0,5)$], [$-457071 slash 676$], [$u$; $7$], [$u$; $0$], [$u$; $5$],
    [], [], [], [$21215257 slash 1444$], [$u$; $8$], [$u$; $4$], [$17^1 u$; $11$],
    [$2994$], [$2$], [$(3,5),(4,6),(0,5)$], [$-531435 slash 289$], [$u$; $3$], [$13^1 u$; $16$], [$u$; $0$],
    [], [], [], [$10850708593 slash 784$], [$u$; $6$], [$u$; $11$], [$u$; $2$],
    [$3714$], [$2$], [$(2,3),(4,5),(0,6)$], [$-3564026823 slash 1643524$], [$u$; $1$], [$u$; $7$], [$u$; $11$],
    [], [], [], [$-6284235 slash 113569$], [$u$; $9$], [$u$; $1$], [$u$; $4$],
  )
  #set text(size: 10.5pt)
]

#block(breakable: true)[
  *Tuple (u,1,u)*, $d_0 = 74$, arena of order $3240$ --- $E^d (QQ_p) = $ $ZZ_11 times C_10$, $ZZ_13 times C_18$, $ZZ_17 times C_18$ for $p = 11, 13, 17$.

  #set text(size: 7.4pt)
  #table(columns: 7, align: (right, center, center, left, left, left, left),
    stroke: 0.35pt + luma(175), inset: (x: 4pt, y: 2.5pt),
    table.header([$d$], [index], [bases $g$], [$x(P)$], [at $11$], [at $13$], [at $17$]),
    [$-3441$], [$2$], [$(3,5),(4,6),(1,8)$], [$223665 slash 64$], [$u$; $3$], [$13^1 u$; $15$], [$u$; $1$],
    [], [], [], [$23901$], [$u$; $2$], [$u$; $13$], [$u$; $2$],
    [$-1213$], [$2$], [$(1,4),(4,5),(5,2)$], [$27899 slash 25$], [$u$; $1$], [$u$; $12$], [$u$; $11$],
    [], [], [], [$30514235278 slash 16056049$], [$u$; $4$], [$u$; $16$], [$u$; $17$],
    [$-641$], [$2$], [$(1,4),(4,5),(1,7)$], [$36537$], [$u$; $4$], [$u$; $10$], [$u$; $9$],
    [], [], [], [$55185 slash 121$], [$u$; $0$], [$u$; $15$], [$u$; $7$],
    [$-367$], [$2$], [$(2,3),(3,1),(14,4)$], [$263104 slash 625$], [$u$; $8$], [$u$; $13$], [$u$; $1$],
    [], [], [], [$1825513417 slash 2762244$], [$u$; $1$], [$u$; $3$], [$u$; $17$],
    [$-199$], [$2$], [$(4,1),(4,5),(1,7)$], [$6169 slash 16$], [$u$; $9$], [$u$; $9$], [$u$; $2$],
    [], [], [], [$18144424 slash 109561$], [$u$; $8$], [$u$; $13$], [$u$; $9$],
    [$131$], [$2$], [$(4,1),(1,4),(7,6)$], [$655$], [$u$; $7$], [$u$; $5$], [$u$; $14$],
    [], [], [], [$5371 slash 25$], [$u$; $8$], [$u$; $14$], [$u$; $15$],
    [$2859$], [$2$], [$(4,1),(1,1),(2,6)$], [$411$], [$u$; $9$], [$u$; $11$], [$u$; $8$],
    [], [], [], [$16100935 slash 121$], [$u$; $0$], [$u$; $11$], [$u$; $12$],
  )
  #set text(size: 10.5pt)
]

#block(breakable: true)[
  *Tuple (11,u,u)*, $d_0 = 11$, arena of order $3960$ --- $E^d (QQ_p) = $ $ZZ_11 times C_2$, $ZZ_13 times C_10$, $ZZ_17 times C_18$ for $p = 11, 13, 17$.

  #set text(size: 7.4pt)
  #table(columns: 7, align: (right, center, center, left, left, left, left),
    stroke: 0.35pt + luma(175), inset: (x: 4pt, y: 2.5pt),
    table.header([$d$], [index], [bases $g$], [$x(P)$], [at $11$], [at $13$], [at $17$]),
    [$4279$], [$---$], [$-,(6,1),(7,6)$], [$-2334$], [$u$; ord $11$], [$u$; $1$], [$u$; $16$],
    [], [], [], [$110961$], [$u$; ord $11$], [$u$; $1$], [$u$; $3$],
    [], [], [], [$-196222103 slash 88804$], [$u$; ord $22$], [$u$; $5$], [$u$; $1$],
  )
  #set text(size: 10.5pt)
]

#block(breakable: true)[
  *Tuple (u,u,u)*, $d_0 = 6$, arena of order $1800$ --- $E^d (QQ_p) = $ $ZZ_11 times C_10$, $ZZ_13 times C_10$, $ZZ_17 times C_18$ for $p = 11, 13, 17$.

  #set text(size: 7.4pt)
  #table(columns: 7, align: (right, center, center, left, left, left, left),
    stroke: 0.35pt + luma(175), inset: (x: 4pt, y: 2.5pt),
    table.header([$d$], [index], [bases $g$], [$x(P)$], [at $11$], [at $13$], [at $17$]),
    [$241$], [$2$], [$(4,1),(3,6),(2,6)$], [$9640 slash 529$], [$u$; $9$], [$u$; $7$], [$u$; $15$],
    [], [], [], [$1464$], [$u$; $8$], [$13^1 u$; $7$], [$u$; $1$],
    [$-889$], [$2$], [$(3,5),(9,6),(7,6)$], [$5461 slash 9$], [$u$; $1$], [$u$; $6$], [$u$; $11$],
    [], [], [], [$584335165465 slash 248882176$], [$u$; $7$], [$u$; $1$], [$u$; $0$],
    [$-938$], [$2$], [$(1,4),(1,6),(11,3)$], [$7499913 slash 1024$], [$u$; $2$], [$u$; $7$], [$u$; $6$],
    [], [], [], [$115842421857 slash 10407076$], [$11^1 u$; $3$], [$u$; $2$], [$u$; $13$],
    [$1047$], [$2$], [$(3,5),(3,6),(1,8)$], [$597837 slash 121$], [$u$; $0$], [$u$; $7$], [$u$; $2$],
    [], [], [], [$1922641 slash 400$], [$11^1 u$; $6$], [$u$; $8$], [$u$; $17$],
    [$4886$], [$2$], [$(3,5),(1,6),(14,4)$], [$60148405 slash 3481$], [$u$; $5$], [$13^1 u$; $3$], [$u$; $5$],
    [], [], [], [$27778442265305 slash 3528597604$], [$u$; $4$], [$u$; $6$], [$u$; $17$],
  )
  #set text(size: 10.5pt)
]

#block(breakable: true)[
  *Tuple (1,u,1)*, $d_0 = -19$, arena of order $2520$ --- $E^d (QQ_p) = $ $ZZ_11 times C_14$, $ZZ_13 times C_10$, $ZZ_17 times C_18$ for $p = 11, 13, 17$.

  #set text(size: 7.4pt)
  #table(columns: 7, align: (right, center, center, left, left, left, left),
    stroke: 0.35pt + luma(175), inset: (x: 4pt, y: 2.5pt),
    table.header([$d$], [index], [bases $g$], [$x(P)$], [at $11$], [at $13$], [at $17$]),
    [$-149$], [$2$], [$(5,1),(3,6),(0,8)$], [$1639$], [$u$; $8$], [$u$; $4$], [$u$; $7$],
    [], [], [], [$8791 slash 25$], [$11^1 u$; $10$], [$u$; $5$], [$u$; $13$],
    [$-349$], [$2$], [$(1,2),(6,1),(0,6)$], [$2443$], [$u$; $13$], [$u$; $3$], [$u$; $12$],
    [], [], [], [$2582892113 slash 456976$], [$u$; $12$], [$13^1 u$; $0$], [$u$; $7$],
    [$-1086$], [$2$], [$(1,2),(5,1),(0,5)$], [$113125 slash 121$], [$u$; $0$], [$u$; $5$], [$u$; $7$],
    [], [], [], [$1072425 slash 1024$], [$u$; $5$], [$u$; $2$], [$u$; $11$],
    [$2546$], [$2$], [$(5,1),(1,6),(0,2)$], [$-6767 slash 4$], [$u$; $13$], [$u$; $2$], [$u$; $5$],
    [], [], [], [$55650401 slash 1444$], [$u$; $1$], [$u$; $1$], [$u$; $17$],
    [$3391$], [$2$], [$(1,2),(1,6),(0,6)$], [$50865$], [$11^1 u$; $13$], [$u$; $4$], [$u$; $10$],
    [], [], [], [$81416056988410093681 slash 3930431307695104$], [$u$; $5$], [$u$; $1$], [$u$; $15$],
  )
  #set text(size: 10.5pt)
]

The star test on each sign-closed ledger confirms the outcome of @sec-sweep64 line for line:
$(1,1,1)$, $(1,1,u)$, $(u,1,1)$ and $(u,1,u)$ *cover*; $(u,u,u)$ and $(1,u,1)$ do *not*. The
reach index is omitted for $(11,u,u)$, where $11 divides d_0$ makes the reduction additive and
$tilde(E)(FF_11)$ does not exist --- the per-place data is still listed, and the $T$-coordinate is
given by its order.

= Result

#block(fill: rgb("#eef4ff"), inset: 9pt, radius: 3pt, width: 100%)[
  For
  $ f(x) = x^3 + x + 1 quad (op("disc") f = -31), $
  the rational points of $X : y^2 = f(x) f(t)$ are dense in $X(QQ_p)$ for *every prime
  $p <= 200$*.
]

Here $E : v^2 = u^3 + u + 1$ is the curve *496a*: rank 1, trivial torsion, generator $(0,1)$.
It is non-CM, which matters --- see @sec-remarks.

== The headline case $p = 5$

The four witnesses, one per class of $QQ_5^times slash (QQ_5^times)^2$ ($u$ = a non-residue):

#table(
  columns: (auto, auto, auto, auto, auto, auto),
  align: (center, center, left, left, left, center),
  stroke: 0.4pt + luma(150),
  table.header([*class*], [$d$], [$E_d : Y^2 = X^3 + d^2 X + d^3$], [generator],
               [reduction at 5], [$M$]),
  [$1$],    [$1$],   [$y^2 = x^3 + x + 1$],           [$(0, 1)$], [good, $a_5 = -3$], [9],
  [$u$],    [$3$],   [$y^2 = x^3 + 9x + 27$],         [$(3, 9)$], [good, $a_5 = 3$],  [3],
  [$5$],    [$5$],   [$y^2 = x^3 + 25x + 125$],       [$(4, 17)$], [$I_0^*$, $c = 1$], [5],
  [$5u$],   [$-35$], [$y^2 = x^3 + 1225x - 42875$],
    [$(59004 slash 1369, 15194717 slash 50653)$], [$I_0^*$, $c = 1$], [5],
)

Each twist has rank 1 and trivial torsion, and in each case the single generator topologically
generates $E_d (QQ_5)$. In the $(u, v)$ coordinates on $d v^2 = f(u)$ these correspond to
$t_0 = 0, 1, 4 slash 5, -59004 slash 47915$.

*Sample point.* On $d = 1$, $P = (0,1)$ and $2P = (1 slash 4, -9 slash 8)$, giving
$(x, t, y) = (0, 1 slash 4, -9 slash 8) in X(QQ)$; indeed
$f(0) f(1 slash 4) = 81 slash 64 = y^2$.

== $p = 2$

All eight classes of $QQ_2^times slash (QQ_2^times)^2$ are covered by small twists:

#table(
  columns: 9, align: center, stroke: 0.4pt + luma(150),
  table.header([*class*], [$1$], [$3$], [$5$], [$7$], [$2$], [$6$], [$10$], [$14$]),
  [$d$], [$1$], [$3$], [$5$], [$-1$], [$-30$], [$6$], [$-6$], [$30$],
)

== All primes $p < 200$ <tab-primes>

Witnesses from the pure-descent run with $|d| <= 3000$; the two marked $dagger$ lie beyond that
bound. The hybrid of @sec-strategy finds a full set for all 45 primes in one pass (sometimes
different, equally valid, witnesses).

#let ptab(..rows) = table(
  columns: 5,
  align: right,
  stroke: 0.4pt + luma(170),
  inset: (x: 6pt, y: 3pt),
  table.header([$p$], [$[1]$], [$[u]$], [$[p]$], [$[u p]$]),
  ..rows
)

#set text(size: 8.5pt)
#grid(columns: (auto, auto), column-gutter: 1.2cm, align: top,
  ptab(
    [3],  [7],   [-1],   [3],    [6],
    [5],  [1],   [3],    [5],    [-35],
    [7],  [1],   [-1],   [7],    [-7],
    [11], [3],   [6],    [11],   [-11],
    [13], [-1],  [5],    [-13],  [26],
    [17], [-1],  [7],    [34],   [51],
    [19], [1],   [-1],   [95],   [-95],
    [23], [1],   [-1],   [46],   [115],
    [29], [-1],  [11],   [-29],  [58],
    [31], [1],   [-1],   [31],   [-62],
    [37], [-11], [6],    [-37],  [74],
    [41], [-1],  [3],    [41],   [123],
    [43], [1],   [-1],   [-86],  [86],
    [47], [-11], [-149], [94],   [705],
    [53], [11],  [22],   [53],   [106],
    [59], [1],   [6],    [295],  [-59],
    [61], [1],   [7],    [-61],  [122],
    [67], [-221],[51],   [2211], [134],
    [71], [1],   [-1],   [71],   [-71],
    [73], [3],   [-21],  [146],  [-365],
    [79], [1],   [-1],   [158],  [-158],
    [83], [-22], [-11],  [83],   [166],
    [89], [1],   [-7],   [178],  [-267],
  ),
  ptab(
    [97],  [1],   [7],   [97],    [485],
    [101], [-1],  [3],   [101],   [-2626],
    [103], [1],   [-1],  [103],   [2266],
    [107], [-7],  [-1],  [-1605], [-107],
    [109], [1],   [6],   [109],   [654],
    [113], [1],   [3],   [113],   [339],
    [127], [-6],  [3],   [254],   [-127],
    [131], [53],  [-11], [131],   [8646#super[†]],
    [137], [7],   [3],   [274],   [-411],
    [139], [51],  [3],   [139],   [-139],
    [149], [53],  [94],  [-149],  [13559#super[†]],
    [151], [1],   [-1],  [755],   [453],
    [157], [1],   [5],   [157],   [2355],
    [163], [1],   [-1],  [978],   [815],
    [167], [-13], [-6],  [334],   [-334],
    [173], [51],  [53],  [-173],  [519],
    [179], [1],   [-19], [179],   [-537],
    [181], [1],   [7],   [-181],  [-1086],
    [191], [1],   [-1],  [191],   [-191],
    [193], [1],   [5],   [-193],  [965],
    [197], [-6],  [3],   [197],   [394],
    [199], [-6],  [3],   [199],   [-199],
  ),
)
#set text(size: 10.5pt)

== An extended certificate <sec-cert-extended>

The table of @tab-primes records only the witness twists $d$. That is enough to *reproduce* the
search, but not enough to *check* it without redoing the local work. What follows repeats the same
witnesses with three further columns, so that each line can be verified on its own:

+ the isomorphism type of $E^d (QQ_p)$, as $ZZ_p times C_a times C_b$;
+ the generators of $E^d (QQ)$ actually used --- redundant ones are dropped, so a rank-$2$ twist
  appears with one generator whenever one suffices;
+ the images of those generators in $ZZ_p times C_a times C_b$.

Nothing in @tab-primes is altered; this is the same certificate with its local half written out.

=== Conventions <sec-cert-conv>

$E_d : Y^2 = X^3 + d^2 X + d^3$ throughout, the twist of $E = 496 a$. For $p >= 3$ the formal
group is $E_1 (QQ_p) tilde.equiv ZZ_p$ with $E_n <-> p^(n-1) ZZ_p$, and
$M = \#(E(QQ_p) slash E_1) = c_p dot \#tilde(E)^"ns"(FF_p)$ as in @sec-local. Writing
$E(QQ_p) tilde.equiv ZZ_p times T$ with $T$ the torsion subgroup:

- *Good reduction with $p divides.not M$.* Then $T tilde.equiv E(FF_p)$, read off by `ellgroup`,
  and the $T$-coordinate of a point is *literally its reduction mod $p$*. It is recorded as a
  discrete logarithm $[e]$ or $[e, f]$ against the generators PARI returns.
- *The classes $[p]$ and $[u p]$.* Here $v_p (d)$ is odd, so $v_p (c_4) = 2$ and $v_p (Delta) = 6$:
  the reduction is additive of type $I_0^*$, $a_p = 0$, and $M = c_p dot p$. The prime-to-$p$ part
  of $T$ is $Phi(FF_p)$, of order $c_p$; the $p$-part is trivial, because a single point
  topologically generates and $ZZ_p times ZZ slash p$ is not procyclic. The $T$-coordinate is
  recorded by its order in $C_(c_p)$.

The $ZZ_p$-coordinate is only defined up to a unit --- choosing a topological generator of $ZZ_p$
is a choice --- so what is canonical is its *valuation*. It is written $u$ for a unit and $p^k u$
otherwise. A point generates the $ZZ_p$ factor exactly when that coordinate is a unit, which is
exactly the condition $v_p (c(m P)) = 1$ of @sec-local. An asterisk marks a $T$-coordinate that
generates its cyclic factor.

So a line certifies density at $p$ in the class shown precisely when, for the listed generators
together, the $ZZ_p$-coordinates include a unit and the $T$-coordinates generate $T$.

=== The table <tab-primes-extended>

*How to read the last column.* It is the image of the point in
$E^d (QQ_p) tilde.equiv ZZ_p times T$, written as a pair $(alpha; t)$ --- first the
$ZZ_p$-coordinate, then the $T$-coordinate, separated by a semicolon. Reading the four shapes
that occur:

#align(center)[
#table(columns: 2, align: (left, left), stroke: 0.4pt, inset: 6pt,
  [entry], [meaning],
  [$u$; $(1)$],
    [$ZZ_p$-coordinate a *unit*; $T$-coordinate the class $1 dot g_1$, a discrete logarithm
     against PARI's generators of $T = E(FF_p)$],
  [$u$; $(6, 1)$],
    [same, with $T$ non-cyclic: the class $6 g_1 + g_2$],
  [$u$; $2$ in $C_2$#super[\*]],
    [an additive line, where $T$ is cyclic and the coordinate is given by its *order*; the
     asterisk marks one that generates its factor],
  [$u$; ---], [$T$ is trivial, so there is no second coordinate],
)]

Only the *valuation* of the $ZZ_p$-coordinate is recorded, for the reason given in
@sec-cert-conv: a topological generator of $ZZ_p$ has to be chosen, and the coordinate is only
defined up to a unit. So $u$ means valuation $0$, and $p^k u$ would mean valuation $k$.

#block(fill: rgb("#fff4e6"), inset: 8pt, radius: 3pt, width: 100%)[
  *The base matters, and an earlier version of this table did not record it.* A class is a
  discrete logarithm, so it means nothing until one says *against which generator*. PARI's
  `ellgroup(E,p,1)` returns a generator chosen *at random on each call* --- five successive calls
  at $p = 23$ for $d = 1$ return $(18,20)$, $(9,7)$, $(9,7)$, $(1,7)$, $(19,5)$. Computing it
  inside the per-generator loop therefore made the class column irreproducible, and on the $22$
  lines with two generators it dlogged them against *different* bases, so the pair was not even
  mutually consistent.

  The fix is a canonical base, stated once: *order the affine points of $E^d (FF_p)$
  lexicographically by $(x,y)$ and take the first of maximal order; in the non-cyclic case take
  the first $g_2$ of order $n_2$ independent of $g_1$.* It is deterministic, and it is printed in
  the *base $g$* column so that each line can be checked on its own. The class values below
  therefore differ from the earlier version of this table; the group structures, orders, depths
  and the choice of which generators are needed are unaffected, since none of them uses a
  discrete logarithm.
]

*Why every line begins with $u$.* Because it does --- in all $180$ of them --- and that is not
padding but half of what each line asserts. A point generates the $ZZ_p$ factor exactly when its
$ZZ_p$-coordinate is a unit, equivalently when $v_p (c(m P)) = 1$; a witness failing this would
close up on $E_k$ for some $k >= 2$ and certify nothing. The column being constant in its first
component is therefore the statement that *every witness clears the formal-group condition*, and
all the information that varies from line to line sits in the second component.

Only $x(P)$ is listed: $y$ is determined up to sign, and the sign does not change the subgroup
generated, hence not the certificate.

#set text(size: 7.2pt)
#table(
  columns: 7,
  align: (right, center, right, left, center, left, left),
  stroke: 0.35pt + luma(175),
  inset: (x: 4pt, y: 2.5pt),
  table.header([$p$], [class], [$d$], [$E^d (QQ_p)$], [base $g$], [$x(P)$],
               [image $(alpha; t)$]),
  [$3$], [$[1]$], [$7$], [$ZZ_p times C_4$], [$(0,1)$], [$-3$], [$u$; $(1)$],
  [$3$], [$[u]$], [$-1$], [$ZZ_p times C_4$], [$(1,1)$], [$1$], [$u$; $(1)$],
  [$3$], [$[p]$], [$3$], [$ZZ_p times C_2$], [---], [$3$], [$u$; $2$ in $C_2$#super[\*]],
  [$3$], [$[u p]$], [$6$], [$ZZ_p times C_2$], [---], [$-3$], [$u$; $2$ in $C_2$#super[\*]],
  [$5$], [$[1]$], [$1$], [$ZZ_p times C_9$], [$(0,1)$], [$0$], [$u$; $(1)$],
  [$5$], [$[u]$], [$3$], [$ZZ_p times C_3$], [$(3,1)$], [$3$], [$u$; $(2)$],
  [$5$], [$[p]$], [$5$], [$ZZ_p$], [---], [$4$], [$u$; ---],
  [$5$], [$[u p]$], [$-35$], [$ZZ_p$], [---], [$59004 slash 1369$], [$u$; ---],
  [$7$], [$[1]$], [$1$], [$ZZ_p times C_5$], [$(0,1)$], [$0$], [$u$; $(1)$],
  [$7$], [$[u]$], [$-1$], [$ZZ_p times C_11$], [$(1,1)$], [$1$], [$u$; $(1)$],
  [$7$], [$[p]$], [$7$], [$ZZ_p$], [---], [$-3$], [$u$; ---],
  [$7$], [$[u p]$], [$-7$], [$ZZ_p$], [---], [$424 slash 25$], [$u$; ---],
  [$11$], [$[1]$], [$3$], [$ZZ_p times C_14$], [$(1,2)$], [$3$], [$u$; $(3)$],
  [$11$], [$[u]$], [$6$], [$ZZ_p times C_10$], [$(8,2)$], [$-3$], [$u$; $(9)$],
  [$11$], [$[p]$], [$11$], [$ZZ_p times C_2$], [---], [$22$], [$u$; $2$ in $C_2$#super[\*]],
  [$11$], [$[u p]$], [$-11$], [$ZZ_p times C_2$], [---], [$33 slash 4$], [$u$; $2$ in $C_2$#super[\*]],
  [$13$], [$[1]$], [$-1$], [$ZZ_p times C_18$], [$(1,1)$], [$1$], [$u$; $(1)$],
  [$13$], [$[u]$], [$5$], [$ZZ_p times C_10$], [$(2,1)$], [$4$], [$u$; $(3)$],
  [$13$], [$[p]$], [$-13$], [$ZZ_p times C_2$], [---], [$247$], [$u$; $2$ in $C_2$#super[\*]],
  [$13$], [$[u p]$], [$26$], [$ZZ_p times C_2$], [---], [$13$], [$u$; $2$ in $C_2$#super[\*]],
  [$17$], [$[1]$], [$-1$], [$ZZ_p times C_18$], [$(0,4)$], [$1$], [$u$; $(13)$],
  [$17$], [$[u]$], [$7$], [$ZZ_p times C_18$], [$(14,4)$], [$-3$], [$u$; $(17)$],
  [$17$], [$[p]$], [$34$], [$ZZ_p times C_2$], [---], [$85$], [$u$; $2$ in $C_2$#super[\*]],
  [$17$], [$[u p]$], [$51$], [$ZZ_p times C_2$], [---], [$-17$], [$u$; $2$ in $C_2$#super[\*]],
  [$19$], [$[1]$], [$1$], [$ZZ_p times C_21$], [$(0,1)$], [$0$], [$u$; $(1)$],
  [$19$], [$[u]$], [$-1$], [$ZZ_p$], [---], [$1$], [$u$; ---],
  [$19$], [$[p]$], [$95$], [$ZZ_p$], [---], [$59101 slash 121$], [$u$; ---],
  [$19$], [$[u p]$], [$-95$], [$ZZ_p$], [---], [$3723268224 slash 6105841$], [$u$; ---],
  [$23$], [$[1]$], [$1$], [$ZZ_p times C_28$], [$(0,1)$], [$0$], [$u$; $(1)$],
  [$23$], [$[u]$], [$-1$], [$ZZ_p times C_20$], [$(1,1)$], [$1$], [$u$; $(1)$],
  [$23$], [$[p]$], [$46$], [$ZZ_p times C_2$], [---], [$3381 slash 625$], [$u$; $2$ in $C_2$#super[\*]],
  [$23$], [$[u p]$], [$115$], [$ZZ_p times C_2$], [---], [$-69$], [$u$; $2$ in $C_2$#super[\*]],
  [$29$], [$[1]$], [$-1$], [$ZZ_p times C_36$], [$(1,1)$], [$1$], [$u$; $(1)$],
  [$29$], [$[u]$], [$11$], [$ZZ_p times C_24$], [$(4,9)$], [$22$], [$u$; $(5)$],
  [$29$], [$[p]$], [$-29$], [$ZZ_p times C_2$], [---], [$87$], [$u$; $2$ in $C_2$#super[\*]],
  [$29$], [$[u p]$], [$58$], [$ZZ_p times C_2$], [---], [$-72682323 slash 1885129$], [$u$; $2$ in $C_2$#super[\*]],
  [$31$], [$[1]$], [$1$], [$ZZ_p times C_32$], [---], [$0$], [$u$; $32$ in $C_32$#super[\*]],
  [$31$], [$[u]$], [$-1$], [$ZZ_p times C_30$], [---], [$1$], [$u$; $30$ in $C_30$#super[\*]],
  [$31$], [$[p]$], [$31$], [$ZZ_p times C_2$], [---], [$93$], [$u$; $2$ in $C_2$#super[\*]],
  [$31$], [$[u p]$], [$-62$], [$ZZ_p times C_4$], [---], [$93$], [$u$; $4$ in $C_4$#super[\*]],
  [$37$], [$[1]$], [$-11$], [$ZZ_p times C_48$], [$(1,7)$], [$220$], [$u$; $(19)$],
  [$37$], [$[u]$], [$6$], [$ZZ_p times C_28$], [$(7,16)$], [$-3$], [$u$; $(5)$],
  [$37$], [$[p]$], [$-37$], [$ZZ_p times C_2$], [---], [$8473 slash 16$], [$u$; $2$ in $C_2$#super[\*]],
  [$37$], [$[u p]$], [$74$], [$ZZ_p times C_2$], [---], [$91945 slash 1156$], [$u$; $2$ in $C_2$#super[\*]],
  [$41$], [$[1]$], [$-1$], [$ZZ_p times C_35$], [$(1,1)$], [$1$], [$u$; $(1)$],
  [$41$], [$[u]$], [$3$], [$ZZ_p times C_49$], [$(1,18)$], [$3$], [$u$; $(27)$],
  [$41$], [$[p]$], [$41$], [$ZZ_p$], [---], [$-1328 slash 121$], [$u$; ---],
  [$41$], [$[u p]$], [$123$], [$ZZ_p$], [---], [$9146571 slash 625$], [$u$; ---],
  [$43$], [$[1]$], [$1$], [$ZZ_p times C_34$], [$(0,1)$], [$0$], [$u$; $(1)$],
  [$43$], [$[u]$], [$-1$], [$ZZ_p times C_54$], [$(1,1)$], [$1$], [$u$; $(1)$],
  [$43$], [$[p]$], [$-86$], [$ZZ_p times C_2$], [---], [$26445 slash 169$], [$u$; $2$ in $C_2$#super[\*]],
  [$43$], [$[u p]$], [$86$], [$ZZ_p times C_2$], [---], [$-169979 slash 47089$], [$u$; $2$ in $C_2$#super[\*]],
  [$47$], [$[1]$], [$-11$], [$ZZ_p times C_30 times C_2$], [$(12,4),(2,0)$], [$33 slash 4$ #linebreak() $220$], [$u$; $(1, 1)$ #linebreak() $u$; $(28, 1)$],
  [$47$], [$[u]$], [$-149$], [$ZZ_p times C_18 times C_2$], [$(3,6),(2,0)$], [$1639$ #linebreak() $8791 slash 25$], [$u$; $(12, 1)$ #linebreak() $u$; $(11, 1)$],
  [$47$], [$[p]$], [$94$], [$ZZ_p times C_4$], [---], [$141$ #linebreak() $1833 slash 16$], [$u$; $2$ in $C_4$ #linebreak() $u$; $2$ in $C_4$],
  [$47$], [$[u p]$], [$705$], [$ZZ_p times C_4$], [---], [$376$ #linebreak() $-2439159 slash 6400$], [$u$; $2$ in $C_4$ #linebreak() $u$; $2$ in $C_4$],
  [$53$], [$[1]$], [$11$], [$ZZ_p times C_58$], [$(2,16)$], [$22$], [$u$; $(33)$],
  [$53$], [$[u]$], [$22$], [$ZZ_p times C_50$], [$(2,21)$], [$2937 slash 196$], [$u$; $(3)$],
  [$53$], [$[p]$], [$53$], [$ZZ_p times C_2$], [---], [$-10388 slash 289$], [$u$; $2$ in $C_2$#super[\*]],
  [$53$], [$[u p]$], [$106$], [$ZZ_p times C_2$], [---], [$25798969 slash 7396$], [$u$; $2$ in $C_2$#super[\*]],
  [$59$], [$[1]$], [$1$], [$ZZ_p times C_63$], [$(0,1)$], [$0$], [$u$; $(1)$],
  [$59$], [$[u]$], [$6$], [$ZZ_p times C_57$], [$(1,28)$], [$-3$], [$u$; $(46)$],
  [$59$], [$[p]$], [$295$], [$ZZ_p$], [---], [$8251821 slash 49$], [$u$; ---],
  [$59$], [$[u p]$], [$-59$], [$ZZ_p$], [---], [$217697199204 slash 5358093601$], [$u$; ---],
  [$61$], [$[1]$], [$1$], [$ZZ_p times C_50$], [$(0,1)$], [$0$], [$u$; $(1)$],
  [$61$], [$[u]$], [$7$], [$ZZ_p times C_74$], [$(5,15)$], [$-3$], [$u$; $(59)$],
  [$61$], [$[p]$], [$-61$], [$ZZ_p times C_2$], [---], [$10675 slash 81$], [$u$; $2$ in $C_2$#super[\*]],
  [$61$], [$[u p]$], [$122$], [$ZZ_p times C_2$], [---], [$2358325453 slash 110889$], [$u$; $2$ in $C_2$#super[\*]],
  [$67$], [$[1]$], [$-221$], [$ZZ_p times C_28 times C_2$], [$(4,30),(13,0)$], [$1326$ #linebreak() $1819 slash 9$], [$u$; $(20, 1)$ #linebreak() $u$; $(25, 0)$],
  [$67$], [$[u]$], [$51$], [$ZZ_p times C_40 times C_2$], [$(1,28),(10,0)$], [$-17$ #linebreak() $-714 slash 25$], [$u$; $(9, 1)$ #linebreak() $u$; $(8, 1)$],
  [$67$], [$[p]$], [$2211$], [$ZZ_p times C_4$], [---], [$28743$ #linebreak() $4623$], [$u$; $2$ in $C_4$ #linebreak() $u$; $2$ in $C_4$],
  [$67$], [$[u p]$], [$134$], [$ZZ_p times C_4$], [---], [$-335 slash 4$ #linebreak() $94537 slash 196$], [$u$; $2$ in $C_4$ #linebreak() $u$; $2$ in $C_4$],
  [$71$], [$[1]$], [$1$], [$ZZ_p times C_59$], [$(0,1)$], [$0$], [$u$; $(1)$],
  [$71$], [$[u]$], [$-1$], [$ZZ_p times C_85$], [$(1,1)$], [$1$], [$u$; $(1)$],
  [$71$], [$[p]$], [$71$], [$ZZ_p$], [---], [$-47$], [$u$; ---],
  [$71$], [$[u p]$], [$-71$], [$ZZ_p$], [---], [$334272 slash 6889$], [$u$; ---],
  [$73$], [$[1]$], [$3$], [$ZZ_p times C_72$], [$(3,9)$], [$3$], [$u$; $(1)$],
  [$73$], [$[u]$], [$-21$], [$ZZ_p times C_76$], [$(6,5)$], [$15$], [$u$; $(31)$],
  [$73$], [$[p]$], [$146$], [$ZZ_p times C_2$], [---], [$7081 slash 64$], [$u$; $2$ in $C_2$#super[\*]],
  [$73$], [$[u p]$], [$-365$], [$ZZ_p times C_2$], [---], [$121326 slash 169$], [$u$; $2$ in $C_2$#super[\*]],
  [$79$], [$[1]$], [$1$], [$ZZ_p times C_86$], [$(0,1)$], [$0$], [$u$; $(1)$],
  [$79$], [$[u]$], [$-1$], [$ZZ_p times C_74$], [$(1,1)$], [$1$], [$u$; $(1)$],
  [$79$], [$[p]$], [$158$], [$ZZ_p times C_2$], [---], [$5004161712613 slash 72071308521$], [$u$; $2$ in $C_2$#super[\*]],
  [$79$], [$[u p]$], [$-158$], [$ZZ_p times C_2$], [---], [$7760048840149 slash 57386598025$], [$u$; $2$ in $C_2$#super[\*]],
  [$83$], [$[1]$], [$-22$], [$ZZ_p times C_90$], [$(9,9)$], [$1177 slash 64$], [$u$; $(13)$],
  [$83$], [$[u]$], [$-11$], [$ZZ_p times C_78$], [$(2,9)$], [$33 slash 4$ #linebreak() $220$], [$u$; $(51)$ #linebreak() $u$; $(13)$],
  [$83$], [$[p]$], [$83$], [$ZZ_p times C_2$], [---], [$115702 slash 9$], [$u$; $2$ in $C_2$#super[\*]],
  [$83$], [$[u p]$], [$166$], [$ZZ_p times C_2$], [---], [$-7055 slash 64$], [$u$; $2$ in $C_2$#super[\*]],
  [$89$], [$[1]$], [$1$], [$ZZ_p times C_100$], [$(0,1)$], [$0$], [$u$; $(1)$],
  [$89$], [$[u]$], [$-7$], [$ZZ_p times C_80$], [$(3,3)$], [$424 slash 25$], [$u$; $(57)$],
  [$89$], [$[p]$], [$178$], [$ZZ_p times C_2$], [---], [$50010613 slash 58081$], [$u$; $2$ in $C_2$#super[\*]],
  [$89$], [$[u p]$], [$-267$], [$ZZ_p times C_2$], [---], [$13439267253561 slash 39505537600$], [$u$; $2$ in $C_2$#super[\*]],
  [$97$], [$[1]$], [$1$], [$ZZ_p$], [---], [$0$], [$u$; ---],
  [$97$], [$[u]$], [$7$], [$ZZ_p times C_99$], [$(2,35)$], [$-3$], [$u$; $(20)$],
  [$97$], [$[p]$], [$97$], [$ZZ_p$], [---], [$-3020977264272 slash 60834742609$], [$u$; ---],
  [$97$], [$[u p]$], [$485$], [$ZZ_p$], [---], [$607367181296288749204 slash 261353291940472081$], [$u$; ---],
  [$101$], [$[1]$], [$-1$], [$ZZ_p times C_105$], [$(1,1)$], [$1$], [$u$; $(1)$],
  [$101$], [$[u]$], [$3$], [$ZZ_p times C_99$], [$(3,9)$], [$3$], [$u$; $(1)$],
  [$101$], [$[p]$], [$101$], [$ZZ_p$], [---], [$-68$], [$u$; ---],
  [$101$], [$[u p]$], [$-2626$], [$ZZ_p$], [---], [$80987149350133 slash 43587835729$], [$u$; ---],
  [$103$], [$[1]$], [$1$], [$ZZ_p times C_87$], [$(0,1)$], [$0$], [$u$; $(1)$],
  [$103$], [$[u]$], [$-1$], [$ZZ_p times C_121$], [$(1,1)$], [$1$], [$u$; $(1)$],
  [$103$], [$[p]$], [$103$], [$ZZ_p$], [---], [$1433661 slash 625$], [$u$; ---],
  [$103$], [$[u p]$], [$2266$], [$ZZ_p$], [---], [$-811896233775 slash 535089424$], [$u$; ---],
  [$107$], [$[1]$], [$-7$], [$ZZ_p times C_105$], [$(13,43)$], [$424 slash 25$], [$u$; $(46)$],
  [$107$], [$[u]$], [$-1$], [$ZZ_p times C_111$], [$(1,1)$], [$1$], [$u$; $(1)$],
  [$107$], [$[p]$], [$-1605$], [$ZZ_p$], [---], [$2571$], [$u$; ---],
  [$107$], [$[u p]$], [$-107$], [$ZZ_p$], [---], [$348$], [$u$; ---],
  [$109$], [$[1]$], [$1$], [$ZZ_p times C_123$], [$(0,1)$], [$0$], [$u$; $(1)$],
  [$109$], [$[u]$], [$6$], [$ZZ_p times C_97$], [$(1,12)$], [$-3$], [$u$; $(63)$],
  [$109$], [$[p]$], [$109$], [$ZZ_p$], [---], [$33919060748052 slash 93717413689$], [$u$; ---],
  [$109$], [$[u p]$], [$654$], [$ZZ_p$], [---], [$15870885 slash 6889$], [$u$; ---],
  [$113$], [$[1]$], [$1$], [$ZZ_p times C_125$], [$(0,1)$], [$0$], [$u$; $(1)$],
  [$113$], [$[u]$], [$3$], [$ZZ_p times C_103$], [$(2,36)$], [$3$], [$u$; $(13)$],
  [$113$], [$[p]$], [$113$], [$ZZ_p$], [---], [$-160779984385773438752 slash 2170759046766859201$], [$u$; ---],
  [$113$], [$[u p]$], [$339$], [$ZZ_p$], [---], [$-129$], [$u$; ---],
  [$127$], [$[1]$], [$-6$], [$ZZ_p times C_126$], [$(15,4)$], [$21$], [$u$; $(121)$],
  [$127$], [$[u]$], [$3$], [$ZZ_p times C_130$], [$(3,9)$], [$3$], [$u$; $(1)$],
  [$127$], [$[p]$], [$254$], [$ZZ_p times C_2$], [---], [$39963217 slash 20164$], [$u$; $2$ in $C_2$#super[\*]],
  [$127$], [$[u p]$], [$-127$], [$ZZ_p times C_2$], [---], [$3122041 slash 25600$], [$u$; $2$ in $C_2$#super[\*]],
  [$131$], [$[1]$], [$53$], [$ZZ_p times C_64 times C_2$], [$(0,42),(3,0)$], [$148$ #linebreak() $-10388 slash 289$], [$u$; $(3, 0)$ #linebreak() $u$; $(49, 1)$],
  [$131$], [$[u]$], [$-11$], [$ZZ_p times C_68 times C_2$], [$(3,32),(76,0)$], [$33 slash 4$ #linebreak() $220$], [$u$; $(41, 1)$ #linebreak() $u$; $(25, 0)$],
  [$131$], [$[p]$], [$131$], [$ZZ_p times C_4$], [---], [$655$ #linebreak() $5371 slash 25$], [$u$; $2$ in $C_4$ #linebreak() $u$; $2$ in $C_4$],
  [$131$], [$[u p]$], [$8646$], [$ZZ_p times C_4$], [---], [$80565$ #linebreak() $-29168680211 slash 7425625$], [$u$; $2$ in $C_4$ #linebreak() $u$; $2$ in $C_4$],
  [$137$], [$[1]$], [$7$], [$ZZ_p times C_126$], [$(5,24)$], [$-3$], [$u$; $(97)$],
  [$137$], [$[u]$], [$3$], [$ZZ_p times C_150$], [$(3,9)$], [$3$], [$u$; $(1)$],
  [$137$], [$[p]$], [$274$], [$ZZ_p times C_2$], [---], [$331123731117 slash 5803544761$], [$u$; $2$ in $C_2$#super[\*]],
  [$137$], [$[u p]$], [$-411$], [$ZZ_p times C_2$], [---], [$1101728244 slash 3508129$], [$u$; $2$ in $C_2$#super[\*]],
  [$139$], [$[1]$], [$51$], [$ZZ_p times C_42 times C_3$], [$(2,23),(93,43)$], [$-17$ #linebreak() $-714 slash 25$], [$u$; $(34, 1)$ #linebreak() $u$; $(19, 2)$],
  [$139$], [$[u]$], [$3$], [$ZZ_p times C_154$], [$(1,68)$], [$3$], [$u$; $(71)$],
  [$139$], [$[p]$], [$139$], [$ZZ_p times C_2$], [---], [$417 slash 4$], [$u$; $2$ in $C_2$#super[\*]],
  [$139$], [$[u p]$], [$-139$], [$ZZ_p times C_2$], [---], [$3892 slash 9$], [$u$; $2$ in $C_2$#super[\*]],
  [$149$], [$[1]$], [$53$], [$ZZ_p times C_68 times C_2$], [$(0,18),(13,0)$], [$148$ #linebreak() $-10388 slash 289$], [$u$; $(47, 0)$ #linebreak() $u$; $(38, 1)$],
  [$149$], [$[u]$], [$94$], [$ZZ_p times C_82 times C_2$], [$(1,36),(40,0)$], [$141$ #linebreak() $1833 slash 16$], [$u$; $(50, 1)$ #linebreak() $u$; $(5, 0)$],
  [$149$], [$[p]$], [$-149$], [$ZZ_p times C_4$], [---], [$1639$ #linebreak() $8791 slash 25$], [$u$; $2$ in $C_4$ #linebreak() $u$; $2$ in $C_4$],
  [$149$], [$[u p]$], [$13559$], [$ZZ_p times C_4$], [---], [$20413$ #linebreak() $712634381069 slash 37982569$], [$u$; $2$ in $C_4$ #linebreak() $u$; $2$ in $C_4$],
  [$151$], [$[1]$], [$1$], [$ZZ_p times C_154$], [$(0,1)$], [$0$], [$u$; $(1)$],
  [$151$], [$[u]$], [$-1$], [$ZZ_p times C_150$], [$(1,1)$], [$1$], [$u$; $(1)$],
  [$151$], [$[p]$], [$755$], [$ZZ_p times C_2$], [---], [$151$], [$u$; $2$ in $C_2$#super[\*]],
  [$151$], [$[u p]$], [$453$], [$ZZ_p times C_2$], [---], [$3366104446853292 slash 32473665853489$], [$u$; $2$ in $C_2$#super[\*]],
  [$157$], [$[1]$], [$1$], [$ZZ_p times C_171$], [$(0,1)$], [$0$], [$u$; $(1)$],
  [$157$], [$[u]$], [$5$], [$ZZ_p times C_145$], [$(4,17)$], [$4$], [$u$; $(1)$],
  [$157$], [$[p]$], [$157$], [$ZZ_p$], [---], [$4195788 slash 2809$], [$u$; ---],
  [$157$], [$[u p]$], [$2355$], [$ZZ_p$], [---], [$22623639965396331 slash 4382453351761$], [$u$; ---],
  [$163$], [$[1]$], [$1$], [$ZZ_p times C_189$], [$(0,1)$], [$0$], [$u$; $(1)$],
  [$163$], [$[u]$], [$-1$], [$ZZ_p times C_139$], [$(1,1)$], [$1$], [$u$; $(1)$],
  [$163$], [$[p]$], [$978$], [$ZZ_p$], [---], [$933$], [$u$; ---],
  [$163$], [$[u p]$], [$815$], [$ZZ_p$], [---], [$-2464911059 slash 18309841$], [$u$; ---],
  [$167$], [$[1]$], [$-13$], [$ZZ_p times C_144$], [$(3,72)$], [$247$], [$u$; $(119)$],
  [$167$], [$[u]$], [$-6$], [$ZZ_p times C_192$], [$(2,71)$], [$21$], [$u$; $(161)$],
  [$167$], [$[p]$], [$334$], [$ZZ_p times C_2$], [---], [$58617 slash 4$], [$u$; $2$ in $C_2$#super[\*]],
  [$167$], [$[u p]$], [$-334$], [$ZZ_p times C_2$], [---], [$743828521 slash 1444804$], [$u$; $2$ in $C_2$#super[\*]],
  [$173$], [$[1]$], [$51$], [$ZZ_p times C_86 times C_2$], [$(0,47),(16,0)$], [$-17$ #linebreak() $-714 slash 25$], [$u$; $(41, 0)$ #linebreak() $u$; $(16, 1)$],
  [$173$], [$[u]$], [$53$], [$ZZ_p times C_88 times C_2$], [$(2,35),(95,0)$], [$148$ #linebreak() $-10388 slash 289$], [$u$; $(39, 0)$ #linebreak() $u$; $(64, 1)$],
  [$173$], [$[p]$], [$-173$], [$ZZ_p times C_4$], [---], [$4671 slash 25$ #linebreak() $84078 slash 289$], [$u$; $2$ in $C_4$ #linebreak() $u$; $2$ in $C_4$],
  [$173$], [$[u p]$], [$519$], [$ZZ_p times C_4$], [---], [$3633 slash 4$ #linebreak() $-1211 slash 25$], [$u$; $2$ in $C_4$ #linebreak() $u$; $2$ in $C_4$],
  [$179$], [$[1]$], [$1$], [$ZZ_p times C_180$], [$(0,1)$], [$0$], [$u$; $(1)$],
  [$179$], [$[u]$], [$-19$], [$ZZ_p times C_180$], [$(6,78)$], [$9772 slash 361$], [$u$; $(161)$],
  [$179$], [$[p]$], [$179$], [$ZZ_p times C_2$], [---], [$21659 slash 169$], [$u$; $2$ in $C_2$#super[\*]],
  [$179$], [$[u p]$], [$-537$], [$ZZ_p times C_2$], [---], [$1428490275232098 slash 2937758292121$], [$u$; $2$ in $C_2$#super[\*]],
  [$181$], [$[1]$], [$1$], [$ZZ_p times C_190$], [$(0,1)$], [$0$], [$u$; $(1)$],
  [$181$], [$[u]$], [$7$], [$ZZ_p times C_174$], [$(4,28)$], [$-3$], [$u$; $(73)$],
  [$181$], [$[p]$], [$-181$], [$ZZ_p times C_2$], [---], [$1267 slash 9$], [$u$; $2$ in $C_2$#super[\*]],
  [$181$], [$[u p]$], [$-1086$], [$ZZ_p times C_2$], [---], [$113125 slash 121$], [$u$; $2$ in $C_2$#super[\*]],
  [$191$], [$[1]$], [$1$], [$ZZ_p times C_217$], [$(0,1)$], [$0$], [$u$; $(1)$],
  [$191$], [$[u]$], [$-1$], [$ZZ_p times C_167$], [$(1,1)$], [$1$], [$u$; $(1)$],
  [$191$], [$[p]$], [$191$], [$ZZ_p$], [---], [$147421 slash 49$], [$u$; ---],
  [$191$], [$[u p]$], [$-191$], [$ZZ_p$], [---], [$32463476400 slash 184334929$], [$u$; ---],
  [$193$], [$[1]$], [$1$], [$ZZ_p times C_201$], [$(0,1)$], [$0$], [$u$; $(1)$],
  [$193$], [$[u]$], [$5$], [$ZZ_p times C_187$], [$(4,17)$], [$4$], [$u$; $(1)$],
  [$193$], [$[p]$], [$-193$], [$ZZ_p$], [---], [$9866360014417 slash 20332193281$], [$u$; ---],
  [$193$], [$[u p]$], [$965$], [$ZZ_p$], [---], [$99428383084 slash 1100401$], [$u$; ---],
  [$197$], [$[1]$], [$-6$], [$ZZ_p times C_222$], [$(2,88)$], [$21$], [$u$; $(85)$],
  [$197$], [$[u]$], [$3$], [$ZZ_p times C_174$], [$(2,29)$], [$3$], [$u$; $(91)$],
  [$197$], [$[p]$], [$197$], [$ZZ_p times C_2$], [---], [$237188 slash 289$], [$u$; $2$ in $C_2$#super[\*]],
  [$197$], [$[u p]$], [$394$], [$ZZ_p times C_2$], [---], [$55718377785 slash 34175716$], [$u$; $2$ in $C_2$#super[\*]],
  [$199$], [$[1]$], [$-6$], [$ZZ_p times C_218$], [$(5,41)$], [$21$], [$u$; $(123)$],
  [$199$], [$[u]$], [$3$], [$ZZ_p times C_182$], [$(3,9)$], [$3$], [$u$; $(1)$],
  [$199$], [$[p]$], [$199$], [$ZZ_p times C_2$], [---], [$-995 slash 9$], [$u$; $2$ in $C_2$#super[\*]],
  [$199$], [$[u p]$], [$-199$], [$ZZ_p times C_2$], [---], [$6169 slash 16$], [$u$; $2$ in $C_2$#super[\*]],

)
#set text(size: 10.5pt)

The $22$ lines carrying two generators are exactly the twists where one point cannot suffice:
$E^d (QQ_p)$ is not procyclic there, so a rank-$1$ twist could never have worked, and the search
was forced to rank $2$. The $34$ lines with $E^d (QQ_p) tilde.equiv ZZ_p$ are the additive classes
with $c_p = 1$, where the torsion vanishes entirely.

As a spot check, the four lines at $p = 5$ reproduce @tab-primes and the table of §6.1 exactly ---
same twists $d = 1, 3, 5, -35$, same generators $(0,1)$, $(3,9)$, $(4,17)$,
$(59004 slash 1369, dots.h)$, same $M = 9, 3, 5, 5$ --- now with
$E^d (QQ_5) tilde.equiv ZZ_5 times C_9, ZZ_5 times C_3, ZZ_5, ZZ_5$ and the generator a unit in
the $ZZ_5$ factor in each case.

= Verification <sec-verify>

*Unconditional.* The certificate only ever uses *explicit rational points* plus a finite exact
computation. `ellrank` / `ellsaturation` are used to *find* points, but nothing depends on their
rank bounds being sharp: if the exhibited subgroup is dense, so is the full Mordell--Weil group.

*Internal consistency.* The $p$-adic implementation of the density test was validated against a
purely exact-rational reference implementation (1826 cases, 0 mismatches), and the
multi-generator version was validated against the single-generator one.

#block(fill: rgb("#fff4e6"), inset: 8pt, radius: 3pt, width: 100%)[
  *A bug that was found and fixed.* An earlier version of `densegroup` short-circuited with
  `if(rem == 1, break())` as soon as the running index reached $M$. That skipped the remaining
  generators, so they never contributed to the kernel lattice $L$ --- and condition (ii) is
  tested only on a basis of $L$. A twist whose generators were, say, $P_1 in.not E_1$ and
  $P_2 in E_1 without E_2$ (which *is* dense) was therefore reported as *not* dense.

  The bug is *one-sided*: it can only turn a true "dense" into a reported "not dense", never the
  reverse. Every positive result and every witness in this document is therefore unaffected;
  only negative results had to be re-examined. Doing so overturned the claim about
  $f = x^3 - 2$ --- see @sec-cm.
]

*Independent check on $X$ itself.* For each of two regions I enumerated exactly those residue
classes mod $p^k$ that are genuine reductions of points of $X(ZZ_p)$ with $y$ a unit, and
checked that every one is hit by an honest rational point built from the four twists:

#table(
  columns: 4, align: (center, center, center, center), stroke: 0.4pt + luma(150),
  table.header([$p$], [level], [$x, t in ZZ_p$], [$v_p (x) = v_p (t) = -1$]),
  [2], [$2^4$], [256 / 256 ✓],       [64 / 64 ✓],
  [3], [$3^4$], [2916 / 2916 ✓],     [2916 / 2916 ✓],
  [5], [$5^3$], [21250 / 21250 ✓],   [10000 / 10000 ✓],
  [7], [$7^2$], [2842 / 2842 ✓],     [1764 / 1764 ✓],
)

The two regions are needed because for $x, t in ZZ_p$ the value $f(x) f(t)$ only realises the
*unit* square classes; the classes of odd valuation live where $v_p (x) < 0$. The second region
is handled by the substitution $x = x' slash p$, $t = t' slash p$, $y = y' slash p^3$, which
turns the equation into $y'^2 = g(x') g(t')$ with $g(w) = w^3 + A p^2 w + B p^3$ and $x', t'$
units.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *A trap at $p = 2$.* For odd $p$, if $y$ is a unit and $y^2 equiv s space (mod p^k)$ then
  $plus.minus sqrt(s) equiv y space (mod p^k)$, so "all congruence solutions" is the correct
  target set. At $p = 2$ the congruence $y^2 equiv s space (mod 2^k)$ has *four* solutions but
  only two are genuine reductions, so the naive target set is a factor 2 too large and the check
  spuriously reports failure. The table above uses the corrected enumeration (lift $x, t$ mod
  $2^(k+4)$, require $s equiv 1 space (mod 8)$, and record $plus.minus sqrt(s)$).
]

= Remarks and open ends <sec-remarks>

*Rank 1 is not always enough.* As noted in @sec-local, non-cyclic $tilde(E)_delta (bb(F)_p)$ forces a
rank-$>= 2$ twist. At $p = 47$ we have $tilde(E)(bb(F)_47) tilde.equiv ZZ slash 30 times ZZ slash 2$
and the class $[1]$ needs $d = -11$ (rank 2); at $p = 67$,
$tilde(E)(bb(F)_67) tilde.equiv ZZ slash 28 times ZZ slash 2$ and $[1]$ needs $d = -221$.

== The CM case $f = x^3 - 2$ <sec-cm>

#block(fill: rgb("#fff4e6"), inset: 8pt, radius: 3pt, width: 100%)[
  *Corrigendum.* An earlier draft claimed that this $j = 0$ curve (CM by $ZZ[zeta_3]$) succeeds
  exactly for $p equiv 2 space (mod 3)$ and fails systematically for $p equiv 1 space (mod 3)$.
  *That was wrong* --- an artifact of testing only single generators from the $t_0$-family,
  compounded by the bug described in @sec-verify. It is corrected here.
]

With the full multi-generator search, $f = x^3 - 2$ in fact succeeds for *every* odd prime
$5 <= p <= 97$, and at $p = 2$ as well. The primes $p equiv 1 space (mod 3)$ are simply the ones that *require* a
rank-$2$ twist in the class $[1]$, precisely because CM by $ZZ[zeta_3]$ makes
$tilde(E)(bb(F)_p)$ frequently non-cyclic there (e.g. $tilde(E)(bb(F)_7)$-twist
$tilde.equiv (ZZ slash 3)^2$, $tilde(E)(bb(F)_19) tilde.equiv ZZ slash 9 times ZZ slash 3$,
$tilde(E)(bb(F)_73) tilde.equiv (ZZ slash 9)^2$). Witnesses: $p = 7, 19, 43, 67, 73$ take
$d = -41, -29, -29, -41, -41$. The anomalous prime $p = 61$ (where
$\#tilde(E)(bb(F)_61) = 61 = p$) likewise needs a rank-2 twist, $d = 2931$.

*The prime 2 is fine.* All eight classes of $QQ_2^times slash (QQ_2^times)^2$ are covered by
small twists, each of rank 1:

#table(
  columns: 9, align: center, stroke: 0.4pt + luma(150),
  table.header([class], [$1$], [$3$], [$5$], [$7$], [$2$], [$6$], [$10$], [$14$]),
  [$d$], [$1$], [$3$], [$-3$], [$-1$], [$-30$], [$-10$], [$10$], [$30$],
)

and the independent check on the surface is complete in both regions, $64 slash 64$ each at
$2^4$ and $256 slash 256$ each at $2^5$ (using the corrected $p = 2$ target set of @sec-verify). So for
$f = x^3 - 2$ every prime $<= 97$ other than $p = 3$ is settled *positively*; $p = 3$ is the one
place where the evidence points the other way, and @sec-cm-resid makes that precise.

*The one exception: $p = 3$, class $[u dot 3]$.* Here the four classes behave very
differently, and the difference is entirely the Tamagawa number:

#table(
  columns: 5, align: (center, center, center, center, left), stroke: 0.4pt + luma(150),
  table.header([class], [Kodaira], [$c_3$], [$M$], [outcome]),
  [$[1]$],       [$I I$],   [1], [3], [OK, $d = -1115$ (rank 2)],
  [$[u]$],       [$I I$],   [1], [3], [OK, $d = -1$ (rank 1)],
  [$[3]$],       [$I V^*$], [1], [3], [OK, $d = 3$ (rank 1)],
  [$[u dot 3]$], [$I V^*$], [3], [9], [*no witness with $|d| <= 100000$*],
)

In the bad class every twist has $c_3 = 3$ and
$ E_d (QQ_3) slash E_1 tilde.equiv (ZZ slash 3)^2 $
($E_1$ = kernel of reduction, as in @sec-local), so *two* independent generators are needed. This was
checked directly on $QQ_3$-points --- all eight non-trivial cosets have order 3 --- rather than
inferred from rational generators, which are exactly the biased sample. Yet across 41 twists of
rank $>= 2$ the achieved index is *always* 3, never 9: the images are invariably dependent. Two
vectors span $bb(F)_3^2$ with probability $48 slash 81$, so 41 independent failures would have
probability of order $0.41^41$.

=== Why exactly the class $[u dot 3]$: a CM mechanism <sec-cm-mech>

The non-cyclicity has an exact and entirely elementary explanation. For $y^2 = x^3 + k$,
$ psi_3 (x) = 3x^4 + 12 k x = 3 x (x^3 + 4k). $
The linear factor is the CM signature: $ZZ[zeta_3]$ contains $sqrt(-3)$ of norm 3 with
$(3) = (sqrt(-3))^2$ *ramified*, so $[3]$ factors and every $j = 0$ curve carries a rational
3-isogeny with kernel ${x = 0}$. That one is a red herring here --- for $d = -3$ its dual maps
$E_(d') (QQ_3)$ entirely into $E_1$.

The operative factor is the cubic. In this family $k = -2 d^3$, so $-4k = 8 d^3 = (2d)^3$ is a
*perfect cube*, the quartic splits off a second rational root $x = 2d$, and there is a second
Galois-stable subgroup of order 3, generated by
$ T_d = (2d, sqrt(6 d^3)), quad "defined over" QQ(sqrt(6d)). $
This is why $E[3]$ is decomposable for the whole family, matching the isogeny class ${1,3,9,3}$.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *The kernel characters.* A Galois-stable subgroup $C subset E[3]$ of order 3 consists of $O$
  and two points $plus.minus (x_0, y_0)$, so Galois permutes them through
  $"Aut"(ZZ slash 3) = {plus.minus 1}$ and acts on $C$ by a *quadratic* character
  $chi_C : G_QQ -> {plus.minus 1}$. Concretely $x_0 in QQ$ and $y_0^2 = f(x_0)$, so $chi_C$ is the
  character of $QQ(sqrt(d))$ where $d$ is the squarefree part of $f(x_0)$; we write $chi_d$ for it
  and call $d$ the *kernel field* of $C$. For the two kernels of a decomposable $E[3]$ this gives
  $chi_1 = chi_(d_1)$ and $chi_2 = chi_(d_2)$.

  #v(1mm)
  The Weil pairing $C_1 times C_2 -> mu_3$ is Galois-equivariant and non-degenerate, and Galois
  acts on $mu_3$ by the quadratic character of $QQ(zeta_3) = QQ(sqrt(-3))$. Hence
  $ chi_1 chi_2 = chi_(-3), quad "i.e." quad d_1 d_2 equiv -3 " modulo squares." $
  For $E_d : y^2 = x^3 - 2d^3$ the two kernels sit at $x = 0$ and $x = 2d$, with kernel fields
  $-2d$ and $6d$, and indeed $(-2d)(6d) = -12 d^2 equiv -3$. Twisting by $e$ replaces $chi_i$ by
  $chi_i chi_e$, i.e. $d_i$ by $d_i e$; this is what makes the pair $(d_1, d_2)$ move with the
  twist while their product stays $-3$.
]

Now $T_d in E_d (QQ_3)$ iff $6 d^3 = 6d dot d^2$ is a square in $QQ_3$, iff $6d$ is. Writing
$d = 3^a m$ with $m$ prime to 3, $6d = 2 dot 3^(a+1) m$ is a square in $QQ_3$ exactly when $a$
is odd and $2m equiv 1 space (mod 3)$, i.e. $m equiv 2 space (mod 3)$ --- which is precisely the
definition of the class $[u dot 3]$.

#table(
  columns: 6, align: (center, center, center, center, center, left), stroke: 0.4pt + luma(150),
  table.header([class], [$6d$ square in $QQ_3$?], [$E_d (QQ_3)_"tors"$], [$c_3$], [$M$],
               [$E_d (QQ_3) slash E_1$]),
  [$[3]$ ($m equiv 1$)],       [no],  [trivial],      [1], [3],
    [$ZZ slash 3$, *procyclic* --- rank 1 suffices],
  [$[u dot 3]$ ($m equiv 2$)], [yes], [$ZZ slash 3$], [3], [9],
    [$(ZZ slash 3)^2$ --- rank $>= 2$ *mandatory*],
)

Verified with no exceptions on all 458 squarefree twists with $|d| <= 1500$ lying in the
two ramified classes (`cm-torsion.gp`). So the Tamagawa jump $c_3 : 1 -> 3$, the doubling
of $M$, and the non-cyclicity all have a single source: an extra $QQ_3$-rational 3-torsion point,
present in that class and in no other. *No Brauer group is needed for any of this.* (The same local picture arises for other curves too --- at $p = 3$, $M = 9$ forces additive reduction with $c_3 = 3$ --- which is what makes the control experiment below possible.)

=== The residual failure, and a control experiment <sec-cm-resid>

Only the second half is left: not why two independent generators are *needed*, but why they
never *occur*. First, that the failure is real.

#table(
  columns: 3, align: (left, center, center), stroke: 0.4pt + luma(150),
  table.header([search over class $[u dot 3]$], [twists of rank $>= 2$], [dense]),
  [even root number, $|d| <= 100000$], [708], [*0*],
  [odd root number (rank $>= 3$), $|d| <= 30000$], [5], [*0*],
)

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Proposition (the question at $p = 3$ is a dichotomy).* This is the instance at $p = 3$ of the
  equivalence proved in @sec-criterion; the direct argument below also identifies the open set that is missed.
  For $f = x^3 - 2$,
  $ X(QQ) "is dense in" X(QQ_3) quad <==> quad exists d "in the class" [u dot 3] "with" \
    E_d (QQ) --> E_d (QQ_3) slash 3 E_d (QQ_3) tilde.equiv (ZZ slash 3)^2 quad "surjective." $

  #v(2mm)
  ($arrow.l.double$) $E_delta (QQ_3) tilde.equiv ZZ_3 times ZZ slash 3$ is pro-3, so
  $E_d (QQ)$ surjecting onto the Frattini quotient $E slash 3E$ forces
  $overline(E_d (QQ)) = E_delta (QQ_3)$ by topological Nakayama; the sufficient criterion of @sec-criterion
  then applies, the other three classes already having witnesses.

  #v(1mm)
  ($arrow.r.double$) Otherwise every $d$ gives an image of dimension $<= 1$, so *every* rational
  point of $X$ in the $[u dot 3]$ part yields a pair whose images in $W_3$ are linearly
  *dependent*. Pairs with independent images form a non-empty open subset of $X(QQ_3)$, because
  $W_3$ is a finite discrete quotient of $E_delta (QQ_3)$. Density therefore fails.
]

Only twists of rank $>= 2$ can surject: the sole squarefree $d$ in this class with rational
3-torsion is $d = 6$, of rank 0 (checked for all $|d| <= 200000$), so
$dim E_d (QQ) slash 3 = "rank"$ throughout the class and rank $<= 1$ cannot span.

So the search above is not merely a failure to find witnesses --- it is evidence for a *negative*
statement, and the negative statement is exactly the failure of 3-adic density. What stops this
being a theorem is only that the right-hand side quantifies over infinitely many twists, of which
713 have been checked. A Brauer--Manin obstruction, if constructed, would settle all of them at
once; that is the real reason to want one.

*Not an artifact.* The exhibited generators were audited for 3-saturation (`ellisdivisible` on
all eight non-zero combinations, 40 twists of rank $>= 2$): no non-saturated combination exists.
So the image really is that of $E_d (QQ) slash 3 E_d (QQ)$, not of a proper subgroup.

*Reformulation.* $E_1$ and $3 E_d (QQ_3)$ are both torsion-free of index 9 in $E_d (QQ_3)$, hence
equal. The failure therefore reads: the localisation map
$ E_d (QQ) slash 3 E_d (QQ) --> E_d (QQ_3) slash 3 E_d (QQ_3) tilde.equiv (ZZ slash 3)^2 $
always has image of dimension $<= 1$.

*Three explanations ruled out.* (i) It is not "rational points stay in $E_0$": of 285 generators,
198 hit the component group. (ii) There is no universal functional --- in the canonical basis
$(E_0 slash E_1, ⟨T_d⟩)$ the occupied line ranges over *all four* lines, with multiplicities
$10, 13, 6, 9$. (iii) It is not either 3-isogeny descent: both duals $hat(phi)_1, hat(phi)_2$
were built explicitly (checking $hat(phi)_i compose phi_i = [3]$) and both have local image
*exactly* $E_1$, i.e. trivial in the quotient, so neither cuts out an index-3 subgroup containing
the rational points.

*The control.* At $p = 3$, $M = 9$ forces additive reduction with $c_3 = 3$; other curves have
classes with exactly that local structure, so the phenomenon can be tested against controls.

#table(
  columns: 5, align: (left, center, center, center, center), stroke: 0.4pt + luma(150),
  table.header([curve], [CM?], [$E[3]$], [rank $>= 2$ twists], [dense]),
  [$x^3 - 2$ ($p = 3$)],            [yes], [*decomposable*],  [708], [*0*],
  [$x^3 + 2$],                      [yes], [*decomposable*],  [41],  [*0*],
  [$x^3 plus.minus 3, 5, 6, 7, 11$],[yes], [not decomp.],     [26--35], [6--30],
  [$x^3 plus.minus 3x + 1$, $x^3 plus.minus 6x + 1$], [no], [not decomp.], [26--53], [12--38],
  [$x^3 - 24x plus.minus 26$],      [no],  [*decomposable*],  [43],  [15],
  [$x^3 + 21x plus.minus 26$],      [no],  [*decomposable*],  [36],  [*0*],
  [$x^3 - 2$ at $p = 7$, class $[u]$], [yes], [---],          [25],  [20],
)

Two things follow, and both correct the framing of @sec-cm-mech. *CM is not necessary*: the family
$x^3 + 21x plus.minus 26$ ($j = 9261 slash 8$, no CM) is obstructed exactly like $x^3 - 2$. And
*decomposable $E[3]$ is necessary in every case observed but not sufficient*, since
$x^3 - 24x plus.minus 26$ is decomposable and behaves normally. Decomposability is precisely the
condition $"End"_G (E[3]) supset.eq bb(F)_3 times bb(F)_3 supset.neq bb(F)_3$ feeding the
Skorobogatov--Zarhin description of the odd-order part of $"Br"(overline(X))^G$ for
$X = "Kum"(E times E)$ --- the expected *input* for a 3-torsion class, which need not then exist.
The last row shows there is nothing hard about surjecting onto $(ZZ slash 3)^2$ in general.

*The obstruction is not local.* Comparing the obstructed $x^3 + 21x + 26$ with the
non-obstructed $x^3 - 24x + 26$ on every local invariant at 3: same reduction type, $c_3 = 3$,
$M = 9$, quotient $(ZZ slash 3)^2$; two rational roots of $psi_3$ of which exactly one becomes
$QQ_3$-rational (61 of 61 twists each); trivial rational torsion; isogeny class $\{1, 3, 3\}$;
kernel fields with $chi_1 chi_2 = chi_(-3)$, one ramified at 3. They are *locally
indistinguishable at 3*, yet one family fails systematically and the other does not. No local
condition at 3 can therefore be the explanation: the constraint must involve global input.

That is the signature of a *Brauer--Manin / reciprocity* obstruction, and it eliminates the whole
class of local explanations pursued above. Note that BM *can* obstruct density at a single prime
even when $X(QQ) != nothing$: one needs
$overline(X(QQ))^((p)) subset.eq "pr"_p (X(bb(A))^"Br")$ to be proper, which happens exactly when
some $cal(A) in "Br"(X)$ has $"inv"_v cal(A)$ constant on $X(QQ_v)$ for every $v != p$ and
non-constant at $p$. Descent-with-reciprocity and the transcendental Brauer class are largely two
views of the same mathematics, so these were never really competing explanations.

=== How rare is the obstruction? <sec-cm-rare>

That global lead pans out, but the honest conclusion is a finiteness statement rather than a
criterion. Every decomposable family has a twist with a rational 3-torsion *point*, so the
$X_1(3)$ family $y^2 + a_1 x y + a_3 y = x^3$ sees them all up to twist. There
$psi_3 = x (3x^3 + a_1^2 x^2 + 3 a_1 a_3 x + 3 a_3^2)$, and solving the cubic factor for $a_3$
forces $-3(12x + 1)$ to be a square. So the decomposable families are parametrised by a genus-0
curve: with $a_1 = 1$,
$ x = -(w^2 + 3) slash 36, quad quad a_3 = x(-3 plus.minus w) slash 6, quad quad w in QQ. $
There are therefore *infinitely many* decomposable families.

Scanning $|a_1|, |a_3| <= 130$ gives 39 of them, 19 with an $M = 9$ class at $p = 3$ and hence
testable. Writing $j$ in lowest terms, the primes dividing the denominator are exactly the primes
of *potentially multiplicative* reduction --- a twist-invariant notion --- and the outcome splits
on them without exception:

#table(
  columns: 3, align: (left, center, center), stroke: 0.4pt + luma(150),
  table.header([denominator of $j$], [families], [outcome]),
  [$1$ or a power of $2$ --- $j = 0$ and $j = 9261 slash 8$], [2], [*obstructed* (0 dense)],
  [divisible by some $p >= 5$ --- $5, 7, 13, 19, 31, 37, 61, 127$ occur], [17],
    [free (5--30 dense each)],
)

*But the obstructed side is not a small sample --- it is the entire population.* Searching the
genus-0 parametrisation directly over 2 433 532 values of $w$ (all $m slash n$ with
$|m|, n <= 1000$) turns up *exactly two* $j$-invariants whose denominator is a power of 2:
$j = 0$ and $j = 9261 slash 8$. That is what one expects: $j in ZZ[1 slash 2]$ on a genus-0 curve
minus its cusps is a Siegel-type finiteness condition. So on current evidence the obstruction
occurs for exactly two families out of infinitely many, and both have been found.

#block(fill: rgb("#fff4e6"), inset: 8pt, radius: 3pt, width: 100%)[
  *What this does and does not establish.* The negative direction is well supported: 17 of 17
  families having a potentially multiplicative prime $>= 5$ are unobstructed. The positive
  direction is *underdetermined by the data* --- with only two obstructed families in existence,
  any property those two happen to share would fit equally well, and $j = 0$ and
  $j = 9261 slash 8$ share many. "Denominator a power of 2" is singled out here not by the
  statistics but because it is the invariant with the right Brauer--Manin meaning.
]

That meaning: BM localises at a single prime $p$ only when $"inv"_v cal(A)$ is constant on
$X(QQ_v)$ for every $v != p$. Each prime of potentially multiplicative reduction is an extra place
at which the local evaluation can vary, and one such place suffices to let an adelic point be
corrected there, dissolving the obstruction at 3. The two obstructed families are precisely those
with the smallest possible set of bad primes --- potentially good reduction away from
$\{2, 3\}$. Reproduced by `families.gp`.

=== Background: the objects the argument uses <sec-cm-bg>

Everything below is standard, but it is the part of the story furthest from the elementary
computations, so here it is spelled out. Throughout $ell$ is an odd prime ($ell = 3$ in practice),
$G_v = "Gal"(overline(QQ_v) slash QQ_v)$, and $W_v = E(QQ_v) slash ell E(QQ_v)$.

*The Kummer map.* Applying Galois cohomology to
$0 -> E[ell] -> E limits(-->)^ell E -> 0$ over $QQ_v$ gives a connecting map
$ delta_v : E(QQ_v) slash ell E(QQ_v) arrow.hook H^1 (G_v, E[ell]), $
explicitly $delta_v (P) = (sigma |-> sigma Q - Q)$ for any $Q$ with $ell Q = P$; changing $Q$
changes the cocycle by a coboundary. It is injective, and we keep its source and its image apart:
$W_v$ always denotes the *quotient group* $E(QQ_v) slash ell$, and
$ L_v := delta_v (W_v) subset.eq H^1 (G_v, E[ell]) $
its image, the *local Kummer image*. They are isomorphic, but $W_v$ is a quotient of a group of
points --- the one the density criterion of @sec-local speaks about --- while $L_v$ is a subspace
of a cohomology group, and only $L_v$ can be intersected with, or compared to, other subgroups of
$H^1$. A bilinear form on $L_v$ pulls back along $delta_v$ to a form on $W_v$ and we give the two
the same name; a *subgroup of $H^1$* is never written $W_v$. The same construction over $QQ$ gives a global
$delta : E(QQ) slash ell -> H^1 (G_QQ, E[ell])$ whose localisation at $v$ is $delta_v$.

*The local pairing.* Cup product gives
$H^1 (G_v, E[ell]) times H^1 (G_v, E[ell]) -> H^2 (G_v, E[ell] ⊗ E[ell])$; pushing
forward along the Weil pairing $e_ell : E[ell] ⊗ E[ell] -> mu_ell$ lands in
$H^2 (G_v, mu_ell) = "Br"(QQ_v)[ell]$. Local class field theory identifies
$"Br"(QQ_v) tilde.equiv QQ slash ZZ$ for finite $v$ (and $(1 slash 2) ZZ slash ZZ$ for $v = infinity$)
by the *invariant* map $"inv"_v$. The composite
$ ⟨ dot, dot ⟩_v : H^1 (G_v, E[ell]) times H^1 (G_v, E[ell]) --> (1 slash ell) ZZ slash ZZ $
is the *local Tate pairing*. It is *symmetric*: cup product on $H^1 times H^1$ is
anti-symmetric and $e_ell$ is anti-symmetric, and the two signs cancel. For $ell = 3$ the reader
who prefers concreteness may think of it as a cubic analogue of the Hilbert symbol.

*Terminology.* For a bilinear form $beta$ on a finite-dimensional space $V$, a subspace
$U subset.eq V$ is *isotropic* if $beta$ vanishes on it identically, i.e.
$U subset.eq U^perp = {v : beta(v, U) = 0}$. If $beta$ is non-degenerate then
$dim U + dim U^perp = dim V$, so isotropic forces $dim U <= dim V slash 2$; a subspace attaining
that bound, $U = U^perp$, is *Lagrangian* (= maximal isotropic).

*Tate local duality* says the pairing is non-degenerate and, crucially, that
$ L_v "is Lagrangian:" quad L_v = L_v^perp . $
That $L_v$ is isotropic is the concrete half one actually uses; the reason is that two points of
$E(QQ_v)$ can be divided by $ell$ inside a common field, so their cocycles cup to a class that
splits. The dimension is fixed by the local Euler characteristic
$\#H^1 = \#H^0 dot \#H^2 dot |\#E[ell]|_v^(-1)$ together with $\#H^2 = \#H^0$ (also duality). At
$v = ell = 3$ with $E[3](QQ_3) tilde.equiv ZZ slash 3$ this gives
$\#H^1 = 3 dot 3 dot 9 = 81$, so $dim H^1 = 4$ and $dim W_3 = 2$ --- matching the direct count
$dim W_3 = 1 + dim E(QQ_3)[3]$.

*Global reciprocity.* The fundamental exact sequence of global class field theory,
$ 0 -> "Br"(QQ) -> plus.big_v "Br"(QQ_v) limits(-->)^(sum "inv"_v) QQ slash ZZ -> 0 , $
says that a Brauer class defined over $QQ$ has local invariants summing to zero. Feeding a
*global* cohomology class into the cup product above therefore gives, for $P, Q in E(QQ)$,
$ sum_v ⟨ delta_v P, psi delta_v Q ⟩_v = 0 $
for any Galois-equivariant $psi$ on $E[ell]$ --- equivariance being what makes the cup product a
class over $QQ$ in the first place. This is the engine of the whole argument. It is the same kind
of statement as quadratic reciprocity in the form "the product of all Hilbert symbols is 1": a
constraint linking every place at once, so that if all places but one are forced to contribute
nothing, the remaining place inherits a condition.

*Two vanishing facts.* (i) $H^1 (G_v, C_i)$ is isotropic, because the pairing factors through
$e_ell$ restricted to $C_i times C_i$, which is trivial: $e_ell$ is alternating and $C_i$ is
cyclic. (ii) At $v tilde.not ell$ of good reduction, $L_v$ equals the *unramified* subgroup
$H^1_"ur" (G_v, E[ell]) = H^1 ("Gal"(QQ_v^"ur" slash QQ_v), E[ell]^(I_v))$, which is its own
annihilator; and a Galois-equivariant $psi$ preserves it, so the pairing of $L_v$ against
$psi L_v$ vanishes.

*Two counting facts.* (iii) For $v tilde.not ell$, $E(QQ_v)$ is (topologically) a product of a
pro-$v$ group with a finite group; the pro-$v$ part is uniquely $ell$-divisible, so multiplication
by $ell$ has kernel and cokernel of equal size and
$W_v tilde.equiv E(QQ_v)[ell]$. (iv) At a prime $q$ of split multiplicative reduction the Tate
parametrisation gives $E(QQ_q) tilde.equiv QQ_q^times slash q_E^ZZ$ with
$v_q (q_E) = -v_q (j)$, whence $E(QQ_q)[ell]$ has order $ell^2$ exactly when
$mu_ell subset QQ_q$ (i.e. $q equiv 1$ mod $ell$) *and* $q_E$ is an $ell$-th power up to units,
i.e. $ell divides v_q (j)$. That is the source of condition (D) in @sec-general.

=== What the obstruction must be <sec-cm-form>

Nothing below constructs a Brauer class, and nothing below needs one. When this section was first
drafted the plan was to exhibit $cal(A) in "Br"(X)$ and evaluate $"inv"_v cal(A)$ directly; what
actually happened is that the *mechanism* --- a twisted pairing plus reciprocity --- turned out to
prove the statement on its own, so the class became an optional extra rather than a prerequisite.
It also accounts for every observation above, including the one that resisted longest.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *The class, and the symbol that was missing.* Both of the obstacles this box used to record have
  since been removed. They are recorded here because the argument below was built to avoid them,
  and still does.

  #v(1.5mm)
  *The class.* $E[3] = C_1 xor C_2$ with $C_1 tilde.equiv ZZ slash 3$ and
  $C_2 tilde.equiv mu_3$, so $beta_3 (P,Q) = ⟨alpha_2 (P), alpha_1 (Q)⟩_3$ is the cup product of a
  class in $QQ_3^times slash 3$ with a class in $"Hom"(G_3, ZZ slash 3)$: a *cyclic algebra* of
  degree 3, not a symbol $(g_1, g_2)_3$, which would need $zeta_3 in.not QQ$. Both entries are
  explicit. Setting $w = v sqrt(6d) slash 6$ and $z = v sqrt(-2d) slash 2$ on $E_d : d v^2 = f(x)$
  clears the twist and lands on two *fixed* curves of conductor 27, each with a rational 3-torsion
  point,
  $ E_((6)) : 6w^2 = x^3 - 2, quad T = (2,1); quad quad E_((-2)) : -2z^2 = t^3 - 2, quad S = (0,1), $
  whose tangents there are $w = x-1$ and $z = 1$. Normalised as $G = 36(w - x + 1)$ and
  $H = (z-1) slash 2$ they satisfy $G sigma(G) = (-6(x-2))^3$ and $H sigma(H) = (t slash 2)^3$, and
  $cal(A) = "cor"_(F(X) slash QQ(X)) (G, H)_3$ with $F(X) = QQ(X)(zeta_3, sqrt(6 f(x)))$. The full
  account, with the level-2 analogue worked out as an explicit quaternion algebra, is §7 of the
  survey document.

  #v(1.5mm)
  *The symbol.* PARI's `nfhilbert` and Sage's `hilbert_symbol` are *quadratic only*, and neither
  system has Brauer groups of surfaces, so a cubic norm-residue symbol at $v = 3$ had to be built.
  Away from 3 the symbol is *tame* and elementary; at $v = ell = 3$ it is wildly ramified, and the
  expectation here was that it would need an explicit reciprocity law (Artin--Hasse, Coleman). It
  does not. $QQ(zeta_3)$ has a *single* prime above 3, so for global $a, b$ the product formula
  gives the wild symbol as minus the sum of the tame ones; and every class of
  $K^times slash (K^times)^3$, $K = QQ_3 (zeta_3)$, has a global representative, since
  $U^((4)) subset.eq (K^times)^3$ and $pi^4$ generates $(9)$, so a class is determined by its
  valuation and its unit part modulo 9. The resulting symbol is non-degenerate, skew, and kills
  $(a, 1-a)$; `level3.gp` carries it out.

  #v(1.5mm)
  *What that buys.* $beta_3$ can now be *evaluated*. On 161 sampled points of $E_(-3)(QQ_3)$ it is
  alternating (0 of 161 diagonal values non-zero), it vanishes on all 9 pairs from $E_(-3)(QQ)$ ---
  the theorem below, seen at the critical place --- and its Gram matrix on a basis of $W_3$ is
  $mat(0,2;1,0)$. So $beta_3 equiv.not 0$ is now a computation as well as the coset argument of
  @sec-cm-beta3, and the two agree. Nothing below depends on this; the argument is still the one that
  needs no symbol at all.
]

Decomposability of $E[3]$ supplies a *non-scalar* $phi in "End"_G (E[3])$, namely projection onto
$C_1$. Twist the local Tate pairing by it:
$ beta_v (P, Q) = ⟨ delta_v P, phi delta_v Q ⟩_v . $
This is the step that was missing earlier. The *untwisted* pairing vanishes identically on the
Kummer image $L_v$, because $L_v$ is Lagrangian --- which is why plain reciprocity gave only
$0 = 0$ in @sec-cm-resid. The twisted pairing carries no such constraint. Since $phi$ is
Galois-equivariant, reciprocity still gives $sum_v beta_v (P,Q) = 0$ for global $P, Q$. If
$beta_v equiv 0$ for every $v != 3$, then $beta_3$ vanishes on all rational pairs, so the image of
$E_d (QQ)$ in $W_3$ is *$beta_3$-isotropic* --- and an isotropic subspace of a non-degenerate
2-dimensional symplectic $bb(F)_3$-space has dimension $<= 1$.

That is precisely the measured phenomenon, and it explains all four observations together:

#table(
  columns: 2, align: (left, left), stroke: 0.4pt + luma(150),
  table.header([observation], [explanation]),
  [image has dimension $<= 1$], [isotropic in a 2-dimensional symplectic space],
  [the line *varies* with $d$ (@sec-cm-resid)],
    [every line is isotropic, so no line is preferred --- the obstruction is a *pairing*, not a
     linear functional, which is why the search for a universal functional failed],
  [decomposable $E[3]$ necessary],
    [otherwise $"End"_G (E[3]) = bb(F)_3$, $phi$ is scalar and $beta$ collapses to the untwisted
     pairing, which vanishes on $L_v$],
  [few bad primes necessary (@sec-cm-rare)],
    [each extra place with $beta_v equiv.not 0$ lets the sum be balanced away from 3],
)

*A quantitative consequence, and it holds.* If this is right, the constraint should not switch off
abruptly outside the two obstructed families: in an unobstructed family, spanning still fails
whenever the compensating places happen to contribute zero for that particular twist. So the
spanning rate should sit *below* the unconstrained rate. Pooling all unobstructed families,
195 of 421 rank-$>= 2$ twists span, a rate of $0.463$, against $48 slash 81 = 0.593$ for two
uniform random vectors in $bb(F)_3^2$ --- some five standard errors low. The obstructed families
are then the extreme case, rate exactly $0$, of a mechanism that depresses the rate everywhere.
(The null model is crude: it assumes the two images are uniform and independent, and the sample
mixes ranks $2$ and higher, which biases the rate up rather than down.)

*The vanishing away from 3 is not a hypothesis --- it is provable.* The step that looked out of
reach turns out to be elementary for this family. Three observations:

- $W_infinity = E_d (RR) slash 3 = 0$, since $E_d (RR)$ is 3-divisible.
- At a prime $q != 3$ of *good* reduction, $L_q = H^1_"ur" (QQ_q, E[3])$ is its own
  annihilator under the Tate pairing, and $phi$ is Galois-equivariant so $phi_*$ preserves
  unramifiedness; hence $beta_q (W_q, W_q) subset.eq ⟨H^1_"ur", H^1_"ur"⟩ = 0$.
- At any $q != 3$, $W_q tilde.equiv E_d (QQ_q)[3]$, because $E_d (QQ_q)$ has a
  3-divisible subgroup of finite index. For $E_d : y^2 = x^3 - 2d^3$ the 3-torsion sits at
  $x = 0$ and $x = 2d$, so $W_q != 0$ requires $-2d$ or $6d$ to be a square in $QQ_q$.

(Here and below $q$ denotes a place; $ell$ is reserved for the *level* of the descent, which is
$3$ throughout this subsection.) The bad primes of $E_d$ divide $6d$. For $q divides d$ with
$q != 2, 3$ and $d$ squarefree,
$v_q (-2d) = v_q (6d) = 1$ is *odd*, so neither is a square and $W_q = 0$. This is a proof,
uniform in $d$, not a check: a scan of all 456 twists with $|d| <= 3000$ in the class finds no
exception. Hence

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  For every squarefree $d$ in the class $[u dot 3]$, the only places $v != 3$ at which $beta_v$
  can be non-zero are $v = 2$; and $W_2 = 0$ --- so $beta_2 = 0$ too --- unless $d$ is *even*.
  For *odd* $d$, reciprocity therefore gives $beta_3 (P,Q) = 0$ on all rational pairs outright.
]

Of the 456 twists with $|d| <= 3000$, 381 have $W_2 = 0$. So for those the image of $E_d (QQ)$ in
$W_3$ is $beta_3$-isotropic, and since a non-zero bilinear form on a 2-dimensional space has no
2-dimensional totally isotropic subspace, the image has dimension $<= 1$ --- *provided only that
$beta_3 equiv.not 0$*.

*$beta$ is alternating, which kills every place with $dim W_v <= 1$.* Write
$delta_v P = a_1 + a_2$ with $a_i in H^1 (QQ_v, C_i)$. Each $H^1 (C_i)$ is isotropic for the Tate
pairing, since the Weil pairing restricted to the cyclic $C_i$ is trivial; and $L_v$ is isotropic,
so $0 = ⟨delta_v P, delta_v P⟩ = 2 ⟨a_1, a_2⟩$, whence $⟨a_1, a_2⟩ = 0$ as $2$ is invertible mod 3.
Therefore
$ beta_v (P,P) = ⟨a_1 + a_2, a_1⟩ = ⟨a_1,a_1⟩ + ⟨a_2,a_1⟩ = 0 . $
So $beta_v$ is alternating on $W_v$, and in particular *vanishes identically whenever
$dim W_v <= 1$*.

That disposes of $v = 2$: since $zeta_3 in.not QQ_2$ (the extension $QQ_2 (zeta_3) slash QQ_2$ is
the unramified quadratic one), full 3-torsion is never $QQ_2$-rational, so $dim W_2 <= 1$ and
$beta_2 equiv 0$ for *every* $d$ --- the even-$d$ case included.

*$beta_3 equiv.not 0$.* This is the one point where the argument needs a fact about $E$ at 3 that
is not formal. The rest of this subsection proves it.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Claim.* Let $d$ be squarefree in the class $[u dot 3]$ and write $E = E_d$. The twisted pairing
  $ beta_3 (P, Q) = ⟨ delta_3 P, space phi_* delta_3 Q ⟩_3 $
  is *not* identically zero on $W_3 = E(QQ_3) slash 3 E(QQ_3)$.
]

==== Notation, kept apart <sec-cm-notation>

Three pairs of objects have to be distinguished; earlier drafts of these notes did not
distinguish them, and the argument is unreadable without the distinction.

- *The quotient and its Kummer image.* $W_3 = E(QQ_3) slash 3E(QQ_3)$ is a *quotient of the group
  of local points*, an $bb(F)_3$-vector space of dimension 2; it is the Frattini quotient that the
  density criterion of @sec-local refers to. Its image under the injective Kummer map is
  $ L_3 := delta_3 (W_3) subset.eq H^1 (QQ_3, E[3]), $
  a *subspace of a cohomology group*. The two are isomorphic, but they are not the same object,
  and only $L_3$ can be intersected with subgroups of $H^1$.

- *The projector and the map it induces.* $phi$ is the projector of $E[3]$ onto $C_1$ along $C_2$
  --- an endomorphism of a *Galois module*. Since $E[3] = C_1 xor C_2$ gives
  $H^1 (QQ_3, E[3]) = H_1 xor H_2$ with $H_i := H^1 (QQ_3, C_i)$, the map $phi$ induces on
  cohomology, written $phi_*$, is the projector onto $H_1$ along $H_2$.

- *The projector and the isogenies.* $psi_i : E -> B_i := E slash C_i$ is the 3-isogeny with kernel
  $C_i$, and $hat(psi)_i : B_i -> E$ is its dual, so $hat(psi)_i psi_i = 3$. These are isogenies of
  *curves*, whereas $phi$ is an endomorphism of the 3-torsion; earlier drafts wrote $phi$ and
  $hat(phi)$ for both. Here $E_1$ keeps the meaning it has from @sec-local --- the kernel of
  reduction --- and $N_i subset.eq B_i (QQ_3)$ denotes the kernel of reduction of $B_i$.

$beta_3$ is a bilinear form on $W_3$. Every statement below about *isotropy* is about subspaces of
$W_3$; every statement about *stability* is about the subspace $L_3$ of $H^1 (QQ_3, E[3])$.

==== The proof, in six steps <sec-cm-beta3>

*Step 1: $beta_3 equiv 0$ if and only if $L_3$ is $phi_*$-stable.* By definition $beta_3 equiv 0$
says $⟨w, phi_* w'⟩_3 = 0$ for all $w, w' in L_3$, that is, $phi_* L_3 subset.eq L_3^perp$. Tate
local duality (@sec-cm-bg) gives $L_3^perp = L_3$. So $beta_3 equiv 0$ iff
$phi_* L_3 subset.eq L_3$.

*Step 2: $L_3$ is $phi_*$-stable if and only if $L_3 = (L_3 inter H_1) xor (L_3 inter H_2)$.* If
$L_3$ is that direct sum it is stable, since $phi_*$ is the identity on $H_1$ and zero on $H_2$.
Conversely suppose $phi_* L_3 subset.eq L_3$. Then $(1 - phi_*) L_3 subset.eq L_3$ as well, and
since $phi_*$ is idempotent every $w in L_3$ decomposes as $w = phi_* w + (1 - phi_*) w$ with
$phi_* w in L_3 inter H_1$ and $(1 - phi_*) w in L_3 inter H_2$. The sum is direct because
$H_1 inter H_2 = 0$.

*Step 3: it therefore suffices to prove $L_3 inter H_1 = L_3 inter H_2 = 0$.* If both vanish then
by Step 2 a $phi_*$-stable $L_3$ would be zero --- but $dim L_3 = dim W_3 = 2$. So $L_3$ is not
$phi_*$-stable, and $beta_3 equiv.not 0$ by Step 1.

*Step 4: the two intersections, expressed inside $W_3$.* Let
$pi_i : H^1 (QQ_3, E[3]) -> H_i$ be the two projections attached to $H^1 = H_1 xor H_2$, and set
$ alpha_i := pi_i compose delta_3 : W_3 --> H_i . $
So $alpha_i$ is defined *on $W_3$*, and $ker alpha_i$ is a subspace of $W_3$ --- not of $H^1$. A
class $w = delta_3 (overline(P)) in L_3$ lies in $H_1$ exactly when its $H_2$-component vanishes,
i.e. exactly when $alpha_2 (overline(P)) = 0$, and symmetrically for $H_2$. Hence
$ L_3 inter H_1 = delta_3 (ker alpha_2), quad quad L_3 inter H_2 = delta_3 (ker alpha_1), $
and since $delta_3$ is injective the two intersections vanish if and only if
$ker alpha_1 = ker alpha_2 = 0$.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  Earlier drafts wrote "$L_3 inter H_1 = ker alpha_2$". That cannot be right as stated: the left
  side is a subspace of $H^1 (QQ_3, E[3])$ and the right side a subspace of
  $W_3 = E(QQ_3) slash 3$. What is true is that the first is the *image under $delta_3$* of the
  second; because $delta_3$ is injective this suffices for the only use made of the identity,
  namely that one vanishes exactly when the other does.
]

*Step 5: $ker alpha_i$ is the image of a dual isogeny.* Fix $i$ and let $j != i$. From
$hat(psi)_j psi_j = 3$ and $C_i inter C_j = 0$,
$ ker hat(psi)_j = psi_j (E[3]) = psi_j (C_i), $
and $psi_j$ restricts to an isomorphism of Galois modules $C_i arrow.r.tilde ker hat(psi)_j$. Take
$P in E(QQ_3)$ and $Q$ with $3Q = P$, and split the Kummer cocycle along $E[3] = C_1 xor C_2$:
$ sigma Q - Q = c_1 (sigma) + c_2 (sigma), quad c_i (sigma) in C_i, $
so that $alpha_i (overline(P)) = [c_i]$ by definition. Applying $psi_j$, which kills $C_j$,
$ sigma (psi_j Q) - psi_j Q = psi_j (c_i (sigma)) . $
The left-hand side is the cocycle of the *isogeny* Kummer map for $hat(psi)_j$ at $P$: indeed
$hat(psi)_j (psi_j Q) = 3Q = P$, so $psi_j Q$ is a $hat(psi)_j$-preimage of $P$, and the connecting
map of $0 -> ker hat(psi)_j -> B_j -> E -> 0$ is exactly
$ delta_(hat(psi)_j) : E(QQ_3) slash hat(psi)_j (B_j (QQ_3)) arrow.hook
  H^1 (QQ_3, ker hat(psi)_j) . $
Therefore $alpha_i$ factors as
$ W_3 = E(QQ_3) slash 3E(QQ_3) arrow.r.twohead E(QQ_3) slash hat(psi)_j (B_j (QQ_3))
  arrow.hook H^1 (QQ_3, ker hat(psi)_j) arrow.r.tilde H_i , $
where the second map is $delta_(hat(psi)_j)$ and the third is induced by $psi_j^(-1)$; the first is
defined because $3 E(QQ_3) = hat(psi)_j psi_j E(QQ_3) subset.eq hat(psi)_j (B_j (QQ_3))$. The
second and third maps are injective, so $ker alpha_i$ is the kernel of the first:
$ ker alpha_i = hat(psi)_j (B_j (QQ_3)) slash 3E(QQ_3) space subset.eq space W_3,
  quad quad j != i . $
In particular $ker alpha_i = 0$ if and only if $hat(psi)_j (B_j (QQ_3)) subset.eq 3E(QQ_3)$.

*Step 6: both dual images land in $3E(QQ_3)$.* By Steps 3--5 the claim is now a statement about
two explicit isogenies. Before proving it, here are the curves; their reduction at 3 is where
$\#A_i = 3$ comes from, and it is also the cheapest cross-check on the rest of the step.

*The three curves.* Take $d = -3$; the other five $d$ tested behave identically
(@sec-cm-beta3-remarks). Then $E = E_(-3) : y^2 = x^3 + 54$, and
$ psi_3 = 3x (x + 6)(x^2 - 6x + 36) $
has the two rational roots $x = 0$ and $x = 2d = -6$ --- hence the two Galois-stable lines. At
$x = -6$ one has $y^2 = -162 = 81 dot (-2)$ with $-2 in (ZZ_3^times)^2$, so
$C_1 = ⟨(-6, 9 sqrt(-2))⟩$ is $QQ_3$-rational, $C_1 tilde.equiv ZZ slash 3$; at $x = 0$ one has
$y^2 = 54$ with $v_3 (54) = 3$ odd, so $C_2$ is not, and $C_2 tilde.equiv mu_3$ by the Weil
pairing. Quotienting by each gives:

#align(center, table(
  columns: 7, align: (left, left, center, center, center, center, center),
  stroke: 0.4pt + luma(170), inset: (x: 7pt, y: 3.5pt),
  table.header([curve], [model minimal at 3], [Kodaira], [comps.],
               [mult. 1], [$Phi$], [$c_3$]),
  [$E$], [$y^2 = x^3 + 54$], [$"IV"^*$], [7], [3], [$ZZ slash 3$], [3],
  [$B_1 = E slash C_1$], [$y^2 = x^3 - 1080 x + 13662$], [$"II"^*$], [9], [1], [$0$], [1],
  [$B_2 = E slash C_2$], [$y^2 = x^3 - 2$], [$"II"$], [1], [1], [$0$], [1],
))

#v(2mm)

All three reductions are *additive*, so $tilde(C)^"ns" (bb(F)_3) tilde.equiv bb(F)_3^+$ has order
3 in every row and $M = c_3 dot 3$: thus $M = 9$ for $E$ --- as @sec-cm-resid already recorded ---
and $M_1 = M_2 = 3$.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *A trap worth naming.* `ellisogeny` returns $y^2 = x^3 - 1458$ for $B_2$, which is *not*
  minimal at 3: $1458 = 2 dot 3^6$, so $u = 3$ and the minimal model is $y^2 = x^3 - 2$ --- the
  curve of the title, i.e. the member $d = 1$ of the family. Since $E_1$ and $N_i$ are defined by
  $v_3 (x) < 0$ *on a minimal model*, the raw equation gives the wrong membership test. $B_1$ and
  $E$ happen to come out minimal at 3 already for $d = -3$, but not for every $d$: at $d = 6$ all
  three need a change of model.
]

*Why $\#A_i = 3$.* Kodaira types $"II"$ and $"II"^*$ both have *trivial component group* ---
$"II"$ has a single component, and $"II"^*$ has nine of which exactly one has multiplicity 1 ---
so $c_3 (B_i) = 1$ for both $i$. That is the statement that
$B_i (QQ_3) = B_i^0 (QQ_3)$: *every* $QQ_3$-point of $B_i$ lies on the identity component, and
none reduces to the singular point of the special fibre. Hence
$ A_i = B_i (QQ_3) slash N_i tilde.equiv tilde(B_i)^"ns" (bb(F)_3) tilde.equiv ZZ slash 3 , $
so $\#A_i = 3$ --- prime for a structural reason, not as the outcome of a count.

*And why $E$ is not like that.* $"IV"^*$ has seven components, three of multiplicity 1, and
$c_3 = 3$ says all three are rational. So $E(QQ_3)$ carries the full filtration
$ E_1 subset.eq E_0 (QQ_3) subset.eq E(QQ_3), quad
  E_0 (QQ_3) slash E_1 tilde.equiv bb(F)_3^+, quad
  E(QQ_3) slash E_0 (QQ_3) tilde.equiv ZZ slash 3 , $
which recovers $\#A = 9$ but leaves $A$ as either $ZZ slash 9$ or $(ZZ slash 3)^2$: an extension
of $ZZ slash 3$ by $ZZ slash 3$ can be either, and no reduction datum decides it. That is exactly
what half one has to settle, and it settles it with $T_d$ --- which the table cannot see, since
$T_d$ is a point and not a Kodaira symbol.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *To be shown:* $hat(psi)_i (B_i (QQ_3)) subset.eq 3 E(QQ_3)$ for $i = 1$ and $i = 2$.

  #v(2.5mm)
  The proof has two halves: that the subgroup $3E(QQ_3)$ *is* the kernel of reduction $E_1$, and
  that each $hat(psi)_i$ lands in $E_1$. Only the second involves the isogenies.

  #v(2.5mm)
  *Half one: $3 E(QQ_3) = E_1$.* Of the two 3-torsion kernels only $x = 2d$ is $QQ_3$-rational ---
  that point being $T_d$ --- so $\#E[3](QQ_3) = 3$, and the local formula
  $\#E(K) slash n E(K) = \#E(K)[n] dot |n|_K^(-1)$ gives
  $ \#E(QQ_3) slash 3E(QQ_3) = 3 dot 3 = 9 = \#E(QQ_3) slash E_1 . $
  So $3E$ and $E_1$ have the *same index* in $E(QQ_3)$, and it is enough to show that one contains
  the other.

  #v(1mm)
  Write $A = E(QQ_3) slash E_1$ and $A_0 = E_0 (QQ_3) slash E_1 subset.eq A$. By the filtration
  above, $A_0 tilde.equiv bb(F)_3^+$ is killed by 3 and $A slash A_0 tilde.equiv ZZ slash 3$. Now
  $T_d$ itself lies *outside* $E_0 (QQ_3)$: since $d$ is in the class $[u dot 3]$ we have
  $3 divides d$, so $v_3 (Delta) = v_3 (-1728 d^6) = 3 + 6 v_3 (d) = 9 < 12$ and the model
  $y^2 = x^3 - 2d^3$ is already minimal at 3; its reduction is $y^2 = x^3$, singular at $(0,0)$;
  and $T_d = (2d, sqrt(6d^3))$ has $v_3 (2d) >= 1$ and $v_3 (sqrt(6 d^3)) >= 2$, so $T_d$ reduces
  to $(0,0)$. Hence $overline(T_d)$ generates $A slash A_0$, and $3 T_d = O$. So $A$ is generated
  by $A_0$ and $overline(T_d)$, both killed by 3, and being abelian it is killed by 3. That says
  $3E subset.eq E_1$; with equal indices, $3E = E_1$. No search is involved: the witness is the
  torsion point the whole construction started from.

  #v(2.5mm)
  *Half two: $hat(psi)_i (B_i (QQ_3)) subset.eq E_1$.* An isogeny extends to the Néron models and
  hence carries the kernel of reduction into the kernel of reduction:
  $hat(psi)_i (N_i) subset.eq E_1$. Combined with $\#A_i = 3$ this reduces the half to the
  following, and the reduction is the whole point:

  #v(1mm)
  #block(fill: white, stroke: 0.4pt + luma(140), inset: 7pt, radius: 2pt, width: 100%)[
    It is enough to exhibit a *subgroup* $S_i subset.eq B_i (QQ_3)$ with
    $ (a) space hat(psi)_i (S_i) subset.eq E_1, quad quad (b) space S_i subset.eq.not N_i . $
    For then $(S_i + N_i) slash N_i$ is a non-trivial subgroup of $A_i$, which has *prime* order
    3, so $S_i + N_i = B_i (QQ_3)$; and therefore
    $hat(psi)_i (B_i (QQ_3)) = hat(psi)_i (S_i) + hat(psi)_i (N_i) subset.eq E_1$.
  ]

  #v(1mm)
  *For $i = 2$ the kernel of the dual serves, and nothing is computed.* By Step 5,
  $ker hat(psi)_2 = psi_2 (C_1) tilde.equiv C_1 tilde.equiv ZZ slash 3$, whose points *are*
  $QQ_3$-rational because those of $C_1$ are. Take $S_2 = (ker hat(psi)_2)(QQ_3)$, of order 3.
  Then (a) holds because $hat(psi)_2 (S_2) = O$, and (b) holds because $N_2 tilde.equiv ZZ_3$ is
  torsion-free and $S_2$ is not. So $B_2 (QQ_3) = S_2 + N_2$ and
  $hat(psi)_2 (B_2 (QQ_3)) = hat(psi)_2 (N_2) subset.eq E_1$ --- from the Kodaira data and the
  rationality of $C_1$ alone, with no point evaluated and no equation used.

  #v(1mm)
  *For $i = 1$ that choice is unavailable.* Here
  $ker hat(psi)_1 = psi_1 (C_2) tilde.equiv C_2 tilde.equiv mu_3$, and $mu_3 (QQ_3) = 0$ because
  $zeta_3 in.not QQ_3$; in fact $B_1 [3](QQ_3) = 0$ outright --- the 3-division polynomial of
  $B_1$ has a single root in $QQ_3$ and that root carries no $QQ_3$-point. So
  $(ker hat(psi)_1)(QQ_3) = 0$, which fails (b). Take instead
  $ S_1 = psi_1 (E(QQ_3)) . $
  Condition (a) is then free, and it is half one that makes it so:
  $hat(psi)_1 (S_1) = hat(psi)_1 psi_1 (E(QQ_3)) = 3E(QQ_3) = E_1$. Condition (b) is the one thing
  computed in this half --- a single $P in E(QQ_3)$ with $v_3 (x(psi_1 P)) >= 0$; of 162 sampled
  points of $E(QQ_3)$, 45 qualify.

  #v(1mm)
  ($S_i = psi_i (E(QQ_3))$ works for $i = 2$ as well --- 27 of the 162 escape $N_2$ --- so one may
  have the argument uniform at the cost of a computed point in both halves. The kernel-of-the-dual
  route is the free one, and only $i = 2$ has it.)

  #v(2.5mm)
  *Together.* $hat(psi)_i (B_i (QQ_3)) subset.eq E_1 = 3E(QQ_3)$ for $i = 1, 2$. $qed$
]

*The reduction data as a cross-check.* Both halves make predictions about where $QQ_3$-points
fall, and `beta3.gp` checks them. Of 162 sampled points of $E(QQ_3)$: 108 in $E_1$, 27 in
$E_0 without E_1$, and 27 outside $E_0$ --- all three layers occupied, as $c_3 = 3$ requires, and
every one of the 27 satisfies $3P in E_1$, corroborating on 27 points what half one gets from
$T_d$ alone. Of the sampled points of $B_1 (QQ_3)$ and $B_2 (QQ_3)$: *none* outside the identity
component, the direct corroboration of $c_3 (B_i) = 1$. The target curve `ellisogeny` produces for
$hat(psi)_i$ has the same minimal model as $E$ in every case, confirming that the isogeny built
from the kernel $psi_i (C_j)$ really does land back on $E$. And the older form of half two survives
as an independent check: evaluating $hat(psi)_i$ at one point of $B_i (QQ_3)$ outside $N_i$ gives
$v_3 (x(hat(psi)_i P_i)) = -2 < 0$, i.e. $hat(psi)_i P_i in E_1$, for both $i$ and all six $d$.

Reading the steps back: both dual images lie in $3E(QQ_3)$ (Step 6), so
$ker alpha_1 = ker alpha_2 = 0$ (Step 5), so $L_3 inter H_1 = L_3 inter H_2 = 0$ (Step 4), so
$L_3$ is not $phi_*$-stable (Steps 3 and 2), so $beta_3 equiv.not 0$ (Step 1). $qed$

==== Three remarks on Step 6 <sec-cm-beta3-remarks>

*Where the finiteness comes from, and why the two isogenies differ.* Everything in half two rests
on $\#A_i = 3$ being *prime*, which is the triviality of the component group at $"II"$ and
$"II"^*$ --- a fact about the special fibre of $B_i$, not an accident of a sample. It is also the
same order-3 observation the status note below records as *blocking* a structural shortcut, and
both readings are correct: a homomorphism $ZZ slash 3 -> (ZZ slash 3)^2$ need not vanish for order
reasons, so $overline(hat(psi)_i)$ is not zero automatically; but a source of prime order is
exactly what lets a single subgroup $S_i$ settle the map.

#v(1mm)
The asymmetry between $i = 1$ and $i = 2$ in half two is not an artefact of how the argument was
written --- it is the asymmetry between $C_1 tilde.equiv ZZ slash 3$ and $C_2 tilde.equiv mu_3$
that the whole construction is built on, seen once more. The kernel of $hat(psi)_i$ is $psi_i$ of
the *other* line, so it is $mu_3$ for $i = 1$ and $ZZ slash 3$ for $i = 2$; and only the latter has
$QQ_3$-points, because $zeta_3 in.not QQ_3$. Whether some third choice of $S_1$ makes $i = 1$ free
as well is open; nothing here decides it.

*One twist settles the class.* All $d$ in a square class give $QQ_3$-isomorphic curves, so a
single $d$ suffices. Both kernels and $d = -3, 6, -21, 87, -30, 69$ were run, with identical
results throughout: $E$ of type $"IV"^*$ with $c_3 = 3$, $B_1$ of type $"II"^*$ and $B_2$ of type
$"II"$, both with $c_3 = 1$; $T_d$ outside $E_0$ in all six; $ker hat(psi)_2$ $QQ_3$-rational and
$ker hat(psi)_1$ not, in all six; and $v_3 (x(hat(psi)_i P_i)) = -2$ in all twelve cases. The
equations change with $d$; none of the rest does.

*The computational inputs, and how they were checked.* After the reduction data is in hand, Step 6
rests on exactly two finite facts: that $\#E[3](QQ_3) = 3$, and that $v_3 (x(psi_1 P)) >= 0$ for
some $P in E(QQ_3)$. (Half one and the case $i = 2$ of half two need no point at all.) The older
form of the second, $v_3 (x(hat(psi)_i P_i)) = -2$ for some $P_i in.not N_i$, was obtained
three times independently --- by a PARI script that builds the duals by hand, by Sage's
`verify-dual.sage`, which constructs $QQ_3$-points and tests membership, and by a Magma run that
evaluates the dual isogenies' rational maps (`IsogenyMapPhi` / `IsogenyMapPsi`) at 3-adic
$x$-coordinates and reads off the valuation, constructing no points at all. Magma also
independently returned Kodaira type $"IV"^*$ and $c_3 = 3$ for $E$, the labels @sec-cm-resid
records. The table of curves, the Kodaira types of the $B_i$ and the layer census are produced by
`beta3.gp`; its output is `results/survey-beta3-curves.txt`.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Theorem.* For $f = x^3 - 2$ and *every*
  squarefree $d$ in the class $[u dot 3]$, the group $E_d (QQ)$ is not dense in $E_d (QQ_3)$.
  Consequently, by the equivalence of @sec-criterion, $X(QQ)$ is *not* dense in $X(QQ_3)$.

  #v(2mm)
  _Proof._ $beta_v equiv 0$ for every $v != 3$: at $v = infinity$ because $W_infinity = 0$; at
  good $q != 3$ by unramified isotropy; at $q divides d$ with $q != 2,3$ because
  $W_q = 0$ (odd valuation of $-2d$ and $6d$); and at $q = 2$ because $dim W_2 <= 1$ and
  $beta$ is alternating. Reciprocity $sum_v beta_v = 0$ then forces $beta_3 (P,Q) = 0$ for all
  $P, Q in E_d (QQ)$. Since $beta_3$ is alternating and non-zero on the 2-dimensional $W_3$ it is
  a symplectic form, so its isotropic subspaces have dimension $<= 1$; hence the image of
  $E_d (QQ)$ in $W_3$ has dimension $<= 1$ and cannot be all of $W_3$. Topological Nakayama
  (@sec-criterion) upgrades this to non-density in $E_d (QQ_3)$. $qed$
]

This is what the 713 twists were seeing. Note the proof covers *all* twists at once, which is
exactly what a finite search never could, and it is the reason the Brauer--Manin framing was worth
pursuing: the mechanism, not the class, is what does the work. Constructing
$cal(A) in "Br"(X)$ explicitly remains a separate and more ambitious question.

#block(fill: rgb("#fff4e6"), inset: 8pt, radius: 3pt, width: 100%)[
  *Status.* The argument is complete. What was for a long time its one unverified input ---
  $beta_3 equiv.not 0$, i.e. the failure of $phi_*$-stability of $L_3$ --- is settled by the
  exhaustive coset computation above, whose only imported ingredient is the standard fact that an
  isogeny carries $E'_1$ into $E_1$. Everything else is standard too: Tate local duality, isotropy
  of the Kummer image, reciprocity for the sum of local invariants. The argument should still be
  checked by hand before being relied on.

  #v(2mm)
  Before that, the input had been confirmed numerically three times, in three systems and by three
  different routes. The three are kept below, since they were what gave confidence that the
  statement was true while it was still unproved, and the last of them is what prompted looking
  for a proof.

  #v(2mm)
  *Independently verified in Sage 10.9.* The PARI computation built the dual isogenies by hand
  (locating the kernel by trial) and evaluated them with its own substitution code, so it was
  re-run using Sage's `EllipticCurveIsogeny.dual()` and `rational_maps()`. Sage reproduces the
  same codomains, confirms $hat(phi)_i compose phi_i = [3]$, and finds *no* $QQ_3$-point of either
  codomain whose image leaves $E_1$: 3376 points tested across $d = -3, 6, -21, 87$, zero
  outside. A structural shortcut looked unavailable --- the induced map
  $E' (QQ_3) slash E'_1 -> E (QQ_3) slash E_1$ has source of order 3, so it is not forced to
  vanish for order reasons. That is right as far as it goes, but the same order-3 fact is what
  makes the one-point check above exhaustive.

  #v(1mm)
  Sage also corrected the Kodaira labels in the table above, which read $I I^*$ in an earlier
  draft: PARI's code $-4$ is $I V^*$, not $I I^*$ (its starred types mirror the unstarred ones),
  and $I I^*$ is in any case incompatible with $c_3 = 3$. The mislabelling was cosmetic --- every
  computation used the numeric $c_p$ and $M$, never the symbol.

  #v(2mm)
  *And in Magma.* A third system and a third route: rather than construct $QQ_3$-points at all,
  evaluate the dual isogeny's rational maps `IsogenyMapPhi` and `IsogenyMapPsi` at 3-adic
  $x$-coordinates and read off the valuation of $x(hat(phi) P')$. For $d = -3, 6, -21, 87$ and both
  kernels: 244 and 20 points of $E'(QQ_3)$, *none* leaving $E_1$. Magma independently returns
  $I V^*$ and $c_3 = 3$ as well, confirming Sage's correction.

  ```
  Qx<x> := PolynomialRing(Rationals());
  K := pAdicField(3, 200);
  for d in [-3, 6, -21, 87] do
    E := EllipticCurve([0,0,0,0,-2*d^3]);
    printf "\nd = %o   Kodaira at 3 = %o   c_3 = %o\n",
           d, KodairaSymbol(E,3), TamagawaNumber(E,3);
    for ker in [x, x - 2*d] do
      Ep, phi := IsogenyFromKernel(E, ker);
      ph  := DualIsogeny(phi);
      num := IsogenyMapPhi(ph);  den := IsogenyMapPsi(ph);
      a := aInvariants(Ep);  A := K!a[4];  B := K!a[5];
      tot := 0; bad := 0;
      for n in [-8..30] do
        for u in [1,2,4,5,7,8,10,11] do
          x0 := K!u * K!3^n;
          v  := x0^3 + A*x0 + B;
          if v ne 0 and IsSquare(v) then
            d0 := Evaluate(ChangeRing(den, K), x0);
            if d0 ne 0 then
              X := Evaluate(ChangeRing(num, K), x0) / d0^2;
              tot +:= 1;
              if X ne 0 and Valuation(X) ge 0 then bad +:= 1; end if;
            end if;
          end if;
        end for;
      end for;
      printf "  kernel %o : %o points of E'(Q_3), %o outside E_1\n", ker, tot, bad;
    end for;
  end for;
  ```

  #v(1mm)
  This route is superseded by the exhaustive argument above, and is kept because it is the
  cleanest of the three to re-run: it touches no point construction, only polynomial evaluation.
  It is also what prompted the exhaustive argument --- asking how much a clean sample was really
  worth led to computing $\#A' = M'$, and the answer, 3, made the rest immediate.
]

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *Caveats.* The 708-twist figure filters on even root number; the odd-root-number case was
  checked separately only to $|d| <= 30000$. All control counts are at $|d| <= 3000$, so the
  zeros there are far weaker evidence than the one for $x^3 - 2$.
]

== A general criterion <sec-general>

The argument of @sec-cm-form never used $f = x^3 - 2$, nor $ell = 3$, nor $p = ell$. Distilled, it gives
conditions on a triple (curve, prime, square class) alone.

Fix an odd prime $ell$, an elliptic curve $E slash QQ$, a prime $p$, and a class
$c in QQ_p^times slash (QQ_p^times)^2$. All twists $E^d$ with $d in c$ become isomorphic over
$QQ_p$; write $E^c$ for that common curve, $W_v (d) = E^d (QQ_v) slash ell$, and $j = j_E$.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Criterion.* Suppose

  #v(1mm)
  #set enum(numbering: "(A)")
  + $E[ell] = C_1 xor C_2$ as $G_QQ$-modules, with $C_i$ of order $ell$ --- equivalently two
    independent rational $ell$-isogenies, equivalently
    $"End"_(G_QQ) (E[ell]) supset.neq bb(F)_ell$. (Twist-invariant.)
  + $dim_(bb(F)_ell) W_p = 2$. For $p = ell$ this says $E^c (QQ_p)[ell] != 0$; for $p != ell$ it
    says $E[ell] subset.eq E^c (QQ_p)$, which forces $p equiv 1 space (mod ell)$.
  + The local Kummer image $L_p = delta_p (W_p (d))$ is *not* stable under $phi_*$, where
    $phi$ is the projection of $E[ell]$ onto $C_1$ along $C_2$.
    Equivalently both dual-isogeny images $hat(psi)_i (E^c slash C_i)(QQ_p)$ lie in
    $ell E^c (QQ_p)$.
  + No prime $q != p$ is *dangerous*, where $q$ is dangerous when
    $ v_q (j) < 0, quad q equiv 1 space (mod ell), quad ell divides v_q (j). $
  + $beta_v equiv 0$ on $W_v (d)$ at every remaining place, for every $d in c$. If $p = ell$
    there are none. If $p != ell$ the place $v = ell$ remains, where
    $dim W_ell = 1 + dim E^d (QQ_ell)[ell]$, so it suffices that $E^d (QQ_ell)[ell] = 0$ or that
    $L_ell$ be $phi_*$-stable.

  #v(2mm)
  Then for *every* $d in c$ the image of $E^d (QQ)$ in $W_p$ has dimension $<= 1$, so $E^d (QQ)$
  is not dense in $E^d (QQ_p)$.
]

Conditions (A)--(C) and (E) depend only on $(E, ell, p, c)$, and (D) only on $(E, ell, p)$, so the
criterion is uniform in $d$ --- which is what lets it beat any finite search.

_Why each place is harmless._ The pairing $beta_v (P,Q) = ⟨delta_v P, phi delta_v Q⟩_v$ is
alternating on $W_v$ (@sec-cm-form), so it vanishes as soon as $dim W_v <= 1$. At $v = infinity$,
$W_infinity = 0$ since $ell$ is odd. At $v tilde.not ell$ of good reduction, $L_v = H^1_"ur"$ is
its own annihilator and $phi$ preserves unramifiedness. At $v tilde.not ell$ of *additive*
reduction --- which includes every $q divides d$, so the varying twist does no harm ---
$E^d (QQ_v)[ell]$ injects into the component group, of order $<= 4$, so $dim W_v <= 1$ whenever
$ell >= 3$. The only remaining case is *multiplicative* reduction at $q tilde.not ell$, where the
Tate parametrisation gives $dim W_q = 2$ exactly when $q equiv 1 space (mod ell)$ and
$ell divides v_q (q_E) = -v_q (j)$: that is condition (D). Reciprocity then forces
$beta_p equiv 0$ on rational pairs, and by (C) $beta_p$ is a non-zero alternating form on the
2-dimensional $W_p$, whose isotropic subspaces have dimension $<= 1$. $qed$

*Remarks.* Note that $q = 2$ is *never* dangerous, since $2 equiv 1 space (mod ell)$ for no odd
$ell$. This explains the empirical rule of @sec-cm-rare --- "denominator of $j$ a power of 2" --- as a
special case of (D). On the genus-0 family of @sec-cm-rare the two happen to be extensionally equal: a
search over 390 000 parameter values found no decomposable family satisfying (D) whose
$j$-denominator is divisible by a prime other than 2, so no test distinguishes them there. For
$ell = 3$ the safe primes are those $equiv 2 space (mod 3)$; a family with $j$-denominator
supported at $5$ alone, say, would separate the two statements.

*The criterion forces $p = ell$.* Condition (E) is not merely awkward for $p != ell$ --- it is
unsatisfiable, at least for $ell = 3$. The two kernels are cut by quadratic characters
$chi_(d_1), chi_(d_2)$ with $d_1 d_2 equiv -3$ modulo squares (computed: $d_1 = 1$, $d_2 = -3$ for
every family checked), and $E^d$ has $C_i$ pointwise $QQ_3$-rational exactly when $d_i d$ is a
square in $QQ_3$. When $p != 3$ the class $c$ constrains $d$ only at $p$, so $d$ is free at 3 and
some $d in c$ makes $d_1 d$ a square --- giving $dim W_3 = 2$. For those twists $L_3$ is not
$phi_*$-stable, by the very computation that (C) demands, so $beta_3 != 0$ and (E) fails. Note also
that $d_1 d$ and $d_2 d$ cannot both be squares, since $-3$ is not one in $QQ_3$; this is why
$dim W_3 <= 2$ throughout.

So the mechanism is intrinsically a phenomenon *at the prime $ell$ itself*: it can only obstruct
density at $p = ell$. That is the sharpest answer available here to "what property of $E$ causes
the failure" --- decomposable $E[ell]$, no dangerous prime, and the local condition (C) at $ell$.
For $ell = 3$ the known instances are $j = 0$ and $j = 9261 slash 8$, and @sec-cm-rare suggests they may
be the only ones. Larger $ell$ is untouched: (A) alone becomes very restrictive, since $E[ell]$
decomposable means the mod-$ell$ image lies in the split Cartan's diagonal, but the search is
well-posed.

*Towards all $p$.* I see no obstruction. The only way a prime could fail is if some square class
$delta$ contained *only* rank-0 twists, which there is no reason to expect. A proof for all $p$
would need a uniform supply of positive-rank twists in prescribed $p$-adic classes with
controlled reduction of the generator. The $t_0$-family is the natural tool, since $t_0$ controls
the class of $d = f(t_0)$ by an open condition; note that the generation condition depends on
$t_0$ only modulo $p^2$ or so, which makes it a genuinely finite check per residue class --- and
therefore potentially provable for a well-chosen $f$.

*A near-necessary condition.* If for some $delta$ every twist in that class had rank 0, all $H_d$
would be uniformly bounded finite groups and density would be extremely implausible (though a
countable union can in principle be dense in $QQ_p^2$, so this is not a formal proof of
necessity).

= Search strategy <sec-strategy>

There are two ways to get rational points on the twists, with very different
costs.

The *$t_0$ sweep* uses the remark of @sec-setup: $E_d$ has an affine rational point iff $d$ is the
squarefree part of $f(t_0)$ for some $t_0$, and then $(t_0, 1)$ *is* such a point. Sweeping
$t_0 = a slash b$ and bucketing by squarefree part therefore hands out one generator per twist
for free, and the family is complete. The alternative, *per-twist descent*, runs `ellrank` on
each $E_d$ in turn: it finds generators of any rank, but pays for a 2-descent every time.
Measured on $f = x^3 + x + 1$:

#table(
  columns: 3, align: (left, left, left), stroke: 0.4pt + luma(150),
  table.header([strategy], [throughput], [rank-2 twists produced]),
  [$t_0$ sweep], [91963 twists / 663 ms = *0.007 ms*], [54 of 91963 (0.06%)],
  [per-twist `ellrank`], [366 twists / 833 ms = *2.28 ms*], [all, on demand],
)

So the sweep is some $300 times$ cheaper per twist --- but it almost never yields *two
independent points on one twist*. That needs a collision of squarefree parts, and
$|a|, b <= H$ gives $tilde H^2$ values of $f(t_0)$ spread over a range $tilde H^4$, so
collisions stay negligible (a 7500-point sweep gave 18, a 92000-point sweep gave 54). Rank 1 is
insufficient exactly when $E_delta (QQ_p) slash E_1$ fails to be cyclic.

*The triage.* That condition depends only on $(p, delta)$ and not on the choice of twist within
the class, because all $d$ in one class give $QQ_p$-isomorphic curves. One local computation per
$(p, delta)$ --- four per prime, no point search --- therefore decides the path: procyclic means
the sweep can settle it, otherwise rank $>= 2$ is mandatory and descent is run on twists in that
class only (already a factor 4). The test is exact at good reduction (`ellgroup`) and
conservative at additive primes, so the cheap set is never overstated.

#table(
  columns: 4, align: (left, center, center, left), stroke: 0.4pt + luma(150),
  table.header([$f$], [$(p,delta)$ pairs], [procyclic], [rank $>= 2$ mandatory]),
  [$x^3+x+1$, $p < 200$], [180], [158 (88%)], [22, at $p = 31, 47, 67, 131, 139, 149, 173$],
  [$x^3-2$, $p < 100$],   [96],  [78 (81%)],  [18, at $p = 3, 7, 13, 19, 31, 37, 43, 61, 67, 73, 79, 97$],
)

The second list is exactly ${3}$ together with the primes $p equiv 1 space (mod 3)$; no prime
$equiv 2 space (mod 3)$ occurs. This is the whole explanation of the retracted claim in
@sec-cm: CM by $ZZ[zeta_3]$ is what makes those classes non-procyclic, so a rank-1-only search
appears to fail there. It is a blind spot of the method, not a fact about the surface.

*Result.* The hybrid settles all 45 odd primes below 200 in a single pass in about 5 seconds,
including $p = 131$ and $149$, which the pure-descent path reached only through separate
targeted searches. Of the 180 pairs, 134 are resolved straight from the sweep with no descent
at all.

#pagebreak()

= Appendix: the PARI/GP scripts

Run with `gp -q -s 2000000000 script.gp < /dev/null`.

#block(fill: luma(240), inset: 7pt, radius: 3pt, width: 100%)[
  #text(size: 9pt)[
    Two GP gotchas cost me time and are worth recording: (i) `*/` occurring inside a comment
    (e.g. writing `Qp^*/(Qp^*)^2`) silently terminates the comment; (ii) `my(...)` must be the
    *first* statement of a block, and a `f(x) = ...` definition without braces cannot span
    lines. Also, `default(parisize, N)` in the middle of a script aborts the rest of the file ---
    use the `-s` flag instead.
  ]
]

== `kummer2.gp` --- the criterion

`densegroup(Em, pts, p)` decides whether the subgroup generated by `pts` is dense in
$E_m (QQ_p)$. It does a triangular reduction against the filtration: it finds the successive
orders $m_1, m_2, dots$ of the generators in $E(QQ_p) slash E_1$, so that
$product m_i$ is the index; that must equal $M$. Along the way it records a basis of the kernel
lattice $L = {a in ZZ^r : sum a_i P_i in E_1}$, and finally checks that the homomorphism
$L -> E_1 slash E_2 tilde.equiv bb(F)_p$ is non-zero, i.e. that some basis vector gives a point
with $v_p (x) = -2$.

```
/* ============================================================
   p-adic density of Q-points on X : y^2 = f(x)f(t),  f = x^3+Ax+B
   X = Kum(E x E),  E : v^2 = f(u),  E_d : Y^2 = X^3 + A d^2 X + B d^3
   ============================================================ */

PREC = 100;

sqclass(d, p) = { my(v = valuation(d,p), u = d/p^v); 2*(v%2) + if(kronecker(u,p)==1,0,1); }
sqclassname(k, p) = if(k==0, "1", k==1, "u", k==2, Str(p), Str("u*",p));

/* M = # E(Qp)/E_1(Qp) for a MINIMAL model Em, p odd */
Mval(Em, p) = {
  my(ap = ellap(Em,p), lr = elllocalred(Em,p));
  if(lr[2] == 1, lr[4]*(p+1-ap), lr[4]*(p-ap));
}

padiccurve(Em, p) = {
  ellinit([Em.a1+O(p^PREC), Em.a2+O(p^PREC), Em.a3+O(p^PREC),
           Em.a4+O(p^PREC), Em.a6+O(p^PREC)]);
}

inE1(Q, p) = (Q == [0]) || (valuation(Q[1],p) < 0);

/* Is the subgroup generated by pts dense in Em(Qp)?  (Em minimal, p odd) */
densegroup(Em, pts, p) = {
  my(M, r, Ep, P, S, coefs, basis, idx, rem, dv, mi, bvec, k, kP, Q, S2, C2, jP, cc, b, T);
  M = Mval(Em, p);
  r = #pts;
  if(M == 0 || r == 0, return(0));
  Ep = padiccurve(Em, p);
  P = vector(r, i, [pts[i][1]+O(p^PREC), pts[i][2]+O(p^PREC)]);
  S = [[0]];                       /* coset representatives mod E_1, start with O */
  coefs = [vector(r, j, 0)];       /* their coefficient vectors */
  basis = List();                  /* basis of the kernel lattice L */
  idx = 1;                         /* running index = prod m_i */
  for(i = 1, r,
    rem = M \ idx;                 /* NB: do NOT break when rem==1 -- a generator that
                                      already lies in Gamma_{<i} + E_1 still contributes
                                      a kernel-lattice vector, needed for condition (ii) */
    dv = divisors(rem);            /* m_i must divide the remaining index */
    mi = 0; bvec = 0;
    for(t = 1, #dv,
      k = dv[t];
      kP = ellmul(Ep, P[i], k);
      for(s = 1, #S,
        Q = if(S[s] == [0], kP, elladd(Ep, kP, S[s]));
        if(inE1(Q, p),
          mi = k;
          bvec = coefs[s]; bvec[i] += k;
          break(2)
        )
      )
    );
    if(mi == 0, next);
    listput(basis, bvec);
    S2 = List(); C2 = List();      /* extend the coset reps by multiples of P_i */
    for(j = 0, mi-1,
      jP = if(j == 0, [0], ellmul(Ep, P[i], j));
      for(s = 1, #S,
        Q = if(j == 0, S[s], if(S[s] == [0], jP, elladd(Ep, jP, S[s])));
        cc = coefs[s]; cc[i] += j;
        listput(S2, Q); listput(C2, cc)
      )
    );
    S = Vec(S2); coefs = Vec(C2); idx *= mi
  );
  if(idx != M, return(0));         /* (i) no surjection onto E(Qp)/E_1 */
  for(i = 1, #basis,               /* (ii) some kernel basis vector lands in E_1 \ E_2 */
    b = basis[i]; Q = [0];
    for(j = 1, r,
      if(b[j] != 0,
        T = ellmul(Ep, P[j], b[j]);
        Q = if(Q == [0], T, elladd(Ep, Q, T))
      )
    );
    if(Q != [0] && valuation(Q[1],p) == -2, return(1))
  );
  0;
}

/* generators of a finite-index subgroup of E_d(Q) */
twistdata(A, B, d) = {
  my(Ec, v, Em, R, pts, tors);
  Ec = ellinit([A*d^2, B*d^3]);
  v = 0;
  Em = ellminimalmodel(Ec, &v);
  R = ellrank(Em);
  pts = R[4];
  if(#pts > 0, pts = ellsaturation(Em, pts, 50));
  tors = elltors(Em);
  pts = concat(pts, tors[3]);
  [Em, pts, R[1], R[2]];
}
```

== `driver.gp` --- the search over twists

Implements the hybrid of @sec-strategy: `sweep` buckets $t_0$ by the squarefree part of
$f(t_0)$, `procyclic` triages each $(p, delta)$ with a purely local computation, and `hybrid`
takes the cheap or the expensive path accordingly. The pure-descent functions `build` /
`report`, and the targeted single-class search `hunt`, are retained as a reference path.

```
/* ---------- stage 1: the cheap t_0 sweep ---------------------------- */

/* bucket t_0 = a/b (|a| <= HN, b <= HD) by the squarefree part of f(t_0).
   Returns [Map: d -> vector of t_0, keys sorted by |d|]. */
sweep(A, B, HN, HD) = {
  my(M = Map(), a, b, t0, q, d, keys);
  for(b = 1, HD,
    for(a = -HN, HN,
      if(gcd(a,b) != 1, next);
      t0 = a/b; q = t0^3 + A*t0 + B;
      if(q == 0, next);
      d = sqfreepart(q)[1];
      if(mapisdefined(M,d), mapput(M, d, concat(mapget(M,d), [t0])),
                            mapput(M, d, [t0]))
    )
  );
  keys = Mat(M)[,1];
  keys = vecsort(keys, x -> abs(x));
  [M, keys];
}

/* minimal model of E_d together with the points coming from the swept t_0 */
sweptdata(A, B, d, t0s) = {
  my(Ec, v = 0, Em, pts = List(), t0, c);
  Ec = ellinit([A*d^2, B*d^3]);
  Em = ellminimalmodel(Ec, &v);
  for(i = 1, #t0s,
    t0 = t0s[i];
    c = sqfreepart(t0^3 + A*t0 + B)[2];
    listput(pts, ellchangepoint([d*t0, d^2*c], v))
  );
  [Em, Vec(pts)];
}

/* ---------- stage 2: local triage, no point search ------------------ */

/* Is E_delta(Qp)/E_1 cyclic?  Depends only on (p,target).
   Conservative at additive primes: may return 0 for a cyclic group,
   never 1 for a non-cyclic one, so the "cheap" set is never overstated. */
procyclic(A, B, p, target) = {
  my(d = classrep(A,B,p,target,4000), Ec, v = 0, Em, lr, ns, c);
  if(d == 0, return(0));
  Ec = ellinit([A*d^2, B*d^3]);
  Em = ellminimalmodel(Ec, &v);
  lr = elllocalred(Em, p);
  if(lr[2] == 1, return(#ellgroup(Em,p) == 1));   /* good: G_1 = Etilde(Fp) */
  ns = p - ellap(Em, p); c = lr[4];               /* bad: |G_1| = c_p * ns  */
  gcd(c, ns) == 1 && c <= 3;
}

/* ---------- stage 3: the hybrid search ------------------------------ */

hybrid(A, B, SW, PMAX, TRIES, DMAX) = {
  my(M = SW[1], keys = SW[2], prs = primes([3,PMAX]), good = List(),
     p, k, w, path, nf, i, j, n, sg, d, td, tried, ncheap = 0, ndesc = 0, hit);
  for(j = 1, #prs,
    p = prs[j];
    w = vector(4, i, 0); path = vector(4, i, "");
    for(k = 0, 3,
      hit = 0;
      if(procyclic(A, B, p, k),
        /* --- cheap path: witnesses straight from the sweep --- */
        ncheap++; tried = 0;
        for(i = 1, #keys,
          d = keys[i];
          if(sqclass(d,p) != k, next);
          tried++; if(tried > TRIES, break());
          td = sweptdata(A, B, d, mapget(M,d));
          if(densegroup(td[1], td[2], p),
             w[k+1] = d; path[k+1] = "sweep"; hit = 1; break())
        )
      );
      if(!hit,
        /* --- descent path: only twists in this class --- */
        ndesc++;
        for(n = 1, DMAX,
          if(!issquarefree(n), next);
          for(sg = 0, 1,
            d = if(sg == 0, n, -n);
            if(sqclass(d,p) != k, next);
            td = twistdata(A, B, d);
            if(#td[2] == 0, next);
            if(densegroup(td[1], td[2], p),
               w[k+1] = d; path[k+1] = "descent"; hit = 1; break(2))
          )
        )
      )
    );
    nf = 0; for(k = 1, 4, if(w[k] != 0, nf++));
    /* ... reporting elided ... */
  );
  Vec(good);
}
```

Usage:

```
read("driver.gp");
SW = sweep(1, 1, 1500, 50);         /* 92k twists, each with a free point */
hybrid(1, 1, SW, 200, 60, 20000);   /* 45 / 45 odd primes, ~5 s */
```

== `p2.gp` --- the modifications for $p = 2$

Identical logic, except that the safe procyclic level is $E_2$ rather than $E_1$: hence
$M_2 = 2 c_2 dot \#tilde(E)^"ns"(bb(F)_2)$, membership is $v_2 (x) <= -4$, the final test is
$v_2 (x) = -4$, and there are 8 square classes. `densegroup2` is `densegroup` verbatim with
`Mval` $arrow.r$ `M2val` and `inE1` $arrow.r$ `inE2`.

```
read("kummer2.gp");

/* ---- p = 2 :  E_2(Q_2) = hat E(4 Z_2) is the safe procyclic level ----
   M2 = # E(Q2)/E_2(Q2) = 2 * c_2 * #Ens(F_2).
   Q in E_2  <=>  Q = O  or  v_2(x(Q)) <= -4 ;   generates E_2 <=> v_2(x) = -4. */

sqclass2(d) = {
  my(v = valuation(d,2), u = (d/2^v) % 8);
  if(u < 0, u += 8);
  4*(v%2) + (u-1)/2;
}
sqclass2name(k) = { my(nm = ["1","3","5","7","2","6","10","14"]); nm[k+1]; }

M2val(Em) = {
  my(ap = ellap(Em,2), lr = elllocalred(Em,2));
  2 * if(lr[2] == 1, lr[4]*(3-ap), lr[4]*(2-ap));
}

inE2(Q) = (Q == [0]) || (valuation(Q[1],2) <= -4);

/* densegroup2(Em, pts) == densegroup with Mval -> M2val, inE1 -> inE2,
   and the final test valuation(Q[1],2) == -4 */
```

== `cover2.gp` --- the independent check on $X$

For each of the two regions, build the set of genuine reductions mod $p^k$ (as a
`vectorsmall` bitmap keyed by $x p^(2k) + t p^k + y$), then hammer it with pairs of rational
points drawn from the four twists and count how many distinct targets are reached.

```
/* main loop of coverage(A, B, p, k, ds, NB), p odd */
q = p^k; q2 = q*q; q3 = q2*q;
for(region = 1, 2,
  AA = if(region == 1, A, A*p^2);          /* region 2: x = x'/p, y = y'/p^3 */
  BB = if(region == 1, B, B*p^3);
  tgt = vectorsmall(q3); tot = 0;
  for(x = 0, q-1,
    if(region == 2 && x % p == 0, next);
    for(t = 0, q-1,
      if(region == 2 && t % p == 0, next);
      s = ((x^3 + AA*x + BB) * (t^3 + AA*t + BB)) % q;
      if(s % p == 0, next);
      if(kronecker(s, p) != 1, next);      /* s must be a square in Z_p */
      rr = truncate(sqrt(s + O(p^k))) % q;
      tgt[x*q2 + t*q + rr + 1] = 1; tot++;
      tgt[x*q2 + t*q + (q-rr)%q + 1] = 1; tot++
    )
  );
  hit = vectorsmall(q3); cnt = 0;
  for(i = 1, #ds,
    d = ds[i];
    S = twistpoints(A, B, d, p, NB);       /* rational (u,v) on d v^2 = f(u) */
    allpts = List();
    for(a = 1, #S,
      if(region == 1 && valuation(S[a][1], p) >= 0, listput(allpts, S[a]));
      if(region == 2 && valuation(S[a][1], p) == -1, listput(allpts, S[a]))
    );
    allpts = Vec(allpts);
    for(a = 1, #allpts,
      u1 = allpts[a][1]; v1 = allpts[a][2];
      for(b = 1, #allpts,
        u2 = allpts[b][1]; v2 = allpts[b][2];
        yy = d*v1*v2;                      /* the Kummer point (u1, u2, d v1 v2) */
        if(region == 1, xx = u1; tt = u2, xx = p*u1; tt = p*u2; yy = p^3*yy);
        if(valuation(yy, p) != 0, next);
        x = truncate(xx + O(p^k)) % q;
        t = truncate(tt + O(p^k)) % q;
        y = truncate(yy + O(p^k)) % q;
        key = x*q2 + t*q + y + 1;
        if(tgt[key] && !hit[key], hit[key] = 1; cnt++)
      )
    )
  );
  print("  region ", region, " mod ", p, "^", k, ": targets = ", tot, ", hit = ", cnt)
);
```
