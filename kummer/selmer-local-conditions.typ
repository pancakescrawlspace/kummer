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
  #text(size: 16pt, weight: "bold")[What local Selmer conditions are for]
  #v(2mm)
  #text(size: 10pt)[Seven things the formalism buys, the theorems that illustrate each,
  and where the involution theorem sits among them]
  #v(1mm)
  #text(size: 9pt, style: "italic")[companion to `selmer-involution.typ`]
]

#v(4mm)

= The formalism, and the one idea in it <sec-idea>

A Selmer group is never attached to an object. It is attached to a *pair*: a Galois module and a
choice of local subspaces. Write $M$ for a finite $G_QQ$-module (or a $p$-adic representation), and
for each place $v$ choose a subgroup
$ L_v subset.eq H^1 (QQ_v, M) . $
The collection $cal(L) = {L_v}$ is a *Selmer structure*, subject to one finiteness axiom: $L_v =
H^1_"ur" (QQ_v, M)$ for all but finitely many $v$. The associated Selmer group is
$ "Sel" (M, cal(L)) = ker (H^1 (QQ, M) --> product_v H^1 (QQ_v, M) slash L_v) . $
That is the whole definition. The vocabulary is Mazur--Rubin's; the objects are older.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *The one idea.* A global object --- a class in $H^1(QQ, M)$, ultimately a rational point or an
  element of Ш --- is pinned down by a *finite list of independent local questions*. Nothing in the
  definition remembers where $M$ came from. Two entirely different arithmetic problems that produce
  the same $(M, cal(L))$ have literally the same Selmer group, and two problems that produce the
  same $M$ with different $cal(L)$ differ by an amount that is *computable place by place*.
]

Everything below is a consequence of that sentence. The classical case is $M = E[n]$ and $L_v =
"im" (E(QQ_v) slash n E(QQ_v) -> H^1(QQ_v, E[n]))$, giving $"Sel"_n (E)$; but the point of the
formalism is that this is one point in a space of choices, and that *moving* the choice is the
technique.

Three structural facts make the formalism work, and each is the source of a family of applications.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *(F1) Finiteness.* $"Sel"(M, cal(L))$ is finite and effectively computable: classes are unramified
  outside a finite set $S$, and $H^1_S (QQ, M)$ is finite by Hermite--Minkowski. Each local
  condition is a computation over one local field.

  #v(1.5mm)
  *(F2) Duality.* If $M^* = "Hom"(M, mu_n)$ is the Cartier dual, Tate local duality makes
  $H^1(QQ_v, M) times H^1(QQ_v, M^*) -> QQ slash ZZ$ a perfect pairing, and $cal(L)^perp = {L_v^perp}$
  is a Selmer structure for $M^*$. When $M$ is *self-dual* --- as $E[n]$ is, by the Weil pairing ---
  the local conditions live in a metabolic space and the Kummer images $L_v$ are *maximal isotropic*.

  #v(1.5mm)
  *(F3) Functoriality.* A morphism of modules carries Selmer structures to Selmer structures. This is
  what lets a statement about one curve become a statement about another.
]

The first thing to notice is that (F2) already dictates the *size* of the classical local condition
with no reference to the curve --- which is Lemma B$'$ of the companion note, and the reason the
comparison there is only ever about *which* subspace, never about how big.

= Application 1: descent is finite because the conditions are local <sec-descent>

The oldest application, and the one everything else is built on. Mordell--Weil gives no algorithm;
the exact sequence
$ 0 -> E(QQ) slash n E(QQ) -> "Sel"_n (E) -> Ш(E)[n] -> 0 $
does, because the middle term is cut out by conditions that can each be checked over a single
$QQ_v$. *Rank bounds are computable; ranks are not.* Every `ellrank`, every `mwrank`, every
2-descent in the companion note is this observation.

What is worth saying is how far the consequence reaches. Because $"Sel"_n$ is defined by local
conditions, it is amenable to *counting* in a way $E(QQ)$ is not: a Selmer element is a local datum,
and local data can be parametrised by lattice points in a fundamental domain.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Theorem* (Bhargava--Shankar, #link("https://arxiv.org/abs/1006.1002")[arXiv:1006.1002],
  #link("https://annals.math.princeton.edu/wp-content/uploads/annals-v181-n1-p03-p.pdf")[Annals *181* (2015) 191--242])*.*
  When elliptic curves over $QQ$ are ordered by height, the average size of $"Sel"_2 (E)$ is exactly
  $3$. Consequently the average rank is at most $3 slash 2$.
]

The mechanism is exactly (F1): a 2-Selmer element is a binary quartic form with prescribed
invariants and local solubility everywhere, so the average is a volume computation with a congruence
condition at each place. The same method gives average $"Sel"_3 = 4$, $"Sel"_5 = 6$
(#link("https://arxiv.org/abs/1312.7859")[arXiv:1312.7859]), average rank $< 0.885$, and a positive
proportion of curves of rank $0$ and of rank $1$ satisfying Birch--Swinnerton-Dyer. None of this is
available for $E(QQ)$ directly. It is available for $"Sel"_n$ *because* the definition is a list of
local conditions.

= Application 2: the comparison formula <sec-gw>

If (F1) is why Selmer groups are computable, the following is why they are *usable*. It is the
single most-quoted consequence of the formalism, and it is a global statement whose right-hand side
is entirely local.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Theorem (Greenberg--Wiles).* Let $M$ be a finite $G_QQ$-module, $M^*$ its Cartier dual,
  $cal(L)$ a Selmer structure and $cal(L)^perp$ its dual. Then
  $ (\# "Sel"(M, cal(L))) / (\# "Sel"(M^*, cal(L)^perp))
    = (\# H^0 (QQ, M)) / (\# H^0 (QQ, M^*)) dot product_v (\# L_v) / (\# H^0 (QQ_v, M)) , $
  the product over all places, almost all factors being $1$.
]

Read it as: *the difference between a Selmer group and its dual is a sum of local terms.* One does
not need to know either side to know their ratio. Four uses, in increasing order of ambition.

== Descent by isogeny <sec-gw-isog>

Take $phi : E -> E'$ an isogeny with dual $hat(phi)$, and $M = E[phi]$, so $M^* = E'[hat(phi)]$ by
the Weil pairing. With the Kummer local conditions on both sides, Greenberg--Wiles becomes the
classical formula of Cassels comparing $"Sel"^phi (E)$ with $"Sel"^(hat(phi)) (E')$ as a product of
local indices $\# (E'(QQ_v) slash phi E(QQ_v))$. This is how descent by 2-isogeny is *organised*:
one computes each local index --- a Tamagawa-number-sized quantity --- and reads off the difference
of the two Selmer ranks. It is the route to the classical results on the congruent number curve
$y^2 = x^3 - n^2 x$, where the local indices are the entries of Monsky's matrix and the whole
2-descent becomes a rank computation over $bb(F)_2$.

== Parity, without computing either side <sec-gw-parity>

When $M$ is self-dual and $cal(L)$, $cal(L)'$ are both self-dual Selmer structures, the formula
degenerates to the congruence used at the end of the companion note:
$ dim "Sel"(cal(L)) equiv dim "Sel"(cal(L)') + sum_v dim (L_v slash (L_v inter L'_v)) quad (mod 2) . $
Two maximal isotropic subspaces of a metabolic space meet in something of predictable parity; that
is all this is. It is weak --- it sees only the sum mod 2 --- but it is *unconditional and local*,
and it is the reason parity results are so much easier than rank results (@sec-parity).

== Changing the condition at one place <sec-gw-one>

This is the operational heart of the subject. Suppose $cal(L) subset.eq cal(L)'$ differ only at a
single place $q$. Poitou--Tate global duality gives an exact sequence
$ 0 -> "Sel"(M, cal(L)) -> "Sel"(M, cal(L)') -> L'_q slash L_q
  -> "Sel"(M^*, cal(L)^perp)^or -> "Sel"(M^*, cal(L)'^perp)^or -> 0 . $

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *What this is for.* Relaxing the condition at $q$ can only *grow* the Selmer group, and it grows by
  an amount governed by the *dual* Selmer group. So: if you can produce a global class that is
  locally trivial everywhere except at $q$, where it is non-trivial, the sequence forces the dual
  Selmer group to *shrink*. That is the entire strategy of Euler systems, of Ribet's converse to
  Herbrand, and of level-raising. One manufactures global classes with prescribed local behaviour,
  and duality converts them into upper bounds.
]

== The class-group face <sec-gw-class>

Take $M = mu_p$ and $M^* = ZZ slash p$ with everywhere-unramified conditions. Then
$"Sel"(mu_p, "ur")$ is the $p$-Selmer group of the ring of integers --- units modulo $p$-th powers,
extended by $"Cl"(K)[p]$ --- while $"Sel"(ZZ slash p, "ur")$ is $"Hom"("Cl"(K), ZZ slash p)$, the
everywhere-unramified $ZZ slash p$-extensions. Greenberg--Wiles then relates the $p$-rank of the
class group to the $p$-rank of the unit group, with the local terms sitting at $v | p$ and $v |
infinity$; the archimedean factors are Dirichlet's unit theorem in disguise, and the resulting
inequalities are the reflection principles of Scholz and Leopoldt. It is worth doing once: the same
formula that runs 2-descent also runs genus theory.

= Application 3: bounding Ш --- Euler systems <sec-euler>

Selmer groups are upper bounds for ranks; the hard direction is bounding them from *above*, which
means proving Ш is small. The only known general mechanism is @sec-gw-one, applied with global
classes that come from geometry.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Kolyvagin's theorem.* If $E slash QQ$ is modular and the Heegner point $y_K$ has infinite order,
  then $"rank" E(QQ) = 1$ and $Ш(E)$ is finite. Combined with Gross--Zagier: if
  $"ord"_(s=1) L(E, s) <= 1$ then the analytic rank equals the algebraic rank and $Ш$ is finite.
]

The proof is @sec-gw-one run infinitely often. Kolyvagin builds, from Heegner points over ring class
fields, a system of *derived classes* $c(n) in H^1(K, E[p^k])$ indexed by squarefree products of
"Kolyvagin primes" $ell$, each of which is *locally in the Selmer condition at every place except at
the $ell | n$*, where its localisation is computable and non-zero. Feeding these into the duality
sequence one place at a time bounds the Selmer group by the index of the Heegner point. The primes
$ell$ are chosen by Chebotarev precisely so that the local condition at $ell$ *can be moved*.

The same architecture, with different classes:

- *Rubin* (#link("https://link.springer.com/article/10.1007/BF01231285")[Invent. *103* (1991)]): elliptic units, giving the main conjecture of Iwasawa theory for imaginary quadratic fields, hence the finiteness of Ш for CM curves of analytic rank 0 --- this is the input the note on Ш at the Fermat primes uses.
- *Kato*: Beilinson elements in $K_2$ of modular curves, giving that $L(E,1) != 0 arrow.r.double "Sel"_(p^infinity)(E)$ finite, for all modular $E$ and almost all $p$.
- *Skinner--Urban*: the converse divisibility, via Eisenstein congruences on $"GU"(2,2)$; with Kato this yields the $p$-part of BSD in analytic rank 0 for a large class of curves.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  In all four cases the theorem being proved is about $L$-functions and rational points; the
  *mechanism* is the movement of one local condition at a time, and the duality sequence that
  converts a local non-vanishing into a global bound.
]

= Application 4: parity is local <sec-parity>

Because the Kummer conditions are maximal isotropic (F2), the *parity* of a Selmer rank is a sum of
local invariants, and can be computed with no global information at all. This is the cheapest thing
local conditions give, and the source of some of the most quotable theorems.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *$p$-parity theorem* (Nekovář; Dokchitser--Dokchitser,
  #link("https://arxiv.org/abs/0709.2852")[Invent. *178* (2009)])*.* For $E slash QQ$ and any prime
  $p$,
  $ (-1)^(dim "Sel"_(p^infinity) (E)) = w(E) , $
  the global root number, itself a product of local root numbers $w_v$.
]

So the parity half of Birch--Swinnerton-Dyer is a *theorem*, and it is a theorem because both sides
factor over places. The Dokchitsers' technique --- *regulator constants* --- is worth knowing as a
method: one compares a Selmer group over $QQ$ with its behaviour in a $G$-extension, and Brauer
relations among the subgroups of $G$ turn the comparison into a product of local terms. The
by-product, "BSD modulo squares"
(#link("https://annals.math.princeton.edu/2010/172-1/p12")[Annals *172* (2010)]), constrains the
Birch--Swinnerton-Dyer quotient by purely local data.

An older, more elementary instance of the same idea, and the one closest to the companion note:

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Kramer* (#link("https://www.ams.org/journals/tran/1981-264-01/S0002-9947-1981-0597871-8/")[Trans. AMS *264* (1981)])*.*
  For $E slash QQ$ and $K = QQ(sqrt(d))$, $dim "Sel"_2 (E slash K)$ is expressed through local norm
  indices $E(QQ_v) slash N_(K_w slash QQ_v) E(K_w)$; in particular the 2-Selmer ranks of $E$ and its
  quadratic twist $E^d$ are related by an explicit sum of local terms.
]

That is the general theorem of which the situation in the companion note is a very rigid special
case: there, the twist is by $-1$, ramified only at $2$ and $infinity$, and the local terms are shown
to vanish one by one rather than merely in aggregate.

= Application 5: statistics --- local conditions as random Lagrangians <sec-stats>

If a Selmer group is the intersection of a global subspace with a product of local Lagrangians, then
*modelling the local conditions as random* should predict Selmer statistics. It does, spectacularly.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Poonen--Rains* (#link("https://arxiv.org/abs/1009.0287")[arXiv:1009.0287], JAMS *25* (2012)
  245--269)*.* The $p$-Selmer group of $E$ is naturally the intersection of a discrete maximal
  isotropic subspace with a compact open maximal isotropic subspace in a locally compact quadratic
  space over $bb(F)_p$. Modelling the first as random predicts that the $m$-th moment of
  $\# "Sel"_p$ is $product_(i=1)^m (p^i + 1)$; in particular the average is $p + 1$.
]

For $p = 2$ that is the average $3$ of Bhargava--Shankar --- proved independently, and matching. The
model also reproduces Heath-Brown's and Kane's theorems on 2-Selmer distributions in quadratic twist
families. *The heuristic is a heuristic about local conditions and nothing else.*

Once one thinks this way, the behaviour of Selmer ranks *along a twist family* becomes a question
about how the Lagrangians move.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Klagsbrun--Mazur--Rubin* (#link("https://annals.math.princeton.edu/wp-content/uploads/annals-v178-n1-p05-p.pdf")[Annals *178* (2013) 287--320];
  #link("https://arxiv.org/abs/1303.6507")[Compositio *150* (2014) 1077--1106])*.* In the family of
  quadratic twists of a fixed $E slash K$, the proportion of twists with *even* 2-Selmer rank exists
  and equals an explicit product of local factors --- the *disparity* $delta(E, K)$; and the
  distribution of 2-Selmer ranks is governed by a *Markov chain*, in which adjoining one more prime
  to the twisting parameter moves the rank by $plus.minus 1$ with computable probabilities.
]

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *This is the frame the companion note's even-$a$ table belongs in.* Adjoining the prime $2$ to the
  twisting parameter moves one Lagrangian at one place, and a single moved place changes the Selmer
  rank by exactly $0$ or $1$. The observed "$14$ of $16$ even $a$ differ by exactly $1$" is not a
  curiosity: it is the generic outcome of a single-place discrepancy, and its *absence* for odd $a$
  is what the theorem there proves.
]

The deepest current result in this direction removes the heuristic entirely.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *A. Smith* (#link("https://arxiv.org/abs/1702.02325")[arXiv:1702.02325])*.* Let $E slash QQ$ have
  full rational 2-torsion and no rational cyclic subgroup of order 4. Then the $2^infinity$-Selmer
  groups of the quadratic twists of $E$ are distributed as Delaunay's heuristic predicts; in
  particular $100%$ of twists have rank $0$ or $1$ (Goldfeld's conjecture for the family), and the
  number with rank $>= 2$ among $|d| < N$ is $o(N)$.

  #v(2mm)
  *Corollary.* The congruent numbers of the form $1, 2, 3$ modulo $8$ have natural density zero.
]

A statement about right triangles with rational sides, proved by controlling how local conditions at
the primes of $d$ interact as $d$ varies. If one wants a single answer to "why are local Selmer
conditions useful", this is a good one.

= Application 6: local conditions as *definitions* --- deformations and Bloch--Kato <sec-defo>

So far the local conditions came from a curve. The formalism's real reach is that one may *impose*
them, and thereby define objects that have no elementary description.

== Deformation theory <sec-defo-def>

Let $overline(rho) : G_QQ -> "GL"_2(bb(F)_p)$ be residually irreducible. The tangent space to the
functor of deformations of $overline(rho)$ with prescribed behaviour at each place --- unramified
outside $Sigma$, ordinary at $p$, of fixed type at $ell in Sigma$ --- is *a Selmer group*
$ H^1_(cal(L)_Sigma) (QQ, "ad"^0 overline(rho)) , $
where $cal(L)_Sigma$ is precisely the list of local deformation conditions. Wiles's numerical
criterion for $R = TT$ compares two such Selmer groups differing at finitely many places, and the
comparison is made by Greenberg--Wiles (@sec-gw): the local terms are exactly the Euler factors that
appear in the change of level. *Level-raising and level-lowering are changes of local condition.*
Ribet's converse to Herbrand's theorem is the same move in the abelian case: a non-zero Selmer class
is an unramified extension, and it is constructed by congruence.

== Bloch--Kato <sec-defo-bk>

For a $p$-adic representation $V$, there is no Kummer map to define $L_v$ with. Bloch and Kato
supply one:
$ H^1_f (QQ_p, V) = ker (H^1(QQ_p, V) -> H^1(QQ_p, V ⊗ B_"cris")) , $
with $H^1_"ur"$ at $v != p$, and variants $H^1_e subset.eq H^1_f subset.eq H^1_g$. The resulting
$"Sel"_f (V)$ is *conjecturally* the object whose dimension is the order of vanishing of the
$L$-function of the motive. Every modern formulation of a Birch--Swinnerton-Dyer-type conjecture is
a statement about a Selmer group defined this way.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  Mazur and Rubin remark, in the paper of @sec-companion, that most of what they do "applies more
  generally to the Bloch--Kato Selmer groups attached to a motive", and that *"the subtlest problem
  in the general case, as in the case of elliptic curves, is to understand the local condition at
  $p$"*. That is worth underlining, since it is exactly where the companion note's proof spends all
  of its effort: at $v = 2$, for $p = 2$.
]

= Application 7: consequences that do not look like Selmer theory <sec-diophantine>

Two results where the local conditions are the *tool* and the conclusion is in another subject
entirely.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Mazur--Rubin* (#link("https://arxiv.org/abs/0904.3709")[Invent. *181* (2010) 541--575])*.* By
  controlling how the 2-Selmer rank changes when the twisting parameter acquires one more prime, one
  produces, over suitable number fields $K$, quadratic twists of prescribed 2-Selmer rank --- in
  particular many twists with $"Sel"_2 = 0$, hence rank $0$ and trivial Mordell--Weil group.

  #v(2mm)
  *Consequence.* Hilbert's tenth problem has a negative answer over the ring of integers of every
  number field $K$ admitting such a curve: an elliptic curve of rank $1$ over $QQ$ that keeps rank
  $1$ over $K$ gives a diophantine model of $ZZ$ in $cal(O)_K$.
]

The undecidability of a class of diophantine problems, obtained by moving a local condition at a
finite prime. The companion result, *Diophantine stability*
(#link("https://arxiv.org/abs/1503.04642")[Mazur--Rubin, 2018]), shows in the same way that
$E(K) = E(QQ)$ for many extensions $K$ --- rank does not grow --- which is again a statement that
certain local conditions do not move.

= Where the involution theorem sits: Selmer companions <sec-companion>

The companion note proves that two *non-isogenous* curves have *equal* 2-Selmer groups, and it does
so by the exact route (F3) predicts: identify the modules, then compare local conditions. There is a
literature that names this phenomenon, and the note's theorem turns out to sit just outside it.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Definition* (Mazur--Rubin, #link("https://arxiv.org/abs/1203.0620")[arXiv:1203.0620])*.* Two
  elliptic curves $E_1, E_2$ over $K$ are *$n$-Selmer companions* if for every quadratic character
  $chi$ of $K$ there is an isomorphism $"Sel"_n (E_1^chi slash K) tilde.equiv "Sel"_n (E_2^chi slash K)$.
]

Their sufficient criterion is the exact analogue of the note's Theorem A plus $(star)$, with the
local work concentrated at the potentially multiplicative places:

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Theorem 3.1* (Mazur--Rubin)*.* Let $S_i$ be the set of primes where $E_i$ has potentially
  multiplicative reduction, and let $m = p^(k+1)$ if $p <= 3$, $m = p^k$ if $p > 3$. Suppose

  #v(1mm)
  #set enum(numbering: "(i)")
  + there is a $G_K$-isomorphism $E_1 [m] tilde.equiv E_2 [m]$;
  + $S_1 = S_2$;
  + for all $frak(l) in S_1$, the isomorphism sends $C_(E_1 slash K_frak(l))[m]$ to $C_(E_2 slash K_frak(l))[m]$;
  + for every $frak(p) | p$, either $frak(p) in S_1$, or $k = 1$, both curves have good reduction at
    $frak(p)$, and $e(frak(p) slash p) < p - 1$.

  #v(1mm)
  Then $"Sel"_(p^k) (E_1^chi slash F) tilde.equiv "Sel"_(p^k) (E_2^chi slash F)$ for every finite
  $F slash K$ and every $chi$ --- and in fact the two groups are *equal* inside the common
  $H^1(F, E_1^chi [p^k])$.
]

Here $C_(E slash K_frak(l))[m] = tau_(E slash K_frak(l))(mu_m)$ is the *canonical subgroup* cut out
by the Tate parametrisation --- the same object the survey calls $C_"can"(v)$, and Mazur--Rubin's
Lemma 2.5 (if $p divides.not "ord"_frak(l) (j(E_1))$, every $G$-isomorphism $E_1[p^k] tilde.equiv
E_2[p^k]$ automatically matches the canonical subgroups) is the structural reason the survey's
recipe can read the local condition off reduction data alone.

== The criterion does not reach $y^2 = x^3 + a$ <sec-companion-gap>

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  Apply Theorem 3.1 with $p = 2$, $k = 1$ to $E_a$ and $E_(-1 slash a)$. Both have $j = 0$, hence
  *potentially good reduction everywhere*, so $S_1 = S_2 = emptyset$ and hypothesis (ii) holds
  vacuously, (iii) is empty --- and (iv) *fails*: at $frak(p) = 2$ we are not in $S_1$, and the
  alternative demands $e(frak(p) slash 2) < p - 1 = 1$, which no place satisfies. Independently,
  (i) would demand $E_a [4] tilde.equiv E_(-1 slash a)[4]$, whereas Theorem A supplies the
  isomorphism only on $E[2]$.

  #v(2mm)
  *So the theorem of the companion note is a companion-type result for a pair the known criterion
  cannot reach, and it fails to reach it at exactly the place where the note's proof does all its
  work.* The exhaustive check over $a$ mod $8$ is not a shortcut around a general argument; it is
  standing in for the one hypothesis the literature also cannot dispose of.
]

== What the note actually proves, in this vocabulary <sec-companion-what>

Twisting $E_a$ by $d$ gives $E_(a d^3)$, and the involution commutes with it:
$-1 slash (a d^3) equiv (-1 slash a) d^3$ modulo sixth powers. So the note's theorem, applied to the
odd integer $a d^3$, says:

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Observation.* For $a$ odd, $E_a$ and $E_(-1 slash a)$ are 2-Selmer companions *along every
  quadratic character unramified at 2*: for every odd squarefree $d$,
  $ "Sel"_2 (E_a^((d))) = "Sel"_2 (E_(-1 slash a)^((d))) $
  as subgroups of one $H^1(QQ, M)$. The even-$a$ table is the statement that companionship *fails*
  for $chi$ ramified at $2$, and the failure is by the single step $plus.minus 1$ that one moved
  place permits.
]

That is a slightly stronger and more standard-sounding form of the same theorem, and it says
precisely which characters are allowed. It also explains why the note's Theorem B is the right
structural remark: the involution is the quadratic twist by $-1$ composed with a cubic twist, and
$chi_(-1)$ is ramified only at $2$ and $infinity$.

== And the converse holds <sec-companion-converse>

Finally, a theorem which says that Theorem A was not merely *an* explanation of the correlation but
the *only* possible one.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Yu* (#link("https://arxiv.org/abs/1610.01195")[arXiv:1610.01195])*.* Let $E, A$ be elliptic
  curves over a number field $K$. If $ | dim "Sel"_2 (E^chi) - dim "Sel"_2 (A^chi) | $ is bounded
  independently of $chi$, then there is a $G_K$-isomorphism $E[2] tilde.equiv A[2]$.
]

This settles, in the affirmative, the question the companion note opens with. The 2-Selmer ranks of
$y^2 = x^3 + a$ and $y^2 = x^3 - a^(-1)$ track each other to within $1$ across the whole twist
family; by Yu's theorem that *forces* the mod-2 modules to be isomorphic. Theorem A exhibits the
isomorphism explicitly, but its existence was already implied by the numerics.

= Summary <sec-summary>

#align(center, table(
  columns: 3, align: (left, left, left),
  stroke: 0.4pt + luma(170), inset: (x: 7pt, y: 4pt),
  table.header([what local conditions buy], [because], [flagship]),
  [descent is an algorithm],
    [finitely many local questions (F1)],
    [Bhargava--Shankar: mean $\#"Sel"_2 = 3$],
  [Selmer groups can be *compared*],
    [Greenberg--Wiles is a product over $v$],
    [Cassels' isogeny formula; 2-descent],
  [Ш can be bounded above],
    [move one condition, use duality],
    [Kolyvagin; Kato; Skinner--Urban],
  [parity is unconditional],
    [self-duality $=>$ Lagrangians (F2)],
    [$p$-parity theorem; BSD mod squares],
  [Selmer *statistics* exist],
    [random maximal isotropic model],
    [Poonen--Rains; Smith; Goldfeld],
  [objects can be *defined* by conditions],
    [no Kummer map needed],
    [Bloch--Kato; $R = TT$; level-raising],
  [transfers between curves],
    [functoriality (F3)],
    [Selmer companions],
))

#v(3mm)

*Where the companion note lives.* Rows 2, 4 and 7. Its Theorem A is a functoriality statement (F3);
its Lemma B$'$ is (F2) in the sharp form "the dimension of $L_v$ is an invariant of the module";
its $(star)$ is a companion-type comparison stronger than the parity consequence of
Greenberg--Wiles that row 4 would give; and its one computational input is the local condition at
$p = 2$ for $p = 2$, which is where the general theory also stops.

*The one open question it suggests.* Mazur--Rubin's Theorem 3.1 needs potentially multiplicative
reduction at $2$ precisely because the Tate parametrisation is what makes the local condition at $2$
legible. For a curve with $j = 0$ there is no such parametrisation, and the note's answer at $v = 2$
is a finite enumeration. A criterion for $2$-Selmer companionship at potentially *good* reduction
--- some CM-theoretic substitute for the canonical subgroup --- would both prove the note's theorem
by hand and extend Theorem 3.1 in the direction its authors flag as the subtle one.

= Reading list <sec-reading>

#set enum(numbering: "[1]")
+ B. Mazur, K. Rubin, *Kolyvagin systems*, Memoirs AMS *168* (2004). The reference for the Selmer
  structure formalism; Chapter 1 is the definition and the duality sequence of @sec-gw-one.
+ K. Rubin, *Euler systems*, Annals of Math. Studies *147* (2000). Local conditions as a technique,
  from the ground up; Chapter I is the best short account of (F1)--(F3).
+ H. Darmon, F. Diamond, R. Taylor, *Fermat's Last Theorem*, §2. Greenberg--Wiles stated and proved,
  in the deformation-theoretic context that motivates it.
+ J. Neukirch, A. Schmidt, K. Wingberg, *Cohomology of Number Fields*, §8.6--8.7. Poitou--Tate and
  the general comparison formula, in the generality of @sec-gw-class.
+ B. Poonen, #link("https://math.mit.edu/~poonen/papers/aws2014.pdf")[*Selmer group heuristics and sieves*]
  (AWS 2014 notes). The Lagrangian picture of @sec-stats, informally.
+ B. Mazur, K. Rubin, #link("https://arxiv.org/abs/1203.0620")[*Selmer companion curves*] (2012).
  The paper of @sec-companion.
