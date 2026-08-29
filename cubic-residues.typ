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
  #text(size: 16pt, weight: "bold")[When is $3$ a cube mod $p$?]
  #v(2mm)
  #text(size: 10pt)[A criterion that cannot be a congruence, why the answer is a quadratic
  form, and what happens for $ell$-th powers in general]
  #v(1mm)
  #text(size: 9pt, style: "italic")[checks in `cubic-residues.gp`; the condition
  `kummer-example-j0.typ` §6.6.2 runs on]
]

#v(4mm)

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *The answer.* For $p = 3$ and for $p equiv 2$ (mod $3$): *always* --- cubing is a bijection on
  $bb(F)_p^times$ when $gcd(3, p-1) = 1$. For $p equiv 1$ (mod $3$), write
  $ 4p = L^2 + 27 M^2 , $
  which is possible and, once normalised by $L equiv 1$ (mod $3$) and $M > 0$, *uniquely* so. Then
  $ 3 " is a cube mod " p quad <==> quad 3 divides M . $
  Equivalently: $p$ is represented by $x^2 + x y + 61 y^2$.

  #v(2mm)
  No congruence on $p$ can decide this, because $QQ(zeta_3, root(3,3))$ is $S_3$ over $QQ$ and
  therefore non-abelian (@sec-nocong). The set of such $p$ has density $1 slash 6$ among all
  primes, so there are infinitely many --- though infinitude alone is far cheaper than the density
  (@sec-density).
]

= The trivial half <sec-easy>

If $p = 3$ then $3 equiv 0 = 0^3$. If $p equiv 2$ (mod $3$) then $gcd(3, p-1) = 1$, so
$x |-> x^3$ is a bijection of $bb(F)_p^times$ and *everything* is a cube. Only $p equiv 1$
(mod $3$) is a question at all, and then $mu_3 subset bb(F)_p$, so $x^3 = 3$ has either three
solutions or none.

= Why the answer cannot be a congruence <sec-nocong>

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  For $p eq.not 3$, "$3$ is a cube mod $p$ and $p equiv 1$ (mod $3$)" says exactly that $x^3 - 3$
  splits into linear factors mod $p$ *and* $zeta_3 in bb(F)_p$ --- that is, that $p$ splits
  completely in
  $ L = QQ(zeta_3, root(3,3)) , quad "Gal"(L slash QQ) tilde.equiv S_3 . $
]

A set of primes is defined by congruence conditions if and only if it is the set of primes
splitting completely in an *abelian* extension --- that is the content of class field theory. $S_3$
is not abelian, so no modulus works. The witnesses are small and worth having (@sec-gp, check 4):

#align(center, table(
  columns: 3, align: (center, left, left),
  stroke: 0.4pt + luma(170), inset: (x: 8pt, y: 3.5pt),
  table.header([modulus], [a colliding pair], [verdicts]),
  [$9$, and $27$], [$7$ and $61$, both $equiv 7$], [$3$ is a cube mod $61$, not mod $7$],
  [$81$], [$31$ and $193$, both $equiv 31$], [a cube mod $193$, not mod $31$],
  [$243$], [$13$ and $499$, both $equiv 13$], [a cube mod $499$, not mod $13$],
  [$729$], [$139$ and $1597$, both $equiv 139$], [a cube mod $1597$, not mod $139$],
))

#v(2mm)
The pair $7, 61$ is the one to remember, for a reason that becomes visible in @sec-crit.

= The criterion <sec-crit>

For $p equiv 1$ (mod $3$) the representation
$ 4p = L^2 + 27 M^2 , quad L equiv 1 space (mod 3), quad M > 0 $
exists and is unique --- it is $p = pi overline(pi)$ in $ZZ[omega]$ written out, and it is checked
for all $4784$ such primes below $10^5$ in @sec-gp. The criterion is:

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  $ 3 " is a cube mod " p quad <==> quad 3 divides M . $
]

#align(center, table(
  columns: 8, align: (center,)*8,
  stroke: 0.4pt + luma(170), inset: (x: 7pt, y: 3.5pt),
  table.header([$p$], [$7$], [$13$], [$31$], [$61$], [$67$], [$73$], [$103$]),
  [$(L, M)$], [$(1,1)$], [$(-5,1)$], [$(4,2)$], [$(1,3)$], [$(-5,3)$], [$(7,3)$], [$(13,3)$],
  [$3$ a cube?], [no], [no], [no], [*yes*], [*yes*], [*yes*], [*yes*],
))

#v(2mm)
Now look again at $7$ and $61$: they have *the same $L$*, and are congruent mod $27$. Only $M$
separates them --- $(1,1)$ against $(1,3)$ --- which is precisely the information a congruence on
$p$ discards.

The same $L$ and $M$ answer the neighbouring questions, and it is worth seeing $3$ as one case of a
pattern rather than an isolated trick (@sec-gp, check 2, all with no mismatch over the $2556$
primes below $50000$):

#align(center, table(
  columns: 2, align: (center, left),
  stroke: 0.4pt + luma(170), inset: (x: 9pt, y: 3.5pt),
  table.header([$q$], [$q$ is a cube mod $p$ iff]),
  [$2$], [$2 divides M$ --- equivalently $p = a^2 + 27 b^2$ (Gauss)],
  [$3$], [$3 divides M$],
  [$5$], [$5 divides L M$],
  [$7$], [$7 divides L M$],
))

= The quadratic form, and one trap <sec-form>

Since $3 divides M$ turns $4p = L^2 + 27M^2$ into $4p = L^2 + 243 M'^2$, and
$4(x^2 + x y + 61 y^2) = (2x+y)^2 + 243 y^2$, the criterion is a representation statement:

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  $ 3 " is a cube mod " p quad <==> quad p = x^2 + x y + 61 y^2 , $
  the *principal form of discriminant $-243$*. Verified with no mismatch on all $2556$ primes
  $p equiv 1$ (mod $3$) below $50000$.
]

That this is the right shape of answer is the theory of $x^2 + n y^2$ (Cox). $L = QQ(zeta_3,
root(3,3))$ is abelian --- cyclic of degree $3$ --- over $K = QQ(sqrt(-3))$, and it is the *ring
class field* of the order of conductor $9$ in $K$, whose discriminant is $9^2 dot (-3) = -243$ and
whose form class number is $h(-243) = 3$ (the forms being $x^2 + x y + 61 y^2$ and
$7 x^2 plus.minus 3 x y + 9 y^2$). The general theorem --- $p$ is represented by the principal form
of the order iff $p$ splits completely in its ring class field --- is exactly the criterion above.

#block(fill: rgb("#fff4e6"), inset: 8pt, radius: 3pt, width: 100%)[
  *The trap.* Gauss's criterion for $2$ is often quoted in the pretty form $p = a^2 + 27 b^2$, so
  one expects $p = x^2 + 243 y^2$ for $3$. That is *sufficient but not necessary*: of the $833$
  primes below $50000$ with $3$ a cube, only $271$ have that shape, and there are no
  counterexamples in the other direction. The reason is that $x^2 + 243 y^2$ has discriminant
  $-972$, the order of conductor $18$, with $h(-972) = 9$ --- a strictly finer invariant than the
  one the question is about. The correct analogue of $x^2 + 27 y^2$ is $x^2 + x y + 61 y^2$, not
  $x^2 + 243 y^2$.
]

= Infinitely many, and how many <sec-density>

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Density.* The primes in question are those splitting completely in $L$, of degree $6$, so by
  Chebotarev they have natural density $1 slash 6$ among all primes --- equivalently $1 slash 3$
  among the primes $equiv 1$ (mod $3$). In particular there are infinitely many.
]

#align(center, table(
  columns: 6, align: (left, center, center, center, center, center),
  stroke: 0.4pt + luma(170), inset: (x: 8pt, y: 3.5pt),
  table.header([$x$], [$10^3$], [$10^4$], [$10^5$], [$10^6$], [$10^7$]),
  [$"count" slash pi(x)$], [$0.1566$], [$0.1557$], [$0.1650$], [$0.1662$], [$0.16656$]),
)

#v(2mm)
against $1 slash 6 = 0.16667$.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *Infinitude is much cheaper than the density, and worth separating.* For *any* number field $L$,
  infinitely many primes split completely, by a Euclid-style argument with no analysis in it.
  Write $L = QQ(theta)$ with $theta$ an algebraic integer of minimal polynomial $f in ZZ[x]$. The
  set of primes dividing some value $f(m)$, $m in ZZ$, is infinite --- if $p_1, dots, p_k$ were all
  of them, evaluate $f$ at a suitable multiple of $f(0) p_1 dots.c p_k$ and extract a new prime
  factor. For $p divides.not "disc" f$ dividing some $f(m)$, $f$ acquires a root mod $p$, so $p$
  has a prime above it of residue degree $1$; and *because $L slash QQ$ is Galois all residue
  degrees agree*, forcing them all to be $1$. So $p$ splits completely.

  #v(2mm)
  $L = QQ(zeta_3, root(3,3))$ is Galois, so this applies directly. Only the *density* $1 slash 6$
  needs Chebotarev.
]

Two neighbouring statements are genuinely harder. Infinitude of the primes represented by
$x^2 + x y + 61 y^2$ --- the same set, phrased by @sec-form --- is the classical theorem on primes
represented by a binary quadratic form, and does need $L$-functions of ring class characters; the
density it gives is $1 slash (2h) = 1 slash 6$, the principal form being ambiguous, which agrees.
And good error terms are open: unconditionally one has only effective Chebotarev of
Lagarias--Odlyzko type, with its possible Siegel zero, while GRH gives
$pi_L (x) = 1/6 "Li"(x) + O(sqrt(x) log x)$.

= General $ell$-th power residues <sec-general>

Everything above is the case $ell = 3$ of one mechanism, and it is worth seeing the mechanism,
because the *shape* of the answer changes with $ell$ in a way that is easy to mispredict.

== The criterion, for any $ell$ <sec-gen-crit>

Let $ell$ be an odd prime, $K = QQ(zeta_ell)$, $lambda = 1 - zeta_ell$, and $p equiv 1$ (mod
$ell$). Assume $K$ has class number $1$ (true for $ell <= 19$), so each of the $ell - 1$ primes
above $p$ has a generator $pi$. Normalise $pi$ to be *primary*: $pi equiv a$ (mod $lambda^2$) for
some rational integer $a$. Exactly one of the $ell$ associates $zeta^j pi$ is.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Eisenstein reciprocity.* For a rational integer $a$ coprime to $ell$ and $pi$ primary and
  coprime to $a$,
  $ (a slash pi)_ell = (pi slash a)_ell . $
]

The left side is what we want: $(q slash pi)_ell = 1$ says exactly that $q$ is an $ell$-th power
mod $p$. The right side is computable, because it lives in the residue fields *of $q$*, which are
small. Writing $f = "ord"_ell (q)$, the prime $q$ is unramified in $K$ with residue field
$bb(F)_(q^f)$ at each of the $(ell-1) slash f$ primes above it, and

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  $q$ is an $ell$-th power mod $p$ if and only if
  $ product_(Q divides q) ( pi mod Q )^((q^f - 1) slash ell) = 1 . $
]

So the question becomes a *congruence on $pi$ modulo $q$* --- never a congruence on $p$, which
@sec-nocong rules out for good. When $q$ is inert ($f = ell - 1$) there is a single factor and it
reads: *$pi$ mod $q$ is an $ell$-th power in $bb(F)_(q^(ell-1))^times$*.

Verified with no mismatch (@sec-gp, check 6):

#align(center, table(
  columns: 5, align: (center, center, center, left, center),
  stroke: 0.4pt + luma(170), inset: (x: 8pt, y: 3.5pt),
  table.header([$ell$], [$q$], [$f = "ord"_ell q$], [the test], [primes, mismatches]),
  [$3$], [$2$], [$2$], [$pi equiv 1$ (mod $2$), in $bb(F)_4$], [$1124$, none],
  [$3$], [$5$], [$2$], [$pi^8 equiv 1$ (mod $5$), in $bb(F)_(25)$], [$1124$, none],
  [$5$], [$2$], [$4$], [$pi^3 equiv 1$ (mod $2$), in $bb(F)_(16)$], [$563$, none],
  [$5$], [$3$], [$4$], [$pi^(16) equiv 1$ (mod $3$), in $bb(F)_(81)$], [$563$, none],
  [$5$], [$7$], [$4$], [$pi^(480) equiv 1$ (mod $7$), in $bb(F)_(2401)$], [$563$, none],
  [$7$], [$2$], [$3$], [a *product* over the two primes above $2$], [$126$, none],
  [$7$], [$3$], [$6$], [$pi^(104) equiv 1$ (mod $3$), in $bb(F)_(729)$], [$126$, none],
))

#v(2mm)
The row $ell = 3$, $q = 2$ is Gauss's criterion in disguise: $pi equiv 1$ (mod $2$) in $ZZ[omega]$
is $p = a^2 + 27 b^2$. And the row $ell = 7$, $q = 2$ is the one that shows the general shape ---
$2$ splits into two primes there, and the symbol is a genuine product, not a single power.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *Why it is well defined.* $pi$ is pinned only up to units, and several associates can be primary
  at once: for $ell = 5$ both $pi$ and $(1+zeta)zeta^2 pi$ are, since $(1+zeta)zeta^2$ is a primary
  unit. What saves the criterion is that *every primary unit has trivial symbol* --- checked over
  $56$ units for $ell = 3, 5$ with no violation (@sec-gp, check 7) --- so the answer depends only on
  the ideal $(pi)$. Note $zeta$ itself is *not* primary, and does not have trivial symbol; that is
  precisely what the normalisation is for.
]

== Why $ell = 3$ gets a quadratic form and $ell = 5$ does not <sec-gen-shape>

The pretty part of @sec-crit --- a criterion in terms of a *binary quadratic form* --- does not
generalise, and the reason is a coincidence of small numbers.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  $QQ(zeta_3)$ is *imaginary quadratic*. That is what puts $QQ(zeta_3, root(3,3))$ inside the
  theory of ring class fields of imaginary quadratic orders, where Cox's theorem converts "splits
  completely" into "represented by a binary quadratic form" (@sec-form). For $ell >= 5$,
  $QQ(zeta_ell)$ has degree $ell - 1 >= 4$; there is no imaginary quadratic field underneath, and
  no binary form.
]

For $ell = 5$ the structural facts are otherwise the same as at $ell = 3$: $x^5 - 3$ has splitting
field of degree $20$ with Galois group the Frobenius group $F_(20)$ --- non-abelian, so still no
congruence --- and the density of $\{p : 3$ is a fifth power$\}$ is $1 slash 20$ among all primes,
observed as $0.04993$ below $10^6$ (@sec-gp, check 8).

What replaces the binary form classically is a *quaternary* system, due to Dickson:
$ 16 p = x^2 + 50 u^2 + 50 v^2 + 125 w^2 , quad x w = v^2 - 4 u v - u^2 , quad x equiv 1 space
  (mod 5) . $

#block(fill: rgb("#fff4e6"), inset: 8pt, radius: 3pt, width: 100%)[
  *Reported honestly:* as written above, that system does *not* determine the representation.
  Of $58$ primes tested, $55$ admit essentially different $(u,v,w)$ --- $p = 11$ has both
  $(1,-1,0,-1)$ and $(1,0,1,1)$ --- so more normalisation is needed than the side condition
  supplies. And no simple divisibility condition on $(x,u,v,w)$ reproduces the quintic character:
  the best of the ones tried, $3 divides w$, fails $5$ times in $58$ (@sec-gp, check 9). The
  classical quintic residuacity criteria of Dickson and E. Lehmer are stated in these terms but
  are markedly more involved than $3 divides M$; nothing of that kind is claimed here.
]

== What the pattern actually is <sec-gen-pattern>

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  For $q$ *unramified* in $QQ(zeta_ell)$ --- which is every $q eq.not ell$ --- Eisenstein
  reciprocity turns "$q$ is an $ell$-th power mod $p$" into a congruence on $pi$ modulo $q$, in a
  residue field of size $q^f$. That is the general answer, and it is uniform in $ell$.

  #v(2mm)
  What made $ell = 3$, $q = 3$ special --- and produced the memorable $3 divides M$ --- is that
  there $q = ell$ is *ramified*: $3 = -omega^2 (1 - omega)^2$, Eisenstein does not apply, and one
  falls back on the supplementary law for $lambda = 1 - omega$. That is where the shape $4p = L^2 +
  27 M^2$ comes from. The memorable criterion is the exceptional case, not the typical one.
]

= Where this is used in the repository <sec-uses>

`kummer-example-j0.typ` §6.6.2 proves that for $q eq.not 3$ and every twist $d$,
$ dim_(bb(F)_2) E_d [2](QQ_q) = dim_(bb(F)_2) E'_d [2](QQ_q) = cases(
  1 & "if" q equiv 2 space (mod 3),
  2 & "if" q equiv 1 space (mod 3) "and" 3 "is a cube mod" q,
  0 & "otherwise",
) $
--- the $2$-torsion of $y^2 = x^3 + 9d^3$ needing a root of $x^3 = -9$, and $chi(-9) = chi(3)^2$.
So the criterion of @sec-crit turns that trichotomy into something decidable by a quadratic form,
and @sec-density says the middle case occurs for a positive proportion of $q$ --- a third of the
$q equiv 1$ (mod $3$). The same condition governs `kummer-example-j0.typ` §6.5, where the
hypothesis "$-9 in (QQ_q^times)^6$" is "$q equiv 1$ (mod $4$) and $-9$ a cube mod $q$".

= What the companion script checks <sec-gp>

`cubic-residues.gp`, results in `results/cubic-residues.txt`.

#v(1mm)
- *(1)* $4p = L^2 + 27M^2$ has exactly one solution with $M > 0$, for all $4784$ primes
  $p equiv 1$ (mod $3$) below $10^5$: never none, never two.
- *(2)* The four criteria of @sec-crit, on the $2556$ such primes below $50000$: no mismatch for
  any of $2, 3, 5, 7$.
- *(3)* $p = x^2 + x y + 61 y^2 <==> 3$ is a cube: no mismatch. And $p = x^2 + 243 y^2$ implies it
  with no counterexample but catches only $271$ of the $833$ --- @sec-form's trap. Class numbers
  $h(-243) = 3$, $h(-972) = 9$, $h(-108) = 3$.
- *(4)* Colliding pairs at moduli $9, 27, 81, 243, 729$: the table of @sec-nocong.
- *(5)* The density, to $10^7$.
- *(6)* The general criterion of @sec-gen-crit for $ell = 3, 5, 7$ and seven pairs $(ell, q)$,
  including the split case $ell = 7$, $q = 2$: no mismatch anywhere.
- *(7)* Every primary unit has trivial symbol, over $56$ units for $ell = 3, 5$ --- the
  well-definedness of @sec-gen-crit.
- *(8)* $x^5 - 3$ has splitting field of degree $20$ with group $F_(20)$, non-abelian; density
  $0.04993$ below $10^6$ against $1 slash 20$.
- *(9)* Dickson's quaternary system: its non-uniqueness, and the failure of five candidate
  divisibility rules.

= References <sec-refs>

#block(inset: (left: 4pt))[
#set enum(numbering: "[1]")
+ D. A. Cox, *Primes of the Form $x^2 + n y^2$*, 2nd ed., Wiley 2013. *The reference for this
  note*: §4 for the cubic case and Gauss's $p = a^2 + 27b^2$, §9 for ring class fields and the
  general theorem used in @sec-form.
+ K. Ireland, M. Rosen, *A Classical Introduction to Modern Number Theory*, 2nd ed., GTM 84, Ch. 9.
  Cubic reciprocity in $ZZ[omega]$, the supplementary laws, and the $4p = L^2 + 27M^2$
  normalisation --- where the criteria of @sec-crit come from.
+ F. Lemmermeyer, *Reciprocity Laws: from Euler to Eisenstein*, Springer 2000, Ch. 7. The cubic
  residue character in its historical setting, with the $2, 3, 5, 7$ supplements tabulated.
+ J. Neukirch, *Algebraic Number Theory*, Ch. VII §13 for Chebotarev, and Ch. VI for the
  characterisation of congruence-defined sets of primes as those coming from abelian extensions ---
  the theorem behind @sec-nocong.
+ K. Ireland, M. Rosen, op. cit., Ch. 14. *Eisenstein reciprocity* --- the statement used in
  @sec-gen-crit, with the definition of primary and the $ell$-th power residue symbol. Ch. 11 and
  12 for the residue symbol in general.
+ L. E. Dickson, *Cyclotomy, higher congruences, and Waring's problem*, Amer. J. Math. *57*
  (1935), 391--424; and E. Lehmer, *Criteria for cubic and quintic residuacity*, Mathematika *5*
  (1958), 20--29. The quintic criteria in terms of the quaternary system of @sec-gen-shape.
+ J. C. Lagarias, A. M. Odlyzko, *Effective versions of the Chebotarev density theorem*, in
  Algebraic Number Fields (Durham 1975), 409--464. The effective and GRH-conditional error terms
  quoted in @sec-density.
]
