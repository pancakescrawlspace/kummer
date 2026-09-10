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
  #text(size: 16pt, weight: "bold")[What is local about a non-maximal order]
  #v(2mm)
  #text(size: 10pt)[The singularity is local, sharply so; what it does to the class group is
  local modulo the units, and the units are not]
  #v(1mm)
  #text(size: 9pt, style: "italic")[a question of René Pannekoek's; checks in
  `local-nonmaximality.gp`]
]

#v(4mm)

#block(fill: luma(240), inset: 9pt, radius: 3pt, width: 100%)[
  *Two questions.* Can non-maximality of an order be seen locally, and what remains of the
  geometric picture of `singular-orders.typ` once one asks that?

  #v(2mm)
  *Yes, in every sense one might mean, and they agree* (@sec-yes): Zariski-locally
  ($R$ is maximal iff every $R_frak(p)$ is, and $R_frak(p)$ non-maximal means exactly that
  $frak(m)_frak(p)$ is *not principal*), at finitely many primes only, and formally --- one may read
  everything off the completions $hat(R)_frak(p)$, which is legal because number rings are
  *excellent*. That last point is what makes `singular-orders.typ`'s dictionary a theorem rather
  than a resemblance. The sharp quantitative form (@sec-sharp) is that *$p$-maximality of
  $ZZ[theta]$ depends only on $f$ modulo $p^2$*, and $p^2$ is the right modulus: check 3 perturbs
  $f$ by $p^2$ $284$ times without ever moving it, and $x^2+1, x^2+3, x^2+5, x^2+7$ --- all
  congruent mod $2$ --- alternate. Dedekind's criterion *is* that mod-$p^2$ test, visibly.

  #v(2mm)
  *What is not local is the class group* (@sec-no). In the Picard sequence every term is a product
  over the primes dividing the conductor except $cal(O)_K^times$. Check 6 exhibits the failure as
  sharply as it can be exhibited: the orders $ZZ + 4 cal(O)_K$ for $D = 5$ and $D = 37$ have
  *the same completion* $ZZ_2 + 4 W$ at their one singular prime --- same $delta$, same non-split
  node, same local factor $6$ --- and class numbers $1$ and $3$. The whole discrepancy is
  $[cal(O)_K^times : cal(O)_4^times] = 6$ versus $2$, the order of the fundamental unit mod $4$.
  In the imaginary case this defect is bounded by $3$; in the real case check 7 finds it as large as
  $60$.

  #v(2mm)
  *What remains of the geometry* is audited in @sec-remains. Everything local survives verbatim;
  properness, Riemann--Roch and deformation theory do not survive at all; and one thing is *gained*:
  the residue field is not algebraically closed, so branches and geometric branches come apart and
  there are *three* singularity types where geometry over $overline(k)$ has two.
]

= Yes, and in three agreeing senses <sec-yes>

Let $R$ be an order in a number field $K$, $cal(O)_K$ its integral closure, $frak(f)$ the conductor.

#v(2mm)
*(i) Zariski-locally.* Integral closure commutes with localisation and $R = inter_frak(p) R_frak(p)$,
so $R$ is maximal if and only if every $R_frak(p)$ is. Better, at a one-dimensional Noetherian local
domain the four conditions
$ "normal" quad <==> quad "regular" quad <==> quad "DVR" quad <==> quad frak(m) " principal" $
coincide. So *non-maximality at $frak(p)$ is exactly the failure of $frak(m)_frak(p)$ to be
principal* --- about as local as a statement can be, and computable: the embedding dimension
$dim_(k(frak(m))) frak(m) slash frak(m)^2$ is $1$ at a maximal point and $2$ at a singular one.
Check 2 computes it by hand for $cal(O)_f = ZZ + f cal(O)_K$ at nine triples $(D, f, p)$ and finds
$2$ exactly when $p divides f$.

#v(2mm)
*(ii) At finitely many primes, independently.* The singular locus is $V(frak(f))$, the support of
the index, and only $p$ with $p^2 divides "disc"(f)$ can appear. The local problems do not interact:
computing $cal(O)_K$ is a family of independent $p$-maximal order problems that are then glued, and
check 1 verifies both halves of that --- each `nfbasis([f,[p]])` really is maximal at $p$, and the
$ZZ$-module they span together really is $cal(O)_K$ --- for seven polynomials of degree $2$ to $6$.

#v(2mm)
*(iii) Formally.* $delta_frak(p)$, the number of branches and the node/cusp type are read off
$hat(R)_frak(p)$, and
$ [cal(O)_K : R] = product_frak(p) abs(k(frak(p)))^(delta_frak(p)) $
assembles the local lengths into the global index (check 5, $48$ pairs $(D, f)$).

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  Sense (iii) is the one that needs a hypothesis, and it is worth naming. Reading the singularity
  off the completion requires *normalisation to commute with completion* --- equivalently, that $R$
  be analytically unramified, so that $hat(R)_frak(p)$ is reduced and $delta$ computed upstairs and
  downstairs agree. This holds for *excellent* rings, and number rings are excellent, being of
  finite type over $ZZ$.

  #v(1.5mm)
  This is the theorem that licenses `singular-orders.typ`. Its claim that
  $"Spec" cal(O)_K -> "Spec" R$ *is* a resolution, and that the local types are literally nodes and
  cusps, is a statement about completions; without excellence one could not pass between the local
  ring and its completion, and the dictionary would degrade to an analogy after all.
]

= How local: the modulus is $p^2$ <sec-sharp>

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *$p$-maximality of $ZZ[theta]$ depends only on $f$ modulo $p^2$.*
]

#v(2mm)
Check 3 perturbs $f |-> f + p^2 dot ("random")$ over six polynomials and the primes up to $7$:
$284$ perturbations, none of which changed $p$-maximality. And $p^2$ is not an overestimate --- $f$
modulo $p$ does not decide it:

#align(center, table(
  columns: 4, align: (left, center, center, center),
  stroke: 0.4pt + luma(170), inset: (x: 10pt, y: 4pt),
  table.header([$f$], [$f mod 2$], [$f mod 4$], [$2$-maximal?]),
  [$x^2 + 1$], [$x^2 + 1$], [$x^2 + 1$], [yes],
  [$x^2 + 3$], [$x^2 + 1$], [$x^2 + 3$], [*no*],
  [$x^2 + 5$], [$x^2 + 1$], [$x^2 + 1$], [yes],
  [$x^2 + 7$], [$x^2 + 1$], [$x^2 + 3$], [*no*],
))

#v(2mm)
All four are congruent modulo $2$; $2$-maximality alternates, and separates exactly along the
classes mod $4$. Check 3 confirms this systematically: over squarefree $c <= 400$, $2$-maximality of
$x^2 + c$ is constant on each class modulo $4$ and splits every class modulo $2$.

#v(2mm)
That the modulus is $p^2$ is not a coincidence but a reading of Dedekind's criterion. In the
notation of `kummer-dedekind.typ` §Dedekind's criterion, one forms $T = (g h - f) slash p$ and asks
whether $gcd(overline(T), overline(g), overline(h)) = 1$: the division by $p$ reads the coefficient
of $p^1$ in $f$, and everything after that is taken modulo $p$. *Nothing beyond $f mod p^2$ is ever
consulted.* Check 4 confirms both halves --- the criterion agrees with the index at $35$ pairs
$(f, p)$, and is unchanged by all $275$ perturbations by $p^2$.

So `kummer-dedekind.typ`'s "the hypothesis is local maximality" can be sharpened to a statement
about a finite quotient: whether $ZZ_p [theta] = cal(O)_K ⊗ ZZ_p$ is a function on
$(ZZ slash p^2)[x]$.

= What is not local: the class group <sec-no>

The singularity is local. What it *does* is not. Write the Picard sequence of
`singular-orders.typ` with each term labelled:

$ 1 --> R^times --> underbrace(cal(O)_K^times, "GLOBAL") -->
  underbrace((cal(O)_K slash frak(f))^times slash (R slash frak(f))^times,
             "local: a product over " frak(p) divides frak(f))
  --> "Pic"(R) --> "Pic"(cal(O)_K) --> 1 $

Everything is local except $cal(O)_K^times$, which is Dirichlet's theorem. The kernel of
$"Pic"(R) -> "Pic"(cal(O)_K)$ is therefore *local data modulo the image of a global lattice*, and
that image is not determined by any amount of local information.

#v(2mm)
Check 6 makes this as sharp as it can be made.

#align(center, table(
  columns: 8, align: (center, center, center, center, center, center, center, left),
  stroke: 0.4pt + luma(170), inset: (x: 7pt, y: 4pt),
  table.header([$D$], [$f$], [$2$ in $K$], [$hat(R)_2$], [$delta_2$], [local factor],
               [$h(cal(O)_4)$], [$[cal(O)_K^times : cal(O)_4^times]$]),
  [$5$],  [$4$], [inert], [$ZZ_2 + 4 W$], [$1$], [$6$], [$1$], [$6$],
  [$37$], [$4$], [inert], [$ZZ_2 + 4 W$], [$1$], [$6$], [$bold(3)$], [$2$],
))

#v(2mm)
Both orders are $ZZ + 4 cal(O)_K$ with $2$ inert, so at the one singular prime the completion is
$ZZ_2 + 4 W$ in both cases, $W$ the unramified quadratic extension of $ZZ_2$ --- *the same ring*.
Same $delta$, same conductor, same non-split node, same local factor
$abs((cal(O)_K slash 4)^times slash (ZZ slash 4)^times) = 6$. The class numbers are $1$ and $3$.

The entire difference is the order of the fundamental unit modulo $4$. For $D = 5$ the unit is
$epsilon = (1 + sqrt(5)) slash 2$, and $epsilon^n = F_n epsilon + F_(n-1)$ lands in
$ZZ + 4 cal(O)_K$ first when $4 divides F_n$, i.e. at $n = 6$. For $D = 37$ the unit is
$6 + sqrt(37)$ and $n = 2$ suffices. Check 6 also runs the phenomenon systematically and exhibits
four such pairs, the discrepancy being the unit index every time.

#v(2mm)
*How badly it fails.* In the imaginary case the units are roots of unity, so the unit index is
$w_K slash w_f in {1, 2, 3}$ --- check 7 verifies that identity at every pair and finds the maximum
is indeed $3$. So for imaginary quadratic orders $"Pic"$ is local *up to a factor of at most $3$*.
In the real case the unit index is the order of the fundamental unit modulo $f$ and is unbounded:
check 7 finds $60$ already at $D = 5$, $f = 30$. Locality fails by an arbitrarily large factor, and
it fails in exactly the direction `dirichlet-rank-one.typ` measures.

#v(2mm)
*Monogenicity* is the other non-local item, and it is subtler because it has local obstructions that
are not the whole story. `kummer-dedekind.typ` §Common index divisors gives the local one: if
$product_(frak(p) divides p) cal(O)_frak(p)$ is not a monogenic $ZZ_p$-algebra --- because there are
not enough monic irreducibles of the right degree over $bb(F)_p$ --- then $p$ divides every index.
But the converse fails. By a theorem of Gras, a cyclic extension of $QQ$ of prime degree
$ell >= 5$ is monogenic only when it is $QQ(zeta_p)^+$, and most such fields have no common index
divisor at all. That obstruction is genuinely global. #text(size: 9pt, style: "italic")[(Cited, not
checked --- nothing here tests monogenicity.)]

= What remains of the geometric picture <sec-remains>

#v(2mm)
*Survives verbatim* --- everything in `singular-orders.typ` that is local, which is most of it:
normalisation $=$ resolution; the conductor cutting out the non-normal locus; $delta$; branch
counts; the node / non-split node / cusp classification by completion; the value semigroup
$⟨2,3⟩$ at a cusp; $(frak(m):frak(m))$ as the blow-up, climbing one prime at a time; and
Gorenstein $<==>$ $dim tilde(cal(O)) slash frak(c) = 2 delta$ $<==>$ $N(frak(f)) = "index"^2$.

#v(2mm)
*Survives only as a point count:* the generalised Jacobian. Geometrically it is an extension of an
*abelian variety* by an affine algebraic group; here $"Pic"(cal(O)_K)$ is a finite group and
$bb(G)_m$, the non-split torus and $bb(G)_a$ appear only through
$abs(G(bb(F)_p)) = p-1, p+1, p$. `singular-orders.typ` §5 already says this; @sec-no says why the
extension itself cannot be assembled locally.

#v(2mm)
*Does not survive:*

#block(inset: (left: 6pt))[
- *Properness.* $"Spec" cal(O)_K$ is affine. There is no genus, no $H^1$, no Riemann--Roch, no
  duality, so $delta$ is defined but $p_a (X) = p_a (tilde(X)) + delta$ has no target. Recovering one
  means adding the archimedean places, which is Arakelov theory and a different subject.
- *Mixed characteristic.* For a curve over a field, $hat(cal(O))_P tilde.equiv k[[x,y]] slash (F)$
  by the Cohen structure theorem, and the singularity has an *equation*. $hat(R)_frak(p)$ is a
  $ZZ_p$-algebra and there is no such normal form: "Gorenstein means plane curve" survives as the
  numerical statement $N(frak(f)) = "index"^2$, but $ZZ[x] slash (f)$ is a hypersurface over $ZZ$,
  not over a field, and no plane curve is produced.
- *Deformation theory.* One cannot deform $ZZ$. Geometrically $delta$ is the codimension of the
  equisingular stratum and singularities come in versal families; arithmetically $delta$ is only a
  length, and there is no moduli space in which the orders of a given type form a stratum.
]

#v(2mm)
*And one thing is gained.* The residue field is finite, not algebraically closed, so *branches* ---
primes of $cal(O)_K$ above $p$ --- and *geometric branches* --- the same after
$⊗ overline(bb(F))_p$, i.e. $sum_i f_i$ --- come apart:

#align(center, table(
  columns: 5, align: (left, center, center, center, left),
  stroke: 0.4pt + luma(170), inset: (x: 9pt, y: 4pt),
  table.header([$p$ in $K$], [branches], [geometric branches], [$delta$], [type]),
  [split], [$2$], [$2$], [$1$], [node],
  [inert], [$1$], [$2$], [$1$], [*non-split node*],
  [ramified], [$1$], [$1$], [$1$], [cusp],
))

#v(2mm)
Over $overline(k)$ there are two singularities with $delta = 1$; here there are *three*. Base change
to $overline(bb(F))_p$ collapses the first two rows onto each other and leaves the third alone ---
check 8 confirms $3$ distinct arithmetic types against $2$ distinct geometric branch counts, over
twelve pairs $(D, p)$. The extra row is not a defect of the analogy but a phenomenon the classical
picture cannot see, and it is exactly the row supplying the $p + 1$ in the class number formula.

#v(2mm)
So the honest summary is a split verdict. *The singularity is local; what it does to the class group
is local modulo the global units.* The first half is why the geometry transports at all; the second
half is why the class number formula has a unit index in it, and why the geometric side of the
dictionary closes over $overline(k)$ --- where $H^0(cal(O)^times)$ is just $overline(k)^times$ ---
and does not close here.

= What the companion script checks <sec-gp>

`local-nonmaximality.gp`, results in `results/local-nonmaximality.txt`; $0$ failed assertions.

#v(1mm)
- *(1)* Local answers are independent and glue: for seven polynomials of degree $2$ to $6$, each
  `nfbasis([f,[p]])` is verified maximal at $p$ by a lattice index computation, and the $ZZ$-module
  they span together is verified equal to $cal(O)_K$.
- *(2)* Non-maximality is $frak(m)$ not principal: $abs(frak(m) slash frak(m)^2)$ and $abs(k(frak(m)))$
  computed from lattice determinants at nine triples $(D, f, p)$ --- embedding dimension $2$ exactly
  when $p divides f$, $1$ otherwise.
- *(3)* $p$-maximality depends only on $f mod p^2$: $284$ perturbations by $p^2$, none changed it;
  and the modulus is sharp, verified on all squarefree $c <= 400$ for $x^2 + c$.
- *(4)* Dedekind's criterion is that test: agrees with the index at $35$ pairs $(f,p)$, and is
  unchanged by all $275$ perturbations by $p^2$.
- *(5)* $[cal(O)_K : cal(O)_f] = product abs(k(frak(p)))^(delta_frak(p))$ at $48$ pairs $(D, f)$.
- *(6)* The class group is not local: $D = 5$ and $D = 37$ at conductor $4$, same completion at the
  singular prime, $h = 1$ and $3$; plus four further pairs with identical local data and different
  $h(cal(O)_f) slash h_K$, the gap being the unit index every time.
- *(7)* The defect is bounded by $3$ in the imaginary case --- verified equal to $w_K slash w_f$ at
  every pair --- and reaches $60$ at $D = 5$, $f = 30$ in the real case.
- *(8)* Three arithmetic types against two geometric branch counts, over twelve pairs $(D, p)$.

= Ties to the rest of this repository <sec-repo>

`singular-orders.typ` is the geometric dictionary; this note supplies the hypothesis under which it
is a theorem (excellence, @sec-yes) and the one place it does not close (@sec-no).

`kummer-dedekind.typ` §The local picture already identifies the hypothesis $p tack.r.not m$ as local
maximality; @sec-sharp is the quantitative form, and its §Common index divisors is the local half of
the monogenicity story whose global half is cited in @sec-no.

`dirichlet-rank-one.typ` is the term that breaks locality: $cal(O)_K^times$ is the only entry of the
Picard sequence not assembled from the primes dividing the conductor.

`corestriction.typ` is the general shape of the local-to-global bookkeeping used throughout ---
what pushes down, and what one is entitled to conclude from the pushed-down class.

= References <sec-refs>

#block(inset: (left: 4pt))[
#set enum(numbering: "[1]")
+ P. Stevenhagen, *The arithmetic of number rings*, in Algorithmic Number Theory, MSRI Publications
  $44$ ($2008$), $209$--$266$. The singular locus of an order, and the language of @sec-yes.
+ H. Matsumura, *Commutative Ring Theory*, Ch. $13$ (excellent rings), and J. Nagata,
  *Local Rings*. Analytic unramifiedness and the commutation of normalisation with completion ---
  the hypothesis isolated in @sec-yes.
+ J. Neukirch, *Algebraic Number Theory*, Ch. I §$12$--$13$. Orders, conductors, and one-dimensional
  schemes.
+ H. Cohen, *A Course in Computational Algebraic Number Theory*, §$6.1$. Dedekind's criterion and
  the round-$2$/round-$4$ construction of $p$-maximal orders --- the algorithmic form of
  @sec-sharp.
+ M.-N. Gras, *Non monogénéité de l'anneau des entiers des extensions cycliques de $QQ$ de degré
  premier $ell >= 5$*, J. Number Theory $23$ ($1986$), $347$--$353$. The global obstruction to
  monogenicity cited in @sec-no.
+ J.-P. Serre, *Algebraic Groups and Class Fields*. Generalised Jacobians, and the geometric side of
  @sec-remains.
+ `singular-orders.typ`, `kummer-dedekind.typ`, `dirichlet-rank-one.typ` and `corestriction.typ` in
  this repository --- see @sec-repo.
]
