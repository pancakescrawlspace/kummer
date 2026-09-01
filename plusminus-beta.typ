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
  #text(size: 16pt, weight: "bold")[Two isomorphisms, one obstruction]
  #v(2mm)
  #text(size: 10pt)[The pairing $beta$ for $y^2 = x^3 minus.plus c^3$, from scratch:
  why $Sigma subset.eq {2}$ is forced, and why the answer at $2$ is
  $v_2(c)$ odd]
  #v(1mm)
  #text(size: 9pt, style: "italic")[a question of René Pannekoek's; companion to
  `plusminus-cube.typ`; checks in `plusminus-beta.gp`]
]

#v(4mm)

#block(fill: luma(240), inset: 9pt, radius: 3pt, width: 100%)[
  *Summary.* Everything below is built from the two curves and nothing else. For
  $ E_c : y^2 = x^3 - c^3, wide E'_c : y^2 = x^3 + c^3 wide (c in QQ^times) $
  both cubics factor as (linear)(quadratic) with quadratic discriminant $-3c^2$, so both
  $2$-division fields are $QQ(zeta_3)$ and $E[2] tilde.equiv E'[2] tilde.equiv FF_2 [C_2]$. That
  module has exactly *two* automorphisms, so there are exactly two isomorphisms
  $psi : E[2] -> E'[2]$, and each has its own $Sigma_psi = {v : psi_* L_v eq.not L'_v}$.

  #v(1.5mm)
  The whole analysis reduces to one observation (@sec-torsion). Writing both cubic algebras as
  $A = QQ[t]slash(t^3-1) = QQ times K$, $K = QQ(zeta_3)$, the two $psi$ are the identity and
  complex conjugation on $K$; and *conjugation matches the $2$-torsion Kummer classes exactly*,
  because the ratio it leaves behind is $zeta_3 = (zeta_3^2)^2$, a global square. Since at every
  odd place these curves have good or *potentially good additive* reduction --- $j = 0$, so never
  multiplicative --- $E(QQ_v)$ has no point of order $4$, $L_v$ is spanned by the $2$-torsion, and
  $beta_v equiv 0$. Hence:

  #v(1.5mm)
  #block(stroke: 0.6pt + black, inset: 8pt, radius: 3pt, width: 100%)[
    *Theorem A.* For $psi_2 = $ conjugation, $Sigma_(psi_2) subset.eq {2}$ for *every*
    $c in QQ^times$, and $beta_2 equiv.not 0$ *exactly when $v_2(c)$ is odd*. For such $c$ the
    rational points of $E_c times E'_c$ are not dense in $(E_c times E'_c)(QQ_2)$.
  ]
  #v(1mm)
  #block(stroke: 0.6pt + black, inset: 8pt, radius: 3pt, width: 100%)[
    *Theorem B.* For $psi_1 = $ the identity,
    $Sigma_(psi_1) = {2, 3} union {q equiv 7 space (mod 12) : v_q (c) "odd"}$, for every
    $c$. So *every* member of the family carries a two-place obstruction, at ${2,3}$.
  ]

  #v(1.5mm)
  The statement at $2$ is a *finite* check, not a search: $beta_v$ depends only on the square class
  of $c$ in $QQ_v^times$, so the eight classes at $v = 2$ exhaust the question (@sec-two). Every
  local Kummer image is computed to its predicted dimension --- the script raises an error rather
  than report a short one --- and Hilbert reciprocity is verified on genuine global points.
]

= The pair, and one algebra for both curves <sec-pair>

Fix $c in QQ^times$ and put
$ E = E_c : y^2 = x^3 - c^3, wide E' = E'_c : y^2 = x^3 + c^3 . $
These are not independent: $(x,y) |-> (-x, i y)$ carries $E$ to $E'$, so $E'$ is the quadratic
twist of $E$ by $-1$. In the twist family of the companion note, $E_d : y^2 = x^3 - a^3 d^3$ and
$E'_d : y^2 = x^3 + a^3 d^3$, one has $c = a d$ and $E'_d = E_(-d)$; every statement below is a
statement about the single parameter $c$.

Both cubics factor over $QQ$:
$ x^3 - c^3 = (x - c)(x^2 + c x + c^2), wide x^3 + c^3 = (x+c)(x^2 - c x + c^2), $
and both quadratics have discriminant $-3c^2$. So each curve has one rational $2$-torsion point and
a pair conjugate over $QQ(sqrt(-3)) = QQ(zeta_3)$: the two $2$-division fields *coincide*, and
$ E[2] tilde.equiv E'[2] tilde.equiv FF_2 [C_2] , wide C_2 = "Gal"(QQ(zeta_3)slash QQ) , $
the regular representation, with the rational point corresponding to the invariant element.

The useful move is to give both curves the *same* étale algebra. Let
$ A := QQ[t] slash (t^3 - 1) tilde.equiv QQ times K , wide K = QQ(zeta_3) = QQ[y]slash(y^2+y+1) , $
with $t |-> (1, zeta_3)$. The roots of $x^3 - c^3$ are the $c t$ and the roots of $x^3 + c^3$ are
the $-c t$, so
$ QQ[x]slash(x^3 - c^3) tilde.equiv A tilde.equiv QQ[x]slash(x^3+c^3) $
canonically, by $x |-> c t$ and $x |-> -c t$ respectively. From here on both descent algebras
*are* $A$, and the two curves differ only in the sign that enters the descent map.

= Descent, and the pairing <sec-descent>

Let $Omega$ be the $G_QQ$-set of the three roots. From $0 -> E[2] -> FF_2[Omega] -->^Sigma FF_2 -> 0$
(the injection sends $T_i$ to $e_j + e_k$) together with Shapiro's lemma and Kummer theory,
$H^1(QQ, FF_2[Omega]) = A^times slash (A^times)^2$; the invariant $e_0$ has $Sigma(e_0) = 1$, so
$H^0(FF_2[Omega]) -> H^0(FF_2)$ is onto and the connecting map vanishes. Hence for every field
$F supset.eq QQ$
$ H^1(F, E[2]) = ker (N_(A slash QQ) : A_F^times slash 2 -> F^times slash 2) , $
and the descent map is
$ delta(x,y) = [x - c] in A^times slash 2 wide ("that is," [x - c, x - c zeta_3]) , $
with the usual value at the rational $2$-torsion $T_0 = (c,0)$,
$ delta(T_0) = [3c^2, thin c(1 - zeta_3)] , wide delta'(T'_0) = [3c^2, thin -c(1-zeta_3)] $
($T'_0 = (-c,0)$ on $E'$; the first slot is $f'(c) = 3c^2$, the second is $c - c zeta_3$).

*The Weil pairing is the diagonal form.* On $FF_2[Omega]$ take $⟨ e_i, e_j ⟩ =
delta_(i j)$. Under $T_i |-> e_j + e_k$ one gets $⟨ T_i, T_i ⟩ = 1 + 1 = 0$ and
$⟨ T_0, T_1 ⟩ = ⟨ e_1 + e_2, thin e_0 + e_2 ⟩ = 1$: this is the Weil
pairing, the unique non-degenerate alternating form on a two-dimensional $FF_2$-space. Consequently
the cup product $H^1(QQ_v, E[2])^(times 2) -> "Br"(QQ_v)[2]$ is *the sum of Hilbert symbols over
the factors of $A$*: for $alpha, alpha' in A_v^times slash 2$,
$ beta_v (alpha, alpha') = product_i product_(w | v) (alpha_i, alpha'_i)_(K_(i,w)) in {plus.minus 1} , $
because $"inv" compose "cor" = "inv"$. With $A = QQ times K$ this is one rational symbol times one
symbol over $K$ at each place above $v$ --- entirely computable.

*Local conditions.* Write $L_v = delta(E(QQ_v)slash 2) subset H^1(QQ_v, E[2])$. By local duality
$L_v$ is its own annihilator: a *Lagrangian*. Therefore, for an isomorphism $psi$,
$ beta_v equiv 0 "on" E(QQ_v)slash 2 times E'(QQ_v) slash 2
  quad <==> quad psi_*^(-1) L'_v subset.eq L_v^perp = L_v quad <==> quad psi_* L_v = L'_v , $
both being Lagrangians of the same dimension. Set $Sigma_psi = {v : psi_* L_v eq.not L'_v}$. If
$Sigma_psi$ is finite, reciprocity $sum_v beta_v (P, P') = 0$ holds on global points, and if
$Sigma_psi = {p}$ is a single place then $beta_p (P,P') = 0$ for all rational $P, P'$ while
$beta_p equiv.not 0$ locally --- the rational points miss a non-empty open set of
$E(QQ_p) times E'(QQ_p)$.

The dimensions are forced. Since $|E(QQ_v)slash 2| = |E[2](QQ_v)| dot |2|_v^(-1)$ for $v$
non-archimedean,
#align(center)[
  #table(columns: 6, stroke: 0.4pt, inset: 5pt, align: center,
    [$v$], [$oo$], [$2$], [$3$], [$v equiv 1 space (3)$], [$v equiv 2 space (3)$],
    [$K ⊗ QQ_v$], [$CC$], [inert], [ramified], [split], [inert],
    [$dim_(FF_2) A_v^times slash 2$], [$1$], [$7$], [$4$], [$6$], [$4$],
    [$dim_(FF_2) L_v$], [$0$], [$2$], [$1$], [$2$], [$1$],
  )
]
The archimedean entry is the first free gift: $x^3 - c^3$ has *one* real root, so $E(RR)$ is
connected and $E(RR) slash 2 = 0$. #h(2mm) *$beta_oo equiv 0$ always, for either $psi$.*

= Exactly two $psi$, and what they are <sec-psi>

$E[2] tilde.equiv FF_2[C_2]$ is free of rank one over the group ring, so
$"End"_(G)(E[2]) = FF_2[C_2] = FF_2[u]slash(u^2)$ with $u = sigma + 1$, and
$ "Aut"_G (E[2]) = (FF_2[C_2])^times = {1, sigma} $
has order $2$. Hence *exactly two* isomorphisms $psi : E[2] -> E'[2]$, differing by the swap of the
two conjugate $2$-torsion points. On the algebra $A$ they are the two $QQ$-algebra isomorphisms
$A -> A$ compatible with $c t |-> -c t$:
$ psi_1 : t |-> t quad ("the identity on" A) , wide psi_2 : t |-> t^2 quad ("conjugation on" K) . $
Both are involutions, so $psi_w^(-1) = psi_w$ on $A^times slash 2$. Concretely, for
$P' = (x', y') in E'$,
$ psi_1^(-1) delta'(P') = [x' + c, thin x' + c zeta_3] , wide
  psi_2^(-1) delta'(P') = [x' + c, thin x' + c zeta_3^2] . $

= Conjugation matches the $2$-torsion, at every place <sec-torsion>

This is the one computation the whole note turns on.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Lemma.* $psi_2^(-1) delta'(T'_0) = delta(T_0)$ in $A^times slash (A^times)^2$, and more
  generally $psi_(2,*) delta(T_j) = delta'(T'_(-j))$ over any field containing $zeta_3$.
]

#v(1mm)
*Proof.* $psi_2^(-1) delta'(T'_0) = [3c^2, thin -c(1 - zeta_3^2)]$, and
$ (1 - zeta_3^2) = (1-zeta_3)(1 + zeta_3) = -zeta_3^2 (1 - zeta_3) , $
so the two $K$-slots differ by $-(-zeta_3^2) = zeta_3^2$. #h(2mm) *That is a square in $K$* ---
trivially, $zeta_3^2 = (zeta_3)^2$; equivalently $zeta_3 = (zeta_3^2)^2$, since $zeta_3$ has odd
order. Hence the two classes agree. For the split case, with $e_j = c zeta_3^j$ and
$e'_j = -c zeta_3^j$, the coordinatewise ratios of $psi_(2,*) delta(T_1)$ and $delta'(T'_2)$ are
$zeta_3, thin 1, thin zeta_3$, again all squares. $qed$

The contrast with $psi_1$ is exactly one sign: $psi_1^(-1) delta'(T'_0) = delta(T_0) dot [1, -1]$.
So $psi_1$ *fails* to match the torsion classes wherever $-1$ is not a square in $K ⊗ QQ_v$
--- and $psi_2$ never fails. Nothing here is local: the ratio is a global square.

== The Lemma is not formal <sec-notformal>

It matters to be exact about what the Lemma uses, because the tempting argument --- "$psi$ is an
isomorphism of $E[2]$, so corresponding $2$-torsion points must go to corresponding classes" ---
is *false*, and the counterexample is inside this note. $psi_1$ is equally a $G$-isomorphism
$E[2] -> E'[2]$, differing from $psi_2$ only by an automorphism of $E[2]$, and for $psi_1$ the
conclusion fails. So no property of the $G$-module $E[2]$ can decide it.

*What $delta$ actually sees.* On $E(F) slash 2$ the map $delta$ is the connecting map of
$0 -> E[2] -> E -->^2 E -> 0$. Restricted to the $2$-torsion it factors through $E[4]$: if
$2P = T$ with $T in E[2]$ then $P in E[4]$, so
$ delta|_(E[2](F)) = partial , wide "the connecting map of" wide
  0 -> E[2] -> E[4] -->^2 E[2] -> 0 . $
Thus $delta$ on $2$-torsion is a function of $E[4]$, not of $E[2]$. Check 9(b) confirms this
concretely: $delta(T_0) = 1$ exactly when $T_0$ is halved in $E(QQ_v)$, tested against the roots of
the halving quartic $x^4 - 4c x^3 + 8c^3 x + 4c^4$ --- $32$ comparisons, no mismatch.

*The exact extra hypothesis.* It is *sufficient* that $psi$ lift to a $G$-isomorphism
$Psi : E[4] -> E'[4]$ inducing $psi$ on both the sub and the quotient; then the Lemma is just
naturality of $partial$. What is strictly *needed* is weaker: only that the two extension classes have
the same image under
$ "Ext"^1_(G_F) (E[2], E[2]) --> "Hom"(E[2](F), thin H^1(F, E[2])) , $
i.e. that they induce the same connecting map on $H^0$. Over a field where $E[2]$ is a *trivial*
module --- here any $F supset.eq QQ(zeta_3)$ --- that arrow is an isomorphism and the two conditions
coincide; over $QQ$ they need not.

*In coordinates.* All of this is visible in the descent formula. The slot of $delta(T_i)$ indexed by
the root $e_k$ is $e_i - e_k$ (and the slot at $e_i$ is $product_(k eq.not i)(e_i - e_k)$, the
product of the others). So $psi_* delta(T_i) = delta'(T'_(psi i))$ precisely when
$ (e_i - e_k) slash (e'_(psi(i)) - e'_(psi(k))) wide "is a square, for all" i eq.not k , $
in the field of the corresponding slot. That is *exactly* the $E[4]$ datum again: classically
$T_i in 2E(F)$ iff the differences $e_i - e_k$ are squares, i.e.
$F(E[4]) = F(E[2])(sqrt(e_i - e_k))$.

Here all six ratios are independent of $c$ --- it cancels --- and check 9(a) computes them:
$ psi_1 : quad (e_i - e_k) slash (e'_i - e'_k) = -1 , wide wide
  psi_2 : quad (e_i - e_k) slash (e'_(-i) - e'_(-k)) = zeta_3^(i+k) . $
For $psi_2$ what survives is a power of $zeta_3$, of *odd order* and hence a square: that is the
Lemma, and it is the only reason it holds. For $psi_1$ what survives is $-1$, a square exactly
where $-1$ is --- which is why $psi_1$ fails at $3$ and at the primes $equiv 7 space (mod 12)$
(@sec-psi1), and never fails elsewhere.

== Why the $2$-torsion is all of $L_v$, for $v$ odd

The curves have $j = 0$, hence *potentially good* reduction: at an odd $v$ the reduction is good, or
additive of one of the types $"II"$, $"III"$, $"IV"$, $"I"_0^*$, $"IV"^*$, $"III"^*$, $"II"^*$ ---
never $"I"_n$ or $"I"_n^*$ with $n >= 1$. The component groups of those types have exponent $2$ or
order $3$; *none has an element of order $4$*.

Now let $v$ be odd with additive reduction. $E_1(QQ_v) tilde.equiv (ZZ_v, +)$ is torsion-free and
$E_0 slash E_1 tilde.equiv (kappa_v, +)$ has odd order, so $E_0(QQ_v)$ is *uniquely $2$-divisible*.
If $P in E(QQ_v)$ had order $4$ then $2P$ would be a non-zero $2$-torsion point; were $P$ trivial in
$Phi_v$ we would get $2P in E_0$, forcing $2P = 0$. So $P$ would have order $4$ in $Phi_v$ ---
impossible. Hence $E(QQ_v)$ has no point of order $4$, so
$E[2](QQ_v) -> E(QQ_v)slash 2E(QQ_v)$ is injective, hence bijective since
$|E(QQ_v)slash 2| = |E[2](QQ_v)|$, and
$ L_v = delta(E[2](QQ_v)) . $
At the odd $v$ of *good* reduction there is nothing to prove either: $L_v = H^1_"ur"$, and
$psi$ is $G_QQ$-equivariant, so $psi_*$ preserves the inertia-defined subgroup.

Combining with the Lemma and $beta_oo equiv 0$:

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Proposition.* $Sigma_(psi_2) subset.eq {2}$, for every $c in QQ^times$.
]

= The place $2$ is a finite computation <sec-two>

Replacing $c$ by $c t^2$ is the isomorphism $(x,y) |-> (t^2 x, t^3 y)$, under which $delta$ is
multiplied by the square $t^2$ in every slot. So $L_v$, $L'_v$ and $beta_v$ depend only on the class
of $c$ in $QQ_v^times slash (QQ_v^times)^2$ --- eight classes at $v = 2$, four at each odd $v$.
Running all of them is therefore a *complete case check*, and it gives (check 5):

#align(center)[
  #table(columns: 3, stroke: 0.4pt, inset: 5.5pt, align: (left, center, center),
    [], [$c equiv 1,3,5,7$ #h(1mm) ($v_2(c)$ even)], [$c equiv 2,6,10,14$ #h(1mm) ($v_2(c)$ odd)],
    [$beta_2^(psi_2)$], [$0$], [$eq.not 0$],
    [$beta_2^(psi_1)$], [$eq.not 0$], [$eq.not 0$],
  )
]

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Theorem A.* Let $c in QQ^times$ with $v_2(c)$ odd. Then $Sigma_(psi_2) = {2}$ exactly, so
  $sum_v beta_v = beta_2$ vanishes on $E_c (QQ) times E'_c (QQ)$ while $beta_2 equiv.not 0$ on
  $E_c (QQ_2)slash 2 times E'_c (QQ_2) slash 2$. Hence $(E_c times E'_c)(QQ)$ is *not dense* in
  $(E_c times E'_c)(QQ_2)$.
]

Check 8 exhibits the witnesses. For $c = 26$, for instance,
$ g = [-1, thin -26 zeta_3 + 25] in L_2 , wide h = [27, thin 26 zeta_3 + 1] in L'_2 , wide
  ⟨ g, psi_2^(-1) h ⟩_2 = -1 . $
And check 7 shows the other side of the same coin: on the genuine global points
$P = (65, 507) in E_26 (QQ)$ and $P' = (22,168) in E'_26 (QQ)$ the pairing $beta_2$ is trivial, as
reciprocity demands.

= The other isomorphism, and a two-place obstruction <sec-psi1>

Since $psi_1 = psi_2 compose sigma$ with $sigma$ the conjugation, and $psi_2$ matches $L_v$ with
$L'_v$ wherever $beta_v^(psi_2) equiv 0$, we get the clean reformulation
$ beta_v^(psi_1) equiv.not 0 quad <==> quad sigma L_v eq.not L_v . $
The defect is computable in closed form. For $P = (x,y)$,
$ N_(K slash QQ)(x - c zeta_3) = x^2 + c x + c^2 = y^2 slash (x - c) , $
and $overline(z) = N(z) slash z$, so
$ sigma(delta(P)) = delta(P) dot [1, thin x - c] . $
Thus $sigma L_v = L_v$ iff every class $[1, x(P) - c]$ lies in $L_v$; for the torsion generator the
factor is $[1, -1]$.

At a place with $dim L_v = 1$ --- that is $v = 3$ or $v equiv 2 space (mod 3)$ --- the entire
pairing is the single symbol
$ ⟨ delta(T_0), [1,-1] ⟩_v = product_(w | v) (c(1 - zeta_3), thin -1)_(K_w) , $
which is the Legendre symbol of $-1$ in the residue field of $K_w$. That field is $FF_(v^2)$ for
$v equiv 2 space (mod 3)$, where $-1$ is *always* a square; at the ramified prime it is $FF_3$,
where $-1$ is *not*. So among these places the symbol is $-1$ at $v = 3$ alone (check 2). The
places $v equiv 1 space (mod 3)$ have $dim L_v = 2$ and need the full test, which the square-class
sweep supplies:

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Theorem B.* $Sigma_(psi_1) = {2, 3} union {q equiv 7 space (mod 12) : v_q (c) "odd"}$, for every
  $c in QQ^times$.
]

In particular $|Sigma_(psi_1)| >= 2$ always, so $psi_1$ never gives a one-place obstruction; but it
always gives a two-place one. For $c$ odd with no prime factor $equiv 7 space (mod 12)$ ---
$c = 1$ included, i.e. the pair $y^2 = x^3 - 1$, $y^2 = x^3 + 1$ --- one has
$Sigma_(psi_1) = {2,3}$ exactly, and $beta_2 = beta_3$ is forced on rational points while the two
are independent locally: $(E times E')(QQ)$ is not dense in
$(E times E')(QQ_2) times (E times E')(QQ_3)$.

The residue $7 space (mod 12)$ is the two conditions $q equiv 1 space (mod 3)$ ($K$ splits, so
$dim L_q = 2$) and $q equiv 3 space (mod 4)$ ($-1$ is not a square in $QQ_q$) at once.

= Back to the family $y^2 = x^3 minus.plus a^3 d^3$ <sec-family>

With $a$ an odd prime and $d$ squarefree, $c = a d$, so $v_2(c) = v_2(d)$ and Theorem A reads:

#block(fill: luma(243), inset: 9pt, radius: 3pt, width: 100%)[
  For every odd prime $a$ and every *even* squarefree $d$, the rational points of
  $E_d times E'_d$ are not dense in the $2$-adic topology. For *odd* $d$,
  $Sigma_(psi_2) = nothing$ and this construction says nothing at $2$.
]

That is exactly the dichotomy the independent density scan of `plusminus-cube.typ` found, by a
completely different route (saturated Mordell--Weil generators, and closure in $E(QQ_2)$): among the
eight square classes of $d$ at $2$, the four *odd* ones are realised by twists whose rational points
*are* $2$-adically dense, and the four *even* ones are never realised --- and not for want of rank:
across $a = 3, 5, 7$ the scan turns up $366$ *even* twists with positive rank on *both* curves, each
one a place a witness could have come from, and none is dense. The root numbers agree
too: $w(E_d) w(E'_d) = +1$ for every odd $d$ and $-1$ for every even $d$ in the range tested.
Two computations that share no code agree on where the obstruction lives.

= What is proved, and what is not <sec-status>

*Proved here, self-contained.* The identification $H^1 = ker N$ and the symbol formula for the cup
product; that $psi_2$ matches the $2$-torsion classes globally; that $E(QQ_v)$ has no point of order
$4$ at odd $v$; hence $Sigma_(psi_2) subset.eq {2}$ for every $c$; the eight-class computation at
$2$; Theorems A and B; and reciprocity on global points as an end-to-end check of every convention.

*Not proved here.* Two things.

+ *From $E times E'$ to the Kummer surface.* What Theorem A obstructs is density of
  $(E times E')(QQ)$. A rational point of $X = "Kum"(E times E')$ need not lift to a rational point
  of $E times E'$ --- it may lift only over a quadratic field, with the two lifts swapped and
  negated. Upgrading to $X(QQ)$ is the Brauer step: $beta$ is the evaluation of a class
  $cal(A) in "Br"(X)$, and Brauer--Manin then applies to all of $X(bb(A)_QQ)$. That is
  Skorobogatov--Zarhin's construction and is *not* redone here.

+ *Non-emptiness.* The obstruction is unconditional but vacuous when both curves have rank $0$ and
  only torsion to obstruct. It has content exactly on the even twists with points on both sides;
  check 7 uses $c = 26, 38, 78$, which are such.

*A remark on method.* The earlier note in this repository reported survivors from a *sampled*
evaluation of $beta_q$ and had to retract them. The computation here never samples: each local
image is built until its $FF_2$-rank reaches the value forced by
$|E(QQ_v)slash 2| = |E[2](QQ_v)| dot |2|_v^(-1)$, and `kimage` raises an error rather than return a
short one. The ambient coordinates are themselves certified --- the Gram matrix of the test set is
required to have rank $dim A_v^times slash 2$ before anything is measured against it.

= The checks <sec-gp>

`plusminus-beta.gp`, run from the repository root; output in `results/plusminus-beta.txt`.

#table(columns: 2, stroke: 0.4pt, inset: 5.5pt, align: (center, left),
  [1], [the configuration: conductors, torsion, both $2$-division fields $= QQ(zeta_3)$,
       non-isogenous, $|"Aut"_G (E[2])| = 2$],
  [2], [the two $psi$ on the rational $2$-torsion: ratio $zeta_3$ for $psi_2$ (a global square),
       $-1$ for $psi_1$; and the residue-field symbol that makes $v = 3$ the only
       one-dimensional failure],
  [3], [local structure: $dim A_v^times slash 2$ against the Gram rank of the test set,
       $dim L_v$ against the prediction, and $L_v$ isotropic],
  [4], [reduction at odd primes: Kodaira type and $c_v$, all potentially good, no element of
       order $4$ in $Phi_v$],
  [5], [$beta_v$ over *all* square classes of $c$, at fourteen places --- the complete check
       behind Theorems A and B],
  [6], [$Sigma_(psi_1)$ and $Sigma_(psi_2)$ across $128$ twists $c = a d$, $a in {3,5,7,11}$,
       against the two rules: no mismatches],
  [7], [Hilbert reciprocity on six pairs of genuine global points: every product $+1$],
  [8], [the obstruction exhibited: explicit $g in L_2$, $h in L'_2$ with
       $⟨ g, psi_2^(-1) h ⟩_2 = -1$, present exactly when $v_2(c)$ is odd],
)

= References <sec-refs>

- A. Skorobogatov and Yu. Zarhin, on Brauer groups and rational points of Kummer varieties --- the
  source of the pairing and of the passage from $E times E'$ to $"Kum"(E times E')$.
- J. Silverman, *The Arithmetic of Elliptic Curves*, Ch. VII (component groups, formal groups,
  Tate's algorithm) and Ch. X (descent via $A^times slash (A^times)^2$).
- J. Tate, *Duality theorems in Galois cohomology* --- local duality, and that the Kummer image is
  a Lagrangian.
- Serre, *A Course in Arithmetic*, Ch. III --- Hilbert symbols and the product formula, which is
  what check 7 tests.
