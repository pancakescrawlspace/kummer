# When do the bad fibers of two elliptic fibrations carry group structures?

*Notes from a conversation with Claude, 17 September 2026. Standard material (Néron models, Kodaira's classification, minimal models of surfaces); no historical claims.*

---

## The question

Let $S$ be a non-singular projective surface over $\mathbb{C}$ carrying two elliptic fibrations
$\pi_1\colon S \to C_1$ and $\pi_2\colon S \to C_2$. Can one find $S'$ birational to $S$ on which all
bad fibers of both fibrations carry a group structure, in the sense that the smooth locus of each fiber
is an algebraic group? Is this automatic for $S$ itself, since $S$ is non-singular?

**Short answer.** Not automatic: non-singularity is the weakest of the conditions involved. Three
things are needed, for each fibration: a section, relative minimality, and (implied by the section)
no multiple fibers. With sections assumed, the remaining obstruction is that both fibrations must be
relatively minimal *on the same surface*. This fails for rational surfaces in general, but holds
for $\kappa(S) \ge 0$ after passing to the minimal model $S_{\min}$; it holds on $S$ itself iff $S$ is
minimal.

---

## 1. What "group structure on a bad fiber" means

A singular fiber $F$ is never a group as a whole: it has singular points and possibly non-reduced
components. The precise statement is Néron's.

> **Theorem (Néron).** Let $\pi\colon S \to C$ be an elliptic fibration with a section, and suppose
> $\pi$ is relatively minimal, i.e. no fiber contains a $(-1)$-curve. Then the smooth locus
> $S^{\mathrm{sm}} \to C$ is the Néron model of the generic fiber. In particular, for every fiber $F$
> the smooth locus $F^{\mathrm{sm}}$ is a commutative algebraic group, with group law the closure of
> the one on the generic fiber and the section as origin.

Kodaira's classification then identifies the groups: $F^{\mathrm{sm}}$ is an extension of a finite
abelian component group $\Phi$ by the identity component, which is an elliptic curve (smooth fiber),
$\mathbb{G}_m$ (type $\mathrm{I}_n$) or $\mathbb{G}_a$ (all other types). For instance
$\mathrm{I}_n$ gives $\mathbb{G}_m \times \mathbb{Z}/n$, and $\mathrm{I}_n^*$ gives
$\mathbb{G}_a \times (\mathbb{Z}/2)^2$ or $\mathbb{G}_a \times \mathbb{Z}/4$ according to the parity
of $n$.

---

## 2. Why non-singularity of $S$ is not enough

**A section is needed.** Without one, even the smooth fibers have no group structure: they are torsors
under the Jacobian of the generic fiber. No birational modification helps, since "the generic fiber
has a rational point" is a property of the genus-one curve over $\mathbb{C}(C)$ that every model
shares. The only remedy is the Jacobian fibration $J(S) \to C$, which has the same fiber types but is
in general not birational to $S$ (for K3 surfaces, birational means isomorphic, and $J(S) \not\cong S$
in general).

**Relative minimality is needed.** Blow up a point $p$ on a smooth fiber $E$. The surface stays
non-singular, but the new fiber is $\tilde E \cup L$, with $L$ the exceptional curve, and its smooth
locus is $(E \smallsetminus \{p\}) \sqcup \mathbb{A}^1$. This is not an algebraic group, since all
components of an algebraic group are isomorphic to the identity component and
$E \smallsetminus \{p\} \not\cong \mathbb{A}^1$. Contracting $L$ restores the group. The statement is
really about the relatively minimal regular model, which for a genus-one fibration is unique.

**Multiple fibers** are excluded automatically by a section.

So for a *single* fibration with a section, the answer is yes: contract the $(-1)$-curves in fibers
to reach the relatively minimal model.

---

## 3. Two fibrations: the obstruction

Assume both $\pi_1$ and $\pi_2$ have sections. To make $\pi_1$ relatively minimal one must contract
the $(-1)$-curves lying in $\pi_1$-fibers. Such a curve $L \cong \mathbb{P}^1$ is either

- **vertical for $\pi_2$** as well, in which case contracting it keeps $\pi_2$ a morphism; or
- **horizontal for $\pi_2$**, i.e. $L \to C_2$ is surjective (so $C_2 \cong \mathbb{P}^1$ and $L$ is a
  multisection of $\pi_2$). Contracting $L$ then turns $\pi_2$ into a mere rational map: the pencil
  acquires a base point at the image of $L$.

So both fibrations can be made relatively minimal on one surface iff every $(-1)$-curve in a
$\pi_1$-fiber is $\pi_2$-vertical and vice versa. Sections do not buy this.

**Counterexample (rational).** Take two pencils of plane cubics with disjoint base loci and blow up
all 18 base points. Each pencil becomes an elliptic fibration, and each has sections: the exceptional
curve over a base point of pencil 1 is a section of $\pi_1$. But the exceptional curve $E_q$ over a
base point $q$ of pencil 2 satisfies $E_q \cdot F_2 = 1$ (a section of $\pi_2$) while lying in the
unique $\pi_1$-fiber through $q$, where it is a $(-1)$-curve. It cannot be contracted without losing
$\pi_2$.

In fact no birational model of this surface has both fibrations relatively minimal: a relatively
minimal genus-one fibration on a rational surface has $K \equiv -\tfrac{1}{m} F$ for some $m \ge 1$
(Halphen pencil of index $m$), so a second fiber class $F'$ with $K \cdot F' = 0$ forces
$F \cdot F' = 0$, hence $F' \propto F$ by Hodge index, and the fibration is unique.

---

## 4. Kodaira dimension $\ge 0$: the minimal model works for all fibrations at once

> **Claim.** If $\kappa(S) \ge 0$, every $(-1)$-curve on $S$ is contained in a fiber of every
> elliptic fibration on $S$.

**Proof.** Suppose $L$ is a $(-1)$-curve horizontal for $\pi\colon S \to C$. Contract $L$ to get
$\sigma\colon S \to S_1$. Then $\pi$ becomes a pencil on $S_1$ with a base point $p = \sigma(L)$. If
$k = L \cdot F > 0$ is the multiplicity of the pencil at $p$, the general member $F'$ satisfies
$F = \sigma^* F' - kL$, so

$$
F'^2 = F^2 + k^2 = k^2 > 0,
$$

while $F'$ is still a smooth curve of genus $1$. Adjunction gives
$K_{S_1} \cdot F' = -F'^2 = -k^2 < 0$. But $F'$ moves in a pencil with $F'^2 > 0$, so $F'$ is nef,
and $\kappa(S_1) = \kappa(S) \ge 0$ means some $mK_{S_1}$ is effective, whence
$K_{S_1} \cdot F' \ge 0$. Contradiction. $\blacksquare$

**Consequences.**

1. Since $\kappa(S) \ge 0$, $S$ has a unique minimal model $S_{\min}$, and $S \to S_{\min}$ is a
   composite of contractions of $(-1)$-curves. By the claim each contracted curve is vertical for
   every elliptic fibration, so **every elliptic fibration on $S$ descends to a morphism on
   $S_{\min}$**. Sections descend too: the image of a section still maps isomorphically onto $C$.
2. $S_{\min}$ has no $(-1)$-curves at all, so every elliptic fibration on it is relatively minimal.
3. Hence on $S_{\min}$, for every elliptic fibration with a section, the smooth locus of every fiber
   is a group (§1). This holds simultaneously for any number of fibrations, because $S_{\min}$ does
   not depend on the fibration.

So the answer for $\kappa(S) \ge 0$ is: take $S' = S_{\min}$. And that is the only candidate, so the
property holds on $S$ itself iff $S$ is already minimal. Non-singularity alone never suffices, since
blowing up any point of $S$ keeps it non-singular and produces a fiber whose smooth locus is not a
group (§2).

---

## 5. Which surfaces this concerns

Two distinct elliptic fibrations, both with sections, and $\kappa \ge 0$ is a narrower situation than
it looks.

- $\kappa = 1$: the elliptic fibration is unique (it is the Iitaka fibration). So $\kappa = 0$.
- Among minimal surfaces with $\kappa = 0$: Enriques surfaces have two double fibers on every elliptic
  fibration, and bielliptic surfaces have multiple fibers on their fibration over $\mathbb{P}^1$
  (the Albanese fibration over an elliptic curve does have a section, e.g. the image of $E \times \{f_0\}$
  for $f_0$ a fixed point of the $G$-action on $F$ in $S = (E \times F)/G$). Neither admits two
  fibrations with sections.
- That leaves **K3 surfaces** and **abelian surfaces**. On a K3 surface every elliptic fibration is
  automatically relatively minimal, and there can be many Jacobian fibrations at once; each has
  Néron-type bad fibers on the nose. On an abelian surface all fibers are smooth.

For $\kappa = -\infty$ the answer stays negative in general: rational surfaces carry pairs of Jacobian
elliptic fibrations (§3) but never a common relatively minimal model.

---

## 6. Application: multiplication along the two fibrations

*(Added 17 September 2026.)* The motivation for the question was the following. Let $S$ be minimal
with two elliptic fibrations $\pi_1, \pi_2$, both with sections $O_1, O_2$, so $S$ is a K3 or abelian
surface (§5). One would like "multiplication by $p$ along the $i$-th fiber",

$$
\mu_{i,p}\colon S \to S, \qquad x \mapsto [p]\text{ applied to } x \text{ in the fiber } \pi_i^{-1}(\pi_i(x)),
$$

and an action of the free monoid $M$ on the symbols $\mu_{i,p}$ ($i = 1,2$, $p \in \mathbb{Z}$) on $S$.
The group structure on the smooth loci of the bad fibers (§4) makes each $\mu_{i,p}$ a morphism on
$U_i = S \smallsetminus \Sigma_i$, where $\Sigma_i$ is the set of points that are singular in their
$\pi_i$-fiber: by the Néron mapping property, $[p]$ on the generic fiber extends to the Néron model
$S^{\mathrm{sm}} \to C_i$. But the points of $\Sigma_i$ remain in the way, and compositions
$\mu_{2,q} \circ \mu_{1,p}$ require the image of $\mu_{1,p}$ to avoid $\Sigma_2$, which it does not.

### 6.1 The indeterminacy is unavoidable on a K3

For $|p| \ge 2$, $\mu_{i,p}$ is never a morphism $S \to S$ on a K3 surface, on any birational model.
If $f\colon S \to S$ is a surjective morphism of a K3 then $K_S = f^*K_S + R$ with $R$ the
ramification divisor, and $K_S = 0$ forces $R = 0$, so $f$ is étale; étale covers multiply
$\chi(\mathcal{O})$, so $2 = \deg(f) \cdot 2$ and $\deg f = 1$. Since $\mu_{i,p}$ has degree $p^2$ on
the surface, it has genuine indeterminacy points, hidden in $\Sigma_i$.

For abelian surfaces there is no problem: a section of $A \to E_1$ through the origin is a
homomorphism by rigidity, so $A \cong F_1 \times E_1$ and $\mu_{1,p} = [p] \times \mathrm{id}$ is an
endomorphism.

### 6.2 The salvage: dominant rational maps, i.e. the function field

Each $\mu_{i,p}$ with $p \ne 0$ is a dominant rational self-map $S \dashrightarrow S$. Dominant
rational self-maps compose without any hypothesis, since the image of a dominant map meets every
dense open, so they form a monoid $\operatorname{Rat}_{\mathrm{dom}}(S)$ and one gets a monoid
homomorphism

$$
M \longrightarrow \operatorname{Rat}_{\mathrm{dom}}(S).
$$

Contravariantly, this is an action of $M$ on the function field $\mathbb{C}(S)$ by injective
$\mathbb{C}$-algebra endomorphisms $\mu_{i,p}^*\colon \mathbb{C}(S) \hookrightarrow \mathbb{C}(S)$,
each of degree $p^2$. Because pullback reverses composition, $(f \circ g)^* = g^* \circ f^*$, this is
precisely a homomorphism $M^{\mathrm{op}} \to \operatorname{End}_{\mathbb{C}\text{-alg}}(\mathbb{C}(S))$,
i.e. a right action of $M$ on $\mathbb{C}(S)$.

This formulation needs the two sections, so that the generic fibers $E_i / \mathbb{C}(C_i)$ are
elliptic curves and $[p]$ is defined on them, and nothing else. It does not need group structures on
the bad fibers: $\mathbb{C}(S) = \mathbb{C}(C_1)(E_1) = \mathbb{C}(C_2)(E_2)$ sees only generic
fibers. The bad-fiber structure of §4 only matters for the pointwise question below.

If one wants a space on which rational maps act as genuine maps, the canonical one is the
Zariski–Riemann space of $\mathbb{C}(S)/\mathbb{C}$ (all valuations of the function field): an
injective endomorphism of the field pulls valuations back.

### 6.3 Points: no Zariski open works, but very general points do

Each word $w \in M$ is a morphism on a dense open $U_w \subseteq S$, but there is no single dense open
$U$ with $\mu_{i,p}(U) \subseteq U$ for all $i, p$. Indeed $U$ must avoid $\Sigma_2$; pick
$x \in \Sigma_2$ on a smooth $\pi_1$-fiber $F_1$ (a K3 always has singular fibers, as $e(S) = 24$ is
the sum of the Euler numbers of the singular fibers). Then $\mu_{1,p}^{-1}(x)$ consists of $p^2$ points
of $F_1$, and as $p$ varies these are Zariski dense in $F_1$, so $U \cap F_1 = \emptyset$. But $F_1$
is a multisection of $\pi_2$, and $\mu_{2,q}^{-1}(F_1)$ is a curve of degree $q^2 (F_1 \cdot F_2)$
over $C_2$; these are infinitely many distinct curves that must all miss $U$, contradicting that
$S \smallsetminus U$ is a proper closed subset.

What survives over $\mathbb{C}$: the set of points at which every word of $M$ is defined is the
complement of a countable union of proper closed subsets. As $\mathbb{C}$ is uncountable this set is
nonempty, dense in the Euclidean topology and of full measure. So $M$ acts on the set of **very
general** points of $S$, as a set-theoretic action rather than on a variety.

### 6.4 The degree-one part acts by automorphisms

Translation by a section of a relatively minimal elliptic fibration extends to an automorphism of
$S$ preserving the fibration (a birational self-map of a minimal surface with $\kappa \ge 0$ is
biregular), and so does $[-1]_i = \mu_{i,-1}$. Hence

$$
G = \langle \operatorname{MW}(\pi_1),\ \operatorname{MW}(\pi_2),\ \mu_{1,-1},\ \mu_{2,-1} \rangle
\subseteq \operatorname{Aut}(S)
$$

acts by honest automorphisms, where $\operatorname{MW}(\pi_i)$ is the Mordell–Weil group of the
$i$-th fibration. This is one of the classical mechanisms producing K3 surfaces with infinite
automorphism groups and interesting dynamics (Wehler's surfaces in $\mathbb{P}^2 \times \mathbb{P}^2$,
Silverman's canonical heights, Cantat and McMullen on K3 dynamics). Only the generators with
$|p| \ge 2$ are forced to be rational maps.

---

## 7. The monoid $\bar M = (\mathbb{Z} \smallsetminus \{0\}, \cdot) * (\mathbb{Z} \smallsetminus \{0\}, \cdot)$

The free monoid $M$ is too big: the relations $\mu_{i,a}\mu_{i,b} = \mu_{i,ab}$ and $\mu_{i,1} = 1$
hold in $\operatorname{End}(\mathbb{C}(S))$ because they hold on the generic fiber $E_i$, so the
action descends to the quotient $\bar M$. Two refinements first.

- **Drop $0$.** $\mu_{i,0}$ is $x \mapsto O_i(\pi_i(x))$, a morphism $S \to C_i \to S$ with image
  the section $O_i$. It is not dominant, so it has no pullback on $\mathbb{C}(S)$ and does not belong
  to the encoding of §6.2. Use the factor $(\mathbb{Z} \smallsetminus \{0\}, \cdot)$.
- **Structure of one factor.** Unique factorisation gives
  $(\mathbb{Z} \smallsetminus \{0\}, \cdot) \cong \{\pm 1\} \times \mathbb{N}^{(P)}$, with
  $\mathbb{N}^{(P)}$ the free commutative monoid on the primes.

Then $\bar M$ is the **free product of monoids** (the coproduct in the category of monoids):

$$
\bar M \;\cong\; (\mathbb{Z} \smallsetminus \{0\}, \cdot) * (\mathbb{Z} \smallsetminus \{0\}, \cdot)
\;\cong\; \bigl(\{\pm 1\} \times \mathbb{N}^{(P)}\bigr) * \bigl(\{\pm 1\} \times \mathbb{N}^{(P)}\bigr).
$$

**Normal form.** As for free products of groups, every element has a unique alternating normal form

$$
(i_1, a_1)(i_2, a_2)\cdots(i_k, a_k), \qquad i_j \in \{1,2\},\ i_j \ne i_{j+1},\ a_j \in \mathbb{Z} \smallsetminus \{0, 1\},
$$

with $k = 0$ the identity. Multiplication concatenates and merges adjacent letters from the same
factor by multiplying the integers (deleting the letter if the product is $1$). So $\bar M$ is the
monoid of finite alternating sequences of nonzero integers $\ne 1$, tagged by fibration.

**Presentation.** $\bar M$ is generated by $\varepsilon_i = \mu_{i,-1}$ and $\mu_{i,p}$ for
$i = 1, 2$ and $p$ prime, subject only to

$$
\varepsilon_i^2 = 1, \qquad \varepsilon_i \mu_{i,p} = \mu_{i,p} \varepsilon_i, \qquad
\mu_{i,p}\mu_{i,q} = \mu_{i,q}\mu_{i,p},
$$

with no relation between index-$1$ and index-$2$ generators.

**Invariants matching the geometry.**

- *Units.* In a free product of monoids an element is invertible iff every letter is (non-unit letters
  cannot cancel in the normal form). So $\bar M^\times = \{\pm 1\} * \{\pm 1\} \cong D_\infty$, the
  infinite dihedral group, which is exactly the subgroup $\langle \mu_{1,-1}, \mu_{2,-1} \rangle$
  acting on $S$ by automorphisms (§6.4).
- *Degree.* $w \mapsto \prod a_j^2$ is a homomorphism $\bar M \to (\mathbb{N}_{>0}, \cdot)$, the
  degree of the rational map; its kernel is $\bar M^\times$.
- *Abelianisation.* $\bar M^{\mathrm{ab}} = (\mathbb{Z} \smallsetminus \{0\})^2$. On a product
  abelian surface $E_1 \times E_2$ the maps $[a] \times \mathrm{id}$ and $\mathrm{id} \times [b]$
  commute, so the action factors through the abelianisation. The same happens on some K3 surfaces;
  see §7.1.
- *Group completion.* Grothendieck-group formation is a left adjoint, so it commutes with coproducts:
  $K(\bar M) = \mathbb{Q}^\times * \mathbb{Q}^\times$. This group does not act on $S$, since $[p]$
  cannot be inverted, but it is the natural symmetry group of the inverse limit of $S$ under all the
  $\mu_{i,p}$, a solenoid-like object.

**The savepoint, precisely.** The encoding is a homomorphism
$\bar M^{\mathrm{op}} \to \operatorname{End}_{\mathbb{C}\text{-alg}}(\mathbb{C}(S))$, equivalently a
left action of $\bar M$ on $S$ by dominant rational maps. Since each factor is commutative,
reversing alternating words gives $\bar M^{\mathrm{op}} \cong \bar M$, so the distinction is
cosmetic. The generators go to the degree-$a^2$ field embeddings induced by multiplication by $a$ on
the generic fiber of $\pi_i$.

### 7.1 Is the action of $\bar M$ faithful on a K3?

Not in general; it depends on the surface and on the chosen sections.

**A counterexample: the Kummer surface of a product.** Let $S = \operatorname{Km}(E_1 \times E_2)$,
the minimal resolution of $(E_1 \times E_2)/\pm 1$. The two projections induce elliptic fibrations
$\pi_i\colon S \to E_i/\pm 1 \cong \mathbb{P}^1$, with generic fiber of $\pi_1$ isomorphic to $E_2$
and of $\pi_2$ to $E_1$. Each has sections: the image of $E_1 \times \{t\}$ for $t \in E_2[2]$ maps
isomorphically to $E_1/\pm 1$, so is a section of $\pi_1$ (it is also the double component of an
$\mathrm{I}_0^*$ fiber of $\pi_2$); symmetrically for $\pi_2$. Take these as $O_1, O_2$. With these
origins, $\mu_{1,a}$ is induced by $\mathrm{id} \times [a]$ on $E_1 \times E_2$ (because $2t = 0$)
and $\mu_{2,b}$ by $[b] \times \mathrm{id}$. These commute, and

$$
\varepsilon_1 \varepsilon_2 = [-1]_1 \circ [-1]_2 \text{ is induced by } [-1] \times [-1],
\text{ which is the identity on } S.
$$

So the action of $\bar M$ on $S$ factors through
$\bar M \to (\mathbb{Z} \smallsetminus \{0\})^2 / \langle (-1,-1) \rangle$, and this quotient does
act faithfully, since the map induced by $[b] \times [a]$ is trivial on $S$ iff $(a,b) = \pm(1,1)$.
The kernel is exactly the congruence generated by "the two factors commute" and
$\varepsilon_1 \varepsilon_2 = 1$: the free product collapses to a quotient of its abelianisation,
and the unit group $D_\infty$ collapses to $\mathbb{Z}/2$.

The mechanism is general: whenever the pair of fibrations comes from a product structure (Kummer
surfaces, and more generally K3 surfaces dominated by or dominating an abelian surface compatibly
with both fibrations), the two families of maps commute.

**The unit part.** $D_\infty \to \operatorname{Aut}(S)$ is injective iff
$\varepsilon_1 \varepsilon_2$ has infinite order. Two facts sharpen this:

- Each $\varepsilon_i = [-1]_i$ is a non-symplectic involution: locally $\omega = dt \wedge dz$ with
  $z$ a fiber coordinate, and $z \mapsto -z$ negates $\omega$. Hence $\varepsilon_1 \varepsilon_2$
  is symplectic.
- A symplectic automorphism of finite order of a K3 has order $\le 8$ (Nikulin), with isolated fixed
  points whose number is determined by the order.

So the unit part fails to be faithful iff $\langle \varepsilon_1, \varepsilon_2 \rangle$ is a finite
dihedral group $D_n$ with $n \le 8$, generated by two non-symplectic involutions whose product is a
symplectic automorphism of order $n$. The Kummer example is the case $n = 1$. For a K3 whose
Néron–Severi lattice is generic for two Jacobian fibrations one expects
$\varepsilon_1 \varepsilon_2$ to have infinite order; this can often be verified by checking that it
acts on the hyperbolic lattice $\operatorname{NS}(S)$ by a hyperbolic or parabolic isometry.

**The full monoid.** No proof in general, but the tool is clear. Let $\operatorname{Fib}(S)$ be the
set of fibrations of $S$ over curves, i.e. algebraically closed subfields of transcendence degree $1$
in $\mathbb{C}(S)$. A dominant rational self-map $f$ acts on $\operatorname{Fib}(S)$ by
$K \mapsto$ (algebraic closure of $f^*K$ in $\mathbb{C}(S)$), compatibly with composition, so
$\bar M$ acts on $\operatorname{Fib}(S)$ on the right, and $\mu_{i,a}$ fixes $\pi_i$. Faithfulness
on $\operatorname{Fib}(S)$ implies faithfulness on $S$, and it is a ping-pong question: does
$\mu_{1,a}$ ($|a| \ge 2$) move $\pi_2$ to a fibration different from $\pi_1, \pi_2$, and does
$\mu_{2,b}$ move $\pi_1$ likewise?

Degrees alone do not settle it. The pencil $\mu_{1,a}^{-1}(F_2)$ has class $\mu_{1,a}^* F_2$ with
$(\mu_{1,a}^* F_2) \cdot F_1 = a^2 (F_1 \cdot F_2)$, so it is not $|F_2|$; but its Stein
factorisation may return $\pi_2$. In the Kummer case $\mu_{1,a}^{-1}(F_2)$ is a union of $a^2$
fibers of $\pi_2$, so the algebraic closure of $\mu_{1,a}^* \mathbb{C}(C_2)$ is $\mathbb{C}(C_2)$
again and $\pi_2$ is fixed by everything. The precise hypothesis for ping-pong is therefore:

> $\pi_2 \circ \mu_{1,a}$ has connected fibers, i.e. $\mu_{1,a}$ does not permute the
> $\pi_2$-fibers; and symmetrically $\mu_{2,b}$ does not permute the $\pi_1$-fibers.

In the Kummer example this fails. For a K3 with no product structure relating the two fibrations one
expects it to hold, and then a ping-pong argument on $\operatorname{Fib}(S)$ (with some care, since
$\bar M$ is a monoid rather than a group) should give faithfulness. This is the expected answer, not
a theorem.

**Summary.** Not faithful in general: on $\operatorname{Km}(E_1 \times E_2)$ with the $2$-torsion
sections the action factors through $(\mathbb{Z} \smallsetminus \{0\})^2/\pm$, and even
$\varepsilon_1 \varepsilon_2 = 1$. The unit part is faithful iff $\varepsilon_1 \varepsilon_2$ has
infinite order, which can only fail for $\langle \varepsilon_1, \varepsilon_2 \rangle \cong D_n$,
$n \le 8$. The full monoid is expected to act faithfully exactly when neither family of maps
permutes the other's fibers.

### 7.2 A ping-pong lemma for free products of monoids

*(Added 17 September 2026.)* The group ping-pong lemma does not apply verbatim: one cannot conjugate,
and non-injective maps can satisfy all containment hypotheses while collapsing words. Here is a
version that works.

**Conventions.** $A, B$ are monoids acting on the left on a set $X$. Elements of $A * B$ are written
as alternating words $\ell_k \cdots \ell_1$ with letters in $(A \smallsetminus \{1\}) \sqcup
(B \smallsetminus \{1\})$, $\ell_1$ applied first; every element has a unique such normal form. Let
$W_A$ be the set of normal forms that are empty or whose *first-applied* letter lies in $A$, and
$W_B$ likewise.

> **Lemma.** Suppose there are points $p_1, p_2 \in X$ and subsets $X_A, X_B \subseteq X$ such that
>
> - (a) $A$ fixes $p_1$ and $B$ fixes $p_2$;
> - (b) $X_A \cap X_B = \emptyset$ and $p_1, p_2 \notin X_A \cup X_B$;
> - (c) the map $(A \smallsetminus \{1\}) \times (X_B \cup \{p_2\}) \to X$, $(a, y) \mapsto a \cdot y$,
>   takes values in $X_A$ and is **injective**;
> - (d) the map $(B \smallsetminus \{1\}) \times (X_A \cup \{p_1\}) \to X$, $(b, y) \mapsto b \cdot y$,
>   takes values in $X_B$ and is **injective**.
>
> Then $A * B \to \operatorname{Map}(X)$ is injective.

**Proof.** *Step 1: $w \mapsto w \cdot p_2$ is injective on $W_A$.* For nonempty $w \in W_A$, feed
$p_2$ through the letters: the first letter $a_1$ receives $p_2 \in X_B \cup \{p_2\}$ and outputs into
$X_A$ by (c); the next letter, in $B$, receives an element of $X_A \subseteq X_A \cup \{p_1\}$ and
outputs into $X_B$ by (d); and so on. Hence $w \cdot p_2 \in X_A$ if the last-applied letter is in
$A$, $\in X_B$ if it is in $B$, and the input to the last letter always lies in the domain of (c)
resp. (d).

Now let $w \ne w'$ in $W_A$; we show $w \cdot p_2 \ne w' \cdot p_2$ by induction on $|w| + |w'|$. If
$w = \emptyset \ne w'$, then $w \cdot p_2 = p_2 \notin X_A \cup X_B \ni w' \cdot p_2$ by (b). If both
are nonempty with last letters in different factors, the images lie in $X_A$ and $X_B$, which are
disjoint. If both last letters lie in $A$, write $w = \ell u$, $w' = \ell' u'$. Removing the
last-applied letter does not change the first-applied one (or leaves the empty word), so
$u, u' \in W_A$, and $u \cdot p_2,\, u' \cdot p_2 \in X_B \cup \{p_2\}$. Since $w \ne w'$ as words,
$(\ell, u) \ne (\ell', u')$: if $\ell \ne \ell'$ then $(\ell, u \cdot p_2) \ne (\ell', u' \cdot p_2)$,
and if $\ell = \ell'$ then $u \ne u'$ and by induction $u \cdot p_2 \ne u' \cdot p_2$, so again
$(\ell, u \cdot p_2) \ne (\ell', u' \cdot p_2)$. Injectivity in (c) gives
$w \cdot p_2 \ne w' \cdot p_2$. Last letters in $B$: the same with (d).

*Step 2:* symmetrically, $w \mapsto w \cdot p_1$ is injective on $W_B$.

*Step 3.* Let $w \ne w'$ be normal forms acting identically on $X$. If both lie in $W_A$, Step 1
gives a contradiction; if both lie in $W_B$, Step 2. Otherwise, say $w$ starts with $a \in A$ and
$w'$ starts with $b \in B$. Write $w' = w'' b$ with $w'' \in W_A$ (normal forms alternate). Then,
using (a),

$$
w \cdot p_2 = w' \cdot p_2 = w'' \cdot (b \cdot p_2) = w'' \cdot p_2,
$$

so $w = w''$ by Step 1. Symmetrically $w = \tilde w a$ with $\tilde w \in W_B$ and
$w' \cdot p_1 = \tilde w \cdot p_1$, so $w' = \tilde w$. Hence $w' = wb = \tilde w ab = w' ab$, which
is absurd since it says $|w'| = |w'| + 2$. $\blacksquare$

**Why the hypotheses are needed.** Injectivity in (c), (d) cannot be dropped for monoids: if
$a \in A$ and $b \in B$ act as constant maps with values in $X_A$ and $X_B$, all containment
hypotheses hold but $a \circ b \circ a = a$. Injectivity in the *first* coordinate is what
distinguishes different elements of the same factor, and it cannot be dropped either: on
$X = \{p, q\}$ with $X_A = \{p\}$, $X_B = \{q\}$ and $a, b$ both the swap, all containments hold and
the maps are bijections, but $ba = 1$. (For groups this is the familiar need for an extra point or
$|G_i| \ge 3$.)

**Application to $\operatorname{Fib}(S)$.** Take $X = \operatorname{Fib}(S)$, the set of subfields
$K \subseteq \mathbb{C}(S)$ of transcendence degree $1$ that are algebraically closed in
$\mathbb{C}(S)$, i.e. rational fibrations with connected fibers, pencils with base points included.
A dominant rational map $f$ acts by $f \cdot K =$ algebraic closure of $f^*K$ in $\mathbb{C}(S)$.

*This action is injective for every $f$.* Let $L = f^*\mathbb{C}(S)$, a subfield of finite index.
Then $(f \cdot K) \cap L$ is the algebraic closure of $f^*K$ in $L$, which is $f^*(\text{algebraic
closure of } K \text{ in } \mathbb{C}(S)) = f^*K$. So $K = (f^*)^{-1}\bigl((f \cdot K) \cap L\bigr)$
is recovered from $f \cdot K$.

With $A = (\mathbb{Z} \smallsetminus \{0\}, \cdot)$ acting through the $\mu_{1,a}$, $B$ through the
$\mu_{2,b}$, $p_1 = \pi_1$, $p_2 = \pi_2$, hypothesis (a) holds by construction and injectivity in
the second coordinate of (c), (d) is automatic. Taking $X_A, X_B$ to be the smallest sets forced by
(c), (d) — the fibrations reached from $\pi_2$ by words in $W_A$ and from $\pi_1$ by words in $W_B$,
sorted by the factor of the last-applied letter — the lemma reduces faithfulness to three **orbit
conditions**:

- (O1) no nonempty word in $W_A$ sends $\pi_2$ to $\pi_1$ or $\pi_2$, and no nonempty word in $W_B$
  sends $\pi_1$ to $\pi_1$ or $\pi_2$;
- (O2) fibrations reached with last letter in $A$ differ from those reached with last letter in $B$;
- (O3) $a \cdot y \ne a' \cdot y'$ whenever $a \ne a'$ in $A \smallsetminus \{1\}$ and
  $y, y' \in X_B \cup \{\pi_2\}$, and the same for $B$.

The first instance of (O1) is the condition of §7.1, $\mu_{1,a} \cdot \pi_2 \ne \pi_2$, i.e.
$\mu_{1,a}$ does not permute the $\pi_2$-fibers. The Kummer example fails already there.

**What remains open.** The combinatorics is settled by the lemma, but (O1)–(O3) are statements about
two orbits in $\operatorname{Fib}(S)$, and verifying them for a given K3 needs an invariant on
$\operatorname{Fib}(S)$ that separates the orbits, as $|x| > |y|$ on $\mathbb{P}^1$ separates the
ping-pong sets for matrix groups. The natural candidates are the degrees $d_i(K) = G_K \cdot F_i$ of
a fibration over the two bases. One has $d_1(\mu_{1,a} \cdot K) = a^2 d_1(K)/e$, with $e$ the number
of connected components of $\mu_{1,a}^{-1}(\text{general fiber of } K)$, but $d_2(\mu_{1,a} \cdot K)$
is not controlled by this, and $\mu_{1,a}^*$ on $\operatorname{NS}(S)$ is not functorial for rational
maps, so the hyperbolic-geometry argument used for automorphism groups does not transfer directly.
The geometry is thus reduced to (O1)–(O3); proving them for a general non-product K3 is not done
here.

### 7.3 The size of the bad set

*(Added 17 September 2026.)* For $m \in \bar M$ let $\operatorname{Bad}(m) = \operatorname{Ind}(m)$
be the finite set of indeterminacy points of the associated dominant rational map $S \dashrightarrow S$.
Recall the degree homomorphism $\deg\colon \bar M \to (\mathbb{N}_{>0}, \cdot)$,
$\deg(\mu_{i,a}) = a^2$.

> **Bound.** On a K3 surface, under the two caveats stated in §7.3.4,
>
> $$
> \#\operatorname{Bad}(m) \;\le\; \tfrac{N}{3} \cdot \deg(m) \;\le\; 8 \cdot \deg(m),
> $$
>
> where $N \le 24$ is the maximum over $i = 1, 2$ of the number of singular points of the reduced
> singular fibers of $\pi_i$. Conversely $\#\operatorname{Bad}(m) \ge c \cdot \deg(m)$ for generic
> pairs of fibrations along alternating words, so a constant times $\deg$ is the correct shape.

#### 7.3.1 The bad set of a generator

- $\operatorname{Ind}(\mu_{i,\pm 1}) = \emptyset$: these are automorphisms.
- For $|a| \ge 2$, $\operatorname{Ind}(\mu_{i,a}) \subseteq \Sigma_i$ (points not smooth on their
  $\pi_i$-fiber), since $[a]$ is a morphism on the Néron model. It genuinely contains every node of
  every $\mathrm{I}_n$ fiber. Explicitly, near a node the surface is $\{xy = t\}$ with the Tate
  coordinate $u = x$ on the fiber $E_t \cong \mathbb{C}^*/q^{\mathbb{Z}}$, $q \sim t$. Along the curve
  $y = c\,x^{a-1}$ through the node one has $t = c\,x^a$, so $u^a = x^a = t/c \equiv 1/c \pmod{q^{\mathbb{Z}}}$:
  the whole curve maps to the point $1/c \in \mathbb{G}_m$ of the special fiber. Different $c$ give
  different limits, so the node is an indeterminacy point, and the exceptional curve of its blow-up
  maps onto the closure of the smooth component, $c \mapsto 1/c$.

Modulo caveat (i) below, $\operatorname{Ind}(\mu_{i,a})$ is the set of singular points of the reduced
singular fibers of $\pi_i$; write $N_i$ for its cardinality. For each Kodaira type
$\#\operatorname{Sing}(F_{\mathrm{red}}) \le e(F)$ ($\mathrm{I}_n$: $n = e$; II, III, IV: $1 < e$;
$\mathrm{I}_n^*$: $n + 4 < n + 6$; II$^*$, III$^*$, IV$^*$: $8, 7, 6 < 10, 9, 8$), and
$\sum_F e(F) = e(S) = 24$, so $N_i \le 24$ independently of $a$.

#### 7.3.2 Composition: a derivation twisted by the degree

For dominant rational self-maps $f, g$ of a smooth projective surface,

$$
\operatorname{Ind}(g \circ f) \subseteq \operatorname{Ind}(f) \cup \{x \notin \operatorname{Ind}(f) : f(x) \in \operatorname{Ind}(g)\},
$$

since if $f$ is defined at $x$ and $g$ at $f(x)$ then $g \circ f$ is defined at $x$. If $f$ contracts
no curve onto a point of $\operatorname{Ind}(g)$ (caveat (ii)), each point of $\operatorname{Ind}(g)$
has at most $\deg(f)$ isolated preimages, so

$$
\#\operatorname{Ind}(g \circ f) \;\le\; \#\operatorname{Ind}(f) + \deg(f) \cdot \#\operatorname{Ind}(g).
$$

Iterating along a normal form $m = \ell_k \cdots \ell_1$ ($\ell_1$ applied first,
$\ell_j = \mu_{i_j, a_j}$):

$$
\#\operatorname{Bad}(m) \;\le\; f(m) := \sum_{j\,:\,|a_j| \ge 2} N_{i_j} \prod_{l < j} a_l^2 .
$$

The function $f$ is the unique one with $f(\text{units}) = 0$, $f(\mu_{i,a}) = N_i$ for $|a| \ge 2$,
and

$$
f(xy) = f(y) + \deg(y)\, f(x),
$$

i.e. a $1$-cocycle (derivation) of $\bar M$ twisted by the character $\deg$. Since every non-unit
letter has $a_l^2 \ge 4$, the $j$-th non-unit letter from the end contributes at most
$\deg(m)/4^{(\text{number of non-unit letters from } j \text{ onward})}$, and summing the geometric
series gives $f(m) \le (N/3) \deg(m)$, the bound above.

#### 7.3.3 Sharpness

The linear growth is real. Where $\mu_{1,a}$ is étale — everywhere on smooth $\pi_1$-fibers, since
$[a]$ is étale in characteristic $0$ — it is a local isomorphism, so $x$ is an indeterminacy point of
$\mu_{2,b} \circ \mu_{1,a}$ iff $\mu_{1,a}(x)$ is one of $\mu_{2,b}$. Hence every node of a
$\pi_2$-fiber lying on a smooth $\pi_1$-fiber has $a^2$ preimages in
$\operatorname{Ind}(\mu_{2,b} \circ \mu_{1,a})$. Continuing, for a generic pair of fibrations
$\#\operatorname{Bad}(m) \ge c \cdot \deg(m)$ along alternating words. So no bound $o(\deg m)$ is
possible and only the constant can be sharpened.

#### 7.3.4 Caveats, and an unconditional bound

Two points were not verified:

- (i) that $\mu_{i,a}$ has no indeterminacy points on the non-reduced components of
  $\mathrm{I}_n^*$, II$^*$, III$^*$, IV$^*$ fibers, where the Néron model does not see the surface;
- (ii) that no $\mu_{i,a}$ contracts a curve onto an indeterminacy point of another generator (the
  only candidates are again non-reduced fiber components).

Without them, one still has a bound of the shape $C \cdot \deg(m)^2$, with an exponential in the word
length: for any dominant rational self-map $f$ of a smooth projective surface with ample $H$, resolve
the indeterminacy by $\sigma\colon \tilde S \to S$ with $g = f \circ \sigma$ a morphism, and write
$g^*H = \sigma^*(f^*H) - \sum_j m_j E_j$ with $m_j \ge 0$ (negativity lemma, $g^*H$ nef). Then
$\sum_j m_j^2 = (f^*H)^2 - \deg(f) H^2$, and each indeterminacy point forces some $m_j \ge 1$, since
otherwise $g$ contracts the whole exceptional fiber over it and $f$ extends by Zariski's main
theorem. With the Hodge index theorem,

$$
\#\operatorname{Ind}(f) \;\le\; (f^*H)^2 - \deg(f) H^2 \;\le\; \frac{(f^*H \cdot H)^2}{H^2} - \deg(f) H^2 .
$$

Degrees $f \mapsto f^*H \cdot H$ are submultiplicative up to a constant depending on $(S, H)$
(Dinh–Sibony), and $\mu_{i,a}^* H \cdot H = O(a^2)$ since $\mu_{i,a*}$ acts by $a^2$ on the fiber
class and by $a$ on the Mordell–Weil part. This yields $\#\operatorname{Bad}(m) \le A \cdot B^{\ell(m)} \cdot \deg(m)^2$
with $\ell(m)$ the word length: rigorous without caveats, but weaker than §7.3.2 whenever the caveats
hold.

---

## References

- S. Bosch, W. Lütkebohmert, M. Raynaud, *Néron Models* (Springer, 1990), §1.5, Prop. 1: the smooth
  locus of the minimal regular model of an elliptic curve is its Néron model. Ch. 9 for the component
  groups.
- K. Kodaira, "On compact analytic surfaces II", *Ann. of Math.* 77 (1963): classification of singular
  fibers.
- W. Barth, K. Hulek, C. Peters, A. Van de Ven, *Compact Complex Surfaces*, 2nd ed. (Springer, 2004),
  Ch. V (elliptic surfaces, canonical bundle formula) and Ch. III (minimal models).
- R. Miranda, *The Basic Theory of Elliptic Surfaces* (ETS, 1989): Kodaira fibers and the group
  structure on their smooth loci; rational elliptic surfaces.
- J. H. Silverman, "Rational points on K3 surfaces: a new canonical height", *Invent. Math.* 105
  (1991), 347–373: Wehler surfaces and the automorphisms generated by two involutions.
- S. Cantat, "Dynamique des automorphismes des surfaces K3", *Acta Math.* 187 (2001), 1–57.
- C. T. McMullen, "Dynamics on K3 surfaces: Salem numbers and Siegel disks", *J. reine angew. Math.*
  545 (2002), 201–233.
- V. V. Nikulin, "Finite automorphism groups of Kähler K3 surfaces", *Trans. Moscow Math. Soc.* 38
  (1980), 71–135: symplectic automorphisms of finite order have order $\le 8$, with fixed-point counts.
- T.-C. Dinh and N. Sibony, "Une borne supérieure pour l'entropie topologique d'une application
  rationnelle", *Ann. of Math.* 161 (2005), 1637–1644: submultiplicativity of degrees of rational maps.
