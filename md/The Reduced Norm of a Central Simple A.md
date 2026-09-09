# The Reduced Norm of a Central Simple Algebra via Determinants

## The definition

Let $A$ be a central simple algebra over $K$ with $\dim_K A = n^2$, so $A$ has **degree** $n$. By Wedderburn, $A$ becomes a matrix algebra after a field extension: there is a finite separable *splitting field* $L/K$ and an $L$-algebra isomorphism

$$\varphi : A \otimes_K L \;\xrightarrow{\ \sim\ }\; M_n(L).$$

(One can always take $L = \bar K$, or a separable closure, or — more economically — a maximal subfield of $A$ when $A$ is a division algebra.)

For $a \in A$, set

$$\mathrm{Nrd}_{A/K}(a) := \det\big(\varphi(a \otimes 1)\big).$$

Two things need checking: that this doesn't depend on $\varphi$ or $L$, and that the answer lies in $K$ rather than merely in $L$.

## Independence of the choice of $\varphi$

If $\varphi, \psi$ are two isomorphisms $A\otimes L \to M_n(L)$, then $\psi \circ \varphi^{-1}$ is an automorphism of $M_n(L)$, hence **inner** by Skolem–Noether: $\psi(x) = u\,\varphi(x)\,u^{-1}$ for some $u \in GL_n(L)$. Since $\det$ is conjugation-invariant,

$$\det \psi(a\otimes 1) = \det\varphi(a \otimes 1).$$

For independence of $L$: any two splitting fields embed into a common larger one, and $\det$ is unchanged by base change $L \subseteq L'$, since $\varphi \otimes_L L'$ is again a splitting isomorphism.

## Why the value lies in $K$

### Galois descent

Take $L/K$ Galois with group $G$ (possible, since separable splitting fields exist). Each $\sigma \in G$ acts on $A \otimes_K L$ by $1 \otimes \sigma$, and on $M_n(L)$ entrywise; call the latter $\sigma_*$. Then

$$\varphi^\sigma := \sigma_* \circ \varphi \circ (1\otimes\sigma)^{-1}$$

is again an $L$-algebra isomorphism $A \otimes L \to M_n(L)$. Because $a \otimes 1$ is fixed by $1 \otimes \sigma$,

$$\sigma\big(\det \varphi(a\otimes 1)\big) = \det\big(\varphi^\sigma(a \otimes 1)\big) = \det \big(\varphi(a\otimes 1)\big),$$

the last equality by the Skolem–Noether argument above. So $\mathrm{Nrd}(a)$ is $G$-invariant, hence lies in $L^G = K$.

### Alternative, via the regular representation

Let $L_a : A \to A$ be left multiplication, a $K$-linear endomorphism of the $n^2$-dimensional space $A$, and let $\chi_a \in K[X]$ be its characteristic polynomial. Over a splitting field, $A \otimes L \cong M_n(L)$ acts on $L^{n^2} \cong (L^n)^{\oplus n}$, i.e. the regular representation is $n$ copies of the standard one. Hence

$$\chi_a(X) = \big(\mathrm{Prd}_a(X)\big)^n, \qquad \mathrm{Prd}_a(X) := \det\big(X\cdot I - \varphi(a\otimes 1)\big).$$

A monic polynomial has at most one monic $n$-th root, and $\chi_a$ has coefficients in $K$; since $K[X] \hookrightarrow L[X]$ is injective and the root computed in $L[X]$ must agree with the one computed in $\bar K[X]$, the root $\mathrm{Prd}_a$ already lies in $K[X]$. This simultaneously gives you the **reduced characteristic polynomial** for free.

## Reduced characteristic polynomial, norm, trace

Writing $\mathrm{Prd}_a(X) = X^n - c_1 X^{n-1} + \cdots + (-1)^n c_n \in K[X]$:

- $\mathrm{Trd}(a) = c_1 = \mathrm{tr}\,\varphi(a\otimes 1)$
- $\mathrm{Nrd}(a) = c_n = \det \varphi(a \otimes 1)$
- $\mathrm{Prd}_a(a) = 0$ in $A$ (Cayley–Hamilton, checked after base change)

Relation to the ordinary norm and trace of the $K$-algebra $A$:

$$N_{A/K}(a) = \mathrm{Nrd}(a)^n, \qquad \mathrm{Tr}_{A/K}(a) = n\,\mathrm{Trd}(a).$$

So the reduced norm really is the "$n$-th root" of the honest determinant of $L_a$ — which is where the name comes from, and why in characteristic dividing $n$ you must define it by descent rather than by extracting a root numerically.

## Properties

- **Multiplicative:** $\mathrm{Nrd}(ab) = \mathrm{Nrd}(a)\mathrm{Nrd}(b)$, and $\mathrm{Nrd}(1) = 1$.
- **Homogeneous:** $\mathrm{Nrd}(\lambda a) = \lambda^n \mathrm{Nrd}(a)$ for $\lambda \in K$; it is a homogeneous polynomial map of degree $n$ in the coordinates of $a$ with respect to any $K$-basis of $A$.
- **Detects units:** $a \in A^\times \iff \mathrm{Nrd}(a) \neq 0$. For a division algebra $\mathrm{Nrd}$ is therefore nonvanishing away from $0$, giving a homomorphism $\mathrm{Nrd}: A^\times \to K^\times$.

## Examples

**Matrix algebra.** $A = M_n(K)$: $\mathrm{Nrd} = \det$, as it must be.

**Quaternion algebra.** $A = \big(\tfrac{a,b}{K}\big)$ with $i^2 = a$, $j^2 = b$, $k = ij$. Split it over $L = K(\sqrt a)$ via

$$i \mapsto \begin{pmatrix}\sqrt a & 0\\ 0 & -\sqrt a\end{pmatrix}, \qquad j \mapsto \begin{pmatrix}0 & 1\\ b & 0\end{pmatrix}.$$

Then

$$x + yi + zj + wk \;\longmapsto\; \begin{pmatrix} x + y\sqrt a & z + w\sqrt a \\ b(z - w\sqrt a) & x - y\sqrt a\end{pmatrix},$$

whose determinant is $x^2 - ay^2 - bz^2 + abw^2$ — the usual quaternion norm form, visibly in $K$.

**Maximal subfields.** When $A$ is a division algebra of degree $n$, any maximal subfield $E \subset A$ has $[E:K] = n$ and splits $A$, and for $a \in E$ one gets

$$\mathrm{Nrd}(a) = N_{E/K}(a).$$

The reduced norm restricts to the ordinary field norm on maximal subfields, which is often the fastest way to compute it.