#set page(
  paper: "a4",
  margin: (x: 2.2cm, y: 2.4cm),
  numbering: "1",
)
#set text(size: 10.5pt, lang: "en")
#set par(justify: true, leading: 0.62em)
#set heading(numbering: none)

#show heading.where(level: 1): it => block(above: 1.6em, below: 0.9em)[
  #set text(size: 15pt, weight: "bold")
  #it.body
]
#show heading.where(level: 2): it => block(above: 1.25em, below: 0.7em)[
  #set text(size: 12pt, weight: "bold")
  #it.body
]
#show heading.where(level: 3): it => block(above: 1.1em, below: 0.55em)[
  #set text(size: 11pt, weight: "bold", style: "italic")
  #it.body
]

#let thm(name, body) = block(
  width: 100%,
  inset: 10pt,
  radius: 3pt,
  stroke: 0.6pt + luma(140),
  fill: luma(250),
)[
  *#name.* #body
]

#align(center)[
  #text(size: 18pt, weight: "bold")[
    Orders from a pair of elliptic fibrations
  ]

  #v(0.4em)
  #text(size: 11pt, style: "italic")[
    Local and global structure of the relations $<_1$, $<_2$, $<$
  ]

  #v(0.3em)
  #text(size: 9.5pt)[Session transcript, rewritten as a single document]
]

#v(1.2em)

#block(
  width: 100%,
  inset: 10pt,
  radius: 3pt,
  fill: luma(245),
)[
  *Setup.* Let $S$ be an algebraic surface over a metric field $K$, carrying two
  distinct elliptic fibrations $f_1, f_2 : S -> PP^1$ with zero sections
  $O_1, O_2$. For $x in S(K)$ write $F_i (x) = f_i^(-1)(f_i (x))$ for the
  $f_i$-fibre through $x$, and set
  $
    Omega_i (x) = overline({ n x : n in ZZ }) subset.eq F_i (x)(K),
  $
  the closure of the group-law multiples of $x$ inside its own $f_i$-fibre. Define
  $
    y <_i x #h(1em) <==> #h(1em) y in Omega_i (x),
  $
  and let $<$ be the transitive closure of $<_1 union <_2$ on all of $S(K)$.

  *The question.* Does the restriction of $<$ to a single fibre recover $<_1$
  (resp. $<_2$) on that fibre?
]

= Part I. The global question

*Short answer: no.* The restriction of $<$ to a single fibre is in general
_strictly larger_ than $<_1$ on that fibre. The whole point of building $<$ as a
transitive closure is that it lets you leave a fibre of one fibration, travel
along the other, and come back to a _different_ point of the original fibre than
any orbit closure of $<_1$ alone would give you.

== The bridging mechanism

Fix $P in S(K)$ and let $F_1 = F_1 (P)$, $F_2 = F_2 (P)$. These are two curves on
$S$, and as long as the two fibration classes are distinct in $op("Pic")(S)$ the
intersection number $F_1 dot.op F_2$ is typically $> 1$. (This nondegeneracy is
exactly the hypothesis under which the two-fibration method is useful at all.) So
besides $P$ itself, $F_1$ and $F_2$ typically meet in a further point
$P' != P$, with $P' in F_1 ∩ F_2$.

Now:

- Since $P' in F_2$ and — generically, e.g. whenever the multiples of $P$ are
  dense in $F_2$ — every point of $F_2$ is a limit of multiples of $P$ under the
  second group law, we get $P' <_2 P$.

- But $P'$ _also_ lies on $F_1$. So we may take multiples of $P'$ (not of $P$)
  along the *first* fibration. These are dense in $F_1$ itself — the same fibre
  that $P$ lives on. Hence $Q <_1 P'$ for any $Q in F_1$.

Chaining: $Q <_1 P' <_2 P$, so by transitive closure
$
  Q < P #h(1.2em) "for every" Q in F_1 .
$

Crucially this holds for $Q$ in the *whole fibre* $F_1$, not just the typically
much thinner orbit closure of $P$ under $<_1$ alone. There is no reason for
$Q <_1 P$ to hold directly: that would require $Q$ to be a limit of multiples of
$P$ itself, whereas what we produced is a limit of multiples of the _bridge
point_ $P'$, an a priori unrelated point of $F_1$.

== When does restriction give back $<_1$?

Only in degenerate situations:

+ $F_1 dot.op F_2 = 1$, so the two fibres through $P$ meet _only_ at $P$ and there
  is no bridge point. This cannot happen for two genuinely different elliptic
  fibrations on most surfaces of interest (e.g. K3 surfaces), where fibre classes
  have $F_1 dot.op F_2 >= 2$ generically.

+ The orbit of $P$ under $<_2$ fails to be dense in $F_2$ (e.g. $P$ torsion, or
  rank considerations blocking density), so $P'$ is unreachable.

+ If one only ever allows a single hop — but that is not what transitive closure
  does; it closes under arbitrarily long chains.

== Back to the motivation

This is exactly why one bothers with _two_ fibrations. A single elliptic
fibration only lets you chase the orbit closure of $P$ within its own fibre, and
that closure can be genuinely thin. By alternately using the second fibration as
a ferry to other fibres of the first and back, the transitive closure $<$
typically relates $P$ to points on every fibre of $F_1$ meeting the orbit of some
bridge point. This is the mechanism, going back to Bogomolov–Tschinkel-style
arguments, used to obtain strong density statements from a single starting point.

= Part II. The local question

Now define the relations only inside an open $U in.rev P$: for $P', Q' in U$, set
$Q' <_i P'$ by the same recipe but demanding everything stay in $U$. The
expectation is that for $U$ small the answer becomes _yes_, except for special
$P$. This is correct — but the reason is more deflationary than one might hope.

== The naive local argument does not suffice

One might argue: locally $F_1 (P) ∩ F_2 (P) = {P}$, since the other
$F_1 dot.op F_2 - 1$ intersection points lie outside $U$; hence no bridge point,
hence no new relations.

That is not enough. The chain need not return to $F_1 (P)$ through a second point
of $F_1 (P) ∩ F_2 (P)$. It can hop through _neighbouring_ fibres, entirely inside
$U$:
$
  P limits(-->)^(<_2) P_1 limits(-->)^(<_1) P_2 limits(-->)^(<_2) Q,
$
where $P_1 in F_2 (P) ∩ U$ is close to but distinct from $P$, so that
$F_1 (P_1)$ is a different nearby fibre of the first fibration;
$P_2 in F_1 (P_1) ∩ U$; and finally $F_2 (P_2)$ crosses $F_1 (P)$ at a point $Q$
near $P$. Nothing leaves $U$. So the local question is genuinely open on these
grounds.

== The real reason: local orbit closures are fat

Take $K in { RR, CC, QQ_p }$ (or $QQ$ with the induced metric — closures are taken
in the ambient metric space, so it comes to the same thing). Let $E = F_1 (P)$ and
let $P$ be non-torsion in $E$.

- $K = QQ_p$: $E(QQ_p) tilde.equiv Delta times ZZ_p$ with $Delta$ finite. Writing
  $P = (delta, x)$ with $x != 0$ and $m = abs(Delta)$, the closure of $ZZ P$
  contains ${0} times m x ZZ_p$, which is *open*. So $overline(ZZ P)$ is an open
  subgroup containing a ball around $P$ of radius $≍ abs(m x)$.

- $K = RR$: $overline(ZZ P)$ is the identity component of $E(RR)$ — again open,
  since $E(RR)$ is one-dimensional.

- $K = CC$: for $P$ outside a thin set, $ZZ P$ is dense in the whole torus
  $E(CC)$.

Now shrink $U$. Since $abs(x)$ is locally constant (as $x != 0$), every $P' in U$
on a nearby $f_1$-fibre obeys the same radius bound, uniformly. Choosing
$op("diam")(U)$ below that uniform radius gives
$
  Q' <_1 P' #h(1em) "for all" P', Q' in U "on a common" f_1"-fibre",
$
and symmetrically. In other words, *$<_1$ restricted to $U$ collapses to the
equivalence relation "lies on the same $f_1$-fibre"*, and likewise for $<_2$.
This holds under either reading of the definition — whether or not the witnessing
multiples are required to stay in $U$ — because density of ${n P'}$ in the open
subgroup $overline(ZZ P')$ forces the multiples _inside_ $U$ to be dense in
$U ∩ "fibre"$.

Consequently $<$ on $U$ relates everything to everything: two moves suffice, via
$(u_0, v_0) -> (u_1, v_0) -> (u_1, v_1)$ in local product coordinates
$(f_1, f_2)$. Its restriction to $F_1 (P) ∩ U$ is therefore all of
$F_1 (P) ∩ U$ — which is exactly what $<_1$ already gives. So the answer is yes,
but because both sides have become the total relation. A symptom: locally these
"partial orders" are symmetric, so they are not partial orders at all.

== The special points, and what goes wrong there

+ *$P$ torsion in one of its two fibres* (including $P$ on a zero section). Here
  the answer is genuinely *no*. If $P$ has finite order $n$ in $F_1 (P)$ then
  $overline(ZZ P)$ is finite, so shrinking $U$ leaves nothing below $P$ in $<_1$.
  But if $P$ is non-torsion in $F_2 (P)$, the four-step chain above still works:
  reach $P_1 in F_2 (P) ∩ U$, whose $f_1$-fibre is a _different_ elliptic curve in
  which $P_1$ is non-torsion, and come back. One gets $Q < P$ for essentially all
  $Q in F_1 (P) ∩ U$ with $Q lt.not_1 P$.

+ *$P$ on a singular fibre or at a critical point*, or where the fibrations are
  tangent, so $(f_1, f_2)$ is not a local isomorphism and the product picture
  fails. Related: on the smooth locus of a multiplicative fibre the group is
  $GG_m$-like, and $overline(u^ZZ)$ is open only when $v(u) = 0$; otherwise the
  orbit is discrete and thin.

+ *Over $CC$, points whose orbit closure is a subcircle* rather than the full
  torus — a $QQ$-linear-relation condition on the lattice coordinate.

== A structural caveat

The collapse really depends on $overline(ZZ P)$ being _open_ in the fibre, and
that uses $[K : QQ_p] = 1$ (or $dim_RR = 1$). For $K slash QQ_p$ finite of degree
$d >= 2$ we have $E(K) tilde.equiv Delta times ZZ_p^d$, and
$overline(ZZ P) supset.eq ZZ_p dot.op x$ is only a $ZZ_p$-line in $ZZ_p^d$: thin,
with empty interior. Then $<_1$ restricted to $U$ stays genuinely nontrivial, the
collapse argument fails, and chained moves should reach $ZZ_p$-directions outside
the single line $ZZ_p ell_1 (P)$ — so the answer becomes *no* again. For
applications over $QQ$ this does not bite, but it shows the "yes" is not formal.

= Part III. Theorems

From here on: $K = QQ_p$ with $p >= 3$ (the prime $2$ needs the usual formal-group
care), $S slash QQ_p$ smooth projective, $f_1, f_2$ as above.

== The local invariant that controls everything

The single fact driving all of this is:

#block(inset: (left: 1.2em))[
  For $E slash QQ_p$ and $x in E(QQ_p)$ non-torsion,
  $E(QQ_p) tilde.equiv Delta times ZZ_p$ with $Delta$ finite, and $Omega(x)$ is an
  *open* subgroup containing a ball around $x$ of radius $≍ abs(ell(x))_p$, where
  $ell$ is the $ZZ_p$-coordinate, i.e. $log$ in the formal group.
]

So $Omega_1 (x)$ is "a ball of radius $abs(ell_1 (x))$". The relation $<_1$ is
therefore nontrivial near $P_0$ exactly when $ell_1$ degenerates at $P_0$ — that
is, exactly when $P_0$ is _torsion_ in its own $f_1$-fibre. Near a $P_0$
non-torsion on both fibrations, $abs(ell_1)$ and $abs(ell_2)$ are locally constant
and nonzero, both orbit closures swallow $U$, and everything collapses. That was
Part II.

Concretely: if $P_0$ is $n$-torsion in $F_1 (P_0)$, put $z_1 (x) := ell_1 (n
dot.op x)$, a function on a neighbourhood of $P_0$ vanishing at $P_0$ and cutting
out locally the torsion multisection through $P_0$. Define $z_2$ symmetrically.
Then
$
  Omega_1 (x) ≍ { y in F_1 (x) : abs(z_1 (y)) <= abs(z_1 (x)) },
$
up to bounded index. *The orbit closure can only make $abs(z_1)$ smaller.* So the
whole question becomes: can chaining through $f_2$ make $abs(z_1)$ bigger?

== Theorem A

#thm("Theorem A")[
  *Hypotheses on $P_0$.*

  + $F_1 (P_0)$ and $F_2 (P_0)$ are both smooth fibres, and they meet
    transversally at $P_0$ — equivalently $(f_1, f_2)$ is étale at $P_0$;
  + $P_0$ is *torsion* in $F_1 (P_0)(QQ_p)$, e.g. $P_0 in O_1$;
  + $P_0$ is *non-torsion* in $F_2 (P_0)(QQ_p)$;
  + $F_2 (P_0)$ is not contained in the $f_1$-torsion multisection through $P_0$
    (automatic once $F_1 dot.op F_2 >= 2$).

  *Conclusion.* For every neighbourhood $U in.rev P_0$ there are a neighbourhood
  $V subset.eq U$ and a constant $rho = rho(U) > 0$ such that for every $P in V$
  non-torsion in $F_1 (P)$, and every $k >= 1$ with
  $p^k abs(z_1 (P)) <= rho$:

  - every $Q in F_1 (P)(QQ_p)$ with $p^k Q = P$ satisfies $Q < P$, witnessed by a
    chain of length $3$ whose every intermediate point and every witnessing
    multiple lies in $U$;
  - yet $Q lt.not_1 P$ and $Q lt.not_2 P$.
]

Since $abs(z_1 (P)) -> 0$ as $P -> P_0$ while $rho$ is fixed, the range of
admissible $k$ grows without bound as $P$ approaches $P_0$. In fact the conclusion
is stronger: $<$ restricted to $F_1 (P) ∩ U$ is essentially all of
$F_1 (P) ∩ U$, while $<_1$ is only the tiny ball $Omega_1 (P)$.

=== Why the negative clauses hold

$abs(z_1 (Q)) = p^k abs(z_1 (P)) > abs(z_1 (P))$, so $Q in.not Omega_1 (P)$ —
indeed a whole neighbourhood of $Q$ misses $Omega_1 (P)$, which is the
parenthetical point about no multiple of $P$ lying close to $Q$. And
$Q in.not F_2 (P)$ at all: transversality gives
$F_1 (P) ∩ F_2 (P) ∩ U = {P}$ and $Q != P$.

=== Why $Q$ exists

In the formal group $hat(F_1 (P))(p ZZ_p) tilde.equiv ZZ_p$, torsion-free for
$p >= 3$ with good reduction, $P$ is $p^k$-divisible as soon as
$abs(z_1 (P)) <= p^(-(k+1))$ — automatic for $P$ close to $P_0$ — and then $Q$ is
unique.

=== The chain

Use $(t_1, t_2) = (f_1, f_2)$ as étale coordinates on $U$. Because $P_0$ is
non-torsion on $f_2$, $abs(ell_2)$ is bounded below uniformly near $P_0$, so for
$U$ small enough $Omega_2 (x) supset.eq F_2 (x) ∩ U$ for _every_ $x in U$: thus
$<_2$ has already collapsed to "same $f_2$-fibre", while $<_1$ has not. Then
$
  P limits(-->)^(<_2) P_1 limits(-->)^(<_1) P_2 limits(-->)^(<_2) Q .
$
Choose $P_1 in F_2 (P) ∩ U$ with $abs(z_1 (P_1)) ≍ rho$ — possible by
hypothesis (4), since $z_1$ is non-constant on $F_2 (P)$. Now $Omega_1 (P_1)$ is a
ball of radius $≍ rho$ in the _neighbouring_ fibre $F_1 (P_1)$, so $P_2$ ranges
over a set on which $t_2$ takes a full ball of values. Finally $F_2 (P_2)$ meets
$F_1 (P)$ in exactly one point of $U$, and as $t_2 (P_2)$ sweeps its ball this
point sweeps a ball of radius $≍ rho$ in $F_1 (P)$, which contains $Q$.

One bookkeeping point: $<$ is defined via closures, so the chain literally proves
$Q < P$. To get an honest _sequence of iterated multiples_ landing near $Q$,
approximate at each of the three stages and use continuity of the group laws.
Standard, but worth saying, since that was the original motivation.

== Theorem B: the sharp dichotomy, and the cross-ratio

Theorem A is generous because it lets $P_0$ be non-torsion on $f_2$, which makes
$<_2$ collapse outright. The delicate and more interesting case is $P_0$ *torsion
on both*, e.g. $P_0 in O_1 ∩ O_2$. Here $(z_1, z_2)$ is an étale coordinate system
on $U$ and neither relation collapses.

Normalise $t_1 = z_2 + alpha z_1 + dots.c$ and $t_2 = z_1 + gamma z_2 + dots.c$.
Neither $alpha$ nor $gamma$ is an invariant — the $z_i$ carry scaling freedom —
but two things are:

- $lambda := alpha gamma$ is the *cross-ratio*
  $(T O_2, T O_1 ; T F_1, T F_2)$ of the four tangent directions at $P_0$.
  Transversality of the fibrations is $lambda != 1$; and $lambda = 0$ means one
  fibre is tangent to the other's zero section.

- the ratio $abs(gamma z_2 (P)) slash abs(z_1 (P))$ is invariant. Coordinate-free:
  it compares $abs(z_1 (P))$ with $sup { abs(z_1 (y)) : y in Omega_2 (P) }$, i.e.
  *how far a single $f_2$-hop can push $abs(z_1)$*.

#thm("Theorem B")[
  Suppose $abs(lambda)_p <= 1$. Set
  $A(x) := max(abs(z_1 (x)), abs(gamma z_2 (x)))$. Then $A$ is non-increasing
  along every $<_1$- and $<_2$-move, and
  $
    { y in F_1 (P) : y < P "inside" U } = { y in F_1 (P) : abs(z_1 (y)) <= A(P) },
  $
  the upper bound being attained by an explicit $3$-step chain. Consequently:

  - if $abs(gamma z_2 (P)) <= abs(z_1 (P))$, then $<$ restricted to $F_1 (P)$
    *is* $<_1$ — the expected "yes";
  - if $abs(gamma z_2 (P)) >= p^k abs(z_1 (P))$, then all $p^k$-division points of
    $P$ in $F_1 (P)$ are $< P$ — "no".
]

So the exceptional $P$ are exactly those lying *much closer to the zero section
$O_1$ than to $O_2$*, and the threshold is calibrated by the cross-ratio.

The computation behind the equality is pleasantly clean. With $P = (a, b)$,
hopping $P ->_2 P_1 ->_1 P_2 ->_2 Q$ and imposing $Q in F_1 (P)$ forces
$
  z_1 (Q) = a_2 - gamma b, #h(1.5em) abs(a_2) <= abs(a + gamma b),
$
so $z_1 (Q)$ sweeps the full ball of radius
$max(abs(a), abs(gamma b)) = A(P)$. Note what this says structurally: when
$abs(lambda) <= 1$, one $f_2$-hop already determines the entire reachable set, and
longer chains buy nothing.

#thm("Theorem B$'$")[
  If instead $abs(lambda)_p > 1$ — a non-integral cross-ratio — then $A$ is not
  monotone, and iterating the round trip multiplies the scale by $abs(lambda)$
  each time. Then _every_ $P$ near $P_0$ with $z_1 (P) != 0$ admits arbitrarily
  large $k$, bounded only by the size of $U$, and the size hypothesis in
  Theorem B disappears.
]

== The resulting dictionary

#table(
  columns: (0.9fr, 1.35fr),
  inset: 9pt,
  align: left + top,
  stroke: 0.5pt + luma(180),
  table.header(
    [*Geometry at $P_0$*],
    [*Local behaviour of the orders*],
  ),

  [$P_0$ non-torsion on both, smooth fibres],
  [$<_1, <_2$ each collapse to "same fibre"; $<$ is total on $U$; restriction
   gives back $<_1$ trivially — and all three relations become _symmetric_, so
   they are not partial orders locally at all],

  [$P_0$ torsion on $f_1$, non-torsion on $f_2$],
  [$<_1$ nontrivial, $<_2$ collapsed; restriction of $<$ strictly exceeds $<_1$
   (Theorem A)],

  [$P_0$ torsion on both],
  [both nontrivial; sharp threshold governed by the cross-ratio $lambda$ and the
   position of $P$ relative to the two torsion loci (Theorems B, B$'$)],

  [$(f_1, f_2)$ ramified at $P_0$, or a singular fibre],
  [coordinates degenerate; on a multiplicative fibre $Omega$ is open only in the
   unit part, on an additive fibre $Omega(x) = ZZ_p x$ — Kodaira type enters
   directly],
)

Two structural remarks. First, the _torsion multisections_ of the two fibrations
are precisely the locus where the local order structure is nontrivial: the order
"detects" them, which is a rather pretty way for an order-theoretic gadget to see
the Mordell–Weil geometry. Second, the openness of $Omega(x)$ that drives the
collapses is special to $[K : QQ_p] = 1$. Over a degree-$d$ extension,
$E(K) tilde.equiv Delta times ZZ_p^d$ and $Omega(x)$ is a $ZZ_p$-line with empty
interior, so nothing collapses, and the local theory becomes a genuinely
$d$-dimensional question about which $ZZ_p$-directions chained moves can reach.
That looks like the most interesting direction to push, if the orders are to
carry more information than the $QQ_p$ case allows.
