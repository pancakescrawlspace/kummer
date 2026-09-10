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
  #text(size: 16pt, weight: "bold")[Ш of $y^2 = x^3 - p x$ at the Fermat primes]
  #v(2mm)
  #text(size: 10pt)[The minus family has no Ш at all --- and the rank that replaces it
  is visible by hand]
  #v(1mm)
  #text(size: 9pt, style: "italic")[companion to `sha-fermat.typ`, which treats $+ p x$ and is
  the family actually asked about; checks in `sha-fermat-minus.gp`]
]

#v(4mm)

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *The answer.* For $p = F_k = 2^(2^k) + 1$ a Fermat prime, the curve $y^2 = x^3 - p x$ has
  $ "rank" = cases(1 & k = 1, 2 & k = 2, 3, 4) , quad quad Ш = 0 quad "in every case." $
  So the exponent of Ш is $1$: there is nothing there. That is the exact opposite of the sister
  family $y^2 = x^3 + p x$, where the rank is $0$ and
  $Ш tilde.equiv (ZZ slash 2^(k-1))^2$ grows (`sha-fermat.typ`).

  #v(2mm)
  And the rank is not mysterious. Write $p = m^2 + 1$ with $m = 2^(2^(k-1))$ --- which is what a
  Fermat prime *is*. Then
  $ (-1, space m) quad "and" quad (-m, space sqrt(m)) $
  both lie on $y^2 = x^3 - p x$, the first always, the second exactly when $m$ is a square, i.e.
  when $2^(k-1)$ is even, i.e. when $k >= 2$. *That is the whole rank pattern*, and it is why
  $k = 1$ is the exception.
]

= Why this family <sec-origin>

MathOverflow 151396 asks about the exponent of Ш for $y^2 = x^3 + p x$ --- the *plus* family, the
one `sha-fermat.typ` treats. This note is about the minus family, which is not what was asked
there.

#block(fill: rgb("#fff4e6"), inset: 8pt, radius: 3pt, width: 100%)[
  *Recorded because it was an error.* The first version of this note claimed to be about the family
  of MathOverflow 151396. It is not: the URL slug renders both signs as `x3-px`, and the sign was
  guessed wrong. The saved page's title is $y^2 = x^3 + p x$.
]

What survives is the contrast, which is worth having on its own: the same primes, the same CM by
$ZZ[i]$, a quartic twist apart, and completely opposite behaviour --- all the arithmetic in Ш on
one side, all of it in $E(QQ)$ on the other.

= The two points <sec-points>

A Fermat prime is by definition $p = 2^(2^k) + 1$, so with $m := 2^(2^(k-1))$,
$ p = m^2 + 1 . $
Two points then drop out of the equation $y^2 = x^3 - p x = x(x^2 - p)$:

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *At $x = -1$:* $y^2 = -1 + p = m^2$, so $P_1 = (-1, space m)$. This needs only $p = m^2 + 1$,
  so it is there for *every* $k$.

  #v(2mm)
  *At $x = -m$:* $y^2 = -m^3 + p m = m(p - m^2) = m$, so $P_2 = (-m, space sqrt(m))$ --- rational
  exactly when $m = 2^(2^(k-1))$ is a perfect square, i.e. when the exponent $2^(k-1)$ is even,
  i.e. when $k >= 2$.
]

#align(center, table(
  columns: 5, align: (center, center, center, left, center),
  stroke: 0.4pt + luma(170), inset: (x: 8pt, y: 3.5pt),
  table.header([$k$], [$p = F_k$], [$m$], [points], [rank]),
  [$1$], [$5$], [$2$], [$(-1,2)$ only --- $2$ is not a square], [$1$],
  [$2$], [$17$], [$4$], [$(-1,4)$, $(-4,2)$], [$2$],
  [$3$], [$257$], [$16$], [$(-1,16)$, $(-16,4)$], [$2$],
  [$4$], [$65537$], [$256$], [$(-1,256)$, $(-256,16)$], [$2$],
))

#v(2mm)
Those are exactly the generators `ellrank` returns, after saturation --- so the two hand-written
points generate the full Mordell--Weil group modulo torsion, not merely a finite-index subgroup
(@sec-gp, checks 2 and 3).

= Ш is trivial <sec-sha>

Computing the BSD ratio
$ Ш_"an" = (L^((r))(1) slash r!) dot \#E(QQ)_"tors"^2 slash (Omega dot "Reg" dot product_v c_v) $
gives $1$ at $p = 5, 17, 257, 65537$. The contrast with the plus family, on the same primes:

#align(center, table(
  columns: 5, align: (center, center, center, center, center),
  stroke: 0.4pt + luma(170), inset: (x: 8pt, y: 4pt),
  table.header([$p$], [$y^2 = x^3 + p x$: rank], [Ш], [$y^2 = x^3 - p x$: rank], [Ш]),
  [$5$], [$1$], [$0$], [$1$], [$0$],
  [$17$], [$0$], [$(ZZ slash 2)^2$], [$2$], [$0$],
  [$257$], [$0$], [$(ZZ slash 4)^2$], [$2$], [$0$],
  [$65537$], [$0$], [$(ZZ slash 8)^2$], [$2$], [$0$],
))

#v(2mm)
Both curves have root number $+1$ for $k >= 2$ and $-1$ for $k = 1$, so both have even analytic
rank in the first case and odd in the second --- the parity is the same, and it is the *placement*
of the resulting classes that differs. In the plus family the $2$-Selmer group is
$(ZZ slash 2)^3$ (`sha-fermat.typ` §2) with rank $0$, so all of it is Ш; in the minus family the
same size of Selmer group is accounted for by actual points, and nothing is left over.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *The two curves are quartic twists of each other.* For $y^2 = x^3 + d x$ the twist by $u$ is
  $y^2 = x^3 + d u^2 x$, so passing from $+p$ to $-p$ needs $u^2 = -1$: they become isomorphic over
  $QQ(i)$, not over $QQ$. Both have CM by $ZZ[i]$. So the question "why does the same Selmer group
  land in Ш on one side and in $E(QQ)$ on the other" is a question about a quartic twist, which is
  exactly the sort of thing the $L$-value of `sha-fermat.typ` §3 is measuring.
]

= What is actually explained, and what is not <sec-status>

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Explained.* Why the rank is $2$ for $k >= 2$ and $1$ for $k = 1$: the two points of
  @sec-points, and the squareness of $m$. This is elementary and needs no BSD --- it gives
  rank $>= 2$ unconditionally, and the analytic rank being $2$ then pins it.

  #v(2mm)
  *Computed, not explained.* That Ш is trivial for $k = 1, 2, 3, 4$. Four data points, from an
  analytic BSD ratio; and there are only five Fermat primes known, so "for all Fermat primes" is
  a statement about at most one further curve unless new ones are found. The pattern
  $Ш = (ZZ slash 2^(k-1))^2$ on the plus side is a genuine growing pattern; the triviality here is
  not obviously a pattern at all, just repeated absence.

  #v(2mm)
  *Not addressed.* Whether the rank is exactly $2$ for every Fermat prime (this needs $L''(1) != 0$,
  computed here case by case), and whether the two families' behaviour can be related directly by
  the quartic twist rather than case by case.
]

= What the companion script checks <sec-gp>

`sha-fermat-minus.gp`, results in `results/sha-fermat-minus.txt`.

#v(1mm)
- *(1)* The BSD ratio, calibrated against six curves of known Ш --- ranks $0$, $1$, $2$ and one
  curve with $Ш = 4$ --- all exact.
- *(2)* The two points of @sec-points really lie on the curve, and the second is rational exactly
  for $k >= 2$.
- *(3)* The table of @sec-sha: both families, rank, root number and Ш.

#block(fill: rgb("#fff4e6"), inset: 8pt, radius: 3pt, width: 100%)[
  *Three PARI conventions, each of which was got wrong on the first attempt, and each of which
  check 1 exists to pin down.* `ellanalyticrank` returns $L^((r))(1)$ and *not* $L^((r))(1) slash
  r!$, which is invisible below rank $2$ and a factor $2$ at rank $2$. `ellrank` returns generators
  that need *not* be saturated --- on `37a1` they have index $3$, inflating the regulator by $9$.
  And `E.omega[1]` is already the full real period; doubling it for $"disc" > 0$ is wrong. Without
  the controls, the first run of this computation reported $Ш = 2$ for the minus family, which is
  impossible: the Cassels--Tate pairing is alternating, so $|Ш|$ is a square.
]

= References <sec-refs>

#block(inset: (left: 4pt))[
#set enum(numbering: "[1]")
+ `sha-fermat.typ` in this repository --- the plus family, where the shape
  $(ZZ slash 2^(k-1))^2$ is forced and the size is one $L$-value.
+ #link("https://mathoverflow.net/questions/151396/")[MathOverflow 151396], "The exponent of Ш of
  $y^2 = x^3 + p x$, where $p$ is a Fermat prime" --- the *plus* family, and the origin of
  `sha-fermat.typ`. See @sec-origin.
+ `mersenne-fermat-class.typ` in this repository --- Lemmermeyer's comment on that same thread,
  about class groups at Mersenne and Fermat discriminants.
+ J. H. Silverman, *The Arithmetic of Elliptic Curves*, 2nd ed., GTM 106, X.6 for the $2$-descent
  on $y^2 = x^3 + d x$ used by both notes, and X.4 for the Cassels--Tate pairing being alternating
  --- the fact that catches the error recorded in @sec-gp.
]
