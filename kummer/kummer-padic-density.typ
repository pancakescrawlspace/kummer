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
  columns: 4, align: (center, center, center, left), stroke: 0.4pt + luma(150),
  table.header([$S$ (for $f = x^3+x+1$)], [tuples], [witnessed], [outcome]),
  [${5, 7}$],    [16], [16], [*$X(QQ)$ is dense in $X(QQ_S)$*, $|d| <= 4000$, 0.4 s],
  [${3, 5, 7}$], [64], [46], [inconclusive so far, $|d| <= 6000$],
)

The three-place case is not a failure, only an unfinished search: witnesses become scarcer as
$|S|$ grows, since a twist must now be simultaneously good at every place.

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
longer forced. For $f = x^3+x+1$ and $S = {5,7}$, computing $g$ over the 16 tuples gives $g <= 2$
for fourteen of them and $g = 3$ for two --- and yet @sec-sadic-level found a full twist for all
sixteen, so those two are settled by rank-$>= 3$ twists rather than by any ledger. For
$S = {11,13,17}$ all 48 realised tuples have $g = 3$, since the cubic has a root in each of
$QQ_11, QQ_13, QQ_17$; that is where a ledger would first be needed if full twists ran out.

*Monotonicity.* Truncation $cal(G)(n+1) -> cal(G)(n)$ is surjective and carries reaches onto
reaches, so coverage at level $n+1$ implies coverage at level $n$. Deficiency is therefore
monotone in $n$: work at the lowest level, refine only after it closes. A full twist is full at
every level, so once one is found the class is finished for good.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *Two cautions.* (i) In practice one knows only a finite-index subgroup of $E^d (QQ)$, so the
  computed reach may be *smaller* than $R(d)$. The error is one-sided: coverage verdicts stay
  sound, non-coverage verdicts do not. (ii) The arena is large --- $|cal(G)(2)| = product_p p M_p$
  is already in the millions for three places --- so the ledger must store reaches by *generators*,
  with containment tested by linear algebra in the $ell$-primary pieces, never by listing
  elements. The star test is then run prime by prime.
]

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
changes the cocycle by a coboundary. It is injective, and we write $W_v$ for both the group and
its image, the *local Kummer image*. The same construction over $QQ$ gives a global
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
$ W_v "is Lagrangian:" quad W_v = W_v^perp . $
That $W_v$ is isotropic is the concrete half one actually uses; the reason is that two points of
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
cyclic. (ii) At $v tilde.not ell$ of good reduction, $W_v$ equals the *unramified* subgroup
$H^1_"ur" (G_v, E[ell]) = H^1 ("Gal"(QQ_v^"ur" slash QQ_v), E[ell]^(I_v))$, which is its own
annihilator; and a Galois-equivariant $psi$ preserves it, so the pairing of $W_v$ against
$psi W_v$ vanishes.

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
  *Why the class is still not exhibited.* Not for want of trying the obvious tools. Both computer
  algebra systems used here were checked: PARI's `nfhilbert` and Sage's `hilbert_symbol` are
  *quadratic only* --- neither takes an exponent argument --- Sage's `three_selmer_rank` shells
  out to Magma, and neither system has Brauer groups of surfaces. What is missing is a cubic
  norm-residue symbol at $v = 3$. Away from 3 the symbol is *tame* and elementary, but those are
  exactly the places the argument already disposes of structurally; the one place that would need
  a symbol, $v = ell = 3$, is wildly ramified, where one needs an explicit reciprocity law
  (Artin--Hasse, Coleman) rather than a formula. That is an implementation task, not a conceptual
  gap --- but it is a real one, and it is not what the theorem below rests on.
]

Decomposability of $E[3]$ supplies a *non-scalar* $phi in "End"_G (E[3])$, namely projection onto
$C_1$. Twist the local Tate pairing by it:
$ beta_v (P, Q) = ⟨ delta_v P, phi delta_v Q ⟩_v . $
This is the step that was missing earlier. The *untwisted* pairing vanishes identically on the
Kummer image $W_v$, because $W_v$ is Lagrangian --- which is why plain reciprocity gave only
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
     pairing, which vanishes on $W_v$],
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
- At a prime $ell != 3$ of *good* reduction, $W_ell = H^1_"ur" (QQ_ell, E[3])$ is its own
  annihilator under the Tate pairing, and $phi$ is Galois-equivariant so preserves
  unramifiedness; hence $beta_ell (W_ell, W_ell) subset.eq ⟨H^1_"ur", H^1_"ur"⟩ = 0$.
- At any $ell != 3$, $W_ell tilde.equiv E_d (QQ_ell)[3]$, because $E_d (QQ_ell)$ has a
  3-divisible subgroup of finite index. For $E_d : y^2 = x^3 - 2d^3$ the 3-torsion sits at
  $x = 0$ and $x = 2d$, so $W_ell != 0$ requires $-2d$ or $6d$ to be a square in $QQ_ell$.

The bad primes of $E_d$ divide $6d$. For $ell divides d$ with $ell != 2, 3$ and $d$ squarefree,
$v_ell (-2d) = v_ell (6d) = 1$ is *odd*, so neither is a square and $W_ell = 0$. This is a proof,
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
pairing, since the Weil pairing restricted to the cyclic $C_i$ is trivial; and $W_v$ is isotropic,
so $0 = ⟨delta_v P, delta_v P⟩ = 2 ⟨a_1, a_2⟩$, whence $⟨a_1, a_2⟩ = 0$ as $2$ is invertible mod 3.
Therefore
$ beta_v (P,P) = ⟨a_1 + a_2, a_1⟩ = ⟨a_1,a_1⟩ + ⟨a_2,a_1⟩ = 0 . $
So $beta_v$ is alternating on $W_v$, and in particular *vanishes identically whenever
$dim W_v <= 1$*.

That disposes of $v = 2$: since $zeta_3 in.not QQ_2$ (the extension $QQ_2 (zeta_3) slash QQ_2$ is
the unramified quadratic one), full 3-torsion is never $QQ_2$-rational, so $dim W_2 <= 1$ and
$beta_2 equiv 0$ for *every* $d$ --- the even-$d$ case included.

*$beta_3 equiv.not 0$.* $W_3$ is Lagrangian in $H^1 (QQ_3, E[3])$, so $beta_3 equiv 0$ on $W_3$
iff $phi W_3 subset.eq W_3^perp = W_3$, i.e. iff $W_3$ is $phi$-stable. Now
$W_3 inter H^1 (C_1) = ker alpha_2$ and $W_3 inter H^1 (C_2) = ker alpha_1$, where $alpha_i$ is the
$C_i$-component of $delta_3$; and $ker alpha_i$ is the image of the corresponding dual isogeny.
Both dual images were computed to be exactly $E_1 = 3 E_delta (QQ_3)$, i.e. *zero* in $W_3$. So
both intersections vanish, $W_3$ is not $phi$-stable, and $beta_3 equiv.not 0$. This is one local
computation, valid for the whole class, since all $d$ in a square class give $QQ_3$-isomorphic
curves; it was checked for eight twists as a consistency test.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Theorem (modulo the local computation of $beta_3 equiv.not 0$).* For $f = x^3 - 2$ and *every*
  squarefree $d$ in the class $[u dot 3]$, the group $E_d (QQ)$ is not dense in $E_d (QQ_3)$.
  Consequently, by the equivalence of @sec-criterion, $X(QQ)$ is *not* dense in $X(QQ_3)$.

  #v(2mm)
  _Proof._ $beta_v equiv 0$ for every $v != 3$: at $v = infinity$ because $W_infinity = 0$; at
  good $ell != 3$ by unramified isotropy; at $ell divides d$ with $ell != 2,3$ because
  $W_ell = 0$ (odd valuation of $-2d$ and $6d$); and at $ell = 2$ because $dim W_2 <= 1$ and
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
  *Status.* The one input not verified symbolically is $beta_3 equiv.not 0$, i.e. the failure of
  $phi$-stability of $W_3$; it rests on the computation that both dual-isogeny images equal $E_1$.
  Everything else is standard: Tate local duality, isotropy of the Kummer image, reciprocity for
  the sum of local invariants. The argument should be checked by hand before being relied on.

  #v(2mm)
  *Independently verified in Sage 10.9.* The PARI computation built the dual isogenies by hand
  (locating the kernel by trial) and evaluated them with its own substitution code, so it was
  re-run using Sage's `EllipticCurveIsogeny.dual()` and `rational_maps()`. Sage reproduces the
  same codomains, confirms $hat(phi)_i compose phi_i = [3]$, and finds *no* $QQ_3$-point of either
  codomain whose image leaves $E_1$: 3376 points tested across $d = -3, 6, -21, 87$, zero
  outside. A structural shortcut is not available --- the induced map
  $E' (QQ_3) slash E'_1 -> E (QQ_3) slash E_1$ has source of order 3, so it is not forced to
  vanish for order reasons.

  #v(1mm)
  Sage also corrected the Kodaira labels in the table above, which read $I I^*$ in an earlier
  draft: PARI's code $-4$ is $I V^*$, not $I I^*$ (its starred types mirror the unstarred ones),
  and $I I^*$ is in any case incompatible with $c_3 = 3$. The mislabelling was cosmetic --- every
  computation used the numeric $c_p$ and $M$, never the symbol.
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
  + $W_p$ is *not* stable under $phi$, the projection of $E[ell]$ onto $C_1$ along $C_2$.
    Equivalently both dual-isogeny images $hat(psi)_i (E^c slash C_i)(QQ_p)$ lie in
    $ell E^c (QQ_p)$.
  + No prime $q != p$ is *dangerous*, where $q$ is dangerous when
    $ v_q (j) < 0, quad q equiv 1 space (mod ell), quad ell divides v_q (j). $
  + $beta_v equiv 0$ on $W_v (d)$ at every remaining place, for every $d in c$. If $p = ell$
    there are none. If $p != ell$ the place $v = ell$ remains, where
    $dim W_ell = 1 + dim E^d (QQ_ell)[ell]$, so it suffices that $E^d (QQ_ell)[ell] = 0$ or that
    $W_ell$ be $phi$-stable.

  #v(2mm)
  Then for *every* $d in c$ the image of $E^d (QQ)$ in $W_p$ has dimension $<= 1$, so $E^d (QQ)$
  is not dense in $E^d (QQ_p)$.
]

Conditions (A)--(C) and (E) depend only on $(E, ell, p, c)$, and (D) only on $(E, ell, p)$, so the
criterion is uniform in $d$ --- which is what lets it beat any finite search.

_Why each place is harmless._ The pairing $beta_v (P,Q) = ⟨delta_v P, phi delta_v Q⟩_v$ is
alternating on $W_v$ (@sec-cm-form), so it vanishes as soon as $dim W_v <= 1$. At $v = infinity$,
$W_infinity = 0$ since $ell$ is odd. At $v tilde.not ell$ of good reduction, $W_v = H^1_"ur"$ is
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
some $d in c$ makes $d_1 d$ a square --- giving $dim W_3 = 2$. For those twists $W_3$ is not
$phi$-stable, by the very computation that (C) demands, so $beta_3 != 0$ and (E) fails. Note also
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
