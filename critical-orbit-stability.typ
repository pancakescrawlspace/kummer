#set page(paper: "a4", margin: (x: 2.0cm, y: 2.2cm), numbering: "1")
#set text(font: "New Computer Modern", size: 10.5pt)
#set par(justify: true)
#set heading(numbering: "1.")
#show link: set text(fill: blue.darken(20%))
#let wreath = math.op(sym.wreath)
#show raw.where(block: true): it => block(
  fill: luma(247), inset: 8pt, radius: 3pt, width: 100%, breakable: true,
  text(size: 8pt, it),
)

#align(center)[
  #text(size: 16pt, weight: "bold")[The critical orbit decides]
  #v(2mm)
  #text(size: 10pt)[Where the $delta_i$ and $delta'_i$ came from, and the general theorem
  they are an instance of]
  #v(1mm)
  #text(size: 9pt, style: "italic")[a question of René Pannekoek's
  (#link("https://math.stackexchange.com/questions/5010063/is-every-element-of-this-sequence-of-polynomials-irreducible")[Mathematics Stack Exchange 5010063], answered there by
  himself); checks in `critical-orbit-stability.gp`]
]

#v(4mm)

#block(fill: luma(240), inset: 9pt, radius: 3pt, width: 100%)[
  *The pattern is real and it has a name.* The polynomials $f_1 = X$,
  $f_(n+1) = 1 + product_(i <= n) f_i$ satisfy $f_n = g^(circle.small (n-2))(X + 1)$ for
  $g = X^2 - X + 1$, and the question is whether every iterate of $g$ is irreducible. A polynomial
  all of whose iterates are irreducible is called *stable*, and stability of a quadratic is decided,
  once and for all, by a single sequence: the forward orbit
  $c_n = g^(circle.small n)(gamma)$ of its *critical point* $gamma$ (@sec-thm). That is the general
  phenomenon (@sec-general): it is the arithmetic shadow of the fact that a covering
  $g^(circle.small n) : bb(P)^1 -> bb(P)^1$ ramifies over the post-critical set, and it is visible
  as the exact statement $"disc"(g^(circle.small n)) = D_n$ modulo squares (@sec-why).

  #v(2mm)
  Three lemmas do all the work (@sec-lemmas), of which the load-bearing one is a single
  factorisation, $g(C) - g(Y) = (C - Y)(C - overline(Y))$, giving
  $N_(K_i slash K_(i-1))(c - alpha_i) = g(c) - alpha_(i-1)$: *one norm step moves the base point
  one step along the critical orbit and drops one floor of the tower.* That identity is what
  "the conclusion travels upwards" means.

  #v(2mm)
  The posted answer's $delta_i = 2 + 4 alpha_i$ and $delta'_i = 3 + 4 alpha_i$ are, modulo squares,
  $alpha_i - c_1$ and $alpha_i - c_2$ (@sec-deltas). They are *one* family indexed by the two
  points of the critical cycle; there are two of them because mod $5$ the critical point of $g$ is
  periodic of *period two*, and their alternation is that cycle turning. And the whole proof
  collapses to one line: mod $5$ the critical cycle is ${2, 3}$, which *is* the set of non-squares
  mod $5$. @sec-rewrite is the answer rewritten that way. $p = 5$ is the only prime below $10^9$ for which
  the argument runs at all (@sec-only), and the cycle length at a working prime is forced to be
  even.
]

= What the question is <sec-question>

With $f_1 = X$ and $f_(n+1) = 1 + product_(i = 1)^n f_i$, one has for $n >= 2$
$ f_(n+1) = 1 + f_n product_(i <= n-1) f_i = 1 + f_n (f_n - 1) = f_n^2 - f_n + 1 , $
so with $g = X^2 - X + 1$ and $f_2 = X + 1$,
$ f_n = g^(circle.small (n-2)) (X + 1), wide deg f_n = 2^(n-2) . $
Irreducibility of $f_n$ over $QQ$ is irreducibility of $g^(circle.small (n-2))$, after the harmless
translation $X mapsto X + 1$. Check 8 confirms both recursions agree and that
$f_n = g^(circle.small (n-2))(X+1)$ for $n <= 15$.

Everything below is over a field of characteristic $eq.not 2$. Write a monic quadratic in the form
that makes its critical point visible,
$ g(Y) = (Y - gamma)^2 + beta, wide gamma = -a slash 2 " for " g = Y^2 + a Y + b, wide
  beta = g(gamma) , $
and let
$ c_n = g^(circle.small n)(gamma), wide n >= 1 $
be the forward orbit of the critical point, so $c_1 = beta$ is the critical value. For $g =
X^2 - X + 1$ we have $gamma = 1 slash 2$ and $beta = 3 slash 4$.

= Three lemmas <sec-lemmas>

*Lemma 1 (the Kummer step).* _Let $L$ be a field of characteristic $eq.not 2$ and $z in L$. Then
$g(Y) - z$ has a root in $L$ if and only if $z - beta$ is a square in $L$; otherwise it is
irreducible and its root generates $L(sqrt(z - beta))$._

This is immediate from $g(Y) - z = (Y - gamma)^2 - (z - beta)$: completing the square is nothing but
naming the critical point. Note where the critical value enters --- at the very first step, before
any iteration.

#v(2mm)
*Lemma 2 (the norm step).* _Let $g(alpha) = z$ with $alpha$ of degree $2$ over $L in.rev z$, and let
$overline(alpha)$ be its conjugate. Then for every $c in L$_
$ N_(L(alpha) slash L)(c - alpha) = g(c) - z . $

_Proof._ As polynomials in a new variable $C$, both $g(C) - g(alpha)$ and
$(C - alpha)(C - overline(alpha))$ are monic quadratics with the same two roots $alpha,
overline(alpha)$; hence they are equal. Substitute $C = c$. $qed$

That is the whole mechanism, and it deserves to be read slowly. Norming *down* one floor of the
tower replaces the base point $c$ by $g(c)$ --- it moves one step *along the orbit of $g$*. So a
condition stated at height $i$ in the tower, about an element $c - alpha_i$, becomes the same
condition at height $i-1$ about $g(c) - alpha_(i-1)$: the *shape* of the condition is preserved and
only the base point moves. Iterate it and the base point walks the orbit. If one starts at the
critical value $c = c_1$, the walk is the critical orbit.

Telescoping is the same as evaluating the minimal polynomial: if $alpha_i$ has minimal polynomial
$g^(circle.small (i-1)) - b$ over the ground field $F$, then
$ N_(K_i slash F)(c - alpha_i) = product_"conj" (c - dot.c) = g^(circle.small (i-1))(c) - b , $
which at $c = c_1$ is $c_i - b$. The one-step form is the mechanism; this is its closed form.

#v(2mm)
*Lemma 3 (finite fields).* _Let $q$ be odd and $d >= 1$. Then $x in FF_(q^d)^times$ is a square in
$FF_(q^d)$ if and only if $N_(FF_(q^d) slash FF_q)(x)$ is a square in $FF_q$._

_Proof._ $N(x) = x^((q^d - 1) slash (q - 1))$, so
$N(x)^((q-1) slash 2) = x^((q^d - 1) slash 2)$. $qed$

The posted answer uses this for $d = 2$ only, and pays for it: the descent then has to be taken two
floors at a time, which is exactly what forces two families $delta$, $delta'$ and two base cases.
Lemma 3 holds in *every* degree and descends all the way to $FF_q$ in one move. Check 3 verifies it
exhaustively for $q in {3,5,7}$ and $d <= 4$.

The structural reason is worth stating, because it is what makes the tower tractable at all: for
every finite field $F$ of odd characteristic
$ F^times slash (F^times)^2 tilde.equiv ZZ slash 2 , $
one bit, on *every* floor of the tower --- and the norm, which is corestriction on
$H^1(dot, mu_2)$, is an isomorphism between consecutive floors. So the obstruction group does not
grow as one climbs; it is the same $ZZ slash 2$ throughout, canonically identified with the ground
floor's. (See `corestriction.typ` in this repository for corestriction in degree $1$ being the
norm.) The map induced on that $ZZ slash 2$ by going up one floor is, by Lemma 2, the dynamics of
$g$. *An infinite tower of conditions is thereby pushed down onto the forward orbit of one point.*

= The criterion <sec-thm>

*Theorem.* _Let $q$ be odd, $g$ a monic quadratic over $FF_q$ with critical point $gamma$ and
critical orbit $c_n = g^(circle.small n)(gamma)$, and let $b in FF_q$ be a base point. Put_
$ D_1 = b - c_1, wide D_n = c_n - b " for " n >= 2 . $
_Then $g^(circle.small n) - b$ is irreducible over $FF_q$ if and only if $D_1, ..., D_n$ are all
non-squares in $FF_q$. In particular $g$ is stable with base point $b$ if and only if the whole
adjusted critical orbit $(D_n)_(n >= 1)$ avoids the squares._

_Proof._ Set $alpha_1 = b$ and choose $alpha_i$ with $g(alpha_i) = alpha_(i-1)$; put
$K_i = FF_q (alpha_i)$. By induction, suppose $[K_j : K_(j-1)] = 2$ for $j <= i$, so that
$[K_i : FF_q] = 2^(i-1)$ and the minimal polynomial of $alpha_i$ is $g^(circle.small (i-1)) - b$
(a monic polynomial of the right degree vanishing at $alpha_i$). By Lemma 1,
$ [K_(i+1) : K_i] = 2 quad <==> quad alpha_i - beta " is a non-square in " K_i , $
by Lemma 3 this happens iff $N_(K_i slash FF_q)(alpha_i - beta)$ is a non-square in $FF_q$, and by
Lemma 2 telescoped
$ N_(K_i slash FF_q)(alpha_i - beta) = (-1)^(2^(i-1)) (c_i - b) = cases(
  b - c_1 & i = 1, c_i - b quad & i >= 2, ) = D_i . $
The sign appears only at $i = 1$, where the number of conjugates $2^(i-1) = 1$ is odd. Since
$g^(circle.small n) - b$ is irreducible exactly when the tower is quadratic all the way to $K_(n+1)$,
the theorem follows. $qed$

This is the criterion of Ayad--McQuillan [1], in the form Stoll [2] uses over $QQ$; see @sec-general.
Check 4 verifies it against honest factorisation for $g$ at $45$ primes and for $96$ random triples
(prime, monic quadratic, base point), with no mismatch.

#v(2mm)
Two remarks on why the finite-field case is so much better behaved than a general field.

- *There is only one quadratic extension in each degree.* The tower $K_1 subset K_2 subset dots.c$
  has no choices in it; "the extension is non-trivial" is a single bit, and Lemma 3 says the norm
  reads that bit correctly at any height. Over $QQ$ the group $QQ^times slash (QQ^times)^2$ is
  infinite, the norm is far from injective, and only one direction survives (@sec-char0).
- *The critical orbit is automatically finite.* $gamma$ lands in the finite set $FF_q$, so its
  forward orbit is eventually periodic: a tail followed by a cycle. The infinite list of conditions
  $D_1, D_2, ...$ has only finitely many distinct entries. *The check is finite.*

= The original question, in six lines <sec-answer>

Take $q = 5$, $g = X^2 - X + 1$, $b = 0$.

#v(1mm)
+ $gamma = 1 slash 2 = 3$ and $beta = c_1 = g(3) = 2$.
+ $c_2 = g(2) = 3$, $c_3 = g(3) = 2$: the critical point is *periodic of period $2$*, with cycle
  ${2, 3}$.
+ The squares mod $5$ are ${0, 1, 4}$, so the non-squares are exactly ${2, 3}$ --- *the critical
  cycle is the set of non-squares.*
+ $-1 = 4$ is a square mod $5$, so $D_1 = -c_1 = 3$ and $D_n = c_n in {2,3}$ for $n >= 2$: every
  $D_n$ is a non-square.
+ By the theorem, every $g^(circle.small n)$ is irreducible over $FF_5$.
+ The $f_n$ are monic in $ZZ[X]$, so every $f_n$ is irreducible over $QQ$. $qed$

#v(2mm)
The slogan: *mod $5$ the critical point of $g$ is periodic of period two, and its cycle is exactly
the set of non-squares.* Check 1 walks the tower floor by floor up to $[K_9 : FF_5] = 256$,
verifying at each floor that Lemma 1's obstruction is a non-square, that $g(Y) - alpha_i$ really is
irreducible, and that the norm is the predicted $c_i$.

#align(center, table(
  columns: 6, align: (center, center, center, center, center, left),
  stroke: 0.4pt + luma(170), inset: (x: 8pt, y: 4pt),
  table.header([$i$], [$[K_i : FF_5]$], [$N(alpha_i - beta)$], [predicted], [square?],
               [step $K_i -> K_(i+1)$]),
  [$1$], [$1$],   [$3$], [$-c_1 = 3$], [no], [degree $2$],
  [$2$], [$2$],   [$3$], [$c_2 = 3$],  [no], [degree $2$],
  [$3$], [$4$],   [$2$], [$c_3 = 2$],  [no], [degree $2$],
  [$4$], [$8$],   [$3$], [$c_4 = 3$],  [no], [degree $2$],
  [$dots.v$], [$dots.v$], [$dots.v$], [$dots.v$], [$dots.v$], [$dots.v$],
))

= What $delta_i$ and $delta'_i$ were <sec-deltas>

The posted answer works with the discriminant of $Y^2 - Y + 1 - alpha_(i)$, namely
$delta_i = 2 + 4 alpha_i$, and with its norm $delta'_(i-1) = 3 + 4 alpha_(i-1)$. In $FF_5$,
$4 = 2^2$ is a square and $4^(-1) = 4$, so modulo squares
$ delta_i = 4(alpha_i - 2) = 4 (alpha_i - c_1), wide
  delta'_i = 4(alpha_i - 3) = 4 (alpha_i - c_2) . $
So there are not two families. There is *one* family, $alpha_i - c$, with $c$ running over the
points of the critical cycle; and the reason it has two members is that the cycle has length two.
Check 7 verifies both identifications up to $[K_8 : FF_5] = 128$, and verifies that the answer's
step $delta_(i) mapsto delta'_(i-1)$ is Lemma 2 applied with $c = c_1$, followed by
$c_1 mapsto c_2$.

Three features of the original write-up are now accounted for, and all three disappear:

#v(1mm)
- *The alternation $delta -> delta' -> delta$* is the critical cycle turning under $g$. At a prime
  whose critical orbit had a tail of length $t$ and a cycle of length $ell$, one would have found
  $t + ell$ families, not two, and the answer's inductive bookkeeping would have had to carry them
  all.
- *The two base cases $delta_2$, $delta'_2$* are an artifact of descending two floors at a time,
  which is forced by using Lemma 3 only in degree $2$. With Lemma 3 in full strength there is no
  base case: the condition at height $i$ is $D_i$, computed by a single norm, uniformly in $i$.
- *The "easy exercise in finite field theory"* left unproved in the answer is Lemma 3, and its
  one-line proof is above.

Nothing in the original argument was wrong; it was carrying the general theorem in disguise, one
prime and one cycle at a time.

= Why the critical orbit, and not some other sequence <sec-why>

Because the $D_n$ *are* the discriminants.

#v(2mm)
*Proposition.* _Modulo squares, $"disc"(g^(circle.small n) - b) = D_n$._

_Proof._ Write $P = g^(circle.small n) - b$, $d = 2^n$, so
$"disc"(P) = (-1)^(d(d-1) slash 2) "Res"(P, P')$. By the chain rule
$P' = product_(j=0)^(n-1) g'(g^(circle.small j))$ and $g' = 2(X - gamma)$, whence
$ "Res"(P, P') = product_(P(alpha) = 0) thin product_(j=0)^(n-1) 2 (g^(circle.small j)(alpha) - gamma) . $
Fix $j >= 1$. As $alpha$ runs over the $2^n$ roots of $P$, the value $g^(circle.small j)(alpha)$
runs over the $2^(n-j)$ roots of $g^(circle.small (n-j)) - b$, each attained $2^j$ times; so that
factor is a $2^j$-th power, hence a square. The factor $2^(2^n)$ is a square. Only $j = 0$ survives:
$ product_(P(alpha) = 0) (alpha - gamma) = (-1)^d P(gamma) = P(gamma) = c_n - b , $
$d$ being even. Finally $d(d-1) slash 2 = 2^(n-1)(2^n - 1)$ is odd exactly for $n = 1$, which
contributes the sign of $D_1 = b - c_1$ and nothing else. $qed$

So the sign twist on the first term of the adjusted critical orbit --- the one ugly feature of the
statement --- is precisely the $(-1)^(d(d-1) slash 2)$ in the definition of the discriminant.
Check 5 verifies the proposition at $210$ pairs $(p, n)$, with no mismatch.

This also says what kind of fact the criterion is. The ramification of the covering
$g^(circle.small n) : bb(P)^1 -> bb(P)^1$ lies over the *post-critical set*
${c_1, c_2, c_3, dots}$; discriminants are the arithmetic shadow of that ramification; and over a
finite field, where a quadratic extension is determined by one bit of square-class data, the shadow
carries all the information there is. Over a general field the discriminant only distinguishes
$A_(2^n)$ from $S_(2^n)$ and says nothing about irreducibility --- which is exactly the gap in
@sec-char0.

= The general phenomenon <sec-general>

The name is *stability*: $g$ is stable over $K$ if every iterate $g^(circle.small n)$ is irreducible
over $K$. The setting in which the pattern is the natural one is the following.

#v(2mm)
*The pre-image tree.* The roots of $g^(circle.small n) - b$ are the level-$n$ vertices of the tree
$T$ of iterated pre-images of $b$, each vertex of level $n$ joined to its image at level $n-1$. For
$g$ quadratic and the tree complete, $T_n$ is the complete binary rooted tree of depth $n$ and
$ "Aut"(T_n) = (ZZ slash 2) wreath dots.c wreath (ZZ slash 2) quad (n " times"), wide
  abs("Aut"(T_n)) = 2^(2^n - 1) . $
The absolute Galois group acts, giving the *arboreal Galois representation*
$rho : G_K -> "Aut"(T_infinity) = limits(lim)_(<--) "Aut"(T_n)$, the arboreal analogue of the
$ell$-adic representation attached to a Galois module. Irreducibility of $g^(circle.small n) - b$ is
exactly *transitivity of the image on level $n$*; stability is transitivity on every level.

The tower $K_1 subset K_2 subset dots.c$ of the posted answer is a single *path* in this tree ---
one point of its boundary --- and $[K_i : K_(i-1)] = 2$ says the path keeps branching. By
transitivity, one path is as good as all of them, which is why following a single $alpha_i$ suffices.

#v(2mm)
*What the critical orbit governs.* Odoni [3] set up the Galois theory of iterates; Stoll [2] gave
the critical-orbit criterion over $QQ$; Ayad--McQuillan [1] proved the finite-field statement in the
form of @sec-thm; Jones [4] is the survey. The recurring theorem is that *stability, the crudest
piece of arboreal data, is controlled by the post-critical orbit alone*, while the finer questions
--- how large is the image of $rho$ in $"Aut"(T_infinity)$, does it have finite index (Odoni's
problem) --- need the finer geometry of the same post-critical set. Post-critically finite maps are
exactly those for which this data is finite, and they are exactly the maps whose arboreal images are
*small*: PCF is the source of both the tractability here and the failure of surjectivity in general.

#v(2mm)
*Where the finiteness comes from.* Over $FF_q$ every point is pre-periodic, so every quadratic is
post-critically finite and @sec-thm is a finite check. That is the real content of "the conclusion
travels upwards": the level-$i$ obstruction lives in a group of order $2$ that is the same on every
floor, the norm identifies the floors, and the identification transports the obstruction by applying
$g$. A tower of conditions becomes an orbit, and an orbit in a finite set closes up.

= Characteristic zero, and the recipe <sec-char0>

Over a number field only one direction of Lemma 3 survives: if $N(x)$ is a non-square then $x$ is a
non-square, but not conversely. So the criterion becomes *sufficient only*.

#v(2mm)
*Theorem (Stoll).* _Let $g$ be a monic quadratic over $QQ$ with critical point $gamma$ and base
point $b$. If $b - c_1$ and $c_n - b$ $(n >= 2)$ are all non-squares in $QQ$, then every
$g^(circle.small n) - b$ is irreducible over $QQ$._

The classical instance is $g = X^2 + 1$, $b = 0$, whose adjusted critical orbit
$-1, 2, 5, 26, 677, 458330, dots$ never meets a square. Check 9 runs the test for $X^2 + c$,
$-12 <= c <= 30$, against honest factorisation over $QQ$ up to the sixth iterate: the test never
lies, and it is never sharp either.

#v(2mm)
The recipe the original problem is an instance of, and the one worth remembering:

#block(inset: (left: 6pt))[
  To prove that all iterates of a monic quadratic $g in ZZ[X]$ are irreducible over $QQ$:
  #v(1mm)
  + Compute the critical point $gamma = -a slash 2$ and the base point $b$.
  + For each small odd prime $p$ of good reduction, iterate $gamma$ in $FF_p$ until it repeats. The
    orbit is a tail plus a cycle; there are finitely many distinct values.
  + Test whether $b - c_1$ and all the $c_n - b$, $n >= 2$, are non-squares mod $p$. *This is a
    finite test.*
  + If some $p$ passes, every iterate is irreducible mod $p$, hence over $QQ$, for every $n$ at once.
]

#v(2mm)
The test is finite for each $p$ but rarely passes, because the orbit has length of order $sqrt(p)$
and each of its values must independently land among the non-squares. Heuristically $p$ succeeds
with probability about $2^(-sqrt(p))$, so the small primes are the only realistic candidates, and
one expects only finitely many successes ever. For $g = X^2 - X + 1$ this is borne out sharply:
check 6 scans the primes below $20000$ and finds *exactly one* success, $p = 5$, whose orbit
${2, 3}$ is the shortest an orbit can be and lands on the non-squares exactly. The choice of $5$ in
the posted answer is not a convenience --- and @sec-only pushes this much further, to $10^9$, with
two structural constraints proved along the way.

= Is $5$ the only prime? <sec-only>

The question splits, but only apparently. Because @sec-thm is an *if and only if*, "the argument
runs at $p$" and "the iterates stay irreducible mod $p$" are the *same* statement: there is no
prime that secretly works and no prime at which the method is merely too weak. So the failure of
the criterion at $p$ is a proof that some $g^(circle.small n)$ *is* reducible mod $p$, and one can
say exactly which. Writing $N(p)$ for the first $n$ with $D_n$ a square, check 13 confirms $N(p)$
against honest factorisation and confirms that reducibility persists past it --- as it must, since
$g^(circle.small m) = g^(circle.small N) circle.small g^(circle.small (m - N))$ pulls a
factorisation back.

#align(center, table(
  columns: 9, align: (left, center, center, center, center, center, center, center, center),
  stroke: 0.4pt + luma(170), inset: (x: 7pt, y: 4pt),
  table.header([$p$], [$7$], [$11$], [$17$], [$23$], [$29$], [$41$], [$47$], [$59$]),
  [first reducible $f_m$], [$f_3$], [$f_6$], [$f_4$], [$f_4$], [$f_4$], [$f_6$], [$f_10$], [$f_6$]),
)

#v(2mm)
So $p = 47$ carries eight levels --- $f_2, dots, f_9$ are irreducible mod $47$ --- and then dies.
Below $2 dot 10^5$ the record is $p = 139703$, good for sixteen: $f_2, dots, f_17$ irreducible,
$f_18$ not.

== Two things one can prove <sec-proved>

Both come from a single identity. From $c_(n+1) = c_n^2 - c_n + 1$,
$ c_(n+1) - 1 = c_n (c_n - 1) , wide "hence" wide
  chi(c_(n+1) - 1) = chi(c_n) dot chi(c_n - 1) $
for the quadratic character $chi$ mod $p$. *The sign of $c_n - 1$ flips exactly when $c_n$ is a
non-residue.*

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Proposition 1.* _If the argument runs at $p$, the critical orbit's cycle length mod $p$ is
  even._

  #v(1.5mm)
  _Proof._ Every $c_n$ is a non-residue, so $chi(c_n - 1)$ alternates. Going once round a cycle of
  length $L$ returns to the starting value, so $(-1)^L = 1$. $qed$
]

#v(2mm)
Equivalently: iterating $c_(n+k) - 1 = (c_n - 1) product_(j=n)^(n+k-1) c_j$ round a full cycle and
cancelling $c_n - 1 eq.not 0$ gives $product_"cycle" c_j = 1$, so an all-non-residue cycle has
evenly many terms. Check 10 verifies the product identity at $2260$ primes without exception, and
finds $26$ cycles consisting entirely of non-residues --- every one of even length.

#v(2mm)
The shortest admissible cycle can then be classified outright. Solving $g(a) = b$, $g(b) = a$ with
$a eq.not b$ gives $(a - b)(a + b - 1) = -(a - b)$, so $b = -a$, and then $a^2 = -1$.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Proposition 2.* _The only $2$-cycle of $g$ mod $p$ is ${i, -i}$ with $i^2 = -1$; it exists iff
  $p equiv 1 (mod 4)$, and both members are non-residues iff $p equiv 5 (mod 8)$. Since
  $chi(-3) = -1$ iff $p equiv 2 (mod 3)$, a prime running the argument on a $2$-cycle satisfies_
  $ p equiv 5 (mod 24) . $
]

#v(2mm)
The condition $p equiv 2 (mod 3)$ is not an extra hypothesis: it is exactly the statement that
$g = Phi_6$ is irreducible mod $p$, i.e. that the tower gets off the ground at all. And $5$ is the
smallest prime $equiv 5 (mod 24)$, at which the critical point lands in the cycle *immediately* ---
tail length $0$, the shortest orbit that exists. Check 11 verifies the classification at all primes
below $500$ and the residue conditions below $20000$.

== Density zero <sec-density>

Write $c_n = t_n slash 2^(2^n)$. The denominator is a square for every $n >= 1$, so *modulo squares
the conditions are about integers*:
$ D_1 equiv -3, wide D_n equiv t_n quad (n >= 2), wide
  t_1, t_2, t_3, dots = 3, 13, 217, 57073, 3811958497, dots $
with $t_(n+1) = t_n^2 - 2^(2^n) t_n + 2^(2^(n+1))$. Each condition $chi_p (t_n) = -1$ is therefore a
*congruence condition* on $p$, by quadratic reciprocity.

Check 12 verifies that $-3, t_2, dots, t_7$ are independent modulo squares --- their squarefree
kernels $-3$, $13$, $7 dot 31$, $57073$, $dots$ have disjoint prime supports, and the exponent
matrix over $bb(F)_2$ has full rank $7$. So $QQ(sqrt(-3), sqrt(t_2), dots, sqrt(t_k))$ has degree
$2^k$, and Chebotarev gives:

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Proposition 3.* _The primes surviving $k$ levels have density exactly $2^(-k)$. Hence the primes
  at which the argument runs have density $0$._
]

== What is not decided <sec-open>

Whether $5$ is the only such prime, full stop. Check 13 runs the scan to $10^9$ --- $50.8$ million
primes, with early abort, since surviving $k$ levels has probability about $2^(-k)$ and the average
cost per prime is therefore $O(1)$ --- and finds nothing else. The longest any other prime survives
is $27$ levels, at $p = 443762873$; since $log_2 (5.08 dot 10^7) approx 25.6$, that is exactly what
the random model predicts, and there is no near miss anywhere in the range.

The heuristic is overwhelming. A prime succeeds only by surviving its entire orbit, of length
$ell(p)$ typically of order $sqrt(p)$, at probability about $2^(-ell(p))$; and
$sum_p 2^(-sqrt(p))$ contributes essentially nothing past $5$. But converting that into a proof
needs a lower bound on the orbit length at *every* prime, which is out of reach --- the same
obstruction that prevents anyone proving that only finitely many Fermat numbers are prime. So:

#block(fill: rgb("#fff4e6"), inset: 9pt, radius: 3pt, width: 100%)[
  For any *fixed* prime the question is settled by a finite computation, and no prime can secretly
  work. Below $10^9$, $p = 5$ is the only one, and at every other prime the $f_i$ genuinely do
  become reducible --- the method is not at fault. That $5$ is the only such prime is true beyond
  reasonable doubt and is not a theorem.
]

= The answer, rewritten <sec-rewrite>

#block(fill: luma(247), inset: 9pt, radius: 3pt, width: 100%)[
As noted in the comments, one may define the $f_n$ by $f_1 = X$, $f_2 = X + 1$ and
$f_n = f_(n-1)^2 - f_(n-1) + 1$, so that with $g = X^2 - X + 1$
$ f_n = g^(circle.small (n-2))(X + 1) . $
Since the $f_n$ are monic in $ZZ[X]$, it is enough to prove that every iterate
$g^(circle.small n)$ is irreducible *modulo $5$*.

#v(2mm)
Write $g$ so that its critical point is visible:
$ g(Y) = (Y - 1 slash 2)^2 + 3 slash 4, wide gamma = 1 slash 2 = 3, wide
  beta = g(gamma) = 3 slash 4 = 2 quad "in " FF_5 . $
Let $c_n = g^(circle.small n)(gamma)$ be the forward orbit of the critical point. Mod $5$:
$ c_1 = 2, quad c_2 = 3, quad c_3 = 2, quad c_4 = 3, quad dots $
--- the critical point is periodic of period $2$, with cycle ${2, 3}$. *The squares mod $5$ are
${0,1,4}$, so ${2,3}$ is exactly the set of non-squares.* That is the entire content of the proof;
the rest is bookkeeping.

#v(2mm)
Take $overline(FF)_5$, set $alpha_1 = 0$, and choose $alpha_i$ with $g(alpha_i) = alpha_(i-1)$;
let $K_i = FF_5 (alpha_i)$, so $alpha_i$ is a root of $g^(circle.small (i-1))$. We show
$[K_i : K_(i-1)] = 2$ for all $i$, which is the assertion.

*Step 1.* Since $g(Y) - alpha_i = (Y - gamma)^2 - (alpha_i - beta)$, we have
$[K_(i+1) : K_i] = 2$ if and only if $alpha_i - beta$ is a *non-square* in $K_i$.

*Step 2.* Over a finite field the norm detects squares in every degree: for $x in FF_(q^d)^times$,
$N(x)^((q-1) slash 2) = x^((q^d-1) slash 2)$, so $x$ is a square in $FF_(q^d)$ iff $N(x)$ is a
square in $FF_q$. So it suffices to compute $N_(K_i slash FF_5)(alpha_i - beta)$.

*Step 3.* That norm is the critical orbit. Indeed $alpha_i$ has minimal polynomial
$g^(circle.small (i-1))$, which is monic, so
$ N_(K_i slash FF_5)(beta - alpha_i) = product_"conjugates" (beta - dot.c)
  = g^(circle.small (i-1))(beta) = g^(circle.small (i-1))(g(gamma)) = c_i . $
(Equivalently, and this is the mechanism: $g(C) - g(Y) = (C - Y)(C - overline(Y))$ as polynomials in
$C$, so *one* norm step gives $N_(K_i slash K_(i-1))(c - alpha_i) = g(c) - alpha_(i-1)$ --- norming
down one floor advances the base point one step along the orbit of $g$. Telescoping from $c = c_1$
gives $c_i$.) Since $-1 = 4$ is a square in $FF_5$, the sign is irrelevant and
$N_(K_i slash FF_5)(alpha_i - beta) = plus.minus c_i$ is a non-square iff $c_i$ is.

*Conclusion.* $c_i in {2,3}$ for every $i$, and $2, 3$ are non-squares mod $5$. So
$[K_(i+1) : K_i] = 2$ for every $i >= 1$, every $g^(circle.small n)$ is irreducible mod $5$, and
every $f_n$ is irreducible over $QQ$. $qed$

#v(2mm)
This is the criterion of Ayad and McQuillan: a monic quadratic $g$ over $FF_q$ ($q$ odd) with base
point $b$ has all its iterates irreducible iff $b - c_1$ and $c_n - b$ $(n >= 2)$ are non-squares.
Stoll's version over $QQ$ is the same statement in the sufficient direction. Modulo squares $c_n - b$
is nothing but $"disc"(g^(circle.small n) - b)$, which is why the critical orbit and not some other
sequence: the covering ramifies over the post-critical set.

Two footnotes on the choice of $5$. First, it is forced: a computer search finds that $5$ is the
*only* prime below $10^9$ whose critical orbit avoids the squares --- the orbit has length about
$sqrt(p)$ and every value has to land right. Moreover the cycle length at a working prime must be
*even* (because $c_(n+1) - 1 = c_n (c_n - 1)$ makes $chi(c_n - 1)$ alternate), and a prime working
on a $2$-cycle must satisfy $p equiv 5 (mod 24)$ --- the only $2$-cycle being ${i, -i}$. Second, this is why one sees *two* auxiliary elements
alternating in the more computational version of the argument: they are $alpha_i - c_1$ and
$alpha_i - c_2$ up to squares, one for each point of the critical cycle, and their alternation is
the cycle turning.
]

= What the companion script checks <sec-gp>

`critical-orbit-stability.gp`, results in `results/critical-orbit-stability.txt`; $0$ failed
assertions.

#v(1mm)
- *(1)* The tower over $FF_5$ floor by floor to $[K_9 : FF_5] = 256$: at each floor, Lemma 1's
  obstruction is a non-square, $g(Y) - alpha_i$ is honestly irreducible over $K_i$, and the norm is
  the predicted $(-1)^d c_i$.
- *(2)* Lemma 2 both ways --- symbolically ($g(C) - g(Y) - (C-Y)(C-(1-Y)) = 0$), one floor at a time,
  and telescoped --- at three base points on each of seven floors, each pair verified twice.
- *(3)* Lemma 3 exhaustively for $q in {3,5,7}$ and $d in {1,2,3,4}$: no element of $FF_(q^d)^times$
  disagrees with its norm about being a square.
- *(4)* The criterion against brute-force factorisation: $45$ primes for $g$, and $96$ random
  triples (prime, monic quadratic, base point), $0$ mismatches.
- *(5)* $"disc"(g^(circle.small n)) = D_n$ modulo squares at $210$ pairs $(p,n)$, $0$ mismatches.
- *(6)* The scan: of the $2261$ primes below $20000$, exactly one --- $p = 5$ --- has a critical
  orbit avoiding the squares, with its orbit printed.
- *(7)* $delta_i = 4(alpha_i - c_1)$ and $delta'_i = 4(alpha_i - c_2)$ to $[K_8 : FF_5] = 128$, and
  the answer's two-floor norm step is Lemma 2 twice.
- *(8)* The original polynomials: both recursions agree, $f_n = g^(circle.small (n-2))(X+1)$, and
  $f_n$ is irreducible mod $5$ --- hence over $QQ$ --- for $n <= 15$, $deg f_15 = 8192$.
- *(9)* The characteristic-zero form for $X^2 + c$, $-12 <= c <= 30$: the test never passes where an
  iterate is reducible.
- *(10)* $c_(n+1) - 1 = c_n (c_n - 1)$ for $p < 500$; the product round a cycle is $1$ at $2260$
  primes; and all $26$ all-non-residue cycles found have even length (@sec-proved).
- *(11)* The $2$-cycle classification at all primes below $500$, and the residue conditions
  $p equiv 5 (mod 8)$, $p equiv 2 (mod 3)$ below $20000$.
- *(12)* $-3, t_2, dots, t_7$ independent modulo squares: full rank $7$ over $bb(F)_2$, so the
  density at level $k$ is $2^(-k)$ (@sec-density).
- *(13)* $N(p)$ against factorisation for $p < 60$, persistence of reducibility, the record
  survivals below $2 dot 10^5$, and the early-abort scan to $10^9$ --- one success, $p = 5$.

= Ties to the rest of this repository <sec-repo>

`corestriction.typ` is the general form of Lemma 3's structural half: corestriction in degree $1$
with $mu_2$ coefficients *is* the norm on $K^times slash (K^times)^2$, and the reason the tower here
is tractable is that over finite fields that map is an isomorphism at every floor --- so
$H^1(K_i, mu_2) = ZZ slash 2$ for all $i$, canonically identified with the ground floor.

`splitting-galois-closure.typ` is the same distinction between a field and its Galois closure that
separates the *path* $K_1 subset K_2 subset dots.c$ used here from the splitting field of
$g^(circle.small n)$, whose group is the arboreal image of @sec-general. Irreducibility is a
statement about the path; Odoni's problem is a statement about the closure.

`kummer-dedekind.typ` factors $g^(circle.small n)$ modulo $p$ in the guise of splitting a prime;
@sec-thm is the statement that for $p = 5$ the factorisation is always trivial.

= References <sec-refs>

#block(inset: (left: 4pt))[
#set enum(numbering: "[1]")
+ M. Ayad and D. L. McQuillan, *Irreducibility of the iterates of a quadratic polynomial over a
  field*, Acta Arith. $93$ ($2000$), $87$--$97$; corrigendum, Acta Arith. $99$ ($2001$), $97$. The
  finite-field criterion of @sec-thm, in the form used here.
+ M. Stoll, *Galois groups over $QQ$ of some iterated polynomials*, Arch. Math. $59$ ($1992$),
  $239$--$244$. The characteristic-zero criterion of @sec-char0, and the source of the
  "adjusted critical orbit" ${-c_1} union {c_n : n >= 2}$.
+ R. W. K. Odoni, *The Galois theory of iterates and composites of polynomials*, Proc. London Math.
  Soc. (3) $51$ ($1985$), $385$--$414$. Where the wreath-product picture of @sec-general is set up.
+ R. Jones, *Galois representations from pre-image trees: an arboreal survey*, Actes de la
  Conférence "Théorie des Nombres et Applications", Publ. Math. Besançon ($2013$), $107$--$136$.
  The survey; stability, arboreal images, and the role of the post-critical set.
+ N. Boston and R. Jones, *Settled polynomials over finite fields*, Proc. Amer. Math. Soc. $140$
  ($2012$), $1849$--$1863$. What happens at the primes where stability *fails* --- the finer
  factorisation statistics of the iterates mod $p$.
+ #link("https://math.stackexchange.com/questions/5010063/is-every-element-of-this-sequence-of-polynomials-irreducible")[Mathematics Stack Exchange 5010063],
  the question and the answer being rewritten here. The reformulation
  $f_n = f_(n-1)^2 - f_(n-1) + 1$ is due to Sassatelli Giulio in the comments.
+ `corestriction.typ` and `splitting-galois-closure.typ` in this repository --- see @sec-repo.
]
