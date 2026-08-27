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
  #text(size: 16pt, weight: "bold")[A $j = 0$ non-diagonal example]
  #v(2mm)
  #text(size: 10pt)[$"Kum"(E times E')$ for $y^2 = x^3 + 9$ and $v^2 = u^3 - 81$:
  the scan at $p = 2, 3, 5, 7$, and the two things that make $p = 2$ hard]
  #v(1mm)
  #text(size: 9pt, style: "italic")[computed in `kummer-example-j0.gp`, on top of the repository's
  own `kummer2.gp` and `p2.gp`; companion to `kummer-example-p13.typ`]
]

#v(4mm)

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *Summary.* At $p = 3, 5, 7$ a single twist covers every square class, so $X(QQ)$ is dense in
  $X(QQ_p)$ there. At
  $p = 2$ *all four odd classes* are covered and all four even classes are empty --- and the even
  half is genuinely *obstructed*: @sec-obstruction computes the twisted pairing at $ell = p = 2$
  and finds $beta_2 equiv.not 0$ there, so $X(QQ)$ is not dense in $X(QQ_2)$. $E_d (QQ_2)$ always has a $2$-torsion point while $E_d (QQ)$ never
  does, so a rank-$1$ twist has *procyclic* closure and can never be dense: at $p = 2$ a witness
  needs rank $>= 2$ on *both* curves at once. Steering the search by that --- root numbers first,
  `ellrank` only on survivors --- finds witnesses in all four odd classes out to $|d| <= 6000$. In
  the even classes $w(E_d) w(E'_d) = -1$ always, so one curve has odd analytic rank and a witness
  would need rank $>= 3$ on one side paired with rank $>= 2$ on the other.
]

= The pair <sec-pair>

$ E : y^2 = x^3 + 9, quad N_E = 972 = 2^2 dot 3^5 ; wide
  E' : v^2 = u^3 - 81, quad N_(E') = 3888 = 2^4 dot 3^5 . $

Both have $j = 0$, so both have CM by $ZZ[zeta_3]$. Ranks are $1$ and $1$; torsion is
$ZZ slash 3$ (the points $(0, plus.minus 3)$) and trivial. They are *not* isogenous --- $a_q$
differs over $ZZ$ at $42$ of the $93$ good primes below $500$ --- and $E'$ is not a quadratic
twist of $E$, since $E_d : y^2 = x^3 + 9 d^3$ would need $9 d^3 = -81$, i.e. $d^3 = -9$.

The twist families are
$ E_d : y^2 = x^3 + 9 d^3 , wide E'_d : y^2 = x^3 - 81 d^3 , $
and a search over squarefree $|d| <= 150$ gives *$77$* twists with both ranks positive.

Reduction is bad at $2$ and $3$ for both: at $2$, type $I V$ with $c_2 = 3$ for $E$ and type $I I$
with $c_2 = 1$ for $E'$; at $3$, type $I V$ with $c_3 = 3$ and type $I V^ast$ with $c_3 = 1$.

= Method, and why the repository's tests apply <sec-method>

The scan is run with `densegroup` and `densegroup2` from `kummer2.gp` and `p2.gp`. Those were
written for the diagonal problem, so it is worth saying why they transfer.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *They are single-curve tests.* `densegroup(Em, pts, p)` takes one minimal model and a set of
  points and decides whether $⟨"pts"⟩$ is dense in $E_m (QQ_p)$; `Mval` computes
  $\#E(QQ_p) slash E_1$ from $a_p$, the Kodaira type and $c_p$; `sqclass` is a statement about
  $d$ alone. Nothing in any of them refers to a second curve. What is diagonal-specific is
  `driver.gp`, which applies the test *once per class to one twist family*. Off the diagonal one
  applies the same test *twice*, to $E_d$ and to $E'_d$ separately --- which is exactly the
  single-twist form of the criterion.
]

That reasoning was checked rather than trusted. An independent density test was written from
scratch and compared with `densegroup` on $126$ (curve, $p$) pairs at $p = 5, 7, 11, 13$.

#block(fill: rgb("#fff4e6"), inset: 8pt, radius: 3pt, width: 100%)[
  *The first attempt disagreed twice, and the repository was right.* The naive test --- "some
  generator $P$ has $v_p (x(M P)) = -2$" --- is *wrong* when $p divides \#tilde(E)(bb(F)_p)$. For
  $d = 10$ and $d = -30$ at $p = 7$ one has $\#tilde(E)(bb(F)_7) = 7$, so $E(QQ_7) tilde.equiv ZZ_7$
  with $E_1 = 7 ZZ_7$ *one level deeper* than the shortcut assumes, and a generator can be
  outside $E_1$ while $7P$ sits in $E_2$. Rewritten to follow $section 2.2$ of the main notes
  literally --- $Gamma$ onto $E(QQ_p) slash E_1$, *and* $Gamma inter E_1 subset.eq.not E_2$
  checked by enumerating combinations rather than single generators --- the two tests agree on
  all $126$ pairs, four of which have $p divides M$.
]

= The two factors really are independent <sec-indep>

The sufficient form needs the pair $(P, P')$ to range over a *product*. It does:
$(E_d times E'_d)(QQ) = E_d (QQ) times E'_d (QQ)$, with no constraint linking the factors, and
closure commutes with products, $overline(A times B) = overline(A) times overline(B)$. Checked
directly: for nine values of $d$, all $144$ cross pairs $(P, P')$ formed independently from
multiples of the generators on each side satisfy
$ y^2 = (x^3 + 9)(t^3 - 81), quad (x, t, y) = (u, s, d v w) , $
none failing. Correlation between the two factors is a real issue for the *union* form of the
criterion --- several deficient twists conspiring --- but not for the single-twist form.

= The scan <sec-scan>

For each prime and square class, a $d$ with $E_d (QQ)$ dense in $E_d (QQ_p)$ *and* $E'_d (QQ)$
dense in $E'_d (QQ_p)$:

#v(2mm)
#align(center)[
#table(columns: 5, align: (center, left, left, left, left), stroke: 0.4pt + luma(170),
  inset: (x: 9pt, y: 4pt),
  table.header([$p$], [class], [class], [class], [class]),
  [$3$], [$[1]$: $d = 1$],  [$[u]$: $d = 2$],    [$[3]$: $d = -6$],  [$[u 3]$: $d = -3$],
  [$5$], [$[1]$: $d = 1$],  [$[u]$: $d = 47$],   [$[5]$: $d = -5$],  [$[u 5]$: $d = 15$],
  [$7$], [$[1]$: $d = 22$], [$[u]$: $d = -30$],  [$[7]$: $d = -182$], [$[u 7]$: $d = -7$],
)]

#v(2mm)

So $p = 3$, $p = 5$ *and* $p = 7$ are settled outright: one twist per class, hence $X(QQ)$ is
dense in $X(QQ_p)$ for those three primes.

== The class $[7]$ at $p = 7$: sparse, not obstructed <sec-scan-seven>

The class $[7]$ was empty in the first pass, which invited the reading that it is blocked the way
the even classes at $p = 2$ are (@sec-parity). It is not. It was a range effect, and the smallest
witness sits just outside the first search.

First, the local question at $7$ has *one* answer per class, not one per twist.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Lemma.* For *every* prime $p$, the curves $E_d$ and $E_(d')$ are isomorphic over $QQ_p$ if and
  only if $d$ and $d'$ lie in the same square class of $QQ_p^times$. The same holds for $E'_d$.

  #v(2mm)
  _Proof._ $j = 0$, so $"Aut" = mu_6$ and the twists of $y^2 = x^3 + A$ over $QQ_p$ are classified
  by $A$ modulo $(QQ_p^times)^6$. Thus $E_d tilde.equiv E_(d')$ over $QQ_p$ iff
  $9 d^3 slash 9 d'^3 = (d slash d')^3 in (QQ_p^times)^6$. Now for $x, y in QQ_p^times$,
  $x^3 = y^6$ forces $(x slash y^2)^3 = 1$, so $x slash y^2 in mu_3 (QQ_p)$ --- and
  $mu_3 (QQ_p) subset.eq (QQ_p^times)^2$ always: it is trivial unless $p equiv 1$ (mod $3$), and
  then $zeta_3 = (zeta_3^2)^2$. Either way $x in (QQ_p^times)^2$. The converse is immediate. $qed$
]

So the indexing of @sec-scan by square classes is the right one at *every* prime: four classes at
each odd $p$, eight at $p = 2$, and one curve apiece.

In particular the square class is the $QQ_7$-isomorphism class. Kodaira type, $c_7$, $M$, the group $E_d (QQ_7)$ and the density condition
itself are constant across a class, and a single twist decides them. What they are:

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Proposition.* Let $7 parallel d$, $d$ squarefree --- i.e. $d$ in class $[7]$ or $[u 7]$. Then
  $ E_d (QQ_7) tilde.equiv ZZ_7 quad "and" quad E'_d (QQ_7) tilde.equiv ZZ_7 , $
  both *procyclic*. Consequently $E_d (QQ)$ is dense in $E_d (QQ_7)$ as soon as it contains a
  single point $P$ with $v_7 (x(P)) >= 0$.

  #v(2mm)
  _Proof._ Three steps, none numerical.

  #v(1mm)
  *(a) Type and Tamagawa number.* $v_7 (a_6) = v_7 (9 d^3) = 3$ and $v_7 (Delta) = v_7(-432 a_6^2)
  = 6 < 12$, so the model is minimal and the reduction is additive of type $I_0^ast$. For
  $I_0^ast$, $c_7 = 1 + \#\{"roots in" bb(F)_7 "of" P(T) = T^3 + a_2 slash 7 dot T^2 + a_4 slash
  7^2 dot T + a_6 slash 7^3\}$, which here is $T^3 + 9 (d slash 7)^3$. Since $7 equiv 1$ (mod $3$),
  that has a root iff $-9$ is a cube mod $7$; the cubes are $\{1, 6\}$ and $-9 equiv 5$, so it has
  none and $c_7 = 1$. For $E'_d$ the polynomial is $T^3 - 81 (d slash 7)^3$ and $81 equiv 4$ is
  likewise not a cube, so again $c_7 = 1$. Hence $E_d (QQ_7) = E_0 (QQ_7)$ and
  $ M := \# E_d (QQ_7) slash E_1 = \# tilde(E)^"ns" (bb(F)_7) = 7 . $

  #v(1mm)
  *(b) $E_0 (QQ_7)$ is procyclic.* By Theorem 1 of [P], for $E slash QQ_p$ with additive reduction
  given by a minimal model with every $a_i in p ZZ_p$, $E_0 (QQ_p) tilde.equiv ZZ_p$ *except* in
  four listed cases, of which the one at $p = 7$ is $a_6 equiv 14$ (mod $49$). Here
  $v_7 (a_6) = 3$, so $a_6 equiv 0$ (mod $49$), and $0 equiv.not 14$. The exception therefore
  cannot occur *for any $d$ in this family*: $v_7 (a_6) = 3 v_7 (d)$ is a multiple of $3$, while
  $a_6 equiv 14$ (mod $49$) forces $v_7 (a_6) = 1$. Same for $E'_d$, where $a_6 = -81 d^3$.

  #v(1mm)
  *(c)* Combining, $E_d (QQ_7) = E_0 (QQ_7) tilde.equiv ZZ_7$. Its unique subgroup of index $7$ is
  $E_1$, so a point generates topologically iff it lies outside $E_1$, i.e. iff
  $v_7 (x(P)) >= 0$. $qed$
]

#block(inset: (left: 4pt))[
  [P] R. Pannekoek, #link("https://arxiv.org/abs/1211.5833")[*On $p$-torsion of $p$-adic elliptic
  curves with additive reduction*], arXiv:1211.5833 (2013). Theorem 1: with $E slash QQ_p$
  additive and $a_i in p ZZ_p$ throughout a minimal model, $E_0 (QQ_p) tilde.equiv ZZ_p$ unless
  ($p=2$, $a_1 + a_3 equiv 2$ mod $4$), ($p=3$, $a_2 equiv 6$ mod $9$), ($p=5$, $a_4 equiv 10$ mod
  $25$) or ($p=7$, $a_6 equiv 14$ mod $49$), in which cases it is $p ZZ_p times bb(F)_p$.
]

So the situation at $p = 7$ is the exact opposite of @sec-why2, where non-procyclicity of
$E_delta (QQ_2)$ is a theorem for *every* twist and rank $>= 2$ is forced on both curves. Here
procyclicity is a theorem for every twist in the class, rank $1$ on each curve suffices, and the
density condition is the mild one that some rational point avoid the formal group.

What makes the class thin is therefore only the double rank condition. Of the squarefree $d$ in
class $[7]$ with $|d| <= 182$ --- there are fourteen of them --- exactly two have positive rank on
*both* curves, and the first of those fails the density test:

#v(2mm)
#align(center)[
#table(columns: 5, align: (right, center, center, left, left), stroke: 0.4pt + luma(170),
  inset: (x: 8pt, y: 3pt),
  table.header([$d$], [rank $E_d$], [rank $E'_d$], [dense at $7$], [why]),
  [$-91$],   [$1$], [$1$], [yes, *no*],
    [the generator of $E'_(-91)$ has $x = -3951 slash 7^4$: it lies in $E_2$],
  [$-182$],  [$1$], [$2$], [yes, yes], [*witness*],
)]

#v(2mm)

All twelve other candidates have rank $0$ on at least one of the two curves. So the class is
settled by
$ d = -182 = -2 dot 7 dot 13 , quad -182 slash 7 = -26 equiv 2 space (mod 7) , $
a quadratic residue, so $d$ is indeed in class $[7]$; $"rank" E_(-182) (QQ) = 1$,
$"rank" E'_(-182)(QQ) = 2$, and both closures are everything.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *Checked twice.* `densegroup` says dense on both, and so does an independent test written for
  the additive case: since $E_1 tilde.equiv ZZ_7$ and any element of $E_1 ∖ E_2$ generates it
  topologically, a subgroup is dense as soon as its image in $E_d (QQ_7) slash E_2$ --- a group of
  order $7 M = 49$ --- is everything. Both curves give $49$ of $49$ for $d = -182$ and for
  $d = 203$, and the same test reproduces the failures: $1$ of $49$ at $d = -91$ and $d = 273$
  (all of $E'_d (QQ)$ sits inside $E_2$), $0$ of $49$ at $d = 14$ and $d = -42$ (rank $0$).
  The `crosscheck` of @sec-method cannot be used here --- it skips $p divides N$, and $7$ divides
  the conductor throughout this class --- which is why the second test was needed.
]

Widening further confirms the picture is sparsity and nothing else. Of the $30$ squarefree $d$ in
class $[7]$ with $|d| <= 400$, seven have positive rank on both curves and *three* are witnesses:
$d = -182$, $203$, $371$. That is a hit rate of one in ten across the class --- low, but of the
same order as the other classes once the double rank condition is imposed, and with no sign of the
systematic vanishing that @sec-obstruction establishes at $p = 2$. As a check on step (b) of the
Proposition, none of those $30$ twists has a point of order $7$ over $QQ_7$ on either curve
(`elldivpol`, in the companion script) --- which is what $E_d (QQ_7) tilde.equiv ZZ_7$ predicts,
the alternative $7 ZZ_7 times bb(F)_7$ having such a point. By the Lemma one twist would have
sufficed and the other $29$ are free, but they cost nothing.

At $p = 2$ the first pass ($|d| <= 150$) found a single witness in eight classes, which looked
like an obstruction. It is not --- it is @sec-why2, which says a witness needs rank $>= 2$ on
*both* curves, so the density of witnesses is far lower than one would guess. Using the rank-$2$
requirement to steer the search (root numbers first, `ellrank` only on survivors) and going out to
$|d| <= 6000$:

#v(2mm)
#align(center)[
#table(columns: 4, align: (center, left, center, left), stroke: 0.4pt + luma(170),
  inset: (x: 9pt, y: 4pt),
  table.header([class at $2$], [witness], [ranks], [status]),
  [$[1]$],  [$d = 5105$], [$2, 2$], [dense],
  [$[3]$],  [$d = -61$],  [$2, 2$], [dense],
  [$[5]$],  [$d = 2501$], [$2, 2$], [dense],
  [$[7]$],  [$d = 183$],  [$2, 2$], [dense],
  [$[2]$],  [--], [--], [blocked by parity, @sec-parity],
  [$[6]$],  [--], [--], [blocked by parity, @sec-parity],
  [$[10]$], [--], [--], [blocked by parity, @sec-parity],
  [$[14]$], [--], [--], [blocked by parity, @sec-parity],
)]

#v(2mm)

*All four odd classes are settled.* Of $2432$ odd $d$ with $|d| <= 6000$ passing the root-number
filter, $87$ had rank $>= 2$ on both curves, and four of those are witnesses. The four even
classes remain empty, and @sec-parity explains why.

= Why $p = 2$ is hard here <sec-why2>

The first obstacle is not a shortage of search. It has a proof.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *At $p = 2$, no twist of rank $1$ can be dense.*

  #v(2mm)
  _Proof._ A $2$-torsion point of $E_d$ has $x^3 = -9 d^3$, so it is $QQ_2$-rational exactly when
  $-9 d^3$ is a cube in $QQ_2$. An element of $QQ_2^times$ is a cube if and only if its valuation
  is divisible by $3$ --- cubing is bijective on $ZZ slash 2 times ZZ_2$ and is multiplication by
  $3$ on the value group --- and $v_2 (-9 d^3) = 3 v_2 (d)$. So *every* twist acquires a
  $2$-torsion point over $QQ_2$, and the same holds for $E'_d$ with $81 d^3$. Hence
  $E_d (QQ_2) tilde.equiv ZZ_2 times T$ with $2 divides |T|$, which needs *two* topological
  generators.

  #v(1.5mm)
  Over $QQ$, by contrast, $-9$ is not a cube, so $E_d (QQ)$ never has $2$-torsion; its torsion is
  $ZZ slash 3$ or trivial. A group $ZZ xor ZZ slash 3$ or $ZZ$ has *procyclic* closure, which
  cannot be all of a non-procyclic $E_d (QQ_2)$. $qed$
]

Checked on $48$ twisted curves: all have a $QQ_2$-rational $2$-torsion point. And of $32$ twists
inspected, every one that `densegroup2` reports dense has rank $>= 2$ --- no exceptions.

== The even classes are blocked by parity <sec-parity>

The second obstacle is sharper, and it is what actually separates the two halves of the table.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Observed.* For every squarefree $d$ with $|d| <= 1200$ --- $1460$ twists ---
  $ w(E_d) thin w(E'_d) = cases(+1 & "if" d "is odd", -1 & "if" d "is even") . $
  Equivalently: for odd $d$ the pair $(w(E_d), w(E'_d))$ is $(+,+)$ or $(-,-)$ and never mixed;
  for even $d$ it is $(+,-)$ or $(-,+)$ and never equal. Tabulated:
]

#v(2mm)
#align(center)[
#table(columns: 6, align: (center, right, right, right, right, right),
  stroke: 0.4pt + luma(170), inset: (x: 8pt, y: 3pt),
  table.header([class], [twists], [$(+,+)$], [$(+,-)$], [$(-,+)$], [$(-,-)$]),
  [$[1]$],  [$242$], [$125$], [$0$],  [$0$],  [$117$],
  [$[3]$],  [$244$], [$120$], [$0$],  [$0$],  [$124$],
  [$[5]$],  [$244$], [$124$], [$0$],  [$0$],  [$120$],
  [$[7]$],  [$242$], [$117$], [$0$],  [$0$],  [$125$],
  [$[2]$],  [$121$], [$0$],   [$64$], [$57$], [$0$],
  [$[6]$],  [$123$], [$0$],   [$62$], [$61$], [$0$],
  [$[10]$], [$123$], [$0$],   [$62$], [$61$], [$0$],
  [$[14]$], [$121$], [$0$],   [$64$], [$57$], [$0$],
)]

#v(2mm)

So in the four even classes *one of the two curves always has root number $-1$*, hence odd
analytic rank. Combined with @sec-why2, a witness there would need rank $>= 2$ on both curves
*and* odd rank on one of them --- that is, rank $>= 3$ on one side. That is why the even half of
the table is empty while the odd half is not: it is not that the search was too short, it is that
the even classes demand a rank-$3$ twist paired with a rank-$2$ twist in the same square class.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *How conditional is this?* Root number $-1$ forces odd *analytic* rank unconditionally. Passing
  to the Mordell--Weil rank is the parity conjecture; the $p$-parity statement is a theorem for
  elliptic curves over $QQ$ (Dokchitser--Dokchitser), and gives the Mordell--Weil parity when Ш
  is finite. The identity $w(E_d) w(E'_d) = (-1)^(v_2 (d))$ is here an *observation* on $1460$
  twists, not a derivation; it ought to come out of the local root number at $2$, where the two
  conductors differ ($2^2$ against $2^4$), but that computation is not done. Citation from memory.
]

= Is there a twisted-pairing obstruction here? <sec-obstruction>

The natural suspicion, given how empty the even classes at $2$ are, is that the mechanism of
`nondiagonal-obstruction.typ` is at work. It is not, and the reason is structural: for *this kind
of pair* the criterion can never be set up.

== Condition (A) forces $ell = 2$ <sec-obs-A>

The criterion needs $"Hom"_(G_QQ) (E'[ell], E[ell]) != 0$, i.e. an $ell$-congruence. Here $E'$ is
a *sextic twist* of $E$:
$ E : y^2 = x^3 + 9 , wide E' : y^2 = x^3 - 81 , wide (-81) slash 9 = -9 = (-1)^3 dot 3^2 , $
so $E'$ is the quadratic twist by $-1$ composed with the cubic twist by $3$. Twisting acts through
$"Aut"(E) = mu_6 subset ZZ[zeta_6]$, and $zeta in mu_6$ acts trivially on $E[ell]$ exactly when
$ell$ divides $zeta - 1$ in $ZZ[zeta_6]$.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *$mu_6 --> "Aut"(E[ell])$ is injective for every odd $ell$.* Indeed $N(zeta_6 - 1) = 1$, a unit;
  $N(zeta_3 - 1) = 3$ but $3 = -zeta_3^2 (zeta_3 - 1)^2$, so $3$ does *not* divide $zeta_3 - 1$;
  and the only $zeta in mu_6$ with $zeta - 1$ divisible by a prime is $zeta = -1$, where
  $zeta - 1 = -2$. So the kernel is $\{plus.minus 1\}$ when $ell = 2$ and trivial otherwise.

  #v(1.5mm)
  *Consequence.* If $E'$ is a non-trivial sextic twist of $E$, then $E[ell] tilde.equiv.not
  E'[ell]$ for *every odd $ell$*. The same argument with $mu_4 subset ZZ[i]$, $N(i-1) = 2$, rules
  out $j = 1728$ twist pairs. So *no CM twist pair can satisfy (A) at an odd $ell$.*
]

Confirmed numerically: $a_q equiv a'_q$ fails mod $ell$ for every odd $ell <= 47$, over the $548$
good primes $q < 4000$. At $ell = 2$ the congruence does hold, and genuinely so --- both
$2$-division fields are $QQ(root(3,3), zeta_3)$ (`polredabs` gives $x^3 - 3$ for both $x^3 + 9$
and $x^3 - 81$), so $E[2]$ and $E'[2]$ are the same standard $2$-dimensional
$bb(F)_2 [S_3]$-module. Since $E$ and $E'$ are not isogenous, $"Hom"(E', E) = 0$ and every
non-zero $psi$ is admissible. So (A) holds --- but only for $ell = 2$.

== Two conditions are free, and one is not <sec-obs-DE>

Encouragingly, the parts that were delicate for the conductor-$200$ pair are free here.

- *(D) is vacuous.* $j = 0$ means potentially good reduction everywhere, so *no twist of either
  curve is ever multiplicative* and there are no dangerous primes at all.
- *$v = infinity$ is free even at $ell = 2$.* $"disc"(y^2 = x^3 + k) = -432 k^2 < 0$ always, so
  $E_d (RR)$ is connected, $E_d (RR) slash 2 = 0$, and $W_infinity = 0$. (Checked on nine twists.)
- *$v = 3$ is free.* At the CM prime, $dim W_3 = dim W'_3 = 0$ --- for every twist, not merely
  every twist tested. @sec-obs-three proves it.

What kills it is the rest of (E).

=== $v = 3$: a valuation, and nothing to check <sec-obs-three>

The Proposition of @sec-obs-twelve computes $dim E_d [2](QQ_q)$ for $q != 3$ and excludes $q = 3$
because the cubic residue character is the wrong tool there. The right tool is the valuation, and
it is even easier.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Proposition.* For every non-zero integer $d$,
  $ E_d [2](QQ_3) = 0 quad "and" quad E'_d [2](QQ_3) = 0 , $
  hence $dim W_3 = dim W'_3 = 0$ and $beta_3 equiv 0$ because a factor of the pairing vanishes.

  #v(2mm)
  _Proof._ A non-trivial $2$-torsion point of $E_d$ over $QQ_3$ is a root of $x^3 + 9 d^3$, i.e. a
  cube root of $-9 d^3$ in $QQ_3$. Such a root would have
  $3 v_3 (x) = v_3 (9 d^3) = 2 + 3 v_3 (d)$, and $2 + 3 v_3(d) equiv 2$ (mod $3$) is never
  divisible by $3$. For $E'_d$ the root is a cube root of $81 d^3$, with
  $3 v_3 (x) = 4 + 3 v_3 (d) equiv 1$ (mod $3$) --- again impossible. Since $3 divides.not 2$,
  $dim W_3 = dim E_d [2](QQ_3) = 0$, and likewise for $E'_d$. $qed$
]

Note what the argument does *not* use: it is independent of $d$ entirely, so unlike the primes
$q divides d$ it needs no twist-by-twist work. The reason is that $3$ ramifies in the CM field
$QQ(zeta_3)$: the valuation $v_3 (9 d^3) equiv 2$ (mod $3$) can never be adjusted by a twist,
because twisting multiplies the coefficient by a *cube*.

For the record, the local data at $3$, which by the Lemma of @sec-scan-seven depends only on the
square class of $d$ in $QQ_3^times$:

#v(2mm)
#align(center)[
#table(columns: 6, align: (center, center, center, center, center, center),
  stroke: 0.4pt + luma(170), inset: (x: 9pt, y: 3.5pt),
  table.header([class of $d$], [rep.], [$E_d$ type], [$c_3 (E_d)$], [$E'_d$ type], [$c_3 (E'_d)$]),
  [$[1]$],   [$d = 1$],  [$I V$],    [$3$], [$I V^ast$], [$1$],
  [$[u]$],   [$d = -1$], [$I V$],    [$1$], [$I V^ast$], [$3$],
  [$[3]$],   [$d = 3$],  [$I I^ast$], [$1$], [$I I$],    [$1$],
  [$[u 3]$], [$d = -3$], [$I I^ast$], [$1$], [$I I$],    [$1$],
)]

#v(2mm)

The conductor exponent at $3$ is $5$ in all eight cases, matching $N_E = 2^2 dot 3^5$ and
$N_(E') = 2^4 dot 3^5$ of @sec-pair. Every type is *additive with potentially good reduction*, as
$j = 0$ demands, and $dim W_3 = 0$ throughout --- the Proposition, seen in the table.

#block(fill: rgb("#fff4e6"), inset: 8pt, radius: 3pt, width: 100%)[
  *At $ell = 2$ the primes dividing $d$ are never free.* For $ell >= 5$ a place $q divides d$ is
  additive with $dim W_q = 0$, and *that* is what makes the criterion uniform in $d$. At
  $ell = 2$, $dim W_q = dim E_d [2](QQ_q)$ instead, read off from the roots of $x^3 + 9 d^3$ in
  $QQ_q$ --- and at *every* $q divides d$ inspected, both $dim W_q$ and $dim W'_q$ are non-zero:

  #v(2mm)
  #align(center)[
  #table(columns: 5, align: (right, right, center, center, left), stroke: 0.4pt + luma(170),
    inset: (x: 7pt, y: 3pt),
    table.header([$d$], [$q$], [$dim W_q$], [$dim W'_q$], [$beta_q$ forced $0$?]),
    [$-61$],  [$3$],    [$0$], [$0$], [yes],
    [$-61$],  [$61$],   [$2$], [$2$], [*no*],
    [$183$],  [$61$],   [$2$], [$2$], [*no*],
    [$2501$], [$41$],   [$1$], [$1$], [*no*],
    [$5105$], [$5$],    [$1$], [$1$], [*no*],
    [$5105$], [$1021$], [$2$], [$2$], [*no*],
    [$-66$],  [$11$],   [$1$], [$1$], [*no*],
    [$94$],   [$47$],   [$1$], [$1$], [*no*],
  )]

  #v(2mm)
  So $beta_q$ would have to be *evaluated* at every prime dividing $d$, afresh for each twist.
  Twist-uniformity --- the property that lets the criterion beat a finite search
  ($section 4$ of `nondiagonal-obstruction.typ`) --- is gone.
]

@sec-obs-A shows condition (A) forces $ell = 2$, and @sec-obs-DE shows that at $ell = 2$ the
primes $q divides d$ are not *forced* free. An earlier draft stopped there and concluded the
criterion could not be set up. That was too quick: *not forced to vanish* is not *non-vanishing*,
and $beta_q$ can simply be computed. It is, and the answer is that the obstruction is real.

== The pairing is explicit at $ell = 2$ <sec-obs-formula>

For every twist, both $2$-torsion fields are the same $K = QQ(u)$, $u^3 = 3$: the roots of
$x^3 + 9 d^3$ are $r_i = -d u^2 zeta_3^i$ and those of $x^3 - 81 d^3$ are $s_j = 3 d u zeta_3^j$,
and $d^3$ being a cube changes nothing. Galois acts by $sigma(r_i) = r_(i+2)$ and
$sigma(s_j) = s_(j+1)$, so the unique equivariant bijection is $psi(s_j) = r_(2j)$; under the
embedding $iota_k (u) = zeta_3^k u$ one has $iota_k (-d u^2) = r_(2k)$ and $iota_k (3 d u) = s_k$.
So in the *same* copy of $K$ the two descent classes are $x(P) + d u^2$ and $x(P') - 3 d u$, and

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  $ beta_q (P, P') = sum_(w divides q) ( x(P) + d u^2, thin x(P') - 3 d u )_(K_w) , $
  a sum of Hilbert symbols over the places of $K = QQ(u)$, $u^3 = 3$, above $q$ --- computable
  with `nfhilbert`.
]

Two checks that the normalisation is right. The local Kummer image must be *isotropic*: pairing
two points of the *same* curve gave $0$ in all $56$ symbols tested. And global reciprocity
$sum_v beta_v = 0$ held for all nine twists tested.

== Condition (E) holds --- it just is not forced <sec-obs-E>

Evaluating $beta_q$ as a *form*, over sampled local points on both curves:

#v(2mm)
#align(center)[
#table(columns: 4, align: (right, right, right, left), stroke: 0.4pt + luma(170),
  inset: (x: 8pt, y: 3pt),
  table.header([$d$], [$q$], [pairs tested], [$beta_q$]),
  [$-5$],  [$5$],  [$30100$], [zero],
  [$-7$],  [$7$],  [$44100$], [zero],
  [$-61$], [$61$], [$53824$], [zero],
  [$183$], [$61$], [$53824$], [zero],
  [$-66$], [$11$], [$49952$], [zero],
  [$94$],  [$47$], [$57600$], [zero],
  [any],   [$3$],  [$17000$--$32000$], [zero],
)]

#v(2mm)

So at every prime dividing $d$, and at the CM prime $3$, the form vanishes identically on the
sample. Together with the free places of @sec-obs-DE --- $v = infinity$, and every $v$ of good
reduction --- condition (E) holds, and reciprocity pins $beta_2$.

== Paying part of the debt: $psi_* L'_q = L_q$ <sec-obs-owed>

The right way to attack condition (E) is not to evaluate $beta_q$ but to identify the two local
Kummer images, because the two are *equivalent*:

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  $L_q$ is *maximal* isotropic, so $L_q^perp = L_q$, and therefore
  $ beta_q equiv 0 quad <==> quad psi_* L'_q subset.eq L_q quad <==> quad psi_* L'_q = L_q , $
  the last step because $dim L'_q = dim L_q$ (equal in every case tabulated).
]

So the numerics of @sec-obs-E are exactly the statement $psi_* L'_q = L_q$, and a proof of the
latter is what is owed. In one regime it is available.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Proposition.* Let $q tilde.not 6$ and suppose $-9 in (QQ_q^times)^6$. Then
  $psi_* L'_q = L_q$, hence $beta_q equiv 0$ --- unconditionally.

  #v(2mm)
  _Proof._ $E'_d$ is the sextic twist of $E_d$ by $-9$: with $c^6 = -9$ the map
  $ lambda : E'_d --> E_d , wide (X, Y) |-> (X slash c^2, thin Y slash c^3) $
  is an isomorphism, defined over $QQ_q$ as soon as $c in QQ_q$. On $2$-torsion it sends
  $theta' |-> theta' slash c^2 = theta$, since $theta' = c^2 theta$ --- which is precisely $psi$.
  Functoriality of the Kummer map then gives
  $psi_* L'_q = lambda_* delta' (E'_d (QQ_q)) = delta(lambda E'_d (QQ_q)) = delta(E_d (QQ_q)) = L_q$.
  $qed$
]

This is the *local* form of the collapse criterion of $section 3$ of
`nondiagonal-obstruction.typ`: an isomorphism defined over $QQ_q$ kills $beta_q$ there, exactly as
a global isogeny would kill it everywhere. And it is *not* vacuous, because $-9$ being a $6$th
power locally does not make $E$ and $E'$ isomorphic globally.

Since $9$ is always a square, $-9$ is a square in $QQ_q$ iff $q equiv 1 space (mod 4)$; so the
hypothesis is "$q equiv 1 space (mod 4)$ and $-9$ a cube mod $q$". On the primes that actually
arose as $q divides d$:

#v(2mm)
#align(center)[
#table(columns: 5, align: (right, center, center, center, left), stroke: 0.4pt + luma(170),
  inset: (x: 8pt, y: 3pt),
  table.header([$q$], [$q mod 4$], [$-9$ square], [$-9$ cube], [$beta_q = 0$]),
  [$5$],    [$1$], [yes], [yes], [*proved*],
  [$41$],   [$1$], [yes], [yes], [*proved*],
  [$61$],   [$1$], [yes], [yes], [*proved*],
  [$1021$], [$1$], [yes], [yes], [*proved*],
  [$7$],    [$3$], [no],  [no],  [verified, $44100$ pairs],
  [$11$],   [$3$], [no],  [yes], [verified, $49952$ pairs],
  [$47$],   [$3$], [no],  [yes], [verified, $57600$ pairs],
)]

#v(2mm)

So the debt is not discharged, but it is *localised*: what remains open is exactly the primes
$q divides d$ with $q equiv 3 space (mod 4)$, where $-9$ is not a square and the local
isomorphism does not exist. There $E'_d$ is the unramified quadratic twist of $E_d$ up to a cube,
and one wants the weaker statement that such a twist does not move the local Kummer image at a
place of additive reduction. That is not proved here.

=== Is $L_q$ unramified at $q divides d$?  No <sec-obs-unram>

At $q tilde.not d$ of good reduction $L_q = H^1_"ur"$, which is *intrinsic to the Galois module*
and therefore matched by $psi$ automatically --- that is why the good places are free. The obvious
hope is that the same holds at $q divides d$. It does not: there the twist makes $q$ additive, and
the local Kummer image escapes the unramified subgroup.

#block(fill: rgb("#fff4e6"), inset: 8pt, radius: 3pt, width: 100%)[
  *Tested and refuted.* For $q tilde.not 3$ the prime $q$ is unramified in $K = QQ(u)$
  ($"disc" K = -243$) and $v_w (u) = 0$, so $v_w (theta) = v_w (d) = 1$ at every $w divides q$ when
  $q parallel d$ --- $theta$ itself is ramified. Sampling local points and recording the parity of
  $v_w (x - theta)$:

  #v(2mm)
  #align(center)[
  #table(columns: 4, align: (right, right, right, right), stroke: 0.4pt + luma(170),
    inset: (x: 8pt, y: 3pt),
    table.header([$d$], [$q$], [odd $v_w$ on $E_d$], [odd $v_w$ on $E'_d$]),
    [$-5$],  [$5$],  [$6$ of $344$], [$9$ of $350$],
    [$-7$],  [$7$],  [$0$ of $210$], [$0$ of $210$],
    [$-66$], [$11$], [$1$ of $446$], [$2$ of $448$],
    [$94$],  [$47$], [$0$ of $480$], [$0$ of $480$],
    [$-61$], [$61$], [$0$ of $696$], [$0$ of $696$],
  )]

  #v(2mm)
  So $L_q$ is *not* contained in the unramified classes at $q = 5$ or $q = 11$. The route closes.
]

What the check did buy is a much smaller open set. Splitting the primes $q divides d$ three ways:

#v(2mm)
#align(center)[
#table(columns: 5, align: (right, right, center, center, left), stroke: 0.4pt + luma(170),
  inset: (x: 8pt, y: 3pt),
  table.header([$d$], [$q$], [$dim W_q$], [$dim W'_q$], [status]),
  [$-7$],   [$7$],    [$0$], [$0$], [*trivial*: a factor vanishes],
  [$130$],  [$13$],   [$0$], [$0$], [*trivial*],
  [$-5$],   [$5$],    [$1$], [$1$], [*proved*, @sec-obs-owed],
  [$10$],   [$5$],    [$1$], [$1$], [*proved*],
  [$-30$],  [$5$],    [$1$], [$1$], [*proved*],
  [$2501$], [$41$],   [$1$], [$1$], [*proved*],
  [$-61$],  [$61$],   [$2$], [$2$], [*proved*],
  [$5105$], [$1021$], [$2$], [$2$], [*proved*],
  [$-66$],  [$11$],   [$1$], [$1$], [*open*],
  [$94$],   [$47$],   [$1$], [$1$], [*open*],
)]

#v(2mm)

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *What is actually left.* Only $q divides d$ with $q equiv 11 space (mod 12)$
  (@sec-obs-twelve). There $dim H^1 (QQ_q, E[2]) = 2 dim H^0 = 2$, so $L_q$ and $psi_* L'_q$ are two
  *Lagrangian lines in a plane*, and $beta_q = 0$ says they coincide --- a codimension-one
  coincidence, recurring every time it is tested. Something forces it; neither the local
  isomorphism of @sec-obs-owed nor unramifiedness is that something.
]


=== The $2$-torsion, and the gap collapsing to $q equiv 11 space (mod 12)$ <sec-obs-twelve>

The $2$-torsion is indeed independent of $d$ --- twisting does not move $E[2]$, and concretely
$x^3 = -9 d^3$ has a root iff $x^3 = -9$ does, $d^3$ being a cube. One step needs correcting: $-9$
is *not* a cube in $QQ_q$ for every $q != 3$. Cubing is bijective on $QQ_q^times$ only when
$q equiv 2 space (mod 3)$; for $q equiv 1 space (mod 3)$ it is a genuine condition, and it fails
at $q = 7, 13, 37, 43, 79, 97, 109, dots.h$

Making that correction gives a clean rule --- and, better than hoped, the *same* rule for both
curves.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Proposition.* For $q != 3$, independently of $d$,
  $ dim_(bb(F)_2) E_d [2](QQ_q) = dim_(bb(F)_2) E'_d [2](QQ_q) =
    cases(
      1 & "if" q equiv 2 space (mod 3),
      2 & "if" q equiv 1 space (mod 3) "and" 3 "is a cube mod" q,
      0 & "if" q equiv 1 space (mod 3) "and" 3 "is not",
    ) $

  #v(2mm)
  _Proof._ $E_d [2]$ needs a root of $x^3 = -9 d^3$, i.e. of $x^3 = -9$; $E'_d [2]$ needs
  $x^3 = 81$. Since $-1 = (-1)^3$ and the cubic residue character $chi$ has order $3$,
  $chi(-9) = chi(3)^2$ and $chi(81) = chi(3)^4 = chi(3)$, so *all three conditions are equivalent
  to "$3$ is a cube"*. For $q equiv 2 space (mod 3)$ cubing is bijective, giving exactly one root
  and no $zeta_3$, hence $dim = 1$; for $q equiv 1 space (mod 3)$ one has $zeta_3 in QQ_q$, so
  there are three roots or none. $qed$
]

Checked against `polrootspadic` for every $q < 120$ and eight values of $d$: no mismatches, and
$dim W_q = dim W'_q$ throughout --- which is the equality observed empirically all along.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *The gap collapses.* $dim W_q = 1$ happens exactly when $q equiv 2 space (mod 3)$. The open
  cases of @sec-obs-unram were "$q equiv 3 space (mod 4)$ and $dim W_q = 1$", so what is left is
  $ q equiv 3 space (mod 4) "and" q equiv 2 space (mod 3)
    quad <==> quad q equiv 11 space (mod 12) . $
  Both open primes fit: $11$ and $47$ are $11 space (mod 12)$.

  #v(1.5mm)
  Everything else is settled. $q equiv 1 space (mod 3)$ with $3$ not a cube gives $dim W_q = 0$
  and $beta_q = 0$ trivially; $q equiv 1 space (mod 3)$ with $3$ a cube gives $q equiv 1$ or
  $7 space (mod 12)$, and if also $q equiv 1 space (mod 4)$ the local isomorphism of
  @sec-obs-owed applies.

  #v(1.5mm)
  *Two corrections, both made below.* First, $q equiv 7 space (mod 12)$ with $3$ a cube is *not*
  settled by either clause above --- it has $dim W_q = 2$ and $q equiv 3 space (mod 4)$ --- so the
  open set is $q equiv 11 space (mod 12)$ *together with* that case. Second, both are now closed:
  @sec-obs-deg2 does $q equiv 2 space (mod 3)$ and @sec-obs-general does the rest, leaving only
  $q = 3$.
]

And the remaining case has usable structure: for $q equiv 2 space (mod 3)$ the polynomial
$x^3 - 3$ has exactly one root mod $q$, so $q$ splits in $K$ as (degree $1$)(degree $2$) and
$ K times.o QQ_q tilde.equiv QQ_q times QQ_(q^2) , $
with $QQ_(q^2)$ the *unramified* quadratic extension --- better named $QQ_q (zeta_3)$, since the
three roots of $x^3 + B$ differ from one another by $zeta_3$, which is what makes the two classes
visibly proportional. So $L_q$ and $psi_* L'_q$ are two Lagrangian lines inside a group built from
one split factor and one unramified quadratic factor: concrete enough that the coincidence is
provable there, and @sec-obs-deg2 proves it.


=== Towards $q equiv 11 space (mod 12)$: the unique $2$-torsion point <sec-obs-lag>

For $q equiv 2 space (mod 3)$ there is a *unique* point of order $2$ on each curve over $QQ_q$,
and that pins down a great deal. Two steps go through; the third is where the argument still
stops.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Step 1 ($psi(T') = T$).* By @sec-obs-twelve, $E_d [2](QQ_q)$ and $E'_d [2](QQ_q)$ each have
  order $2$; write $T$, $T'$ for their non-trivial points. Since $psi$ is Galois-equivariant it
  carries $E'_d [2](QQ_q)$ to $E_d [2](QQ_q)$, so $psi(T') = T$ --- forced, not chosen.

  #v(1.5mm)
  *Step 2 ($delta_q (T)$ spans $L_q$).* At $q divides d$ the reduction is $I_0^ast$, so
  $E_0 (QQ_q)$ is pro-$q$ and has no $2$-torsion; the $2$-primary torsion of $E_d (QQ_q)$
  therefore injects into the component group $Phi_q tilde.equiv (ZZ slash 2)^2$, which has
  *exponent $2$*. So $E_d (QQ_q)$ has no point of order $4$, hence $T in.not 2 E_d (QQ_q)$ and
  $delta_q (T) != 0$. As $dim L_q = 1$, $L_q = ⟨delta_q (T)⟩$, and likewise
  $L'_q = ⟨delta'_q (T')⟩$.
]

Step 3 would be $psi_* delta'_q (T') = delta_q (T)$, giving $psi_* L'_q = L_q$ at once. It does
*not* follow formally from Step 1: the Kummer class $delta_q (T)$ is represented by
$sigma |-> sigma Q - Q$ for a point $Q$ with $2 Q = T$, and $Q$ lives on the curve, not in the
module --- $psi$ says nothing about it.

== A possible completion, and where it stops <sec-obs-lag2>

There is a way round that avoids Step 3 entirely.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *(a) $psi_*$ is an isometry.* An isomorphism of Galois modules preserves the Weil pairing up to
  a scalar; at $ell = 2$ that scalar lies in $bb(F)_2^times = \{1\}$, so *every* module
  isomorphism preserves the pairing exactly. Hence $psi_* L'_q$ is isotropic.

  #v(1.5mm)
  *(b) In characteristic $2$ the self-pairing is linear.* On $H^1 (QQ_q, E_d [2])$, which is
  $2$-dimensional here,
  $ ⟨x + y, x + y⟩ = ⟨x,x⟩ + ⟨y,y⟩ + 2⟨x,y⟩ = ⟨x,x⟩ + ⟨y,y⟩ , $
  so $x |-> ⟨x,x⟩$ is $bb(F)_2$-*linear*. If it is not identically zero its kernel is a *single*
  line --- the unique isotropic line --- and both $L_q$ and $psi_* L'_q$, being isotropic, must
  equal it. Then $psi_* L'_q = L_q$ and $beta_q = 0$.
]

So everything reduces to: *is $x |-> ⟨x,x⟩$ non-zero on $H^1 (QQ_q, E_d [2])$?* In the Hilbert
symbol model $⟨a,a⟩ = sum_(w divides q) (a, -1)_(K_w)$. For $q equiv 2 space (mod 3)$ the algebra
splits as $K times.o QQ_q tilde.equiv QQ_q times QQ_(q^2)$, and one expects the degree-$2$ term to
die --- its residue field is $bb(F)_(q^2)$ with $q^2 equiv 1 space (mod 4)$ --- leaving
$⟨a,a⟩ = v_(w_1) (a) mod 2$ at the degree-one place, where $q equiv 3 space (mod 4)$ makes $-1$ a
non-square. That functional is non-zero as soon as some class of $H^1$ has odd valuation at $w_1$.

The valuation data is consistent with exactly this:

#v(2mm)
#align(center)[
#table(columns: 5, align: (right, right, center, center, center), stroke: 0.4pt + luma(170),
  inset: (x: 8pt, y: 3pt),
  table.header([$d$], [$q$], [$q mod 4$], [odd $v_(w_1)$], [odd $v_(w_2)$]),
  [$-66$],  [$11$], [$3$], [$0$], [$1$ / $2$],
  [$94$],   [$47$], [$3$], [$0$], [$0$],
  [$-5$],   [$5$],  [$1$], [$0$], [$6$ / $9$],
  [$2501$], [$41$], [$1$], [$0$], [$0$],
)]

#v(2mm)

Both $L_q$ and $psi_* L'_q$ have *even* valuation at the degree-one place in every case, which is
what isotropy demands, and the odd valuations of @sec-obs-unram all sit at the degree-*two* place,
where the symbol is expected to vanish anyway.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *This route is no longer needed --- and it never could have worked.* What it asks for is that
  $x |-> ⟨x,x⟩$ be non-zero on $H^1$, equivalently that $-1$ be a non-square in $K_(w_1)$ but a
  square in $K_(w_2)$. The second half is fine, but at $w_2$ the reason is that $-1$ is a square
  in *every* $L = QQ_q (zeta_3)$ with $q$ odd; and by Corollary 7(b) of `descent-s3.typ` the
  functional is $a |-> (N a, -1)_q$, which vanishes identically on $ker N$. So
  $x |-> ⟨x,x⟩ equiv 0$ on $H^1 (QQ_q, E_d[2])$ *always* --- every line is isotropic, and (b)
  distinguishes nothing.

  #v(1.5mm)
  (An earlier attempt to test the square condition with `nfhilbert(K,-1,-1,pr)` was also wrong on
  its own terms: that symbol tests whether $-1$ is a *norm* from $K_w (sqrt(-1))$, not whether it
  is a square.) Steps 1, 2 and (a) remain proofs and are used below; (b) is a dead end.
  @sec-obs-deg2 proves Step 3 directly instead, by computing both components of the class.
]


=== Step 3, and why the extension is $QQ_q (sqrt(3))$ <sec-obs-step3>

Step 3 is not a dead end. Choose $Q$ with $2 Q = T$ and $Q'$ with $2 Q' = T'$ over the *same*
quadratic extension; the cocycles $sigma |-> sigma Q - Q$ and $sigma |-> sigma Q' - Q'$ are then
both "$0$ or the $2$-torsion point, according to $sigma$ on that extension", and
$psi(T') = T$ closes the argument. Two things make this work, and neither is a guess.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *The cocycle really is inflated.* If $Q$ is defined over a quadratic $L slash QQ_q$ then
  $sigma |-> sigma Q - Q$ factors through $"Gal"(L slash QQ_q) = \{1, tau\}$, and the cocycle
  identity forces $tau(c(tau)) = c(tau)$, so $c(tau) in E(L)[2]$. For $q equiv 2 space (mod 3)$
  and $q equiv 3 space (mod 4)$ one has $zeta_3 in.not L$ --- because $-3$ is a square mod $q$ only
  when $q equiv 1 space (mod 3)$ --- so $E(L)[2] = \{O, T\}$. And $c(tau) != O$, since otherwise
  $Q$ would be rational and $T in 2 E_d (QQ_q)$, contradicting Step 2. Hence $c(tau) = T$.

  #v(1.5mm)
  *The extension is $QQ_q (sqrt(3))$, for both curves at once.* The halving points of $T = (e,0)$
  on $y^2 = f(x)$ live over $QQ_q (sqrt(e - e'), sqrt(e - e''))$, and
  $ (e - e')(e - e'') = f'(e) = 3 e^2 quad "for" quad f = x^3 + B , $
  so $sqrt((e-e')(e-e'')) = e sqrt(3)$. This is *independent of $B$ and of $d$*: the same
  $QQ_q (sqrt(3))$ serves $E_d$ and $E'_d$, which is exactly what the argument needs.
]

The same identity shows up on the descent side, and unconditionally. The class of $T$ in
$K times.o QQ_q$ is $f'(e) = 3 e^2$ at the degree-one place and $e - theta$ at the degree-two
place; modulo squares the first component is *the class of $3$* --- and the same computation on
$E'_d$, where $f'(e') = 3 e'^2$, gives the class of $3$ again. So

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  $L_q$ and $psi_* L'_q$ *provably agree at the degree-one place*: both are the class of $3$.
]

@sec-obs-deg2 does the degree-two place as well, and the two classes turn out to be equal there
too --- which finishes Step 3 outright.

=== The degree-two component, and $L_q$ in closed form <sec-obs-deg2>

The degree-two component is no harder, once the quadratic factor is named correctly. It is not
merely "the unramified quadratic extension": it is $QQ_q (zeta_3)$, and that is the whole point ---
the three roots of $x^3 + B$ differ from one another by $zeta_3$, so naming the field by $zeta_3$
makes the two classes visibly proportional.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *The splitting, explicitly.* Let $q equiv 2 space (mod 3)$, $q != 3$, and let $c in ZZ_q^times$
  be the cube root of $3$ (unique: cubing is bijective on $ZZ_q^times$). Then
  $ K times.o QQ_q attach(-->, t: tilde) QQ_q times L , quad u |-> (c, thin zeta_3 c) ,
    quad L = QQ_q (zeta_3) , $
  the second factor being the unramified quadratic extension, and the two embeddings
  $u |-> zeta_3 c$, $u |-> zeta_3^2 c$ being Frobenius-conjugate, hence one place.

  #v(1.5mm)
  The $QQ_q$-rational roots are then
  $ e = -d c^2 quad "on" E_d : y^2 = x^3 + 9 d^3 , quad quad
    e' = 3 d c quad "on" E'_d : y^2 = x^3 - 81 d^3 , $
  and $psi(T') = T$ of Step 1 is visible: $psi$ matches $s_0 |-> r_0$, i.e. $e' |-> e$.
]

Now write both classes out. With $theta |-> -d u^2$ on $E_d$ and $theta' |-> 3 d u$ on $E'_d$
(the identification of @sec-obs-formula, which is what makes $psi_*$ the identity on $K$), the
degree-one components use the $f'(e)$ rule and the degree-two components are $e - theta$ read
through $u |-> zeta_3 c$:

$ delta_q (T) = (thin 3 e^2, thin e + d zeta_3^2 c^2 thin)
  = (thin 3 e^2, thin d c^2 (zeta_3^2 - 1) thin) , $
$ psi_* delta'_q (T') = (thin 3 e'^2, thin e' - 3 d zeta_3 c thin)
  = (thin 3 e'^2, thin 3 d c (1 - zeta_3) thin) . $

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Proposition (Step 3, proved).* For every $q equiv 2 space (mod 3)$ with $q != 3$, and every $d$,
  $ delta_q (T) = (thin c^(-2), thin zeta_3 c^(-1) thin)^2 dot psi_* delta'_q (T')
    quad "in" quad QQ_q^times times L^times . $
  This is an *identity in $A_q^times$*, not a congruence modulo squares: the two classes differ by
  an explicit square.

  #v(2mm)
  _Proof._ Degree one: $3 e^2 = 3 d^2 c^4$ and $3 e'^2 = 27 d^2 c^2$, so the ratio is
  $c^2 slash 9 = c^2 slash c^6 = c^(-4)$, using $c^3 = 3$.

  #v(1mm)
  Degree two: $zeta_3^2 - 1 = zeta_3^2 (1 - zeta_3)$, so the two components are
  $d c^2 zeta_3^2 (1 - zeta_3)$ and $3 d c (1 - zeta_3)$, of ratio
  $c zeta_3^2 slash 3 = zeta_3^2 slash c^2$. $qed$
]

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *Consequence.* By Step 2, $L_q = ⟨delta_q (T)⟩$ and $L'_q = ⟨delta'_q (T')⟩$ at
  $q divides d$, so
  $ psi_* L'_q = L_q quad "and hence" quad beta_q equiv 0 $
  at *every* $q divides d$ with $q equiv 2 space (mod 3)$: the two Lagrangian lines are the same
  line, and $beta_q (T,T') = ⟨delta_q (T), delta_q (T)⟩ = 0$ because $L_q$ is isotropic. No
  congruence on $q$ modulo $4$ enters, so this covers $q equiv 5$ and $q equiv 11 space (mod 12)$
  at once --- the whole of the open set of @sec-obs-twelve.
]

Reducing modulo squares gives $L_q$ itself. In $L$ the element $c$ is a unit and
$3 c = c^4 = (c^2)^2$; $zeta_3 = (zeta_3^2)^2$; and $e^2$, $c^2$ are squares. So both classes
collapse to the same normal form:

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *$L_q$ in closed form.* For $q equiv 2 space (mod 3)$, $q divides d$, $q != 2, 3$,
  $ L_q = psi_* L'_q = ⟨ thin ( thin 3, thin d (1 - zeta_3) thin ) thin ⟩
    subset.eq QQ_q^times slash "sq" times L^times slash "sq" , $
  and for $d$ squarefree this is $⟨ (3, thin q (1 - zeta_3)) ⟩$, since every unit of $ZZ_q$ is a
  square in the unramified quadratic extension.
]

Three checks that this is the right object, none of them numerical:

*(i) It lies in $ker N$.* $N_(L slash QQ_q) (1 - zeta_3) = (1-zeta_3)(1-zeta_3^2) = 3$, so the
norm of the generator is $3 dot d^2 dot 3 = (3d)^2$, a square --- as every class of
$H^1 (QQ_q, E_d [2])$ must be.

*(ii) It is not unramified, and the odd valuation sits at $w_2$.* $v_(w_1)(3) = 0$ while
$v_(w_2)(q(1 - zeta_3)) = 1$. That is exactly the pattern sampled in @sec-obs-unram --- odd
valuations at the degree-two place only, none at the degree-one place --- which is what closed
the unramified route there, now derived rather than observed.

*(iii) It explains the zero counts.* @sec-obs-unram found *no* point of odd valuation for
$d = 94, q = 47$ and $d = 2501, q = 41$, and a handful for $d = -66, q = 11$ and $d = -5, q = 5$.
Both are consistent: the non-trivial class exists in every case, but a search over small rational
abscissae meets it rarely when $q$ is large. Re-running the same sampling and testing membership
in $⟨delta_q (T)⟩$ rather than parity of valuation puts *every* sampled class inside the line ---
see `results/kummer-example-j0.txt`.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *What the identity does not give at $q = 2$.* The Proposition holds verbatim at $q = 2$
  ($2 equiv 2$ mod $3$, and $3$ is a cube in $ZZ_2^times$), so
  $delta_2 (T) = psi_* delta'_2 (T')$ there too. But Step 2 fails at $q = 2$:
  $dim L_2 = dim E[2](QQ_2) + 1 = 2$, so $L_2$ is *not* the line spanned by $delta_2 (T)$ and the
  argument gives only that the two lines inside $L_2$ and $psi_* L'_2$ agree. $beta_2$ stays with
  @sec-obs-verdict.
]

=== The same computation at every $q != 3$ <sec-obs-general>

Nothing above used $q equiv 2 space (mod 3)$ except to name the local factors. Done in the
splitting field once, the identity covers every $q$ at which there is any $2$-torsion to speak of.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Proposition (general form).* Write $r_i = -d u^2 zeta_3^i$ and $s_j = 3 d u zeta_3^j$ for the
  roots, as in @sec-obs-formula, with $psi(s_j) = r_(2j)$. Then for all $j$ and all $k != j$,
  $ (3 r_(2j)^2) / (3 s_j^2) = (r_(2j) / s_j)^2 , quad quad
    (r_(2j) - r_(2k)) / (s_j - s_k) = zeta_3^m / u^2 = (zeta_3^(2m) / u)^2 , $
  where $m$ is the index outside $\{j, k\}$.

  #v(2mm)
  _Proof._ $r_(2j) - r_(2k) = -d u^2 (zeta_3^(2j) - zeta_3^(2k))
  = -d u^2 (zeta_3^j - zeta_3^k)(zeta_3^j + zeta_3^k)$ and $s_j - s_k = 3 d u (zeta_3^j -
  zeta_3^k)$, so the ratio is $-u (zeta_3^j + zeta_3^k) slash 3 = u zeta_3^m slash u^3
  = zeta_3^m slash u^2$, using $zeta_3^j + zeta_3^k = -zeta_3^m$ and $u^3 = 3$. $qed$
]

The point is that the square root is *available locally*. At a place $w$ of $A_q$ the relevant
component is $r_(2j) - theta_w$ with $r_(2j) in QQ_q$ and $theta_w = r_(2k) in A_w$; then
$zeta_3^(2(j-k)) = r_(2j) slash r_(2k) in A_w$, so $zeta_3 in A_w$, and $u^2 = -r_(2j)
zeta_3^(-2j) slash d in A_w$, whence $u = 3 slash u^2 in A_w$. So $zeta_3^(2m) slash u$ lies in
$A_w$ and the ratio is a square *there*.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *Corollary.* $psi_* delta'_q (T') = delta_q (T)$ for every $QQ_q$-rational $2$-torsion point,
  at every $q != 3$. And the Step 2 argument generalises: at $q divides d$ the reduction is
  $I_0^ast$, $E_0 (QQ_q)$ is pro-$q$, and $Phi_q tilde.equiv (ZZ slash 2)^2$ has exponent $2$, so
  $E_d [2](QQ_q) --> E_d (QQ_q) slash 2$ is *injective*; its image therefore has dimension
  $dim E_d [2](QQ_q) = dim L_q$ and is all of $L_q$. Hence
  $ psi_* L'_q = L_q quad "and" quad beta_q equiv 0 quad "at every" q divides d "with"
    q != 2, 3 . $
  The three regimes of @sec-obs-twelve are covered uniformly: $dim L_q = 0$ (nothing to prove),
  $dim L_q = 1$ (the case above), and $dim L_q = 2$ (all three roots rational, all nine component
  ratios square).
]

Only $q = 3$ escapes, and it escapes for a reason: there $x^3 - 3$ is Eisenstein, $A_3$ is a
*totally ramified* cubic field rather than a product, the roots do not generate it over each
other in the way just used, and $u$ is a uniformiser rather than a unit. Nothing here replaces
that case.

== The open primes, now settled by an exact computation <sec-obs-step3b>

Because $L_q = ⟨delta_q (T)⟩$ and $psi_* L'_q = ⟨psi_* delta'_q (T')⟩$ are *lines* (Step 2),
bilinearity means $beta_q equiv 0$ is the single symbol $beta_q (T, T') = 0$ --- a finite, exact
computation, with no sampling. Evaluating it place by place:

#v(2mm)
#align(center)[
#table(columns: 5, align: (right, right, center, center, center), stroke: 0.4pt + luma(170),
  inset: (x: 8pt, y: 3pt),
  table.header([$d$], [$q$], [$q mod 4$], [symbol at $w_1$], [symbol at $w_2$]),
  [$-66$],  [$11$], [$3$], [$+1$], [$+1$],
  [$94$],   [$47$], [$3$], [$+1$], [$+1$],
  [$-5$],   [$5$],  [$1$], [$+1$], [$+1$],
  [$2501$], [$41$], [$1$], [$+1$], [$+1$],
)]

#v(2mm)

So $beta_q (T, T') = 0$ at both open primes. This *replaces* the sampled verification of
@sec-obs-E at $q divides d$ by an exact one on a spanning vector --- a strictly stronger
statement, and much cheaper.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *And now it is a proof.* The table was the evidence; @sec-obs-deg2 is the reason. Both
  components agree --- degree one by the $f'(e) = 3 e^2$ computation above, degree two by the
  Proposition --- so $delta_q (T) = psi_* delta'_q (T')$ outright and the symbols are forced to be
  $+1$. The $+1$ at $w_1$ is $(3,3)_(QQ_q) = (3,-1)_(QQ_q) = +1$ for $q divides.not 6$, and the
  $+1$ at $w_2$ is $(alpha, alpha)_L = (alpha, -1)_L = +1$, where $alpha = d(1 - zeta_3)$ is the
  common degree-two component, because $-1$ is a square in $L$ for odd $q$
  ($\#bb(F)_(q^2)^times = q^2 - 1 equiv 0$ mod $8$). Nothing is left to check at these primes.
]


== $beta_2$, and the verdict <sec-obs-verdict>

#v(2mm)
#align(center)[
#table(columns: 4, align: (center, right, right, left), stroke: 0.4pt + luma(170),
  inset: (x: 9pt, y: 3pt),
  table.header([class at $2$], [$d$], [non-zero / pairs], [$beta_2$]),
  [$[1]$],  [$1$, $-7$],    [$0 slash 4950$, $0 slash 4800$], [zero],
  [$[3]$],  [$-61$, $67$],  [$0 slash 460$, $0 slash 504$],   [zero],
  [$[5]$],  [$-3$, $2501$], [$0 slash 660$, $0 slash 675$],   [zero],
  [$[7]$],  [$183$],        [$0 slash 4800$],                 [zero],
  [$[2]$],  [$2$, $-30$],   [$2809 slash 4554$, $2809 slash 4290$], [*non-zero*],
  [$[6]$],  [$6$, $38$],    [$2862 slash 4422$, $2862 slash 4690$], [*non-zero*],
  [$[10]$], [$-6$, $10$],   [$2915 slash 4692$, $2862 slash 4686$], [*non-zero*],
  [$[14]$], [$-66$, $94$],  [$2970 slash 4556$, $2970 slash 4824$], [*non-zero*],
)]

#v(2mm)

Two independent $d$ per class agree, confirming that $beta_2$ depends on $d$ only through its
square class. The split is exact: *$beta_2 equiv.not 0$ on all four even classes and
$beta_2 equiv 0$ on all four odd ones.*

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Conclusion.* $X(QQ)$ is *not* dense in $X(QQ_2)$.

  #v(2mm)
  On each even square class $beta_2 equiv.not 0$, so there is $(w, w') in W_2 times W'_2$ with
  $beta_2 (w, w') != 0$; by the endgame of $section 5$ of `nondiagonal-obstruction.typ` no twist
  can have $w in R_d$ *and* $w' in R'_d$, so $union.big_d H_d times H'_d$ misses that pair and the
  *union* form of the criterion fails --- not merely the single-twist form.
]

This is exactly the empirical picture of @sec-scan: the four odd classes have witnesses, the four
even ones have none. The parity observation of @sec-parity is the shadow of this, not the cause;
it explains why rank-$2$ pairs are scarce in the even classes, while $beta_2 != 0$ explains why
no twist there could ever have worked.

== Status <sec-obs-status>

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *Proved.* $beta_2 equiv.not 0$ on the four even classes: a single non-zero value settles it, and
  thousands were found. $beta_2 equiv 0$ on the four odd classes, twice over --- directly, and by
  the refutation argument, since the witnesses of @sec-scan have both local images full.

  #v(1.5mm)
  *Proved at $q divides d$, $q equiv 2 space (mod 3)$.* @sec-obs-deg2 computes $L_q$ in closed
  form, $⟨(3, thin d(1 - zeta_3))⟩$, and shows $delta_q (T) = psi_* delta'_q (T')$ as an identity
  in $A_q^times$. So $psi_* L'_q = L_q$ and $beta_q equiv 0$ there --- which is the whole of the
  set left open by @sec-obs-twelve, $q equiv 11 space (mod 12)$ included, and it subsumes the
  $q equiv 5 space (mod 12)$ part of @sec-obs-owed.

  #v(1.5mm)
  *Proved at every $q divides d$ with $q != 2, 3$.* @sec-obs-general does the remaining regime,
  $q equiv 1 space (mod 3)$ with $3$ a cube, by the same identity in the splitting field. This
  also fills a case @sec-obs-twelve passed over: $q equiv 7 space (mod 12)$ with $3$ a cube has
  $dim W_q = 2$ and $q equiv 3 space (mod 4)$, so neither the local isomorphism of @sec-obs-owed
  nor the $dim W_q = 1$ analysis reached it. No such $q$ divides any $d$ in the tables, but the
  bookkeeping needed it.

  #v(1.5mm)
  *Proved at $q = 3$.* @sec-obs-three: $dim W_3 = dim W'_3 = 0$ for every $d$, because
  $v_3 (9 d^3) equiv 2$ and $v_3 (81 d^3) equiv 1$ (mod $3$) are never divisible by $3$, so
  neither curve has a $2$-torsion point over $QQ_3$ and a factor of the pairing vanishes. This
  needed the valuation rather than the cubic residue character, which is why @sec-obs-twelve
  excluded it.

  #v(1.5mm)
  *Nothing is open.* Condition (E) asks for $beta_v equiv 0$ at every $v != 2$, and the places
  are exhausted: $v = infinity$ ($E_d (RR)$ connected, so $W_infinity = 0$), $v = 3$
  (@sec-obs-three), $v = q divides d$ (@sec-obs-deg2 and @sec-obs-general), and $v$ of good
  reduction (@sec-obs-DE). Both curves have bad reduction only at $2$, $3$ and the primes dividing
  $d$, so that is every place. *The obstruction at $p = 2$ is therefore unconditional.*

  #v(1.5mm)
  *No longer assumed.* That the local Tate pairing is the sum of Hilbert symbols over
  $w divides q$: this is Theorem 6 of `descent-s3.typ`, proved there and referenced there
  (§4.7), and proved again from the definition of corestriction in `corestriction.typ` §5.
  The self-pairing formula used in @sec-obs-lag2 is its Corollary 7(b).
]

= What this does and does not prove <sec-status>

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *Proved.* $X(QQ)$ is dense in $X(QQ_3)$, in $X(QQ_5)$ and in $X(QQ_7)$ --- a single twist in
  each of the four classes, the last of them $d = -182$ (@sec-scan-seven). At $p = 2$ the four odd
  classes are settled, by $d = 5105, -61, 2501, 183$.

  #v(1.5mm)
  *Also proved: $X(QQ)$ is not dense in $X(QQ_2)$.* The four even classes fail, and not for want
  of searching. Two steps, both now complete. $beta_2 equiv.not 0$ on each even class ---
  a *single* non-zero symbol settles that, and thousands were found (@sec-obs-verdict). And
  condition (E), which the criterion needs, holds at every place other than $2$: at $infinity$
  because $"disc" < 0$ makes $E_d (RR)$ connected and $W_infinity = 0$; at $q = 3$ by
  @sec-obs-three; at $q divides d$ by @sec-obs-deg2 and @sec-obs-general; and at every good place
  by @sec-obs-DE. Both curves are bad only at $2$, $3$ and the primes dividing $d$, so those are
  all the places there are. The conclusion is therefore *unconditional*, and it is stronger than
  the parity obstruction of @sec-parity: parity blocks the single-twist route, while
  @sec-obstruction blocks the *union* form as well.

  #v(1.5mm)
  *Imported rather than proved here.* The criterion itself --- that
  $beta_2 (w, w') != 0$ for some pair rules out every union $union.big_d H_d times H'_d$ --- is the
  endgame of $section 5$ of `nondiagonal-obstruction.typ`, used as a black box. And the scan covers
  $p = 2, 3, 5, 7$ only: nothing here says anything about $p >= 11$.

  #v(1.5mm)
  *Search-limited.* The odd-class witnesses came from $|d| <= 6000$; three of the four lie beyond
  $|d| = 150$, which is why the first pass looked so empty. A rank-$3$ / rank-$2$ pair in an even
  class may simply lie further out still.
]
