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

Only $v = 3$ imposes a condition, and it is explicit: $E_d [3](QQ_3) = 0$ exactly
when
$ 3 divides.not d "and" d equiv 2 (mod 3), quad "or" quad
  3 divides d "and" d slash 3 equiv 1 (mod 3), $
since $d$ is a square in $QQ_3$ iff $d equiv 1$ $(mod 3)$, and $-3d$ is a square
iff $3 divides d$ with $-d slash 3 equiv 1$. Of the 1062 squarefree $d$ in the
class with $|d| <= 2000$, *533* satisfy it --- exactly half.

=== The theorem <sec-14a1-thm>

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Theorem.* Let $d$ be squarefree in the class $[1]$ of $QQ_7^times$ and suppose
  $E_d [3](QQ_3) = 0$, i.e. $d equiv 2$ $(mod 3)$, or $3 divides d$ with
  $d slash 3 equiv 1$ $(mod 3)$. Then $E_d (QQ)$ is not dense in $E_d (QQ_7)$;
  hence $X(QQ)$ is not dense in $X(QQ_7)$ for $X : y^2 = f(x) f(t)$,
  $f = x^3 + 10x^2 + 105x - 116$.

  #v(2mm)
  _Proof._ $beta$ is alternating at every place, so $beta_v = 0$ wherever
  $dim W_v <= 1$; by the table that is every $v != 7$. Reciprocity
  $sum_v "inv"_v beta_v = 0$ then gives $beta_7 (P,Q) = 0$ for all
  $P, Q in E_d (QQ)$. On $W_7$, $beta_7$ is the tame cubic symbol transported by
  $c_1$, non-zero and alternating on a 2-dimensional $bb(F)_3$-space, hence
  symplectic; the image of $E_d (QQ)$ is isotropic and so has dimension $<= 1$.
  It is therefore not all of $W_7 = E_delta (QQ_7) slash 3$, the Frattini
  quotient at the layer, and $E_d (QQ)$ is not dense. $qed$
]

Two things distinguish this from @sec-15a1.

*Nothing was verified numerically.* At level 2 the alternating property had to be
proved by hand (`x^3 + x`) or the local vanishing checked by machine (`15a1`).
Here decomposability hands over the alternating property, and the places then
fall out of a single fact --- $-3$ is a square in $QQ_7$ and in neither $QQ_2$
nor $QQ_3$. The only computation is the symbol table at 7.

*The remaining half needs exactly what §5.1.5 needs.* For $d equiv 1$ $(mod 3)$,
$dim W_3 = 2$ and $beta_3$ has to be evaluated at the wild place --- the cubic
norm-residue symbol at $3$ that neither PARI nor Sage provides. The difference is
that here it is an *auxiliary* place: the obstruction lives at 7 and is tame,
while §5.1.5's lives at 3 and is not. Closing it would finish the other half.

#align(center, table(
  columns: 5, align: (left, center, center, center, left),
  stroke: 0.4pt + luma(170), inset: (x: 6pt, y: 3pt),
  table.header([case], [level], [critical place], [$E[ell]$], [status]),
  [$x^3 - 2$ (§5.1.5)], [3], [3 --- *wild*], [decomposable],
    [$beta_3 equiv.not 0$ closed in @sec-magma],
  [$x^3 + x$ (@sec-thm2)], [2], [2], [*indecomposable*], [complete],
  [`15a1` (@sec-15a1)], [2], [5], [split over $QQ$],
    [local vanishing verified],
  [`14a1` (@sec-14a1)], [3], [7 --- *tame*], [decomposable],
    [complete for half the class],
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
    [$0$ iff $d$ is not a square in $QQ_5$],
  [$v = 11$], [$dim W_11 = 2$, $beta_11$ non-degenerate], [$!= 0$],
)

#v(2mm)

Note $11 divides.not d$ throughout, since the class is $[1]$ at 11. The condition
at 5 is cleaner than `14a1`'s: it asks only that $d$ fail to be a square in
$QQ_5$, i.e. $5 divides d$ or $d equiv plus.minus 2$ $(mod 5)$.

=== The theorem <sec-11a1-thm>

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Theorem.* Let $d$ be squarefree, a square in $QQ_11^times$ (the class $[1]$),
  and *not* a square in $QQ_5^times$. Then $E_0^((d))(QQ)$ is not dense in
  $E_0^((d))(QQ_11)$; hence $X(QQ)$ is not dense in $X(QQ_11)$ for the surface
  `11a1`.

  #v(2mm)
  _Proof._ $beta$ is alternating at every place, so $beta_v = 0$ wherever
  $dim W_v <= 1$; by the table that is every $v != 11$. Reciprocity
  $sum_v "inv"_v beta_v = 0$ gives $beta_11 (P,Q) = 0$ for all
  $P, Q in E_0^((d))(QQ)$. But $beta_11$ is non-degenerate on the 2-dimensional
  $W_11$, so the image of the rational points is a proper subspace, of dimension
  $<= 1$. It is therefore not all of $W_11 = E_delta (QQ_11) slash 5$, and the
  rational points are not dense. $qed$
]

Of the 1115 squarefree $d$ in the class with $|d| <= 2000$, *652* --- $58.5%$ ---
satisfy the condition at 5. @sec-ledger-odd's measurement agrees with the
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
$v = ell$. These should go through exactly as `14a1` did, giving a theorem on the
half of each class where $E_d [ell](QQ_ell) = 0$, with the other half waiting on
the wild symbol. The worry that `11a1` would need a *quintic* residue symbol
turned out to be unfounded --- see @sec-11a1.

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
