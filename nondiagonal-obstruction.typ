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
  #text(size: 16pt, weight: "bold")[The twisted-pairing obstruction on $"Kum"(E times E')$]
  #v(2mm)
  #text(size: 10pt)[The obstruction of $section 5.1.5$ does generalise off the diagonal ---
  and the hypothesis it needs becomes *weaker*: not $E[ell]$ decomposable, but $E$ and $E'$
  $ell$-congruent and non-isogenous]
  #v(1mm)
  #text(size: 9pt, style: "italic")[checked in `nondiagonal-obstruction.gp`; companion to
  $section 5$ of `kummer-padic-density.typ`, $section 2$ and $section 5$ of `density-bridge.typ`,
  and `openness-covering.typ`]
]

#v(4mm)

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *Verdict.* Yes. Replace the non-scalar $phi in "End"_(G_QQ) (E[ell])$ by a Galois-equivariant
  $ psi in "Hom"_(G_QQ) (E'[ell], E[ell]) $
  and set $beta_v (P, P') = ⟨ delta_v P, thin psi delta'_v P' ⟩_v$. Reciprocity, twist-uniformity
  and the vanishing at good places all survive verbatim. Three things change, two of them for the
  better: the construction is *non-vacuous* exactly when $psi$ is not induced by an isogeny
  $E' -> E$, which for non-isogenous curves is automatic; the conclusion blocks the *union* form
  of the criterion and not merely the single-twist form; and $ell$ is no longer capped at $5$ by
  Mazur--Kenku. What is *lost* is that $beta_v$ is no longer alternating, so places with
  $dim W_v = 1$ are no longer free.
]

= What has to generalise <sec-what>

Recall the diagonal mechanism ($section 5.1.5$ of the main notes). Write
$W_v = E(QQ_v) slash ell$, $delta_v : W_v arrow.hook H^1 (G_v, E[ell])$ for the Kummer map and
$L_v = delta_v (W_v)$ for its image; $L_v$ is *maximal isotropic* for the local Tate pairing
$⟨thin , thin⟩_v$ induced by the Weil pairing. A rational point of $X = "Kum"(E times E)$ is an
unordered pair $(P, Q)$ on one twist, and the *untwisted* sum $sum_v ⟨delta_v P, delta_v Q⟩_v$
vanishes term by term, since both entries lie in $L_v$: this is the collapse of
$section 2$ of `density-bridge.typ`. Twisting one entry by a non-scalar
$phi in "End"_(G_QQ) (E[ell])$ moves $phi delta_v Q$ off $L_v$ and revives the argument, at the
price of requiring $E[ell]$ *decomposable*.

Off the diagonal a rational point of $X = "Kum"(E times E')$ is a pair $(P, P')$ with
$P in E_d (QQ)$ and $P' in E'_d (QQ)$ --- points on *different* curves. So the second entry must
be moved from $H^1(E'[ell])$ to $H^1(E[ell])$ before it can be paired at all, and the object that
does this is a *homomorphism between the two mod-$ell$ representations*.

= The pairing <sec-pairing>

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Construction.* Let $psi in "Hom"_(G_QQ) (E'[ell], E[ell])$ and, for
  $P in E_d (QQ)$, $P' in E'_d (QQ)$, set
  $ beta_v (P, P') = ⟨ delta_v P, thin psi_* delta'_v P' ⟩_v
    quad in quad (1 slash ell) ZZ slash ZZ , $
  where $psi_*$ is the induced map $H^1 (G_v, E'[ell]) -> H^1 (G_v, E[ell])$. Then
  $ sum_v beta_v (P, P') = 0 . $
]

Both entries lie in $H^1 (G_v, E[ell])$, so the pairing is defined; and both are localisations of
*global* classes --- $delta P in H^1 (G_QQ, E[ell])$ and $psi_* delta' P'$, which is global because
$psi$ is Galois-equivariant --- so the sum of local invariants of their cup product vanishes by
global reciprocity. Nothing in this uses $E = E'$.

= When it is not vacuous <sec-vacuous>

The whole question is whether $beta_v$ can be non-zero, and there is a clean answer.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Collapse criterion.* If $psi$ is the restriction to $E'[ell]$ of an isogeny
  $lambda : E' -> E$, then $beta_v equiv 0$ at *every* place.

  #v(2mm)
  _Proof._ Functoriality of the Kummer map gives $psi_* delta'_v (P') = delta_v (lambda P')$, which
  lies in $L_v$. So both entries lie in $L_v$, which is maximal isotropic, and the pairing
  vanishes. $qed$
]

So the construction has content precisely when $psi$ survives the quotient by the isogenies. That
quotient is exactly the group computed in $section 5$ of `density-bridge.typ`: by Kunneth and
Skorobogatov--Zarhin,
$ "Br"(overline(X))^(G_QQ) [ell] = "Hom"_(G_QQ) (E'[ell], E[ell]) thin slash
  ("Hom"(E', E) times.o bb(F)_ell) . $
For $E = E'$ non-CM the denominator is the scalars and the numerator is $"End"_(G_QQ) (E[ell])$,
recovering "$phi$ non-scalar", i.e. $E[ell]$ decomposable. Off the diagonal the denominator is
usually *zero*:

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *The hypothesis, in its useful form.* If $E$ and $E'$ are *$ell$-congruent* ---
  $E[ell] tilde.equiv E'[ell]$ as $G_QQ$-modules --- and *not isogenous*, then
  $"Hom"(E',E) = 0$, so every non-zero $psi$ works and
  $"Br"(overline(X))^(G_QQ) [ell] != 0$.
]

This is a genuinely weaker demand than decomposability. Decomposable $E[ell]$ forces the mod-$ell$
image into a split Cartan, hence a rational point of $X_"split" (ell) = X_0 (ell^2)$, and
Mazur--Kenku then caps $ell$ at $5$ ($section 5.2$ of the main notes). Congruence is governed
instead by the modular *surface* $X_E (ell)$, a twist of $X(ell)$: rational for $ell = 3, 5$, so
infinitely many partners for a given $E$, and with known examples at $ell = 7$ and beyond. The
$ell <= 5$ ceiling is a feature of the diagonal case only.

= Twist-uniformity survives <sec-twist>

The property that lets the diagonal criterion beat any finite search is that $phi$ does not depend
on $d$. The same holds here, and for a reason worth spelling out: twisting multiplies *both*
representations by the same quadratic character, and it cancels in $"Hom"$.

$ "Hom"_(G_QQ) (E'_d [ell], E_d [ell])
  = "Hom"_(G_QQ) (E'[ell] times.o chi_d, thin E[ell] times.o chi_d)
  = "Hom"_(G_QQ) (E'[ell], E[ell]) . $

So a single $psi$ serves every twist in the family, and the criterion below is a condition on the
quadruple $(E, E', ell, p)$ and a square class --- not on individual twists.

= The endgame, which is stronger than on the diagonal <sec-endgame>

Fix a square class $c$ and suppose $beta_v equiv 0$ for every $v != p$. Reciprocity then gives
$beta_p (P, P') = 0$ for *all* rational $P in E_d (QQ)$, $P' in E'_d (QQ)$ and all $d in c$. Write
$R_d subset.eq W_p$ and $R'_d subset.eq W'_p$ for the images of the rational points. Then
$ beta_p (R_d, R'_d) = 0 quad "for every" d in c . $

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Consequence.* Suppose $beta_p equiv.not 0$. Choose $(w, w') in W_p times W'_p$ with
  $beta_p (w, w') != 0$. Then no $d$ has $w in R_d$ *and* $w' in R'_d$. Hence the union
  $ union.big_(d in c) R_d times R'_d subset.neq W_p times W'_p $
  is not everything, and since $E_delta (QQ_p) times E'_delta (QQ_p) ->> W_p times W'_p$ is
  surjective, $union.big_d H_d times H'_d$ is not all of
  $E_delta (QQ_p) times E'_delta (QQ_p)$ either. So $X(QQ)$ is *not* dense in $X(QQ_p)$.
]

This is a sharper conclusion than the diagonal one. There the argument bounds $dim R_d <= 1$ for
each twist separately, which refutes the single-twist form; here it directly refutes the *union*
form --- the criterion that $section 2.1$ of the main notes shows is the real one off the
diagonal, and that $section 2.1.1$ shows the single-twist form does not imply. And it needs only
$beta_p != 0$, not non-degeneracy: on the diagonal one wants a non-zero *alternating* form on a
$2$-dimensional $W_p$, so $dim W_p = 2$ is a hypothesis; here $dim W_p = dim W'_p = 1$ already
suffices.

= Which places stay harmless, and which do not <sec-places>

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Kept.* At $v = infinity$, $W_infinity = 0$ for odd $ell$. At $v tilde.not ell$ of *good*
  reduction, $L_v = H^1_"ur"$ is its own annihilator and $psi$ preserves unramifiedness, being
  Galois-equivariant --- so $psi_* L'_v subset.eq H^1_"ur"$ and $beta_v = 0$.

  #v(1.5mm)
  *Lost.* On the diagonal $beta_v$ is *alternating* on $W_v$, so it dies wherever
  $dim W_v <= 1$. Off the diagonal $beta_v$ pairs two *different* spaces, $W_v times W'_v$;
  "alternating" is not even defined, and a pairing of two $1$-dimensional spaces can be non-zero.
  The cheap dimension count is gone.
]

What replaces it is a sharper but still usable statement at additive places.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Additive places are still free, provided $ell >= 5$.* Let $v tilde.not ell$ have additive
  reduction. Then $E_0 (QQ_v)$ is pro-$v$, so $E(QQ_v)[ell] arrow.hook Phi_v$, the component group,
  of order at most $4$. For $ell >= 5$ this forces $E(QQ_v)[ell] = 0$; and for $v tilde.not ell$,
  $ZZ_v$ is $ell$-divisible, so
  $ dim W_v = dim E(QQ_v)[ell] = 0 . $
  Hence $beta_v = 0$. For $ell = 3$ the component group can be $ZZ slash 3$ (types $I V$,
  $I V^ast$) and $dim W_v = 1$ is possible on both sides at once --- there the place must be
  checked by hand.
]

Since every $q divides d$ is additive for both twists, this is what keeps the *varying* twist
harmless, exactly as on the diagonal --- but now only for $ell >= 5$. That is the one place where
the non-diagonal argument is strictly more demanding, and it is a mild trade for dropping
decomposability.

Multiplicative places behave as before, with the danger condition now imposed on the pair: $q$ is
*dangerous* when $v_q (j) < 0$, $q equiv 1 space (mod ell)$ and $ell divides v_q (j)$ for
*both* curves, since $beta_q$ needs $W_q$ and $W'_q$ both non-zero.

= The criterion <sec-criterion>

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Criterion (non-diagonal).* Fix an odd prime $ell$, elliptic curves $E, E' slash QQ$, a prime
  $p$, and a square class $c$. Suppose

  #v(1mm)
  #set enum(numbering: "(A)")
  + $"Hom"_(G_QQ) (E'[ell], E[ell]) != 0$ and some $psi$ in it is not induced by an isogeny
    $E' -> E$ --- automatic if $E, E'$ are $ell$-congruent and non-isogenous. (Twist-invariant,
    @sec-twist.)
  + $W_p != 0 != W'_p$. For $p = ell$ this is automatic, since
    $dim W_ell = dim E[ell](QQ_ell) + 1 >= 1$.
  + $beta_p equiv.not 0$ on $W_p times W'_p$.
  + No prime $q != p$ is dangerous for the pair.
  + $beta_v equiv 0$ at every remaining place. For $ell >= 5$ the additive places are free by
    @sec-places; if $p != ell$ the place $v = ell$ remains.

  #v(2mm)
  Then for *every* $d in c$ the rational images satisfy $beta_p (R_d, R'_d) = 0$, and
  $X(QQ)$ is not dense in $X(QQ_p)$ --- the union form and not merely the single-twist form.
]

Conditions (A), (B), (D) depend only on $(E, E', ell, p)$ and (C), (E) only on the square class,
so the criterion is uniform in $d$, which is what lets it beat a finite search.

= A candidate pair, checked <sec-example>

The hypotheses are not empty. Searching curves of conductor $<= 500$ for pairs with
$a_q equiv a'_q space (mod 5)$ but $a_q != a'_q$ over $ZZ$ turns up three; here is one.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  $ E : y^2 = x^3 - 5x^2 + 5x, wide E' : y^2 = x^3 + 5x - 10, wide N = 200, wide ell = 5 . $
  $j_E = 2048$, $j_(E') = 270$; ranks $1$ and $0$; torsion $ZZ slash 2$ and trivial.
]

Verified:

#v(2mm)
#align(center)[
#table(columns: 2, align: (left, left), stroke: 0.4pt + luma(170), inset: (x: 8pt, y: 4pt),
  table.header([condition], [status]),
  [$a_q equiv a'_q space (mod 5)$], [holds at all $428$ good primes $q <= 3000$],
  [$a_q != a'_q$ over $ZZ$], [at $403$ of those $428$ --- so not isogenous],
  [isogeny classes], [sizes $2$ and $1$, and disjoint],
  [rational $5$-isogenies], [none on either curve],
  [(D) dangerous primes], [none: $v_q (j) >= 0$ at both bad primes $q = 2, 5$],
  [(E) at $v = 2$], [$dim W_2 = dim W'_2 = 0$, so $beta_2 = 0$],
  [(B) at $v = 5$], [$dim W_5 = dim W'_5 = 1$],
)]

#v(2mm)

So with $p = ell = 5$ every place except $5$ is harmless, and the entire obstruction reduces to
the single question of whether $beta_5$ --- a pairing of two one-dimensional $bb(F)_5$-spaces ---
is non-zero.

= What is and is not established <sec-status>

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *Proved here.* The construction transposes: the pairing is defined, reciprocity holds, the
  collapse criterion identifies exactly when it is vacuous, twist-uniformity survives with the
  quadratic characters cancelling, good places are free, additive places are free for
  $ell >= 5$, and $beta_p != 0$ refutes the union form. Each step is the diagonal argument with
  $"End"$ replaced by $"Hom"$, and none of them used $E = E'$.

  #v(1.5mm)
  *Not proved here.* Condition (C) --- $beta_5 equiv.not 0$ for the conductor-$200$ pair --- is
  *not* verified. That is a norm-residue symbol computation at $v = ell = 5$ of the kind
  `level3.gp` performs for $ell = 3$, and it has not been done. So the example establishes that
  (A), (B), (D), (E) are simultaneously satisfiable, not that this pair obstructs anything.

  #v(1.5mm)
  *Not chased.* Whether $psi$ can be taken *symplectic* (Weil-pairing preserving) or only
  anti-symplectic affects the identification of the Brauer class, though not the construction
  above. The citations for congruences at $ell = 7$ and beyond are from memory.
]
