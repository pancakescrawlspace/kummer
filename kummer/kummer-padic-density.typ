#set page(paper: "a4", margin: (x: 2.2cm, y: 2.4cm), numbering: "1")
#set text(font: "New Computer Modern", size: 10.5pt)
#set par(justify: true)
#set heading(numbering: "1.")
#show raw.where(block: true): it => block(
  fill: luma(247), inset: 8pt, radius: 3pt, width: 100%, breakable: true,
  text(size: 8pt, it),
)
#show link: set text(fill: blue.darken(20%))

#align(center)[
  #text(size: 16pt, weight: "bold")[
    $p$-adic density of rational points on the Kummer surface
    $y^2 = f(x) f(t)$
  ]
  #v(2mm)
  #text(size: 10pt)[Computational notes --- witnesses for every prime $p <= 200$]
  #v(1mm)
  #text(size: 9pt, style: "italic")[computations in PARI/GP 2.18]
]

#v(4mm)

= Setup and the basic reformulation

Let $f in QQ[x]$ be a cubic with no repeated root, let
$ E : v^2 = f(u) $
and let $X$ be the affine surface $y^2 = f(x) f(t)$. The map
$ ((u_1, v_1), (u_2, v_2)) |-> (x, t, y) = (u_1, u_2, v_1 v_2) $
identifies $X$ with the Kummer surface $(E times E) slash {plus.minus 1}$; resolving the
nine affine nodes $(e_i, e_j, 0)$ (with $f(e_i) = f(e_j) = 0$) gives a K3 surface.
Each exceptional curve is a conic with a rational point, hence a $PP^1$, so density on the
resolution is equivalent to density on $X$.

Because $-1$ acts *diagonally*, a $k$-point of $X$ lifts to a $k$-point of
$E_d times E_d$ for a *single* class $d$, where $E_d : d v^2 = f(u)$ is the quadratic twist.
Thus for any field $k$ of characteristic $!= 2$,
$ X(k) = union.sq.big_(d in k^times slash (k^times)^2) (E_d times E_d)(k) slash plus.minus. $

Concretely, two points $P = (u_1, v_1)$ and $Q = (u_2, v_2)$ on the *same* twist $E_d$ produce
the rational point
$ (x, t, y) = (u_1, u_2, d v_1 v_2) in X. $

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *Remark (the family of usable twists is complete).* A twist $E_d$ has an affine rational
  point $(u_0, v_0)$ exactly when $d$ is the squarefree part of $f(u_0)$. So
  $ {d : E_d (QQ) != {O}} = {"sqfreepart"(f(t_0)) : t_0 in QQ}, $
  which is precisely the family obtained from the canonical point $(t_0, 1) in E_(f(t_0))$.
  Nothing is lost by restricting to it.
]

= The density criterion

Write $H_d = overline(E_d (QQ)) subset.eq E_delta (QQ_p)$ for the closure of the rational points,
where $delta$ is the class of $d$ in $QQ_p^times slash (QQ_p^times)^2$.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Criterion.* $X(QQ)$ is dense in $X(QQ_p)$ if and only if for every
  $delta in QQ_p^times slash (QQ_p^times)^2$ the set
  $ union.big_(d |-> delta) H_d times H_d $
  is dense in $E_delta (QQ_p) times E_delta (QQ_p)$.

  #v(2mm)
  *Sufficient form (what is used below).* If for each $delta$ there exists a single rational
  $d in delta dot (QQ_p^times)^2$ with $E_d (QQ)$ *dense in* $E_d (QQ_p)$, then $X(QQ)$ is dense
  in $X(QQ_p)$.
]

For odd $p$ there are 4 classes, for $p = 2$ there are 8. So the whole problem reduces to
exhibiting 4 (resp. 8) elliptic curves per prime.

_Proof of the sufficient form._ Let $(x_1, t_1, y_1) in X(QQ_p)$ with $y_1 != 0$, and let
$delta$ be the class of $f(x_1)$ (equivalently of $f(t_1)$). Choose $d$ as in the statement and
$c in QQ_p^times$ with $f(t_1) = d c^2$. The target lifts to the pair
$A = (x_1, y_1 c slash f(t_1))$, $B = (t_1, c)$ in $E_d (QQ_p)^2$. Approximate $A, B$ by rational
points $A', B' in E_d (QQ)$; then $(u(A'), u(B'), d v(A') v(B'))$ is a rational point of $X$ close
to $(x_1, t_1, y_1)$. Points with $y_1 = 0$ and the nodes are limits of such points. $qed$

Since $y |-> -y$ is an automorphism of $X$ defined over $QQ$, both sheets over a given $(x, t)$
are reached, so density of the image in the $(x, t)$-plane already suffices.

== Local structure: testing "$Gamma$ dense in $E_d (QQ_p)$"

Work on a *minimal* Weierstrass model. Let $E_n (QQ_p)$ be the standard filtration
($E_1$ = kernel of reduction). Two standard facts:

- $E_1 (QQ_p) tilde.equiv hat(E)(p ZZ_p) tilde.equiv ZZ_p$ for $p >= 3$; at $p = 2$ one must go
  one step down and use $E_2 (QQ_2) tilde.equiv hat(E)(4 ZZ_2) tilde.equiv ZZ_2$.
- $M := \#(E(QQ_p) slash E_1 (QQ_p)) = c_p dot \#tilde(E)^"ns" (bb(F)_p)$, where $c_p$ is the
  Tamagawa number and $\#tilde(E)^"ns" (bb(F)_p) = p + 1 - a_p$ (good reduction) or $p - a_p$
  (bad reduction, with $a_p in {0, plus.minus 1}$ recording additive / split / non-split).

Hence, for a subgroup $Gamma subset.eq E_d (QQ)$:

$ overline(Gamma) = E_d (QQ_p) quad <==> quad
  cases(
    Gamma arrow.r.twohead E(QQ_p) slash E_1 (QQ_p) quad "(index" = M")",
    Gamma inter E_1 subset.eq.not E_2 .
  ) $

The second condition is checked pointwise: for $Q in E_1$ one has $v_p (x(Q)) = -2 n$ where
$n = v_p (z(Q))$ for the formal parameter $z = -x slash y$, so $Q$ topologically generates $E_1$
iff $v_p (x(Q)) = -2$ exactly. Both conditions are finite exact computations.

*Consequence used later.* If $tilde(E)_delta (bb(F)_p)$ is *non-cyclic* then $E_delta (QQ_p)$ is
not procyclic and no single point can generate: a twist of rank $>= 2$ (or with torsion) is
forced. This really happens --- see $p = 47, 67$ in @tab-primes.

= Result

#block(fill: rgb("#eef4ff"), inset: 9pt, radius: 3pt, width: 100%)[
  For
  $ f(x) = x^3 + x + 1 quad (op("disc") f = -31), $
  the rational points of $X : y^2 = f(x) f(t)$ are dense in $X(QQ_p)$ for *every prime
  $p <= 200$*.
]

Here $E : v^2 = u^3 + u + 1$ is the curve *496a*: rank 1, trivial torsion, generator $(0,1)$.
It is non-CM, which matters --- see @sec-remarks.

== The headline case $p = 5$

The four witnesses, one per class of $QQ_5^times slash (QQ_5^times)^2$ ($u$ = a non-residue):

#table(
  columns: (auto, auto, auto, auto, auto, auto),
  align: (center, center, left, left, left, center),
  stroke: 0.4pt + luma(150),
  table.header([*class*], [$d$], [$E_d : Y^2 = X^3 + d^2 X + d^3$], [generator],
               [reduction at 5], [$M$]),
  [$1$],    [$1$],   [$y^2 = x^3 + x + 1$],           [$(0, 1)$], [good, $a_5 = -3$], [9],
  [$u$],    [$3$],   [$y^2 = x^3 + 9x + 27$],         [$(3, 9)$], [good, $a_5 = 3$],  [3],
  [$5$],    [$5$],   [$y^2 = x^3 + 25x + 125$],       [$(4, 17)$], [$I_0^*$, $c = 1$], [5],
  [$5u$],   [$-35$], [$y^2 = x^3 + 1225x - 42875$],
    [$(59004 slash 1369, 15194717 slash 50653)$], [$I_0^*$, $c = 1$], [5],
)

Each twist has rank 1 and trivial torsion, and in each case the single generator topologically
generates $E_d (QQ_5)$. In the $(u, v)$ coordinates on $d v^2 = f(u)$ these correspond to
$t_0 = 0, 1, 4 slash 5, -59004 slash 47915$.

*Sample point.* On $d = 1$, $P = (0,1)$ and $2P = (1 slash 4, -9 slash 8)$, giving
$(x, t, y) = (0, 1 slash 4, -9 slash 8) in X(QQ)$; indeed
$f(0) f(1 slash 4) = 81 slash 64 = y^2$.

== $p = 2$

All eight classes of $QQ_2^times slash (QQ_2^times)^2$ are covered by small twists:

#table(
  columns: 9, align: center, stroke: 0.4pt + luma(150),
  table.header([*class*], [$1$], [$3$], [$5$], [$7$], [$2$], [$6$], [$10$], [$14$]),
  [$d$], [$1$], [$3$], [$5$], [$-1$], [$-30$], [$6$], [$-6$], [$30$],
)

== All primes $p < 200$ <tab-primes>

Witnesses from the pure-descent run with $|d| <= 3000$; the two marked $dagger$ lie beyond that
bound. The hybrid of @sec-strategy finds a full set for all 45 primes in one pass (sometimes
different, equally valid, witnesses).

#let ptab(..rows) = table(
  columns: 5,
  align: right,
  stroke: 0.4pt + luma(170),
  inset: (x: 6pt, y: 3pt),
  table.header([$p$], [$[1]$], [$[u]$], [$[p]$], [$[u p]$]),
  ..rows
)

#set text(size: 8.5pt)
#grid(columns: (auto, auto), column-gutter: 1.2cm, align: top,
  ptab(
    [3],  [7],   [-1],   [3],    [6],
    [5],  [1],   [3],    [5],    [-35],
    [7],  [1],   [-1],   [7],    [-7],
    [11], [3],   [6],    [11],   [-11],
    [13], [-1],  [5],    [-13],  [26],
    [17], [-1],  [7],    [34],   [51],
    [19], [1],   [-1],   [95],   [-95],
    [23], [1],   [-1],   [46],   [115],
    [29], [-1],  [11],   [-29],  [58],
    [31], [1],   [-1],   [31],   [-62],
    [37], [-11], [6],    [-37],  [74],
    [41], [-1],  [3],    [41],   [123],
    [43], [1],   [-1],   [-86],  [86],
    [47], [-11], [-149], [94],   [705],
    [53], [11],  [22],   [53],   [106],
    [59], [1],   [6],    [295],  [-59],
    [61], [1],   [7],    [-61],  [122],
    [67], [-221],[51],   [2211], [134],
    [71], [1],   [-1],   [71],   [-71],
    [73], [3],   [-21],  [146],  [-365],
    [79], [1],   [-1],   [158],  [-158],
    [83], [-22], [-11],  [83],   [166],
    [89], [1],   [-7],   [178],  [-267],
  ),
  ptab(
    [97],  [1],   [7],   [97],    [485],
    [101], [-1],  [3],   [101],   [-2626],
    [103], [1],   [-1],  [103],   [2266],
    [107], [-7],  [-1],  [-1605], [-107],
    [109], [1],   [6],   [109],   [654],
    [113], [1],   [3],   [113],   [339],
    [127], [-6],  [3],   [254],   [-127],
    [131], [53],  [-11], [131],   [8646#super[†]],
    [137], [7],   [3],   [274],   [-411],
    [139], [51],  [3],   [139],   [-139],
    [149], [53],  [94],  [-149],  [13559#super[†]],
    [151], [1],   [-1],  [755],   [453],
    [157], [1],   [5],   [157],   [2355],
    [163], [1],   [-1],  [978],   [815],
    [167], [-13], [-6],  [334],   [-334],
    [173], [51],  [53],  [-173],  [519],
    [179], [1],   [-19], [179],   [-537],
    [181], [1],   [7],   [-181],  [-1086],
    [191], [1],   [-1],  [191],   [-191],
    [193], [1],   [5],   [-193],  [965],
    [197], [-6],  [3],   [197],   [394],
    [199], [-6],  [3],   [199],   [-199],
  ),
)
#set text(size: 10.5pt)

= Verification <sec-verify>

*Unconditional.* The certificate only ever uses *explicit rational points* plus a finite exact
computation. `ellrank` / `ellsaturation` are used to *find* points, but nothing depends on their
rank bounds being sharp: if the exhibited subgroup is dense, so is the full Mordell--Weil group.

*Internal consistency.* The $p$-adic implementation of the density test was validated against a
purely exact-rational reference implementation (1826 cases, 0 mismatches), and the
multi-generator version was validated against the single-generator one.

#block(fill: rgb("#fff4e6"), inset: 8pt, radius: 3pt, width: 100%)[
  *A bug that was found and fixed.* An earlier version of `densegroup` short-circuited with
  `if(rem == 1, break())` as soon as the running index reached $M$. That skipped the remaining
  generators, so they never contributed to the kernel lattice $L$ --- and condition (ii) is
  tested only on a basis of $L$. A twist whose generators were, say, $P_1 in.not E_1$ and
  $P_2 in E_1 without E_2$ (which *is* dense) was therefore reported as *not* dense.

  The bug is *one-sided*: it can only turn a true "dense" into a reported "not dense", never the
  reverse. Every positive result and every witness in this document is therefore unaffected;
  only negative results had to be re-examined. Doing so overturned the claim about
  $f = x^3 - 2$ --- see @sec-cm.
]

*Independent check on $X$ itself.* For each of two regions I enumerated exactly those residue
classes mod $p^k$ that are genuine reductions of points of $X(ZZ_p)$ with $y$ a unit, and
checked that every one is hit by an honest rational point built from the four twists:

#table(
  columns: 4, align: (center, center, center, center), stroke: 0.4pt + luma(150),
  table.header([$p$], [level], [$x, t in ZZ_p$], [$v_p (x) = v_p (t) = -1$]),
  [2], [$2^4$], [256 / 256 ✓],       [64 / 64 ✓],
  [3], [$3^4$], [2916 / 2916 ✓],     [2916 / 2916 ✓],
  [5], [$5^3$], [21250 / 21250 ✓],   [10000 / 10000 ✓],
  [7], [$7^2$], [2842 / 2842 ✓],     [1764 / 1764 ✓],
)

The two regions are needed because for $x, t in ZZ_p$ the value $f(x) f(t)$ only realises the
*unit* square classes; the classes of odd valuation live where $v_p (x) < 0$. The second region
is handled by the substitution $x = x' slash p$, $t = t' slash p$, $y = y' slash p^3$, which
turns the equation into $y'^2 = g(x') g(t')$ with $g(w) = w^3 + A p^2 w + B p^3$ and $x', t'$
units.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *A trap at $p = 2$.* For odd $p$, if $y$ is a unit and $y^2 equiv s space (mod p^k)$ then
  $plus.minus sqrt(s) equiv y space (mod p^k)$, so "all congruence solutions" is the correct
  target set. At $p = 2$ the congruence $y^2 equiv s space (mod 2^k)$ has *four* solutions but
  only two are genuine reductions, so the naive target set is a factor 2 too large and the check
  spuriously reports failure. The table above uses the corrected enumeration (lift $x, t$ mod
  $2^(k+4)$, require $s equiv 1 space (mod 8)$, and record $plus.minus sqrt(s)$).
]

= Remarks and open ends <sec-remarks>

*Rank 1 is not always enough.* As noted in §2.1, non-cyclic $tilde(E)_delta (bb(F)_p)$ forces a
rank-$>= 2$ twist. At $p = 47$ we have $tilde(E)(bb(F)_47) tilde.equiv ZZ slash 30 times ZZ slash 2$
and the class $[1]$ needs $d = -11$ (rank 2); at $p = 67$,
$tilde(E)(bb(F)_67) tilde.equiv ZZ slash 28 times ZZ slash 2$ and $[1]$ needs $d = -221$.

== The CM case $f = x^3 - 2$ <sec-cm>

#block(fill: rgb("#fff4e6"), inset: 8pt, radius: 3pt, width: 100%)[
  *Corrigendum.* An earlier draft claimed that this $j = 0$ curve (CM by $ZZ[zeta_3]$) succeeds
  exactly for $p equiv 2 space (mod 3)$ and fails systematically for $p equiv 1 space (mod 3)$.
  *That was wrong* --- an artifact of testing only single generators from the $t_0$-family,
  compounded by the bug described in §4. It is corrected here.
]

With the full multi-generator search, $f = x^3 - 2$ in fact succeeds for *every* odd prime
$5 <= p <= 97$. The primes $p equiv 1 space (mod 3)$ are simply the ones that *require* a
rank-$2$ twist in the class $[1]$, precisely because CM by $ZZ[zeta_3]$ makes
$tilde(E)(bb(F)_p)$ frequently non-cyclic there (e.g. $tilde(E)(bb(F)_7)$-twist
$tilde.equiv (ZZ slash 3)^2$, $tilde(E)(bb(F)_19) tilde.equiv ZZ slash 9 times ZZ slash 3$,
$tilde(E)(bb(F)_73) tilde.equiv (ZZ slash 9)^2$). Witnesses: $p = 7, 19, 43, 67, 73$ take
$d = -41, -29, -29, -41, -41$. The anomalous prime $p = 61$ (where
$\#tilde(E)(bb(F)_61) = 61 = p$) likewise needs a rank-2 twist, $d = 2931$.

*One genuinely open case: $p = 3$, class $[u dot 3]$.* Here the four classes behave very
differently, and the difference is entirely the Tamagawa number:

#table(
  columns: 5, align: (center, center, center, center, left), stroke: 0.4pt + luma(150),
  table.header([class], [Kodaira], [$c_3$], [$M$], [outcome]),
  [$[1]$],       [$I I$],   [1], [3], [OK, $d = -1115$ (rank 2)],
  [$[u]$],       [$I I$],   [1], [3], [OK, $d = -1$ (rank 1)],
  [$[3]$],       [$I I^*$], [1], [3], [OK, $d = 3$ (rank 1)],
  [$[u dot 3]$], [$I I^*$], [3], [9], [*no witness with $|d| <= 12000$*],
)

In the bad class every twist has $c_3 = 3$ and
$ E_d (QQ_3) slash E_1 tilde.equiv (ZZ slash 3)^2 $
($E_1$ = kernel of reduction, as in §2.1), so *two* independent generators are needed. This was
checked directly on $QQ_3$-points --- all eight non-trivial cosets have order 3 --- rather than
inferred from rational generators, which are exactly the biased sample. Yet across 41 twists of
rank $>= 2$ the achieved index is *always* 3, never 9: the images are invariably dependent. Two
vectors span $bb(F)_3^2$ with probability $48 slash 81$, so 41 independent failures would have
probability of order $0.41^41$.

=== Why exactly the class $[u dot 3]$: a CM mechanism

The non-cyclicity has an exact and entirely elementary explanation. For $y^2 = x^3 + k$,
$ psi_3 (x) = 3x^4 + 12 k x = 3 x (x^3 + 4k). $
The linear factor is the CM signature: $ZZ[zeta_3]$ contains $sqrt(-3)$ of norm 3 with
$(3) = (sqrt(-3))^2$ *ramified*, so $[3]$ factors and every $j = 0$ curve carries a rational
3-isogeny with kernel ${x = 0}$. That one is a red herring here --- for $d = -3$ its dual maps
$E_(d') (QQ_3)$ entirely into $E_1$.

The operative factor is the cubic. In this family $k = -2 d^3$, so $-4k = 8 d^3 = (2d)^3$ is a
*perfect cube*, the quartic splits off a second rational root $x = 2d$, and there is a second
Galois-stable subgroup of order 3, generated by
$ T_d = (2d, sqrt(6 d^3)), quad "defined over" QQ(sqrt(6d)). $
This is why $E[3]$ is decomposable for the whole family, matching the isogeny class ${1,3,9,3}$.

Now $T_d in E_d (QQ_3)$ iff $6 d^3 = 6d dot d^2$ is a square in $QQ_3$, iff $6d$ is. Writing
$d = 3^a m$ with $m$ prime to 3, $6d = 2 dot 3^(a+1) m$ is a square in $QQ_3$ exactly when $a$
is odd and $2m equiv 1 space (mod 3)$, i.e. $m equiv 2 space (mod 3)$ --- which is precisely the
definition of the class $[u dot 3]$.

#table(
  columns: 6, align: (center, center, center, center, center, left), stroke: 0.4pt + luma(150),
  table.header([class], [$6d$ square in $QQ_3$?], [$E_d (QQ_3)_"tors"$], [$c_3$], [$M$],
               [$E_d (QQ_3) slash E_1$]),
  [$[3]$ ($m equiv 1$)],       [no],  [trivial],      [1], [3],
    [$ZZ slash 3$, *procyclic* --- rank 1 suffices],
  [$[u dot 3]$ ($m equiv 2$)], [yes], [$ZZ slash 3$], [3], [9],
    [$(ZZ slash 3)^2$ --- rank $>= 2$ *mandatory*],
)

Verified with no exceptions on all 458 squarefree twists with $|d| <= 1500$ lying in the
two ramified classes (`cm-torsion.gp`). So the Tamagawa jump $c_3 : 1 -> 3$, the doubling
of $M$, and the non-cyclicity all have a single source: an extra $QQ_3$-rational 3-torsion point,
present in that class and in no other. *No Brauer group is needed for any of this.* (The same local picture arises for other curves too --- at $p = 3$, $M = 9$ forces additive reduction with $c_3 = 3$ --- which is what makes the control experiment below possible.)

=== The residual failure, and a control experiment

Only the second half is left: not why two independent generators are *needed*, but why they
never *occur*. First, that the failure is real.

#table(
  columns: 3, align: (left, center, center), stroke: 0.4pt + luma(150),
  table.header([search over class $[u dot 3]$], [twists of rank $>= 2$], [dense]),
  [even root number, $|d| <= 100000$], [708], [*0*],
  [odd root number (rank $>= 3$), $|d| <= 30000$], [5], [*0*],
)

*Not an artifact.* The exhibited generators were audited for 3-saturation (`ellisdivisible` on
all eight non-zero combinations, 40 twists of rank $>= 2$): no non-saturated combination exists.
So the image really is that of $E_d (QQ) slash 3 E_d (QQ)$, not of a proper subgroup.

*Reformulation.* $E_1$ and $3 E_d (QQ_3)$ are both torsion-free of index 9 in $E_d (QQ_3)$, hence
equal. The failure therefore reads: the localisation map
$ E_d (QQ) slash 3 E_d (QQ) --> E_d (QQ_3) slash 3 E_d (QQ_3) tilde.equiv (ZZ slash 3)^2 $
always has image of dimension $<= 1$.

*Three explanations ruled out.* (i) It is not "rational points stay in $E_0$": of 285 generators,
198 hit the component group. (ii) There is no universal functional --- in the canonical basis
$(E_0 slash E_1, ⟨T_d⟩)$ the occupied line ranges over *all four* lines, with multiplicities
$10, 13, 6, 9$. (iii) It is not either 3-isogeny descent: both duals $hat(phi)_1, hat(phi)_2$
were built explicitly (checking $hat(phi)_i compose phi_i = [3]$) and both have local image
*exactly* $E_1$, i.e. trivial in the quotient, so neither cuts out an index-3 subgroup containing
the rational points.

*The control.* At $p = 3$, $M = 9$ forces additive reduction with $c_3 = 3$; other curves have
classes with exactly that local structure, so the phenomenon can be tested against controls.

#table(
  columns: 5, align: (left, center, center, center, center), stroke: 0.4pt + luma(150),
  table.header([curve], [CM?], [$E[3]$], [rank $>= 2$ twists], [dense]),
  [$x^3 - 2$ ($p = 3$)],            [yes], [*decomposable*],  [708], [*0*],
  [$x^3 + 2$],                      [yes], [*decomposable*],  [41],  [*0*],
  [$x^3 plus.minus 3, 5, 6, 7, 11$],[yes], [not decomp.],     [26--35], [6--30],
  [$x^3 plus.minus 3x + 1$, $x^3 plus.minus 6x + 1$], [no], [not decomp.], [26--53], [12--38],
  [$x^3 - 24x plus.minus 26$],      [no],  [*decomposable*],  [43],  [15],
  [$x^3 + 21x plus.minus 26$],      [no],  [*decomposable*],  [36],  [*0*],
  [$x^3 - 2$ at $p = 7$, class $[u]$], [yes], [---],          [25],  [20],
)

Two things follow, and both correct the framing of §5.2.1. *CM is not necessary*: the family
$x^3 + 21x plus.minus 26$ ($j = 9261 slash 8$, no CM) is obstructed exactly like $x^3 - 2$. And
*decomposable $E[3]$ is necessary in every case observed but not sufficient*, since
$x^3 - 24x plus.minus 26$ is decomposable and behaves normally. Decomposability is precisely the
condition $"End"_G (E[3]) supset.eq bb(F)_3 times bb(F)_3 supset.neq bb(F)_3$ feeding the
Skorobogatov--Zarhin description of the odd-order part of $"Br"(overline(X))^G$ for
$X = "Kum"(E times E)$ --- the expected *input* for a 3-torsion class, which need not then exist.
The last row shows there is nothing hard about surjecting onto $(ZZ slash 3)^2$ in general.

*The obstruction is not local.* Comparing the obstructed $x^3 + 21x + 26$ with the
non-obstructed $x^3 - 24x + 26$ on every local invariant at 3: same reduction type, $c_3 = 3$,
$M = 9$, quotient $(ZZ slash 3)^2$; two rational roots of $psi_3$ of which exactly one becomes
$QQ_3$-rational (61 of 61 twists each); trivial rational torsion; isogeny class $\{1, 3, 3\}$;
kernel fields with $chi_1 chi_2 = chi_(-3)$, one ramified at 3. They are *locally
indistinguishable at 3*, yet one family fails systematically and the other does not. No local
condition at 3 can therefore be the explanation: the constraint must involve global input.

That is the signature of a *Brauer--Manin / reciprocity* obstruction, and it eliminates the whole
class of local explanations pursued above. Note that BM *can* obstruct density at a single prime
even when $X(QQ) != nothing$: one needs
$overline(X(QQ))^((p)) subset.eq "pr"_p (X(bb(A))^"Br")$ to be proper, which happens exactly when
some $cal(A) in "Br"(X)$ has $"inv"_v cal(A)$ constant on $X(QQ_v)$ for every $v != p$ and
non-constant at $p$. Descent-with-reciprocity and the transcendental Brauer class are largely two
views of the same mathematics, so these were never really competing explanations.

=== How rare is the obstruction?

That global lead pans out, but the honest conclusion is a finiteness statement rather than a
criterion. Every decomposable family has a twist with a rational 3-torsion *point*, so the
$X_1(3)$ family $y^2 + a_1 x y + a_3 y = x^3$ sees them all up to twist. There
$psi_3 = x (3x^3 + a_1^2 x^2 + 3 a_1 a_3 x + 3 a_3^2)$, and solving the cubic factor for $a_3$
forces $-3(12x + 1)$ to be a square. So the decomposable families are parametrised by a genus-0
curve: with $a_1 = 1$,
$ x = -(w^2 + 3) slash 36, quad quad a_3 = x(-3 plus.minus w) slash 6, quad quad w in QQ. $
There are therefore *infinitely many* decomposable families.

Scanning $|a_1|, |a_3| <= 130$ gives 39 of them, 19 with an $M = 9$ class at $p = 3$ and hence
testable. Writing $j$ in lowest terms, the primes dividing the denominator are exactly the primes
of *potentially multiplicative* reduction --- a twist-invariant notion --- and the outcome splits
on them without exception:

#table(
  columns: 3, align: (left, center, center), stroke: 0.4pt + luma(150),
  table.header([denominator of $j$], [families], [outcome]),
  [$1$ or a power of $2$ --- $j = 0$ and $j = 9261 slash 8$], [2], [*obstructed* (0 dense)],
  [divisible by some $p >= 5$ --- $5, 7, 13, 19, 31, 37, 61, 127$ occur], [17],
    [free (5--30 dense each)],
)

*But the obstructed side is not a small sample --- it is the entire population.* Searching the
genus-0 parametrisation directly over 2 433 532 values of $w$ (all $m slash n$ with
$|m|, n <= 1000$) turns up *exactly two* $j$-invariants whose denominator is a power of 2:
$j = 0$ and $j = 9261 slash 8$. That is what one expects: $j in ZZ[1 slash 2]$ on a genus-0 curve
minus its cusps is a Siegel-type finiteness condition. So on current evidence the obstruction
occurs for exactly two families out of infinitely many, and both have been found.

#block(fill: rgb("#fff4e6"), inset: 8pt, radius: 3pt, width: 100%)[
  *What this does and does not establish.* The negative direction is well supported: 17 of 17
  families having a potentially multiplicative prime $>= 5$ are unobstructed. The positive
  direction is *underdetermined by the data* --- with only two obstructed families in existence,
  any property those two happen to share would fit equally well, and $j = 0$ and
  $j = 9261 slash 8$ share many. "Denominator a power of 2" is singled out here not by the
  statistics but because it is the invariant with the right Brauer--Manin meaning.
]

That meaning: BM localises at a single prime $p$ only when $"inv"_v cal(A)$ is constant on
$X(QQ_v)$ for every $v != p$. Each prime of potentially multiplicative reduction is an extra place
at which the local evaluation can vary, and one such place suffices to let an adelic point be
corrected there, dissolving the obstruction at 3. The two obstructed families are precisely those
with the smallest possible set of bad primes --- potentially good reduction away from
$\{2, 3\}$. Reproduced by `families.gp`.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *Caveats.* The 708-twist figure filters on even root number; the odd-root-number case was
  checked separately only to $|d| <= 30000$. All control counts are at $|d| <= 3000$, so the
  zeros there are far weaker evidence than the one for $x^3 - 2$.
]

*Towards all $p$.* I see no obstruction. The only way a prime could fail is if some square class
$delta$ contained *only* rank-0 twists, which there is no reason to expect. A proof for all $p$
would need a uniform supply of positive-rank twists in prescribed $p$-adic classes with
controlled reduction of the generator. The $t_0$-family is the natural tool, since $t_0$ controls
the class of $d = f(t_0)$ by an open condition; note that the generation condition depends on
$t_0$ only modulo $p^2$ or so, which makes it a genuinely finite check per residue class --- and
therefore potentially provable for a well-chosen $f$.

*A near-necessary condition.* If for some $delta$ every twist in that class had rank 0, all $H_d$
would be uniformly bounded finite groups and density would be extremely implausible (though a
countable union can in principle be dense in $QQ_p^2$, so this is not a formal proof of
necessity).

= Search strategy <sec-strategy>

There are two ways to get rational points on the twists, with very different
costs.

The *$t_0$ sweep* uses the remark of §1: $E_d$ has an affine rational point iff $d$ is the
squarefree part of $f(t_0)$ for some $t_0$, and then $(t_0, 1)$ *is* such a point. Sweeping
$t_0 = a slash b$ and bucketing by squarefree part therefore hands out one generator per twist
for free, and the family is complete. The alternative, *per-twist descent*, runs `ellrank` on
each $E_d$ in turn: it finds generators of any rank, but pays for a 2-descent every time.
Measured on $f = x^3 + x + 1$:

#table(
  columns: 3, align: (left, left, left), stroke: 0.4pt + luma(150),
  table.header([strategy], [throughput], [rank-2 twists produced]),
  [$t_0$ sweep], [91963 twists / 663 ms = *0.007 ms*], [54 of 91963 (0.06%)],
  [per-twist `ellrank`], [366 twists / 833 ms = *2.28 ms*], [all, on demand],
)

So the sweep is some $300 times$ cheaper per twist --- but it almost never yields *two
independent points on one twist*. That needs a collision of squarefree parts, and
$|a|, b <= H$ gives $tilde H^2$ values of $f(t_0)$ spread over a range $tilde H^4$, so
collisions stay negligible (a 7500-point sweep gave 18, a 92000-point sweep gave 54). Rank 1 is
insufficient exactly when $E_delta (QQ_p) slash E_1$ fails to be cyclic.

*The triage.* That condition depends only on $(p, delta)$ and not on the choice of twist within
the class, because all $d$ in one class give $QQ_p$-isomorphic curves. One local computation per
$(p, delta)$ --- four per prime, no point search --- therefore decides the path: procyclic means
the sweep can settle it, otherwise rank $>= 2$ is mandatory and descent is run on twists in that
class only (already a factor 4). The test is exact at good reduction (`ellgroup`) and
conservative at additive primes, so the cheap set is never overstated.

#table(
  columns: 4, align: (left, center, center, left), stroke: 0.4pt + luma(150),
  table.header([$f$], [$(p,delta)$ pairs], [procyclic], [rank $>= 2$ mandatory]),
  [$x^3+x+1$, $p < 200$], [180], [158 (88%)], [22, at $p = 31, 47, 67, 131, 139, 149, 173$],
  [$x^3-2$, $p < 100$],   [96],  [78 (81%)],  [18, at $p = 3, 7, 13, 19, 31, 37, 43, 61, 67, 73, 79, 97$],
)

The second list is exactly ${3}$ together with the primes $p equiv 1 space (mod 3)$; no prime
$equiv 2 space (mod 3)$ occurs. This is the whole explanation of the retracted claim in
@sec-cm: CM by $ZZ[zeta_3]$ is what makes those classes non-procyclic, so a rank-1-only search
appears to fail there. It is a blind spot of the method, not a fact about the surface.

*Result.* The hybrid settles all 45 odd primes below 200 in a single pass in about 5 seconds,
including $p = 131$ and $149$, which the pure-descent path reached only through separate
targeted searches. Of the 180 pairs, 134 are resolved straight from the sweep with no descent
at all.

#pagebreak()

= Appendix: the PARI/GP scripts

Run with `gp -q -s 2000000000 script.gp < /dev/null`.

#block(fill: luma(240), inset: 7pt, radius: 3pt, width: 100%)[
  #text(size: 9pt)[
    Two GP gotchas cost me time and are worth recording: (i) `*/` occurring inside a comment
    (e.g. writing `Qp^*/(Qp^*)^2`) silently terminates the comment; (ii) `my(...)` must be the
    *first* statement of a block, and a `f(x) = ...` definition without braces cannot span
    lines. Also, `default(parisize, N)` in the middle of a script aborts the rest of the file ---
    use the `-s` flag instead.
  ]
]

== `kummer2.gp` --- the criterion

`densegroup(Em, pts, p)` decides whether the subgroup generated by `pts` is dense in
$E_m (QQ_p)$. It does a triangular reduction against the filtration: it finds the successive
orders $m_1, m_2, dots$ of the generators in $E(QQ_p) slash E_1$, so that
$product m_i$ is the index; that must equal $M$. Along the way it records a basis of the kernel
lattice $L = {a in ZZ^r : sum a_i P_i in E_1}$, and finally checks that the homomorphism
$L -> E_1 slash E_2 tilde.equiv bb(F)_p$ is non-zero, i.e. that some basis vector gives a point
with $v_p (x) = -2$.

```
/* ============================================================
   p-adic density of Q-points on X : y^2 = f(x)f(t),  f = x^3+Ax+B
   X = Kum(E x E),  E : v^2 = f(u),  E_d : Y^2 = X^3 + A d^2 X + B d^3
   ============================================================ */

PREC = 100;

sqclass(d, p) = { my(v = valuation(d,p), u = d/p^v); 2*(v%2) + if(kronecker(u,p)==1,0,1); }
sqclassname(k, p) = if(k==0, "1", k==1, "u", k==2, Str(p), Str("u*",p));

/* M = # E(Qp)/E_1(Qp) for a MINIMAL model Em, p odd */
Mval(Em, p) = {
  my(ap = ellap(Em,p), lr = elllocalred(Em,p));
  if(lr[2] == 1, lr[4]*(p+1-ap), lr[4]*(p-ap));
}

padiccurve(Em, p) = {
  ellinit([Em.a1+O(p^PREC), Em.a2+O(p^PREC), Em.a3+O(p^PREC),
           Em.a4+O(p^PREC), Em.a6+O(p^PREC)]);
}

inE1(Q, p) = (Q == [0]) || (valuation(Q[1],p) < 0);

/* Is the subgroup generated by pts dense in Em(Qp)?  (Em minimal, p odd) */
densegroup(Em, pts, p) = {
  my(M, r, Ep, P, S, coefs, basis, idx, rem, dv, mi, bvec, k, kP, Q, S2, C2, jP, cc, b, T);
  M = Mval(Em, p);
  r = #pts;
  if(M == 0 || r == 0, return(0));
  Ep = padiccurve(Em, p);
  P = vector(r, i, [pts[i][1]+O(p^PREC), pts[i][2]+O(p^PREC)]);
  S = [[0]];                       /* coset representatives mod E_1, start with O */
  coefs = [vector(r, j, 0)];       /* their coefficient vectors */
  basis = List();                  /* basis of the kernel lattice L */
  idx = 1;                         /* running index = prod m_i */
  for(i = 1, r,
    rem = M \ idx;                 /* NB: do NOT break when rem==1 -- a generator that
                                      already lies in Gamma_{<i} + E_1 still contributes
                                      a kernel-lattice vector, needed for condition (ii) */
    dv = divisors(rem);            /* m_i must divide the remaining index */
    mi = 0; bvec = 0;
    for(t = 1, #dv,
      k = dv[t];
      kP = ellmul(Ep, P[i], k);
      for(s = 1, #S,
        Q = if(S[s] == [0], kP, elladd(Ep, kP, S[s]));
        if(inE1(Q, p),
          mi = k;
          bvec = coefs[s]; bvec[i] += k;
          break(2)
        )
      )
    );
    if(mi == 0, next);
    listput(basis, bvec);
    S2 = List(); C2 = List();      /* extend the coset reps by multiples of P_i */
    for(j = 0, mi-1,
      jP = if(j == 0, [0], ellmul(Ep, P[i], j));
      for(s = 1, #S,
        Q = if(j == 0, S[s], if(S[s] == [0], jP, elladd(Ep, jP, S[s])));
        cc = coefs[s]; cc[i] += j;
        listput(S2, Q); listput(C2, cc)
      )
    );
    S = Vec(S2); coefs = Vec(C2); idx *= mi
  );
  if(idx != M, return(0));         /* (i) no surjection onto E(Qp)/E_1 */
  for(i = 1, #basis,               /* (ii) some kernel basis vector lands in E_1 \ E_2 */
    b = basis[i]; Q = [0];
    for(j = 1, r,
      if(b[j] != 0,
        T = ellmul(Ep, P[j], b[j]);
        Q = if(Q == [0], T, elladd(Ep, Q, T))
      )
    );
    if(Q != [0] && valuation(Q[1],p) == -2, return(1))
  );
  0;
}

/* generators of a finite-index subgroup of E_d(Q) */
twistdata(A, B, d) = {
  my(Ec, v, Em, R, pts, tors);
  Ec = ellinit([A*d^2, B*d^3]);
  v = 0;
  Em = ellminimalmodel(Ec, &v);
  R = ellrank(Em);
  pts = R[4];
  if(#pts > 0, pts = ellsaturation(Em, pts, 50));
  tors = elltors(Em);
  pts = concat(pts, tors[3]);
  [Em, pts, R[1], R[2]];
}
```

== `driver.gp` --- the search over twists

Implements the hybrid of @sec-strategy: `sweep` buckets $t_0$ by the squarefree part of
$f(t_0)$, `procyclic` triages each $(p, delta)$ with a purely local computation, and `hybrid`
takes the cheap or the expensive path accordingly. The pure-descent functions `build` /
`report`, and the targeted single-class search `hunt`, are retained as a reference path.

```
/* ---------- stage 1: the cheap t_0 sweep ---------------------------- */

/* bucket t_0 = a/b (|a| <= HN, b <= HD) by the squarefree part of f(t_0).
   Returns [Map: d -> vector of t_0, keys sorted by |d|]. */
sweep(A, B, HN, HD) = {
  my(M = Map(), a, b, t0, q, d, keys);
  for(b = 1, HD,
    for(a = -HN, HN,
      if(gcd(a,b) != 1, next);
      t0 = a/b; q = t0^3 + A*t0 + B;
      if(q == 0, next);
      d = sqfreepart(q)[1];
      if(mapisdefined(M,d), mapput(M, d, concat(mapget(M,d), [t0])),
                            mapput(M, d, [t0]))
    )
  );
  keys = Mat(M)[,1];
  keys = vecsort(keys, x -> abs(x));
  [M, keys];
}

/* minimal model of E_d together with the points coming from the swept t_0 */
sweptdata(A, B, d, t0s) = {
  my(Ec, v = 0, Em, pts = List(), t0, c);
  Ec = ellinit([A*d^2, B*d^3]);
  Em = ellminimalmodel(Ec, &v);
  for(i = 1, #t0s,
    t0 = t0s[i];
    c = sqfreepart(t0^3 + A*t0 + B)[2];
    listput(pts, ellchangepoint([d*t0, d^2*c], v))
  );
  [Em, Vec(pts)];
}

/* ---------- stage 2: local triage, no point search ------------------ */

/* Is E_delta(Qp)/E_1 cyclic?  Depends only on (p,target).
   Conservative at additive primes: may return 0 for a cyclic group,
   never 1 for a non-cyclic one, so the "cheap" set is never overstated. */
procyclic(A, B, p, target) = {
  my(d = classrep(A,B,p,target,4000), Ec, v = 0, Em, lr, ns, c);
  if(d == 0, return(0));
  Ec = ellinit([A*d^2, B*d^3]);
  Em = ellminimalmodel(Ec, &v);
  lr = elllocalred(Em, p);
  if(lr[2] == 1, return(#ellgroup(Em,p) == 1));   /* good: G_1 = Etilde(Fp) */
  ns = p - ellap(Em, p); c = lr[4];               /* bad: |G_1| = c_p * ns  */
  gcd(c, ns) == 1 && c <= 3;
}

/* ---------- stage 3: the hybrid search ------------------------------ */

hybrid(A, B, SW, PMAX, TRIES, DMAX) = {
  my(M = SW[1], keys = SW[2], prs = primes([3,PMAX]), good = List(),
     p, k, w, path, nf, i, j, n, sg, d, td, tried, ncheap = 0, ndesc = 0, hit);
  for(j = 1, #prs,
    p = prs[j];
    w = vector(4, i, 0); path = vector(4, i, "");
    for(k = 0, 3,
      hit = 0;
      if(procyclic(A, B, p, k),
        /* --- cheap path: witnesses straight from the sweep --- */
        ncheap++; tried = 0;
        for(i = 1, #keys,
          d = keys[i];
          if(sqclass(d,p) != k, next);
          tried++; if(tried > TRIES, break());
          td = sweptdata(A, B, d, mapget(M,d));
          if(densegroup(td[1], td[2], p),
             w[k+1] = d; path[k+1] = "sweep"; hit = 1; break())
        )
      );
      if(!hit,
        /* --- descent path: only twists in this class --- */
        ndesc++;
        for(n = 1, DMAX,
          if(!issquarefree(n), next);
          for(sg = 0, 1,
            d = if(sg == 0, n, -n);
            if(sqclass(d,p) != k, next);
            td = twistdata(A, B, d);
            if(#td[2] == 0, next);
            if(densegroup(td[1], td[2], p),
               w[k+1] = d; path[k+1] = "descent"; hit = 1; break(2))
          )
        )
      )
    );
    nf = 0; for(k = 1, 4, if(w[k] != 0, nf++));
    /* ... reporting elided ... */
  );
  Vec(good);
}
```

Usage:

```
read("driver.gp");
SW = sweep(1, 1, 1500, 50);         /* 92k twists, each with a free point */
hybrid(1, 1, SW, 200, 60, 20000);   /* 45 / 45 odd primes, ~5 s */
```

== `p2.gp` --- the modifications for $p = 2$

Identical logic, except that the safe procyclic level is $E_2$ rather than $E_1$: hence
$M_2 = 2 c_2 dot \#tilde(E)^"ns"(bb(F)_2)$, membership is $v_2 (x) <= -4$, the final test is
$v_2 (x) = -4$, and there are 8 square classes. `densegroup2` is `densegroup` verbatim with
`Mval` $arrow.r$ `M2val` and `inE1` $arrow.r$ `inE2`.

```
read("kummer2.gp");

/* ---- p = 2 :  E_2(Q_2) = hat E(4 Z_2) is the safe procyclic level ----
   M2 = # E(Q2)/E_2(Q2) = 2 * c_2 * #Ens(F_2).
   Q in E_2  <=>  Q = O  or  v_2(x(Q)) <= -4 ;   generates E_2 <=> v_2(x) = -4. */

sqclass2(d) = {
  my(v = valuation(d,2), u = (d/2^v) % 8);
  if(u < 0, u += 8);
  4*(v%2) + (u-1)/2;
}
sqclass2name(k) = { my(nm = ["1","3","5","7","2","6","10","14"]); nm[k+1]; }

M2val(Em) = {
  my(ap = ellap(Em,2), lr = elllocalred(Em,2));
  2 * if(lr[2] == 1, lr[4]*(3-ap), lr[4]*(2-ap));
}

inE2(Q) = (Q == [0]) || (valuation(Q[1],2) <= -4);

/* densegroup2(Em, pts) == densegroup with Mval -> M2val, inE1 -> inE2,
   and the final test valuation(Q[1],2) == -4 */
```

== `cover2.gp` --- the independent check on $X$

For each of the two regions, build the set of genuine reductions mod $p^k$ (as a
`vectorsmall` bitmap keyed by $x p^(2k) + t p^k + y$), then hammer it with pairs of rational
points drawn from the four twists and count how many distinct targets are reached.

```
/* main loop of coverage(A, B, p, k, ds, NB), p odd */
q = p^k; q2 = q*q; q3 = q2*q;
for(region = 1, 2,
  AA = if(region == 1, A, A*p^2);          /* region 2: x = x'/p, y = y'/p^3 */
  BB = if(region == 1, B, B*p^3);
  tgt = vectorsmall(q3); tot = 0;
  for(x = 0, q-1,
    if(region == 2 && x % p == 0, next);
    for(t = 0, q-1,
      if(region == 2 && t % p == 0, next);
      s = ((x^3 + AA*x + BB) * (t^3 + AA*t + BB)) % q;
      if(s % p == 0, next);
      if(kronecker(s, p) != 1, next);      /* s must be a square in Z_p */
      rr = truncate(sqrt(s + O(p^k))) % q;
      tgt[x*q2 + t*q + rr + 1] = 1; tot++;
      tgt[x*q2 + t*q + (q-rr)%q + 1] = 1; tot++
    )
  );
  hit = vectorsmall(q3); cnt = 0;
  for(i = 1, #ds,
    d = ds[i];
    S = twistpoints(A, B, d, p, NB);       /* rational (u,v) on d v^2 = f(u) */
    allpts = List();
    for(a = 1, #S,
      if(region == 1 && valuation(S[a][1], p) >= 0, listput(allpts, S[a]));
      if(region == 2 && valuation(S[a][1], p) == -1, listput(allpts, S[a]))
    );
    allpts = Vec(allpts);
    for(a = 1, #allpts,
      u1 = allpts[a][1]; v1 = allpts[a][2];
      for(b = 1, #allpts,
        u2 = allpts[b][1]; v2 = allpts[b][2];
        yy = d*v1*v2;                      /* the Kummer point (u1, u2, d v1 v2) */
        if(region == 1, xx = u1; tt = u2, xx = p*u1; tt = p*u2; yy = p^3*yy);
        if(valuation(yy, p) != 0, next);
        x = truncate(xx + O(p^k)) % q;
        t = truncate(tt + O(p^k)) % q;
        y = truncate(yy + O(p^k)) % q;
        key = x*q2 + t*q + y + 1;
        if(tgt[key] && !hit[key], hit[key] = 1; cnt++)
      )
    )
  );
  print("  region ", region, " mod ", p, "^", k, ": targets = ", tot, ", hit = ", cnt)
);
```
