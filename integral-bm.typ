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
  #text(size: 16pt, weight: "bold")[A Brauer--Manin obstruction to integral points]
  #v(2mm)
  #text(size: 10pt)[Worked out on the negative Pell conic $x^2 - 34 y^2 = -1$:
  rational points are dense, local integral points exist everywhere, and a single
  quaternion class kills every integral point]
  #v(1mm)
  #text(size: 9pt, style: "italic")[every claim below is checked in `integral-bm.gp`;
  output in `results/integral-bm.txt`]
]

#v(4mm)

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *The example in one line.* Let $cal(X) subset AA^2_ZZ$ be
  $ cal(X) : quad x^2 - 34 y^2 = -1 , $
  and let $cal(A) = (2, x+4)$ be the quaternion algebra over $QQ(cal(X))$. Then
  $cal(X)(ZZ_v) != nothing$ for every place $v$, and $cal(X)(QQ)$ is infinite and Zariski
  dense --- but
  $ sum_v "inv"_v cal(A)(P_v) = 1/2 quad "for every" quad (P_v) in cal(X)(bold(A)_ZZ) , $
  so $cal(X)(bold(A)_ZZ)^cal(A) = nothing$ and hence $cal(X)(ZZ) = nothing$. The entire
  obstruction sits at the prime $2$: at every $ZZ_2$-point $x equiv plus.minus 1 mod 8$,
  which makes $x + 4 equiv plus.minus 3 mod 8$, which makes $2$ a non-norm.
]

= What the integral obstruction is, and how it differs from the rational one <sec-setup>

Let $cal(X)$ be a separated scheme of finite type over $ZZ$ with generic fibre $X = cal(X)_QQ$.
The *integral adelic points* are
$ cal(X)(bold(A)_ZZ) = cal(X)(RR) times product_p cal(X)(ZZ_p) subset.eq X(bold(A)_QQ) , $
a *closed* subset of the rational adelic points, and a much smaller one: it is the locus where
every coordinate is a $p$-adic integer at every $p$. For $cal(B) in "Br"(X)$ the evaluation
$P |-> "inv"_v cal(B)(P_v) in QQ slash ZZ$ is locally constant on $X(QQ_v)$ and vanishes for
almost all $v$, and one sets
$ cal(X)(bold(A)_ZZ)^"Br" = { (P_v) : sum_v "inv"_v cal(B)(P_v) = 0 " for all " cal(B) } . $
Because a global point $P in cal(X)(ZZ) subset.eq X(QQ)$ has $"inv"_v cal(B)(P) = "inv"_v$ of a
single class in $"Br"(QQ)$, class field theory ($sum_v "inv"_v = 0$ on $"Br"(QQ)$) gives
$ cal(X)(ZZ) subset.eq cal(X)(bold(A)_ZZ)^"Br" subset.eq cal(X)(bold(A)_ZZ) . $
An emptiness of the middle set with non-emptiness of the right one is a *Brauer--Manin
obstruction to an integral point*.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Why this can bite when the rational obstruction does not.* The pairing is the same pairing;
  only the domain shrinks. A class $cal(B)$ may take both values $0$ and $1 slash 2$ on
  $X(QQ_p)$ but only one of them on the compact subset $cal(X)(ZZ_p)$. That is exactly what
  happens below: the invariant at an odd $p$ is $chi(2)^(v_p (x+4))$, which is non-trivial only
  when $x$ has a *pole* at $p$ --- something a rational point may afford and an integral point
  may not. So the mechanism is not exotic: *the class measures denominators*, and integrality
  is the statement that there are none.
]

Two remarks on the definition, since both matter here.

- One may pair against $"Br"(cal(X))$ (the $ZZ$-scheme) or against the larger $"Br"(X)$ of the
  generic fibre; the latter gives a possibly finer obstruction and is what is used below. All
  the argument needs is that $cal(A)$ lies in $"Br"(X)$, so that its invariants are defined at
  every point of $cal(X)(bold(A)_ZZ) subset.eq X(bold(A)_QQ)$ and reciprocity applies to the
  rational ones.
- The integral analogue of the Hasse principle is *strong* approximation, not weak; the obstruction
  below is an obstruction to strong approximation on the group $bold(G)_m^1$-torsor $cal(X)$, and by
  a theorem of Colliot-Thélène and Xu for homogeneous spaces of connected groups it is the only one.
  So $cal(X)(ZZ) = nothing$ is not merely implied by the computation --- the computation is
  the reason.

= The variety <sec-variety>

Take $cal(X) : x^2 - 34 y^2 = -1$ over $ZZ$; write $K = QQ(sqrt(34))$, so $cal(X)$ is the affine
conic $N_(K slash QQ)(x + y sqrt(34)) = -1$, a torsor under the norm-one torus
$T = R^1_(K slash QQ) bold(G)_m$.

== No integral point

$cal(O)_K = ZZ[sqrt(34)]$ and its fundamental unit is $35 + 6 sqrt(34)$, of norm $+1$. An integral
point is a unit of norm $-1$, so there is none: *$cal(X)(ZZ) = nothing$.* (Checked also by brute
force for $0 <= y <= 2 dot 10^5$.)

== Local integral points everywhere

At $v = infinity$: $y = 1$, $x = sqrt(33)$.

At $v = 2$: again $y = 1$, so $x^2 = 33$; and $33 equiv 1 mod 8$, so $33$ is a square in $ZZ_2$.

At odd $p$: the gradient $(2x, -68 y)$ of $x^2 - 34 y^2 + 1$ vanishes mod $p$ only if
$x equiv 0$ and $34 y equiv 0$, which contradicts the equation; so $cal(X)$ is smooth over
$ZZ[1 slash 2]$ and Hensel lifts $FF_p$-points. A point mod $p$ exists for every odd $p$
(verified for all $p < 2000$; in general the affine conic over $FF_p$ has $p plus.minus 1 >= 2$
points). So *$cal(X)(ZZ_v) != nothing$ for all $v$.*

== Rational points are dense

$(3 slash 5, 1 slash 5)$ is a point: $9 slash 25 - 34 slash 25 = -1$. So $X tilde.equiv PP^1_QQ$
minus one closed point $P_infinity$ of degree $2$ (the locus $x = plus.minus sqrt(34) y$ at
infinity, with residue field $K$), and $X(QQ)$ is infinite and Zariski dense. *This example is
therefore about integrality and nothing else.*

= The Brauer class <sec-class>

We want a non-constant class in $"Br"(X)$. Since $X = PP^1_QQ without P_infinity$, the residue
sequence
$ 0 --> "Br"(PP^1_QQ) --> "Br"(QQ(X)) -->^(⊕ partial_Q) ⊕_(Q in (PP^1)^((1))) H^1(kappa(Q), QQ slash ZZ) $
says that a class lies in $"Br"(X)$ exactly when all its residues *on $X$* vanish; a residue at the
deleted point $P_infinity$ is allowed, and a non-zero one there makes the class non-constant.

Try $cal(A) = (2, lambda)$ with $lambda = x + c$, $c in ZZ$. For a constant $a$ the tame symbol is
$partial_Q (a, f) = overline(a)^(v_Q (f)) in kappa(Q)^times slash kappa(Q)^(times 2)$, so:

- *At $P_infinity$*, $v(x+c) = -1$ and $kappa(P_infinity) = K = QQ(sqrt(34))$. Since
  $2$ is not a square in $K$, the residue is non-trivial and $cal(A)$ is non-constant.
- *At the zeros of $x + c$*, which form the closed subscheme $x = -c$, $34 y^2 = c^2 + 1$: the
  residue field is $QQ(sqrt(34(c^2+1)))$, and the residue is the class of $2$ there. It is trivial
  precisely when $2$ is a square in that field, i.e. when $34(c^2+1) in 2 (QQ^times)^2$, i.e. when
  $ 17(c^2 + 1) "is a perfect square." $

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *The choice $c = 4$.* $17 dot (4^2 + 1) = 17 dot 17 = 289 = 17^2$. So the zeros of $x + 4$ on
  $X$ are $x = -4$, $y = plus.minus 1 slash sqrt(2)$, a single closed point with residue field
  $QQ(sqrt(2))$ --- and $2$ *is* a square there. Hence
  $ cal(A) = (2, x + 4) in "Br"(X) , quad cal(A) in.not "Br"(QQ) . $
]

There is a second representative. On $X$,
$ (2, x+4)(2, x-4) = (2, x^2 - 16) = (2, 34 y^2 - 17) = (2, 17)(2, 2y^2 - 1) , $
and $(2,17)$ splits because $17 equiv 1 mod 8$, while $2y^2 - 1 = -N_(QQ(sqrt(2)) slash QQ)(1 + y sqrt(2))$
gives $(2, 2y^2-1) = (2,-1) = 1$. So $(2, x+4) = (2, x-4)$, and one of the two is regular at any
given point --- useful at the point $x = -4$ itself.

= The evaluation, place by place <sec-eval>

Throughout, $"inv"_v cal(A)(P) = 1 slash 2$ iff the Hilbert symbol $(2, x+4)_v = -1$.

== The real place: always $0$

$(a,b)_infinity = -1$ requires $a < 0$ *and* $b < 0$, and here $a = 2 > 0$. So
$"inv"_infinity cal(A) = 0$ at every real point, whatever the sign of $x + 4$.

== The prime $2$: always $1 slash 2$

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Proposition.* For every $(x,y) in cal(X)(ZZ_2)$ one has $x equiv plus.minus 1 mod 8$, and
  therefore $"inv"_2 cal(A) = 1 slash 2$.

  #v(2mm)
  _Proof._ Write the equation as $x^2 + 1 = 34 y^2 = 2 dot 17 y^2$. The right side has odd
  $2$-valuation $1 + 2 v_2(y)$. If $x$ were even, $x^2 + 1$ would be a unit; so $x$ is odd, hence
  $x^2 equiv 1 mod 8$, hence $v_2(x^2+1) = 1$, hence $v_2(y) = 0$. Now divide by $2$:
  $ (x^2+1) slash 2 = 17 y^2 equiv 17 equiv 1 mod 8 , $
  using $y^2 equiv 1 mod 8$ for a $2$-adic unit $y$. But if $x equiv plus.minus 3 mod 8$ then
  $x^2 equiv 9 mod 16$ and $(x^2+1) slash 2 equiv 5 mod 8$. Contradiction; so
  $x equiv plus.minus 1 mod 8$.

  Then $x + 4 equiv 5$ or $3 mod 8$, i.e. $x + 4 equiv plus.minus 3 mod 8$, and for an odd
  $2$-adic unit $u$ one has $(2, u)_2 = +1$ iff $u equiv plus.minus 1 mod 8$. So
  $(2, x+4)_2 = -1$. $qed$
]

An exhaustive machine check over $ZZ slash 2^10$ finds $2048$ solutions, all with
$x mod 8 in {1, 7}$ and all with $(2, x+4)_2 = -1$.

== Odd primes: always $0$

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Proposition.* For every odd $p$ and every $(x,y) in cal(X)(ZZ_p)$, $"inv"_p cal(A) = 0$.

  #v(2mm)
  _Proof._ For odd $p$ and a constant $a$, $(a, f)_p = ((a slash p))^(v_p (f))$. So
  $(2, x+4)_p = -1$ forces both $(2 slash p) = -1$ (i.e. $p equiv plus.minus 3 mod 8$) and
  $v_p (x+4)$ odd, in particular $p | x + 4$.

  Suppose $p | x+4$, so $x equiv -4$. Then $34 y^2 = x^2 + 1 equiv 17 mod p$. Here $p != 17$,
  because $17 equiv 1 mod 8$ has $(2 slash 17) = +1$; so $17$ is invertible and
  $2 y^2 equiv 1 mod p$, with $y$ a unit. Thus $2 equiv (y^(-1))^2$ is a square mod $p$,
  contradicting $(2 slash p) = -1$. $qed$
]

(The two conditions "$p | x+4$ is realisable on $cal(X)(ZZ_p)$" and "$2$ is a square mod $p$" were
also compared directly for all odd $p < 5000$: they agree at every prime.)

== The sum

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *Theorem.* For every $(P_v) in cal(X)(bold(A)_ZZ)$,
  $ sum_v "inv"_v cal(A)(P_v) = underbrace(0, v = infinity) + underbrace(1 slash 2, v = 2)
    + underbrace(0, v "odd") = 1/2 != 0 . $
  Hence $cal(X)(bold(A)_ZZ)^cal(A) = nothing$ while $cal(X)(bold(A)_ZZ) != nothing$: a
  Brauer--Manin obstruction to an integral point, on a variety with a dense set of rational
  points.
]

= How the rational points escape <sec-escape>

This is the interesting half, and it is what makes the example an *integral* one. Reciprocity
forces $sum_v "inv"_v cal(A)(P) = 0$ at every $P in X(QQ)$, and the theorem says
$"inv"_2 = 1 slash 2$ whenever $P$ is $2$-integral and $"inv"_p = 0$ whenever $P$ is
$p$-integral. So *every rational point must fail to be $p$-integral at some odd
$p equiv plus.minus 3 mod 8$*, and the failure must be visible as an odd pole order of $x+4$,
i.e. as a denominator.

Here are all rational points of denominator $<= 45$, with the places where the invariant is
$1 slash 2$:

#align(center)[
#table(columns: 5, align: (right, right, right, center, center), stroke: 0.4pt,
  inset: 5pt,
  [$x$], [$y$], [denom], [places with $"inv" = 1 slash 2$], [that odd $p$ mod $8$],
  [$5 slash 3$], [$1 slash 3$], [$3$], [${2, 3}$], [$3$],
  [$29 slash 3$], [$5 slash 3$], [$3$], [${2, 3}$], [$3$],
  [$3 slash 5$], [$1 slash 5$], [$5$], [${2, 5}$], [$5$],
  [$99 slash 5$], [$17 slash 5$], [$5$], [${2, 5}$], [$5$],
  [$27 slash 11$], [$5 slash 11$], [$11$], [${2, 11}$], [$3$],
  [$75 slash 11$], [$13 slash 11$], [$11$], [${2, 11}$], [$3$],
  [$11 slash 27$], [$5 slash 27$], [$27$], [${2, 3}$], [$3$],
  [$3 slash 29$], [$5 slash 29$], [$29$], [${2, 29}$], [$5$],
  [$141 slash 37$], [$25 slash 37$], [$37$], [${2, 37}$], [$5$],
  [$61 slash 45$], [$13 slash 45$], [$45$], [${2, 5}$], [$5$],
)]

Every row has an even number of bad places --- Hilbert reciprocity --- and every row contains $2$
together with exactly one odd prime, which is $equiv plus.minus 3 mod 8$ and divides the
denominator. Nothing here is a coincidence: it is the two propositions of @sec-eval read
backwards.

The same holds along the orbit of $(3 slash 5, 1 slash 5)$ under multiplication by the
fundamental unit $35 + 6 sqrt(34)$:
$ (3/5, 1/5) --> (309/5, 53/5) --> (21627/5, 3709/5) --> (1513581/5, 259577/5) --> dots , $
all with denominator $5$, all with $"inv"_5 = 1 slash 2$. The denominator $5$ never goes away,
and $5 equiv 5 mod 8$. The rational points are dense, and *every single one of them carries a
pole at a prime where $2$ is a non-residue.*

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *The escape hatch, directly.* Take $p = 3$ and a $QQ_3$-point with $v_3(x) = -1$, say
  $x = a slash 3$, $y = b slash 3$ with $a, b$ units: the equation becomes $a^2 + 9 = 34 b^2$,
  which mod $9$ asks that $7$ be a square --- and $4^2 = 16 equiv 7 mod 9$. Such points exist,
  they have $v_3(x+4) = -1$ odd, and $"inv"_3 = 1 slash 2$. They are not $3$-integral. The class
  $cal(A)$ takes both values on $X(QQ_3)$ and only one value on $cal(X)(ZZ_3)$ --- the
  phenomenon described in @sec-setup, with numbers.
]

= What the class really is: genus theory <sec-genus>

The residue of $cal(A)$ at $P_infinity$ is the class of $2$ in $K^times slash K^(times 2)$,
$K = QQ(sqrt(34))$ --- that is, the quadratic character of $K$ cutting out
$ K(sqrt(2)) = QQ(sqrt(2), sqrt(17)) , $
which is *the genus field of $K$*: the unramified quadratic extension of $K$ corresponding to the
factorisation $34 = 2 dot 17$. PARI gives $h(K) = 2$ with class group $ZZ slash 2$, generated by
that genus class.

So the Brauer--Manin obstruction here is not new mathematics dressed up --- it *is* the classical
genus-theory obstruction to the negative Pell equation, written as a sum of local invariants.
Two consistency checks that it had to be this class:

- The residue must be *unramified everywhere* over $K$, or $cal(A)$ would not extend over the
  integral model in the way the argument uses; the unramified quadratic characters of $K$ are the
  genus characters.
- The residue must lie in $ker("cor"_(K slash QQ))$ for the class to descend, and corestriction on
  square classes is the norm: $N_(K slash QQ)(2) = 4$, a square. $checkmark$

This also explains the shape of the answer. $"Br"(cal(X)) slash "Br"(ZZ) tilde.equiv ZZ slash 2$
for a torsor under $T = R^1_(K slash QQ) bold(G)_m$, since
$H^1(QQ, hat(T)) = hat(H)^1(ZZ slash 2, ZZ^-) = ZZ slash 2$; there is one class to try, and it
works.

= Is $34$ special? <sec-family>

No --- and it is worth checking, because a single example proves nothing about the method. Run the
same recipe for $d = 2q$ with $q equiv 1 mod 8$ prime: find $c$ with $q(c^2+1)$ a square (a point
on an auxiliary Pell conic), form $cal(A) = (2, x+c)$ on $x^2 - d y^2 = -1$, and compute
$"inv"_2$ over all of $ZZ slash 2^10$.

#align(center)[
#table(columns: 5, align: (right, right, right, center, center), stroke: 0.4pt, inset: 5pt,
  [$d$], [$q$], [$c$], [$"inv"_2$ on $cal(X)(ZZ_2)$], [negative Pell],
  [$34$],  [$17$],  [$4$],    [$1 slash 2$ (constant)], [insoluble],
  [$82$],  [$41$],  [$32$],   [$0$ (constant)],         [soluble],
  [$146$], [$73$],  [$1068$], [$1 slash 2$ (constant)], [insoluble],
  [$178$], [$89$],  [$500$],  [$1 slash 2$ (constant)], [insoluble],
  [$194$], [$97$],  [$5604$], [$1 slash 2$ (constant)], [insoluble],
  [$226$], [$113$], [$776$],  [$0$ (constant)],         [soluble],
  [$274$], [$137$], [$1744$], [$0$ (constant)],         [soluble],
)]

The class detects the obstruction exactly when there is one, and is silent exactly when there is
not: seven for seven. In each case the residue field of the zeros of $x + c$ is $QQ(sqrt(2))$,
so the class is unramified on $X$ by the same computation as for $d = 34$; and $d = 34$ is the
smallest such $d$.

= Relative dimension zero <sec-dim0>

Does any of this survive when $cal(X) --> "Spec" ZZ$ is quasi-finite --- when the generic fibre
is a finite set of closed points rather than a curve? It does, but the answer splits in two, and
the split is exactly the point made in the box of @sec-setup.

== The collapse: a finite $ZZ$-scheme has no integral theory

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Proposition.* Let $cal(X) = "Spec" B$ with $B$ a *finite* $ZZ$-algebra. Then
  $cal(X)(ZZ_p) = cal(X)(QQ_p)$ for every $p$, and therefore
  $ cal(X)(bold(A)_ZZ) = X(bold(A)_QQ) . $

  #v(2mm)
  _Proof._ A $QQ_p$-point is a ring homomorphism $phi : B --> QQ_p$. Every element of $B$ is
  integral over $ZZ$, hence over $ZZ_p$, so every element of $phi(B)$ is integral over $ZZ_p$;
  and $ZZ_p$ is integrally closed in $QQ_p$. So $phi(B) subset.eq ZZ_p$. (Equivalently: a finite
  morphism is proper, and this is the valuative criterion for the discrete valuation ring
  $ZZ_p subset QQ_p$.) The real place is unchanged. $qed$
]

So for a finite $ZZ$-scheme --- an order in a number field, or $ZZ[x] slash (f)$ with $f$ *monic*
--- the integral Brauer--Manin set *is* the rational one, and nothing bearing the word "integral"
can be new. In the language of @sec-setup: a class separates $cal(X)(ZZ_p)$ from $X(QQ_p)$ only by
seeing a denominator, and a finite $ZZ$-scheme has none. That is why the example of this note is an
affine curve: non-properness is not a convenience of the exposition, it is the hypothesis.

== What the rational theory in dimension zero is

Write $X = "Spec"(product_i K_i)$; equivalently, $X$ is the finite $G_QQ$-set
$S = "Hom"(product K_i, overline(QQ))$, and
$ X(QQ) = S^(G_QQ), quad X(QQ_v) = S^(G_v) . $
Local points almost everywhere therefore says: every Frobenius --- by Chebotarev, every cyclic
subgroup --- of $Gamma = "Gal"(L slash QQ)$, $L$ the Galois closure, is conjugate into one of the
stabilisers $H_i$. If $X$ is *connected* there is a single proper $H$, and a proper subgroup can
never cover a finite group by its conjugates (Jordan); so a connected zero-dimensional scheme with
points almost everywhere has a rational point, which is the familiar statement that a number field
$K != QQ$ has infinitely many primes with no degree-one factor. Disconnected $X$ can fail, and the
first failure is in degree $5$: a zero-dimensional scheme of degree $<= 4$ with points almost
everywhere has a global point, a fact Harari and Voloch use as a lemma, and whose sharpness they
record in Remark 3.1 with an example they credit to Tate.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Tate's example, and the class that kills it.* Let $f = x^3 - x - 1$, of discriminant $-23$ and
  Galois group $S_3$, and take
  $ X = "Spec" QQ[x] slash (f) quad union.sq quad "Spec" QQ(sqrt(-23)) . $
  A Frobenius in $S_3$ is trivial, a transposition, or a $3$-cycle; in the first two cases $f$ has
  a root in $QQ_v$, and in the third the Frobenius lies in $A_3$, so $-23$ is a square in $QQ_v$.
  Hence $X(QQ_v) != nothing$ for every $v$ (checked for all $p < 50000$, at the ramified prime
  $23$, and at $infinity$, where $f$ has one real root), while $X(QQ) = nothing$: neither factor
  is $QQ$.

  #v(2mm)
  Now $2$ is *inert* in $QQ[x] slash (f)$ and *splits* in $K_2 = QQ(sqrt(-23))$. Let
  $ cal(B) = (0, cal(B)_2) in "Br"(K_1) xor "Br"(K_2) = "Br"(X) , $
  with $cal(B)_2$ the quaternion algebra over $K_2$ ramified at exactly the two primes above $2$
  --- it exists, the ramification set being even and $K_2$ having no real place, and PARI's
  `alginit` builds it. Then at $v = 2$ the only available branch is $K_2$, and both of its points
  give $"inv"_2 = 1 slash 2$; at every other $v$ the $K_1$-branch gives $0$ because
  $cal(B)_1 = 0$, and the $K_2$-branch gives $0$ because $cal(B)_2$ is unramified there. So
  $ sum_v "inv"_v cal(B)(P_v) = 1/2 quad "for every" (P_v) in X(bold(A)_QQ) , $
  and $X(bold(A)_QQ)^"Br" = nothing$. The shape is the one of @sec-eval: the whole obstruction at
  a single prime.

  #v(2mm)
  Both branches are cut out by *monic* polynomials, so by the Proposition
  $cal(X)(bold(A)_ZZ) = X(bold(A)_QQ)$ and this is simultaneously an obstruction to
  $cal(X)(ZZ)$ --- an integral Brauer--Manin obstruction in relative dimension zero with no
  integral content whatsoever.
]

== Where integrality does bite: quasi-finite, not finite

What is left is the non-monic case. There a root can fail to be $p$-adically integral,
$cal(X)(ZZ_p) subset.neq X(QQ_p)$ again, and integrality *selects among the degree-one places
above $v$*. That is enough for a genuinely integral obstruction, and the smallest example is
about as small as an example gets.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *An integral obstruction in relative dimension zero.* Let
  $ cal(X) = "Spec" ZZ[x] slash ((2x-1)(3x-1)) = "Spec" ZZ[x] slash (6x^2 - 5x + 1) , $
  so $X = "Spec"(QQ times QQ)$. Then $cal(X)(ZZ) = nothing$ and $X(QQ) = {1 slash 2, 1 slash 3}$,
  while
  $ cal(X)(ZZ_2) = {1/3}, quad cal(X)(ZZ_3) = {1/2}, quad
    cal(X)(ZZ_p) = {1/2, 1/3} " otherwise," quad cal(X)(RR) = {1/2, 1/3} , $
  so $cal(X)(bold(A)_ZZ) != nothing$. Now $"Br"(X) = "Br"(QQ) xor "Br"(QQ)$, one class per
  component; the constant classes are the diagonal, so the useful ones are the *non-diagonal*
  ones. Take
  $ cal(B) = ((-1,-1), (-1,-3)) , quad "ramified at" {2, infinity} "and" {3, infinity} . $
  At $v = 2$ the point is forced onto the second branch, where $"inv"_2 (-1,-3) = 0$; at $v = 3$
  onto the first, where $"inv"_3 (-1,-1) = 0$; at $v = infinity$ nothing is forced and *both*
  branches give $1 slash 2$; everywhere else both classes are unramified. Hence
  $ sum_v "inv"_v cal(B)(P_v) = 1/2 quad "for every" (P_v) in cal(X)(bold(A)_ZZ) . $
  But the rational adelic point that is $x = 1 slash 2$ at every place has
  $"inv"_2 + "inv"_infinity = 1 slash 2 + 1 slash 2 = 0$, as reciprocity demands. So
  $ cal(X)(bold(A)_ZZ)^"Br" = nothing quad "while" quad X(bold(A)_QQ)^"Br" != nothing : $
  the obstruction is integral and nothing but integral.
]

Two remarks on that example. First, the underlying fact is a triviality --- $1 slash 2$ and
$1 slash 3$ are not integers, though at each place one of them is a local integer --- and the
Brauer class is exactly the reciprocity bookkeeping of that covering, just as the class of
@sec-genus was the bookkeeping of genus theory. Second, the two *forced* places $2$ and $3$
contribute nothing, and the obstruction is carried by the real place, where nothing is forced at
all; the forcing is what removes the escape route, not what supplies the invariant.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *The dichotomy.* In relative dimension zero the integral Brauer--Manin obstruction is
  non-vacuous exactly when $cal(X) --> "Spec" ZZ$ fails to be finite. What a Brauer class can see
  is denominators; a finite $ZZ$-scheme has none, the negative Pell conic of this note has a
  denominator at some prime $p equiv plus.minus 3 mod 8$ for every one of its rational points, and
  the leading coefficient of $2x - 1$ is the smallest denominator there is.
]

= Summary <sec-summary>

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  On $cal(X) : x^2 - 34 y^2 = -1$ over $ZZ$ the quaternion class $cal(A) = (2, x+4)$ is
  unramified on the generic fibre, non-constant, and evaluates to $1 slash 2$ at $v = 2$ and to
  $0$ at every other place, *for every integral adelic point*. Hence
  $cal(X)(bold(A)_ZZ) != nothing$, $cal(X)(bold(A)_ZZ)^"Br" = nothing$, $cal(X)(ZZ) = nothing$.
  Rational points are dense and satisfy $sum_v "inv"_v = 0$ by reciprocity; they manage it by
  having a denominator at a prime $p equiv plus.minus 3 mod 8$, and that denominator is precisely
  what an integral point is forbidden. The class is the genus character of $QQ(sqrt(34))$, so the
  obstruction is the classical one --- but the Brauer formulation is the one that generalises,
  and by Colliot-Thélène--Xu it is, for such torsors, the only obstruction there is.
]

#v(3mm)

_Companion file:_ `integral-bm.gp`, run as

```sh
gp -q -s 2000000000 integral-bm.gp < /dev/null > results/integral-bm.txt
```

It verifies (1) the norm of the fundamental unit, (2) local solubility at every place,
(3) the residue computation for $cal(A)$, (4)--(6) the three invariant computations,
(8) reciprocity and the denominators of rational points, (9) the genus-field identification,
(10) the family scan of @sec-family, and (11) the three claims of @sec-dim0: the collapse
$cal(X)(ZZ_p) = cal(X)(QQ_p)$ for monic equations, Tate's example with its quaternion class,
and the invariant sums of $(2x-1)(3x-1) = 0$ over $cal(X)(bold(A)_ZZ)$ and over
$X(bold(A)_QQ)$.
