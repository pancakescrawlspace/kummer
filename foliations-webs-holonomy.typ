#set page(
  paper: "a4",
  margin: (x: 2.2cm, y: 2.4cm),
  numbering: "1",
)
#set text(size: 10.5pt, lang: "en")
#set par(justify: true, leading: 0.62em)
#set heading(numbering: "1.1")

#show heading.where(level: 1): it => block(above: 1.8em, below: 0.9em)[
  #set text(size: 14pt, weight: "bold")
  #counter(heading).display() #h(0.6em) #it.body
]
#show heading.where(level: 2): it => block(above: 1.3em, below: 0.65em)[
  #set text(size: 11.5pt, weight: "bold")
  #counter(heading).display() #h(0.6em) #it.body
]

#let box-note(title, body) = block(
  width: 100%,
  inset: 10pt,
  radius: 3pt,
  stroke: 0.6pt + luma(140),
  fill: luma(250),
  breakable: true,
)[
  *#title.* #body
]

#let slogan(body) = block(
  width: 100%,
  inset: (left: 12pt, top: 6pt, bottom: 6pt),
  stroke: (left: 2pt + luma(120)),
)[
  #emph[#body]
]

#align(center)[
  #text(size: 18pt, weight: "bold")[
    Foliations, Holonomy, Webs, and Local Dynamics
  ]

  #v(0.4em)
  #text(size: 11.5pt, style: "italic")[
    An expository article for algebraists and number theorists
  ]
]

#v(1.4em)

#box-note("What this is")[
  A self-contained introduction to the four notions that appeared in our
  discussion of orderings on a surface with two elliptic fibrations: *foliations*,
  *holonomy*, *web geometry*, and the *attracting/repelling classification of
  analytic germs*. No prior differential geometry is assumed. Wherever possible I
  give the algebraic definition first — as a condition on transition functions, or
  as an involutive subsheaf of a tangent sheaf — and reach for pictures only
  afterwards.

  The last section translates everything back into the setting of Parts I–IV.
]

#outline(depth: 2, indent: 1.2em)

#pagebreak()

= Foliations

== The algebraist's definition first

Let $X$ be a smooth variety (or complex manifold, or smooth real manifold — the
definition is the same in each category). Recall that the tangent sheaf $T_X$ is a
sheaf of $cal(O)_X$-modules equipped with a Lie bracket $[dot.op, dot.op]$, which
is $cal(O)_X$-bilinear only up to the Leibniz correction.

#box-note("Definition (foliation, algebraic version)")[
  A *foliation* $cal(F)$ on $X$ is a subsheaf $T_cal(F) subset.eq T_X$ which is

  + *coherent and saturated* (so $T_X slash T_cal(F)$ is torsion-free), and
  + *involutive*: $[T_cal(F), T_cal(F)] subset.eq T_cal(F)$.

  Its *rank* is the rank of $T_cal(F)$; its *codimension* is
  $dim X - op("rk") T_cal(F)$.
]

Involutivity is the whole content. A subbundle of $T_X$ is just a field of
subspaces, a "distribution"; involutivity is the algebraic condition that makes
the distribution *integrable*, i.e. that makes it the field of tangent spaces to
an actual family of subvarieties.

If you have met foliations in characteristic $p$ — as $p$-Lie subalgebras of
$T_X$, closed under both bracket and $p$-th power, corresponding to purely
inseparable quotients by the Jacobson correspondence — then you already know this
definition. The characteristic-zero story below is the analytic counterpart.

== The geometric definition: charts with triangular transitions

Here is the equivalent picture, and the one you should carry around. Let $M$ be a
smooth $n$-manifold and $0 <= q <= n$.

#box-note("Definition (foliation, chart version)")[
  A *codimension-$q$ foliation* of $M$ is an atlas of charts
  $
    phi_i : U_i --> RR^(n-q) times RR^q, #h(1em) phi_i = (x_i, y_i),
  $
  whose transition maps are *block-triangular*:
  $
    phi_j compose phi_i^(-1) (x, y) = (g_(i j)(x, y), #h(0.3em) h_(i j)(y)) .
  $
  The point is that the second component $h_(i j)$ depends on $y$ *alone*.
]

So the "$y$-coordinate" is not globally defined, but the *level sets of $y$* are
globally meaningful, because the transition functions preserve them. Inside a
chart, the sets ${y = "const"}$ are called *plaques*; a *leaf* is a maximal
connected set obtained by chaining plaques together across charts.

Compare: a locally constant sheaf is one whose transition data is locally trivial
but globally can be twisted. A foliation is exactly this phenomenon one level up:
locally it is a product $"(leaf direction)" times "(transverse direction)"$, but
globally the leaves can wander.

#slogan[
  A foliation is a partition of $M$ into immersed submanifolds (the leaves) that
  is locally, but usually not globally, the partition of a product into slices.
]

The equivalence of the two definitions is the *Frobenius theorem*: an involutive
subbundle of $T M$ is locally spanned by $partial slash partial x_1, ..., partial slash
partial x_(n-q)$ in suitable coordinates. Involutivity is exactly the obstruction:
if $V, W$ are tangent to a common family of submanifolds, then so is $[V, W]$.

== Examples, in increasing order of interest

/ Fibres of a submersion: If $f : M -> B$ is a submersion, its fibres foliate $M$.
  This is the *trivial* case in the sense that a global first integral exists; all
  the invariants defined below vanish. In our setting, an elliptic fibration
  $f_1 : S -> PP^1$ foliates the complement of the singular fibres.

/ Solutions of an ODE: A nowhere-zero vector field on $M$ has integral curves
  which foliate $M$ in rank $1$. Here you can already see the subtlety: the
  integral curves need not be the level sets of any function, even locally in the
  large.

/ The linear foliation on the torus: On $T^2 = RR^2 slash ZZ^2$, take the lines of
  slope $alpha$. If $alpha in QQ$ every leaf is a closed circle. If
  $alpha in.not QQ$ *every leaf is dense*, and each leaf is a copy of $RR$ injected
  with dense image. There is no continuous first integral at all.

This third example is the one to remember, because it is the exact model for the
orbit closures $Omega_i (x)$ of Parts I–III. There, density of the multiples of a
point in its own fibre plays precisely the role played here by irrationality of
$alpha$.

/ The Reeb foliation: On the closed solid torus $D^2 times S^1$ there is a
  codimension-$1$ foliation whose only compact leaf is the boundary torus, all
  other leaves being planes spiralling towards it. Glueing two copies gives a
  foliation of $S^3$. This is the standard example showing that leaves in the same
  foliation can have wildly different topology.

= Holonomy

This is the central concept, and the one your intuition was reaching for.

== The problem it solves

Given a foliation and a leaf $L$, ask: *what does the foliation look like in a
neighbourhood of $L$?* Locally, near any single point, it is a product. But
transporting that product structure around $L$ may fail to close up. Holonomy
measures the failure.

== The construction

Fix a leaf $L$ and a point $x in L$. Choose a small *transversal* $T$ at $x$: a
submanifold of dimension $q$ (the codimension) meeting $L$ transversally at $x$,
so $T$ is a local cross-section of the leaves.

Let $gamma : [0,1] -> L$ be a loop based at $x$. Cover $gamma$ by finitely many
foliation charts. Within each chart, "sliding along plaques" defines a
diffeomorphism between small transversals at consecutive points. Composing these
gives a germ of a diffeomorphism
$
  h_gamma : (T, x) --> (T, x), #h(1.2em) h_gamma (x) = x .
$

#box-note("Theorem (holonomy representation)")[
  The germ $h_gamma$ depends only on the homotopy class of $gamma$ in $L$, and
  $gamma |-> h_gamma$ defines a homomorphism
  $
    op("hol") : pi_1 (L, x) --> op("Germ")(T, x)
  $
  into the group of germs at $x$ of diffeomorphisms of $T$ fixing $x$. Its image,
  the *holonomy group* of $L$, is independent of choices up to conjugacy.
]

The key phrase is *germ*: the map $h_gamma$ is only defined on some unspecified
small neighbourhood, because a nearby leaf may wander off and fail to return.
Germs are the natural objects here for exactly the same reason that stalks are the
natural objects in sheaf theory.

== Holonomy generalises monodromy — precisely how

This is the bridge from your background, so let me make it exact.

Suppose $pi : E -> B$ is a covering map, and foliate $E$ by the *discrete* fibres
— no, better: foliate $E$ by the connected components of $pi^(-1)$ of nothing at
all. The cleanest statement is via the *suspension* construction.

#box-note("Suspension")[
  Let $B$ be a connected manifold with universal cover $tilde(B)$, let $F$ be a
  manifold, and let
  $
    rho : pi_1 (B) --> op("Diff")(F)
  $
  be any homomorphism. Let $pi_1 (B)$ act on $tilde(B) times F$ by
  $g dot.op (tilde(b), f) = (g dot.op tilde(b), rho(g) f)$ and set
  $M = (tilde(B) times F) slash pi_1 (B)$. The images of the slices
  $tilde(B) times {f}$ foliate $M$, with $F$ as a transversal.

  *The holonomy representation of the leaf through $f$ is exactly the germ of
  $rho$ at $f$.*
]

So every group of germs of diffeomorphisms arises as a holonomy group. And now the
comparison:

#table(
  columns: (0.9fr, 1.1fr, 1.1fr),
  inset: 8pt,
  align: left + top,
  stroke: 0.5pt + luma(180),
  table.header([], [*Monodromy*], [*Holonomy*]),

  [Object being transported],
  [a discrete fibre, or a vector space $H^i$],
  [a germ of a transversal],

  [Group of symmetries],
  [$op("Sym")(F)$ or $"GL"_n$],
  [$op("Germ")(T, x)$, an infinite-dimensional non-linear group],

  [Source],
  [$pi_1$ of the base],
  [$pi_1$ of a *leaf*],

  [Trivial when],
  [the cover splits / local system is constant],
  [the foliation is a product near $L$],
)

The right column is the honest generalisation of the left: monodromy is what
holonomy becomes when the transversal is $0$-dimensional, so that
$op("Germ")(T,x)$ collapses to a permutation group. Conversely, holonomy is what
you get when the transverse structure is *continuous*, and then the interesting
information is not a permutation but a *germ*, with all the local-dynamical data —
derivative at the fixed point, resonances, and so on — that a germ carries. That
extra data is precisely what Section 4 is about.

== Why holonomy matters: stability

#box-note("Reeb stability theorem")[
  Let $L$ be a *compact* leaf with *finite* holonomy group. Then $L$ has a
  neighbourhood which is a union of leaves, each a finite covering of $L$; in
  particular the foliation is a "product up to finite data" near $L$. If moreover
  the holonomy is trivial, the neighbourhood is a genuine product
  $L times T$.
]

So nontrivial holonomy is exactly the obstruction to local triviality along a
leaf, and the *size* of the holonomy group measures how badly things fail. In the
irrational torus foliation, the leaves are non-compact and the relevant object is
not a holonomy group of a single leaf but the pseudogroup of the next section.

= Pseudogroups

Holonomy of a single leaf is a group. But if one wants to describe the transverse
structure of the *whole* foliation, groups are the wrong category, because the
maps involved are only partially defined.

#box-note("Definition")[
  A *pseudogroup* $Gamma$ on a space $T$ is a collection of homeomorphisms
  $g : U -> V$ between open subsets of $T$, such that:
  identities are in $Gamma$; $Gamma$ is closed under composition (where defined),
  inverse, and restriction to smaller opens; and if $g : U -> V$ restricts to an
  element of $Gamma$ on each member of an open cover of $U$, then $g in Gamma$.
]

If this feels like a groupoid, that is because it is: a pseudogroup is essentially
an étale groupoid over $T$, and the modern treatment (Haefliger, Moerdijk–Mrčun)
is entirely in groupoid language. Number theorists may also enjoy knowing that
Malgrange defined a *Galois groupoid* of a foliation, which specialises to the
differential Galois group in the linear case; the analogy with Galois theory is
not merely rhetorical.

#box-note("Holonomy pseudogroup")[
  Choose a complete transversal $T$ — a disjoint union of local transversals
  meeting every leaf. The germs of all "slide along a plaque" maps between open
  subsets of $T$ generate a pseudogroup $Gamma_cal(F)$ on $T$. Its *orbits* are
  exactly the intersections $L ∩ T$ of leaves with the transversal.
]

Two consequences worth internalising:

+ The transverse dynamics of a foliation *is* the orbit structure of a pseudogroup
  acting on a $q$-manifold. Leaf closures correspond to orbit closures.

+ For the irrational linear foliation of $T^2$, take $T$ to be a circle
  ${x = 0}$. The holonomy pseudogroup is generated by the rotation by $alpha$.
  Leaves are dense $<=>$ every orbit of $⟨"rotation by" alpha⟩$ is
  dense $<=>$ $alpha in.not QQ$.

That last line is the template for everything in Parts I–III: an orbit closure of
a one-generator group acting on a compact transversal, dense or not according to
an arithmetic condition. Replace "rotation by $alpha$ on $S^1$" by "translation by
$P$ on $E(QQ_p)$" and you have the setting of our Theorem A.

= Germs of analytic diffeomorphisms: attracting, repelling, neutral

Holonomy produces germs of diffeomorphisms fixing a point. So we now need to know
how such germs are classified. In codimension $1$ — the relevant case — this is
*local dynamics in one variable*, and the theory is clean, classical, and pleasant.

Throughout, let $K$ be a complete valued field and consider a germ
$
  f(z) = lambda z + a_2 z^2 + a_3 z^3 + dots.c, #h(1.2em) lambda != 0,
$
convergent near $0$, with $f(0) = 0$. The number $lambda = f'(0)$ is the
*multiplier*. We ask: when is $f$ *conjugate* to its linear part, i.e. when does
there exist an invertible germ $h(z) = z + h_2 z^2 + dots.c$ with
$
  h compose f compose h^(-1) (z) = lambda z ?
$

This is a conjugacy problem in a group of formal or convergent power series, which
should feel familiar.

== The formal problem: resonances

Let us solve for $h$ degree by degree. Write the conjugacy equation as
$h(f(z)) = lambda h(z)$. Comparing coefficients of $z^n$ for $n >= 2$ gives an
equation of the shape
$
  (lambda^n - lambda) h_n = P_n (a_2, ..., a_n, h_2, ..., h_(n-1)),
$
where $P_n$ is a universal polynomial. So we can solve recursively *provided*
$lambda^n - lambda != 0$ for all $n >= 2$, i.e. provided
$
  lambda^(n-1) != 1 #h(1em) "for all" n >= 2
  #h(1.5em) <==> #h(1.5em) lambda "is not a root of unity" .
$

#box-note("Formal linearisation")[
  If $lambda$ is not a root of unity, $f$ is *formally* linearisable, and the
  linearising series $h$ is unique once normalised by $h'(0) = 1$.
]

The failures $lambda^(n-1) = 1$ are called *resonances*. Concretely, for
$lambda = 1$ the first obstruction is at $n = 2$: the germ
$f(z) = z + a_2 z^2 + dots.c$ with $a_2 != 0$ is not conjugate to the identity,
and one gets instead the *parabolic* normal form
$f(z) = z + a z^(m+1) + b z^(2m+1) + dots.c$. Its dynamics is the Leau–Fatou
flower: $m$ attracting and $m$ repelling petals alternating around $0$. This is the
genuinely hard case and we will not need it.

== The analytic problem: small divisors

Formal solvability is not convergence. Even when $lambda^n - lambda != 0$, the
recursion divides by it at every step, so we need those numbers not to be *too
small*.

#box-note("The two regimes")[
  / Poincaré domain, $abs(lambda) != 1$: the quantities $abs(lambda^n - lambda)$
    grow geometrically (if $abs(lambda) > 1$) or are bounded below by
    $abs(lambda) - abs(lambda)^n >= c > 0$ (if $abs(lambda) < 1$). No small
    divisors, and convergence is automatic.

  / Siegel domain, $abs(lambda) = 1$: now $lambda^(n-1) - 1$ can be extremely small
    without vanishing. Convergence becomes a delicate diophantine question.
]

In the Poincaré domain there is a beautiful one-line construction, which is worth
seeing because it explains the word "attracting":

#box-note("Kœnigs linearisation theorem")[
  If $0 < abs(lambda) < 1$, then
  $
    h(z) = lim_(n -> infinity) lambda^(-n) f^(compose n)(z)
  $
  converges uniformly near $0$, and satisfies $h compose f = lambda dot.op h$.
  Hence $f$ is analytically conjugate to $z |-> lambda z$. The case
  $abs(lambda) > 1$ follows by applying this to $f^(-1)$.
]

The proof is exactly what an algebraist would guess: $f$ contracts a small disc by
a factor of roughly $abs(lambda)$, so $f^(compose n)(z) = lambda^n z (1 + O(rho^n))$
for some $rho < 1$, and the telescoping product converges geometrically.

So: *$abs(lambda) < 1$ is attracting, $abs(lambda) > 1$ is repelling, and in both
cases the germ is completely understood — it is a scaling in suitable coordinates.*
All the difficulty of one-dimensional local dynamics sits on the unit circle.

== The neutral case over $CC$, briefly

For $lambda = e^(2 pi i theta)$ with $theta$ irrational, whether $f$ is
linearisable depends on the continued fraction of $theta$:

- *Siegel (1942):* linearisable if $theta$ is diophantine, i.e.
  $abs(theta - p slash q) >= C q^(-mu)$ for some $C, mu > 0$.
- *Bruno:* the weaker condition $sum_k (log q_(k+1)) slash q_k < infinity$ on the
  continued fraction convergents suffices.
- *Yoccoz:* for quadratic polynomials the Bruno condition is *sharp* — outside it,
  linearisation genuinely fails.

This is a place where number theory enters dynamics head-on, and it is the
historical origin of the phrase "small divisors".

== The ultrametric case — and why it is cleaner

Now let $K$ be non-archimedean, e.g. $QQ_p$ or a finite extension. Two things
change, one for the better and one for the worse.

*For the better.* Ultrametric balls are the natural invariant objects, and the
condition $abs(lambda) <= 1$ — merging the attracting and neutral cases — has a
clean meaning: if $abs(lambda) <= 1$ and $f$ has integral coefficients, then $f$
maps each ball $abs(z) <= r$ into itself, and
$
  abs(f(z)) <= abs(lambda) dot.op abs(z) #h(1em) "for" abs(z) "small",
$
so $abs(z)$ is a *Lyapunov function*: it never increases along the orbit. If
instead $abs(lambda) > 1$, then $abs(f(z)) = abs(lambda) abs(z)$ exactly for small
$z$, by the ultrametric equality case, and orbits escape at a uniform geometric
rate until they leave the domain.

#slogan[
  Non-archimedeanly, the natural dichotomy is $abs(lambda) <= 1$ versus
  $abs(lambda) > 1$: "the filtration by balls is preserved" versus "the filtration
  is expanded". There is no boundary case to worry about at the level of *orbit
  sizes*, because there is no continuum of moduli of $abs(dot.op)$.
]

This is exactly the dichotomy of Theorem B in Part III, and it is why that theorem
could be stated with a sharp threshold rather than a diophantine condition.

*For the worse.* At the finer level of *analytic linearisability*, small divisors
do not disappear. If $abs(lambda)_p = 1$ then $lambda$ is a unit, and in
$ZZ_p^times tilde.equiv Delta times (1 + p ZZ_p) tilde.equiv Delta times ZZ_p$ we
have $lambda^(abs(Delta) p^k) -> 1$ as $k -> infinity$. So $lambda^(n-1) - 1$
becomes arbitrarily small $p$-adically along a subsequence, for *every*
non-root-of-unity unit $lambda$. Small divisors are therefore unavoidable in the
neutral case, and one again needs a Bruno-type condition (Herman–Yoccoz, and later
work of Lindahl and others). I mention this only so that the analogy is not
oversold: the *coarse* dichotomy above is elementary, but the *fine* classification
of neutral $p$-adic germs is as hard as its complex counterpart.

= Web geometry

We now have foliations one at a time. Web geometry studies *several at once*, and
the phenomenon it isolates — that $d$ foliations have local invariants once
$d >= 3$ — is what made the cross-ratio $lambda$ appear in Part III.

== Definition and the first two cases

#box-note("Definition")[
  A *$d$-web* on a surface $M$ is a collection $cal(W) = (cal(F)_1, ..., cal(F)_d)$
  of $d$ foliations by curves, pairwise transverse at each point of an open dense
  set. Two webs are *equivalent* near a point if a local diffeomorphism carries
  one family of foliations to the other.
]

Now count invariants.

/ $d = 1$: no invariants. Every foliation by curves is locally
  ${y = "const"}$ — this is the flow-box theorem, i.e. the rank-$1$ case of
  Frobenius.

/ $d = 2$: still no invariants. If $u$ and $v$ are local first integrals of
  $cal(F)_1$ and $cal(F)_2$, then transversality says $d u and d v != 0$, so
  $(u, v)$ is a local coordinate system, and in it the two webs are
  ${u = "const"}$ and ${v = "const"}$: two families of parallel lines. *Any two
  transverse foliations are locally equivalent to any other two.*

That second line is worth pausing on, because it is exactly the collapse of Part
II. Two elliptic fibrations on a surface, near a point where they meet
transversally, are locally indistinguishable from the horizontal and vertical
rulings of a square. Nothing local can possibly distinguish them.

== $d = 3$: the Blaschke curvature

With three foliations you have used up your coordinate freedom. Take $u, v$ as
above; the third foliation is ${w = "const"}$ for some function $w = w(u,v)$ with
$w_u w_v != 0$. The residual freedom is $u |-> phi(u)$, $v |-> psi(v)$, which is
two functions of one variable — not enough to normalise $w$, a function of two
variables. So invariants must exist.

#box-note("Blaschke curvature")[
  For a $3$-web with first integrals $u, v, w(u,v)$, set
  $
    K = partial_u partial_v log abs(w_u slash w_v)
  $
  (conventions on sign and normalisation vary between sources). Then
  $K dif u and dif v$ is a well-defined $2$-form on $M$, independent of the
  choices, called the *curvature of the web*.
]

The formula should look familiar: it is a second logarithmic derivative, exactly
as a Gaussian curvature or the curvature of a connection is. Its meaning:

#box-note("Thomsen's theorem")[
  For a $3$-web the following are equivalent:
  + $K equiv 0$;
  + the web is locally equivalent to three families of *parallel lines* in the
    plane (one says the web is *parallelisable*, or *hexagonal*);
  + the hexagonal closure figure closes up, locally, at every point.
]

The closure condition in (3) deserves a picture. Fix a point $p$ and the three
leaves through it. Starting from a nearby point $a$ on the first leaf, alternate
between the three families as shown; after six steps you return to a point on the
first leaf. The web is hexagonal precisely when that point is always $a$ itself.

#align(center)[
  #block(width: 175pt, height: 145pt)[
    // the three leaves through p
    #place(line(start: (35pt, 70pt), end: (125pt, 70pt), stroke: 0.4pt + luma(150)))
    #place(line(start: (80pt, 25pt), end: (80pt, 115pt), stroke: 0.4pt + luma(150)))
    #place(line(start: (40pt, 30pt), end: (120pt, 110pt), stroke: 0.4pt + luma(150)))
    // hexagon: a -> b -> c -> d -> e -> f -> a
    #place(line(start: (120pt, 70pt), end: (120pt, 110pt), stroke: 0.9pt))
    #place(line(start: (120pt, 110pt), end: (80pt, 110pt), stroke: 0.9pt))
    #place(line(start: (80pt, 110pt), end: (40pt, 70pt), stroke: 0.9pt))
    #place(line(start: (40pt, 70pt), end: (40pt, 30pt), stroke: 0.9pt))
    #place(line(start: (40pt, 30pt), end: (80pt, 30pt), stroke: 0.9pt))
    #place(line(start: (80pt, 30pt), end: (120pt, 70pt), stroke: 0.9pt))
    // vertices
    #place(dx: 118pt, dy: 68pt, circle(radius: 2pt, fill: black))
    #place(dx: 118pt, dy: 108pt, circle(radius: 2pt, fill: black))
    #place(dx: 78pt, dy: 108pt, circle(radius: 2pt, fill: black))
    #place(dx: 38pt, dy: 68pt, circle(radius: 2pt, fill: black))
    #place(dx: 38pt, dy: 28pt, circle(radius: 2pt, fill: black))
    #place(dx: 78pt, dy: 28pt, circle(radius: 2pt, fill: black))
    #place(dx: 78pt, dy: 68pt, circle(radius: 1.7pt, fill: white, stroke: 0.7pt))
    // labels
    #place(dx: 126pt, dy: 62pt, text(8.5pt)[$a$])
    #place(dx: 126pt, dy: 106pt, text(8.5pt)[$b$])
    #place(dx: 70pt, dy: 114pt, text(8.5pt)[$c$])
    #place(dx: 26pt, dy: 62pt, text(8.5pt)[$d$])
    #place(dx: 28pt, dy: 18pt, text(8.5pt)[$e$])
    #place(dx: 76pt, dy: 14pt, text(8.5pt)[$f$])
    #place(dx: 84pt, dy: 72pt, text(8.5pt)[$p$])
  ]

  #text(9.5pt, style: "italic")[
    The hexagonal closure figure, drawn for the parallel $3$-web where it always
    closes. For a general $3$-web the sixth step misses $a$, and the size of the
    gap is measured, to leading order, by $K$.
  ]
]

The gap in the sixth step is a germ of a diffeomorphism of the first leaf fixing
$p$ — a *holonomy germ* of the web. This is the first point where the two halves of
this article meet: *web curvature is the infinitesimal version of a holonomy germ
being nontrivial.*

== $d >= 4$: cross-ratios, and why they are forced

Here is the observation that made $lambda$ appear in Part III, and it is pure
linear algebra.

At a point $p in M$, each foliation $cal(F)_i$ determines a tangent line
$T_i subset.eq T_p M$, i.e. a point of the projective line
$PP(T_p M) tilde.equiv PP^1$. A local diffeomorphism fixing $p$ acts on
$PP(T_p M)$ through its derivative, so through the full group
$"PGL"(T_p M) tilde.equiv "PGL"_2$.

#box-note("The counting principle")[
  $"PGL"_2$ acts *sharply $3$-transitively* on $PP^1$. Therefore:

  - $d <= 3$ tangent directions can always be normalised (to $0, 1, infinity$),
    so they carry *no pointwise invariant*;
  - $d = 4$ directions carry *exactly one*: the cross-ratio
    $(T_1, T_2 ; T_3, T_4)$;
  - $d$ directions carry exactly $d - 3$ independent pointwise invariants.
]

This is why a $3$-web's only invariant, $K$, is a *second-order* object — a
curvature — whereas from $d = 4$ onwards there is already a *zeroth-order* one. And
it is why, in Part III, once the two torsion multisections joined the two
fibrations to make four foliations, a cross-ratio was inevitable rather than an
artefact of my normalisation.

== A glance at the deeper theory

Web geometry has a rich global side, which I mention because it touches subjects a
number theorist will recognise.

An *abelian relation* of a $d$-web with first integrals $u_1, ..., u_d$ is a
relation $sum_i g_i (u_i) dif u_i = 0$ with each $g_i$ a function of one variable.
The space of these is finite-dimensional, and its dimension is the *rank* of the
web.

- *Bol's bound:* the rank of a $d$-web on a surface is at most
  $(d-1)(d-2) slash 2$. This is the same number as the arithmetic genus of a plane
  curve of degree $d$, and that is no coincidence.
- *Algebraisation:* by a theorem of Lie, Poincaré, and Blaschke–Bol, webs of
  maximal rank are — with exactly one exceptional case in dimension $2$ — dual to
  algebraic plane curves via Abel's theorem, the abelian relations coming from
  abelian differentials.
- *The exceptional case* is Bol's $5$-web, formed by the four pencils of lines
  through four general points in $PP^2$ together with the pencil of conics through
  all four. Its exceptional abelian relation is *Abel's five-term functional
  equation for the dilogarithm*.

So the very last thing web geometry produces, at the boundary of its
classification theory, is the five-term relation that number theorists know from
$K_3$, Bloch groups, and Zagier's conjectures. It is a nice place for the two
subjects to meet.

= Translation back to the elliptic-fibration problem

Now everything in Parts I–IV can be restated in standard vocabulary.

#table(
  columns: (1fr, 1.15fr),
  inset: 9pt,
  align: left + top,
  stroke: 0.5pt + luma(180),
  table.header([*In our problem*], [*In the vocabulary above*]),

  [The fibres of $f_1$ and of $f_2$],
  [Two transverse foliations, i.e. a $2$-web — hence *no local invariants*, which
   is exactly the collapse proved in Part II],

  [The torsion multisections ${z_1 = 0}$, ${z_2 = 0}$ and their translates],
  [Two further foliations, upgrading the configuration to a $4$-web],

  [The cross-ratio $lambda = (T O_2, T O_1 ; T F_1, T F_2)$],
  [The unique pointwise invariant of a $4$-web, forced to exist by sharp
   $3$-transitivity of $"PGL"_2$],

  [$Omega_i (x)$, the closure of the multiples of $x$ in its fibre],
  [An orbit closure of the holonomy pseudogroup, exactly as for the irrational
   linear foliation of $T^2$],

  [The pseudogroup $Gamma_U$ generated by both fibrewise translations],
  [The holonomy pseudogroup of the configuration; its orbits are the symmetric
   part of the preorder $<$],

  [The round trip $P ->_2 P_1 ->_1 P_2 ->_2 Q$],
  [A holonomy germ of the web at $P_0$ — the analogue of the hexagonal closure
   gap],

  [$abs(lambda)_p <= 1$ versus $abs(lambda)_p > 1$],
  [Non-expanding versus expanding multiplier of that germ: the ultrametric form of
   the attracting/repelling dichotomy of Section 4],
)

Two honest caveats, repeating Part IV.

+ *It is holonomy, not monodromy.* There is no loop around $P_0$ to speak of: over
  $CC$, a punctured neighbourhood in a surface is simply connected. The
  "$pi_1 = ZZ^2$" picture only appears once one removes the *divisor*
  ${z_1 z_2 = 0}$ rather than the point.

+ *The mechanism is a step-size constraint, not curvature.* Standard web geometry
  studies foliations with unconstrained motion along leaves. In our problem the
  admissible step at $x$ along $cal(F)_i$ has size $abs(z_i (x))$, degenerating
  along the torsion locus. That filtration is extra structure, and it is what makes
  escape possible even though the relevant vector fields commute to leading order.
  The web-holonomy language becomes exactly right only at the level of the iterated
  round trip, where $lambda$ takes over as the multiplier.

= Further reading

*Foliations and holonomy.*
C. Camacho and A. Lins Neto, _Geometric Theory of Foliations_ — short, concrete,
starts from ODEs; the best first book for this purpose.
A. Candel and L. Conlon, _Foliations I_ — thorough, with a careful treatment of
holonomy and Reeb stability.
I. Moerdijk and J. Mrčun, _Introduction to Foliations and Lie Groupoids_ — for the
pseudogroup/groupoid perspective, and the most algebraic in flavour.

*Local dynamics of germs.*
J. Milnor, _Dynamics in One Complex Variable_ — chapters on Kœnigs, Leau–Fatou,
and Siegel discs; very readable.
M. Herman and J.-C. Yoccoz, "Generalizations of some theorems of small divisors to
non-Archimedean fields", in _Geometric Dynamics_ (Springer LNM 1007, 1983) — the
$p$-adic small-divisor theory.
J. Silverman, _The Arithmetic of Dynamical Systems_ — for $p$-adic dynamics in a
number-theoretic idiom.

*Web geometry.*
W. Blaschke and G. Bol, _Geometrie der Gewebe_ (1938) — the original.
J. V. Pereira and L. Pirio, _An Invitation to Web Geometry_ — modern, and the place
to read about Bol's $5$-web and the dilogarithm.
S.-S. Chern and P. Griffiths, "Abel's theorem and webs", _Jahresber. DMV_ 80 (1978)
— the algebraisation theory.
