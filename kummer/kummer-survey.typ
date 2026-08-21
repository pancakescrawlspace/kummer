#set page(paper: "a4", margin: (x: 2.0cm, y: 2.2cm), numbering: "1")
#set text(font: "New Computer Modern", size: 10.5pt)
#set par(justify: true)
#set heading(numbering: "1.")
#show raw.where(block: true): it => block(
  fill: luma(247), inset: 8pt, radius: 3pt, width: 100%, breakable: true,
  text(size: 8pt, it),
)
#show link: set text(fill: blue.darken(20%))

#import "survey-tables.typ": idtable, summarytable, p2table, failtable, primetables
#import "survey-tables-cm.typ": cmtable, cmfailtable, sextictable, quartictable, cmprimetables

#align(center)[
  #text(size: 16pt, weight: "bold")[
    A survey of the Kummer surfaces $y^2 = f(x) f(t)$
  ]
  #v(2mm)
  #text(size: 10pt)[$p$-adic density for every $p <= 200$: the thirty
  smallest-conductor surfaces, and the surfaces with complex multiplication]
  #v(1mm)
  #text(size: 9pt, style: "italic")[
    companion to _$p$-adic density of rational points on the Kummer surface
    $y^2 = f(x) f(t)$_; computations in PARI/GP 2.18, curve list from Sage's
    Cremona database]
]

#v(4mm)

The companion notes settle two surfaces: $f = x^3 + x + 1$ (dense at every
$p <= 200$) and $f = x^3 - 2$ (dense except at one square class at $p = 3$).
This document runs the same test over two deliberately chosen batches: the
thirty smallest surfaces, in the sense made precise in @sec-which (@sec-result),
and then all the surfaces with complex multiplication (@sec-cm).

= Which surfaces, and why <sec-which>

== The surface sees $f$ only up to $f |-> c^(-3) f(c x + mu)$

Let $f$ be a monic cubic with distinct roots and $X_f : y^2 = f(x) f(t)$. For
$c in QQ^times$ and $mu in QQ$ put $h(x) = c^(-3) f(c x + mu)$, again a monic
cubic. Substituting $x = c X + mu$, $t = c T + mu$, $y = c^3 Y$ turns
$y^2 = f(x) f(t)$ into $Y^2 = h(X) h(T)$, so
$ X_f tilde.equiv X_h quad "for every" c in QQ^times, mu in QQ. $
Taking $c = 1$ shows the $x^2$-coefficient is not seen; taking $mu = 0$ and $c$
non-square shows that $E : v^2 = f(u)$ and its quadratic twist $E_c$ give the
*same* surface --- which is just the decomposition
$X(k) = union.sq_d (E_d times E_d)(k) slash plus.minus$ of the companion notes
read backwards. Hence

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *The surfaces $X$ are in bijection with elliptic curves over $QQ$ taken up to
  quadratic twist.* The natural invariant to order them by is therefore
  $N_min$, the conductor of the minimal quadratic twist --- not the conductor
  of whichever model of $f$ one happens to write down.
]

== Monic cubics, not depressed ones <sec-monic>

The scripts of the companion notes hard-code the depressed form
$f = x^3 + A x + B$. Nothing in the construction needs it: for
$f = x^3 + a x^2 + b x + c$, multiplying $E_d : d v^2 = f(u)$ by $d^3$ and
putting $(U, Y) = (d u, d^2 v)$ gives
$ E_d : Y^2 = U^3 + a d U^2 + b d^2 U + c d^3, $
and a rational $t_0$ with $f(t_0) = d gamma^2$ still yields the point
$(d t_0, d^2 gamma)$ --- the same two lines as before, with one extra
coefficient carried along.

Insisting on the depressed form is expensive. Removing the $x^2$-term is the
shift $x |-> x - a slash 3$, whose denominators are cleared by $c = 1 slash 3$,
so the coefficients grow by $3^4$ and $3^6$. For the curve *11a2* this is the
difference between
$ f = x^3 - 14 x^2 - 31216 x - 1983614 quad "and" quad
  f = x^3 - 281532 x + 57496282, $
and it is what makes ordering by conductor look impractical: it is an artefact
of the model, not of the curve. `survey.gp` therefore carries the cubic as
$F = [a, b, c]$ throughout. Everything downstream --- `densegroup`, `Mval`,
`sqclass`, `densegroup2` --- acts on a minimal model and is untouched.

Each surface then has a small canonical representative: starting from the
minimal Weierstrass model, $f = x^3 + b_2 x^2 + 8 b_4 x + 16 b_6$, reduced by
$f |-> q^(-3) f(q x + mu)$ for as long as the result stays integral, and
finally translated to make the $x^2$-coefficient small.

== The list

Sage's Cremona database gives every curve of conductor $<= 9999$; grouping them
by quadratic twist class (equivalently: deduplicating on the reduced depressed
pair, which _is_ unique per surface) and sorting by $N_min$ gives a complete
list of surfaces. Taken here:

- *all 28 surfaces with $N_min <= 20$* --- conductors $11, 14, 15, 17, 19, 20$,
  contributing $3, 6, 8, 4, 3, 4$ surfaces respectively. Isogenous curves are
  _not_ quadratic twists, so one isogeny class contributes several distinct
  surfaces; the list is complete, not thinned.
- *two controls*: `27a1`, which is exactly $f = x^3 - 2$ of the companion notes,
  and `496a`, which is exactly $f = x^3 + x + 1$. Both are outside the
  $N_min <= 20$ range and are included to check the machinery against known
  answers.

That both of the companion notes' surfaces reappear on the nose --- the
reduction of `27a1` returns the cubic $x^3 - 2$ itself --- is the first sanity
check on the whole set-up.

== A caveat on class labels <sec-labels>

The four square classes of $QQ_p^times slash (QQ_p^times)^2$ are labelled
relative to a chosen $f$. Passing from $f$ to $h = c^(-3) f(c x + mu)$
multiplies the twist parameter $d$ by $c$, so the labelling is permuted by
multiplication by the class of $c$. Concretely, `11a3` in the monic model
$x^3 + x^2 - x + 1$ and in the depressed model $x^3 - 12x + 38$ differ by
$c = 1 slash 3$, and since $(3 slash 103) = -1$ the classes $[1]$ and $[u]$,
and $[103]$ and $[u dot 103]$, are interchanged between the two. Every table
below is stated for the monic model printed alongside it. @sec-verify turns
this into a test.

= The method, and the one change to it <sec-method>

The criterion, the local test, and the two-stage search ($t_0$ sweep, then
per-twist descent where $E_delta (QQ_p)$ is not procyclic) are exactly those of
the companion notes, §2 and §6. One thing had to change.

== Enumerate by cofactor, not by $|d|$ <sec-cofactor>

The classes $[p]$ and $[u p]$ force $p | d$. A search bounded by $|d| <= D$
therefore offers them about $D slash p$ candidates against about $D slash 2$
for $[1]$ and $[u]$ --- a $100 : 1$ starvation at $p = 103$. This is the same
effect the companion notes diagnose for $S$-adic tuples (§2.2), now at a
single place. Writing
$ d = plus.minus P dot m, quad P = cases(p "for" [p]", " [u p], 1 "for" [1]", " [u]),
  quad m "squarefree, " gcd(m, p) = 1 $
and bounding the *cofactor* $m$ gives all four classes the same supply.

It is not a cosmetic change. Under the old bound `11a3` reports $44 slash 45$,
missing one class at $p = 103$, and the shortfall looks like an obstruction; under
the cofactor bound the same run reports $45 slash 45$. The same enumeration is
used at $p = 2$, with $P = 2$ for the four even classes.

= Result: the smallest surfaces <sec-result>

#block(fill: rgb("#eef4ff"), inset: 9pt, radius: 3pt, width: 100%)[
  Of the $30 times 45 times 4 = 5400$ pairs (odd prime, square class) tested,
  *5392 carry a witness*. The eight that do not are listed in @sec-fail; they
  affect eight distinct surfaces, each at exactly one prime, and that prime
  always divides the conductor. Twenty-two of the thirty surfaces are witnessed
  at *every odd* prime $p <= 200$, and at $p = 2$ 239 of the 240 square classes
  are witnessed --- so *twenty-one* surfaces are witnessed at every prime
  $p <= 200$, the odd one out being `17a4`.
]

== The surfaces

$N_min$ is the conductor of the minimal quadratic twist, $N$ that of the model
shown; $r$ and $T$ are the rank and the torsion order of $E : v^2 = f(u)$;
$n_QQ$ and $n_(QQ_2)$ are the numbers of roots of $f$ in $QQ$ and in $QQ_2$
(equivalently $dim E[2](QQ)$ and $dim E[2](QQ_2)$ are $0, 1, 2$ as these are
$0, 1, 3$). $n_(QQ_2) = 3$ is the case where the criterion at $p = 2$ stops
being an equivalence.

#set text(size: 8.5pt)
#idtable
#set text(size: 10.5pt)

All 28 curves in the $N_min <= 20$ range have rank $0$, as does the control
`27a1`: at these conductors $E(QQ)$ itself contributes nothing, and every
point on $X$ comes from a twist.

== Summary, with timings <sec-summary>

"cheap" and "descent" count the $(p, delta)$ pairs, out of $180$ per surface,
that the local triage sent down each path; times are wall-clock seconds for
the $t_0$ sweep, the 45 odd primes, and $p = 2$. Rows marked #super[+] are completed only by the
deeper searches of @sec-fail and @sec-two; rows marked #super[\*] are still
short after them.

#set text(size: 8.5pt)
#summarytable
#set text(size: 10.5pt)

Across all thirty surfaces the sweeps cost $21.9$ s, the odd primes $288.5$ s
and $p = 2$ $10.9$ s, for $321.3$ s in total --- an average of $10.7$ s per
surface for $180$ square classes plus eight more at $p = 2$. Of the $5400$
pairs, $2744$ were settled straight from the $t_0$ sweep with no descent at
all and $2647$ by descent. The spread is wide: `20a3` finishes in $3.9$ s,
`15a7` takes $48.0$ s.

== The eight classes with no witness <sec-fail>

#failtable

#v(2mm)

These survive a search over cofactors $m <= 20000$ --- so $|d| <= 20000$ for
the classes $[1]$, $[u]$ and $|d| <= 20000 p$ for $[p]$, $[u p]$ --- taking
$9.9$ minutes. Three things are worth saying about them.

*They are not rank-starved.* $g = 2$ throughout: $E_delta (QQ_p)$ needs two
topological generators, so no rank-1 twist can ever be dense there and the
question is whether the search met enough twists of rank $>= 2$. It did. The
last column counts the twists of Mordell--Weil rank $>= 2$ actually tested
inside the failing class at cofactor $m <= 3000$ --- between 96 and 167 of
them, every one of them not dense --- and the $m <= 20000$ pass covers $6.7$
times that range. This is the shape of evidence the companion notes use in
§5.1, and it is now available for eight surfaces instead of one.

*$g = 2$ is very far from sufficient.* Of the $5400$ pairs, $2491$ have
$E_delta (QQ_p)$ non-procyclic by the same triage, and all but these eight are
witnessed. Nothing about needing a rank-2 twist predicts failure on its own.

*The failure is a property of the surface, not of the model.* By @sec-labels
the class label moves when the model does, and it moves correctly: see
@sec-verify.

For odd $p$ the single-twist criterion is an *equivalence* --- the necessity
argument of the companion notes needs only that $E_delta (QQ_p)$ has at most
two topological generators, which holds at every odd $p$. So a genuinely
exhaustive search failing here would mean $X(QQ)$ is not dense in $X(QQ_p)$.
The searches are finite, so these are candidate obstructions, not theorems.

=== What the ledger says about them <sec-ledger-odd>

The companion notes' ledger (§2.3) proves density from a *union* of partial
twists: it records each twist's reach in a finite arena and applies the star
test --- for every pair of arena elements, is there a single twist whose reach
contains both? That is the right question, because the Kummer surface supplies
*pairs* of points on one twist. It is worth being clear about what it can do
here.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *At one odd place the ledger cannot prove anything the single-twist search
  misses.* $G = E_delta (QQ_p)$ is topologically 2-generated for $p$ odd. Feed
  the star test a pair $(a,b)$ of topological generators: it demands a single
  $d$ with $a, b in H_d$, and then
  $H_d supset.eq overline(⟨a,b⟩) = G$ --- a full twist. So the star test closes
  *if and only if* a full twist exists.

  #v(1.5mm)
  This is the $g <= 2$ regime the companion notes flag. The ledger pays for
  itself at $S = {11,13,17}$ precisely because there $g = 3$: no pair can
  generate, a full twist is not forced, and partial patches do together what no
  single twist can.
]

What the ledger does give is a *measurement*. Density needs the reach to be
everything in each layer $ell$ with $dim A slash ell A = 2$, where
$A = E_delta (QQ_p) slash E_1$; the reach of a twist is its image in
$A slash ell A tilde.equiv (ZZ slash ell)^2$. Whether the reaches that do occur
are spread over *all* the lines, or confined to one, is exactly the test that
separates a pairing obstruction from a linear functional --- the question
@sec-measured settles for $x^3 + x$. Since all $d$ in a class give
$QQ_p$-isomorphic curves, the lines can be labelled once and compared.

`27a1` is left out: non-density is proved there (§5.1.5). For the other seven:

#table(
  columns: 8, align: (left, center, center, center, right, center, center, center),
  stroke: 0.4pt + luma(170), inset: (x: 5pt, y: 3pt),
  table.header([surface], [$p$], [class], [$ell$], [twists], [reach $= (ZZ slash ell)^2$],
               [lines seen], [star deficiency]),
  [`11a1`], [11], [$[u]$], [5], [584],  [*0*], [6 of 6], [480/625],
  [`14a1`], [7],  [$[1]$], [3], [1062], [*0*], [4 of 4], [48/81],
  [`14a2`], [7],  [$[1]$], [3], [1062], [*0*], [4 of 4], [48/81],
  [`15a1`], [5],  [$[1]$], [2], [1012], [*0*], [3 of 3], [6/16],
  [`15a4`], [5],  [$[1]$], [2], [1012], [*0*], [3 of 3], [6/16],
  [`17a1`], [17], [$[1]$], [2], [1150], [*0*], [3 of 3], [6/16],
  [`19a1`], [19], [$[u]$], [3], [546],  [*0*], [4 of 4], [48/81],
)

#v(2mm)

Three things come out of it.

*The ledgers have closed as far as they possibly can.* If the reaches are
exactly the $ell + 1$ lines and nothing more, the pairs the star test cannot
cover are those $(a,b)$ with $a$ and $b$ non-zero and spanning, of which there
are $(ell^2 - 1)(ell^2 - ell)$ out of $ell^4$ --- that is $6 slash 16$,
$48 slash 81$, $480 slash 625$ for $ell = 2, 3, 5$. Every deficiency in the
table is *exactly* that number. So in each case the ledger has collected every
line, and the only thing it is missing is the full reach that would make it
close --- which is the full twist the search could not find.

*Every line occurs, and roughly equally often.* At `11a1` the six lines of
$(ZZ slash 5)^2$ are hit $92, 97, 97, 103, 77, 95$ times out of 561; at `19a1`
the four lines of $(ZZ slash 3)^2$ are hit $132, 112, 121, 122$ out of 487. No
line is preferred, so no linear functional vanishes on all the rational points.
This is the signature of a *pairing*, and it is the same signature
@sec-measured finds for $x^3 + x$ --- where @sec-thm2 then proves the pairing
is $(x(P), x(Q))_v$. So the seven non-CM cases look like instances of the same
mechanism, and a twisted-pairing argument of the kind in @sec-dict is what to
look for. Constructing it for them is not done here.

*`14a2` splits its layers, and shows the obstruction is one-layer.* It has
$M = 36$, so density needs the reach to be everything in both
$A slash 2A$ and $A slash 3A$. At $ell = 2$ the ledger *closes*: 252 of its 1062
twists reach all of $(ZZ slash 2)^2$ and the deficiency is $0 slash 16$. At
$ell = 3$ it behaves like the rest of the table. The class is unwitnessed
because of the 3-layer alone, which is a sharper statement than "no full twist
found" and tells any future proof exactly where to work.

#v(1mm)

Two controls behave as they should: `15a1` in the *witnessed* class $[u]$ has
all 1016 of its twists reaching the whole of $(ZZ slash 2)^2$, deficiency
$0 slash 16$; and `14a1` in class $[u]$ has no 2-dimensional layer at all ---
$E_delta (QQ_p)$ is procyclic there, so the question does not arise.


== $p = 2$ <sec-two>

#set text(size: 8pt)
#p2table
#set text(size: 10.5pt)

#v(2mm)

The interesting column of @sec-which's table is $n_(QQ_2)$. When $f$ splits
completely over $QQ_2$ --- ten of the thirty surfaces --- one has
$E_delta (QQ_2) tilde.equiv ZZ_2 times (ZZ slash 2)^2$ for *every* $delta$,
because the 2-torsion of $d v^2 = f(u)$ sits at $v = 0$ over the roots of $f$,
which do not depend on $d$. Three topological generators are then needed, and
the Kummer surface only ever supplies pairs of points: the criterion is no
longer an equivalence, and a single twist can only work if it has rank $>= 2$
(rank $>= 1$ when $f$ splits over $QQ$ already, since then each twist carries
$(ZZ slash 2)^2$ rationally).

That is exactly what the search sees. With the cofactor bound $m <= 300$, seven
of those ten surfaces fall short --- `15a8` covering only $1$ of $8$ classes.
Raising the bound to $m <= 4000$ and then hunting the residue to $m <= 20000$
recovers all of them but one, always on a twist of rank $2$ or $3$:
`15a3` at $d = 4807$ (rank 3), `17a3` at $d = -10481$ (rank 3), and `15a8` at
$d = -6315$, $10695$, $-9690$ (ranks 2, 3, 2). Every surface with
$n_(QQ_2) <= 1$ was already complete at $m <= 300$.

The one survivor is *`17a4`, class $[7]$*, still unwitnessed at $m <= 20000$.
Since $n_(QQ_2) = 3$ there, the criterion is only sufficient, so this is a
limitation of the method and not evidence of non-density --- unlike the eight
odd-prime cases above.

== Witnesses, all odd $p < 200$

One table per surface: the squarefree $d$ whose twist $E_d$ has $E_d (QQ)$
dense in $E_d (QQ_p)$, for each of the four square classes. Entries marked
#super[+] come from the deeper cofactor pass, #text(fill: rgb("#b00"))[---]
from @sec-fail.

#primetables

= Verification <sec-verify>

*The two controls reproduce the companion notes exactly.* `496a`
($f = x^3 + x + 1$) gives $45 slash 45$ odd primes with $158$ of $180$ pairs on
the cheap path --- the same count as §6 of the companion notes --- and the
identical $p = 2$ witness row $1, 3, 5, -1, -30, 6, -6, 30$. `27a1`
($f = x^3 - 2$) reproduces the one known failure: every odd $p <= 200$ except
$p = 3$, where the class $[u dot 3]$ has no witness.

*Model-independence.* @sec-labels predicts that rewriting a surface must
permute the class labels by the class of $c$, and in particular must move a
failing class to a definite other one. Tested on `14a1`, which fails at $p = 7$:

#table(
  columns: 3, align: (left, left, center), stroke: 0.4pt + luma(170),
  inset: (x: 6pt, y: 3pt),
  table.header([model], [relation to the first], [failing class at $p = 7$]),
  [$x^3 + 10x^2 + 105x - 116$], [---], [$[1]$],
  [$x^3 + 645x - 10582$], [$c = 1 slash 3$, $(3 slash 7) = -1$], [$[u]$],
  [$x^3 + 645x + 10582$], [and then $c = -1$, $(-1 slash 7) = -1$], [$[1]$],
)

All three agree, and the three witness rows are transported correctly. This
also re-runs `14a1` through the *depressed* code path of the companion notes,
so the generalisation of @sec-monic is checked against the original scripts.

*Nothing rests on a rank bound.* As in the companion notes, `ellrank` and
`ellsaturation` are used only to *find* points; every positive entry is an
explicit rational $d$ together with explicit rational points, and density of a
subgroup implies density of the full Mordell--Weil group. The negative entries
are search results and are reported as such.


= The CM batch <sec-cm>

The first batch was chosen by size and turned out to be non-CM throughout, which
left the one CM surface of the companion notes --- $f = x^3 - 2$, the only
surface anywhere in this project known to be defective --- with no company. This
section supplies it.

== What the CM surfaces are <sec-cm-which>

There are thirteen CM $j$-invariants over $QQ$. For $j != 0, 1728$ all curves
with that $j$ form a *single* quadratic-twist class, so by @sec-which each such
$j$ is *one* surface: eleven rigid points, one per CM discriminant
$D = -7, -8, -11, -12, -16, -19, -27, -28, -43, -67, -163$.

For $j = 0$ and $j = 1728$ the twisting is sextic and quartic, so one $j$ spreads
over infinitely many quadratic-twist classes, and the reduced pairs of
@sec-which name them:

$ D = -3: quad f = x^3 + B, quad (0, B) |-> (0, B u^3), quad "surfaces" <-> B > 0 "cubefree"; $
$ D = -4: quad f = x^3 + A x, quad (A, 0) |-> (A u^2, 0), quad "surfaces" <-> A != 0 "squarefree". $

This is the point of the section. $x^3 - 2$ is not an isolated example, it is the
member $B = 2$ of a family, and the question "is the defect a fact about the CM
order, or about that one surface?" can be settled by *walking the family*.

Run over all $p <= 200$: the eleven rigid surfaces, the sextic members with
$B <= 20$ (eighteen) and the quartic members with $|A| <= 10$ (fourteen) ---
43 surfaces, $334$ s. Then the two families are scanned much further at the one
place that matters (@sec-cm-family).

== Result <sec-cm-result>

#block(fill: rgb("#eef4ff"), inset: 9pt, radius: 3pt, width: 100%)[
  Of the $43 times 45 times 4 = 7740$ pairs (odd prime, square class), *all but
  one* carry a witness; of the $43 times 8 = 344$ classes at $p = 2$, all but
  two. *Forty-one of the forty-three CM surfaces are dense at every prime
  $p <= 200$.* The two that are not are $x^3 + 2$ at $p = 3$ --- the quadratic
  twist of the companion notes' $x^3 - 2$, so the known case --- and
  $x^3 + x$ at $p = 2$, which is new.
]

#set text(size: 8pt)
#cmtable
#set text(size: 10.5pt)

#v(1mm)

Marks as in @sec-summary: #super[+] completed only by a deeper pass,
#super[\*] still short. The one #super[+] in the odd column is the
$D = -163$ surface at $p = 199$, class $[199]$, which the standard pass misses
because the class holds only five twists of rank $>= 2$ up to cofactor $3000$;
it is settled at $d = 1949802$ on a twist of rank $3$, by some margin the
deepest witness anywhere in this document.

At $p = 2$, the surfaces $D = -7$ and $A = 7$ are short at $m <= 300$ and
complete at $m <= 4000$; both have $n_(QQ_2) = 3$, so they are the familiar
three-generator case of @sec-two.

== The two defects <sec-cm-fail>

#cmfailtable

#v(2mm)

*Both sit at the prime ramified in the CM field* --- $3$ for $ZZ[zeta_3]$, $2$
for $ZZ[i]$ --- where the curve has additive, potentially good reduction. That
is *not* the mechanism of @sec-fail, where seven of the eight cases had
multiplicative reduction $I_nu$ with $gcd(c_p, p - a_p) > 1$; a curve with
potentially good reduction everywhere cannot produce that signature at all.

*Both are genuine, in the sense that the criterion is an equivalence there.*
For odd $p$ that is automatic. At $p = 2$ it is not, and this is the first
$p = 2$ shortfall in either batch that means anything: $f = x(x^2+1)$ has
*exactly one* root in $QQ_2$, so $dim E[2](QQ_2) = 1$, $E_delta (QQ_2)$ is
topologically 2-generated, and the necessity argument of the companion notes
applies verbatim. The shortfalls of @sec-two all had $n_(QQ_2) = 3$ and
$g = 3$, where it does not.

*The defective classes of $x^3 + x$ are exactly $delta = 2$ and $delta = -2$*,
and the local structure picks them out on its own --- the analogue at $p = 2$ of
`find3` at $p = 3$ in the companion notes' §5.1.1:

#table(
  columns: 9, align: (left, center, center, center, center, center, center, center, center),
  stroke: 0.4pt + luma(170), inset: (x: 5pt, y: 3pt),
  table.header([$x^3 + x$ at $p = 2$], [$[1]$], [$[3]$], [$[5]$], [$[7]$],
               [$[2]$], [$[6]$], [$[10]$], [$[14]$]),
  [$M_2$],            [4], [4], [4], [4], [*16*], [8], [8], [*16*],
  [$c_2$],            [1], [1], [1], [1], [*4*],  [2], [2], [*4*],
  [torsion over $QQ$],[2], [2], [2], [2], [*4*],  [2], [2], [*4*],
  [witnessed],        [yes], [yes], [yes], [yes],
    [#text(fill: rgb("#b00"))[no]], [yes], [yes], [#text(fill: rgb("#b00"))[no]],
)

#v(2mm)

The two classes where the twist picks up a rational point of order $4$, the
Tamagawa number jumps to $4$ and $M_2$ to $16$ are precisely the two with no
witness. This is the same shape as §5.1.1, where the extra $QQ_3$-rational
3-torsion point exists exactly on the defective class.

It is not simply that $M_2 = 16$ is too big: $x^3 - x$ has $M_2 = 16$ on all
four even classes and witnesses them at $d = -30, 6, -6, 30$, and $x^3 + 2x$
witnesses $[2]$ and $[14]$ at $d = 2, -2$. Nor is it starvation: $79$ twists of
rank $>= 2$ were tested in each of the two classes at $m <= 4000$, none dense,
and a hunt to $m <= 30000$ finds nothing.

== Walking the families <sec-cm-family>

The question @sec-cm-which was set up to answer. Both families are scanned at
the single place where their defect could live --- $p = 3$ for the sextic
family, $p = 2$ for the quartic one --- far past the range the full run covers.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  Of the *85* sextic surfaces $x^3 + B$ with $B <= 100$ cubefree, exactly *one*
  is defective at $p = 3$: $B = 2$. ($72$ s.)

  Of the *74* quartic surfaces $x^3 + A x$ with $|A| <= 60$ squarefree, exactly
  *one* is defective at $p = 2$: $A = 1$. ($10$ s.)
]

So the defect is a fact about the individual surface, not about the CM order and
not about the family: it does not spread. "CM, therefore trouble at the ramified
prime" is false --- 84 other members of the sextic family are fine at $3$, and
73 other members of the quartic family are fine at $2$, on twists that are
mostly small.

Witnesses for the whole sextic scan at $p = 3$:

#set text(size: 7pt)
#sextictable
#set text(size: 10.5pt)

#v(2mm)

and for the quartic scan at $p = 2$:

#set text(size: 7pt)
#quartictable
#set text(size: 10.5pt)


== A reciprocity obstruction at $p = 2$ <sec-pairing>

The companion notes' §5.1.5 does not construct a Brauer class; it identifies a
*mechanism* --- a Galois-twisted Tate pairing plus reciprocity --- and that
mechanism proves the statement on its own. The same mechanism is available for
$x^3 + x$, with the descent done by 2 instead of by 3, and better than that: it
can be written down with *no cohomology at all*. The twisted pairing turns out to be the Hilbert symbol of two
$x$-coordinates, and the only imported theorem is Hilbert reciprocity ---
equivalently quadratic reciprocity. The next four subsections are self-contained
and elementary; @sec-dict then gives the cohomological proof in full --- the
form the argument was found in, and where each step is an instance of something
standard --- which is where it came from but not what it needs.

Throughout, $E_d : y^2 = x (x^2 + d^2)$, $T = (0,0)$, and $d$ is a squarefree
integer.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *Notation: two different 2's.* The *level* of the descent is 2 --- we work with
  $E[2]$, with square classes, with $K^times slash (K^times)^2$ --- and the
  *place* that survives reciprocity is also $v = 2$. These are the two families of
  primes the companion notes keep apart in §2.3: a *layer* and a *place*. They
  happen to coincide numerically here, which is precisely why they must be
  separated in the notation.

  #v(1.5mm)
  So below the level is *never* given a letter: it is always the literal $2$, in
  $E[2]$ and in "modulo squares". Places do get letters --- $v$ for a place of
  $QQ$, including $v = infinity$ and $v = 2$, and $q$ for a finite *odd* place,
  where $v_q$ is the $q$-adic valuation. Nothing is denoted $ell$ until
  @sec-dict, where $ell$ resumes its §5.1.5 meaning of a *level*.
]

=== The square-class map, and the norm lemma <sec-alt>

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Definition.* For any field $K$ of characteristic $!= 2$ define
  $ c : E_d (K) --> K^times slash (K^times)^2, quad
    c(O) = 1, quad c(T) = d^2, quad c(x, y) = x "otherwise." $

  #v(2.5mm)
  *Lemma 1.* $c$ is a group homomorphism.

  #v(1.5mm)
  _Proof._ Let $P + Q + R = O$ with none of them $O$; the three points are the
  intersections of $E_d$ with a line. A vertical line meets $E_d$ at $O$, so the
  line is $y = lambda x + nu$, and the $x$-coordinates are the roots of
  $ x^3 - lambda^2 x^2 + (d^2 - 2 lambda nu) x - nu^2 = 0 . $
  If $nu != 0$ no root is $0$ and the product of the roots is $nu^2$, so
  $c(P) c(Q) c(R) = nu^2$ is a square. If $nu = 0$ the cubic is
  $x(x^2 - lambda^2 x + d^2)$, so one point is $T$ and the other two have
  $x$-coordinates multiplying to $d^2$; then $c(P) c(Q) c(R) = d^2 dot d^2$,
  again a square. $qed$

  #v(2.5mm)
  *Lemma 2 (the norm lemma).* For every $P in E_d (K)$, $c(P)$ is a norm from
  $K(i)$. Equivalently $(c(P), -1)_v = 1$ at every place $v$ of $QQ$ when
  $K = QQ$.

  #v(1.5mm)
  _Proof._ $c(O) = 1$ and $c(T) = d^2$ are squares. Otherwise
  $x (x^2 + d^2) = y^2$, so $x equiv x^2 + d^2$ modulo squares, and
  $x^2 + d^2 = N_(K(i) slash K) (x + d i)$. $qed$
]

Lemma 1 is the classical descent-by-2-isogeny lemma, proved here by nothing more
than Vieta. It was checked on 7780 triples $(P, Q, P+Q)$ across all squarefree
$d = plus.minus 2^e m$ with $m <= 300$: the product $c(P) c(Q) c(P+Q)$ was a
square every time.

Lemma 2 is where the curve's complex multiplication enters, and it is the *whole*
reason $x^3 + x$ is different from its neighbours. For a general
$E : y^2 = x(x^2 + a x + b)$ the same two lines give $c(P) equiv N_(K(theta))(x - theta)$
with $theta$ a root of $x^2 + a x + b$, hence $(c(P), a^2 - 4b)_v = 1$. The twist
$E_d$ of $x^3 + A x$ has $a = 0$, $b = A d^2$ and $a^2 - 4b = -4 A d^2 equiv -A$,
so the relevant field is $QQ(sqrt(-A))$ for every $d$, and it is $QQ(i)$ ---
which is what makes $(c(P), -1)_v = 1$ --- exactly when $A = 1$.

#table(
  columns: 4, align: (center, center, center, left),
  stroke: 0.4pt + luma(170), inset: (x: 7pt, y: 3pt),
  table.header([$A$], [$QQ(sqrt(a^2 - 4b))$], [$(c(P), -1)_v != 1$ ever?], [ ]),
  [$1$],  [$QQ(sqrt(-1))$], [0 of 6032],   [*never*],
  [$2$],  [$QQ(sqrt(-2))$], [128 of 6760], [],
  [$3$],  [$QQ(sqrt(-3))$], [364 of 5720], [],
  [$5$],  [$QQ(sqrt(-5))$], [64 of 6240],  [],
  [$-2$], [$QQ(sqrt(2))$],  [400 of 6760], [],
  [$-3$], [$QQ(sqrt(3))$],  [388 of 5720], [],
  [$6$],  [$QQ(sqrt(-6))$], [360 of 5824], [],
)

#v(2mm)

Every point of every twist, at every place $v <= 100$; the identity
$(c(P), a^2 - 4b)_v = 1$ of Lemma 2 itself is trivial in all 18512 evaluations.
*This is the answer to "why exactly $A = 1$"* --- the same shape of explanation
as §5.1.1's account of why exactly the class $[u dot 3]$ fails for $x^3 - 2$.

=== The symbol vanishes away from 2 <sec-places2>

For $P, Q in E_d (QQ)$ write $(c(P), c(Q))_v$ for the quadratic Hilbert symbol:
$+1$ if $z^2 = c(P) x^2 + c(Q) y^2$ has a non-zero solution in $QQ_v$, and $-1$
otherwise. We use two standard elementary properties: bilinearity, and
$(a, -a)_v = 1$ (take $x = y = 1$, $z = 0$), whence
$(a,a)_v = (a, -a)_v (a, -1)_v = (a,-1)_v$.

- *$v = infinity$.* $x^2 + d^2 > 0$, so $y^2 = x(x^2 + d^2)$ forces $x >= 0$ on
  real points. Both arguments are $>= 0$ and the symbol is $+1$.

- *$q$ odd, $q divides.not 2 d$.* Write $x = a slash e^2$ in lowest terms and
  $y = b slash e^3$, so $b^2 = a (a^2 + d^2 e^4)$. A common prime factor of $a$
  and $a^2 + d^2 e^4$ divides $d^2 e^4$, hence $d^2$ since $gcd(a,e) = 1$; as
  $q divides.not d$ it divides neither or exactly one of the two factors, so
  $v_q (a)$ is even and $v_q (c(P)) = v_q (a) - 2 v_q (e)$ is even. Two
  $q$-adic units pair trivially at odd $q$, so the symbol is $+1$.

- *$q$ odd, $q divides d$.* Two lemmas, needing no condition on $q mod 4$.

  #block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
    *Lemma A.* Let $q$ be odd, $e = v_q (d)$ and $P in E_d (QQ_q)$ with
    $k = v_q (x(P)) != e$. Then $c(P) = 1$.

    #v(1.5mm)
    _Proof._ If $k < e$ then $x^2 + d^2 = x^2 (1 + (d slash x)^2)$ and
    $v_q ((d slash x)^2) = 2(e-k) > 0$, so the second factor is a 1-unit, hence
    a square in $ZZ_q^times$ as $q$ is odd. If $k > e$ then symmetrically
    $x^2 + d^2 = d^2 (1 + (x slash d)^2)$ with $1 + (x slash d)^2$ a square.
    Either way $x^2 + d^2$ is a square times $x^2$ or $d^2$, so
    $x (x^2 + d^2) = y^2$ exhibits $x$ as a square. $qed$

    #v(2.5mm)
    *Lemma B.* $S := c(E_d (QQ_q))$ has order at most 2.

    #v(1.5mm)
    _Proof._ By Lemma 1, $S$ is a *subgroup* of
    $QQ_q^times slash (QQ_q^times)^2$, a group of order 4 with
    representatives $1, u, q, q u$. By Lemma A every element of $S$ is either
    $1$ or the class of some $x(P)$ with $v_q (x(P)) = e$, so every
    non-identity element of $S$ has valuation $equiv e$ $(mod 2)$. If $e$ is
    even, $S subset.eq {1, u}$. If $e$ is odd, $S without {1} subset.eq {q, q u}$;
    were both in $S$ then so would be their product $u$, a non-identity element
    of *even* valuation --- contradiction. Either way $\#S <= 2$. $qed$
  ]

  #v(2mm)

  So $S = ⟨g⟩$ for a single $g$, and any two elements pair as
  $(g^i, g^j)_q = (g,g)_q^(i j) = (g,-1)_q^(i j) = 1$ by Lemma 2. The
  symbol is $+1$.

Both lemmas were checked: Lemma A on 3345 sampled $QQ_q$-points over nine
twists, no exception; Lemma B on *1851* bad odd places across four square
classes, where $\#S$ came out $1$ or $2$ and never $4$. Note that
$dim E_d (QQ_q) slash 2$ is often $2$ at these places --- the point of Lemma A
is that $c$ is *not* injective there, which a dimension count alone misses:

#align(center, table(
  columns: 5, align: (right, right, center, center, left),
  stroke: 0.4pt + luma(170), inset: (x: 6pt, y: 2.5pt),
  table.header([$d$], [$q$], [$q mod 4$], [$dim E_d (QQ_q) slash 2$],
               [$c(E_d (QQ_q))$]),
  [10],  [5],  [1], [2], [${1, 5}$],
  [26],  [13], [1], [2], [${1, 13}$],
  [34],  [17], [1], [2], [${1, 17}$],
  [82],  [41], [1], [2], [${1, 41}$],
  [130], [5],  [1], [2], [${1, 10}$],
  [130], [13], [1], [2], [${1, 26}$],
  [66],  [3],  [3], [1], [${1}$],
  [66],  [11], [3], [1], [${1}$],
))

=== The image at 2: a computation modulo 8 <sec-img2>

Let $d = 2m$ with $m$ odd. Write a point as $x = 2^k u$ with $u$ odd, or $x = 0$.
Since $y^2 = x(x^2 + 4m^2)$, the valuation $v_2 (x) + v_2 (x^2 + 4m^2)$ must be
even and the remaining unit must be $equiv 1$ $(mod 8)$. Going through the cases,
and using $m^2 equiv 1$ $(mod 16)$ when $m equiv plus.minus 1$ $(mod 8)$ and
$m^2 equiv 9$ $(mod 16)$ when $m equiv plus.minus 3$ $(mod 8)$:

#table(
  columns: 3, align: (center, left, center),
  stroke: 0.4pt + luma(170), inset: (x: 7pt, y: 3pt),
  table.header([$k = v_2 (x)$], [condition for a $QQ_2$-point], [class of $c$]),
  [$< 0$ or $>= 3$], [$k$ even; then $x^2 + 4m^2$ is $x^2$ or $4 m^2$ times a
    1-unit], [$1$],
  [$0$], [$x^2 + 4m^2 equiv 5$, so $5x equiv 1$, i.e. $x equiv 5$], [$5$],
  [$1$], [$x = 2u$: $y^2 = 16 u w$ with $w = (u^2+m^2) slash 2$; need
    $u w equiv 1$], [$2u$],
  [$2$], [$x = 4u$: need $5 u equiv 1$, i.e. $u equiv 5$], [$5$],
)

#v(2mm)

Only $k = 1$ depends on $m$, and it is where the two families part:

#align(center, table(
  columns: 4, align: (center, left, left, center),
  stroke: 0.4pt + luma(170), inset: (x: 7pt, y: 3pt),
  table.header([$m mod 8$], [$w mod 8$], [$u w equiv 1$ solvable?],
               [$c(E_d (QQ_2))$]),
  [$plus.minus 1$], [$1$ if $u equiv plus.minus 1$, $5$ if $u equiv plus.minus 3$],
    [yes: $u equiv 1$ and $u equiv 5$], [${1, 5, 2, 10}$],
  [$plus.minus 3$], [$5$ if $u equiv plus.minus 1$, $1$ if $u equiv plus.minus 3$],
    [no], [${1, 5}$],
)) 

#v(2mm)

and for $d$ odd the image is ${1}$. A machine scan of 324 squarefree $d$
reproduces the table exactly, sorted by $v_2 (d)$ and $d slash 2^(v_2 (d))$
modulo 8 --- no other pattern appears. So $c(E_d (QQ_2))$ has order 4 precisely
on the square classes $[2]$ and $[14]$, which are precisely the two with no
witness in @sec-cm-fail.

Finally the symbol on that image, four entries of an elementary table:

#align(center, table(
  columns: 5, align: center, stroke: 0.4pt + luma(170), inset: (x: 8pt, y: 3pt),
  table.header([$( , )_2$], [$1$], [$5$], [$2$], [$10$]),
  [$1$],  [$+$], [$+$], [$+$], [$+$],
  [$5$],  [$+$], [$+$], [$-$], [$-$],
  [$2$],  [$+$], [$-$], [$+$], [$-$],
  [$10$], [$+$], [$-$], [$-$], [$+$],
))

#v(2mm)

The diagonal is $+$ --- that is Lemma 2 again --- and the form is
non-degenerate. Its isotropic subgroups are $1, ⟨5⟩, ⟨2⟩, ⟨10⟩$, all of order at
most 2.

=== The theorem <sec-thm2>

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Theorem.* Let $d = 2m$ be squarefree with $m equiv plus.minus 1$ $(mod 8)$ ---
  that is, $d$ in the square class $[2]$ or $[14]$ of $QQ_2^times$. Then
  $E_d (QQ)$ is not dense in $E_d (QQ_2)$; and hence $X(QQ)$ is not dense in
  $X(QQ_2)$ for $X : y^2 = (x^3 + x)(t^3 + t)$. (The criterion of the companion
  notes, §2, is an equivalence at $p = 2$ here: $f = x(x^2+1)$ has exactly one
  root in $QQ_2$, so $E_delta (QQ_2)$ is topologically 2-generated and the
  necessity argument applies.)

  #v(2mm)
  _Proof._ Let $P, Q in E_d (QQ)$. By @sec-places2 the symbol
  $(c(P), c(Q))_v$ equals $+1$ at every place $v != 2$, so Hilbert reciprocity
  $product_v (c(P), c(Q))_v = 1$ gives $(c(P), c(Q))_2 = +1$.

  Therefore $H :=$ the image of $c(E_d (QQ))$ in
  $QQ_2^times slash (QQ_2^times)^2$ is a subgroup on which the symbol is
  identically $+1$. By @sec-img2 it sits inside ${1,5,2,10}$, where the symbol
  is non-degenerate, so $\#H <= 2$.

  The map $c : E_d (QQ_2) -> QQ_2^times slash (QQ_2^times)^2$ is *locally
  constant*, since the squares are open in $QQ_2^times$ and $c$ is given locally
  by $x$ or by the constant $d^2$. Its image is all of ${1,5,2,10}$ by
  @sec-img2. So
  $ U = { P in E_d (QQ_2) : c(P) in.not H } $
  is open, non-empty, and contains no rational point --- and being open it
  contains no limit of rational points either. Hence $E_d (QQ)$ is not dense in
  $E_d (QQ_2)$. $qed$
]

Nothing in that proof uses cohomology, Selmer groups, Frattini subgroups or
Nakayama: it is Vieta's formulas, a norm identity, three valuation arguments, a
computation modulo 8, and Hilbert reciprocity. The proof covers *all* twists in
the two classes at once, which the searches of @sec-cm-fail never could.

Two independent measurements agree with it. Across 190 twists in the two
defective classes, all 950 rational pairs give $(c(P), c(Q))_2 = +1$ --- as the
theorem says they must. And the control cuts the other way: $x^3 + 2x$ has
$a^2 - 4b equiv -2$, so Lemma 2 gives only $(c(P), -2)_v = 1$, the diagonal of
its symbol table is not $+$, the odd places are not killed and reciprocity
localises nothing --- there 132 of 395 and 214 of 464 rational pairs have a
*non-trivial* symbol at 2, and all four of its classes are witnessed.

=== The cohomological proof <sec-dict>

The argument was found through the twisted-pairing picture of §5.1.5, and it is
worth writing that version out in full: every step above is then an instance of
something standard, and the mechanism becomes directly comparable with the
$ell = 3$ case. Nothing in @sec-thm2 depends on this subsection.

In it, $ell$ resumes its §5.1.5 meaning of a *level*: here always 2. Places keep
the letters $v$ and $q$ of the notation box.

*The standard input.* Write $G_v = "Gal"(overline(QQ)_v slash QQ_v)$. Three
facts, all classical:

+ *(Kummer)* $0 -> E[2] -> E attach(-->, t: 2) E -> 0$ gives an injection
  $delta_v : E_d (QQ_v) slash 2 arrow.hook H^1 (QQ_v, E[2])$ with image $W_v$.
+ *(Tate)* The Weil pairing $e_2 : E[2] times E[2] -> mu_2$ is perfect and
  Galois-equivariant, and cup product followed by
  $"inv"_v : H^2 (QQ_v, mu_2) tilde.equiv 1/2 ZZ slash ZZ$ gives a *perfect*
  pairing $⟨ , ⟩_v$ on $H^1 (QQ_v, E[2])$, for which $W_v$ is its own
  annihilator --- a Lagrangian.
+ *(Reciprocity)* For global $alpha, beta in H^1 (QQ, E[2])$,
  $sum_v "inv"_v (op("res")_v alpha union op("res")_v beta) = 0$, because the
  global cup product lands in $H^2 (QQ, mu_2) subset "Br"(QQ)$ and the sum of
  local invariants vanishes there.

The untwisted pairing is useless on its own: $W_v$ is Lagrangian, so
$⟨delta_v P, delta_v Q⟩_v = 0$ identically and reciprocity says $0 = 0$. The
point of §5.1.5 is to break that by twisting with a non-scalar endomorphism.

==== The twisting endomorphism

The 2-torsion sits at $x = 0$ and $x = plus.minus i$, so the 2-torsion field is
$QQ(i)$ and Galois acts through $ZZ slash 2$, fixing $e_1 = T = (0,0)$ and
interchanging the other two points; in the basis $(e_1, e_2)$ the non-trivial
element acts by $mat(1, 1; 0, 1)$. Hence $C_1 := ⟨T⟩ = {O, T}$ is the *unique*
Galois-stable line, it has no stable complement, and *$E[2]$ is
indecomposable* --- §5.1.5's route to a twisting endomorphism, projection onto a
summand, is closed.

It is not needed. $bb(F)_2 [ZZ slash 2]$ is not semisimple, and the commutant of
a single unipotent Jordan block is $bb(F)_2 [N] slash (N^2)$, which contains the
non-scalar
$ N : e_1 |-> 0, quad e_2 |-> e_1 . $

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  What §5.1.5 actually needs is that the endomorphism ring of the torsion module
  is bigger than the prime field --- $"End"_G (E[3]) != bb(F)_3$ there,
  $"End"_G (E[2]) != bb(F)_2$ here --- not that the module is decomposable. At an
  odd level with semisimple Galois action the two conditions agree, which is why
  the distinction does not arise in §5.1.5. At level 2 they come apart, and it is
  the weaker one the mechanism uses.
]

Since $ker N = "im" N = C_1$, $N$ factors as
$ E[2] attach(-->, t: pi) E[2] slash C_1 attach(-->, t: n) C_1 attach(arrow.hook, t: iota) E[2], $
with $pi$ the quotient map, $iota$ the inclusion, and $n$ the unique isomorphism
between them. Both $C_1$ and $E[2] slash C_1$ are the *trivial* module
$ZZ slash 2$ --- $C_1$ because $T$ is rational, $E[2] slash C_1$ because
$sigma(e_2) - e_2 = e_1 in C_1$ --- so $n$ is the only non-zero map between them
and is automatically Galois-equivariant. On the basis, $pi(e_1) = 0$,
$pi(e_2) = overline(e)_2$, $n(overline(e)_2) = e_1$, $iota(e_1) = e_1$, so
$iota compose n compose pi = N$.

Define $ beta_v (P, Q) = ⟨delta_v P, N_* delta_v Q⟩_v . $
Since $N$ is defined over $QQ$, $N_*$ commutes with restriction, so
$sum_v beta_v = 0$ for global points --- reciprocity survives the twist. That is
the whole idea.

==== $C_1$ is its own annihilator, and the induced pairing

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Lemma C.* $C_1^perp = C_1$, and $e_2$ induces a *perfect* pairing
  $ overline(e) : (E[2] slash C_1) times C_1 --> mu_2, quad
    overline(e) (overline(x), t) = e_2 (x, t) . $

  #v(1.5mm)
  _Proof._ $e_2$ is alternating, so $e_2 (t,t) = 1$ for every $t$; as
  $C_1 = {O, T}$ this gives $e_2 (C_1, C_1) = 1$, i.e. $C_1 subset.eq C_1^perp$.
  Since $e_2$ is perfect on the 2-dimensional $E[2]$, $dim C_1^perp = 2 - 1 = 1$,
  so $C_1^perp = C_1$.

  Well-definedness: if $x' = x + t_0$ with $t_0 in C_1$ then
  $e_2 (x', t) = e_2 (x,t) e_2 (t_0, t) = e_2 (x,t)$ for $t in C_1$. Perfectness:
  both sides have order 2, and if $overline(e)(overline(x), dot) equiv 1$ then
  $x in C_1^perp = C_1$, so $overline(x) = 0$. $qed$
]

==== The adjunction, and why it holds

This is the step that carries the argument, and it is worth doing slowly.

Recall that a Galois-equivariant pairing $phi : M times N -> P$ induces a cup
product $union_phi : H^i (M) times H^j (N) -> H^(i+j) (P)$, given on cochains by
$ (a union_phi b)(sigma_1, ..., sigma_(i+j))
  = phi lr(( a(sigma_1, ..., sigma_i), space
             sigma_1 dots.c sigma_i dot b(sigma_(i+1), ..., sigma_(i+j)) )) . $

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Lemma D (functoriality in the coefficients).* Let $f : M' -> M$ and
  $g : N' -> N$ be Galois maps. Then for $a in H^i (M')$, $b in H^j (N')$,
  $ f_* (a) union_phi g_* (b) = a union_(phi compose (f times g)) b . $

  #v(1.5mm)
  _Proof._ On cochains $f_* a = f compose a$ and $g_* b = g compose b$, so the
  left-hand side is
  $sigma |-> phi(f(a(...)), space sigma dot g(b(...)))$. As $g$ is
  Galois-equivariant, $sigma dot g(b(...)) = g(sigma dot b(...))$, and the
  expression becomes
  $sigma |-> (phi compose (f times g))(a(...), space sigma dot b(...))$, which is
  the right-hand side. The two cocycles are *equal*, not merely cohomologous.
  $qed$

  #v(2.5mm)
  *Lemma E (the adjunction).* For $a in H^1 (QQ_v, E[2])$ and
  $z in H^1 (QQ_v, C_1)$,
  $ ⟨ a, iota_* z ⟩_v = ⟨ pi_* a, space z ⟩_(overline(e)) . $

  #v(1.5mm)
  _Proof._ Everything rests on one identity *between pairings of modules*:
  $ e_2 compose (op("id") times iota) = overline(e) compose (pi times op("id"))
    quad "as maps" quad E[2] times C_1 --> mu_2 . $
  Indeed both send $(x, t)$ to $e_2 (x, t)$ --- the right-hand one by the very
  definition of $overline(e)$ in Lemma C, which is legitimate exactly because
  $C_1$ is isotropic. Now apply Lemma D twice:
  $ a union_(e_2) iota_* z
      = a union_(e_2 compose (op("id") times iota)) z
      = a union_(overline(e) compose (pi times op("id"))) z
      = pi_* a union_(overline(e)) z , $
  the first step by Lemma D with $f = op("id")$, $g = iota$, and the third by
  Lemma D with $f = pi$, $g = op("id")$. Apply $"inv"_v$. $qed$
]

So the isotropy of $C_1$ is not a convenience: it is what makes $overline(e)$
exist, and therefore what makes the adjunction true. Combining Lemma E with
$N = iota compose n compose pi$, and taking $z = n_* pi_* delta_v Q$,
$ beta_v (P,Q) = ⟨delta_v P, space iota_* n_* pi_* delta_v Q⟩_v
  = ⟨pi_* delta_v P, space n_* pi_* delta_v Q⟩_(overline(e)) . $
Identifying $C_1$ and $E[2] slash C_1$ with $ZZ slash 2$ makes $n$ the identity
and $overline(e)$ the multiplication $ZZ slash 2 times ZZ slash 2 -> mu_2$, so
$ beta_v (P, Q) = ⟨pi_* delta_v P, space pi_* delta_v Q⟩ . $

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *$beta$ is symmetric.* $e_2$ makes $N$ *self-adjoint*: both
  $e_2 (N x, y)$ and $e_2 (x, N y)$ vanish on all basis pairs except
  $(e_2, e_2)$, where both equal $e_2 (e_1, e_2) = -1$. (Equivalently: on a
  2-dimensional symplectic space the adjoint of $M$ is $op("tr")(M) op("id") - M$,
  and $op("tr") N = 0$.) Since cup product on $H^1$ is anti-symmetric and
  $-1 = 1$ in characteristic 2, $⟨ , ⟩_v$ is symmetric, hence so is $beta_v$.
]

==== Identifying $pi_* compose delta_v$

Let $phi : E -> E' = E slash C_1$ be the 2-isogeny with kernel $C_1$, and
$hat(phi) : E' -> E$ its dual, so $hat(phi) compose phi = [2]$. Then
$phi(E[2]) subset.eq ker hat(phi)$, and counting orders
($4 slash 2 = 2 = \# ker hat(phi)$) shows $phi$ induces an isomorphism
$E[2] slash C_1 tilde.equiv ker hat(phi)$. Under it, the diagram of
$G_QQ$-modules

$ 0 --> E[2] --> E attach(-->, t: 2) E --> 0 $
$ 0 --> ker hat(phi) --> E' attach(-->, t: hat(phi)) E --> 0 $

has exact rows and commutes, with vertical maps $pi$, $phi$ and $op("id")$: the
right square is $hat(phi) compose phi = [2]$ and the left one is the definition
of $pi$. Functoriality of connecting homomorphisms therefore gives
$ pi_* compose delta_v = delta_v^(hat(phi)) : E_d (QQ_v) --> H^1 (QQ_v, ker hat(phi)) . $
And $ker hat(phi) = ⟨(0,0)⟩ tilde.equiv ZZ slash 2$ with trivial action, so
Kummer theory identifies $H^1 (QQ_v, ker hat(phi))$ with
$QQ_v^times slash (QQ_v^times)^2$; under that identification
$delta_v^(hat(phi))$ is the classical descent map $c(P) = x(P)$ of
@sec-alt. That last identification is the standard computation
(Silverman X.4.9); a one-line check of its shape is that
$x compose hat(phi) = (Y slash X)^2$ on $E'$, so $c$ does kill
$hat(phi)(E'(QQ_v))$ as it must.

Finally, $H^1 (QQ_v, mu_2) = QQ_v^times slash (QQ_v^times)^2$ and the cup
product $H^1 (mu_2) times H^1 (mu_2) -> H^2 (mu_2)$ followed by $"inv"_v$ *is*
the quadratic Hilbert symbol. Assembling,
$ beta_v (P, Q) = (x(P), x(Q))_v , $
which is where @sec-alt starts.

==== The dictionary

#table(
  columns: 2, align: (left, left), stroke: 0.4pt + luma(150),
  inset: (x: 7pt, y: 4pt),
  table.header([elementary statement], [cohomological content]),
  [$c(P) = x(P)$ modulo squares],
    [$pi_* delta_v P$, by the isogeny diagram above],
  [Lemma 1 (Vieta)], [$delta_v$ and $pi_*$ are homomorphisms],
  [the Hilbert symbol $( , )_v$],
    [cup product on $H^1 (QQ_v, mu_2)$, then $"inv"_v$],
  [$beta_v (P,Q) = (x(P), x(Q))_v$],
    [$⟨delta_v P, N_* delta_v Q⟩_v$, via Lemmas C--E],
  [Lemma 2, giving $(c(P), -1)_v = 1$],
    [$beta_v$ is alternating on $W_v$],
  [Lemmas A and B], [$beta_q equiv 0$ at bad odd $q$],
  [$c(E_d (QQ_2)) = {1,5,2,10}$, symbol non-degenerate],
    [$beta_2 equiv.not 0$ on the Lagrangian $W_2$],
  [Hilbert reciprocity], [$sum_v "inv"_v beta_v = 0$],
  [$\#H <= 2$], [the rational image in $W_2$ is $beta_2$-isotropic],
  [$c$ locally constant, $U$ open and missed],
    [$W_2$ is the Frattini quotient; topological Nakayama],
)

#v(2mm)

Read this way the theorem is §5.1.5's mechanism run at level 2, and it goes
further than §5.1.5 could at level 3 on both of the points that document leaves
open: the alternating property, which there needs $E[3]$ decomposable, is
Lemma 2 here; and the local input $beta_3 equiv.not 0$, which there needs a
cubic norm-residue symbol at a wildly ramified place, is here the mod-8 table of
@sec-img2. That is not a coincidence: at level 2 the norm-residue symbol is
*quadratic*, which is elementary and which `hilbert` computes, while at level 3
it is cubic.

=== The measurements <sec-measured>

Before the proof existed, the prediction it makes was tested directly: the image
of $E_d (QQ)$ in $W_2 = E_delta (QQ_2) slash 2$ should be isotropic, hence of
dimension $<= 1$, and the line it spans should *vary* with $d$ --- an isotropic
line is not a preferred line, which is how a pairing differs from a linear
functional. $E_delta (QQ_2)$ is pro-2 here ($M_2 = 16$ is a 2-power and $E_2$ is
torsion-free), so $W_2$ is its Frattini quotient and the quotient map onto
$A slash 2A$, $A = E_delta (QQ_2) slash E_2$ of order 16, is an isomorphism;
working in $A$ makes every test a valuation.

#table(
  columns: 6, align: (left, right, center, center, center, left),
  stroke: 0.4pt + luma(170), inset: (x: 6pt, y: 3pt),
  table.header([class], [twists with $>= 2$ gens], [$dim = 0$], [$dim = 1$],
               [$dim = 2$], [lines seen among the $dim = 1$]),
  [$[2]$ *defective*],  [168], [14], [154], [*0*],  [73 / 34 / 47 --- all three],
  [$[14]$ *defective*], [168], [14], [154], [*0*],  [73 / 34 / 47 --- all three],
  [$[6]$ witnessed],    [133], [0],  [93],  [40],   [one line only],
  [$[10]$ witnessed],   [132], [0],  [93],  [39],   [one line only],
  [$x^3 + 2x$, $[2]$],  [127], [0],  [27],  [100],  [one line only],
)

#v(2mm)

Both halves hold: in the two defective classes not one of the 168 twists reaches
dimension 2, while the witnessed classes reach it 39--40 times and $x^3 + 2x$
reaches it in 100 of 127; and the defective images are spread over *all three*
lines, so no linear functional vanishes on all of them. @sec-thm2 explains it:
an isotropic line of a non-degenerate alternating form is precisely a line that
is forced to exist without being preferred.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *Why two classes and not one.* For $f = x^3 + A x$ the twist is
  $E_d : y^2 = x^3 + A d^2 x$, which depends on $d^2$: $E_d$ and $E_(-d)$ are the
  *same curve*. So the classes $delta$ and $-delta$ pose literally the same
  question, and the whole $p = 2$ witness row of $x^3 + x$ is antisymmetric
  ($-15, 3, -3, 15 thin | thin 0, -10, 10, 0$). The defect is one square class,
  seen twice. The sextic family has no such collapse, since $B d^3$ does
  distinguish $plus.minus d$.
]

== Witnesses, all odd $p < 200$ <sec-cm-primes>

#cmprimetables


= Twisted pairings at non-CM surfaces <sec-nonCM>

@sec-ledger-odd found that all seven open classes of @sec-fail carry the pairing
signature --- reaches isotropic, every line occurring, none preferred. This
section constructs the pairing in four of them, all at *non-CM* surfaces, which
settles that the mechanism is not about complex multiplication. They run at
three different levels --- $ell = 2$ in @sec-15a1 and @sec-15a4, $ell = 3$ in
@sec-14a1, $ell = 5$ in @sec-11a1 --- and the level-3 case reaches the cubic
symbols §5.1.5 could not evaluate. @sec-magma then closes the one local input
§5.1.5 itself left open, and @sec-triage asks what the module structure permits
in the three classes still untouched.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *Notation for the values of $beta$.* $beta_v$ takes values in
  $"Br"(QQ_v)[ell] tilde.equiv (1 slash ell) ZZ slash ZZ$, which we write
  *additively*: the trivial value is $0$ and reciprocity reads
  $sum_v beta_v = 0$. At $ell = 2$ it is more natural to write the pairing as a
  quadratic Hilbert symbol, with values $plus.minus 1$ written
  *multiplicatively*: there the trivial value is $+1$ and reciprocity reads
  $product_v beta_v = 1$. These are the same thing under
  $plus.minus 1 tilde.equiv (1 slash 2) ZZ slash ZZ$. Each section below keeps
  to one convention --- @sec-15a1 and @sec-15a4 multiplicative, @sec-14a1 and
  @sec-11a1 additive --- and where the distinction is immaterial we say that
  $beta_v$ is *trivial* or *non-trivial* rather than naming a value.
]

== A condition on $d$ is not free <sec-class-warning>

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  Each theorem below proves something about $E_d (QQ)$ for $d$ in a square class, and then draws a
  conclusion about the *surface*. The second step needs the first to hold for *every* $d$ in the
  class, and it is easy to get this wrong.

  #v(1.5mm)
  The reason is the decomposition. $X(QQ_p) = union.sq_delta (E_delta times E_delta)(QQ_p) slash
  plus.minus$ over the four square classes $delta$ of $QQ_p^times$, while
  $X(QQ) = union.sq_d (E_d times E_d)(QQ) slash plus.minus$ over the *global* squarefree $d$. The
  part of $X(QQ)$ sitting over one local class $delta$ is therefore the union of the
  $(E_d times E_d)(QQ)$ for *all* $d$ mapping to $delta$ --- a countable union. If each of those is
  a proper closed subgroup of $(E_delta times E_delta)(QQ_p)$ then, being a countable union of
  closed nowhere-dense sets, it is not dense (Baire), and $X(QQ)$ is not dense in $X(QQ_p)$. But if
  the theorem only covers *some* of the $d$ in the class, the remaining ones are unconstrained and
  may well fill the local class up: nothing about the surface follows.

  #v(1.5mm)
  So a theorem of the shape "for $d$ in the class *and* satisfying $C$, $E_d (QQ)$ is not dense"
  supports a statement about $X$ only when $C$ is vacuous on the class. All four theorems below
  clear this bar --- but @sec-11a1 and @sec-14a1 only after their conditions at $v = ell$ were
  removed, which took the lemma of @sec-11a1-five and the computation of @sec-14a1-places
  respectively. The bar is easy to miss.
]

== `15a1` at $p = 5$: level 2, $f$ split <sec-15a1>

Take `15a1`, $p = 5$, class $[1]$. Here
$ f = (x - 17)(x - 1)(x + 8), quad quad e = (17, 1, -8), $
so *$f$ splits over $QQ$* --- the row $n_QQ = 3$ of @sec-which's table. The
twist is $E_d : y^2 = (x - 17d)(x - d)(x + 8d)$, and the three descent maps of
@sec-alt become
$ c_i (P) = x(P) - d e_i, quad c_i (T_i) = product_(j != i) d(e_i - e_j),
  quad c_1 c_2 c_3 = y^2 . $

=== Choosing the endomorphism <sec-15a1-choose>

$E[2]$ is now the *trivial* Galois module, so $"End"_G (E[2]) = M_2 (bb(F)_2)$:
in contrast with $x^3 + x$, where the twisting endomorphism was essentially
unique, here they are not scarce at all, and $phi$ has to be *chosen*. Writing
$a = (c_1 (P), c_2 (P))$ and $b = (c_1 (Q), c_2 (Q))$ as coordinates on
$H^1 (QQ_v, E[2]) = (QQ_v^times slash (QQ_v^times)^2)^2$, every
$phi in "End"_G (E[2])$ produces a pairing of the shape
$ beta_n (P, Q) = product_(i, j in {1,2}) (c_i (P), c_j (Q))_v^(n_(i j)),
  quad quad n in M_2 (bb(F)_2), $
and all 16 of them arise. The *untwisted* Tate pairing is the antidiagonal
$n = mat(0,1;1,0)$, which dies on $W_v$ because $W_v$ is Lagrangian --- that is
the $1 = 1$ the twist has to break.

Two conditions pin $n$ down.

*First, $beta_5$ must be non-trivial on $W_5$.* Sampling $E_d (QQ_5)$ for $d$ in the
class gives the local image

#align(center, table(
  columns: 4, align: (right, center, center, center),
  stroke: 0.4pt + luma(170), inset: (x: 8pt, y: 3pt),
  table.header([$d$], [$c_1$], [$c_2$], [$c_3$]),
  [1],  [$1, u, 5, 5u$], [$1$], [$1, u, 5, 5u$],
  [-1], [$1, u, 5, 5u$], [$1$], [$1, u, 5, 5u$],
  [11], [$1, u, 5, 5u$], [$1$], [$1, u, 5, 5u$],
  [19], [$1, u, 5, 5u$], [$1$], [$1, u, 5, 5u$],
))

#v(2mm)

In every case $c_2$ is a *square* on $E_delta (QQ_5)$, so $c_3 = c_1 c_2 = c_1$
there, while $c_1$ is *onto* $QQ_5^times slash (QQ_5^times)^2$. Hence every
$beta_n$ collapses on $W_5$ to $(c_1 (P), c_1 (Q))_5^(n_11)$, which is
non-trivial exactly when $n_11 = 1$.

*Second, $beta_v$ must be trivial at every $v != 5$*, or reciprocity localises
nothing. Testing all 16 candidates on 7318 rational pairs drawn from 150 twists
leaves exactly four, and two of those are the ones with $n_11 = 1$:

#align(center, table(
  columns: 3, align: (center, left, left),
  stroke: 0.4pt + luma(170), inset: (x: 8pt, y: 3pt),
  table.header([$n$], [$beta_n$], [ ]),
  [$mat(0,0;0,0)$], [trivial], [--],
  [$mat(0,1;1,0)$], [$(c_1 (P), c_2 (Q))(c_2 (P), c_1 (Q))$],
    [the untwisted pairing, trivial on $W_v$],
  [$mat(1,1;0,0)$], [$(c_1 (P), c_1 (Q) c_2 (Q)) = (c_1 (P), c_3 (Q))$], [*the twist*],
  [$mat(1,0;1,0)$], [$(c_1 (P) c_2 (P), c_1 (Q)) = (c_3 (P), c_1 (Q))$], [its transpose],
))

#v(2mm)

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  $ beta_v (P, Q) = (c_1 (P), space c_3 (Q))_v
    = ( x(P) - 17 d, space x(Q) + 8 d )_v . $
]

The two survivors are transposes, and their product is the untwisted pairing,
which is $1$ on $W_v$: so $beta_v (Q, P) = beta_v (P, Q)$ there --- $beta$ is
*symmetric* on $W_v$, as it must be.

=== The local statements <sec-15a1-local>

*$beta_5$ is alternating and non-trivial on $W_5$.* From
$c_1 - c_3 = -25 d$ and the Steinberg relation one gets, for a single point,
$ (c_1, c_3)_v = (c_2, d)_v dot (c_3, -1)_v . $
At $v = 5$ both factors are trivial: $c_2$ is a square on $E_delta (QQ_5)$ by
the table, and $-1$ is a square in $QQ_5$ because $5 equiv 1 (mod 4)$. So
$beta_5 (P,P) = +1$. And $beta_5$ is non-trivial, since $c_1$ is onto and
$(5, u)_5 = -1$. A non-trivial alternating form on the 2-dimensional $W_5$ is
symplectic, so its isotropic subspaces have dimension $<= 1$.

*$beta_infinity = 1$.* For $d > 0$ the roots are $-8d < d < 17d$, so real points
have $x >= -8d$ and $c_3 >= 0$; for $d < 0$ they are $17d < d < -8d$, so
$x >= 17d$ and $c_1 >= 0$. Either way one argument is non-negative and the
symbol is $+1$.

*$beta_q = 1$ for $q in.not {2, 3, 5}$ with $q divides.not d$.* The $c_i$ differ
by $d(e_i - e_j) in {16d, 25d, 9d}$, so for such $q$ at most one $c_i$ is a
non-unit, and then $v_q (c_i) = v_q (y^2)$ is even. Both arguments are units and
the symbol is $+1$.

That the root differences $16, 25, 9$ are *perfect squares* is what confines the
remaining places to $2$, $3$, $5$ and the divisors of $d$ --- and $5$ survives
because $e_1 - e_3 = 25$.

*The places $2$, $3$ and $q divides d$.* Here $beta_q$ vanishes identically on
the *local* group, which is stronger than vanishing on rational pairs. Over all
202 squarefree $d$ in the class with $|d| <= 400$: *640 of 640* such places
checked, $beta_q equiv 1$ at every one; and $beta_5$ is non-trivial on $W_5$ for all 202.
This is verified, not proved.

=== The theorem <sec-15a1-thm>

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Theorem (modulo the local vanishing at $2$, $3$ and $q divides d$).* For
  $f = (x-17)(x-1)(x+8)$ and every squarefree $d$ in the class $[1]$ of
  $QQ_5^times$, the group $E_d (QQ)$ is not dense in $E_d (QQ_5)$; hence
  $X(QQ)$ is not dense in $X(QQ_5)$.

  #v(2mm)
  _Proof._ $beta_v (P,Q) = (c_1 (P), c_3 (Q))_v$ is $+1$ at $v = infinity$, at
  every $q in.not {2,3,5}$ prime to $d$, and --- by the verification above --- at
  $2$, $3$ and each $q divides d$. Hilbert reciprocity
  $product_v (c_1 (P), c_3 (Q))_v = 1$ then forces $beta_5 (P,Q) = 1$ for all
  $P, Q in E_d (QQ)$. So the image of $E_d (QQ)$ in $W_5$ is isotropic for
  $beta_5$, which is a non-trivial alternating form on the 2-dimensional $W_5$;
  the image therefore has dimension $<= 1$ and is not all of $W_5$. As
  $W_5 = E_delta (QQ_5) slash 2$ is the Frattini quotient, $E_d (QQ)$ is not
  dense. $qed$
]

Three remarks.

*The mechanism is not about CM.* `15a1` has $j = 111284641 slash 50625$ and no
complex multiplication, and the pairing is of exactly the shape @sec-thm2
exhibits for $x^3 + x$. What §5.1.1 explains for $x^3 - 2$ is *which* class
fails, not why any class fails at all.

*The pairing explains the measurement.* @sec-ledger-odd found the reaches at `15a1`,
$p = 5$ spread over all three lines of $(ZZ slash 2)^2$, $180 slash 129 slash 170$
--- and an isotropic line of a symplectic form is precisely a line that is
forced to exist without being preferred.

*The endomorphism had to be chosen, not found.* For $x^3 + x$ the module $E[2]$
was indecomposable and $phi$ was essentially unique; here $E[2]$ is split and
$"End"_G (E[2])$ is all of $M_2 (bb(F)_2)$, so the content moved from *existence*
to *selection* --- the two conditions of @sec-15a1-choose cut 16 candidates down
to one, up to transpose. That is the part of the construction that would have to
be redone for each remaining class; @sec-triage says which of them can expect
to avoid it.


== `14a1` at $p = 7$: the same at level 3 <sec-14a1>

The second construction runs at a different *level*. @sec-ledger-odd puts the
obstruction for `14a1` at $ell = 3$, not 2 --- so this needs 3-descent and cubic
norm-residue symbols, exactly the machinery §5.1.5 records as missing. It works
anyway, for a reason worth isolating: *the critical place is 7, not 3*, and
$7 equiv 1$ $(mod 3)$, so the symbol there is *tame*.

=== $E[3]$ is decomposable, so §5.1.5 applies on the nose <sec-14a1-str>

$ psi_3 = 3x^4 + x^3 + 27x^2 - 69x - 26 = (x-2)(3x+1)(x^2 + 2x + 13) . $
Two rational roots, hence *two* Galois-stable lines in $E[3]$ --- confirmed by
`ellisomat`, which gives two independent 3-isogenies. So $E[3] = C_1 xor C_2$
is *decomposable*, and §5.1.5's route to a twisting endomorphism, projection onto
a summand, is open. (Contrast $x^3 + x$, where $E[2]$ was indecomposable and the
non-scalar $phi$ had to come from the non-semisimplicity of $bb(F)_2 [ZZ slash 2]$.)

$C_1 = ⟨(2,2)⟩$ consists of rational points, so $C_1 tilde.equiv ZZ slash 3$; by
the Weil pairing $C_2 tilde.equiv mu_3$, and indeed the other subgroup has
$x = -7 slash 3$ with $y in QQ(sqrt(-3)) = QQ(zeta_3)$.

Moving $T_1$ to the origin and shearing so its tangent is $y = 0$ puts the curve
in *3-torsion normal form*,
$ E : y^2 + 5 x y + 7 y = x^3, quad T_1 = (0,0),
  quad quad E_d : Y^2 = 4X^3 + d (5X + 7d)^2 . $
For any $T$ of order 3 the tangent at $T$ meets $E$ only there, so
$op("div")(ell_T) = 3(T) - 3(O)$ and the descent map attached to $⟨T⟩$ is
$c_T (P) = ell_T (P)$ modulo *cubes*. For $T_1$ the tangent is $y = 0$, so
$c_1 (P) = y(P)$ --- the level-3 analogue of $c(P) = x(P)$.

With $phi$ the projection onto $C_1$,
$ beta_v (P, Q) = ⟨delta_v P, phi delta_v Q⟩_v = -⟨c_2 (P), space c_1 (Q)⟩_v . $

=== The critical place is tame <sec-14a1-seven>

$7 equiv 1$ $(mod 3)$, so $zeta_3 in QQ_7$ and *both* kernels are rational over
$QQ_7$: $E[3](QQ_7) = (ZZ slash 3)^2$ and $W_7 = E_delta (QQ_7) slash 3$ has
dimension 2, matching the layer @sec-ledger-odd measured. Both $c_i$ then land in
$QQ_7^times slash (QQ_7^times)^3 tilde.equiv (ZZ slash 3)^2$, and the pairing is
the *tame cubic Hilbert symbol*.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  This is the point of difference with §5.1.5. There the critical place *was*
  $ell = 3$, where the cubic symbol is wildly ramified and needs an explicit
  reciprocity law --- which is why that document long left
  $beta_3 equiv.not 0$ unproved (@sec-magma closes it, but by a coset count, not
  by evaluating a symbol). Here the critical place is $7$, the symbol is tame,
  and the tame formula
  $(a,b)_v = ((-1)^(alpha beta) a^beta slash b^alpha)^((q-1) slash 3)$ evaluates
  it outright.
]

Sampling $E(QQ_7)$ shows the image of $(c_1, c_2)$ is the *diagonal* of
$(QQ_7^times slash (QQ_7^times)^3)^2$, of size 9 --- so $c_1$ alone identifies
$W_7$ with $QQ_7^times slash (QQ_7^times)^3$ and
$beta_7 (P,Q) = -(c_1 (P), c_1 (Q))_7$. Its table on the nine classes
$7^a u$, $a = 0,1,2$, $u = 1, 3, 2$:

Tabulating it on all 81 pairs: 48 of the values are non-zero, and every diagonal
value $(a,a)_7$ is $0$ --- so the form is non-degenerate and alternating. The
diagonal vanishes because $-1 = (-1)^3$ is a cube, so $(a,a)_7 = (a,-1)_7 = 0$.
A non-zero alternating form on $(ZZ slash 3)^2$ is symplectic, and its isotropic
subspaces are the four lines --- exactly the four @sec-ledger-odd counted, hit
$120 slash 126 slash 139 slash 118$ times.

=== Every other place, structurally <sec-14a1-places>

*$beta$ is alternating at every place, for free.* This is §5.1.5's argument and it
applies verbatim, because $E[3]$ is decomposable: write $delta_v P = a_1 + a_2$
with $a_i in H^1 (QQ_v, C_i)$; each $H^1 (C_i)$ is isotropic since the Weil
pairing is trivial on the cyclic $C_i$; $W_v$ is isotropic, so
$0 = ⟨delta_v P, delta_v P⟩ = 2 ⟨a_1, a_2⟩$ and $2$ is invertible mod 3, whence
$beta_v (P,P) = ⟨a_1, a_1⟩ + ⟨a_2, a_1⟩ = 0$. *So $beta_v equiv 0$ whenever
$dim W_v <= 1$*, and the whole place analysis reduces to computing $dim W_v$.

For $v divides.not 3$, $dim W_v = dim E_d [3](QQ_v)$; at $v = 3$ it is one more.
And since $C_1^((d)) tilde.equiv ZZ slash 3 times.o chi_d$ and
$C_2^((d)) tilde.equiv mu_3 times.o chi_d$,
$ C_1^((d)) (QQ_v) != 0 <==> d in (QQ_v^times)^2, quad quad
  C_2^((d)) (QQ_v) != 0 <==> -3d in (QQ_v^times)^2, $
so *both* hold only if $-3$ is a square in $QQ_v$. That is false at $2$
($-3 equiv 5$ mod 8) and at $3$ (odd valuation), and true at $7$
($-3 equiv 4 equiv 2^2$). Hence:

#table(
  columns: 3, align: (left, left, left),
  stroke: 0.4pt + luma(170), inset: (x: 7pt, y: 3.5pt),
  table.header([place], [why], [$beta_v$]),
  [$v = infinity$], [$E_d (RR)$ is 3-divisible, so $W_infinity = 0$], [$0$],
  [$v$ good, $v != 3$], [$W_v = H^1_"ur"$ is its own annihilator and $phi$
    preserves it], [$0$],
  [$v = 2$], [$-3$ is not a square in $QQ_2$, so $dim W_2 <= 1$], [$0$],
  [$v = q divides d$, $q != 3$], [$v_q (d) = v_q (-3d) = 1$ is odd, so
    $W_q = 0$], [$0$],
  [$v = 3$], [$dim W_3 = 1 + dim E_d [3](QQ_3)$], [$0$ iff that is $1$],
  [$v = 7$], [$dim W_7 = 2$, symbol non-degenerate], [$!= 0$],
)

#v(2mm)

Only $v = 3$ could impose a condition, and it turns out not to. The point to exploit is that
*$E_d$ over $QQ_3$ depends on $d$ only through its class in $QQ_3^times$ modulo squares*, and for
squarefree $d$ there are exactly *four* such classes. So four local computations settle every twist
at once --- this is a complete check, not a sample.

#align(center, table(
  columns: 5, align: (left, center, center, left, left),
  stroke: 0.4pt + luma(170), inset: (x: 7pt, y: 3.5pt),
  table.header([class of $d$ in $QQ_3^times slash 2$], [$dim W_3$], [reduction at 3],
               [why $L_3$ is $phi_*$-stable], [$beta_3$]),
  [$[u]$: $3 divides.not d$, $d equiv 2$], [1], [good], [nothing to check], [$0$],
  [$[3]$: $3 divides d$, $d slash 3 equiv 1$], [1], [additive $"I"_0^*$],
    [nothing to check], [$0$],
  [$[1]$: $3 divides.not d$, $d equiv 1$], [2], [good, *ordinary* ($a_3 = -2$)],
    [both intersections have dimension 1], [$0$],
  [$[3u]$: $3 divides d$, $d slash 3 equiv 2$], [2], [additive $"I"_0^*$, $c_3 = 2$],
    [$L_3$ lies *inside* one $H_i$], [$0$],
))

#v(2mm)

The first two rows are free: $beta$ is alternating, so it vanishes on a space of dimension $<= 1$.

The third row is the lemma of @sec-11a1-five. $d$ a square in $QQ_3$ forces $3 divides.not d$, so
$E_d tilde.equiv E_0$ over $QQ_3$ with good reduction, and $a_3 = -2$ is prime to 3, so the
reduction is *ordinary* and the lemma applies verbatim. `vell.gp` confirms it: *54 of 173* and
*102 of 2245* dual images escape $3E(QQ_3)$, so both $ker alpha_i$ are non-zero, each therefore has
dimension 1, and $L_3$ is $phi_*$-stable.

The fourth row is the one that took work, and getting it wrong twice is worth recording.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *A criterion that is sufficient but not necessary.* $L_3$ is $phi_*$-stable iff
  $L_3 = (L_3 inter H_1) xor (L_3 inter H_2)$, and the two intersections have dimensions
  $dim ker alpha_2$ and $dim ker alpha_1$. If both are non-zero then, $L_3$ being 2-dimensional,
  each has dimension 1 and the sum is direct --- so *both non-zero* implies stable. The converse
  fails: if $L_3$ lies inside a single $H_i$ then that intersection has dimension 2, the other is
  zero, and $L_3$ is a direct sum trivially, hence still stable. A computation showing one
  intersection zero and the other non-zero therefore decides *nothing* until the dimension of the
  non-zero one is known. `vell.gp` tested only non-vanishing; an earlier version of this section
  read its output as a negative verdict, and that was wrong.
]

Since $ker alpha_1 inter ker alpha_2 = ker delta_3 = 0$, the two dimensions sum to at most
$dim W_3 = 2$, with equality exactly when $L_3$ is $phi_*$-stable. So it is enough to measure one
of them, and `alpha3.gp` does it without any $p$-adic arithmetic on isogeny images. In the fourth
row the line $C_2^((d))$ *is* $QQ_3$-rational --- that is what $-3d$ being a square says --- so it
is generated by a point $S$ with $y(S) in QQ_3$, and by @sec-brauer-twofns the corresponding
component of the Kummer map is evaluation of the function with divisor $3(S) - 3(O)$, which for a
point of order 3 is the tangent:
$ alpha(P) = y(P) - y_S - m (x(P) - x_S) quad (mod "cubes"), quad m = g'(x_S) slash 2 y_S . $
Its values lie in $QQ_3^times slash (QQ_3^times)^3$, of order 9, and a class there is fixed by
$v_3$ modulo 3 together with the unit part *modulo 9* --- since $1 + 9 ZZ_3$ consists of cubes and
$-1$ is a cube. So no precision is lost, and the answer is exact.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  In the class $[3u]$ the image of $alpha$ is *trivial*: every sampled value is a cube, over six
  representatives $d = -3, 33, 51, 267, -66, 87$. So $ker alpha = W_3$, $L_3$ lies inside a single
  $H_i$, and $L_3$ is $phi_*$-stable --- hence $beta_3 = 0$ there too.
]

The check is not vacuous: `alpha3.gp` also verifies that the sampled points *generate*
$E_d (QQ_3) slash E_2$ --- 18 of 18 in every case --- and $alpha$ is a homomorphism with
$3 E supset.eq E_2$, so a trivial image on a generating set is a trivial image. For contrast, the
same computation in the third row returns *three* classes, i.e. $dim ker alpha = 1$, matching
`vell.gp` there.

*So $beta_3 = 0$ for every squarefree $d$*, and $v = 3$ imposes no condition at all.

=== The theorem <sec-14a1-thm>

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Theorem.* Let $d$ be squarefree in the class $[1]$ of $QQ_7^times$ --- *any* such $d$, with no
  further condition. Then $E_d (QQ)$ is not dense in $E_d (QQ_7)$. Since that holds for every $d$
  in the class, $X(QQ)$ is not dense in $X(QQ_7)$ for $X : y^2 = f(x) f(t)$,
  $f = x^3 + 10x^2 + 105x - 116$.

  #v(2mm)
  The hypothesis is vacuous on the class, which is what @sec-class-warning demands; it took two
  corrections to get there, both recorded in @sec-14a1-places.

  #v(2mm)
  _Proof._ $beta$ is alternating at every place, so $beta_v = 0$ wherever
  $dim W_v <= 1$; that is every $v != 3, 7$, and $v = 3$ as well by the four-class table of
  @sec-14a1-places. Reciprocity
  $sum_v "inv"_v beta_v = 0$ then gives $beta_7 (P,Q) = 0$ for all
  $P, Q in E_d (QQ)$. On $W_7$, $beta_7$ is the tame cubic symbol transported by
  $c_1$, non-zero and alternating on a 2-dimensional $bb(F)_3$-space, hence
  symplectic; the image of $E_d (QQ)$ is isotropic and so has dimension $<= 1$.
  It is therefore not all of $W_7 = E_delta (QQ_7) slash 3$, the Frattini
  quotient at the layer, and $E_d (QQ)$ is not dense. $qed$
]

Two things distinguish this from @sec-15a1.

*Almost nothing was verified numerically.* At level 2 the alternating property had to be
proved by hand (`x^3 + x`) or the local vanishing checked by machine (`15a1`).
Here decomposability hands over the alternating property, and the places then
fall out of a single fact --- $-3$ is a square in $QQ_7$ and in neither $QQ_2$
nor $QQ_3$. The computations are the symbol table at 7 and, at the wild place, the
$phi_*$-stability check of @sec-14a1-places.

*What is missing is not a symbol but a mechanism.* An earlier version of this section said the
remaining twists needed the wild cubic norm-residue symbol at 3, the thing §5.1.5 also lacked.
Both halves of that have changed. The symbol is no longer missing --- @sec-brauer-3-wild computes
it --- and it is no longer what stands in the way: for $d equiv 1$ $(mod 3)$ the place is settled
structurally, and for $3 divides d$ with $d slash 3 equiv 2$ what was needed was the *dimension* of an
intersection, not any symbol.

#align(center, table(
  columns: 5, align: (left, center, center, center, left),
  stroke: 0.4pt + luma(170), inset: (x: 6pt, y: 3pt),
  table.header([case], [level], [critical place], [$E[ell]$], [status]),
  [$x^3 - 2$ (§5.1.5)], [3], [3 --- *wild*], [decomposable],
    [$beta_3 equiv.not 0$ closed in @sec-magma],
  [$x^3 + x$ (@sec-thm2)], [2], [2], [*indecomposable*], [complete],
  [`15a1` (@sec-15a1)], [2], [5], [split over $QQ$],
    [local vanishing verified],
  [`14a1` (@sec-14a1)], [3], [7 --- *tame*], [decomposable], [complete],
))


== `15a4` at $p = 5$: the $x^3 + x$ template, verbatim <sec-15a4>

The triage of @sec-triage predicted this one would follow @sec-thm2. It does ---
and shifting by the rational root makes it literally the same shape.
$f = (x-1)(x^2 + 12x + 612)$, and $f(x+1) = x^3 + 14x^2 + 625x$, a shift with
$c = 1$ and therefore the same surface. So

$ f = x (x^2 + 14 x + 625), quad quad
  E_d : y^2 = x (x^2 + 14 d x + 625 d^2), quad T = (0,0), $
with $c(P) = x(P)$ and $c(T) = 625 d^2$, a square. The point is the identity
$ x^2 + 14 d x + 625 d^2 = (x + 7d)^2 + (24 d)^2 , $
a *sum of two squares*: $a^2 - 4b = -2304 d^2 equiv -1$, the 2-torsion field is
$QQ(i)$, and Lemma 2 of @sec-alt applies unchanged --- $c(P)$ is a norm from
$QQ(i)$, so $(c(P), -1)_v = 1$ and *$beta$ is alternating at every place*.

#table(
  columns: 3, align: (left, right, right),
  stroke: 0.4pt + luma(170), inset: (x: 7pt, y: 3pt),
  table.header([over the 202 twists in the class], [tested], [failures]),
  [Lemma 1 (Vieta): $c$ a homomorphism], [2444 triples], [*0*],
  [Lemma 2: $(c(P), a^2 - 4b)_v = 1$], [10036 evaluations], [*0*],
  [$beta_v (P,P) = +1$, every point and place], [10036 evaluations], [*0*],
)

=== The places <sec-15a4-places>

- *$v = infinity$.* The quadratic is a sum of two squares, hence positive, so
  $y^2 = x dot (>0)$ forces $x >= 0$ on real points and the symbol is $+1$. This
  is cleaner than @sec-places2, where the sign of $d$ had to be split on.

- *$q divides.not 2 dot 5 dot d$.* With $x = a slash e^2$, $y = b slash e^3$ and
  $b^2 = a(a^2 + 14 d a e^2 + 625 d^2 e^4)$, a common prime factor of the two
  divides $625 d^2 e^4$, hence $625 d^2$. So for such $q$ the factors are coprime,
  $v_q (c(P))$ is even, both arguments are units and the symbol is $+1$. Note the
  bad places are only $2$, $5$ and the divisors of $d$ --- there is no analogue of
  the $3$ that @sec-places2 had to handle.

- *$q$ odd, $q divides d$.* Lemmas A and B of @sec-places2 apply verbatim: their
  proof uses only that a 1-unit is a square at an odd place. The image of $c$ is
  cyclic, and an alternating form on a cyclic group is trivial.

- *$q = 2$.* Here the 1-unit argument fails and the image has to be computed. It
  comes out cyclic --- ${1}$, ${1,5}$ or ${1,10}$ --- in *all 202* twists, so
  $beta_2 equiv 1$. This is the one step verified rather than proved, and it is the
  only one: @sec-15a1 had three.

- *$q = 5$.* The image of $c$ on $E_delta (QQ_5)$ is *all four* classes
  ${1, u, 5, 5u}$, in all 202 twists, so the symbol is non-degenerate; and it is
  alternating because $5 equiv 1$ $(mod 4)$ makes $-1$ a square in $QQ_5$. So
  $beta_5$ is symplectic on the 2-dimensional $W_5$.

#table(
  columns: 4, align: (left, center, center, center),
  stroke: 0.4pt + luma(170), inset: (x: 7pt, y: 3pt),
  table.header([place], [checks], [$beta_v$ non-trivial], []),
  [$q = 5$ (critical)], [202 twists], [*202*], [symplectic on $W_5$],
  [$q = 2$], [202 twists], [0], [image cyclic],
  [$q$ odd, $q divides d$], [288 places], [0], [Lemmas A, B],
)

=== The theorem <sec-15a4-thm>

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Theorem (modulo the local vanishing at $2$).* For
  $f = x(x^2 + 14x + 625)$ --- that is, `15a4` --- and every squarefree $d$ in
  the class $[1]$ of $QQ_5^times$, the group $E_d (QQ)$ is not dense in
  $E_d (QQ_5)$; hence $X(QQ)$ is not dense in $X(QQ_5)$.

  #v(2mm)
  _Proof._ $beta_v (P,Q) = (c(P), c(Q))_v$ is $+1$ at $v = infinity$, at every
  $q divides.not 2 dot 5 dot d$, at every odd $q divides d$, and --- by the
  verification above --- at $q = 2$. Hilbert reciprocity then forces
  $beta_5 (P,Q) = +1$ for all $P, Q in E_d (QQ)$. On $W_5$, $beta_5$ is a
  non-trivial alternating form on a 2-dimensional $bb(F)_2$-space, hence symplectic,
  so the image of $E_d (QQ)$ is isotropic and of dimension $<= 1$. It is
  therefore not all of $W_5 = E_delta (QQ_5) slash 2$, and $E_d (QQ)$ is not
  dense. $qed$
]

The measurement agrees: across 231 twists in the class, all *1079* rational
pairs give $(c(P), c(Q))_5 = +1$, exactly as the theorem says they must. And
@sec-ledger-odd's reaches for `15a4` --- spread over all three lines of
$(ZZ slash 2)^2$ at $82 slash 138 slash 104$ --- are the isotropic lines of this
symplectic form.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *What the triage bought.* @sec-triage predicted, from the module structure
  alone, that `15a4` would follow the $x^3 + x$ template and that Lemma 2 would
  apply because
  its 2-torsion field is $QQ(i)$. Both held, and the construction then took no
  searching at all --- unlike @sec-15a1, where $E[2]$ was split, $phi$ was not
  determined, and 16 candidates had to be tried. Indecomposable $E[2]$ makes the
  twisting endomorphism essentially unique, which is why this case is the
  shortest of the four.
]


== `11a1` at $p = 11$: level 5, and no quintic symbol needed <sec-11a1>

@sec-triage flagged this one as needing the *quintic* residue symbol at 11.
It turns out not to: the proof needs $beta_11$ to be *non-degenerate*, not to be
*evaluated*, and multiplicative reduction settles that structurally.

A caveat first, of the kind @sec-triage-data warns about. The reduced monic cubic
$x^3 - 11x^2 - x - 83$ has $N = 704$ and trivial torsion --- it is a twist of the
labelled curve. Take instead $E_0 = $ `11a1` $= [0,-1,1,-10,-20]$, of conductor
11, with torsion $ZZ slash 5$ generated by $T = (5,5)$; then the family is
$E_0^((d))$, and the failing class is $[1]$ at 11, i.e. $d$ a square in
$QQ_11^times$. $psi_5$ has two rational factors, so $E[5] = C_1 xor C_2$ is
decomposable with $C_1 = ⟨T⟩ tilde.equiv ZZ slash 5$ and, by the Weil pairing,
$C_2 tilde.equiv mu_5$.

=== $beta_11$ is non-degenerate, by the Tate curve <sec-11a1-local>

$E_0$ has *split multiplicative* reduction at 11 ($a_11 = 1$, type $I_5$,
$c_11 = 5$), so over $QQ_11$ it is a Tate curve,
$E_0 (QQ_11) tilde.equiv QQ_11^times slash q^ZZ$ with $v_11 (q) = 5$.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *$W_11 = H^1 (QQ_11, mu_5)$ for the Tate $mu_5$.* For $P = [x]$ the Kummer
  cocycle is $sigma |-> sigma(y) slash y$ with $y^5 in x q^ZZ$; writing
  $y = x^(1 slash 5) (q^(1 slash 5))^m$ shows $sigma(y) slash y in mu_5$ for
  *every* $P$. So $W_11 subset.eq H^1 (QQ_11, mu_5)$. Both have dimension 2 ---
  $11 equiv 1$ $(mod 5)$, so $zeta_5 in QQ_11$ --- hence they are equal.
]

The Tate $mu_5$ is intrinsic: in the parametrisation $[x] |-> v(x)$ mod 5 is the
map to the component group $Phi_11 tilde.equiv ZZ slash 5$, and $mu_5 subset O^times$
is its kernel. So $mu_5 = E[5] inter E^0$.

Now $beta_11 (a,b) = -⟨a, phi_* b⟩$ with $phi$ the projection onto $C_1$ along
$C_2$. If the Tate $mu_5$ *were* $C_2$, then $phi$ would kill
$W_11 = H^1 (C_2)$ and $beta_11$ would vanish identically; if it were $C_1$,
then $beta_11$ would be the untwisted pairing, which also vanishes on the
Lagrangian $W_11$. So everything turns on whether the Tate $mu_5$ is one of the
two *global* subgroups --- and it is not:

#align(center, table(
  columns: 3, align: (left, left, left),
  stroke: 0.4pt + luma(170), inset: (x: 7pt, y: 3pt),
  table.header([subgroup], [$x$-coordinates mod 11], [in $E^0$?]),
  [singular point of $tilde(E)$], [$(5,5)$ --- *the 5-torsion point itself*], [---],
  [$C_1 = ⟨(5,5)⟩$], [$5$ and $16 equiv 5$], [*no*],
  [$C_2$: $5x^2 + 5x - 29$], [$op("disc") = 605 = 5 dot 11^2$, double root $-1 slash 2 equiv 5$],
    [*no*],
))

#v(2mm)

($sqrt(5) in QQ_11$, so $C_2$ is rational there and the reduction makes sense.)
Both global subgroups reduce onto the singular point, so neither lies in $E^0$
and the Tate $mu_5$ is a *third* line. Then $phi$ restricts to an isomorphism
$mu_5 -> C_1$, and the Weil pairing of two distinct lines of a symplectic plane
is perfect --- so

$ beta_11 (a,b) = -⟨a, phi_* b⟩ quad "is NON-DEGENERATE on" W_11 . $

*No quintic symbol is used.* One would need it to compute $beta_11$ on given
points; the proof needs only that it does not vanish, and that came from the
reduction type.

=== The other places <sec-11a1-places>

As in @sec-14a1-places, $beta$ is alternating at every place --- §5.1.5's
argument needs only that $E[5]$ is decomposable and $2$ is invertible mod 5 ---
so $beta_v = 0$ wherever $dim W_v <= 1$, and everything reduces to $dim W_v$.
With $C_1^((d)) tilde.equiv chi_d$ and $C_2^((d)) tilde.equiv mu_5 times.o chi_d$:

#table(
  columns: 3, align: (left, left, left),
  stroke: 0.4pt + luma(170), inset: (x: 7pt, y: 3.5pt),
  table.header([place], [why], [$beta_v$]),
  [$v = infinity$], [$E_d (RR)$ is 5-divisible, so $W_infinity = 0$], [$0$],
  [$v$ good, $v != 5$], [unramified isotropy], [$0$],
  [$q divides d$, $q != 5$], [$chi_d$ is ramified at $q$ and the cyclotomic character is not, so
    both $C_i^((d))(QQ_q) = 0$ and $W_q = 0$], [$0$],
  [$v = 5$], [the cyclotomic character mod 5 has order 4 on $G_5$ ($QQ_5 (zeta_5) slash QQ_5$ is
    totally ramified of degree 4) while $chi_d$ has order $<= 2$, so
    $C_2^((d))(QQ_5) = 0$ always and $dim W_5 = 1 + [d "square in" QQ_5]$],
    [$0$ --- see @sec-11a1-five],
  [$v = 11$], [$dim W_11 = 2$, $beta_11$ non-degenerate], [$!= 0$],
)

#v(2mm)

Note $11 divides.not d$ throughout, since the class is $[1]$ at 11.

=== The wild place $v = ell = 5$ <sec-11a1-five>

The row above is the only one that is not immediate, and an earlier version of this section left it
as a *condition* on $d$ --- which, as @sec-class-warning explains, would have been fatal. It is not
a condition: $beta_5$ vanishes for every $d$ in the class.

If $d$ is not a square in $QQ_5$ then $dim W_5 = 1$ and $beta_5 = 0$ because $beta$ is alternating.
So suppose $d$ *is* a square in $QQ_5$. Since $d$ is squarefree that forces $5 divides.not d$, so
$E_d tilde.equiv E_0$ over $QQ_5$ and $E_d$ has *good* reduction at 5 --- one curve to check, not a
family. And $a_5 (E_0) = 1$, not divisible by 5, so the reduction is *ordinary*.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Lemma.* Let $v = ell$ and suppose $E$ has good *ordinary* reduction at $ell$, with
  $E[ell] = C_1 xor C_2$ where $C_1 tilde.equiv ZZ slash ell$ is generated by a $QQ_ell$-rational
  point and $C_2 tilde.equiv mu_ell$. Then $L_ell = delta_ell (W_ell)$ is $phi_*$-stable, so
  $beta_ell equiv 0$.

  #v(2mm)
  _Proof._ Over $ZZ_ell$ the closure of $C_1$ is the constant, hence *étale*, group scheme
  $ZZ slash ell$, and the closure of $C_2$ is $mu_ell$, which is *connected* at residue
  characteristic $ell$. Ordinary reduction means the connected--étale sequence
  $0 -> cal(E)[ell]^0 -> cal(E)[ell] -> cal(E)[ell]^"ét" -> 0$ has both ends of order $ell$; so
  $cal(C)_2 = cal(E)[ell]^0$, and $cal(C)_1$ splits the sequence:
  $cal(E)[ell] = cal(C)_1 xor cal(C)_2$ as finite flat group schemes. At a place of good reduction
  the Kummer image is the flat subgroup $H^1_f$, which is functorial in the group scheme, so
  $L_ell$ splits along that decomposition. A split $L_ell$ is $phi_*$-stable, and Step 1 of §5.1.5
  gives $beta_ell equiv 0$. $qed$
]

`vell.gp` checks the conclusion directly, without the lemma, in the form Steps 4 and 5 of §5.1.5
give it: $L_ell$ is $phi_*$-stable iff *both* $ker alpha_1$ and $ker alpha_2$ are non-zero, i.e.
iff each dual isogeny image escapes $ell E(QQ_ell)$. That is decidable because
$ell E supset.eq ell E_1 = E_2$, so $ell E$ is a union of $E_2$-cosets. For `11a1` at 5, with
$dim W_5 = 2$: *2576 of 2704* sampled points of $B_1 (QQ_5)$ and *109 of 2511* of $B_2 (QQ_5)$ have
dual image outside $5 E(QQ_5)$. Both kernels non-zero, so $beta_5 = 0$.

=== The theorem <sec-11a1-thm>

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Theorem.* Let $d$ be squarefree and a square in $QQ_11^times$ --- that is, *any* $d$ in the
  class $[1]$, with no further condition. Then $E_0^((d))(QQ)$ is not dense in
  $E_0^((d))(QQ_11)$. Since that holds for *every* $d$ in the class, $X(QQ)$ is not dense in
  $X(QQ_11)$ for the surface `11a1`.

  #v(2mm)
  _Proof._ $beta$ is alternating at every place, so $beta_v = 0$ wherever
  $dim W_v <= 1$; that is every $v != 5, 11$ by the table, and $v = 5$ as well by
  @sec-11a1-five. Reciprocity
  $sum_v "inv"_v beta_v = 0$ gives $beta_11 (P,Q) = 0$ for all
  $P, Q in E_0^((d))(QQ)$. But $beta_11$ is non-degenerate on the 2-dimensional
  $W_11$, so the image of the rational points is a proper subspace, of dimension
  $<= 1$. It is therefore not all of $W_11 = E_delta (QQ_11) slash 5$, and the
  rational points are not dense. $qed$
]

@sec-ledger-odd's measurement agrees with the
conclusion: none of the 584 twists it examined reached the full
$(ZZ slash 5)^2$, and the six lines came up $92 slash 97 slash 97 slash 103 slash 77 slash 95$
times, which is what an alternating form on $(ZZ slash 5)^2$ forces --- *every*
line is isotropic there, so the only content is that dimension 2 is unreachable.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *The lesson for the triage.* @sec-triage checked that a non-scalar $phi$
  exists. That is necessary but not sufficient: one also needs $W_p$ not to be
  $phi$-stable, which is a further *local* condition --- and it is exactly the
  input §5.1.5 leaves open for $x^3 - 2$, closed in @sec-magma. At a place of
  multiplicative
  reduction it is decidable for free, because $W_p$ is then forced to be
  $H^1$ of the Tate $mu_ell$: the mechanism fires precisely when the Tate
  $mu_ell$ is neither $C_1$ nor $C_2$, i.e. when neither global subgroup meets
  $E^0$. For `11a1` neither $C_1$ nor $C_2$ meets $E^0$, and the pairing exists.
]

== §5.1.5's input, checked in Magma and then proved <sec-magma>

The local condition the previous section needed --- that $W_p$ not be
$phi$-stable --- is the one input §5.1.5 leaves open for $f = x^3 - 2$: there it
takes the form $beta_3 equiv.not 0$, equivalently that the images of *both* dual
3-isogenies lie in $E_1 (QQ_3)$. This section settles it. The statement had
already been checked twice --- the companion notes' PARI check built the duals by
hand, and Sage's `verify-dual.sage` constructed $QQ_3$-points and tested
membership --- and it is checked a third time here, in Magma, by a route that
constructs no points at all; the Magma run then makes visible why the check can
be replaced by a proof, which is what the second half of this section does. The
Magma script evaluates the dual isogeny's *rational maps*
`IsogenyMapPhi` / `IsogenyMapPsi` at 3-adic $x$-coordinates and reads off
$v_3 (x(hat(phi) P'))$, constructing no points at all.

#align(center, table(
  columns: 5, align: (right, center, center, right, center),
  stroke: 0.4pt + luma(170), inset: (x: 7pt, y: 3pt),
  table.header([$d$], [Kodaira at 3], [$c_3$], [points of $E'(QQ_3)$],
               [outside $E_1$]),
  [$-3$],  [$"IV"^*$], [3], [244 / 20], [*0 / 0*],
  [$6$],   [$"IV"^*$], [3], [244 / 20], [*0 / 0*],
  [$-21$], [$"IV"^*$], [3], [244 / 20], [*0 / 0*],
  [$87$],  [$"IV"^*$], [3], [244 / 20], [*0 / 0*],
)) 

#v(2mm)

(The two counts are the two kernels, $x$ and $x - 2d$; the difference is only how
many sampled $x$-coordinates happen to give points.) Magma also independently
returns $"IV"^*$ and $c_3 = 3$, the labels Sage corrected in the companion notes.

*Why this is more than a sample.* The image of
$hat(phi) : E'(QQ_3) -> A = E(QQ_3) slash E_1$ is a *subgroup* of $A$, and
$\#A = M = 9$. If it were non-trivial its kernel would have index at least 3, so
at least two thirds of $E'(QQ_3)$ would land outside $E_1$ --- observing none of
244 is a structural zero, not a near miss. The one caveat is that points with
$v_3 (x) < 0$ lie in $E'_1$ and map into $E_1$ automatically, so they test
nothing; the sample's informative part is the roughly 180 with $v_3 (x) >= 0$,
which do lie outside $E'_1$.

*And now a proof.* $hat(phi)(E'_1) subset.eq E_1$ --- an isogeny extends to the
Néron models, so it respects the kernel of reduction --- hence $hat(phi)$ induces
a map of the *finite* groups $A' = E'(QQ_3) slash E'_1 -> A = E(QQ_3) slash E_1$.
What has to be shown is that this induced map is zero, since that says exactly
that $hat(phi)(E'(QQ_3)) subset.eq E_1 (QQ_3)$. Because $A'$ and $A$ are finite,
showing it is a finite check rather than a sample --- and, as the last two rows
below show, a check on a single point:

#align(center, table(
  columns: 4, align: (left, center, center, left),
  stroke: 0.4pt + luma(170), inset: (x: 7pt, y: 3.5pt),
  table.header([step], [value], [], [conclusion]),
  [$\#E[3](QQ_3)$], [$3$], [only $x = 2d$ is rational],
    [$\#E(QQ_3) slash 3E = 9$],
  [$\#A = M$], [$9$], [4 classes found outside $E_1$, all killed by 3],
    [$\#A[3] >= 5 > 3$, so $A$ is not cyclic: $A tilde.equiv (ZZ slash 3)^2$
     and $3E = E_1$],
  [$\#A' = M'$], [$3$], [*prime*], [one class generates $A'$],
  [$v_3 (x(hat(phi) P'))$], [$-2$], [for $P'$ outside $E'_1$],
    [$hat(phi) P' in E_1$, so $hat(phi)(A') = 0$],
))

#v(2mm)

The last two lines are the whole content: because $\#A' = 3$ is *prime*, any
single class outside $E'_1$ generates $A'$, so one evaluation of $hat(phi)$
settles the induced map. Both kernels $x$ and $x - 2d$ give
$v_3 = -2$, and the same numbers come out for
$d = -3, 6, -21, 87, -30, 69$. One $d$ suffices, since all $d$ in a square class
give $QQ_3$-isomorphic curves --- which is exactly the reduction §5.1.5 needs.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  So $hat(phi)(E'(QQ_3)) subset.eq E_1 (QQ_3) = 3 E(QQ_3)$ for *both* 3-isogenies:
  the two dual images are zero in $W_3 = E(QQ_3) slash 3$, so
  $W_3 inter H^1 (C_1) = W_3 inter H^1 (C_2) = 0$, so $W_3$ is not $phi$-stable,
  so $beta_3 equiv.not 0$. The input §5.1.5 leaves open is closed.
]

The one thing still taken on trust is the standard fact that an isogeny carries
$E'_1$ into $E_1$; everything else above is a finite computation.

== The remaining three: what the module structure permits <sec-triage>

Three classes are left: `14a2`, `19a1` and `17a1`. Before constructing anything
in a given case it is worth asking whether the mechanism is even *available*
there, and that is not automatic: $beta_v (P,Q) = ⟨delta_v P, phi delta_v Q⟩_v$
is useful only when $phi$ is *non-scalar*, since a scalar $phi$ collapses $beta$
to the untwisted Tate pairing, which vanishes on the Lagrangian $W_v$. So the
first question about each open class is whether
$"End"_G (E[ell]) != bb(F)_ell$.

For a 2-dimensional $bb(F)_ell$-module $V = E[ell]$ the possibilities are:

#table(
  columns: 3, align: (left, left, center),
  stroke: 0.4pt + luma(170), inset: (x: 7pt, y: 3pt),
  table.header([structure of $E[ell]$], [$"End"_G$], [non-scalar?]),
  [two stable lines (decomposable)], [$bb(F)_ell times bb(F)_ell$], [*yes*],
  [one stable line, characters on sub and quotient *agree*],
    [$bb(F)_ell [N] slash (N^2)$], [*yes*],
  [one stable line, characters *differ*], [$bb(F)_ell$], [no],
  [irreducible, image in a nonsplit Cartan], [$bb(F)_(ell^2)$], [*yes*],
  [irreducible, larger image], [$bb(F)_ell$], [no],
)

#v(2mm)

The Weil pairing forces $chi_1 chi_2 = $ cyclotomic mod $ell$, so with a rational
point of order $ell$ (giving $chi_1 = 1$) the two characters agree *only when
$ell = 2$*, where $bb(F)_2^times$ is trivial. Hence the criterion splits:

- *$ell = 2$*: reducible $=>$ always non-scalar; irreducible $=>$ non-scalar iff
  $op("Gal")(f) = ZZ slash 3$, i.e. iff $op("disc") f$ is a square.
- *$ell$ odd*: need *two* stable lines, or an irreducible image inside a nonsplit
  Cartan.

Twisting by a quadratic character changes none of this, since
$"End"_G (V times.o chi) = "End"_G (V)$ --- so this is a property of the surface.

#block(fill: rgb("#eef4ff"), inset: 9pt, radius: 3pt, width: 100%)[
  *All the remaining classes admit a non-scalar $phi$.* The mechanism is
  available in every one of the seven classes of @sec-fail that remained open ---
  the eighth is the class where non-density was already proved outright. What is
  not settled is
  whether it *works* --- selecting the right $phi$ and proving the local
  vanishing still has to be done case by case.
]

=== The structural data <sec-triage-data>

One caveat first. The reduced monic cubic of @sec-which is a model of the
*surface*, and the reduction $f |-> q^(-3) f(q x + mu)$ can twist the curve; so
the curve to analyse is not $y^2 = f(x)$ but $E_0$, the minimal quadratic twist,
which is where the rational $ell$-torsion lives.

#table(
  columns: 8, align: (left, center, center, center, center, center, center, left),
  stroke: 0.4pt + luma(170), inset: (x: 5pt, y: 3pt),
  table.header([class], [$p$], [$ell$], [$E_0$: $N$], [tors], [stable lines],
               [$p mod ell$], [$E[ell]$]),
  [`11a1` $[u]$ #super[✓]], [11], [5],  [11], [5], [2], [1], [decomposable],
  [`14a2` $[1]$], [7],  [3],  [14], [6], [2], [1], [decomposable],
  [`19a1` $[u]$], [19], [3],  [19], [3], [2], [1], [decomposable],
  [`15a4` $[1]$ #super[✓]], [5],  [2],  [15], [8], [1], [1], [indecomposable],
  [`17a1` $[1]$], [17], [2],  [17], [4], [1], [1], [indecomposable],
  [`14a1` $[1]$ #super[✓]], [7], [3], [14], [6], [2], [1], [decomposable],
  [`15a1` $[1]$ #super[✓]], [5], [2], [15], [8], [3], [1], [split],
)

#v(2mm)

Two things are true across the board.

*$p equiv 1$ $(mod ell)$ in every case, and it is forced.* $dim W_p = 2$ requires
$E_delta [ell](QQ_p) = (ZZ slash ell)^2$, hence $mu_ell subset QQ_p$. So at the
*critical* place the symbol is always the *tame* $ell$-th power residue symbol,
never the wild one. This is the structural reason every case here is more
tractable than §5.1.5's, where the critical place was $ell = 3$ itself.

*The places that can carry $beta$ are few.* Good places die by unramified
isotropy, and $beta_v = 0$ wherever $dim W_v <= 1$. With $chi_1 = 1$ and
$chi_2 = $ cyclotomic, $C_1^((d))(QQ_v)$ and $C_2^((d))(QQ_v)$ are both non-zero
only if $mu_ell subset QQ_v$, i.e. $v equiv 1$ $(mod ell)$. So only three kinds
of place remain: the critical $p$; the wild place $v = ell$; and bad primes
$equiv 1$ $(mod ell)$ at which $d$ is a square. The conductor column of the triage shows
there are *no* such extra bad primes in the three odd-$ell$ cases: each
conductor's only prime factors are $ell$ itself, the critical $p$, and primes
$equiv.not 1$ $(mod ell)$.

=== Two templates <sec-triage-templates>

They fall into the two patterns already worked out.

*The `14a1` template --- $ell$ odd, $E[ell]$ decomposable (@sec-14a1). Open
cases: `14a2` and `19a1`; `11a1` also belongs here and @sec-11a1 has since
carried it out.* Here $beta$ is alternating at every place for free --- §5.1.5's
argument needs only decomposability and $2$ invertible mod $ell$ --- so the whole
analysis reduces to $dim W_v$, and by the triage the only place left is the wild
$v = ell$. Both worked cases came out with $beta_ell = 0$ there, by two different mechanisms, and
both are worth trying on `14a2` and `19a1`: the lemma of @sec-11a1-five when $dim W_ell = 2$ forces
good ordinary reduction at $ell$, and the descent-image computation of @sec-14a1-places when it
does not --- there $L_ell$ turned out to lie inside a single $H_i$, which is the other way a
$phi_*$-stable image can arise. Since $E_d$ over $QQ_ell$ depends only on the class of $d$ modulo
squares, four local computations settle a whole family. And @sec-class-warning is why it matters
that they cover all four: a theorem covering part of a class says nothing about $X$. The worry
that `11a1` would need a *quintic* residue symbol turned out to be unfounded --- see @sec-11a1.

*The $x^3 + x$ template --- $ell = 2$, $E[2]$ indecomposable (@sec-thm2). Open
case: `17a1`; `15a4` also belongs here and @sec-15a4 has since carried it out.*
At $ell = 2$ the alternating step is *not* free: $2$ is not invertible
mod $2$ and §5.1.5's argument fails, which is exactly why `x^3 + x` needed the
norm lemma. And the norm lemma applies here:

#align(center, table(
  columns: 3, align: (left, center, left),
  stroke: 0.4pt + luma(170), inset: (x: 8pt, y: 3pt),
  table.header([surface], [2-torsion field], [$beta$ alternating?]),
  [`15a4` #super[✓]], [$QQ(i)$], [*yes*, by Lemma 2],
  [`17a1`], [$QQ(i)$], [*yes*, by Lemma 2],
  [`x^3 + x` #super[✓]], [$QQ(i)$], [*yes*],
  [`x^3 + 2x` (no obstruction)], [$QQ(sqrt(-2))$], [no],
))

#v(2mm)

Both open cases have 2-torsion field $QQ(i)$, so $(c(P), -1)_v = 1$ and $beta$ is
alternating for the same reason as in @sec-alt. Since $E_d [2] tilde.equiv E[2]$
as Galois modules for every $d$ ($chi_d$ is trivial on $bb(F)_2^times$), this is a
surface invariant.

That is a suggestive pattern rather than a theorem: of the four defective classes
at $ell = 2$, the three with $E[2]$ indecomposable all have 2-torsion field
$QQ(i)$ --- the condition that makes $beta$ alternating --- while `x^3 + 2x`,
which has no obstruction, does not. It would be worth knowing whether a defective
class at $ell = 2$ with indecomposable $E[2]$ *must* have 2-torsion field
$QQ(i)$. Nothing here decides that.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *What this does not show.* That $"End"_G (E[ell]) != bb(F)_ell$ makes the
  mechanism possible, not that it fires. For each class one still has to pick the
  right $phi$ out of the available ones --- the step that took a 16-candidate
  search at `15a1` --- and then prove the local vanishing. The triage says only
  that no case is ruled out on module-theoretic grounds, and which of the two
  worked examples each should imitate.
]


= The Brauer class <sec-brauer>

Everything above produces $beta$ as a globally defined pairing obeying a reciprocity law, and that
is exactly the structure an Azumaya algebra supplies. So one should expect a class
$cal(A) in "Br"(X)$ with
$ "inv"_v cal(A) (T) = beta_v (P, Q) quad quad "for" T in X(QQ_v) "the image of" (P,Q), $
and the theorems above rewritten as a Brauer--Manin obstruction. This section works that out. At
level 2 the class can be written down, shown unramified on $E_d times E_d$, and checked; at level 3
the descent functions come out twist-free on two fixed curves of conductor 27, the class is a
corestricted symbol, and $beta_3$ --- the wild symbol §5.1.5 could never evaluate --- becomes
computable.

One point of vocabulary first, because it is easy to mis-say. $X(QQ) != nothing$ here --- there is
no obstruction to the *existence* of rational points. What $cal(A)$ obstructs is *weak
approximation*: $"inv"_p cal(A)$ is a locally constant function on $X(QQ_p)$ which is *not*
constant, and reciprocity pins it to $0$ on $X(QQ)$, so the closure of $X(QQ)$ misses the open set
where it is non-zero. Non-density, not emptiness.

== The construction, from an endomorphism of $E[n]$ <sec-brauer-gen>

The two algebras below were each found by hand, one level at a time. They are both instances of a
single construction that takes $phi in "End"_G (E[n])$ and returns an Azumaya algebra, and it is
worth doing that first: it makes the evaluation formula a triviality, it makes the *unramifiedness*
on $E times E$ a triviality, and it says how many candidates $phi$ there are and what each one
looks like.

=== The universal Kummer class <sec-brauer-tau>

Multiplication by $n$ makes $E$ a torsor under $E[n]$ *over the base $E$*: the fibre of
$[n] : E -> E$ over a point is a coset of $E[n]$. Let
$ tau in H^1_"ét" (E, space E[n]) $
be its class. For $P in E(k)$ the fibre $[n]^(-1)(P)$ is the torsor whose class is $delta(P)$, so
$ P^* tau = delta(P) . $
That is the Kummer map before any point is chosen; everything below is $tau$ pushed around.

=== The class attached to $phi$ <sec-brauer-Aphi>

Let $A = E times E$ with projections $p_1, p_2$, and let $phi in "End"_G (E[n])$.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  $ cal(A)_phi := e_(n *) ( p_1^* tau space union space phi_* (p_2^* tau) )
    space in space H^2 (A, mu_n) , $
  where $union$ is the cup product and $e_(n*)$ pushes forward along the Weil pairing
  $e_n : E[n] times.o E[n] -> mu_n$. Its image under
  $H^2 (A, mu_n) -> "Br"(A)[n]$ is the algebra.
]

Three properties come for free.

*It is Azumaya.* $A$ is smooth, so $"Br"(A)$ is the Azumaya Brauer group; the Kummer sequence
$0 -> "Pic"(A) slash n -> H^2 (A, mu_n) -> "Br"(A)[n] -> 0$ produces the class.

*Its evaluation is $beta_phi$.* Cup product and pushforward commute with pullback along
$(P,Q) : "Spec" k -> A$, so
$ (P,Q)^* cal(A)_phi = ⟨delta P, space phi_* delta Q⟩ = beta_phi (P,Q) $
--- by functoriality, with nothing to compute. This is what @sec-brauer-status previously listed as
conjectural.

*Only $phi$ modulo scalars matters.* $phi |-> cal(A)_phi$ is additive, and for $phi = c$ scalar
$cal(A)_c = c dot cal(A)_"id"$, whose evaluation is $c$ times the *untwisted* Tate pairing --- zero
on every $W_v$, since $W_v$ is Lagrangian. So adding a scalar to $phi$ changes $cal(A)_phi$ by a
class that is invisible to the obstruction.

=== Reduction to rank one <sec-brauer-rank1>

Take $n = ell$ prime, so $E[ell]$ is a 2-dimensional $bb(F)_ell$-space. Suppose $phi$ is non-scalar
and has an eigenvalue $c in bb(F)_ell$. Then $phi - c$ is non-zero with non-trivial kernel: it has
*rank one*, and by the last paragraph it does the same job. So assume

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  $phi$ has rank one. Then $K := ker phi$ and $I := "im" phi$ are *Galois-stable lines* in
  $E[ell]$, and $phi$ is the composite
  $ E[ell] arrow.r.twohead E[ell] slash K limits(-->)^(overline(phi), tilde) I arrow.hook E[ell] $
  for an isomorphism $overline(phi)$. Conversely every ordered pair of stable lines, together with
  such an isomorphism, gives a rank-one $phi in "End"_G (E[ell])$.
]

(If $phi$ has no eigenline over $k$ --- the nonsplit-Cartan case of @sec-triage --- pass to the
extension over which it acquires one. That has degree 2 for $ell$ odd, and degree 3 in the
$bb(F)_4$ case at $ell = 2$; both are coprime to $ell$, so the class descends by corestriction as
in @sec-brauer-cor.)

=== The two functions <sec-brauer-twofns>

For a Galois-stable line $C subset.eq E[ell]$ generated by $T$, let $f_C$ be a function on $E$ with
$ "div"(f_C) = ell (T) - ell (O) , $
unique up to a constant. It exists because $ell(T) - ell(O)$ is principal, $T$ having order $ell$;
concretely it is the tangent line at $T$ for $ell = 3$, and $x - e_m$ for $ell = 2$.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *The $E[ell] slash C$-component of the Kummer map is evaluation of $f_C$*:
  $ pi_(C *) compose delta : E(k) slash ell --> H^1 (k, space E[ell] slash C), quad quad
    P |-> f_C (P) space (mod ell"-th powers") . $
  Reason: with $psi_C : E -> E slash C$ one has $ker hat(psi)_C = psi_C (E[ell]) tilde.equiv
  E[ell] slash C$, and Step 5 of §5.1.5 identifies $pi_(C*) delta$ with the descent map for
  $hat(psi)_C$, which is classically given by $f_C$.
]

Two remarks. The constant in $f_C$ is genuinely free at $ell = 2$, where $ell$-th powers are
squares and the natural choice $x - e_m$ is already normalised; at odd $ell$ it is *not* free, and
is pinned by requiring $f_C dot sigma(f_C)$ to be an $ell$-th power --- which is exactly the
normalisation of @sec-brauer-3-norm. And $"div"(f_C)$ is divisible by $ell$, which is the second
free property below.

=== Putting it together <sec-brauer-cor>

The Weil pairing is alternating, so it kills $I times I$ and induces a *perfect* pairing
$(E[ell] slash I) times I -> mu_ell$. Hence for $z in H^1 (k, I)$,
$ ⟨delta P, space iota_* z⟩ = ⟨pi_(I *) delta P, space z⟩ $
--- the adjunction of §5.5.5. Applying it with $z = overline(phi)_* pi_(K*) delta Q$:

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  $ beta_phi (P, Q) = ⟨pi_(I*) delta P, space overline(phi)_* pi_(K*) delta Q⟩
    = ( f_I (P), space f_K (Q) )_ell^(space u) , $
  the $ell$-th power symbol, where $u in bb(F)_ell^times$ is the scalar contributed by
  $overline(phi)$; and therefore
  $ cal(A)_phi = 1 / [L : k] space "cor"_(L(A) slash k(A))
    ( (p_1^* f_I, space p_2^* f_K)_ell^(space u) ) , $
  where $L = k(zeta_ell, T_I, T_K)$. The Galois action on a line is by a character into
  $bb(F)_ell^times$, so $[L : k]$ divides a power of $ell - 1$ and is *coprime to $ell$*; hence
  $"cor" compose "res" = [L:k]$ is invertible modulo $ell$ and the formula is exact.
]

*And it is unramified on $E times E$, for free.* Both entries have $ell$-divisible divisor, since
$"div"(f_C) = ell(T) - ell(O)$; so every residue vanishes (@sec-brauer-unram). The single property
that makes $f_C$ a descent function is the property that makes the algebra Azumaya. (Descending to
the Kummer surface is a separate question --- @sec-brauer-unram2.)

=== The two worked cases are the two specialisations <sec-brauer-cases>

#align(center, table(
  columns: 5, align: (left, center, left, left, left),
  stroke: 0.4pt + luma(170), inset: (x: 7pt, y: 3.5pt),
  table.header([case], [$ell$], [$(I, K)$], [$f_I$, $f_K$], [$L$, and the algebra]),
  [@sec-brauer-2], [2], [$(C_i, C_j)$, any two stable lines],
    [$x - e_i$, $t - e_j$], [$L = k$: the quaternion algebra $(c_i, c_j)$],
  [@sec-brauer-3], [3], [$(C_1, C_2)$ for $x^3 - 2$],
    [$hat(g) = w - x + 1$, $hat(h) = z - 1$],
    [$L = QQ(zeta_3, sqrt(6d))$, degree 4: $"cor"(hat(g), hat(h))_3$],
))

#v(2mm)

At $ell = 2$ the corestriction is invisible because $mu_2 = ZZ slash 2$ needs no roots of unity, so
$L = k$ whenever the lines are rational, and the class is a plain symbol. At $ell = 3$ it is not,
which is the whole content of @sec-brauer-3.

=== What the construction settles about choosing $phi$ <sec-brauer-count>

*How many candidates there are.* Rank-one equivariant $phi$ correspond to *ordered pairs of
Galois-stable lines*. At $ell = 2$:

#align(center, table(
  columns: 4, align: (left, center, center, left),
  stroke: 0.4pt + luma(170), inset: (x: 7pt, y: 3.5pt),
  table.header([$f$], [stable lines], [rank-one $phi$], [in $"Br"(X)$, by @sec-brauer-unram-2]),
  [$(x-17)(x-1)(x+8)$ (`15a1`)], [3], [9], [*2*: $(c_1, c_3)$ and $(c_3, c_1)$],
  [$x(x-9)(x-25)$], [3], [9], [*2*: $(c_1, c_3)$ and $(c_3, c_1)$],
  [$x(x-1)(x-4)$], [3], [9], [*0*],
  [$x^3 + x$, `15a4`], [1], [*1*], [*1*: $(q(x), q(t))$],
  [$x^3 + 2x$], [1], [1], [*0*],
))

#v(2mm)

The fourth row is @sec-triage-templates's observation that "indecomposable $E[2]$ makes the
twisting endomorphism essentially unique", now with a reason: indecomposable means *one* stable
line, hence one ordered pair, hence one $phi$. The first row is why `15a1` needed a search.

*Which candidate to pick.* @sec-15a1-choose cut 16 matrices down to four by a local condition ---
$beta_v$ must vanish at every $v != 5$ --- and kept two non-trivial ones, transposes of each other.
The construction plus the ramification criterion say, independently and with no local computation,
that exactly *two* of the nine rank-one $phi$ give a class in $"Br"(X)$: $(c_1, c_3)$ and
$(c_3, c_1)$. They are the same two. By @sec-brauer-harari the agreement is not a coincidence ---
Harari's theorem makes the local condition and membership in $"Br"(X)$ equivalent --- but the two
computations are genuinely independent, one local and one geometric. `endo.gp` runs the count.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *What is still not proved here.* That $cal(A)_phi$ generates the relevant part of $"Br"(X)$, or
  that every class arising this way is accounted for by some $phi$ --- the surjectivity of
  $phi |-> cal(A)_phi$ onto the "transcendental" part. That is the Skorobogatov--Zarhin question,
  and nothing above touches it.
]

== Level 2: the algebra, explicitly <sec-brauer-2>

Two things stand between $beta$ and a class on $X$. The descent map $c_i (P) = U(P) - d e_i$
mentions the *twist* $d$, and $U$ is a coordinate on $E_d$, not on $X$. Both go away at once, and
by the same one-line identity.

On $E_d : Y^2 = product_i (U - d e_i)$ the product of the three factors is a square, so each factor
is congruent to the product of the other two:
$ U - d e_1 equiv (U - d e_2)(U - d e_3) space (mod (QQ^times)^2) . $
Now substitute $U = d x$, where $x$ is the coordinate on $X$: the left side is $d(x - e_1)$, the
right side is $d^2 (x-e_1')(x-e_1'')$, and the $d$'s cancel modulo squares.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  $ c_i (P) equiv product_(j != i) (x - e_j) space (mod "squares"), quad quad
    x = "the " x "-coordinate of " T in X . $
  The twist has disappeared and the right-hand side is a function on $X$.
]

So the pairing $beta_v (P,Q) = (c_i (P), c_j (Q))_v$ of @sec-15a1 and @sec-alt is the local
invariant of the quaternion algebra
$ cal(A)_(i j) = ( product_(k != i) (x - e_k), space product_(l != j) (t - e_l) )
  quad "over" QQ(X), $
which mentions no twist at all. In the three worked cases:

#align(center, table(
  columns: 3, align: (left, left, left),
  stroke: 0.4pt + luma(170), inset: (x: 7pt, y: 3.5pt),
  table.header([case], [$beta_v (P,Q)$], [$cal(A)$ over $QQ(X)$]),
  [$x^3 + x$ (@sec-thm2)], [$(x(P), x(Q))_v$], [$(x^2 + 1, space t^2 + 1)$],
  [`15a4` (@sec-15a4)], [$(x(P), x(Q))_v$],
    [$(x^2 + 14x + 625, space t^2 + 14t + 625)$],
  [`15a1` (@sec-15a1)], [$(c_1 (P), c_3 (Q))_v$],
    [$((x-1)(x+8), space (t-17)(t-1))$],
))

#v(2mm)

For $f = u dot q(u)$ with a single rational root at $u = 0$ this reads
$cal(A) = (q(x), q(t))$ with $q = f slash u$ --- and one of @sec-15a4's observations improves in
the translation. There the alternating property came from
$q(u) = u^2 + 14u + 625 = (u+7)^2 + 24^2$ being a sum of two squares, argued over points; here it
says that *the first entry of $cal(A)$ is a norm form from $QQ(i)$*, which is a statement about the
algebra and holds before any point is chosen.

=== It is unramified <sec-brauer-unram>

On $E_d$ the function $U - d e_i$ has divisor $2(T_i) - 2(O)$: *divisible by 2*, because $T_i$ is
2-torsion. Hence on $E_d times E_d$ both entries of $cal(A)_(i j)$ pull back to functions whose
valuation along *every* prime divisor is even, and the residue
$ partial_D (g_1, g_2) = overline((-1)^(v_D (g_1) v_D (g_2)) space g_1^(v_D (g_2)) g_2^(-v_D (g_1)))
  in kappa(D)^times slash (kappa(D)^times)^2 $
is trivial for every $D$. So $cal(A)_(i j) in "Br"(E_d times E_d)$ --- and for every $d$ at once,
since the divisor argument never mentions $d$. That the divisor of the descent function is
$ell$-divisible is exactly what makes it a descent function *and* what makes the algebra
unramified; the two facts are the same fact.

Descending to $X$: both entries are functions of $x$ and $t$ alone, so they are already defined on
$X$ and invariant under $(P,Q) |-> (-P,-Q)$, and $E times E --> (E times E) slash plus.minus$ is
étale in codimension one, so the divisors stay 2-divisible. The one place left to check is the
sixteen exceptional curves of the Kummer resolution: a function vanishing to order 2 at a fixed
point acquires *odd* valuation along the exceptional curve $F tilde.equiv PP^1$, and the residue
there is $overline(q(x) slash q(t))$. That is a square, by the relation $A C = B^2$ among the
invariants $A = s^2$, $B = s u$, $C = u^2$ of the local $plus.minus$-action. This last step is
sketched, not verified in detail --- see @sec-brauer-status.

=== It reproduces $beta$ <sec-brauer-check>

By construction, and `azumaya.gp` checks it place by place against the classical descent maps,
together with $product_v "inv"_v cal(A) = 1$ on rational pairs:

#align(center, table(
  columns: 5, align: (left, right, right, center, center),
  stroke: 0.4pt + luma(170), inset: (x: 7pt, y: 3.5pt),
  table.header([$f$], [pairs], [place evaluations],
               [$"inv"_v cal(A) != beta_v$], [reciprocity failures]),
  [$x^3 + x$], [140], [584], [*0*], [*0*],
  [`15a4`], [48], [200], [*0*], [*0*],
  [`15a1`, $(c_1, c_3)$], [156], [736], [*0*], [*0*],
  [`15a1`, transpose], [156], [736], [*0*], [*0*],
  [`15a1`, untwisted], [156], [736], [*0*], [*0*],
  [$x(x-1)(x-4)$], [80], [260], [*0*], [*0*],
))

#v(2mm)

3252 place evaluations, no mismatch. The untwisted row is included as a control: it matches too,
which it must --- the twisting is a choice of $phi$, not a change in the dictionary between $c_i$
and the coordinates of $X$.

== Level 3: cyclic, not a symbol --- and explicit <sec-brauer-3>

At level 3 a symbol algebra $(g_1, g_2)_3$ is the natural guess. It is right in *shape* --- the
class has order 3 and the algebra has degree 3, so dimension 9 over the function field --- but the
two slots are not alike, and cannot be.

$E[3] = C_1 xor C_2$ with $C_1 tilde.equiv ZZ slash 3$ and $C_2 tilde.equiv mu_3$. Over a field $k$,
$ H^1 (k, C_1) = "Hom"(G_k, ZZ slash 3) quad "— a cyclic cubic extension", $
$ H^1 (k, C_2) = k^times slash (k^times)^3 quad "— a function value", $
and $beta_v (P,Q) = ⟨alpha_2 (P), space alpha_1 (Q)⟩_v$ is the cup product of a $mu_3$-class with a
$ZZ slash 3$-class: the class of a *cyclic algebra* $(L_chi slash k, sigma, g)$, not of a symbol. It
collapses to a symbol only over a field containing $zeta_3$, and $zeta_3 in.not QQ$. The asymmetry
is the same $ZZ slash 3$-versus-$mu_3$ asymmetry that made one of the two isogenies of §5.1.5 free
and the other not.

=== The two twists that carry the descent functions <sec-brauer-3-fns>

The obstacle at level 3 looked worse than at level 2, because there the twist cancelled modulo
squares and here descent is modulo cubes. It cancels anyway, and more cleanly.

On $E_d : d v^2 = x^3 - 2$ the two Galois-stable lines are generated by
$T_d = (2d, sqrt(6 d^3))$ and $S_d = (0, sqrt(-2d^3))$, neither of them rational. Set
$ w := v sqrt(6d) slash 6, quad quad z := v sqrt(-2d) slash 2 . $
Then $w^2 = (x^3 - 2) slash 6$ and $z^2 = -(x^3-2) slash 2$: *the twist is gone*, and each of
$w, z$ lands on a curve that does not depend on $d$ at all.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  #align(center, table(
    columns: 5, align: (left, left, center, center, left),
    stroke: 0.4pt + luma(170), inset: (x: 7pt, y: 3.5pt),
    table.header([curve], [Weierstrass form], [conductor], [$E(QQ)$], [3-torsion, and its tangent]),
    [$E_((6)) : 6w^2 = x^3 - 2$], [$Y^2 = X^3 - 432$], [27], [$ZZ slash 3$],
      [$T = (2,1)$, tangent $w = x - 1$],
    [$E_((-2)) : -2z^2 = t^3 - 2$], [$Y^2 = X^3 + 16$], [27], [$ZZ slash 3$],
      [$S = (0,1)$, tangent $z = 1$],
  ))
  #v(2mm)
  $ hat(g) = w - x + 1, quad quad hat(h) = z - 1 . $
]

Both tangencies are exact identities:
$ (x^3 - 2) - 6(x-1)^2 = (x-2)^3, quad quad (t^3 - 2) - (-2) dot 1^2 = t^3 , $
so $"div"(hat(g)) = 3(T) - 3(O)$ and $"div"(hat(h)) = 3(S) - 3(O)$, which is what makes each a
descent function. The two curves are the twists of $x^3 - 2$ by $6$ and by $-2$; both have
conductor 27 and rational 3-torsion, and $6 dot (-2) = -12 equiv -3$ modulo squares --- the Weil
pairing $C_1 times.o C_2 tilde.equiv mu_3$, showing up as a relation between the two twisting
constants.

=== The normalisation, which is what was missing <sec-brauer-3-norm>

$hat(g)$ lives over $QQ(sqrt(6d))$ and $hat(h)$ over $QQ(sqrt(-2d))$; to descend, each must satisfy
$xi dot sigma(xi) in ("cubes")$, where $sigma$ is the conjugation. As they stand they do not:
$ hat(g) dot sigma(hat(g)) = (x-1)^2 - (x^3-2) slash 6 = -(x-2)^3 slash 6, quad quad
  hat(h) dot sigma(hat(h)) = 1 - z^2 = t^3 slash 2 , $
leaving the constants $-1 slash 6$ and $1 slash 2$, which are not cubes. Constant multiples are
free --- rescaling a descent function by $lambda$ multiplies each value by $lambda$, and
$lambda^3$ is invisible --- so choose them to clear the constants:

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  $ G := 36 (w - x + 1), quad quad H := (z - 1) slash 2 , $
  $ G dot sigma(G) = (-6(x-2))^3, quad quad H dot sigma(H) = (t slash 2)^3 . $
]

That is the normalisation the previous draft of this section recorded as the missing step. With it,
$ cal(A) = "cor"_(F(X) slash QQ(X)) \( (G, space H)_3 \), quad quad
  F(X) = QQ(X)(zeta_3, space sqrt(6 f(x))) , $
where the corestriction is exact rather than up to a factor: $[F : QQ] = 4$ and
$"cor" compose "res" = 4 equiv 1$ modulo 3. Inside $F(X)$ the two radicals are not independent ---
$w z = y sqrt(-3) slash 6$, since $(w z)^2 = -f(x) f(t) slash 12 = -y^2 slash 12$ --- so one
quadratic extension carries both, and $z = y sqrt(-3) slash (6 w)$.

=== Which makes $beta_3$ computable <sec-brauer-3-wild>

Since $[F : QQ]$ is coprime to 3, restriction is injective on $"Br"[3]$, so $beta_v = 0$ exactly
when $(G, H)_frak(p) = 0$ for $frak(p) | v$. Two consequences, both of them things the companion
notes could not do.

*Away from 3, the symbol is tame and the place analysis can simply be checked.* §5.1.5 proves
$beta_v equiv 0$ for $v != 3$ structurally, place class by place class. `level3.gp` instead
evaluates the tame cubic symbol: over 26 rational pairs drawn from 7 twists in the class,
*84 of 84* place evaluations away from 3 vanish.

*At 3 the symbol is wild --- and it is still computable, by going global.* The companion notes call
the missing ingredient "a cubic norm-residue symbol at $v = 3$ ... where one needs an explicit
reciprocity law (Artin--Hasse, Coleman) rather than a formula". There is a way round that needs no
reciprocity law at all.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  Let $K = QQ_3 (zeta_3)$, and note that $QQ(zeta_3)$ has a *single* prime above 3. For global
  $a, b in QQ(zeta_3)^times$ the product formula therefore gives the wild symbol as
  $ (a,b)_(frak(p)_3) = - sum_(frak(q) tilde.not 3) (a,b)_frak(q) , $
  a finite sum of *tame* symbols. And every class of $K^times slash (K^times)^3$ has a global
  representative: with $pi = zeta_3 - 1$ one has $U^((4)) subset.eq (K^times)^3$, because
  $4 > 3 e slash (p-1) = 3$, and $pi^4$ generates the ideal $(9)$ --- so a class is pinned down by
  its valuation together with its unit part *modulo 9*, and any integer of $QQ(zeta_3)$ in that
  residue class will do.
]

The resulting symbol passes the checks that matter: it is skew-symmetric, it kills $(a, 1-a)$ and
$(a, -a)$, and its Gram matrix on $⟨pi, zeta_3, 1 + 3 zeta_3, 4⟩$ has rank 4 over $bb(F)_3$ ---
non-degenerate on $K^times slash (K^times)^3 tilde.equiv (ZZ slash 3)^4$, as local duality demands.

=== $beta_3 equiv.not 0$, evaluated <sec-brauer-3-beta>

With that, $beta_3$ can be computed on actual local points. For $d = -3$, where
$sqrt(6d) = 3 sqrt(-2) in QQ_3$, so that $G(P) in QQ_3^times$ and $H(Q) in K^times$:

#align(center, table(
  columns: 3, align: (left, center, left),
  stroke: 0.4pt + luma(170), inset: (x: 7pt, y: 3.5pt),
  table.header([test], [result], [what it confirms]),
  [$beta_3 (P,P)$ over 161 sampled points of $E_d (QQ_3)$], [*0 of 161 non-zero*],
    [$beta$ is alternating --- proved structurally in §5.1.5],
  [$beta_3 (P,Q)$ over the 9 pairs from $E_d (QQ)$], [*0 of 9 non-zero*],
    [the theorem of §5.1.5, seen at the critical place],
  [$beta_3$ on all 25921 sampled pairs], [*1854 non-zero*], [the form is not identically zero],
  [Gram matrix on a basis of $W_3$], [$mat(0,2;1,0)$], [symplectic on the 2-dimensional $W_3$],
))

#v(2mm)

The last line is the point. §5.1.5's one open local input, $beta_3 equiv.not 0$, was closed in
@sec-magma by a structural coset argument about dual isogeny images; it is now *evaluated*, and the
two agree. The 1854 non-zero values split $927 slash 927$ between the two non-trivial classes, as a
skew form must.

== Unramified on the Kummer surface <sec-brauer-unram2>

The one thing left open above was whether $cal(A)$ is unramified on $X$ itself rather than on
$E_d times E_d$. It is, in every case worked out here --- for free at level 3, and at level 2 under
an explicit condition that the surfaces in question satisfy. There are two routes; they agree, and
each says something the other does not.

Prime divisors of $X$ come in two kinds: the sixteen *exceptional curves* $F_(a b)$ of the
resolution $X -> Y = (E times E) slash iota$, lying over the fixed points $(T_a, T_b)$ of
$iota = (-1,-1)$ with $T_a, T_b in E[2]$; and the strict transforms of prime divisors of $Y$, which
correspond to $iota$-orbits of prime divisors of $E times E$.

*The second kind is free, at both levels.* $E times E -> Y$ is étale in codimension one --- it
ramifies only at the sixteen fixed points --- so a divisorial valuation $v_D$ of $QQ(X)$ of the
second kind extends to $QQ(E times E)$ with $e = 1$, and $v_D (g) = v_(D') (g)$ for $D'$ above $D$.
Every entry $g$ of $cal(A)$ has $ell$-divisible divisor on $E times E$ (@sec-brauer-unram), so
$v_D (g)$ is divisible by $ell$ and the residue vanishes.

=== Level 3: no condition <sec-brauer-unram-3>

Blow up the sixteen fixed points first. On $tilde(B) = "Bl"_16 (E_((6)) times E_((-2)))$ the
involution acts trivially on each exceptional $PP^1$ --- it acts by $-1$ on the tangent space, hence
trivially on its projectivisation --- so $tilde(B) -> X$ is finite, and $F$ is now the image of a
*divisor* $tilde(F)$ with ramification index $e = 2$. Residue functoriality gives
$ partial_(tilde(F)) (rho^* cal(A)) = 2 dot partial_F (cal(A)) , $
and $2$ is invertible modulo 3. So it is enough that $rho^* cal(A) = (G, H)_3$ be unramified on
$tilde(B)$ --- and it is: $"div"(G) = 3(T) - 3(O)$ and $"div"(H) = 3(S) - 3(O)$ on the two factors,
$T$ and $S$ have order 3 while the blown-up points are 2-torsion, so
$v_(tilde(F))(G), v_(tilde(F))(H) in {0, -3}$, divisible by 3. Every residue vanishes. Since
$[F(X) : QQ(X)] = 4$ is coprime to 3, restriction is injective on $"Br"[3]$ and $cal(A)$ itself is
unramified.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  That argument dies at level 2 for one reason: $partial_(tilde(F)) = 2 partial_F$ and $2 = 0$ in
  $ZZ slash 2$. So the pullback being unramified says nothing, and the residue has to be computed on
  $X$ directly. Level 3 is the easy case here, which is the reverse of the pattern everywhere else
  in these notes.
]

=== Level 2: the residue is a constant, and it is computable <sec-brauer-unram-2>

This subsection is deliberately structured in two stages, and it is worth saying so at the outset.
*Stages 1 and 2 assume nothing about the surfaces this document is actually about*: they compute the
residue of $cal(A)_(i j)$ along all sixteen exceptional curves for an *arbitrary* monic separable
cubic $f$ over $QQ$ and an *arbitrary* choice of indices $i, j$. The answer is a table of
constants, and the criterion for being unramified is that those constants be squares. Only in
stage 3 is the criterion applied to $x^3 + x$, `15a4` and `15a1`.

==== Stage 1: the hypotheses, and what $T_a$, $T_b$ are <sec-unram-hyp>

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *(H1)* $f = (u - e_1)(u - e_2)(u - e_3) in QQ[u]$ is monic, separable, of degree 3. Its roots
  $e_1, e_2, e_3$ lie in $overline(QQ)$ and *need not be rational*; the Galois action permutes them.
  $E : v^2 = f(u)$ is the associated elliptic curve.

  *(H2)* $E[2] = {T_0, T_1, T_2, T_3}$ with $T_0 = O$ and $T_m = (e_m, 0)$ for $m = 1,2,3$. These
  are the *2-torsion points*, and they are the points at which the descent functions of @sec-alt
  have their zeros: $"div"(u - e_m) = 2(T_m) - 2(O)$.

  *(H3)* $X = "Kum"(E times E)$: the minimal resolution of $Y = (E times E) slash iota$, where
  $iota = (-1,-1)$ is the *diagonal* involution. The fixed points of $iota$ are exactly the pairs of
  2-torsion points,
  $ (T_a, T_b), quad a, b in {0,1,2,3} , $
  sixteen of them, each an $A_1$ singularity of $Y$, and $F_(a b)$ is the exceptional curve above
  $(T_a, T_b)$. So *$T_a$ is a 2-torsion point of the first factor and $T_b$ one of the second*, and
  the pair $(a,b)$ is nothing but an address for one of the sixteen curves.

  *(H4)* $i, j in {1,2,3}$ are fixed but arbitrary, and
  $ cal(A)_(i j) = \( product_(k != i) (x - e_k), space product_(l != j)(t - e_l) \)_2 , $
  the class of @sec-brauer-2. Write $g_1, g_2$ for its two entries.
]

Nothing else is assumed. In particular $f$ may split over $QQ$ or not, $i$ may equal $j$ or not,
and the twist $d$ does not appear --- $cal(A)_(i j)$ is a class on the single surface $X$, and the
computation below never mentions a twist.

One point about fields, needed because of (H1). The Galois group permutes the sixteen points
$(T_a, T_b)$, so a *prime divisor of $X$ over $QQ$* is a Galois orbit of exceptional curves, and its
residue field is $k_(a b)(lambda)$ where
$ k_(a b) := QQ(e_a, e_b) $
is the field of definition of the point (with $e_0 := $ nothing, so $k_(0 b) = QQ(e_b)$ and
$k_(0 0) = QQ$). A *constant* $c in k_(a b)^times$ is a square in $k_(a b)(lambda)$ if and only if
it is a square in $k_(a b)$, since $k_(a b)$ is algebraically closed in $k_(a b)(lambda)$. That is
the test that will appear.

==== Stage 2: the residue, for arbitrary $f$ and arbitrary $i, j$ <sec-unram-calc>

Fix $(a,b)$ and work locally at $(T_a, T_b)$. Choose *anti-invariant* uniformisers: $s = v$ on the
first factor if $a != 0$ (the $y$-coordinate vanishes to order 1 at a 2-torsion point) and
$s = -u slash v$ if $a = 0$; likewise $u$ on the second factor. Then $iota(s, u) = (-s, -u)$, so
$sans(A) = s^2$, $sans(B) = s u$, $sans(C) = u^2$ generate the invariants, and $lambda = u slash s$
is invariant. On the minimal resolution the chart $QQ[sans(A), lambda]$ is smooth, $F$ is
$sans(A) = 0$, and
$ v_F = "ord" slash 2 quad "on invariant functions", quad quad kappa(F) = k_(a b)(lambda) . $

Each entry of $cal(A)_(i j)$ depends on one factor only, and is a function of $x$ (resp. $t$) alone,
hence expands in *even* powers of its uniformiser:
$ g_1 = C_1 space s^(2 alpha) (1 + O(s^2)), quad quad g_2 = C_2 space u^(2 beta) (1 + O(u^2)), $
with $alpha = v_F (g_1)$ and $beta = v_F (g_2)$. The three local shapes of a single factor are:

#align(center, table(
  columns: 4, align: (left, center, left, left),
  stroke: 0.4pt + luma(170), inset: (x: 7pt, y: 3.5pt),
  table.header([at $T_m$], [$"ord"(u - e_k)$], [leading coefficient], [reason]),
  [$m != 0$, $k = m$], [$2$], [$1 slash f'(e_m)$],
    [$v^2 = (u - e_m) product_(k != m)(u - e_k)$ and the second factor tends to $f'(e_m)$],
  [$m != 0$, $k != m$], [$0$], [$e_m - e_k$], [$u -> e_m$],
  [$m = 0$], [$-2$], [$1$], [$u = s^(-2)(1 + O(s))$ for $s = -u slash v$],
))

#v(2mm)

Multiplying the two factors of $g_1 = product_(k != i)(u - e_k)$ gives three cases, and this is
where the index $i$ enters:

#align(center, table(
  columns: 3, align: (left, center, left),
  stroke: 0.4pt + luma(170), inset: (x: 8pt, y: 3.5pt),
  table.header([position of $a$], [$alpha$], [$C_1$]),
  [$a = 0$], [$-2$], [$1$],
  [$a = i$], [$0$], [$product_(k != i)(e_i - e_k) = f'(e_i)$],
  [$a in.not {0, i}$], [$1$],
    [$(e_a - e_c) slash f'(e_a) = 1 slash (e_a - e_i)$, where $c$ is the third index],
))

#v(2mm)

So *$alpha$ is odd exactly when $a in.not {0, i}$*, and then $alpha = 1$. The same table with
$(j, b)$ in place of $(i, a)$ gives $beta$ and $C_2$. Now
$ partial_F (g_1, g_2) = (-1)^(alpha beta) space overline(g_1^beta g_2^(-alpha))
  = (-1)^(alpha beta) space C_1^beta C_2^(-alpha) space lambda^(-2 alpha beta) , $
and $lambda^(-2 alpha beta)$ is a square, so

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  $ partial_F (cal(A)_(i j)) = (-1)^(alpha beta) C_1^beta C_2^alpha
    quad in k_(a b)^times slash (k_(a b)^times)^2 --- "a constant." $
  #v(2mm)
  Substituting the three cases for each of $alpha$ and $beta$:
  #align(center, table(
    columns: 3, align: (left, center, left),
    stroke: 0.4pt + luma(170), inset: (x: 8pt, y: 3.5pt),
    table.header([the curve $F_(a b)$], [how many], [$partial_F cal(A)_(i j)$ mod squares]),
    [$a in.not {0,i}$ and $b in.not {0,j}$], [4], [$-(e_a - e_i)(e_b - e_j)$],
    [$a in.not {0,i}$ and $b = j$], [2], [$f'(e_j)$],
    [$a = i$ and $b in.not {0,j}$], [2], [$f'(e_i)$],
    [$a = 0$, or $b = 0$, or $(a,b) = (i,j)$], [8], [$1$],
  ))
  #v(2mm)
  *Criterion.* $cal(A)_(i j)$ is unramified along $F_(a b)$ if and only if the entry above is a
  square in $k_(a b) = QQ(e_a, e_b)$; and unramified on $X$ if and only if that holds for all
  sixteen, the other kinds of divisor being free (@sec-brauer-unram2).
]

Two sanity checks on the table. The eight trivial entries are forced: when $alpha$ and $beta$ are
both even, $C_1^beta$ and $C_2^alpha$ are squares outright. And the twist has vanished --- rescaling
$f$ by $d$ multiplies $C_1$ and $C_2$ by $d^(plus.minus 1)$ in a way that cancels in every row, as
it must for a statement about $X$.

==== Stage 3: the criterion applied to the surfaces of this document <sec-unram-apply>

Only now does anything specific to these notes enter. There are two shapes to consider.

*$f$ split over $QQ$.* Every $e_m$ is rational, so every $k_(a b) = QQ$ and the eight conditions are
squareness in $QQ$. For `15a1` (@sec-15a1) the algebra is $cal(A)_13$ --- $beta_v$ there is
$(c_1 (P), c_3 (Q))_v$, so $i = 1$ and $j = 3$ --- and $(e_1, e_2, e_3) = (17, 1, -8)$. The eight
non-trivial curves and their residues:

#align(center, table(
  columns: 4, align: (center, left, center, center),
  stroke: 0.4pt + luma(170), inset: (x: 8pt, y: 3.5pt),
  table.header([$(a,b)$], [residue], [value], [square?]),
  [$(2,1)$], [$-(e_2 - e_1)(e_1 - e_3)$], [$400 = 20^2$], [yes],
  [$(2,2)$], [$-(e_2 - e_1)(e_2 - e_3)$], [$144 = 12^2$], [yes],
  [$(3,1)$], [$-(e_3 - e_1)(e_1 - e_3)$], [$625 = 25^2$], [yes],
  [$(3,2)$], [$-(e_3 - e_1)(e_2 - e_3)$], [$225 = 15^2$], [yes],
  [$(2,3)$, $(3,3)$], [$f'(e_3) = (e_3-e_1)(e_3-e_2)$], [$225 = 15^2$], [yes],
  [$(1,1)$, $(1,2)$], [$f'(e_1) = (e_1-e_2)(e_1-e_3)$], [$400 = 20^2$], [yes],
))

#v(2mm)

All eight are squares, so *$cal(A)_13$ is unramified on $X$*. Every value is built from the
differences $e_1 - e_2 = 16$, $e_1 - e_3 = 25$, $e_2 - e_3 = 9$, which is why they are squares ---
and @sec-15a1-local had already singled out that those three differences are perfect squares, for
the different purpose of confining the bad places to $2, 3, 5$ and the divisors of $d$. The two
facts are the same fact.

*$f = (u - e_1) q(u)$ with $q$ irreducible over $QQ$.* Then $e_1 in QQ$ while $e_2, e_3$ are
conjugate over $K := QQ(e_2)$, so $k_(a b) = QQ$ when $a, b in {0, 1}$ and $k_(a b) = K$ otherwise.
The algebra of @sec-thm2 and @sec-15a4 is $(q(x), q(t))$, i.e. $i = j = 1$, so
$a in.not {0, i}$ means $a in {2,3}$. The eight non-trivial curves fall into three families, all
with residue field $K(lambda)$:

#align(center, table(
  columns: 4, align: (center, left, left, left),
  stroke: 0.4pt + luma(170), inset: (x: 8pt, y: 3.5pt),
  table.header([$(a,b)$], [residue], [condition], [$x^3 + x$ / `15a4`]),
  [$(2,2)$, $(3,3)$], [$-(e_a - e_1)^2$], [$-1$ a square in $K$, i.e. $K = QQ(i)$],
    [$K = QQ(i)$ / $K = QQ(i)$],
  [$(2,3)$, $(3,2)$], [$-(e_2 - e_1)(e_3 - e_1) = -q(e_1)$], [$-q(e_1)$ a square in $K$],
    [$-1 = i^2$ / $-625 = (25 i)^2$],
  [$(2,1)$, $(3,1)$, $(1,2)$, $(1,3)$], [$f'(e_1) = q(e_1)$], [$q(e_1)$ a square in $K$],
    [$1$ / $625 = 25^2$],
))

#v(2mm)

For $x^3 + x$: $e_1 = 0$, $q = u^2 + 1$, $K = QQ(i)$, $q(e_1) = 1$. For `15a4`:
$f = x(x^2 + 14x + 625)$, so $e_1 = 0$, $q(e_1) = 625$, and $q$ has discriminant
$14^2 - 4 dot 625 = -2304 = -(48)^2$, so $K = QQ(sqrt(-2304)) = QQ(i)$. All conditions hold in both
cases, so *both algebras are unramified on $X$*.

The first row is the interesting one: it says the mechanism needs the *2-torsion field to be
$QQ(i)$* --- and that is exactly Lemma 2 of @sec-alt, the condition that made $beta$ alternating.
The contrast is $x^3 + 2x$, where $K = QQ(sqrt(-2))$, $-1$ is not a square, the algebra is ramified,
and @sec-triage-templates records that this surface has no obstruction at all. `ramification.gp`
runs the criterion on all of these.

=== Harari's theorem, and what it adds <sec-brauer-harari>

There is a second route, and it is cleaner than the computation above. Harari's formal lemma
--- D. Harari, _Méthode des fibrations et obstruction de Manin_, Duke Math. J. 75 (1994),
Théorème 2.1.1, p. 226 --- reads:

#block(fill: luma(245), inset: 9pt, radius: 3pt, width: 100%)[
  *Théorème 2.1.1.* _Soient $k$ un corps de nombres et $X$ une $k$-variété géométriquement intègre,
  projective et lisse, dont on note $k(X)$ le corps des fonctions. Soient $alpha$ un élément de
  $"Br"(k(X))$ qui n'est pas dans $"Br" X$ et $U$ un ouvert de Zariski non vide de $X$ tel que
  $alpha in "Br" U$. Alors, il existe une infinité de places $v$ de $k$ telles que la flèche
  $U(k_v) -> "Br" k_v$ induite par $alpha$ prenne une valeur non nulle._
]

Contrapositive: if $"inv"_v cal(A)$ vanishes identically on $X(QQ_v)$ for all but finitely many
$v$, then $cal(A) in "Br"(X)$. That hypothesis is exactly what the place analysis of each theorem
establishes --- $beta_v equiv 0$ at every place of good reduction, by unramified isotropy --- and
$X(QQ_v) = union.sq_delta (E_delta times E_delta)(QQ_v) slash plus.minus$, so the evaluation map
*is* $beta_v$. So the theorems already proved imply that $cal(A)$ is unramified, with no geometry
at all.

Three things worth separating.

*Where Harari is enough on its own.* For $x^3 - 2$ (§5.1.5) and for `15a4` (@sec-15a4) the place
analysis is proved for every twist at every $v$ outside a fixed finite set --- including
$v divides d$, where §5.1.5 uses the odd valuation of $-2d$ and $6d$, and @sec-15a4-places uses
Lemmas A and B. So Harari gives unramifiedness unconditionally there.

*Where the direct computation is stronger.* For `15a1` the vanishing at $q divides d$ was
*verified over 640 places, not proved* (@sec-15a1-local). Harari's hypothesis therefore rests on
that verification, while the residue computation does not: it is a finite calculation with the
roots $17, 1, -8$ and needs no local analysis. So for `15a1` the geometry gives what the arithmetic
only checked.

*What the pair of them says about @sec-15a1-choose.* That section cut 16 candidate $phi$ down to
four by imposing two conditions, the second being "$beta_v$ must vanish at every $v != 5$, or
reciprocity localises nothing". Harari's theorem turns that condition into an equivalence: a
candidate satisfies it if and only if the corresponding $cal(A)_(i j)$ lies in $"Br"(X)$. And the
residue table confirms it in the one case where the two can be compared --- the rejected
$cal(A)_12$ is exactly the one that comes out ramified. The 16-candidate search was a search for an
unramified class, without knowing it.

== What is and is not claimed <sec-brauer-status>

#align(center, table(
  columns: 2, align: (left, left),
  stroke: 0.4pt + luma(170), inset: (x: 7pt, y: 3.5pt),
  table.header([statement], [status]),
  [$c_i (P) equiv product_(j != i)(x - e_j)$ mod squares],
    [*proved* --- one line from $product_i (U - d e_i) = Y^2$],
  [$cal(A)_(i j)$ is a quaternion algebra over $QQ(X)$ with no twist in it], [*immediate*],
  [$cal(A)_(i j)$ is unramified on $E_d times E_d$, for every $d$],
    [*proved* --- the divisors are 2-divisible],
  [$cal(A)_(i j)$ is unramified on the Kummer surface, level 2],
    [*proved* --- the residue at each exceptional curve is a constant; unramified iff those are
     squares, which holds for `15a1`, `15a4`, $x^3 + x$],
  [$cal(A)$ is unramified on the Kummer surface, level 3],
    [*proved* --- no condition; $partial_(tilde(F)) = 2 partial_F$ and 2 is invertible mod 3],
  [the same, independently of the geometry],
    [*proved* by Harari's Théorème 2.1.1 wherever the place analysis is proved for every twist],
  [$"inv"_v cal(A) = beta_v$ at level 2],
    [*proved*, and checked at 3252 place evaluations],
  [the level-3 class is cyclic of degree 3, not a symbol],
    [*proved* --- $zeta_3 in.not QQ$],
  [the level-3 descent functions, twist-free and normalised],
    [*proved* --- $G = 36(w-x+1)$, $H = (z-1) slash 2$, with exact norm relations],
  [$cal(A) = "cor"_(F(X) slash QQ(X)) (G, H)_3$ at level 3],
    [*derived*; unramifiedness on the Kummer surface not checked],
  [the wild cubic symbol at $v = 3$ is computable],
    [*implemented* --- validated non-degenerate, skew, Steinberg],
  [$beta_3 equiv.not 0$], [*evaluated* --- symplectic Gram matrix on $W_3$],
  [the general construction $cal(A)_phi = e_(n*)(p_1^* tau union phi_* (p_2^* tau))$],
    [*proved* --- evaluation is $beta_phi$ by functoriality, Azumaya by the Kummer sequence,
     unramified on $E times E$ because $"div"(f_C)$ is $ell$-divisible],
  [rank-one $phi$ $<->$ ordered pairs of stable lines, and the resulting symbol],
    [*proved*; recovers both worked cases as specialisations],
  [$phi |-> cal(A)_phi$ hits the whole transcendental part of $"Br"(X)$],
    [*not addressed* --- the Skorobogatov--Zarhin question],
))

#v(2mm)

What this buys is uniformity. The theorems of @sec-thm2, @sec-15a1 and
@sec-15a4 are each proved twist by twist, with a separate local analysis for each class of $d$;
$cal(A)$ is a single object on a single surface, and "$"inv"_p cal(A)$ is non-constant on
$X(QQ_p)$" is one statement covering every twist at once. That is what the twist-by-twist proofs
were reaching for --- and, with @sec-brauer-unram2, the reaching is over: $cal(A)$ is a genuine
element of $"Br"(X)$ at both levels, so "non-density at $p$" is now literally a Brauer--Manin
obstruction to weak approximation on $X$, given by one algebra.

= Remarks

== The obstruction is not about complex multiplication <sec-notcm>

The companion notes' §5.1 explains the failure of $f = x^3 - 2$ at $p = 3$
through a CM mechanism: the extra $QQ_3$-rational 3-torsion point
$T_d = (2d, sqrt(6 d^3))$ exists exactly on the class $[u dot 3]$, and
$E[3]$ is decomposable. That accounts for *which* class fails there.

It cannot be the general reason a class fails. Seven of the eight cases in
@sec-fail are non-CM curves of conductor $11$ to $20$, failing at
$p = 5, 7, 11, 17, 19$, and their common local signature is not CM but
something much plainer: at the failing place $E_delta$ has *multiplicative*
reduction $I_nu$ with $gcd(c_p, p - a_p) > 1$, so that
$E_delta (QQ_p) slash E_1$ has $(ZZ slash ell)^2$ as a quotient for the *layer*
prime $ell = 2, 3$ or $5$ --- here, as in §2.3 of the companion notes, $p$ is the
place and $ell$ the layer. `27a1` is the odd one out --- additive $"IV"^*$ with
$c_3 = 3$ and $p - a_p = 3$ --- but lands on the same conclusion,
$(ZZ slash 3)^2$ as a quotient.

So the object to look for is a pairing that keeps the rational points of every
twist in that class inside a proper subgroup of $(ZZ slash ell)^2$, and the
CM story of §5.1.1 is one way, not the way, for that to happen. @sec-pairing
measures exactly that subgroup for the second CM defect and finds it isotropic
with a varying line, which is a pairing and not a functional. §5.1.3's
criterion --- obstructed iff the denominator of $j$ is a power of $2$ --- was
formulated for the $E[3]$-decomposable families at $p = 3$; here the
denominators of $j$ are powers of the failing prime itself, which is just
potentially-multiplicative reduction and does not discriminate.

The CM batch (@sec-cm) closes the converse direction too. CM is not a cause of
trouble: one defect in $7740$ pairs there against eight in $5400$ here, and
both CM defects are isolated points of infinite families whose other members
--- 84 and 73 of them --- are fine at the very prime where their one bad
sibling fails. What the two batches share is only that $g = 2$ at the failing
place, which is necessary and nowhere near sufficient.

== Torsion drives the cost

The triage split is set almost entirely by the rational torsion of $E$:
rational $l$-torsion injects into $tilde(E)(bb(F)_p)$ at good primes and
pushes it off being cyclic. The four surfaces with $n_QQ = 3$ (`15a1`, `15a2`,
`15a3`, `17a2`) have *zero* pairs on the cheap path --- $180$ of $180$ went to descent --- while `496a`, with trivial
torsion, sends only $46$. Since descent is some 300 times dearer per twist
than the sweep, torsion is what the runtime is really measuring.

= Reproducing

From this directory, with `gp` given a large stack:

```
gp -q -s 4000000000 survey.gp < /dev/null
```

then, inside it:

```
/* one surface, all odd p <= 200 and p = 2, with timings */
runsurface("11a3", [1,-1,1], 1500, 50, 200, 60, 3000, 300);

/* the deeper pass on a single class (cofactor window) */
deephunt([-11,-1,-83], 11, 1, 1, 20000);       /* 11a1, p=11, class [u] */
hunt2("17a4", [3,-8,-4], 3, 1, 20000);         /* p = 2, class [7]      */

/* why a class failed: local generator count, then the rank supply */
gloc([10,105,-116], 1, 7);                     /* 2 -- rank 1 is useless */
classaudit("14a1", [10,105,-116], 7, 0, 3000);
rankaudit("14a1", [10,105,-116], 7, 0, 3000);

/* the CM batch (section 5) */
runsurface("j1728:1", [0,1,0], 1500, 50, 200, 60, 3000, 300);
gloc2([0,1,0], 1);                             /* 2 -- the criterion binds */
rankaudit2("j1728:1", [0,1,0], 4, 4000);       /* class [2] */
sexticscan(100, 3, 3000);                      /* 85 surfaces at p = 3 */
quarticscan(60, 1500);                         /* 74 surfaces at p = 2 */

/* the section-5.1.5 question at l = 2 */
torsionmodule([0,1,0]);                        /* E[2] indecomposable, End non-scalar */
imagelines("x^3+x [2] DEFECTIVE", [0,1,0], 2, 1500, 40);
imagelines("x^3+x [6] witnessed", [0,1,0], 6, 1500, 40);

/* the elementary argument of section 5.5 */
homtest([0,1,0], 130, 6);                      /* [n, 0] -- Lemma 1, Vieta     */
normtest([0,1,0], 130, 100);                   /* [n, 0] -- Lemma 2            */
lemmaA([0,1,0], 130, 5, 30, 5, 60);            /* [510, 0] -- Lemma A          */
cyctest([0,1,0], 2, 1200, 30);                 /* #S is 1 or 2, never 4        */
img2table([0,1,0], 200);                       /* the mod-8 table at 2         */
nzbeta(cimagep([0,1,0], 2, 2, 40, 8, 60), 2);  /* 1 -- symbol non-degenerate   */

/* the ledger at one odd place (section 3.3.1) */
ledgerp("15a1", [-10,-127,136], 5, 0, 2, 2000, 30);

/* the pairings of section 6 */
cvals([17,1,-8], 1, [5, 10]);                  /* the three descent values     */
nzlocal(cpairimage([17,1,-8], 11, 3, 30, 4, 40), [[1,1],[0,0]], 3);
cubicsym(3, 7, 7);                             /* the tame cubic symbol at 7   */
tangent3(ellinit([5,0,7,0,0]), [0,0]);         /* 14a1: tangent at T1 is y = 0 */
```

The two surface lists come from Sage:

```sh
docker run --rm --platform linux/amd64 -v "$PWD":/work -w /work \
       sagemath/sagemath:latest sage surfaces.sage       # smallest conductors
docker run --rm --platform linux/amd64 -v "$PWD":/work -w /work \
       sagemath/sagemath:latest sage cm-surfaces.sage    # the CM surfaces
```

Raw output of every run is in `results/survey-*.txt`; `survey-tables.typ` and
`survey-tables-cm.typ` are generated from it by `survey-tables.py` and are not
edited by hand.

Total compute for everything in this document: for the first batch, $321$ s for
the main sweep over thirty surfaces, $595$ s for the deep hunts of @sec-fail,
$216$ s for the two $p = 2$ passes, $124$ s for the local audits and $32$ s for
the model-independence check; for the CM batch, $334$ s for the main sweep over
43 surfaces, $198$ s for the audits and deep hunts, $82$ s for the two family
scans, $109$ s for the $p = 2$ work on $x^3 + x$, $10$ s for the image-line
experiment of @sec-pairing and $6$ s for the Hilbert-symbol runs behind
@sec-alt and @sec-thm2. About $34$ minutes, plus $21$ s of Sage for the two
curve lists.
