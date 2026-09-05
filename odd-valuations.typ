#set document(
  title: "Odd valuations of polynomial values",
)

#set page(
  paper: "a4",
  margin: (x: 2.6cm, y: 2.4cm),
  numbering: "1",
  number-align: center,
)

#set text(font: ("New Computer Modern", "Libertinus Serif"), size: 10.5pt, lang: "en")
#set par(justify: true, leading: 0.62em, spacing: 1.1em)
#set heading(numbering: "1.")
#show heading: set block(above: 1.5em, below: 0.9em)
#show heading.where(level: 1): set text(size: 12pt)
#show heading.where(level: 2): set text(size: 11pt)
#set math.equation(numbering: "(1)")
#show link: set text(fill: rgb("#1a4d8f"))

#let accent = rgb("#2b2b2b")

#let statement(kind, title: none, body) = block(
  width: 100%,
  inset: (left: 12pt, top: 8pt, bottom: 8pt, right: 8pt),
  stroke: (left: 1.6pt + accent),
  breakable: true,
  above: 1.2em,
  below: 1.2em,
)[
  #strong(kind)#if title != none [ (#title)]#strong(".")
  #body
]

#let proof(body) = block(
  width: 100%,
  above: 1.0em,
  below: 1.2em,
)[
  #emph[Proof.] #body #h(1fr) $square$
]

#align(center)[
  #text(size: 17pt, weight: "bold")[Odd valuations of polynomial values]
  #v(0.4em)
  #text(size: 10pt)[When does a non-constant $f in bb(Z)[x]$ take values divisible \
  by infinitely many primes to an odd power?]
  #v(0.8em)
  #text(size: 9.5pt)[5 September 2026]
]

#v(1em)

#block(
  width: 100%,
  fill: rgb("#f4f4f1"),
  inset: 12pt,
  radius: 3pt,
)[
  *Summary.* The answer is *no in general*: for $f(x) = x^2$ the valuation $v_p (f(n)) = 2 v_p (n)$
  is even for every prime $p$ and every $n$. That is essentially the only obstruction. Writing
  $f = c dot f_1^(e_1) dots.c f_k^(e_k)$ with the $f_i$ distinct primitive irreducibles, the set of
  primes admitting an odd valuation is infinite exactly when some $e_i$ is odd --- equivalently,
  when $f$ is not a constant times a square in $bb(Z)[x]$ --- and in that case it has positive
  density.
]

= The question and the answer

Fix a non-constant polynomial $f in bb(Z)[x]$. For a prime $p$ let $v_p$ denote the $p$-adic
valuation on $bb(Z)$, so that $v_p (m)$ is the exponent of $p$ in $m$ (and $v_p (0) = infinity$).
Define
$ S(f) := { p "prime" : v_p (f(n)) "is odd for some" n in bb(Z) }. $

The question is whether $S(f)$ is always infinite. It is not.

#statement("Counterexample")[
  Let $f(x) = x^2$. Then $v_p (f(n)) = 2 v_p (n)$ is even for every prime $p$ and every
  $n in bb(Z)$, so $S(f) = emptyset$. The same happens for $x^4$, for $(x^2 + 1)^2$, and for
  $4 x^2$ --- while $S(2 x^2) = {2}$, which is finite but non-empty.
]

By Gauss's lemma we may factor
$ f = c dot f_1^(e_1) f_2^(e_2) dots.c f_k^(e_k), $ <factorization>
where $c in bb(Z)$ is the content of $f$ (up to sign) and the $f_i in bb(Z)[x]$ are distinct
primitive irreducible polynomials. This factorization is unique up to signs and reordering.

#statement("Theorem", title: "main result")[
  Let $f in bb(Z)[x]$ be non-constant, factored as in @factorization. Then:

  #set enum(numbering: "(a)")
  + If every $e_i$ is even, then $f = c dot h(x)^2$ for some $h in bb(Z)[x]$, and
    $ S(f) = { p : v_p (c) "is odd" }, $
    a finite (possibly empty) set.
  + If some $e_i$ is odd, then $S(f)$ is infinite. In fact $S(f)$ contains all but finitely many
    of the primes $p$ for which that $f_i$ has a root modulo $p$, a set of primes of density at
    least $1 slash deg f_i$.

  Consequently $S(f)$ is infinite if and only if $f$ is *not* of the form $c dot h(x)^2$ with
  $c in bb(Z)$ and $h in bb(Z)[x]$ --- if and only if some irreducible factor of $f$ occurs to an
  odd multiplicity.
]

The two halves are proved in @sec:easy and @sec:main. Neither is deep; the content of the theorem
is that the obvious obstruction is the only one.

= The square case <sec:easy>

#proof[
  Suppose every $e_i$ is even and set $h := product_(i=1)^k f_i^(e_i slash 2) in bb(Z)[x]$, so that
  $f = c h^2$. For any prime $p$ and any $n in bb(Z)$ with $f(n) != 0$,
  $ v_p (f(n)) = v_p (c) + 2 v_p (h(n)) equiv v_p (c) space (mod 2). $
  Hence $v_p (f(n))$ is odd precisely when $v_p (c)$ is odd, independently of $n$; and
  $v_p (f(n)) = infinity$ is not odd. So $S(f) = {p : v_p (c) "odd"}$, which is contained in the
  finite set of prime divisors of $c$.
]

Note that this direction says something slightly stronger than "$S(f)$ is finite'': the parity of
$v_p (f(n))$ does not depend on $n$ at all. The square class of $f(n)$ in $bb(Q)^times slash
(bb(Q)^times)^2$ is constant.

= The ingredients <sec:tools>

Three standard facts go into the other direction.

== Schur's theorem on prime divisors

A prime $p$ is called a #emph[prime divisor of the polynomial] $g$ if $p divides g(n)$ for some
integer $n$.

#statement("Theorem", title: "Schur, 1912")[
  Every non-constant $g in bb(Z)[x]$ has infinitely many prime divisors.
]

#proof[
  If $g(0) = 0$ then $p divides g(p)$ for every prime $p$ and we are done, so assume
  $a := g(0) != 0$. Suppose for contradiction that $p_1, dots, p_r$ are all the prime divisors of
  $g$. Writing $g(x) = a + c_1 x + dots.c + c_d x^d$, every term $c_i (a N)^i$ with $i >= 1$ is
  divisible by $a$, so
  $ g(a N) = a (1 + N M(N)) $
  for some $M in bb(Z)[x]$. Take $N := (p_1 dots.c p_r)^m$. Each $p_j$ divides $N$, hence
  $1 + N M(N) equiv 1 space (mod p_j)$ for every $j$. Since $g$ is non-constant, $abs(g(a N)) -> infinity$ as $m -> infinity$, so for $m$ large
  enough $abs(1 + N M(N)) = abs(g(a N) slash a) > 1$ and this integer has some prime factor $q$, and $q$ divides $g(a N)$ while
  $q in.not {p_1, dots, p_r}$ --- a contradiction.
]

This is Euclid's argument with a change of variable. It is the engine behind Schur's Euclidean
proofs of special cases of Dirichlet's theorem; see @sec:refs for the attribution.

== Resultants detect common roots modulo $p$

For $g, h in bb(Z)[x]$ not both zero, the resultant $"Res"(g, h) in bb(Z)$ satisfies a Bézout-type
identity
$ "Res"(g, h) = A(x) g(x) + B(x) h(x), quad A, B in bb(Z)[x]. $ <bezout>
Moreover $"Res"(g, h) = 0$ if and only if $g$ and $h$ have a common factor of positive degree (over
$bb(Q)$, equivalently over $overline(bb(Q))$), assuming they are not both constant. Evaluating
@bezout at an integer $n$ gives the fact we need:

#statement("Consequence")[
  If a prime $p$ divides both $g(n)$ and $h(n)$ for some $n in bb(Z)$, then $p$ divides
  $"Res"(g, h)$.
]

Applied with $h = g'$ this says: if $p divides gcd(g(n), g'(n))$ then $p divides "Res"(g, g')$,
which is non-zero whenever $g$ is separable --- in particular whenever $g$ is irreducible over
$bb(Q)$. Applied with two distinct irreducibles $g, h$ it says that $p$ can be a common prime
divisor of both only if $p$ divides the non-zero integer $"Res"(g, h)$.

== Lifting a simple root to valuation exactly one

#statement("Lemma", title: "Hensel step")[
  Let $g in bb(Z)[x]$, let $p$ be prime and $n in bb(Z)$ with $g(n) equiv 0 space (mod p)$ and
  $g'(n) equiv.not 0 space (mod p)$. Then $v_p (g(n)) = 1$ or $v_p (g(n + p)) = 1$.
]

#proof[
  Taylor expansion with integer coefficients gives
  $ g(n + p) = g(n) + p g'(n) + p^2 R $
  for some $R in bb(Z)$. If $v_p (g(n)) >= 2$ then $p^2 divides g(n)$, so
  $g(n + p) equiv p g'(n) space (mod p^2)$, and since $p divides.not g'(n)$ this has
  $v_p = 1$ exactly.
]

This is nothing but the uniqueness half of Hensel's lemma: a simple root mod $p$ lifts uniquely to
$bb(Z)_p$, so among the integers congruent to it mod $p$ the valuation $1$ case is the generic one.
Observe also that the substitution $n arrow.r n + p$ changes nothing modulo $p$: for any
$u in bb(Z)[x]$ we have $u(n + p) equiv u(n) space (mod p)$. This is what lets us apply the lemma
to one irreducible factor without disturbing the others.

= The odd multiplicity case <sec:main>

#proof[
  Assume some $e_i$ is odd; after reordering, say $e_1$ is odd, and write $g := f_1$, of degree
  $d := deg g >= 1$. Define the integer
  $ D := c dot "Res"(g, g') dot product_(i != 1) "Res"(g, f_i), $
  Each factor is non-zero: $c != 0$ because $f != 0$; $"Res"(g, g') != 0$ because $g$ is irreducible over $bb(Q)$, hence separable; and
  $"Res"(g, f_i) != 0$ for $i != 1$ because $g$ and $f_i$ are distinct irreducibles in $bb(Z)[x]$
  and so are coprime in $bb(Q)[x]$. Thus $D != 0$ and only finitely many primes divide $D$.

  By Schur's theorem, $g$ has infinitely many prime divisors, so we may pick any prime $p$ with
  $p divides.not D$ together with an $n in bb(Z)$ such that $g(n) equiv 0 space (mod p)$. We claim
  $p in S(f)$.

  Since $p divides.not "Res"(g, g')$ and $p divides g(n)$, the consequence in @sec:tools forces
  $p divides.not g'(n)$: the root $n$ is a *simple* root of $g$ mod $p$. By the Hensel step lemma,
  after replacing $n$ by $n + p$ if necessary we may assume
  $ v_p (g(n)) = 1 $
  exactly. The replacement is harmless: $g(n + p) equiv g(n) equiv 0$ and
  $g'(n + p) equiv g'(n) equiv.not 0$ modulo $p$, so the hypotheses still hold, and the congruence
  class of $n$ mod $p$ is unchanged for every other polynomial too.

  Now evaluate the whole factorization at this $n$. For $i != 1$ we have
  $p divides.not "Res"(g, f_i)$ and $p divides g(n)$, so $p divides.not f_i (n)$, i.e.
  $v_p (f_i (n)) = 0$. And $p divides.not c$, so $v_p (c) = 0$. Therefore
  $ v_p (f(n)) = v_p (c) + sum_(i=1)^k e_i v_p (f_i (n)) = e_1 dot 1 = e_1, $
  which is odd by assumption. Hence $p in S(f)$.

  Since this holds for every prime divisor $p$ of $g$ outside the finite set of divisors of $D$,
  and $g$ has infinitely many prime divisors, $S(f)$ is infinite.
]

The proof gives slightly more than infinitude: it exhibits $n$ with $v_p (f(n))$ equal to the
specific odd number $e_1$, and it shows that the exceptional primes are confined to the divisors of
the explicit integer $D$.

= The density refinement

Schur's theorem is enough for infinitude, but the set produced is in fact of positive density. Let
$g = f_1$ be irreducible of degree $d$ with splitting field $L slash bb(Q)$ and Galois group
$G = "Gal"(L slash bb(Q))$, viewed as a transitive subgroup of $S_d$ through its action on the $d$
roots of $g$.

By the Frobenius density theorem, for $p$ unramified the factorization type of $g$ mod $p$ matches
the cycle type of the Frobenius class, and the density of primes with a prescribed cycle type is
the proportion of elements of $G$ of that type. In particular
$ delta({p : g "has a root mod" p}) = (abs(union.big_(x) G_x)) / abs(G), $
the union running over the $d$ point stabilizers $G_x$ --- these are exactly the elements with at
least one fixed point. Two remarks:

#set enum(numbering: "(a)")
+ *Lower bound.* Transitivity gives $[G : G_x] = d$, so a single stabilizer already has
  $abs(G_x) = abs(G) slash d$. Hence the density is at least $1 slash d$. Combined with @sec:main,
  $S(f)$ has density at least $1 slash deg f_1 > 0$.
+ *Strict upper bound.* Jordan's theorem (1872) says a transitive subgroup of $S_d$ with $d > 1$
  always contains a fixed-point-free element, so the density is strictly less than $1$. Thus for
  $d > 1$ there are also infinitely many primes $p$ for which $f_1$ has no root mod $p$ at all.

One can of course quote Chebotarev instead of Frobenius; Frobenius suffices because "having a root''
is a condition on cycle types, which is stable under the coarser equivalence Frobenius controls.

= Examples

#set enum(numbering: "(a)")
+ $f(x) = x^3$. Here $c = 1$, $f_1 = x$, $e_1 = 3$. For every prime $p$, $v_p (f(p)) = 3$ is odd, so
  $S(f)$ is the set of all primes.
+ $f(x) = x^2 (x + 1)$. The factor $x + 1$ has multiplicity $1$, and $v_p (f(p - 1)) = 1$ for every
  prime $p$: again $S(f)$ is everything.
+ $f(x) = x^2 + 1$. Here $S(f)$ contains every prime $p equiv 1 space (mod 4)$: such $p$ has
  $n$ with $n^2 equiv -1$, and the Hensel step makes the valuation exactly $1$. It misses every
  $p equiv 3 space (mod 4)$, which never divides $x^2 + 1$. Density $1 slash 2 = 1 slash deg f$,
  matching the bound.
+ $f(x) = 12 (x^2 + 1)^2$. Every irreducible factor has even multiplicity, so part (a) applies:
  $v_p (f(n)) equiv v_p (12) space (mod 2)$, and since $12 = 2^2 dot 3$ we get $S(f) = {3}$.

= Notes on the literature <sec:refs>

*Schur's theorem.* The customary citation is

#block(inset: (left: 14pt))[
  I. Schur, #emph[Über die Existenz unendlich vieler Primzahlen in einigen speziellen arithmetischen
  Progressionen], Sitzungsberichte der Berliner Mathematischen Gesellschaft *11* (1912), 40--50.
]

Schur's own aim there was Euclidean proofs of Dirichlet's theorem for residue classes $a mod m$
with $a^2 equiv 1 space (mod m)$; the prime-divisor lemma is the tool. The context, and a converse
due to Ram Murty (1988), are laid out in Keith Conrad's notes
#link("https://kconrad.math.uconn.edu/blurbs/gradnumthy/dirichleteuclid.pdf")[#emph[Euclidean proofs
of Dirichlet's theorem]], where the Schur reference above appears as item [8].

As a textbook theorem it is in Nagell: prime divisors of a polynomial are defined on p. 81 and the
infinitude is Theorem on p. 82 of

#block(inset: (left: 14pt))[
  T. Nagell, #emph[Introduction to Number Theory], Wiley, 1951 (reprinted by AMS Chelsea).
]

A caveat on the name: the argument is a change of variable away from Euclid's and predates 1912 in
substance, so it travels under several names --- Schur's theorem, Nagell's theorem, or simply
folklore. A modern reproof (via Furstenberg's topological method) that calls it "the celebrated
Schur's theorem'' is X. Lin, #link("https://arxiv.org/abs/1706.09102")[#emph[Prime divisors of
sequences of integers]] (arXiv:1706.09102, 2017). For a broader treatment of the prime divisors of a
polynomial, see I. Gerst and J. Brillhart,
#link("https://www.tandfonline.com/doi/abs/10.1080/00029890.1971.11992737")[#emph[On the prime
divisors of polynomials]], Amer. Math. Monthly *78* (1971), 250--266.

*Density.* Readable accounts of the Frobenius density theorem: B. Sury,
#link("https://www.ias.ac.in/article/fulltext/reso/008/12/0033-0041")[#emph[Frobenius and his
density theorem for primes]], Resonance *8* (2003), 33--41; and H. W. Lenstra and P. Stevenhagen,
#link("https://pub.math.leidenuniv.nl/~lenstrahw/papers/cheb.pdf")[#emph[Chebotarëv and his density
theorem]], Math. Intelligencer *18* (1996), 26--37. The group-theoretic input for the lower bound is
trivial, as noted; the converse direction, Jordan's theorem, is treated definitively in J.-P. Serre,
#link("https://www.ams.org/journals/bull/2003-40-04/S0273-0979-03-00988-1/")[#emph[On a theorem of
Jordan]], Bull. Amer. Math. Soc. *40* (2003), 429--440.

*Routine ingredients.* The resultant identity @bezout and the theory behind it are in Lang,
#emph[Algebra], in the chapter on polynomials, and --- with elimination theory spelled out --- in
Cox, Little and O'Shea, #emph[Ideals, Varieties, and Algorithms], ch. 3 §6. Gauss's lemma and unique
factorization in $bb(Z)[x]$: Lang, #emph[Algebra], ch. IV. Hensel's lemma: Serre, #emph[A Course in
Arithmetic], ch. II, or Cassels, #emph[Local Fields].

*The theorem itself.* I know of no canonical citation for the packaged statement. It circulates as
folklore because it is the standard lemma showing that $y^2 = f(x)$ defines a genuine quadratic
extension of $bb(Q)(x)$ --- one meets it as an unnumbered lemma in treatments of hyperelliptic
curves and of $2$-descent rather than as a named theorem. The nearest relatives in the literature
are the results on when a polynomial takes square values infinitely often (Davenport--Lewis--Schinzel;
LeVeque's work on $y^2 = f(x)$ via Siegel's theorem). It is best presented as an exercise assembled
from Schur, resultants and Hensel, which is what has been done above.
