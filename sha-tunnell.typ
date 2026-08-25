#set page(paper: "a4", margin: (x: 2.0cm, y: 2.2cm), numbering: "1")
#set text(font: "New Computer Modern", size: 10.5pt)
#set par(justify: true)
#set heading(numbering: "1.")
#show raw.where(block: true): it => block(
  fill: luma(247), inset: 8pt, radius: 3pt, width: 100%, breakable: true,
  text(size: 8pt, it),
)

#align(center)[
  #text(size: 16pt, weight: "bold")[Looking for a Tunnell-style formula]
  #v(2mm)
  #text(size: 10pt)[The square root of $L(E_p, 1) slash Omega$ for
  $y^2 = x^3 + p x$, what governs its parity, and what does not]
  #v(1mm)
  #text(size: 9pt, style: "italic")[sequel to #emph[Ш of $y^2 = x^3 + p x$ at the Fermat primes]]
]

#v(4mm)

= What a Tunnell-style formula is <sec-bg>

The companion note reduced the Fermat-prime pattern to a single assertion,
$ L(E_p, 1) slash Omega = 2 m^2 quad "with" quad m = 2^(k-2) , $
and observed that $L(1) slash Omega$ is *twice a perfect square* in all 64 computed cases. A
square is the signature of a particular kind of theorem, and this section says which.

== Half-integral weight and the Shimura correspondence <sec-bg-shimura>

Classical modular forms have integral weight. There is a parallel world of forms of *half-integral*
weight $k + 1 slash 2$, and Shimura constructed a correspondence
$ #[weight $k + 1 slash 2$] quad <--> quad #[weight $2k$] $
matching Hecke eigenforms on the two sides. The half-integral side is smaller and stranger --- its
Fourier coefficients are indexed by integers but behave like *square roots* of the quantities the
integral side sees. Concretely, if $g = sum c(n) q^n$ has weight $3 slash 2$ and corresponds to a
weight-2 form $f$, then $c(n)$ knows about $f$ twisted by the quadratic character of $n$.

== Waldspurger's theorem <sec-bg-wald>

Waldspurger made that precise, and in the form we care about it reads: for $f$ of weight 2 with a
weight-$3 slash 2$ partner $g = sum c(n) q^n$,
$ L(f "twisted by" chi_d, 1) = kappa dot (c(|d|)^2) / sqrt(|d|) $
for $d$ ranging over a fixed square class, with $kappa$ independent of $d$. *The central value of
the twisted $L$-function is the square of a Fourier coefficient.* That is where squares come from,
and it is why such formulas are so effective: a coefficient $c(|d|)$ is a finite, computable
integer, so vanishing of a central $L$-value --- an analytic condition --- becomes the arithmetic
condition $c(|d|) = 0$.

== Tunnell's theorem, the model case <sec-bg-tunnell>

The famous instance is the congruent number problem, $E_n : y^2 = x^3 - n^2 x$. Tunnell (1983)
identified the weight-$3 slash 2$ partner explicitly, and its coefficients count representations by
ternary quadratic forms. For $n$ odd and squarefree, put
$ a_n = \#{(x,y,z) in ZZ^3 : n = 2x^2 + y^2 + 32 z^2} - 2 \#{(x,y,z) in ZZ^3 : n = 2x^2 + y^2 + 8 z^2} . $
Then
$ L(E_n, 1) = (Omega a_n^2) / (4 sqrt(n)) , $
so that $n$ congruent $==>$ $a_n = 0$, and conversely under BSD. The whole analytic content is
compressed into counting lattice points on two ellipsoids.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *Why this matters for Ш.* Under BSD the order of Ш is $L(1) slash Omega$ times torsion and
  Tamagawa factors. If $L(1) slash Omega$ is essentially $c(|d|)^2$, then $\# Ш$ is essentially a
  square --- which is exactly what the Cassels--Tate pairing independently demands. The two
  statements meet, and $m$ is the arithmetic square root that both are pointing at.
]

= Why our family is not literally Tunnell's <sec-quartic>

Here is the obstacle. Waldspurger's theorem governs *quadratic* twist families. Ours is not one.

The quadratic twist of $y^2 = x^3 + d x$ by $t$ is $y^2 = x^3 + d t^2 x$, so twisting moves $d$
inside its *square* class. Two squarefree integers $d != d'$ are therefore never quadratic twists
of each other: the family $\{E_d\}_(d "squarefree")$ is the family of *quartic* twists of
$y^2 = x^3 + x$, indexed by $QQ^times slash (QQ^times)^4$, and each quadratic twist class contains
just one squarefree $d$.

What does organise the family is the complex multiplication. $E_d$ has CM by $ZZ[i]$, and
$ L(E_d, s) = L(s, overline(psi) chi_d) , $
a Hecke $L$-function of $QQ(i)$, where $chi_d = (d slash dot)_4$ is the *quartic* residue
character. At a prime $p = pi overline(pi)$ of good reduction,
$ a_p = 2 "Re" (overline(chi_d (pi)) pi) . $
So the family is a family of quartic twists of one Hecke character. The square shape of the central
value still has an explanation on this side --- values of such $L$-functions at the centre are, via
elliptic units, essentially norms from $QQ(i)$, and a norm is a square in the relevant sense --- but
it is not Waldspurger's theorem, and the coefficient $m$ is not a Tunnell coefficient.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  Nevertheless the computation says a square root exists and is small: $L(1) slash Omega = 2 m^2$
  in every one of 64 cases, with $m = 1, 2, 3, 4$ occurring. So there *is* something to find. The
  rest of this note is what we could determine about $m$.
]

= The first rung: when is $m$ even? <sec-rung1>

This one has a clean answer, and it is classical arithmetic rather than modular forms.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Observation 1.* For every rank-0 prime $p equiv 1$ $(mod 8)$ tested (82 of them, $p < 4000$):
  $ m "is even" quad <==> quad 2 "is a quartic residue mod" p quad <==> quad 8 divides b , $
  where $p = a^2 + b^2$ with $a$ odd. Zero exceptions.
]

The second equivalence is Gauss's criterion, and the third description is the classical
$ 2 "a quartic residue mod" p quad <==> quad p = x^2 + 64 y^2 . $

For a Fermat prime this settles the bottom of the pattern immediately. Since
$p = 2^(2^k) + 1 = 1^2 + (2^(2^(k-1)))^2$ we have $a = 1$ and $b = 2^(2^(k-1))$, so
$ 8 divides b quad <==> quad 2^(k-1) >= 3 quad <==> quad k >= 3 . $
And indeed $m = 1$ at $k = 2$, $m = 2$ at $k = 3$, $m = 4$ at $k = 4$: odd exactly when $k = 2$.

= The second rung is *not* the octic criterion <sec-rung2>

The obvious continuation --- $4 divides m$ iff 2 is an *octic* residue mod $p$ --- is false, and
badly so.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Observation 2.* Among the 101 primes $p < 20000$ with $m$ even, the condition $4 divides m$
  disagrees with "2 is an octic residue mod $p$" in *48* cases.
]

A clean counterexample pair, which also kills the guess that $p = x^2 + 256 y^2$ is the criterion:

#align(center, table(
  columns: 5, align: (center, center, center, center, center),
  stroke: 0.4pt + luma(170), inset: (x: 7pt, y: 3.5pt),
  table.header([$p$], [$a$], [$b$], [$p = x^2 + 256 y^2$ ?], [$m$]),
  [4177], [9],  [64], [$9^2 + 256 dot 4^2$], [2],
  [4937], [29], [64], [$29^2 + 256 dot 4^2$], [*4*],
))

#v(2mm)

Same $b$, same $v_2 (b) = 6$, both represented by $x^2 + 256 y^2$ with the same $y$ --- and $m$
differs. Whatever governs the higher 2-adic valuation of $m$ is not a power-residue condition on 2
alone.

= Status, and where to look next <sec-status>

*Established here.* The background reduction: a Tunnell-style formula is exactly a statement that
the central value is a square of a half-integral-weight coefficient, and that is the shape our
$L(1) slash Omega = 2 m^2$ has. The obstruction to importing Waldspurger directly: our family is a
*quartic* twist family, so the right framework is the Hecke character $overline(psi) chi_d$ with
$chi_d$ quartic, not a weight-$3 slash 2$ form. And Observation 1, which pins the parity of $m$ to
Gauss's quartic residue criterion and thereby explains the bottom of the Fermat pattern.

*Refuted here.* The natural continuation by octic residues (Observation 2).

*Still open.* The full statement $m = 2^(k-2)$. The place we would look next is the literature on
the *2-adic valuation of central $L$-values* in exactly these CM families --- Zhao's criteria for
$y^2 = x^3 - d x$ and Tian's induction on the number of prime divisors for the congruent number
problem. Those compute $v_2 (L(1) slash Omega)$ from combinatorial data attached to the prime
factors of $d$ (residue symbol graphs, and the rank of an associated matrix over $bb(F)_2$). For
$d = p$ prime that data degenerates to a single vertex, which is why one might hope the Fermat case
is within reach --- and why it is strange that it grows at all.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *The oddity worth stating plainly.* For the Fermat primes, $m = 2^(k-2)$ while
  $b = 2^(2^(k-1))$. So $m$ is *doubly logarithmic* in $b$:
  $ log_2 m = (log_2 log_2 b) - 1 . $
  No algebraic expression in $a$ and $b$ behaves like that. Whatever computes $m$ must be a
  counting or class-number-like quantity, of the sort that is generically of size $sqrt(p)$ but
  collapses to something tiny on a thin family --- which is precisely the character of a
  half-integral weight coefficient, and is the best evidence we have that a Tunnell-style formula
  is the right thing to be looking for.
]
