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
  $p = 2$ *all four odd classes* are covered and all four even classes are empty, and both halves
  have structural explanations. $E_d (QQ_2)$ always has a $2$-torsion point while $E_d (QQ)$ never
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

== The lesson <sec-obs-lesson>

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *CM twist pairs are exactly the wrong place to look.* Being sextic twists is what makes $E$ and
  $E'$ *look* congruent --- half their $a_q$ agree, all the supersingular ones being $0$ --- and
  it is also precisely what forbids a congruence at any odd $ell$. The criterion wants two curves
  that are congruent *without* being geometrically related: different $j$-invariants, congruent by
  accident of the modular surface $X_E (ell)$. That is the conductor-$200$ pair of
  `nondiagonal-obstruction.typ`, with $j = 2048$ and $j = 270$.

  #v(1.5mm)
  So the emptiness of the four even classes at $p = 2$ is *not* explained by a twisted-pairing
  obstruction. As far as this document goes it is explained by @sec-parity --- a parity
  obstruction to the single-twist route --- and whether density itself fails there is open.
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
  @sec-parity blocks the *single-twist* route in the even classes; it says nothing about the union.
  And by @sec-obstruction the twisted-pairing obstruction is *not* available for this pair at any
  odd $ell$, so it is not the explanation either.

  #v(1.5mm)
  *Search-limited.* The odd-class witnesses came from $|d| <= 6000$; three of the four lie beyond
  $|d| = 150$, which is why the first pass looked so empty. A rank-$3$ / rank-$2$ pair in an even
  class may simply lie further out still.
]
