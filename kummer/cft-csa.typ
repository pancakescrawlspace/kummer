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
  #text(size: 16pt, weight: "bold")[Class field theory through central simple algebras]
  #v(2mm)
  #text(size: 10pt)[A road map: what the steps are, which one carries the weight,
  and what the algebras buy that the cohomology does not]
  #v(1mm)
  #text(size: 9pt, style: "italic")[a question of René Pannekoek's; checks in `cft-csa.gp`]
]

#v(4mm)

#block(fill: luma(240), inset: 9pt, radius: 3pt, width: 100%)[
  *Summary.* One object carries the whole theory: $"Br"(F)$, central simple algebras up to
  Morita equivalence. Local class field theory is the *computation* of $"Br"(F)$ for $F$ local
  (@sec-local); global class field theory is the exact sequence relating $"Br"(K)$ to the
  $"Br"(K_v)$ (@sec-global); and Artin reciprocity is *exactness in the middle* of that sequence
  (@sec-recip). The reason to do it this way is @sec-crossed: a $2$-cocycle is not an abstract
  gadget but the *multiplication table* of an algebra, and the cocycle identity is not imposed ---
  it is what associativity forces. Compatibilities that one would otherwise take on faith become
  computations one can run, and check 1 of the companion script runs the central one exhaustively.

  #v(1.5mm)
  *And one honest caveat*, stated in @sec-hard: the algebras buy meaning and computability
  everywhere, and buy *nothing* on the two norm-index inequalities, which remain the hard core.
]

= Central simple algebras and the Brauer group <sec-csa>

$A$ is a *central simple algebra* over $F$ if it is finite-dimensional, simple, with centre exactly
$F$. Two facts do all the work.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Wedderburn.* $A tilde.equiv M_n (D)$ with $D$ a division algebra over $F$, and $D$ is unique up
  to isomorphism.

  #v(1.5mm)
  *Base change.* $A ⊗_F overline(F) tilde.equiv M_N (overline(F))$. In particular $dim_F A$ is a
  square, say $n^2$, and $n = deg A$.
]

#v(2mm)
Declare $A tilde B$ when $D_A tilde.equiv D_B$. Then $⊗_F$ makes the classes into a group
$"Br"(F)$, with the inverse of $[A]$ given by the *opposite* algebra:
$ A ⊗_F A^"op" tilde.equiv "End"_F (A), wide a ⊗ b |-> (x |-> a x b) . $
That isomorphism is written down, not invoked --- the first sign of what this approach is like.
Base change $A |-> A ⊗_F L$ gives $"Br"(F) -> "Br"(L)$, whose kernel $"Br"(L slash F)$ is the set of
classes *split by* $L$.

= Crossed products: where the cocycle comes from <sec-crossed>

This is the step that justifies the whole approach. Fix $L slash F$ Galois with group $G$, and build
an algebra by hand: take a copy of $L$ for each $sigma in G$, and force the twisting.

$ A = ⊕_(sigma in G) L thin u_sigma, wide
  u_sigma x = sigma(x) thin u_sigma quad (x in L), wide
  u_sigma u_tau = c(sigma, tau) thin u_(sigma tau) $

for some function $c : G times G -> L^times$. Now *ask that $A$ be a ring* --- impose
$(u_sigma u_tau) u_rho = u_sigma (u_tau u_rho)$. Expanding both sides gives
$ sigma(c(tau, rho)) thin c(sigma, tau rho) = c(sigma, tau) thin c(sigma tau, rho) , $
which *is* the $2$-cocycle condition. It was not assumed; it is what associativity means. Rescaling
$u_sigma |-> a_sigma u_sigma$ replaces $c$ by a cohomologous cochain, and one gets

$ "Br"(L slash F) tilde.equiv H^2 (G, L^times) . $

#block(fill: rgb("#fff4e6"), inset: 8pt, radius: 3pt, width: 100%)[
  *This is the answer to the objection.* $H^2$ is still there, but it now has a meaning: a class is
  a multiplication table modulo renaming basis vectors. Check 1 verifies the equivalence
  *exhaustively*: over $L = QQ(i)$ with $G$ of order $2$, of all $256$ cochains with values in
  ${1, -1, 2, i}$, exactly $9$ satisfy the cocycle condition and exactly the same $9$ give an
  associative algebra --- $0$ disagreements. The identity above is not quoted; it is exhibited.
]

#v(2mm)
The workhorse is the cyclic case $G = ⟨sigma⟩$ of order $n$, where one may take
$c(sigma^i, sigma^j) = 1$ if $i + j < n$ and $= b$ otherwise. The resulting *cyclic algebra* is
$ (L slash F, sigma, b) = ⊕_(i < n) L thin u^i, wide u^n = b in F^times, wide
  u x = sigma(x) u . $
Two facts, both provable by direct manipulation:
- $(L slash F, sigma, b)$ *splits* $arrow.l.r.double$ $b in N_(L slash F)(L^times)$;
- $(L slash F, sigma, b) ⊗ (L slash F, sigma, b') tilde (L slash F, sigma, b b')$.

So $F^times slash N_(L slash F)(L^times) arrow.hook "Br"(L slash F)$, and *norms have entered
without anyone saying the word cohomology*.

#block(fill: rgb("#fff4e6"), inset: 8pt, radius: 3pt, width: 100%)[
  *A trap worth recording,* because the script fell into it. A crossed product needs $sigma$ to be a
  genuine automorphism *of the right order*; feed it anything else and the algebra is silently
  non-associative. The cyclic cubic with $sigma : y |-> y^2 - 2$ is $y^3 - 3y + 1$, *not*
  $y^3 - 3y - 1$ --- both have discriminant $81$ and both are cyclic, but $y |-> y^2 - 2$ permutes
  the roots of only the first. Check 2 now verifies that $sigma$ is an automorphism and that its
  order is exactly $n$ before building anything. PARI's `alginit` accepted the bad pair without
  complaint.
]

= Local fields: the invariant is a valuation <sec-local>

Let $F$ be local nonarchimedean. The structural input is:

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  Every division algebra over $F$ contains an *unramified* maximal subfield.
]

#v(2mm)
So $"Br"(F) = union.big_n "Br"(F_n slash F)$ over the unramified $F_n$, and *every class is
cyclic*. Take $L slash F$ unramified of degree $n$ and $sigma = "Frob"$. Units are norms in the
unramified case, so $N_(L slash F)(L^times) = {x : n divides v_F (x)}$, and the class of
$(L slash F, sigma, b)$ depends only on $v_F (b) mod n$. Define

$ "inv"_F ((L slash F, sigma, b)) = v_F (b) slash n in (1 slash n) ZZ slash ZZ, wide
  "inv"_F : "Br"(F) tilde.equiv QQ slash ZZ . $

with $"Br"(RR) = {1, HH} tilde.equiv (1 slash 2) ZZ slash ZZ$ and $"Br"(CC) = 0$. For quaternion
algebras this is a statement one can simply check: $(u,b)_p = (-1)^(v_p (b))$ for $u$ a non-residue
mod $p$, which is $"inv" = v_p (b) slash 2$ written multiplicatively. Check 4 does so at six primes
over $480$ symbols, $0$ mismatches.

The one compatibility that must be *proved* is
$ "inv"_E (A ⊗_F E) = [E : F] dot "inv"_F (A) , $
and here it is a computation with $e$ and $f$, not a diagram. Its sharpest visible consequence: a
quaternion algebra stays ramified at $P$ exactly when the local degree $[K_P : QQ_p]$ is *odd*.
Check 5 tests that prediction over fields of degree $2, 3, 4$ at every prime above every ramified
place, $0$ mismatches.

= Local class field theory <sec-lcft>

For $L slash F$ cyclic of degree $n$, @sec-crossed and @sec-local combine to give
$ F^times slash N_(L slash F) L^times tilde.equiv "Br"(L slash F) = (1 slash n) ZZ slash ZZ
  tilde.equiv ZZ slash n , $
the local norm index, on the nose. For $L slash F$ abelian the local Artin map is then *defined* by
invariants: for $chi in "Hom"("Gal"(L slash F), QQ slash ZZ)$,
$ chi(theta_F (b)) = "inv"_F (chi union b) , $
where $chi union b$ is concretely the cyclic algebra attached to $chi$'s cyclic extension and to
$b$. Existence and uniqueness of norm groups follow.

= The global exact sequence <sec-global>

For $K$ a number field, everything is in one sequence:

#block(fill: luma(243), inset: 9pt, radius: 3pt, width: 100%)[
  $ 0 --> "Br"(K) --> ⊕_v "Br"(K_v) -->^(sum_v "inv"_v) QQ slash ZZ --> 0 $
]

#v(2mm)
- *Injectivity* is the Albert--Brauer--Hasse--Noether theorem: split everywhere locally $arrow.r.double$ split.
- *Exactness in the middle*, $sum_v "inv"_v (A) = 0$, is Artin reciprocity.
- *Surjectivity* is the easy end: invariants may be prescribed subject only to summing to zero.

Check 3 is ABHN for quaternions, by two routes sharing no code: $(a,b)$ has index $1$ over $QQ$
exactly when $b$ is a global norm from $QQ(sqrt(a))$ (via `bnfisnorm`) and exactly when every local
Hilbert symbol is $+1$. Check 7 is surjectivity, made constructive --- for each even set of places
a quaternion algebra ramified there and nowhere else:

#align(center, table(
  columns: 4, align: (center, center, center, center),
  stroke: 0.4pt + luma(170), inset: (x: 9pt, y: 3.5pt),
  table.header([ramified at], [${infinity, 2}$], [${2,3}$], [${infinity,2,3,5}$]),
  [algebra], [$(-1,-1)$], [$(-1,3)$], [$(-3,-10)$],
))

#v(2mm)
The first is Hamilton's quaternions, recovered as the unique algebra ramified exactly at
$infinity$ and $2$.

= Where the real work is <sec-hard>

I should be straight about this. The CSA formulation makes the objects and the maps concrete, but
it does not dissolve the hard core. Proving ABHN needs:

+ a reduction showing every class is split by a *cyclic cyclotomic* extension;
+ the *Hasse norm theorem* for cyclic $L slash K$: a global element is a norm iff it is a local norm
  everywhere;
+ underneath both, the two inequalities bounding the norm index
  $[I_K : K^times N_(L slash K) I_L]$ by $n$ from each side. One is analytic --- Dirichlet
  $L$-functions, or a density argument. The other is algebraic: a Herbrand-quotient computation
  resting on Dirichlet's unit theorem.

Step 1 is where the *Grunwald--Wang* phenomenon lives, and it is not a technicality. The naive
local--global principle for $n$-th powers is false. Check 8 verifies Wang's counterexample:
$16$ is an $8$th power in $QQ_p$ for every one of the $45$ odd primes $p < 200$, and in $RR$ ---
but *not* in $QQ_2$, where $v_2 (16) = 4 in.not 8 ZZ$, and not in $QQ$. So $16$ is an $8$th power at
every place but one and yet not globally, and $8 divides n$ at the prime $2$ is exactly where the
reduction has to be repaired.

= Reciprocity, and an instance already in this repository <sec-recip>

Once $sum_v "inv"_v = 0$ is known, $theta_K = product_v theta_(K_v)$ kills $K^times$ and descends to
$theta_K : bb(A)_K^times slash K^times -> "Gal"(L slash K)^"ab"$.

The smallest non-trivial case is one this repository has already computed. A quaternion algebra
$(a,b)_F$ is the cyclic algebra for $F(sqrt(a)) slash F$, and its local invariant is $0$ or
$(1 slash 2)$ according to the *Hilbert symbol* $(a,b)_v$. So

$ sum_v "inv"_v = 0 quad arrow.l.r.double quad product_v (a,b)_v = +1 , $

which is Hilbert reciprocity, and quadratic reciprocity after unwinding. Check 6 verifies it on
$396$ random pairs with $abs(a), abs(b) < 200$, $0$ failures. And check 7 of `plusminus-beta.gp`
verifies the *same product formula* on genuine global points of $y^2 = x^3 minus.plus c^3$: the
pairing $beta_v$ there is a sum of local invariants, and the reason it must vanish on rational
points is precisely this section. The Brauer--Manin obstruction is this exact sequence used in
anger.

= Where this route came from <sec-history>

The choice made in this note is not a stylistic one. Working through algebras is the *historical*
solution to a specific defect, and the defect is exactly the one a reader is likely to worry about.

#block(fill: luma(243), inset: 9pt, radius: 3pt, width: 100%)[
  *The first local class field theory was a corollary of the global one.* Hasse and F. K. Schmidt
  (1930) obtained it as follows. Given an abelian $E slash F$ of local fields with
  $"char" F = 0$, write $F = K_v$ for a number field $K$ --- every characteristic-zero local field
  contains a dense number field, in many ways. Takagi's theory supplies an abelian $L slash K$ with
  $E = L dot K_v$, and the *global* Artin map for $L slash K$, restricted to $K_v^times$, defines
  the local one. One then checks independence of the choice of $L$.
]

#v(2mm)
Emmy Noether objected to the order of business: there ought to be a self-contained derivation of the
local theory, with the global theory derived *from it*. F. K. Schmidt announced a local development
for tamely ramified extensions in 1930 but never published it.

The obstruction is sharp, and it is worth naming because it explains why the fix took three years
rather than three weeks. For an *unramified* extension there is no difficulty: Frobenius is sitting
there, and the local Artin map is obvious. It is the *ramified* abelian extensions where nothing
tells you what the Artin symbol ought to be.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *What broke the deadlock was noncommutative algebra.* Two steps.

  #v(1.5mm)
  *Hasse (1931).* Every cyclic algebra over a characteristic-zero local field $F$, of dimension
  $n^2$, can be normalised as
  $ (F_n slash F, "Frob", pi^a) $
  with $F_n slash F$ *unramified* of degree $n$ and $pi$ a prime of $F$. Since
  $N_(F_n slash F)(F_n^times) = pi^(n ZZ) times cal(O)_F^times$, the residue $a mod n$ is a
  well-defined invariant, zero exactly when the algebra splits. That is @sec-local of this note.

  #v(1.5mm)
  *Hasse (1933), extended to the abelian case by Chevalley.* For $E slash F$ cyclic of degree $n$,
  $alpha in F^times$ and $sigma$ a generator of $"Gal"(E slash F)$, form the cyclic algebra
  $A = (E slash F, sigma, alpha)$ and let its invariant be $a mod n$. Changing $sigma$ changes $A$
  and changes $a$ --- but $sigma^a$ does *not* change. And $sigma^a$ is the local Artin symbol:
  $ (alpha, E slash F) = sigma^a . $
  The abelian case follows by writing $E$ as a composite of cyclic $E_i slash F$ and checking the
  symbols agree on overlaps. No global input anywhere.
]

#v(2mm)
So the route through cyclic algebras is precisely what allowed local class field theory to stand on
its own --- a surprising thing, as Conrad observes, since the subject is about *abelian* Galois
groups of *commutative* fields. Chevalley's ideles then supplied the other half of Noether's
programme, deriving the global theory from the local one, which is the order every modern treatment
uses.

#block(fill: rgb("#fff4e6"), inset: 8pt, radius: 3pt, width: 100%)[
  *And the cohomology came afterwards, by subtraction.* In 1950--52, Hochschild, Nakayama, Weil,
  Artin and Tate observed that the algebras were defined entirely in terms of the fields anyway, and
  stripped them out of the proofs, leaving the cohomological formalism behind. The $H^2$ one meets
  first in a modern course is historically a *residue* of the crossed products of @sec-crossed, not
  their conceptual origin. Reading the algebras back in is not a detour; it is a return.

  #v(1.5mm)
  What was lost in the stripping is worth naming, because it is the whole complaint this note began
  with: an algebra can be multiplied out, and a claim about it can be *checked*. Hasse's own worked
  example is the first line of check 3. He computes $(-1, QQ(i) slash QQ)_v$ from the rational
  quaternions $(-1,-1)$, finding the invariant $1 slash 2$ at $infinity$ and at $2$ and $0$ at every
  odd prime, because $-1$ is a sum of two squares in $QQ_p$ for $p$ odd. The script reports exactly
  that: index $2$, ramified at ${infinity, 2}$.
]

#v(2mm)
Explicit *construction* of the local class fields, as opposed to the existence statement, came much
later --- Lubin and Tate (1965), via formal groups. And an elementary, cohomology-free foundation
covering the local and global reciprocity laws uniformly is Neukirch's, from the mid-1980s; if a
date in that decade is attached to this story in one's memory, that is the likeliest source, but it
is a reworking of a theory whose independence from the global case had been settled fifty years
earlier.

= What the approach buys, and what it does not <sec-verdict>

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Buys.* Every object is explicit. A cocycle is a multiplication table (@sec-crossed); the local
  invariant is a valuation (@sec-local); reciprocity is a product of symbols you can evaluate
  (@sec-recip). Compatibility claims turn into computations, and the computations can be run ---
  which is what `cft-csa.gp` does for nine of them. The failure modes are honest ones: a wrong
  automorphism gives a non-associative algebra rather than a plausible-looking wrong theorem.

  #v(1.5mm)
  *Does not buy.* The two norm-index inequalities (@sec-hard), which are the analytic and the
  unit-theoretic heart of the subject and are untouched by any of this. Nor does it remove $H^2$;
  it only makes $H^2$ mean something. And the Grunwald--Wang repair is genuinely needed, not
  cosmetic.
]

= What the companion script checks <sec-gp>

`cft-csa.gp`, results in `results/cft-csa.txt`; $0$ failed assertions.

#v(1mm)
- *(1)* Associativity $arrow.l.r.double$ the cocycle condition, exhaustively over all $256$
  cochains with values in ${1,-1,2,i}$ for $G$ of order $2$: $9$ and $9$, $0$ disagreements.
- *(2)* The cyclic cochain is a cocycle and is associative, for $n = 2,3,4,5$ over genuine cyclic
  fields of those degrees --- with $sigma$ *verified* to be an automorphism of exactly order $n$.
- *(3)* ABHN for quaternions: index $1$ $arrow.l.r.double$ $b$ a global norm $arrow.l.r.double$
  split at every place, on nine pairs, by three independent computations.
- *(4)* The unramified local invariant as a valuation: $(u,b)_p = (-1)^(v_p (b))$, $480$ symbols at
  six primes.
- *(5)* $"inv"_(K_P) = [K_P : QQ_p] dot "inv"_(QQ_p)$: a quaternion algebra survives base change
  exactly at odd local degree, over fields of degree $2,3,4$.
- *(6)* Reciprocity $product_v (a,b)_v = +1$ on $396$ random pairs.
- *(7)* Every even set of places is a ramification set, realised constructively.
- *(8)* Wang's counterexample: $16$ locally an $8$th power at every place but $2$, not globally.
- *(9)* Cyclic algebras of degree $3$ built directly by `alginit`, index $1$ or $3$ according as $b$
  is a norm; and quaternion index never exceeds $2$ (period $=$ index).

= References <sec-refs>

#block(inset: (left: 4pt))[
#set enum(numbering: "[1]")
+ A. Weil, *Basic Number Theory*, Ch. IX--XIII. The canonical treatment along exactly these lines:
  simple algebras, then local, then global, then both class field theories. The book for this
  question.
+ P. Gille and T. Szamuely, *Central Simple Algebras and Galois Cohomology*. The modern version;
  crossed products carefully in Ch. 2 and 4, the Brauer group of a local field in Ch. 6.
+ P. Roquette, *The Brauer--Hasse--Noether Theorem in Historical Perspective*. Short, and shows why
  the algebras came first.
+ K. Conrad, *History of Class Field Theory* (online notes), §7. The source for @sec-history: the
  Hasse--Schmidt derivation of $1930$ and its use of the global theory, Noether's objection,
  Hasse's normalisation of cyclic algebras over a local field ($1931$), the local definition of the
  Artin symbol via invariants ($1933$, with Chevalley), and the stripping-out of the algebras in
  $1950$--$52$.
+ H. Hasse, *Die Normenresttheorie relativ-Abelscher Zahlkörper als Klassenkörpertheorie im
  Kleinen*, Crelle $162$ ($1930$). Local class field theory, in its original global-dependent form.
+ H. Hasse, *Über $frak(p)$-adische Schiefkörper und ihre Bedeutung für die Arithmetik
  hyperkomplexer Zahlsysteme*, Math. Ann. $104$ ($1931$), $495$--$534$. The Brauer group of a local
  field, and the normalisation $(F_n slash F, "Frob", pi^a)$ of @sec-history --- the step that made
  the invariant available.
+ C. Chevalley, *Sur la théorie du corps de classes dans les corps finis et les corps locaux*
  ($1933$). The abelian case, and later the ideles that derive the global theory from the local one.
+ J. Lubin and J. Tate, *Formal complex multiplication in local fields*, Ann. of Math. $81$
  ($1965$), $380$--$387$. Explicit construction of the local class fields, which the existence
  statement of @sec-lcft does not provide.
+ J. Neukirch, *Class Field Theory*, Springer, Grundlehren $280$ ($1986$). The cohomology-free
  foundation, local and global under one group-theoretic principle; the likeliest referent of a
  $1980$s date attached to the story of @sec-history.
+ M. Rosen, *An elementary proof of the local Kronecker--Weber theorem*, Trans. AMS $265$ ($1981$),
  $599$--$605$; J. Lubin, *The local Kronecker--Weber theorem*, Trans. AMS $267$ ($1981$),
  $133$--$138$. Purely local proofs of local Kronecker--Weber. *A distinct question from
  @sec-history*, and worth flagging because it is easy to conflate the two: the classical route runs
  local $=>$ global, and local Kronecker--Weber was classically proved *via local class field
  theory*, not deduced from the global theorem. These papers avoid local class field theory, not a
  dependence on the global case.
+ J. Koenigsmann and B. Stock, *An Elementary Proof of the Local Kronecker--Weber Theorem*,
  arXiv:$2206.05801$. Its introduction is the source for the direction of the classical argument
  just described.
+ I. Reiner, *Maximal Orders*, §32. The arithmetic of orders alongside the Brauer group.
+ J. S. Milne, *Class Field Theory* (online notes). Compact statement-level map, with a Brauer-group
  chapter.
+ `plusminus-beta.typ` in this repository, §2 and check 7 --- the product formula of @sec-recip
  used on a real problem.
+ `dirichlet-rank-one.typ` in this repository --- the unit theorem that the algebraic norm-index
  inequality of @sec-hard rests on.
]
