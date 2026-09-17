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
  commute, so the action factors through the abelianisation. On a K3 the two families do not commute
  in general and the action is presumably faithful, though this was not checked for a given surface.
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
