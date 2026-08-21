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
  $(c(P), c(Q))_2 = +1$ for all $P, Q in E_d (QQ)$. Hence $E_d (QQ)$ is not dense in
  $E_d (QQ_2)$, and --- by @sec-class-warning, the vanishing holding for every $d$ in the two
  classes --- $X(QQ)$ is not dense in $X(QQ_2)$ for $X : y^2 = (x^3 + x)(t^3 + t)$. (The criterion of the companion
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
  $E_d (QQ_2)$. The statement about $X$ is @sec-class-warning applied to the pair statement
  $(c(P), c(Q))_2 = +1$, which is what reciprocity gave in the first place. $qed$
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


= Local technique <sec-toolkit>

The sections that follow all do the same thing at every place of $QQ$: decide whether the twisted
pairing $beta_v$ is trivial there, for every twist $d$ in a square class at once. By now the same
half-dozen moves have been made repeatedly, in four different families and at three levels, so they
are worth stating once. Nothing in this chapter is new; it is the accumulated technique of
@sec-nonCM and of §5.1.5 of the companion notes, pulled out of the worked examples.

Throughout, unless said otherwise, $E slash QQ$ has $E[ell] = C_1 xor C_2$ *decomposable* and
$phi$ is the projector onto $C_1$ along $C_2$; that is the situation of five of the six worked
cases, and @sec-tk-indec says what changes in the sixth, where $E[ell]$ has a unique stable line.
For a place $v$,
$ W_v = E_d (QQ_v) slash ell, quad quad L_v = delta_v (W_v) subset.eq H^1 (QQ_v, E[ell]) =: H_1 xor H_2, $
with $H_i = H^1 (QQ_v, C_i)$ and $alpha_i = pi_i compose delta_v : W_v -> H_i$. Recall from
§5.1.4 that $W_v$ is a *quotient of points* and $L_v$ a *subspace of cohomology*: they are
isomorphic but only $L_v$ can be intersected with $H_i$.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *Notation for the values of $beta$.* $beta_v$ takes values in
  $"Br"(QQ_v)[ell] tilde.equiv (1 slash ell) ZZ slash ZZ$, which we write
  *additively*: the trivial value is $0$ and reciprocity reads
  $sum_v beta_v = 0$. At $ell = 2$ it is more natural to write the pairing as a
  quadratic Hilbert symbol, with values $plus.minus 1$ written
  *multiplicatively*: there the trivial value is $+1$ and reciprocity reads
  $product_v beta_v = 1$. These are the same thing under
  $plus.minus 1 tilde.equiv (1 slash 2) ZZ slash ZZ$. Each worked section keeps
  to one convention --- @sec-15a1 and @sec-15a4 multiplicative, @sec-14a1 and
  @sec-11a1 additive --- and where the distinction is immaterial, as it mostly is in this chapter,
  we say that $beta_v$ is *trivial* or *non-trivial* rather than naming a value.
]

== What has to be shown at a place <sec-tk-criterion>

Everything reduces to one chain of equivalences, established as Steps 1--2 of §5.1.5.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Criterion.* $beta_v equiv 0$ on $W_v$ if and only if $L_v$ is $phi_*$-stable, if and only if
  $ L_v = (L_v inter H_1) xor (L_v inter H_2) . $
  Writing $L_v inter H_1 = delta_v (ker alpha_2)$ and $L_v inter H_2 = delta_v (ker alpha_1)$, and
  noting $ker alpha_1 inter ker alpha_2 = ker delta_v = 0$, this says
  $ dim ker alpha_1 + dim ker alpha_2 = dim W_v . $
]

The first equivalence is Tate local duality: $beta_v equiv 0$ says
$phi_* L_v subset.eq L_v^perp$, and $L_v^perp = L_v$ because $L_v$ is Lagrangian.

#block(fill: rgb("#fff4f4"), inset: 8pt, radius: 3pt, width: 100%)[
  *The trap.* When $dim W_v = 2$ it is tempting to test stability by asking whether *both*
  $ker alpha_i$ are non-zero. That is *sufficient* --- each is then 1-dimensional and the sum is
  direct --- but not necessary: if $L_v$ happens to lie inside a single $H_i$, that intersection
  has dimension 2, the other is zero, and $L_v$ is a direct sum trivially, hence still stable. A
  computation returning "one zero, one non-zero" therefore decides *nothing* until the dimension of
  the non-zero one is known. Both possibilities occur in practice: dimensions $1 + 1$ at `11a1` and
  at the good-reduction twists of `14a1`, and $2 + 0$ at `14a1`'s additive twists (@sec-14a1-places).
]

== The indecomposable case <sec-tk-indec>

Everything so far has assumed $E[ell] = C_1 xor C_2$ decomposable, which is the situation of five
of the six worked cases. When $E[ell]$ has a *unique* stable line the decomposition is not
available, and the criterion of @sec-tk-criterion has to be restated. It becomes simpler, not
harder.

=== The unique twisting endomorphism, and what replaces $phi_*$-stability <sec-tk-indec-crit>

Suppose $E[ell]$ has exactly one Galois-stable line $C$, and that the characters on $C$ and on
$E[ell] slash C$ agree --- automatic at $ell = 2$, where $bb(F)_2^times$ is trivial. Then
$"End"_G (E[ell]) = bb(F)_ell [N] slash (N^2)$: the commutant of a single unipotent Jordan block.
By the classification of @sec-brauer-rank1 there is *exactly one* rank-one $phi$, namely the
nilpotent $N$, with
$ ker N = "im" N = C , $
which is why @sec-triage-templates can call the twisting endomorphism "essentially unique" here
while `15a1`, with three stable lines, needed a search among nine.

Write $c = pi_(C *) compose delta_v : W_v -> H^1 (QQ_v, E[ell] slash C)$ for the descent map
attached to $C$, as in @sec-tk-alpha. Since $N$ factors as
$E[ell] arrow.r.twohead E[ell] slash C limits(-->)^(overline(N), tilde) C arrow.hook E[ell]$, and
the Weil pairing is alternating so that $C^perp = C$ and it induces a perfect pairing of
$E[ell] slash C$ with $C$, the adjunction of @sec-brauer-cor gives

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  $ beta_v (P, Q) = ⟨c(P), space overline(N)_* c(Q)⟩ $
  --- *the same map in both slots*. So $beta_v$ is trivial if and only if the image $c(W_v)$ is
  *isotropic* for the induced pairing on $H^1 (QQ_v, E[ell] slash C)$, and non-degenerate exactly
  when that image is everything and the pairing is non-degenerate on it.
]

That is the structural difference. In the decomposable case the two slots carry *different* maps
$alpha_1$ and $alpha_2$, and the question is whether $L_v$ *splits*; here they carry the *same*
map, and the question is whether one subgroup is *isotropic*. In particular a *cyclic* image is
isotropic as soon as the pairing is alternating on it, which is the form the argument takes at
every auxiliary place.

At $ell = 2$ everything is concrete. $E[2] slash C tilde.equiv ZZ slash 2 tilde.equiv mu_2$, so
$H^1 (QQ_v, E[2] slash C) = QQ_v^times slash (QQ_v^times)^2$, the induced pairing is the quadratic
Hilbert symbol, and with $f = (u - e_1) q(u)$ and $C = ⟨T⟩$, $T = (e_1, 0)$,
$ c(P) = x(P) - e_1 quad (mod "squares"), quad quad
  beta_v (P,Q) = (c(P) , space c(Q))_v . $
Alternating is then the condition $(c(P), -1)_v = 1$, which is Lemma 2 of @sec-alt: it holds when
the 2-torsion field is $QQ(i)$, equivalently when $q$ is a *sum of two squares*, because then
$c(P)$ is a norm from $QQ(i)$.

=== The image at a ramified odd place <sec-tk-lemAB>

The one auxiliary place that is not covered by @sec-tk-places is $q divides d$ with $q$ odd: as
@sec-tk-ramtwist observes, the twist does nothing to $E[2]$, so the torsion is not killed and
$W_q$ need not vanish. What settles it instead is that the *image* of $c$ is small. This was
proved for $x^3 + x$ in @sec-places2 and used verbatim for `15a4` and `17a1`; the hypothesis that
makes it transfer is worth naming.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Lemma (A and B).* Let $f = u(u^2 + a u + b)$ with $b$ a *perfect square*, and let
  $E_d : y^2 = x(x^2 + a d x + b d^2)$ with $c(P) = x(P)$ modulo squares. Let $q$ be an odd prime
  with $q divides.not b$ and $q divides d$, $d$ squarefree, so $e := v_q (d) = 1$. Then

  #v(1.5mm)
  *(A)* every $P in E_d (QQ_q)$ with $v_q (x(P)) != 1$ has $c(P) = 1$; and

  *(B)* the image $S := c(E_d (QQ_q))$ has order at most 2.

  #v(1.5mm)
  Consequently, if $beta$ is alternating at $q$ then $beta_q$ is trivial.

  #v(2mm)
  _Proof._ (A) Write $k = v_q (x(P))$. If $k < 1$ then
  $x^2 + a d x + b d^2 = x^2 (1 + a d slash x + b d^2 slash x^2)$, and both correction terms have
  positive valuation, so the bracket is a 1-unit and hence a *square* at an odd place; then
  $y^2 = x dot x^2 dot (square)$ exhibits $x$ as a square. If $k > 1$, put $t = x slash d$, so
  $v_q (t) = k - 1 > 0$ and
  $ x^2 + a d x + b d^2 = b d^2 (1 + (a slash b) t + t^2 slash b) , $
  where $q divides.not b$ makes the bracket integral and again a 1-unit, hence a square. Then
  $y^2 = x dot b d^2 dot (square)$ gives $c(P) = x equiv b$ modulo squares --- and $b$ is a square.

  #v(1.5mm)
  (B) $S$ is a subgroup of $QQ_q^times slash (QQ_q^times)^2$, and by (A) each of its elements is
  either trivial or the class of some $x$ with $v_q (x) = 1$, i.e. of *odd* valuation. If $S$ had
  two distinct non-trivial elements, their product would be a non-trivial element of *even*
  valuation, which (A) forbids. So $\#S <= 2$. An alternating form vanishes on a group of order
  $<= 2$. $qed$
]

Both hypotheses are used, and both hold in the cases here: $b = 1$ for $x^3 + x$, $b = 625 = 25^2$
for `15a4`, $b = 289 = 17^2$ for `17a1`; and in each the only prime dividing $b$ is the *critical*
$p$, which cannot divide $d$ because the failing class asks $d$ to be a square in $QQ_p^times$. For
$f$ *split* over $QQ$ the lemma does not apply at all, and @sec-15a1 needs its own Lemma C.

== The two faces of $alpha_i$ <sec-tk-alpha>

The maps $alpha_i$ can be computed in two ways, and which is convenient varies.

*As a dual isogeny image.* With $psi_j : E -> B_j = E slash C_j$ and $hat(psi)_j$ its dual, Step 5
of §5.1.5 gives
$ ker alpha_i = hat(psi)_j (B_j (QQ_v)) slash ell E(QQ_v) subset.eq W_v, quad quad j != i . $
Good for *existence*: exhibiting one point of $B_j (QQ_v)$ whose image escapes $ell E(QQ_v)$ proves
$ker alpha_i != 0$, and that direction is sound however coarse the sample. Bad for *dimension*,
which is what the trap above needs, and bad numerically --- the isogeny is evaluated as a rational
map at $v$-adic points and precision drains fast.

*As a function value.* If $C$ is a Galois-stable line generated by a $QQ_v$-rational point $T$, let
$f_C$ be the function with $"div"(f_C) = ell(T) - ell(O)$ --- unique up to a constant, and for
$ell = 3$ simply the tangent at $T$, for $ell = 2$ simply $x - e(T)$. Then, as in
@sec-brauer-twofns,
$ pi_(C *) compose delta_v : W_v --> H^1 (QQ_v, E[ell] slash C), quad P |-> f_C (P) space (mod ell"-th powers") . $
Good for *dimension*: the image is a subgroup of a group of order $ell^2$, and the computation is
exact (@sec-tk-classes). Available only when the line has a rational generator, which at the wild
place is exactly the interesting case.

== Places that cannot contribute <sec-tk-places>

Most places are disposed of without any computation. The following are used verbatim in every one
of the worked cases.

#align(center, table(
  columns: 3, align: (left, left, left),
  stroke: 0.4pt + luma(170), inset: (x: 7pt, y: 3.5pt),
  table.header([place], [why $beta_v$ is trivial], [needs]),
  [$v = infinity$], [$E_d (RR)$ is $ell$-divisible, so $W_infinity = 0$], [$ell$ odd],
  [$v$ good, $v != ell$], [$L_v = H^1_"ur"$ is its own annihilator and $phi_*$ preserves it],
    [nothing],
  [$dim W_v <= 1$], [an alternating form on a space of dimension $<= 1$ is zero],
    [$beta$ alternating],
  [$q divides d$, $q != ell$], [the twist is ramified at $q$ and the torsion characters are not,
    so $E_d [ell](QQ_q) = 0$ and $W_q = 0$ --- @sec-tk-ramtwist],
    [*$ell$ odd*, $d$ squarefree],
))

#v(2mm)

Two dimension counts drive the third row:
$ dim W_v = dim E_d [ell](QQ_v) space (v != ell), quad quad
  dim W_ell = 1 + dim E_d [ell](QQ_ell) , $
the first because $E_d (QQ_v)$ is a pro-$v$ group times a finite one and the pro-$v$ part is
uniquely $ell$-divisible, the second from $\#E(K) slash n E(K) = \#E(K)[n] dot |n|_K^(-1)$.

=== The twist at a ramified place <sec-tk-ramtwist>

The fourth row of the table above compares the ramification of two characters, and deserves to be
spelled out --- not least because it is *false at $ell = 2$*, which is why `15a1` cannot use it.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Lemma.* Let $ell$ be an *odd* prime and $E slash QQ$ an elliptic curve with
  $E[ell] = C_1 xor C_2$ a sum of Galois-stable lines. Let $d$ be squarefree and let $q$ be a prime
  with $q divides d$ and $q != ell$. Suppose the character through which Galois acts on $C_1$ is
  *unramified at $q$* --- as it is, being trivial, when $C_1$ is generated by a $QQ$-rational point
  of order $ell$. Then
  $ E_d [ell](QQ_q) = 0, quad "hence" quad W_q = 0 quad "and" quad beta_q "is trivial." $

  #v(2mm)
  _Proof._ Galois acts on the line $C_i$ through a character
  $theta_i : G_QQ -> bb(F)_ell^times$, and the Weil pairing
  $C_1 times.o C_2 -> mu_ell$ forces $theta_1 theta_2 = overline(chi)$, the mod-$ell$ cyclotomic
  character. Quadratic twisting by $d$ tensors $E[ell]$ with the quadratic character $chi_d$ of
  $QQ(sqrt(d))$, so $C_i^((d)) = bb(F)_ell (theta_i chi_d)$; and a one-dimensional space carries a
  non-zero fixed vector exactly when its character is trivial, so
  $ C_i^((d))(QQ_q) != 0 quad <==> quad theta_i chi_d |_(G_q) = 1 . $

  #v(1.5mm)
  Restrict to the inertia subgroup $I_q subset.eq G_q$ and compare *ramification*:

  #v(1mm)
  - $chi_d |_(I_q) != 1$. Since $d$ is squarefree and $q divides d$, $v_q (d) = 1$ is odd, so
    $QQ_q (sqrt(d)) slash QQ_q$ is a *ramified* quadratic extension.
  - $overline(chi) |_(I_q) = 1$. The field $QQ(mu_ell)$ is ramified only at $ell$, and
    $q != ell$.
  - $theta_1 |_(I_q) = 1$ by hypothesis, and therefore
    $theta_2 |_(I_q) = overline(chi) theta_1^(-1) |_(I_q) = 1$ as well.

  #v(1mm)
  So $theta_i chi_d |_(I_q) = chi_d |_(I_q) != 1$ for $i = 1$ and $i = 2$: each character is
  already non-trivial on inertia, hence non-trivial on $G_q$. Both $C_i^((d))(QQ_q)$ therefore
  vanish, so $E_d [ell](QQ_q) = 0$; and $q != ell$ gives
  $dim W_q = dim E_d [ell](QQ_q) = 0$. $qed$
]

#block(fill: rgb("#fff4f4"), inset: 8pt, radius: 3pt, width: 100%)[
  *Why $ell$ must be odd.* $chi_d$ takes values in ${plus.minus 1}$, which is a subgroup of
  $bb(F)_ell^times$ of order 2 only when $ell$ is odd. At $ell = 2$ it is the *trivial* subgroup,
  the twist does nothing to the torsion module --- $E_d [2] tilde.equiv E[2]$ as Galois modules for
  every $d$ --- and the lemma has no content. Worse, when $f$ splits over $QQ$ all three 2-torsion
  points are rational, so $dim W_q = 2$ at *every* odd $q$, ramified twist or not. That is exactly
  why @sec-15a1 gets nothing from this row and needs Lemma C at $q divides d$, while @sec-14a1 and
  @sec-11a1 get those places for free.

  #v(1.5mm)
  The two behaviours are visible side by side in `localimg.gp`: for `14a1` at $ell = 3$ and
  $q divides d$ --- $q = 2, 5, 11, 13, 23$ --- there are *no* $QQ_q$-rational 3-torsion points,
  while for `15a1` at $ell = 2$ and the same kind of $q$ *all three* 2-torsion points are
  $QQ_q$-rational.
]

=== When $beta$ is alternating <sec-tk-alt>

For $ell$ odd it is free: writing $delta_v P = a_1 + a_2$, each
$H^1 (C_i)$ is isotropic (the Weil pairing is trivial on a cyclic $C_i$), $L_v$ is isotropic, so
$0 = ⟨delta_v P, delta_v P⟩ = 2 ⟨a_1, a_2⟩$ and 2 is invertible modulo $ell$. At $ell = 2$ that
argument dies and one needs the norm lemma: if the 2-torsion field is $QQ(i)$ then
$(c(P), -1)_v = 1$ and $beta$ is alternating (Lemma 2 of @sec-alt).

=== Which places are left <sec-tk-left>

Since $C_1^((d))$ and $C_2^((d))$ are $ZZ slash ell$ and $mu_ell$ twisted
by the same quadratic character, both are rational at $v$ only if $mu_ell subset QQ_v$, i.e.
$v equiv 1$ modulo $ell$. So $dim W_v = 2$ needs that, and at the *critical* place
$p equiv 1$ modulo $ell$ --- which is why the symbol there is always the *tame* $ell$-th power
residue symbol, never the wild one. What survives is: the critical $p$; the wild place $v = ell$;
and bad primes $equiv 1$ modulo $ell$ at which $d$ is a square.

== The wild place $v = ell$ <sec-tk-wild>

This is the one place where the method needs something non-generic, since a 2-dimensional $L_ell$
inside a 4-dimensional $H^1$ has no reason to be $phi_*$-stable. Two mechanisms have been found to
make it so, and they are structurally different.

=== The good ordinary case <sec-tk-ordinary>

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Lemma.* Let $v = ell$ and suppose $E$ has good
  *ordinary* reduction at $ell$, with $E[ell] = C_1 xor C_2$ where $C_1 tilde.equiv ZZ slash ell$
  is generated by a $QQ_ell$-rational point and $C_2 tilde.equiv mu_ell$. Then
  $L_ell = delta_ell (W_ell)$ is $phi_*$-stable, so $beta_ell equiv 0$.

  #v(2mm)
  _Proof._ Over $ZZ_ell$ the closure of $C_1$ is the constant, hence *étale*, group scheme
  $ZZ slash ell$, and the closure of $C_2$ is $mu_ell$, which is *connected* at residue
  characteristic $ell$. Ordinary reduction means the connected--étale sequence
  $0 -> cal(E)[ell]^0 -> cal(E)[ell] -> cal(E)[ell]^"ét" -> 0$ has both ends of order $ell$; so
  $cal(C)_2 = cal(E)[ell]^0$, and $cal(C)_1$ splits the sequence:
  $cal(E)[ell] = cal(C)_1 xor cal(C)_2$ as finite flat group schemes. At a place of good reduction
  the Kummer image is the flat subgroup $H^1_f$, which is functorial in the group scheme, so
  $L_ell$ splits along that decomposition. A split $L_ell$ is $phi_*$-stable. $qed$
]

The hypothesis is often forced rather than assumed: if $dim W_ell = 2$ requires $d$ to be a square
in $QQ_ell$, then $d$ is squarefree so $ell divides.not d$, so $E_d tilde.equiv E$ over $QQ_ell$
and the reduction is whatever $E$'s is. That is how `11a1` at $v = 5$ and the good-reduction twists
of `14a1` at $v = 3$ are settled.

=== The collapse case <sec-tk-collapse>

When $dim W_ell = 2$ is reached through *additive* reduction the
lemma says nothing, and what can happen instead is that one of the two descent maps vanishes
identically. Then $ker alpha_i = W_ell$, $L_ell$ lies inside a single $H_j$, and $L_ell$ is
$phi_*$-stable for the trivial reason. This is what happens at `14a1`'s additive twists, and it is
invisible to the "both non-zero" test --- see the trap in @sec-tk-criterion.

=== Detecting either <sec-tk-detect>

Use the function-value description of @sec-tk-alpha: at the wild place the
relevant line usually *does* have a rational generator, so $alpha$ is evaluation of a tangent, the
image is computed exactly, and $dim ker alpha = dim W_ell - dim "im" alpha$ settles the criterion.

== Reduction to finitely many computations <sec-tk-classes>

This is the organising principle that turns a claim about infinitely many twists into a bounded
check, and it is worth stating flatly.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *$E_d$ over $QQ_v$ depends on $d$ only through its class in
  $QQ_v^times slash (QQ_v^times)^2$*, a group of order 4 for $v$ odd and 8 for $v = 2$. So a
  statement about $E_d (QQ_v)$ for *all* squarefree $d$ is at most 4 (or 8) local computations. If
  the twists are further restricted to a square class at some other place $p != v$, that restricts
  the class at $v$ not at all, and all 4 (or 8) are still needed.
]

Two things make each computation a *proof* rather than a sample.

*Generation.* The maps in play are homomorphisms out of $W_v$, so an image computed on a set of
points that *generates* $W_v$ is the whole image. It is enough to generate a finite quotient
$E_d (QQ_v) slash E_n$ with $E_n subset.eq ell E_d (QQ_v)$, and
$ ell E supset.eq ell E_1 = E_1 quad (v != ell), quad
  ell E supset.eq ell E_1 = E_2 quad (v = ell "odd"), quad
  ell E supset.eq 2 E_2 = E_3 quad (v = ell = 2) , $
using that $E_1$ is pro-$v$ and uniquely $ell$-divisible in the first case, and that
$E_n (QQ_v) tilde.equiv ZZ_v$ once $n > e slash (ell - 1)$ in the others. The order of the quotient
is $M_v$ (or $M_v dot ell$, or $M_v dot 4$), which gives the check something to match.

*Exact classes.* A class in $QQ_v^times slash (QQ_v^times)^ell$ is determined by the valuation
together with finitely many digits of the unit, because $U^((m)) subset.eq (QQ_v^times)^ell$ as
soon as $m > ell e slash (ell - 1)$. In the cases used here:

#align(center, table(
  columns: 3, align: (left, left, left),
  stroke: 0.4pt + luma(170), inset: (x: 7pt, y: 3.5pt),
  table.header([$ell$, $v$], [a class is $(v_v (z) mod ell, dots)$], [order]),
  [$ell = 2$, $v$ odd], [the quadratic residue symbol of the unit], [4],
  [$ell = 2$, $v = 2$], [the unit modulo 8], [8],
  [$ell = 3$, $v equiv 1 (mod 3)$], [$u^((v-1) slash 3)$ modulo $v$], [9],
  [$ell = 3$, $v = 3$], [the unit modulo 9, up to sign ($1 + 9 ZZ_3$ are cubes, $-1$ is a cube)],
    [9],
))

#v(2mm)

No $v$-adic precision is consumed, which matters: the dual-isogeny route of @sec-tk-alpha, which
does consume it, once returned an "image" of 5 elements inside $(ZZ slash 3)^2$.

== Symbol technique <sec-tk-symbols>

The identities that keep coming up.

- *Steinberg.* $(a, 1-a)_v = 0$ and $(a, -a)_v = 0$. The second closes Lemma C of @sec-15a1-local:
  the only possibly non-trivial symbol there is $(-q d', q d')_q$.
- *1-units are $ell$-th powers at $v$ prime to $ell$.* Hence at an odd $q$, a factor
  $1 + O(q)$ may be discarded modulo squares --- the engine of Lemma A and B (@sec-tk-lemAB) and
  of cases (i) and (iii) of Lemma C.
- *The tame formula.* At $v tilde.not ell$ with $mu_ell subset QQ_v$,
  $(a,b)_v = ((-1)^(alpha beta) a^beta slash b^alpha)^((N v - 1) slash ell)$ with
  $alpha = v(a)$, $beta = v(b)$. This evaluates the critical symbol in every case here, since
  $p equiv 1$ modulo $ell$ always (@sec-tk-places).
- *The wild symbol, by going global.* At $v = ell$ the formula fails and an explicit reciprocity
  law was expected to be needed. It is not: if the global field has a *single* prime above $ell$,
  the product formula gives the wild symbol as minus the sum of the tame ones, and every local
  class has a global representative because $U^((m))$ is inside the $ell$-th powers for $m$ large.
  Carried out for $QQ_3 (zeta_3)$ in @sec-brauer-3-wild.
- *Square root differences.* When $f$ splits and the differences $e_i - e_j$ are perfect squares,
  the descent classes collapse to a single quantity up to sign. That fact does three separate jobs
  for `15a1`: it confines the bad places (@sec-15a1-local), it proves Lemma C, and it makes
  $cal(A)$ unramified on the Kummer surface (@sec-brauer-unram-2).

== From a pairing to a statement about the surface <sec-class-warning>

Each theorem of @sec-nonCM proves something about $E_d (QQ)$ for $d$ in a square class and then
draws a conclusion about the *surface*. Two things are needed, and the first is not what it looks
like: the conclusion has to be read on *pairs*.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Lemma.* Fix a place $p$ and a square class $delta$ of $QQ_p^times$, and write
  $W_delta = E_delta (QQ_p) slash ell$. Suppose $beta_p equiv.not 0$ on $W_delta$, and suppose that
  for *every* squarefree $d$ in the class,
  $ beta_p (P, Q) = 0 quad "for all" P, Q in E_d (QQ). $
  Then $X(QQ)$ is not dense in $X(QQ_p)$.

  #v(2mm)
  _Proof._ On the locus $y != 0$ the class of $f(x)$ in $QQ_p^times slash (QQ_p^times)^2$ is
  locally constant, so the part of $X(QQ_p)$ lying over $delta$ --- namely
  $(E_delta times E_delta)(QQ_p) slash plus.minus$ --- is *open* in $X(QQ_p)$; and for every $d$ in
  the class $E_d$ is $QQ_p$-isomorphic to $E_delta$, so $beta_p$ is one and the same pairing on one
  and the same $W_delta$ for all of them. The pairing factors through the *finite
  discrete* quotient $W_delta times W_delta$, so
  $ Z = { (P, Q) in (E_delta times E_delta)(QQ_p) : beta_p (P,Q) = 0 } $
  is open and closed, and *proper* because $beta_p equiv.not 0$. It is stable under
  $(P,Q) |-> (-P,-Q)$, so it descends to a proper open subset of the $delta$-part. Every rational
  point of $X$ lying over $delta$ is a pair of points of $E_d (QQ)$ for some squarefree $d$ in the
  class, hence lies in $Z$. So $X(QQ)$ misses the non-empty open complement. $qed$
]

*Why the group statement is too weak.* The same hypothesis also gives that the image $R_d$ of
$E_d (QQ)$ in $W_delta$ is isotropic --- hence, when $beta_p$ is non-degenerate on the
2-dimensional $W_delta$, a *proper subspace* --- and therefore that $E_d (QQ)$ is not dense in
$E_d (QQ_p)$. That is true, and it is not enough. The preimage of a proper subspace is an *open*
subgroup, so it is not nowhere dense and no countable-union or Baire argument applies to the union
over the $d$ in the class. Worse, the union really can be everything: $W_delta$ is 2-dimensional,
so it is the union of its $ell + 1$ lines, and as few as $ell + 1$ twists with distinct $R_d$
already fill the local class.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  The repair is combinatorial, not topological. Both $P$ and $Q$ land in the *same* $R_d$, and any
  two elements of a subspace of dimension $<= 1$ are $bb(F)_ell$-multiples of one another. That is
  a condition on the *pair* which does not depend on which line $R_d$ is, so it is uniform over the
  twists --- and in the 2-dimensional non-degenerate case it is exactly $beta_p (P,Q) = 0$. An
  earlier version of this section argued the passage to $X$ by Baire; that argument was wrong, and
  the lemma above replaces it.
]

*The class must still be covered.* The lemma needs the vanishing for *every* $d$ in the class. If a
theorem covers only *some* of them --- carrying a side condition $C$ on $d$ --- the remaining
twists are unconstrained and may fill the local class up, and nothing about the surface follows. So
a theorem of the shape "for $d$ in the class *and* satisfying $C$" supports a statement about $X$
only when $C$ is vacuous on the class. All the theorems of @sec-nonCM clear this bar --- but
@sec-11a1 and @sec-14a1 only after their conditions at $v = ell$ were removed, which took
@sec-tk-ordinary and the collapse mechanism respectively. The bar is easy to miss.

== Where each tool was used <sec-tk-checklist>

#align(center, table(
  columns: 5, align: (left, left, left, left, left),
  stroke: 0.4pt + luma(170), inset: (x: 6pt, y: 3.5pt),
  table.header([case], [$ell$], [critical $p$], [wild place $v = ell$], [other places]),
  [$x^3 + x$ (@sec-thm2)], [2], [2 --- also the wild place], [---],
    [indecomposable; @sec-tk-lemAB; norm lemma],
  [$x^3 - 2$ (§5.1.5)], [3], [3 --- also the wild place],
    [$beta_3 equiv.not 0$ needed, and proved], [structural],
  [`15a1` (@sec-15a1)], [2], [tame; $c_1$ onto], [$v = 2$: 8 square classes],
    [$v = 3$: 4 classes; $q divides d$: Lemma C],
  [`14a1` (@sec-14a1)], [3], [tame; descent image, 1 class],
    [good ordinary, and collapse], [structural],
  [`15a4` (@sec-15a4)], [2], [tame; $c$ onto, 1 class], [$v = 2$: 8 square classes],
    [indecomposable; @sec-tk-lemAB; norm lemma],
  [`17a1` (@sec-17a1)], [2], [tame; $c$ onto, 1 class], [$v = 2$: 8 square classes],
    [indecomposable; @sec-tk-lemAB; norm lemma],
  [`11a1` (@sec-11a1)], [5], [Tate curve, non-degenerate], [@sec-tk-ordinary], [structural],
  [`14a2`, `19a1` (@sec-1419)], [3], [tame; descent image, 1 class],
    [good ordinary *and* collapse], [structural; $v = 2$ for `14a2`],
))

#v(2mm)

The pattern in the fourth column is the one to carry forward to `14a2`, `19a1` and `17a1`: when
$ell$ is an *auxiliary* place the wild contribution has so far always turned out to be trivial, by
one of the two mechanisms of @sec-tk-wild; when $ell$ is the *critical* place, as for $x^3 - 2$ and
$x^3 + x$, it must not be, and that is the whole content of the argument.

Every row of the table has *one* critical place: that is what makes reciprocity conclude
$beta_p = 0$. @sec-twoplace asks what the same tools give when two places survive, and shows that
the two structural lemmas of this chapter --- @sec-alt for the alternating property and
@sec-tk-lemAB for $q divides d$ --- cut the level-2 family down to the Pythagorean triples, where
the surviving places can be read off the hypotenuse. @sec-depends then asks which places can be
critical *at all*, and answers it from the reduction data of $E$ alone; several lemmas of this
chapter turn out to be special cases, @sec-tk-ordinary among them.

= Twisted pairings at non-CM surfaces <sec-nonCM>

@sec-ledger-odd found that all seven open classes of @sec-fail carry the pairing
signature --- reaches isotropic, every line occurring, none preferred. This
section constructs the pairing in all seven, at *non-CM* surfaces, which
settles that the mechanism is not about complex multiplication. They run at
three different levels --- $ell = 2$ in @sec-15a1 and @sec-15a4, $ell = 3$ in
@sec-14a1, $ell = 5$ in @sec-11a1 --- and the level-3 case reaches the cubic
symbols §5.1.5 could not evaluate. @sec-magma then closes the one local input
§5.1.5 itself left open, and @sec-triage asks what the module structure permits
in the three classes still untouched.

The technique is collected in @sec-toolkit, and this section is where it is applied; the
conventions for the *values* of $beta$ are fixed there too.

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

*The places $2$, $3$ and $q divides d$.* Here $beta_q$ is trivial on the *local* group, which is
stronger than triviality on rational pairs. An earlier version of this section had this over 640
places drawn from 202 twists and called it verified rather than proved. It splits into a finite
part and a lemma.

*$v = 2$ and $v = 3$: finite.* $E_d$ over $QQ_v$ depends on $d$ only through its class in
$QQ_v^times slash (QQ_v^times)^2$ --- eight classes at 2, four at 3 --- and the class of $d$ at 5
constrains neither. `localimg.gp` runs all twelve, checking in each case that the sampled points
*generate* the relevant finite quotient of $E_d (QQ_v)$ and then evaluating every Hilbert symbol
between the image of $c_1$ and the image of $c_3$. Every one is trivial. The same runs settle the
critical place: at $v = 5$ the image of $c_1$ is all four classes of $QQ_5^times$ modulo squares,
so $beta_5$ is non-trivial there, and only the class $[1]$ of $QQ_5^times$ occurs.

*$q divides d$, $q != 2, 3, 5$: a lemma.* Here $q$ ranges over infinitely many primes and no finite
check reaches it. What settles it is, once again, that the root differences are squares.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Lemma C.* Let $q$ be a prime not dividing $2 dot 3 dot 5 dot 17$, let $d$ be squarefree with
  $q divides d$, and write $d = q d'$. Then, modulo squares in $QQ_q^times$,
  $ c_1 (E_d (QQ_q)) subset.eq {1, space -q d'}, quad quad
    c_3 (E_d (QQ_q)) subset.eq {1, space q d'} , $
  and consequently $beta_q equiv 1$ on $E_d (QQ_q)$.

  #v(2mm)
  _Proof._ $q$ divides none of the root differences $e_1 - e_2 = 16$, $e_1 - e_3 = 25$,
  $e_2 - e_3 = 9$, none of the roots, and $v_q (d) = 1$. Let $P in E_d (QQ_q)$, $x = x(P)$,
  $k = v_q (x)$.

  #v(1.5mm)
  *(i) $k <= 0$.* Then $x - d e_i = x(1 - d e_i slash x)$ with
  $v_q (d e_i slash x) >= 1 - k >= 1$, so the second factor is a 1-unit and hence a square at an
  odd place: $c_i equiv x$ for all three $i$. As $c_1 c_2 c_3 = y^2$, $x^3$ is a square, so $x$ is,
  so all three $c_i$ are trivial.

  #v(1.5mm)
  *(ii) $k = 1$.* Write $x = q x'$ and $lambda_i = x' - d' e_i$, so $c_i = q lambda_i$ and
  $y^2 = q^3 lambda_1 lambda_2 lambda_3$. The differences
  $lambda_i - lambda_j = d'(e_j - e_i)$ are units, so at most one $lambda_i$ is a non-unit, and
  $v_q (y^2)$ being even forces exactly one, say $lambda_(i_0)$, of odd valuation. Then
  $x' equiv d' e_(i_0)$ modulo $q$, so for $i != i_0$ the unit $lambda_i equiv d'(e_(i_0) - e_i)$
  --- and $16, 25, 9$ being squares, its class is that of $d'$ up to the sign of the root
  difference. With $c_(i_0) equiv product_(i != i_0) c_i$:
  #v(1mm)
  #align(center, table(
    columns: 4, align: (center, center, center, center),
    stroke: 0.4pt + luma(170), inset: (x: 8pt, y: 3pt),
    table.header([$i_0$], [$c_1$], [$c_2$], [$c_3$]),
    [1], [$1$], [$q d'$], [$q d'$],
    [2], [$-q d'$], [$-1$], [$q d'$],
    [3], [$-q d'$], [$-q d'$], [$1$],
  ))

  #v(1.5mm)
  *(iii) $k >= 2$.* Then $x - d e_i = -d e_i (1 - x slash (d e_i))$ with the second factor a
  1-unit, so $c_i equiv -d e_i$ and
  $y^2 = product c_i equiv -d^3 e_1 e_2 e_3 = 136 d^3 equiv 136 d$. Since
  $q divides.not 136 = 8 dot 17$, that has odd valuation and is not a square: *no such $P$
  exists*.

  #v(1.5mm)
  So $c_1 in {1, -q d'}$ and $c_3 in {1, q d'}$. The four resulting symbols are $(1,1)$,
  $(1, q d')$, $(-q d', 1)$ and $(-q d', q d')$; the first three are trivial because an entry is a
  square, and the last is trivial by the Steinberg relation $(a, -a)_q = 1$ with $a = q d'$, the
  quadratic Hilbert symbol being symmetric. $qed$
]

*The prime 17 is left over*, because $17 = e_1$ makes case (iii) of the proof non-vacuous. It is
finite: $17 divides d$ forces $v_17 (d)$ odd, so only *two* classes of $QQ_17^times$ occur, and
`localimg.gp` runs both --- the conclusion of Lemma C holds there as well. (Case (iii) at $q = 17$
forces $2 d'$, hence $d'$, to be a square modulo 17, and then $c_1 equiv -d' equiv 1$ since
$17 equiv 1$ modulo 4, and $c_3 equiv 8 dot 17 d' equiv q d'$.)

`localimg.gp` also confirms Lemma C's prediction directly at fifteen pairs $(q, d)$, matching the
predicted images exactly and giving no non-trivial symbol.

=== The theorem <sec-15a1-thm>

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Theorem.* For
  $f = (x-17)(x-1)(x+8)$ and every squarefree $d$ in the class $[1]$ of
  $QQ_5^times$, the pairing $beta_5$ vanishes on $E_d (QQ) times E_d (QQ)$. Hence
  $E_d (QQ)$ is not dense in $E_d (QQ_5)$, and --- by @sec-class-warning ---
  $X(QQ)$ is not dense in $X(QQ_5)$.

  #v(2mm)
  _Proof._ $beta_v (P,Q) = (c_1 (P), c_3 (Q))_v$ is $+1$ at $v = infinity$, at
  every $q in.not {2,3,5}$ prime to $d$, and --- by @sec-15a1-local --- at
  $2$, $3$ and each $q divides d$. Hilbert reciprocity
  $product_v (c_1 (P), c_3 (Q))_v = 1$ then forces $beta_5 (P,Q) = 1$ for all
  $P, Q in E_d (QQ)$. So the image of $E_d (QQ)$ in $W_5$ is isotropic for
  $beta_5$, which is a non-trivial alternating form on the 2-dimensional $W_5$;
  the image therefore has dimension $<= 1$ and is not all of $W_5$. As
  $W_5 = E_delta (QQ_5) slash 2$ is the Frattini quotient, $E_d (QQ)$ is not
  dense. The vanishing holds for every $d$ in the class, so @sec-class-warning carries it to
  $X$. $qed$
]

Three remarks.

*Nothing is left to a sample.* Every local step of this section is either proved (Lemma C, the
alternating property, the places prime to $2 dot 3 dot 5 dot d$) or settled over a complete set of
square classes with a generation check (@sec-15a1-local).

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

The image of $(c_1, c_2)$ on $W_7$ has *9 elements*, and $c_2$ is determined by $c_1$: the pair
runs over the *antidiagonal* $c_2 = c_1^(-1)$ of
$(QQ_7^times slash (QQ_7^times)^3)^2$. So $c_1$ alone identifies $W_7$ with
$QQ_7^times slash (QQ_7^times)^3$, and
$ beta_7 (P,Q) = -⟨c_2 (P), c_1 (Q)⟩_7 = ⟨c_1 (P), c_1 (Q)⟩_7 . $

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  Diagonal or antidiagonal is a *choice*, not a fact: the two generators of $C_2$ give tangents
  whose values are inverse to one another, so replacing $T_2$ by $-T_2$ swaps the two descriptions
  and flips the sign in the display above. Neither the non-degeneracy nor the alternating property
  is affected, so the theorem is untouched; an earlier version of this section wrote "diagonal" and
  carried the other sign.

  #v(1.5mm)
  What *is* a fact, and what an earlier version of this section obtained only by sampling, is that
  the image has exactly 9 elements. `localimg.gp` makes it exhaustive: the sampled points of
  $E_d (QQ_7)$ are shown to generate $E_d (QQ_7) slash E_1$ --- *18 of 18* --- and $3E$ contains
  $E_1$ at $v = 7$, since $E_1$ is pro-7 and hence uniquely 3-divisible, so they generate $W_7$;
  the $c_i$ are homomorphisms, so their image on a generating set is the whole image. And the class
  of a value in $QQ_7^times slash (QQ_7^times)^3$ is read off from $v_7$ modulo 3 together with the
  unit *modulo 7*, since $1 + 7 ZZ_7$ consists of cubes. Nothing is sampled and no precision is
  lost. One $d$ suffices, $E_d$ over $QQ_7$ depending only on the class of $d$ modulo squares;
  $d = 1, 2, 4, 8, 11, 22$ all agree.
]

The symbol table on the nine classes $7^a u$, $a = 0,1,2$, $u = 1, 3, 2$:

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

The third row is @sec-tk-ordinary. $d$ a square in $QQ_3$ forces $3 divides.not d$, so
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
  further condition. Then $beta_7$ vanishes on $E_d (QQ) times E_d (QQ)$, so $E_d (QQ)$ is not
  dense in $E_d (QQ_7)$. Since the vanishing holds for every $d$ in the class, @sec-class-warning
  gives that $X(QQ)$ is not dense in $X(QQ_7)$ for $X : y^2 = f(x) f(t)$,
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
  quotient at the layer, and $E_d (QQ)$ is not dense. The vanishing holds for every $d$ in the
  class, so @sec-class-warning carries it to $X$. $qed$
]

Two things distinguish this from @sec-15a1.

*Nothing here is left to a sample.* At level 2 the alternating property had to be
proved by hand (`x^3 + x`).
Here decomposability hands over the alternating property, and the places then
fall out of a single fact --- $-3$ is a square in $QQ_7$ and in neither $QQ_2$
nor $QQ_3$. Three things are computed rather than argued, and each is *exhaustive*: the symbol
table at 7 (all 81 pairs of a 9-element group, by the explicit tame formula); the image of the
descent maps at 7 (@sec-14a1-seven); and the $phi_*$-stability at 3 (@sec-14a1-places). The last
two are exhaustive because the sampled points are shown to generate the relevant quotient and the
maps are homomorphisms, and because $E_d$ over $QQ_v$ depends only on the class of $d$ modulo
squares --- one class at 7, four at 3.

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
  [`15a1` (@sec-15a1)], [2], [5], [split over $QQ$], [complete],
  [`14a1` (@sec-14a1)], [3], [7 --- *tame*], [decomposable], [complete],
  [`14a2`, `19a1` (@sec-1419)], [3], [7, 19 --- *tame*], [decomposable], [complete],
  [`17a1` (@sec-17a1)], [2], [17 --- *tame*], [*indecomposable*], [complete],
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

- *$q = 2$.* Here the 1-unit argument fails and the image has to be computed. Since $beta$ is
  alternating (Lemma 2), it is enough that the image be of order at most 2. It is, and the check is
  *exhaustive*: $E_d$ over $QQ_2$ depends on $d$ only through its class in
  $QQ_2^times slash (QQ_2^times)^2$, and the class at 5 constrains that not at all, so all
  *eight* classes are needed --- and all eight give an image of order 1 or 2, namely one of
  ${1}$, ${1,2}$, ${1,5}$, ${1,10}$. (`localimg.gp`; the earlier pass over 202 twists reported only
  three of those four, having missed the class of $d = 2$.) So $beta_2 equiv 1$, and this is no
  longer a step taken on trust.

- *$q = 5$.* The image of $c$ on $E_delta (QQ_5)$ is *all four* classes
  ${1, u, 5, 5u}$, so the symbol is non-degenerate; and it is
  alternating because $5 equiv 1$ $(mod 4)$ makes $-1$ a square in $QQ_5$. So
  $beta_5$ is symplectic on the 2-dimensional $W_5$. Only the failing class $[1]$ of $QQ_5^times$
  occurs here, and $E_d$ over $QQ_5$ depends only on that, so one $d$ settles it.

#table(
  columns: 4, align: (left, center, center, left),
  stroke: 0.4pt + luma(170), inset: (x: 7pt, y: 3pt),
  table.header([place], [what settles it], [exhaustive?], []),
  [$q = 5$ (critical)], [1 square class of $QQ_5^times$], [yes],
    [image of $c$ is all four classes: symplectic on $W_5$],
  [$q = 2$], [8 square classes of $QQ_2^times$], [yes],
    [image of $c$ has order $<= 2$, so $beta_2 equiv 1$],
  [$q$ odd, $q divides d$], [Lemmas A, B], [proved], [image of $c$ is cyclic],
)

=== The theorem <sec-15a4-thm>

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Theorem.* For
  $f = x(x^2 + 14x + 625)$ --- that is, `15a4` --- and every squarefree $d$ in
  the class $[1]$ of $QQ_5^times$, the pairing $beta_5$ vanishes on
  $E_d (QQ) times E_d (QQ)$. Hence $E_d (QQ)$ is not dense in $E_d (QQ_5)$, and --- by
  @sec-class-warning --- $X(QQ)$ is not dense in $X(QQ_5)$.

  #v(2mm)
  _Proof._ $beta_v (P,Q) = (c(P), c(Q))_v$ is $+1$ at $v = infinity$, at every
  $q divides.not 2 dot 5 dot d$, at every odd $q divides d$, and at $q = 2$. Hilbert reciprocity
  then forces
  $beta_5 (P,Q) = +1$ for all $P, Q in E_d (QQ)$. On $W_5$, $beta_5$ is a
  non-trivial alternating form on a 2-dimensional $bb(F)_2$-space, hence symplectic,
  so the image of $E_d (QQ)$ is isotropic and of dimension $<= 1$. It is
  therefore not all of $W_5 = E_delta (QQ_5) slash 2$, and $E_d (QQ)$ is not
  dense. The vanishing holds for every $d$ in the class, so @sec-class-warning carries it to
  $X$. $qed$
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

That is exactly the hypothesis of @sec-tk-ordinary, which therefore gives $beta_5 equiv 0$
outright: the closure of $C_1$ is étale and that of $C_2$ is connected, ordinarity makes them the
two ends of the connected--étale sequence, $E[5]$ splits as finite flat group schemes, and the
Kummer image --- being the flat subgroup $H^1_f$, which is functorial --- splits with it.

`vell.gp` checks the conclusion directly, without the lemma, in the form Steps 4 and 5 of §5.1.5
give it: $L_ell$ is $phi_*$-stable iff *both* $ker alpha_1$ and $ker alpha_2$ are non-zero, i.e.
iff each dual isogeny image escapes $ell E(QQ_ell)$. That is decidable because
$ell E supset.eq ell E_1 = E_2$, so $ell E$ is a union of $E_2$-cosets. For `11a1` at 5, with
$dim W_5 = 2$: *2576 of 2704* sampled points of $B_1 (QQ_5)$ and *109 of 2511* of $B_2 (QQ_5)$ have
dual image outside $5 E(QQ_5)$. Both kernels non-zero, so $beta_5 = 0$.

=== The theorem <sec-11a1-thm>

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Theorem.* Let $d$ be squarefree and a square in $QQ_11^times$ --- that is, *any* $d$ in the
  class $[1]$, with no further condition. Then $beta_11$ vanishes on
  $E_0^((d))(QQ) times E_0^((d))(QQ)$, so $E_0^((d))(QQ)$ is not dense in $E_0^((d))(QQ_11)$.
  Since the vanishing holds for *every* $d$ in the class, @sec-class-warning gives that $X(QQ)$ is
  not dense in $X(QQ_11)$ for the surface `11a1`.

  #v(2mm)
  _Proof._ $beta$ is alternating at every place, so $beta_v = 0$ wherever
  $dim W_v <= 1$; that is every $v != 5, 11$ by the table, and $v = 5$ as well by
  @sec-11a1-five. Reciprocity
  $sum_v "inv"_v beta_v = 0$ gives $beta_11 (P,Q) = 0$ for all
  $P, Q in E_0^((d))(QQ)$. But $beta_11$ is non-degenerate on the 2-dimensional
  $W_11$, so the image of the rational points is a proper subspace, of dimension
  $<= 1$. It is therefore not all of $W_11 = E_delta (QQ_11) slash 5$, and the
  rational points are not dense. The vanishing holds for every $d$ in the class, so
  @sec-class-warning carries it to $X$. $qed$
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

== `14a2` and `19a1`: the template, twice more <sec-1419>

@sec-triage predicted that these two would follow @sec-14a1, and they do --- closely enough that
they are best treated together. Both are level 3 with $E[ell]$ decomposable, both have
$p equiv 1$ modulo 3 so the critical symbol is tame, and at the wild place both exhibit *both*
mechanisms of @sec-tk-wild, one in each of two square classes. `template3.gp` carries out the
computations.

=== The two curves <sec-1419-curves>

#align(center, table(
  columns: 5, align: (left, left, center, left, left),
  stroke: 0.4pt + luma(170), inset: (x: 7pt, y: 3.5pt),
  table.header([surface], [$f$], [$p$], [$E_0$], [relation to $y^2 = f(x)$]),
  [`14a2`], [$x^3 - 11x^2 - 528x - 2240$], [7], [`14a2` $= [1,0,1,-36,-70]$, $N = 14$,
    torsion $ZZ slash 6$], [equal --- no twist],
  [`19a1`], [$x^3 - 10x^2 - 4x - 6$], [19], [`19a1` $= [0,1,1,-9,-15]$, $N = 19$,
    torsion $ZZ slash 3$], [$y^2 = f(x)$ is $E_0^((2))$, of conductor $2^6 dot 19$],
))

#v(2mm)

The second row is the caveat of @sec-triage-data in action: the reduced cubic is a model of the
*surface*, and here it twists the curve. Reindex by $E_0$: $E_d = E_0^((d'))$ with $d'$ the
squarefree part of $2d$. Since $2$ is a *non-residue* modulo 19, the surface's failing class $[u]$
of $QQ_19^times$ becomes the class $[1]$ for the parameter $d'$. For `14a2` no reindexing is
needed. In both cases $C_1$ is generated by a $QQ$-rational point of order 3, which is what
@sec-tk-ramtwist needs.

=== The critical place <sec-1419-crit>

Both lines of $E[3]$ are rational over $QQ_p$ --- $7 equiv 19 equiv 1$ modulo 3, so
$mu_3 subset QQ_p$ --- giving $dim W_p = 2$. The image of $(c_1, c_2)$ on $W_p$ is computed as the
*subgroup generated* by the values on a set of points shown to generate $E_d (QQ_p) slash E_1$:

#align(center, table(
  columns: 5, align: (left, center, center, center, left),
  stroke: 0.4pt + luma(170), inset: (x: 7pt, y: 3.5pt),
  table.header([surface], [$p$], [$M_p$], [generated], [image of $(c_1, c_2)$]),
  [`14a2`], [7], [36], [36 of 36], [9 elements, the diagonal],
  [`19a1`], [19], [54], [54 of 54], [9 elements, diagonal or antidiagonal],
))

#v(2mm)

Nine elements means $c_2$ is determined by $c_1$, so $c_1$ alone identifies $W_p$ with
$QQ_p^times$ modulo cubes and $beta_p$ is $plus.minus$ the tame cubic symbol there. Whether the
image is the diagonal or the antidiagonal depends on which generator of each line the square root
picks, exactly as in @sec-14a1-seven; only the sign of $beta_p$ is affected. Written additively,
that symbol on classes $[alpha, j]$ --- valuation modulo 3, cubic character of the unit --- is
$ (a, b)_p = j_a beta - j_b alpha space in ZZ slash 3 , $
since $p equiv 1$ modulo 6 makes $(p-1) slash 3$ even and the sign $(-1)^(alpha beta)$ drop out.
That is the standard symplectic form: *48 of 81* values non-zero and the whole diagonal zero, at
$p = 7$ and at $p = 19$ alike. So $beta_p$ is symplectic on the 2-dimensional $W_p$ and its
isotropic subspaces have dimension $<= 1$.

=== The wild place, all four classes <sec-1419-wild>

$E_d$ over $QQ_3$ depends only on the class of $d$ in $QQ_3^times$ modulo squares, so four
computations settle every twist. Both curves give the same table, and it is the `14a1` table of
@sec-14a1-places:

#align(center, table(
  columns: 5, align: (left, center, left, left, center),
  stroke: 0.4pt + luma(170), inset: (x: 7pt, y: 3.5pt),
  table.header([class of $d$], [$dim W_3$], [reduction at 3], [why $L_3$ is $phi_*$-stable],
               [$beta_3$]),
  [$[u]$, $[3]$], [1], [good / additive $"I"_0^*$], [nothing to check], [trivial],
  [$[1]$], [2], [good, *ordinary*], [@sec-tk-ordinary], [trivial],
  [$[3u]$], [2], [additive $"I"_0^*$], [$dim ker alpha = 2$: $L_3$ lies inside one $H_i$],
    [trivial],
))

#v(2mm)

The ordinarity is real: $a_3 = -2$ for `14a2` and for `19a1`, both prime to 3. In the last row the
image of the descent map attached to the $QQ_3$-rational line is *trivial* --- one class, on a set
of points generating $E_d (QQ_3) slash E_2$ (18 of 18) --- so $ker alpha$ is all of $W_3$ and
$L_3$ sits inside a single $H_i$. In the third row the same computation returns three classes,
$dim ker alpha = 1$, and @sec-tk-ordinary supplies the other kernel.

=== The remaining places, and the theorems <sec-1419-thm>

Everything else is @sec-tk-places. $W_infinity = 0$; good $v != 3$ dies by unramified isotropy;
$q divides d'$ dies by @sec-tk-ramtwist, whose hypotheses hold because $ell = 3$ is odd and $C_1$
comes from a rational point. The only bad prime of $E_0$ other than $p$ is $2$, for `14a2` alone,
and there $mu_3 subset.not QQ_2$ forces $dim W_2 <= 1$. For `19a1` the conductor is $19$, so there
is no such place at all: every bad prime of $E_d$ other than 19 divides $d'$.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Theorem.* Let $X : y^2 = f(x) f(t)$.

  #v(1.5mm)
  (a) For $f = x^3 - 11x^2 - 528x - 2240$ (`14a2`) and *every* squarefree $d$ in the class $[1]$ of
  $QQ_7^times$, the pairing $beta_7$ vanishes on $E_d (QQ) times E_d (QQ)$; hence $E_d (QQ)$ is not
  dense in $E_d (QQ_7)$, and $X(QQ)$ is not dense in $X(QQ_7)$.

  #v(1.5mm)
  (b) For $f = x^3 - 10x^2 - 4x - 6$ (`19a1`) and *every* squarefree $d$ in the class $[u]$ of
  $QQ_19^times$, the pairing $beta_19$ vanishes on $E_d (QQ) times E_d (QQ)$; hence $E_d (QQ)$ is
  not dense in $E_d (QQ_19)$, and $X(QQ)$ is not dense in $X(QQ_19)$.

  #v(2mm)
  _Proof._ $beta$ is alternating at every place, $E[3]$ being decomposable and 2 invertible modulo
  3. By @sec-1419-wild and the paragraph above, $beta_v$ is trivial at every $v != p$. Reciprocity
  $sum_v beta_v = 0$ then forces $beta_p (P,Q) = 0$ for all $P, Q in E_d (QQ)$. On $W_p$, $beta_p$
  is the tame cubic symbol transported by $c_1$, symplectic by @sec-1419-crit, so the image of
  $E_d (QQ)$ is isotropic and of dimension $<= 1$: not all of $W_p = E_delta (QQ_p) slash 3$. By
  topological Nakayama $E_d (QQ)$ is not dense; and since $beta_p$ vanishes on rational pairs for
  *every* $d$ in the class --- the hypothesis being vacuous on it --- @sec-class-warning gives the
  statement about $X$. $qed$
]

With these, *seven* of the eight classes of @sec-fail are settled --- the eighth having been
proved non-dense outright --- and only `17a1` at $p = 17$ is left. It is the one remaining case at
$ell = 2$ with $E[2]$ indecomposable, so it belongs to the $x^3 + x$ template rather than this one;
@sec-triage-templates records what is expected there.

== `17a1` at $p = 17$: the last class <sec-17a1>

The eighth and last class of @sec-fail, and the only one at $ell = 2$ with $E[2]$ indecomposable.
It is the shortest of the six, because it turns out to have exactly the shape of @sec-15a4.

=== The surface <sec-17a1-surface>

$f = x^3 - 6x^2 + x - 876 = (x - 12)(x^2 + 6x + 73)$, and $y^2 = f(x)$ *is* `17a1`: conductor 17,
torsion $ZZ slash 4$, rank 0, so no reindexing is needed. Shifting by the rational root --- with
$c = 1$, so the same surface by @sec-which ---
$ f(x + 12) = x (x^2 + 30 x + 289), quad quad 289 = 17^2 . $
Two features of that quadratic do all the work:

#align(center, table(
  columns: 2, align: (left, left),
  stroke: 0.4pt + luma(170), inset: (x: 8pt, y: 3.5pt),
  table.header([feature], [what it gives]),
  [$x^2 + 30x + 289 = (x + 15)^2 + 8^2$, a *sum of two squares*],
    [$a^2 - 4b = -256 equiv -1$, so the 2-torsion field is $QQ(i)$, so $c(P)$ is a norm from
     $QQ(i)$ and $beta$ is *alternating* at every place (Lemma 2 of @sec-alt)],
  [$b = 289 = 17^2$ is a *perfect square*],
    [@sec-tk-lemAB applies at every odd $q divides d$],
))

#v(2mm)

$E[2]$ has the unique stable line $C = ⟨T⟩$, $T = (0,0)$, so @sec-tk-indec applies: the twisting
endomorphism is the nilpotent $N$ and is essentially unique, $c(P) = x(P)$ modulo squares, and
$ beta_v (P, Q) = (c(P), space c(Q))_v , $
with triviality at $v$ meaning that the image of $c$ is *isotropic* there.

=== The places <sec-17a1-places>

- *$v = infinity$.* The quadratic is a sum of two squares, hence positive, so $y^2 = x dot (>0)$
  forces $x >= 0$ on real points and the symbol is $+1$.

- *$q divides.not 2 dot 17 dot d$.* With $x = a slash e^2$, $y = b slash e^3$ and
  $b^2 = a(a^2 + 30 d a e^2 + 289 d^2 e^4)$, a common prime factor of the two divides
  $289 d^2 e^4$, hence $289 d^2$. So for such $q$ the factors are coprime, $v_q (c(P))$ is even,
  both arguments are units and the symbol is $+1$. The bad places are therefore only $2$, $17$ and
  the divisors of $d$ --- as for @sec-15a4, and again with no analogue of the extra $3$ that
  @sec-places2 had to handle.

- *$q$ odd, $q divides d$.* @sec-tk-lemAB: $b = 289$ is a perfect square and its only prime is
  $17$, which cannot divide $d$ because the failing class asks $d$ to be a square in
  $QQ_17^times$. So the image of $c$ has order at most 2, and $beta$ being alternating, $beta_q$ is
  trivial.

- *$q = 2$, the wild place.* Here the 1-unit argument fails and the image has to be computed. It
  has order at most 2 in *all eight* square classes of $QQ_2^times$ --- the class of $d$ at 2 being
  unconstrained by its class at 17 --- with the sampled points shown to generate
  $E_d (QQ_2) slash E_3$ each time. So $beta_2$ is trivial. (`localimg.gp`; the images are ${1}$,
  ${1,2}$, ${1,5}$, ${1,10}$, exactly the four that occur for `15a4`.)

- *$q = 17$, the critical place.* The image of $c$ on $E_delta (QQ_17)$ is *all four* classes of
  $QQ_17^times$ modulo squares, so the symbol is non-degenerate; and it is alternating because
  $17 equiv 1$ $(mod 4)$ makes $-1$ a square in $QQ_17$. So $beta_17$ is symplectic on the
  2-dimensional $W_17$. Only the failing class $[1]$ of $QQ_17^times$ occurs, so one $d$ settles
  it; $d = 1, 2, 13, 15, 19$ all agree, each generating $E_d (QQ_17) slash E_1$ --- $64$ of $64$,
  the reduction at 17 being split multiplicative of type $"I"_4$ with $c_17 = 4$.

=== The theorem <sec-17a1-thm>

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Theorem.* For $f = x(x^2 + 30x + 289)$ --- that is, `17a1` --- and *every* squarefree $d$ in the
  class $[1]$ of $QQ_17^times$, the pairing $beta_17$ vanishes on $E_d (QQ) times E_d (QQ)$; hence
  $E_d (QQ)$ is not dense in $E_d (QQ_17)$, and $X(QQ)$ is not dense in $X(QQ_17)$.

  #v(2mm)
  _Proof._ $beta_v (P,Q) = (c(P), c(Q))_v$ is $+1$ at $v = infinity$, at every
  $q divides.not 2 dot 17 dot d$, at every odd $q divides d$, and at $q = 2$, by
  @sec-17a1-places. Hilbert reciprocity then forces $beta_17 (P,Q) = +1$ for all
  $P, Q in E_d (QQ)$. On $W_17$, $beta_17$ is a non-trivial alternating form on a 2-dimensional
  $bb(F)_2$-space, hence symplectic, so the image of $E_d (QQ)$ is isotropic and of dimension
  $<= 1$: not all of $W_17 = E_delta (QQ_17) slash 2$. Topological Nakayama gives non-density; and
  since $beta_17$ vanishes on rational pairs for *every* $d$ in the class --- the hypothesis being
  vacuous on it --- @sec-class-warning gives the statement about $X$.
  $qed$
]

*All eight classes of @sec-fail are now settled* --- seven by a twisted pairing and one by the
direct non-density proof that put it on the list. The four surfaces at $ell = 2$ split two ways:
`15a1`, where $f$ splits over $QQ$ and three stable lines force a search among nine candidate
$phi$ (@sec-15a1-choose); and $x^3 + x$, `15a4`, `17a1`, all indecomposable, all with $q$ a sum of
two squares and $b$ a perfect square, and all following @sec-thm2 with nothing to choose.

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

== The triage, in hindsight <sec-triage>

This section was written when three classes were left --- `14a2`, `19a1` and `17a1`. All three have
since been done, the first two in @sec-1419 and the last in @sec-17a1, so it is now a record of what
could be predicted before any of them was attempted. The question it asks is whether the mechanism
is even *available*, and that is not automatic: $beta_v (P,Q) = ⟨delta_v P, phi delta_v Q⟩_v$
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
  [`14a2` $[1]$ #super[✓]], [7],  [3],  [14], [6], [2], [1], [decomposable],
  [`19a1` $[u]$ #super[✓]], [19], [3],  [19], [3], [2], [1], [decomposable],
  [`15a4` $[1]$ #super[✓]], [5],  [2],  [15], [8], [1], [1], [indecomposable],
  [`17a1` $[1]$ #super[✓]], [17], [2],  [17], [4], [1], [1], [indecomposable],
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

*The `14a1` template --- $ell$ odd, $E[ell]$ decomposable (@sec-14a1). No open cases left:
`11a1` was carried out in @sec-11a1 and `14a2`, `19a1` in @sec-1419.* Here $beta$ is alternating at every place for free --- §5.1.5's
argument needs only decomposability and $2$ invertible mod $ell$ --- so the whole
analysis reduces to $dim W_v$, and by the triage the only place left is the wild
$v = ell$. All of them came out with $beta_ell = 0$ there, by the two mechanisms of @sec-tk-wild:
@sec-tk-ordinary when $dim W_ell = 2$ forces good ordinary reduction at $ell$, and collapse ---
$L_ell$ inside a single $H_i$ --- when it does not. `14a2` and `19a1` exhibit *both*, one in each
of two square classes, exactly as `14a1` does; see @sec-1419-wild. Since $E_d$ over $QQ_ell$
depends only on the class of $d$ modulo squares, four local computations settle a whole family, and
@sec-class-warning is why it matters that they cover all four. The worry
that `11a1` would need a *quintic* residue symbol turned out to be unfounded --- see @sec-11a1.

*The $x^3 + x$ template --- $ell = 2$, $E[2]$ indecomposable (@sec-thm2). No open cases left:
`15a4` was carried out in @sec-15a4 and `17a1` in @sec-17a1.*
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

= Two live places <sec-twoplace>

Every theorem of @sec-nonCM works the same way: arrange for $beta_v$ to be trivial at all places
but one, so that reciprocity pins the survivor to zero on rational pairs. This chapter asks what
happens when *two* places survive. The answer is that reciprocity still says something --- but
something of a different kind, a *correlation* between the two places rather than a constraint at
either --- and that the phenomenon does occur, though not at any surface small enough to have been
surveyed in @sec-result.

== What reciprocity still gives <sec-tp-crit>

Suppose $beta_v$ is trivial for every $v in.not {p, q}$, on the local groups, for every $d$ in a
fixed pair of square classes --- one at $p$, one at $q$. Reciprocity then reads
$ beta_p (P, Q) + beta_q (P, Q) = 0 quad "for all" P, Q in E_d (QQ), $
which is *not* $beta_p = 0$. Writing $R subset.eq W_p xor W_q$ for the image of $E_d (QQ)$, it says
exactly that $R$ is *isotropic* for
$ gamma := beta_p xor beta_q quad "on" W_p xor W_q . $

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Criterion.* If $gamma != 0$ then $R$ is a *proper* subgroup of $W_p xor W_q$, and $E_d (QQ)$ is
  not dense in $E_d (QQ_p) times E_d (QQ_q)$. If moreover $beta_p$ and $beta_q$ are both
  non-degenerate and alternating on 2-dimensional spaces, $gamma$ is symplectic on a
  *4-dimensional* space and $dim R <= 2$.
]

The passage to the surface is @sec-class-warning, read on the product, and it is the *isotropy*
that transfers, not the properness of $R$. A rational point of $X$ over the pair of classes is a
pair $(P,Q)$ of points of $E_d (QQ)$ for a single global $d$; its images in $X(QQ_p)$ and
$X(QQ_q)$ are $(P_p, Q_p)$ and $(P_q, Q_q)$, and isotropy says
$ beta_p (P_p, Q_p) + beta_q (P_q, Q_q) = 0 . $
That is a condition on a point of the *product*, it factors through the finite discrete
$(W_p times W_p) times (W_q times W_q)$, and it is *proper* as soon as one of $beta_p$, $beta_q$
is non-zero. So the rational points miss a non-empty open subset of $X(QQ_p) times X(QQ_q)$,
whatever the $R_d$ do individually. As in @sec-class-warning, the properness of $R$ by itself would
*not* do: the union over the countably many $d$ of the open subgroups it cuts out can be all of
$W_p xor W_q$.

If the Azumaya algebra of @sec-brauer is available the argument is shorter and needs no
decomposition by twist at all: $"inv"_v cal(A)$ is locally constant on $X(QQ_v)$, so
$ {(T_p, T_q) : "inv"_p cal(A)(T_p) + "inv"_q cal(A)(T_q) != 0 } $
is a non-empty open subset of $X(QQ_p) times X(QQ_q)$ --- non-empty precisely because both
invariants are non-constant --- and $X(QQ)$ misses it, because the standing hypothesis makes
$"inv"_v cal(A)$ vanish at every other place, so that global reciprocity is the two-term relation
above. That is the Brauer--Manin obstruction to
weak approximation in its usual adelic form; @sec-nonCM's theorems are the special case where only
one invariant is non-constant.

== It is invisible one place at a time <sec-tp-invisible>

This is the point of the chapter. $R$ can have dimension 2 and still project *onto* $W_p$ and
*onto* $W_q$: take $R$ the graph of an isomorphism $psi : W_p -> W_q$ with
$psi^* beta_q = -beta_p$, which exists because all symplectic forms on $(ZZ slash ell)^2$ are
isomorphic. So $X(QQ)$ may be dense in $X(QQ_p)$ *and* dense in $X(QQ_q)$ and still fail to be
dense in the product. Neither single-place argument gives anything, since reciprocity yields
$beta_p = -beta_q$ rather than $beta_p = 0$.

A surface of this kind is therefore invisible to @sec-result, which tests one prime at a time and
would report a witness in every class. The place it could show up is the
$S$-adic ledger of the companion notes, whose sweep over the 64 tuples for
$S = {11, 13, 17}$ proved only 13 --- an $S$-adic test *is* a several-places-at-once test, and a
tuple it fails to prove is exactly a correlation it cannot rule out.

== Where to look <sec-tp-family>

For the criterion to apply, *every* place except $p$ and $q$ must be dead, and at level 2 with
$f = x q(x)$ that needs both structural lemmas at once:

- $beta$ alternating at every place, which by Lemma 2 of @sec-alt asks that the 2-torsion field be
  $QQ(i)$, i.e. that $q$ be a *sum of two squares*;
- $beta_q$ trivial at odd $q divides d$, which by @sec-tk-lemAB asks that $b$ be a *perfect square*.

Writing $q(x) = (x + alpha)^2 + mu^2$, so that $b = alpha^2 + mu^2$, the two conditions together
say $alpha^2 + mu^2 = k^2$: *the family is indexed by Pythagorean triples*.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Lemma.* For $f = x q(x)$ with $q(x) = (x + alpha)^2 + mu^2$ and $alpha^2 + mu^2 = k^2$, every
  place at which $beta_v$ can be non-trivial divides $2 k$.

  #v(2mm)
  _Proof._ At $v = infinity$, $q > 0$ forces $x >= 0$ on real points, so the symbol is $+1$. At an
  odd $q$ dividing $d$, @sec-tk-lemAB applies because $b = k^2$ is a square. At any other
  $q divides.not 2 b d$: writing $x = a slash e^2$, $y = b slash e^3$, a common prime factor of $a$
  and $a^2 + 2 alpha d a e^2 + k^2 d^2 e^4$ divides $k^2 d^2 e^4$, hence $k^2 d^2$, so the two are
  coprime, $v_q (c(P))$ is even, both arguments are units and the symbol is $+1$. What is left is
  $2$ and the primes of $b = k^2$. $qed$
]

So the *odd* live places lie among the prime factors of the *hypotenuse*. (@sec-dep-dim explains
why: the 2-torsion field is $QQ(i)$, so a live place needs $-1$ to be a square, i.e.
$v equiv 1$ $(mod 4)$ --- and those are exactly the primes that divide a hypotenuse.) For a primitive triple
$k$ is a product of primes $equiv 1$ $(mod 4)$, so two live odd places require a hypotenuse that is
not a prime power, and the smallest candidates are $k = 65 = 5 dot 13$ and $k = 85 = 5 dot 17$.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  That is why the phenomenon never appeared in @sec-nonCM. The three surfaces of this family that
  were surveyed are $x^3 + x$ with $(alpha, mu, k) = (0,1,1)$, `15a4` with $(7, 24, 25)$ and `17a1`
  with $(15, 8, 17)$ --- and $1$, $25$, $17$ are all prime powers. One live place is exactly what a
  prime-power hypotenuse allows.
]

== The screen <sec-tp-screen>

`twoplace.gp` runs the family over the first 24 triples, testing at each candidate place and
each square class of $d$ whether the image of $c$ is *non-isotropic* for the Hilbert symbol --- the
correct test, since a one-dimensional image can be non-isotropic when $beta$ fails to be
alternating, so "the image is everything" would be too strong. A representative point of view
matters here: for $v equiv 1$ $(mod 4)$ the list $1, -1, v, -v$ covers only *two* of the four
classes, because $-1$ is then a residue; the script uses a primitive root.

#align(center, table(
  columns: 4, align: (left, left, center, left),
  stroke: 0.4pt + luma(170), inset: (x: 7pt, y: 3.5pt),
  table.header([$(alpha, mu, k)$], [$f = x(x^2 + 2 alpha x + k^2)$], [$N$], [live places]),
  [$(0,1,1)$ = $x^3 + x$], [$x(x^2 + 1)$], [64], [2],
  [$(7,24,25)$ = `15a4`], [$x(x^2 + 14x + 625)$], [15], [5],
  [$(15,8,17)$ = `17a1`], [$x(x^2 + 30x + 289)$], [17], [17],
  [$(3,4,5)$], [$x(x^2 + 6x + 25)$], [40], [5],
  [$(5,12,13)$], [$x(x^2 + 10x + 169)$], [624], [13],
  [$(8,15,17)$], [$x(x^2 + 16x + 289)$], [16320], [*2 and 17*],
  [$(33,56,65)$], [$x(x^2 + 66x + 4225)$], [7280], [*5 and 13*],
  [$(13,84,85)$], [$x(x^2 + 26x + 7225)$], [28560], [*5 and 17*],
  [$(16,63,65)$], [$x(x^2 + 32x + 4225)$], [87360], [*2, 5 and 13*],
))

#v(2mm)

Eleven of the twenty-four have a single live place; the other thirteen have two or three. Note that swapping
$alpha$ and $mu$ within a triple changes the answer --- $(15,8,17)$ has one live place and
$(8,15,17)$ has two --- because it changes $q(x)$, not just the curve.

== An example <sec-tp-example>

Take $(alpha, mu, k) = (33, 56, 65)$:
$ f = x (x^2 + 66 x + 4225), quad q(x) = (x + 33)^2 + 56^2, quad b = 65^2, quad N = 7280 . $
It is the cleanest of the hits: both live places are *odd*, and each is live in exactly one square
class. The complete local picture, over every place and every class:

#align(center, table(
  columns: 4, align: (center, left, center, left),
  stroke: 0.4pt + luma(170), inset: (x: 7pt, y: 3.5pt),
  table.header([$v$], [classes of $d$], [$|$image of $c|$], [verdict]),
  [$infinity$], [all], [---], [dead: $q > 0$ forces $x >= 0$],
  [$2$], [all *eight*], [1 or 2], [dead in every class],
  [$5$], [$[1]$], [*4*], [*live*: symplectic on the 2-dimensional $W_5$],
  [$5$], [the other three], [2], [dead],
  [$13$], [$[1]$], [*4*], [*live*: symplectic on the 2-dimensional $W_13$],
  [$13$], [the other three], [2], [dead],
  [$7$], [all four], [1 or 2], [dead --- computed, and predicted by coprimality],
  [every other $q divides.not 2 dot 5 dot 13 dot d$], [all], [---],
    [dead by the coprimality argument],
  [odd $q divides d$], [---], [$<= 2$], [dead by @sec-tk-lemAB, $b = 65^2$],
))

#v(2mm)

Once $beta$ is alternating, $beta(P,P) = 0$, so an image of size $1$ or $2$ is automatically
isotropic and the place is dead; "image of size 4" is therefore the live condition, and it makes
$beta_v$ non-degenerate as well as non-zero. In each computed row the sampled points are shown to
generate the relevant quotient of
$E_d (QQ_v)$ --- $E_1$ at odd $v$, $E_3$ at $v = 2$ --- so the images are exhaustive, and the four
square classes at 5 and 13 and the eight at 2 cover every squarefree $d$.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Theorem.* Let $f = x(x^2 + 66x + 4225)$ and $X : y^2 = f(x) f(t)$. For every squarefree $d$ that
  is a square in $QQ_5^times$ *and* a square in $QQ_13^times$, the group $E_d (QQ)$ is not dense in
  $E_d (QQ_5) times E_d (QQ_13)$. Hence $X(QQ)$ is not dense in $X(QQ_5) times X(QQ_13)$.

  #v(2mm)
  _Proof._ $q$ is a sum of two squares, so the 2-torsion field is $QQ(i)$ and $beta$ is alternating
  at every place (Lemma 2 of @sec-alt). By the table, $beta_v$ is trivial at every $v != 5, 13$.
  Reciprocity gives $beta_5 (P,Q) + beta_13 (P,Q) = 0$ for all $P, Q in E_d (QQ)$, so the image $R$
  of $E_d (QQ)$ in $W_5 xor W_13$ is isotropic for $gamma = beta_5 xor beta_13$. Both summands are
  non-trivial alternating forms on 2-dimensional $bb(F)_2$-spaces, hence symplectic, so $gamma$ is
  symplectic on a 4-dimensional space and $dim R <= 2 < 4$. As $W_5 times W_13$ is a finite
  discrete quotient of $E_d (QQ_5) times E_d (QQ_13)$, a dense subgroup would surject onto it, and
  $R$ does not. For $X$ the relevant consequence is the isotropy itself:
  $beta_5 (P_5, Q_5) + beta_13 (P_13, Q_13) = 0$ holds at every rational point and for every $d$ in
  the pair of classes, which by @sec-tp-crit and @sec-class-warning excludes a non-empty open
  subset of $X(QQ_5) times X(QQ_13)$. $qed$
]

== What is not settled <sec-tp-open>

- *Whether the obstruction is genuinely two-place here.* @sec-tp-invisible shows it *can* be, but
  for this surface it is not checked whether $X(QQ)$ is dense in $X(QQ_5)$ and in $X(QQ_13)$
  separately. If it is, this is a failure of weak approximation that no single-place argument can
  see; if not, the two-place statement is weaker than a single-place one and the interest is only
  in the mechanism. Running @sec-result's witness search at $p = 5$ and $p = 13$ for this surface
  would settle it, and is the obvious next step.
- *The Brauer class.* @sec-brauer-2 writes the algebra down for level 2, and @sec-brauer-unram-2
  gives the criterion for it to be unramified on the Kummer surface. Neither has been checked here.
- *Level 3, and split $f$.* The family above is the indecomposable level-2 case. The decomposable
  cases have their own pair of structural lemmas (@sec-tk-ramtwist kills $q divides d$ for free at
  odd $ell$), so the analogous family should be easier to describe, and is not described here.
- *Finding more of them.* @sec-dep-recipe replaces this screen: the condition is two bad primes
  $equiv 1$ $(mod ell)$ with $ell divides v_p (Delta)$ whose canonical lines escape $phi$, which is
  a discriminant computation rather than a point search.
- *More than two live places.* $(16,63,65)$ has three. Reciprocity then makes $R$ isotropic in a
  6-dimensional space, giving $dim R <= 3$ of $6$; nothing in @sec-tp-crit is special to two.

= What the obstruction depends on <sec-depends>

@sec-nonCM and @sec-twoplace build examples one at a time: pick a surface, analyse $beta_v$ place
by place, collect what survives. This chapter asks the structural question instead. Given $E$,
$ell$ and a non-scalar $phi in "End"_G (E[ell])$, which sets $S$ of primes are obstructed, and in
which square classes --- *without* analysing the $beta_v$? The answer is that almost all of it is
reduction data: Tate's algorithm, the factorisation of the minimal discriminant, and the
$ell$-isogeny class. Two gaps remain, and @sec-dep-gaps says exactly where they are.

== Notation, and the criterion restated <sec-dep-crit>

Everything in this chapter refers to the following fixed data, and to one definition.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Fixed throughout:* an elliptic curve $E slash QQ$ given by $y^2 = f(x)$, a prime $ell$, and a
  non-scalar $phi in "End"_G (E[ell])$. The surface is $X : y^2 = f(x) f(t)$.

  #v(1.5mm)
  *$d$ is a squarefree integer* --- an element of $QQ^times$, not a square class --- and
  $E_d : d y^2 = f(x)$ is the corresponding quadratic twist. *$v$ ranges over all places of $QQ$,
  the archimedean one included.* For each $d$ and $v$ write
  $ W_v (d) = E_d (QQ_v) slash ell, quad
    L_v (d) = delta_v (W_v (d)) subset.eq H^1 (QQ_v, E_d [ell]), $
  and let $beta_v^((d))$ be the twisted Tate pairing on $W_v (d)$. Superscripts are dropped when
  $d$ is clear.

  #v(1.5mm)
  *Definition.* $ Sigma_phi (d) = { v : L_v (d) "is not" phi_*"-stable" } . $
  We write $Sigma(d)$ when $phi$ is fixed, and keep the subscript when several $phi$ are in play,
  as in @sec-dep-15a1.
]

Three things about that definition. It attaches a set of *places* to a single squarefree
*integer*; no prime and no finite set $S$ is fixed in advance, and $Sigma(d)$ is what the chapter
computes. It is *finite* for every $d$: Lemma 1 below gives
$Sigma(d) subset.eq {infinity} union {v : E_d "is bad at" v}$, and that is the first thing to
prove, since without it nothing in @sec-dep-global would even typecheck. For $ell$ odd Lemma 2
sharpens this to a bound *independent of $d$*, which is the stronger statement the chapter needs;
at $ell = 2$ the primes $q divides d$ stay in the bound and have to be removed by hand. And although $d$ is an integer, $E_d slash QQ_v$
depends on $d$ only through its class in $QQ_v^times slash (QQ_v^times)^2$, so $Sigma(d)$ is
constant on the tuples of local square classes of @sec-class-warning; that is what lets a statement
about $Sigma(d)$ become a statement about the surface.

The classical fact behind descent is that the local Kummer image
$ L_v = delta_v (E_d (QQ_v) slash ell) subset.eq H^1 (QQ_v, E_d [ell]) $
is *maximal isotropic* for the cup product with the Weil pairing: it is its own annihilator. Since
$beta_v (P,Q) = ⟨c(P), phi_* c(Q)⟩$ with both arguments in $L_v$:

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  $ beta_v equiv 0 quad <==> quad phi_* L_v subset.eq L_v^perp = L_v quad <==> quad
    L_v "is" phi_*"-stable" quad <==> quad v in.not Sigma_phi (d) . $
  #v(1.5mm)
  _Proof._ If $phi_* L_v subset.eq L_v = L_v^perp$ then $beta_v (P,Q) = ⟨c(P), phi_* c(Q)⟩$ pairs
  an element of $L_v$ against an element of $L_v^perp$, so it vanishes. Conversely if
  $beta_v equiv 0$ then $phi_* L_v subset.eq L_v^perp = L_v$. $qed$
  #v(1.5mm)
  So $Sigma_phi (d) = { v : beta_v equiv.not 0 }$, and by @sec-class-warning and @sec-tp-crit the
  obstructed sets are exactly the $S$ containing $Sigma_phi (d)$.
]

Everything below computes $Sigma(d)$. Note that $phi$ is a *twist-invariant* datum: $E_d [ell]$ is $E[ell]$ twisted by
the quadratic character $chi_d$, so $"End"_G (E_d [ell]) = "End"_G (E[ell])$ and the same $phi$ serves every twist at once.

== Step 1: almost every place dies by functoriality <sec-dep-func>

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Lemma 1.* Let $v$ be a finite place at which *$E_d$ itself* --- not $E$ --- has good reduction.
  #v(1.5mm)
  (a) If $v != ell$ then $L_v = H^1_"ur" (QQ_v, E_d [ell])$.
  #v(1mm)
  (b) If $v = ell >= 3$ then $L_ell = H^1_f (QQ_ell, E_d [ell])$.
  #v(1.5mm)
  In both cases $L_v$ is $phi_*$-stable for *every* $phi$, so $v in.not Sigma(d)$.

  #v(2mm)
  _Proof._ (a) and (b) are the standard identifications of the local condition. What matters here
  is that both $H^1_"ur"$ and $H^1_f$ are *functorial in the Galois module*: an unramified class
  pushes forward to an unramified class, and $H^1_f$ is functorial for maps of finite flat group
  schemes (which $phi$ is, by Raynaud, since $e = 1 < ell - 1$ for $ell >= 3$). A subgroup carried
  into itself by every $phi$ is in particular carried into itself by ours. $qed$
]

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *What the hypothesis says about $d$.* It is a condition on $E_d$, and for odd $v$ it *almost*
  forces $v divides.not d$: if $v divides d$ then $chi_d$ is ramified at $v$, and a ramified
  quadratic twist of a curve with good or multiplicative reduction is additive (type $"I"_n^*$).
  So if $E$ has good or multiplicative reduction at $v$, then $E_d$ good at $v$ does force
  $v divides.not d$.

  #v(1.5mm)
  It does *not* force it when $E$ is additive at $v$, because a ramified twist can then *improve*
  the reduction. Twisting `11a1` by 3 gives a curve of type $"I"_0^*$ at 3 and conductor 1584;
  twisting that one by $d = 3$ again --- so $v divides d$ --- returns `11a1`, good at 3. Lemma 1
  applies to that place, and correctly.
]

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  Lemma 1(b) *upgrades @sec-tk-ordinary*. That lemma proved the vanishing at $v = ell$ under good
  *ordinary* reduction, by splitting the connected--étale sequence. The ordinarity was never
  needed: good reduction alone gives $L_ell = H^1_f$, and functoriality does the rest. The
  supersingular case is covered too.
]

Two more *kinds* of place die for $ell$ odd --- the archimedean one, and every prime dividing $d$,
of which there may of course be many --- and here the twist is what kills them.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Lemma 2.* Let $ell$ be odd. Then $W_infinity = 0$, and $W_q = 0$ for every prime $q divides d$,
  $q != ell$, at which $E$ has good reduction.

  #v(2mm)
  _Proof._ $E_d (RR)$ is a compact Lie group, hence divisible by the odd $ell$. At $q divides d$
  the twisting character $chi_d$ is ramified, so inertia acts on $E_d [ell]$, the twist of $E[ell]$ by $chi_d$,
  by $-1$ times an unramified action; as $ell$ is odd, $-1 != 1$ and there are no non-zero inertia
  invariants, so $E_d [ell](QQ_q) = 0$. Since $E_d (QQ_q) tilde.equiv ZZ_q times T$ with $T$ finite
  and $q != ell$, $W_q = E_d (QQ_q) slash ell tilde.equiv T slash ell$ has the same order as
  $E_d [ell](QQ_q)$, namely $1$. $qed$
]

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Corollary.* For $ell$ odd, $Sigma(d) subset.eq { v : v divides N_E } union { ell }$, and the
  right-hand side does not depend on $d$: *the arena is the conductor of $E$*.
]

At $ell = 2$ Lemma 2 fails --- $chi_d$ takes values in ${plus.minus 1}$, which is trivial modulo 2
--- and $infinity$ and the $q divides d$ have to be handled by hand. That is exactly what
@sec-tk-lemAB and the norm lemma do, and it is why the level-2 arguments are longer.

== Step 2: the dimension condition is a splitting condition <sec-dep-dim>

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Lemma 3.* Suppose $beta_v$ is alternating (automatic for $ell$ odd; for $ell = 2$ this is the
  norm lemma of @sec-alt). If $beta_v equiv.not 0$ then $dim W_v = 2$, i.e. *all* of $E_d [ell]$ is
  rational over $QQ_v$. For $v != ell$ this forces $zeta_ell in QQ_v$, hence
  $ v equiv 1 quad (mod ell). $

  #v(2mm)
  _Proof._ $dim W_v = dim E_d [ell](QQ_v) <= 2$. An alternating form on a space of dimension
  $<= 1$ vanishes, so $beta_v equiv.not 0$ needs dimension exactly 2, which is all of $E_d [ell]$.
  The Weil pairing then puts $mu_ell$ inside $QQ_v^times$. $qed$
]

This single congruence is the sharpest filter in the chapter. Every live place in the whole
document satisfies it, and every place that the cruder tests wrongly flag fails it:

#align(center, table(
  columns: 5, align: (left, center, center, center, left),
  stroke: 0.4pt + luma(170), inset: (x: 7pt, y: 3.5pt),
  table.header([case], [$ell$], [$v$], [$v mod ell$], [$ell$-torsion $x$-coordinates over $QQ_v$]),
  [`14a1`, `14a2`], [3], [7], [1], [4 of 4 --- full, and *live*],
  [`19a1` (class $[u]$)], [3], [19], [1], [4 of 4 --- full, and *live*],
  [`11a1`], [5], [11], [1], [12 of 12 --- full, and *live*],
  [`15a1`, `15a4`, `17a1`, @sec-tp-example], [2], [5, 13, 17], [1], [3 of 3 --- full, and *live*],
  [`14a1`, `14a2` at the other bad place], [3], [2], [2], [1 of 4 --- dead, though $3 divides c_2$],
  [@sec-tp-example at 7], [2], [7], [1], [1 of 3 --- dead, though $7$ is split multiplicative],
  [`15a4` at 3], [2], [3], [1], [1 of 3 --- dead],
))

#v(2mm)

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *This is where the hypotenuse came from.* In the family of @sec-tp-family the 2-torsion field is
  $QQ(i)$ --- that was forced by the norm lemma --- so full local 2-torsion means $-1$ is a square
  in $QQ_v$, i.e. $v equiv 1$ $(mod 4)$. The primes dividing the hypotenuse of a primitive
  Pythagorean triple are precisely the primes $equiv 1$ $(mod 4)$. The empirical lemma of
  @sec-tp-family, found by screening, is a one-line corollary of Lemma 3.
]

== Step 3: which reduction types can carry it <sec-dep-red>

At a multiplicative $v != ell$ the Tate parametrisation gives $E_d (overline(QQ)_v) = overline(QQ)_v^times slash q^ZZ$
with $E_d [ell] = ⟨zeta_ell, q^(1 slash ell)⟩$. Full rationality of $E_d [ell]$ therefore asks for
two things: $zeta_ell in QQ_v$, which is Lemma 3 again, and $q in (QQ_v^times)^ell$ --- which in
particular forces
$ ell divides v(q) = v(Delta_min). $
Additive places have $c_v <= 4$ for every Kodaira type, so they can only contribute for small
$ell$: type $"IV"$ or $"IV"^*$ with $c_v = 3$ at $ell = 3$ (which is what $x^3 - 2$ does at its
wild place), and types with $c_v in {2,4}$ at $ell = 2$.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Corollary.* For $ell >= 5$, every place of $Sigma(d)$ is a place of *split multiplicative*
  reduction of $E_d$ with $ell divides v(Delta_min)$. The obstructed set is read off the
  factorisation of the discriminant.
]

`11a1` is the whole story in one line: $Delta = -11^5$, and $ell = 5$.

== Step 4: the square class comes for free <sec-dep-class>

Let $v divides.not 2 ell$ and let $E$ have multiplicative reduction at $v$. The four square classes
of $QQ_v^times$ do the following to $E_d$:

#align(center, table(
  columns: 3, align: (center, left, left),
  stroke: 0.4pt + luma(170), inset: (x: 7pt, y: 3.5pt),
  table.header([class of $d$], [reduction of $E_d$ at $v$], [verdict]),
  [$[1]$, $[u]$], [multiplicative, same $v(Delta)$; one of the two is *split*, the other non-split],
    [only the split one can be live],
  [$[v]$, $[u v]$], [additive (type $"I"_n^*$), $c_v <= 4$],
    [dead for $ell >= 5$; needs checking for $ell <= 3$],
))

#v(2mm)

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Corollary.* At each place at most *one* square class is live: the unique unramified class making
  $E_d$ split multiplicative at $v$. Which one it is depends only on whether $E$ itself is split
  there.
]

That is the "one class out of four" which every theorem of @sec-nonCM reports, and which the survey
of @sec-result measures class by class. It was never a computational accident.

== Step 5: where $phi$ finally enters <sec-dep-phi>

Steps 1--4 do not mention $phi$ at all: they cut the places down to a candidate set determined by
$E$ and $ell$ alone. $phi$ decides among the candidates, and it does so by a single comparison.

At a split multiplicative $v$ the module $E_d [ell]$ carries a distinguished $G_v$-stable line, the
kernel of reduction
$ C_"can" (v) = mu_ell subset overline(QQ)_v^times slash q^ZZ . $
It is $G_v$-stable but *need not be $G_QQ$-stable*: that is the whole point, and it is why
@sec-14a1 records that at the critical place both global lines become $QQ_p$-rational, leaving room
for a third.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Criterion.* At such a $v$, $beta_v equiv.not 0$ iff $C_"can" (v)$ is *not* one of the $phi$-stable
  lines --- for a rank-one $phi$, iff $C_"can" (v) in.not { ker phi, "im" phi }$.
]

And $C_"can" (v)$ can be seen with no local points at all. Quotienting the Tate curve by $mu_ell$ sends
$q |-> q^ell$, while quotienting by an étale line sends $q |-> q^(1 slash ell)$. So:

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  A rational $ell$-isogeny $E -> E slash C$ has
  $ v(Delta_(E slash C)) = ell dot v(Delta_E) quad "if" C = C_"can", quad quad
    v(Delta_(E slash C)) = v(Delta_E) slash ell quad "if" C "is étale". $
  So: label each candidate place by the rational line canonical there --- the one whose isogeny
  *multiplies* $v(Delta)$ by $ell$ --- or by "irrational" if no rational line does. Then $S_phi$ is
  the set of labelled places whose label $phi$ fails to stabilise, and places labelled "irrational"
  are live for every $phi$.
]

There is a second, independent signature of the same thing, and it connects back to the machinery
of @sec-nonCM: $C_i = C_"can"$ exactly when the descent map $c_i$ *collapses*, i.e. its image on
$E_d (QQ_v)$ is a single square class.

=== `15a1`, where $phi$ actually changes the answer <sec-dep-15a1>

With three rational 2-torsion lines there are three choices of rank-one $phi$, each excluding one
line, and the labels separate them. For $f = (x-17)(x-1)(x+8)$:

#align(center, table(
  columns: 5, align: (center, center, center, left, left),
  stroke: 0.4pt + luma(170), inset: (x: 7pt, y: 3.5pt),
  table.header([$v$], [reduction], [live class], [canonical line], [$phi = (c_1, c_3)$ excludes $e = 1$]),
  [3], [$"I"_4$ non-split], [$[u]$], [$e = 17$, since $v(Delta)$ goes $4 -> 8$],
    [$e=17$ *is* $phi$-stable: dead],
  [5], [$"I"_4$ split], [$[1]$], [$e = 1$, since $v(Delta)$ goes $4 -> 8$],
    [$e=1$ is *not* $phi$-stable: *live*],
))

#v(2mm)

So the recipe predicts $S = {5}$ in class $[1]$ for the $phi$ of @sec-15a1 --- which is the theorem
proved there --- and that $3 in Sigma(d)$ in class $[u]$ for the $phi$ pairing $c_2$ with $c_3$,
where @sec-15a1 has nothing to say. That second
prediction was made from the table above and then tested directly:

#align(center, table(
  columns: 3, align: (left, left, left),
  stroke: 0.4pt + luma(170), inset: (x: 7pt, y: 3.5pt),
  table.header([$phi$], [$v = 5$, class $[1]$], [$v = 3$, class $[u]$]),
  [$(c_1, c_3)$ --- @sec-15a1's], [$|"im" c_1| = 4$, six non-trivial symbols: *live*],
    [$|"im" c_1| = 1$: trivial],
  [$(c_2, c_3)$ --- the other], [$|"im" c_2| = 1$: trivial],
    [$|"im" c_2| = 4$, six non-trivial symbols: *live*],
))

#v(2mm)

The collapse of $c_i$ at the place where $C_i$ is canonical is visible in the second column of each
row. The same curve, the same $ell$, two endomorphisms, two different critical primes.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *But $Sigma(d)$ is not ${3}$, and the recipe never said it was.* At $ell = 2$ steps 1--5 govern
  only the *odd places of multiplicative reduction*: Lemma 2 fails, so $infinity$ and the
  $q divides d$ are outside the scheme, and $v = 2$ is the wild place. @sec-15a1 supplies exactly
  those places for its own $phi$ --- Lemma C is a statement about $c_1$ and $c_3$ --- and supplies
  nothing for any other. Computing them for $phi = (c_2, c_3)$ at $d = -1$:

  #v(2mm)
  #align(center, table(
    columns: 5, align: (left, center, center, center, center),
    stroke: 0.4pt + luma(170), inset: (x: 7pt, y: 3.5pt),
    table.header([$phi$], [$infinity$], [$2$], [$3$], [$5$]),
    [$(c_1, c_3)$ --- @sec-15a1's], [trivial], [trivial], [trivial], [*live*],
    [$(c_2, c_3)$ --- the other], [*live*], [*live*], [*live*], [trivial],
  ))

  #v(2mm)
  So $Sigma_(phi_B)(-1) = {infinity, 2, 3}$: reciprocity gives
  $beta_infinity + beta_2 + beta_3 = 0$, a *three-place correlation*, and no constraint at $3$
  alone. That is @sec-tp-invisible again, and it is why @sec-fail's search --- which tests one
  prime at a time --- witnesses every class of `15a1` at $p = 3$ and fails only at $p = 5$. There
  is no conflict between the two.
]

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  The real place is also a reminder that the *alternating* property is $phi$-dependent. For
  $phi_B$ and $d < 0$ both $c_2$ and $c_3$ are negative on the egg of $E_d (RR)$, so
  $beta_infinity != 0$ on the *1-dimensional* $W_infinity$ --- which an alternating form could not
  manage. Lemma 3 therefore does not even apply to $phi_B$ at $infinity$: the norm lemma of
  @sec-alt buys the alternating property for a particular pair of descent maps, not for the
  curve.
]

== The recipe <sec-dep-recipe>

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Input:* $E$, $ell$, and $phi$ given by its stable lines. *Output:* $Sigma(d)$ and the class at
  each place. *No local points, no descent images, no symbols.*

  #v(2mm)
  1. Start with the primes dividing $N_E$ (Lemma 1; for $ell$ odd this is already everything, by
     Lemma 2).
  2. Discard every $v$ with $v equiv.not 1$ $(mod ell)$ (Lemma 3).
  3. Keep $v$ multiplicative with $ell divides v_v (Delta_min)$; for $ell >= 5$ that is the only
     possibility, for $ell <= 3$ also check additive types with $ell divides c_v$.
  4. The class at $v$ is the unique unramified class making $E_d$ split multiplicative.
  5. Label $v$ by the canonical line, via the $ell$-isogeny that multiplies $v(Delta)$ by $ell$;
     keep $v$ iff $phi$ does not stabilise the label.
  #v(1.5mm)
  For $ell$ odd this is $Sigma(d)$ entire, and $S = Sigma(d)$ together with its supersets are the
  obstructed sets. *At $ell = 2$ it is only $Sigma(d)$ intersected with the odd places of
  multiplicative reduction*: $infinity$, $v = 2$ and the $q divides d$ must be added by hand, with
  @sec-tk-lemAB and the norm lemma, and until that is done a one-element output does *not* mean a
  one-place obstruction. @sec-dep-15a1 shows what goes wrong if this is forgotten.
]

`depends.gp` runs exactly this, and `results/survey-depends.txt` is its output on every case in the
document. The predicted sets agree with the computed ones throughout:

#align(center, table(
  columns: 5, align: (left, center, left, left, center),
  stroke: 0.4pt + luma(170), inset: (x: 7pt, y: 3.5pt),
  table.header([case], [$ell$], [predicted $S$], [computed], [agree]),
  [`11a1`], [5], [${11}$, class $[1]$], [${11}$, class $[1]$], [yes],
  [`14a1`], [3], [${7}$, class $[1]$], [${7}$, class $[1]$], [yes],
  [`14a2`], [3], [${7}$, class $[1]$], [${7}$, class $[1]$], [yes],
  [`19a1`], [3], [${19}$, class $[u]$], [${19}$, class $[u]$], [yes],
  [`15a4`], [2], [${5}$, class $[1]$], [${5}$, class $[1]$], [yes],
  [`17a1`], [2], [${17}$, class $[1]$], [${17}$, class $[1]$], [yes],
  [@sec-tp-example], [2], [${5, 13}$, class $[1]$ of each], [${5,13}$, class $[1]$ of each], [yes],
  [`15a1`, $phi$ excl. $e=1$], [2], [$5$ in, $3$ out], [$Sigma = {5}$, class $[1]$], [yes],
  [`15a1`, $phi$ excl. $e=17$], [2], [$3$ in, $5$ out], [$Sigma = {infinity, 2, 3}$], [yes #super[\#]],
  [$x^3 - 2$], [3], [--- (wild place)], [${3}$, class $[u dot 3]$], [out of scope],
))

#v(2mm)

The marked row is the one to read carefully. The recipe's two assertions --- $3$ is critical, $5$
is not --- are both correct, and the computed $Sigma$ contains two further places that the recipe
does not claim to see, because at $ell = 2$ it covers only the odd multiplicative ones. For the
other eight rows the missing places were supplied by @sec-nonCM for the $phi$ in question, which is
why $Sigma$ came out equal to the predicted set there.

== Sufficiency at a Tate place <sec-dep-suff>

The recipe was presented above as a filter: a place failing any of the five steps cannot be live.
This section proves the converse at the places that matter, and the proof also explains why every
computation in @sec-nonCM turned into a Hilbert symbol.

Throughout, $v divides.not ell$ and $E_d slash QQ_v$ has *split multiplicative* reduction, with
Tate parametrisation
$ E_d (overline(QQ)_v) = overline(QQ)_v^times slash q^ZZ, quad
  E_d [ell] = ⟨s, t⟩, quad s = zeta_ell, quad t = q^(1 slash ell), quad
  C_"can" (v) = ⟨s⟩ = mu_ell . $
The Weil pairing is the obvious one, $e(s,t) = zeta_ell$ and $e(s,s) = e(t,t) = 1$.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *The canonical line is local, and the argument is kept.* $C_"can" (v)$ is *not* a globally defined
  subgroup of $E[ell]$: it is attached to the place $v$, and it exists only when $E$ is
  *potentially multiplicative* at $v$, i.e. $v(j) < 0$. Different places give different lines ---
  for `15a1` it is $e = 1$ at $v = 5$ and $e = 17$ at $v = 3$ (@sec-dep-15a1) --- so the argument
  $v$ is written throughout.

  #v(1.5mm)
  What it does *not* depend on is $d$. The condition $v(j) < 0$ for its existence is
  twist-invariant, and so is the line: quadratic twisting by $d$ is an isomorphism
  $psi : E -> E_d$ over $QQ_v (sqrt(d))$, hence an isomorphism of Néron models over the ring of
  integers, so it carries kernel of reduction to kernel of reduction, and under the canonical
  identification $E_d [ell] = E[ell]$ the two lines coincide. (Only $psi$ up to sign is canonical,
  which is enough for a *subgroup*.) What the twist *does* change is the Galois module structure
  carried by that line: $mu_ell$ for one twist, $mu_ell$ times $chi_d$ for another. The line stays
  put; the action on it moves.

  #v(1.5mm)
  Inside a proof, where $v$ is fixed once and for all, we drop the argument and write $C_"can"$.
]

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Lemma 4 (the local condition is the cohomology of the canonical line).*
  #v(1.5mm)
  (a) $L_v subset.eq H^1 (QQ_v, C_"can")$, always.
  #v(1mm)
  (b) If moreover $E_d [ell] subset.eq E_d (QQ_v)$, then $L_v = H^1 (QQ_v, C_"can")$ exactly, and
  both sides have dimension 2.

  #v(2mm)
  _Proof._ (a) A point $P in E_d (QQ_v)$ is represented by some $u in QQ_v^times$. Take
  $R = u^(1 slash ell)$, which satisfies $ell R = P$ in $overline(QQ)_v^times slash q^ZZ$. Then
  $ delta_v (P)(sigma) = sigma(R) - R = sigma(u^(1 slash ell)) slash u^(1 slash ell) in mu_ell , $
  so the cocycle takes its values in $C_"can" (v)$, i.e. $delta_v (P) = chi_u$, the Kummer character
  of $u$. As $E_d [ell]$ is a direct summand extension of trivial modules, $H^1 (QQ_v, C_"can")$
  injects into $H^1 (QQ_v, E_d [ell])$, and $L_v$ lands in the image.

  #v(1.5mm)
  (b) Full rationality of $E_d [ell]$ says $zeta_ell in QQ_v$ and $q in (QQ_v^times)^ell$. The
  second gives $E_d (QQ_v) slash ell = QQ_v^times slash (q^ZZ (QQ_v^times)^ell) = QQ_v^times slash (QQ_v^times)^ell$,
  and the first makes that group of order $ell^2$; so $dim W_v = 2$ and $P |-> u$ identifies $W_v$
  with $QQ_v^times slash (QQ_v^times)^ell$. On the other side, local class field theory gives
  $H^1 (QQ_v, C_"can") = "Hom"(G_v, mu_ell) tilde.equiv (QQ_v^times slash (QQ_v^times)^ell)^or$,
  also of dimension 2, and $u |-> chi_u$ is the Kummer isomorphism between them. $qed$
]

Lemma 4(b) is the structural statement the chapter has been circling: *at a Tate place with full
local $ell$-torsion, the Selmer local condition is the cohomology of the canonical line.* Since
$H^1 (QQ_v, -)$ is $"Hom"(G_v, -)$ on trivial modules, and $"Hom"(G_v, F_ell) != 0$, the map
$C |-> H^1 (QQ_v, C)$ is an inclusion-preserving injection on subspaces of $E_d [ell]$. So
$phi_* L_v = H^1 (QQ_v, phi(C_"can"))$, and $phi$-stability of $L_v$ is *the same thing as*
$phi$-stability of $C_"can" (v)$ --- both directions, with no computation.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Theorem 5 (sufficiency at a Tate place).* Let $v divides.not ell$ and suppose
  #v(1mm)
  (a) $E_d slash QQ_v$ has split multiplicative reduction;
  #v(1mm)
  (b) $E_d [ell] subset.eq E_d (QQ_v)$;
  #v(1mm)
  (c) $phi(C_"can" (v)) subset.eq.not C_"can" (v)$ --- *a condition on $E$, $ell$, $phi$ and $v$ alone,
  with no reference to $d$* (see the remark below).
  #v(1.5mm)
  Then, writing $phi(s) = a s + b t$ with $b != 0$,
  $ beta_v (P, Q) = b dot (u, w)_ell $
  for $P, Q in E_d (QQ_v)$ with Tate representatives $u, w$. In particular $beta_v$ is
  *non-degenerate*, and a fortiori $beta_v equiv.not 0$.

  #v(2mm)
  _Proof._ By Lemma 4(b), $delta_v (P) = chi_u ⋅ s$ and $delta_v (Q) = chi_w ⋅ s$. Condition (c)
  says exactly that the $t$-coefficient $b$ of $phi(s)$ is non-zero. Then
  $ beta_v (P,Q) = ⟨chi_u s, phi_* (chi_w s)⟩ = ⟨chi_u s, chi_w (a s + b t)⟩
    = a ⟨chi_u s, chi_w s⟩ + b ⟨chi_u s, chi_w t⟩ , $
  and the first term vanishes because $e(s,s) = 1$, while the second is $b$ times the cup product
  $chi_u union chi_w$ evaluated through $e(s,t) = zeta_ell$ --- that is, $b$ times the $ell$-th
  power Hilbert symbol $(u, w)_ell$. Since $zeta_ell in QQ_v$, that symbol is a non-degenerate
  pairing on $QQ_v^times slash (QQ_v^times)^ell$, which is $W_v$ by Lemma 4(b). $qed$
]

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *How to check (c) in practice.* The preamble to this section explains why $C_"can" (v)$, and with
  it condition (c), does not depend on $d$. The computational shadow of that is that the invariant separating the lines is
  $v(q) = -v(j)$, and $j$ is twist-invariant. Indeed $C = C_"can"$ iff
  $v(j_(E slash C)) = ell dot v(j_E)$, which is why `depends.gp` may read the label off the
  untwisted curve. Note that this formulation, unlike the one in terms of $v(Delta)$, survives
  *additive potentially multiplicative* reduction, where $v(Delta)$ picks up the extra 6 of a
  type $"I"_n^*$ fibre.

  #v(1.5mm)
  What is *not* twist-invariant is the Galois characterisation. Under (b) the local representation
  on $E_d [ell]$ is trivial, so $C_"can" (v)$ is not visible in the Galois module at all --- it is a
  property of the curve, of its Néron model. That is precisely the room @sec-14a1 exploits when it
  records that both global lines become $QQ_p$-rational at the critical place, leaving a third line
  free to be canonical.
]

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  This is why every case in @sec-nonCM came down to a Hilbert symbol on square or cube classes, and
  why the computed images were always the *full* $W_v$ when the place was live: at a Tate place
  with full torsion there is nothing else the pairing can be. The tame symbol tables of
  @sec-14a1 and @sec-1419, and the quaternion symbols of @sec-15a1 and @sec-17a1, are all
  Theorem 5 in coordinates.
]

=== Tested out of sample <sec-dep-oos>

Theorem 5 predicts more than a verdict. At a live place $beta_v$ should be *non-degenerate*, so
both descent images should be the whole of $W_v$ and, at $ell = 2$, exactly $3 dot 2 = 6$ of the
16 ordered pairs should carry a non-trivial symbol --- the number of ordered independent pairs in
$bb(F)_2^2$. At a dead place the descent map belonging to the canonical line should *collapse* to a
single class, which is Lemma 4(a) with $L_v$ too small.

`depends-check.gp` tests this on curves appearing nowhere else in the document, taking each of the
three rank-one $phi$ on a curve with full rational 2-torsion, predicting from reduction data alone
and then computing the symbol table:

#align(center, table(
  columns: 5, align: (left, center, center, left, left),
  stroke: 0.4pt + luma(170), inset: (x: 7pt, y: 3.5pt),
  table.header([$f$], [$v$], [$phi$ excludes], [recipe], [computed]),
  [$x(x-5)(x+4)$], [3], [$e_1 = 0$], [*live*], [images $4, 4$; 6 of 16 symbols non-trivial],
  [$x(x-5)(x+4)$], [3], [$e_2 = 5$], [dead], [$|"im" c_1| = 1$: collapse],
  [$x(x-5)(x+4)$], [5], [$e_3 = -4$], [*live*], [images $4, 4$; 6 of 16],
  [$x(x-5)(x+4)$], [5], [$e_1 = 0$], [dead], [$|"im" c_3| = 1$: collapse],
  [$x(x-9)(x+7)$], [7], [$e_2 = 9$], [*live*], [images $4, 4$; 6 of 16],
  [$x(x-9)(x+7)$], [7], [$e_1 = 0$], [dead], [$|"im" c_2| = 1$: collapse],
  [$(x-1)(x-6)(x+6)$], [5], [$e_3 = -6$], [*live*], [2 non-trivial symbols found],
))

#v(2mm)

Thirteen predictions, thirteen agreements, and the non-degeneracy signature appears wherever the
theorem says it should. The last row is worth a word: the sampler builds points from
$x = plus.minus m p^k$ with $m <= 40$, so it can miss a square class and report an image of size 3,
which is impossible for a subgroup. The non-vanishing is still *proved* --- the symbols are
evaluated at genuine points --- and Lemma 4(b) says the true image is all of $W_v$. It is a case
of the theory correcting the experiment rather than the other way round.

=== The global consequence <sec-dep-global>

For an obstruction we do not need $Sigma(d)$ itself --- only that it is finite and non-empty. The
sum $ (T_v)_(v in S) |-> sum_(v in S) beta_v (T_v) $ on a product is non-constant as soon as *one*
summand is, since the others can be held fixed. That is the whole point of working with a set $S$
rather than a single place.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Corollary 6 (failure of weak approximation).* Let $ell >= 3$, let $phi in "End"_G (E[ell])$ be
  non-scalar, and put
  $ S = {infinity, ell} union { v : v divides N_E } . $
  Suppose there is a place $p in S$, $p != ell$, at which
  #v(1mm)
  --- condition (c) of Theorem 5 holds. This is checked *once*, on $E$ itself: it involves no
  twist, and if it fails at $p$ then no $d$ whatever will make $p$ critical.
  #v(1mm)
  --- and there is a square class $delta_p$ of $QQ_p^times$ for which conditions (a) and (b) hold.
  These are the only $d$-dependent hypotheses, and they depend on $d$ only through $delta_p$.
  #v(1.5mm)
  Then for every tuple
  of square classes $(delta_v)_(v in S)$ extending $delta_p$, the surface $X$ satisfies
  $ X(QQ) "is not dense in" product_(v in S) X(QQ_v) . $
  In particular $X$ fails weak approximation.

  #v(2mm)
  _Proof._ Fix the tuple and let $d$ be any squarefree integer realising it. For $v in.not S$: if
  $v divides.not ell d$ then $E_d$ has good reduction at $v$ and Lemma 1(a) gives
  $beta_v equiv 0$; if $v divides d$ then $v$ is a prime of good reduction for $E$ and $ell$ is
  odd, so Lemma 2 gives $W_v = 0$ and again $beta_v equiv 0$. Hence Hilbert reciprocity reads
  $ sum_(v in S) beta_v (P, Q) = 0 quad "for all" P, Q in E_d (QQ), $
  and this holds for *every* $d$ realising the tuple, since $S$ and the classes $delta_v$ determine
  every $E_d slash QQ_v$ for $v in S$. By Theorem 5 the summand at $p$ is non-degenerate, so the
  sum map is non-constant on the product of the $delta_v$-parts --- a non-empty open subset of
  $product_(v in S) X(QQ_v)$ --- while it vanishes at every rational point. The argument of
  @sec-class-warning, applied on the product as in @sec-tp-crit, finishes it. $qed$
]

Three things are worth noting about the shape of Corollary 6. It never computes $Sigma(d)$: the
places of $S$ other than $p$ are simply carried along, and whatever their pairings do is absorbed
into the sum. It needs $ell$ odd only for the places $q divides d$, which is Lemma 2; at $ell = 2$
one must add @sec-tk-lemAB and the norm lemma, exactly as @sec-nonCM does. And $S$ is
*independent of $d$*, which is what lets the conclusion be about the surface rather than about one
twist.

== Additive places <sec-dep-add>

Theorem 5 needs multiplicative reduction. The gap it leaves is the *additive* candidates, and this
section closes most of it --- entirely for $ell$ odd. Two observations do the work: one about which
square class to look in, and one about what $W_v$ can be.

=== The split class need not be unramified <sec-dep-ram>

Step 4 of @sec-dep-recipe says the live class is the unique *unramified* class making $E_d$ split
multiplicative. That is right when $E$ is multiplicative at $v$, and wrong when $E$ is additive of
type $"I"_n^*$, i.e. *potentially multiplicative*: there the split class is the *ramified* one.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  `11a1` is split $"I"_5$ at 11. Its twist by 11 is $"I"_5^*$ at 11 with $c_v = 4$, and among the
  four classes it is $d = 11$ --- ramified --- that returns split multiplicative reduction. Exactly
  one of the four classes is split multiplicative in either case; which one it is, is not always
  unramified.
]

So potentially multiplicative additive places are *not a gap at all*: Theorem 5 governs them, via a
twist with $v divides d$. Only the bookkeeping of Step 4 had to be widened, and `depends.gp` now
scans all four classes.

=== At an additive place, $W_v$ is the component group <sec-dep-comp>

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Lemma 7.* Let $v divides.not ell$ be a place at which $E_d$ has additive reduction, and let
  $Phi_v$ be its component group. Then
  $ W_v = E_d (QQ_v) slash ell tilde.equiv Phi_v slash ell . $
  Consequently, since $c_v <= 4$ at every additive place:
  #v(1mm)
  --- $ell >= 5$: $W_v = 0$, so $beta_v equiv 0$;
  #v(1mm)
  --- $ell = 3$: $dim W_v <= 1$, attained only for $Phi_v = ZZ slash 3$ (types $"IV"$, $"IV"^*$);
  #v(1mm)
  --- $ell = 2$: $dim W_v <= 2$, with equality exactly when $Phi_v tilde.equiv (ZZ slash 2)^2$,
  i.e. type $"I"_n^*$ with $n$ *even*.

  #v(2mm)
  _Proof._ In the filtration $E_1 subset.eq E_0 subset.eq E_d (QQ_v)$, the formal group
  $E_1 (QQ_v)$ is pro-$v$, and $E_0 slash E_1 tilde.equiv tilde(E)^"ns" (bb(F)_v) = bb(F)_v^+$
  because the reduction is *additive* --- also of order a power of $v$. So $E_0 (QQ_v)$ is a
  pro-$v$ group, hence $ell$-divisible for $ell != v$, and $E_0 (QQ_v) slash ell = 0$. The exact
  sequence $E_0 slash ell -> E_d (QQ_v) slash ell -> Phi_v slash ell -> 0$ then gives the
  isomorphism. For the consequences, the component group of an additive fibre is trivial,
  $ZZ slash 2$, $ZZ slash 3$, $ZZ slash 4$, or $(ZZ slash 2)^2$, the last exactly for $"I"_n^*$
  with $n$ even; and $|Phi slash ell| = |Phi[ell]|$. $qed$
]

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Corollary.* For $ell$ odd and $v divides.not ell$, additive reduction gives $beta_v equiv 0$.

  #v(2mm)
  _Proof._ For $ell >= 5$, $W_v = 0$. For $ell = 3$, $dim W_v <= 1$ and $beta_v$ is alternating
  (Lemma 3's hypothesis is automatic at odd $ell$), and an alternating form on a space of dimension
  $<= 1$ vanishes. $qed$
]

Putting this beside Lemma 1 and Theorem 5 settles every place away from $ell$, for $ell$ odd:

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Theorem 8 (complete classification at $v divides.not ell$, $ell$ odd).* Let $ell >= 3$ and
  $v divides.not ell$. Then $v in Sigma_phi (d)$ *if and only if*
  #v(1mm)
  (a) $E_d$ has split multiplicative reduction at $v$; and
  #v(1mm)
  (b) $E_d [ell] subset.eq E_d (QQ_v)$; and
  #v(1mm)
  (c) $phi(C_"can" (v)) subset.eq.not C_"can" (v)$.

  #v(2mm)
  _Proof._ Good reduction is Lemma 1, additive reduction is the Corollary, non-split multiplicative
  reduction has $dim W_v <= 1$ --- the Tate parametrisation is only defined over the unramified
  quadratic extension, so $E_d [ell](QQ_v)$ cannot be everything --- and split multiplicative
  reduction is Theorem 5 together with Lemma 3 for the necessity of (b). $qed$
]

That is the sufficiency question answered outright for $ell$ odd, away from the wild place.

=== The remaining case: $ell = 2$, and the wild place <sec-dep-add2>

At $ell = 2$ Lemma 7 leaves additive places alive, with $W_v = Phi_v [2]$ of dimension 1 or 2. The
2-dimensional case is $Phi_v tilde.equiv (ZZ slash 2)^2$, type $"I"_n^*$ with $n$ even. For
$n >= 2$ that is potentially multiplicative and @sec-dep-ram applies; the genuinely new case is
$"I"_0^*$ with $c_v = 4$, which is potentially *good*. There the answer is as explicit as Theorem 5:

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Proposition 9.* Let $ell = 2$, $v$ odd, $f = (x - e_1)(x - e_2)(x - e_3)$ with $E_d$ of type
  $"I"_0^*$ at $v$ and $c_v = 4$. Then $W_v = Phi_v$ is generated by the images of the three
  2-torsion points, so $beta_v$ is computed from the *root differences* alone:
  $ c_i (T_j) = e_j - e_i quad (j != i), quad quad
    c_i (T_i) = product_(k != i) (e_i - e_k), $
  and $beta_v (T_j, T_k) = (c_a (T_j), c_b (T_k))_v$ for $phi$ with stable lines $a$, $b$. No point
  search is involved.
]

`additive.gp` checks this against a direct search: on $x(x-5)(x+5)$ at 5, $x(x-7)(x+7)$ at 7,
$x(x-3)(x+3)$ at 3 and $x(x-11)(x+11)$ at 11, for all three rank-one $phi$ each, the images and the
symbol counts agree exactly, and *these places are live*. So an additive place really can carry the
obstruction at $ell = 2$ --- Theorem 8 has no analogue there.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *Why the wild place is different, in one line.* Lemma 7 needs $v divides.not ell$ so that the
  formal group is prime to $ell$. At $v = ell$ the formal group is pro-$ell$ and contributes
  *everything*. That is why $x^3 - 2$ is live at $v = 3$ on a type $"II"$ fibre with $c_v = 1$,
  where $Phi_v slash 3 = 0$: its $W_3$ is entirely formal-group. The wild place is the only place
  at which $W_v$ sees the formal group at all, and no argument in this chapter reaches it.
]

== Corollary 6 in the field: six new surfaces <sec-dep-new>

Theorem 8 makes the search for obstructed surfaces mechanical. To get a *single* critical prime,
add one condition to Corollary 6:

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  Let $ell$ be odd, $phi$ non-scalar, and suppose
  #v(1mm)
  (i) $E[ell]$ is *decomposable*, so a rank-one $phi$ exists. With exactly two rational
  $ell$-lines both are $phi$-stable, so condition (c) says *no rational line is canonical* at $v$;
  #v(1mm)
  (ii) $ell divides.not N_E$, so $E$ has good reduction at $ell$ and Lemma 1(b) kills the wild
  place --- the one place Theorem 8 does not reach;
  #v(1mm)
  (iii) exactly one bad prime $p$ passes (a), (b), (c) of Theorem 8.
  #v(1.5mm)
  Then $Sigma_phi (d) = {p}$ for every squarefree $d$ in the class that (a) selects, and *for every
  $d$ whatever in that class*, since a place is live only in its split class and the others fail
  (b) or (c) there. Reciprocity gives $beta_p equiv 0$ on rational pairs, and @sec-class-warning
  gives that $X(QQ)$ is not dense in $X(QQ_p)$.
]

`corollary6.gp` runs this. Since $E[3]$ decomposable is rare in a naive box --- twelve curves in
$|A|, |B| <= 60$ --- the scan runs over the universal curve with a rational 3-torsion point,
$y^2 + a x y + b y = x^3$, with $|a|, |b| <= 40$. It finds *eight* curves satisfying (i) and (ii),
and *all eight* satisfy (iii). Two of them are already in this document, `14a1` and `19a1`; the
other six are new. At $ell = 5$ the same search over the Tate normal form carrying a point of order
5 returns exactly one curve --- conductor 11, that is `11a1`, the case of @sec-11a1, rediscovered
and alone in its range.

#align(center, table(
  columns: 4, align: (center, left, center, center),
  stroke: 0.4pt + luma(170), inset: (x: 7pt, y: 3.5pt),
  table.header([$N_E$], [$f$, for $X : y^2 = f(x) f(t)$], [critical $p$], [class]),
  [26],  [$x^3 + x^2 - 72x - 496$],     [13], [$[1]$],
  [35],  [$x^3 + 4x^2 + 144x + 80$],    [7],  [$[1]$],
  [37],  [$x^3 + 4x^2 - 368x - 3184$],  [37], [$[1]$],
  [38],  [$x^3 + x^2 + 152x + 5776$],   [19], [$[1]$],
  [91],  [$x^3 + 4x^2 + 208x + 2704$],  [13], [$[1]$],
  [370], [$x^3 + x^2 - 296x + 21904$],  [37], [$[1]$],
  table.hline(),
  [23808], [$x^3 - 4x^2 + 30608x - 5474624$],  [31], [$[u]$],
  [18176], [$x^3 + 4x^2 - 69104x - 6427840$],  [71], [$[u]$],
))

#v(2mm)

The last two are at $ell = 5$ and come from a different search, described in @sec-dep-howmany:
quadratic twists give the *same* surface, so the parameter is $j$, and one scans the genus-0
Hauptmodul of $X_0(ell)$ for the $j$ whose curves have decomposable $E[ell]$. Note that their live
class is $[u]$, not $[1]$ --- the class prediction is doing real work.

#v(2mm)

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Theorem 10.* For each surface in the table, at level $ell = 3$, and for *every* squarefree $d$
  in the class $[1]$ of $QQ_p^times$, the pairing $beta_p$ vanishes on
  $E_d (QQ) times E_d (QQ)$. Hence $X(QQ)$ is not dense in $X(QQ_p)$.

  #v(2mm)
  _Proof._ Theorem 8 at every $v divides.not 3$, Lemma 1(b) at $v = 3$ (good reduction, since
  $3 divides.not N_E$), Lemma 2 at $infinity$ and the $q divides d$. So $Sigma(d) = {p}$,
  reciprocity forces $beta_p equiv 0$ on rational pairs, and $beta_p$ is non-degenerate on $W_p$ by
  Theorem 5. Apply @sec-class-warning. $qed$
]

=== How many are there, and why $ell = 7$ is empty <sec-dep-howmany>

The right parameter is the $j$-invariant, not the curve: quadratic twists give the *same* Kummer
surface, since $f_d (x) = d^3 f(x slash d)$ and the substitution $x = d u$, $t = d w$ turns
$y^2 = f_d (x) f_d (t)$ into $y^2 = d^6 f(u) f(w)$. So the question is how many $j$ carry a
non-scalar $phi$.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *For $ell$ odd, a non-scalar $phi$ forces $E[ell]$ decomposable or a non-split Cartan image.*
  If $E[ell]$ is reducible and indecomposable with sub- and quotient characters $alpha != beta$
  then $"End"_G$ is scalar; and $alpha = beta$ would force $alpha^2 = chi_"cyc"$, impossible,
  because $chi_"cyc"$ is *surjective* onto $bb(F)_ell^times$ while every square lands in the
  subgroup of index 2. (At $ell = 2$ that obstruction is vacuous, which is why the indecomposable
  case of @sec-tk-indec exists there and not here.)
]

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Decomposable $E[ell]$ forces $ell <= 5$.* Let $E[ell] = C_1 xor C_2$ and $E_1 = E slash C_1$.
  Then $ker hat(psi)_1 = psi_1 (C_2)$, so the composite
  $ E_1 -->^(hat(psi)_1) E -->^(psi_2) E slash C_2 $
  has kernel $hat(psi)_1^(-1)(C_2)$, of order $ell^2$; and it is *cyclic*, since
  $hat(psi)_1 (E_1 [ell]) = ker psi_1 = C_1 != C_2$ means the kernel is not $E_1 [ell]$. So $E_1$
  carries a rational cyclic $ell^2$-isogeny, and by Mazur and Kenku the rational cyclic isogeny
  degrees are at most 19 together with $21, 25, 27, 37, 43, 67, 163$. Hence
  $ell^2 in {4, 9, 25}$ and $ell in {2, 3, 5}$.
]

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *So $ell = 7$ is empty, and there is nothing to search for.* The computation agrees: scanning
  2066 distinct $j$ on the Hauptmodul of $X_0 (7)$ turns up *no* curve with $E[7]$ decomposable.
  The remaining loophole is a non-split Cartan image mod 7, which would give
  $"End"_G (E[7]) = bb(F)_49$ and a non-scalar --- indeed invertible --- $phi$; nothing in
  @sec-dep-suff needs $phi$ to have rank one, so Theorem 5 would apply. But a scan of 2596 curves,
  testing whether $a_p^2 - 4p$ is a non-square modulo 7 at every good $p <= 200$, finds *none*
  compatible with such an image. We have not pursued it further.
]

For $ell = 3$ and $ell = 5$, by contrast, the supply is *infinite*: $X_0 (9)$ and $X_0 (25)$ both
have genus 0, so there are infinitely many $j$ carrying a rational cyclic $ell^2$-isogeny, and the
middle curve of each chain has $E[ell]$ decomposable. Whether infinitely many of *those* have
exactly one critical prime we have not proved --- it asks that all but one bad prime fail (a), (b)
or (c) --- but the observed yield is high: at $ell = 3$, all eight curves in the search range that
satisfy the hypotheses have exactly one, and at $ell = 5$, three of the four $j$ found do (the
fourth, $N = 550$, is excluded only because $5 divides N$ leaves its wild place uncovered).

#align(center, table(
  columns: 4, align: (center, center, center, left),
  stroke: 0.4pt + luma(170), inset: (x: 7pt, y: 3.5pt),
  table.header([$ell$], [$X_0 (ell^2)$], [supply of $j$], [found here]),
  [3], [genus 0], [infinite], [8 curves in the scan range, *all* with one critical prime],
  [5], [genus 0], [infinite], [4 $j$ in 2066 on $X_0 (5)$; 3 usable, all with one critical prime],
  [7], [no rational cyclic 49-isogeny], [*empty*], [none, and none possible],
))

=== The experiment <sec-dep-newcheck>

Nothing above involved a rational point. The prediction is therefore a genuine one, and
@sec-result's search is the way to test it: run it on the six surfaces over all 45 odd primes
$p <= 200$ and the eight square classes at 2, with the parameters of @sec-summary, and see whether
the witnesses fail exactly where they are predicted to.

#align(center, table(
  columns: 5, align: (center, center, center, center, left),
  stroke: 0.4pt + luma(170), inset: (x: 7pt, y: 3.5pt),
  table.header([$N_E$], [predicted], [odd primes full], [prime that falls short], [classes there]),
  [26],  [13 in $[1]$], [44 of 45], [*13*], [3 of 4 --- $[1]$ missing],
  [35],  [7 in $[1]$],  [44 of 45], [*7*],  [3 of 4 --- $[1]$ missing],
  [37],  [37 in $[1]$], [44 of 45], [*37*], [3 of 4 --- $[1]$ missing],
  [38],  [19 in $[1]$], [44 of 45], [*19*], [3 of 4 --- $[1]$ missing],
  [91],  [13 in $[1]$], [44 of 45], [*13*], [3 of 4 --- $[1]$ missing],
  [370], [37 in $[1]$], [44 of 45], [*37*], [3 of 4 --- $[1]$ missing],
  table.hline(),
  [23808], [31 in $[u]$], [44 of 45], [*31*], [3 of 4 --- $[u]$ missing],
  [18176], [71 in $[u]$], [44 of 45], [*71*], [3 of 4 --- $[u]$ missing],
))

#v(2mm)

Eight predictions, eight confirmations: in each case the search witnesses all four square classes at
every odd prime up to 200 *except* the predicted one, where it witnesses three and misses exactly
the predicted class --- $[1]$ for the six at $ell = 3$, $[u]$ for the two at $ell = 5$. The critical prime and the class were read off the conductor, the discriminant and
the isogeny class before any point was looked for.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  One row needed a second look. At $p = 2$ five of the six surfaces cover all eight classes at
  once, but $N_E = 38$ reported $6 slash 8$. Theorem 8 says $p = 2$ *cannot* be critical at
  $ell = 3$, since full rationality of $E_d [3]$ over $QQ_2$ would need $zeta_3 in QQ_2$; so this
  had to be search depth rather than an obstruction. Raising the bound from $300$ to $4000$ returns
  $8 slash 8$. The theory said where to look, and what to expect to find.
]

=== Additive at the critical prime <sec-dep-addex>

Theorem 8's hypothesis (a) is about $E_d$, not about $E$, and @sec-dep-ram showed that when $E$ is
of type $"I"_n^*$ --- additive, but *potentially multiplicative* --- the class making $E_d$ split
is the *ramified* one. None of the eight surfaces above is presented that way: all eight have their
critical class among $[1]$ and $[u]$. Twisting the defining cubic by its own critical prime,
$ f_p (x) = p^3 f(x slash p), $
gives the *same* Kummer surface in a model where $E$ is additive at $p$, and the critical class
must move to $[p]$ or $[u p]$.

#align(center, table(
  columns: 5, align: (left, center, center, center, center),
  stroke: 0.4pt + luma(170), inset: (x: 7pt, y: 3.5pt),
  table.header([$f$ after twisting], [$ell$], [type at $p$], [predicted class], [search]),
  [$x^3 + 28x^2 + 7056x + 27440$], [3], [$"I"_3^*$ at 7], [$[7]$], [44/45, misses $[7]$ at 7],
  [$x^3 + 13x^2 - 12168x - 1089712$], [3], [$"I"_3^*$ at 13], [$[13]$],
    [44/45, misses $[13]$ at 13],
  [$x^3 + 148x^2 - 503792x - 161279152$], [3], [$"I"_3^*$ at 37], [$[37]$],
    [44/45, misses $[37]$ at 37],
  [$x^3 + 284x^2 - 348353264x - 2300594642240$], [5], [$"I"_5^*$ at 71], [$[u dot 71]$],
    [44/45, misses $[u dot 71]$ at 71],
))

#v(2mm)

(The $ell = 5$ row first reported $7 slash 8$ at $p = 2$; Lemma 3 forbids 2 from being critical
there, since $zeta_5 in.not QQ_2$, so it had to be search depth, and raising the bound to
$M_2 = 6000$ gives $8 slash 8$ --- the same episode as in @sec-dep-newcheck.)

Four for four, and the last is the sharpest: the recipe named the *fourth* of the four classes,
$[u dot 71]$ rather than $[71]$, and that is the one the search misses. Since a surface and its
twists are the same surface, these are the same four surfaces as before in different models --- so
what is being tested is not a new obstruction but @sec-dep-ram itself, together with the
class-label transport of @sec-verify: change the model, and the obstruction reappears in the class
the recipe says it should.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *At odd $ell$ that is the only way an additive critical place arises.* By Lemma 7 a place with
  *potentially good* additive reduction has $dim W_v <= 1$ at $ell = 3$ and $W_v = 0$ for
  $ell >= 5$, so it is dead. Hence every critical place at odd $ell$ has $v(j) < 0$, and whether
  its model shows multiplicative or additive reduction is a choice of twist. Genuinely additive
  critical places --- potentially good, with no twist making them multiplicative --- exist only at
  $ell = 2$, where they are the $"I"_0^*$ fibres with $c_v = 4$ of Proposition 9, and Corollary 6
  does not reach them.
]

== Level 2, and why the norm lemma cannot be repaired <sec-dep-l2>

@sec-dep-gaps left two things at $ell = 2$: the degenerate additive case $dim W_v = 1$, and the
places $infinity$ and $q divides d$, which Lemma 2 does not reach. Both turn on whether $beta$ is
alternating, and for *split* $f$ it is not.

=== The norm lemma is false when $f$ splits <sec-dep-normfail>

The norm lemma controls $(c(P), c(P))_v = (c(P), -1)_v$, and that is the diagonal of $beta$ *only
when both slots carry the same descent map* --- that is, in the indecomposable case of
@sec-tk-indec, where $phi = N$ has $ker N = "im" N$. When $f$ splits, the rank-one $phi$ has
$ker phi = C_a$ and $"im" phi = C_b$ with $a != b$, and the diagonal is
$ beta_v (P,P) = (c_a (P), c_b (P))_v , $
which no norm condition touches. It is genuinely non-zero: for $f = x(x-5)(x+5)$ at $v = 5$, two of
the three 2-torsion points have $beta_v (P,P) != 0$, for either choice of $phi$.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *The right statement at $ell = 2$.* Isotropy of $L_v$ gives
  $(c_a (P), c_b (Q))_v = (c_b (P), c_a (Q))_v$, so $beta_v$ is *symmetric*, and
  $q_v (P) = beta_v (P,P)$ is a *quadratic refinement* of it. "Alternating" is the special case
  $q_v equiv 0$, which the indecomposable case gets from the norm lemma and the split case does
  not.
]

Two consequences. Lemma 3's dimension bound *fails* for split $f$: a 1-dimensional $W_v$ can be
live, through the diagonal alone. That is exactly what happened at $infinity$ for `15a1`'s second
$phi$ in @sec-dep-15a1, where $beta_infinity != 0$ on a 1-dimensional space. And the places
$q divides d$ need a criterion of their own.

=== What replaces it at $q divides d$ <sec-dep-l2qd>

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Lemma 11.* Let $f = (x-e_1)(x-e_2)(x-e_3)$ have integer roots and let $phi$ have
  $ker phi = C_a$, $"im" phi = C_b$. Then $beta_q equiv 0$ for *every* odd prime $q divides d$ with
  $q divides.not 2 "disc" f$ if and only if
  $ f'(e_a) quad "and" quad f'(e_b) quad "are both perfect squares." $

  #v(2mm)
  _Proof sketch._ At such a $q$ the twist is ramified, so $E_d$ has type $"I"_0^*$ with $c_q = 4$
  and Proposition 9 applies: $W_q$ is generated by the 2-torsion and every symbol is one of root
  differences. Writing $u = e_a - e_b$, $v = e_a - e_c$, $w = e_b - e_c$, the nine symbols reduce
  to: the pair $(T_b, T_a)$, which is $(x, -x)_q = 1$ by Steinberg; four which repeat
  $f'(e_a) = u v$ and $f'(e_b) = -u w$; and the rest, which repeat those two again because
  $f'(e_a) f'(e_b) f'(e_c) = -(u v w)^2$. Dirichlet then upgrades "square modulo every such $q$" to
  "square". $qed$
]

Lemma C of @sec-15a1-local is the case of `15a1`: $f'(e_1) = 400$ and $f'(e_3) = 225$. Its second
$phi$ fails the test --- $f'(e_2) = -144$ --- which is precisely why $Sigma_(phi_B)$ of
@sec-dep-15a1 is large.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *And the family is Pythagorean again.* Order the roots $r_1 < r_2 < r_3$ and put
  $p = r_2 - r_1$, $q = r_3 - r_2$. The condition is that $p(p+q)$ and $q(p+q)$ be squares, whence
  $p q$ is a square; writing $p = g a^2$ and $q = g b^2$ it becomes $a^2 + b^2 = square$. And
  $beta_infinity$ vanishes for *every* $d$ exactly when the excluded root $e_c$ is the *middle*
  one, since on the egg of $E_d (RR)$ the two larger roots give negative $c_i$. `15a1` is the
  triple $(3,4,5)$: its root gaps are $9$ and $16$.
]

=== Why an additive critical place can never be isolated <sec-dep-noadd>

Genuinely additive live places do exist at $ell = 2$. For $f = x(x-3)(x-5)$ and
$phi = (c_1, c_3)$, the place $v = 13$ is live in the class $[13]$, on a fibre of type $"I"_0^*$
with $c_v = 4$ --- potentially *good*, so no twist makes it multiplicative, and Theorem 8 has
nothing to say. But such a place is never alone:

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  A potentially good additive fibre means the model is a ramified twist of one with good reduction.
  Rescaling $f$ by a square --- which does not change the surface --- returns a model in which the
  place is *good*, and the liveness reappears as a place $q divides d$. So an additive live place
  *is* a $q divides d$ place in another model, and those come as an infinite family indexed by the
  primes dividing $d$, all live or all dead together by Lemma 11. Since a surface-level statement
  needs them dead (@sec-class-warning), an additive place can never be the *only* live one.
]

The two models make this concrete. $x(x-507)(x-845)$ has $507 = 3 dot 13^2$ and $845 = 5 dot 13^2$,
so it is $169^3 tilde(f)(x slash 169)$ with $tilde(f) = u(u-3)(u-5)$ --- the same surface. In the
first model $v = 13$ carries a live $"I"_0^*$ fibre; in the second, 13 is not even a bad prime, and
the same liveness is the class $13 divides d$. Both models report conductor 480.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *So the honest summary at $ell = 2$.* The condition of Lemma 11 is what a surface-level theorem
  needs, and it kills the additive places along with the $q divides d$ ones --- for
  $f = x(x-63)(x-175)$, which satisfies it, the $"I"_0^*$ fibre at 7 is dead and the only live
  place is $v = 5$, of type $"I"_4$. Additive critical places at $ell = 2$ are therefore real but
  never isolated: they belong to obstructions whose set $S$ *depends on $d$*, which is exactly the
  situation @sec-class-warning cannot convert into a statement about $X$. That, and not the missing
  norm lemma, is what blocks a genuinely additive example.
]

== What is proved, and what is not <sec-dep-gaps>

*Proved.* The criterion of @sec-dep-crit; Lemmas 1, 2 and 3; the square-class corollary of
@sec-dep-class; and --- at a Tate place --- Lemma 4, Theorem 5 and Corollary 6. Together these give
both directions where it counts:

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  For $v divides.not ell$ with $E_d$ *split multiplicative* and $E_d [ell]$ fully rational over
  $QQ_v$,
  $ beta_v equiv.not 0 quad <==> quad phi(C_"can") subset.eq.not C_"can" , $
  and when it is non-zero it is non-degenerate. Outside that hypothesis the recipe is proved only
  as a *necessary* condition.
]

*Level 2 is now understood too, and negatively.* @sec-dep-l2 shows the norm lemma is *false* when
$f$ splits, so $beta$ is symmetric with a quadratic refinement rather than alternating; Lemma 11
replaces it at the places $q divides d$; and @sec-dep-noadd shows that the condition a
surface-level theorem needs kills the additive places along with the $q divides d$ ones. Additive
critical places at $ell = 2$ are real but never isolated.

*What the remaining gap actually is.* @sec-dep-add closed the additive case away from $ell$:
Lemma 7 computes $W_v$ there as the component group mod $ell$, which kills every additive place at
odd $ell$ and leaves, at $ell = 2$, only $Phi_v tilde.equiv (ZZ slash 2)^2$ --- handled by
@sec-dep-ram when the type is $"I"_n^*$ with $n >= 2$, and by Proposition 9, explicitly in root
differences, when it is $"I"_0^*$. So for $ell$ odd Theorem 8 is a complete answer at every
$v divides.not ell$, and at $ell = 2$ what is missing is the *degenerate* additive case
$dim W_v = 1$, where $beta_v$ can be non-zero only by failing to be alternating.

*The wild place is what is really left.* $v = ell$ is outside every argument here, for the reason
in @sec-dep-add2: it is the only place where the formal group survives into $W_v$. Both surfaces
whose obstruction sits there --- $x^3 - 2$ and $x^3 + x$ --- were settled by hand in @sec-cm, which
is evidence that the case is tractable but not a proof of anything general.

*Still not written out.* The identification of $C_"can" (v)$ by the discriminant valuations of the
$ell$-isogenous curves (Step 5) is used to *locate* the canonical line but is not needed for
Theorem 5, which takes $C_"can" (v)$ as given; it deserves a proof anyway, since it is what makes the
recipe mechanical.

*Still untouched.* Lemma 1(b) covers $v = ell$ only under good reduction; when $E$ is additive at
$ell$, as for $x^3 - 2$, nothing here applies. And at $ell = 2$ Corollary 6 needs @sec-tk-lemAB and
the norm lemma to handle $infinity$ and the $q divides d$, because Lemma 2 fails there.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *The $ell = 2$ caveat is not a formality.* @sec-dep-15a1 exhibits a $phi$ on `15a1` for which the
  recipe correctly reports that $3$ is critical, while $Sigma(d) = {infinity, 2, 3}$ --- so there
  is no obstruction at $3$ alone, and @sec-fail's search rightly witnesses that class. At $ell = 2$
  a one-element output of @sec-dep-recipe is a statement about *one* place being critical, never
  about the others being inert. Corollary 6 is stated for $ell >= 3$ for exactly this reason, and
  the honest level-2 statement needs the structural lemmas of @sec-toolkit alongside it.
]

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *What it buys.* Corollary 6 turns the search for obstructed surfaces into a finite check on
  reduction data: a bad prime $p equiv 1$ $(mod ell)$ where some twist is split multiplicative with
  full $ell$-torsion, and whose canonical line escapes $phi$. No local points, no descent, no
  symbols --- and no need to determine $Sigma(d)$, since one non-zero $beta_p$ inside a finite $S$
  is all an obstruction to weak approximation requires. Finding a *two-place* surface as in
  @sec-twoplace is then the same check run twice, which is what @sec-tp-screen had to sample points
  for.
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
