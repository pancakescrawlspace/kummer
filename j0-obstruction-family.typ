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
  #text(size: 16pt, weight: "bold")[Where the obstruction can live]
  #v(2mm)
  #text(size: 10pt)[The criterion that actually matters is twist-uniformity of $Sigma$, not $Sigma = {2}$:
  the $4$-torsion mechanism, an exact criterion, and a search that finds $Sigma$ of size one]
  #v(1mm)
  #text(size: 9pt, style: "italic")[a question of René Pannekoek's; sequel to
  `kummer-example-j0.typ`; checks in `j0-obstruction-family.gp`]
]

#v(4mm)

#block(fill: luma(240), inset: 9pt, radius: 3pt, width: 100%)[
  *Summary.* For $j = 0$ pairs $E_a : y^2 = x^3 + a$, the conditions that make the argument of
  `kummer-example-j0.typ` run are five, and four of them are cheap congruences (@sec-cond). The
  fifth, condition (E) --- $beta_q equiv 0$ at every $q eq.not 2$ --- is the binding one, and
  @sec-four identifies half of its mechanism: *at an odd prime of additive reduction a $j = 0$
  curve has no point of order $4$*, because its component group has exponent dividing $6$; hence
  $L_q$ is spanned by the classes of the $2$-torsion and $beta_q equiv 0$ becomes an *exact, finite*
  check on nine torsion classes. That is enough to settle the question, and the answer is negative
  for the whole quadratic-twist branch: @sec-diagnosis shows the comparison of torsion classes is
  governed by whether the twisting parameter is a square, and @sec-search finds that *every* pair
  with $a' = -a$ fails, at the first prime $q equiv 7$ (mod $12$) at which $x^3 - a$ splits.

  #v(1.5mm)
  *A correction.* An earlier version of this note evaluated $beta_q$ on *sampled* local points and
  reported fifteen survivors. That sampling under-covers $QQ_q$ as $q$ grows and the survivors were
  spurious; the exact test of @sec-diagnosis retracts them.
]

= The criterion, corrected <sec-reframe>

`kummer-example-j0.typ` proves its non-density by showing $beta_2 equiv.not 0$ and
$beta_v equiv 0$ at every other place. That is *one* way to obstruct, not the only one, and
isolating the obstruction at $2$ is not what the argument needs. Set
$ Sigma = { v : psi_* L'_v eq.not L_v } . $

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Criterion.* Let $E, E'$ be non-isogenous with $E[2] tilde.equiv E'[2]$ via $psi$. Suppose
  #v(1mm)
  *(a)* $Sigma$ is finite and *independent of the twist $d$*; and #h(4mm) *(b)* $Sigma eq.not
  nothing$.
  #v(1mm)
  Then for every $d$ reciprocity gives $sum_(q in Sigma) beta_q (R_d, R'_d) = 0$, so $X(QQ)$ is
  *not dense in $product_(q in Sigma) X(QQ_q)$*.
]

#v(2mm)
Condition (E) of the companion conflates two things. The load-bearing half is (a) --- the
*varying* primes $q divides d$ must contribute nothing, or $Sigma$ grows with the twist and the
sum condition says nothing uniform. The inessential half is the demand $Sigma = {2}$. Everything
proved in @sec-four about the $4$-torsion is about (a) and keeps its value; the work spent in the
companion on showing $beta_3 equiv 0$ and $W_infinity = 0$ was buying something not needed.

= Full rational $2$-torsion, and an exact criterion <sec-full2>

The reframing opens a family the $j = 0$ world cannot reach. Take $E : y^2 = x(x-m)(x-n)$ with all
of $E[2]$ rational. Then the descent algebra is $QQ times QQ times QQ$, $"Aut"(E[2]) = S_3$
permutes the three slots --- so there are *six* admissible $psi$, not one --- and the torsion
classes are *rational* triples,
$ delta(T_0) = (m n, -m, -n), wide delta(T_m) = (m, m(m-n), m-n), wide
  delta(T_n) = (n, n-m, n(n-m)) . $

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *Reciprocity fixes the size of $Sigma$ from below.* Since the classes are global,
  $sum_v beta_v (T_i, T'_j) = 0$ for every $i, j$. So a single place cannot carry a non-vanishing
  supported on torsion classes: on torsion, $abs(Sigma) eq.not 1$. Under the old framing this was
  fatal; under @sec-reframe it merely says two places, and two places is a legitimate answer. It is
  also the reason the companion's §6.8(b) found $beta_2 (T, P') = beta_2 (P, T') = 0$ --- with
  $abs(Sigma) = 1$ the obstruction had nowhere to sit but the non-torsion part of $L_2$.
]

#v(2mm)
Twisting by $d$ replaces the roots by $d r$, which multiplies slot $k$ of $delta(T_i)$ by $d$ for
$k eq.not i$. Expanding the symbol bilinearly gives the whole $d$-dependence in one factor:

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  $ beta_v^((d)) (T_i, T'_j) = beta_v^((1)) (T_i, T'_j) dot (d, M_(i j))_v , wide
    M_(i j) = product_(sigma(k) eq.not j) u_(i k) dot product_(k eq.not i) v_(j sigma(k)) dot
    (-1)^(1 + [sigma(i) = j]) . $
  So $beta_v$ is independent of $d$ exactly where $M_(i j)$ is a square in $QQ_v$, and
  $ Sigma = S_1 union S_2 , wide S_1 = {v : beta_v^((1)) eq.not 0} , wide
    S_2 = {v : "some" M_(i j) in.not (QQ_v^times)^2} . $
  Both are finite and computable from rational data, so *$Sigma$ is automatically finite and
  independent of $d$* --- condition (a) is free, and the search is only for $Sigma$ small and
  non-empty.
]

#v(2mm)
Sanity check: for $E' = E$ and $psi = "id"$ every $M_(i j)$ is a square, as it must be.

= The search on the corrected terms <sec-newsearch>

Scanning pairs $y^2 = x(x-m)(x-n)$ over small $m, n$, non-isogenous, all six $psi$ (check 9): of
$684$ combinations, the smallest non-empty $Sigma$ has size *one*, realised twice:

#align(center, table(
  columns: 3, align: (left, center, center),
  stroke: 0.4pt + luma(170), inset: (x: 10pt, y: 3.5pt),
  table.header([$E$ / $E'$], [$psi$], [$Sigma$]),
  [$x(x-1)(x-2)$ / $x(x-1)(x-9)$], [$"id"$], [${2}$],
  [$x(x-1)(x+1)$ / $x(x-1)(x-9)$], [$(1 2 3)$], [${2}$],
))

#v(2mm)
$abs(S_1) = 1$ never occurs, exactly as reciprocity demands. And computing the *full* $L_2$ ---
the two torsion classes together with one further point of $E(QQ_2)$, giving $dim L_2 = 3$ in each
case --- confirms that the obstruction is real:

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  For both pairs, $psi_* L'_2 eq.not L_2$ with $dim L_2 = dim L'_2 = 3$. So $Sigma = {2}$ is
  attained, with the non-vanishing carried --- as reciprocity requires --- by the class outside the
  torsion span.
]

= What the example actually uses <sec-cond>

Stripped to load-bearing parts, the conclusion of `kummer-example-j0.typ` needs conditions
(A)--(E) of `nondiagonal-obstruction.typ` §6, and for $j = 0$ they become the following. Write
$E_a : y^2 = x^3 + a$ throughout, and recall $E_a$ depends only on $a$ modulo $(QQ^times)^6$.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *(i) $E_a [2] tilde.equiv E_(a') [2]$ $<==>$ $a' slash a$ or $a a'$ is a cube in $QQ^times$.*

  #v(1.5mm)
  $E_a [2]$ is the sum-zero part of the permutation module on the roots of $x^3 + a$, so the module
  is determined by the cubic étale algebra $QQ[x] slash (x^3 + a)$, and two pure cubic fields agree
  exactly under that condition. The two branches are *$a' slash a$ a cube*, where $E_(a')$ is a
  quadratic twist of $E_a$, and *$a a'$ a cube*, which is the configuration of the known example,
  $9 dot (-81) = (-9)^3$.

  #v(1.5mm)
  Condition (A) also forces $ell = 2$: for CM curves $mu_6 --> "Aut"(E[ell])$ is injective for
  every odd $ell$, so no sextic-twist pair is $ell$-congruent above $2$ (§6.1 of the companion).
]

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *(ii) $q = 3$ is free $<==>$ $v_3 (a) equiv.not 0$ and $v_3 (a') equiv.not 0$ (mod $3$).*

  #v(1.5mm)
  This is the valuation lemma of §6.2.1 turned into a condition: $x^3 + a d^3$ has a root in $QQ_3$
  only if $3$ divides $v_3 (a) + 3 v_3 (d)$, and twisting moves $v_3$ by multiples of $3$ only. So
  $dim W_3 = 0$ for *every* twist, and $beta_3 equiv 0$ because a factor of the pairing vanishes.
]

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *(iii) $v = infinity$ and the good primes are free, unconditionally.* $"disc"(y^2 = x^3 + k) =
  -432 k^2 < 0$, so $E_d (RR)$ is connected and $W_infinity = 0$; and at $q divides.not 6 d$ with
  good reduction $L_q = H^1_"ur"$, which is intrinsic to the module and therefore matched by $psi$.
]

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *(iv) The place $2$: $a equiv 1$ and $a' equiv 7$ (mod $8$) reproduce the example exactly.*

  #v(1.5mm)
  A unit of $ZZ_2$ congruent to $1$ mod $8$ is a square, and cubing is bijective on $ZZ_2^times$;
  so $a equiv 1$ (mod $8$) makes $a$ a *sixth power* in $QQ_2^times$ and hence
  $E_(a d^3) tilde.equiv E_(d^3)$ over $QQ_2$. Likewise $a' equiv 7$ (mod $8$) makes $-a'$ a sixth
  power, so $E'_d tilde.equiv E_(-d)$. The local pair at $2$ is then $(E_d, E_(-d))$ for
  $y^2 = x^3 + 1$ --- *the example's pair verbatim* --- and its Theorem (§6.8) applies unchanged:
  $ beta_2 equiv.not 0 quad <==> quad v_2 (d) "is odd" . $
]

#v(2mm)
Check 1 verifies the sixth-power claims and check 2 computes $beta_2$ directly from Hilbert
symbols, reproducing §6.9 of the companion for $(9, -81)$ --- zero on $d = 1, -7, 3$ and non-zero
on $d = 2, -6, 10$ --- and finding the same signature for the new pairs. The symbol machinery is
soundness-tested in check 3 by isotropy of $L_2$: $21008$ symbols pairing points of the *same*
curve, all zero.

= The $4$-torsion mechanism behind condition (E) <sec-four>

Conditions (i)--(iv) are cheap. Condition (E) is not, and the following is why the example's
$q divides d$ rows are free at all.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Proposition.* Let $q$ be odd and let $E slash QQ_q$ have *additive* reduction and $j = 0$. Then
  $E(QQ_q)$ has no point of order $4$, and consequently
  $ L_q = ⟨ delta_q (T) : T in E[2](QQ_q) ⟩ . $

  #v(2mm)
  _Proof._ For $q$ odd the formal group $E_1 (QQ_q) tilde.equiv (ZZ_q, +)$ is uniquely
  $2$-divisible, and for additive reduction $E_0 (QQ_q) slash E_1 (QQ_q) tilde.equiv
  tilde(E)_"ns" (bb(F)_q) tilde.equiv GG_a (bb(F)_q)$ has *odd* order $q$. So multiplication by $2$
  is bijective on $E_0 (QQ_q)$, whence
  $ E(QQ_q)[2] tilde.equiv Phi_q [2] , wide E(QQ_q) slash 2 E(QQ_q) tilde.equiv
    Phi_q slash 2 Phi_q , $
  where $Phi_q$ is the component group. A point of order $4$ in $E(QQ_q)$ is exactly an element of
  order $4$ in $Phi_q$. Now $j = 0$ forces *potentially good* reduction, so the Kodaira type is one
  of $I I, I I I, I V, I_0^ast, I V^ast, I I I^ast, I I^ast$, with
  $Phi_q in {0, ZZ slash 2, ZZ slash 3, (ZZ slash 2)^2}$ --- exponent dividing $6$ in every case.
  (The one additive type with $Phi = ZZ slash 4$ is $I_n^ast$ with $n$ odd, which needs
  $v_q (j) < 0$.) So there is no element of order $4$.

  #v(1.5mm)
  Finally, for $q$ odd $dim L_q = dim E(QQ_q) slash 2 E(QQ_q) = dim E[2](QQ_q)$, and the map
  $E[2](QQ_q) --> E(QQ_q) slash 2 E(QQ_q)$ has kernel $E[2](QQ_q) inter 2 E(QQ_q)$, which is
  trivial precisely when there is no point of order $4$. So the torsion classes already span.
  $qed$
]

#v(2mm)
#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *What this buys.* $beta_q equiv 0$ is equivalent to $psi_* L'_q = L_q$, and both sides are now
  *spanned by torsion classes*. So the condition is a finite check on at most $3 times 3 = 9$
  pairs $(T, T')$ --- which is exactly what §6.6.3 of the companion computes when it speaks of
  "all nine component ratios". No sampling of local points is needed in principle.
]

= The filter it yields, and the good-reduction leak <sec-filter>

The Proposition needs *additive* reduction. At $q divides d$ with $d$ squarefree,
$v_q (a d^3) = v_q (a) + 3$, which is $equiv 0$ (mod $6$) --- good reduction, no Proposition ---
exactly when $v_q (a) equiv 3$ (mod $6$). Hence:

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *(v) No odd prime divides $a$, or $a'$, to an exponent $equiv 3$ (mod $6$).*
]

#v(2mm)
This is not decoration. The pair $(a, a') = (9, 375)$ satisfies (i)--(iv), has exactly the right
$beta_2$, and *fails* condition (E) at $q = 5$ --- and $375 = 3 dot 5^3$ has $v_5 = 3$, so
$E'_d$ acquires *good* reduction at $5$ whenever $5 divides d$ and the mechanism lapses there.
Check 5 is that pair, end to end.

= Where the naive argument fails <sec-diagnosis>

There is a tempting argument that condition (E) should be automatic once @sec-four applies: if
$E[2] tilde.equiv E'[2]$ and both $L_q$ and $L'_q$ are spanned by torsion classes, then surely
corresponding torsion points go to corresponding cohomology classes, so $psi_* L'_q = L_q$. The
argument is wrong, and it is worth seeing exactly where.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *$delta$ restricted to $E[2](QQ_q)$ is not a function of the module $E[2]$.*

  #v(1.5mm)
  For $T in E[2](QQ_q)$, $delta(T)$ is the class of $sigma |-> sigma Q - Q$ where $2 Q = T$, so
  $Q in E[4]$. That is precisely the connecting map of
  $ 0 --> E[2] --> E[4] -->^(times 2) E[2] --> 0 , $
  and therefore $delta|_(E[2](QQ_q))$ is determined by *$E[4]$ as an extension of $E[2]$ by
  $E[2]$*, i.e. by a class in $"Ext"^1_(G_q) (E[2], E[2])$. An isomorphism
  $psi : E'[2] --> E[2]$ carries no information about how $E'[4]$ sits over $E'[2]$. Demanding
  $psi_* delta'(T') = delta(psi T')$ is demanding that *$psi$ lift to an isomorphism
  $E'[4] --> E[4]$*, which is an extra hypothesis, not a consequence.
]

#v(2mm)
In the quadratic-twist branch the discrepancy can be written down. With $a' = -a$ the roots satisfy
$s_i = -r_i$ and the canonical $psi$ sends $s_i |-> r_i$; using the standard descent formula
--- $delta(T_i)$ has $product_(j eq.not i) (r_i - r_j)$ in slot $i$ and $r_i - r_j$ in slot $j$ ---

#block(fill: luma(240), inset: 9pt, radius: 3pt, width: 100%)[
  $ (psi_* delta'(T'_i)) / (delta(T_i)) = (thin 1 " in slot" i thin ; thin -1 " in the other two"
    thin) . $
  *The twisting parameter surfaces literally as the ratio.* It is trivial exactly when $-1$ is a
  square in the relevant slots, and that is the whole of condition (E) here.
]

#v(2mm)
Three regimes follow, and check 6 confirms all three:

#align(center, table(
  columns: 3, align: (center, left, left),
  stroke: 0.4pt + luma(170), inset: (x: 9pt, y: 3.5pt),
  table.header([$dim W_q$], [situation], [verdict]),
  [$0$], [no $QQ_q$-rational $2$-torsion], [nothing to compare],
  [$1$], [$q equiv 2$ (mod $3$), one root], [the companion slot is the *unramified quadratic*
    extension, in which $-1$ is a square --- *equal, always*],
  [$2$], [$q equiv 1$ (mod $3$), cubic split], [equal iff $-1 in (QQ_q^times)^2$, i.e. iff
    $q equiv 1$ (mod $4$)],
))

#v(2mm)
So the danger zone is exactly $q equiv 7$ (mod $12$) with $x^3 - a$ split in $QQ_q$, and nowhere
else. Such primes have positive density by Chebotarev, so *every* pair in this branch meets one.

= The search, corrected <sec-search>

Conditions (i)--(v) are congruences and factorisations, and over $6$th-power-free
$abs(a), abs(a') <= 250$, with non-isogeny tested on $a_q$ to $q < 300$, *$24$ pairs* survive them.
Sweeping condition (E) with the *exact* torsion-class test of @sec-diagnosis rather than with
sampled points (check 7):

#v(2mm)
#align(center, table(
  columns: 4, align: (right, center, right, center),
  stroke: 0.4pt + luma(170), inset: (x: 10pt, y: 3.5pt),
  table.header([$a$ (with $a' = -a$)], [first bad $q$], [$a$], [first bad $q$]),
  [$9$], [$67$], [$249$], [$31$],
  [$33$], [$31$], [$-39$], [$19$],
  [$81$], [$67$], [$-63$], [$31$],
  [$105$], [$139$], [$-87$], [$19$],
  [$129$], [$67$], [$-159$], [$19$],
  [$177$], [$67$], [$-207$], [$43$],
  [$57$, $153$, $225$], [$7$], [$-231$], [$43$],
))

#v(2mm)
*Zero survivors out of sixteen*, and the first bad $q$ is $equiv 7$ (mod $12$) in every single
case --- the signature of @sec-diagnosis. The quadratic-twist branch does not work, and the
candidates $(9,-9)$ and $(33,-33)$ offered by the sampled sweep are withdrawn.

= Why the known example is different <sec-why>

$(9, -81)$ is in the *other* branch, $a a'$ a cube, where the roots are $s_j = -d c slash alpha
zeta_3^j$ against $r_i = -d alpha zeta_3^i$ and the equivariant $psi$ matches $s_j |-> r_(-j)$
rather than $s_j |-> r_j$. The ratio computed in @sec-diagnosis is replaced by a different one, and
§6.6.3 of `kummer-example-j0.typ` proves that *those nine ratios are squares* --- identically, not
at a density of primes. So the example survives for a structural reason.

#block(fill: rgb("#fff4e6"), inset: 8pt, radius: 3pt, width: 100%)[
  *The contrast, in one line.* In the quadratic-twist branch the obstruction to condition (E) is
  the class of the twisting parameter, a non-square at half the primes. In the branch $a a'$ a
  cube, it is a ratio that is always a square. The $4$-torsion mechanism of @sec-four is what makes
  either statement checkable, but it does not decide between them --- that is exactly the
  information $psi$ does not carry.
]

= A criterion for the odd places, and why it backfires <sec-criterion>

@sec-diagnosis makes the requirement precise, and it can be turned into a criterion. Let
$E' = E^((delta))$ be the quadratic twist by $delta$. The twisting map $x |-> delta x$ gives
$s_i = delta r_i$ and $psi(s_i) = r_i$, so the ratio of @sec-diagnosis generalises to
$ (psi_* delta'(T'_i)) / (delta(T_i)) = (thin 1 " in slot" i thin ; thin delta " elsewhere" thin) , $
and $beta_q equiv 0$ at an odd $q$ is exactly the statement that *$delta$ is a square in the slots
away from $i$*.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Criterion.* If $QQ(sqrt(delta)) subset.eq QQ(E[2])$ then $beta_q equiv 0$ at *every* odd $q$.

  #v(2mm)
  _Proof._ Two cases. If $dim W_q = 1$ the companion slot is the quadratic subfield of the
  splitting field, namely $QQ_q (zeta_3) = QQ_q (sqrt(-3))$, and $delta$ is a square there. If
  $dim W_q = 2$ then $q$ splits completely in $QQ(E[2]) = QQ(zeta_3, a^(1 slash 3))$, so
  $zeta_3 in QQ_q$, so $sqrt(delta) in QQ_q$ and every slot is $QQ_q$. If $dim W_q = 0$ there is
  nothing to compare. $qed$
]

#v(2mm)
For $j = 0$ the field $QQ(E[2]) = QQ(zeta_3, a^(1 slash 3))$ is $S_3$ over $QQ$ with *unique*
quadratic subfield $QQ(sqrt(-3))$, so the criterion says $delta equiv -3$ modulo squares. Check 8
confirms it: for six values of $a$ the twist by $-3$ has no failure at any odd $q <= 400$, while
the twists by $-1, 3, 5, -7$ all fail, at $67$, $67$, $67$, $61$ respectively.

#block(fill: rgb("#fff4e6"), inset: 9pt, radius: 3pt, width: 100%)[
  *And that is exactly why the branch cannot produce an example.* The same criterion that empties
  $Sigma(d)$ of odd primes also empties it at $2$: for $delta = -3$, check 8 finds
  $beta_2 equiv 0$ on every square class tested as well. So the quadratic-twist branch offers a
  dichotomy and no middle:

  #v(1.5mm)
  - $delta equiv -3$: condition (E) holds at every odd $q$, *and* $beta_2 equiv 0$ --- no
    obstruction anywhere, so no conclusion;
  - $delta equiv.not -3$: $beta_2$ can be non-zero, but $beta_q eq.not 0$ at a positive density of
    odd $q$ --- condition (E) fails.

  #v(1.5mm)
  The known example escapes this because it is in the *other* branch, where $psi$ is not induced by
  a twist at all (@sec-why) and the ratios are squares for a different reason. Note also that the
  Proposition of @sec-four needs $q$ *odd*: at $2$ one has $dim L_2 = dim E[2](QQ_2) + 1$, so $L_2$
  is strictly larger than the span of its torsion and the comparison there is a genuinely different
  question --- which is precisely why an obstruction can live at $2$ and nowhere else.
]

= Status <sec-status>

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Established.* Conditions (i)--(v); the Proposition of @sec-four; the reduction of condition (E)
  to nine torsion classes and its exact evaluation; the ratio formula of @sec-diagnosis and its
  three regimes; and that *no* pair with $a' = -a$ and $abs(a) <= 250$ satisfies condition (E),
  each failing at a prime $equiv 7$ (mod $12$).

  #v(1.5mm)
  *Retracted.* The fifteen survivors reported by the sampled sweep. Sampling integral $x$ in a
  fixed range under-covers $QQ_q$ once $q$ is large, and reports $beta_q = 0$ where the exact test
  reports a difference.

  #v(1.5mm)
  *Also established.* The criterion of @sec-criterion, and the dichotomy that follows from it: the
  quadratic-twist branch can never produce an example, for a structural reason rather than by
  exhaustion.

  #v(1.5mm)
  *New.* The criterion of @sec-reframe; the exact $M_(i j)$ formula of @sec-full2, which makes
  twist-uniformity automatic and computable; the reciprocity bound $abs(S_1) eq.not 1$; and two
  full-$2$-torsion pairs with $Sigma = {2}$ and $psi_* L'_2 eq.not L_2$ on the full $L_2$
  (@sec-newsearch). Those two still owe condition (D) --- dangerous multiplicative primes, no
  longer vacuous since $j eq.not 0$ --- and a check that $L_v$ is torsion-spanned at the odd
  places of $Sigma$'s complement, i.e. no point of order $4$ there.

  #v(1.5mm)
  *Open.* Whether any pair with $a a'$ a cube other than the known example satisfies condition (E).
  That branch has a different ratio and is not covered by @sec-criterion; the exact test of
  @sec-diagnosis specialised to it is the tool, and it was not run here.
]

= What the companion script checks <sec-gp>

`j0-obstruction-family.gp`, results in `results/j0-obstruction-family.txt`.

#v(1mm)
- *(1)* The local-at-$2$ transfer of (iv): $a equiv 1$, $a' equiv 7$ (mod $8$), and both sixth-power
  claims, on seven pairs. No failures.
- *(2)* $beta_2$ from Hilbert symbols over $K = QQ(a^(1 slash 3))$, reproducing §6.9 of the
  companion for $(9,-81)$ and extending it; the quadratic-twist branch shows the all-classes
  signature.
- *(3)* Isotropy of $L_2$ on $21008$ symbols --- the soundness test for the machinery.
- *(4)* The $24$ pairs meeting (i)--(v) with $abs(a), abs(a') <= 250$, with the *sampled* sweep
  retained only to show what it reported.
- *(5)* The pair $(9, 375)$ end to end, as the demonstration that filter (v) is needed.
- *(6)* The three regimes of @sec-diagnosis, exactly: $dim W_q$, whether $-1$ is a square, and the
  verdict, on six $(a, d, q)$.
- *(7)* The corrected sweep of @sec-search by the exact torsion-class test: $0$ survivors of $16$,
  every first failure at a prime $equiv 7$ (mod $12$).
- *(9)* The search of @sec-newsearch: $684$ combinations, smallest non-empty $Sigma$ of size $1$,
  and the reciprocity bound $abs(S_1) eq.not 1$ observed throughout.
- *(8)* The criterion of @sec-criterion: the twist by $-3$ has no odd-$q$ failure up to $400$ for
  six values of $a$, where $-1, 3, 5, -7$ all fail; and $beta_2 equiv 0$ for the twist by $-3$,
  which is the dichotomy.

= References <sec-refs>

#block(inset: (left: 4pt))[
#set enum(numbering: "[1]")
+ `kummer-example-j0.typ` in this repository. The example this note generalises; §6 for the
  conditions, §6.8 for the theorem at $2$, §6.6.3 for the nine component ratios.
+ `nondiagonal-obstruction.typ` §5--§6. The criterion (A)--(E) and the reciprocity endgame.
+ `selmer-involution.typ` §11.3. The odd square classes of the theorem at $2$.
+ J. H. Silverman, *Advanced Topics in the Arithmetic of Elliptic Curves*, Springer 1994. IV §9 for
  the Kodaira types and component groups used in @sec-four.
]
