# The Reduced Trace Form on a Central Simple Algebra

*Does $(x,y) \mapsto \mathrm{Trd}(xy)$ define a bilinear form on $A$?*

## Yes, and it is a good one

$T_A(x,y) = \mathrm{Trd}(xy)$ is a **symmetric, nondegenerate, associative** bilinear form on $A$, canonically attached to the algebra with no choices made.

**Symmetric.** $\mathrm{Trd}$ commutes with base change, so after passing to a splitting field $A \otimes_k \bar k \cong M_n(\bar k)$ it becomes the ordinary trace, and $\mathrm{tr}(xy) = \mathrm{tr}(yx)$.

**Associative.** $T_A(xy,z) = \mathrm{Trd}(xyz) = T_A(x,yz)$. This is the Frobenius condition, and it is the property that makes the form structural rather than incidental.

**Nondegenerate — in every characteristic.** Again check on $M_n$: for $x \neq 0$ with $x_{ij} \neq 0$, take $y = e_{ji}$, and $\mathrm{tr}(x e_{ji}) = x_{ij} \neq 0$. Nondegeneracy is insensitive to base field extension, so it descends to $A$.

That last point deserves emphasis, because the *naive* trace form is much worse. The trace $\mathrm{Tr}_{A/k}$ of the left regular representation satisfies $\mathrm{Tr}_{A/k} = n \cdot \mathrm{Trd}$ where $n = \deg A$, so the form $\mathrm{Tr}_{A/k}(xy)$ is identically zero when $\operatorname{char} k \mid n$. The reduced trace is precisely the $n$-th root of it that survives. This is one of the concrete payoffs of working with $\mathrm{Trd}$ rather than $\mathrm{Tr}$.

A related subtlety: $T_A(1,1) = \mathrm{Trd}(1) = n$. So when $\operatorname{char} k \mid n$ the line $k \cdot 1$ is isotropic and the decomposition $A = k \oplus A_0$ into scalars and trace-zero elements is *not* orthogonal — indeed $k \subseteq A_0$ in that case. Away from that, $A = k \perp A_0$ is an orthogonal splitting.

## What the form buys you

**$A$ is a symmetric Frobenius algebra.** The map $x \mapsto T_A(x,-)$ is an isomorphism $A \xrightarrow{\ \sim\ } A^*$ of $(A,A)$-bimodules. This underlies duality statements about $A$-modules, and it is why $\mathrm{Trd}$ shows up whenever one needs a canonical pairing.

**It is invariant.** $T_A(gxg^{-1}, gyg^{-1}) = T_A(x,y)$ for $g \in A^\times$, so it is an $\mathrm{Ad}$-invariant form. On $A_0 = \mathfrak{sl}_1(A)$ this is the Lie-theoretic trace form; for $A = M_n$ it is the usual $\mathrm{tr}(XY)$ on $\mathfrak{sl}_n$, proportional to the Killing form.

**Involutions are isometries of it.** If $\sigma$ is any involution on $A$, then

$$T_A(\sigma x, \sigma y) = \mathrm{Trd}\big(\sigma(y)\sigma(x)\big) = \mathrm{Trd}\big(\sigma(xy)\big) = \mathrm{Trd}(xy) = T_A(x,y),$$

using $\mathrm{Trd} \circ \sigma = \mathrm{Trd}$. Consequently $\mathrm{Sym}(A,\sigma) \perp \mathrm{Skew}(A,\sigma)$: for $\sigma x = x$ and $\sigma y = -y$, applying $\sigma$ to $xy$ gives $T_A(x,y) = -T_A(y,x) = -T_A(x,y)$.

## Relation to involutions and bilinear forms on $V$

It is worth being careful about what kind of form this is. Involutions on $\operatorname{End}_D(V)$ correspond to forms on **$V$**. The trace form lives on **$A$ itself**, a $k$-space of dimension $n^2$. Different objects.

They do connect, though: $T_A$ is a nondegenerate symmetric form on the vector space $A$, so by the usual dictionary it determines an orthogonal involution on $\operatorname{End}_k(A) \cong M_{n^2}(k)$ — the adjoint with respect to $T_A$. And this one *is* canonical in $A$, unlike a transpose. It is a genuine instance of "a bilinear form arising with no basis in sight."

## Quaternion example

For $A = (a,b)_k$ with $\operatorname{char} k \neq 2$, the standard basis $1, i, j, ij$ is orthogonal for $T_A$ and

$$T_A \cong \langle 2,\ 2a,\ 2b,\ -2ab \rangle,$$

since $\mathrm{Trd}(i^2) = 2a$, $\mathrm{Trd}(j^2) = 2b$, and $\mathrm{Trd}\big((ij)^2\big) = -2ab$. Restricted to $A_0$ it is $\langle 2a,\ 2b,\ -2ab \rangle$, whose similarity class recovers the algebra: $(a,b)_k \cong (a',b')_k$ if and only if these ternary forms are similar.

So the trace form is not merely a decoration; for quaternions it is a complete invariant. In higher degree the trace form still carries real information — its discriminant and Hasse invariant give cohomological invariants of $A$ — but it stops being complete.

*(Note on notation: the fourth basis element is written $ij$ rather than the customary $k$, to avoid a clash with the base field $k$.)*
