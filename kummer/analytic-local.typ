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
  #text(size: 16pt, weight: "bold")[Regular functions are $v$-adically analytic]
  #v(2mm)
  #text(size: 10pt)[The formal expansion of $f in cal(O)_(X,P)$ in local coordinates converges on a
  $v$-adic neighbourhood of $P$ --- proved from one fixed-point lemma, applied twice]
  #v(1mm)
  #text(size: 9pt, style: "italic")[with the formal group of an elliptic curve as the worked case]
]

#v(4mm)

= Statement <sec-statement>

Throughout, $K$ is a number field, $v$ a place of $K$, $K_v$ the completion, and $|dot|$ an absolute
value on $K_v$ inducing its topology. *No distinction is made between the archimedean and the
non-archimedean case*: the only properties used are that $|dot|$ is multiplicative, satisfies the
triangle inequality, and that $K_v$ is complete.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *Standing hypotheses.* $X$ is a variety over $K$ (a separated scheme of finite type), and
  $P in X(K)$ is a *regular* point of $X$, of local dimension $n = dim_P X$. Since $K$ is perfect,
  regular is the same as smooth. Regularity is not a convenience but a necessity: it is exactly what
  makes "local coordinates $x_1, dots, x_n$ at $P$" exist, and @sec-complements says what happens
  without it.

  #v(2mm)
  *Local coordinates* at $P$ means a regular system of parameters: elements
  $x_1, dots, x_n in frak(m)_P subset cal(O)_(X,P)$ whose classes form a $K$-basis of
  $frak(m)_P slash frak(m)_P^2$.
]

Because $cal(O)_(X,P)$ is a regular local ring of dimension $n$ containing its residue field $K$,
Cohen's structure theorem gives a canonical isomorphism
$ hat(cal(O))_(X,P) tilde.equiv K [[x_1, dots, x_n]] $
carrying $x_i$ to $x_i$, and $cal(O)_(X,P) arrow.r.hook hat(cal(O))_(X,P)$ is injective by Krull's
intersection theorem. The *formal expansion* of $f in cal(O)_(X,P)$ is its image
$ F = sum_alpha a_alpha x^alpha in K [[x_1, dots, x_n]], quad a_alpha in K . $

The set $X(K_v)$ carries the $v$-adic topology, defined through any affine chart and independent of
the choice. For $rho > 0$ write $D(rho) = { a in K_v^n : |a_i| < rho "for all" i }$.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Theorem.* With the hypotheses above, there exist $rho > 0$ and a $v$-adically open
  $Omega subset.eq X(K_v)$ with $P in Omega$ such that

  #v(1mm)
  *(a)* $sum_alpha |a_alpha| rho^(|alpha|) < infinity$; in particular $F$ converges absolutely at
  every point of $D(rho)$;

  #v(1mm)
  *(b)* $x = (x_1, dots, x_n)$ is defined on $Omega$ and maps it homeomorphically onto an open
  subset of $D(rho)$ containing $0$;

  #v(1mm)
  *(c)* $f$ is defined at every $Q in Omega$ and
  $ f(Q) = sum_alpha a_alpha thin x(Q)^alpha , $
  the series converging absolutely.

  #v(2mm)
  The conclusion holds for *every* choice of local coordinates at $P$, and $rho$ and $Omega$ may be
  shrunk freely.
]

The proof occupies @sec-series through @sec-proof. The engine is a single fixed-point lemma
(@sec-fixed), applied twice: once in a Banach algebra of power series, where it produces the
expansion and its convergence, and once in $K_v$ itself, where it produces the neighbourhood
$Omega$. That the two applications agree is a one-line functoriality argument, and it is what glues
"formal" to "analytic".

= Convergent power series <sec-series>

For $rho > 0$ and $F = sum_alpha a_alpha x^alpha in K_v [[x_1, dots, x_n]]$ set
$ norm(F)_rho = sum_alpha |a_alpha| rho^(|alpha|) in [0, infinity], quad
  K_v ⟨rho⟩ = { F : norm(F)_rho < infinity } , $
and let $K_v {x} = union.big_(rho > 0) K_v ⟨rho⟩$ be the ring of *convergent* power
series. (In the non-archimedean case the more usual condition is $|a_alpha| rho^(|alpha|) -> 0$;
since the number of $alpha$ with $|alpha| = d$ grows polynomially in $d$, the two conditions define
the same ring $K_v {x}$, differing only by a shrinking of $rho$.)

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Lemma 2.1.* $(K_v ⟨rho⟩, norm(dot)_rho)$ is a commutative Banach $K_v$-algebra:
  the norm satisfies $norm(lambda F)_rho = |lambda| norm(F)_rho$,
  $norm(F + G)_rho <= norm(F)_rho + norm(G)_rho$, $norm(F G)_rho <= norm(F)_rho norm(G)_rho$, and
  $K_v ⟨rho⟩$ is complete. For $a in D(rho)$ the evaluation
  $"ev"_a : K_v ⟨rho⟩ -> K_v$ is a $K_v$-algebra homomorphism with
  $|"ev"_a (F)| <= norm(F)_rho$.

  #v(2mm)
  _Proof._ Submultiplicativity: the $gamma$-th coefficient of $F G$ is
  $sum_(alpha + beta = gamma) a_alpha b_beta$, so
  $norm(F G)_rho <= sum_gamma sum_(alpha + beta = gamma) |a_alpha| |b_beta| rho^(|gamma|)
  = norm(F)_rho norm(G)_rho$. Completeness: $K_v ⟨rho⟩$ is the space of
  coefficient families that are absolutely summable against the weights $rho^(|alpha|)$, and $K_v$
  is complete. Evaluation: $|sum a_alpha a^alpha| <= sum |a_alpha| rho^(|alpha|)$, and absolute
  convergence licenses rearranging the product. $qed$
]

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Lemma 2.2 (shrinking).* If $F(0) = 0$ and $norm(F)_(rho_0) < infinity$, then for
  $0 < rho <= rho_0$,
  $ norm(F)_rho <= (rho slash rho_0) norm(F)_(rho_0) . $
  In particular $norm(F)_rho -> 0$ as $rho -> 0$.

  #v(2mm)
  _Proof._ Every $alpha$ occurring has $|alpha| >= 1$, so
  $rho^(|alpha|) = rho_0^(|alpha|) (rho slash rho_0)^(|alpha|) <= rho_0^(|alpha|) (rho slash rho_0)$.
  $qed$
]

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Lemma 2.3 (units).* If $F in K_v {x}$ and $F(0) != 0$ then $F$ is a unit of $K_v {x}$. Hence
  $K_v {x}$ is a local ring with maximal ideal ${F : F(0) = 0}$.

  #v(2mm)
  _Proof._ Rescale so $F(0) = 1$ and write $F = 1 - G$ with $G(0) = 0$. By Lemma 2.2 choose $rho$
  with $norm(G)_rho <= 1 slash 2$. Then $sum_(k >= 0) G^k$ converges in the Banach algebra
  $K_v ⟨rho⟩$ and is inverse to $F$. $qed$
]

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Lemma 2.4 (composition).* Let $F in K_v {y_1, dots, y_k}$ and $G_1, dots, G_k in K_v {x}$ with
  $G_i (0) = 0$. Then the formal composite $F(G_1, dots, G_k)$ lies in $K_v {x}$.

  #v(2mm)
  _Proof._ Pick $sigma$ with $norm(F)_sigma < infinity$, then by Lemma 2.2 pick $rho$ with
  $norm(G_i)_rho <= sigma$ for all $i$. Then
  $norm(F(G))_rho <= sum_beta |b_beta| product_i norm(G_i)_rho^(beta_i)
  <= sum_beta |b_beta| sigma^(|beta|) = norm(F)_sigma < infinity$; absolute convergence justifies
  the rearrangement. $qed$
]

= The fixed-point lemma <sec-fixed>

This is the implicit function theorem, stated so that it can be applied in any Banach algebra at
once. Fix $m = n + r$ and convergent power series $g_1, dots, g_r in K_v {T_1, dots, T_m}$ with
$ g_i (0) = 0 quad "and" quad M := ((partial g_i) / (partial T_(n+j)) (0))_(1 <= i,j <= r)
  in "GL"_r (K_v) . $
Write $T = (T', T'')$ with $T' = (T_1, dots, T_n)$ and $T'' = (T_(n+1), dots, T_m)$, and expand
$ g(T', T'') = A T' + M T'' + Q(T', T'') , $
where $A in M_(r times n)(K_v)$ collects the remaining linear terms and $Q$ collects all terms of
total degree $>= 2$.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Lemma 3.1.* There are $epsilon, delta > 0$, depending only on $g$, with the following property.
  Let $(B, norm(dot))$ be any commutative Banach $K_v$-algebra whose norm satisfies
  $norm(lambda b) = |lambda| norm(b)$ and $norm(b b') <= norm(b) norm(b')$. Then for every
  $u in B^n$ with $norm(u_i) <= epsilon$ there is a *unique* $t in B^r$ with
  $ norm(t_j) <= delta quad "and" quad g(u, t) = 0 "in" B^r . $
]

_Proof._ Let $R > 0$ be less than the radius of convergence of all the $g_i$, so that
$C_0 := sum_(|beta| + |gamma| >= 2) |q_(beta gamma)| R^(|beta| + |gamma| - 2)$ and
$C_1 := sum_(|beta| + |gamma| >= 2) |gamma| thin |q_(beta gamma)| R^(|beta| + |gamma| - 2)$ are both
finite, where $q_(beta gamma)$ are the coefficients of $Q$. (If the $g_i$ are polynomials, as they
will be in @sec-proof, these are finite sums and there is nothing to check.) Put
$ c = max_i sum_j |(M^(-1))_(i j)|, quad a = max_i sum_j |A_(i j)| , $
so that $norm(M^(-1) b) <= c max_j norm(b_j)$ and $norm(A b) <= a max_j norm(b_j)$ in any $B$: these
bounds use only the triangle inequality and $norm(lambda b) = |lambda| norm(b)$, so they are
*uniform in $B$*.

Choose
$ delta <= min(R, 1 / (4 c C_0), 1 / (2 c C_1)), quad
  epsilon <= min(delta, delta / (2 c a)) . $

Let $u in B^n$ with $norm(u_i) <= epsilon$ and let
$ cal(B) = { t in B^r : norm(t_j) <= delta "for all" j } , $
a closed ball in $B^r$ with the max norm, hence a complete metric space. For
$t in cal(B)$ all the series $g_i (u,t)$ converge absolutely in $B$, since
$norm(u_i), norm(t_j) <= delta <= R$. Define
$ N(t) = t - M^(-1) g(u, t) = -M^(-1) A u - M^(-1) Q(u, t) , $
the second equality by the expansion of $g$. A fixed point of $N$ is exactly a solution of
$g(u,t) = 0$, since $M^(-1)$ is invertible.

*$N$ maps $cal(B)$ into itself.* With $s = delta$ (note $epsilon <= delta$),
$ norm(Q(u,t)) <= sum_(|beta| + |gamma| >= 2) |q_(beta gamma)| epsilon^(|beta|) delta^(|gamma|)
  <= s^2 sum |q_(beta gamma)| R^(|beta| + |gamma| - 2) = C_0 delta^2 , $
using $epsilon, delta <= R$ and $|beta| + |gamma| >= 2$. Hence
$ norm(N(t)) <= c a epsilon + c C_0 delta^2 <= delta / 2 + delta / 4 <= delta . $

*$N$ is a contraction.* For $t, t' in cal(B)$ only the terms with $|gamma| >= 1$ survive in the
difference, and telescoping gives
$norm(t^gamma - t'^gamma) <= |gamma| thin delta^(|gamma| - 1) max_j norm(t_j - t'_j)$. Therefore
$ norm(N(t) - N(t')) <= c sum_(|gamma| >= 1, |beta| + |gamma| >= 2)
  |q_(beta gamma)| epsilon^(|beta|) |gamma| delta^(|gamma| - 1) max_j norm(t_j - t'_j)
  <= c C_1 delta max_j norm(t_j - t'_j) <= 1/2 max_j norm(t_j - t'_j) , $
where the middle step uses
$epsilon^(|beta|) delta^(|gamma| - 1) <= delta dot R^(|beta| + |gamma| - 2)$, valid because
$|beta| + |gamma| - 1 >= 1$ and $epsilon <= delta <= R$.

By the Banach fixed-point theorem $N$ has a unique fixed point in $cal(B)$. $qed$

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Lemma 3.2 (functoriality).* Let $chi : B -> B'$ be a $K_v$-algebra homomorphism with
  $norm(chi(b)) <= norm(b)$, and let $u, t$ be as in Lemma 3.1. Then $chi(t)$ is the unique solution
  attached to $chi(u)$.

  #v(2mm)
  _Proof._ $chi$ is continuous, so it commutes with the convergent series defining $g$; hence
  $g(chi(u), chi(t)) = chi(g(u,t)) = 0$, and $norm(chi(t_j)) <= norm(t_j) <= delta$, and
  $norm(chi(u_i)) <= epsilon$. Uniqueness in Lemma 3.1 applied over $B'$ finishes. $qed$
]

= Formal uniqueness <sec-formal>

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Lemma 4.1.* Let $L$ be any field and $g_1, dots, g_r in L[[T_1, dots, T_m]]$ with $g(0) = 0$ and
  $M in "GL"_r (L)$ as above. Then there is *at most one* $t in (x)^r subset L[[x_1, dots, x_n]]^r$
  with $g(x, t) = 0$, where $(x)$ denotes the maximal ideal.

  #v(2mm)
  _Proof._ Suppose $t, t'$ are two solutions and $t equiv t' mod (x)^d$ with $d >= 1$; write
  $e = t' - t in (x)^d$. Taylor expansion in the second block of variables gives
  $ 0 = g(x,t') - g(x,t) = sum_j (partial g) / (partial T_(n+j)) (x, t) thin e_j + O(e^2) . $
  Now $(partial g slash partial T_(n+j))(x,t) equiv M_(dot j) mod (x)$ because $x$ and $t$ lie in
  $(x)$, so the sum is $equiv M e mod (x)^(d+1)$; and $O(e^2) in (x)^(2d) subset.eq (x)^(d+1)$.
  Hence $M e equiv 0 mod (x)^(d+1)$ and, $M$ being invertible, $e in (x)^(d+1)$, i.e.
  $t equiv t' mod (x)^(d+1)$. Both solutions lie in $(x)^1$, so induction gives $t = t'$. $qed$
]

Two consequences used below. First, the solution produced by Lemma 3.1 in
$B = K_v ⟨rho⟩$ is *the* formal solution. Second, if the $g_i$ have coefficients in a
subfield $K subset.eq K_v$, then solving degree by degree --- which is possible, and determined, by
the same computation --- produces a solution in $K[[x]]^r$; by uniqueness it coincides with the
analytic one. *So the convergent solution automatically has coefficients in $K$.*

= The local presentation of a smooth point <sec-local>

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Proposition 5.1.* There are an affine open $U subset.eq X$ containing $P$, a closed embedding
  $U arrow.r.hook AA^m$ sending $P$ to the origin, and polynomials
  $g_1, dots, g_r in I(U) subset K[T_1, dots, T_m]$ with $r = m - n$, such that after renumbering
  the coordinates:

  #v(1mm)
  *(i)* $M = (partial g_i slash partial T_(n+j) (0))_(i,j)$ is invertible;

  #v(1mm)
  *(ii)* $U = V(g_1, dots, g_r)$ in some Zariski neighbourhood of $P$;

  #v(1mm)
  *(iii)* $T_1|_U, dots, T_n|_U$ is a system of local coordinates at $P$.
]

_Proof._ Choose any affine open $U = "Spec" A$ containing $P$ and a closed embedding
$U subset AA^m$ with $P |-> 0$; let $I = I(U)$. Since $P$ is a smooth point of local dimension $n$,
the Jacobian criterion says the matrix $(partial g slash partial T_j (0))_(g in I)$ has rank
$m - n = r$. Pick $g_1, dots, g_r in I$ realising that rank and renumber the $T_j$ so that (i)
holds.

For (ii): $V := V(g_1, dots, g_r)$ contains $U$ near $P$ and is cut out by $r$ equations whose
differentials at $0$ are independent, so $cal(O)_(V,P)$ is regular of dimension $m - r = n$; in
particular it is a domain. The surjection $cal(O)_(V,P) ->> cal(O)_(U,P)$ has kernel a prime
$frak(p)$ with $dim cal(O)_(V,P) slash frak(p) = n = dim cal(O)_(V,P)$, so $"ht" frak(p) = 0$ and
$frak(p) = 0$. Thus $cal(O)_(V,P) tilde.equiv cal(O)_(U,P)$, and two finite-type schemes with the
same local ring at $P$ agree on a neighbourhood.

For (iii): the relations $d g_i = sum_j (partial g_i slash partial T_j)(0) thin d T_j = 0$ hold in
$frak(m)_P slash frak(m)_P^2$, and by (i) they express $d T_(n+1), dots, d T_m$ in terms of
$d T_1, dots, d T_n$. Hence $d T_1, dots, d T_n$ span the $n$-dimensional space
$frak(m)_P slash frak(m)_P^2$, so they are a basis. $qed$

= Proof of the Theorem <sec-proof>

*Step 0: reduction to $K_v$.* Base change to $K_v$ commutes with everything in sight: $P$ remains a
smooth $K_v$-point of $X_(K_v)$, the local coordinates remain local coordinates, and the formal
expansion of $f$ over $K_v$ is the image of the one over $K$ --- *the same coefficients*. So we may
compute over $K_v$, and it is only the convergence statement that is at issue.

*Step 1: the special coordinates.* Take $U, g_i, m = n + r$ as in Proposition 5.1, and write
$x_i^0 = T_i|_U$ for $i <= n$, which by 5.1(iii) are local coordinates at $P$. Apply *Lemma 3.1
with $B = K_v ⟨rho⟩$* (the power series algebra in $n$ variables) and
$ u = (x_1, dots, x_n), quad norm(x_i)_rho = rho <= epsilon . $
This yields $phi = (phi_1, dots, phi_r) in K_v ⟨rho⟩^r$ with
$norm(phi_j)_rho <= delta$ and
$ g_i (x_1, dots, x_n, phi_1, dots, phi_r) = 0 quad (i = 1, dots, r) . $
Applying Lemma 3.2 to $"ev"_0 : K_v ⟨rho⟩ -> K_v$ shows $phi(0)$ is the unique small
solution of $g(0, t) = 0$, which is $t = 0$; hence $phi_j (0) = 0$. By Lemma 4.1 the $phi_j$ are
*the* formal solutions, so by 5.1(ii) they are the formal expansions of $T_(n+j)|_U$, and by
@sec-formal they have coefficients in $K$.

*Step 2: the neighbourhood.* Apply *Lemma 3.1 with $B = K_v$* itself. For each $a in D(epsilon)$
there is a unique $t(a) in K_v^r$ with $|t_j (a)| <= delta$ and $g(a, t(a)) = 0$; and by Lemma 3.2
applied to $"ev"_a$ --- which is norm-decreasing by Lemma 2.1 --- we get $t(a) = phi(a)$. Set
$ Omega = { Q in U(K_v) : |T_i (Q)| < epsilon " " (i <= n), " " |T_(n+j)(Q)| < delta " " (j <= r) } . $
Then $Omega$ is open in $X(K_v)$ (it is $U(K_v)$, open, intersected with an open box), contains $P$,
and by the previous sentence
$ Omega = { (a, phi(a)) : a in D(epsilon) } . $
So $x = (T_1, dots, T_n)$ maps $Omega$ bijectively onto $D(epsilon)$, continuously in both
directions --- the inverse being $a |-> (a, phi(a))$, continuous because a convergent power series
is continuous on its polydisc of convergence. This is (b), with $rho = epsilon$.

*Step 3: every regular function.* Let
$ cal(E) : cal(O)_(X,P) --> K_v [[x_1, dots, x_n]] $
be the expansion map, a $K_v$-algebra homomorphism. The affine coordinate ring $A$ of $U$ is
generated by the $T_i|_U$, whose expansions are $x_1, dots, x_n$ and $phi_1, dots, phi_r$, all in
$K_v ⟨rho⟩$. As $K_v ⟨rho⟩$ is a $K_v$-algebra, $cal(E)(A) subset.eq
K_v ⟨rho⟩$. A general $f in cal(O)_(X,P)$ is $g slash h$ with $g, h in A$ and
$h(P) != 0$; then $cal(E)(h)$ is convergent with constant term $h(P) != 0$, hence invertible in
$K_v {x}$ by Lemma 2.3, so
$ F = cal(E)(f) = cal(E)(g) dot cal(E)(h)^(-1) in K_v {x} . $
That is (a), after shrinking $rho$.

*Step 4: the identity on $Omega$.* Shrink $Omega$ so that $|h(Q) - h(P)| < |h(P)|$ on it, which is
possible since $h$ is continuous and $h(P) != 0$; then $h$ does not vanish on $Omega$ and $f$ is
defined there. Fix $Q in Omega$ and let $a = x(Q) in D(rho)$. Under the norm-decreasing
homomorphism $"ev"_a$ we have $x_i |-> T_i (Q)$ and, by Step 2, $phi_j |-> phi_j (a) = T_(n+j)(Q)$.
Hence for every $p in A$, $"ev"_a (cal(E)(p)) = p(Q)$, both sides being the same polynomial in the
coordinates of $Q$. Applying this to $g$ and $h$ and using that $"ev"_a$ is a ring homomorphism,
$ F(a) = "ev"_a (cal(E)(g)) dot "ev"_a (cal(E)(h))^(-1) = g(Q) slash h(Q) = f(Q) . $
That is (c).

*Step 5: arbitrary local coordinates.* Let $x'_1, dots, x'_n$ be any system of local coordinates at
$P$. Each $x'_i$ lies in $cal(O)_(X,P)$, so by Steps 3--4 its expansion $G_i$ in the coordinates
$x^0$ is convergent, and $G_i (0) = 0$ because $x'_i in frak(m)_P$. The matrix
$J = (partial G_i slash partial x_j (0))$ is the matrix of the change of basis of
$frak(m)_P slash frak(m)_P^2$ from $x^0$ to $x'$, hence invertible. Apply Lemma 3.1 to the
convergent system
$ tilde(g)_i (y, t) = G_i (t) - y_i quad (i = 1, dots, n) , $
for which $partial tilde(g)_i slash partial t_j (0) = J$ is invertible: it produces a convergent
$H$ with $H(0) = 0$ and $G(H(y)) = y$, and Lemma 4.1 gives $H(G(x)) = x$ as well. Since the
identification $K[[x']] tilde.equiv hat(cal(O))_(X,P) tilde.equiv K[[x^0]]$ sends $x'_i$ to $G_i$,
the expansion of $f$ in the coordinates $x'$ is
$ F' = F compose H , $
which is convergent by Lemma 2.4. Statements (a)--(c) for $x'$ follow, after replacing $Omega$ by
$Omega inter x'^(-1)(D(rho'))$. $qed$

= Complements <sec-complements>

== The expansion map, and a rigidity corollary <sec-rigidity>

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Corollary 7.1.* $cal(E) : cal(O)_(X,P) -> K_v {x}$ is an injective local homomorphism of
  $K$-algebras. Consequently, if $f in cal(O)_(X,P)$ vanishes on some $v$-adic neighbourhood of $P$
  in $X(K_v)$, then $f = 0$ in $cal(O)_(X,P)$, hence $f$ vanishes on the irreducible component of
  $X$ through $P$.
]

_Proof._ Injectivity is Krull. If $f$ vanishes near $P$, then by (c) the convergent series $F$
vanishes at every point of a polydisc of positive radius; a convergent power series with that
property has all coefficients zero --- for archimedean $v$ this is the identity theorem, for
non-archimedean $v$ it follows from Strassmann's theorem by induction on $n$. So $F = 0$ and
$f = 0$. $qed$

This is the statement that gets used whenever one argues that an algebraic identity may be *checked
$v$-adically on a small neighbourhood*: it is legitimate exactly because the expansion map is
injective.

== $X^"sm" (K_v)$ is a $K_v$-analytic manifold <sec-manifold>

Steps 2 and 5 say more than the theorem: the charts $x : Omega -> D(rho)$ obtained at the various
smooth rational points are analytically compatible, since the transition maps are the $H$ of Step 5,
convergent with convergent inverses. Hence $X^"sm"(K_v)$ is a $K_v$-analytic manifold of dimension
$n$, and every regular function on $X$ is analytic on it. For archimedean $v$ this is the classical
statement that a smooth variety over $RR$ or $CC$ is a real or complex manifold; for
non-archimedean $v$ it is the statement underlying every "$p$-adic density" argument.

== The integral refinement, for almost all $v$ <sec-integral>

In practice one wants more than *some* radius: one wants the whole residue disc, and coefficients
in $cal(O)_v$. This holds for all but finitely many $v$, and the proof is the same contraction run
in a different complete ring.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Proposition 7.2.* Suppose $v$ is non-archimedean, $g_1, dots, g_r in cal(O)_v [T_1, dots, T_m]$
  and $M in "GL"_r (cal(O)_v)$. Then the solution $phi$ of Step 1 lies in
  $cal(O)_v [[x_1, dots, x_n]]^r$, and the parametrisation $a |-> (a, phi(a))$ identifies
  $frak(m)_v^n$ with the residue disc of $P$ in $X(K_v)$.

  #v(2mm)
  _Proof._ Run the map $N(t) = -M^(-1) A x - M^(-1) Q(x,t)$ of @sec-fixed on
  $J dot cal(O)_v [[x]]^r$, where $J = (x_1, dots, x_n)$. All coefficients stay in $cal(O)_v$
  because $M^(-1), A, Q$ have entries there. If $t equiv t' mod J^d$ then each surviving term
  $q_(beta gamma) x^beta (t^gamma - t'^gamma)$ lies in $J^(|beta| + |gamma| - 1 + d) subset.eq
  J^(d+1)$, since $|beta| + |gamma| >= 2$; so $N$ is a contraction for the $J$-adic metric, which is
  complete. Its fixed point is $phi$, by Lemma 4.1. $qed$
]

Given a model of $X$ over $cal(O)_K [1 slash N]$ that is smooth along $P$, the hypotheses of 7.2
hold for every $v divides.not N$. This --- not the qualitative theorem --- is the form used when
one needs uniformity in $v$.

== What regularity was for <sec-singular>

If $P$ is a singular point there is no system of $n$ local coordinates, and the statement as posed
does not typecheck: $hat(cal(O))_(X,P)$ is not a power series ring. For the nodal cubic
$y^2 = x^2 (x+1)$ at the origin one has $hat(cal(O))_(X,P) tilde.equiv K[[u,w]] slash (u w)$, and
$X(K_v)$ near $P$ is two analytic branches crossing --- not a manifold. What survives is the
statement *branch by branch*: on the normalisation, where the preimages of $P$ are smooth, the
theorem applies unchanged. Similarly, if $P$ is a closed point whose residue field is a finite
extension $L slash K$ rather than $K$, one replaces $v$ by the places $w | v$ of $L$ and the theorem
holds over each $L_w$.

Nothing in @sec-series through @sec-proof used that $K$ is a number field beyond the completeness of
$K_v$. *The theorem holds verbatim over any field complete with respect to an absolute value* ---
$CC_p$, a Laurent series field, a completion of a function field.

= Worked example: the formal group of an elliptic curve <sec-example>

Let $E : y^2 = x^3 + a x + b$ over $K$, and let $P = cal(O)$ be the point at infinity, a smooth
rational point with $n = 1$. In the standard affine chart at infinity put
$ z = -x slash y, quad w = -1 slash y , $
so that $x = z slash w$ and $y = -1 slash w$; both $z$ and $w$ are regular at $cal(O)$, and $z$ is a
uniformiser, hence a local coordinate. Substituting into the Weierstrass equation and clearing
denominators gives the exact relation
$ w = z^3 + a z w^2 + b w^3 , $
that is $g(z, w) = 0$ for $g = T_2 - T_1^3 - a T_1 T_2^2 - b T_2^3$, with
$g(0,0) = 0$ and $partial g slash partial T_2 (0,0) = 1$, invertible. *This is precisely the
situation of Lemma 3.1 with $n = r = 1$*, so the theorem applies: the formal expansion
$w(z) in K[[z]]$ converges on a $v$-adic disc around $z = 0$, and there parametrises $E(K_v)$ near
$cal(O)$.

For $E : y^2 = x^3 - 16 x + 16$ (a model of `37a1`), iterating the relation gives
$ w(z) = z^3 - 16 z^7 + 16 z^9 + 512 z^11 - 1280 z^13 - 19712 z^15 + dots , $
the coefficients lying in $ZZ[a,b]$ as Proposition 7.2 predicts. Taking $v = 5$ and the point
$Q = 8 P_0$, where $P_0 = (0,4)$ generates $E(QQ)$, one has $v_5 (z(Q)) = 1$ and
$v_5 (w(Q)) = 3$; truncating the series at order $N$ and evaluating at $z(Q)$ gives an error of
valuation

#align(center, table(
  columns: 5, align: (left, center, center, center, center),
  stroke: 0.4pt + luma(170), inset: (x: 8pt, y: 3.5pt),
  table.header([truncation order $N$], [10], [20], [30], [40]),
  [$v_5 (w(Q) - w_N (z(Q)))$], [14], [23], [33], [43],
))

#v(2mm)

--- growing linearly in $N$, which is exactly what convergence at a point of valuation 1 predicts.
The computation is in `analytic-local.gp`.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *Why this example is the one that matters here.* The first proof of Lemma B$'$ in
  `selmer-involution.typ` opens with: "the formal group gives a finite-index subgroup of $E(K)$
  isomorphic to $(frak(m)_K, +) tilde.equiv ZZ_p^([K : QQ_p])$". That sentence *is* the theorem of
  @sec-statement, specialised to $X = E$, $P = cal(O)$, $f = w$: what makes the formal group a
  subgroup of $E(K_v)$ rather than a formal object is precisely that $w(z)$, and the formal group
  law, converge. The count $dim E(QQ_v) slash 2 = dim M^(G_v) + [QQ_v : QQ_2]$ rests on it.
]

= Where this is used elsewhere in these notes <sec-uses>

The theorem is the licence for three moves that are made constantly and rarely stated.

#align(center, table(
  columns: 2, align: (left, left),
  stroke: 0.4pt + luma(170), inset: (x: 7pt, y: 4pt),
  table.header([move], [what licenses it]),
  [treating $X(QQ_p)$ as a $p$-adic manifold and speaking of *density* of a subset],
    [@sec-manifold],
  [parametrising a residue disc by $ZZ_p^n$ and pushing a measure around],
    [Proposition 7.2],
  [checking an algebraic identity on a $p$-adic neighbourhood and concluding it globally],
    [Corollary 7.1],
))

#v(2mm)

The first two are what `kummer-padic-density.typ` and `kummer2.gp` assume throughout: `densegroup`
asks whether a subgroup of $E(QQ_p)$ is *dense*, a question that presupposes the analytic structure
of @sec-manifold and is answered by reducing to the formal group, i.e. to @sec-example. The third
is what allows a local computation to prove a global statement.
