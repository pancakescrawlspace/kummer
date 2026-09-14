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

You need **at least as many equations as unknown exponents**. In general there are $r$ exponents, one per fundamental unit, and some number of coefficient conditions. Having at least $r$ conditions is **necessary** for the method to prove finiteness, but it is **not sufficient**: the equations can be degenerate. The next section explains this, and gives a complete proof via Weierstrass preparation in the one-variable case.

- For a cubic field with negative discriminant, $r = 1$ and there is one condition, so the method works.
- For a totally real cubic field, $r = 2$ and there is still only one condition, so the basic method fails without extra tricks.

More generally, for a Thue equation of degree $n \ge 3$ you get $n - 2$ conditions and $r = r_1 + r_2 - 1$ exponents. Since $r_1 + 2r_2 = n$, the inequality $r \le n - 2$ holds exactly when $r_2 \ge 1$, i.e. when $f(x, 1)$ has at least one non-real root. So the basic method fails only when the field is totally real.

This "number of conditions versus rank" count is made precise in the section "Skolem and Chabauty" below.

## Finiteness via Weierstrass preparation

This section does four things:
1. It shows that counting conditions alone does not give finiteness.
2. It proves the Weierstrass preparation theorem for power series converging on $\mathbb{Z}_p$.
3. It uses that theorem to give a complete proof that $x^3 - dy^3 = 1$ has only finitely many integer solutions.
4. It explains what survives in several variables.

### Counting conditions is not enough

Let $K = \mathbb{Q}(\sqrt{2}, i)$, of degree $n = 4$. It is totally complex, so its unit rank is $r = 1$. Consider
$$N_{K/\mathbb{Q}}\big(x + y\sqrt{2}\big) = 1, \qquad x, y \in \mathbb{Z}.$$
The module $M = \mathbb{Z} + \mathbb{Z}\sqrt{2}$ has rank $m = 2$. Writing $x + y\sqrt{2}$ in a basis of $K$ imposes $n - m = 2$ linear conditions: the coefficients of $i$ and $i\sqrt{2}$ vanish. So there are $2 \ge r = 1$ conditions.

Nevertheless there are infinitely many solutions. For $\alpha \in \mathbb{Q}(\sqrt{2})$, $N_{K/\mathbb{Q}}(\alpha) = N_{\mathbb{Q}(\sqrt{2})/\mathbb{Q}}(\alpha)^2$, so the equation says $x^2 - 2y^2 = \pm 1$. Every power $(1 + \sqrt{2})^k$ is a solution.

In Skolem's setup, the powers of the unit $1 + \sqrt{2}$ lie in $M$. On the corresponding residue class, both analytic coefficient functions vanish **identically**, so no zero-counting argument can work.

The cause is the intermediate field $\mathbb{Q}(\sqrt{2})$, which has infinitely many units. Borevich–Shafarevich (Ch. 4, §6.4) call such modules *degenerate*. That norm form equations for non-degenerate modules always have finitely many solutions was proved only by Schmidt (1972), using his subspace theorem rather than $p$-adic analysis.

So any finiteness proof must show that the analytic functions are **not identically zero**. For cubic fields this is easy, because a field of prime degree has no intermediate subfields.

### The ring of power series converging on $\mathbb{Z}_p$

Let
$$A = \mathbb{Z}_p\langle t \rangle = \Big\{ \textstyle\sum_{k \ge 0} a_k t^k : a_k \in \mathbb{Z}_p,\ a_k \to 0 \Big\}.$$
Each such series converges at every $a \in \mathbb{Z}_p$. Sums and products of elements of $A$ stay in $A$. Evaluation $f \mapsto f(a)$ is a ring homomorphism $A \to \mathbb{Z}_p$: in the non-archimedean setting, absolutely convergent series can be multiplied and rearranged freely.

The **Gauss norm** is $\|f\| = \max_k |a_k|_p$. It is multiplicative, and $A$ is complete for it. Write $\bar{f} \in \mathbb{F}_p[t]$ for the reduction of $f$ modulo $p$. It is a polynomial, because $a_k \to 0$.

### Weierstrass division and preparation

Throughout, let $f = \sum a_k t^k \in A$ with $\bar{f} \neq 0$, and let
$$N = \deg \bar{f} = \max\{k : a_k \in \mathbb{Z}_p^\times\}.$$

**Lemma (division).** For every $g \in A$ there are $q \in A$ and $r \in \mathbb{Z}_p[t]$ with $\deg r < N$ such that $g = qf + r$.

*Proof.*
1. **Split $f$.** Let $f_0 = \sum_{k \le N} a_k t^k$, a polynomial of degree $N$ whose leading coefficient $a_N$ is a unit. Every $a_k$ with $k > N$ lies in $p\mathbb{Z}_p$, so $f = f_0 + p f_1$ with $f_1 \in A$ and $\|f_1\| \le 1$.
2. **Divide by $f_0$.** For a polynomial $g \in \mathbb{Z}_p[t]$, long division by $f_0$ gives $g = Q(g) f_0 + R(g)$ with $Q(g), R(g) \in \mathbb{Z}_p[t]$ and $\deg R(g) < N$. No denominators appear, because $a_N$ is a unit. Scaling shows $\|Q(g)\|, \|R(g)\| \le \|g\|$. The maps $Q$ and $R$ are $\mathbb{Z}_p$-linear, so they extend by continuity from polynomials (which are dense) to all of $A$, keeping the same bounds and the identity $g = Q(g) f_0 + R(g)$.
3. **Correct for $f_1$ by iterating.** Put $g_0 = g$ and $g_{i+1} = -p\,Q(g_i)\, f_1$. Then
   $$g_i = Q(g_i) f_0 + R(g_i) = Q(g_i)\, f + R(g_i) + g_{i+1},$$
   and $\|g_{i+1}\| \le p^{-1}\|g_i\|$, so $\|g_i\| \le p^{-i}\|g\|$. Summing,
   $$g = \Big(\sum_{i \ge 0} Q(g_i)\Big) f + \sum_{i \ge 0} R(g_i).$$
   Both series converge, because $A$ is complete and polynomials of degree $< N$ form a closed subspace. $\square$

**Theorem (Weierstrass preparation).** There is a unit $u \in A^\times$ and a monic polynomial $P \in \mathbb{Z}_p[t]$ of degree $N$ with
$$f = u \cdot P .$$

*Proof.*
1. **Divide $t^N$ by $f$.** The lemma gives $t^N = qf + r$ with $\deg r < N$. Put $P = t^N - r$, which is monic of degree $N$, so $P = qf$.
2. **Reduce mod $p$.** We get $\bar{q}\,\bar{f} = t^N - \bar{r}$. The right side has degree exactly $N$, and $\deg \bar{f} = N$. Hence $\bar{q}$ is a nonzero constant.
3. **$q$ is a unit.** Step 2 means $q = w + ph$ with $w \in \mathbb{Z}_p^\times$ and $h \in A$. Then $q = w\,(1 + p w^{-1} h)$, and $1 + p w^{-1} h$ is invertible in $A$ via the convergent geometric series $\sum_j (-p w^{-1} h)^j$.
4. **Conclude.** Take $u = q^{-1}$; then $f = uP$. $\square$

**Corollary (Strassmann's theorem).** Let $0 \neq f = \sum a_k t^k \in A$, and let $N$ be the largest index with $|a_N|_p = \max_k |a_k|_p$. Then $f$ has at most $N$ zeros in $\mathbb{Z}_p$.

*Proof.*
1. **Normalize.** The maximum of $|a_k|_p$ is attained, since $a_k \to 0$. Write $f = p^\mu f'$ with $\bar{f'} \neq 0$. Then $\deg \bar{f'} = N$.
2. **Factor.** By preparation, $f' = uP$ with $\deg P = N$.
3. **Count zeros.** For $a \in \mathbb{Z}_p$, $u(a)\,u^{-1}(a) = 1$, so $u(a) \neq 0$. Hence the zeros of $f$ in $\mathbb{Z}_p$ are exactly the roots of $P$ in $\mathbb{Z}_p$, and there are at most $N$ of them. $\square$

### Full proof: $x^3 - dy^3 = 1$ has finitely many integer solutions

> **Theorem.** Let $d \in \mathbb{Z}$ not be a cube. Then $x^3 - dy^3 = 1$ has only finitely many solutions $(x, y) \in \mathbb{Z}^2$.

*Proof.*

**Step 1: reduce to units.**
- Let $\theta = \sqrt[3]{d}$ (real), $K = \mathbb{Q}(\theta)$, and $R = \mathbb{Z}[\theta]$. Since $X^3 - d$ is irreducible, $[K:\mathbb{Q}] = 3$.
- $K$ has one real and one pair of complex embeddings. By Dirichlet's unit theorem, which holds for any order, $R^\times = \{\pm 1\} \times \langle \eta_0 \rangle$ with $\eta_0$ of infinite order.
- $N(-1) = -1$, so exactly one of $\pm\eta_0$ has norm $1$; call it $\eta$. The units of norm $1$ are then exactly the powers $\eta^n$, $n \in \mathbb{Z}$.
- A solution $(x, y)$ gives $N(x - y\theta) = x^3 - dy^3 = 1$, so $x - y\theta = \eta^n$ for a unique $n$. Distinct solutions give distinct $n$.
- Writing $\eta^n = A(n) + B(n)\,\theta + C(n)\,\theta^2$ with $A(n), B(n), C(n) \in \mathbb{Z}$, it therefore suffices to show that **$C(n) = 0$ for only finitely many $n \in \mathbb{Z}$**.

**Step 2: choose a prime and residue classes.**
- Fix an odd prime $p$. The image of $\eta$ in the finite ring $R/pR$ is a unit, so there is $m \ge 1$ with $\eta^m \equiv 1 \pmod{pR}$.
- Put $\beta = \eta^m = 1 + p\alpha$ with $\alpha \in R$.
- Every $n$ can be written as $n = n_0 + mt$ with $0 \le n_0 < m$ and $t \in \mathbb{Z}$. Fix $n_0$ and put $\gamma = \eta^{n_0} \in R$.

**Step 3: interpolate $t \mapsto \gamma\beta^t$ by power series.** For $t \in \mathbb{Z}_{\ge 0}$ the binomial theorem gives
$$\gamma\,\beta^t = \sum_{j \ge 0} \binom{t}{j} p^j\, \gamma\alpha^j, \qquad \binom{t}{j} = \frac{1}{j!}\sum_{k=0}^{j} s(j,k)\, t^k,$$
where the $s(j,k) \in \mathbb{Z}$ are Stirling numbers of the first kind.

- **Bound the coefficients.** By Legendre's formula, $v_p(j!) \le (j-1)/(p-1)$. Hence
  $$v_p\!\left(\frac{p^j}{j!}\right) \ge \frac{j(p-2) + 1}{p-1},$$
  which tends to $\infty$ because $p \ge 3$.
- **Rearrange.** The double series $\sum_{j,k} \frac{p^j s(j,k)}{j!}\, \gamma\alpha^j\, t^k$ can therefore be rearranged by powers of $t$. Taking coordinates in the $\mathbb{Z}_p$-basis $1, \theta, \theta^2$ of $R \otimes \mathbb{Z}_p$ gives three series $\mathcal{A}, \mathcal{B}, \mathcal{C} \in \mathbb{Q}_p[[t]]$.
- **They lie in $A$.** The coefficient of $t^k$ collects only terms with $j \ge k$, so its valuation is at least $k(p-2)/(p-1) \to \infty$, and all coefficients are in $\mathbb{Z}_p$. Hence $\mathcal{A}, \mathcal{B}, \mathcal{C} \in A = \mathbb{Z}_p\langle t\rangle$.
- **They interpolate.** By construction $\mathcal{C}(t) = C(n_0 + mt)$ for all $t \in \mathbb{Z}_{\ge 0}$. This extends to all $t \in \mathbb{Z}$ by continuity. The right side is continuous for the $p$-adic topology on $\mathbb{Z}$, because $\beta^{p^k} \equiv 1 \pmod{p^{k+1}R}$. The left side is continuous on $\mathbb{Z}_p$. And $\mathbb{Z}_{\ge 0}$ is $p$-adically dense in $\mathbb{Z}$.

**Step 4: $\mathcal{C}$ is not identically zero.** Suppose $\mathcal{C} = 0$.
- Then $C(n_0 + mt) = 0$ for all $t \ge 0$, so $\gamma\beta^t \in L := \mathbb{Q} + \mathbb{Q}\theta$ for all $t \ge 0$.
- $L$ is a $\mathbb{Q}$-subspace, so it contains the $\mathbb{Q}$-span of these elements, which is $\gamma\,\mathbb{Q}[\beta]$.
- Now $\beta = \eta^m$ has infinite order, so $\beta \neq \pm 1$, and $\beta \notin \mathbb{Q}$ because the only rational units are $\pm 1$. Since $[K:\mathbb{Q}] = 3$ is prime, $\mathbb{Q}[\beta] = \mathbb{Q}(\beta) = K$.
- Therefore $\gamma K = K \subseteq L$, which is impossible because $\dim_{\mathbb{Q}} K = 3 > 2 = \dim_{\mathbb{Q}} L$.

This is exactly where degeneracy is ruled out: a field of prime degree has no intermediate subfield like the $\mathbb{Q}(\sqrt{2})$ in the counterexample.

**Step 5: conclude with Weierstrass preparation.**
- By Step 4, $0 \neq \mathcal{C} \in A$. By the corollary, $\mathcal{C}$ has at most $N_{n_0}$ zeros in $\mathbb{Z}_p$, hence at most $N_{n_0}$ zeros $t \in \mathbb{Z}$.
- So each residue class $n \equiv n_0 \pmod m$ contains at most $N_{n_0}$ values of $n$ with $C(n) = 0$.
- There are $m$ classes, so there are at most $\sum_{n_0} N_{n_0}$ such $n$, and at most that many solutions. $\blacksquare$

**Remarks.**
- The proof works for any odd prime $p$. Choosing $p$ well only affects how small the bound $\sum N_{n_0}$ is.
- The same argument works for any irreducible binary cubic form $F$ with negative discriminant and any $c \neq 0$ in $F(x,y) = c$. One replaces $\gamma = \eta^{n_0}$ by $\gamma_i\,\eta^{n_0}$, where the $\gamma_i$ are the finitely many elements of norm $c$ up to units. Step 4 is unchanged.
- **Worked check** ($d = 2$, $p = 5$, computed in PARI/GP):
  - Here $\eta = \theta - 1$ has norm $1$, and $\eta^8 \equiv 1 \pmod 5$, so $m = 8$ works.
  - For $n_0 = 0$ and $n_0 = 1$, the coefficients $c_k$ of $\mathcal{C}$ have valuations $(\infty, 1, \ge 2, \dots)$. The minimum is attained only at $k = 1$, so $N_{n_0} = 1$. The known zero $t = 0$ gives the solutions $(1, 0)$ and $(-1, -1)$ respectively.
  - For the other six classes, $c_0$ is a unit and all other $c_k$ lie in $p\mathbb{Z}_p$, so $N_{n_0} = 0$.
  - Hence $(1, 0)$ and $(-1, -1)$ are the only solutions.

### Several variables: what is true

With unit rank $r \ge 2$, Step 3 produces restricted power series $F_1, \dots, F_s$ in $r$ variables, lying in $\mathbb{Z}_p\langle t_1, \dots, t_r\rangle$. One wants their common zeros in $\mathbb{Z}_p^r$ to be finite. There is a clean sufficient criterion.

> **Proposition.** Let $I$ be the ideal generated by $F_1, \dots, F_s$ in $\mathbb{Q}_p\langle t_1, \dots, t_r\rangle = \mathbb{Z}_p\langle t_1, \dots, t_r\rangle \otimes \mathbb{Q}_p$. If $D = \dim_{\mathbb{Q}_p} \mathbb{Q}_p\langle t\rangle / I$ is finite, then the $F_i$ have at most $D^r$ common zeros in $\mathbb{Z}_p^r$.

*Proof.*
1. **A polynomial in each variable.** Fix $i$. The images of $1, t_i, \dots, t_i^D$ in the $D$-dimensional quotient are linearly dependent. So some nonzero polynomial $g_i \in \mathbb{Q}_p[X]$ of degree $\le D$ has $g_i(t_i) \in I$.
2. **Evaluate at a common zero.** For $a \in \mathbb{Z}_p^r$, evaluation at $a$ is a ring homomorphism $\mathbb{Q}_p\langle t\rangle \to \mathbb{Q}_p$. If $a$ is a common zero of the $F_i$, it kills all of $I$, so $g_i(a_i) = 0$ for every $i$.
3. **Count.** Each coordinate $a_i$ is one of at most $D$ roots of $g_i$. $\square$

For $r = 1$, Weierstrass preparation shows that every nonzero $f$ generates an ideal of finite codimension: $\mathbb{Q}_p\langle t\rangle/(f) = \mathbb{Q}_p\langle t\rangle/(P)$ has dimension $\deg P$. So the proposition recovers the one-variable argument above.

For $r \ge 2$, Weierstrass preparation in several variables gives more structure. It applies to series that are "distinguished" in $t_r$, which a linear change of variables always arranges. The consequences are that $\mathbb{Q}_p\langle t_1, \dots, t_r\rangle$ is Noetherian, satisfies Noether normalization, and has Krull dimension $r$; see Bosch–Güntzer–Remmert, *Non-Archimedean Analysis*, §5.2. Dimension theory then gives
$$\dim \mathbb{Q}_p\langle t\rangle / (F_1, \dots, F_s) \;\ge\; r - s .$$

So $s \ge r$ equations are **necessary** for the quotient to have dimension $0$, which is exactly Skolem's counting condition. They are not **sufficient**: each equation must actually cut the dimension down, and the counterexample above shows this can fail.

Proving non-degeneracy for the specific exponential sums that come from norm forms is the real work. For $r = 1$ and a field of prime degree it is Step 4 above. Borevich–Shafarevich (§6.2–6.3 with §7) treat Thue equations of any degree with a non-real root. Their route: if there are infinitely many solutions, then the $p$-adic analytic set contains an analytic curve (§6, Theorem 1). An algebraic argument (§6.3, Lemma 2) then shows that no such curve exists.

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

- Bosch, Güntzer & Remmert, *Non-Archimedean Analysis* (Grundlehren 261, Springer, 1984), §5.2: Weierstrass division and preparation for restricted power series in several variables, Noetherianity and Noether normalization.
- Schmidt, "Norm form equations", *Ann. of Math.* (2) 96 (1972), 526–551: finiteness for non-degenerate norm form equations via the subspace theorem.

**Chabauty and its descendants**

- Chabauty, "Sur les points rationnels des courbes algébriques de genre supérieur à l'unité", *C. R. Acad. Sci. Paris* 212 (1941), 882–885.
- Coleman, "Effective Chabauty", *Duke Math. J.* 52 (1985).
- McCallum & Poonen, "The method of Chabauty and Coleman", *Panoramas et Synthèses* 36 (2012): the standard survey, including the proof of Coleman's bound.
- Stoll, "Rational points on curves", *J. Théor. Nombres Bordeaux* 23 (2011): a survey of the computational methods.
- Kim, "The motivic fundamental group of $\mathbb{P}^1 \setminus \{0,1,\infty\}$ and the theorem of Siegel", *Invent. Math.* 161 (2005).
- Balakrishnan & Dogra, "Quadratic Chabauty and rational points I: $p$-adic heights", *Duke Math. J.* 167 (2018).
