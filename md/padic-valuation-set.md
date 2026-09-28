# Which valuations does a polynomial over $\mathbb{Z}_p$ attain?

**Notation.** $p$ is prime, $v$ is the $p$-adic valuation normalized by $v(p) = 1$, with $v(0) = \infty$. For $f \in \mathbb{Z}_p[x]$ write

$$V(f) := \{\, v(f(x)) : x \in \mathbb{Z}_p \,\} \subseteq \mathbb{Z}_{\ge 0} \cup \{\infty\}.$$

**The question.** If $n \ge 1$ and $n \in V(f)$, must $V(f)$ contain every integer $m > n$?

**Answer: no.** But there is a clean sufficient condition under which it does hold, and a complete description of $V(f)$ in general.

---

## 1. Counterexamples

### (a) Sparse: $f(x) = x^2$

$v(f(x)) = 2v(x)$, so

$$V(f) = \{0, 2, 4, 6, \dots\} \cup \{\infty\}.$$

Take $n = 2$, attained at $x_0 = p$. Then $3 \notin V(f)$. This works for every prime $p$, and $f$ is monic, primitive and nonconstant, so none of the obvious side conditions rescue the statement.

### (b) Bounded: $f(x) = x^2 + p$

- If $v(x) = 0$ then $v(x^2) = 0$ and $v(p) = 1$, so $v(f(x)) = 0$.
- If $v(x) \ge 1$, write $x = pu$ with $u \in \mathbb{Z}_p$: then $f(x) = p(1 + pu^2)$ and $v(f(x)) = 1$ exactly.

So $V(f) = \{0, 1\}$. Here $n = 1$ is attained and *nothing* above it ever is. (Consistently, $f$ is Eisenstein, hence has no root in $\mathbb{Z}_p$.)

### (c) A gap in the middle: $f(x) = x^2 + p^3$

- $v(x) = 0 \Rightarrow v(f(x)) = 0$.
- $v(x) = 1$, $x = pu$ with $u$ a unit: $f(x) = p^2(u^2 + p)$, so $v(f(x)) = 2$.
- $v(x) \ge 2 \Rightarrow v(x^2) \ge 4 > 3$, so $v(f(x)) = 3$.

Thus $V(f) = \{0, 2, 3\}$: the value $1$ is skipped even though larger values occur.

### (d) Degenerate: constants

$f = p^n$ gives $V(f) = \{n\}$. Worth stating only to note that the intended hypothesis is presumably $f$ nonconstant — but (a)–(c) show that adding that hypothesis does not save the claim.

---

## 2. When the claim *is* true (why a random search finds no counterexample)

**Theorem (Hensel–Newton).** Let $f \in \mathbb{Z}_p[x]$, $x_0 \in \mathbb{Z}_p$, and set $n = v(f(x_0))$, $k = v(f'(x_0))$. If

$$n > 2k,$$

then:

1. $f$ has a unique root $a \in \mathbb{Z}_p$ with $v(a - x_0) = n - k \ \ (\ge k+1)$;
2. $a$ is a simple root and $v(f'(a)) = k$;
3. every integer $m > 2k$ lies in $V(f)$ — in particular every integer $m \ge n$ does.

*Proof.* (1) is Hensel's lemma in its strong (Newton-iteration) form: the iteration $x_{j+1} = x_j - f(x_j)/f'(x_j)$ converges, and the first step already moves by $v(f(x_0)/f'(x_0)) = n-k$, with all later steps moving strictly further.

(2) Since $f'(a) - f'(x_0) \in (a - x_0)\mathbb{Z}_p$ we get $v(f'(a) - f'(x_0)) \ge n - k \ge k + 1 > k = v(f'(x_0))$, hence $v(f'(a)) = k$ by the ultrametric equality case. In particular $f'(a) \ne 0$, so $a$ is simple.

(3) Taylor-expand at $a$ (all coefficients lie in $\mathbb{Z}_p$, since $a \in \mathbb{Z}_p$):

$$f(a + t) = f'(a)\,t + \sum_{j \ge 2} c_j t^j, \qquad c_j \in \mathbb{Z}_p.$$

If $v(t) > k$ then $v(c_j t^j) \ge 2v(t) > k + v(t) = v(f'(a)t)$ for all $j \ge 2$, so

$$v(f(a+t)) = k + v(t).$$

Letting $v(t)$ run over all integers $> k$ gives every integer $> 2k$. Since $n > 2k$, all $m \ge n$ are included. $\blacksquare$

**Corollary.** If $f'(x_0)$ is a unit (i.e. $k = 0$) and $n = v(f(x_0)) \ge 1$, then $V(f) \supseteq \mathbb{Z}_{\ge 1}$.

This is the reason an experimental search turns up nothing: for a "random" $f$ and a random $x_0$ with $v(f(x_0)) \ge 1$, the derivative $f'(x_0)$ is almost always a unit, and then the conclusion genuinely holds. A counterexample must be degenerate at $x_0$, i.e. satisfy $n \le 2\,v(f'(x_0))$ for **every** $x_0$ realizing that valuation. Check the examples above:

- (a) $f' = 2x$; at $x_0 = p$, $k = v(2p) \ge 1$, and $n = 2 \le 2k$.
- (b) $f' = 2x$; at $x_0 = pu$, $k \ge 1$, and $n = 1 \le 2k$.

---

## 3. The complete structure of $V(f)$

**Theorem.** Let $f \in \mathbb{Z}_p[x]$, $f \ne 0$. Let $a_1, \dots, a_r$ be the distinct roots of $f$ in $\mathbb{Z}_p$, with multiplicities $m_i$, and write $f(x) = (x - a_i)^{m_i} g_i(x)$ with $g_i(a_i) \ne 0$; put $c_i = v(g_i(a_i))$. Then there is an $N \ge 0$ and a finite set $S \subset \mathbb{Z}_{\ge 0}$ with

$$V(f) \;=\; S \;\cup\; \bigcup_{i=1}^{r} \{\, m_i s + c_i \;:\; s \ge N \,\} \;\cup\; \{\infty \text{ if } r \ge 1\}.$$

*Proof sketch.* Choose $N$ large enough that the balls $B_i = a_i + p^N\mathbb{Z}_p$ are pairwise disjoint and that $v(g_i(a_i + t)) = c_i$ for all $v(t) \ge N$ (possible since $g_i$ is continuous and $g_i(a_i) \ne 0$). For $t$ with $v(t) \ge N$,

$$v(f(a_i + t)) = m_i v(t) + c_i,$$

which gives the $i$-th progression. The complement $K = \mathbb{Z}_p \setminus \bigcup_i B_i$ is compact and contains no zero of $f$, so $x \mapsto |f(x)|_p$ attains a positive minimum on $K$; hence $v(f)$ is bounded on $K$ and contributes only the finite set $S$. $\blacksquare$

**Consequences.**

- $V(f)$ is **unbounded** $\iff$ $f$ has a root in $\mathbb{Z}_p$. ($\Leftarrow$ is clear. $\Rightarrow$: if $v(f(x_j)) \to \infty$, compactness of $\mathbb{Z}_p$ gives a convergent subsequence $x_j \to a$, and continuity forces $f(a) = 0$.) Equivalently, if $f$ has no root in $\mathbb{Z}_p$ then $V(f)$ is **finite** — which is exactly what happens in example (b).
- $V(f)$ contains all sufficiently large integers $\iff$ the progressions $\{m_i s + c_i\}$ cover a cofinite set of integers.
- A **simple root** ($m_i = 1$) is sufficient for that, but not necessary. Example with $p = 3$:
  $$f(x) = x^2 (x-1)^2 (x^2 + x + 1).$$
  The factor $x^2+x+1$ has no root in $\mathbb{Z}_3$ (it is $\equiv (x-1)^2 \bmod 3$, and for $x = 1 + 3s$ its value is $3(1 + 3s + 3s^2)$, of valuation exactly $1$, never $0 \bmod 9$). Near $0$: $v(f(t)) = 2v(t)$, giving all even values $\ge 2$. Near $1$: $f(1+t) = (1+t)^2 t^2 (t^2 + 3t + 3)$ and $v(t^2+3t+3) = 1$ for $v(t) \ge 1$, so $v(f(1+t)) = 2v(t) + 1$, giving all odd values $\ge 3$. Together: every integer $\ge 2$, with both roots of multiplicity $2$.
- Gaps in $V(f)$ are therefore a ramification phenomenon — they come from multiplicities, i.e. from slopes of the Newton polygon of $f(a + t)$ — not from arithmetic accidents.

**Remark.** Everything above except the compactness argument (finiteness of $V(f)$ when $f$ has no root) works over an arbitrary complete discrete valuation ring. The compactness step needs the residue field to be finite, which is why it is stated for $\mathbb{Z}_p$.
