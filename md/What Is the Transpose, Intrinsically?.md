# What Is the Transpose, Intrinsically?

*Involutions of $\operatorname{End}_k(V)$ and the datum they depend on.*

## The genuinely canonical operation

There *is* a canonical transpose; it just doesn't land where you want it to. For any $f \in \operatorname{End}_k(V)$ the dual map $f^\vee \in \operatorname{End}_k(V^*)$, defined by $f^\vee(\varphi) = \varphi \circ f$, requires no choices, and $(fg)^\vee = g^\vee f^\vee$. So

$$\operatorname{End}_k(V) \longrightarrow \operatorname{End}_k(V^*), \qquad f \mapsto f^\vee$$

is a canonical **anti-isomorphism**. Choosing a basis $e$ of $V$ and the dual basis $e^*$ of $V^*$, the matrix of $f^\vee$ in $e^*$ is literally the transposed matrix of $f$ in $e$. That is the whole content of the classical operation.

The trouble is that this is an anti-isomorphism between two *different* algebras. An involution has to be an anti-automorphism of $\operatorname{End}_k(V)$ itself, so you must identify $\operatorname{End}_k(V^*)$ with $\operatorname{End}_k(V)$, and that means identifying $V^*$ with $V$. Nothing more, nothing less.

## The extra datum is exactly an isomorphism $V \to V^*$

An isomorphism $b : V \to V^*$ is the same thing as a nondegenerate bilinear form $\langle x,y\rangle = b(x)(y)$. Given one, set

$$\sigma_b(f) = b^{-1} \circ f^\vee \circ b,$$

which in matrix terms with $b$ the Gram matrix is $b^{-1} f^{\mathsf t} b$, and which is characterized adjoint-style by $\langle \sigma_b(f)x, y\rangle = \langle x, fy\rangle$. This is an anti-automorphism for *any* nondegenerate $b$.

When is it an involution? Identify $V^{**} = V$ and write $b^\vee : V \to V^*$ for the dual of $b$. Then

$$\sigma_b^2(f) = b^{-1}\big(b^{-1}f^\vee b\big)^\vee b = (b^{-1}b^\vee)\, f\, (b^{-1}b^\vee)^{-1} = \operatorname{Int}(u)(f), \qquad u := b^{-1}b^\vee.$$

So $\sigma_b^2 = \mathrm{id}$ iff $u$ is a scalar $\lambda$, i.e. $b^\vee = \lambda b$; dualizing that relation gives $\lambda^2 = 1$. Hence $\lambda = \pm 1$: **$b$ symmetric or alternating**. The $\pm$ that looks like a stipulation in the textbook formula $\sigma_b(x) = b^{-1}x^{\mathsf t}b$, $b^{\mathsf t} = \pm b$, is forced by requiring order $2$.

Finally, $\sigma_b = \sigma_{cb}$ for $c \in k^\times$, and conversely $\sigma_b = \sigma_{b'}$ forces $b' \in k^\times b$. So:

$$\left\{\text{involutions of the first kind on } \operatorname{End}_k(V)\right\} \;\longleftrightarrow\; \left\{\begin{array}{c}\text{nondegenerate symmetric or alternating}\\ \text{bilinear forms on } V\end{array}\right\} \Big/ k^\times.$$

That bijection is the answer. The natural input datum is a bilinear form up to scalar — not a basis.

## Why a basis is the wrong datum, in both directions

**A basis carries too much information.** A basis $e$ determines the form $b_e$ with Gram matrix $I$, and every basis in the same $\mathrm O(b_e)$-orbit gives the same form, hence the same involution. The map $\{\text{bases}\} \to \{\text{involutions}\}$ has fibers that are torsors under an orthogonal group. The redundancy is visible already for $V = k^2$: rotating an orthonormal basis changes the basis but not the transpose.

**A basis reaches too few involutions.** Only the forms admitting an orthonormal basis arise this way, and over most fields that is a thin subclass.

- Over $\mathbb{R}$ with $\dim V = 2$, take $b = \operatorname{diag}(1,-1)$. Then

  $$\sigma_b\begin{pmatrix} p & q \\ r & s\end{pmatrix} = \begin{pmatrix} p & -r \\ -q & s\end{pmatrix}$$

  is a perfectly good orthogonal involution of $M_2(\mathbb{R})$. It is *not* the transpose in any basis: $\operatorname{diag}(1,-1)$ is not isometric to $I$ even up to scaling, and by Skolem–Noether $\sigma_b \sim \sigma_{b'}$ iff $b \sim b'$ up to similarity. Its automorphism group is $\mathrm{O}(1,1)$, not $\mathrm{O}(2)$.
- Over $\mathbb{Q}$ the situation is much richer: nondegenerate symmetric forms up to similarity are classified by rank, discriminant and Hasse invariants, so $M_n(\mathbb{Q})$ carries many mutually non-conjugate orthogonal involutions, while "transpose in a basis" produces exactly one of them.
- Alternating forms are missed entirely. Symplectic involutions exist on $M_{2n}(k)$ and no basis produces them, since a basis always gives $\mathrm{Gram} = I$.

So "transpose depends on a choice of basis" is true but is a coordinate artifact: bases are a surjection onto only *part* of the correct parameter space, with large fibers.

## The structural reason $V^*$ appears

$\operatorname{End}_k(V)$ does not remember $V$ on the nose. What it remembers is the pair: minimal right ideals recover $V$, minimal left ideals recover $V^*$. An anti-automorphism interchanges left and right ideals, so any involution necessarily encodes an identification of $V$ with $V^*$. From this angle the bilinear form is not an auxiliary gadget you happen to use — it is precisely the structure an involution *is*.

This is also why the story generalizes cleanly: for $A = \operatorname{End}_D(V)$ with $D$ a division algebra, involutions on $A$ correspond to hermitian or skew-hermitian forms on $V$ over $(D, \overline{\phantom{x}})$ up to scalar, and one cannot even phrase the basis version sensibly.

## Two caveats

- In characteristic $2$, "symmetric" and "alternating" are not complementary; the correct dichotomy is symmetric-nonalternating (orthogonal) versus alternating (symplectic), so the trichotomy above should be stated with *alternating*, never *skew-symmetric*.
- Some authors prefer the phrasing "an involution is a self-dual or anti-self-dual isomorphism $b : V \xrightarrow{\ \sim\ } V^*$, modulo scalars." That is the same statement; the condition $b^\vee = \pm b$ is what the computation above extracted.

## Summary

The transpose is the adjoint operation attached to a nondegenerate symmetric-or-alternating bilinear form, taken up to scalar; that datum is in exact bijection with involutions. A basis is merely one convenient way to present the standard form $b = I$, and it is both redundant (orthogonal-group-many bases give the same involution) and incomplete (it never reaches non-standard symmetric forms or any alternating form).