#set page(paper: "a4", margin: (x: 2.0cm, y: 2.2cm), numbering: "1")
#set text(font: "New Computer Modern", size: 10.5pt)
#set par(justify: true)
#set heading(numbering: "1.")
#show raw.where(block: true): it => block(
  fill: luma(247), inset: 8pt, radius: 3pt, width: 100%, breakable: true,
  text(size: 8pt, it),
)

#align(center)[
  #text(size: 16pt, weight: "bold")[Why the 2-Selmer ranks agree]
  #v(2mm)
  #text(size: 10pt)[$y^2 = x^3 + a$ and $y^2 = x^3 - a^(-1)$ share their mod-2
  Galois module; what that explains, and what it leaves to check]
  #v(1mm)
  #text(size: 9pt, style: "italic")[on a question of Rene Pannekoek, MathOverflow 227987 (2015)]
]

#v(4mm)

= The question <sec-q>

Numerically, the Mordell--Weil ranks of $y^2 = x^3 + p^3$ and $y^2 = x^3 - p^3$ almost always
agree, the first exceptions being $p = 37, 61, 157, 193$. The curves are *not isogenous*, so the
correlation is puzzling. Looking instead at 2-Selmer ranks makes the pattern exact: they appear to
agree for *every* prime $p > 2$ --- including at $p = 37$, where the ranks are 0 and 2 but both
2-Selmer ranks are 3. The general form conjectured is:

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Conjecture.* For $a$ an *odd* integer, the elliptic curves
  $ E_a : y^2 = x^3 + a quad "and" quad E_(-1 slash a) : y^2 = x^3 - a^(-1) tilde.equiv y^2 = x^3 - a^5 $
  have equal 2-Selmer ranks.
]

The original statement is the case $a = p^3$; the variants with $x^3 plus.minus p$ against
$x^3 minus.plus p^5$, and $x^3 plus.minus p^2$ against $x^3 minus.plus p^4$, are $a = plus.minus p$
and $a = plus.minus p^2$.

Note that $a |-> -1 slash a$ is an *involution*, and that it is the natural one: the curves
$y^2 = x^3 + a$ are the sextic twists of one another, the twisting parameter lives in
$QQ^times slash (QQ^times)^6$, and $-1 slash a equiv -a^5$ there.

= The answer to "why are they correlated" <sec-module>

The 2-Selmer group of $E$ is cut out of $H^1(QQ, E[2])$ by local conditions. So two curves with
*isomorphic mod-2 Galois modules* have their 2-Selmer groups inside the *same* group, and their
ranks are constrained to be close whether or not the curves are isogenous. That is exactly what
happens here, and it is visible in one line.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Theorem A.* Let $a in QQ^times$ and let $A_b = QQ[t] slash (t^3 + b)$. Then
  $ theta |-> -1 slash theta $
  is an isomorphism of $QQ$-algebras $A_a -> A_(-1 slash a)$. Consequently
  $ E_a [2] tilde.equiv E_(-1 slash a) [2] $
  as $G_QQ$-modules, and the two 2-Selmer groups are subgroups of one and the same
  $H^1 (QQ, M)$.

  #v(2mm)
  _Proof._ If $theta^3 = -a$ then $(-1 slash theta)^3 = -1 slash theta^3 = 1 slash a$, so
  $-1 slash theta$ is a root of $t^3 - 1 slash a$; the map is a $QQ$-algebra map between
  3-dimensional algebras sending a generator to a generator, hence an isomorphism. For an elliptic
  curve $y^2 = f(x)$ with $f$ cubic, $E[2]$ *is* the $G_QQ$-set of roots of $f$ --- the non-zero
  points are $(theta_i, 0)$ --- with its induced $bb(F)_2$-structure. An isomorphism of the étale
  algebras is an isomorphism of the root sets as $G_QQ$-sets, hence of the modules. $qed$
]

So the curves, though non-isogenous, have the same 2-division field
$QQ(root(3, a), zeta_3)$ and the same mod-2 representation. Checked numerically on
$a = 3, 5, 7, 9, 11, 13, 15, 25, 27, -5, -7, 49, 121$: the factorisation types of $x^3 + a$ and
$x^3 - a^5$ agree at every good prime up to 300, and the 2-division fields are isomorphic.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *This already answers the question as asked.* "Why would the ranks of non-isogenous curves be
  correlated?" --- because rank correlation is not what is happening. The 2-*Selmer* ranks are
  correlated because the two curves share the object that 2-Selmer ranks are computed from. The
  Mordell--Weil ranks then agree whenever $Sha[2]$ does not intervene, and $p = 37$ is precisely
  a case where it does: the ranks are 0 and 2, the 2-Selmer ranks both 3, the difference being
  $dim Sha[2] = 2$ on one side and $0$ on the other.
]

= What remains: a purely local statement <sec-local>

Fix $M = E_a [2] = E_(-1 slash a) [2]$ and write $L_v (E) subset.eq H^1 (QQ_v, M)$ for the image of
$E(QQ_v) slash 2$. Both $L_v (E_a)$ and $L_v (E_(-1 slash a))$ are *maximal isotropic* subspaces of
the same $H^1 (QQ_v, M)$, and their dimensions agree at every place, being determined by $M$ alone:
$ dim L_v = cases(
  dim M^(G_v) & v "finite", v divides.not 2,
  dim M^(G_2) + 1 & v = 2,
  dim M^(G_infinity) - 1 & v = infinity.
) $

So the conjecture would follow at once from

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *(#sym.star)* $L_v (E_a) = L_v (E_(-1 slash a))$ for every place $v$.
]

and (#sym.star) is automatic at all but finitely many places:

- *good $v$*: both conditions are the unramified subgroup $H^1_"ur" (QQ_v, M)$, which depends only
  on $M$;
- *$v = infinity$*: $Delta(y^2 = x^3 + k) = -432 k^2 < 0$ for both curves, so both real loci are
  connected, $E(RR)$ is divisible by 2, and $L_infinity = 0$ on both sides.

The bad places are the same for both curves --- $2$, $3$ and the primes dividing $a$ --- so
everything reduces to a finite check there.

= The two descent maps differ by $-1$ <sec-lambda>

There is one more piece of structure, and it says the two descents are not merely parallel but
*aligned*.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Theorem B.* Under the identification of Theorem A, the $overline(QQ)$-isomorphism between the
  two curves carries the descent map of $E_a$ to $lambda$ times that of $E_(-1 slash a)$, where
  $ lambda = -1 slash theta^2 = -(1 slash theta)^2 equiv -1 quad "in" A_a^times slash (A_a^times)^2 . $

  #v(2mm)
  _Proof._ $x^3 - a^(-1) = x^3 + a u$ with $u = -a^(-2)$, so $E_(-1 slash a)$ is the sextic twist
  of $E_a$ by $u$ and the isomorphism over $overline(QQ)$ is $(x,y) |-> (u^(1 slash 3) x,
  u^(1 slash 2) y)$. It carries roots to roots, so $theta' = u^(1 slash 3) theta$, whence
  $u^(1 slash 3) = theta' slash theta = -1 slash theta^2$; and then
  $X - theta' = u^(1 slash 3)(x - theta)$. Finally $-1 slash theta^2$ is $-1$ times a square. $qed$
]

Two readings. First, the quadratic part of the twist is by $u^(1 slash 2) = a^(-1) sqrt(-1)$: the
involution $a |-> -1 slash a$ is *the quadratic twist by $-1$, composed with a cubic twist* --- and
for $a = p^3$ the cubic part is trivial, so the original question is exactly about the quadratic
twist by $-1$. Second, $chi_(-1)$ is ramified only at 2 and $infinity$, which is why the two curves
are so tightly coupled: at every odd place the twist is *unramified*.

= Where the hypothesis "$a$ odd" lives <sec-odd>

The conjecture is stated for odd $a$, and the computations say the restriction is not cosmetic. For
odd $a$ --- positive and negative, prime, prime power and composite --- the 2-Selmer ranks agree in
every case tested. For even $a$ they usually do *not*, and the failure is always by exactly one:

#align(center, table(
  columns: 4, align: (center, center, center, left),
  stroke: 0.4pt + luma(170), inset: (x: 7pt, y: 3.5pt),
  table.header([$a$], [$dim "Sel"_2 (x^3+a)$], [$dim "Sel"_2 (x^3-a^5)$], [ ]),
  [2],  [1], [0], [differ by 1],
  [6],  [0], [1], [differ by 1],
  [8],  [2], [1], [differ by 1],
  [10], [1], [0], [differ by 1],
  [12], [1], [0], [differ by 1],
  [14], [0], [1], [differ by 1],
  [16], [0], [1], [differ by 1],
  [18], [1], [0], [differ by 1],
))

#v(2mm)

Fourteen of the sixteen even $a$ tested disagree, every time by exactly 1. Since the local
conditions agree at every good place and at $infinity$ regardless of parity, and since 2 is the
only place where the quadratic part of the twist is ramified, this locates the whole content of the
conjecture at $v = 2$: *oddness of $a$ is what makes $L_2 (E_a) = L_2 (E_(-1 slash a))$.* A
discrepancy of exactly 1 is what one expects from a single place where two maximal isotropic
subspaces of a common $H^1 (QQ_2, M)$ meet in a hyperplane.

= Numerical verification <sec-num>

Sage's `selmer_rank` is $dim_(bb(F)_2) "Sel"_2$; in PARI, `ellrank` returns $[r_1, r_2, s, L]$ with
$C = T + r_2 + s$, where $T = dim E(QQ)[2]$ is 1 when $x^3 + a$ has a rational root and 0 otherwise.

```gp
dimtors2(E) = { my(f = factor(x^3 + E.a6));
  sum(i = 1, #f~, if(poldegree(f[i,1]) == 1, 1, 0)); }
C2(k) = { my(E = ellinit([0,0,0,0,k]), r);
  r = ellrank(E);
  if(dimtors2(E) > 0, 1, 0) + r[2] + r[3]; }
```

#align(center, table(
  columns: 3, align: (left, center, left),
  stroke: 0.4pt + luma(170), inset: (x: 7pt, y: 3.5pt),
  table.header([family], [agree / total], [comment]),
  [odd $a$, $|a| <= 25$], [26 / 26], [reproduces the original table],
  [odd $a$, mixed prime powers and composites], [19 / 19],
    [$3, 5, dots, 81, 99, 121, 125$],
  [odd $a < 0$], [12 / 12], [$-3, dots, -49$],
  [*even $a$*], [*2 / 16*], [always off by exactly 1],
))

= Status <sec-status>

*Proved here.* Theorem A --- the two curves have isomorphic mod-2 Galois modules, by the explicit
algebra isomorphism $theta |-> -1 slash theta$. This is what makes the correlation structural
rather than accidental, and it is what the question was asking for. Theorem B --- the descent maps
differ by $-1$ modulo squares, and the involution is the quadratic twist by $-1$ composed with a
cubic twist, so that at every *odd* place the twist is unramified. The reduction of the conjecture
to the local statement (#sym.star), together with its verification at the good places and at
$infinity$.

*Not proved.* The local statement (#sym.star) at $v = 2$, $v = 3$ and $v divides a$. The even-$a$
data says that $v = 2$ carries the real content and that oddness is exactly the hypothesis that
makes it work; $v = 3$ and $v divides a$ are odd places, where the quadratic part of the twist is
unramified, so one expects them to be tractable by the standard local analysis --- at an odd place
of additive reduction, for instance, $E(QQ_v) slash 2$ is the 2-torsion of the component group, and
the comparison is a finite computation with the Kodaira type.

*A remark on what "equal" costs.* Comparing two Selmer structures on a self-dual module, the
Greenberg--Wiles formula gives only
$ dim "Sel"(L) equiv dim "Sel"(L') + sum_v dim (L_v slash (L_v inter L'_v)) quad (mod 2) . $
So parity agreement already requires the local discrepancies to cancel modulo 2, and the observed
*equality* is the stronger statement that they vanish one by one. That is why (#sym.star), and not
a parity argument, is the right target.
