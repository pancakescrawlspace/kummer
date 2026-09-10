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
  #text(size: 16pt, weight: "bold")[Zhao's method, and why it does not reach a single prime]
  #v(2mm)
  #text(size: 10pt)[What the literature proves about $v_2 (L(1) slash Omega)$ for
  $y^2 = x^3 + D x$, and why the Fermat primes sit outside it]
  #v(1mm)
  #text(size: 9pt, style: "italic")[third note on Ш at the Fermat primes]
]

#v(4mm)

= The state of the art, and it is our exact family <sec-lit>

The previous note reduced everything to $v_2 (L(E_p,1) slash Omega) = 2k - 3$ and suggested looking
at the literature on 2-adic valuations of central $L$-values in CM families. That literature exists,
it uses *Zhao's method*, and one paper treats precisely the curves in question.

== Zhao's method in one paragraph <sec-zhao>

For a CM elliptic curve the central value $L(1) slash Omega$ can be written as an *explicit finite
sum* of special values of the Weierstrass function $cal(P)$ --- an expression going back to Birch and
Swinnerton-Dyer. Zhao's idea is to estimate the 2-adic valuation of that sum by *induction on the
number of distinct prime divisors of the twisting parameter $D$*: one relates the sum for $D$ to the
sums for the divisors $D_T$ of $D$, and each prime factor contributes a fixed amount to the
valuation. The output is always a lower bound of the shape
$ v_2 (L(1) slash Omega) >= alpha dot r(D) + beta , $
with $r(D)$ the number of prime divisors.

== Nomoto's theorem <sec-nomoto>

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Theorem* (Nomoto, #link("https://arxiv.org/abs/2207.10380")[arXiv:2207.10380], Thm 1.1)*.*
  Let $K = QQ(i)$ and let $E_(-D) : y^2 = x^3 + D x$ over $K$, with $D in cal(O)_K$ quartic-free and
  congruent to 1 modulo $2 + 2i$. Let $psi_(-D)$ be the associated Hecke character and let
  $L_2 (overline(psi)_(-D), s)$ be its $L$-function with the Euler factor at $(1+i)$ removed. If
  $D in.not K^(times 2)$ then
  $ v_2 ((L_2 (overline(psi)_(-D), 1)) / Omega) >= (r(D) - 2) / 2 , $
  where $r(D)$ is the number of distinct primes dividing $D$ and $Omega = 2.6220575...$ is the least
  positive real period of $y^2 = x^3 - x$. For $D in K^(times 2)$, Zhao's bound is
  $(2 r(D) - 3) slash 2$.
]

This is *exactly* our family --- $y^2 = x^3 + D x$, quartic-free $D$, CM by $ZZ[i]$, the same
period. So the question is whether it says anything about $D = p$.

= Why it says nothing here <sec-vacuous>

It does not, and the reason is structural rather than technical.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  $r(D)$ counts primes of $cal(O)_K = ZZ[i]$, not of $ZZ$. Our $D = p$ is a rational prime
  $equiv 1$ $(mod 4)$, so it *splits*: $p = pi overline(pi)$ and $r(D) = 2$. The bound reads
  $ v_2 >= (2 - 2) / 2 = 0 , $
  which is vacuous; Zhao's square case would give $1 slash 2$. Meanwhile the truth, for
  $p = 2^(2^k)+1$, is $v_2 = 2k - 3$, which grows without bound.
]

So the Fermat primes are *extremal in the direction the theory does not control*. Every bound in
this line grows with the number of prime factors of $D$; our family has the minimum possible number
of them --- one rational prime, two Gaussian primes, fixed forever --- and the valuation grows
anyway. Nothing in the Zhao framework is shaped to see that.

= Two candidate mechanisms, both eliminated <sec-elim>

The same paper supplies the one local invariant at 2 that these arguments turn on, and it is
constant on our family.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Proposition* (Nomoto, Prop. 2.1)*.* $E_(-D)$ has good reduction at $(1+i)$ if and only if
  $(i slash D)_4 = i$, and the valuations with and without the Euler factor at $(1+i)$ differ by
  $1 slash 2$ exactly in that case.
]

For $D = p$ a rational prime the symbol is computable in closed form:
$ (i slash p)_4 = (i slash pi)_4 (i slash overline(pi))_4 = i^((p-1) slash 4) dot i^((p-1) slash 4)
  = i^((p-1) slash 2) , $
which for $p equiv 1$ $(mod 8)$ is $1$. So $(i slash p)_4 = 1 != i$ for *every* prime in our family:
$E_p$ always has bad reduction at $(1+i)$, there is never a half-shift, and the invariant is
constant where the answer is not.

A second guess, that the answer is driven by how 2-divisible $p - 1$ is --- natural, since
$p - 1 = 2^(2^k)$ is as 2-divisible as it gets --- also fails:

#align(center, table(
  columns: 5, align: (center, center, center, center, center),
  stroke: 0.4pt + luma(170), inset: (x: 7pt, y: 3.5pt),
  table.header([$p$], [$v_2 (p-1)$], [$b$], [$m$], [$v_2 (L(1) slash Omega)$]),
  [193], [6], [12], [1], [1],
  [577], [6], [24], [2], [*3*],
))

#v(2mm)

Same $v_2 (p-1)$, different answer. Together with the counterexample $4177$ versus $4937$ of the
previous note --- same $b$, both of the form $x^2 + 256 y^2$, different $m$ --- three of the four
natural invariants at 2 are eliminated: the quartic symbol $(i slash p)_4$, the octic residue
character of 2, the 2-divisibility of $p - 1$, and the shape of $b$.

= What does survive <sec-survives>

One statement, from the previous note, and it now sits naturally in this framework, since quartic
residue symbols are exactly the currency of these papers:

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  For every rank-0 prime $p equiv 1$ $(mod 8)$ tested (82 of them),
  $ m "even" quad <==> quad 2 "is a quartic residue mod" p quad <==> quad 8 divides b , $
  where $L(1) slash Omega = 2 m^2$ and $p = a^2 + b^2$ with $a$ odd. For a Fermat prime
  $b = 2^(2^(k-1))$, so this holds exactly when $k >= 3$ --- which is exactly when $m$ stops being
  odd.
]

That fixes $v_2 (L(1) slash Omega) = 1$ versus $>= 3$. It is the first rung, and the ladder above it
is what remains unknown.

= Conclusion <sec-concl>

*What we can now say precisely.* The pattern $Ш(E_p) tilde.equiv (ZZ slash 2^(k-1))^2$ has three
layers. The *shape* is a theorem for any $p equiv 1$ $(mod 8)$ with $L(1) != 0$, needing no BSD
(first note). The *parity* of the square root $m$ is Gauss's quartic residue criterion (second
note). The *height* $m = 2^(k-2)$ is open, and --- this is the point of this note --- it is open in
a regime the existing machinery does not address: all known lower bounds grow with the number of
prime divisors of $D$, and here that number is pinned at its minimum while the valuation grows.

*What would settle it.* Either an exact evaluation, rather than a lower bound, of the
Birch--Swinnerton-Dyer finite sum for $D = p$ prime --- the sum is explicit, so this is a concrete
if delicate 2-adic computation --- or an identification of $m$ as a coefficient of a half-integral
weight form for the quartic-twist family, which is what the doubly logarithmic growth
$log_2 m = log_2 log_2 b - 1$ is pointing at.

#v(3mm)

#text(size: 9pt)[
  *Sources.*
  #link("https://arxiv.org/abs/2207.10380")[K. Nomoto, _Lower bound for the 2-adic valuations of
  central $L$-values of elliptic curves with complex multiplication_, arXiv:2207.10380] --- treats
  $y^2 = x^3 + D x$ over $QQ(i)$, quartic-free $D$; Theorem 1.1 and Proposition 2.1 quoted above.
  #linebreak()
  #link("https://arxiv.org/abs/2403.11474")[T. Adachi, K. Nomoto, R. Shii, _The 2-adic valuations of
  the algebraic central $L$-values for quadratic twists of weight 2 newforms_, arXiv:2403.11474] ---
  the quadratic-twist analogue, with bounds $frak(w)_m dot r + c$ linear in the number of prime
  factors.
  #linebreak()
  C. Zhao, _A criterion for elliptic curves with lowest 2-power in $L(1)$_ (I), (II), Math. Proc.
  Cambridge Philos. Soc. --- the original method.
]
