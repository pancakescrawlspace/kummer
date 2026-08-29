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
  #text(size: 16pt, weight: "bold")[Why the four primes]
  #v(2mm)
  #text(size: 10pt)[A geometric reading of the $p$-torsion in arXiv:1211.5833:
  Néron models, inertia, and two routes to the same list]
  #v(1mm)
  #text(size: 9pt, style: "italic")[checks in `padic-ptorsion.gp`]
]

#v(4mm)

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *The theorem.* [P, Thm 1]: for $E slash QQ_p$ with additive reduction given by a minimal model
  with every $a_i in p ZZ_p$, one has $E_0 (QQ_p) tilde.equiv ZZ_p$ *except* when
  $ p = 2, thick a_1 + a_3 equiv 2 space (4); quad p = 3, thick a_2 equiv 6 space (9); quad
    p = 5, thick a_4 equiv 10 space (25); quad p = 7, thick a_6 equiv 14 space (49), $
  in which cases $E_0 (QQ_p) tilde.equiv p ZZ_p times bb(F)_p$ --- there is a point of order $p$.

  #v(2mm)
  *The four congruences are one congruence*, and there are four of them for a reason that can be
  given twice over, arithmetically and geometrically, with the two arriving at the same list from
  opposite directions (@sec-weights, @sec-inertia).
]

= One congruence, not four <sec-one>

Line up the index of the coefficient against the prime: $a_1$ at $p = 2$, $a_2$ at $3$, $a_4$ at
$5$, $a_6$ at $7$. The index is $p - 1$. And the residue is $2p$:

#align(center, table(
  columns: 4, align: (center, center, center, center),
  stroke: 0.4pt + luma(170), inset: (x: 9pt, y: 3.5pt),
  table.header([$p$], [the condition], [as $a_(p-1)$], [$2p$]),
  [$3$], [$a_2 equiv 6$ (mod $9$)], [$a_2$], [$6$],
  [$5$], [$a_4 equiv 10$ (mod $25$)], [$a_4$], [$10$],
  [$7$], [$a_6 equiv 14$ (mod $49$)], [$a_6$], [$14$],
))

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  $ E_0 (QQ_p) "has a point of order" p quad <==> quad a_(p-1) equiv 2 p space (mod p^2) $
  --- verified directly at $p = 3, 5, 7$ by sweeping all residues (@sec-gp, check 1). At $p = 2$
  the coefficient of index $p - 1 = 1$ is $a_1$, and the condition involves $a_1 + a_3$; the
  characteristic-$2$ mixing of $a_1$ and $a_3$ is the usual exception.
]

= Reading I: weights, and why $p <= 7$ <sec-weights>

Why is it $a_(p-1)$ that can possibly appear? Because of *weight*. Under the scaling
$(x,y) |-> (u^2 x, u^3 y)$ the coefficients transform by $a_i |-> u^(-i) a_i$, so $a_i$ has weight
$i$. Restrict to $u in ZZ_p^times$ and reduce: $u^(p-1) equiv 1$ (mod $p$), so

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  $a_(p-1) slash p$ mod $p$ is the *unique* coefficient whose leading term is an invariant of the
  model. Any criterion expressible as a congruence on one coefficient has to be a criterion on
  $a_(p-1)$, because no other coefficient has a well-defined leading term.
]

And now the bound falls out with nothing else added. A Weierstrass equation has coefficients
$ a_1, space a_2, space a_3, space a_4, space a_6 $
and no others. So $p - 1$ must lie in ${1,2,3,4,6}$ --- which happens exactly for
$p in {2,3,5,7}$, and for no larger prime. *There is no $a_(10)$ to impose a condition on at
$p = 11$.*

= The mechanism inside $QQ_p$ <sec-mech>

Additive reduction means the special fibre of the connected Néron model $cal(E)^0$ is
$GG_a$ over $bb(F)_p$. Write the usual filtration
$ E_0 (QQ_p) = cal(E)^0 (ZZ_p) supset E_1 supset E_2 supset dots.c , quad
  E_0 slash E_1 = GG_a (bb(F)_p) tilde.equiv bb(F)_p , quad
  E_n slash E_(n+1) tilde.equiv "Lie"(cal(E)) times.circle bb(F)_p tilde.equiv bb(F)_p . $
Since $GG_a$ is killed by $p$, multiplication by $p$ carries $E_0$ into $E_1$, and induces an
$bb(F)_p$-linear map between two one-dimensional spaces:

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  $ lambda : E_0 slash E_1 --> E_1 slash E_2 , quad "a scalar in" bb(F)_p . $
  $E_1$ is torsion-free (it is $hat(E)(p ZZ_p) tilde.equiv ZZ_p$ for $p >= 3$), so the extension
  $0 --> E_1 --> E_0 --> bb(F)_p --> 0$ splits --- i.e. there is $p$-torsion --- *exactly when
  $lambda = 0$*.
]

That is testable without any theory: take $P in E_0 without E_1$ and read the valuation of $p P$.
$v(x(p P)) = -2$ says $p P in E_1 without E_2$, i.e. $lambda eq.not 0$; anything lower says
$lambda = 0$. Over $36$ curves at $p = 5$ and $p = 7$ the drop happens *exactly* when the
congruence of @sec-one holds (@sec-gp, check 2). So the congruence *is* the vanishing of $lambda$
--- an invariant of the Néron model, not of the equation.

= Reading II: Néron models and inertia <sec-inertia>

This is the argument I take the geometric explanation to have been, and it gives the bound
$p <= 7$ again, by a completely different route.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Step 1: the point is forced into a formal group.* $E$ acquires good reduction over a finite
  extension $L slash QQ_p$; let $Delta$ be the image of inertia and $e = |Delta|$ the
  *semistability defect*, which is also the ramification index of $L slash QQ_p^"ur"$. The Néron
  property gives a map $cal(E)^0 times_(ZZ_p) cal(O)_L --> cal(E)_L$, and on special fibres a
  homomorphism
  $ GG_a --> overline(E) . $
  An abelian variety contains no additive subgroup, so *this map is trivial*. Hence every point of
  $E_0 (QQ_p)$ reduces to $cal(O)$ over $cal(O)_L$:
  $ E_0 (QQ_p) subset.eq hat(E)(frak(m)_L) , $
  the formal group.

  #v(2mm)
  *Step 2: formal groups resist $p$-torsion.* A one-dimensional formal group over a field of
  absolute ramification $e$ has no point of order $p$ unless $e >= p - 1$ (Silverman IV.6.1: a
  point of order $p$ has $v <= e slash (p-1)$). So
  $ E_0 (QQ_p)[p] eq.not 0 quad ==> quad e >= p - 1 . $

  #v(2mm)
  *Step 3: inertia is small.* For potentially good reduction $Delta$ embeds in
  $"Aut"(overline(E))$, so $e in {1,2,3,4,6}$ when $p >= 5$. (Potentially *multiplicative*
  reduction gives $e = 2$, which is even weaker.) Hence $p - 1 <= 6$, i.e.
  $ p <= 7 . $
]

Step 2 is a genuine constraint and it is visible in the data (@sec-gp, check 3): at $p = 7$ the
curves with $7$-torsion have $e = 6$ and *only* $6$; at $p = 5$ they have $e in {4, 6}$ and never
$3$ --- while curves without the torsion occur at every $e$. So $e >= p-1$ is necessary and not
sufficient, exactly as the argument predicts: it bounds the primes, and the congruence of
@sec-one then picks out which curves.

= Why the two readings give the same list <sec-both>

They look independent --- one is about the weights of Weierstrass coefficients, the other about
ramification of the field where good reduction appears --- and they land on
$p in {2,3,5,7}$ for the same underlying reason.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  The weights available to a Weierstrass equation are ${1,2,3,4,6}$; the orders available to
  $"Aut"(overline(E))$ for $p >= 5$ are ${1,2,3,4,6}$. *These are the same set*, and neither
  coincidence: both are the possible orders of automorphisms of an elliptic curve --- the weights
  because the scaling $(x,y) |-> (u^2 x, u^3 y)$ is exactly the automorphism action on a
  Weierstrass model, the $e$'s because $Delta$ embeds into $"Aut"$.

  #v(2mm)
  So "$p - 1$ is a Weierstrass weight" and "$p - 1$ divides an automorphism order" are two
  spellings of the same restriction, and the theorem's four primes are the four with
  $p - 1 <= 6$ and $p-1 eq.not 5$.
]

= Status <sec-status>

#block(fill: rgb("#fff4e6"), inset: 8pt, radius: 3pt, width: 100%)[
  *What is a reconstruction.* @sec-inertia is an argument of the shape described --- Néron model,
  inertia action --- that does give the theorem's bound. It is *not* a report of what was said in
  the conversation that prompted this note, and it may not be the argument that was meant. What is
  checked here is only that the argument is correct and that its intermediate prediction
  ($e >= p-1$) holds.

  #v(2mm)
  *What is verified.* The unified congruence $a_(p-1) equiv 2p$ (mod $p^2$) at $p = 3,5,7$; that it
  is equivalent to the vanishing of $lambda$; and that $p$-torsion forces $e >= p-1$.

  #v(2mm)
  *What is not done here.* Deriving the constant $2$ in $a_(p-1) equiv 2p$ from the geometry ---
  @sec-inertia bounds the primes but says nothing about which curves. That is what [P] proves, and
  this note does not reprove it.
]

= What the companion script checks <sec-gp>

`padic-ptorsion.gp`, results in `results/padic-ptorsion.txt`.

#v(1mm)
- *(1)* Sweeping all residues at $p = 3, 5, 7$: the $p$-torsion occurs exactly at
  $a_(p-1) equiv 2p$ (mod $p^2$), agreeing with [P]'s four cases.
- *(2)* $v(x(p P))$ for $P in E_0 without E_1$ over $36$ curves: it drops below $-2$ exactly when
  the congruence holds --- the congruence is $lambda = 0$.
- *(3)* The semistability defect of the curves with and without $p$-torsion: $e = 6$ only at
  $p = 7$, $e in {4,6}$ at $p=5$, never below $p-1$, while curves without torsion occur at every
  $e$.

= References <sec-refs>

#block(inset: (left: 4pt))[
#set enum(numbering: "[1]")
+ R. Pannekoek, #link("https://arxiv.org/abs/1211.5833")[*On $p$-torsion of $p$-adic elliptic
  curves with additive reduction*], arXiv:1211.5833 (2013). The theorem; used in
  `kummer-example-j0.typ` §2.1 to prove $E_0 (QQ_7) tilde.equiv ZZ_7$ for a whole twist family.
+ J. H. Silverman, *The Arithmetic of Elliptic Curves*, 2nd ed., GTM 106. IV.6.1 for the formal
  group torsion bound of @sec-inertia step 2; VII.6 for the filtration of @sec-mech; VII.7 and
  Appendix A.1 for $"Aut"(overline(E))$.
+ A. Néron, and the standard account in Silverman, *Advanced Topics in the Arithmetic of Elliptic
  Curves*, GTM 151, IV.5--IV.10, for Néron models and the semistability defect $e$.
+ J.-P. Serre, J. Tate, *Good reduction of abelian varieties*, Ann. of Math. *88* (1968), 492--517.
  The criterion behind @sec-inertia step 3.
]
