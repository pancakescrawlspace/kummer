# Why $n$ divides $\dim_k I$ for a right ideal of a central simple algebra

*Companion note to "Severi–Brauer varieties as parameter spaces of ideals".*

Setting: $k$ a field, $A$ a central simple $k$-algebra of degree $n$ (so $\dim_k A = n^2$),
$I \subseteq A$ a right ideal. Two arguments follow, one by base change and one intrinsic.

---

## 1. Base change

Dimension is preserved by flat base change, and $I_L := I \otimes_k L$ is a right ideal of $A_L$ for
any field extension $L/k$. So take $L$ splitting $A$, identify $A_L \cong \operatorname{End}_L(V)$
with $\dim_L V = n$, and use the following.

> **Lemma.** Every right ideal of $\operatorname{End}_L(V)$ equals $\operatorname{Hom}_L(V, W)$ for a
> unique subspace $W \subseteq V$.

**Proof.** Given a right ideal $I$, put

$$
W \;=\; \sum_{f \in I} \operatorname{im} f .
$$

Since $\operatorname{im}(f \circ g) \subseteq \operatorname{im} f$, the inclusion
$I \subseteq \operatorname{Hom}(V, W)$ is immediate.

Conversely, choose $f_1, \dots, f_s \in I$ and $v_1, \dots, v_s \in V$ such that
$w_i := f_i(v_i)$ is a basis of $W$. For $h \in \operatorname{Hom}(V, W)$ write

$$
h(v) = \sum_i \lambda_i(v)\, w_i, \qquad \lambda_i \in V^*,
$$

and set $g_i(v) = \lambda_i(v)\, v_i$. Then

$$
h = \sum_i f_i \circ g_i \;\in\; I .
$$

Uniqueness of $W$ is clear, since $W$ is recovered as the sum of the images. $\blacksquare$

Hence

$$
\dim_k I \;=\; \dim_L I_L \;=\; n \cdot \dim_L W,
$$

and $\operatorname{rdim}(I) = \dim_L W$ is the "rank" one expects. Note this also shows that
$\operatorname{rdim}$ is independent of the choice of $L$ and of the splitting, since $\dim_k I$ was
defined over $k$ to begin with.

---

## 2. Intrinsic version

$A$ is simple, hence semisimple, so all simple right $A$-modules are isomorphic to a single $S$, and
every right ideal is a submodule of $A_A$. Therefore

$$
I \cong S^{\oplus j}, \qquad \dim_k I = j \cdot \dim_k S .
$$

Write $A \cong M_m(D)$ with $D$ division of degree $e$, so that $n = me$ and $\dim_k D = e^2$. The
simple module is $S = D^m$ (column vectors), giving

$$
\dim_k S \;=\; m e^2 \;=\; n e \;=\; n \cdot \operatorname{ind}(A).
$$

---

## 3. The sharper statement over $k$

Over $k$ the divisibility is therefore stronger than $n \mid \dim_k I$:

$$
n \cdot \operatorname{ind}(A) \;\big|\; \dim_k I,
\qquad\text{i.e.}\qquad
\operatorname{ind}(A) \;\big|\; \operatorname{rdim}(I)
$$

for ideals defined over $k$. That is exactly the content of

$$
\mathrm{SB}_d(A)(k) \neq \emptyset \iff \operatorname{ind}(A) \mid d
$$

— the necessity direction, anyway; sufficiency comes from exhibiting $S^{\oplus d/e}$.

It is also why, in the $(-1,-1)_{\mathbb{Q}}$ example, where $e = 2$, a right ideal of reduced
dimension $1$ cannot exist over $\mathbb{Q}$: the smallest nonzero one has $\operatorname{rdim} = 2$,
namely $Q$ itself.

The plain statement $n \mid \dim_k I$ is the base-changed, index-blind version — which is the right
one for the functor, since over a general $R$ the algebra need not be split and $\operatorname{ind}$
is not constant in families.
---

## 4. Not just ideals: every finite-dimensional module

*(Added 17 September 2026.)* Nothing in §2 used that $I$ sits inside $A$. Since $A$ is simple
Artinian, every right $A$-module is a direct sum of copies of the unique simple module $S = D^m$,
and a finite-dimensional one is $M \cong S^{\oplus j}$ with $j$ its length. Hence, for every
finite-dimensional right (or left) $A$-module $M$,

$$
\dim_k M \;=\; j \cdot n \cdot \operatorname{ind}(A), \qquad j = \operatorname{length}(M),
$$

and conversely every non-negative multiple of $n \cdot \operatorname{ind}(A)$ occurs, namely as
$S^{\oplus j}$. So the set of dimensions of finite-dimensional $A$-modules is exactly
$n \cdot \operatorname{ind}(A) \cdot \mathbb{Z}_{\ge 0}$. (Infinite-dimensional modules exist, e.g.
$S^{\oplus \mathbb{N}}$, and the statement is only about finite-dimensional ones.)

Sanity checks at the extremes:

- $A$ split ($e = 1$): dimensions are the multiples of $n$, the smallest being $k^n$ for $M_n(k)$.
- $A$ a division algebra ($e = n$): dimensions are the multiples of $n^2$, the smallest being $A$
  itself, as it must be since modules over a division ring are free.
- $A$ as a module over itself: $n^2 = m \cdot ne$, i.e. $A_A \cong S^{\oplus m}$, which is
  "$M_m(D)$ is $m$ copies of its column space".

In particular $A$ is split if and only if it has a module of $k$-dimension $n$, which is the form in
which this is used in "How Central Simple Algebras Entered Number Theory", §1, to prove that a cyclic
algebra $(L/K, \sigma, a)$ splits iff $a$ is a norm.
