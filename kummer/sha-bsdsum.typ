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
  #text(size: 16pt, weight: "bold")[The exact evaluation]
  #v(2mm)
  #text(size: 10pt)[The Birch--Swinnerton-Dyer finite sum for $y^2 = x^3 + p x$,
  computed, and what it turns the Fermat pattern into]
  #v(1mm)
  #text(size: 9pt, style: "italic")[fourth note on Ш at the Fermat primes]
]

#v(4mm)

= The formula <sec-formula>

The previous note ended by saying that what was wanted was an *exact evaluation*, not a lower
bound, of the finite sum that expresses the central $L$-value. Here it is, and here is what it
gives.

For a CM elliptic curve the central value is a finite sum of special values of the Weierstrass
function --- Birch and Swinnerton-Dyer's expression, restated as Theorem 2.6 of
#link("https://arxiv.org/abs/2207.10380")[Nomoto]. Our curves fall in its first branch, because
$(i slash p)_4 = i^((p-1) slash 2) = 1$ for every $p equiv 1$ $(mod 8)$. Taking $D = Delta = p$:

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  $ (epsilon p) / Omega L_(2p) (overline(psi)_(-p), 1)
    = sqrt(2)/4 sum_(c) (c/p)_4
      + 1/sqrt(2) sum_(c) (c/p)_4 (cal(P)_c + 1)/(cal(P)_c^2 - 2 cal(P)_c - 1) , $
  the sums being over $c in (cal(O)_K slash p)^times$, where $cal(P)_c = cal(P)(c Omega slash p)$ is
  the Weierstrass function of the lattice $Omega cal(O)_K$ --- so $cal(P)_c$ is the
  $x$-coordinate of a $p$-torsion point of $E_1 : y^2 = x^3 - x$ --- and $Omega = 2.6220575...$.
]

The first sum *vanishes*: $(dot slash p)_4$ is a non-trivial character and $c$ runs over the whole
group. So everything is in the second sum, which we call $S(p)$. Note that its denominator
$w^2 - 2w - 1$ has roots $1 plus.minus sqrt(2) = cal(P)(Omega slash 4), cal(P)((1+2i)Omega slash 4)$:
the poles sit at the 4-torsion.

*Normalisation check.* Before trusting anything, `sha-bsdsum.gp` reproduces the paper's own special
values to 60 digits: $Omega = 2.62205755...$, $cal(P)(Omega slash 4) = 1 + sqrt(2)$,
$cal(P)'(Omega slash 4) = -4 - 2 sqrt(2)$, $cal(P)((1+2i) Omega slash 4) = 1 - sqrt(2)$.

= The evaluation <sec-eval>

Computing $S(p)$ to 60 digits and recognising it with `algdep`:

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  $ S(17)^4 = 2^6 dot 17^3 , quad quad S(257)^4 = 2^(14) dot 257^3 . $
  That is, $S(17) = 2^(3 slash 2) dot 17^(3 slash 4)$ and
  $S(257) = 2^(7 slash 2) dot 257^(3 slash 4)$ --- *exact* algebraic numbers, with no odd part
  whatever.
]

The factor $p^(3 slash 4)$ is not a surprise: the period of $y^2 = x^3 + p x$ is
$Omega slash p^(1 slash 4)$, the quartic twist scaling the period, and the theorem's left-hand side
carries $Omega$ rather than the twisted period. Dividing it out and comparing with the quantity $m$
of the second note, defined by $L(E_p, 1) slash Omega_E = 2 m^2$:

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *The finite sum computes $m^2$ on the nose.* On every prime tested, to 40 digits,
  $ S(p) = 2 sqrt(2) dot m^2 dot p^(3 slash 4) . $
]

#align(center, table(
  columns: 4, align: (center, center, center, center),
  stroke: 0.4pt + luma(170), inset: (x: 7pt, y: 3.5pt),
  table.header([$p$], [$S(p) slash p^(3 slash 4)$], [$S(p) slash (2 sqrt(2) p^(3 slash 4))$], [$m$]),
  [17],  [$2 sqrt(2)$],  [1], [1],
  [41],  [$2 sqrt(2)$],  [1], [1],
  [97],  [$2 sqrt(2)$],  [1], [1],
  [137], [$2 sqrt(2)$],  [1], [1],
  [257], [$4 dot 2 sqrt(2)$], [4], [2],
  [577], [$4 dot 2 sqrt(2)$], [4], [2],
))

#v(2mm)

= What the pattern has become <sec-becomes>

Putting the four notes together, the Fermat-prime observation is now this, and nothing else:

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *For $p = 2^(2^k) + 1$, the character sum over the $p$-torsion of $y^2 = x^3 - x$*
  $ sum_(c in (cal(O)_K slash p)^times) (c/p)_4 (cal(P)(c Omega slash p) + 1)
      / (cal(P)(c Omega slash p)^2 - 2 cal(P)(c Omega slash p) - 1) $
  *equals $2 sqrt(2) dot 4^(k-2) dot p^(3 slash 4)$.*
]

Everything else is done: this value gives $m = 2^(k-2)$, hence $L(1) slash Omega = 2^(2k-3)$, hence
$\# Ш = 2^(2k-2)$, and the shape $(ZZ slash 2^(k-1))^2$ was already a theorem. The whole mystery is
now one identity about one finite sum.

= Why this is the right target, and what to try <sec-target>

Three features make the reformulation worth having.

*It is finite and elementary.* No $L$-functions, no BSD: a sum of $(p-1)^2$ algebraic numbers,
each a rational function of the $x$-coordinate of a torsion point, weighted by a quartic residue
symbol.

*It explains the square.* $m^2$ appears, not $m$ --- the sum is intrinsically a square, which is why
$\# Ш = (2m)^2$ and why the Cassels pairing had to be alternating. The two came out consistent
because they are the same fact.

*And it is a Gauss-sum-shaped object.* A sum over a finite group, weighted by a multiplicative
character of 2-power order, of values of a fixed algebraic function. The tool for the *exact* 2-adic
valuation of such sums is #emph[Stickelberger's theorem], whose answer is a *sum of base-$p$
digits*. Digit sums are exactly the sort of quantity that is generically of size $sqrt(p)$ and
collapses to something tiny on a thin family --- and, crucially, they can behave doubly
logarithmically along a family like $p - 1 = 2^(2^k)$, which is precisely the growth
$log_2 m = log_2 log_2 b - 1$ that no algebraic formula in $a$ and $b$ could produce (second note).
That is where we would look next.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *The obstacle to more data.* $S(p)$ has $(p-1)^2$ terms, so $p = 65537$ needs $4.3 dot 10^9$
  evaluations of $cal(P)$ --- out of reach this way, even though the analytic $L$-value for that $p$
  was computed in the first note. Any further progress needs the sum evaluated *2-adically* rather
  than numerically: reduce the torsion points and the character into a 2-adic field and compute the
  valuation directly. That is the concrete next step, and it is the step Zhao's method takes by
  induction on prime factors --- an induction that, as the third note showed, has nothing to induct
  on when $D$ is a single split prime.
]

= Status <sec-status>

*Done here.* The finite sum is implemented, its normalisation validated against four independent
special values, and evaluated exactly for $p = 17$ and $257$: $S = 2^(3 slash 2) p^(3 slash 4)$ and
$2^(7 slash 2) p^(3 slash 4)$. The identity $S = 2 sqrt(2) m^2 p^(3 slash 4)$ is confirmed on six
primes to 40 digits, so the sum computes $m^2$ directly and the Fermat pattern is reduced to a
single explicit identity.

*Not done.* The identity itself. What remains is a 2-adic evaluation of a quartic-character sum over
torsion points --- Stickelberger territory --- rather than anything about elliptic curves.
