# Quaternion algebras and rational points on quadric surfaces

**Setup.** $k$ is a field of characteristic $\ne 2$, $q$ is a nondegenerate quadratic form in four variables over $k$, and $Q = \{q = 0\} \subset \mathbb{P}^3_k$ is the corresponding smooth quadric surface. Its **discriminant** is

$$d = \det q \in k^\times / k^{\times 2},$$

(for $n = 4$ the signed discriminant $(-1)^{n(n-1)/2}\det q$ equals $\det q$), and we put $K = k[t]/(t^2 - d)$. So $K = k(\sqrt d)$ when $d$ is not a square, and $K \cong k \times k$ when it is.

**The question.** Does the theory of quaternion algebras help with the study of rational points on quadric surfaces?

**Answer: yes, and for existence it is almost the whole story.** A smooth quadric surface has a rational point if and only if a certain quaternion algebra over $K$ splits. This is the geometric form of the exceptional isomorphism $D_2 = A_1 \times A_1$. The Hasse principle for $Q$ then *is* the Hasse principle for that algebra. Beyond existence, for integral points and counting, quaternion orders are the natural tool.

---

## 1. The warm-up: conics

For a ternary form the dictionary is classical. The conic $C = \{x_0^2 - a x_1^2 - b x_2^2 = 0\}$ is the Severi–Brauer variety of the quaternion algebra $A = (a,b)_k$, and

$$C(k) \ne \emptyset \iff x_0^2 - a x_1^2 - b x_2^2 \text{ is isotropic} \iff A \cong M_2(k).$$

Concretely, the form $\langle 1, -a, -b \rangle$ is the reduced norm restricted to the span of $1, i, j$. A nonzero isotropic vector is a zero divisor, which exists iff $A$ is not a division algebra. More intrinsically, $C$ is the conic of the even Clifford algebra $C_0(q)$, which is a quaternion algebra with centre $k$. The same construction one dimension up gives everything below.

---

## 2. Trivial discriminant: $Q$ is the zero-divisor locus of a quaternion algebra

For $A = (a,b)_k$ with basis $1, i, j, ij$, the reduced norm is

$$\operatorname{Nrd}(x_0 + x_1 i + x_2 j + x_3 ij) = x_0^2 - a x_1^2 - b x_2^2 + ab\, x_3^2,$$

a quaternary form of determinant $a^2 b^2$, which is a square. Conversely, every quaternary form of square discriminant is **similar** (equal up to a scalar) to the reduced norm of a quaternion algebra, namely $C_0(q) \cong A \times A$. Scaling does not change the zero locus, so

$$Q \cong \{\operatorname{Nrd} = 0\} \subset \mathbb{P}(A),$$

the projectivised variety of zero divisors of $A$. Two cases follow.

**$A$ split.** Then $A \cong M_2(k)$, $\operatorname{Nrd} = \det$, and $Q$ is the set of rank-one $2 \times 2$ matrices, $x = v w^{\mathsf T}$. This is the Segre embedding

$$\mathbb{P}^1 \times \mathbb{P}^1 \xrightarrow{\ \sim\ } Q, \qquad ([v],[w]) \mapsto [v w^{\mathsf T}],$$

so $Q(k) = \mathbb{P}^1(k) \times \mathbb{P}^1(k)$, and the two families of lines are $\{v\} \times \mathbb{P}^1$ and $\mathbb{P}^1 \times \{w\}$.

**$A$ division.** Every nonzero element is invertible, so $\operatorname{Nrd}$ is anisotropic and $Q(k) = \emptyset$. Geometrically $Q$ is still $\mathbb{P}^1 \times \mathbb{P}^1$, but each ruling is a nontrivial form of $\mathbb{P}^1$. Both are isomorphic to the conic $C_A$ of §1 (see §5 for why the Brauer class of each is $[A]$), and

$$Q \cong C_A \times C_A.$$

**Symmetry.** The group $A^\times \times A^\times$ acts on $A$ by $x \mapsto \alpha x \beta^{-1}$. This multiplies $\operatorname{Nrd}$ by $\operatorname{Nrd}(\alpha)/\operatorname{Nrd}(\beta)$, and with the obvious kernel it gives the similitude group of $q$. In particular

$$(\operatorname{SL}_1(A) \times \operatorname{SL}_1(A)) / \mu_2 \cong \operatorname{SO}(q),$$

so the orthogonal group acting on $Q(k)$ is also described by quaternions.

---

## 3. Nontrivial discriminant: $Q$ is a Weil restriction of a conic

Now let $d$ be a nonsquare, so $K = k(\sqrt d)$ is a field. The even Clifford algebra $C_0(q)$ has centre $K$ and is a **quaternion algebra $B$ over $K$**. For a diagonal form this is explicit. Scale $q = \langle a_1, a_2, a_3, a_4 \rangle$ to $\langle 1, a_1a_2, a_1a_3, a_1a_4\rangle$ and set $a = -a_1a_2$, $b = -a_1a_3$. Then $a_1 a_4 \equiv ab \cdot d$ modulo squares, so

$$q \sim \langle 1, -a, -b, ab\,d\rangle, \qquad q_K \sim \langle 1, -a, -b, ab \rangle = \operatorname{Nrd}_{(a,b)_K}, \qquad B = (a, b)_K = (-a_1a_2,\, -a_1a_3)_K.$$

Geometrically $Q_{\bar k} \cong \mathbb{P}^1 \times \mathbb{P}^1$ still, but now $\operatorname{Gal}(K/k)$ **swaps the two rulings**. The scheme of lines on $Q$ is a conic $C_B$ over $K$, namely the Severi–Brauer variety of $B$, viewed as a $k$-scheme. Sending a point to the pair of lines through it identifies

$$Q \cong R_{K/k}(C_B), \qquad\text{hence}\qquad Q(k) = C_B(K).$$

This is the geometric side of $\operatorname{Spin}(q) \cong R_{K/k}\operatorname{SL}_1(B)$.

A consequence worth isolating (Lam, *Introduction to Quadratic Forms over Fields*):

> **If $d$ is not a square, $q$ is isotropic over $k$ iff $q_K$ is isotropic over $K$.**

Both sides are equivalent to "$B$ splits". Over $K$ the discriminant becomes trivial and $q_K$ is similar to $\operatorname{Nrd}_B$, so §2 applies.

---

## 4. The dictionary in one line

Combining §2 and §3:

$$\boxed{\;Q(k) \ne \emptyset \iff C_0(q) \text{ is split over its centre } K\;}$$

with $C_0(q) = A \times A$ when $d$ is a square (the condition is "$A$ splits") and $C_0(q) = B$ over $K = k(\sqrt d)$ otherwise. Two corollaries:

- **Rationality.** If $Q(k) \ne \emptyset$ then $Q$ is $k$-rational, by projecting from the point. More precisely $Q \cong \mathbb{P}^1 \times \mathbb{P}^1$ when $d$ is square and $Q \cong R_{K/k}\mathbb{P}^1_K$ otherwise.
- **Finite fields.** Over $\mathbb{F}_p$ every quaternion algebra splits, so $Q(\mathbb{F}_p) \ne \emptyset$ always, and the rulings count the points: $\#Q(\mathbb{F}_p) = \#\mathbb{P}^1(\mathbb{F}_p)^2 = (p+1)^2$ if $d$ is a square, and $\#\mathbb{P}^1(\mathbb{F}_{p^2}) = p^2 + 1$ otherwise. (Check 3 below.)

---

## 5. Local–global, and the Brauer group of $Q$

### 5.1 Hasse–Minkowski for quaternary forms from ABHN

Let $k$ be a number field. Apply the Albert–Brauer–Hasse–Noether theorem ($\operatorname{Br}(K) \hookrightarrow \bigoplus_w \operatorname{Br}(K_w)$) to $C_0(q)$ over $K$:

$$Q(k) \ne \emptyset \iff C_0(q) \text{ split} \iff C_0(q)_w \text{ split for every place } w \text{ of } K \iff Q(k_v) \ne \emptyset \text{ for every place } v \text{ of } k.$$

The last step is the local version of §4 at each $v$: $K \otimes_k k_v = \prod_{w \mid v} K_w$. So the Hasse principle for quadric surfaces **is** the Hasse principle for quaternion algebras over $K$. The implication also runs the other way: the ternary case of Hasse–Minkowski is exactly the Hasse principle for quaternion algebras over $k$ itself. The honest summary is that both are the case $n = 2$ of the injectivity of $\operatorname{Br}(K) \to \bigoplus_w \operatorname{Br}(K_w)$, which is class field theory.

### 5.2 Why there is no further obstruction

Put $\bar Q = Q_{\bar k}$. Then $\operatorname{Pic}(\bar Q) = \mathbb{Z}^2$, generated by the two rulings, and Galois acts trivially if $d$ is a square and by the swap otherwise. In both cases it is a **permutation module**, so by Shapiro

$$H^1(k, \operatorname{Pic}\bar Q) = 0.$$

$Q$ is geometrically rational, so $\operatorname{Br}(\bar Q) = 0$ and $\operatorname{Br}(Q) = \operatorname{Br}_1(Q)$. The Hochschild–Serre sequence (valid since $\bar k[Q]^\times = \bar k^\times$)

$$0 \to \operatorname{Pic} Q \to (\operatorname{Pic}\bar Q)^{G} \xrightarrow{\ \delta\ } \operatorname{Br}(k) \to \operatorname{Br}_1(Q) \to H^1(k, \operatorname{Pic}\bar Q) = 0$$

then gives $\operatorname{Br}(Q) = \operatorname{Br}_0(Q)$, the image of $\operatorname{Br}(k)$. Consequently there is **no Brauer–Manin obstruction** and weak approximation holds whenever $Q(k) \ne \emptyset$. Both facts are also classical consequences of Hasse–Minkowski.

### 5.3 The quaternion algebra is the kernel

The map $\delta$ is where $C_0(q)$ shows up. Since $\operatorname{Br}(Q) \hookrightarrow \operatorname{Br}(k(Q))$ for smooth $Q$, the kernel of $\operatorname{Br}(k) \to \operatorname{Br}(k(Q))$ is $\operatorname{im}\delta$. The map $\delta$ sends the class of a ruling to the Brauer class of that ruling as a Severi–Brauer variety.

- **$d$ square.** $(\operatorname{Pic}\bar Q)^G = \mathbb{Z}^2$, and $\delta(1,0) = \delta(0,1) = [A]$. The first equality needs both rulings to have class $[A]$, and it is forced because $\delta(1,1)$ is the hyperplane class, which is defined over $k$ and so $\delta(1,1) = 0$. Hence
  $$\ker\big(\operatorname{Br}(k) \to \operatorname{Br}(k(Q))\big) = \{0, [A]\}.$$
  This is also why $Q \cong C_A \times C_A$ in §2, since conics with the same Brauer class are isomorphic.
- **$d$ nonsquare.** $(\operatorname{Pic}\bar Q)^G = \mathbb{Z}\cdot(1,1)$ and $\delta(1,1) = \operatorname{Cor}_{K/k}[B]$. This is zero because $(1,1)$ is the hyperplane class. So
  $$\operatorname{Cor}_{K/k}[C_0(q)] = 0 \qquad\text{and}\qquad \operatorname{Br}(k) \hookrightarrow \operatorname{Br}(k(Q)).$$
  The first statement is a genuine constraint: only quaternion algebras over $K$ with trivial corestriction arise as $C_0(q)$.

---

## 6. Worked examples over $\mathbb{Q}$

### 6.1 Trivial discriminant, anisotropic: $x_0^2 + x_1^2 + x_2^2 + x_3^2$

This is $\operatorname{Nrd}$ of Hamilton's quaternions $A = (-1,-1)_\mathbb{Q}$, and $d = 1$. Since $(-1,-1)_2 = (-1,-1)_\infty = -1$, $A$ is ramified exactly at $\{2, \infty\}$. That is an even number of places, as it must be. So $Q(\mathbb{R}) = \emptyset$ (obvious) and also $Q(\mathbb{Q}_2) = \emptyset$, which is less obvious: there is no nontrivial solution even 2-adically.

### 6.2 Trivial discriminant, split: $x_0^2 - 2x_1^2 - 7x_2^2 + 14x_3^2$

This is $\operatorname{Nrd}$ of $A = (2,7)_\mathbb{Q}$. Only $2$, $7$ and $\infty$ can ramify:

- $(2,7)_7 = \left(\tfrac{2}{7}\right) = 1$ since $2 \equiv 3^2 \pmod 7$;
- $(2,7)_2 = (-1)^{(7^2-1)/8} = 1$;
- $(2,7)_\infty = 1$ since both entries are positive.

So $A \cong M_2(\mathbb{Q})$ and $Q \cong \mathbb{P}^1 \times \mathbb{P}^1$ over $\mathbb{Q}$. To find a point, write $q = N(x_0 + x_1\sqrt2) - 7\,N(x_2 + x_3\sqrt 2)$ and use $7 = 3^2 - 2\cdot 1^2 = N(3 + \sqrt 2)$:

$$q(3, 1, 1, 0) = 9 - 2 - 7 = 0.$$

### 6.3 Nontrivial discriminant: $x^2 + y^2 + z^2 = n w^2$ and Legendre

Let $n \ge 1$ be squarefree and $q = \langle 1, 1, 1, -n \rangle$. Then $d = -n$, $K = \mathbb{Q}(\sqrt{-n})$ (a field, since $-n < 0$), and by §3 with $a_1 = a_2 = a_3 = 1$

$$B = C_0(q) = (-1, -1)_K.$$

$B$ is the base change of Hamilton's quaternions, which ramify only at $2$ and $\infty$. So $B$ can ramify only at places of $K$ above $2$ and $\infty$. $K$ is imaginary, so its infinite place is complex and $B$ splits there. At a prime $w \mid 2$, base change to a local extension multiplies the local invariant by the degree $[K_w : \mathbb{Q}_2]$. So $B_w$ splits iff that degree is $2$, i.e. iff $2$ is **not split** in $K$. Hence

$$Q(\mathbb{Q}) \ne \emptyset \iff 2 \text{ does not split in } \mathbb{Q}(\sqrt{-n}) \iff -n \not\equiv 1 \pmod 8 \iff n \not\equiv 7 \pmod 8.$$

A solution has $w \ne 0$, since otherwise $x = y = z = 0$. So this says: **a squarefree $n$ is a sum of three rational squares iff $n \not\equiv 7 \pmod 8$**. This is the rational form of Legendre's three-square theorem, derived here from the splitting of one quaternion algebra over one quadratic field. Compare $n = 3$ ($2$ inert in $\mathbb{Q}(\sqrt{-3})$; $1 + 1 + 1 = 3$) with $n = 7$ ($2$ split in $\mathbb{Q}(\sqrt{-7})$; $B$ ramified at both primes above $2$, and $x^2+y^2+z^2 = 7w^2$ has no nontrivial solution). (Check 1 below.)

---

## 7. Beyond existence: where quaternion arithmetic does real work

Existence is settled by §4–5. The quaternion picture really earns its keep for **integral** questions, where the Brauer group is no longer trivial and class-field-theoretic arguments no longer suffice.

- **Representation numbers.** Counting solutions of $q(x) = m$ for a positive definite quaternary $q$ amounts to counting elements of reduced norm $m$ in an order of a definite quaternion algebra. Jacobi's four-square formula $r_4(m) = 8\sum_{e \mid m,\ 4 \nmid e} e$ drops out of the arithmetic of the Hurwitz order, which is a Euclidean ring. For general orders, Eichler's theory of ideal classes and Brandt matrices plays the same role, and the theta series of the ideal classes are modular forms of weight $2$.
- **Integral Hasse principle on affine quadrics.** For an affine quadric $X : q(x) = m$ the group $\operatorname{Br}(X)/\operatorname{Br}_0(X)$ can be nonzero. The extra classes are quaternion algebras, and they can obstruct the integral Hasse principle, as in the work of Colliot-Thélène–Xu on strong approximation for spin groups. Local invariants are computed with Hilbert symbols, exactly as in §6.
- **Equidistribution and expanders.** Linnik- and Duke-type equidistribution of integral points on $x^2 + y^2 + z^2 = m$, and the Lubotzky–Phillips–Sarnak Ramanujan graphs, both run on the action of quaternion units on these quadrics.
- **Nearby surfaces.** For del Pezzo surfaces of degree 4 (intersections of two quadrics in $\mathbb{P}^4$) and for conic bundle surfaces, $\operatorname{Br}(X)/\operatorname{Br}_0(X)$ is typically $2$-torsion and generated by quaternion algebras over $k(X)$. Iskovskikh's counterexample to the Hasse principle is the standard example (see `kummer/residues.typ` §12(e)).

---

## 8. Checks (PARI/GP)

```gp
\\ (1) x^2+y^2+z^2 = n w^2 isotropic over Q  <=>  n != 7 mod 8  <=>  2 not split in Q(sqrt(-n))
{
bad = 0; cnt = 0;
for (n = 1, 500, if (!issquarefree(n), next); cnt++;
  iso   = type(qfsolve(matdiagonal([1,1,1,-n]))) == "t_COL";
  pred  = (n % 8 != 7);
  pred2 = (#idealprimedec(nfinit(t^2+n), 2) == 1);
  if (iso != pred || pred != pred2, bad++; print("mismatch ", n)));
print("(1) squarefree n <= 500: ", cnt, " tested, ", bad, " mismatches");
}
\\ (2) the Hilbert symbols of 6.1 and 6.2
print([hilbert(2,7,2), hilbert(2,7,7), hilbert(2,7,0)]);   \\ [1, 1, 1]
print([hilbert(-1,-1,2), hilbert(-1,-1,0)]);               \\ [-1, -1]
\\ (3) #Q(F_p) = (p+1)^2 or p^2+1 according to whether disc is a square mod p
{
bad = 0; tot = 0;
forprime(p = 3, 19, for (s = 1, 6,
  a = vector(4, i, 1 + random(p-1)); d = prod(i=1,4,a[i]);
  N = 0; forvec(v = vector(4, i, [0, p-1]), if (sum(i=1,4,a[i]*v[i]^2) % p == 0, N++));
  N = (N - 1) / (p - 1);
  pred = if (kronecker(d, p) == 1, (p+1)^2, p^2+1);
  tot++; if (N != pred, bad++; print("mismatch ", p, a))));
print("(3) ", tot, " random diagonal quadrics: ", bad, " mismatches");
}
```

Output (PARI/GP 2.18): (1) 306 squarefree $n \le 500$, 0 mismatches between the three conditions; (2) as annotated; (3) 42 random diagonal quadrics over $\mathbb{F}_p$, $3 \le p \le 19$, 0 mismatches.

---

## References

- T. Y. Lam, *Introduction to Quadratic Forms over Fields*: Clifford algebras, the even Clifford algebra of a quaternary form, and the isotropy criterion of §3.
- M.-A. Knus, A. Merkurjev, M. Rost, J.-P. Tignol, *The Book of Involutions*: $D_2 = A_1 \times A_1$ and $C_0(q)$ with its trivial corestriction.
- J. Voight, *Quaternion Algebras*: the chapters on quadratic forms and ternary forms for the conic/norm-form dictionary; the chapters on orders for §7.
- J.-L. Colliot-Thélène, A. N. Skorobogatov, *The Brauer–Grothendieck Group*: the Hochschild–Serre sequence of §5.2.
- J.-L. Colliot-Thélène, F. Xu, "Brauer–Manin obstruction for integral points of homogeneous spaces and representation by integral quadratic forms", *Compositio Math.* 145 (2009).
