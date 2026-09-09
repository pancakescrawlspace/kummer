# Determinantal models of Severi–Brauer varieties

Let $A$ be a division algebra over a field $k$, of reduced degree $n$, and let $V \subset A$ be a $k$-subspace with $\dim_k V = n+1$.

## 1. Setting up

Since $A$ is central simple of reduced degree $n$, we have $\dim_k A = n^2$, and the reduced norm

$$\operatorname{Nrd} : A \longrightarrow k$$

is a homogeneous polynomial map of degree $n$ defined over $k$; after base change to $\bar k$, an isomorphism $A \otimes \bar k \cong M_n(\bar k)$ carries it to $\det$.

Let

$$\operatorname{SB}(A) = \{\, \text{right ideals } J \subset A \ :\ \dim_k J = n \,\},$$

the Severi–Brauer variety of $A$: a $k$-form of $\mathbb{P}^{n-1}$, of dimension $n-1$. (With the opposite convention one obtains $\operatorname{SB}(A^{\mathrm{op}})$, which is $k$-birational to $\operatorname{SB}(A)$ anyway, by Amitsur.)

Recall also the **adjoint (adjugate) map** $a \mapsto a^{\#}$, a degree $n-1$ polynomial map $A \to A$ defined over $k$ and characterized by

$$a\,a^{\#} = a^{\#}a = \operatorname{Nrd}(a).$$

Geometrically it is the classical adjugate of a matrix. Hence $a^{\#} \neq 0$ exactly when $a$ has rank $\geq n-1$, and in that case $a^{\#}$ has rank $1$, with image $\ker a$ and kernel $\operatorname{im} a$.

## 2. The hypersurface $S$

Choose a basis $v_0, \dots, v_n$ of $V$ and set

$$F(x_0, \dots, x_n) = \operatorname{Nrd}(x_0 v_0 + \cdots + x_n v_n), \qquad S = \{F = 0\} \subset \mathbb{P}(V) \cong \mathbb{P}^n .$$

This is a hypersurface of degree $n$, hence of dimension $n - 1 = \dim \operatorname{SB}(A)$. Over $\bar k$ it becomes

$$\det(x_0 M_0 + \cdots + x_n M_n) = 0,$$

so $S$ is a **linear determinantal hypersurface**: the locus of singular matrices in the $n$-dimensional linear system $\mathbb{P}(V) \subset \mathbb{P}(M_n)$.

Note that $F$ is not identically zero — the reduced norm is anisotropic on $A$, since $A$ is a division algebra — so $S$ really is a hypersurface, and $S(k) = \varnothing$.

## 3. Why $S$ is a model of $\operatorname{SB}(A)$

There are two mutually inverse rational maps, both defined over $k$.

**Forward (adjugate, or "kernel" map).** For $a \in S$ with $a^{\#} \neq 0$, put

$$\psi(a) = a^{\#}A,$$

a right ideal of $k$-dimension $n$. Geometrically, $\psi(a)$ is the point of $\operatorname{SB}(A)$ corresponding to the line $\ker a \subset \bar k^{\,n}$. It is given by the degree $n-1$ forms making up $a^{\#}$.

**Backward.** Given $J \in \operatorname{SB}(A)$, its left annihilator

$$L_J = \{\, a \in A \ :\ aJ = 0 \,\}$$

is a maximal left ideal, with $\dim_k L_J = n^2 - n$. (Over $\bar k$: $L_J = \{ M : Mv = 0 \}$ for the line $\langle v \rangle$ attached to $J$.) Since

$$\dim V + \dim L_J - \dim A = (n+1) + (n^2 - n) - n^2 = 1,$$

one expects $V \cap L_J$ to be a line, and then

$$\chi(J) := \mathbb{P}(V \cap L_J)$$

is a point of $\mathbb{P}(V)$, necessarily lying on $S$.

Whenever $\dim_{\bar k}\bigl(V_{\bar k} \cap L_J\bigr) = 1$ for generic $J$, these maps are inverse to each other and

$$S \ \sim_{\mathrm{bir},\,k}\ \operatorname{SB}(A).$$

This genericity condition is exactly what fails in degenerate cases (for instance if $V$ is chosen so that $F$ is a non-reduced form). It holds for generic $V$, and — as noted below — it holds automatically whenever $S$ is smooth.

## 4. Singularities

Differentiating the reduced norm gives

$$d(\operatorname{Nrd})_a(b) = \operatorname{Trd}(a^{\#}b).$$

Hence, for $a \in S$,

$$S \text{ is singular at } a \iff \operatorname{Trd}(a^{\#}b) = 0 \ \ \forall b \in V \iff a^{\#} \in V^{\perp},$$

where $\perp$ is taken with respect to the (always nondegenerate) reduced trace form $\langle x, y\rangle = \operatorname{Trd}(xy)$.

> **Criterion.** $S$ is non-singular $\iff$ for every $0 \neq a \in V \otimes \bar k$ with $\operatorname{Nrd}(a) = 0$ one has $a^{\#} \notin (V \otimes \bar k)^{\perp}$.

In matrix terms: writing $a^{\#} = v w^{t}$ for a rank $n-1$ element ($v$ spanning $\ker a$, and $w$ the left kernel), the condition at $a$ says that the linear form $b \mapsto w^{t} b v$ is not identically zero on $V$.

Two consequences are worth separating out.

1. **No very degenerate elements.** If $a \in V \otimes \bar k$ has rank $\leq n-2$, then $a^{\#} = 0 \in V^{\perp}$, so $a$ is a singular point. Thus smoothness forces $\mathbb{P}(V_{\bar k})$ to miss the rank $\leq n-2$ determinantal locus.
2. **Smooth $\Rightarrow$ birational.** If $\mathbb{P}(V_{\bar k})$ contains no element of rank $\leq n-2$, the incidence variety $\{(a, v) : av = 0\}$ has dimension $n-1$ and dominates $\mathbb{P}^{n-1}$; hence $\dim(V \cap L_J) = 1$ for generic $J$, and the maps of §3 are inverse birational maps.

## 5. Only $n \leq 3$ can be smooth

The locus of matrices of rank $\leq n-2$ has codimension $\bigl(n - (n-2)\bigr)^2 = 4$ in $\mathbb{P}(M_n) = \mathbb{P}^{n^2 - 1}$. By the projective dimension theorem, a linear subspace $\mathbb{P}(V_{\bar k}) = \mathbb{P}^{n}$ must meet it as soon as $n \geq 4$. Hence:

### $n \geq 4$

$S$ is **always singular**, whatever $V$ is. (This is the classical fact that linear determinantal hypersurfaces of dimension $\geq 3$ are singular.) One obtains only a singular birational model.

### $n = 2$

$A$ is a quaternion algebra, $V \subset A$ is any $3$-dimensional subspace, and $S \subset \mathbb{P}^2$ is the conic $\operatorname{Nrd}|_V = 0$. The rank $\leq 0$ condition is vacuous, and the criterion says: $S$ is smooth iff the quadratic form $\operatorname{Nrd}|_V$ is nondegenerate. Then $S \cong \operatorname{SB}(A)$, the usual anisotropic conic.

### $n = 3$

$A$ is a degree $3$ division algebra, $\dim V = 4$, and $S \subset \mathbb{P}^3$ is a **cubic surface**. Here the rank $\leq 1$ locus is the Segre variety $\mathbb{P}^2 \times \mathbb{P}^2 \subset \mathbb{P}^8$, of dimension $4$; since $4 + 3 < 8$, a general $\mathbb{P}^3$ misses it, and the second half of the criterion is also an open dense condition. (As $A$ is division of degree $> 1$, the field $k$ is infinite, so such $V$ exist over $k$.)

The resulting $S$ is a smooth cubic surface with $S(k) = \varnothing$, $k$-birational to the Severi–Brauer surface $\operatorname{SB}(A)$. Geometrically the birational map is the blow-down of the six points of $\operatorname{SB}(A)$ where $\dim(V \cap L_J) = 2$ — a Galois-stable set of six points, so $S$ is the blow-up of $\operatorname{SB}(A)$ along a closed subscheme of degree $6$. Conversely, the classical theorem that every smooth cubic surface admits a linear determinantal representation is what makes this case so rich.

## 6. Summary

$V$ gives the hypersurface

$$S = \{\operatorname{Nrd}|_V = 0\} \subset \mathbb{P}(V) \cong \mathbb{P}^n,$$

birational to $\operatorname{SB}(A)$ over $k$ via $a \mapsto a^{\#}A$, with inverse $J \mapsto V \cap L_J$. It is non-singular precisely when no nonzero $a \in V_{\bar k}$ with $\operatorname{Nrd}(a) = 0$ satisfies $a^{\#} \in V_{\bar k}^{\perp}$ — which can happen only for $n \leq 3$.