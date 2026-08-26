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
  #text(size: 16pt, weight: "bold")[A $j = 0$ non-diagonal example]
  #v(2mm)
  #text(size: 10pt)[$"Kum"(E times E')$ for $y^2 = x^3 + 9$ and $v^2 = u^3 - 81$:
  the scan at $p = 2, 3, 5, 7$, and why $p = 2$ almost never works]
  #v(1mm)
  #text(size: 9pt, style: "italic")[computed in `kummer-example-j0.gp`, on top of the repository's
  own `kummer2.gp` and `p2.gp`; companion to `kummer-example-p13.typ`]
]

#v(4mm)

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *Summary.* At $p = 3, 5$ a single twist covers every square class; at $p = 7$ three classes of
  four. At $p = 2$ only *one* class of eight has a witness, and the reason is structural rather
  than a shortage of search: $E_d (QQ_2)$ always has a $2$-torsion point while $E_d (QQ)$ never
  does, so a rank-$1$ twist has *procyclic* closure and can never be dense. At $p = 2$ density
  needs rank $>= 2$ *on both curves at once*, which happens for one $d$ in the range. That same
  non-procyclicity means the single-twist criterion is not necessary at $2$, so the seven empty
  classes are not proof of non-density.
]

= The pair <sec-pair>

$ E : y^2 = x^3 + 9, quad N_E = 972 = 2^2 dot 3^5 ; wide
  E' : v^2 = u^3 - 81, quad N_(E') = 3888 = 2^4 dot 3^5 . $

Both have $j = 0$, so both have CM by $ZZ[zeta_3]$. Ranks are $1$ and $1$; torsion is
$ZZ slash 3$ (the points $(0, plus.minus 3)$) and trivial. They are *not* isogenous --- $a_q$
differs over $ZZ$ at $42$ of the $93$ good primes below $500$ --- and $E'$ is not a quadratic
twist of $E$, since $E_d : y^2 = x^3 + 9 d^3$ would need $9 d^3 = -81$, i.e. $d^3 = -9$.

The twist families are
$ E_d : y^2 = x^3 + 9 d^3 , wide E'_d : y^2 = x^3 - 81 d^3 , $
and a search over squarefree $|d| <= 150$ gives *$77$* twists with both ranks positive.

Reduction is bad at $2$ and $3$ for both: at $2$, type $I V$ with $c_2 = 3$ for $E$ and type $I I$
with $c_2 = 1$ for $E'$; at $3$, type $I V$ with $c_3 = 3$ and type $I V^ast$ with $c_3 = 1$.

= Method, and why the repository's tests apply <sec-method>

The scan is run with `densegroup` and `densegroup2` from `kummer2.gp` and `p2.gp`. Those were
written for the diagonal problem, so it is worth saying why they transfer.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *They are single-curve tests.* `densegroup(Em, pts, p)` takes one minimal model and a set of
  points and decides whether $⟨"pts"⟩$ is dense in $E_m (QQ_p)$; `Mval` computes
  $\#E(QQ_p) slash E_1$ from $a_p$, the Kodaira type and $c_p$; `sqclass` is a statement about
  $d$ alone. Nothing in any of them refers to a second curve. What is diagonal-specific is
  `driver.gp`, which applies the test *once per class to one twist family*. Off the diagonal one
  applies the same test *twice*, to $E_d$ and to $E'_d$ separately --- which is exactly the
  single-twist form of the criterion.
]

That reasoning was checked rather than trusted. An independent density test was written from
scratch and compared with `densegroup` on $126$ (curve, $p$) pairs at $p = 5, 7, 11, 13$.

#block(fill: rgb("#fff4e6"), inset: 8pt, radius: 3pt, width: 100%)[
  *The first attempt disagreed twice, and the repository was right.* The naive test --- "some
  generator $P$ has $v_p (x(M P)) = -2$" --- is *wrong* when $p divides \#tilde(E)(bb(F)_p)$. For
  $d = 10$ and $d = -30$ at $p = 7$ one has $\#tilde(E)(bb(F)_7) = 7$, so $E(QQ_7) tilde.equiv ZZ_7$
  with $E_1 = 7 ZZ_7$ *one level deeper* than the shortcut assumes, and a generator can be
  outside $E_1$ while $7P$ sits in $E_2$. Rewritten to follow $section 2.2$ of the main notes
  literally --- $Gamma$ onto $E(QQ_p) slash E_1$, *and* $Gamma inter E_1 subset.eq.not E_2$
  checked by enumerating combinations rather than single generators --- the two tests agree on
  all $126$ pairs, four of which have $p divides M$.
]

= The two factors really are independent <sec-indep>

The sufficient form needs the pair $(P, P')$ to range over a *product*. It does:
$(E_d times E'_d)(QQ) = E_d (QQ) times E'_d (QQ)$, with no constraint linking the factors, and
closure commutes with products, $overline(A times B) = overline(A) times overline(B)$. Checked
directly: for nine values of $d$, all $144$ cross pairs $(P, P')$ formed independently from
multiples of the generators on each side satisfy
$ y^2 = (x^3 + 9)(t^3 - 81), quad (x, t, y) = (u, s, d v w) , $
none failing. Correlation between the two factors is a real issue for the *union* form of the
criterion --- several deficient twists conspiring --- but not for the single-twist form.

= The scan <sec-scan>

For each prime and each square class, the first $d$ found with $E_d (QQ)$ dense in $E_d (QQ_p)$
*and* $E'_d (QQ)$ dense in $E'_d (QQ_p)$:

#v(2mm)
#align(center)[
#table(columns: 5, align: (center, left, left, left, left), stroke: 0.4pt + luma(170),
  inset: (x: 9pt, y: 4pt),
  table.header([$p$], [class], [class], [class], [class]),
  [$3$], [$[1]$: $d = 1$],  [$[u]$: $d = 2$],    [$[3]$: $d = -6$],  [$[u 3]$: $d = -3$],
  [$5$], [$[1]$: $d = 1$],  [$[u]$: $d = 47$],   [$[5]$: $d = -5$],  [$[u 5]$: $d = 15$],
  [$7$], [$[1]$: $d = 22$], [$[u]$: $d = -30$],  [$[7]$: *none*],    [$[u 7]$: $d = -7$],
)]

#v(2mm)

So $p = 3$ and $p = 5$ are settled outright: one twist per class, hence $X(QQ)$ dense in
$X(QQ_p)$. At $p = 7$ the class $[7]$ found nothing in the range.

$p = 2$ is the interesting case. Of the $77$ twists, spread over eight classes:

#v(2mm)
#align(center)[
#table(columns: 5, align: (center, right, right, right, right), stroke: 0.4pt + luma(170),
  inset: (x: 9pt, y: 3pt),
  table.header([class], [twists], [$E_d$ dense], [$E'_d$ dense], [*both*]),
  [$[1]$],  [$14$], [$0$], [$0$], [$0$],
  [$[3]$],  [$18$], [$1$], [$1$], [*$1$*],
  [$[5]$],  [$15$], [$0$], [$0$], [$0$],
  [$[7]$],  [$16$], [$0$], [$0$], [$0$],
  [$[2]$],  [$5$],  [$3$], [$2$], [$0$],
  [$[6]$],  [$3$],  [$2$], [$1$], [$0$],
  [$[10]$], [$3$],  [$2$], [$1$], [$0$],
  [$[14]$], [$3$],  [$3$], [$0$], [$0$],
)]

#v(2mm)

One witness in eight classes: $d = -61$, in class $[3]$.

= Why $p = 2$ is so hard here <sec-why2>

The emptiness is not a shortage of search. It has a proof.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *At $p = 2$, no twist of rank $1$ can be dense.*

  #v(2mm)
  _Proof._ A $2$-torsion point of $E_d$ has $x^3 = -9 d^3$, so it is $QQ_2$-rational exactly when
  $-9 d^3$ is a cube in $QQ_2$. An element of $QQ_2^times$ is a cube if and only if its valuation
  is divisible by $3$ --- cubing is bijective on $ZZ slash 2 times ZZ_2$ and is multiplication by
  $3$ on the value group --- and $v_2 (-9 d^3) = 3 v_2 (d)$. So *every* twist acquires a
  $2$-torsion point over $QQ_2$, and the same holds for $E'_d$ with $81 d^3$. Hence
  $E_d (QQ_2) tilde.equiv ZZ_2 times T$ with $2 divides |T|$, which needs *two* topological
  generators.

  #v(1.5mm)
  Over $QQ$, by contrast, $-9$ is not a cube, so $E_d (QQ)$ never has $2$-torsion; its torsion is
  $ZZ slash 3$ or trivial. A group $ZZ xor ZZ slash 3$ or $ZZ$ has *procyclic* closure, which
  cannot be all of a non-procyclic $E_d (QQ_2)$. $qed$
]

Checked on $30$ twisted curves: all have a $QQ_2$-rational $2$-torsion point. And across the
twists inspected, *every* one that `densegroup2` reports dense has rank $>= 2$, with no
exceptions --- exactly as the proposition requires.

So at $p = 2$ the single-twist condition demands rank $>= 2$ on *both* curves in the same square
class. In $|d| <= 150$ that happens once, at $d = -61$, where $E_(-61)$ and $E'_(-61)$ both have
rank $2$.

= What this does and does not prove <sec-status>

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *Proved.* $X(QQ)$ is dense in $X(QQ_3)$ and in $X(QQ_5)$ --- a single twist in each of the four
  classes. The class $[3]$ at $p = 2$ is likewise settled by $d = -61$.

  #v(1.5mm)
  *Not proved.* That the seven empty classes at $p = 2$, or $[7]$ at $p = 7$, fail. Because
  $E_delta (QQ_2)$ is *not procyclic* --- the very $2$-torsion that makes @sec-why2 work --- the
  single-twist form is not necessary at $2$ ($section 2.1.1$ of the main notes), so a union of
  several deficient twists could still cover. That union question is precisely where the
  correlation between the two factors matters, and it is untouched here.

  #v(1.5mm)
  *Search-limited.* All statements are for squarefree $|d| <= 150$. A rank-$2$ pair in another
  class may simply lie further out.
]
