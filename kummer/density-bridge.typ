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
  #text(size: 16pt, weight: "bold")[One curve, or a family of twists]
  #v(2mm)
  #text(size: 10pt)[How `ec-padic-closure`, `ec-density-bm` and `wild-symbols` sit
  against `kummer-padic-density.typ` and the survey --- including one duplication,
  one collapse, and one correction]
  #v(1mm)
  #text(size: 9pt, style: "italic")[checked in `density-bridge.gp`, output in
  `results/density-bridge.txt`]
]

#v(4mm)

#block(fill: rgb("#fff4e6"), inset: 8pt, radius: 3pt, width: 100%)[
  *Duplication, stated up front.* `ec-padic-closure.typ` re-derives §2.1 of
  `kummer-padic-density.typ`. The density criterion, the index
  $M = c_p dot \#tilde(E)^"ns"(FF_p)$, the $E_1 slash E_2$ test read off the denominator of
  $x(Q)$, and the "$tilde(E)(FF_p)$ non-cyclic forces rank $>= 2$" obstruction are all already
  there. I did not check the existing documents before writing it. What is genuinely new in it is
  narrow: the conductor-$89$ witness where the reduction map is *surjective* and density still
  fails, the census of the component-group layer, and the phrasing of the criterion as
  surjectivity modulo $p^2$.
]

= The criterion was already right here <sec-criterion>

`kummer-padic-density.typ` §2.1 states, for $Gamma subset.eq E_d (QQ)$:
$ overline(Gamma) = E_d (QQ_p) quad <==> quad
  cases(Gamma arrow.r.twohead E(QQ_p) slash E_1 (QQ_p) quad "(index" M ")",
        Gamma inter E_1 subset.eq.not E_2) $
with $M = c_p dot \#tilde(E)^"ns"(FF_p)$. That is exactly the $N_p$ and the $v_p (c(m P)) = 1$
test of `ec-padic-closure.typ`.

Worth noting for its own sake: *the second clause is precisely the one that the phrasing
"$E(QQ) -> E(FF_p)$ is surjective" drops.* The correction made in that document was not a
correction to this repository --- the correct statement was already in it. The conductor-$89$
curve at $p = 11$ and $p = 13$ is just an explicit witness that the second clause has content.

The CM table row reproduces exactly. For $d = 6$, in the bad class $[u dot 3]$:

#align(center)[
#table(columns: 5, align: (center, center, center, center, center), stroke: 0.4pt, inset: 5pt,
  [twist], [curve], [Kodaira], [$c_3$], [$M = c_3 (3 - a_3)$],
  [$d = 6$ (class $[u dot 3]$)], [$y^2 = x^3 - 432$], [$I V^*$], [$3$], [$9$],
  [$d = 3$ (class $[3]$)], [$y^2 = x^3 - 54$], [$I V^*$], [$1$], [$3$],
)]

--- the Tamagawa jump that forces rank $>= 2$ in one class and not the other.

= The collapse: why the single-curve argument says nothing on $X$ <sec-collapse>

This is the substantive difference, and it is worth being blunt about.

In `ec-density-bm.typ` the obstruction pairs *a point against a class*:
$"inv"_v cal(A)_beta (Q) = ⟨Q_v, beta_v⟩_v$ with $beta$ running over $H^1(QQ, E)$. On the Kummer
surface that shape is not available. A point of $X$ over the class $delta$ is an unordered *pair*
$(P, Q)$ of points on one twist $E_d$, so what reciprocity has to work with is
$ ⟨delta_v P, delta_v Q⟩_v , $
*both* entries in the local Kummer image $W_v = "im"(E_d (QQ_v) slash n)$.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  And $W_v$ is maximal isotropic --- $W_v^perp = W_v$, the fact used in `ec-density-bm.typ` §7 to
  identify which classes can obstruct. So $⟨delta_v P, delta_v Q⟩_v = 0$ *identically, at every
  place*, and reciprocity gives $0 = 0$. The single-curve Brauer--Manin argument is not merely
  weaker in the family setting; on $X$ it is *vacuous*.
]

$dim W_v$ is exactly half of $dim H^1(QQ_v, E[2])$ at every place --- checked for the conductor-$37$
curve at $v = 3, 5, 7, 11, 23, 37$. That is the whole of the collapse.

== What rescues it <sec-twist>

`kummer-padic-density.typ` §5.1.5 twists the pairing by a *non-scalar*
$phi in "End"_G (E[n])$:
$ beta_v (P, Q) = ⟨delta_v P, thin phi thin delta_v Q⟩_v . $
$phi$ is Galois-equivariant, so reciprocity still gives $sum_v beta_v (P,Q) = 0$ --- but $W_v$
carries no isotropy constraint for the *twisted* form, so the sum is not forced to be $0 = 0$.
If $beta_v equiv 0$ for every $v != p$, the image of $E_d (QQ)$ in $W_p$ is $beta_p$-isotropic,
hence of dimension $<= 1$ in a non-degenerate symplectic plane --- which is exactly the measured
failure to span.

The price is a hypothesis with no analogue in the single-curve story:

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *$E[n]$ must be decomposable.* Otherwise $"End"_G (E[n]) = FF_n$, every $phi$ is scalar, and
  $beta$ collapses back to the pairing that vanishes on $W_v$. In the CM family this is supplied
  by the $j = 0$ geometry: $psi_3 (x) = 3x(x^3 + 4k)$ with $k = -2d^3$ makes $-4k = (2d)^3$ a
  perfect cube, so a *second* rational root appears and $E[3] = C_1 xor C_2$ for the whole family.

  Note what this means for §5 of `ec-density-bm.typ`: there I showed an index-$2$
  obstruction on a curve with *no rational isogeny at all*. In the family setting that curve would
  be useless --- decomposable $E[n]$ is not a convenience there, it is the hypothesis. The two
  settings want opposite things from $E[n]$.
]

= What `wild-symbols.typ` actually contributes <sec-wild>

Not a new tool --- `level3.gp` already built the wild cubic symbol at $3$. What the computation
adds is *sharpness* of the lemma that makes it work.

`level3.gp` evaluates the wild symbol by the product formula, which needs every class of
$K^times slash (K^times)^3$, $K = QQ_3 (zeta_3)$, to have a global representative; its stated
reason is that $U^((4)) subset.eq (K^times)^3$, so a class is fixed by its valuation and its unit
part *modulo $9$*. Brute force over $cal(O) slash pi^12 = cal(O) slash 3^6$ confirms this and
shows the $4$ cannot be lowered:

#align(center)[
#table(columns: 3, align: (center, right, center), stroke: 0.4pt, inset: 5pt,
  [$m$], [units $equiv 1 mod pi^m$], [all cubes?],
  [$2$], [$59049$], [no ($52488$ fail)],
  [$3$], [$19683$], [no ($13122$ fail)],
  [$4$], [$6561$], [*yes*],
  [$5$], [$2187$], [*yes*],
)]

At $m = 3$ exactly one third of the units are cubes --- one full layer of the filtration would be
lost. *The mod-$9$ precision in `level3.gp` is exactly right and cannot be reduced.*

= A correction to `ec-density-bm.typ` §6 <sec-correction>

That section called the index-$11$ case "blocked by an unimplemented wild symbol". That is too
pessimistic, and this repository already contains two ways round.

*(a) The product-formula evasion generalises.* `level3.gp` needs only (i) a single prime above
$ell$ in $QQ(zeta_ell)$, and (ii) a depth bound giving global representatives. Condition (i) is
automatic --- $ell$ is totally ramified in $QQ(zeta_ell)$ for every $ell$ --- and (ii) is the
depth computation of `wild-symbols.typ`:

#align(center)[
#table(columns: 5, align: (left, center, center, center, center), stroke: 0.4pt, inset: 5pt,
  [field], [$h$], [primes above $ell$], [$e$], [depth $p e slash (p-1)$],
  [$QQ(zeta_3)$], [$1$], [$1$], [$2$], [$3$],
  [$QQ(zeta_11)$], [$1$], [$1$], [$10$], [$11$],
)]

At $11$ the depth is $11$, so $U^((12))$ consists of $11$-th powers; and $v(11^2) = 20 >= 12$, so
a class is pinned down modulo $121$. The two inputs that made the cubic symbol computable are
both present.

*(b) Often you do not need to evaluate the symbol at all.* The survey's treatment of `11a1` at
$p = 11$ was flagged as needing the quintic symbol and then did not use one: the proof needs
$beta_11$ to be *non-degenerate*, not to be computed, and split multiplicative reduction settles
that structurally. The Tate $mu_5$ turns out to be a *third* line, distinct from both global
subgroups $C_1, C_2$, so $phi$ restricts to an isomorphism and the Weil pairing of two distinct
lines of a symplectic plane is perfect.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  So "no explicit class" and "no proof" are different things, and the survey had already
  separated them. What `wild-symbols.typ` establishes is narrower than §6 suggested: the *cost*
  of evaluating a wild symbol --- depth $p e slash (p-1)$, in a field ramified by $p-1$, on a
  class group of size $p^(p+1)$ --- not the impossibility of getting the theorem.
]

= The K3 Brauer group, and why the search stops at $ell = 5$ <sec-k3>

The recollection is *right in substance and wrong as stated*, and the repair is worth having
because it makes the survey's criterion into a Brauer-group statement exactly.

== The literal claim is false <sec-k3-false>

For a K3 surface over an algebraically closed field of characteristic $0$,
$ "Br"(overline(X)) tilde.equiv (QQ slash ZZ)^(22 - rho) , quad rho = "rk" "NS"(overline(X)) <= 20 , $
so $"Br"(overline(X))[ell] tilde.equiv (ZZ slash ell)^(22 - rho)$ is non-zero for *every* $ell$.
The geometric Brauer group of a K3 never runs out of $ell$-torsion.

== The true statement, and it is the criterion <sec-k3-true>

The finiteness lives one level up, in the *Galois-invariant* part. For $A = E_1 times E_2$ the
Künneth decomposition of $H^2$ gives
$ "Br"(overline(A))[ell] tilde.equiv "Hom"(E_1 [ell], E_2 [ell]) slash ("Hom"(E_1,E_2) ⊗ FF_ell) , $
the quotient being the algebraic (Néron--Severi) part. For $E_1 = E_2 = E$ without CM,
$"Hom"(E,E) = ZZ$, so the quotient is by the *scalars*:
$ "Br"(overline(A))[ell] tilde.equiv "End"(E[ell]) slash FF_ell tilde.equiv M_2 (FF_ell) slash "scalars" , $
and $"Br"(overline("Kum"(A))) tilde.equiv "Br"(overline(A))$ away from $2$ (Skorobogatov--Zarhin).
Taking Galois invariants:

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  $ "Br"(overline(X))^(G_QQ) [ell] tilde.equiv "End"_G (E[ell]) slash FF_ell , quad
    X = "Kum"(E times E) . $
  So the survey's criterion $"End"_G (E[ell]) != FF_ell$ is *literally* "the Kummer surface has a
  Galois-invariant transcendental Brauer class of order $ell$". Searching for the twisting
  endomorphism $phi$ and searching for $ell$-torsion in that group are the *same search* --- and
  the scalars are divided out precisely because they are the algebraic part, which is exactly why
  the criterion asks for $phi$ *non-scalar*.
]

== What actually bounds $ell$: Mazur--Kenku, not K3 geometry <sec-k3-bound>

$"End"_G (E[ell]) != FF_ell$ forces the mod-$ell$ image to be small. Over $QQ$, for *odd* $ell$,
only one of the four cases in the survey's triage table can occur:

#align(center)[
#table(columns: 2, align: (left, left), stroke: 0.4pt, inset: 6pt,
  [structure], [what it costs over $QQ$],
  [two stable lines (split Cartan)],
    [a non-cuspidal rational point of $X_"split"(ell) tilde.equiv X_0 (ell^2)$. By Mazur--Kenku
     the cyclic isogeny degrees over $QQ$ are $N <= 19$ together with
     ${21, 25, 27, 37, 43, 67, 163}$; $N = ell^2$ therefore forces
     $ell^2 in {4, 9, 25}$, i.e. $ell in {2,3,5}$. Note $ell^2 = 49$ is *not* on the list.],
  [one stable line, equal characters],
    [$chi_1 = chi_2$ with $chi_1 chi_2 = chi_"cyc"$ gives $chi_1^2 = chi_"cyc" mod ell$; with a
     rational $ell$-torsion point ($chi_1 = 1$) this needs $ell = 2$.],
  [image inside a nonsplit Cartan],
    [*impossible over $QQ$ for odd $ell$.* Complex conjugation $c$ lies in the image with
     $det c = chi_"cyc"(c) = -1$ and $c^2 = 1$, so its eigenvalues are $1, -1$, distinct for odd
     $ell$. An element of a nonsplit Cartan acts with eigenvalues $alpha, alpha^ell$ for
     $alpha in FF_(ell^2)$ --- equal if $alpha in FF_ell$, conjugate and outside $FF_ell$
     otherwise --- never ${1,-1}$. So the fourth row of the triage table is *empty over $QQ$*.],
  [larger irreducible image], [$"End"_G = FF_ell$, scalar.],
)]

So over $QQ$ the usable case is $ell in {2,3,5}$, exactly. A brute-force census agrees, with a caveat: `ellisomat` records isogeny targets up to
*isomorphism*, so two distinct stable lines with isomorphic quotients register once --- `14a1`
has isogeny degrees ${1,2,3,6}$ yet $psi_3$ has *two* rational roots, hence two stable
$3$-lines. The census is therefore a lower bound on which $ell$ occur, not a proof; it returns
$ell in {2,3,5}$ over $44741$ curves, and the exact statement rests on Mazur--Kenku. And
$ell = 7$ genuinely fails even where one would most expect it --- the CM curve of conductor $49$,
$j = -3375$ with CM by $sqrt(-7)$, has isogeny degrees ${1,2,7,14}$: a *single* $7$-isogeny, so
$E[7]$ is reducible but not decomposable and $"End"_G (E[7])$ is scalar.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *Verdict.* Yes, there is a connection, and it is exact rather than analogical: the search for a
  twisting endomorphism is the search for $ell$-torsion in $"Br"(overline(X))^(G_QQ)$. But the
  bound is not a K3 fact --- a K3's geometric Brauer group has $ell$-torsion for every $ell$. It
  is the vanishing of the *Galois-invariant* part, and that vanishing is Mazur--Kenku on rational
  points of modular curves. The mechanism runs out at $ell = 5$ for the same reason there are no
  rational $ell^2$-isogenies past $25$.
]

= Does $beta_p$ vary with the twist? <sec-twistvary>

*No --- it depends on $d$ only through its square class at $p$.* So one check per class
suffices: four at an odd $p$, eight at $2$, not one per twist. But the shortcut that seems to
follow does not, and the reason is worth separating out.

== Why $beta_p$ is twist-independent within a class <sec-twistvary-why>

If $d slash d'$ is a square in $QQ_p$ then
$ psi : E_d --> E_(d') , quad (x, y) |-> (c^2 x, c^3 y) , quad c^2 = d slash d' , $
is an isomorphism *defined over $QQ_p$*. It carries $E_d [ell]$ to $E_(d')[ell]$, each
Galois-stable line to the corresponding one --- so it commutes with $phi$ --- and preserves the
Weil pairing. Hence it identifies $W_p$ with $W_p'$ and $beta_p$ with $beta_(p)'$. The same form,
on the nose.

Checked on `14a1` ($E[3]$ decomposable: $psi_3$ has two rational roots), $ell = 3$, critical place
$p = 7$. Every twist in the class $[1]$ --- the $7$-adic units $d equiv 1, 2, 4$ --- gives
identical local data, and a different class gives different data:

#align(center)[
#table(columns: 5, align: (left, center, center, center, center), stroke: 0.4pt, inset: 5pt,
  [class at $7$], [$d$ tested], [Kodaira], [$c_7$], [$a_7$], )
#table(columns: 5, align: (left, center, center, center, center), stroke: 0.4pt, inset: 5pt,
  [$[1]$], [$1,2,4,8,9,11,15,22,23,37,247,-6,-5$], [$I_3$], [$3$], [$+1$],
  [non-square], [$3,5,6,10,13$], [$I_3$], [$1$], [$-1$],
)]

$M = c_7 (7 - a_7)$ is $18$ throughout the first row and $8$ throughout the second.

== What does move with $d$ <sec-twistvary-moves>

The vanishing *away* from $p$. $beta_v$ can be non-zero only where $dim W_v = 2$, which needs
$mu_ell subset QQ_v$, i.e. $v equiv 1 mod ell$. So the places at risk are
$ {p} union {ell} union {q divides d : q equiv 1 mod ell} , $
and that last set genuinely moves. Among the same $14$a$1$ twists, $d = 1, 2, 4, 11, 15, 23$
contribute nothing new, while $d = 37$ brings in $37$ and $d = 247$ brings in $13$ and $19$ ---
each a fresh place where $beta_v$ could survive and let the reciprocity sum balance away from the
critical place. That is exactly the family-uniform obligation, and it is why the CM table in
`kummer-padic-density.typ` lists "few bad primes necessary" as one of the four things the
mechanism explains.

== Why the shortcut still fails <sec-twistvary-shortcut>

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  $beta_p != 0$ is a *local* fact about a form on $W_p$. "$E_d (QQ)$ fails to surject onto $W_p$"
  is a *global* fact about one twist. The implication runs one way only:
  $ beta_p != 0 " and " beta_v = 0 (v != p) quad ==> quad "image isotropic" ==> dim <= 1
    ==> "no surjection" . $
  It cannot be inverted. A twist can fail to surject simply because its rank is too small, which
  says nothing whatever about $beta_p$. So testing one twist --- or seven hundred --- gives
  evidence, not proof; the $708$ rank-$>= 2$ twists of the CM search are exactly that, and
  `kummer-padic-density.typ` presents them as exactly that.
]

There *is* a valid converse use, in the refuting direction. If a single twist in the class *does*
span $W_p$ (with $beta_v = 0$ away from $p$), then $beta_p$ vanishes on $W_p$ and the mechanism is
dead for that class. So one twist can kill the obstruction; no number of twists can establish it.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *Net effect on the mental picture.* The symbol work, where it is needed at all, is needed
  *once per square class at the critical place* --- a bounded, local computation, not something
  that recurs across an infinite family. And often it is not needed even once: `11a1` at $p = 11$
  gets non-degeneracy structurally from the Tate curve. The genuinely $d$-dependent labour is the
  *vanishing* at the other places, and that is done by the dimension count $dim W_v <= 1$, which
  needs no symbol at all.
]

= Dictionary <sec-dictionary>

#align(center)[
#table(columns: 3, align: (left, left, left), stroke: 0.4pt, inset: 6pt,
  [], [single curve], [twist family on $X$],
  [what is asked], [is $E(QQ)$ dense in $E(QQ_p)$?],
    [is $X(QQ)$ dense in $X(QQ_p)$?],
  [reduces to], [one closure], [4 (or 8) twists, one per square class],
  [local criterion], [the same one: onto $E(QQ_p) slash E_1$, and meet $E_1$ outside $E_2$],
    [ditto, per twist],
  [what pairs], [a point against a class $beta in H^1(QQ,E)$],
    [a point against a point --- both in $W_v$],
  [plain reciprocity], [gives the obstruction], [gives $0 = 0$: $W_v$ is Lagrangian],
  [fix], [none needed], [twist by non-scalar $phi in "End"_G (E[n])$],
  [needs], [nothing special about $E[n]$], [$E[n]$ *decomposable*],
  [obstruction is], [a linear functional], [a *pairing* --- so no preferred line, which is why
    the search for a universal functional failed],
)]

#v(2mm)

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *The short version.* The local half of the single-curve work was already in
  `kummer-padic-density.typ`. The global half --- Brauer--Manin as summed local Tate pairings ---
  is the right frame, but on the Kummer surface it degenerates to $0 = 0$ and only the *twisted*
  pairing survives, which is why the family argument needs decomposable $E[n]$ and the
  single-curve argument does not. And the wild-symbol material describes the cost of an explicit
  class, not a barrier to the theorem: `level3.gp` paid that cost at $3$, and the survey showed
  at $11$ that it often need not be paid at all.
]

#v(3mm)

_Companion file:_ `density-bridge.gp`, run as

```sh
gp -q -s 12000000000 density-bridge.gp < /dev/null > results/density-bridge.txt
```

It reproduces the CM Tamagawa row at $p = 3$, the half-dimension count showing $W_v$ Lagrangian,
the sharpness of $U^((4)) subset.eq (K^times)^3$ by brute force over $cal(O) slash 3^6$, and the
cyclotomic data at $3$ and $11$ behind @sec-correction.
