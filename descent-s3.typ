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
  #text(size: 16pt, weight: "bold")[2-descent when $E[2]$ is generic]
  #v(2mm)
  #text(size: 10pt)[The $S_3$ case: what the full descent computes, why there is no
  partial descent over $QQ$, and what takes its place]
  #v(1mm)
  #text(size: 9pt, style: "italic")[worked examples computed by `descent-s3.gp`]
]

#v(4mm)

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *"Partial 2-descent" has two readings, and in the generic case they have opposite answers.*
  Read as *descent along a 2-isogeny*, it does not exist over $QQ$ at all --- @sec-nopartial proves
  this --- and what takes its place is a descent along a factorisation of $f$ over an *extension*
  (@sec-partial). Read as *doing only some of the work* --- imposing a proper subset of the local
  conditions --- it exists, is cheap, and is what one actually does first (@sec-cheap). Both are
  treated below.
]

= The generic hypothesis, and what it rules out <sec-generic>

Write $E : y^2 = f(x)$ with $f = x^3 + c_2 x^2 + c_1 x + c_0 in QQ[x]$ squarefree, and let
$Omega = {theta_1, theta_2, theta_3}$ be its roots. The 2-torsion is
$ E[2] = {O, (theta_1, 0), (theta_2, 0), (theta_3, 0)} , $
so $G_QQ$ acts on $E[2] ∖ {O}$ exactly as it permutes $Omega$, and
$ "Gal"(QQ(E[2]) slash QQ) tilde.equiv "Gal"(f) subset.eq S_3 . $
The *generic* case is $"Gal"(f) = S_3$, i.e. $f$ irreducible with $"disc" f$ not a square.

The structural statement, which everything below uses:

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Lemma 1.* Let $F_2[Omega]$ be the permutation module on the roots and
  $sigma : F_2[Omega] -> F_2$ the sum-of-coordinates map. Then
  $ 0 --> E[2] --> F_2 [Omega] -->^sigma F_2 --> 0 $
  is exact as $G_QQ$-modules: $E[2]$ is the *sum-zero* submodule of $F_2[Omega]$.

  #v(2mm)
  _Proof._ The three non-zero points of $E[2]$ sum to $O$ (they are the intersections of $E$ with
  $y = 0$, a line), so under $E[2] ∖ {O} tilde.equiv Omega$ the group law on $E[2]$ is
  $T_i + T_j = T_k$ for $\{i,j,k\} = \{1,2,3\}$, which is the sum-zero subspace of $F_2^3$. Galois
  permutes both sides compatibly. $qed$
]

For $"Gal"(f) = S_3$ this identifies $E[2]$ with the *standard* 2-dimensional irreducible
$F_2[S_3]$-module, and $G_QQ ->> "Aut"(E[2]) = "GL"_2 (F_2) tilde.equiv S_3$ is onto. Three
consequences, all immediate and all used later.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Corollary 2.* In the generic case:

  #v(1mm)
  *(a)* $E(QQ)[2] = 0$, since $E[2]^(G_QQ) = 0$: a fixed non-zero point is a rational root of $f$.

  #v(1mm)
  *(b)* $E[2]$ has *no* $G_QQ$-stable line, so *$E$ admits no 2-isogeny over $QQ$*.

  #v(1mm)
  *(c)* $"End"_(G_QQ) (E[2]) = F_2$. Indeed the six elements of $"GL"_2(F_2)$ span
  $M_2 (F_2)$ over $F_2$, so the centraliser of the image is the centre of $M_2(F_2)$.
]

Part (c) is worth recording because it says the module admits no non-trivial endomorphism to
exploit: the rank-one $phi in "End"_G (E[ell])$ that drive the Brauer classes of the survey
(§8.1) simply are not there at $ell = 2$ in the generic case.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *The four cases, for orientation.* Everything about 2-descent is governed by how $f$ factors over
  $QQ$, equivalently by the étale algebra $A = QQ[x] slash f$.

  #v(2mm)
  #align(center, table(
    columns: 4, align: (left, left, center, left),
    stroke: 0.4pt + luma(170), inset: (x: 7pt, y: 3.5pt),
    table.header([$f$ over $QQ$], [$A = QQ[x] slash f$], [$dim E(QQ)[2]$], [2-isogenies over $QQ$]),
    [irreducible, $"disc"$ non-square], [cubic field, non-Galois], [$0$], [*none* --- the generic case],
    [irreducible, $"disc"$ square], [cyclic cubic field], [$0$], [*none*],
    [linear $times$ irred. quadratic], [$QQ times$ quadratic field], [$1$], [one],
    [three linear factors], [$QQ times QQ times QQ$], [$2$], [three],
  ))

  #v(2mm)
  *Partial (isogeny) descent lives in the bottom two rows only.* The top two rows --- $f$
  irreducible --- have no rational 2-torsion at all, hence no 2-isogeny; the generic case is the
  first of them.
]

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *The family of the involution note is entirely generic.* For $f = x^3 + a$ one has
  $"disc" f = -27 a^2 = -3 dot (3a)^2$, which is a square in $QQ$ only if $-3$ is --- never. So
  $y^2 = x^3 + a$ has $"Gal"(f) = S_3$ *whenever $a$ is not a cube*, and
  `selmer-involution.typ` is a statement about full 2-descent in the generic case throughout. Its
  2-division field $QQ(root(3,a), zeta_3)$ is the $S_3$-closure.
]

= The cohomology group the descent lives in <sec-h1>

Let $K = QQ[x] slash f$, a cubic field in the generic case, and $theta$ the image of $x$.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Proposition 3.* There is a canonical isomorphism
  $ H^1 (QQ, E[2]) tilde.equiv ker (N : K^times slash (K^times)^2 --> QQ^times slash (QQ^times)^2) , $
  and likewise over every $QQ_v$ with $K$ replaced by $K ⊗ QQ_v$.

  #v(2mm)
  _Proof._ $F_2[Omega] = "Ind"_(G_K)^(G_QQ) mu_2$, so Shapiro gives
  $H^1(QQ, F_2[Omega]) = H^1(K, mu_2) = K^times slash (K^times)^2$, and $sigma$ induces the norm.
  Taking cohomology of Lemma 1 and noting that $H^0(QQ, F_2[Omega]) = F_2 -> H^0(QQ,F_2) = F_2$ is
  onto (the all-ones vector maps to $1$) gives
  $0 -> H^1(QQ, E[2]) -> K^times slash (K^times)^2 -> QQ^times slash (QQ^times)^2$. $qed$
]

So a class in $H^1(QQ, E[2])$ *is* a square class of the cubic field with square norm. That is the
concrete object every 2-descent in this case manipulates.

The *dimensions* of the local pieces come for free from the module, by Lemma B$'$ of
`selmer-involution.typ`: writing $L_v subset.eq H^1(QQ_v, E[2])$ for the image of the Kummer map,
$ dim_(F_2) L_v = cases(
  dim E[2](QQ_v) & v "finite", v divides.not 2,
  dim E[2](QQ_2) + 1 & v = 2,
  dim E[2](RR) - 1 & v = infinity,
) $
and $dim H^1(QQ_v, E[2]) = 2 dim L_v$, the local condition being maximal isotropic for the
local Tate pairing --- written out explicitly in @sec-tate. Since
$dim E[2](QQ_v)$ counts roots of $f$ in $QQ_v$, this is a table:

#align(center, table(
  columns: 4, align: (left, center, center, center),
  stroke: 0.4pt + luma(170), inset: (x: 7pt, y: 3.5pt),
  table.header([$f$ over $QQ_v$], [$dim E[2](QQ_v)$], [$dim L_v$ ($v != 2, infinity$)], [$dim L_2$]),
  [irreducible, or irred. quadratic factor only], [$0$], [$0$], [$1$],
  [one root], [$1$], [$1$], [$2$],
  [three roots], [$2$], [$2$], [$3$],
))

#v(2mm)

with $dim L_infinity = 0$ if $f$ has one real root and $1$ if it has three. *Every entry depends
only on the splitting of $f$*, never on the curve --- which is exactly the point made in the
involution note, and the reason two curves sharing $E[2]$ have local conditions of equal size.

= The descent map <sec-map>

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Proposition 4.* For $P = (x_0, y_0) in E(QQ)$ set $delta(P) = x_0 - theta in K^times slash
  (K^times)^2$. In the generic case this is defined on all of $E(QQ) ∖ {O}$, extends by
  $delta(O) = 1$, and gives an injection
  $ delta : E(QQ) slash 2 E(QQ) arrow.r.hook ker(N) subset.eq K^times slash (K^times)^2 $
  which is the Kummer map of @sec-h1.
]

Three remarks, each of which is a simplification special to the generic case.

*(i) No exceptional values.* $x_0 - theta$ is a unit of $K$ unless $x_0$ is a root of $f$, i.e.
unless $P in E[2]$; and $E(QQ)[2] = 0$ by Corollary 2(a). So *the formula never degenerates* and one
never needs the usual "if $x_0 = theta_i$ then use $f'(theta_i)$" clause. In the split case that
clause is unavoidable; here it is empty.

*(ii) The norm is automatically a square.* $N_(K slash QQ)(x_0 - theta) = product_i (x_0 - theta_i)
= f(x_0) = y_0^2$. So the image lands in $ker N$ with nothing to check --- and conversely the
norm condition is the only global constraint visible before local conditions are imposed.

*(iii) It is a homomorphism*, by one line. Let $P_1 + P_2 + P_3 = O$ with the $P_i$ on the line
$y = lambda x + mu$. Both $f(x) - (lambda x + mu)^2$ and $product_i (x - x_i)$ are monic cubics with
the same roots, hence equal. Evaluating at $x = theta$ and using $f(theta) = 0$,
$ product_i (theta - x_i) = -(lambda theta + mu)^2, quad "so" quad
  product_i delta(P_i) = product_i (x_i - theta) = (lambda theta + mu)^2 , $
a square. (If the line is vertical, $P_1 + P_2 = O$ and $delta(P_1) delta(P_2) = (x_1 - theta)^2$.)

= The local Tate pairing, on the descent module itself <sec-tate>

@sec-h1 asserted that $L_v$ is *maximal isotropic*; this section writes down the form it is
isotropic for, entirely inside $A^times slash (A^times)^2$, with no cohomology left in the formula.

Throughout let $A = QQ[x] slash f$ be the étale algebra of the four-case table of @sec-generic ---
so $A = K$, the cubic field, in the generic case, but nothing below uses irreducibility --- and for
a place $v$ of $QQ$ write
$ A_v = A ⊗_QQ QQ_v = product_(w divides v) A_w , quad quad alpha = (alpha_w)_(w divides v) , $
the product running over the places $w$ of $A$ above $v$, each $A_w$ a finite extension of $QQ_v$.
By @sec-h1, $H^1(QQ_v, E[2]) = ker(N : A_v^times slash "sq" -> QQ_v^times slash "sq")$.

== The Weil pairing is the permutation pairing <sec-weil>

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Lemma 5.* Give $F_2[Omega]$ the $G_QQ$-invariant symmetric form $⟨e_i, e_j⟩ = delta_(i j)$.
  Under the identification $E[2] = ker sigma$ of Lemma 1, its restriction to $E[2]$ is the Weil
  pairing $e_2$.

  #v(2mm)
  _Proof._ $E[2] = {0, e_1 + e_2, e_1 + e_3, e_2 + e_3}$. On it the form is
  $⟨e_i + e_j, e_i + e_j⟩ = 0$ and $⟨e_i + e_j, e_i + e_k⟩ = 1$ for $j != k$: alternating, and
  non-degenerate, because the perpendicular of $ker sigma$ inside $F_2[Omega]$ is the line
  $⟨e_1 + e_2 + e_3⟩$, which meets $ker sigma$ in $0$. There is exactly one non-degenerate alternating form on $F_2^2$, and $e_2$ is
  one, so they agree. $qed$
]

So the inclusion $E[2] arrow.r.hook F_2[Omega]$ is an *isometry*, and cup products computed in the
big module restrict correctly to the small one. That is the whole reason the formula below can be
written on $A^times slash (A^times)^2$ rather than on $ker N$.

== The formula <sec-tate-formula>

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Theorem 6 (the Tate pairing as a corestricted Hilbert symbol).* For
  $alpha, beta in A_v^times slash (A_v^times)^2$ the cup-product pairing
  $ ⟨thin , thin ⟩_v : H^1(QQ_v, F_2[Omega]) times H^1(QQ_v, F_2[Omega]) --> "Br"(QQ_v)[2] $
  is
  $ ⟨alpha, beta⟩_v = "cor"_(A_v slash QQ_v) (alpha, beta)_(A_v)
    = sum_(w divides v) "cor"_(A_w slash QQ_v) (alpha_w, beta_w)_(A_w) in "Br"(QQ_v)[2] , $
  of invariant
  $ "inv"_v ⟨alpha, beta⟩_v = sum_(w divides v) "inv"_w (alpha_w, beta_w)_(A_w) in 1/2 ZZ slash ZZ ,
  quad quad "equivalently" quad quad
  (-1)^(2 "inv"_v ⟨alpha,beta⟩_v) = product_(w divides v) (alpha_w, beta_w)_w , $
  a product of ordinary Hilbert symbols, one per local factor of $A_v$. Restricted to
  $ker N = H^1(QQ_v, E[2])$ it is the local Tate pairing of $E[2]$.

  #v(2mm)
  _Proof._ The form of Lemma 5 factors as
  $F_2[Omega] ⊗ F_2[Omega] -->^"mult" F_2[Omega] -->^sigma F_2$, coordinatewise multiplication
  followed by the sum of coordinates. Now $F_2[Omega] = "Ind"_(G_A)^(G_QQ) mu_2$, the
  multiplication is the induced multiplication $mu_2 ⊗ mu_2 -> mu_2$, and $sigma$ is the trace map
  of the induced module, whose effect on cohomology is *corestriction*. Shapiro turns
  $H^i(QQ_v, F_2[Omega])$ into $H^i(A_v, mu_2)$ compatibly with cup products, so
  $⟨alpha, beta⟩_v = "cor"_(A_v slash QQ_v)(alpha union beta)$, and $alpha union beta$ in
  $H^2(A_v, mu_2) = "Br"(A_v)[2]$ is the quaternion class $(alpha, beta)_(A_v)$. Splitting
  $A_v$ into its local factors splits the corestriction; and
  $"inv"_(QQ_v) compose "cor"_(A_w slash QQ_v) = "inv"_(A_w)$ in local class field theory gives the
  invariant. Lemma 5 makes $E[2] arrow.r.hook F_2[Omega]$ an isometry, hence the restriction
  statement. $qed$
]

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *The quaternion algebra, as asked for.* Locally the answer is a *tensor product of
  corestrictions of quaternion algebras*,
  $ cal(A)_v (alpha, beta) = limits(⊗)_(w divides v) "cor"_(A_w slash QQ_v)
    ((alpha_w, beta_w)_2 slash A_w) , $
  with slots $alpha_w, beta_w in A_w$ --- not in $QQ_v$. In the generic case that is the honest
  shape of the thing and it cannot be improved: $A$ is a cubic field, $alpha$ genuinely has three
  conjugate components, and the same remark is made in `ec-density-bm.typ` §5 about the associated
  Brauer class on $E$.

  #v(2mm)
  What *is* a single quaternion algebra with slots in $QQ$ is the *global* class. Set
  $ Sigma(alpha, beta) = { v : product_(w divides v) (alpha_w, beta_w)_w = -1 } . $
  By Proposition 9 below this is finite of *even* cardinality, so there is a unique quaternion
  algebra over $QQ$ ramified exactly on $Sigma$, and
  $ "cor"_(A slash QQ) (alpha, beta)_A = (a, b)_2 quad "for that" (a,b) . $
  Computing $Sigma$ is a finite list of Hilbert symbols; reading $(a,b)$ off $Sigma$ is the
  standard recipe of `csa-brauer.typ` §3. @sec-tate-37 does this explicitly.
]

== Cases where the slots are constant <sec-tate-constant>

Three specialisations put the answer back into $QQ_v$ with no corestriction left.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Corollary 7.* Let $N = N_(A slash QQ)$.

  #v(1mm)
  *(a) (projection formula)* For $b in QQ_v^times$, embedded diagonally in $A_v^times$,
  $ ⟨alpha, b⟩_v = (N alpha, thin b)_2 quad "over" QQ_v , $
  a quaternion algebra with both slots in $QQ_v$.

  #v(1mm)
  *(b) (self-pairing)* $ ⟨alpha, alpha⟩_v = ⟨alpha, -1⟩_v = (N alpha, thin -1)_2 . $

  #v(1mm)
  *(c)* Consequently the annihilator of the diagonal $QQ_v^times slash "sq"$ is exactly $ker N$,
  and --- the pairing on $A_v^times slash "sq"$ being perfect --- the annihilator of
  $ker N = H^1(QQ_v, E[2])$ is exactly the diagonal. The two subgroups meet in $1$, since
  $N(b) = b^3 equiv b$.

  #v(1mm)
  *(d)* On $ker N$ the pairing is *alternating*: $N alpha$ is a square there, so
  $⟨alpha,alpha⟩_v = 0$ by (b) --- which is Lemma 5's "alternating" seen on the other side of
  Shapiro.

  #v(2mm)
  _Proof._ (a) is $"cor"(alpha union "res" b) = "cor"(alpha) union b$ and
  $"cor" : A^times slash "sq" -> QQ^times slash "sq"$ is the norm. (b) is
  $(alpha, alpha) = (alpha, -alpha) + (alpha,-1) = (alpha,-1)$ componentwise. (c): $(N alpha, b)_2$
  is trivial for all $b in QQ_v^times$ iff $N alpha in (QQ_v^times)^2$. $qed$
]

Part (b) is the formula used in `kummer-example-j0.typ` §6.3, where
$⟨a,a⟩ = sum_(w divides q) (a, -1)_(K_w)$ decides whether the self-pairing functional is non-zero;
Corollary 7(b) says that functional is nothing but $a |-> (N a, -1)_q$.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Corollary 8 (the reducible rows of the table).* Let $alpha, beta in ker N$.

  #v(1mm)
  *(a)* If $f$ splits completely over $QQ_v$, so $A_v = QQ_v^3$, then
  $ ⟨alpha, beta⟩_v = (alpha_1, beta_2)_2 ⊗ (alpha_2, beta_1)_2 , $
  the classical *antidiagonal* formula of split 2-descent.

  #v(1mm)
  *(b)* If $f = (x - e) g(x)$ over $QQ_v$ with $g$ irreducible, so $A_v = QQ_v times L$ with $L$
  quadratic, then
  $ ⟨alpha, beta⟩_v = (N_(L slash QQ_v) alpha_2, thin N_(L slash QQ_v) beta_2)_2
    ⊗ "cor"_(L slash QQ_v) (alpha_2, beta_2)_L . $

  #v(2mm)
  _Proof._ In (a) the constraint $alpha in ker N$ reads $alpha_3 equiv alpha_1 alpha_2$ modulo
  squares, and likewise for $beta$; bilinearity of the symbol gives
  $(alpha_1,beta_1)(alpha_2,beta_2)(alpha_1 alpha_2, beta_1 beta_2) = (alpha_1,beta_2)(alpha_2,beta_1)$.
  In (b) it reads $alpha_1 equiv N_(L slash QQ_v)(alpha_2)$. $qed$
]

Row (a) is why the split case needs no field arithmetic at all: both slots are rational numbers.
Row (b) shows what the generic case costs --- one irreducible corestriction survives --- and the
generic case proper, $A_v$ a cubic field, is a single symbol $(alpha, beta)_(A_v)$ with no
rational part to peel off.

== The tame formula, and why only $v in S$ matters <sec-tate-tame>

For $v$ odd and $w divides v$ with residue field $k_w$, the symbol is the tame symbol: writing
$n = v_w (alpha_w)$ and $m = v_w (beta_w)$, the element
$ u = (-1)^(n m) thin alpha_w^m thin beta_w^(-n) $
is a unit at $w$, and
$ (alpha_w, beta_w)_w = cases(
  +1 & "if" u mod frak(p)_w "is a square in" k_w^times ,
  -1 & "otherwise" ,
) $
--- the quadratic residue symbol of $u$ at $frak(p)_w$. Two consequences, both used silently in
Step 3 of @sec-full:

*(i)* If $alpha_w$ and $beta_w$ both have even valuation at every $w divides v$ --- the
*unramified* subgroup --- the symbol is a square and the pairing vanishes. So the unramified
subgroup is isotropic, and since it has half the dimension it *is* $L_v$ at good odd $v$.

*(ii)* At odd $v$, $⟨alpha,beta⟩_v$ can be non-zero only if some $alpha_w$ or $beta_w$ has odd
valuation. Membership in $K(S,2)$ forbids that outside $S$, which is exactly the statement that
the conditions outside $S$ are automatic.

== Reciprocity, and the isotropy of the Selmer group <sec-tate-recip>

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Proposition 9.* For $alpha, beta in A^times slash (A^times)^2$ global,
  $ sum_v "inv"_v ⟨alpha, beta⟩_v = 0 , quad quad "equivalently" quad quad
    product_v product_(w divides v) (alpha_w, beta_w)_w = 1 , $
  all but finitely many terms being $1$. Consequently $Sigma(alpha,beta)$ is finite of even
  cardinality.

  #v(2mm)
  _Proof._ Regroup the double product by places $w$ of $A$: it becomes
  $product_w (alpha, beta)_w$, which is Hilbert reciprocity for the number field (or étale algebra)
  $A$. Cohomologically it is $sum_v "inv"_v "cor"(alpha union beta) =
  sum_w "inv"_w (alpha union beta) = 0$ by the reciprocity sequence for $A$. $qed$
]

Two standard consequences follow at once, and they are the reason the pairing is worth having:

*(i) $"Sel"_2(E)$ is isotropic under $sum_v ⟨thin,thin⟩_v$* --- trivially, by Proposition 9 --- and
each $L_v$ is isotropic under $⟨thin,thin⟩_v$, because $L_v$ is the image of
$E(QQ_v) slash 2$ and the Weil pairing of two Kummer classes of the same curve vanishes.

*(ii) A class $alpha in K(S,2) inter ker N$ that pairs non-trivially with a known Selmer class
is not in $"Sel"_2$*, and Proposition 9 says *where* it fails: at the places of $Sigma$. This is
the cheapest possible local test, and it needs no local points at all.

== `37a1`, with the algebras written out <sec-tate-37>

Take $E : Y^2 = X^3 - 16X + 16$ of @sec-37, $K = QQ[theta]$, $theta^3 = 16 theta - 16$, and the
Selmer generator $alpha = -theta$, with $N(-theta) = 16$. Pair it against $beta = x_0 - theta$ for
small rational $x_0$; by Theorem 6 this is $product_(w divides v)(-theta, x_0 - theta)_(K_w)$, and
$N(beta) = f(x_0)$.

#align(center, table(
  columns: 5, align: (center, center, left, left, left),
  stroke: 0.4pt + luma(170), inset: (x: 7pt, y: 3.5pt),
  table.header([$x_0$], [$f(x_0)$ mod sq.], [$Sigma(alpha, beta)$], [$"cor"_(K slash QQ)(alpha,beta)$], [what it says]),
  [$-4, 0, 1, 4, 8$], [$1$], [$emptyset$], [split], [$beta in "Sel"_2$: $x_0$ is a rational point],
  [$2$],  [$-2$], [${infinity, 2}$], [$(-1,-1)_2$], [Hamilton's quaternions],
  [$3$],  [$-5$], [${infinity, 5}$], [$(-2,-5)_2$], [fails at $infinity$ and at $5$],
  [$-2$], [$10$],  [${2, 5}$],       [$(2,5)_2$],   [fails at $2$ and at $5$],
  [$-6$], [$-26$], [${2, 13}$],      [$(2,13)_2$],  [fails at $2$ and at $13$],
  [$6$],  [$34$],  [${2, 17}$],      [$(3,-17)_2$], [fails at $2$ and at $17$],
  [$7$],  [$247$], [${13, 19}$],     [$(2,247)_2$], [fails at $13$ and at $19$],
))

#v(2mm)

Read the first row: $f(-4) = 16$, $f(0) = 16$, $f(1) = 1$, $f(4) = 16$, $f(8) = 400$ are squares, so
$(x_0, sqrt(f(x_0)))$ is a rational point and $beta = delta(P)$ lies in the Selmer group with
$alpha$; the pairing vanishes at *every* place, which is isotropy of $"Sel"_2$ made visible. Read
the second: $f(2) = -8$, so $2$ is not the abscissa of a $QQ_2$-point, and the pairing against the
Selmer class detects it --- the local invariant at $2$ is $1 slash 2$, and since $2$ is totally
ramified in $K$ there is a single $w divides 2$ and the class is the single corestriction
$"cor"_(K_w slash QQ_2)(-theta, thin 2 - theta)$, of invariant $1 slash 2$, i.e. the quaternion
division algebra over $QQ_2$. Globally that and the real place are the only failures, so
$ "cor"_(K slash QQ) (-theta, thin 2 - theta) = (-1,-1)_2 = bb(H) , $
Hamilton's quaternions --- a completely explicit answer to "which quaternion algebra".

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *What `descent-s3.gp` checks.* All four claims, on `37a1`, via `nfhilbert`:
  Corollary 7(b), $⟨a,a⟩_v = (N a, -1)_v$, at $v = 2, 37, infinity$ for ten test classes ---
  no discrepancy; Corollary 7(a), $⟨a,b⟩_v = (N a, b)_v$ for rational $b in {-1,2,3,37,-74}$ ---
  no discrepancy; Proposition 9 over all of $v in {2,3,5,7,11,13,37,101} union {infinity}$ for all
  $100$ pairs --- no discrepancy; and isotropy of $L_v$, by pairing $x - theta$ against
  $x' - theta$ over every rational $x, x' in [-60,60]$ with $f(x), f(x')$ square in $QQ_v$: at
  $v = 2$ all $46^2$ symbols trivial, at $v = 37$ all $57^2$, at $v = 3$ all $121^2$, at
  $v = infinity$ all $63^2$. The normalisation of Theorem 6 is therefore the right one.
]

== Provenance <sec-tate-refs>

Theorem 6 is proved above rather than quoted, but it is standard, and the same formula --- the local
Tate pairing on a descent module $A^times slash (A^times)^n$ as a sum of local symbols over the
places of the étale algebra $A$ --- is the working tool of the explicit-descent literature. Where to
read it:

#block(inset: (left: 4pt))[
#set enum(numbering: "[1]")
+ E. F. Schaefer, *2-descent on the Jacobians of hyperelliptic curves*, J. Number Theory *51*
  (1995), 219--232. The source of the $A = k[x] slash f$ formalism used here: $x - theta$ as the
  descent map, $ker N$ as the image, for hyperelliptic Jacobians and in particular for $E$.
+ B. Poonen, E. F. Schaefer,
  #link("https://math.mit.edu/~poonen/papers/descent.pdf")[*Explicit descent for Jacobians of
  cyclic covers of the projective line*], J. reine angew. Math. *488* (1997), 141--188. The same setup for $mu_n$-covers, with the
  cup-product/corestriction bookkeeping made explicit.
+ B. Poonen, M. Stoll, #link("https://arxiv.org/abs/math/9911267")[*The Cassels--Tate pairing on
  polarized abelian varieties*], Ann. of Math. *150* (1999), 1109--1149. The reference for the
  pairing itself: the local pairing on $H^1(k_v, J[2])$ is computed as a sum of Hilbert symbols
  over the places of $A ⊗ k_v$, which is Theorem 6 for a general hyperelliptic Jacobian.
+ M. Stoll, #link("https://www.impan.pl/en/publishing-house/journals-and-series/acta-arithmetica/all/98/3/83397/implementing-2-descent-for-jacobians-of-hyperelliptic-curves")[*Implementing
  2-descent for Jacobians of hyperelliptic curves*], Acta Arith. *98* (2001), 245--277. The same formula as an algorithm, including the tame reduction of
  @sec-tate-tame and the reason only $v in S$ is tested.
+ J. W. S. Cassels, *Second descents for elliptic curves*, J. reine angew. Math. *494* (1998),
  101--127. Uses the pairing on $A^times slash (A^times)^2$ for an elliptic curve to decide which
  Selmer classes lift --- the 4-descent alluded to at the end of @sec-nopartial.
+ J. Neukirch, A. Schmidt, K. Wingberg, *Cohomology of Number Fields*, Ch. I. The two cohomological
  inputs to the proof of Theorem 6: that Shapiro's isomorphism is compatible with cup products, and
  that the trace map of an induced module induces corestriction. Local duality and
  $"inv" compose "cor" = "inv"$ are in Ch. VII; see also `local-duality.typ`.
]

The elliptic-curve case with $A$ a *cubic* algebra is the $g = 1$ instance of [1]--[4] throughout;
none of those sources assumes $f$ reducible, which is why Corollary 8 reads as a degeneration rather
than as the main case.

= Full 2-descent, as an algorithm <sec-full>

Let $S$ be the set of places consisting of $infinity$, the prime $2$, and the primes of bad
reduction. Write, for a number field $K$,
$ K(S,2) = { alpha in K^times slash (K^times)^2 : "ord"_frak(p) (alpha) equiv 0 (mod 2)
  "for all" frak(p) in.not S } . $

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Step 1 (the global bound).* $"Sel"_2 (E) subset.eq K(S,2) inter ker N$.

  #v(1mm)
  *Step 2 (the size of that).* There is an exact sequence
  $ 1 --> cal(O)_(K,S)^times slash (cal(O)_(K,S)^times)^2 --> K(S,2) --> "Cl"_S (K)[2] --> 1 , $
  whence
  $ dim_(F_2) K(S,2) = underbrace((r_1 + r_2 + \# S_f), "S-units")
    + dim_(F_2) "Cl"_S (K)[2] , $
  with $S_f$ the primes *of $K$* above $S$. (The $S$-unit rank is $r_1 + r_2 - 1 + \# S_f$; the
  extra $1$ is $-1 in mu(K)$.)

  #v(1mm)
  *Step 3 (the local conditions).* For each $v in S$ compute
  $L_v subset.eq (K ⊗ QQ_v)^times slash "squares"$ as the image of $E(QQ_v) slash 2$ under
  $x - theta$, and keep only those global classes landing in $L_v$ for every $v in S$.

  #v(1mm)
  *Step 4 (read off).* $dim "Sel"_2 (E) = "rank" E(QQ) + dim Ш(E)[2]$, since $E(QQ)[2] = 0$. In
  particular $"rank" E(QQ) <= dim "Sel"_2 (E)$, with equality iff $Ш(E)[2] = 0$.
]

Two things make Step 3 finite and cheap. First, *the conditions outside $S$ are automatic*: at a
good $v divides.not 2$ the local condition is the unramified subgroup, and membership in $K(S,2)$
already forces a class to be unramified there. Second, *one knows in advance how big $L_v$ is* ---
the table of @sec-h1 --- so when sampling points of $E(QQ_v)$ one knows exactly when to stop.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *Where the cost is.* Not in the local conditions, which are a bounded number of computations in
  $(K ⊗ QQ_v)^times$ modulo squares. It is in Step 2: one needs the *class group and unit group of
  a cubic field* of discriminant comparable to $"disc" f$. That is subexponential, and
  unconditionally certifying it is the expensive part; most implementations compute it under GRH.
  This is the one structural respect in which the generic case is *harder* than the split case,
  where $A = QQ^3$ and only $QQ(S,2)$ --- pure factorisation --- is needed.
]

= Worked examples <sec-examples>

Computed by `descent-s3.gp`; full output in `results/descent-s3.txt`. All three curves are generic,
have trivial torsion, and admit no rational isogeny of any degree.

#align(center, table(
  columns: 8, align: (left, left, center, center, center, center, center, center),
  stroke: 0.4pt + luma(170), inset: (x: 5pt, y: 3.5pt),
  table.header(
    [curve], [$f$], [$"disc" K$], [$"Cl"(K)$], [$dim K(S,2)$],
    [after $N$], [$dim "Sel"_2$], [rank, $Ш[2]$]),
  [`37a1`, $N=37$],  [$x^3 - 16x + 16$],   [$148$],  [$1$],   [$6$], [$3$],    [$1$], [$1, 0$],
  [`389a1`, $N=389$],[$x^3 + 4x^2 - 32x + 16$], [$1556$], [$1$], [$6$], [$3$],  [$2$], [$2, 0$],
  [`571a1`, $N=571$],[$x^3 - 4x^2 - 14864x - 678064$], [$-2284$], [$ZZ slash 2$], [$6$], [$<= 3$], [$2$], [$0, (ZZ slash 2)^2$],
))

#v(2mm)

In each case $S = {2, N}$ and $S_f$ has three elements: $2$ is totally ramified in $K$, and $N$
factors as $frak(p) frak(q)^2$. The column "after $N$" is the bound *before any local condition* is
imposed, and the last two columns show what the local conditions then achieve: $3 -> 1$, $3 -> 2$,
$3 -> 2$. The local conditions are doing genuine work in every case.

== `37a1` in full <sec-37>

$E : y^2 + y = x^3 - x$ becomes $Y^2 = X^3 - 16X + 16$ under $X = 4x$, $Y = 8y + 4$. Then
$K = QQ[theta]$ with $theta^3 = 16 theta - 16$ is totally real of discriminant $148$, class number
$1$, unit rank $2$; $S = {2, 37}$, and in $K$

$ 2 = frak(p)_2^3, quad 37 = frak(p)_37 frak(q)_37^2 , $

so $\# S_f = 3$ and $dim K(S,2) = (3 + 0) + 3 + 0 = 6$. The six generators $-1, u_1, u_2$ and three
$S$-unit generators have norms, modulo squares,
$ -1, quad -1, quad 1, quad -2, quad 37, quad -37 , $
which span all of $QQ(S,2) = ⟨-1, 2, 37⟩$; so the norm map is surjective and
$ dim (K(S,2) inter ker N) = 6 - 3 = 3 . $
The local conditions are $dim L_2 = 1$, $dim L_37 = 1$, $dim L_infinity = 1$ (three real roots), and
they cut the $3$ down to
$ dim "Sel"_2 (E) = 1 . $
The generator is visible: $P = (0,0)$ on the original model is $(X, Y) = (0, 4)$, so
$ delta(P) = 0 - theta = -theta , $
whose norm is $16$, a square as it must be, and which is *not* a square in $K$ (the polynomial
$T^2 + theta$ has no root there). Hence $"Sel"_2 = ⟨-theta⟩$, $"rank" E(QQ) = 1$, $Ш[2] = 0$.

== `571a1`, where the descent does not see the rank <sec-571>

Here $K$ has signature $(1,1)$ and class number $2$, so $"Cl"_S(K)[2]$ contributes a generator
beyond the $S$-units and $dim K(S,2) = 2 + 3 + 1 = 6$ again. The bound after the norm condition is
$<= 3$, the local conditions give $dim "Sel"_2 = 2$ --- and the rank is $0$. The whole of
$"Sel"_2$ is $Ш(E)[2] = (ZZ slash 2)^2$. *2-descent alone cannot decide this curve*; one needs a
second descent, or the analytic rank.

= There is no partial 2-descent over $QQ$ <sec-nopartial>

By *partial descent* one normally means descent along an isogeny $phi$ of degree 2, computing
$"Sel"^phi (E)$ and $"Sel"^(hat(phi))(E')$ separately and combining them. In the generic case this
is unavailable, and it is worth being precise about how completely.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Proposition 10.* Let $"Gal"(f)$ be $S_3$ or $C_3$. Then over $QQ$:

  #v(1mm)
  *(a)* $E$ has no 2-isogeny, since a 2-isogeny is a $G_QQ$-stable line in $E[2]$, i.e. a fixed
  non-zero point, i.e. a rational root of $f$ (Corollary 2(b)).

  #v(1mm)
  *(b)* Consequently there is no Cassels-type ratio
  $\#"Sel"^phi slash \#"Sel"^(hat(phi))$ to compute, no exact sequence
  $0 -> E'(QQ)[hat(phi)] slash phi E(QQ)[2] -> "Sel"^phi -> "Sel"_2 -> "Sel"^(hat(phi))$
  to interpolate through, and no factorisation of the descent through a smaller field.

  #v(1mm)
  *(c)* More strongly, $E[2]$ is *irreducible* in the $S_3$ case, so $"Sel"_2$ admits no Galois-stable
  filtration at all: it is not assembled from smaller Selmer groups in any way.
]

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *What this costs, concretely.* In the split case $f = x(x-e_1)(x-e_2)$ the descent map goes to
  $(QQ^times slash "squares")^2$ and the whole computation is *factorisation of integers*: no class
  group, no units of a cubic field. The Selmer group of the congruent number curve is computed this
  way, and Monsky's matrix is precisely the resulting $F_2$-linear algebra. In the generic case none
  of that is available: the arithmetic of a cubic field is *forced*, and it is forced by
  Proposition 10.
]

What *does* remain over $QQ$ is not a partial descent but a *deeper* one: second descent, i.e.
4-descent, which refines $"Sel"_2$ by asking which of its classes lift to $"Sel"_4$ and so detects
the elements of $Ш[2]$ that stopped the computation for `571a1`. That is a different and more
expensive technique, not a cheaper one.

= What takes its place: descent along a factorisation over an extension <sec-partial>

The general form of partial descent, as used for hyperelliptic curves (Bruin--Stoll), is: given
$y^2 = f(x)$ and a factorisation $f = g dot h$ over a field $L$, the map
$P |-> (g(x(P)), h(x(P)))$ modulo squares is a *partial descent map*, weaker than the full one but
defined over $L$. Over $QQ$ the generic $f$ has no factorisation. Over an extension it does, and the
minimal one is forced.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *The minimal field for a partial descent is $K$ itself* --- the cubic field, of degree 3, and
  *not Galois*. Over $K$, $f = (x - theta) q(x)$ and $E_K$ acquires the rational 2-torsion point
  $(theta, 0)$; the quadratic resolvent field $QQ(sqrt("disc" f))$ does *not* suffice, because over
  it the Galois group is still $A_3 = C_3$, which acts irreducibly on $F_2^2$.
]

== The isogeny, explicitly <sec-isog>

Shift $x |-> x + theta$. Since $f(theta) = 0$,
$ f(x + theta) = x^3 + A x^2 + B x, quad A = 3 theta + c_2, quad B = f'(theta) , $
so over $K$ the curve is $y^2 = x(x^2 + A x + B)$ with 2-torsion point $(0,0)$, and the 2-isogeny
$phi$ with that kernel has image
$ E' : quad Y^2 = X (X^2 - 2 A X + (A^2 - 4B)) . $
The quadratic $x^2 + A x + B$ has roots $theta_2 - theta$ and $theta_3 - theta$, so
$ A^2 - 4B = (theta_2 - theta_3)^2 , $
a square in the Galois closure but not in $K$. For `37a1`, $c_2 = 0$ and $f' = 3x^2 - 16$, giving
$A = 3 theta$, $B = 3 theta^2 - 16$ and $A^2 - 4B = 64 - 3 theta^2$.

The $phi$-descent over $K$ is then the classical one: $delta_phi (P) = x(P)$ and
$delta_(hat(phi))$ its analogue on $E'$, both landing in $K(S,2)$, with
$ "rank" E(K) <= dim "Sel"^phi (E_K) + dim "Sel"^(hat(phi)) (E'_K) - 2 . $

== Feeding the answer back to $QQ$ <sec-feedback>

A bound over $K$ is worth having only if it constrains $E(QQ)$. It does, and the bookkeeping is
representation theory of $S_3$. Let $L$ be the Galois closure, $"Gal"(L slash QQ) = S_3$, and
decompose
$ E(L) ⊗ QQ tilde.equiv m_1 dot bold(1) ⊕ m_epsilon dot "sgn" ⊕ m_"std" dot "std" . $

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Proposition 11.* With $F = QQ(sqrt("disc" f))$ the quadratic resolvent and $E^Delta$ the quadratic
  twist of $E$ by $"disc" f$,
  $ "rank" E(QQ) = m_1, quad
    "rank" E(F) = m_1 + m_epsilon = "rank" E(QQ) + "rank" E^Delta (QQ), $
  $ "rank" E(K) = m_1 + m_"std" = "rank" E(QQ) + m_"std", quad
    "rank" E(L) = m_1 + m_epsilon + 2 m_"std" . $

  #v(2mm)
  _Proof._ $K$ is the fixed field of a transposition $⟨tau⟩$, of index 3, and
  $"Ind"_(⟨tau⟩)^(S_3) bold(1) = bold(1) ⊕ "std"$; $F$ is the fixed field of $A_3$ and
  $"Ind"_(A_3)^(S_3) bold(1) = bold(1) ⊕ "sgn"$. Now
  $"rank" E(M) = dim "Hom"_(S_3)("Ind"_(H)^(S_3) bold(1), E(L) ⊗ QQ)$ for $M = L^H$. $qed$
]

So $"rank" E(QQ) <= "rank" E(K)$, and a partial descent over $K$ bounds the rank over $QQ$ --- but
*with a defect of $m_"std"$*, which the method does not see. The two-place accounting is:

#align(center, table(
  columns: 3, align: (left, left, left),
  stroke: 0.4pt + luma(170), inset: (x: 7pt, y: 4pt),
  table.header([], [full 2-descent over $QQ$], [partial ($phi$-)descent over $K$]),
  [computes], [$"Sel"_2(E slash QQ)$ exactly], [$"Sel"^phi, "Sel"^(hat(phi))$ over $K$],
  [bounds], [$"rank" E(QQ)$], [$"rank" E(K) = "rank" E(QQ) + m_"std"$],
  [needs], [$"Cl"(K), cal(O)_K^times$, and $ker N$], [$"Cl"(K), cal(O)_K^times$ --- *twice*],
  [local work], [images of $E(QQ_v) slash 2$], [local indices $\#(E'(K_w) slash phi E(K_w))$],
  [defect], [$dim Ш(E slash QQ)[2]$], [$dim Ш(E slash K)[phi]$ *and* $m_"std"$],
))

#v(2mm)

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *Verdict.* Over $QQ$ the partial descent is not merely unavailable but not worth simulating: it
  needs the same cubic field, run twice, and answers a weaker question. Its real use is when the
  base field *already contains a root of $f$* --- descending over $K$, or in a tower, or over a
  function field where the split case is arranged by construction. The one genuine gain is that its
  local conditions are index computations of Tamagawa type rather than images of Kummer maps.
]

= The other reading: doing only part of the local work <sec-cheap>

The second sense of "partial" is real, cheap, and is what one does first. Each of the following is
an upper bound for $dim "Sel"_2$, obtained by *discarding* conditions, and they are nested.

#align(center, table(
  columns: 3, align: (left, left, center),
  stroke: 0.4pt + luma(170), inset: (x: 7pt, y: 4pt),
  table.header([bound], [what is used], [`37a1`]),
  [$dim K(S,2)$], [ramification only], [$6$],
  [$dim (K(S,2) inter ker N)$], [$+$ the norm condition], [$3$],
  [$+$ the condition at $infinity$ and at $2$], [$+$ two local images], [$<= 3$],
  [$dim "Sel"_2$], [$+$ all $v in S$], [$1$],
))

#v(2mm)

Three remarks on using them.

*(i) The norm condition is free* and is the single most effective cut: in all three examples it
removed 3 of the 6 dimensions. It requires no local computation at all, only the norms of the
$S$-unit generators.

*(ii) The parity is free too.* By the $p$-parity theorem the parity of $dim "Sel"_(2^infinity)$ is
the global root number, a product of local root numbers computable from reduction data. In the
generic case with $E(QQ)[2] = 0$ this pins $dim "Sel"_2$ modulo 2 whenever $Ш[2^infinity]$
contributes evenly --- and it is often enough to decide between the two remaining possibilities
after the cheap bounds.

*(iii) Order the places by how much they cut.* $dim L_v$ is known in advance from the table of
@sec-h1, so one can predict which places are most restrictive --- the ones where $f$ is irreducible
over $QQ_v$, forcing $dim L_v = 0$ (or $1$ at $v = 2$) --- and impose those first.

= Relation to the other notes <sec-relation>

`selmer-involution.typ` is this machinery applied to $f = x^3 + a$, which by @sec-generic is generic
for every non-cube $a$. Its Lemma B$'$ is the dimension table of @sec-h1; its algebra $A_a$ is the
cubic field $K$ of @sec-h1; its descent map is the $x - theta$ of @sec-map; and its Proposition E ---
the valuation argument at the primes dividing $a$ --- is precisely the computation of $L_v$ that
Step 3 of @sec-full calls for. Its main theorem is a statement that two *different* curves give the
*same* subspace at every place; the present note is the same computation done once, for one curve,
to the end.

`selmer-local-conditions.typ` places all of this in the general Selmer-structure formalism: the
algorithm of @sec-full is (F1) finiteness, the table of @sec-h1 is (F2) self-duality, and the
absence of partial descent (@sec-nopartial) is the failure of the module to decompose --- which is
also why the statistics of $"Sel"_2$ in the generic case are the cleanest, being the
$"Gal" = S_3$ case where the Klagsbrun--Mazur--Rubin disparity depends on a single parameter.

`ec-density-bm.typ` §5 and `kummer-example-j0.typ` §6 both *use* Theorem 6 --- the first to say that
in the irreducible case the Brauer class on $E$ is a corestriction
$cal(A)_alpha = "cor"_(A(E) slash QQ(E)) (alpha, X - theta)$ rather than a quaternion algebra with
constant slots, the second to compute $beta_q$ as a sum of Hilbert symbols over $w divides q$ and to
flag that identification as *assumed*. Neither note points anywhere for it; @sec-tate supplies the
missing derivation, and @sec-tate-refs the missing citation. The
evaluation pairing $⟨alpha, delta_v (Q)⟩_v = "inv"_v cal(A)_alpha (Q)$ is Theorem 6 applied to
$beta = X(Q) - theta$, and the self-pairing functional $a |-> ⟨a,a⟩$ of the $j = 0$ note is
Corollary 7(b), $(N a, -1)_q$.

`csa-brauer.typ` supplies the last step of @sec-tate-37: turning the ramification set
$Sigma(alpha,beta)$ into an explicit pair $(a,b)$.

#v(3mm)

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Summary.* When $E[2]$ is generic there is exactly one descent available over $QQ$, and it is the
  full one. It computes a subgroup of the square classes of a cubic field with square norm, cut out
  by one local condition per bad place, each of predictable dimension. It costs the class group and
  units of that cubic field, and it fails to give the rank exactly by $dim Ш[2]$. Partial descent
  in the isogeny sense requires a rational 2-torsion point and therefore requires base change to
  the cubic field, where it answers a weaker question at comparable cost; partial descent in the
  sense of discarding local conditions is free, and the norm condition alone is usually half the
  answer.
]
