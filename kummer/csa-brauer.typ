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
  #text(size: 16pt, weight: "bold")[Central simple algebras in number theory]
  #v(2mm)
  #text(size: 10pt)[An explicit tour: quaternion and cyclic algebras, the local invariant,
  reciprocity, and the theorems they prove]
  #v(1mm)
  #text(size: 9pt, style: "italic")[cohomological readings are set off in grey boxes and may be
  skipped; computations in `csa-brauer.gp`]
]

#v(4mm)

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *How to read this.* The argument runs on explicit algebras --- quaternion algebras $(a,b)$,
  cyclic algebras $(L slash K, sigma, b)$, Hilbert symbols --- and never needs class field theory as
  an input. On the contrary: the Brauer group is one of the standard ways to *state and prove* class
  field theory, and that is how it appears below. Wherever an explicit step is a cohomological
  statement in disguise, a grey box says which.
]

= The objects <sec-objects>

Let $K$ be a field. A *central simple algebra* (CSA) over $K$ is a finite-dimensional
$K$-algebra $A$ with centre exactly $K$ and no two-sided ideals but $0$ and $A$.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Wedderburn.* Every CSA over $K$ is $A tilde.equiv M_m (D)$ for a division algebra $D$ with
  centre $K$, and $D$ is determined by $A$ up to isomorphism. Moreover $dim_K A$ is always a square,
  say $dim_K A = n^2$; $n$ is the *degree*, and $sqrt(dim_K D)$ is the *index* of $A$.
]

Two CSAs are *Brauer equivalent* if they have the same $D$. The set of classes, with the product
induced by $⊗_K$, is a group: the *Brauer group* $"Br"(K)$. The identity is the class of
$M_n (K)$; the inverse of $A$ is the opposite algebra $A^"op"$, because
$A ⊗_K A^"op" tilde.equiv M_(n^2)(K)$. A field $L supset.eq K$ *splits* $A$ if
$A ⊗_K L tilde.equiv M_n (L)$; the classes split by $L$ form a subgroup $"Br"(L slash K)$.

Everything below is built from two families of examples, and they are completely explicit.

== Quaternion algebras <sec-quat>

For $a, b in K^times$ (char $K != 2$), let
$ (a,b)_K = K ⟨i, j⟩ quad "with" quad i^2 = a, quad j^2 = b, quad i j = - j i . $
This is a CSA of degree 2, with $K$-basis $1, i, j, i j$. There are only two possibilities: it is a
division algebra, or it is $M_2 (K)$ --- in which case one says it *splits*.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Proposition 1.1.* The following are equivalent:
  #v(1mm)
  (i) $(a,b)_K$ splits; (ii) the conic $a x^2 + b y^2 = z^2$ has a $K$-point other than the origin;
  (iii) $b$ is a norm from $K(sqrt(a))$; (iv) the quadratic form $⟨a, b, -1⟩$ represents $0$.

  #v(2mm)
  _Sketch._ The reduced norm of $x + y i + z j + w i j$ is $x^2 - a y^2 - b z^2 + a b w^2$. An
  algebra of degree 2 is split iff its norm form is isotropic, and one checks directly that the
  norm form is isotropic iff $⟨a,b,-1⟩$ is. For (iii): $(a,b)$ contains $K(sqrt(a)) = K(i)$, and
  $j x j^(-1) = overline(x)$ for $x in K(i)$, so $(a,b)$ is the cyclic algebra of $K(sqrt a) slash
  K$ with twisting element $b$; a degree-2 cyclic algebra splits iff the twisting element is a norm.
  $qed$
]

*The Hilbert symbol* is the indicator of this: for a local field $K_v$ put
$ (a,b)_v = cases(+1 & "if" (a,b)_(K_v) "splits", -1 & "otherwise.") $
This is the single most useful explicit object in the subject, and PARI computes it as
`hilbert(a,b,p)` (with `p = 0` for the real place).

== Cyclic algebras <sec-cyclic>

Let $L slash K$ be cyclic of degree $n$ with $"Gal"(L slash K) = ⟨sigma⟩$, and $b in K^times$. Put
$ (L slash K, sigma, b) = ⊕_(k=0)^(n-1) L u^k , quad
  u^n = b, quad u x = sigma(x) u " for " x in L . $
This is a CSA of degree $n$ over $K$, split by $L$.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Proposition 1.2.* $(L slash K, sigma, b)$ splits if and only if $b in N_(L slash K)(L^times)$.
  More generally $(L slash K, sigma, b) tilde.equiv (L slash K, sigma, b')$ iff
  $b slash b' in N_(L slash K)(L^times)$, so
  $ b |-> (L slash K, sigma, b) quad "induces" quad
    K^times slash N_(L slash K)(L^times) tilde.equiv "Br"(L slash K) . $
]

This one isomorphism is the engine of everything that follows: *it converts a norm question into an
algebra question.* The quaternion algebra $(a,b)$ is the case $L = K(sqrt a)$, $n = 2$.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *Cohomological reading.* $"Br"(K) tilde.equiv H^2 (G_K, overline(K)^times)$, with $"Br"(L slash K)
  = H^2("Gal"(L slash K), L^times)$; the cyclic algebras realise the periodicity of the cohomology
  of a cyclic group, $H^2 (ZZ slash n, L^times) = K^times slash N(L^times)$, which is Proposition
  1.2. The quaternion algebra $(a,b)$ is the cup product of the classes of $a$ and $b$ under
  $K^times slash (K^times)^2 = H^1 (K, mu_2)$, and the Hilbert symbol is that cup product evaluated
  by the local invariant of @sec-local. "Crossed product algebra" is the explicit name for a
  2-cocycle; @sec-crossed makes this precise and derives it.
]

The *exponent* (or period) of $A$ is its order in $"Br"(K)$; the *index* is $sqrt(dim_K D)$. Always
$"exponent" | "index"$ and they have the same prime factors. Over number fields they are *equal*
(@sec-divalg) --- a theorem with no analogue over general fields.

= Local fields: the invariant, explicitly <sec-local>

Let $K_v$ be a non-archimedean local field with residue field $bb(F)_q$, uniformiser $pi$, and let
$K_n$ be *the* unramified extension of degree $n$, cyclic with canonical generator the Frobenius
$phi$.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Theorem 2.1.* Every CSA over $K_v$ is split by an unramified extension. Concretely, every class
  in $"Br"(K_v)$ is $(K_n slash K_v, phi, pi^r)$ for some $n$ and $r$, and
  $ "inv"_v (K_n slash K_v, phi, pi^r) = r / n in QQ slash ZZ $
  is a well-defined isomorphism
  $ "inv"_v : "Br"(K_v) tilde.equiv QQ slash ZZ . $
  The index of the class of invariant $r slash n$ (in lowest terms) is exactly $n$.
]

So the local Brauer group is $QQ slash ZZ$, and *the invariant is nothing but a valuation divided by
a degree*. Two consequences to keep in mind:

- $"inv"_v$ of a quaternion algebra is $0$ or $1 slash 2$, and
  $(a,b)_v = (-1)^(2 "inv"_v (a,b))$. The Hilbert symbol is the invariant, written multiplicatively.
- For the archimedean places: $"Br"(RR) = {0, HH} tilde.equiv 1/2 ZZ slash ZZ$ with $HH$ Hamilton's
  quaternions $(-1,-1)_RR$, and $"Br"(CC) = 0$.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Local class field theory, for free.* Combining 1.2 and 2.1: for $L slash K_v$ cyclic of degree
  $n$, $"Br"(L slash K_v)$ is the subgroup $1/n ZZ slash ZZ$, so
  $ K_v^times slash N_(L slash K_v) (L^times) tilde.equiv 1/n ZZ slash ZZ
    tilde.equiv "Gal"(L slash K_v) . $
  That is the local reciprocity isomorphism, and it fell out of counting invariants.
]

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *Cohomological reading.* $"inv"_v$ is the composite
  $H^2 ("Gal"(K_n slash K_v), K_n^times) -->^(v) H^2 ("Gal"(K_n slash K_v), ZZ)
  tilde.equiv H^1 ("Gal"(K_n slash K_v), QQ slash ZZ) -->^(phi |-> 1 slash n) 1/n ZZ slash ZZ$,
  the first map induced by the valuation (the units contribute nothing, by Hilbert 90 and the
  vanishing of $H^2$ of the unit group in the unramified case). The class of invariant $1 slash n$
  is the *fundamental class*, and the whole of local class field theory is the statement that
  $(K_v, "inv")$ is a class formation.
]

= The two global theorems <sec-global>

Now let $K$ be a number field. A CSA $A$ over $K$ has a local invariant at each place,
$"inv"_v (A ⊗_K K_v) in QQ slash ZZ$, zero for all but finitely many $v$ (those where $A$ has
"good reduction"). The whole of global class field theory is packaged in one exact sequence.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Theorem 3.1 (the fundamental sequence).*
  $ 0 --> "Br"(K) --> ⊕_v "Br"(K_v) -->^(sum_v "inv"_v) QQ slash ZZ --> 0 . $
  The two non-trivial assertions are:

  #v(1.5mm)
  *(a) Albert--Brauer--Hasse--Noether.* $A$ splits over $K$ if and only if $A ⊗_K K_v$ splits for
  every place $v$. (Injectivity: a Hasse principle for algebras.)

  #v(1.5mm)
  *(b) Reciprocity.* $sum_v "inv"_v (A) = 0$ for every $A$. (The composite is zero, and the
  sequence is exact.)
]

Part (b), written multiplicatively for quaternion algebras, is *Hilbert reciprocity*:
$ product_v (a,b)_v = 1 quad "for all" a, b in K^times . $
`csa-brauer.gp` verifies this on a sample; e.g. for $(a,b) = (2,3)$ over $QQ$ the only non-trivial
symbols are $(2,3)_2 = (2,3)_3 = -1$, and the product is $+1$.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *Cohomological reading.* Theorem 3.1 is the statement that the idele class group is a class
  formation with fundamental class of invariant $1 slash n$; part (a) is
  $H^2 (K, overline(K)^times) arrow.r.hook ⊕_v H^2 (K_v, overline(K_v)^times)$, i.e. the vanishing
  of $Ш^2 (K, overline(K)^times) = Ш^2(K, GG_m)$. Global class field theory --- Artin
  reciprocity, the existence theorem --- is *equivalent* to Theorem 3.1, and this is one of the
  standard routes to proving it.
]

= Reciprocity *is* quadratic reciprocity <sec-quadrec>

The cleanest illustration that Theorem 3.1(b) is not an abstraction. Let $p != q$ be odd primes and
take $a = p$, $b = q$ in Hilbert reciprocity. Three explicit local formulas:

$ (p,q)_infinity = 1 quad (p,q > 0), quad quad
  (p,q)_ell = 1 quad (ell divides.not 2 p q), $
$ (p,q)_p = (q / p), quad quad (p,q)_q = (p / q), quad quad
  (p,q)_2 = (-1)^(epsilon(p) epsilon(q)), quad epsilon(m) = (m-1)/2 mod 2 . $

So the product formula $product_v (p,q)_v = 1$ collapses to three factors and reads

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  $ (q / p) (p / q) = (-1)^((p-1)/2 dot (q-1)/2) , $
  which is Gauss's law of quadratic reciprocity.
]

The same trick with $a = -1$ and $a = 2$ gives the two supplements: $(-1,q)_q = ((-1) slash q)$ and
$(-1,q)_2 = (-1)^(epsilon(q))$ give $((-1) slash q) = (-1)^((q-1) slash 2)$; and $(2,q)_2 =
(-1)^(omega(q))$ with $omega(m) = (m^2-1) slash 8$ gives $(2 slash q) = (-1)^((q^2-1) slash 8)$.

`csa-brauer.gp` checks the three local identities and the resulting law on a sample of pairs:

#align(center, table(
  columns: 8, align: (center,)*8,
  stroke: 0.4pt + luma(170), inset: (x: 6pt, y: 3.5pt),
  table.header([$p$], [$q$], [$(p,q)_p$], [$(q slash p)$], [$(p,q)_q$], [$(p slash q)$],
               [$(p,q)_2$], [$(-1)^(epsilon epsilon)$]),
  [3], [5], [$-1$], [$-1$], [$-1$], [$-1$], [$+1$], [$+1$],
  [3], [7], [$+1$], [$+1$], [$-1$], [$-1$], [$-1$], [$-1$],
  [7], [11], [$+1$], [$+1$], [$-1$], [$-1$], [$-1$], [$-1$],
  [13], [17], [$+1$], [$+1$], [$+1$], [$+1$], [$+1$], [$+1$],
))

#v(2mm)

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *Cohomological reading.* Quadratic reciprocity is the degree-2 case of Artin reciprocity, and the
  product formula is the statement that the global fundamental class has total invariant zero. That
  the *hardest* classical theorem of elementary number theory is the *easiest* consequence of the
  sequence in Theorem 3.1 is the best advertisement the Brauer group has.
]

= Applications <sec-applications>

== Conics, Legendre, Hasse--Minkowski <sec-conics>

By Proposition 1.1, a conic $a x^2 + b y^2 = z^2$ over $K$ has a rational point iff $(a,b)_K$
splits. Applying ABHN:

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Legendre's theorem.* $a x^2 + b y^2 = z^2$ has a non-trivial $K$-point if and only if it has one
  over every $K_v$ --- equivalently $(a,b)_v = 1$ for all $v$.
]

And since one place can be omitted (its symbol is determined by the others through reciprocity), one
never has to check them all: *the Hasse principle for conics plus reciprocity is Legendre's
criterion*, and the number of conditions is finite and explicit. `csa-brauer.gp`:

#align(center, table(
  columns: 3, align: (left, center, left),
  stroke: 0.4pt + luma(170), inset: (x: 8pt, y: 3.5pt),
  table.header([$(a,b)$], [splits everywhere], [rational point, height $<= 40$]),
  [$(2,3)$], [no], [none],
  [$(3,5)$], [no], [none],
  [$(1,1)$], [yes], [$(0,1,1)$],
  [$(-1,-1)$], [no], [none --- Hamilton's quaternions, ramified at $infinity$ and $2$],
  [$(2,7)$], [yes], [$(1,1,3)$],
  [$(6,10)$], [yes], [$(1,1,4)$],
))

#v(2mm)

The general Hasse--Minkowski theorem --- a quadratic form over $K$ in any number of variables is
isotropic iff it is isotropic over every $K_v$ --- reduces to the ternary case by an induction, and
the ternary case *is* the statement about quaternion algebras.

== The Hasse norm theorem, and where it fails <sec-norm>

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Theorem (Hasse).* Let $L slash K$ be *cyclic*. Then $x in K^times$ is a norm from $L$ if and only
  if it is a local norm at every place.

  #v(2mm)
  _Proof, in one line._ By Proposition 1.2, $x$ is a norm iff the cyclic algebra
  $(L slash K, sigma, x)$ splits, and $x$ is a local norm at $v$ iff that algebra splits over $K_v$.
  Now apply ABHN. $qed$
]

That is the whole proof, and it is a good example of what the Brauer group buys: *a statement about
norms becomes a statement about an algebra, where the Hasse principle is a theorem.*

The hypothesis "cyclic" is essential, and the failure is instructive. Take
$L = QQ(sqrt(13), sqrt(17))$, with $"Gal"(L slash QQ) = (ZZ slash 2)^2$.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Every decomposition group of $L slash QQ$ has order at most 2.* The discriminant is
  $13^2 dot 17^2$, so only $13$ and $17$ ramify (in particular $2$ is unramified). Now
  $(17 slash 13) = 1$, so $13$ splits in $QQ(sqrt(17))$; and $(13 slash 17) = 1$, so $17$ splits in
  $QQ(sqrt(13))$: each ramified prime has decomposition group of order $2$. Every unramified prime
  has *cyclic* decomposition group, and $(ZZ slash 2)^2$ has no element of order 4, so those have
  order $<= 2$ as well. The real places are split.

  #v(2mm)
  *Consequence.* At every $v$ the local extension $L_w slash QQ_v$ is trivial or quadratic, so
  $25 = N(5)$ is a local norm *everywhere*.
]

And yet it is not a global norm. Since the whole point is that no single place obstructs, the proof
has to use a global input; it uses two, both elementary --- the factorisation of $5$ and the sign of
the fundamental unit.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Proposition 5.1.* $25 in.not N_(L slash QQ) (L^times)$ for $L = QQ(sqrt(13), sqrt(17))$.

  #v(2mm)
  _Proof._ Put $k = QQ(sqrt(13))$, so that $L = k(sqrt(17))$ and
  $N_(L slash QQ) = N_(k slash QQ) compose N_(L slash k)$. Suppose $25 = N_(L slash QQ)(x)$ for some
  $x in L^times$, and set $y = N_(L slash k)(x) in k^times$. Then

  #v(1mm)
  #set enum(numbering: "(i)")
  + $N_(k slash QQ)(y) = 25$, and
  + $y$ is a norm from $L = k(sqrt(17))$.

  #v(2mm)
  *Step 1: (i) forces $y equiv plus.minus 5$ modulo squares.* Since $13 equiv 3$ mod $5$ is not a
  square mod $5$, the prime $5$ is *inert* in $k$; so the only ideal of $k$ of norm $25$ is $(5)$,
  and (i) gives $(y) = (5)$, i.e. $y = 5 u$ with $u$ a unit of norm $1$. The fundamental unit
  $epsilon = (3 + sqrt(13)) slash 2$ has $N(epsilon) = (9 - 13) slash 4 = -1$, so a unit
  $plus.minus epsilon^n$ has norm $(-1)^n$ and the units of norm $1$ are exactly
  $plus.minus epsilon^(2n) = plus.minus (epsilon^n)^2$. Hence
  $ y in {5, -5} dot (k^times)^2 . $

  #v(2mm)
  *Step 2: neither $5$ nor $-5$ is a norm from $k(sqrt(17))$.* By Proposition 1.1, (ii) says the
  quaternion algebra $(17, y)_k$ splits; and the Hilbert symbol depends only on $y$ modulo squares,
  so by Step 1 it would follow that $(17, plus.minus 5)_k = 1$. Now $13 equiv 8^2$ mod $17$, so
  $17$ *splits* in $k$; let $w$ be a place of $k$ above $17$, so that $k_w = QQ_17$. There $17$ is a
  uniformiser and $plus.minus 5$ a unit, so the tame symbol is a Legendre symbol:
  $ (17, plus.minus 5)_w = ((plus.minus 5) / 17) = (5 / 17) = (17 / 5) = (2 / 5) = -1 , $
  using $(-1 slash 17) = 1$ because $17 equiv 1$ mod $4$, then quadratic reciprocity, then
  $17 equiv 2$ mod $5$. So $(17, plus.minus 5)_k$ is ramified at $w$ and does not split --- a
  contradiction. $qed$
]

Note that only the *easy* direction of the local--global principle was used: an algebra that fails
to split at one place fails to split. No appeal to ABHN is needed to prove a negative.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *Why $4$ and $9$ behave differently.* The same argument run on $4$ reaches
  $y in {2,-2} dot (k^times)^2$ ($2$ is inert in $k$ since $13 equiv 5$ mod $8$), and there the
  symbol at $w | 17$ is $(2 slash 17) = +1$ --- $2 equiv 6^2$ mod $17$ --- so no obstruction
  appears, and indeed $4$ *is* a norm. For $9$ the first step already fails to pin $y$ down: $3$
  *splits* in $k$, so there are several ideals of norm $9$ and correspondingly more candidates for
  $y$. The whole difference between $25$ and $4$ is the difference between $(5 slash 17) = -1$ and
  $(2 slash 17) = +1$.

  #v(2mm)
  `csa-brauer.gp` confirms each step: $5$ inert and $17$ split in $k$, $N(epsilon) = -1$, and the
  local symbols $(17, plus.minus 5)_w = -1$ at $w | 17$ while $(17, plus.minus 5)_w = +1$ at
  $w | 2$ and $w | 5$ --- so $17$ is the *only* obstructing place, as the proof claims.
]

=== The norm form, explicitly <sec-normform>

It costs half a page to write $N_(L slash QQ)$ down, and the shape is worth seeing. Take the
$QQ$-basis $1, sqrt(13), sqrt(17), sqrt(221)$ of $L$ (a basis of the *field*; it is not an integral
basis) and let
$ x = a + b sqrt(13) + c sqrt(17) + d sqrt(221) . $
The four conjugates are obtained by the four sign patterns $(plus.minus sqrt(13),
plus.minus sqrt(17))$, with the sign on $sqrt(221) = sqrt(13) sqrt(17)$ being the product. Group
them in pairs. Writing $x = (a + b sqrt(13)) + (c sqrt(17) + d sqrt(221))$ and using
$sqrt(17) dot sqrt(221) = 17 sqrt(13)$,
$ x dot tau_1 (x) = (a + b sqrt(13))^2 - (c sqrt(17) + d sqrt(221))^2
  = A + B sqrt(13) , $
$ A = a^2 + 13 b^2 - 17 c^2 - 221 d^2, quad B = 2(a b - 17 c d) , $
and $tau_2 (x) tau_3 (x)$ is its conjugate $A - B sqrt(13)$. Multiplying:

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  $ N_(L slash QQ)(x) = (a^2 + 13 b^2 - 17 c^2 - 221 d^2)^2 - 52 thin (a b - 17 c d)^2 . $
]

A quartic form in four variables. Sanity checks: $N(5) = 625$, $N(sqrt(13)) = 169$,
$N(sqrt(17)) = 289$, $N(sqrt(221)) = 221^2$, $N(1 + sqrt(13)) = 144$; and
`csa-brauer.gp` checks the formula against PARI on 300 random quadruples.

*Three presentations, one per quadratic subfield.* Since $N_(L slash QQ) = N_(k_i slash QQ) compose
N_(L slash k_i)$ for each of the three quadratic subfields, the *same* quartic form has three
different "$A^2 - d B^2$" shapes:

#align(center, table(
  columns: 4, align: (center, left, left, center),
  stroke: 0.4pt + luma(170), inset: (x: 7pt, y: 4pt),
  table.header([$sigma$], [fixes], [$A_sigma$], [$N = A_sigma^2 - d B_sigma^2$]),
  [$tau_1$], [$sqrt(13)$], [$a^2 + 13b^2 - 17c^2 - 221d^2$], [$d = 13$, $B = 2(a b - 17 c d)$],
  [$tau_2$], [$sqrt(17)$], [$a^2 - 13b^2 + 17c^2 - 221d^2$], [$d = 17$, $B = 2(a c - 13 b d)$],
  [$tau_3$], [$sqrt(221)$], [$a^2 - 13b^2 - 17c^2 + 221d^2$], [$d = 221$, $B = 2(a d - b c)$],
))

#v(2mm)

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *The sign patterns are the character table.* Each basis element $e in {1, sqrt(13), sqrt(17),
  sqrt(221)}$ is an eigenvector of every $sigma in G$, with eigenvalue $plus.minus 1$, and
  $ A_sigma = sum_e epsilon_sigma (e) thin a_e^2 thin e^2 , quad
    e^2 = 1, 13, 17, 221 " respectively." $
  So the three sign rows $(+,+,-,-)$, $(+,-,+,-)$, $(+,-,-,+)$ are exactly the three non-trivial
  characters of $(ZZ slash 2)^2$. The cross term $B_sigma$ pairs the two basis elements fixed by
  $sigma$ against the two it negates, with the factor being their product divided by the fixed
  square root --- $17$, $13$ and $1$ in the three rows.
]

*And here is the counterexample, as a form.* Proposition 5.1 says precisely that the quartic form
$ Q(a,b,c,d) = (a^2 + 13 b^2 - 17 c^2 - 221 d^2)^2 - 52 (a b - 17 c d)^2 $
*represents $25$ over every completion $QQ_v$ but represents it over no rational quadruple.* It does
represent $4$, $9$ and $-25$. That is the Hasse principle failing, written out in four variables and
degree four --- and one sees why nothing like Hasse--Minkowski (@sec-conics) can be expected here:
that theorem is about *quadratic* forms.

=== An Azumaya algebra that registers the obstruction <sec-azumaya25>

Equating the norm form to $25 e^4$ gives a quartic threefold $X subset PP^4$ with
$X(bb(A)_QQ) != nothing$ and $X(QQ) = nothing$ --- the points at infinity are excluded too, since a
norm form of a *field* is anisotropic, so $e = 0$ forces $a = b = c = d = 0$. Is the failure
Brauer--Manin? It must be:

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Sansuc.* For a torsor under a connected linear algebraic group over a number field, the
  Brauer--Manin obstruction to the Hasse principle is the only one. The smooth affine
  $V : N_(L slash QQ)(x) = 25$ is a torsor under the norm-one torus
  $T = R^1_(L slash QQ) GG_m$ (if $x_0$ is one solution, every other is $x_0 t$ with $N(t) = 1$),
  so *some* class must obstruct.
]

It can be written down, and it is a quaternion algebra in the two functions already in hand.

*Step 1: $V$ fibres over a conic.* The map $x |-> N_(L slash k)(x) = A + B sqrt(13)$, $k = QQ(sqrt 13)$,
sends $V$ to the affine conic
$ W : A^2 - 13 B^2 = 25 , quad
  A = a^2 + 13b^2 - 17c^2 - 221d^2, quad B = 2(a b - 17 c d) , $
the very $A$ and $B$ of @sec-normform. The fibre over a point of $W$ is the set of $x$ with
prescribed $N_(L slash k)(x)$ --- non-empty exactly when $A + B sqrt(13)$ is a norm from
$L = k(sqrt(17))$.

*Step 2: parametrise $W$.* It has the rational point $P_0 = (5,0)$, so lines $B = m(A-5)$ through
$P_0$ parametrise it:
$ A = (5(1 + 13m^2)) / (13 m^2 - 1), quad B = (10 m) / (13m^2 - 1), quad
  A - 5 = 10 / (13 m^2 - 1) . $
Modulo squares $A - 5 equiv 10 (13m^2 - 1) = 2 f(m)$ with $f(m) = -5(1 - 13 m^2)$; and
$(17, 2) = 0$ over $QQ$ (as $17 equiv 1$ mod $8$ is a square in $QQ_2$ and $2 equiv 6^2$ mod $17$),
so $(17, A - 5) = (17, f(m))$.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *The class.*
  $ cal(A) = (17, thin A - 5) = (17, thin a^2 + 13 b^2 - 17 c^2 - 221 d^2 - 5) in "Br"(V) . $

  #v(2mm)
  *It is Azumaya.* On the affine conic $W$ the function $A - 5$ vanishes only at $P_0$, and there to
  order $2$: from $(A-5)(A+5) = 13 B^2$ with $A + 5 approx 10$ a unit, $A - 5 = 13 B^2 slash (A+5)$
  and $B$ is a local parameter. It has no poles on affine $W$. So $"div"_W (A - 5) = 2 P_0$ has all
  multiplicities even, every residue of $(17, A-5)$ vanishes, and the class is unramified on $W$ ---
  hence on $V$ by pullback.
]

*Step 3: why it obstructs.* Two facts, one for each kind of place.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *(a) At $v$ non-split in $k = QQ(sqrt 13)$, $"inv"_v cal(A)$ is constant --- it does not depend on
  the local point at all.* First, $17$ is a square in $QQ_v (sqrt 13)$: if $17$ is not already a
  square in $QQ_v$, then $13$ and $17$ are both non-square *units* there, hence equal modulo squares
  (the unit group modulo squares has order 2 for odd $v$), so $221 = 13 dot 17$ is a square and
  $QQ_v (sqrt 17) = QQ_v (sqrt 13)$. Therefore $(17, z)_(QQ_v (sqrt 13)) = 0$ for every $z$, and by
  the projection formula
  $ (17, thin N_(k slash QQ)(z))_v = "cor"((17,z)_(k_w)) = 0 . $
  Since $f(m) = -5 dot N_(k slash QQ)(1 + m sqrt(13))$, this gives
  $ "inv"_v cal(A) = "inv"_v (17, -5) quad "for every local point." $

  #v(1.5mm)
  *(b) At $v$ split in $k$, local solubility forces $"inv"_v cal(A) = 0$.* A local point above $m$
  exists only if $A + B sqrt(13)$ is a local norm from $L$, i.e. $(17, f(m))_w = 0$ at both places
  $w | v$ of $k$; and $k_w = QQ_v$ there, so this says exactly $(17, f(m))_v = +1$.
]

Now add up. $(17,-5)$ ramifies exactly at $5$ and $17$. Of these, $5$ is *inert* in $QQ(sqrt 13)$
(as $13 equiv 3$ mod $5$ is a non-residue) while $17$ *splits* (as $13 equiv 8^2$ mod $17$). So the
split places contribute $0$ by (b), the non-split places contribute $"inv"_v (17,-5)$ by (a), and
only $v = 5$ survives:

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  $ sum_v "inv"_v cal(A)(P_v) = "inv"_5 (17, -5) = 1/2 != 0
    quad "for every" (P_v) in V(bb(A)_QQ) . $
  Hence $V(bb(A)_QQ)^("Br") = nothing$: the Brauer--Manin obstruction is *complete*, and it is
  carried by a single quaternion algebra.
]

`csa-brauer.gp` checks (a) directly --- $93$ values of $m$ against every non-split place up to $40$,
$2139$ symbol comparisons, no deviation from $(17,-5)$ --- and confirms that the class is genuinely
non-constant, its ramification set moving with $m$:

#align(center, table(
  columns: 3, align: (center, center, left),
  stroke: 0.4pt + luma(170), inset: (x: 9pt, y: 3.5pt),
  table.header([$m$], [$f(m)$], [ramification of $cal(A)$]),
  [$0$], [$-5$], [${5, 17}$],
  [$1$], [$60$], [${3, 5}$],
  [$3$], [$580$], [${5, 29}$],
  [$1 slash 2$], [$45 slash 4$], [${5, 17}$],
))

#v(2mm)

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *Two things worth noticing.* First, $5$ lies in *every* ramification set in the table --- that is
  (a) in action, and it is the whole obstruction. Second, the place carrying the Brauer--Manin
  obstruction is $5$, whereas the contradiction in the proof of Proposition 5.1 appeared at $17$.
  There is no conflict: both are shadows of the same group of order $2$, seen through different
  presentations --- once as "which square class can $y$ be", once as "where does the algebra
  ramify".

  #v(2mm)
  *Cohomological reading.* $"Br"(V) slash "Br"(QQ) tilde.equiv ZZ slash 2$, generated by
  $cal(A)$; it is dual to the knot group of the previous box, and the identification is
  Poitou--Tate duality between $Ш^1 (QQ, T)$ and $Ш^2 (QQ, hat(T))$ for the norm-one torus $T$.
  Sansuc's theorem is the statement that this duality is exact --- that the descent obstruction and
  the Brauer--Manin obstruction agree for torsors under connected linear groups.
]


#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *Cohomological reading.* The obstruction is the "knot group"
  $(K^times inter N(bb(A)_L^times)) slash N(L^times)$, and Tate computed it: it is dual to the
  cokernel of $⊕_v hat(H)^(-3)(G_v, ZZ) --> hat(H)^(-3)(G, ZZ)$. Now
  $hat(H)^(-3)(G, ZZ) tilde.equiv H_2 (G, ZZ)$ is the Schur multiplier, which is $ZZ slash 2$ for
  $G = (ZZ slash 2)^2$ and $0$ for $G$ cyclic. So the principle holds automatically for cyclic $G$
  (Hasse), and for a biquadratic field it fails with obstruction of order exactly $2$ precisely when
  *no* decomposition group is all of $G$ --- which is what was checked above by hand. Equivalently,
  the obstruction is $Ш^1$ of the norm-one torus $R^1_(L slash K) GG_m$.
]

== Division algebras over a number field <sec-divalg>

Theorem 3.1 is a *classification*: a class in $"Br"(K)$ is exactly a family
$("inv"_v) in ⊕_v QQ slash ZZ$ with $sum_v "inv"_v = 0$ (with the constraint that
$"inv"_v in 1/2 ZZ slash ZZ$ at real places and $0$ at complex ones). Two consequences that are hard
to see any other way:

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *(a) Index equals exponent.* Over a number field, the index of a CSA is the lcm of the
  denominators of its local invariants, which is also its order in $"Br"(K)$.

  #v(1.5mm)
  *(b) A division algebra ramifies at at least two places*, since a single non-zero invariant cannot
  sum to zero. In particular there is no division algebra over $QQ$ ramified only at $infinity$, and
  none ramified only at one prime.
]

`csa-brauer.gp` builds these to order with PARI's algebra package:

#align(center, table(
  columns: 4, align: (left, center, center, center),
  stroke: 0.4pt + luma(170), inset: (x: 8pt, y: 3.5pt),
  table.header([prescribed invariants], [degree], [index], [lcm of denominators]),
  [$1 slash 3$ at $7$, $2 slash 3$ at $13$], [3], [3], [3],
  [$1 slash 2$ at $2$, $1 slash 2$ at $3$], [2], [2], [2],
  [$1 slash 2$ at $2, 3, 5, 7$], [2], [2], [2],
  [$1 slash 6$ at $7$, $5 slash 6$ at $13$], [6], [6], [6],
  [$1 slash 2$ at $7$, $1 slash 2$ at $13$, in degree 6], [6], [*2*], [2],
))

#v(2mm)

The last row is $M_3 (D)$ for $D$ the quaternion algebra ramified at $7$ and $13$: *the degree is a
choice of presentation, the index is not*. This is the classification doing real work --- one reads
off the division algebra from a finite list of rational numbers.

== Class field theory, and Grunwald--Wang <sec-cft>

Because $"Br"(L slash K) = K^times slash N(L^times)$ for cyclic $L slash K$, and because Theorem 3.1
computes $"Br"$, one obtains the global reciprocity isomorphism
$bb(A)_K^times slash K^times N(bb(A)_L^times) tilde.equiv "Gal"(L slash K)$ by bookkeeping with
invariants. The same bookkeeping answers *existence* questions: given local behaviour prescribed at
finitely many places, is there a global extension realising it? Since one may prescribe local
invariants freely subject only to $sum "inv"_v = 0$, the answer is essentially yes --- with one
famous exception.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Grunwald--Wang, and Wang's counterexample.* The number $16$ is an $8$th power in $QQ_p$ for every
  *odd* $p$ and in $RR$, but not in $QQ_2$, and not in $QQ$.

  #v(2mm)
  _Why, explicitly._ $x^8 - 16 = (x^2-2)(x^2+2)(x^2-2x+2)(x^2+2x+2)$, so $16$ is an $8$th power in a
  field iff one of $2$, $-2$, $-1$ is a square there. For odd $p$ the three Legendre symbols
  $(2 slash p)$, $(-2 slash p)$, $(-1 slash p)$ multiply to $+1$, so at least one of them is $+1$.
  At $p = 2$ none of $2, -2, -1$ is a square in $QQ_2$.
]

Grunwald's original theorem asserted more than is true, and the correction (Wang, 1948) is exactly
that the prime $2$ misbehaves: the "special case" occurs for $8 | n$ and involves the failure of
$QQ_2^times$ to be generated in the expected way. `csa-brauer.gp` prints the Legendre symbols place
by place. It is a good reminder that the sequence of Theorem 3.1 is *exact* but its consequences for
$n$-th powers are not automatic.

== The Brauer--Manin obstruction <sec-bm>

The single most important geometric application, and the one these notes live on. Let $X$ be a
smooth variety over $K$ and $"Br"(X) = H^2_"ét"(X, GG_m)$ its Brauer group --- concretely, classes
of *Azumaya algebras* over $X$, which one may think of as families of CSAs varying algebraically
over $X$. Evaluating at a point gives, for each $cal(A) in "Br"(X)$,
$ X(K_v) --> "Br"(K_v) -->^("inv"_v) QQ slash ZZ , quad P |-> "inv"_v (cal(A)(P)) . $

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *The obstruction.* For $P in X(K)$, the class $cal(A)(P) in "Br"(K)$ has
  $sum_v "inv"_v (cal(A)(P)) = 0$ by reciprocity (Theorem 3.1(b)). So
  $ X(K) subset.eq X(bb(A)_K)^("Br") =
    { (P_v) in X(bb(A)_K) : sum_v "inv"_v (cal(A)(P_v)) = 0 " for all " cal(A) in "Br"(X) } , $
  and if $X(bb(A)_K) != nothing$ but $X(bb(A)_K)^("Br") = nothing$, the Hasse principle fails for
  a reason one can *compute*.
]

This is the same product formula as in @sec-quadrec, applied fibrewise. In the level-2 case an
Azumaya class is literally a quaternion algebra over the function field --- which is what
`azumaya.gp` in these notes computes, checking that
$cal(A) = (product_(k != i)(x - e_k), product_(l != j)(t - e_l))$ has local invariants matching a
twisted Tate pairing, place by place, and that they satisfy reciprocity. `level3.gp` does the
degree-3 analogue with cubic symbols, tame and wild.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *Cohomological reading.* $"Br"(X) = H^2_"ét"(X, GG_m)$; the filtration
  $"Br"_0 subset.eq "Br"_1 subset.eq "Br"$ (constant, algebraic, transcendental) comes from the
  Hochschild--Serre spectral sequence, with
  $"Br"_1(X) slash "Br"_0(X) tilde.equiv H^1 (K, "Pic"(overline(X)))$. The evaluation pairing is
  cup product followed by $"inv"_v$, and the reciprocity constraint is the exactness of Theorem 3.1
  once more.
]

== Two further homes <sec-more>

*Automorphic forms.* Quaternion algebras over $QQ$ ramified at a finite even set of places give
Shimura curves (indefinite case) or finite sets of ideal classes (definite case), and the
Jacquet--Langlands correspondence transfers automorphic forms between $"GL"_2$ and the unit groups
of these algebras. Eichler's basis problem, the arithmetic of maximal orders and Brandt matrices are
all explicit quaternion algebra computations.

*Endomorphism algebras of abelian varieties.* $"End"^0(A) = "End"(A) ⊗ QQ$ is a semisimple algebra
with positive involution, and Albert's classification --- a CSA classification --- says exactly which
algebras occur. Quaternionic multiplication on abelian surfaces is the case where $"End"^0$ is an
indefinite quaternion algebra over $QQ$; this is precisely the setting in which the Kummer surfaces
of these notes acquire extra structure.

= Crossed products <sec-crossed>

Everything so far has been built from quaternion and cyclic algebras. Crossed products are the
general construction those two are special cases of --- and the point of this section is that they
are not a further generalisation one *chooses* to make: by Skolem--Noether, *every* central simple
algebra with a Galois maximal subfield already is one.

== They are not invented, they are found <sec-crossed-found>

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Skolem--Noether.* Every $K$-algebra automorphism of a central simple algebra $A$ over $K$ is
  inner; more generally any two embeddings of a simple $K$-algebra into $A$ differ by conjugation by
  a unit of $A$.
]

Let $A$ be a CSA of degree $n$ over $K$ and let $L subset A$ be a maximal subfield with $L slash K$
Galois of group $G$, $|G| = n$. Watch the crossed product appear.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Proposition 6.1.* $A = ⊕_(sigma in G) L u_sigma$ for units $u_sigma in A^times$ satisfying
  $ u_sigma x u_sigma^(-1) = sigma(x) quad (x in L), quad quad
    u_sigma u_tau = c(sigma, tau) thin u_(sigma tau) $
  for a function $c : G times G -> L^times$.

  #v(2mm)
  _Proof._ Each $sigma in G$ is a $K$-embedding $L -> A$, so by Skolem--Noether it is conjugation by
  some $u_sigma in A^times$. Both $u_sigma u_tau$ and $u_(sigma tau)$ induce $sigma tau$ on $L$, so
  $u_sigma u_tau u_(sigma tau)^(-1)$ centralises $L$; and by the double centraliser theorem the
  centraliser of a maximal subfield is itself, $C_A (L) = L$. Hence
  $u_sigma u_tau u_(sigma tau)^(-1) in L^times$, which defines $c$. Finally the $u_sigma$ are left
  $L$-independent (Dedekind's independence of characters), and $n$ of them each contributing
  $dim_K L = n$ gives $n^2 = dim_K A$, so they span. $qed$
]

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  So the multiplication table of $A$ is completely determined by *one function $c$ on $G times G$
  with values in $L^times$*. The rest of the theory is the bookkeeping of which $c$ occur and when
  two of them give the same algebra.
]

== The definition, and why associativity is the cocycle condition <sec-crossed-def>

Turn Proposition 6.1 around into a construction. Given $L slash K$ Galois with group $G$ and any
$c : G times G -> L^times$, set
$ (L slash K, G, c) = ⊕_(sigma in G) L u_sigma , quad
  u_sigma x = sigma(x) u_sigma, quad u_sigma u_tau = c(sigma,tau) u_(sigma tau) . $

When is this associative? Compute both bracketings of $u_sigma u_tau u_rho$:
$ (u_sigma u_tau) u_rho = c(sigma,tau) u_(sigma tau) u_rho
    = c(sigma,tau) thin c(sigma tau, rho) thin u_(sigma tau rho) , $
$ u_sigma (u_tau u_rho) = u_sigma thin c(tau,rho) thin u_(tau rho)
    = sigma(c(tau,rho)) thin u_sigma u_(tau rho)
    = sigma(c(tau,rho)) thin c(sigma, tau rho) thin u_(sigma tau rho) . $
Equating:

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  $ c(sigma,tau) thin c(sigma tau, rho) = sigma(c(tau,rho)) thin c(sigma, tau rho) . $
  *This is exactly the 2-cocycle identity*, and it arose from nothing but associativity. A $c$
  satisfying it is classically called a *factor set*.
]

One may normalise $c(1,sigma) = c(sigma,1) = 1$ by rescaling $u_1$. The resulting algebra is a CSA
of degree $n$ over $K$, split by $L$.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *The split algebra is the trivial factor set.* Taking $c equiv 1$ gives the twisted group algebra
  $L ⋊ G$, and the map sending $x in L$ to multiplication by $x$ and $u_sigma$ to $sigma$ is an
  isomorphism $(L slash K, G, 1) tilde.equiv "End"_K (L) tilde.equiv M_n (K)$. So *split* means
  *trivial cocycle*, on the nose.
]

== Changing the $u_sigma$ is changing $c$ by a coboundary <sec-crossed-cob>

The $u_sigma$ of Proposition 6.1 were only determined up to $L^times$. Replacing
$u_sigma$ by $b_sigma u_sigma$ with $b_sigma in L^times$ replaces $c$ by
$ c'(sigma,tau) = sigma(b_tau) thin b_sigma thin b_(sigma tau)^(-1) thin c(sigma,tau) , $
that is, by $c$ times a *coboundary*. So the algebra depends only on the class of $c$. Conversely
two factor sets differing by a coboundary give isomorphic algebras, by the same substitution. And
tensoring algebras multiplies factor sets. Hence:

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Theorem 6.2 (the crossed product theorem).* $c |-> (L slash K, G, c)$ induces a group isomorphism
  $ H^2 (G, L^times) tilde.equiv "Br"(L slash K) . $
  Passing to the limit over all finite Galois $L slash K$ --- legitimate because every CSA has a
  separable splitting field, hence a Galois one --- gives
  $ "Br"(K) tilde.equiv H^2 (G_K, overline(K)^times) . $
]

That is the identification asserted in @sec-objects, now *derived* rather than quoted, and derived
from an explicit multiplication table.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *Cohomological reading: this is Galois descent.* A CSA of degree $n$ split by $L$ is a $K$-form of
  $M_n (K)$, and forms are classified by $H^1 (G, "Aut"(M_n (L))) = H^1 (G, "PGL"_n (L))$. The exact
  sequence
  $ 1 --> L^times --> "GL"_n (L) --> "PGL"_n (L) --> 1 $
  has $H^1 (G, "GL"_n (L)) = 1$ (Hilbert 90 in its matrix form, Speiser's theorem), so the connecting
  map $H^1 (G, "PGL"_n (L)) arrow.r.hook H^2 (G, L^times)$ is injective --- and *the connecting map
  is precisely "write down the factor set"*. A crossed product is a descent datum with its
  multiplication table written out.
]

== The cyclic case: @sec-cyclic, recovered <sec-crossed-cyclic>

Let $G = ⟨sigma⟩$ be cyclic of order $n$ and $b in K^times$. Define
$ c(sigma^i, sigma^j) = b^(e(i,j)) , quad
  e(i,j) = cases(1 & "if" i + j >= n, 0 & "otherwise,") quad 0 <= i, j < n . $
Because $b$ lies in $K^times$, $sigma$ acts trivially on it and the cocycle identity collapses to an
identity between exponents,
$ e(i,j) + e(i+j, k) = e(j,k) + e(i, j+k) quad ("indices mod" n) , $
which `csa-brauer.gp` verifies for $n = 2, dots, 8$: 1295 triples, no failures. Setting
$u = u_sigma$ one gets $u^n = b$ and
$ (L slash K, G, c) = (L slash K, sigma, b) , $
the cyclic algebra of @sec-cyclic. Changing $b_sigma$ multiplies $b$ by a norm $N_(L slash K)(x)$,
so Theorem 6.2 specialises to
$ H^2 (ZZ slash n, L^times) tilde.equiv K^times slash N_(L slash K)(L^times) , $
*which is Proposition 1.2 --- now proved.* Two instances:

- $n = 2$, $L = K(sqrt a)$: the factor set is $c(sigma,sigma) = b$ and all else $1$, and the
  algebra is the quaternion algebra $(a,b)$ of @sec-quat.
- $K = RR$, $L = CC$, $sigma$ = complex conjugation, $b = -1$: the crossed product is *Hamilton's
  quaternions*, and $"Br"(RR) = RR^times slash N(CC^times) = RR^times slash RR_(>0) = {plus.minus 1}$
  --- the invariant $1 slash 2$ recorded in @sec-local.

`csa-brauer.gp` builds $(QQ(sqrt 5) slash QQ, sigma, b)$ for ten values of $b$ and finds index $1$
exactly when $b$ is a norm (no mismatches); confirms that $b$ and $-b$ give the same algebra, since
$N(2 + sqrt 5) = -1$ is a coboundary; and confirms that the class of $b = 3$ squares to the class of
$9 = N(3)$, hence has exponent $2$.

== What the crossed product picture buys <sec-crossed-buys>

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *(a) The exponent divides the degree.* If $A$ is split by $L$ with $[L : K] = n$, then
  $"res"_(L slash K) [A] = 0$ in $"Br"(L)$, and since
  $"cor"_(L slash K) compose "res"_(L slash K)$ is multiplication by $n$, we get $n [A] = 0$. So the
  exponent divides the degree --- the fact used silently in @sec-divalg. (Explicitly, the
  corestriction is the algebra-theoretic norm; cohomologically it is the transfer.)

  #v(1.5mm)
  *(b) $"Br"$ is a group for a reason.* The product of Brauer classes is the product of factor sets;
  the inverse of $c$ is $c^(-1)$, realised by the opposite algebra. Without the cocycle description
  the group law on $"Br"$ has to be checked by hand on tensor products.

  #v(1.5mm)
  *(c) The local invariant is a cyclic crossed product computation.* Theorem 2.1 says every class
  over $K_v$ is $(K_n slash K_v, phi, pi^r)$ --- a *cyclic* crossed product with $L$ unramified ---
  and $"inv"_v$ reads off $r slash n$. The whole of @sec-local happens inside one family of factor
  sets.
]

== Which algebras are crossed products? <sec-crossed-which>

Every Brauer *class* is a crossed product, by Theorem 6.2. But it is a genuinely harder question
whether a given division algebra of degree $n$ has a Galois maximal subfield *of degree $n$* --- i.e.
is a crossed product "at its own degree" --- and harder still whether that subfield can be taken
cyclic.

#align(center, table(
  columns: 2, align: (left, left),
  stroke: 0.4pt + luma(170), inset: (x: 8pt, y: 4pt),
  table.header([degree of the division algebra], [status over a general field]),
  [$2$], [always cyclic (a quaternion algebra)],
  [$3$], [always cyclic --- Wedderburn (1921)],
  [$4$], [always a crossed product (Albert), with group $ZZ slash 4$ or $(ZZ slash 2)^2$; *not* always cyclic],
  [$p >= 5$ prime], [open whether always cyclic, or even a crossed product],
  [divisible by $p^3$], [*non-crossed products exist* --- Amitsur (1972)],
))

#v(2mm)

Amitsur showed the universal division algebra of degree $p^r$ is not a crossed product for any prime
$p$ and any $r >= 3$; in particular degree $8$ already contains non-crossed products. So in general
the crossed product description is a statement about Brauer *classes*, not about individual division
algebras at their own degree.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Over a number field none of this bites.* The Albert--Brauer--Hasse--Noether theorem, in its strong
  form, says that *every central simple algebra over a number field is a cyclic algebra*: it has a
  cyclic maximal subfield, of degree equal to its index. One constructs the splitting field directly
  from the local invariants --- a cyclic extension with prescribed local degrees, which exists by the
  existence theorem of class field theory (and this is one of the places where the Grunwald--Wang
  correction of @sec-cft has to be respected).
]

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *This is the answer to "how do crossed products connect to the rest of this document".* They are
  the general frame, and over a number field the frame collapses onto its cyclic special case. The
  quaternion algebras of @sec-quat, the cyclic algebras of @sec-cyclic, the unramified cyclic
  algebras that compute $"inv"_v$ in @sec-local, and the algebras with prescribed invariants in
  @sec-divalg are therefore not a convenient subclass chosen to keep things explicit --- *by ABHN
  they are all of them.* The explicit approach of @sec-objects through @sec-applications is not a
  simplification; over number fields it is complete.
]

Two loose ends worth naming. First, in the geometric setting of @sec-bm the same picture holds over
the function field of a variety: an Azumaya algebra on $X$ is, generically, a crossed product over
$K(X)$, and at level 2 it is the quaternion algebra that `azumaya.gp` writes down. Second, the
cyclicity of ABHN is exactly what makes the local invariants a *complete* and *computable* invariant:
one never has to search for a Galois maximal subfield, because a cyclic one is guaranteed and its
degree is the index.


= Two worked examples <sec-examples>

Both are division algebras over $QQ$, given by a basis and a multiplication rule; in each the
maximal subfields are computed, and in each the answer turns out to be a classical
number-theoretic criterion in disguise.

== Degree 2: Hamilton's quaternions, and the three-square theorem <sec-ham>

Take $B = (-1,-1)_QQ$, with $QQ$-basis $1, i, j, k$ and

#align(center, table(
  columns: 5, align: (center,)*5,
  stroke: 0.4pt + luma(170), inset: (x: 10pt, y: 4pt),
  table.header([$dot$], [$1$], [$i$], [$j$], [$k$]),
  [$1$], [$1$], [$i$], [$j$], [$k$],
  [$i$], [$i$], [$-1$], [$k$], [$-j$],
  [$j$], [$j$], [$-k$], [$-1$], [$i$],
  [$k$], [$k$], [$j$], [$-i$], [$-1$],
))

#v(2mm)

--- that is $i^2 = j^2 = k^2 = -1$ and $i j = k = -j i$, $j k = i = -k j$, $k i = j = -i k$. As a
crossed product (@sec-crossed) this is $(QQ(i) slash QQ, sigma, -1)$ with $sigma$ complex
conjugation and $u_sigma = j$: indeed $j z j^(-1) = overline(z)$ for $z in QQ(i)$, and $j^2 = -1$.

The reduced norm is $N(x + y i + z j + w k) = x^2 + y^2 + z^2 + w^2$, anisotropic over $QQ$, so $B$
is a division algebra. Its Hilbert symbols are $(-1,-1)_2 = (-1,-1)_infinity = -1$ and $+1$
elsewhere: *ramified exactly at $2$ and $infinity$*, invariants $1 slash 2$ at each, summing to $0$
as @sec-global requires.

*The quadratic subfields.* A *pure* quaternion $v = x i + y j + z k$ has all cross terms cancelling,
so
$ v^2 = -(x^2 + y^2 + z^2) . $
Hence $QQ(sqrt(-m)) subset B$ if and only if $m$ is a sum of three *rational* squares. Explicitly:

#align(center, table(
  columns: 3, align: (left, left, left),
  stroke: 0.4pt + luma(170), inset: (x: 8pt, y: 3.5pt),
  table.header([element $v in B$], [$v^2$], [subfield $QQ(v)$]),
  [$i$], [$-1$], [$QQ(i)$],
  [$i + j$], [$-2$], [$QQ(sqrt(-2))$],
  [$i + j + k$], [$-3$], [$QQ(sqrt(-3))$],
  [$j + 2k$], [$-5$], [$QQ(sqrt(-5))$],
  [$i + j + 2k$], [$-6$], [$QQ(sqrt(-6))$],
  [$j + 3k$], [$-10$], [$QQ(sqrt(-10))$],
))

#v(2mm)

Six pairwise non-isomorphic quadratic fields, the $m$ being distinct and squarefree, all inside one
4-dimensional algebra. And there are infinitely many more.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *The bonus: two criteria, one theorem.* The Brauer-group criterion of @sec-divalg says
  $QQ(sqrt(d))$ embeds in $B$ iff it *splits* $B$, i.e. iff the two ramified places $2$ and
  $infinity$ are both non-split in $QQ(sqrt d)$ --- that is, iff $d < 0$ and $d equiv.not 1$ mod
  $8$. Writing $d = -m$ with $m > 0$ squarefree, this reads $m equiv.not 7$ mod $8$.

  #v(2mm)
  The elementary criterion says instead: $m$ is a sum of three rational squares. By
  Davenport--Cassels that is the same as a sum of three *integer* squares, and by Gauss and Legendre
  that happens iff $m$ is not of the form $4^a (8b+7)$ --- for squarefree $m$, iff
  $m equiv.not 7$ mod $8$.

  #v(2mm)
  *The two agree, and their agreement is the three-square theorem.* `csa-brauer.gp` checks it for
  all squarefree $m <= 31$: no disagreements. The first exclusion is $m = 7$:
  $ QQ(sqrt(-7)) "does not embed in" B , $
  because $-7 equiv 1$ mod $8$ makes $2$ *split* in $QQ(sqrt(-7))$ --- equivalently, because $7$ is
  not a sum of three squares.
]

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *And the four-square theorem is next door.* The norm form of $B$ is $x^2+y^2+z^2+w^2$, and the
  Hurwitz order $cal(H) = ZZ ⟨1, i, j, (1+i+j+k) slash 2⟩$ --- a *maximal* order, unlike the naive
  $ZZ⟨1,i,j,k⟩$ --- is left- and right-Euclidean for the norm, hence a principal ideal ring. Every
  prime $p$ therefore has $p = N(h)$ for some $h in cal(H)$, and clearing the halves gives Lagrange's
  four-square theorem. The arithmetic of a maximal order in $B$ *is* classical additive number
  theory.
]

== Degree 3: a cyclic algebra that sees cubic residues mod 7 <sec-cub>

Let $zeta = zeta_7$ and $alpha = zeta + zeta^(-1)$, so $L = QQ(alpha) = QQ(zeta_7)^+$ is the real
cyclic cubic field of conductor 7, with
$ f(x) = x^3 + x^2 - 2x - 1, quad "disc" f = 49 = 7^2 , $
the square discriminant confirming that $L slash QQ$ is cyclic. Its generator is *explicit*:
$ sigma(alpha) = alpha^2 - 2 , $
because $alpha^2 - 2 = zeta^2 + zeta^(-2)$, i.e. $sigma$ is $zeta |-> zeta^2$. Now put
$ A = (L slash QQ, sigma, 2) = L ⊕ L u ⊕ L u^2 , $
a $9$-dimensional $QQ$-algebra with $QQ$-basis
$ 1, alpha, alpha^2, quad u, alpha u, alpha^2 u, quad u^2, alpha u^2, alpha^2 u^2 $
and the two rules that determine everything:
$ u^3 = 2 , quad quad u thin alpha = (alpha^2 - 2) thin u . $
(The second rule moves $u$ past any element of $L$ by applying $sigma$; iterating,
$u^2 alpha = sigma^2(alpha) u^2$.)

*It is a division algebra, and one can see exactly why.* At a prime $p != 7$ the extension
$L_p slash QQ_p$ is unramified, so a unit is automatically a local norm and
$"inv"_p = v_p(2) slash 3$ --- non-zero only at $p = 2$, and only because $2$ is *inert* in $L$.
At $p = 7$ the extension is totally (tamely) ramified, $7$ itself is a norm, and a unit is a local
norm exactly when it is a *cube mod 7*; the cubes mod $7$ are ${1,6}$, and $2$ is not among them.
PARI confirms the resulting invariants:

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  $A$ has degree $3$ and index $3$, ramified exactly at $2$ and $7$, with
  $ "inv"_2 (A) = 1/3 , quad "inv"_7 (A) = 2/3 , quad
    "inv"_2 + "inv"_7 = 1 equiv 0 " in " QQ slash ZZ . $
]

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *The bonus: the algebra is a cubic residue symbol.* For a prime $b != 7$,
  $ (L slash QQ, sigma, b) " is a division algebra" quad <==> quad
    b "is not a cube modulo" 7 . $
  The reason the two ramified invariants vanish *together* is not luck: $p$ is inert in $L$ iff
  $p mod 7 in.not {1,6}$, and $p$ is a cube mod $7$ iff $p mod 7 in {1,6}$ --- the same condition.
  Reciprocity forbids a single non-zero invariant, and here one sees the mechanism.
]

#align(center, table(
  columns: 5, align: (center,)*5,
  stroke: 0.4pt + luma(170), inset: (x: 9pt, y: 3.5pt),
  table.header([$b$], [$b$ mod $7$], [cube mod 7], [index], [division?]),
  [2], [2], [no], [3], [yes],
  [3], [3], [no], [3], [yes],
  [5], [5], [no], [3], [yes],
  [11], [4], [no], [3], [yes],
  [13], [6], [yes], [1], [no],
  [29], [1], [yes], [1], [no],
  [43], [1], [yes], [1], [no],
))

#v(2mm)

*The cubic subfields.* A cubic field $F$ embeds in $A$ iff it splits $A$, i.e. iff at each of the
two ramified places $2$ and $7$ there is a *single* prime of $F$, of local degree $3$. Four fields
that qualify, and one that does not:

#align(center, table(
  columns: 5, align: (left, center, center, center, center),
  stroke: 0.4pt + luma(170), inset: (x: 8pt, y: 3.5pt),
  table.header([cubic field], [disc], [$p = 2$: $(e,f)$], [$p = 7$: $(e,f)$], [embeds?]),
  [$L = QQ(zeta_7)^+$], [$49$], [$(1,3)$], [$(3,1)$], [yes],
  [$QQ(zeta_9)^+$], [$81$], [$(1,3)$], [$(1,3)$], [yes],
  [$QQ(root(3,2))$], [$-108$], [$(3,1)$], [$(1,3)$], [yes],
  [$QQ(root(3,14))$], [$-5292$], [$(3,1)$], [$(3,1)$], [yes],
  [$QQ(root(3,5))$], [$-675$], [$(1,1), (1,2)$], [$(1,3)$], [*no*],
))

#v(2mm)

The discriminants are distinct, so the four are pairwise non-isomorphic. Two of them are cyclic and
two are not --- so *one division algebra of degree 3 contains both Galois and non-Galois maximal
subfields*, which is worth pausing on: the crossed-product description of @sec-crossed requires a
*Galois* maximal subfield, and here it is available ($L$, or $QQ(zeta_9)^+$) while $QQ(root(3,2))$
is equally a maximal subfield and equally useless for that purpose.

Best of all, the generators are visible inside the algebra:

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  #set enum(numbering: "(i)")
  + $alpha in L subset A$ generates $L = QQ(zeta_7)^+$;
  + $u$ satisfies $u^3 = 2$, so $QQ(u) tilde.equiv QQ(root(3,2))$;
  + $(2 - alpha) u$ has cube $N(2-alpha) dot u^3 = f(2) dot 2 = 7 dot 2 = 14$, so it generates
    $QQ(root(3,14))$.

  #v(2mm)
  More generally $(c u)^3 = N_(L slash QQ)(c) dot 2$ for any $c in L^times$, so *every* field
  $QQ(root(3, 2m))$ with $m in N_(L slash QQ)(L^times)$ sits inside $A$ --- an infinite family of
  maximal subfields, produced by solving norm equations in a cubic field.
]

$QQ(root(3,5))$ is excluded for a reason one can check by hand: $x^3 - 5 equiv (x+1)(x^2+x+1)$
modulo $2$, so $2$ splits there, and a prime of local degree $1$ cannot support an algebra of local
index $3$.


= The dictionary <sec-dictionary>

#align(center, table(
  columns: 2, align: (left, left),
  stroke: 0.4pt + luma(170), inset: (x: 8pt, y: 4pt),
  table.header([explicit], [cohomological]),
  [central simple algebra over $K$], [class in $H^2 (G_K, overline(K)^times)$],
  [crossed product $(L slash K, G, c)$], [a 2-cocycle $c in Z^2 (G, L^times)$],
  [associativity of the multiplication table], [the 2-cocycle identity],
  [rescaling $u_sigma |-> b_sigma u_sigma$], [changing $c$ by a coboundary],
  [$(L slash K, G, 1) tilde.equiv M_n (K)$], [the trivial class],
  [Skolem--Noether produces the $u_sigma$], [the descent datum in $H^1 (G, "PGL"_n)$],
  [cyclic algebra $(L slash K, sigma, b)$], [periodicity: $H^2 (ZZ slash n, L^times) = K^times slash N(L^times)$],
  [quaternion algebra $(a,b)$], [cup product in $H^1 (K, mu_2) times H^1(K, mu_2)$],
  [Hilbert symbol $(a,b)_v = plus.minus 1$], [$"inv"_v$ of that cup product],
  [$b$ is a norm from $L$], [the class of $b$ dies in $H^2("Gal"(L slash K), L^times)$],
  [$"inv"_v = v("twist") slash n$], [valuation map $H^2(K_n slash K_v, K_n^times) -> 1/n ZZ slash ZZ$],
  [$product_v (a,b)_v = 1$], [$sum_v "inv"_v = 0$: the global fundamental class],
  [ABHN: split locally $=>$ split globally], [$Ш^2 (K, GG_m) = 0$],
  [Hasse norm theorem for cyclic $L slash K$], [$Ш^1 (K, R^1_(L slash K) GG_m) = 0$ for cyclic $G$],
  [its failure for $QQ(sqrt 13, sqrt 17)$], [Schur multiplier $H_2 ((ZZ slash 2)^2, ZZ) = ZZ slash 2$],
  [Azumaya algebra on $X$], [class in $H^2_"ét"(X, GG_m)$],
  [Brauer--Manin obstruction], [reciprocity applied to the evaluation pairing],
))

= Where this appears in these notes <sec-uses>

The survey's chapters 7--10 are an extended computation in this language, and it may help to see
which piece is which.

- The *twisted Tate pairing* $beta_v$ of the survey is the local invariant $"inv"_v$ of an explicit
  quaternion (or degree-$ell$ cyclic) algebra; `azumaya.gp` verifies exactly that identification
  place by place, and checks reciprocity.
- The *tame and wild cubic symbols* of `level3.gp` are the degree-3 Hilbert symbols, i.e. the
  invariants of cyclic algebras of degree 3, computed by the product formula plus global
  representatives.
- The observation in `selmer-local-conditions.typ` that "parity is local" and the observation here
  that "reciprocity is a product formula" are the same fact wearing different clothes: both are
  $sum_v "inv"_v = 0$.
- The Azumaya algebras of `azumaya.gp` are crossed products over the function field $QQ(X)$: a
  quaternion algebra is the $G = ZZ slash 2$ case of @sec-crossed, and the pair of descent functions
  entering it is the factor set.
- `ramification.gp` computes residues of $cal(A)_(i j)$ along the sixteen exceptional curves of
  $"Kum"(E times E)$ --- that is the *ramification* of a Brauer class, the obstruction to it being
  Azumaya, and it is the geometric analogue of "which places does a division algebra ramify at".

#v(3mm)

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Summary.* A central simple algebra over a local field is a valuation and a degree, and nothing
  more: $"inv"_v : "Br"(K_v) tilde.equiv QQ slash ZZ$. Over a number field, algebras are classified
  by their local invariants subject to one condition, $sum_v "inv"_v = 0$, and that condition is
  reciprocity --- quadratic reciprocity when the degree is 2, Artin reciprocity in general, and the
  Brauer--Manin obstruction when applied fibrewise over a variety. Everything else in this document
  --- Legendre's criterion for conics, the Hasse norm theorem, the classification of division
  algebras, index $=$ exponent --- is a corollary of that one exact sequence, obtained by writing
  down the right algebra and asking whether it splits.
]
