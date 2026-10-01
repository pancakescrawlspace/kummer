# Failure of unique factorization as descent along the normalization

**Setup.** $R$ is a one-dimensional noetherian domain with fraction field $K$, for example an order $\mathcal{O} \subset \mathcal{O}_K$ in a number field. $\tilde{\mathcal{O}}$ is its normalization, assumed finite over $R$, and
$$\mathfrak{f} = \{x \in \tilde{\mathcal{O}} : x\tilde{\mathcal{O}} \subseteq R\}$$
is the conductor. Write $X = \operatorname{Spec} R$, $\tilde X = \operatorname{Spec}\tilde{\mathcal{O}}$ and $\pi : \tilde X \to X$ for the normalization map.

This continues [the module index as a Zariski descent](module-index-as-descent.md). There, unique factorization of ideals in a Dedekind domain was what made the patching of local module indices "automatic".

**The question.** When $R$ is not Dedekind, unique factorization of ideals fails. Does that failure have an interpretation in terms of descent?

**Answer: yes.** Going beyond Dedekind domains shows that the Dedekind argument had two separate parts:

1. **Patching.** Local data glue to global data. This never used the Dedekind hypothesis, and it survives unchanged (§1).
2. **The local computation.** Each local piece of the divisor sheaf is $\mathbb{Z}$. This is where unique factorization lives, and it fails exactly at the singular primes (§2).

The failure in step 2 is itself a descent phenomenon, along the normalization $\pi$ rather than along a Zariski cover (§3).

---

## 1. The Zariski patching survives

The sheaf of invertible fractional ideals
$$\mathcal{D} = K^\times/\mathcal{O}^\times, \qquad \mathcal{D}(U) = \{\text{invertible } \mathcal{O}(U)\text{-submodules of } K\},$$
is still a sheaf on $X$, the sheaf of Cartier divisors, for any noetherian domain. Its stalk at the generic point is $K^\times/K^\times = 1$, so in dimension one it is supported at the closed points. An invertible ideal is trivial at almost all primes, and therefore
$$\operatorname{Inv}(R) = \Gamma(X,\mathcal{D}) \;\cong\; \bigoplus_\mathfrak{p} K^\times/R_\mathfrak{p}^\times, \qquad \mathfrak{a} \mapsto (\mathfrak{a}_\mathfrak{p})_\mathfrak{p}.$$
In words: an invertible fractional ideal of $R$ is the same thing as a choice of local principal ideal at each prime, almost all of them trivial.

More generally, every nonzero ideal of $R$ is uniquely a product of primary ideals belonging to distinct primes (Neukirch, *Algebraic Number Theory*, Ch. I §12).

What the Dedekind case added was the identification of each stalk with $\mathbb{Z}$:
$$K^\times/R_\mathfrak{p}^\times \xrightarrow{\ v_\mathfrak{p}\ } \mathbb{Z} \text{ is an isomorphism} \iff R_\mathfrak{p} \text{ is a DVR}.$$

So "unique factorization of ideals" really means "every stalk of $\mathcal{D}$ is $\mathbb{Z}$", which is the same as $R$ being regular, i.e. normal. It is a **local** property. It fails exactly at the finitely many singular primes, the primes containing $\mathfrak{f}$.

---

## 2. The stalks at singular primes

Let $\tilde{\mathcal{O}}_\mathfrak{p} = \tilde{\mathcal{O}} \otimes_R R_\mathfrak{p}$ be the semilocal normalization of $R_\mathfrak{p}$. Comparing $R_\mathfrak{p}^\times \subseteq \tilde{\mathcal{O}}_\mathfrak{p}^\times \subseteq K^\times$ gives an exact sequence
$$1 \to \tilde{\mathcal{O}}_\mathfrak{p}^\times/R_\mathfrak{p}^\times \to K^\times/R_\mathfrak{p}^\times \to K^\times/\tilde{\mathcal{O}}_\mathfrak{p}^\times \to 1, \qquad K^\times/\tilde{\mathcal{O}}_\mathfrak{p}^\times \cong \bigoplus_{\mathfrak{P}\mid\mathfrak{p}} \mathbb{Z}.$$

Call the left-hand term the **unit defect** at $\mathfrak{p}$.

**Lemma.** $\tilde{\mathcal{O}}_\mathfrak{p}^\times/R_\mathfrak{p}^\times \cong (\tilde{\mathcal{O}}_\mathfrak{p}/\mathfrak{f}_\mathfrak{p})^\times / (R_\mathfrak{p}/\mathfrak{f}_\mathfrak{p})^\times$. In particular, for an order in a number field it is finite, and it is trivial unless $\mathfrak{p} \supseteq \mathfrak{f}$.

*Proof.* We show that $\tilde{\mathcal{O}}_\mathfrak{p}^\times \to (\tilde{\mathcal{O}}_\mathfrak{p}/\mathfrak{f}_\mathfrak{p})^\times$ is surjective with kernel $1+\mathfrak{f}_\mathfrak{p} \subseteq R_\mathfrak{p}^\times$.

- *Surjective:* $\tilde{\mathcal{O}}_\mathfrak{p}$ is semilocal and its maximal ideals all lie over $\mathfrak{p}$. So $\mathfrak{f}_\mathfrak{p} \subseteq \mathfrak{p}\tilde{\mathcal{O}}_\mathfrak{p} \subseteq \operatorname{Jac}(\tilde{\mathcal{O}}_\mathfrak{p})$ when $\mathfrak{p} \supseteq \mathfrak{f}$, and units lift modulo the Jacobson radical.
- *Kernel:* $\mathfrak{f}_\mathfrak{p} \subseteq R_\mathfrak{p}$, so $1 + \mathfrak{f}_\mathfrak{p} \subseteq R_\mathfrak{p}$. It consists of units, because it is contained in $\tilde{\mathcal{O}}_\mathfrak{p}^\times$ and $R_\mathfrak{p} \subseteq \tilde{\mathcal{O}}_\mathfrak{p}$ is integral, so $R_\mathfrak{p}^\times = R_\mathfrak{p} \cap \tilde{\mathcal{O}}_\mathfrak{p}^\times$.

Now divide by $R_\mathfrak{p}^\times$. If $\mathfrak{p} \not\supseteq \mathfrak{f}$, then $\mathfrak{f}_\mathfrak{p} = R_\mathfrak{p}$ and $R_\mathfrak{p} = \tilde{\mathcal{O}}_\mathfrak{p}$. $\square$

As sheaves, the snake lemma applied to $\mathcal{O}_X^\times \subseteq \pi_*\mathcal{O}_{\tilde X}^\times \subseteq K^\times$ gives
$$0 \to \pi_*\mathcal{O}_{\tilde X}^\times/\mathcal{O}_X^\times \to \mathcal{D}_X \to \pi_*\mathcal{D}_{\tilde X} \to 0.$$
The left-hand term is a skyscraper sheaf at the singular points. Here we used that $\pi$ is finite, so $R^1\pi_*\mathcal{O}_{\tilde X}^\times = 0$.

So a divisor on $X$ is:

- a divisor on $\tilde X$, which *does* have unique prime factorization, plus
- a finite amount of extra unit data at the singular points.

### Example: $R = \mathbb{Z}[\sqrt{-3}] \subset \tilde{\mathcal{O}} = \mathbb{Z}[\omega]$

Here $\omega = (-1+\sqrt{-3})/2$ and $R = \mathbb{Z} + 2\tilde{\mathcal{O}}$, so $\mathfrak{f} = 2\tilde{\mathcal{O}}$, with
$$\tilde{\mathcal{O}}/\mathfrak{f} = \mathbb{F}_4, \qquad R/\mathfrak{f} = \mathbb{F}_2.$$

There is one singular prime, $\mathfrak{p} = (2, 1+\sqrt{-3}) = \mathfrak{f}$. Since $2$ is inert in $\mathbb{Z}[\omega]$, $\tilde{\mathcal{O}}_\mathfrak{p}$ is a DVR with uniformizer $2$. The unit defect is $\mathbb{F}_4^\times/\mathbb{F}_2^\times \cong \mathbb{Z}/3$, so the stalk is (non-canonically)
$$K^\times/R_\mathfrak{p}^\times \cong \mathbb{Z} \times \mathbb{Z}/3.$$

Put $u = (1+\sqrt{-3})/2 = -\omega^2$. This is a unit of $\tilde{\mathcal{O}}$ that does not lie in $R_\mathfrak{p}$. Let $a \in \mathbb{Z}/3$ be its class, so that $\bar u = u^{-1}$ has class $-a$. Then $1 \pm \sqrt{-3} = 2u^{\pm 1}$, and the principal ideals map as follows:

| ideal | image in $\mathbb{Z} \times \mathbb{Z}/3$ |
|---|---|
| $(2)$ | $(1, 0)$ |
| $(1+\sqrt{-3})$ | $(1, a)$ |
| $(1-\sqrt{-3})$ | $(1, -a)$ |

Each of these is irreducible in the monoid of integral invertible ideals. An integral invertible ideal of valuation $0$ at $\mathfrak{p}$ is $xR_\mathfrak{p}$ with $x \in \tilde{\mathcal{O}}_\mathfrak{p}^\times \cap R_\mathfrak{p} = R_\mathfrak{p}^\times$, so it is trivial. Hence
$$(2)\cdot(2) = (4) = (1+\sqrt{-3})\cdot(1-\sqrt{-3})$$
are two genuinely different factorizations into irreducible invertible ideals. They have the same image upstairs and differ only in the unit-defect coordinate.

The prime $\mathfrak{p}$ itself is not invertible, since $\mathfrak{p}^2 = 2\mathfrak{p}$, so it does not appear in $\operatorname{Inv}(R)$ at all.

---

## 3. Descent along the normalization

$X$ is obtained from $\tilde X$ by *pinching* $\tilde X$ along the conductor. Algebraically, the conductor square
$$\begin{array}{ccc}
R & \longrightarrow & \tilde{\mathcal{O}} \\
\downarrow & & \downarrow \\
R/\mathfrak{f} & \longrightarrow & \tilde{\mathcal{O}}/\mathfrak{f}
\end{array}$$
is a pullback of rings, i.e. a **Milnor square**. Dually, $X = \tilde X \sqcup_{\tilde Z} Z$ is a pushout of schemes, with $Z = \operatorname{Spec} R/\mathfrak{f}$ and $\tilde Z = \operatorname{Spec}\tilde{\mathcal{O}}/\mathfrak{f}$.

**Milnor patching.** Finitely generated projective $R$-modules are equivalent to triples $(\tilde P, \bar P, \varphi)$, where:

- $\tilde P$ is a projective $\tilde{\mathcal{O}}$-module,
- $\bar P$ is a projective $R/\mathfrak{f}$-module,
- $\varphi : \tilde P/\mathfrak{f}\tilde P \xrightarrow{\sim} \bar P \otimes_{R/\mathfrak{f}} \tilde{\mathcal{O}}/\mathfrak{f}$ is an isomorphism.

The normalization map is not flat, so this is not fpqc descent. It is nonetheless an effective descent statement for vector bundles along the pushout (Milnor, *Introduction to Algebraic K-Theory*, §2; Ferrand, *Conducteur, descente et pincement*).

**Rank one.** A line bundle on $X$ is a line bundle on $\tilde X$ together with a descent datum. The descent datum is a gluing unit in $(\tilde{\mathcal{O}}/\mathfrak{f})^\times$, taken modulo units coming from either side. Since $R/\mathfrak{f}$ is artinian, $\operatorname{Pic}(R/\mathfrak{f}) = 0$, and the Mayer–Vietoris sequence reads
$$1 \to R^\times \to \tilde{\mathcal{O}}^\times \times (R/\mathfrak{f})^\times \to (\tilde{\mathcal{O}}/\mathfrak{f})^\times \to \operatorname{Pic} R \to \operatorname{Pic}\tilde{\mathcal{O}} \to 0.$$

### Interpretation

- An invertible ideal of $R$ is an ideal of $\tilde{\mathcal{O}}$, which factors uniquely, together with a descent datum at the conductor.
- The failure of unique factorization downstairs is exactly the information carried by the descent datum, which prime factorization upstairs cannot see.
- **Locally,** the descent data at $\mathfrak{p}$ form the unit defect $\tilde{\mathcal{O}}_\mathfrak{p}^\times/R_\mathfrak{p}^\times$, the kernel of the stalk map $\mathcal{D}_{X,\mathfrak{p}} \to (\pi_*\mathcal{D}_{\tilde X})_\mathfrak{p}$.
- **Globally,** what remains after dividing out the units of $\tilde{\mathcal{O}}$ is $\ker(\operatorname{Pic} R \to \operatorname{Pic}\tilde{\mathcal{O}})$.
- **Dedekind case:** $\mathfrak{f} = R$ and the descent datum is empty. The only content left is the Zariski patching of §1, and the stalks are $\mathbb{Z}$.

### Non-unique factorization is not a class group phenomenon

In the example, $\tilde{\mathcal{O}}^\times = \mu_6$ surjects onto $\mathbb{F}_4^\times$ (as $\omega \bmod 2$ generates $\mathbb{F}_4^\times$), and $\operatorname{Pic}\mathbb{Z}[\omega] = 0$. So
$$\operatorname{Pic}\mathbb{Z}[\sqrt{-3}] = 0.$$

Every invertible ideal is principal, yet factorization fails, because the stalk at $\mathfrak{p}$ is $\mathbb{Z} \times \mathbb{Z}/3$ rather than $\mathbb{Z}$. $\operatorname{Pic}$ only records the part of the descent data that cannot be absorbed by global units. The failure of unique factorization is the *local* descent data, before that quotient.

---

## 4. Consequences for the module index $[M:N]$

**Locally free lattices.** If $M$ and $N$ are locally free lattices in $V$ of rank $n$, the construction in the earlier note goes through word for word:

- $[M:N]$ is the glued section in $\operatorname{Inv}(R) = \bigoplus_\mathfrak{p} K^\times/R_\mathfrak{p}^\times$;
- $\Lambda^n N = [M:N]\cdot\Lambda^n M$ inside $\Lambda^n_K V$ still characterizes it.

Its image in $\operatorname{Inv}(\tilde{\mathcal{O}})$ is $[\tilde{\mathcal{O}}M : \tilde{\mathcal{O}}N]$. The $R$-index carries, in addition, a unit-defect component at each singular prime.

**Lattices that are not locally free.** Take $N = \mathfrak{p} \subset M = R$ in the example. Then $\Lambda^1 N = \mathfrak{p}$ is not invertible, and there is no index in $\operatorname{Inv}(R)$.

The Knudsen–Mumford determinant of the complex $N \to M$ would require $M/N$ to have finite projective dimension. That fails for $R/\mathfrak{p}$ when $\mathfrak{p}$ is singular, since $R_\mathfrak{p}$ is not regular.

In this case the index has to be computed over a Dedekind base instead, either $\tilde{\mathcal{O}}$ or $\mathbb{Z}$. For example, over $\mathbb{Z}$, $[R:\mathfrak{p}]_\mathbb{Z} = (2)$.

---

## Summary

| | Dedekind $R$ | Non-normal $R$ (e.g. a non-maximal order) |
|---|---|---|
| Zariski patching $\operatorname{Inv}(R) = \bigoplus_\mathfrak{p} \mathcal{D}_\mathfrak{p}$ | holds | holds |
| stalk $\mathcal{D}_\mathfrak{p} = K^\times/R_\mathfrak{p}^\times$ | $\mathbb{Z}$ | extension of $\bigoplus_{\mathfrak{P}\mid\mathfrak{p}}\mathbb{Z}$ by the finite unit defect at $\mathfrak{p} \supseteq \mathfrak{f}$ |
| descent along $\tilde X \to X$ | trivial ($\mathfrak{f} = R$) | Milnor patching along the conductor square |
| failure of unique factorization | none | the local descent data $\tilde{\mathcal{O}}_\mathfrak{p}^\times/R_\mathfrak{p}^\times$ |
| effect on $\operatorname{Pic}$ | none | $\ker(\operatorname{Pic} R \to \operatorname{Pic}\tilde{\mathcal{O}})$ = descent data modulo global units |
