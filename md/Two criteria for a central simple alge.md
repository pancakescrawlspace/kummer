# Two criteria for a central simple algebra to be a division algebra

*Companion note. Throughout, $k$ is a field and $A$ is a central simple $k$-algebra of degree $n$,
so $\dim_k A = n^2$ — in particular $A$ is finite-dimensional over its center. That finiteness
hypothesis is doing real work; see §3.*

---

## 1. No zero divisors

> **Proposition.** A finite-dimensional unital associative $k$-algebra $A \neq 0$ is a division
> algebra iff it has no zero divisors.

Simplicity and centrality are irrelevant to the argument.

**Proof.** ($\Rightarrow$) Immediate: if $x \neq 0$ and $xy = 0$, apply $x^{-1}$.

($\Leftarrow$) Suppose $A$ has no zero divisors and let $x \neq 0$. Left multiplication
$L_x : A \to A$ is a $k$-linear map with $\ker L_x = 0$, hence surjective by finite-dimensionality.
So there is $y$ with $xy = 1$. The same argument applied to $R_x$ gives $z$ with $zx = 1$, and

$$
z = z(xy) = (zx)y = y,
$$

so $x$ is a two-sided unit. $\blacksquare$

Note the argument also shows that left and right zero divisors coincide here.

### 1.1 Refinements in the finite-dimensional case

Writing $A \cong M_m(D)$ by Wedderburn, with $D$ division, the following are equivalent for $A$
central simple of degree $n$:

- $A$ is a division algebra;
- $A$ has no zero divisors;
- $m = 1$, i.e. $\operatorname{ind}(A) = \deg(A) = n$;
- the reduced norm form $\operatorname{Nrd} : A \to k$ is anisotropic, i.e.
  $\operatorname{Nrd}(x) = 0 \Rightarrow x = 0$;
- $A$ has no right ideals of reduced dimension $d$ with $0 < d < n$.

When $m > 1$ the matrix units give zero divisors on the nose: $e_{11} e_{22} = 0$.

The last bullet is the link back to the Severi–Brauer picture. A nonzero non-invertible $x \in A$
generates a proper nonzero right ideal $xA$, hence a $k$-point of some $\mathrm{SB}_d(A)$ with
$0 < d < n$; conversely a proper nonzero right ideal contains such an $x$.

---

## 2. No nonzero elements of norm zero

This is the fourth bullet above, and it is the *same* fact as the zero-divisor criterion, because the
non-invertible elements of $A$ are exactly the zeros of $\operatorname{Nrd}$.

> **Lemma.** For $A$ central simple of degree $n$ over $k$ and $x \in A$:
> $$
> x \in A^\times \iff \operatorname{Nrd}(x) \neq 0 .
> $$

**Proof.** ($\Rightarrow$) $\operatorname{Nrd}$ is multiplicative with $\operatorname{Nrd}(1) = 1$, so
$\operatorname{Nrd}(x)\operatorname{Nrd}(x^{-1}) = 1$.

($\Leftarrow$) Pick a splitting field $L$ and an identification $A_L \cong M_n(L)$; by construction
$\operatorname{Nrd}(x) = \det(x_L)$, and the point of the reduced norm is that this value lies in $k$
and is independent of both choices. If $\det(x_L) \neq 0$ then $L_{x_L}$ is bijective on $A_L$. But

$$
\ker(L_x) \otimes_k L = \ker(L_{x_L}),
$$

so $L_x$ is already bijective on $A$, and $x$ is invertible — bijectivity of $L_x$ in a
finite-dimensional algebra gives a two-sided inverse, as in §1. $\blacksquare$

**A proof that stays inside $A$.** The reduced characteristic polynomial

$$
\operatorname{Prd}_x(T) = T^n - \operatorname{Trd}(x) T^{n-1} + \cdots + (-1)^n \operatorname{Nrd}(x)
$$

has coefficients in $k$ and satisfies $\operatorname{Prd}_x(x) = 0$. Solving for the constant term
exhibits $x^{-1}$ explicitly as a polynomial in $x$ divided by $\pm \operatorname{Nrd}(x)$.

Given the lemma:

$$
A \text{ is division}
\iff \text{every nonzero } x \text{ is invertible}
\iff \operatorname{Nrd} \text{ is anisotropic},
$$

where *anisotropic* means the only $k$-point of $\{\operatorname{Nrd} = 0\}$ is the origin.

### 2.1 Which norm?

If one means instead the algebra norm $N_{A/k}(x) = \det(L_x)$ — the determinant of left
multiplication on the $n^2$-dimensional space $A$ — the statement still holds, because

$$
N_{A/k}(x) = \operatorname{Nrd}(x)^n ,
$$

so the zero loci agree. But the two forms have different degrees ($n$ versus $n^2$), which matters
for the counting argument in §4.

### 2.2 Over $k$ only

Anisotropy is a statement about $k$-rational points. For $n \geq 2$ the hypersurface
$\{\operatorname{Nrd} = 0\} \subset \mathbb{A}^{n^2}$ is always nonempty over $\bar k$ — it contains
the rank-deficient matrices — so the criterion is genuinely arithmetic, not geometric.

---

## 3. Where finite-dimensionality is doing real work

Some authors define "central simple" without the finiteness hypothesis, and then §1 fails. The Weyl
algebra

$$
A_1(k) = k\langle p, q\rangle / (pq - qp - 1), \qquad \operatorname{char} k = 0,
$$

is simple with center $k$, and it is a domain: filter by order and pass to the associated graded,
which is the polynomial ring $k[\bar p, \bar q]$; symbols multiply, so leading terms cannot cancel.
But it is very far from a division algebra — $q$ has no inverse. It is an Ore domain, so it embeds in
a division ring, its Weyl skew field, but that division ring is not $A_1(k)$ itself.

The same collapse applies to §2, only more so: the Weyl algebra has no reduced norm at all.

---

## 4. A payoff: Wedderburn's little theorem, and $C_1$ fields

$\operatorname{Nrd}$ is a form of degree $n$ in $n^2$ variables, and $n^2 > n$ as soon as $n \geq 2$.
So over any field where every form of degree $d$ in more than $d$ variables is isotropic, no
noncommutative central simple algebra can be a division algebra.

- **Finite fields.** Chevalley–Warning supplies exactly that hypothesis, giving *Wedderburn's little
  theorem*: every finite division ring is commutative.
- **$C_1$ fields.** The same argument over function fields of curves over an algebraically closed
  field (Tsen), or over $\bar{\mathbb{F}}_p((t))$ (Lang), gives $\operatorname{Br}(k) = 0$.

### 4.1 The quaternion case

For $n = 2$ this specializes to the classical statement: $\operatorname{Nrd}$ is the quaternion norm
form $\langle 1, -a, -b, ab \rangle$, and $(a,b)_k$ is a division algebra iff that $4$-variable
quadratic form is anisotropic — equivalently, projecting onto pure quaternions, iff the conic $C$ has
no $k$-point.

Concretely, an element $q \in Q^0$ with $\operatorname{Nrd}(q) = 0$ satisfies $q^2 = 0$: the most
conspicuous kind of zero divisor. So $(-1,-1)_{\mathbb{Q}}$ is a division algebra precisely because
$x^2 + y^2 + z^2 = 0$ has no rational point.