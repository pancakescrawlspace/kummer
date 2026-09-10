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
  #text(size: 16pt, weight: "bold")[Why wild norm residue symbols are hard]
  #v(2mm)
  #text(size: 10pt)[Tame symbols live in the residue field; wild ones live in the
  $p$-adic logarithm. The depth, the group sizes and the failure of every
  shortcut, computed]
  #v(1mm)
  #text(size: 9pt, style: "italic")[on a question of Rene Pannekoek;
  everything checked in `wild-symbols.gp`, output in `results/wild-symbols.txt`]
]

#v(4mm)

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *The one-line answer.* For $v divides.not n$ the symbol is a function on the residue field:
  units pair trivially, $K^times slash (K^times)^n$ has $n^2$ elements, and the value is one
  Legendre-type exponentiation in $FF_q$. For $v divides n$ none of that survives: units pair
  non-trivially, the group has $n^2 slash |n|_K$ elements, and the symbol depends on its
  arguments to depth $p e slash (p-1)$ in the maximal ideal. *Tame is algebraic, wild is
  analytic* --- the honest formulas involve $p$-adic logarithms and formal power series, not
  residues. You already know one wild symbol: the quadratic symbol at $2$, the one that needs
  $a$ and $b$ *modulo $8$* rather than modulo $p$.
]

= The two regimes <sec-two>

For a local field $K$ with residue field $FF_q$ containing $mu_n$, the $n$-th norm residue
symbol is
$ ( , )_n : K^times slash (K^times)^n times K^times slash (K^times)^n --> mu_n , quad
  (a,b)_n = (sigma_a (root(n, b))) slash root(n, b) , $
$sigma_a$ being the local Artin symbol. It is $1$ exactly when $a$ is a norm from
$K(root(n, b))$.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Tame, $v divides.not n$.* The extension $K(root(n,b)) slash K$ is tamely ramified, and the
  Artin map on units factors through the residue field. The symbol is given in closed form by
  $ (a,b)_n equiv (-1)^(v(a) v(b) (q-1) slash n) thin (a^(v(b)) slash b^(v(a)))^((q-1) slash n)
    mod frak(m) , $
  one exponentiation in $FF_q^times$. For $n = 2$ and odd $p$ this is the familiar
  $(a,b)_p = ((-1 slash p))^(alpha beta) ((u slash p))^beta ((w slash p))^alpha$ with
  $a = p^alpha u$, $b = p^beta w$ --- checked here against PARI on $195792$ cases, $0$
  disagreements.
]

Everything below is what breaks when $v divides n$.

= Break 1: units stop being invisible <sec-units>

If $v divides.not n$ then $U^((1)) = 1 + frak(m)$ is a pro-$p$ group and $n$ is prime to $p$, so
$U^((1))$ is *uniquely $n$-divisible*: it sits inside $(K^times)^n$ and dies in the quotient. The
symbol cannot see units at all.

Over all odd $p < 200$ and all pairs of units, $556656$ symbols were computed and *every one is
trivial.* At $v = 2$ the four unit classes pair like this:

#align(center)[
#table(columns: 5, align: center, stroke: 0.4pt, inset: 6pt,
  [$(u, w)_2$], [$1$], [$3$], [$5$], [$7$],
  [$1$], [$+1$], [$+1$], [$+1$], [$+1$],
  [$3$], [$+1$], [$bold(-1)$], [$+1$], [$bold(-1)$],
  [$5$], [$+1$], [$+1$], [$+1$], [$+1$],
  [$7$], [$+1$], [$bold(-1)$], [$+1$], [$bold(-1)$],
)]

$(3,3)_2 = -1$: two principal units pairing non-trivially. At an odd place that is impossible
whatever the units are. Wildness *is* the statement that the unit filtration survives into
$K^times slash (K^times)^n$, and the symbol therefore has a filtration to see.

== The pairing has depth

Which layers pair? At $v = 2$ the symbol is non-trivial on $U^((i)) times U^((j))$ exactly when
$i + j <= 2$:

#align(center)[
#table(columns: 5, align: center, stroke: 0.4pt, inset: 5pt,
  [$(i,j)$], [$(1,1)$], [$(1,2)$], [$(2,2)$], [$(i+j >= 3)$],
  [non-trivial?], [*yes*], [no], [no], [no],
)]

That bound $i + j <= p e slash (p-1)$ is the general shape. The tame symbol has no filtration at
all: it is trivial on $U times U$ outright.

= Break 2: how much of $a$ and $b$ the symbol sees <sec-precision>

At an odd $p$, changing $a$ or $b$ by $p$ never changes the symbol --- checked for all odd
$p < 100$, $0$ violations. *The tame symbol reads its arguments modulo $p$.*

At $v = 2$ it does not. $1$ and $5$ agree modulo $4$, but
$ (1, 2)_2 = +1 , quad (5, 2)_2 = -1 . $
Modulo $4$ is not enough; modulo $8$ is (checked on $10^4$ odd pairs, $0$ violations). This is
the wildness everyone has met without naming it.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *The depth, in general.* Write $e = v_K (p)$. Then
  $ U^((m)) subset.eq (K^times)^n quad "exactly when" quad m > (p e) slash (p-1) . $
  For $QQ_2$ and $n = 2$: $e = 1$, $p e slash (p-1) = 2$, so $m >= 3$ --- modulo $8$. Verified.
]

== The same computation for cubes <sec-cubes>

The interesting case is an odd $p$, where nobody has memorised the answer. Take
$K = QQ_3 (zeta_3)$, $cal(O) = ZZ[omega]$ with $omega^2 = -1-omega$, $pi = omega - 1$ and
$pi^2 = -3 omega$, so $e = v_pi (3) = 2$ and $p e slash (p-1) = 3$. The prediction is $m >= 4$.
Brute force over $cal(O) slash pi^12 = cal(O) slash 3^6$ (well past the Hensel threshold
$2 e + 1 = 5$, so "cube mod $pi^12$" really means "cube"):

#align(center)[
#table(columns: 3, align: (center, right, center), stroke: 0.4pt, inset: 5pt,
  [$m$], [units $equiv 1 mod pi^m$], [all cubes?],
  [$0$], [$354294$], [no ($341172$ fail)],
  [$1$], [$177147$], [no ($170586$ fail)],
  [$2$], [$59049$], [no ($52488$ fail)],
  [$3$], [$19683$], [no ($13122$ fail)],
  [$4$], [$6561$], [*yes*],
  [$5$], [$2187$], [*yes*],
  [$6$], [$729$], [*yes*],
)]

Exactly $m >= 4 = p e slash (p-1) + 1$, on the nose. Note the last failing row: at $m = 3$
precisely one third of the units are cubes --- there is exactly one layer of the filtration left,
and the symbol is what detects it.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *This is the same constant as `hensel-different.typ`.* That document asks why square classes
  need $a$ modulo $8$ at $v = 2$ and only $a$ modulo $v$ at odd $v$, and answers: the intrinsic
  invariant is the Kähler different, $e = v(det J)$, and Hensel's threshold is $2 e + 1$ --- so
  $3$ at $2$ and $1$ elsewhere. Here the same $e$ controls the same phenomenon from the other
  side: $2 e + 1$ is the (non-sharp) sufficient bound, $p e slash (p-1)$ the sharp one. For
  $QQ_2$ they agree at $3$; for cubes at $3$ Hensel gives $5$ where the truth is $4$. *Wild
  ramification is a statement about the different, and precision is what it costs.*
]

= Break 3: the group explodes <sec-size>

$ |K^times slash (K^times)^n| = n^2 slash |n|_K . $
Tame means $|n|_K = 1$ and the answer is $n^2$. Wild means $|n|_K < 1$, and the factor
$|n|_K^(-1)$ is the whole story. For $n = 2$: four classes over odd $QQ_p$, eight over $QQ_2$ ---
the familiar ${plus.minus 1, plus.minus 2, plus.minus 5, plus.minus 10}$.

For $n = p$ the symbol is only defined over $K = QQ_p (zeta_p)$, which is totally ramified of
degree $p - 1$, so $e = p-1$, $|p|_K^(-1) = p^(p-1)$ and $|K^times slash (K^times)^p| = p^(p+1)$:

#align(center)[
#table(columns: 4, align: (center, right, right, center), stroke: 0.4pt, inset: 5pt,
  [$p$], [tame answer $p^2$], [wild answer $p^(p+1)$], [depth $p e slash (p-1) = p$],
  [$3$], [$9$], [$81$], [$3$],
  [$5$], [$25$], [$15625$], [$5$],
  [$7$], [$49$], [$5764801$], [$7$],
  [$11$], [$121$], [$3138428376721$], [$11$],
  [$13$], [$169$], [$3937376385699289$], [$13$],
)]

For $p = 11$ --- the case that came up in `ec-density-bm.typ` --- any formula for the symbol has
to be a function on a group with $3.1 dot 10^12$ elements, not $121$.

= Break 4: acquiring $mu_n$ makes it worse <sec-mun>

The symbol is not even *defined* until $mu_n subset.eq K$. For $n = p$ odd this forces
$QQ_p (zeta_p) slash QQ_p$, totally ramified of degree $p-1$ --- so the fix for one problem
deepens the other:

#align(center)[
#table(columns: 4, align: (left, center, center, center), stroke: 0.4pt, inset: 5pt,
  [field], [$e = v(p)$], [depth $p e slash (p-1)$], [$[K : QQ_p]$],
  [$QQ_p$ (no $mu_p$)], [$1$], [$< 2$], [$1$],
  [$QQ_3 (zeta_3)$], [$2$], [$3$], [$2$],
  [$QQ_5 (zeta_5)$], [$4$], [$5$], [$4$],
  [$QQ_7 (zeta_7)$], [$6$], [$7$], [$6$],
  [$QQ_11 (zeta_11)$], [$10$], [$11$], [$10$],
)]

For $n = 2$ this costs nothing: $mu_2 = {plus.minus 1}$ is already in $QQ_2$, $e = 1$, depth $2$,
and the whole answer fits in a mod-$8$ formula. *That is why the quadratic symbol at $2$ is the
one wild symbol with a closed form* --- and the only one in PARI or Sage.

= What the explicit formulas actually look like <sec-formulas>

The wild symbol is not uncomputable; it is that no residue-field shortcut exists, so any formula
must encode a $p$-adic analytic object.

- *Artin--Hasse (1928)*, for $K = QQ_p (zeta_(p^n))$ and $u$ a principal unit, express the symbol
  in the shape
  $ (u, thin dot)_(p^n) = zeta_(p^n)^(#h(2pt) "Tr"_(K slash QQ_p) ( dots.h thin log u ) slash p^n) , $
  a $p$-adic logarithm followed by a trace. Computable --- but you must carry $log u$ to
  precision $p e slash (p-1)$ in a field of degree $p-1$, and the formulas cover only special
  second arguments ($zeta$, or the uniformiser).
- *General explicit reciprocity laws* --- Iwasawa, Wiles, Coleman, Vostokov, Brückner and others
  --- handle general local fields and general $n$. They are power-series formulas: Coleman
  series, residues of differential forms, formal-group logarithms. Each is a theorem with real
  content, not a symbol you evaluate in a line.
- *Lubin--Tate* theory makes the local Artin map completely explicit via formal groups, so
  "computable in principle" is fair. But it is a formal-group computation, not a finite-field one.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *So the honest summary of "hard".* Not undecidable, not even deep --- just: no shortcut through
  the residue field, hence $p$-adic analysis to depth $p e slash (p-1)$, in a field you had to
  ramify by $p-1$ to get into, on a class group of size $p^(p+1)$. Every one of those four
  numbers is $1$ or trivial in the tame case.
]

= Lubin--Tate: where the constant comes from <sec-lt>

Lubin--Tate theory builds the maximal totally ramified abelian extension of $K$ out of a formal
group $F_pi$ over $cal(O)_K$ with
$ [pi](x) = pi x + dots.h + x^q , $
and makes the local Artin map completely explicit: a uniformiser acts trivially on
$K(F_pi [pi^n])$ and by Frobenius on $K^"ur"$, while a unit $u$ acts on $F_pi [pi^n]$ by
$[u^(-1)]$. So the norm residue symbol *is* a formal-group computation, and "computable in
principle" is exactly what that buys.

For $K = QQ_p$ and $pi = p$ the Lubin--Tate group is the multiplicative one, $hat(GG)_m$, and
$K_pi = QQ_p (mu_(p^infinity))$ --- so Lubin--Tate recovers the cyclotomic picture and the
Artin--Hasse formulas of @sec-formulas rather than replacing them. Wiles' explicit reciprocity law
is the Lubin--Tate generalisation of Artin--Hasse, and Coleman power series are what make it work.

== The depth is a formal-group statement <sec-lt-depth>

What the formal group explains outright is the constant $p e slash (p-1)$ that ran through
@sec-precision. On $hat(GG)_m$,
$ [p](x) = (1+x)^p - 1 = p x + binom(p,2) x^2 + dots.h + x^p , $
so with $j = v(x)$ and $e = v_K (p)$ the two extreme terms compete:
$ v(p x) = e + j , quad v(x^p) = p j . $

#align(center)[
#table(columns: 4, align: (center, center, center, left), stroke: 0.4pt, inset: 5pt,
  [], [$v(p x)$], [$v(x^p)$], [which wins],
  [$j < e slash (p-1)$], [$e+j$], [$p j$], [$x^p$ --- *Frobenius regime*, valuation
    multiplied by $p$],
  [$j = e slash (p-1)$], [$e+j$], [$p j$], [tie --- the crossover],
  [$j > e slash (p-1)$], [$e+j$], [$p j$], [$p x$ --- *linear regime*, valuation shifted by $e$],
)]

Above the crossover $[p]$ carries $frak(m)^j$ onto $frak(m)^(j+e)$, so its image contains
$frak(m)^m$ as soon as $m >= e slash (p-1) + e$, which is the threshold $m > p e slash (p-1)$.
Evaluated:

#align(center)[
#table(columns: 5, align: (left, center, center, center, center), stroke: 0.4pt, inset: 5pt,
  [$K$], [$e$], [$e slash (p-1)$], [$p e slash (p-1)$], [$U^((m))$ are $p$-th powers for],
  [$QQ_2$], [$1$], [$1$], [$2$], [$m >= 3$],
  [$QQ_3 (zeta_3)$], [$2$], [$1$], [$3$], [$m >= 4$],
  [$QQ_5 (zeta_5)$], [$4$], [$1$], [$5$], [$m >= 6$],
  [$QQ_11 (zeta_11)$], [$10$], [$1$], [$11$], [$m >= 12$],
)]

The first two rows are exactly the thresholds measured by brute force in @sec-precision --- mod
$8$ for squares in $QQ_2$, and $m >= 4$ for cubes in $QQ_3 (zeta_3)$.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *So "wild" has a one-line formal-group meaning.* Below $j = e slash (p-1)$ the map $[p]$
  behaves like *Frobenius*, $x |-> x^p$, multiplying valuations by $p$; above it like
  *multiplication by $p$*, shifting valuations by $e$. The crossover is precisely where $log_F$
  converges and becomes an isomorphism $F(frak(m)^j) tilde.equiv frak(m)^j$ --- which is why the
  symbol turns analytic there, and why every explicit reciprocity law is a formula in logarithms.

  In the tame case there is no crossover to cross. $n$ is prime to $p$, so $[n]$ is invertible on
  the formal group and the whole unit filtration is $n$-divisible; the formal group never enters
  the computation, and one is left with the residue field. *Tame means the Lubin--Tate group is
  invisible.*
]

= Coleman: the same idea, twice <sec-coleman>

@sec-lt ended on "every explicit reciprocity law is a formula in logarithms". That sentence has a
sequel, and it explains why the name attached to the power series in @sec-formulas is the same
name one meets in $p$-adic integration. It is not a coincidence: Coleman's power series theorem
and Coleman's integration theory are one project, and the object joining them is the wild symbol.

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *The slogan.* The *tame* symbol is a *residue*. The *wild* symbol is an *integral*.

  #v(1.5mm)
  The tame symbol $(f,g)_x = (-1)^(v(f) v(g)) (f^(v(g)) slash g^(v(f)))(x)$ is the residue of
  $d log f and d log g$ --- algebraic, the boundary map in the localisation sequence for Milnor
  $K$-theory, no primitive required. Weil reciprocity $product_x (f,g)_x = 1$ is then just
  "the sum of the residues of a differential vanishes". Wild, and the residue is not enough: one
  needs the actual primitive of $d log$, hence $log$, hence a branch, hence analysis. That is
  @sec-formulas restated --- and it is why the theory that supplies the branch is the theory that
  computes the symbol.
]

== The shared engine <sec-coleman-engine>

Both of Coleman's theories are the same move: *$p$-adic rigidity pins down a unique analytic
function interpolating discrete arithmetic data, and the arithmetic invariant is then a residue or
a derivative of that function.*

#v(2mm)
#align(center)[
#table(columns: 3, align: (left, left, left), stroke: 0.4pt, inset: 5pt,
  [], [*power series* (1979)], [*integration* (1982--85)],
  [input], [norm-compatible units $(u_n)$ in a
    Lubin--Tate tower], [a differential $omega$ on a curve over $CC_p$],
  [output], [unique $g_u in cal(O)_F [[X]]^times$ with
    $g_u (pi_n) = u_n$], [unique primitive $F_omega$ with $d F_omega = omega$],
  [uniqueness from], [the norm operator $cal(N)$], [$phi^*$-equivariance (Dwork's principle)],
  [invariant extracted], [$delta log g_u$, traced], [$F_omega (b) - F_omega (a)$],
)]

#v(2mm)

In both columns the rigidity is a *Frobenius* statement, and it is the same Frobenius that
@sec-lt-depth found governing the formal group below the crossover. Coleman's norm operator is a
transfer along $[pi]$, which is Frobenius on the special fibre; the integration theory's
uniqueness is analytic continuation along Frobenius. Locally constant functions are the enemy in
both settings, and $phi$ is what kills them.

This is what "Coleman power series are what make it work" in @sec-lt means concretely. Wiles'
explicit reciprocity law computes $( , )_(pi^n)$ as a trace of $delta log g_u slash pi^n$: the
symbol is the logarithmic derivative of the function interpolating the units.

== The bridge is a single paper <sec-coleman-dilog>

Coleman, _The dilogarithm and the norm residue symbol_ (1981), is literally both subjects at once:
it expresses the wild norm residue symbol through the $p$-adic dilogarithm, and the $p$-adic
$"Li"_2$ is a Coleman integral,
$ "Li"_2 (z) = integral_0^z log(1-t) thin d t slash t , $
an iterated integral whose definition needs exactly the Frobenius rigidity above. So a wild
Hilbert symbol is computed as the value of a $p$-adic iterated integral. Chronologically the paper
sits between _Division values in local fields_ (1979), which is the power series theorem, and
_Dilogarithms, regulators and $p$-adic $L$-functions_ (1982), where the integration theory proper
appears.

There is a structural reason for the dilogarithm in particular. Milnor $K_2$ is generated by
symbols modulo the Steinberg relation $\{x, 1-x\} = 1$, and the five-term functional equation of
$"Li"_2$ is the analytic shadow of Steinberg. A regulator from symbols to dilogarithm values is
forced by the shape of the relations, before any $p$-adic input.

The global counterpart came later: _Reciprocity laws on curves_ (1989) proves the $p$-adic
analogue of Weil reciprocity by integration, with local terms that are Coleman integrals rather
than residues --- the same proof shape as the tame statement above, one level of analysis deeper.

== What it became <sec-coleman-modern>

Two lines descend from the 1979 theorem and meet:

- *Coleman power series $-->$ the Coleman map $-->$ Perrin-Riou's big exponential.* Perrin-Riou's
  "loi de réciprocité explicite" --- proved by Colmez, Kato--Kurihara--Tsuji, Benois and Berger ---
  says the big logarithm interpolates Bloch--Kato exponentials, with Coleman's theorem for
  $hat(GG)_m$ as the base case.
- *Coleman integration $-->$ syntomic cohomology $-->$ $p$-adic regulators.* Besser showed the
  syntomic regulator is computed by Coleman integrals.

Kato's explicit reciprocity law is the comparison between the two: the étale symbol --- the
Hilbert symbol of @sec-two, a cup product in Galois cohomology --- on one side, the
de Rham--syntomic regulator on the other.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *The connection in one sentence.* An explicit reciprocity law is the statement that a wild
  symbol equals a $p$-adic integral.
]

== What this does not buy <sec-coleman-caveat>

It would be pleasant to conclude that the symbols of @sec-bite are therefore a Coleman-integral
computation away. In principle yes; in practice this machinery is built to *prove formulas*, not
to *evaluate one symbol quickly*, and nothing here contradicts the cost accounting of
@sec-formulas --- Vostokov's and Brückner's formulas already are the practical form of these
ideas, and they are still power series to depth $p e slash (p-1)$. Nor is there anything
off-the-shelf: the Coleman integration implemented in Sage (Balakrishnan and collaborators) is for
hyperelliptic curves and forms $x^i thin d x slash y$, and does not address Hilbert symbols. The
gain from this section is understanding, not an algorithm.

#v(2mm)

_Sources for this section, from memory --- page numbers unverified:_
R. Coleman, _Division values in local fields_, Invent. Math. *53* (1979);
_The dilogarithm and the norm residue symbol_, Bull. SMF *109* (1981);
_Dilogarithms, regulators and $p$-adic $L$-functions_, Invent. Math. *69* (1982);
_Torsion points on curves and $p$-adic abelian integrals_, Ann. of Math. *121* (1985);
_Reciprocity laws on curves_, Compositio Math. *72* (1989).
A. Wiles, _Higher explicit reciprocity laws_, Ann. of Math. *107* (1978).
A. Besser, _Syntomic regulators and $p$-adic integration I, II_, Israel J. Math. *120* (2000).
E. de Shalit, _Iwasawa theory of elliptic curves with complex multiplication_ (1987).

= Where this bit these notes <sec-bite>

- `descent-s3.typ` needed a *cubic* norm-residue symbol at the wild place $v = 3$ to exhibit a
  Brauer class, and recorded that neither PARI nor Sage provides one. Its README entry notes the
  gap is "an implementation task at one wild place, not a missing tool".
- `ec-density-bm.typ` §6 hits the same wall one prime up: the index-$11$ failure of
  density for the conductor-$89$ curve at $p = 11$ needs an order-$11$ Brauer class, and the
  symbol that has to be non-trivial is the $11$-th norm residue symbol *at $11$*. Depth $11$,
  degree $10$, $3.1 dot 10^12$ classes.
- And the structural reason it is always the wild symbol there: $E_1 (QQ_p) tilde.equiv ZZ_p$ is
  pro-$p$, so cutting the formal-group layer always demands a class of order $p$ evaluated at the
  place $p$. The tame layers of the Néron filtration are the reachable ones.

#v(3mm)

_Companion file:_ `wild-symbols.gp`, run as

```sh
gp -q -s 12000000000 wild-symbols.gp < /dev/null > results/wild-symbols.txt
```

It verifies the triviality of the tame symbol on units ($556656$ cases), the mod-$p$ versus
mod-$8$ precision, the depth of the unit filtration for squares in $QQ_2$ and cubes in
$QQ_3 (zeta_3)$ (brute force over $cal(O) slash 3^6$, $531441$ elements), the pairing filtration
at $2$, the class-group sizes, and the tame closed formula against PARI's `hilbert` on $195792$
cases.
