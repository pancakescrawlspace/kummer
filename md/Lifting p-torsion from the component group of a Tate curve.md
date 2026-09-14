# Lifting $p$-torsion from the component group of a Tate curve

*Notes from a conversation with Claude, 14 September 2026. The criterion below was proved using Tate uniformization and checked numerically in PARI/GP 2.18.1 (script in the appendix).*

**Question.** Let $E/\mathbb{Q}_p$ have split multiplicative reduction with $\operatorname{ord}_p(j) = -kp$. Is the component group of the Néron model cyclic of order $kp$? It then has an element $\bar P$ of order $p$. Does $\bar P$ always lift to a point of order $p$ in $E(\mathbb{Q}_p)$? If not, is the existence of such a lift a congruence condition on the coefficients of $E$?

**Answer.**
- The component group is cyclic of order $kp$.
- $\bar P$ does not always lift. It lifts to a point of order $p$ **if and only if $j \in (\mathbb{Q}_p^\times)^p$**.
- This is a congruence condition. For $p$ odd it reads $\big(p^{kp} j\big)^{p-1} \equiv 1 \pmod{p^2}$, and for $p = 2$ it reads $4^k j \equiv 1 \pmod 8$.
- On a minimal model it is a congruence on $a_1, \dots, a_6$ modulo $p^{kp+2}$ (modulo $2^{2k+3}$ when $p = 2$).
- The assumption $k = 1$ is not needed.

## 1. The component group

Split multiplicative reduction with $v(j) = -kp$ means Kodaira type $\mathrm{I}_n$, where
$$n = v(\Delta_{\min}) = -v(j) = kp .$$
Because the reduction is split, every component of the special fibre is defined over $\mathbb{F}_p$. Hence
$$\Phi(\mathbb{F}_p) \cong \mathbb{Z}/kp, \qquad E(\mathbb{Q}_p)/E_0(\mathbb{Q}_p) \cong \mathbb{Z}/kp,$$
and the Tamagawa number is $c_p = kp$. The elements of order $p$ in $\mathbb{Z}/kp$ are the classes $ka$ with $p \nmid a$.

## 2. Tate uniformization: a lift exists iff $q$ is a $p$-th power

By Tate, there is a unique $q \in p\mathbb{Z}_p$ with $v(q) = -v(j) = kp$ and
$$E(\mathbb{Q}_p) \cong \mathbb{Q}_p^\times / q^{\mathbb{Z}} .$$
Under this isomorphism, the map to the component group is
$$\mathbb{Q}_p^\times / q^{\mathbb{Z}} \longrightarrow \mathbb{Z}/kp, \qquad u \longmapsto v(u) \bmod kp,$$
and the identity component $E_0(\mathbb{Q}_p)$ corresponds to $\mathbb{Z}_p^\times$.

> **Proposition 1.** Let $\bar P \in \Phi(\mathbb{F}_p)$ have order $p$. Then $\bar P$ lifts to a point of order $p$ in $E(\mathbb{Q}_p)$ if and only if $q \in (\mathbb{Q}_p^\times)^p$.

*Proof.*
- **If $q = w^p$.** The class of $w$ has order exactly $p$ in $\mathbb{Q}_p^\times/q^{\mathbb{Z}}$, and $v(w) = k$. So the powers $w^a$ are points of order $p$ mapping to the classes $ka$, which are all the elements of order $p$ in $\Phi(\mathbb{F}_p)$.
- **Conversely**, let $u \in \mathbb{Q}_p^\times$ represent a lift of order $p$. Then $u^p = q^a$ for some $a \in \mathbb{Z}$.
  1. Taking valuations, $p \cdot v(u) = a \cdot kp$, so $v(u) = ak$.
  2. The image $ak \bmod kp$ has order $p$, so $p \nmid a$.
  3. Choose $b, c \in \mathbb{Z}$ with $ab = 1 + pc$. Then
     $$q = q^{ab}\, q^{-pc} = (u^p)^b\, q^{-pc} = \big(u^b q^{-c}\big)^p. \qquad \square$$

**The obstruction, intrinsically.** Let $u$ be any lift of $\bar P$ with $v(u) = k$. Then $u^p / q \in \mathbb{Z}_p^\times = E_0(\mathbb{Q}_p)$. Replacing $u$ by another lift $u\varepsilon$ with $\varepsilon \in \mathbb{Z}_p^\times$ changes this element by $\varepsilon^p$. So the class
$$\operatorname{ob}(\bar P) = [\,u^p / q\,] \in \mathbb{Z}_p^\times / (\mathbb{Z}_p^\times)^p$$
is well defined, and $\bar P$ has a lift of order $p$ iff $\operatorname{ob}(\bar P) = 1$. For $p$ odd the obstruction group is
$$\mathbb{Z}_p^\times / (\mathbb{Z}_p^\times)^p \cong (1 + p\mathbb{Z}_p)/(1 + p^2\mathbb{Z}_p) \cong \mathbb{Z}/p ,$$
which is why the final condition lives modulo $p^2$.

**Remarks.**
- For $p$ odd, $E_0(\mathbb{Q}_p) \cong \mathbb{Z}_p^\times$ has no $p$-torsion. So $E(\mathbb{Q}_p)$ has a point of order $p$ at all iff $\bar P$ lifts, and in that case $E(\mathbb{Q}_p)[p] \cong \mathbb{Z}/p$.
- For $p = 2$, the point $-1 \in \mathbb{Z}_2^\times$ is always a 2-torsion point on the identity component. So "$E(\mathbb{Q}_2)$ has a point of order 2" is always true, while "$\bar P$ lifts" is not. When $\bar P$ lifts, $E(\mathbb{Q}_2)[2] = \{1, -1, w, -w\}$ is the full 2-torsion.

## 3. From $q$ to $j$

The inverse of the $q$-expansion of $j$ has integer coefficients:
$$q = j^{-1} + 744\, j^{-2} + 750420\, j^{-3} + \cdots = j^{-1}\big(1 + 744\, j^{-1} + 750420\, j^{-2} + \cdots\big) \in j^{-1}\,\mathbb{Z}[[j^{-1}]] .$$

> **Proposition 2.** $q \in (\mathbb{Q}_p^\times)^p$ if and only if $j \in (\mathbb{Q}_p^\times)^p$.

*Proof.* It suffices to show that the bracket $\beta = 1 + 744\, j^{-1} + \cdots$ is a $p$-th power. Then $q = j^{-1}\beta$, and $q$ is a $p$-th power iff $j^{-1}$ is, iff $j$ is.
- **$p$ odd.** Every term after the $1$ has valuation at least $v(j^{-1}) = kp \ge 3$, so $\beta \in 1 + p^2\mathbb{Z}_p$. For $p$ odd, $1 + p^2\mathbb{Z}_p = (1 + p\mathbb{Z}_p)^p$ consists of $p$-th powers.
- **$p = 2$.** The term $744\, j^{-1}$ has valuation $v_2(744) + 2k = 3 + 2k \ge 5$. For $n \ge 2$, the term with $j^{-n}$ has valuation at least $2kn \ge 4$. So $\beta \in 1 + 8\mathbb{Z}_2$, which consists of squares. $\square$

## 4. The congruence

Write $j = p^{-kp} j_0$ with $j_0 \in \mathbb{Z}_p^\times$. The factor $p^{-kp}$ is a $p$-th power, so $j \in (\mathbb{Q}_p^\times)^p$ iff $j_0 \in (\mathbb{Z}_p^\times)^p$.
- For $p$ odd, $(\mathbb{Z}_p^\times)^p = \mu_{p-1} \times (1 + p^2\mathbb{Z}_p)$. So $j_0$ is a $p$-th power iff $j_0^{p-1} \equiv 1 \pmod{p^2}$.
- For $p = 2$, the unit squares are exactly $1 + 8\mathbb{Z}_2$.

> **Theorem.** Let $E/\mathbb{Q}_p$ have split multiplicative reduction with $v(j) = -kp$. An element of order $p$ in the component group lifts to a point of order $p$ in $E(\mathbb{Q}_p)$ if and only if
> $$\big(p^{kp}\, j\big)^{p-1} \equiv 1 \pmod{p^2} \quad (p \text{ odd}), \qquad\qquad 4^k\, j \equiv 1 \pmod 8 \quad (p = 2).$$

### In terms of a minimal Weierstrass model

On a minimal model with multiplicative reduction, $v(c_4) = 0$ and $v(\Delta) = kp$. Write $\Delta = p^{kp}\,\delta$ with $\delta \in \mathbb{Z}_p^\times$. Then $p^{kp} j = c_4^3/\delta$, and the condition becomes:

| $p$ | condition for a lift of order $p$ |
|---|---|
| $p \ge 5$ | $\big(c_4^3/\delta\big)^{p-1} \equiv 1 \pmod{p^2}$ |
| $p = 3$ | $\delta = \Delta/3^{3k} \equiv \pm 1 \pmod 9$ |
| $p = 2$ | $c_4 \cdot \Delta/4^k \equiv 1 \pmod 8$ |

How the special cases simplify:
- **$p = 3$.** The condition is $(c_4^3/\delta)^2 \equiv 1 \pmod 9$, i.e. $c_4^3/\delta \equiv \pm 1 \pmod 9$, because $(\mathbb{Z}/9)^\times$ is cyclic of order 6. The cubes in $(\mathbb{Z}/9)^\times$ are exactly $\pm 1$, so $c_4^3 \equiv \pm 1$ and the condition reduces to $\delta \equiv \pm 1 \pmod 9$.
- **$p = 2$.** Every unit $u$ satisfies $u^2 \equiv 1 \pmod 8$, hence $u^3 \equiv u^{-1} \equiv u \pmod 8$. So $c_4^3/\delta \equiv c_4\,\delta \pmod 8$.

**Why this is a congruence on the coefficients.** The residue $\delta \bmod p^2$ depends only on $\Delta \bmod p^{kp+2}$, and $c_4 \bmod p^2$ only on the $a_i \bmod p^2$. So the condition depends only on $a_1, \dots, a_6$ modulo $p^{kp+2}$, or modulo $2^{2k+3}$ when $p = 2$. The standing hypotheses are also congruence conditions:
- **Multiplicative reduction with $v(\Delta) = kp$:** $v(c_4) = 0$, and $\Delta$ is divisible by $p^{kp}$ but not by $p^{kp+1}$.
- **Split** (for $p$ odd): $-c_6$ is a square modulo $p$.

Any integral model with $v(c_4) = 0$ is automatically minimal.

## 5. Numerical check

The criterion was compared with a direct computation that does not use the Tate curve:
- **$p$ odd:** does the $p$-division polynomial have a root $x_0 \in \mathbb{Q}_p$ such that the corresponding $y$ is also in $\mathbb{Q}_p$? By the first remark in §2, this is equivalent to $\bar P$ lifting.
- **$p = 2$:** does the 2-division polynomial have three roots in $\mathbb{Q}_2$? This means full rational 2-torsion, which by the second remark in §2 is equivalent to $\bar P$ lifting.

The test ran over all minimal models of $[a_1, a_2, a_3, a_4, a_6]$ with $a_1, a_3 \in \{0, 1\}$, $a_2 \in \{-1, 0, 1\}$ and $|a_4|, |a_6| \le B$, keeping those with split multiplicative reduction of the given type. "Split multiplicative with $v(\Delta) = n$" was detected as Kodaira type $\mathrm{I}_n$ with $a_p = 1$. (An earlier version of this note used "Tamagawa number $= n$" instead. That test cannot distinguish split from non-split when $n = 2$, since non-split $\mathrm{I}_2$ also has Tamagawa number 2. It wrongly included non-split curves in the $p = 2$, $v(\Delta) = 2$ row; the row below is corrected.)

| $p$ | $v(\Delta) = kp$ | $B$ | curves | lift exists | criterion agrees |
|---|---|---|---|---|---|
| 3 | 3 | 30 | 376 | 152 | 376 / 376 |
| 3 | 6 | 60 | 75 | 31 | 75 / 75 |
| 5 | 5 | 60 | 12 | 3 | 12 / 12 |
| 2 | 2 | 12 | 232 | 64 | 232 / 232 |
| 2 | 4 | 20 | 163 | 63 | 163 / 163 |
| 2 | 6 | 30 | 75 | 42 | 75 / 75 |

## 6. The component of order 2: lifts of order 2 and of order 4

*Added 15 September 2026.*

Now let $p$ be arbitrary, let $E/\mathbb{Q}_p$ have split multiplicative reduction, and let $n = -v(j)$ be **even**. The component group $\mathbb{Z}/n$ then has a unique element of order 2, the class $n/2$. There are two ways it can lift:
- **to a point of order 2**, which for $p = 2$ is the case $k = n/2$ of the theorem in §4;
- **to a point of order 4**, whose double is then the 2-torsion point $-1$ on the identity component.

> **Proposition 3.** The class $n/2$ lifts to a point of order 4 in $E(\mathbb{Q}_p)$ if and only if $-q \in (\mathbb{Q}_p^\times)^2$, if and only if $-j \in (\mathbb{Q}_p^\times)^2$.
>
> Similarly, it lifts to a point of order 2 if and only if $q$, equivalently $j$, is a square.

*Proof of the first equivalence.*
- **If $-q = w^2$.** Then $v(w) = n/2$, $w^2 = -q \notin q^{\mathbb{Z}}$, and $w^4 = q^2 \in q^{\mathbb{Z}}$. So $w$ is a point of order 4 on component $n/2$.
- **Conversely**, let $u$ represent a lift of order 4.
  1. $2u$ lies on component $2 \cdot n/2 \equiv 0$, so $u^2 = \varepsilon\, q^a$ with $\varepsilon \in \mathbb{Z}_p^\times$.
  2. Since $u^4 \in q^{\mathbb{Z}}$, we get $\varepsilon^2 = 1$. The only square roots of 1 in $\mathbb{Z}_p^\times$ are $\pm 1$, so $\varepsilon = \pm 1$.
  3. If $\varepsilon = 1$, then $u$ has order at most 2. So $\varepsilon = -1$.
  4. Taking valuations, $2v(u) = an$, and $v(u) \equiv n/2 \pmod n$ forces $a$ to be odd.
  5. Hence $-q = u^2\, q^{1-a} = \big(u\, q^{(1-a)/2}\big)^2$.

*The order-2 statement* is proved the same way with $\varepsilon = 1$, or by the argument of Proposition 1 with $p$ replaced by 2.

*From $q$ to $j$.* Write $q = j^{-1}\beta$ with $\beta = 1 + 744\, j^{-1} + \cdots$ as in §3. For $p$ odd, $\beta \equiv 1 \pmod p$, so $\beta$ is a square. For $p = 2$, $\beta \equiv 1 \pmod 8$ because $n \ge 2$, as shown in the proof of Proposition 2, so again $\beta$ is a square. $\square$

### The congruences

Write $j = p^{-n} j_0$ and, on a minimal model, $\Delta = p^n \delta$, with $j_0, \delta$ units. Since $n$ is even, $p^{-n}$ is a square, so everything depends only on $j_0$.

For $p$ odd, $c_4$ is automatically a square modulo $p$. Indeed $c_4^3 - c_6^2 = 1728\,\Delta \equiv 0 \pmod p$ gives $c_4 \equiv (c_6/c_4)^2$. Hence $\left(\frac{j_0}{p}\right) = \left(\frac{c_4^3/\delta}{p}\right) = \left(\frac{\delta}{p}\right)$. For $p = 2$, the relation $u^3 \equiv u^{-1} \equiv u \pmod 8$ gives $j_0 \equiv c_4\,\delta \pmod 8$.

| | lift of order 2 | lift of order 4 |
|---|---|---|
| $p$ odd, via $j$ | $\left(\frac{j_0}{p}\right) = 1$ | $\left(\frac{-j_0}{p}\right) = 1$ |
| $p$ odd, via $\Delta$ | $\left(\frac{\delta}{p}\right) = 1$ | $\left(\frac{-\delta}{p}\right) = 1$ |
| $p = 2$, via $j$ | $j_0 \equiv 1 \pmod 8$ | $j_0 \equiv 7 \pmod 8$ |
| $p = 2$, via coefficients | $c_4\,\delta \equiv 1 \pmod 8$ | $c_4\,\delta \equiv 7 \pmod 8$ |

**How the two conditions interact.**
- **$p \equiv 1 \pmod 4$:** $-1$ is a square, so the two conditions coincide. Either both kinds of lift exist or neither does. When both exist, they differ by $\sqrt{-1} \in \mathbb{Z}_p^\times \cong E_0(\mathbb{Q}_p)$.
- **$p \equiv 3 \pmod 4$:** exactly one of the two conditions holds. So the component of order 2 **always** lifts to a point of order 2 or 4.
- **$p = 2$:** at most one condition holds. If $j_0 \equiv 3$ or $5 \pmod 8$, neither does.

### Numerical check

The direct test, which does not use the Tate curve, looks for a point $P \in E(\mathbb{Q}_p)$ of exact order 4 with $P \notin E_0(\mathbb{Q}_p)$ and $2P \in E_0(\mathbb{Q}_p)$. Because the component group is cyclic, these two conditions say exactly that $P$ lies on component $n/2$.
- The $x$-coordinates of points of exact order 4 are the roots of the 4-division polynomial with all factors of the 2-division polynomial removed.
- A point lies off $E_0$ iff it is integral and reduces to the singular point of the minimal model.

For order 2, the direct test looks for a 2-torsion point off $E_0$. Coefficient ranges are as in §5, and split reduction was detected by $a_p = 1$.

| $p$ | $n$ | $B$ | split curves | order-4 lift | order-2 lift | criteria agree |
|---|---|---|---|---|---|---|
| 3 | 2 | 25 | 764 | 394 | 370 | all |
| 3 | 4 | 40 | 195 | 76 | 119 | all |
| 7 | 2 | 40 | 561 | 240 | 321 | all |
| 5 | 2 | 40 | 981 | 516 | 516 | all |
| 5 | 4 | 60 | 115 | 79 | 79 | all |
| 13 | 2 | 60 | 457 | 276 | 276 | all |
| 2 | 2 | 12 | 232 | 58 | 64 | all |
| 2 | 4 | 20 | 163 | 39 | 63 | all |
| 2 | 6 | 30 | 75 | 10 | 42 | all |

"Criteria agree" means that both columns match the $j$-criterion and the order-4 column also matches the coefficient form. The counts show the pattern above: for $p = 3, 7$ the two lift counts add up to the total, for $p = 5, 13$ they are equal, and for $p = 2$ they are disjoint.

## 7. Over a finite extension $K/\mathbb{Q}_p$

- **Proposition 1 carries over verbatim.** A lift of order $p$ exists iff $q \in (K^\times)^p$.
- **Proposition 2 needs more care.** The passage from $q$ to $j$ uses that $1 + \mathfrak{m}^{v(q)}$ consists of $p$-th powers. That requires $v_K(q)$ to be large relative to the ramification index; roughly, $v_K(q) > e\,p/(p-1)$ suffices.
- **Extra torsion.** If $\mu_p \subset K$, the identity component $\mathcal{O}_K^\times$ contains $p$-torsion. Then "$E(K)$ has a point of order $p$" no longer implies that $\bar P$ lifts.

## Appendix: PARI/GP scripts

```gp
default(parisize, 10^9);

\\ p odd: does E(Q_p) have a point of order p?  (p-division polynomial, no Tate curve)
haspt(E, p) =
{
  my(F = factorpadic(elldivpol(E, p), p, 40)[,1], x0, d);
  for (i = 1, #F, if (poldegree(F[i]) == 1,
    x0 = -polcoef(F[i], 0)/polcoef(F[i], 1);
    d = (E.a1*x0 + E.a3)^2 + 4*(x0^3 + E.a2*x0^2 + E.a4*x0 + E.a6);
    if (d == 0 || issquare(d), return(1))));
  0;
}
\\ p = 2: full rational 2-torsion?
full2(E) = { my(F = factorpadic(elldivpol(E, 2), 2, 40)[,1]); sum(i = 1, #F, poldegree(F[i]) == 1) == 3; }

\\ criterion: j is a p-th power in Q_p^*
pred(E, p) = { my(u = E.j / p^valuation(E.j, p)); if (p == 2, u % 8 == 1, Mod(u, p^2)^(p-1) == 1); }

test(p, n, B) =
{
  my(tot = 0, agree = 0, yes = 0, E, lr, got);
  forvec(v = [[0,1],[-1,1],[0,1],[-B,B],[-B,B]],
    E = ellinit(v); if (#E == 0, next); E = ellminimalmodel(E);
    lr = elllocalred(E, p);
    if (valuation(E.disc, p) == n && lr[2] == 4 + n && ellap(E, p) == 1,   \\ split I_n (a_p = 1)
      tot++; got = if (p == 2, full2(E), haspt(E, p)); yes += got;
      agree += (got == pred(E, p))));
  print("p=", p, " v(Delta)=", n, ": curves ", tot, ", lift exists ", yes, ", criterion agrees ", agree);
}

test(3, 3, 30); test(3, 6, 60); test(5, 5, 60);
test(2, 2, 12); test(2, 4, 20); test(2, 6, 30);
```

### Script for §6 (lifts of order 2 and 4)

```gp
default(parisize, 10^9);

issplit(E, p, n) = { my(lr = elllocalred(E, p)); valuation(E.disc, p) == n && lr[2] == 4 + n && ellap(E, p) == 1; }

\\ is the p-adic point (x0, y0) off the identity component? (integral, reducing to the singular point)
offE0(E, x0, y0, p) =
{
  if (valuation(x0, p) < 0 || valuation(y0, p) < 0, return(0));
  valuation(3*x0^2 + 2*E.a2*x0 + E.a4 - E.a1*y0, p) > 0 && valuation(2*y0 + E.a1*x0 + E.a3, p) > 0;
}

\\ exists P of exact order 4 with P off E_0 and 2P in E_0, i.e. P on component n/2?
lift4(E, p) =
{
  my(f4 = elldivpol(E, 4), f2 = elldivpol(E, 2), F, x0, d, y0, x2);
  while (f4 % f2 == 0, f4 = f4 / f2);
  F = factorpadic(f4, p, 80)[,1];
  for (i = 1, #F, if (poldegree(F[i]) == 1,
    x0 = -polcoef(F[i], 0)/polcoef(F[i], 1);
    d = (E.a1*x0 + E.a3)^2 + 4*(x0^3 + E.a2*x0^2 + E.a4*x0 + E.a6);
    if (!issquare(d), next);
    y0 = (-(E.a1*x0 + E.a3) + sqrt(d))/2;
    if (!offE0(E, x0, y0, p), next);
    x2 = (x0^4 - E.b4*x0^2 - 2*E.b6*x0 - E.b8) / (4*x0^3 + E.b2*x0^2 + 2*E.b4*x0 + E.b6);   \\ x(2P)
    if (!offE0(E, x2, -(E.a1*x2 + E.a3)/2, p), return(1))));
  0;
}

\\ exists a 2-torsion point off E_0?
lift2(E, p) =
{
  my(F = factorpadic(elldivpol(E, 2), p, 80)[,1], x0);
  for (i = 1, #F, if (poldegree(F[i]) == 1,
    x0 = -polcoef(F[i], 0)/polcoef(F[i], 1);
    if (offE0(E, x0, -(E.a1*x0 + E.a3)/2, p), return(1))));
  0;
}

sq(u, p) = if (p == 2, u % 8 == 1, kronecker(numerator(u)*denominator(u), p) == 1);
unit(x, p) = x / p^valuation(x, p);
predj4(E, p) = sq(-unit(E.j, p), p);
predc4(E, p) = { my(delta = unit(E.disc, p)); if (p == 2, (E.c4*delta) % 8 == 7, kronecker(-delta, p) == 1); }
predj2(E, p) = sq(unit(E.j, p), p);

test24(p, n, B) =
{
  my(tot = 0, g4 = 0, g2 = 0, ok = 0, E, t4, t2);
  forvec(v = [[0,1],[-1,1],[0,1],[-B,B],[-B,B]],
    E = ellinit(v); if (#E == 0, next); E = ellminimalmodel(E);
    if (issplit(E, p, n),
      tot++; t4 = lift4(E, p); t2 = lift2(E, p); g4 += t4; g2 += t2;
      ok += (t4 == predj4(E, p) && t4 == predc4(E, p) && t2 == predj2(E, p))));
  print("p=", p, " n=", n, ": split curves ", tot, ", order-4 lift ", g4, ", order-2 lift ", g2, ", all criteria agree ", ok);
}

test24(3, 2, 25); test24(3, 4, 40); test24(7, 2, 40);
test24(5, 2, 40); test24(5, 4, 60); test24(13, 2, 60);
test24(2, 2, 12); test24(2, 4, 20); test24(2, 6, 30);
```
