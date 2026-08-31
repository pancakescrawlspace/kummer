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
  #text(size: 16pt, weight: "bold")[Factoring a prime by factoring a polynomial]
  #v(2mm)
  #text(size: 10pt)[The Kummer--Dedekind theorem, with a full proof, the exact role of the index
  hypothesis, and the example that shows no generator can always be found]
  #v(1mm)
  #text(size: 9pt, style: "italic")[a question of René Pannekoek's; checks in
  `kummer-dedekind.gp`]
]

#v(4mm)

#block(fill: luma(240), inset: 9pt, radius: 3pt, width: 100%)[
  *The statement in one line.* If $K = QQ(theta)$ with $theta$ an algebraic integer of minimal
  polynomial $f$, and $p$ does not divide the index $[cal(O)_K : ZZ[theta]]$, then factoring $f$
  modulo $p$ factors $p$ in $cal(O)_K$: writing $overline(f) = product_(i=1)^r overline(g)_i^(e_i)$
  with the $overline(g)_i$ distinct monic irreducible,
  $ p cal(O)_K = product_(i=1)^r frak(p)_i^(e_i) , wide frak(p)_i = (p, g_i (theta)) , wide
    f(frak(p)_i slash p) = deg overline(g)_i . $
  The proof is three isomorphisms and a dimension count (@sec-proof), and every step is visible in
  the chain $cal(O)_K slash p tilde.equiv ZZ[theta] slash p tilde.equiv
  bb(F)_p [x] slash (overline(f))$. The index hypothesis is exactly what makes the *first* of these
  an isomorphism --- locally it says $ZZ_p [theta]$ is already the maximal order (@sec-local) ---
  and it cannot be dropped: @sec-fail is Dedekind's example, where at $p = 2$ the
  polynomial says "ramified" and the truth is "split completely", and where *no* choice of
  $theta$ repairs it.
]

= Setting, and what the theorem is for <sec-setting>

Let $K$ be a number field of degree $n$, $cal(O)_K$ its ring of integers. Computing the primes of
$cal(O)_K$ above a rational prime $p$ is, on the face of it, a question about a ring one does not
have explicit hold of. The Kummer--Dedekind theorem replaces it by a question about
$bb(F)_p [x]$, where factorisation is a finite and fast computation.

Fix $theta in cal(O)_K$ with $K = QQ(theta)$, and let $f in ZZ[x]$ be its minimal polynomial over
$QQ$ --- monic, of degree $n$, and with integer coefficients because $theta$ is an algebraic
integer. Then $ZZ[theta] subset.eq cal(O)_K$ is a subring of finite index; write
$ m = [cal(O)_K : ZZ[theta]] $
for that index, a positive integer (both are free $ZZ$-modules of rank $n$). One always has
$ "disc"(f) = m^2 dot "disc"(K) , $
so $p divides m$ forces $p^2 divides "disc"(f)$; in particular *$p tack.r.not "disc"(f)$ is a
sufficient condition* for the hypothesis below, and it is checkable without knowing $cal(O)_K$.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Theorem (Kummer--Dedekind).* Let $p$ be a prime with $p tack.r.not m$. Factor
  $ overline(f) = product_(i=1)^r overline(g)_i^(e_i) quad "in" bb(F)_p [x] , $
  with $overline(g)_1, ..., overline(g)_r$ distinct monic irreducible, and choose monic lifts
  $g_i in ZZ[x]$. Put $f_i = deg overline(g)_i$ and
  $ frak(p)_i = p cal(O)_K + g_i (theta) cal(O)_K . $
  Then $frak(p)_1, ..., frak(p)_r$ are precisely the distinct primes of $cal(O)_K$ above $p$,
  $ cal(O)_K slash frak(p)_i tilde.equiv bb(F)_(p^(f_i)) , wide "so" wide
    f(frak(p)_i slash p) = f_i , $
  and
  $ p cal(O)_K = product_(i=1)^r frak(p)_i^(e_i) , wide "so" wide e(frak(p)_i slash p) = e_i . $
]

= Two lemmas <sec-lemmas>

Everything rests on identifying the ring $cal(O)_K slash p cal(O)_K$. Two elementary lemmas do it.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Lemma 1 (the index lemma).* Let $A subset.eq B$ be an inclusion of torsion-free abelian groups
  with $C = B slash A$ finite, and let $p$ be a prime with $p tack.r.not abs(C)$. Then the natural
  map $A slash p A --> B slash p B$ is an isomorphism.

  #v(2mm)
  _Proof._ Apply the snake lemma to multiplication by $p$ on $0 --> A --> B --> C --> 0$:
  $ 0 --> A[p] --> B[p] --> C[p] --> A slash p A --> B slash p B --> C slash p C --> 0 . $
  Here $A[p] = B[p] = 0$ because $A$ and $B$ are torsion-free. And $C$ is a finite abelian group
  of order prime to $p$, so multiplication by $p$ is an automorphism of $C$, giving $C[p] = 0$ and
  $C slash p C = 0$. The middle map is therefore both injective and surjective. $qed$
]

#v(2mm)

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Lemma 2.* Evaluation at $theta$ induces a ring isomorphism $ZZ[x] slash (f) tilde.equiv
  ZZ[theta]$.

  #v(2mm)
  _Proof._ The map $ZZ[x] --> ZZ[theta]$, $x |-> theta$, is surjective by definition of
  $ZZ[theta]$, and $f$ lies in its kernel. Conversely let $h in ZZ[x]$ with $h(theta) = 0$. Since
  $f$ is *monic*, division with remainder can be performed inside $ZZ[x]$: $h = q f + s$ with
  $q, s in ZZ[x]$ and $deg s < deg f$. Then $s(theta) = 0$, and minimality of $f$ over $QQ$ forces
  $s = 0$. So the kernel is $(f)$. $qed$
]

#v(2mm)
Only Lemma 1 uses the hypothesis $p tack.r.not m$, and it is the only place in the whole proof
where it is used. Lemma 2 is unconditional --- a point taken up in @sec-order.

= The proof <sec-proof>

Throughout, $p tack.r.not m$ and $overline(f) = product_i overline(g)_i^(e_i)$ as in the theorem.

== Step 1: the ring modulo $p$ <sec-step1>

Applying Lemma 1 to $ZZ[theta] subset.eq cal(O)_K$, whose quotient has order $m$ prime to $p$, and
then Lemma 2:
$ cal(O)_K slash p cal(O)_K tilde.equiv ZZ[theta] slash p ZZ[theta] tilde.equiv
  ZZ[x] slash (f, p) tilde.equiv bb(F)_p [x] slash (overline(f)) . $
This is the whole content of the theorem in compressed form; the rest is reading it.

== Step 2: splitting the right-hand side <sec-step2>

The $overline(g)_i$ are distinct irreducibles, so the ideals $(overline(g)_i^(e_i))$ are pairwise
comaximal, and the Chinese remainder theorem gives
$ bb(F)_p [x] slash (overline(f)) tilde.equiv product_(i=1)^r R_i , wide
  R_i := bb(F)_p [x] slash (overline(g)_i^(e_i)) . $
Each $R_i$ is a *local* ring: $bb(F)_p [x]$ is a principal ideal domain, so the ideals of $R_i$ are
the $(overline(g)_i^j)$ for $0 <= j <= e_i$, totally ordered, with unique maximal ideal
$frak(m)_i = (overline(g)_i)$. Its residue field is
$ R_i slash frak(m)_i tilde.equiv bb(F)_p [x] slash (overline(g)_i) tilde.equiv
  bb(F)_(p^(f_i)) , $
and as an $bb(F)_p$-vector space $dim_(bb(F)_p) R_i = deg overline(g)_i^(e_i) = e_i f_i$.

== Step 3: the primes, and their residue degrees <sec-step3>

Primes of $cal(O)_K$ containing $p$ correspond bijectively to maximal ideals of
$cal(O)_K slash p cal(O)_K$, and these are the primes of $cal(O)_K$ above $p$. In a finite product
of local rings the maximal ideals are exactly
$ M_i = R_1 times dots.c times frak(m)_i times dots.c times R_r , wide i = 1, ..., r , $
one for each factor. So there are *exactly $r$* primes above $p$.

Let $frak(p)_i subset.eq cal(O)_K$ be the preimage of $M_i$. Then
$cal(O)_K slash frak(p)_i tilde.equiv R_i slash frak(m)_i tilde.equiv bb(F)_(p^(f_i))$, which is
the assertion $f(frak(p)_i slash p) = f_i$.

It remains to see that $frak(p)_i = p cal(O)_K + g_i (theta) cal(O)_K$. Both contain $p$, so it is
enough to compare their images in $cal(O)_K slash p cal(O)_K tilde.equiv product_j R_j$. The image
of $g_i (theta)$ is the tuple whose $j$-th entry is $overline(g)_i$ read in $R_j$. For $j eq.not i$
the polynomial $overline(g)_i$ is coprime to $overline(g)_j$, hence to $overline(g)_j^(e_j)$, hence
*invertible* in $R_j$; so the ideal generated by that tuple has $j$-th component all of $R_j$. For
$j = i$ it generates $frak(m)_i$. So the image of $p cal(O)_K + g_i (theta) cal(O)_K$ is exactly
$M_i$, and the two ideals coincide.

== Step 4: the exponents <sec-step4>

By unique factorisation of ideals in the Dedekind domain $cal(O)_K$, and because
@sec-step3 identified *all* the primes above $p$,
$ p cal(O)_K = product_(i=1)^r frak(p)_i^(a_i) $
for some integers $a_i >= 1$, and we must show $a_i = e_i$. The $frak(p)_i^(a_i)$ are pairwise
comaximal, so the Chinese remainder theorem in $cal(O)_K$ gives a second decomposition
$ cal(O)_K slash p cal(O)_K tilde.equiv product_(i=1)^r cal(O)_K slash frak(p)_i^(a_i) . $
Both this and @sec-step2 write the finite ring $cal(O)_K slash p cal(O)_K$ as a product of local
rings, and such a decomposition is unique up to order: the factors are the images under the
primitive idempotents, equivalently the localisations at the finitely many maximal ideals. Matching
the factor whose maximal ideal is the one attached to $frak(p)_i$,
$ cal(O)_K slash frak(p)_i^(a_i) tilde.equiv R_i . $

Now count dimensions over $bb(F)_p$. The right-hand side has dimension $e_i f_i$ by @sec-step2. For
the left, filter
$ cal(O)_K supset.eq frak(p)_i supset.eq frak(p)_i^2 supset.eq dots.c supset.eq
  frak(p)_i^(a_i) . $
Each quotient $frak(p)_i^j slash frak(p)_i^(j+1)$ is a one-dimensional vector space over
$cal(O)_K slash frak(p)_i$: picking $t in frak(p)_i^j without frak(p)_i^(j+1)$, multiplication by
$t$ induces a surjection $cal(O)_K slash frak(p)_i --> frak(p)_i^j slash frak(p)_i^(j+1)$, which is
an isomorphism because the localisation of $cal(O)_K$ at $frak(p)_i$ is a discrete valuation ring.
Hence
$ dim_(bb(F)_p) cal(O)_K slash frak(p)_i^(a_i) = a_i f_i . $
Comparing, $a_i f_i = e_i f_i$, and $f_i >= 1$, so $a_i = e_i$. $qed$

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *A shorter finish, if one prefers.* Instead of counting dimensions, compare nilpotency indices.
  In $R_i$ the maximal ideal satisfies $frak(m)_i^(e_i) = 0$ and $frak(m)_i^(e_i - 1) eq.not 0$; in
  $cal(O)_K slash frak(p)_i^(a_i)$ the maximal ideal satisfies the same with $a_i$ in place of
  $e_i$. Isomorphic rings, so $a_i = e_i$. The dimension count is kept above because it also
  delivers the corollary below for free.
]

#v(2mm)
*Corollary (the fundamental identity).* $cal(O)_K$ is free of rank $n$ over $ZZ$, so
$dim_(bb(F)_p) cal(O)_K slash p cal(O)_K = n$; comparing with @sec-step2,
$ sum_(i=1)^r e_i f_i = deg overline(f) = n . $

= What survives without the hypothesis <sec-order>

Lemma 2 is unconditional, so *for every* prime $p$, with no hypothesis at all,
$ ZZ[theta] slash p ZZ[theta] tilde.equiv bb(F)_p [x] slash (overline(f)) , $
and @sec-step2 and @sec-step3 go through verbatim with $cal(O)_K$ replaced by $ZZ[theta]$. So the
ideals $(p, g_i (theta))$ are always precisely the primes of the *order* $ZZ[theta]$ above $p$,
with residue degrees $deg overline(g)_i$.

What fails when $p divides m$ is everything downstream. The primes of $ZZ[theta]$ above $p$ need
not be the primes of $cal(O)_K$ above $p$ --- distinct primes of $cal(O)_K$ can contract to the
same prime of $ZZ[theta]$ --- and $ZZ[theta]$ is not a Dedekind domain at $p$, so there is no
factorisation of $p ZZ[theta]$ into prime powers to compare with in the first place. @sec-step4 is
the step that collapses.

= The local picture <sec-local>

Everything above is a statement about the semilocal ring $cal(O)_K slash p cal(O)_K$, and it reads
better after completing. Doing so separates what is true unconditionally from what the index
hypothesis buys.

== The unconditional statement is $p$-adic <sec-padic>

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  For every prime $p$, with no hypothesis at all,
  $ K ⊗_QQ QQ_p tilde.equiv product_(frak(p) divides p) K_frak(p) , $
  and on the polynomial side this is the factorisation of $f$ into irreducibles over $QQ_p$:
  $ f = product_(frak(p) divides p) F_frak(p) , wide
    K_frak(p) tilde.equiv QQ_p [x] slash (F_frak(p)) , wide
    deg F_frak(p) = e(frak(p) slash p) dot f(frak(p) slash p) . $
  *The primes above $p$ correspond to the irreducible factors of $f$ over $QQ_p$* --- always.
]

#v(2mm)
Check 7 confirms this at $506$ pairs $(f, p)$: the number of $p$-adic factors always equals the
number of primes, and the multiset of their degrees always equals the multiset of the $e f$. So
Kummer--Dedekind is not really a theorem about $cal(O)_K$; it is the assertion that *when
$p tack.r.not m$, the factorisation mod $p$ already determines the $p$-adic one*.

== The hypothesis is local maximality <sec-localmax>

Tensor $ZZ[theta] subset.eq cal(O)_K$ with $ZZ_p$. The quotient has order the $p$-part of $m$, so

$ p tack.r.not m quad <==> quad ZZ_p [theta] = cal(O)_K ⊗_ZZ ZZ_p =
  product_(frak(p) divides p) cal(O)_frak(p) . $

That is the whole content of the hypothesis: *$ZZ_p [x] slash (f)$ is the maximal order of
$product_frak(p) K_frak(p)$*. Nothing global is being asked, which is why a failure at one prime is
invisible at every other, and why computing $cal(O)_K$ splits into independent $p$-maximal order
problems, one for each $p$ with $p^2 divides "disc"(f)$.

== Hensel is the bridge, and one can see where it stops <sec-hensel>

Hensel's lemma for coprime factorisations lifts $overline(f) = product_i overline(g)_i^(e_i)$ to a
factorisation over $ZZ_p$,
$ f = product_(i=1)^r F_i , wide overline(F)_i = overline(g)_i^(e_i) , wide
  "with the " F_i " pairwise coprime," $
so that $ZZ_p [x] slash (f) tilde.equiv product_i ZZ_p [x] slash (F_i)$ --- the local form of
@sec-step2. But the $F_i$ *need not be irreducible over $QQ_p$*, and that is exactly the fault line:

#block(inset: (left: 12pt, y: 2pt), stroke: (left: 2pt + luma(190)))[
  - $p tack.r.not m$: there are exactly $r$ primes above $p$ (@sec-step3) and exactly $r$ coprime
    Hensel factors, so each $F_i$ *is* irreducible, $ZZ_p [x] slash (F_i) = cal(O)_(frak(p)_i)$ is a
    complete discrete valuation ring, and $e_i, f_i$ are its ramification index and residue degree.
    That is the theorem.
  - $p divides m$: some $F_i$ factors further over $QQ_p$, and $ZZ_p [x] slash (F_i)$ is a
    *non-maximal order* inside a product of several $cal(O)_frak(p)$.
]

#v(2mm)
Dedekind's example is the second case in miniature. There $r = 2$, but $f$ has *three* roots in
$ZZ_2$, congruent to $20, 22, 23$ modulo $2^6$. Two of them are even and one is odd: the Hensel
factor lifting $x^2$ is the product of the first two, the factor lifting $x + 1$ is the third. So
$ZZ_2 [x] slash (F_1)$ is a non-maximal order in $ZZ_2 times ZZ_2$ --- a ring whose residue algebra
$bb(F)_2 [x] slash (x^2)$ *looks ramified* while it sits inside a split algebra. That is the whole
of the deception.

== Common index divisors, properly <sec-monogenic>

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  Every finite extension of $QQ_p$ is monogenic: $cal(O)_frak(p) = ZZ_p [alpha]$ for some $alpha$.
  So there is *never* an obstruction at a single prime. The obstruction is to the *product* being
  monogenic.

  #v(1.5mm)
  For if $product_(frak(p) divides p) cal(O)_frak(p) = ZZ_p [x] slash (f)$, reducing mod $p$ gives
  $product_frak(p) bb(F)_p [x] slash (overline(g)_frak(p)^(e_frak(p)))$ with the
  $overline(g)_frak(p)$ *distinct* irreducibles and $deg overline(g)_frak(p) = f(frak(p) slash p)$.
  Hence, for every $d$,
  $ hash {frak(p) divides p : f(frak(p) slash p) = d} space <= space
    hash {"monic irreducibles of degree" d "over" bb(F)_p} . $
]

#v(2mm)
In Dedekind's field, $product_(frak(p) divides 2) cal(O)_frak(p) = ZZ_2 times ZZ_2 times ZZ_2$,
which would force $overline(f)$ to be a product of three *distinct* monic linear polynomials over
$bb(F)_2$. There are two. So $ZZ_2 times ZZ_2 times ZZ_2$ is *not a monogenic $ZZ_2$-algebra*, and
that --- a single fact about a single ring --- is why $2$ is a common index divisor. Compare the
argument of @sec-fail, which reaches the same conclusion but has to quantify over every possible
generator $theta'$. Check 8 runs the inequality at $1564$ triples $(f, p, d)$ and finds exactly one
violation: Dedekind's, at $p = 2$, $d = 1$.

== Sufficient, not necessary <sec-notnec>

The local view also shows that failure of the hypothesis is a warning rather than a verdict. The
batch of check 7 contains three pairs with $p divides m$, and they behave in three different ways:

#align(center, table(
  columns: 5, align: (left, center, center, center, left),
  stroke: 0.4pt + luma(170), inset: (x: 9pt, y: 3.5pt),
  table.header([$f$, at $p = 2$], [factors mod $2$], [over $QQ_2$],
               [$[e,f]$ predicted], [truth]),
  [$x^2 - 5$], [$1$], [$1$], [$[2,1]$], [$[1,2]$ --- *wrong*, $2$ is inert],
  [$x^2 - 12$], [$1$], [$1$], [$[2,1]$], [$[2,1]$ --- right anyway],
  [$x^3 - x^2 - 2x - 8$], [$2$], [$3$], [$[1,1],[2,1]$], [$[1,1],[1,1],[1,1]$ --- *wrong*],
))

#v(2mm)
The middle row is a case where the conclusion survives the loss of the hypothesis. The first is
subtler and worth noticing: there the *counts* agree --- one factor mod $2$, one irreducible factor
over $QQ_2$ --- and the answer is still wrong, because $ZZ_2 [sqrt(5)]$ has index $2$ in
$cal(O)_frak(p) = ZZ_2 [(1 + sqrt(5)) slash 2]$ and the reduction $overline(f) = (x+1)^2$ of the
*wrong* order reports ramification where there is none. When the hypothesis fails, the thing to
compute is the $p$-adic factorisation, not the reduction.

= Dedekind's criterion <sec-criterion>

The hypothesis $p tack.r.not m$ can be tested without computing $cal(O)_K$, using only $f$ and $p$.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Dedekind's criterion.* With $overline(f) = product_i overline(g)_i^(e_i)$ as above, set
  $ overline(g) = product_(i=1)^r overline(g)_i , wide
    overline(h) = overline(f) slash overline(g) , $
  lift $g, h in ZZ[x]$ monic, and put $T = (g h - f) slash p in ZZ[x]$ --- an integer polynomial,
  since $g h equiv f$ (mod $p$). Then
  $ p tack.r.not [cal(O)_K : ZZ[theta]] quad <==> quad
    gcd(overline(T), overline(g), overline(h)) = 1 quad "in" bb(F)_p [x] . $
]

#v(2mm)
Check 4 runs this against `nfinit(f).index` on $1045$ pairs $(f, p)$ with no disagreement. In
practice one uses the cheaper sufficient condition first: if $overline(f)$ is *separable* --- i.e.
$p tack.r.not "disc"(f)$ --- then all $e_i = 1$, $overline(h) = 1$, the criterion is satisfied
automatically, and $p$ is moreover unramified. Only the finitely many $p$ with
$p^2 divides "disc"(f)$ need any thought.

= Where it fails, and why no generator can save it <sec-fail>

#block(fill: rgb("#fff4e6"), inset: 9pt, radius: 3pt, width: 100%)[
  *Dedekind's example.* $f = x^3 - x^2 - 2x - 8$, with
  $ "disc"(f) = -2012 = 2^2 dot (-503) , wide "disc"(K) = -503 , wide m = 2 . $
  So the hypothesis fails exactly at $p = 2$, and there the conclusion is false. Modulo $2$,
  $ overline(f) = x^2 (x + 1) , $
  from which the theorem's recipe would predict two primes above $2$, one ramified with
  $e = 2, f = 1$ and one with $e = f = 1$. The truth (check 2) is that
  $ 2 cal(O)_K = frak(p)_1 frak(p)_2 frak(p)_3 , wide e_i = f_i = 1 : $
  $2$ *splits completely*. Not one feature of the prediction is right --- not the number of primes,
  not the ramification. At every other prime below $500$ the theorem holds for this same $f$.
]

#v(2mm)
One might hope to repair this by choosing a better generator. For this field one cannot, and the
reason is a counting argument that needs no computation.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *$2$ is a common index divisor of $K$.* Suppose $theta' in cal(O)_K$ generated $K$ with
  $2 tack.r.not [cal(O)_K : ZZ[theta']]$, and let $f'$ be its minimal polynomial, of degree $3$.
  Since $2$ splits completely, the theorem applied to $theta'$ would force $overline(f')$ to be a
  product of *three distinct monic linear* polynomials in $bb(F)_2 [x]$. But $bb(F)_2 [x]$ contains
  only *two* monic linear polynomials, $x$ and $x + 1$. Contradiction. So
  $2 divides [cal(O)_K : ZZ[theta']]$ for *every* generator $theta'$.
]

#v(2mm)
Such a $p$ is called a *common index divisor*; the older name is *inessential discriminant
divisor*, since it divides $"disc"(f)$ for every choice of $f$ while --- as here, where
$"disc"(K) = -503$ --- contributing nothing to $"disc"(K)$. They exist only when the splitting type of $p$
demands more monic irreducibles of some degree than $bb(F)_p [x]$ possesses, so $p < n$ is
necessary --- for a cubic field only $p = 2$ can be one. Check 3 confirms the theoretical argument
by brute force: among all $theta' = a + b theta + c theta^2$ with $abs(a), abs(b), abs(c) <= 6$
that generate $K$, not one has odd index. @sec-monogenic reaches the same conclusion without
quantifying over generators at all.

= A worked example <sec-worked>

$K = QQ(2^(1 slash 3))$, $f = x^3 - 2$. Here $"disc"(f) = -108 = "disc"(K)$, so $m = 1$ and the
theorem applies at *every* prime, ramified ones included (check 6):

#align(center, table(
  columns: 3, align: (center, left, left),
  stroke: 0.4pt + luma(170), inset: (x: 10pt, y: 3.5pt),
  table.header([$p$], [$overline(f)$ in $bb(F)_p [x]$], [$p cal(O)_K$]),
  [$2$], [$x^3$], [$frak(p)^3$, with $frak(p) = (2, theta)$ --- totally ramified],
  [$3$], [$(x+1)^3$], [$frak(p)^3$, with $frak(p) = (3, theta + 1)$ --- totally ramified],
  [$5$], [$(x+2)(x^2 + 3x + 4)$], [$frak(p)_1 frak(p)_2$ with $f_1 = 1$, $f_2 = 2$],
  [$7$], [$x^3 + 5$ (irreducible)], [$frak(p)$, inert, $f = 3$],
  [$29$], [$(x+3)(x^2 + 26 x + 9)$], [$frak(p)_1 frak(p)_2$ with $f_1 = 1$, $f_2 = 2$],
  [$31$], [$(x+11)(x+24)(x+27)$], [$frak(p)_1 frak(p)_2 frak(p)_3$ --- splits completely],
  [$127$], [$(x+5)(x+27)(x+95)$], [$frak(p)_1 frak(p)_2 frak(p)_3$ --- splits completely],
))

#v(2mm)
The three regimes at $5, 7, 31$ are the three ways $2$ can behave as a cube modulo $p$ when
$p equiv 1$ (mod $3$) or not, which is the cubic-residue question of `cubic-residues.typ`; the
ramification at $2$ and $3$ is visible in $"disc"(f) = -2^2 dot 3^3$.

= What the companion script checks <sec-gp>

`kummer-dedekind.gp`, results in `results/kummer-dedekind.txt`. Eleven fields of degree $2$ to $5$,
all primes below $500$; the truth is always taken from `idealprimedec` in $cal(O)_K$.

#v(1mm)
- *(1)* The theorem itself: the multiset ${[e_i, deg overline(g)_i]}$ read off $overline(f)$ against
  the multiset ${[e(frak(p) slash p), f(frak(p) slash p)]}$ from $cal(O)_K$, at all $1042$
  prime-field pairs with $p tack.r.not m$. Zero mismatches; $3$ pairs skipped for dividing the
  index.
- *(2)* @sec-fail: the prediction and the truth at $p = 2$ for $x^3 - x^2 - 2x - 8$, together with
  the confirmation that the theorem holds for that $f$ at every other $p < 500$.
- *(3)* The common-index-divisor argument, checked against brute force over $13^3$ candidate
  generators: none has odd index.
- *(4)* Dedekind's criterion of @sec-criterion against `nf.index` on $1045$ pairs $(f, p)$: no
  disagreement.
- *(5)* $"disc"(f) = m^2 "disc"(K)$ on all eleven fields, the fundamental identity
  $sum e_i f_i = n$ at every prime, and that $p divides m$ always entails
  $p^2 divides "disc"(f)$.
- *(6)* The table of @sec-worked.
- *(7)* @sec-padic unconditionally: at $506$ pairs $(f, p)$ with $p < 200$, the number of
  irreducible factors of $f$ over $QQ_p$ equals the number of primes above $p$, and their degrees
  match the products $e f$. Then the three index-dividing pairs of @sec-notnec in detail.
- *(8)* The monogenicity count of @sec-monogenic at $1564$ triples $(f, p, d)$: exactly one
  violation, which is the common index divisor.

= References <sec-refs>

#block(inset: (left: 4pt))[
#set enum(numbering: "[1]")
+ R. Dedekind, *Über den Zusammenhang zwischen der Theorie der Ideale und der Theorie der höheren
  Kongruenzen*, Abh. Akad. Wiss. Göttingen *23* (1878), 1--23. The theorem, the criterion of
  @sec-criterion, and the example of @sec-fail.
+ J. Neukirch, *Algebraic Number Theory*, Springer 1999. I §8, on the decomposition of primes in
  extensions of Dedekind domains, where the theorem is stated with the *conductor* of
  $ZZ[theta]$ in place of the index.
+ J.-P. Serre, *Local Fields*, Springer 1979. Chapters I--III for complete discrete valuation
  rings, the monogenicity of $cal(O)_frak(p)$ over $ZZ_p$ used in @sec-monogenic, and the
  different.
+ P. Stevenhagen, *Number Rings*, Leiden lecture notes. The order-theoretic treatment of
  @sec-order, where the statement is made for $ZZ[theta]$ first and $cal(O)_K$ second.
+ H. Cohen, *A Course in Computational Algebraic Number Theory*, Springer 1993. Dedekind's
  criterion as an algorithm, and the round-2 / Buchmann--Lenstra machinery a system like PARI
  falls back on when $p$ divides the index.
]
