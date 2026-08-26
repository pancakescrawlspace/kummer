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

= The covering check itself <sec-check>

Corollary 4 turns density into "some finite set of twists covers $G times G'$". This section asks
what kind of problem that is. The answer is that it is entirely finite, classical, and cheap ---
the difficulty in @sec-sound lies elsewhere.

Throughout, $frak(g)$ is an abelian profinite group, topologically finitely generated, and
$A_1, dots.h, A_m subset.eq frak(g)$ are closed subgroups of finite index. In the application
$frak(g) = G times G'$ and $A_i = H_(d_i) times H'_(d_i)$, which are of finite index precisely by
Corollary 2.

== The profiniteness is illusory <sec-check-finite>

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Reduction.* Put $N = inter.big_i A_i$, an open subgroup, and $pi : frak(g) --> frak(g) slash N$.
  Every $A_i$ contains $N$, so $A_i = pi^(-1) (pi(A_i))$ and
  $ union.big_i A_i = frak(g) quad <==> quad union.big_i pi(A_i) = frak(g) slash N . $
]

So the question is: *can a finite abelian group be covered by a given finite list of subgroups?*
No topology survives the reduction. In particular the check is decidable outright, and everything
below is about representation and cost rather than about computability.

== What is known about covering a group by subgroups <sec-check-classical>

This is a classical subject --- Scorza, B. H. Neumann, Cohn, Tomkinson. Three facts are worth
having to hand.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *(i) Coverability.* $frak(g)$ is a union of *proper* subgroups if and only if it is not
  procyclic.

  #v(1.5mm)
  *(ii) Covering number.* If coverable, the least number of proper subgroups needed is
  $ sigma(frak(g)) = q + 1, quad
    q = min \{ ell "prime" : dim_(bb(F)_ell) frak(g) slash ell frak(g) >= 2 \} . $

  #v(1.5mm)
  *(iii) Neumann's lemma.* In an *irredundant* cover by $m$ subgroups, every index satisfies
  $[frak(g) : A_i] <= m$. Hence any $A_i$ of index $> m$ may be discarded, and the test iterated.
]

(iii) is the cheap pruning step and is often decisive on its own: if every $A_i$ has index
exceeding $m$, they cannot cover, whatever else is true. (ii) gives the matching lower bound on
how many twists could ever be needed.

When all the $A_i$ have the same prime index $ell$ there is a sharper statement, which
classifies the minimal covers and not merely their size. Suppose $frak(g)$ is elementary abelian,
$V = bb(F)_ell^d$, so that the subgroups of index $ell$ are exactly the linear hyperplanes
$A_i = ker chi_i$ with $chi_i in V^* without \{0\}$. Each $chi_i$ is determined up to scalar, so
it is a *point* $[chi_i]$ of the dual projective space $PP(V^*) = "PG"(d-1, ell)$.

Now dualise the covering condition. For $x != 0$,
$ x in A_i quad <==> quad chi_i (x) = 0 quad <==> quad [chi_i] in x^perp , $
where $x^perp subset PP(V^*)$ is the hyperplane dual to $[x]$; and as $[x]$ runs over $PP(V)$,
$x^perp$ runs over *every* hyperplane of $PP(V^*)$. So

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  $ union.big_i A_i = V quad <==> quad
    cal(B) = \{[chi_1], dots.h, [chi_m]\} "meets every hyperplane of" PP(V^*) , $
  that is, $cal(B)$ is a *blocking set with respect to hyperplanes* in $"PG"(d-1, ell)$.
]

*Bose--Burton (1966)* then says: the minimum *cardinality* of such a $cal(B)$ --- equivalently the
minimum *number of subgroups* $m$ --- is $ell + 1$, and a blocking set of that size is
necessarily the point set of a *line* of $PP(V^*)$.

The line lives in the *dual* space, which is the point that needs saying: its points are not
points of $V$, they *are* the subgroups. Unwinding, a line of $PP(V^*)$ is a $2$-dimensional
$W subset.eq V^*$, and its $ell + 1$ points are exactly the hyperplanes of $V$ containing
$U = W^perp$, a subgroup of *codimension $2$*. Such a family is a *pencil*, and it does cover,
because $V slash U tilde.equiv bb(F)_ell^2$ is covered by its $ell + 1$ lines.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *So, concretely.* At least $ell + 1$ subgroups of index $ell$ are needed, and the covers using
  exactly $ell + 1$ are *precisely* the pencils: all the index-$ell$ subgroups containing one
  fixed codimension-$2$ subgroup, one such cover for each choice of that subgroup. This is
  strictly more than fact (ii), which counts but does not classify. It also says that a minimal
  cover is *rigid* --- three index-$2$ twists that cover, as in $section 2.1.1$ of the main notes,
  have no choice but to be the three subgroups containing a common index-$4$ one.

  #v(1.5mm)
  Checked exhaustively for $ell = 2, 3$ and $d = 2, 3$: the minimum is $ell + 1$ in each case, and
  every minimal cover is a pencil --- there are $7$ of them for $ell = 2, d = 3$ and $13$ for
  $ell = 3, d = 3$, one per codimension-$2$ subspace.
]

== Two representations, and the check each affords <sec-check-rep>

A union of subgroups is not a subgroup and has no canonical group-theoretic normal form. Two
surrogates do the work.

*(a) The index profile.* Store $S |-> [frak(g) : inter.big_(i in S) A_i]$ for $S subset.eq [m]$.
Since $union.big_i A_i$ is closed and $frak(g)$ compact, full Haar measure forces equality, so

$ union.big_i A_i = frak(g) quad <==> quad
  sum_(nothing != S subset.eq [m]) (-1)^(|S|+1) / [frak(g) : inter.big_(i in S) A_i] = 1 . $

This is purely index-theoretic: no quotient need ever be formed. The cost is $2^m$ subgroup
intersections --- but $m$ here is the number of *distinct surviving* subgroups, which is far
smaller than the number of twists and is bounded independently of it. That is @sec-check-pare.

*(b) Per-prime types.* Write $frak(g) = product_ell frak(g)_ell$ for the primary decomposition.
Every closed subgroup splits along it, $A = product_ell A_ell$ with $A_ell = A inter frak(g)_ell$,
so membership is a *conjunction over primes*: $x in A_i$ iff $x_ell in A_(i, ell)$ for every
$ell$. Define the set of realisable types at $ell$,
$ cal(T)_ell = \{ thin t_ell (y) = \{ i : y in A_(i, ell) \} thin : thin y in frak(g)_ell \}
  subset.eq 2^([m]) . $

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Criterion.*
  $ union.big_i A_i = frak(g) quad <==> quad
    "for every" (t_ell) in product_ell cal(T)_ell : quad inter.big_ell t_ell != nothing . $

  #v(2mm)
  _Proof._ $x$ lies in $A_i$ iff $i in t_ell (x)$ for every $ell$, i.e. iff
  $i in inter.big_ell t_ell (x)$. So $x$ is missed by the union exactly when
  $inter.big_ell t_ell (x) = nothing$, and every type tuple is realised by some $x$. $qed$
]

This is the compact representation. One family of subsets per prime, and
$cal(T)_ell = \{[m]\}$ --- contributing nothing --- at every $ell$ where all
$A_(i,ell) = frak(g)_ell$, which is most of them. Read as logic, "is some element missed" is a
CNF with one clause per $i$ and one variable per prime, so the size of the check is governed by
the number of *bad* primes, not by $|frak(g) slash N|$.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *Verified.* Over 300 random finite abelian groups with 2--4 random subgroups each: that every
  subgroup equals the direct sum of its primary parts, that the inclusion--exclusion criterion of
  (a) agrees with brute force, and that the type criterion of (b) does too --- no discrepancies.
  Separately, $sigma(frak(g)) = q + 1$ was checked against exhaustive search on
  $2 times 2$, $3 times 3$, $4 times 2$, $6 times 6$, $2 times 2 times 2$, $9 times 3$,
  $5 times 5$, $12 times 2$, $4 times 4$, $10 times 10$ and the cyclic groups $6, 8, 15$.

  #v(1.5mm)
  Reproduce with the companion script `cover-check.py`.
]

== Paring the list: $m$ is not the parameter <sec-check-pare>

In practice one does not meet a handful of twists. Every $d$ for which $E_d$ and $E'_d$ both have
positive rank contributes an $A_i$, and there will be many such $d$. Left alone, $2^m$ is
hopeless. Three paring steps fix this, and all three are canonical.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *1. Deduplicate.* Many $d$ give the *same* subgroup $H_d times H'_d$. The object of interest is
  the *set* of distinct subgroups that occur, not the list of twists. Most of $m$ disappears here.

  #v(1.5mm)
  *2. Keep only the maximal elements.* If $A_i subset.eq A_j$ then $A_i$ can never be needed. An
  $O(m^2)$ pass of containment tests, cheap in Hermite normal form.

  #v(1.5mm)
  *3. Filter by index (Neumann).* A minimum cover is irredundant, so by fact (iii) of
  @sec-check-classical every member of a cover of size $k$ has $[frak(g) : A_i] <= k$. When
  searching at size $k$, discard everything of larger index.
]

Step 3 is what makes the problem small, because $frak(g)$ has few open subgroups of small index:

#v(2mm)
#align(center)[
#table(columns: 4, align: (left, right, right, right), stroke: 0.4pt + luma(170),
  inset: (x: 8pt, y: 3pt),
  table.header([open subgroups of index $<= k$], [$k = 3$], [$k = 5$], [$k = 50$]),
  [$ZZ_2^2$],    [$4$], [$11$], [$120$],
  [$ZZ_5^2$],    [$1$], [$7$],  [$38$],
  [$ZZ_47^2$],   [$1$], [$1$],  [$49$],
)]

#v(2mm)

So after steps 1--3 the candidate pool has size $nu(frak(g), k)$, *independent of the number of
twists*: the only dependence on $m$ anywhere is one linear deduplication pass.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Algorithm.* Compute $sigma(frak(g)) = q + 1$. For $k = q+1, q+2, dots.h$: restrict to the pool
  of index $<= k$ and test all $k$-subsets. The first success is a minimum cover.

  #v(2mm)
  Deciding whether a subcover of size $<= k$ exists is thus fixed-parameter tractable in $k$ ---
  time $O(m) + f(frak(g), k)$ --- and for fixed $frak(g)$ it is of constant size after
  preprocessing.
]

At the smallest possible $k$ this is nearly free. In the worst case $q = p$ one has $k = p + 1$,
and index $<= p+1$ leaves only index $1$ and index $p$, since $p^2 > p + 1$; so the pool is
$frak(g)$ together with the $p+1$ subgroups of index $p$, and choosing $p+1$ from $p+2$ is $p+2$
trials. When $q < p$ --- as at $p = 47$ with $T_1 tilde.equiv ZZ slash 30 times ZZ slash 2$, where
$q = 2$ and $k = 3$ --- it is smaller still.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *Canonical paring, non-canonical result.* Steps 1--3 are intrinsic. The *answer* is not:
  minimum covers are genuinely non-unique, and @sec-check-classical is the sharpest example ---
  for $ell = 2$, $d = 3$ there are exactly seven minimum covers, one per codimension-$2$
  subgroup, all of size $3$, with nothing to choose between them. What is canonical is the
  minimum *size*, and the *set of all* minimum covers. Singling out one requires a tie-break,
  which is a convention rather than mathematics.

  #v(1.5mm)
  *And a caveat on generality.* Stripped of its structure, "find a minimum subcover" is minimum
  set cover, which is NP-hard; no hardness theorem for the subgroup-restricted case is claimed
  here, and none is needed. What rescues the computation is not that the general problem is easy
  but that Neumann's bound and the finiteness of the subgroup lattice of $frak(g)$ collapse the
  instance before any search begins.

  #v(1.5mm)
  _Checked:_ the index bound of step 3 on 71 irredundant covers across nine abelian groups, no
  violations; and the pool sizes above. Both in `cover-check.py`.
]

== The structure of $frak(g) = ZZ_p^2 times T_1 times T_2$ <sec-check-ours>

Here $G tilde.equiv ZZ_p times T_1$ and $G' tilde.equiv ZZ_p times T_2$, so
$frak(g) = G times G' tilde.equiv ZZ_p^2 times T_1 times T_2$, and the structure helps twice.

First, the bad primes of @sec-check-rep(b) lie in
$\{p\} union \{ell : ell divides |T_1| |T_2|\}$ --- typically one to three of them, so the
combinatorial join is tiny.

Second, $dim_(bb(F)_p) frak(g) slash p frak(g) >= 2$ always, from the $ZZ_p^2$. So $frak(g)$ is
never procyclic, a cover by proper subgroups always exists in principle, and

$ sigma(frak(g)) = q + 1, quad
  q = min ( p, thin min \{ ell : dim T_1 slash ell + dim T_2 slash ell >= 2 \} ) <= p . $

The bound is sharp in the right place. At $p = 47$ with $T_1 tilde.equiv ZZ slash 30 times ZZ
slash 2$, the prime $2$ already gives $dim T_1 slash 2 = 2$, so $q = 2$ and $sigma = 3$: *three*
twists, not forty-eight. That is exactly the configuration of $section 2.1.1$ of the main notes,
now derived rather than exhibited.

For the $ZZ_p^2$ factor, represent open subgroups as lattices in Hermite normal form
$ mat(p^a, c; 0, p^b), $
so that intersections and indices are determinant arithmetic.

== Two different incompletenesses <sec-check-proc>

Enumerate twists, pare the list as in @sec-check-pare, and run the check of @sec-check-rep. By Corollary 4 this
halts if and only if $A^+ = G times G'$. So it is a genuine, *complete* semi-decision procedure
for $Q$ --- the object @sec-sound said we were entitled to.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *But the completeness is relative.* To form $H_d$ at all one needs $overline(E_d (QQ))$, hence
  the Mordell--Weil group, hence descent --- which is itself only sound and incomplete once Ш
  intervenes. So the honest statement is: *a complete semi-decision procedure for $Q$, relative to
  an oracle for Mordell--Weil groups.* The group theory of this section is fully effective; the
  arithmetic input is the part that can hang.

  #v(1.5mm)
  These are two different failure modes and should not be conflated. @sec-sound is about the gap
  $P without Q$ --- a cover may fail to exist although density holds. This one is about computing
  the $A_i$ in the first place. Neither implies the other, and only the first is intrinsic to the
  substitution.
]
