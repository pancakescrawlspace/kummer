# Severi–Brauer varieties as parameter spaces of ideals

*Notes: the precise statement, plus a worked quaternion/conic example.*

---

## 1. The exact statement

Let $k$ be a field and $A$ a central simple $k$-algebra of degree $n$ (so $\dim_k A = n^2$).
For a right ideal $I \subseteq A$ one always has $n \mid \dim_k I$, and one calls

$$
\operatorname{rdim}(I) \;=\; \frac{\dim_k I}{n}
$$

the **reduced dimension** of $I$.

### 1.1 Representability

**Definition/Theorem.** Fix $0 \le d \le n$ and consider the functor on commutative $k$-algebras

$$
\mathcal{SB}_d(A)\colon\quad
R \;\longmapsto\;
\bigl\{\, I \subseteq A_R := A \otimes_k R \;\big|\;
I \text{ a right ideal which is an } R\text{-module direct summand of } A_R \text{ of rank } dn \,\bigr\}.
$$

This functor is representable by a smooth projective $k$-variety $\mathrm{SB}_d(A)$, realized as the
closed subscheme of the Grassmannian $\mathrm{Gr}(dn, A)$ — the Grassmannian of $dn$-dimensional
subspaces of the $n^2$-dimensional $k$-vector space $A$ — cut out by the condition
$I \cdot A \subseteq I$, i.e. by the vanishing of the composite

$$
I \otimes A \longrightarrow A \longrightarrow A/I .
$$

### 1.2 Splitting

If $L/k$ splits $A$, a choice of isomorphism $A_L \cong \operatorname{End}_L(V)$ with $\dim_L V = n$
induces

$$
\mathrm{Gr}(d, V) \;\xrightarrow{\ \sim\ }\; \mathrm{SB}_d(A)_L,
\qquad
W \longmapsto \operatorname{Hom}_L(V, W) = \{\, f : \operatorname{im} f \subseteq W \,\}.
$$

This is a bijection because every right ideal of $\operatorname{End}(V)$ is of this form: the simple
right submodules of $\operatorname{End}(V)$ are exactly the $\operatorname{Hom}(V, L)$ for lines
$L \subseteq V$. In particular, writing

$$
\mathrm{SB}(A) := \mathrm{SB}_1(A),
\qquad
\mathrm{SB}(A)_L \cong \mathbb{P}(V) \cong \mathbb{P}^{\,n-1}_L .
$$

So $\mathrm{SB}(A)$ is a $k$-form of $\mathbb{P}^{n-1}$. The isomorphism above is *not* canonical — it
depends on the splitting, and that is exactly the source of the Brauer class.

### 1.3 The dictionary

Both degree-$n$ central simple algebras and $(n-1)$-dimensional Severi–Brauer varieties are classified
by $H^1(k, \mathrm{PGL}_n)$, via

$$
\operatorname{Aut}(M_n) \;=\; \operatorname{Aut}(\mathbb{P}^{n-1}) \;=\; \mathrm{PGL}_n ,
$$

and $A \mapsto \mathrm{SB}(A)$ is a bijection on isomorphism classes. Consequences:

- $\mathrm{SB}_d(A)(k) \neq \emptyset \iff \operatorname{ind}(A) \mid d$. In particular
  $$
  \mathrm{SB}(A)(k) \neq \emptyset
  \iff A \text{ is split}
  \iff \mathrm{SB}(A) \cong \mathbb{P}^{\,n-1}_k .
  $$
- The Brauer class of $X = \mathrm{SB}(A)$ — defined as the image of
  $\mathcal{O}(1) \in \operatorname{Pic}(X_{\bar k})^{\Gamma}$ under the Hochschild–Serre differential
  $\operatorname{Pic}(X_{\bar k})^\Gamma \to \operatorname{Br}(k)$, i.e. the obstruction to descending
  $\mathcal{O}(1)$ — equals $[A]$.
- **(Amitsur)** $\ker\bigl(\operatorname{Br}(k) \to \operatorname{Br}(k(X))\bigr) = \langle [A] \rangle$.

### 1.4 Two caveats

1. The algebra is not merely determined up to Brauer class: $\mathrm{SB}(A)$ recovers $A$ up to
   **isomorphism**, and the degree is pinned down by $\deg A = \dim X + 1$. Brauer-equivalent algebras
   of different degrees give different varieties: $\mathrm{SB}(Q)$ is a conic, while
   $\mathrm{SB}(M_2(Q))$ is a threefold.
2. Some authors (Artin, among others) use **left** ideals instead of right ideals. That convention
   replaces $A$ by $A^{\mathrm{op}}$, i.e. negates the Brauer class. Knus–Merkurjev–Rost–Tignol use
   right ideals, as above. For quaternion algebras the distinction is invisible, since
   $Q \cong Q^{\mathrm{op}}$ via conjugation.

---

## 2. Quaternion algebras and conics

Let $\operatorname{char} k \neq 2$ and let

$$
Q = (a,b)_k = \langle 1, \mathbf{i}, \mathbf{j}, \mathbf{ij} \rangle,
\qquad
\mathbf{i}^2 = a,\quad \mathbf{j}^2 = b,\quad \mathbf{ji} = -\mathbf{ij}.
$$

The reduced norm is

$$
\operatorname{Nrd}(w + x\mathbf{i} + y\mathbf{j} + z\mathbf{ij})
\;=\; w^2 - a x^2 - b y^2 + ab z^2 .
$$

Restrict it to the space of pure quaternions $Q^0 = \ker(\operatorname{Trd}) = \langle \mathbf{i}, \mathbf{j}, \mathbf{ij}\rangle$ and set

$$
C \;=\; \bigl\{\, [q] \in \mathbb{P}(Q^0) \;:\; \operatorname{Nrd}(q) = 0 \,\bigr\}
\;=\; \{\, a x^2 + b y^2 - ab z^2 = 0 \,\} \;\subset\; \mathbb{P}^2_k ,
$$

which is $k$-isomorphic to the usual conic $b x^2 + a y^2 = z^2$.

> **Claim.** $C \xrightarrow{\ \sim\ } \mathrm{SB}(Q)$ via $[q] \mapsto I_q := qQ$, with inverse
> $I \mapsto [\, I \cap Q^0 \,]$.

**Why this works.** If $q \in Q^0$ and $\operatorname{Nrd}(q) = 0$, then $\bar q = -q$ and

$$
q^2 = -q\bar q = -\operatorname{Nrd}(q) = 0 .
$$

Hence

$$
qQ \;=\; \{\, x \in Q : qx = 0 \,\} \;=\; \ker(L_q),
$$

and since $q \neq 0$ is a rank-one, square-zero element after any splitting, $L_q$ has constant rank
$2$ along $C$. So $[q] \mapsto \ker L_q$ is a morphism $C \to \mathrm{Gr}(2, Q)$ landing in
$\mathrm{SB}(Q)$, manifestly defined over $k$.

Conversely, after splitting, $I = \operatorname{Hom}(V, W)$ with $\dim W = 1$, on which
$\operatorname{Trd}$ is a nonzero functional; so $I \cap Q^0$ is a line, spanned by the unique (up to
scalar) square-zero element with image $W$. The two maps are mutually inverse over $\bar k$, hence
over $k$.

**The full norm quadric.** $\{\operatorname{Nrd} = 0\} \subset \mathbb{P}(Q) = \mathbb{P}^3$ has trivial
discriminant, so both of its rulings are defined over $k$: they are $[q] \mapsto qQ$ and
$[q] \mapsto Qq$, giving

$$
\{\operatorname{Nrd} = 0\} \;\cong\; \mathrm{SB}(Q) \times \mathrm{SB}(Q^{\mathrm{op}}) \;\cong\; C \times C .
$$

---

## 3. Explicit example: $Q = (-1,-1)_{\mathbb{Q}}$

Here $\operatorname{Nrd}|_{Q^0} = x^2 + y^2 + z^2$, so

$$
C : \; x^2 + y^2 + z^2 = 0 \;\subset\; \mathbb{P}^2_{\mathbb{Q}},
\qquad
C(\mathbb{Q}) = \emptyset .
$$

Correspondingly $Q$ is a division algebra — its norm form is anisotropic over $\mathbb{Q}$, indeed
already over $\mathbb{R}$ — so $Q$ has **no** right ideals of reduced dimension $1$ over $\mathbb{Q}$.
The two statements are the same statement. The class $[Q] \in \operatorname{Br}(\mathbb{Q})[2]$ is
ramified exactly at $2$ and $\infty$.

### 3.1 A point after base change

Split by $L = \mathbb{Q}(\sqrt{-1})$ and take the $L$-point $[\,1 : \sqrt{-1} : 0\,] \in C(L)$, i.e.

$$
q = \mathbf{i} + \sqrt{-1}\,\mathbf{j},
\qquad
q^2 = \mathbf{i}^2 + \sqrt{-1}\,(\mathbf{ij} + \mathbf{ji}) - \mathbf{j}^2 = -1 + 0 + 1 = 0 .
$$

Computing $q\mathbf{i} = -1 - \sqrt{-1}\,\mathbf{ij}$ and $q\mathbf{j} = \sqrt{-1}\, q\mathbf{i}$, the
corresponding right ideal is

$$
I_q = qQ_L = \operatorname{span}_L\bigl\{\; \mathbf{i} + \sqrt{-1}\,\mathbf{j},\;\; 1 + \sqrt{-1}\,\mathbf{ij} \;\bigr\},
\qquad \dim_L I_q = 2 .
$$

Its trace-zero part is the line $L \cdot q$, recovering the point — the inverse map in action.

### 3.2 In matrices

Over $L$, send

$$
\mathbf{i} \mapsto \begin{pmatrix} \sqrt{-1} & 0 \\ 0 & -\sqrt{-1} \end{pmatrix},
\qquad
\mathbf{j} \mapsto \begin{pmatrix} 0 & 1 \\ -1 & 0 \end{pmatrix},
\qquad\text{so}\qquad
\mathbf{ij} \mapsto \begin{pmatrix} 0 & \sqrt{-1} \\ \sqrt{-1} & 0 \end{pmatrix},
$$

giving $Q_L \cong M_2(L)$. Then

$$
q \;\longmapsto\; \sqrt{-1} \begin{pmatrix} 1 & 1 \\ -1 & -1 \end{pmatrix},
\qquad
I_q \;\longmapsto\;
\left\{ \begin{pmatrix} s & t \\ -s & -t \end{pmatrix} : s, t \in L \right\}
= \operatorname{Hom}\bigl(L^2, W\bigr),
$$

with $W = L \cdot (1, -1)^{\mathsf{T}}$, the point $[1 : -1] \in \mathbb{P}^1(L)$. So under the
splitting, $I_q$ is exactly the right ideal attached to a line in $V = L^2$, as in §1.2.

### 3.3 The descent obstruction

The nontrivial $\sigma \in \operatorname{Gal}(L/\mathbb{Q})$ sends $q$ to
$\mathbf{i} - \sqrt{-1}\,\mathbf{j}$, hence

$$
\sigma(I_q) = \operatorname{span}_L\{\, \mathbf{i} - \sqrt{-1}\,\mathbf{j},\; 1 - \sqrt{-1}\,\mathbf{ij} \,\}
\;\neq\; I_q ,
$$

matching the fact that the two points $[1 : \pm\sqrt{-1} : 0]$ of $C(L)$ are conjugate. Neither ideal
is defined over $\mathbb{Q}$, and no $\mathbb{Q}$-rational one exists — which is precisely
$C(\mathbb{Q}) = \emptyset$, i.e. $[Q] \neq 0$ in $\operatorname{Br}(\mathbb{Q})$.

---

## References

- M.-A. Knus, A. Merkurjev, M. Rost, J.-P. Tignol, *The Book of Involutions*, AMS Colloquium
  Publications 44, 1998 — §1.C and §1.16 for $\mathrm{SB}_d(A)$ and the conic of a quaternion algebra.
- P. Gille, T. Szamuely, *Central Simple Algebras and Galois Cohomology*, 2nd ed., CUP, 2017 —
  Chapter 5 for Severi–Brauer varieties, Amitsur's theorem, and the $H^1(k,\mathrm{PGL}_n)$ dictionary.
- J. Kollár, *Severi–Brauer varieties; a geometric treatment*, arXiv:1606.04368.