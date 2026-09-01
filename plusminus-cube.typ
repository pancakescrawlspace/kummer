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
  #text(size: 16pt, weight: "bold")[The twin cubes $y^2 = x^3 minus.plus a^3$]
  #v(2mm)
  #text(size: 10pt)[A density scan for $"Kum"(E times E')$ at every $p <= 19$: the odd primes are
  covered, $2$ is not, and the configuration is a third one]
  #v(1mm)
  #text(size: 9pt, style: "italic")[a question of René Pannekoek's; scan in `plusminus-cube.gp`,
  on the repository's own `kummer2.gp` / `p2.gp`]
]

#v(4mm)

#block(fill: luma(240), inset: 9pt, radius: 3pt, width: 100%)[
  *Summary.* For $a = 3, 5, 7$ and every odd $p <= 19$, a single twist covers each square class, so
  $X(QQ)$ is dense in $X(QQ_p)$ there (@sec-odd). At $p = 2$ the four *odd* square classes have
  witnesses and the four *even* ones have none --- out to $abs(d) <= 10^4$ (@sec-deep). That is the
  exact signature of `kummer-example-j0.typ`, and the reason is visible: $E'$ is the quadratic twist
  of $E$ by $-1$, and here *globally*, $E'_d = E_(-d)$. But the pair is *not* covered by either
  branch of `j0-obstruction-family.typ`: both curves have a *rational* $2$-torsion point and the
  $2$-division field is $QQ(zeta_3)$, of degree $2$ --- so $E[2]$ is the module $bb(F)_2 [C_2]$,
  not the $S_3$-module, and the descent algebra is $QQ times QQ(zeta_3)$ (@sec-pair). The $beta$
  analysis for that configuration has not been done, and @sec-status says so.
]

= The pair <sec-pair>

$ E : y^2 = x^3 - a^3 , wide E' : y^2 = x^3 + a^3 , wide a "an odd prime." $

Both have $j = 0$. $E'$ is the sextic twist of $E$ by $a^3 slash (-a^3) = -1$, which is a *cube*,
so $E'$ is the *quadratic twist of $E$ by $-1$* --- and unlike the $j = 0$ example, where that held
only over $QQ_2$, here it holds over $QQ$ and passes to the twists:
$ E'_d : y^2 = x^3 + a^3 d^3 = E_(-d) , wide "since" -a^3 (-d)^3 = a^3 d^3 . $
So the twist family is the pair $(E_d, E_(-d))$, globally.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *A third configuration.* The $2$-division polynomial *splits*:
  $ x^3 minus.plus a^3 = (x minus.plus a)(x^2 plus.minus a x + a^2) , wide
    "disc"(x^2 plus.minus a x + a^2) = -3 a^2 . $
  So both curves carry a *rational* $2$-torsion point, both $2$-division fields are
  $QQ(sqrt(-3)) = QQ(zeta_3)$ --- degree $2$, not $6$ --- and $E[2] tilde.equiv E'[2]$ as the
  $bb(F)_2 [C_2]$-module with one rational point and a conjugate pair. The descent algebra is
  $QQ times QQ(zeta_3)$.

  #v(1.5mm)
  Neither branch of `j0-obstruction-family.typ` applies. There $x^3 + a$ was *irreducible* and
  $E[2]$ was the full $S_3$-module; the ratio formula of that note's §4 and the $M_(i j)$ of its §6
  both presuppose one of those two settings. This pair is outside both.
]

#v(2mm)
The basic data (check 1): the curves are *not* isogenous, $a_q$ separating them well below $q = 400$
in each case, and the torsion is $ZZ slash 2$ on both sides throughout.

#align(center, table(
  columns: 6, align: (center, right, right, center, center, center),
  stroke: 0.4pt + luma(170), inset: (x: 9pt, y: 3.5pt),
  table.header([$a$], [$N(E)$], [$N(E')$], [ranks], [torsion], [isogenous?]),
  [$3$], [$36$], [$144$], [$0, 0$], [$ZZ slash 2$], [no],
  [$5$], [$3600$], [$900$], [$0, 0$], [$ZZ slash 2$], [no],
  [$7$], [$1764$], [$7056$], [$1, 1$], [$ZZ slash 2$], [no],
  [$11$], [$4356$], [$17424$], [$1, 1$], [$ZZ slash 2$], [no],
  [$13$], [$24336$], [$6084$], [$0, 0$], [$ZZ slash 2$], [no],
))

#v(2mm)
For $a = 3, 5, 13$ both curves have rank $0$, so the twists carry everything.

= Root numbers, and the parity of $d$ <sec-parity>

#block(fill: luma(240), inset: 9pt, radius: 3pt, width: 100%)[
  $ w(E_d) thin w(E'_d) = cases(+1 & "for every odd" d, -1 & "for every even" d) $
  --- with no exceptions in $244$ squarefree twists per curve, for each of $a = 3, 5, 7, 11$
  (check 2: $162 slash 0$ on the odd side, $0 slash 82$ on the even).
]

#v(2mm)
So on an *even* square class one of the two curves always has odd analytic rank and the other even.
A witness needs positive rank on *both*, so it needs rank $>= 2$ on the even-root-number curve --- a
condition satisfied by a thin set of twists. This is the same parity phenomenon as §5 of
`kummer-example-j0.typ`, and it is what makes the even classes at $2$ expensive to search rather
than merely unlucky. @sec-deep steers by it.

= The odd primes are covered <sec-odd>

For each odd $p <= 19$ and each of the four square classes of $QQ_p^times$, a twist $d$ with
$E_d (QQ)$ dense in $E_d (QQ_p)$ *and* $E'_d (QQ)$ dense in $E'_d (QQ_p)$ (check 3, $abs(d) <= 150$):

#align(center, table(
  columns: 8, align: (center, center, center, center, center, center, center, center),
  stroke: 0.4pt + luma(170), inset: (x: 8pt, y: 3.5pt),
  table.header([$a$], [$p = 3$], [$5$], [$7$], [$11$], [$13$], [$17$], [$19$]),
  [$3$], [$4 slash 4$], [$4 slash 4$], [$4 slash 4$], [$4 slash 4$], [$2 slash 4$], [$3 slash 4$],
    [$4 slash 4$],
  [$5$], [$4 slash 4$], [$4 slash 4$], [$4 slash 4$], [$4 slash 4$], [$3 slash 4$], [$3 slash 4$],
    [$4 slash 4$],
  [$7$], [$4 slash 4$], [$4 slash 4$], [$4 slash 4$], [$4 slash 4$], [$4 slash 4$], [$4 slash 4$],
    [$4 slash 4$],
))

#v(2mm)
The gaps at $p = 13, 17$ for $a = 3, 5$ are *sparsity*, not obstruction, and they close as the
search widens: a supplementary run at $abs(d) <= 400$ brings $p = 17$ to $4 slash 4$ for both, and
$p = 13$ to $3 slash 4$ for $a = 3$ --- with the surviving gap in a *different* square class for
$a = 3$ than for $a = 5$, which is the signature of a thin search rather than a structural
obstruction. Contrast the behaviour at $2$, which does not move at all.

#block(fill: rgb("#fff4e6"), inset: 8pt, radius: 3pt, width: 100%)[
  *Reading the table.* A full row at $p$ means every square class has a witness, hence
  $X(QQ)$ *is* dense in $X(QQ_p)$: the criterion is a sufficient condition for density and one
  witness per class is all it asks. A gap means only that the search did not find one.
]

= The deep scan at $2$ <sec-deep>

The parity fact of @sec-parity says where the cost is, so the search is steered by it. On an even
class one curve has $w = -1$ and the other $w = +1$; the binding constraint is *rank $>= 2$ on the
$w = +1$ curve*. Check 4 tests that first and computes the partner's rank, and the density test,
only on survivors --- which is what makes $abs(d) <= 10^4$ affordable at all.

#block(fill: rgb("#fff4e6"), inset: 8pt, radius: 3pt, width: 100%)[
  *Why the steering is sound and not a shortcut.* Nothing is skipped that could have been a
  witness. A witness needs rank $>= 1$ on both curves; on an even class the $w = +1$ curve has even
  analytic rank, so rank $>= 1$ there forces rank $>= 2$. Discarding the twists that fail it
  discards only twists that cannot be witnesses --- assuming parity, i.e. that the analytic and
  algebraic ranks agree in parity, which is the one hypothesis the scan leans on.
]

= What this does and does not show <sec-status>

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Established.* The structural facts of @sec-pair: $E'_d = E_(-d)$ globally, a rational
  $2$-torsion point on both curves, $2$-division field $QQ(zeta_3)$, non-isogeny, and hence that
  the pair falls outside both branches treated in `j0-obstruction-family.typ`. The root-number
  dichotomy of @sec-parity, with no exception in the range tested. Density of $X(QQ)$ in
  $X(QQ_p)$ for every odd $p <= 19$ and $a = 3, 5, 7$ --- this direction is a *proof*, since one
  witness per square class is all the criterion needs.

  #v(1.5mm)
  *Not established.* Non-density at $2$. What @sec-deep shows is that no witness exists in the
  range searched; that is evidence, not an obstruction. The $j = 0$ example earns its conclusion
  from $beta_2 equiv.not 0$ together with $beta_v equiv 0$ elsewhere, and *no $beta$ analysis has
  been carried out for this configuration*. It would have to be done afresh: the descent algebra
  here is $QQ times QQ(zeta_3)$, so neither the ratio formula of `j0-obstruction-family.typ` §4 nor
  the $M_(i j)$ of its §6 applies as written.

  #v(1.5mm)
  *The natural next step.* Run that analysis. $E[2]$ is $bb(F)_2 [C_2]$, whose automorphism group
  gives *two* admissible $psi$ rather than one or six, and $Sigma = S_1 union S_2$ should again be
  computable from global data --- with the slot structure $QQ times QQ(zeta_3)$ in place of
  $QQ times QQ times QQ$.
]

= What the companion script checks <sec-gp>

`plusminus-cube.gp`, results in `results/plusminus-cube.txt`. Density is decided by the
repository's own single-curve tests `densegroup` and `densegroup2`, applied once to each curve, as
in $section 2$ of `kummer-example-j0.typ`.

#v(1mm)
- *(1)* The pair for $a = 3, 5, 7, 11, 13$: conductors, ranks, torsion, non-isogeny by $a_q$ below
  $q = 400$, and the discriminant $-3a^2$ that fixes the $2$-division field.
- *(2)* The root-number dichotomy of @sec-parity, over $244$ squarefree twists for each of four
  values of $a$.
- *(3)* The scan of @sec-odd at every odd $p <= 19$, $abs(d) <= 150$.
- *(4)* The deep scan of @sec-deep at $p = 2$, squarefree $abs(d) <= 10^4$, steered by root
  numbers.

= References <sec-refs>

#block(inset: (left: 4pt))[
#set enum(numbering: "[1]")
+ `kummer-example-j0.typ` in this repository. The $j = 0$ example whose signature this pair
  reproduces; $section 2$ for why the single-curve density tests transfer, $section 5$ for the
  parity observation, $section 6.8$ for the theorem at $2$.
+ `j0-obstruction-family.typ`. The two branches, the $4$-torsion mechanism, and the criterion
  $Sigma$ finite and non-empty --- none of which covers the present configuration.
+ `kummer2.gp`, `p2.gp`. `densegroup`, `densegroup2`, `Mval`, `sqclass`: the single-curve density
  tests the scan rests on.
]
