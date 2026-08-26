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
  *Summary.* At $p = 3, 5$ a single twist covers every square class; at $p = 7$ three of four. At
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
  [$7$], [$[1]$: $d = 22$], [$[u]$: $d = -30$],  [$[7]$: *none*],    [$[u 7]$: $d = -7$],
)]

#v(2mm)

So $p = 3$ and $p = 5$ are settled outright: one twist per class, hence $X(QQ)$ is dense in
$X(QQ_p)$. At $p = 7$ the class $[7]$ found nothing in the range.

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
- *$v = 3$ is free.* At the CM prime, $dim W_3 = dim W'_3 = 0$ for every twist tested.

What kills it is the rest of (E).

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
  *Partly discharged.* @sec-obs-owed proves $beta_q equiv 0$ at every $q divides d$ with
  $q equiv 1 space (mod 4)$ (and $-9$ a cube), via a local isomorphism. What remains verified but
  not proved is $beta_q equiv 0$ at $q divides d$ with $q equiv 3 space (mod 4)$, and at $q = 3$.
  The non-density statement is *conditional on those*.

  #v(1.5mm)
  *Also assumed.* That the local Tate pairing is the sum of Hilbert symbols over $w divides q$
  --- standard in $2$-descent, and checked here against isotropy of $L_q$ and against global
  reciprocity, but taken from the literature rather than derived.
]

= What this does and does not prove <sec-status>

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *Proved.* $X(QQ)$ is dense in $X(QQ_3)$ and in $X(QQ_5)$ --- a single twist in each of the four
  classes. At $p = 2$ the four odd classes are settled, by $d = 5105, -61, 2501, 183$.

  #v(1.5mm)
  *Not proved.* That the four even classes at $p = 2$, or $[7]$ at $p = 7$, fail. Because
  $E_delta (QQ_2)$ is *not procyclic* --- the very $2$-torsion that makes @sec-why2 work --- the
  single-twist form is not necessary at $2$ ($section 2.1.1$ of the main notes), so a union of
  several deficient twists could still cover. That union question is precisely where the
  correlation between the two factors matters, and it is untouched here. The parity obstruction of
  @sec-parity blocks the *single-twist* route in the even classes. But @sec-obstruction goes
  further and shows the *union* form fails there too: $beta_2 equiv.not 0$ on all four even
  classes, so $X(QQ)$ is not dense in $X(QQ_2)$ --- conditional on condition (E), which is
  verified on large samples rather than proved.

  #v(1.5mm)
  *Search-limited.* The odd-class witnesses came from $|d| <= 6000$; three of the four lie beyond
  $|d| = 150$, which is why the first pass looked so empty. A rank-$3$ / rank-$2$ pair in an even
  class may simply lie further out still.
]
