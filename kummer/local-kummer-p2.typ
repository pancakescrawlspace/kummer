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
  #text(size: 16pt, weight: "bold")[The local Kummer image at $p = 2$ for $y^2 = x^3 + 1$]
  #v(2mm)
  #text(size: 10pt)[An explicit set $V subset E(QQ_2)$ of representatives for
  $E(QQ_2) slash 2 E(QQ_2)$, and its image in $QQ_4^times$,
  $QQ_4$ the unramified quadratic extension of $QQ_2$]
  #v(1mm)
  #text(size: 9pt, style: "italic")[computed in `local-kummer-p2.gp`,
  output in `results/local-kummer-p2.txt`]
]

#v(4mm)

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *The answer.* Write $omega = zeta_3$, $omega^2 + omega + 1 = 0$, and
  $zeta_6 = -omega^2 = 1 + omega = (1 + sqrt(-3)) slash 2$, a root of $x^2 - x + 1$; then
  $QQ_4 = QQ_2 (omega)$ and the Kummer map is $delta(x, y) = x - zeta_6 = (x - 1) - omega$.
  Let $y in ZZ_2^times$ be the square root of $-7$ with $y equiv 3$ (mod $8$). Then
  $ V = { cal(O), thin (-1, 0), thin (-2, y), thin (-4, -3y) } $
  is a full set of representatives for $E(QQ_2) slash 2 E(QQ_2) tilde.equiv (ZZ slash 2)^2$, and
  $ "Im"(delta) = { 1, thin -2 - omega, thin -3 - omega, thin -5 - omega }
    dot (QQ_4^times)^2 = ⟨[-2-omega], thin [-3-omega]⟩
    subset QQ_4^times slash (QQ_4^times)^2 . $
  The four classes are pairwise distinct for a one-line reason: their norms to $QQ_2$ are
  $1, 3, 7, 21$, i.e. $1, 3, 7, 5$ mod $8$ --- *all four* square classes of $ZZ_2^times$, and a
  square has a square norm. Equivalently, in the basis $(2, -1, -2-omega, -3-omega)$ of the
  $16$-element group $QQ_4^times slash (QQ_4^times)^2$ constructed in @sec-target, the image is the
  span of the last two basis vectors.
]

= The map, and why its target is a single field <sec-map>

$E : y^2 = x^3 + 1$ is curve `36a1`; it has $j = 0$, CM by $ZZ[zeta_3]$, discriminant
$Delta = -432 = -2^4 dot 3^3$ and conductor $36$. Its $2$-torsion sits over
$ x^3 + 1 = (x + 1)(x^2 - x + 1) , $
so $E[2] = { cal(O), thin (-1,0), thin (-omega, 0), thin (-omega^2, 0) }$. Over $QQ_2$ the
quadratic factor stays irreducible, because its discriminant $-3 equiv 5$ (mod $8$) is not a
square in $QQ_2$; its roots are the primitive sixth roots of unity
$zeta_6^(plus.minus 1) = (1 plus.minus sqrt(-3)) slash 2$, and they generate
$ QQ_4 := QQ_2 (zeta_3) = QQ_2 (sqrt(-3)) = QQ_2 (sqrt(5)) , $
the *unramified* quadratic extension of $QQ_2$ (indeed $-3 dot 5 = -15 equiv 1$ mod $8$). Fix
$omega = zeta_3$ and $zeta_6 = -omega^2 = 1 + omega$ once and for all.

So $G_(QQ_2)$ fixes $T_0 = (-1, 0)$ and permutes the other two points through
$"Gal"(QQ_4 slash QQ_2) = ⟨sigma⟩$. As a module over
$bb(F)_2 [ "Gal"(QQ_4 slash QQ_2) ]$, $E[2]$ is *free of rank one* --- the two conjugate points
are a basis, and $T_0$ is their sum --- that is,
$ E[2] = "Ind"_(QQ_4)^(QQ_2) thin mu_2 , wide "so" wide
  H^1 (QQ_2, E[2]) tilde.equiv H^1 (QQ_4, mu_2) = QQ_4^times slash (QQ_4^times)^2 $
by Shapiro's lemma. *This* is why the target of the local Kummer map is the multiplicative group
of one field rather than of an étale algebra: at $p = 2$ the cubic $x^3 + 1$ has a rational root,
and what is left is exactly an induced module.

The same statement without cohomology, which is what the computation actually uses. Let
$L = QQ_2 [x] slash (x^3 + 1) = QQ_2 times QQ_4$ and let
$ E(QQ_2) slash 2 E(QQ_2) arrow.hook L^times slash (L^times)^2 , wide
  P = (x, y) arrow.r.bar (x + 1, thin x - zeta_6) $
be the classical descent map (for $P = T_0$, where the first entry vanishes, it is replaced by
$(e_1 - e_2)(e_1 - e_3) = 3$). The short exact sequence of Galois modules
$ 1 --> E[2] --> "Res"_(L slash QQ_2) mu_2 -->^N mu_2 --> 1 $
identifies its target as the *norm-one subgroup*
$ H^1 (QQ_2, E[2]) = ker (N : L^times slash (L^times)^2 --> QQ_2^times slash (QQ_2^times)^2) ,
  wide "of order" thin 128 slash 8 = 16 . $
Since $N(z_1, z_2) = z_1 dot N_(QQ_4 slash QQ_2)(z_2)$, the first coordinate of a norm-one element
is *determined mod squares* by the second. Hence projection to the $QQ_4$-factor is injective on
that subgroup, and by counting ($16 = 16$) it is an isomorphism onto
$QQ_4^times slash (QQ_4^times)^2$. Concretely, on points, the relation being used is
$ (x + 1) dot N_(QQ_4 slash QQ_2) (x - zeta_6) = (x+1)(x^2 - x + 1) = x^3 + 1 = y^2 . $

So *nothing is lost* by recording only the $QQ_4$-entry, and the local Kummer map may be taken to
be
$ delta : E(QQ_2) --> QQ_4^times slash (QQ_4^times)^2 , wide
  delta(x, y) = x - zeta_6 = (x - 1) - omega , wide delta(cal(O)) = 1 . $
It is a homomorphism killing $2E(QQ_2)$, and the naive formula is valid at *every* point of
$E(QQ_2)$: the only points where $x = zeta_6$ are the two non-rational $2$-torsion points, which
are not in $E(QQ_2)$. Note $delta$ depends on which root of $x^2 - x + 1$ is called $zeta_6$;
naming the other one replaces $delta$ by $sigma compose delta$ and the image by its Frobenius
conjugate (@sec-position, (d)). Everything below is stated for $zeta_6 = 1 + omega$.

= $E(QQ_2) slash 2E(QQ_2)$ has order $4$ <sec-size>

For any elliptic curve over a finite extension $K slash QQ_p$,
$\#E(K) slash m E(K) = \#E(K)[m] dot abs(m)_K^(-1)$. Here $K = QQ_2$, $m = 2$, and
$E(QQ_2)[2] = { cal(O), T_0 }$ by @sec-map, so
$ \#E(QQ_2) slash 2E(QQ_2) = 2 dot 2 = 4 = 2^(r_2 + 1), wide r_2 = 1 . $

It is worth having the group itself. The given model is minimal at $2$ ($v_2(Delta) = 4$,
$v_2(c_6) = 5$), and `elllocalred` returns Kodaira type $"IV"$ with $f = 2$ and Tamagawa number
$c_2 = 3$. In the filtration $E(QQ_2) supset E_0 supset E_1$:

- $E(QQ_2) slash E_0 tilde.equiv ZZ slash 3$ (that is $c_2 = 3$);
- $E_0 slash E_1 tilde.equiv tilde(E)_"ns" (bb(F)_2) = (bb(F)_2, +) tilde.equiv ZZ slash 2$, the
  reduction being additive;
- $E_1 tilde.equiv ZZ_2$, and it is torsion free: $E_1$ is pro-$2$, and the only $2$-torsion point
  $(-1, 0)$ reduces to $(1, 0)$, a *smooth* point of $tilde(E)$ (the singular point is $(0,1)$),
  so $(-1,0) in.not E_1$.

Hence $E(QQ_2) tilde.equiv ZZ_2 ⊕ ZZ slash 6$ and
$E(QQ_2) slash 2E(QQ_2) tilde.equiv (ZZ slash 2)^2$, of order $4$ as claimed.

One consequence shapes the search for $V$: *the global points are not enough*. $E(QQ) = ZZ slash 6$
is generated by $(2,3)$, and modulo $2E(QQ_2)$ its six points cover only two of the four cosets ---
$(0, plus.minus 1)$ is $3$-torsion, hence lies in $2E(QQ_2)$, and $(2, plus.minus 3) = T_0 +
(0, minus.plus 1)$ lies in the coset of $T_0$. The two missing cosets can only be reached by a
point whose $y$-coordinate is irrational.

= The target group $QQ_4^times slash (QQ_4^times)^2$ <sec-target>

$QQ_4$ has ring of integers $cal(O) = ZZ_2 [omega]$, residue field $bb(F)_4$ (so $q = 4$), and
$2$ as a uniformiser, the extension being unramified.

*Why the order is $2^([K : QQ_2] + 2)$.* Let $K slash QQ_2$ be any finite extension, of degree $d$,
with residue field of size $q$ and maximal ideal $frak(m)$. Choosing a uniformiser splits
$ K^times tilde.equiv pi^ZZ times mu_(q-1) times U^((1)) , wide U^((1)) = 1 + frak(m) $
--- valuation, Teichmüller lift of $k^times$, principal units. The one input that is not
bookkeeping is the structure of $U^((1))$: the $2$-adic logarithm is an isomorphism
$U^((m)) tilde.equiv frak(m)^m$ once $m > e slash (p - 1)$, and $frak(m)^m tilde.equiv
(cal(O), +) tilde.equiv ZZ_2^d$ as a topological group; since $U^((1)) supset U^((m))$ with finite
index, $U^((1))$ is a finitely generated $ZZ_2$-module of rank $d$, that is
$ U^((1)) tilde.equiv mu_(2^oo) (K) times ZZ_2^d . $
Now quotient by squares one factor at a time:

- $pi^ZZ$ gives $ZZ slash 2$ --- a class has even or odd valuation: a factor $2$;
- $mu_(q-1)$ has *odd* order, since $q = 2^f$, so it is uniquely $2$-divisible and contributes
  nothing;
- $ZZ_2^d slash 2ZZ_2^d$: a factor $2^d$;
- $mu_(2^oo)(K)$ is finite cyclic and contains $-1$, so modulo squares it contributes exactly $2$.

Multiplying, $\# K^times slash (K^times)^2 = 2 dot 2^d dot 2 = 2^(d + 2)$. Two of those three
factors are already familiar. The factor $2^d = abs(2)_K^(-1)$ is the same $abs(m)_K^(-1)$ that
governed $E(K) slash m E(K)$ in @sec-size, and for the same reason: it measures the failure of
$2$ to be invertible on a $ZZ_2$-module of rank $d$. The remaining two factors are
$\# mu_2 (K) = \# H^0 (K, mu_2)$ and $\# H^2 (K, mu_2) = \#"Br"(K)[2] = 2$, which is the whole
count in one line if one prefers cohomology --- the local Euler characteristic reads
$ (\# H^0 dot \# H^2) slash \# H^1 = abs(2)_K = 2^(-d) , wide "hence" wide
  \# H^1 (K, mu_2) = \# K^times slash (K^times)^2 = 2 dot 2 dot 2^d . $
The odd part $mu_(q-1)$ is invisible to $H^*(K, mu_2)$ for exactly the reason it was invisible
above.

For $K = QQ_4$ we have $d = 2$ and $q = 4$, the odd part is $mu_3$, and
$mu_(2^oo)(QQ_4) = {plus.minus 1}$: $i in.not QQ_4$, because $QQ_2 (i)$ is *ramified*
($x^2 + 1$ has discriminant $-4$) while $QQ_4 slash QQ_2$ is unramified. So
$ QQ_4^times tilde.equiv 2^ZZ times mu_3 times {plus.minus 1} times ZZ_2^2 , wide
  \# QQ_4^times slash (QQ_4^times)^2 = 2 dot 1 dot 2 dot 4 = 16 , $
and this already predicts the *shape* of a basis: one class of odd valuation, the class of $-1$,
and two unit classes coming from the $ZZ_2^2$. That is exactly the $B$ found below.

*A finite verification, with no structure theory.* First, $1 + 8cal(O) subset (cal(O)^times)^2$:
indeed $(1 + 4a)^2 = 1 + 8(a + 2a^2)$, and $a arrow.r.bar a + 2a^2$ is a bijection of $cal(O)$ by
Hensel. (This is the case $p = 2$, $e = 1$ of the threshold $m > p e slash (p-1)$ beyond which
$U^((m))$ consists of $p$-th powers; see `wild-symbols.typ`.) Hence a unit is a square as soon as
it is a square *modulo $8$*: if $u equiv v^2$ (mod $8$) then $u = v^2 (1 + 8t)$ with $1 + 8t$ a
square. Therefore
$ cal(O)^times slash (cal(O)^times)^2 = (cal(O) slash 8cal(O))^times slash
  ((cal(O) slash 8cal(O))^times)^2 , $
a computation inside a ring of $64$ elements. Enumerating it: of the $48$ units of
$cal(O) slash 8cal(O)$ exactly $6$ are squares, namely $mu_3 dot {1, 5}$, so the index is $8$;
together with the factor $2$ from the valuation this gives $16$ again, confirming the count by
brute force.

*Two more facts used below.* $-3 = (1 + 2omega)^2$ is a square, so $sqrt(-3) = 1 + 2omega$. And for
$a in QQ_2^times$: $a$ is a square in $QQ_4$ exactly when $v_2 (a)$ is even and its unit part is
$equiv 1$ or $5$ (mod $8$) --- because $QQ_4 = QQ_2 (sqrt(5))$, and $1, 5$ are the units that are
squares in $QQ_2$ or become so after adjoining $sqrt(5)$. In particular $[3] = [-1]$, $[7] = [-1]$
and $[21] = [1]$ in $QQ_4^times slash (QQ_4^times)^2$, although $3, 7, 21$ are non-squares in
$QQ_2$.

A basis is produced by the Hilbert symbol of $QQ_4$, which is a nondegenerate
$bb(F)_2$-valued pairing on this group; computing it as `nfhilbert` at the inert prime of
$QQ(omega)$ above $2$ (that completion *is* $QQ_4$) on
$B = (2, thin -1, thin -2-omega, thin -3-omega)$ gives the Gram matrix
$ ((. , .))_(i j) = mat(1, 1, -1, 1; 1, 1, -1, -1; -1, -1, -1, -1; 1, -1, -1, -1) ,
  wide #[i.e. over $bb(F)_2$] quad mat(0,0,1,0; 0,0,1,1; 1,1,1,1; 0,1,1,1) ,
  quad #[of determinant] thin 1 . $
Nondegenerate, so $B$ is an $bb(F)_2$-basis of $QQ_4^times slash (QQ_4^times)^2$; the script also
lists all $16$ products and checks that only the empty one is a square. Coordinates below are
taken in this basis. Finally, the norm gives a homomorphism
$N : QQ_4^times slash (QQ_4^times)^2 -> QQ_2^times slash (QQ_2^times)^2$ --- a square has a square
norm --- and that single remark is all the main theorem needs.

= The set $V$ <sec-V>

Let $y in ZZ_2^times$ be a square root of $-7$; one exists because $-7 equiv 1$ (mod $8$), and
Hensel pins it down by three binary digits: for $f(Y) = Y^2 + 7$,
$abs(f(3))_2 = 1 slash 16 < abs(f'(3))_2^2 = 1 slash 4$, so there is exactly one root with
$y equiv 3$ (mod $8$). To twenty digits,
$ y = 1 + 2 + 2^3 + 2^6 + 2^8 + 2^9 + 2^10 + 2^11 + 2^12 + 2^13 + 2^16 + 2^17 + 2^18 + O(2^20)
  = 474955 + O(2^20) , $
and $-3y = 672287 + O(2^20)$. Set
$ #box(inset: 4pt)[$V = { cal(O), quad T_0 = (-1, 0), quad P = (-2, thin y), quad
  P + T_0 = (-4, thin -3y) }$] $
Both non-torsion entries are on the curve, exactly: $(-2)^3 + 1 = -7 = y^2$ and
$(-4)^3 + 1 = -63 = 9 dot (-7) = (-3y)^2$. And they differ by $T_0$, by a three-line addition:
with $lambda = (0 - y) slash (-1 - (-2)) = -y$,
$ x_3 = lambda^2 - x_1 - x_2 = -7 + 2 + 1 = -4 , wide
  y_3 = lambda(x_1 - x_3) - y_1 = -y(-2 + 4) - y = -3y . $

*On precision.* The $x$-coordinates of $V$ are *rational*, so the Kummer classes computed in
@sec-image are exact --- no truncation enters $delta$ at all. The $2$-adic approximation is only
ever used to name the point: $y equiv 3$ (mod $8$) already determines $y$ uniquely, and the twenty
digits above are for concreteness. Even the choice of sign is immaterial, since $-P equiv P$
modulo $2E(QQ_2)$ and $delta$ sees only $x$.

= The image <sec-image>

Apply $delta(x,y) = (x - 1) - omega$ to $V$. Writing $N$ for $N_(QQ_4 slash QQ_2)$, so that
$N(a + b omega) = a^2 - a b + b^2$:

#align(center, table(
  columns: 6, align: (left, center, center, center, center, center),
  stroke: 0.4pt + luma(170), inset: (x: 8pt, y: 3.5pt),
  table.header([point], [$x$], [$delta = x - zeta_6$], [$N delta$], [$N delta$ mod $8$],
               [coordinates]),
  [$cal(O)$], [---], [$1$], [$1$], [$1$], [$(0,0,0,0)$],
  [$T_0 = (-1, 0)$], [$-1$], [$-2 - omega$], [$3$], [$3$], [$(0,0,1,0)$],
  [$P = (-2, y)$], [$-2$], [$-3 - omega$], [$7$], [$7$], [$(0,0,0,1)$],
  [$P + T_0 = (-4, -3y)$], [$-4$], [$-5 - omega$], [$21$], [$5$], [$(0,0,1,1)$],
))

#v(2mm)

*Theorem.* $V$ is a complete set of representatives for $E(QQ_2) slash 2E(QQ_2)$, and the image of
the local Kummer map at $2$ is
$ "Im"(delta) = { 1, thin -2-omega, thin -3-omega, thin -5-omega } dot (QQ_4^times)^2
  = ⟨[-2-omega], thin [-3-omega]⟩ tilde.equiv (ZZ slash 2)^2 . $

*Proof.* A square in $QQ_4$ has square norm in $QQ_2$. The four norms $1, 3, 7, 21$ are
$1, 3, 7, 5$ mod $8$, hence lie in four *different* classes of
$QQ_2^times slash (QQ_2^times)^2$; so the four values of $delta$ lie in four different classes of
$QQ_4^times slash (QQ_4^times)^2$. As $delta$ is injective on $E(QQ_2) slash 2E(QQ_2)$
(@sec-map) and that group has order $4$ (@sec-size), the four points of $V$ represent its four
cosets, and their $delta$-values are the whole image. $qed$

Two features of the answer are worth naming. The values are $(x - 1) - omega$ for
$x = -1, -2, -4$, so the whole image is the arithmetic-looking list $-2-omega$, $-3-omega$,
$-5-omega$; in terms of $sqrt(-3)$ these are $-(3 + sqrt(-3)) slash 2$,
$-(5 + sqrt(-3)) slash 2$, $-(9 + sqrt(-3)) slash 2$. And the norm map is *injective on the
image*, carrying it isomorphically onto the full $ZZ_2^times slash (ZZ_2^times)^2 = { 1,3,5,7 }$.

Multiplicativity is visible by hand, as it must be:
$ (-2-omega)(-3-omega) = 5 + 4omega , wide
  (5 + 4omega)(-5-omega) = -(21 + 21 omega) = -21(1 + omega) = 21 omega^2 , $
which is a square, since $21 equiv 5$ (mod $8$) is a square in $QQ_4$ and $omega^2 = (omega)^2$.
So $[5 + 4 omega] = [-5-omega]$, i.e. $delta(P + T_0) = delta(P) delta(T_0)$.

= Cross-checks <sec-checks>

*(a) Torsion.* $(0,1) = 2 dot (0,-1)$ lies in $2E(QQ_2)$ and must map to $1$: indeed
$delta(0, 1) = -1 - omega = omega^2$, a square. And $(2, plus.minus 3) = T_0 + (0, minus.plus 1)$
must land in the class of $T_0$: $delta(2,3) = 1 - omega$, and
$(1 - omega)(-2 - omega) = -3 = (1 + 2omega)^2$, so the two classes agree.

*(b) A brute-force scan.* Independently of any theory, sample $x in QQ$ (dense in $QQ_2$) with
$x^3 + 1$ a square in $QQ_2$ --- every such $x$ gives a genuine point of $E(QQ_2)$ --- and record
the class of $x - zeta_6$. Over $1034$ sampled points, with $v_2 (x)$ ranging over
$0, -2, -4, ..., -12$ as well as $x in ZZ$, *exactly four* classes occur, and they are the four
above.

*(c) The discarded coordinate.* Restoring the $QQ_2$-entry of the étale-algebra map must reproduce
the norm, by the identity $(x+1) N(x - zeta_6) = y^2$ of @sec-map:

#align(center, table(
  columns: 5, align: (center,)*5,
  stroke: 0.4pt + luma(170), inset: (x: 8pt, y: 3.5pt),
  table.header([$x$], [$QQ_2$-entry], [mod $8$], [$N(x - zeta_6)$], [mod $8$]),
  [$-1$], [$3$], [$3$], [$3$], [$3$],
  [$-2$], [$-1$], [$7$], [$7$], [$7$],
  [$-4$], [$-3$], [$5$], [$21$], [$5$],
))

= Where the image sits <sec-position>

*(a) It is unramified, but that is not the local condition.* All four classes are *unit* classes:
$"Im"(delta) subset H_"ur" := cal(O)^times (QQ_4^times)^2 slash (QQ_4^times)^2$, of order $8$ ---
even though $E$ has *additive* reduction at $2$. But $H_"ur"$ itself is far too big to be a local
condition: duality demands order $4$. The image is the index-$2$ subgroup cut out inside
$H_"ur"$ by a single character, and $[-1]$ is the class of $H_"ur"$ that fails it:
$ "Im"(delta) = { z in H_"ur" : (z, thin sigma(-2-omega))_(QQ_4) = 1 } , wide
  (-1, thin sigma(-2-omega))_(QQ_4) = -1 . $
Equivalently: $N$ maps $H_"ur"$ two-to-one onto $ZZ_2^times slash (ZZ_2^times)^2$ with kernel
${1, [-1]}$, and the image is the complement of that kernel picked out by the points of $E$.

*(b) Maximal isotropy, and a twist that is easy to get wrong.* $\#H^1 (QQ_2, E[2]) = 16$ and
local Tate duality forces $"Im"(delta)$ to be maximal isotropic, of order $4$ --- which matches. But
the pairing that does this is *not* the Hilbert symbol of $QQ_4$. The Weil pairing on
$E[2] = "Ind" thin mu_2$ is the standard pairing of the induced module *composed with the swap*
of the two conjugate points, so under Shapiro the Tate pairing becomes the Frobenius twist
$(a, b) arrow.r.bar (a, thin sigma b)_(QQ_4)$. The two versions on
$"Im"(delta) = (u_1, u_2, u_3, u_4)$ are
$ ((u_i, u_j)) = mat(1,1,1,1; 1,-1,-1,1; 1,-1,-1,1; 1,1,1,1) , wide
  ((u_i, sigma u_j)) = mat(1,1,1,1; 1,1,1,1; 1,1,1,1; 1,1,1,1) . $
The plain symbol is *not* trivial on the image --- already $(u, u)_(QQ_4) = -1$ for
$u = -2-omega$ --- while the twisted one vanishes identically, and the twisted annihilator of the
image is computed to be the image itself, four classes. So the image is maximal isotropic on the
nose, and the swap is not bookkeeping: it is what makes duality come out.

*(c) The other root.* $delta$ was built from $zeta_6 = 1 + omega$. Using $overline(zeta_6)$
instead replaces each value by its conjugate, and since
$sigma(z) = N(z) slash z$ one has $[sigma z] = [N(z) dot z]$; concretely the image becomes
$⟨[omega - 1], [omega - 2]⟩$, a *different* maximal isotropic subgroup, meeting the
first one in ${1, [-5-omega]}$. Nothing is ambiguous: the description is equivariant, and both
$delta$ and its image are conjugated together the moment one renames $omega$ as $omega^2$.

= What the companion script checks <sec-gp>

`local-kummer-p2.gp`, results in `results/local-kummer-p2.txt`. Local arithmetic of $QQ_4$ is done
inside the *number* field $QQ(omega)$ at its inert prime above $2$, whose completion is $QQ_4$;
`nfhilbert` there is the Hilbert symbol of $QQ_4$, and since that symbol is nondegenerate,
"is a square in $QQ_4$" is decided by pairing against the basis $B$ --- no square-root extraction
in a $2$-adic extension is needed anywhere.

#v(1mm)
- *(1)* Reduction data: minimality at $2$, Kodaira type $"IV"$, $c_2 = 3$, and the resulting
  $E(QQ_2) tilde.equiv ZZ_2 ⊕ ZZ slash 6$ (@sec-size).
- *(2)* The Gram matrix of the Hilbert symbol on $B$, its determinant $1$ over $bb(F)_2$, and the
  full table of $16$ classes with their norms and square-or-not verdicts (@sec-target).
- *(3)* That the four points of $V$ lie on $E$ and that $(-2,y) + (-1,0) = (-4,-3y)$ exactly, in
  $QQ_2$ to $39$ binary digits (@sec-V).
- *(4)* The image table, the four norms, and the homomorphism identity
  $delta(P) delta(T_0) = delta(P + T_0)$ (@sec-image).
- *(5)* The $1034$-point brute-force scan, which reaches exactly four classes (@sec-checks).
- *(6)* Plain versus Frobenius-twisted Hilbert pairings on the image, and that the twisted
  annihilator of the image is the image (@sec-position).
- *(7)* The étale-algebra cross-check of the discarded $QQ_2$-coordinate (@sec-checks).

= References <sec-refs>

#block(inset: (left: 4pt))[
#set enum(numbering: "[1]")
+ J. H. Silverman, *The Arithmetic of Elliptic Curves*, 2nd ed., GTM 106. VIII.1 for
  $\#E(K) slash m E(K) = \#E(K)[m] dot abs(m)_K^(-1)$; VII.6--VII.7 for the filtration
  $E supset E_0 supset E_1$ and $E_1 tilde.equiv hat(E)(frak(m))$; X.1 for the descent map
  $x - e$.
+ E. F. Schaefer, *Class groups and Selmer groups*, J. Number Theory *56* (1996), 79--114. The
  étale-algebra formulation used in @sec-map: $H^1(K, E[2]) = ker(N : L^times slash (L^times)^2 ->
  K^times slash (K^times)^2)$ for $L = K[x] slash f$.
+ B. Poonen, E. F. Schaefer, *Explicit descent for Jacobians of cyclic covers of the projective
  line*, J. reine angew. Math. *488* (1997), 141--188, for the same map in general.
+ J. S. Milne, *Arithmetic Duality Theorems*, I.2 (local duality, Euler characteristic) and the
  compatibility of Shapiro's lemma with the local pairing --- the source of the Frobenius twist in
  @sec-position.
+ J.-P. Serre, *Corps Locaux*, XIV, for the Hilbert symbol at $2$ and the structure of
  $K^times slash (K^times)^2$ for a $2$-adic field.
+ Companion notes in this repository: `local-duality.typ` for the duality statement itself,
  `kummer-example-j0.typ` and `kummer-example-p13.typ` for the same descent run at other $j = 0$
  curves and other places.
]
