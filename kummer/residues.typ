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
  #text(size: 16pt, weight: "bold")[Residues on the Brauer group]
  #v(2mm)
  #text(size: 10pt)[What $partial_v$ is, why "unramified" is the right word for its kernel,
  and in what sense a place and a codimension-one subvariety are the same thing]
  #v(1mm)
  #text(size: 9pt, style: "italic")[companion to `csa-brauer.typ` and `corestriction.typ`;
  checks in `residues.gp`]
]

#v(4mm)

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *The map in one line.* Let $K$ be a field with a discrete valuation $v$, valuation ring
  $cal(O)_v$, residue field $kappa(v)$. There is a homomorphism
  $ partial_v : "Br"(K) --> H^1 (kappa(v), QQ slash ZZ) = "Hom"_"cont" (G_(kappa(v)), QQ slash ZZ) $
  (defined on the prime-to-$"char" kappa(v)$ part; see @sec-wild), whose kernel is exactly the set
  of classes that *extend to an Azumaya algebra over $cal(O)_v$* --- classes with good reduction
  at $v$. A class in the kernel is called *unramified at $v$*.

  #v(2mm)
  Three descriptions of the same map, in increasing order of usefulness for computation:
  it is the *inertia edge map* of the Hochschild--Serre spectral sequence (@sec-inertia); it is
  the *Gysin boundary* of the localisation sequence in étale cohomology, which is why codimension
  one is the right codimension (@sec-gysin); and it is the *tame symbol*, which is what you
  actually evaluate (@sec-tame):
  $ partial_v (a, b)_zeta = overline((-1)^(v(a) v(b)) space a^(v(b)) b^(-v(a))) space
    in space kappa(v)^times slash (kappa(v)^times)^n . $

  #v(2mm)
  Over a $p$-adic field $partial_v$ *is* the invariant (@sec-local), so it says nothing new;
  over a number field, likewise (@sec-nf). It becomes an invariant with content exactly when
  $kappa(v)$ is big --- that is, in the geometric setting, where $v$ runs over the prime divisors
  of a variety (@sec-geometry).
]

= The setting, and the exact sequence <sec-setting>

Throughout, $K$ is a field, $n$ an integer invertible in every residue field in sight, and
$"Br"(K) = H^2 (K, (K^s)^times)$; recall $"Br"(K)[n] = H^2 (K, mu_n)$ once $n$ is invertible in
$K$. For a discrete valuation $v$ on $K$ write $cal(O)_v$ for the ring, $pi$ for a uniformiser,
$kappa(v) = cal(O)_v slash pi$ for the residue field, assumed perfect for convenience.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *The residue sequence.* With $n$ invertible in $kappa(v)$,
  $ 0 --> "Br"(cal(O)_v)[n] --> "Br"(K)[n] -->^(partial_v) H^1 (kappa(v), ZZ slash n) $
  is exact, and if $K$ is complete (or $cal(O)_v$ henselian) the last map is *onto* and the first
  group is $"Br"(kappa(v))[n]$:
  $ 0 --> "Br"(kappa(v))[n] --> "Br"(K)[n] -->^(partial_v) H^1 (kappa(v), ZZ slash n) --> 0 . $
]

Two remarks that are easy to slide past.

- The identification $H^1 (kappa, ZZ slash n) tilde.equiv H^1 (kappa, mu_n) = kappa^times slash
  (kappa^times)^n$ used in the tame-symbol formula requires $mu_n subset kappa$ and *a choice of
  primitive $zeta_n$*. Without roots of unity the target is honestly
  $H^1 (kappa, ZZ slash n(-1)) = H^1 (kappa, "Hom"(mu_n, ZZ slash n))$, i.e. a Tate twist by $-1$.
  For $n = 2$ the twist is invisible, which is why the quaternion formulas below look so clean.
- Injectivity of $"Br"(cal(O)_v) --> "Br"(K)$ is *Auslander--Goldman*: for any regular integral
  domain $R$ with fraction field $K$, $"Br"(R) --> "Br"(K)$ is injective. Exactness at
  $"Br"(K)[n]$ --- that a class killed by $partial_v$ really does come from an Azumaya algebra
  over $cal(O)_v$ --- is the one-dimensional case of *purity*, and is the assertion that makes
  the word "unramified" mean something (@sec-unram).

= Construction 1: inertia <sec-inertia>

Assume $K$ complete. Then $G_K$ sits in
$ 1 --> I --> G_K --> G_(kappa(v)) --> 1 , $
$I$ the inertia group, and the tame quotient is $I^t tilde.equiv limits(lim)_(<--) mu_n =
hat(ZZ)'(1)$, canonically, with $G_(kappa(v))$ acting through the cyclotomic character. Since
$mu_n$ is unramified, $H^0 (I, mu_n) = mu_n$ and
$ H^1 (I, mu_n) = "Hom"(I^t, mu_n) = "Hom"(mu_n, mu_n) = ZZ slash n $
canonically, *with trivial* $G_kappa$*-action* --- the twist in $I^t$ cancels the twist in the
coefficients. Hochschild--Serre
$ E_2^(p q) = H^p (G_(kappa(v)), H^q (I, mu_n)) ==> H^(p+q) (K, mu_n) $
has $H^q (I, mu_n) = 0$ for $q >= 2$ ($I^t$ has cohomological dimension $1$), so the
$E_2$-page has two rows and the five-term-type filtration on $H^2$ gives
$ 0 --> H^2 (kappa(v), mu_n) --> H^2 (K, mu_n) -->^(partial_v)
  H^1 (kappa(v), H^1 (I, mu_n)) = H^1 (kappa(v), ZZ slash n) --> 0 . $

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  So $partial_v$ is: *restrict the cocycle to inertia, and read off what is left over the residue
  field*. The kernel is the inflated part, i.e. the classes coming from $kappa(v)$ ---
  the algebras split by an unramified extension in the strong sense that they are already
  defined over the residue field. That is precisely the picture `local-duality.typ` §2.3
  works with when it splits a division algebra over a complete field by its unramified maximal
  subfield.
]

The non-complete case reduces to this one: $partial_v$ for $cal(O)_v subset K$ is *defined* as
$partial_v$ for the completion, precomposed with $"Br"(K) --> "Br"(K_v)$. Everything below is
compatible with that.

= Construction 2: the Gysin boundary, and why codimension one <sec-gysin>

Let $X$ be a regular scheme, $Z subset X$ a regular closed subscheme of codimension $c$, and
$U = X without Z$. Étale cohomology with supports gives the localisation sequence
$ dots.c --> H^q_Z (X, mu_n) --> H^q (X, mu_n) --> H^q (U, mu_n) --> H^(q+1)_Z (X, mu_n) --> dots.c $
and *absolute purity* (Grothendieck's conjecture, proved by Gabber; see [7] of @sec-refs) computes
the local terms:
$ H^q_Z (X, mu_n) tilde.equiv H^(q - 2c) (Z, mu_n^(⊗ (1 - c))) . $

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Why $c = 1$.* For $c = 1$ this reads $H^(q+1)_Z (X, mu_n) tilde.equiv H^(q-1) (Z, ZZ slash n)$,
  so with $q = 2$ the localisation sequence becomes
  $ H^2 (X, mu_n) --> H^2 (U, mu_n) -->^(partial) H^1 (Z, ZZ slash n) --> H^3 (X, mu_n) . $
  A boundary map that lands in $H^1$ --- a *character group* --- happens only in codimension one.
  In codimension $c$ the boundary lands in $H^(3 - 2c)$, which is zero for $c >= 2$. This is the
  structural reason the answer to "which subvarieties carry a residue?" is
  *the codimension-one ones and no others*.
]

Taking $X = "Spec" cal(O)_v$, $Z = "Spec" kappa(v)$, $U = "Spec" K$ recovers @sec-inertia.
Taking $X$ a variety and letting $Z$ run over prime divisors gives @sec-geometry. The two are the
same map; the second is the first applied to the local ring at the generic point of $Z$.

= Construction 3: the tame symbol --- what you compute with <sec-tame>

This is the form in which residues appear in every computation in this repository.

== Cyclic algebras <sec-tame-cyclic>

A class in $"Br"(K)[n]$ is a sum of cyclic algebras $(chi, b)$ with $chi in H^1 (K, ZZ slash n)$ a
character and $b in K^times$; concretely $(chi, b)$ is the crossed product for the cyclic
extension cut out by $chi$, with $u^n = b$ (`csa-brauer.typ` §1.2).

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Residue of a cyclic algebra.* If $chi$ is *unramified* at $v$ --- i.e. $chi$ is inflated from
  a character $overline(chi)$ of $G_(kappa(v))$ --- then
  $ partial_v (chi, b) = v(b) dot overline(chi) space in space H^1 (kappa(v), ZZ slash n) . $
]

Everything is in that line: the residue only sees the *valuation of the slot $b$*, and returns the
*reduction of the character slot*. In particular $(chi, u)$ is unramified for every unit $u$, and
$(chi, pi)$ has residue $overline(chi)$: the algebra is ramified exactly to the extent that its
"norm slot" has a pole or a zero.

== Symbol algebras and the tame symbol <sec-tame-symbol>

Suppose $mu_n subset K$ and fix $zeta$. For $a, b in K^times$ let $(a,b)_zeta$ be the symbol
algebra $⟨ x, y : x^n = a, y^n = b, y x = zeta x y ⟩$. Then

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  $ partial_v (a,b)_zeta = overline((-1)^(v(a) v(b)) space a^(v(b)) space b^(-v(a)))
    space in space kappa(v)^times slash (kappa(v)^times)^n
    tilde.equiv^zeta H^1 (kappa(v), ZZ slash n) . $
]

The argument of the bar is a unit --- that is the point of the exponents --- so reducing it mod
$pi$ makes sense. This is exactly Milnor's *tame symbol*
$partial : K_2^M (K) --> kappa(v)^times$, and the fact that it is well defined on $K_2$ (i.e.
kills the Steinberg relation $(a, 1-a)$) is the fact that it is well defined on Brauer classes.

For $n = 2$, writing $a = pi^alpha u$, $b = pi^beta w$ with $u, w$ units:
$ partial_v (a,b) = (-1)^(alpha beta) space overline(u)^beta space overline(w)^(-alpha)
  space in space kappa(v)^times slash (kappa(v)^times)^2 . $

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Sanity check against the Hilbert symbol.* Over $QQ_p$, $p$ odd, the Legendre symbol of that
  residue is
  $ ((-1) slash p)^(alpha beta) (u slash p)^beta (w slash p)^(-alpha)
    = (-1)^(alpha beta (p-1) slash 2) (u slash p)^beta (w slash p)^alpha , $
  which is the classical formula for $(a,b)_p$. So over a local field
  "$partial_v = 0$" and "$(a,b)_v = 1$" say the same thing --- see @sec-local for why that is not
  a coincidence but a degeneration.
]

== The smallest interesting example <sec-tame-example>

Take $k$ of characteristic $eq.not 2$, $K = k(t)$, and $cal(A) = (a, t)$ with $a in k^times$.
Residues at the closed points of $PP^1_k$:

#align(center, table(
  columns: 4, align: (left, center, center, left),
  stroke: 0.4pt + luma(170), inset: (x: 7pt, y: 4pt),
  table.header([point $P$], [$v_P (a)$], [$v_P (t)$], [$partial_P cal(A) in kappa(P)^times slash
    square$]),
  [$t = 0$], [$0$], [$1$], [$overline(a)^1 = overline(a) in k^times slash square$],
  [$t = c$, $c eq.not 0$], [$0$], [$0$], [trivial],
  [$t = infinity$], [$0$], [$-1$], [$overline(a)^(-1) = overline(a)$],
  [any other closed pt], [$0$], [$0$], [trivial],
))

#v(2mm)
So $cal(A)$ is ramified exactly along the divisor $(0) + (infinity)$, with residue $overline(a)$ at
both --- and the two residues *cancel*, which is @sec-reciprocity. Consequences, all of them
typical:

- $cal(A) in "Br"(GG_m)$: the only ramification of $cal(A)$ is at points *removed* from
  $PP^1 without {0, infinity}$, so on the open set there is nothing to check. This is the exact
  mechanism by which `integral-bm.typ` §2 produces a non-constant class on a conic by deleting one
  closed point at infinity.
- $cal(A) in.not "Br"(PP^1_k)$ unless $a in (k^times)^2$: a proper curve has nowhere to hide
  ramification.

A second one, worth doing because the answer is not what a first guess suggests. For
$cal(B) = (t, t-1)$ over $k(t)$:
$ partial_0 cal(B) = (-1)^(1 dot 0) t^0 (t-1)^(-1) |_(t=0) = overline(-1) , quad
  partial_1 cal(B) = t^1 |_(t=1) = overline(1) = "trivial" , quad
  partial_infinity cal(B) = overline(-1) , $
the last from $alpha = beta = -1$ and $(-1)^1 dot t^(-1) (t-1)^(1) = -(1-s)$ with $s = 1 slash t$.
The vanishing at $t = 1$ is the Steinberg relation in disguise; the surviving residues are
$overline(-1)$ at $0$ and $infinity$, cancelling again.

= What "unramified" means, and why the word is honest <sec-unram>

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Theorem.* For $cal(A) in "Br"(K)[n]$, $n$ invertible in $kappa(v)$, the following are
  equivalent.
  #v(1mm)
  + $partial_v (cal(A)) = 0$.
  + $cal(A)$ is in the image of $"Br"(cal(O)_v) --> "Br"(K)$: it is the generic fibre of an
    *Azumaya algebra over $cal(O)_v$* --- a form of a matrix algebra over the whole ring, not just
    over the fraction field. ("Good reduction.")
  + $cal(A) ⊗_K K_v^"nr"$ is split, where $K_v^"nr"$ is the maximal unramified
    extension --- equivalently the cocycle is trivial on inertia.
  + ($K$ complete) $cal(A)$ is Brauer-equivalent to an algebra $cal(A)_0 ⊗_(kappa(v)) K$
    for some CSA $cal(A)_0$ over $kappa(v)$.
]

(1) $<==>$ (3) is @sec-inertia read backwards. (1) $<==>$ (2) is purity in dimension one. The word
"unramified" is the one from (3): the algebra needs no ramification in the field extensions that
split it.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *A caution about "ramified".* For a *quaternion algebra over a number field*, "ramified at $v$"
  is usually said to mean $"inv"_v = 1 slash 2$, i.e. $cal(A) ⊗ K_v$ is a division
  algebra. That is a different-looking condition, but @sec-nf shows the two coincide at finite
  places. At a *real* place they do not: $"Br"(RR) = 1 slash 2 ZZ slash ZZ$ is non-trivial and
  there is no residue map at all. Archimedean places carry invariants but not residues --- which
  is the first place where "one residue map per place" needs qualifying.
]

= Local fields: the residue *is* the invariant <sec-local>

Let $K_v$ be non-archimedean local, $kappa(v) = bb(F)_q$. Then $"Br"(bb(F)_q) = 0$ (Wedderburn),
so the residue sequence of @sec-setting collapses to an isomorphism
$ partial_v : "Br"(K_v) tilde.equiv H^1 (bb(F)_q, QQ slash ZZ) = "Hom"_"cont" (hat(ZZ), QQ slash ZZ)
  tilde.equiv^(chi |-> chi("Frob")) QQ slash ZZ , $
and *this isomorphism is $"inv"_v$*. The whole of local class field theory's
$"inv"_v : "Br"(K_v) tilde.equiv QQ slash ZZ$ (`local-duality.typ` §2) is the residue
map plus the accident $"Br"(bb(F)_q) = 0$. Equivalently: $"Br"(cal(O)_v) = 0$, so
*every* non-trivial class over a local field is ramified, and "unramified" degenerates to "split".

That is worth stating as a slogan, because it explains why the residue map looks like an empty
notion to someone who has only met it over $QQ_p$:

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  $partial_v$ carries information beyond $"inv"_v$ exactly when $"Br"(kappa(v)) eq.not 0$, i.e.
  exactly when the residue field is *not* finite or algebraically closed. Over $QQ_p$: no
  information. Over $QQ(t)$ at $t = 0$, where $kappa = QQ$: a great deal.
]

= Number fields: still nothing new, and why <sec-nf>

For $K$ a number field the non-archimedean places are the closed points of $"Spec" cal(O)_K$ ---
a regular scheme of dimension $1$ --- so "place" and "codimension-one point" agree on the nose,
and each has residue field a finite field $bb(F)_(q_v)$. By compatibility with completion and
@sec-local,
$ partial_v (cal(A)) = "inv"_v (cal(A) ⊗ K_v) in QQ slash ZZ . $
So the ramification set of $cal(A)$ is its set of non-split finite places, and Albert--Brauer--Hasse--Noether (`csa-brauer.typ` §3) says a class is determined by these plus the
real places, subject to $sum_v "inv"_v = 0$.

Two facts fall out that are used elsewhere in these notes:

- $"Br"(cal(O)_K) = ker(⊕_(v "real") 1 slash 2 ZZ slash ZZ -->^(sum) QQ slash ZZ)$: a
  class unramified at *every* finite place is determined by its real invariants, which must sum to
  zero. So $"Br"(cal(O)_K) = 0$ if $K$ has at most one real place, and is $(ZZ slash 2)^(r-1)$ if
  $K$ has $r >= 1$ real places. For $K = QQ$: zero, which is the statement "no quaternion algebra over $QQ$ is unramified at every finite place", i.e. the
  classical fact that a quaternion algebra over $QQ$ ramifies at an even number of places, and at
  least two of them.
- The residue map on $"Br"(QQ)$ recovers quadratic reciprocity, because it recovers the Hilbert
  symbol (@sec-tame-symbol) and Hilbert reciprocity is $sum_v "inv"_v = 0$. That derivation is
  `csa-brauer.typ` §4.

= Geometry: one residue per prime divisor <sec-geometry>

Now let $X$ be an integral scheme with function field $K = k(X)$.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Where residues come from geometrically.* For each point $x in X^((1))$ --- a codimension-one
  point, i.e. the generic point of an irreducible closed subvariety of codimension one --- the
  local ring $cal(O)_(X,x)$ is a one-dimensional local ring with fraction field $K$. If it is a
  *discrete valuation ring*, we get $partial_x : "Br"(K) --> H^1 (kappa(x), QQ slash ZZ)$.
  #v(2mm)
  $cal(O)_(X,x)$ is a DVR for every $x in X^((1))$ if and only if $X$ is *regular in codimension
  one* --- for which *normal* is enough (Serre's criterion). So residues are defined on any normal
  variety.
]

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *The Bloch--Ogus / Gersten complex.* For $X$ regular and integral,
  $ 0 --> "Br"(X) --> "Br"(k(X)) -->^(⊕_x partial_x)
    ⊕_(x in X^((1))) H^1 (kappa(x), QQ slash ZZ) $
  is exact: *a class on the function field extends to $X$ if and only if all its residues along
  prime divisors vanish.*
]

Three things to be careful about in that statement.

+ *Which Brauer group.* $"Br"(X)$ here means the cohomological Brauer group
  $"Br"'(X) = H^2_"ét" (X, GG_m)_"tors"$. That it coincides with the Azumaya Brauer group is a
  theorem (Gabber, and de Jong's proof) valid for $X$ quasi-projective over a ring, or more
  generally admitting an ample line bundle --- which covers everything in this repository.
+ *Regularity is needed for exactness on the left, not for the definition of the maps.* On a
  normal but singular $X$ the maps exist but a class can have all residues zero without extending.
  This is exactly purity, and it is a real theorem: Grothendieck for $dim <= 2$ (and, with
  Auslander--Goldman, for regular rings of dimension $<= 2$), Gabber for the prime-to-$p$ part in
  general, and, for the $p$-primary part, Česnavičius.
+ *The complex continues.* $⊕_x partial_x$ is only the first differential of the Gersten
  complex; the next map, a sum of "second residues" at codimension-two points, imposes the
  compatibility that makes ramification data glue. That is what Artin--Mumford exploit: the
  ramification of a class on a surface is a curve together with a double cover of it, and the
  double cover is constrained at the singular points of the curve.

== The ramification divisor <sec-ramdiv>

For $cal(A) in "Br"(k(X))$ the set of $x in X^((1))$ with $partial_x (cal(A)) eq.not 0$ is finite
(the tame symbol formula shows the residue is trivial wherever both slots are units, which excludes
only the finitely many components of the divisors of the slots). Its closure is the *ramification
divisor* $"Ram"(cal(A)) subset X$, and $cal(A) in "Br"(X without "Ram"(cal(A)))$. Every Brauer
class on a function field is unramified *somewhere*; the content is where.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *The mechanism behind every unramifiedness proof in these notes.* If $cal(A) = (g_1, g_2)_n$ and
  $"div"(g_1), "div"(g_2)$ are both *divisible by $n$*, then $v_x (g_i) equiv 0$ for all $x$,
  and the tame symbol is $overline(g_1^0 g_2^0) = 1$ everywhere. So $cal(A) in "Br"(X)$.
  #v(2mm)
  This is precisely why *descent functions give unramified algebras*: a function whose divisor is
  $n$-divisible is what an $n$-descent produces, and $n$-divisibility of the divisor is
  simultaneously the reason it is a descent function and the reason the algebra is unramified.
  `kummer-survey.typ` ("It is unramified") makes this argument for $cal(A)_(i j)$ on $E_d times E_d$,
  where $U - d e_i$ has divisor $2(T_i) - 2(O)$ because $T_i$ is $2$-torsion.
]

= Reciprocity, and where corestriction enters <sec-reciprocity>

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Faddeev's exact sequence.* For any field $k$ and $n$ invertible in $k$,
  $ 0 --> "Br"(k) --> "Br"(k(t)) -->^(⊕_P partial_P)
    ⊕_(P in (AA^1_k)^((1))) H^1 (kappa(P), QQ slash ZZ)
    -->^(sum_P "cor"_(kappa(P) slash k)) H^1 (k, QQ slash ZZ) --> 0 $
  is exact.
]

The last map being a *sum of corestrictions* is the residue reciprocity law: for a proper curve
$C$ over $k$ with function field $K$,
$ sum_(x in C^((1))) "cor"_(kappa(x) slash k) space partial_x (cal(A)) = 0
  quad "for all" cal(A) in "Br"(K) . $
For $C = PP^1$ this is the statement that the residue at $infinity$ is determined by the others,
which is what Faddeev's sequence says. It is the exact geometric analogue of
$sum_v "inv"_v = 0$; over $"Spec" cal(O)_K$ it *is* $sum_v "inv"_v = 0$, since $kappa(v)$ is
finite and $"cor"$ to $QQ slash ZZ$ is multiplication by the residue degree, i.e. the
identification of @sec-local.

Two immediate corollaries, both used in this repository:

- $"Br"(PP^1_k) = "Br"(k)$, and more generally $"Br"(PP^n_k) = "Br"(k)$: no room for
  ramification, and the constants inject because a rational point splits the map.
- The exactness in the middle is what lets one *construct* classes by prescribing residues:
  choose residues at finitely many closed points whose corestrictions sum to zero, and a class
  exists with exactly those residues. `integral-bm.typ` §2 chooses $c = 4$ precisely to arrange
  the residue pattern it wants.

Compatibility with the two transfer maps, which is why `corestriction.typ` is a companion to this
note:

#align(center, table(
  columns: 2, align: (left, left),
  stroke: 0.4pt + luma(170), inset: (x: 7pt, y: 4pt),
  table.header([map], [compatibility with residues]),
  [$"res"_(L slash K)$, $w | v$],
    [$partial_w compose "res"_(L slash K) = e(w slash v) dot "res"_(kappa(w) slash kappa(v))
      compose partial_v$],
  [$"cor"_(L slash K)$],
    [$partial_v compose "cor"_(L slash K) = sum_(w | v) "cor"_(kappa(w) slash kappa(v))
      compose partial_w$],
))

#v(2mm)
The second line is the reason *corestriction preserves unramifiedness*: if every $partial_w$
vanishes, so does $partial_v$ of the corestriction. That is the fact `ec-density-bm.typ` §5 needs
in order to know that $cal(A)_alpha = "cor"_(A(E) slash QQ(E)) (alpha, X - theta)$ is an element of
$"Br"$ of the curve and not merely of its function field. The first line shows that ramification
can be *killed by ramified base change*: if $e(w slash v)$ is divisible by $n$, the residue dies,
which is the standard way to split a class over a ramified extension.

= Places versus codimension-one subvarieties: the caveat <sec-places>

The question this note started from was whether "one residue per codimension-one subvariety" and
"one residue per place of $K$" are the same statement. They are close, and the difference is
exactly the interesting part.

#align(center, table(
  columns: 3, align: (left, left, left),
  stroke: 0.4pt + luma(170), inset: (x: 7pt, y: 4pt),
  table.header([], [$K$ a number field], [$K = k(X)$ a function field]),
  [places $arrow.r$ residues],
    [finite places give residues; *real places give an invariant but no residue*],
    [only the *divisorial* valuations give residues in the geometric sense],
  [the right index set],
    [$X^((1))$ for $X = "Spec" cal(O)_K$ --- exact match, up to archimedean],
    [$X^((1))$ for *a chosen model $X$* --- and the answer depends on the model],
  [what "unramified everywhere" means],
    [$"Br"(cal(O)_K)$: almost zero (@sec-nf)],
    [$"Br"_"nr" (K slash k)$: a birational invariant with real content],
))

#v(3mm)
The three ways the identification is imperfect:

+ *Not every valuation is divisorial.* $K$ carries valuations of rank $> 1$, valuations with
  non-finitely-generated residue extension, and so on. All of them have residue maps in the crude
  sense (take the residue for the associated DVR --- if the valuation has rank one and is
  discrete), but none of them are needed: for $X$ smooth and proper over $k$, a class unramified
  with respect to every *divisorial* valuation of $K slash k$ is unramified with respect to every
  valuation trivial on $k$. (Colliot-Thélène, [4] of @sec-refs, §2 --- the reduction uses that any
  valuation is dominated on some model by a divisorial one.) So one may as well work with prime
  divisors.
+ *Divisorial valuations are not the divisors of one $X$.* Blowing up creates new prime divisors
  and hence new residue maps. The valuations of $K slash k$ that are divisorial are those arising
  as $"ord"_D$ for $D$ a prime divisor on *some* normal model. Consequently
  $ "Br"(X) = inter.big_(x in X^((1))) ker partial_x quad "depends on" X , quad "whereas" quad
    "Br"_"nr" (K slash k) := inter.big_(v "divisorial") ker partial_v $
  does not. The two agree when $X$ is smooth and proper: $"Br"_"nr" (k(X) slash k) = "Br"(X)$, and
  therefore $"Br"(X)$ is a *birational invariant of smooth proper varieties*. This is the
  Artin--Mumford invariant, and the reason it is a rationality obstruction:
  $"Br"_"nr" (k(t_1,dots,t_n) slash k) = "Br"(k)$, so a non-constant unramified class certifies
  non-rationality.
+ *Archimedean places have no residue.* Over a number field, $"Br"(RR) eq.not 0$ contributes
  invariants that no residue map sees; the residue formalism computes $"Br"(cal(O)_K)$ only after
  the real places are added by hand. In the geometric setting there is no analogue --- which is
  the sense in which the geometric picture is the cleaner one.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *The short answer.* Yes, "residue at a codimension-one subvariety" and "residue at a place" are
  the same construction --- both are the residue for a discrete valuation ring inside $K$ --- and
  in the arithmetic case (Spec of a Dedekind ring) the two index sets literally coincide. What
  does not transfer is the *completeness* of the family: over a number field there is one canonical
  family of places, whereas over a function field the family of prime divisors depends on the
  model, and the model-independent object is the union over all models, $"Br"_"nr"$.
]

= The wild case <sec-wild>

Everything above assumed $n$ invertible in $kappa(v)$. When $p = "char" kappa(v)$ divides $n$:

- The tame symbol formula is simply false, and there is no map to $H^1 (kappa(v), ZZ slash p)$
  computing the $p$-part. The inertia argument of @sec-inertia breaks because $I$ has a wild part
  $P = I_"wild"$ with $H^*(P, mu_p) eq.not 0$.
- The correct targets are Kato's: for $K$ complete of characteristic $0$ with residue
  characteristic $p$, there is a filtration on $"Br"(K)[p^m]$ by "Swan conductor", with graded
  pieces built from differentials of $kappa(v)$; in equal characteristic $p$ the role of
  $H^1 (kappa, ZZ slash p)$ is played by logarithmic de Rham--Witt sheaves $nu(1)$ and residues
  become Artin--Schreier--Witt symbols.
- Purity for the $p$-part in mixed characteristic is much harder and is the content of
  Česnavičius's theorem ([8] of @sec-refs).

`wild-symbols.typ` in this repository is entirely about the ways the tame picture fails at
$p = "char"$, from the point of view of symbols rather than residues; §1 there is the
same break seen from the other side.

= Applications <sec-apps>

Six things the residue map is actually used for, ordered from the most formal to the most
concrete.

== Tsen's theorem, and the dimension count behind it <sec-tsen>

The residue sequence is a dévissage: it expresses cohomology of $K(t)$ in terms of cohomology of
$K$ and of the residue fields, which are *finite* over $K$. Iterating in every degree gives

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Cohomological dimension goes up by one.* For $K$ perfect and $n$ invertible,
  $ "cd"(K(t)) <= "cd"(K) + 1 . $
  _Sketch._ Each $H^i (K(t), mu_n)$ sits between $H^i (K, mu_n)$ and
  $⊕_P H^(i-1) (kappa(P), ZZ slash n)$; the residue fields $kappa(P)$ are finite over $K$, so they
  have the same cohomological dimension. For $i > "cd"(K) + 1$ both ends vanish. $qed$
]

Specialise to $k$ algebraically closed, so $"cd"(k) = 0$:
$ "cd"(k(t)) <= 1 quad ==> quad "Br"(k(t)) = H^2 (k(t), mu_n) = 0 . $
That is *Tsen's theorem* for $PP^1$, and the same argument with Faddeev's sequence
(@sec-reciprocity) gives it directly: $"Br"(k) = 0$ because $k$ is algebraically closed, and every
residue field $kappa(P)$ equals $k$, so $H^1 (kappa(P), QQ slash ZZ) = 0$ and the middle term of
the sequence is squeezed to nothing. A field with no residues and no constants has no Brauer group.

== Building classes to order: Faddeev backwards <sec-build>

Exactness *in the middle* of Faddeev's sequence is a construction principle: prescribe residues
$c_P$ at finitely many closed points, and a class realising them exists as soon as the
corestrictions cancel. For rational points there is an explicit recipe.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *The recipe.* Given $c_1, dots, c_r in QQ^times slash square$ and distinct
  $alpha_1, dots, alpha_r in QQ$, put
  $ cal(A) = product_(i=1)^r (c_i, space t - alpha_i) in "Br"(QQ(t))[2] . $
  Then $partial_(t - alpha_j) cal(A) = c_j$ for each $j$, every other closed point of $AA^1$ is
  unramified, and $partial_infinity cal(A) = product_i c_i$. So the prescription is realisable on
  $AA^1$ *always*, and on all of $PP^1$ exactly when $product_i c_i$ is a square --- which is the
  reciprocity condition of @sec-reciprocity and nothing else.
]

Two uses. First, this is how a Brauer--Manin obstruction gets *designed* rather than stumbled on:
one decides which places should carry which invariant, reads off the residues that forces, and
solves for the class. `integral-bm.typ` §2 chooses $c = 4$ for exactly this reason --- it is the
value making $17(c^2+1)$ a square, hence making the residue at the zeros of $x + c$ vanish while
the residue at the deleted point survives.

Second, on an *affine* curve there is no condition at all: whatever the residues one wants at the
points of $U$, the compensating residue can be parked at a deleted point. That is why non-proper
varieties have large Brauer groups, and why integral Brauer--Manin has content at all.

== Residues are the computable invariant <sec-computable>

$partial_P$ is a resultant --- see @sec-gp --- so it is the practical test for the two questions
one actually asks about a symbol algebra.

- *Is $cal(A)$ non-trivial? Are $cal(A)$ and $cal(B)$ different?* Compare residues. A single
  closed point where they differ settles it, with no need to find a splitting field.
- *Is $cal(A)$ constant?* Compute all its residues. By exactness on the left, a class on $PP^1_k$
  with no residues anywhere is in $"Br"(k)$ --- a *finite* test for a property that is otherwise a
  statement about every specialisation at once.

The second is worth spelling out because it is the one that surprises. Over $QQ(t)$, "$cal(A)$ is
constant" means all its specialisations $cal(A)(t_0)$ are one and the same class of $"Br"(QQ)$ ---
uncountably many conditions, decided by a handful of resultants. @sec-gp checks this on $64$
classes, twisted by $(-1,-1)$ so that "constant" does not quietly mean "trivial".

A third use, from the restriction half of the table in @sec-reciprocity: since
$partial_w compose "res" = e(w slash v) dot "res" compose partial_v$, a base change whose
ramification index is divisible by $n$ *kills* the residue. That is the standard way to write down
a splitting field: ramify hard enough at the places where the class is ramified.

== Good reduction kills the invariant <sec-goodred>

This is the fact that makes Brauer--Manin a finite computation rather than an infinite one.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Proposition.* $"Br"(ZZ_p) = 0$. Hence if $cal(X) --> "Spec" ZZ_p$ is smooth and
  $cal(A) in "Br"(cal(X))$, then $"inv"_p cal(A)(P) = 0$ for *every* $P in cal(X)(ZZ_p)$.

  #v(2mm)
  _Proof._ The residue sequence for $ZZ_p subset QQ_p$ reads
  $0 --> "Br"(ZZ_p) --> "Br"(QQ_p) --> H^1 (bb(F)_p, QQ slash ZZ) --> 0$ with the second map an
  isomorphism (@sec-local), so the first group vanishes. A point $P in cal(X)(ZZ_p)$ is a map
  $"Spec" ZZ_p --> cal(X)$, and $cal(A)(P) in "Br"(ZZ_p) = 0$. $qed$
]

So in $sum_v "inv"_v cal(A)(P_v)$ only the places of *bad* reduction --- for $cal(X)$ or for
$cal(A)$ --- can contribute, and the sum is finite and computable. And what makes a place bad for
$cal(A)$ specifically is exactly a non-zero residue along the special fibre: that is the
obstruction to extending $cal(A)$ over $cal(X)$, by @sec-unram. The whole Brauer--Manin apparatus
of `kummer-padic-density.typ` and `ec-density-bm.typ` rests on this reduction, usually silently.

== Iskovskikh's surface: an obstruction found by a residue argument <sec-isk>

The cleanest example of the residue map earning its keep. Let

$ X : quad y^2 + z^2 = (3 - x^2)(x^2 - 2) quad "over" QQ $

--- a Châtelet surface, with its standard smooth proper model. Iskovskikh (1971) found it as a
counterexample to the Hasse principle; Colliot-Thélène, Sansuc and Swinnerton-Dyer explained it.
The class is
$ cal(A) = (-1, space 3 - x^2) . $

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *Why it is unramified: two expressions with disjoint ramification.* On $X$,
  $ (3-x^2)(x^2-2) = y^2 + z^2 = N_(QQ(i) slash QQ)(y + i z) , $
  a norm, so $(-1, space (3-x^2)(x^2-2)) = 0$ in $"Br"(QQ(X))$ and therefore
  $ cal(A) = (-1, space 3 - x^2) = (-1, space x^2 - 2) . $
  For a *constant* first slot the residue is $partial_D (a, g) = overline(a)^(v_D (g))$, so the
  first expression can only ramify along components of $"div"(3-x^2)$ and the second only along
  components of $"div"(x^2-2)$. These divisors share no component --- $x^2 = 3$ and $x^2 = 2$
  cannot hold at once. Every residue is therefore computed by an expression that is a unit there,
  and vanishes. Hence $cal(A) in "Br"(X)$.
]

Now the local invariants, place by place. Write $f(x) = (3-x^2)(x^2-2)$; a point of $X(QQ_v)$ over
a given $x$ exists exactly when $f(x)$ is a norm from $QQ_v (i)$, i.e. $(-1, f(x))_v = 1$.

#align(center, table(
  columns: 3, align: (left, left, center),
  stroke: 0.4pt + luma(170), inset: (x: 7pt, y: 4pt),
  table.header([place], [what the local points force], [$"inv"_v cal(A)$]),
  [$v = infinity$], [$f(x) >= 0$ forces $2 <= x^2 <= 3$, hence $3 - x^2 >= 0$], [$0$],
  [$p equiv 1 (4)$], [$-1$ is a square in $QQ_p$, so $(-1, dot)_p$ is trivial], [$0$],
  [$p equiv 3 (4)$], [$(-1,c)_p = (-1)^(v_p (c))$, and $v_p (3-x^2)$ is forced even], [$0$],
  [$p = 2$], [local points force $v_2 (x) >= 2$, hence $3 - x^2 equiv 3 (4)$], [$1 slash 2$],
))

#v(2mm)
The two non-obvious rows:

- *$p equiv 3$ mod $4$.* Solubility needs $v_p (3-x^2) equiv v_p (x^2-2)$ mod $2$. But
  $(3-x^2) + (x^2-2) = 1$. If $v_p (x) < 0$ both valuations equal $2 v_p (x)$, even. If
  $v_p (x) >= 0$ both terms lie in $ZZ_p$ and sum to a *unit*, so at least one of them is a unit;
  the congruence then forces both valuations even. Either way $v_p (3-x^2)$ is even.
- *$p = 2$.* Here $(-1,c)_2 = 1$ iff the unit part of $c$ is $equiv 1$ mod $4$. If $x$ is a
  $2$-adic unit then $x^2 equiv 1$ mod $8$, so $3 - x^2 = 2 dot (1 - 4k)$ has symbol $+1$ while
  $x^2 - 2$ has unit part $equiv 3$ mod $4$ and symbol $-1$: the product is $-1$ and there is no
  local point. The same cancellation rules out $v_2 (x) < 0$ and $v_2 (x) = 1$. What survives is
  $v_2 (x) >= 2$, and then $3 - x^2 equiv 3$ mod $4$, giving $"inv"_2 = 1 slash 2$.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  $ sum_v "inv"_v cal(A)(P_v) = 1/2 quad "for every" (P_v) in X(bold(A)_QQ) , $
  so $X(bold(A)_QQ)^"Br" = nothing$ while $X(bold(A)_QQ) eq.not nothing$. The surface has points
  everywhere locally and none globally, and the entire explanation is one unramifiedness argument
  plus four local symbol computations. @sec-gp confirms the table by sampling.
]

Note the shape: the obstruction sits at a *single* place, and it is the place where $cal(A)$'s
integral model is worst. That is the same shape as `integral-bm.typ` §4 and
`kummer-example-j0.typ` §6 --- and by @sec-goodred it is the only shape available.

== Unramified Brauer groups as a rationality obstruction <sec-artinmumford>

By @sec-places, $"Br"_"nr" (k(X) slash k) = "Br"(X)$ for $X$ smooth proper, so it is a birational
--- indeed a stable birational --- invariant, and it vanishes for projective space. Anything with
$"Br"_"nr" eq.not "Br"(k)$ is therefore not rational, and the residue map is how one computes it.

- *Artin--Mumford (1972).* Take a conic bundle over $PP^2$ degenerating over a plane curve $C$.
  The residue of the class of the generic conic along $C$ is a *quadratic character of $kappa(C)$*
  --- equivalently a double cover of $C$ --- and the codimension-two compatibility of
  @sec-geometry constrains that cover at the singular points of $C$. Choosing $C$ so that the
  forced double cover cannot exist produces a class in $"Br"_"nr"$, hence a unirational
  non-rational threefold. These were among the first such examples, and the invariant is nothing
  but ramification data.
- *Noether's problem.* For $G$ finite acting on $V$ over $k = overline(k)$ of characteristic $0$,
  Bogomolov's formula computes
  $ "Br"_"nr" (k(V)^G slash k) = inter.big_(A subset G "abelian, 2-generated")
    ker("res" : H^2 (G, QQ slash ZZ) --> H^2 (A, QQ slash ZZ)) , $
  the *Bogomolov multiplier*: a class is unramified exactly when it dies on every bicyclic
  subgroup, because those subgroups are what the divisorial valuations of $k(V)^G$ see. Saltman
  used this to produce groups for which $k(V)^G$ is not rational, answering Noether's question
  negatively. A purely group-theoretic computation, and it is a residue computation.

= Worked instances in this repository <sec-examples>

#align(center, table(
  columns: 3, align: (left, left, left),
  stroke: 0.4pt + luma(170), inset: (x: 7pt, y: 4pt),
  table.header([note], [the class], [the residue computation]),
  [`integral-bm.typ` §2],
    [$(2, x+4)$ on $x^2 - 34 y^2 = -1$],
    [$partial_Q (a, f) = overline(a)^(v_Q (f))$ for constant $a$; non-trivial at the deleted point
     $P_infinity$ (so the class is non-constant), trivial at the zeros of $x+4$ because
     $17(4^2+1) = 17^2$ makes the residue field $QQ(sqrt(2))$],
  [`kummer-survey.typ` ("It is unramified")],
    [$cal(A)_(i j) = (x - d e_i, space t - d e_j)$],
    [both slots have $2$-divisible divisors on $E_d times E_d$, so every tame symbol is trivial;
     the only work is at the sixteen exceptional curves of the Kummer resolution, where the
     residue is $overline(q(x) slash q(t))$],
  [`ec-density-bm.typ` §5],
    [$"cor"_(A(E) slash QQ(E)) (alpha, X - theta)$],
    [unramifiedness by the corestriction compatibility of @sec-reciprocity],
  [`csa-brauer.typ` §4],
    [$(a,b)$ over $QQ$],
    [residue $=$ Hilbert symbol; reciprocity $=$ quadratic reciprocity],
))

= What the companion script checks <sec-gp>

`residues.gp` evaluates the $n = 2$ tame symbol of @sec-tame-symbol in the two settings where it
can be checked against something independent. All counts are zero.

#v(1mm)
- *(1) The residue is the Hilbert symbol.* Over $QQ_p$ for odd $p$, the residue
  $(-1)^(alpha beta) u^beta w^(-alpha)$ is a square in $bb(F)_p$ exactly when $(a,b)_p = 1$ ---
  $43,200$ pairs over twelve primes. This is @sec-local made concrete: over a local field the
  residue *is* the invariant, and the sign $(-1)^(alpha beta)$ is exactly what accounts for the
  $(-1 slash p)^(alpha beta)$ in the classical formula.
- *(2) Steinberg.* Every residue of $(f, 1-f)$ over $QQ(t)$, at every closed point of $PP^1$ and
  at infinity, is trivial in $kappa(P)^times slash square$. The cancellation at infinity is not
  formal --- it is where the sign earns its keep.
- *(3) Residue reciprocity.* $product_P N_(kappa(P) slash QQ) (partial_P cal(A)) in (QQ^times)^2$
  for $120$ classes $(f,g)$ with $f, g$ rational functions of degree up to $3$. This is the last
  map of Faddeev's sequence (@sec-reciprocity) being zero, with $"cor" = N$ by
  `corestriction.typ` §2.
- *(4) Corestriction compatibility.* With $QQ(u) subset QQ(t)$ via $u = t^2$ --- a degree-$2$ cover
  of the $t$-line ramified at $0$ and $infinity$ --- and $cal(A) = (t - a, g(u))$, the projection
  formula gives $"cor"(cal(A)) = (a^2 - u, g)$. Comparing
  $partial_P "cor"(cal(A))$ with $sum_(w | P) "cor"_(kappa(w) slash kappa(P)) partial_w (cal(A))$
  at $330$ rational points $P$ and at infinity: equal every time. This is the identity that makes
  "corestriction preserves unramified" true.
- *(5) $2$-divisible divisors.* Every residue of $(f^2, g)$ vanishes, at every closed point ---
  the mechanism of @sec-ramdiv, and the reason descent functions give unramified algebras.
- *(6) Iskovskikh (@sec-isk).* For each place $v$, the $x in QQ_v$ admitting a local point are
  sampled over $x = a slash b$ with $|a|, b <= 40$ --- which realises every $2$-adic valuation from
  $-5$ to $5$ and every unit class mod $32$ --- and the achieved value of
  $"inv"_v (-1, 3-x^2)$ recorded. At every one of the twelve places the achievable set is a
  *single* value: $1 slash 2$ at $p = 2$, zero everywhere else, and the surface is locally soluble
  at all of them. Sum $= 1 slash 2$, obstruction confirmed. The sampling also confirms the two
  non-obvious steps of the hand proof: every soluble $x$ at $p = 2$ has $v_2 (x) >= 2$, and
  $3 - x^2$ is then a unit $equiv 3$ mod $4$. Being a sample this is evidence rather than proof;
  the proof is the table in @sec-isk.
- *(7) Faddeev backwards (@sec-build).* For all $216$ triples of targets from a six-element list
  and three rational points, $product_i (c_i, t - alpha_i)$ has residue $c_j$ at $alpha_j$ ---
  $648$ residues, all correct --- and is unramified at infinity if and only if $product_i c_i$ is
  a square. Both halves of the reciprocity condition, in both directions.
- *(8) Unramified $<==>$ constant (@sec-computable).* For $64$ classes $(f, c)$ over $QQ(t)$,
  twisted by the constant $(-1,-1)$ so that "constant" is not "trivial": the residue test says
  unramified for $12$ of them, and those are exactly the $12$ whose specialisations
  $cal(A)(t_0)$, $t_0 = -12 dots 12$, all have the *same* ramification set in $"Br"(QQ)$. The
  other $52$ all vary. This is Faddeev exactness on the left, tested rather than quoted.

#v(1mm)
Each of the first five was also run against deliberately corrupted symbols --- the sign dropped, the two
exponents transposed --- and each then reports failures, so none of them is passing vacuously; checks (7)
and (8) are self-discriminating, each reporting both a positive and a negative population.

= References <sec-refs>

#block(inset: (left: 4pt))[
#set enum(numbering: "[1]")
+ P. Gille, T. Szamuely, *Central Simple Algebras and Galois Cohomology*, 2nd ed., CUP 2017.
  *Chapter 6 is the reference for this note*: §6.3--6.4 construct $partial_v$ and prove Faddeev's
  sequence, §6.8--6.9 give residue maps in general and the tame symbol, and §7.1--7.5 place them
  in Milnor $K$-theory. Start here.
+ J.-L. Colliot-Thélène, A. N. Skorobogatov, *The Brauer--Grothendieck Group*, Ergebnisse 71,
  Springer 2021. The modern account. Ch. 1 (Azumaya vs. cohomological Brauer group), *Ch. 3
  (residues, purity, the Gersten complex)*, Ch. 6 (Brauer groups of schemes over local and global
  fields). Freely available on the authors' pages.
+ B. Poonen, *Rational Points on Varieties*, GSM 186, AMS 2017. §6.6--6.9: the residue map with the
  minimum of machinery, $"Br"$ of curves and of $PP^1$, and the residue sequence stated exactly as
  it is used in the Brauer--Manin literature.
+ J.-L. Colliot-Thélène, *Birational invariants, purity and the Gersten conjecture*, in $K$-theory
  and Algebraic Geometry (Santa Barbara 1992), Proc. Sympos. Pure Math. *58.1* (1995), 1--64.
  *The reference for $"Br"_"nr"$ and @sec-places*: unramified cohomology, why divisorial
  valuations suffice, birational invariance.
+ A. Grothendieck, *Le groupe de Brauer I, II, III*, in Dix exposés sur la cohomologie des schémas,
  North-Holland 1968. Where $"Br"(X) = H^2 (X, GG_m)_"tors"$, purity in low dimension, and the
  residue sequence are set up. III §6 is the purity discussion.
+ M. Auslander, O. Goldman, *The Brauer group of a commutative ring*, Trans. AMS *97* (1960),
  367--409. Injectivity of $"Br"(R) --> "Br"(K)$ for $R$ regular, and $"Br"(R) = inter.big_("ht" frak(p) = 1) "Br"(R_frak(p))$ in dimension $<= 2$.
+ K. Fujiwara, *A proof of the absolute purity conjecture (after Gabber)*, Adv. Stud. Pure Math.
  *36* (2002), 153--183. Absolute purity, i.e. the isomorphism used in @sec-gysin.
+ K. Česnavičius, #link("https://arxiv.org/abs/1711.06456")[*Purity for the Brauer group*],
  Duke Math. J. *168* (2019), 1461--1486. Purity including the $p$-part; settles the general
  statement quoted in @sec-geometry.
+ M. Artin, D. Mumford, *Some elementary examples of unirational varieties which are not rational*,
  Proc. LMS *25* (1972), 75--95. Residues in action: the ramification data of a class on a surface
  as a curve plus a double cover, and the first use of $"Br"_"nr"$ as a rationality obstruction.
+ D. Saltman, *Lectures on Division Algebras*, CBMS Regional Conf. Ser. *94*, AMS 1999.
  Ch. 10--11: ramification of division algebras over function fields, done concretely and with the
  division-algebra picture kept in view throughout.
+ J. Milnor, *Algebraic $K$-theory and quadratic forms*, Invent. Math. *9* (1970), 318--344. §2:
  the tame symbol on $K_2$, which is the formula of @sec-tame-symbol.
+ S. Bloch, A. Ogus, *Gersten's conjecture and the homology of schemes*, Ann. Sci. ÉNS *7* (1974),
  181--201. The complex of @sec-geometry, in its natural generality.
+ K. Kato, *Swan conductors for characters of degree one in the imperfect residue field case*,
  Contemp. Math. *83* (1989), 101--131; and *A generalization of local class field theory using
  $K$-groups II*, J. Fac. Sci. Univ. Tokyo *27* (1980), 603--683. The wild theory of @sec-wild.
+ J.-P. Serre, *Local Fields*, GTM 67, Ch. XII--XIII, and *Corps Locaux* / Cassels--Fröhlich
  Ch. VI. The complete-field case with the division-algebra proof rather than the spectral
  sequence --- the source of @sec-local.
]

= Where this connects in the repository <sec-used>

#align(center, table(
  columns: 2, align: (left, left),
  stroke: 0.4pt + luma(170), inset: (x: 7pt, y: 4pt),
  table.header([note], [relation to this one]),
  [`csa-brauer.typ`], [the algebras themselves: quaternion and cyclic algebras, $"inv"_v$,
    the two global theorems. Read that first; this note is its codimension-one refinement],
  [`corestriction.typ`], [the transfer used in @sec-reciprocity, and the proof that
    $"inv" compose "cor" = "inv"$],
  [`local-duality.typ`], [the complete-field case done by valuing the division algebra, which is
    @sec-inertia without spectral sequences],
  [`wild-symbols.typ`], [what breaks when $p = "char" kappa(v)$ (@sec-wild)],
  [`integral-bm.typ`], [residues on $PP^1_QQ$ used to build a non-constant class on an affine
    conic --- @sec-build is the general recipe behind that choice],
  [`kummer-padic-density.typ`], [@sec-goodred: only bad places contribute to
    $sum_v "inv"_v$, which is what makes the Brauer--Manin sums finite],
  [`kummer-survey.typ`], [$2$-divisible divisors $==>$ trivial tame symbols $==>$ unramified
    descent algebras (@sec-ramdiv)],
  [`ec-density-bm.typ`], [corestriction preserves unramifiedness],
))
