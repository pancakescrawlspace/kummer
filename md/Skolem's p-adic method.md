# Skolem's $p$-adic method

**Question.** What is Skolem's method?

**Answer.** "Skolem's method" usually means **Skolem's $p$-adic method** for Diophantine equations, introduced by Thoralf Skolem in the 1930s. The name is also sometimes used loosely for **Skolemization** in logic, which is covered briefly at the end.

## The idea

Skolem's method shows that certain Diophantine equations have only finitely many solutions, and often finds all of them. You turn the equation into a problem about when a $p$-adic analytic function vanishes, then count its zeros.

## The setup

Many equations, such as Thue equations and norm form equations, can be rewritten inside a number field $K$. Take the cubic Thue equation
$$x^3 - d y^3 = 1 .$$

Let $\theta = \sqrt[3]{d}$. Since $N_{K/\mathbb{Q}}(x - y\theta) = x^3 - d y^3$, the equation says that $x - y\theta$ is a unit of norm $1$ in $\mathbb{Z}[\theta]$. The field $\mathbb{Q}(\theta)$ has one real embedding and one pair of complex embeddings, so its unit rank is $1$, and
$$x - y\theta = \pm\,\eta^{n}, \qquad n \in \mathbb{Z},$$
where $\eta$ is a fundamental unit of $\mathbb{Z}[\theta]$. Write $\eta^n$ in the basis $1, \theta, \theta^2$:
$$\eta^n = A(n) + B(n)\,\theta + C(n)\,\theta^2 .$$

Every solution requires
$$C(n) = 0 .$$
So the task becomes finding the integers $n$ at which the $\theta^2$-coefficient vanishes.

## The $p$-adic step

1. **Pick a suitable prime $p$.** Take $p$ odd and not dividing the discriminant of $\mathbb{Z}[\theta]$. The unit group of the finite ring $\mathbb{Z}[\theta]/p$ is finite, so there is some $m \ge 1$ with $\eta^m \equiv 1 \pmod{p}$. Split $n$ into residue classes $n = n_0 + m t$ with $0 \le n_0 < m$.

2. **Make the exponent analytic.** Because $\eta^m \equiv 1 \pmod p$, the $p$-adic logarithm and exponential converge and
   $$\eta^{mt} = \exp\big(t \log_p \eta^m\big)$$
   is a power series in $t$ that converges for all $t \in \mathbb{Z}_p$. The same holds for each of its coordinates in the basis $1, \theta, \theta^2$.

3. **Get one equation in one variable.** On each residue class,
   $$C(n_0 + mt) = f(t) = \sum_{k \ge 0} a_k t^k, \qquad a_k \in \mathbb{Z}_p,\ a_k \to 0 .$$

4. **Count the zeros with Strassmann's theorem.**

   > **Strassmann's theorem.** Let $f(t) = \sum a_k t^k \in \mathbb{Z}_p[[t]]$ with $a_k \to 0$ and $f \neq 0$. Let $N$ be the largest index with $|a_N|_p = \max_k |a_k|_p$. Then $f$ has at most $N$ zeros in $\mathbb{Z}_p$.

   This bounds the number of integer solutions in each residue class, hence in total.

5. **Find them all.** Often $N = 1$ in every residue class where a solution is already known, such as the trivial solution $(x, y) = (1, 0)$, which corresponds to $n = 0$, and $N = 0$ in the others. That proves there are no further solutions.

## When it works

You need **at least as many equations as unknown exponents**. In general there are $r$ exponents, one per fundamental unit, and some number of coefficient conditions. If the number of conditions is at least $r$, $p$-adic analytic geometry (Weierstrass preparation in several variables) gives finiteness.

- For a cubic field with negative discriminant, $r = 1$ and there is one condition, so the method works.
- For a totally real cubic field, $r = 2$ and there is still only one condition, so the basic method fails without extra tricks.

More generally, for a Thue equation of degree $n \ge 3$ you get $n - 2$ conditions and $r = r_1 + r_2 - 1$ exponents. Since $r_1 + 2r_2 = n$, the inequality $r \le n - 2$ holds exactly when $r_2 \ge 1$, i.e. when $f(x, 1)$ has at least one non-real root. So the basic method fails only when the field is totally real.

This "number of conditions versus rank" count is made precise in the next section.

## Skolem and Chabauty: one method in two settings

Chabauty's method (1941) generalizes Skolem's. Skolem's argument takes place in the unit group of a number field; Chabauty ran the same argument in the Jacobian of a curve. The connection is clearest once both are put into a common template.

### The common template

The ingredients are:

- a commutative algebraic group $G$ over $\mathbb{Q}$ of dimension $d$: a **torus** for Skolem, an **abelian variety** for Chabauty;
- a finitely generated subgroup $\Gamma \subseteq G(\mathbb{Q})$ of rank $r$ that contains the global points of interest. Its finite generation comes from **Dirichlet's unit theorem** for Skolem and the **Mordell–Weil theorem** for Chabauty;
- a closed subvariety $X \subseteq G$. The solutions we want are the points of $X \cap \Gamma$.

Fix a prime $p$. Then $G(\mathbb{Q}_p)$ is a $p$-adic Lie group, and there is a $p$-adic logarithm
$$\log_G : G(\mathbb{Q}_p)^{\circ} \longrightarrow \operatorname{Lie}(G) \otimes \mathbb{Q}_p \cong \mathbb{Q}_p^{d}$$
on a suitable open subgroup $G(\mathbb{Q}_p)^\circ$: the units of $\mathcal{O}_K \otimes \mathbb{Z}_p$ for a torus, or all of $J(\mathbb{Q}_p)$ for a Jacobian. It is a homomorphism, a local isomorphism near the identity, and its kernel is the torsion subgroup.

Let $\overline{\Gamma}$ be the closure of $\Gamma$ in $G(\mathbb{Q}_p)$. Its image under $\log_G$ lies in the $\mathbb{Q}_p$-span of $\log_G(\Gamma)$, a subspace of dimension at most $r$. So $\overline{\Gamma}$ is a $p$-adic Lie subgroup of dimension at most $r$, and
$$X \cap \Gamma \;\subseteq\; X(\mathbb{Q}_p) \cap \overline{\Gamma}.$$

An analytic subgroup of dimension $\le r$ and an analytic subvariety of dimension $\dim X$ inside a $d$-dimensional group are expected to meet in dimension $r + \dim X - d$. This gives the governing inequality:

$$\boxed{\; r + \dim X \;\le\; d \;} \qquad\Longleftrightarrow\qquad r \le \operatorname{codim}_G X .$$

When it holds, the intersection is expected to be discrete. Compactness then makes it finite, provided nothing degenerate happens (see below).

### Two ways to compute the intersection

There are two dual ways to compute $X(\mathbb{Q}_p) \cap \overline{\Gamma}$:

- **(S) Parametrize $\overline{\Gamma}$ and pull back the equations of $X$.** Choose generators $\gamma_1, \dots, \gamma_r$ of $\Gamma$ modulo torsion, and $m$ so that the $\gamma_i^m$ lie where $\exp$ converges. Cover $\Gamma$ by the cosets $\gamma_0 \cdot \langle \gamma_1^m, \dots, \gamma_r^m \rangle$ and parametrize each by
  $$t \in \mathbb{Z}_p^r \longmapsto \gamma_0 \cdot \exp\Big(\textstyle\sum_i t_i \log_G \gamma_i^m\Big).$$
  The equations of $X$ become $\operatorname{codim} X$ analytic equations in $r$ variables.

- **(C) Parametrize $X(\mathbb{Q}_p)$ and pull back the equations of $\overline{\Gamma}$.** The group $\overline{\Gamma}$ is cut out, near the identity, by linear functionals $\ell$ on $\operatorname{Lie}(G)$ that vanish on $\log_G(\Gamma)$. There are at least $d - r$ independent ones. Each gives an analytic equation $\ell(\log_G x) = 0$ on $X(\mathbb{Q}_p)$, in $\dim X$ local variables.

Both produce the same set. **Skolem uses (S)** because in a torus, $X$ is cut out by simple linear equations in the coordinates of $K \otimes \mathbb{Q}_p$. **Coleman's version of Chabauty uses (C)** because a Jacobian is hard to write down explicitly, while the curve and its differentials are easy to work with.

### Skolem's method in this language

For the Thue equation $x^3 - dy^3 = 1$ with $K = \mathbb{Q}(\theta)$, $\theta = \sqrt[3]{d}$:

- $G = T = R^1_{K/\mathbb{Q}}\mathbb{G}_m$, the **norm-one torus**, whose $R$-points are $\{z \in K \otimes R : N(z) = 1\}$. Here $d = [K:\mathbb{Q}] - 1 = 2$.
- $\Gamma$ is the group of norm-one units of $\mathbb{Z}[\theta]$, of rank $r = 1$.
- $X = \{a + b\theta + c\theta^2 \in T : c = 0\}$. This is the Thue curve itself, embedded via $(x, y) \mapsto x - y\theta$, so $\dim X = 1$.

The count is $r + \dim X = 2 = d$, so the method applies. For a totally real cubic field, $r = 2$ and $r + \dim X = 3 > 2$. This is exactly the failure noted earlier.

The computation in the steps above is method **(S)**: $t \mapsto \eta^{n_0 + mt}$ parametrizes a coset of $\overline{\Gamma}$, and $C(n_0 + mt) = 0$ is the pulled-back equation of $X$.

Method **(C)** works just as well here:
- The Lie algebra is $\operatorname{Lie}(T) = \{z \in K \otimes \mathbb{Q}_p : \operatorname{Tr}(z) = 0\}$, which is 2-dimensional.
- $\log_p(\Gamma)$ spans the line through $\lambda = \log_p \eta$.
- Choose a nonzero linear functional $\ell$ on $\operatorname{Lie}(T)$ with $\ell(\lambda) = 0$.

Every solution then satisfies
$$F(x, y) := \ell\big(\log_p(x - y\theta)\big) = 0,$$
a $p$-adic analytic function on the curve $X(\mathbb{Z}_p)$. On each residue disc it can be expanded in a local parameter, exactly as in Coleman's method below.

The same template covers general norm form equations. The torus has $d = [K:\mathbb{Q}] - 1$, the unit rank is $r = r_1 + r_2 - 1$, and $X$ is a linear slice of $T$. The inequality $r \le \operatorname{codim} X$ is Skolem's condition "at least as many conditions as unknown exponents".

### Degenerate intersections: the Skolem–Mahler–Lech theorem

The dimension count gives finiteness only if $X$ does not contain a positive-dimensional piece of $\overline{\Gamma}$. The Skolem–Mahler–Lech theorem shows what that degeneration looks like.

Consider a linear recurrence $u_n = \sum_{i=1}^s c_i \alpha_i^n$ with distinct, nonzero roots $\alpha_i$. Take:
- $G = \mathbb{G}_m^s$, over a number field containing the $\alpha_i$. Embed that field in some $\mathbb{Q}_p$ where all $\alpha_i$ are $p$-adic units; such primes exist.
- $\Gamma = \{(\alpha_1^n, \dots, \alpha_s^n)\}$, a cyclic group, so $r \le 1$.
- $X$ the hyperplane $\sum c_i z_i = 0$, with $\dim X = s - 1$.

Then $r + \dim X \le s = d$, so the count allows finiteness, but only just.

On each residue class $n = n_0 + mt$, $u_n = f(t)$ is analytic in $t$. So either $f$ has finitely many zeros, or $f \equiv 0$, which happens exactly when $X$ contains that entire coset of $\overline{\Gamma}$. The $f \equiv 0$ classes are the arithmetic progressions in the theorem.

**Example.** $u_n = 2^n - (-2)^n$ has $\Gamma = \{(2^n, (-2)^n)\}$ and $X = \{z_1 = z_2\}$. The subgroup generated by $(4, 4)$ lies in $X$, and $u_n$ vanishes for all even $n$.

For Chabauty's method on a curve of genus $\ge 2$, this degeneration cannot occur, as shown below.

## Chabauty's method

### Setup

Let $C/\mathbb{Q}$ be a smooth, projective, geometrically integral curve of genus $g \ge 2$. Assume $C(\mathbb{Q}) \neq \emptyset$ and fix $P_0 \in C(\mathbb{Q})$. Let $J$ be the Jacobian of $C$, with Abel–Jacobi embedding
$$\iota : C \hookrightarrow J, \qquad P \mapsto [P - P_0].$$
By Mordell–Weil, $J(\mathbb{Q})$ is finitely generated; let $r$ be its rank. In the template, $G = J$ with $d = g$, $\Gamma = J(\mathbb{Q})$, and $X = \iota(C)$ with $\dim X = 1$. The inequality $r + 1 \le g$ becomes:

> **Chabauty's theorem (1941).** If $r < g$, then $C(\mathbb{Q})$ is finite.

Faltings (1983) later proved finiteness for every curve of genus $\ge 2$, whatever the rank. His proof does not give a way to find the points. When $r < g$, Chabauty's method frequently determines $C(\mathbb{Q})$ exactly.

### Proof sketch

1. **The $p$-adic group.** $J(\mathbb{Q}_p)$ is a compact $p$-adic Lie group of dimension $g$. Its logarithm $\log : J(\mathbb{Q}_p) \to \operatorname{Lie}(J) \otimes \mathbb{Q}_p$ is a homomorphism whose kernel is the finite torsion subgroup.

2. **Differentials as functionals.** The dual of $\operatorname{Lie}(J)$ is the space of invariant differentials $H^0(J_{\mathbb{Q}_p}, \Omega^1)$. Pullback along $\iota$ identifies this with $H^0(C_{\mathbb{Q}_p}, \Omega^1)$. So every holomorphic differential $\omega$ on $C$ defines a homomorphism
   $$J(\mathbb{Q}_p) \longrightarrow \mathbb{Q}_p, \qquad D \longmapsto \int_0^D \omega := \langle \log D, \omega \rangle .$$

3. **Annihilating differentials.** Let
   $$V = \Big\{\omega \in H^0(C_{\mathbb{Q}_p}, \Omega^1) : \int_0^D \omega = 0 \text{ for all } D \in J(\mathbb{Q})\Big\}.$$
   These are the functionals $\ell$ of method **(C)**. Since $\log J(\mathbb{Q})$ spans at most $r$ dimensions, $\dim V \ge g - r \ge 1$.

4. **A function vanishing on rational points.** Fix a nonzero $\omega \in V$ and define
   $$\lambda_\omega(P) := \int_{P_0}^{P} \omega := \int_0^{\iota(P)} \omega \qquad (P \in C(\mathbb{Q}_p)).$$
   Then $\lambda_\omega(P) = 0$ for every $P \in C(\mathbb{Q})$.

5. **Finiteness.** $\lambda_\omega$ is locally analytic on $C(\mathbb{Q}_p)$, and $d\lambda_\omega = \omega|_C \neq 0$. So $\lambda_\omega$ is not constant on any residue disc, and its zeros are isolated. Since $C(\mathbb{Q}_p)$ is compact, $\lambda_\omega$ has finitely many zeros. $\blacksquare$

Step 5 is where degeneration is ruled out. In the Skolem–Mahler–Lech setting, the analytic function could vanish identically on a residue class. Here its derivative is a nonzero differential, so it cannot.

### Making it effective: Coleman integration

Coleman (1985) showed that $\lambda_\omega$ can be computed directly on the curve, without ever writing down the Jacobian.

- **Residue discs.** Take $p$ a prime of good reduction, so $C$ has a smooth proper model over $\mathbb{Z}_p$ and $C(\mathbb{Q}_p) = C(\mathbb{Z}_p)$. Reduction gives a map $C(\mathbb{Q}_p) \to C(\mathbb{F}_p)$, and the fibre over $\bar{Q} \in C(\mathbb{F}_p)$ is the **residue disc** $D_{\bar{Q}}$. Pick a lift $Q \in D_{\bar Q}$ and a local parameter $t$ at $Q$ that reduces to a uniformizer at $\bar{Q}$. Then $t$ identifies $D_{\bar{Q}}$ with $p\mathbb{Z}_p$.

- **Tiny integrals (within one disc).** Take $\omega$ in the integral lattice $H^0(C_{\mathbb{Z}_p}, \Omega^1)$. On the disc, $\omega = w(t)\,dt$ with $w(t) = \sum_k w_k t^k \in \mathbb{Z}_p[[t]]$, and
  $$\lambda_\omega(t) = \lambda_\omega(Q) + \int_0^t w(s)\,ds = \lambda_\omega(Q) + \sum_{k \ge 0} \frac{w_k}{k+1}\, t^{k+1}.$$

- **Integrals between discs.** Some integrals connect different residue discs: the constants $\lambda_\omega(Q)$, and the values $\int_0^D \omega$ needed to find $V$ from generators of $J(\mathbb{Q})$. These are **Coleman integrals**, defined by analytic continuation along Frobenius. They can be computed in practice, for example by the algorithm of Balakrishnan–Bradshaw–Kedlaya for hyperelliptic curves.

### Counting zeros on a disc: this is Skolem's Step 4

Scale $\omega \in V$ so that it lies in the integral lattice and its reduction $\bar\omega \in H^0(C_{\mathbb{F}_p}, \Omega^1)$ is nonzero. Let $n = \operatorname{ord}_{\bar{Q}}(\bar\omega)$. Then $w_0, \dots, w_{n-1} \in p\mathbb{Z}_p$ and $w_n \in \mathbb{Z}_p^\times$.

Substitute $t = pu$ with $u \in \mathbb{Z}_p$:
$$\lambda_\omega(pu) = b_0 + \sum_{k \ge 0} b_{k+1} u^{k+1}, \qquad b_{k+1} = \frac{w_k\, p^{k+1}}{k+1}.$$

- The coefficient $b_{n+1}$ has valuation exactly $n + 1$, since $w_n$ is a unit and $n + 1 < p$.
- For $k > n$, $v_p(b_{k+1}) \ge k + 1 - v_p(k+1)$, and this is strictly greater than $n + 1$ when $p > n + 2$. (If $v_p(k+1) = e \ge 1$, then $k + 1 - e \ge p^e - e \ge p - 1 \ge n + 2$.)

So $b_j \to 0$, and the largest index at which $|b_j|_p$ is maximal is at most $n + 1$. By Strassmann's theorem, $\lambda_\omega$ has **at most $n + 1$ zeros in $D_{\bar Q}$**.

Now sum over $\bar{Q} \in C(\mathbb{F}_p)$. The divisor of $\bar\omega$ has degree $2g - 2$, so $\sum_{\bar Q} \operatorname{ord}_{\bar Q}(\bar\omega) \le 2g - 2$. This gives:

> **Coleman's bound (1985).** If $r < g$ and $p > 2g$ is a prime of good reduction for $C$, then
> $$\#C(\mathbb{Q}) \;\le\; \#C(\mathbb{F}_p) + 2g - 2 .$$

The hypothesis $p > 2g$ guarantees $p > n + 2$ for every possible order $n \le 2g - 2$. Later refinements:
- Stoll (2006, Corollary 6.7) improved the error term $2g - 2$ to $2r$: if $r < g$ and $p > 2r + 2$ is a prime of good reduction, then $\#C(\mathbb{Q}) \le \#C(\mathbb{F}_p) + 2r$. (His statement is for number fields and has a slightly sharper invariant $f_C(r) \le 2r$ in place of $2r$.)
- Katz, Rabinoff and Zureick-Brown (2016) proved uniform bounds when $r \le g - 3$, with no good-reduction hypothesis. For a curve over a number field $K$ the bound depends only on $g$ and $[K:\mathbb{Q}]$, so over $\mathbb{Q}$ it depends only on $g$.

### A schematic example in genus 2

Let $C : y^2 = f(x)$ with $f \in \mathbb{Z}[x]$ squarefree of degree 5 or 6, so $g = 2$. A basis of holomorphic differentials is
$$\omega_0 = \frac{dx}{2y}, \qquad \omega_1 = \frac{x\,dx}{2y}.$$
Suppose $r = 1$, and $D \in J(\mathbb{Q})$ has infinite order.

1. **Integrate over the generator.** Compute the Coleman integrals $I_0 = \int_0^D \omega_0$ and $I_1 = \int_0^D \omega_1$ in $\mathbb{Q}_p$. They are not both zero, because $D$ is not torsion, so $\log D \neq 0$.
2. **Find the annihilating differential.** $\omega = I_1\,\omega_0 - I_0\,\omega_1$ lies in $V$, so $\lambda_\omega$ vanishes on $C(\mathbb{Q})$.
3. **Expand on each disc.**
   - Near a non-Weierstrass point $Q = (x_0, y_0)$, take $t = x - x_0$. Expand $y(t) = y_0\sqrt{f(x_0 + t)/f(x_0)}$ as a power series, so $\omega = \big(I_1 - I_0(x_0 + t)\big)\,dt / 2y(t)$, and integrate term by term.
   - Near a Weierstrass point, use $t = y$ as the local parameter instead.
4. **Bound the zeros.** Strassmann or Newton polygons bound the zeros on each disc. If the bound on every disc equals the number of known rational points there, $C(\mathbb{Q})$ is determined. Coleman's bound gives $\#C(\mathbb{Q}) \le \#C(\mathbb{F}_p) + 2$ for any prime $p \ge 5$ of good reduction.

## Dictionary

| | Skolem | Chabauty–Coleman |
|---|---|---|
| Ambient group $G$ | norm-one torus $R^1_{K/\mathbb{Q}}\mathbb{G}_m$ | Jacobian $J$ |
| $\dim G$ | $[K:\mathbb{Q}] - 1$ | $g$ |
| Global group $\Gamma$ | units (Dirichlet) | $J(\mathbb{Q})$ (Mordell–Weil) |
| Rank $r$ | $r_1 + r_2 - 1$ | $\operatorname{rank} J(\mathbb{Q})$ |
| Subvariety $X$ | linear slice of $T$ (e.g. a Thue curve) | the curve $\iota(C)$ |
| $p$-adic logarithm | $\log_p$ on units of $K \otimes \mathbb{Q}_p$ | abelian logarithm, i.e. integrals $\int \omega$ |
| Finiteness condition | $r \le \operatorname{codim}_T X$ | $r \le g - 1$ |
| Natural parametrization | $\overline{\Gamma}$ via $\exp$, method (S) | $C$ by residue discs, method (C) |
| Final step | Strassmann in the exponent variable | Strassmann in the local parameter |
| Degeneration | $f \equiv 0$ on a class (SML progressions) | impossible, since $d\lambda_\omega = \omega \ne 0$ |

## When the rank condition fails

In both settings, a rank $r$ that is too large makes $\overline{\Gamma}$ too big, and the intersection is expected to be positive-dimensional. Extra input is then needed.

- **Skolem's side.** Thue equations over totally real fields are nowadays usually solved with Baker's lower bounds for linear forms in logarithms, followed by lattice reduction (Tzanakis–de Weger, 1989). Historically, Chabauty also handled the totally real case with a refinement of Skolem's $p$-adic method ("Démonstration nouvelle d'un théorème de Thue et Mahler sur les formes binaires", *Bull. Sci. Math.* (2) 65 (1941), 112–130), as Tzanakis and de Weger point out.

- **Changing the ambient group.** The template also explains several variants, each of which improves the dimension count:
  - **Chabauty over number fields.** For $C$ over a number field $K$ of degree $n$, work in the Weil restriction $R_{K/\mathbb{Q}} J$, of dimension $ng$. The image of $R_{K/\mathbb{Q}} C$ there has dimension $n$, so the count becomes $r + n \le ng$, i.e. $r \le n(g-1)$ with $r = \operatorname{rank} J(K)$ (Siksek, 2013). Finiteness is not automatic here, because the degenerate case can occur.
  - **Elliptic Chabauty.** Suppose a cover of $C$ maps to an elliptic curve $E$ over a number field $K$ of degree $n$, with the relevant points having $\mathbb{Q}$-rational image in $\mathbb{P}^1$. Working in $R_{K/\mathbb{Q}}E$ (dimension $n$) with a 1-dimensional $X$ gives the condition $\operatorname{rank} E(K) < n$ (Bruin; Flynn–Wetherell).
  - **Covering collections.** Replace $C$ by a finite collection of étale covers whose Jacobians, or quotients of them, have small rank relative to their dimension.

- **Non-abelian Chabauty (Kim).** The Jacobian is the abelianization of the fundamental group of $C$. Kim replaces $J(\mathbb{Q}_p)$ and its logarithm with unipotent quotients of the $p$-adic étale fundamental group and their **Selmer varieties**; iterated Coleman integrals take the place of $\int \omega$.
  - Kim's first application (2005) was $\mathbb{P}^1 \setminus \{0, 1, \infty\}$, i.e. the $S$-unit equation $x + y = 1$. There the torus template fails: $G = \mathbb{G}_m^2$ has $d = 2$, $\Gamma = (\mathbb{Z}_S^\times)^2$ has rank $2|S|$, and $X$ is a line, so $r + \dim X = 2|S| + 1 > 2$. Equations coming from $p$-adic polylogarithms supply what is missing, and this gave a new proof of Siegel's theorem in that case.

- **Quadratic Chabauty (Balakrishnan–Dogra, 2018).** This is the first non-abelian level, built on $p$-adic heights. It gives finiteness when
  $$r < g + \rho - 1,$$
  where $\rho$ is the rank of the Néron–Severi group of $J$. Since $\rho \ge 1$, this goes beyond classical Chabauty exactly when $\rho \ge 2$. Applications include:
  - integral points on hyperelliptic curves with $r = g$, including rank-1 elliptic curves (Balakrishnan–Besser–Müller);
  - the rational points on the "cursed curve" $X_s(13)$, of genus 3 with Jacobian rank 3 (Balakrishnan–Dogra–Müller–Tuitman–Vonk, *Annals*, 2019).

## Skolemization (logic)

Here "Skolem's method" means removing existential quantifiers by introducing new function symbols, called Skolem functions. For example,
$$\forall x\, \exists y\, P(x,y) \;\;\leadsto\;\; \forall x\, P\big(x, f(x)\big).$$

The new formula is **equisatisfiable** with the original but not logically equivalent. This step is used in the proof of the Löwenheim–Skolem theorem, in resolution theorem proving, and in conversion to clausal normal form.

## Further reading

- Borevich & Shafarevich, *Number Theory* (Academic Press, 1966), Ch. 4, "Local Methods", §6 "Skolem's Method" (pp. 290–301), with the needed facts on local analytic manifolds in §7.
  - §6.2 sets up the method and gives the heuristic condition "$n - m \ge r$": at least as many equations as unit exponents.
  - §6.3, Theorem 2, proves Thue's theorem for irreducible forms of degree $\ge 3$ with at least one non-real root.
  - The remark on p. 300 notes Skolem's extension to $n = 5$, $m = 3$ (*Math. Ann.* 111 (1935), 399–424) and Chabauty's to $m = 3$ (*Ann. Mat. Pura Appl.* 17 (1938)).
  - Problems 2–6 at the end of §6 guide the reader through Skolem's proof that $x^3 + dy^3 = 1$ has at most one nontrivial solution. Problem 8 is Skolem's theorem on zeros of linear recurrence sequences.
- Cassels, *Local Fields* (LMS Student Texts 3, 1986): Strassmann's theorem, and on pp. 223–226 Skolem's proof that $x^3 - dy^3 = 1$ has at most one solution besides $(1, 0)$ (the Delone–Nagell theorem).
- Smart, *The Algorithmic Resolution of Diophantine Equations* (LMS Student Texts 41, 1998): the practical side; pp. 34–35 treat $x^3 - 2y^3 = 1$.
- K. Conrad, "Integral solutions of $x^3 - 2y^3 = 1$" (expository note, freely available): a complete worked example of Skolem's method.
- N. Bruin, "Skolem's method" (lecture notes, BIRS summer school, 2012): the general Thue setup and the interpretation via twisted tori.
- Skolem, "Ein Verfahren zur Behandlung gewisser exponentialer Gleichungen und diophantischer Gleichungen", *8. Skand. Mat.-Kongr.*, Stockholm, 1934, pp. 163–188.
- Skolem, *Diophantische Gleichungen* (Ergebnisse der Mathematik und ihrer Grenzgebiete 5, Springer, 1938).

**Chabauty and its descendants**

- Chabauty, "Sur les points rationnels des courbes algébriques de genre supérieur à l'unité", *C. R. Acad. Sci. Paris* 212 (1941), 882–885.
- Coleman, "Effective Chabauty", *Duke Math. J.* 52 (1985).
- McCallum & Poonen, "The method of Chabauty and Coleman", *Panoramas et Synthèses* 36 (2012): the standard survey, including the proof of Coleman's bound.
- Stoll, "Rational points on curves", *J. Théor. Nombres Bordeaux* 23 (2011): a survey of the computational methods.
- Kim, "The motivic fundamental group of $\mathbb{P}^1 \setminus \{0,1,\infty\}$ and the theorem of Siegel", *Invent. Math.* 161 (2005).
- Balakrishnan & Dogra, "Quadratic Chabauty and rational points I: $p$-adic heights", *Duke Math. J.* 167 (2018).
