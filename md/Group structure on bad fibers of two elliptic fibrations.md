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
