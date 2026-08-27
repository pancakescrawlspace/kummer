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
  #text(size: 16pt, weight: "bold")[Corestriction]
  #v(2mm)
  #text(size: 10pt)[What the transfer is, why it deserves to be called a norm, and the one
  computation the descent notes actually use it for]
  #v(1mm)
  #text(size: 9pt, style: "italic")[checks in `corestriction.gp`]
]

#v(4mm)

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *Two questions, one answer.* Corestriction $"cor"_(K slash k) : H^i (K, M) -> H^i (k, M)$ is the
  map that pushes cohomology *down* from a bigger field to a smaller one. In degree $0$ it is
  literally the norm $N_(K slash k)$; in degree $1$ with $mu_n$ coefficients it is again the norm,
  on $K^times slash (K^times)^n$; in degree $2$ it is the map on Brauer groups that *preserves the
  local invariant*. All three are one definition, given in @sec-def.

  #v(2mm)
  The claim the descent notes rest on --- that the local Tate pairing on a $2$-descent module is a
  product of Hilbert symbols over the places of an étale algebra --- is a corollary, and
  @sec-tate proves it from scratch. The only non-formal input is $"inv" compose "cor" = "inv"$,
  which is local class field theory.
]

= The definition, and why it is a norm <sec-def>

Let $G$ be a group (for us $G = G_k = "Gal"(k^s slash k)$) and $H <= G$ of finite index $n$ (for us
$H = G_K$ for a separable $K slash k$ of degree $n$). Restriction $"res" : H^i (G, M) -> H^i (H, M)$
is obvious: a cocycle on $G$ is in particular a cocycle on $H$. Corestriction goes the other way,
and there is no map of cocycles doing it directly. It is manufactured in two steps.

== Step one: induced modules and Shapiro <sec-shapiro>

For an $H$-module $N$ put
$ "Ind"_H^G N := "Map"_H (G, N) = { phi : G -> N : phi(h g) = h phi(g) " for all " h in H } , $
a $G$-module by $(g_0 phi)(g) = phi(g g_0)$. Choosing coset representatives identifies
$"Ind"_H^G N$ with $N^([G:H])$ as a group, with $G$ permuting the factors and acting on each
through $H$.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Shapiro's lemma.* Evaluation at $1$,
  $ "ev"_1 : "Ind"_H^G N --> N , quad phi |-> phi(1) , $
  is $H$-equivariant, and the composite
  $ "sh" : H^i (G, "Ind"_H^G N) -->^("res") H^i (H, "Ind"_H^G N) -->^(("ev"_1)_*) H^i (H, N) $
  is an isomorphism for every $i$.
]

For Galois modules this says exactly: *cohomology of an induced module over $k$ is cohomology of
the original module over $K$.* Concretely, with $A = k[x] slash f$ an étale algebra and $Omega$ the
roots of $f$, the permutation module $F_2 [Omega]$ is $"Ind"_(G_A)^(G_k) mu_2$, and Shapiro reads
$ H^i (k, F_2[Omega]) = H^i (A, mu_2) , quad "so in degree" 1 : quad
  H^1 (k, F_2 [Omega]) = A^times slash (A^times)^2 . $

== Step two: the trace map <sec-trace>

Now let $N$ be a $G$-module, so that $"Ind"_H^G ("Res" N)$ makes sense. There is a canonical
$G$-map back to $N$:

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *The trace.* $ pi : "Ind"_H^G ("Res" N) --> N , quad
    pi(phi) = sum_(H g in H backslash G) g^(-1) phi(g) . $
  This is well defined ($g |-> h g$ changes nothing, since $(h g)^(-1) phi(h g) = g^(-1) h^(-1) h
  phi(g)$) and $G$-equivariant ($pi(g_0 phi) = sum_(H g) g^(-1) phi(g g_0) = g_0 pi(phi)$ after
  $g' = g g_0$).
]

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *Definition.* $ "cor"_(K slash k) := pi_* compose "sh"^(-1) :
    H^i (H, N) -->^("sh"^(-1)) H^i (G, "Ind"_H^G N) -->^(pi_*) H^i (G, N) . $
]

That is the whole construction: *transport to an induced module, then take the trace.*

== Why it is a norm <sec-norm>

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Degree $0$.* $H^0 (H, N) = N^H$ and $H^0 (G,N) = N^G$, and
  $ "cor" (x) = sum_(H g in H backslash G) g^(-1) x , $
  the sum over coset representatives --- the *norm*, written additively.

  #v(2mm)
  _Proof._ A $G$-invariant $phi in "Ind"_H^G N$ satisfies $phi(g g_0) = phi(g)$ for all $g_0$, so
  $phi$ is the constant function at some $x = phi(1)$, and $H$-equivariance forces $x in N^H$.
  Thus $"sh"^(-1)(x)$ is that constant function, and $pi$ of it is $sum_(H g) g^(-1) x$. $qed$
]

For $N = (k^s)^times$ this is *literally* $N_(K slash k) : K^times -> k^times$. That is the
sense in which corestriction "is" a norm, and it is the only intuition needed: everything below is
that map propagated up the degrees.

= The dictionary in low degrees <sec-dictionary>

Corestriction commutes with connecting maps --- it is a morphism of $delta$-functors, being induced
by a map of coefficient modules --- so degree $0$ determines degrees $1$ and $2$ on the modules we
care about.

#align(center, table(
  columns: 4, align: (center, left, left, left),
  stroke: 0.4pt + luma(170), inset: (x: 7pt, y: 4pt),
  table.header([$i$], [$H^i (K, -)$], [what $"cor"$ is], [why]),
  [$0$], [$(k^s)^times : K^times$], [$N_(K slash k)$], [@sec-norm],
  [$1$], [$mu_n : K^times slash (K^times)^n$],
    [$N_(K slash k)$ on classes], [Kummer $delta$ from $i=0$],
  [$1$], [$ZZ slash m$ (trivial): characters], [transfer of characters],
    [dual to the norm on $"Gal"^"ab"$],
  [$2$], [$mu_n$ (or $(k^s)^times$) : $"Br"(K)[n]$], [$"cor"$ on Brauer classes],
    [$delta$ from $i = 1$],
))

#v(2mm)

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Degree $1$, explicitly.* From $1 -> mu_n -> (k^s)^times -->^n (k^s)^times -> 1$ the connecting
  map identifies $K^times slash (K^times)^n tilde.equiv H^1 (K, mu_n)$, and the square
  $ K^times slash (K^times)^n --> H^1 (K, mu_n) , quad
    k^times slash (k^times)^n --> H^1 (k, mu_n) $
  commutes with $N_(K slash k)$ on the left and $"cor"$ on the right. So *corestriction on square
  classes is the norm* --- the fact `integral-bm.typ` §6 uses to check that a residue descends.
]

= The four properties everything is built from <sec-props>

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *(P1) $"cor" compose "res" = [G : H]$.*

  #v(1mm)
  _Proof._ For $x in H^i (G,N)$, $"sh"^(-1)("res" x)$ is the image of $x$ under
  $N -> "Ind"_H^G N$, $y |-> (g |-> g y)$; composing with $pi$ gives
  $sum_(H g) g^(-1) g y = [G:H] y$ on coefficients. $qed$

  #v(2mm)
  *(P2) Projection formula.* $"cor"(x union "res" y) = "cor"(x) union y$ for
  $x in H^i (H, N)$, $y in H^j (G, P)$.

  #v(2mm)
  *(P3) Shapiro is multiplicative.* If $N$ carries an $H$-equivariant product $N times N -> N'$,
  then $"Ind"_H^G N$ carries the coordinatewise product $(phi psi)(g) = phi(g) psi(g)$ into
  $"Ind"_H^G N'$, and
  $ "sh"(u) union "sh"(v) = "sh"(u union v) quad "in" H^(i+j) (H, N') $
  for $u, v in H^* (G, "Ind"_H^G N)$ --- where the left cup product uses the coordinatewise product.

  #v(2mm)
  *(P4) Local class field theory.* For $K slash k$ a finite extension of local fields,
  $ "inv"_k compose "cor"_(K slash k) = "inv"_K quad "on" "Br"(K) ,
    quad quad "inv"_K compose "res"_(K slash k) = [K : k] dot "inv"_k . $
]

(P1), (P2), (P3) are formal; (P4) is the one genuine input, and it is the statement that the
invariant map is compatible with the norm on the idele/Brauer side. See @sec-refs.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Proof of (P3), on cochains.* Both sides are computed by $"ev"_1$ after restriction to $H$, so
  it suffices that $"ev"_1$ is multiplicative and interacts correctly with the twist in the cup
  product. Write the cup product of inhomogeneous cochains as
  $ (c union c')(g_1, ..., g_(i+j)) = c(g_1,...,g_i) dot (g_1 ... g_i) c'(g_(i+1),...,g_(i+j)) . $
  Apply $"ev"_1$ to the coordinatewise product, with all $g_ell in H$ and $h := g_1 ... g_i in H$:
  $ "ev"_1 ((c union c')(dots.h)) = c(arrow(g))(1) dot ((h) c'(arrow(g)'))(1)
    = c(arrow(g))(1) dot c'(arrow(g)')(h) . $
  But $phi(h) = phi(h dot 1) = h phi(1)$ for $phi in "Map"_H (G, N)$ and $h in H$, so the right-hand
  factor is $h dot c'(arrow(g)')(1)$, and the whole expression is
  $("ev"_1 c) union ("ev"_1 c')$ evaluated at the same arguments. $qed$
]

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *What corestriction is not.* It does *not* shrink an algebra. If $A$ is a quaternion algebra over
  a cubic field $K$, then $"cor"_(K slash QQ) [A]$ is a Brauer class over $QQ$ of order dividing
  $2$, but the obvious algebra representing it --- the algebra-theoretic norm --- has degree
  $2^3 = 8$. The class is *Brauer-equivalent* to a quaternion algebra over $QQ$, but writing that
  quaternion algebra down means computing the ramification set, not manipulating the slots. That is
  exactly the point made in `descent-s3.typ` §4.2 and `ec-density-bm.typ` §5, and it is why the
  descent pairing in the irreducible case has no "constant slots" form.
]

= The computation the notes use: the local Tate pairing <sec-tate>

This is the statement the other notes assert and this section proves.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Setting.* $k$ a field of characteristic $!= 2$, $A$ an étale $k$-algebra of finite degree,
  $Omega = "Hom"_k (A, k^s)$ the set of $k$-embeddings with its $G_k$-action, and
  $M = F_2 [Omega]$ the permutation module. Give $M$
  #v(1mm)
  - the coordinatewise product $M times M -> M$, and
  - the trace $sigma : M -> F_2$, $sigma(sum_theta a_theta e_theta) = sum_theta a_theta$,
  #v(1mm)
  and let $⟨x, y⟩ = sigma(x y)$ be the resulting symmetric form, i.e. $⟨e_theta, e_(theta')⟩ =
  delta_(theta theta')$. Under $M = "Ind"_(G_A)^(G_k) mu_2$ these are the induced product and the
  trace $pi$ of @sec-trace: *the permutation form on $M$ is the trace form of $A$*.
]

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Theorem.* Let $k$ be a local field, $"char" k != 2$, and $A = product_w A_w$ an étale
  $k$-algebra. Under Shapiro's identification $H^1 (k, M) = A^times slash (A^times)^2$, the cup
  product pairing induced by $⟨thin , thin ⟩$,
  $ H^1 (k, M) times H^1 (k, M) --> H^2 (k, mu_2) = "Br"(k)[2] , $
  is
  $ ⟨alpha, beta⟩ = "cor"_(A slash k) (alpha, beta)_A
    = limits(⊗)_w "cor"_(A_w slash k) (alpha_w, beta_w)_(A_w) , $
  of invariant
  $ "inv"_k ⟨alpha, beta⟩ = sum_w "inv"_(A_w) (alpha_w, beta_w) in 1/2 ZZ slash ZZ , $
  equivalently $(-1)^(2 "inv"_k ⟨alpha,beta⟩) = product_w (alpha_w, beta_w)_(A_w)$, a product of
  ordinary Hilbert symbols, one per factor of $A$.

  #v(2mm)
  _Proof._ Three lines, one for each ingredient.

  #v(1mm)
  *(i)* The form is $sigma compose "mult"$, so the pairing on $H^1$ is the composite
  $ H^1 (k,M) times H^1(k,M) -->^("mult"_*(union)) H^2 (k, M) -->^(sigma_*) H^2 (k, mu_2) . $

  #v(1mm)
  *(ii)* By (P3), $"mult"_* (union)$ *is* the cup product of $H^1 (A, mu_2)$ carried across
  Shapiro: for $alpha, beta in A^times slash (A^times)^2 = H^1 (A, mu_2)$ it is
  $alpha union beta in H^2 (A, mu_2) = "Br"(A)[2]$, which is the quaternion class
  $(alpha, beta)_A$ --- componentwise, $((alpha_w, beta_w)_(A_w))_w$.

  #v(1mm)
  *(iii)* $sigma$ is the trace $pi$, so $sigma_*$ is $"cor"_(A slash k)$ by the definition of
  @sec-trace. Applying $"inv"_k$ and (P4) turns each factor into $"inv"_(A_w)$. $qed$
]

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *So the answer to "why a sum of Hilbert symbols over an extension field".* Because the descent
  module is *induced*; because the pairing on an induced module is the trace of the product; and
  because the trace of an induced module induces corestriction, whose effect on local invariants is
  the identity. The sum over $w$ is the sum over cosets in the definition of the trace --- nothing
  more.
]

== Two sanity checks that cost nothing <sec-checks>

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *(a) Restriction, then corestriction.* If $alpha, beta in k^times$ are pushed into $A^times$
  diagonally, every $(alpha, beta)_(A_w)$ is $"res"_(A_w slash k) (alpha,beta)_k$, so by (P4)
  $ product_w (alpha,beta)_(A_w) = (alpha,beta)_k^(sum_w [A_w : k]) = (alpha,beta)_k^(dim_k A) , $
  which is (P1) made visible: $"cor" compose "res" = dim_k A$.

  #v(2mm)
  *(b) Projection formula.* If only $beta = b$ is diagonal, (P2) gives
  $ ⟨alpha, b⟩ = "cor"(alpha union "res" b) = "cor"(alpha) union b = (N_(A slash k) alpha, thin b)_k , $
  a quaternion algebra over $k$ with *both slots in $k$* --- because $"cor"$ in degree $1$ is the
  norm (@sec-dictionary). This is the one case where the corestriction disappears, and it is
  Corollary 7 of `descent-s3.typ`.
]

= What the companion script checks <sec-gp>

`corestriction.gp` verifies, over $QQ$ with $A = QQ[x] slash (x^3 - 16x + 16)$ the cubic field of
`37a1` and with $B = QQ times QQ(sqrt(-1))$ a decomposable one. All counts are zero.

#v(1mm)
- *(P1), i.e. $"cor" compose "res" = deg$*: $product_(w divides v) (a,b)_(A_w) = (a,b)_v^3$ for
  rational $a, b$ --- $900$ symbols. Since $3$ is odd and the target is $2$-torsion this also says
  $"cor" compose "res" = "id"$ on $"Br"(QQ)[2]$ for an odd-degree extension.
- *(P2) and degree $1$*: $⟨alpha, b⟩_v = (N_(A slash QQ) alpha, thin b)_v$ for rational $b$ ---
  $450$ symbols over $A$, $640$ over $B$.
- *(P4) via reciprocity*: $product_v product_(w divides v) (alpha_w,beta_w)_w = 1$ on all $100$
  pairs of test classes. This is Hilbert reciprocity for $A$ regrouped by the places of $QQ$, and
  it is the check that the local invariants really do add up the way (P4) says.
- *degree $1$ is the norm, recovered not assumed*: for each test class $alpha$, solve for the
  square class $c in QQ^times slash (QQ^times)^2$ satisfying $(c, b)_v = product_w (alpha_w, b)_w$
  for all test $b$ and all $v$. The solution is *unique* in every case and equals
  $N_(A slash QQ) (alpha)$ modulo squares --- so the norm is forced by the pairing rather than
  put in by hand.

= References <sec-refs>

#block(inset: (left: 4pt))[
#set enum(numbering: "[1]")
+ K. S. Brown, *Cohomology of Groups*, GTM 87, Ch. III §9--§10. The cleanest treatment of the
  transfer: III.9 defines it exactly as @sec-def does, III.10 has (P1) and the Mackey formula.
+ J. Neukirch, A. Schmidt, K. Wingberg, *Cohomology of Number Fields*, 2nd ed., Ch. I. §4 for
  induced modules and Shapiro, §5 for cup products and their compatibilities --- (P2) and (P3) are
  there --- and Ch. VII for local duality and (P4).
+ J.-P. Serre, *Local Fields*, Ch. VII--XI. VII for the transfer, XI for
  $"inv" compose "cor" = "inv"$ in the form used above.
+ J.-P. Serre, *Galois Cohomology*, I §2.4 and II §1. Short and in exactly the Galois-module
  language of these notes.
+ P. Gille, T. Szamuely, *Central Simple Algebras and Galois Cohomology*, §3.9 and §4.2.
  Corestriction of Brauer classes with the algebra-theoretic norm alongside it --- the reference
  for "cor does not shrink the algebra".
+ B. Poonen, M. Stoll, #link("https://arxiv.org/abs/math/9911267")[*The Cassels--Tate pairing on
  polarized abelian varieties*], Ann. of Math. *150* (1999), 1109--1149. Where the Theorem of
  @sec-tate is used for descent, in the generality of hyperelliptic Jacobians.
]

= Where this is used in the repository <sec-used>

#align(center, table(
  columns: 2, align: (left, left),
  stroke: 0.4pt + luma(170), inset: (x: 7pt, y: 4pt),
  table.header([note], [what it needs from here]),
  [`descent-s3.typ` §4], [the Theorem of @sec-tate, with the corollaries of @sec-checks],
  [`kummer-example-j0.typ` §6.3], [the same, as $beta_q = sum_(w divides q) (dot,dot)_(K_w)$],
  [`ec-density-bm.typ` §5], [$cal(A)_alpha = "cor"_(A(E) slash QQ(E))(alpha, X - theta)$ and that
    corestriction preserves "unramified"],
  [`integral-bm.typ` §6], [$"cor"$ on square classes is the norm (@sec-dictionary)],
  [`csa-brauer.typ` §6], [(P1), to get exponent $divides$ degree],
  [`kummer-survey.typ` §8], [$"cor" compose "res" = [F:QQ]$ invertible mod $ell$, so classes
    descend],
))
