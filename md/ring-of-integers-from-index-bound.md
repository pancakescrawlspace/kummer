# Computing $\mathcal{O}_K$ from the bound $\mathcal{O}_K \subseteq N^{-1}\mathbb{Z}[\alpha]$

**Setup.** $K$ is a number field of degree $d$, $\alpha \in K$ is an **algebraic integer** with $K = \mathbb{Q}(\alpha)$, $f \in \mathbb{Z}[x]$ is its minimal polynomial, and

$$R = \mathbb{Z}[\alpha] = \mathbb{Z} \oplus \mathbb{Z}\alpha \oplus \dots \oplus \mathbb{Z}\alpha^{d-1}, \qquad D = \operatorname{disc}(R) = \operatorname{disc}(f).$$

(Integrality of $\alpha$ is essential: otherwise $\mathbb{Z}[\alpha]$ is not finitely generated as a $\mathbb{Z}$-module and is not an order.) Write $\mathcal{O} = \mathcal{O}_K$ and

$$N = \prod_{p} p^{\lfloor v_p(D)/2 \rfloor},$$

so $N^2$ is the largest square dividing $D$.

**The question.** We know $\mathcal{O} \subseteq N^{-1}R$, and $R$ has finite index in $N^{-1}R$. Can we compute $\mathcal{O}$ by checking integrality on the finitely many cosets of $R$ in $N^{-1}R$?

**Answer: yes.** It is a correct algorithm, but exponential as stated. With three refinements (work one prime at a time, one factor of $p$ at a time, and replace coset enumeration by linear algebra over $\mathbb{F}_p$) it becomes the Round 2 algorithm of Pohst and Zassenhaus. The real bottleneck is not the integrality checks but finding $N$, which requires factoring $D$.

---

## 1. Why $\mathcal{O} \subseteq N^{-1}R$

**Lemma.** $\operatorname{disc}(R) = [\mathcal{O} : R]^2 \cdot \operatorname{disc}(\mathcal{O})$.

*Proof.* Choose $\mathbb{Z}$-bases $\omega_1,\dots,\omega_d$ of $\mathcal{O}$ and $1,\alpha,\dots,\alpha^{d-1}$ of $R$, and let $M \in M_d(\mathbb{Z})$ express the latter in terms of the former. Then $|\det M| = [\mathcal{O}:R]$, and the Gram matrix of the trace form transforms as $G_R = M^{\mathsf T} G_{\mathcal{O}} M$. Take determinants. $\square$

Let $n = [\mathcal{O}:R]$. Since $\operatorname{disc}(\mathcal{O}) \in \mathbb{Z}$, the lemma gives $n^2 \mid D$. So $v_p(n) \le \lfloor v_p(D)/2 \rfloor$ for every $p$, i.e. $n \mid N$.

The finite abelian group $\mathcal{O}/R$ has order $n$, so it is killed by $n$: $n\mathcal{O} \subseteq R$. Hence

$$R \subseteq \mathcal{O} \subseteq n^{-1}R \subseteq N^{-1}R.$$

The same argument applied to the $p$-primary part gives the local version:

$$(\mathcal{O}/R)[p^\infty] \text{ is killed by } p^{\lfloor v_p(D)/2 \rfloor}.$$

In particular, only primes with $p^2 \mid D$ can divide the index.

---

## 2. The naive algorithm

$N^{-1}R/R \cong (\mathbb{Z}/N)^d$, so $R$ has index $N^d$ in $N^{-1}R$. Coset representatives are

$$x_c = \frac{c_0 + c_1\alpha + \dots + c_{d-1}\alpha^{d-1}}{N}, \qquad 0 \le c_i < N.$$

**Integrality test.** Let $\chi_x$ be the characteristic polynomial of multiplication by $x$ on $K$ (a $d \times d$ rational matrix in the basis $\alpha^i$). Then $\chi_x$ is a power of the minimal polynomial of $x$. By Gauss's lemma, $x$ is integral $\iff \chi_x \in \mathbb{Z}[t]$.

**Algorithm.**

1. Factor $D$ and compute $N$.
2. For each $c \in \{0,\dots,N-1\}^d$, test whether $x_c$ is integral.
3. The integral cosets form the subgroup $\mathcal{O}/R \subseteq N^{-1}R/R$. Return $\mathcal{O} = R + \sum_{c \text{ integral}} \mathbb{Z}x_c$, and reduce to a $\mathbb{Z}$-basis with a Hermite normal form.

Correctness is immediate from §1. Every element of $\mathcal{O}$ lies in some coset $x_c + R$, and a coset is either entirely integral or entirely not, because $R$ is integral.

### Example: $K = \mathbb{Q}(\sqrt{m})$, $m$ squarefree, $\alpha = \sqrt m$

Here $D = 4m$. So $N = 2$ (both when $m$ is odd and when $v_2(4m) = 3$), and we check the three nonzero cosets

$$\tfrac12, \qquad \tfrac12\sqrt m, \qquad \tfrac12(1+\sqrt m).$$

The first two have characteristic polynomials $(t - \frac12)^2$ and $t^2 - \frac m4$, so they are never integral. The third has characteristic polynomial $t^2 - t + \frac{1-m}{4}$.

- $m \equiv 1 \pmod 4$: $\frac{1+\sqrt m}{2}$ is integral, so $\mathcal{O} = \mathbb{Z}\big[\frac{1+\sqrt m}{2}\big]$.
- $m \equiv 2, 3 \pmod 4$: no nonzero coset is integral, so $\mathcal{O} = \mathbb{Z}[\sqrt m]$.

### Example: $N$ can overshoot $n$

Take $\alpha = \sqrt{12}$, so $D = 48 = 2^4 \cdot 3$ and $N = 4$. The actual index is $n = 2$, with $\mathcal{O} = \mathbb{Z}[\sqrt 3] = \mathbb{Z}[\alpha/2]$. The bound $n \mid N$ is only an upper bound, because $\operatorname{disc}(\mathcal{O})$ may itself contain squares.

---

## 3. Why it is impractical as stated

There are $N^d$ cosets, and $N$ can be as large as $\sqrt{|D|}$, where $|D|$ itself grows like $H(f)^{2d-2}$. Already for $f = x^3 - 19$ we have $D = -3^3 \cdot 19^2$, $N = 57$ and $57^3 = 185{,}193$ cosets, all to find a single new element $\frac{1+\alpha+\alpha^2}{3}$.

The waste has three sources:

- **Mixing primes.** The primes dividing $N$ are handled jointly, although the problem splits over them.
- **Jumping to the maximum exponent.** Going straight to $p^{-\lfloor v_p(D)/2\rfloor}R$ enumerates far more than necessary.
- **Ignoring structure.** The integral cosets form a subgroup, and at each step an $\mathbb{F}_p$-subspace, so they are cut out by linear conditions and need not be found by search.

---

## 4. The refinements

### 4.1 Localize at each prime

$\mathcal{O}/R = \bigoplus_p (\mathcal{O}/R)[p^\infty]$, so

$$\mathcal{O} = \sum_{p^2 \mid D} \mathcal{O}_{(p)}, \qquad \mathcal{O}_{(p)} := \text{the } p\text{-maximal order containing } R \text{ with } p\text{-power index}.$$

Compute each $\mathcal{O}_{(p)}$ separately and add them (HNF of the concatenated bases). The cost now depends on each $p$ separately rather than on $N$.

### 4.2 Go up one factor of $p$ at a time

Let $R' \supseteq R$ be the current order. Instead of searching $p^{-k}R'$, look only at

$$(\mathcal{O} \cap p^{-1}R')/R' \;\subseteq\; p^{-1}R'/R' \cong \mathbb{F}_p^d.$$

This is an $\mathbb{F}_p$-subspace. It is nonzero iff $R'$ is not $p$-maximal: if $(\mathcal{O}/R')[p^\infty] \ne 0$, it contains an element of order $p$. Replace $R'$ by the order generated by $R'$ and this subspace, and repeat. Each step multiplies the index by at least $p$, so it divides the discriminant by at least $p^2$. The loop therefore terminates after at most $\lfloor v_p(D)/2 \rfloor$ steps.

Even with brute-force enumeration inside each step, this replaces one search of size $N^d$ by at most $\sum_p \lfloor v_p(D)/2 \rfloor \cdot p^d$ checks (see the table in §6).

### 4.3 Replace enumeration by linear algebra (Round 2)

The Pohst–Zassenhaus Round 2 algorithm finds the enlargement in §4.2 without enumerating.

- **The $p$-radical** $I_p = \{x \in R' : x^m \in pR' \text{ for some } m\}$. It is the kernel of $x \mapsto x^{p^j}$ on $R'/pR'$ for any $j$ with $p^j \ge d$. Since $R'/pR'$ is an $\mathbb{F}_p$-algebra, that map is additive and fixes $\mathbb{F}_p$, so it is $\mathbb{F}_p$-linear. So $I_p/pR'$ is the kernel of a $d \times d$ matrix over $\mathbb{F}_p$.
- **The ring of multipliers** $R'' = \{x \in K : xI_p \subseteq I_p\}$. Since $p \in I_p$, it satisfies $R' \subseteq R'' \subseteq p^{-1}R'$, and it is computed by solving a linear system.

**Theorem (Pohst–Zassenhaus).** $R'$ is $p$-maximal $\iff R'' = R'$.

So one Round 2 step costs polynomially many operations in $d$ and $\log p$, instead of $p^d$ integrality tests.

### 4.4 Skip primes early: Dedekind's criterion

For the *first* step, starting from $R = \mathbb{Z}[\alpha]$, there is an even cheaper test that needs only polynomial arithmetic over $\mathbb{F}_p$ (see Cohen, *A Course in Computational Algebraic Number Theory*, Thm 6.1.4).

Factor $\bar f = \prod \bar g_i^{e_i}$ in $\mathbb{F}_p[x]$ and choose monic lifts $g_i \in \mathbb{Z}[x]$. Put

$$g = \prod g_i, \qquad h = \prod g_i^{e_i - 1}, \qquad F = \frac{gh - f}{p} \in \mathbb{Z}[x], \qquad \bar T = \gcd(\bar F, \bar g, \bar h).$$

Then:

- $\mathbb{Z}[\alpha]$ is $p$-maximal $\iff \bar T = 1$.
- If $\bar T \ne 1$, let $m = \deg \bar T$ and let $U \in \mathbb{Z}[x]$ be a lift of $\bar f/\bar T$. Then $\mathbb{Z}[\alpha] + \frac{U(\alpha)}{p}\mathbb{Z}[\alpha]$ is an order containing $\mathbb{Z}[\alpha]$ with index $p^m$.

Checks against the examples:

- **$f = x^2 - m$, $p = 2$, $m \equiv 1 \pmod 4$.** Here $\bar f = (x+1)^2$, $F = x + \frac{1+m}{2}$ and $\bar T = x+1$. Then $U = x + 1$, which gives $\frac{1+\sqrt m}{2}$. When $m \equiv 3 \pmod 4$, $\bar F = x$ and $\bar T = 1$.
- **$f = x^3 - 19$, $p = 3$.** Here $\bar f = (x-1)^3$ and $\bar T = x - 1$. Then $U = x^2 + x + 1$, which gives $\frac{1+\alpha+\alpha^2}{3}$. At $p = 19$, $\bar T = 1$, so the $19^3$ cosets there are pure waste.

In practice most primes with $p^2 \mid D$ are dismissed this way. Only the rest go to Round 2 (or to Round 4 / Montes, which refine the local step further via Newton polygons and are what PARI's `nfbasis` and Sage's `maximal_order()` use).

### 4.5 A linear sieve: the trace dual

Every $x \in \mathcal{O}$ satisfies $\operatorname{Tr}_{K/\mathbb{Q}}(xy) \in \mathbb{Z}$ for all $y \in R$. So

$$\mathcal{O} \subseteq R^\# := \{x \in K : \operatorname{Tr}(xR) \subseteq \mathbb{Z}\}, \qquad [R^\# : R] = |D|.$$

For a monogenic order, Euler's lemma gives $R^\# = f'(\alpha)^{-1}\,\mathbb{Z}[\alpha]$ explicitly. Intersecting $N^{-1}R$ with $R^\#$ before any characteristic polynomials are computed is a purely linear cut on the candidates.

---

## 5. The real bottleneck: factoring $D$

Everything above assumes we know the primes $p$ with $p^2 \mid D$, which amounts to knowing the square part of $D$. Buchmann and Lenstra (*Approximating rings of integers in number fields*, J. Théor. Nombres Bordeaux 6 (1994)) show that computing $\mathcal{O}_K$ is polynomial-time equivalent to computing the largest squarefree divisor of $\operatorname{disc}(f)$.

Given the factorization, the refined algorithm runs in polynomial time. Without it, one can still:

- compute an order that is $p$-maximal for every prime found by trial division up to some bound $B$;
- guarantee that its remaining index in $\mathcal{O}$ has no prime factor $\le B$.

That is what PARI does when $D$ cannot be fully factored (`nfbasis` with a partial factorization, then `nfcertify` to list what remains unproven).

---

## 6. Sage check

Both the naive algorithm (§2) and the one-prime-at-a-time, one-step-at-a-time version (§4.1–4.2, still by brute force inside each step) were checked against `K.maximal_order()`:

```python
from itertools import product

def is_integral(x):
    # char poly of multiplication-by-x has integer coefficients
    return all(c in ZZ for c in x.matrix().charpoly().list())

def naive_maximal_order(f):
    K = NumberField(f, 'a'); a = K.gen(); d = f.degree()
    D = f.discriminant()
    N = prod(p^(e//2) for p, e in D.factor())
    basis = [a^i for i in range(d)]
    new = []
    for c in product(range(N), repeat=d):
        if any(c):
            x = sum(ci*bi for ci, bi in zip(c, basis)) / N
            if is_integral(x):
                new.append(x)
    return K.order(basis + new)

def stepwise_maximal_order(f):
    K = NumberField(f, 'a'); a = K.gen(); d = f.degree()
    O = K.order([a^i for i in range(d)])
    for p, e in f.discriminant().factor():
        if e < 2:
            continue
        while True:
            B = O.basis()
            new = []
            for c in product(range(p), repeat=d):
                if any(c):
                    x = sum(ci*bi for ci, bi in zip(c, B)) / p
                    if is_integral(x):
                        new.append(x)
            if not new:
                break
            O = K.order(list(B) + new)
    return O
```

| $f$ | $D$ | $N$ | naive cosets $N^d$ | stepwise checks | $[\mathcal{O}:\mathbb{Z}[\alpha]]$ | Dedekind $\bar T$ |
|---|---|---|---|---|---|---|
| $x^2-5$ | $2^2\cdot5$ | 2 | 4 | 6 | 2 | $p=2$: $x+1$ |
| $x^2-3$ | $2^2\cdot3$ | 2 | 4 | 3 | 1 | $p=2$: $1$ |
| $x^2-12$ | $2^4\cdot3$ | 4 | 16 | 6 | 2 | $p=2$: $x$ |
| $x^2-45$ | $2^2\cdot3^2\cdot5$ | 6 | 36 | 22 | 6 | $p=2$: $x+1$; $p=3$: $x$ |
| $x^3-2$ | $-2^2\cdot3^3$ | 6 | 216 | 33 | 1 | $p=2,3$: $1$ |
| $x^3-x^2-2x-8$ | $-2^2\cdot503$ | 2 | 8 | 14 | 2 | $p=2$: $x$ |
| $x^3-19$ | $-3^3\cdot19^2$ | 57 | 185,193 | 6,910 | 3 | $p=3$: $x+2$; $p=19$: $1$ |
| $x^4+1$ | $2^8$ | 16 | 65,536 | 15 | 1 | $p=2$: $1$ |

In every case both methods return exactly `K.maximal_order()`, and $\bar T \ne 1$ precisely for the primes dividing the index.

- **Stepwise checks.** Each non-final step costs $p^d - 1$ checks, and one more round of $p^d - 1$ confirms $p$-maximality. That is why $x^2-5$ needs 6 checks against 4 naive cosets. The overhead is irrelevant for small $N$ and decisive for large $N$.
- **$x^3-19$.** Nearly all of its 6,910 stepwise checks are the $19^3 - 1 = 6858$ checks spent confirming 19-maximality. Dedekind's criterion settles that at once.
- **$x^3 - x^2 - 2x - 8$.** This is Dedekind's example of a field with no power integral basis at all. The algorithm doesn't care: it only needs *some* order $R$ with known discriminant to start from.
