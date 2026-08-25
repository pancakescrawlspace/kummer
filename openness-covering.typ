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
  #text(size: 16pt, weight: "bold")[Approximability is open, and what that buys]
  #v(2mm)
  #text(size: 10pt)[Rank-zero twists are confined to a fixed nowhere-dense slice; the rest
  is an open cover of a compact group --- so density wants to be a *finite* condition]
  #v(1mm)
  #text(size: 9pt, style: "italic")[companion to $section 2.1$ of `kummer-padic-density.typ`;
  on an observation of René Pannekoek]
]

#v(4mm)

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *The one-line answer.* Yes: $H_d times H'_d$ is open in $E_delta (QQ_p) times E'_delta (QQ_p)$
  *exactly* when both twists have positive rank, so approximability is open *with the twist held
  fixed*. Rank-zero twists then contribute only inside a fixed nowhere-dense set and can be
  discarded outright. What survives is an open cover of a compact group, hence --- *if it is a
  cover* --- finite. The one step that does not follow formally is upgrading *dense* to
  *covering*: @sec-gap gives a counterexample for general open subgroups and two cases where the
  upgrade is valid.
]

= The question, as posed <sec-question>

#block(inset: (left: 12pt, y: 2pt), stroke: (left: 2pt + luma(190)))[
  #set text(size: 10pt)
  Now back to the non-diagonal Kummer surface of $E times E'$. I think we should use the
  decomposition of $X(QQ_p)$ as a finite disjoint union of groups of the form
  $E^delta (QQ_p) times E'^delta (QQ_p)$. Explicitly, this decomposition says that rational points
  are $p$-adically dense on $X$ if for every $delta$ in $QQ_p$ and every pair of points
  $P in E^delta (QQ_p)$ and $P' in E'^delta (QQ_p)$ there exists a $d$ in the same square class as
  $delta$ for which we can approximate the isomorphic images of $P$ and $P'$ arbitrarily well by
  rational points. Now I have the idea that this condition is _open_ in $X(QQ_p)$, and moreover
  that there exists an open set $U$ containing the point $(P, P')$ on the product $E times E'$,
  such that we can approximate every $(R, R')$ in $U$ by rational points on the same $E^d$. I hope
  you catch my drift; if not I should develop this thought further myself, and then resubmit.

  #v(1mm)
  #align(right)[#text(size: 9pt, style: "italic")[--- R. Pannekoek]]
]

#v(2mm)

The answer is that the drift is right, and that the openness is of the stronger kind: the
neighbourhood $U$ can be taken to be $H_d times H'_d$ itself, provided both twists have positive
rank. @sec-open and @sec-rank0 make this precise, @sec-compact draws the consequence, and
@sec-gap isolates the one step that does not follow formally.

= The setting <sec-setting>

Notation as in $section 2.1$ of the main notes. $X$ is the Kummer surface of $E times E'$, and for
a square class $delta in QQ_p^times slash (QQ_p^times)^2$ we write
$ G = E_delta (QQ_p) tilde.equiv ZZ_p times T, quad G' = E'_delta (QQ_p) tilde.equiv ZZ_p times T' , $
with $T, T'$ finite, and
$ H_d = overline(E_d (QQ)) subset.eq G, quad H'_d = overline(E'_d (QQ)) subset.eq G' $
for the closures of the rational points of the twists. The criterion there reads: $X(QQ)$ is dense
in $X(QQ_p)$ if and only if, for every $delta$,
$ A := union.big_(d |-> delta) H_d times H'_d quad "is dense in" quad G times G' . $

Each $H_d$ is a *closed subgroup* of $G$, being the closure of a subgroup. The observation below
is that these subgroups are of only two kinds.

= Approximability is open <sec-open>

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Proposition 1.* For a closed subgroup $H subset.eq G tilde.equiv ZZ_p times T$ the following
  are equivalent: (i) $H$ is open; (ii) $H$ is infinite; (iii) $H$ is not contained in $T$.

  In particular $H_d$ is open in $G$ if and only if $"rank" E_d (QQ) >= 1$, and otherwise
  $H_d = E_d (QQ)_"tors" subset.eq T$.

  #v(2mm)
  _Proof._ (i) $=>$ (ii) is clear, $G$ being infinite. For (ii) $=>$ (i): the projection
  $H --> T$ has kernel $H inter ZZ_p$, so $[H : H inter ZZ_p] <= |T| < infinity$ and $H$ infinite
  forces $H inter ZZ_p$ infinite. A closed infinite subgroup of $ZZ_p$ is $p^m ZZ_p$ for some
  $m$, and $p^m ZZ_p times \{0\}$ is open in $ZZ_p times T$ because $T$ carries the discrete
  topology. So $H$ contains an open subgroup and is therefore open. (ii) $<==>$ (iii) is the
  observation that the torsion subgroup of $G$ is exactly $T$, which is finite. $qed$
]

#v(2mm)

Consequently, for a pair:

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Corollary 2.* $H_d times H'_d$ is open in $G times G'$ if and only if
  $ "rank" E_d (QQ) >= 1 quad "and" quad "rank" E'_d (QQ) >= 1 . $
  When this holds, $U = H_d times H'_d$ is itself an open neighbourhood of each of its points: for
  *every* $(R, R') in U$, and not merely for the point one started from, $R$ and $R'$ are
  simultaneously approximable by rational points of the *same* twist $E_d, E'_d$.
]

This is the strong form of the idea. It is not only that the set of approximable pairs is open;
it is open *with the twist held fixed*, which is what makes a finite certificate conceivable at
all.

= Rank-zero twists are confined <sec-rank0>

The gain is that the deficient twists all fail in the *same place*.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Corollary 3.* Put
  $ A^+ = union.big_(d |-> delta, thin "both ranks" >= 1) H_d times H'_d , quad
    Z = (T times G') union (G times T') . $
  Then $A^+$ is open, $A without A^+ subset.eq Z$, and $Z$ is closed and nowhere dense. Hence
  $ A "is dense in" G times G' quad <==> quad A^+ "is dense in" G times G' . $

  #v(2mm)
  _Proof._ If $"rank" E_d (QQ) = 0$ then $H_d subset.eq T$ by Proposition 1, so
  $H_d times H'_d subset.eq T times G' subset.eq Z$; symmetrically on the other factor. $Z$ is a
  finite union of sets of the form $\{t\} times G'$ and $G times \{t'\}$, each closed with empty
  interior, so $Z$ is closed and nowhere dense. On the dense open set $(G times G') without Z$ the
  sets $A$ and $A^+$ therefore coincide, and a set is dense iff its intersection with a fixed
  dense open set is dense there. $qed$
]

The point is that $T$ and $T'$ are *fixed*: they do not vary with $d$. A rank-zero twist does not
merely contribute a small set, it contributes inside a slice that no amount of varying $d$ can
move. So rank-zero twists can be discarded from the criterion altogether --- which is also the
condition the search of $section 7$ already imposes, now with a reason rather than as a
convenience.

= Compactness: density wants to be finite <sec-compact>

$G times G'$ is compact, and $A^+$ is a union of open sets. Hence:

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Corollary 4.* $A^+ = G times G'$ if and only if there are *finitely many* rational
  $d_1, dots.h, d_r in delta$ with
  $ union.big_(i = 1)^r H_(d_i) times H'_(d_i) = G times G' . $
  Each of the finitely many conditions is a finite computation, by the local test of $section 2.2$.
]

That is the prize: a certificate of the same shape as the ones in $section 4$, but for the
non-diagonal surface, and *without* requiring any single twist to be full. The counterexample
configuration of $section 2.1.1$ --- three twists whose closures are the three index-$2$ subgroups
$M_1, M_2, M_3$ of $G$, each with $H'_(d_i) = G'$ --- is precisely such a cover, since
$M_1 union M_2 union M_3 = G$. Restated this way it stops being a pathology and becomes a
certificate.

= The gap: dense does not formally imply covering <sec-gap>

Corollary 3 gives *$A^+$ dense*; Corollary 4 needs *$A^+$ everything*. These are not the same, and
the implication does not follow from openness alone.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *A dense union of open subgroups need not be the whole group.* In $ZZ_p^2$ consider
  $ V = \{a equiv 0 space (mod p)\}, quad
    W_c = \{b equiv c a space (mod p)\}_(c equiv.not 0), quad
    W^((k))_e = \{b equiv e p^(k-1) a space (mod p^k)\}_(e equiv.not 0) . $
  Every one of these is an open subgroup. Their union misses $(1, 0)$ --- indeed misses exactly
  $ZZ_p^times times \{0\}$ --- yet it is dense, because $(1, p^(k-1)) in W^((k))_1$ for every $k$
  and $p^(k-1) --> 0$.
]

The mechanism is worth naming: *the subgroups get deeper as they get closer*. An open subgroup $H$
with $p^m$ the exponent of $G slash H$ satisfies $"dist"(g, H) > p^(-m)$ whenever $g in.not H$, so
approximation to within $p^(-m)$ does force membership --- but only for that $H$. If the index is
allowed to grow with the precision, arbitrarily good approximation never upgrades to membership.

Checked mod $3^7$:

```python
p, N = 3, 7
subs  = [lambda a,b: a % p == 0]                                     # V
subs += [(lambda c: lambda a,b: (b - c*a) % p == 0)(c) for c in (1,2)]
subs += [(lambda k,e: lambda a,b: (b - e*p**(k-1)*a) % p**k == 0)(k,e)
         for k in range(2, N+1) for e in (1,2)]

# subgroups containing (1,0):                     NONE
# elements of (Z/p^N)^2 in no subgroup:           1458
#   ... of them NOT of the form (unit, 0):        0
# (1,3) in W^(2)_1, (1,9) in W^(3)_1, (1,27) in W^(4)_1, ...   -> dense at (1,0)
```

== Two cases where the upgrade is valid <sec-gap-ok>

The counterexample uses subgroups that are *not products*: the $W$'s are graphs, not rectangles.
The sets occurring in @sec-setting are products $H_d times H'_d$, and that restriction is what one
has to exploit. Two cases are settled.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *(a) $G$ and $G'$ procyclic.* Then $A$ dense $=>$ some single $d$ has $H_d = G$ and
  $H'_d = G'$, so certainly $A^+ = G times G'$. This is the necessity argument of
  $section 2.1.1$: choose topological generators, use that $Phi(G)$ is open, and conclude by the
  Frattini property.

  #v(2mm)
  *(b) $p divides.not |T|$ (and likewise for $T'$).* Let $H subset.eq G$ be open with
  $H inter ZZ_p = p^m ZZ_p$, and let $(w, tau) in H$ with $tau$ of order $e$ in $T$. Then
  $e (w, tau) = (e w, 0) in p^m ZZ_p$, and $e$ is prime to $p$, so $w in p^m ZZ_p$. Hence every
  element of $H$ over the torsion component $tau$ has its $ZZ_p$-part in $p^m ZZ_p$, and for
  $g = (z, tau)$ with $z$ a unit one gets $"dist"(g, H) in \{0, |z|\}$ --- nothing in between.
  The deepening trick of @sec-gap is therefore unavailable, and approximation does force
  membership.
]

== What is open <sec-gap-open>

Unsettled: whether $union.big_d H_d times H'_d$ dense forces $A^+ = G times G'$ when $p$ divides
$|T|$ or $|T'|$. I do not want to assert it either way. Note that $p divides |T|$ means
$E_delta (QQ_p)$ has a rational point of order $p$; for $p > 2$ the Weil pairing forces the
$p$-part of $T$ to be *cyclic* ($section 2$ of the main notes), so the failure mode, if there is one, is narrow.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Status.*

  #v(1mm)
  #set enum(numbering: "(A)")
  + $H_d times H'_d$ open $<==>$ both ranks positive. *Proved* (Prop. 1, Cor. 2).
  + Rank-zero twists confined to a fixed nowhere-dense $Z$; they may be discarded. *Proved*
    (Cor. 3).
  + $A^+ = G times G'$ $<==>$ a *finite* set of twists covers. *Proved* (Cor. 4), by compactness.
  + $A$ dense $=>$ $A^+ = G times G'$. *Proved* when $p divides.not |T| |T'|$, which includes the
    procyclic case. *Open* in general; false for unions of open subgroups that are not products.
]

= The cost of substituting a sufficient condition <sec-sound>

Something happens the moment one stops testing density $P$ itself and starts testing a sufficient
condition $Q$ instead --- here, "a finite set of twists covers", or in the main notes "a single
twist is full". It is worth stating in general, because it is automatic and it recurs.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *The principle.* Let $Q ==> P$ and search for a witness of $Q$. Then the search
  - *is sound and complete for $Q$*: it halts exactly when $Q$ holds --- a perfect recogniser,
    a genuine semi-decision procedure for $Q$;
  - *is sound but incomplete for $P$*: $P$ may hold while $Q$ fails, and then it runs forever.

  The relativity is the whole point. On an instance where $P$ is true and $Q$ false the search
  never halts --- and is *right* not to, since $Q$ really is false. So incompleteness is not a
  defect of the algorithm, which is doing its job exactly; it is a property of the *substitution*
  $P |-> Q$, and it is invisible from inside a run, because "no witness yet" and "no witness
  exists" are the same observed behaviour. A failed search therefore never licenses "$P$ is
  false" --- nor even "$Q$ is false", until one waits forever.
]

The only escape is to prove $Q <==> P$. Then the search becomes a semi-decision procedure for $P$
itself, still non-terminating on the no-instances, but now a failed search is at least *evidence*
of non-density rather than no information at all. That is the whole value of the equivalence in
$section 2$ of the main notes, and the reason the residual failure at $p = 3$ in $section 5.1.2$
could be pursued as a real obstruction rather than dismissed as a search that had not run long
enough.

Within this note the split is clean: @sec-compact is $Q$, @sec-gap is the gap $P without Q$.

#v(2mm)

Three places in these notes currently sit on the wrong side of it, and all for one reason. The
Kummer construction returns a fixed number of points per twist, and $Q <==> P$ survives exactly
while the local group needs no more topological generators than that:

#align(center)[
#table(columns: (auto, auto, auto, 1fr), align: (left, center, center, left),
  stroke: 0.4pt + luma(160), inset: (x: 6pt, y: 4pt),
  table.header([case], [budget], [needs], [status]),
  [diagonal, $p > 2$], [$2$], [$r(G) <= 2$ always],
    [$Q <==> P$ --- $section 2$],
  [diagonal, $p = 2$, full $2$-torsion], [$2$], [$r(G) = 3$],
    [$Q ==> P$ only; occurs iff $f$ splits completely over $QQ_2$],
  [non-diagonal $E times E'$], [$1$ per curve], [$r(G) = r(G') = 1$],
    [$Q ==> P$ only unless both procyclic --- $section 2.1.1$],
  [$S$-adic, generic], [$2$], [$r(G_S) <= 2$],
    [$Q ==> P$ only when $G_S$ is not $2$-generated --- $section 2.3$],
)]

#v(2mm)

In the diagonal case both coordinates of a rational point of $X$ land in the *same* group, so one
twist yields a pair, hence two generators; at $p = 2$ with full $2$-torsion
$G tilde.equiv ZZ_2 times (ZZ slash 2)^2$ needs three and the pair falls short. For $E != E'$ the
coordinates land in *different* groups and the budget is one generator per curve. For $S$-adic
density the budget is two again, but $G_S = product_(p in S) E_d (QQ_p)$ can need more, and the
two-generator lemma of $section 2.3$ says exactly when.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *What is and is not claimed.* In each of the three cases what is established is that the
  *necessity argument* fails --- the generator count runs out --- which is enough to lose completeness
  *for $P$*, since one can no longer certify $Q <==> P$. Whether $Q$ is genuinely strictly
  weaker is a further question; only for the $S$-adic case do the notes assert an outright
  equivalence with $2$-generation ($section 2.3$). For $p = 2$ with full $2$-torsion and for the
  non-diagonal surface no counterexample is exhibited, here or there; @sec-gap gives the
  group-theoretic configuration that would produce one. Soundness is unconditional throughout.
]
