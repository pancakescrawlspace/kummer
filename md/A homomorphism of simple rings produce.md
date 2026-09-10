# A homomorphism of simple rings produces a common central field

*Rings are unital and associative, homomorphisms satisfy $f(1) = 1$, and "simple" means: the only
two-sided ideals are $0$ and $R$, and $1 \neq 0$. No chain condition, no finite-dimensionality, and
no ambient field is assumed anywhere — the field in the title is manufactured, not given. See §7 for
what happens without $f(1) = 1$, and §8 for the finiteness hypotheses that are genuinely absent.*

---

## 0. The question

> Given a homomorphism $f : A \to B$ between simple rings, are $A$ and $B$ both $k$-algebras for a
> single field $k$?

Yes, and the sharp form is §3. But the obvious route to it has a gap worth isolating, because the
gap is exactly the place where simplicity of the *source* has to be used.

---

## 1. Two standard facts

> **Lemma 1.** If $R$ is simple then $Z(R)$ is a field.

**Proof.** $Z(R)$ is a commutative subring containing $1$. Let $0 \neq z \in Z(R)$. Because $z$ is
central, $zR = Rz$ is a two-sided ideal, and it is nonzero since $z = z \cdot 1 \in zR$. Hence
$zR = R$, so $zb = 1$ for some $b \in R$, and then also $bz = 1$. That $b$ is itself central:

$$
bx \;=\; bx(zb) \;=\; b(xz)b \;=\; b(zx)b \;=\; (bz)(xb) \;=\; xb
$$

for every $x \in R$. So $z^{-1} = b \in Z(R)$. $\blacksquare$

The computation is worth naming separately, since it gets reused:

> **Lemma 1'.** The inverse of a central unit is central.

> **Lemma 2.** If $A$ is simple then any homomorphism $f : A \to B$ into a nonzero ring is injective.

**Proof.** $\ker f$ is a two-sided ideal, so $\ker f \in \{0, A\}$; and $\ker f \neq A$ because
$f(1) = 1 \neq 0$. $\blacksquare$

Both uses of $f(1) = 1$ matter; see §7.

---

## 2. The gap

Here is the tempting argument. Put $K = Z(B)$, a field by Lemma 1, and $k = f^{-1}(K)$. Since $f$ is
injective, $k \cong f(A) \cap K$, "a subfield of $K$" — done.

That last step is a non sequitur. $f(A) \cap K$ is a *subring* of the field $K$, and a subring of a
field need not be a field: $\mathbb{Z} \subset \mathbb{Q}$, or $\mathbb{Q}[t] \subset \mathbb{Q}(t)$.
Nothing so far forces $k$ to be closed under inversion.

Note also what the argument has and has not used: it invoked simplicity of $A$ only to get
injectivity. Any correct proof has to come back for more, because "subring of a field" is genuinely
not enough.

---

## 3. The repair

> **Theorem.** Let $f : A \to B$ be a homomorphism of simple rings and set $k = f^{-1}(Z(B))$. Then
> $k$ is a subfield of $Z(A)$, and $f(k)$ is a subfield of $Z(B)$. Consequently $A$ and $B$ are
> $k$-algebras — $A$ via the inclusion $k \subseteq Z(A)$, $B$ via $f|_k : k \xrightarrow{\sim} f(k)
> \subseteq Z(B)$ — and $f$ is a homomorphism of $k$-algebras.

**Proof.** $k$ is a subring of $A$ containing $1$, since $f(1) = 1 \in Z(B)$ and preimages of
subrings are subrings.

*Centrality.* Let $a \in k$ and $a' \in A$. Then $f(a) \in Z(B)$ gives

$$
f(aa') = f(a)f(a') = f(a')f(a) = f(a'a),
$$

and $f$ is injective by Lemma 2, so $aa' = a'a$. Hence $k \subseteq Z(A)$.

*Inverses.* Let $0 \neq a \in k$. By the previous paragraph $a \in Z(A)$, and $Z(A)$ is a field by
Lemma 1 applied to $A$ — this is the step the argument of §2 was missing. So $a^{-1}$ exists
**in $Z(A) \subseteq A$**. Applying $f$ to $aa^{-1} = a^{-1}a = 1$ shows $f(a^{-1})$ is a two-sided
inverse of $f(a)$ in $B$, hence *the* inverse. Since $f(a)$ is a central unit, Lemma 1' gives
$f(a)^{-1} \in Z(B)$, so $a^{-1} \in f^{-1}(Z(B)) = k$.

Thus $k$ is a subfield of $Z(A)$, and $f(k) \subseteq Z(B)$ is an isomorphic copy. The $k$-algebra
structures are central by construction, and $f$ is $k$-linear because $f(\lambda a) = f(\lambda)f(a)$
for $\lambda \in k$. $\blacksquare$

The whole content is the second paragraph of *Inverses*: the inverse has to be produced inside $A$,
by simplicity of $A$, and only then transported to $B$.

---

## 4. Maximality, and its limits

If $k' \subseteq Z(A)$ is any subfield with $f(k') \subseteq Z(B)$, then $k' \subseteq f^{-1}(Z(B)) = k$
by definition. So $k$ is the largest field over which $A$ and $B$ are algebras *compatibly with $f$*.

This says nothing about unrelated structures: $B$ alone may be an algebra over a much larger field via
a structure map having nothing to do with $f$. Maximality is relative to $f$, not absolute.

---

## 5. The statement is cheaper than it looks

By Lemma 1, $Z(A)$ is a field, so its prime subring is a domain and $\operatorname{char} A \in \{0, p\}$;
same for $B$. Injectivity of $f$ makes the two agree: $n \cdot 1_A = 0 \iff n \cdot 1_B = 0$.

- In characteristic $p$, both rings contain $\mathbb{F}_p$ centrally.
- In characteristic $0$, $Z(A)$ is a field of characteristic $0$, hence contains $\mathbb{Q}$; same
  for $Z(B)$.

So $A$ and $B$ are algebras over their common prime field before any of §3, and $f$ is automatically
a homomorphism over it — additive maps between $\mathbb{Q}$-vector spaces are $\mathbb{Q}$-linear.
The literal question of §0 therefore has a one-line affirmative answer. What §3 adds is the *best*
such $k$, which can be much larger than the prime field: for $A = B = \mathbb{Q}(t)$ and $f = \mathrm{id}$
one gets $k = \mathbb{Q}(t)$.

---

## 6. $k$ can be strictly smaller than $Z(A)$

$f$ need not carry $Z(A)$ into $Z(B)$ at all. Embed

$$
\mathbb{Q}(i) \hookrightarrow M_2(\mathbb{Q}), \qquad
i \longmapsto \begin{pmatrix} 0 & -1 \\ 1 & 0 \end{pmatrix},
$$

which is a homomorphism of simple rings since $J^2 = -I$. Here $Z(A) = \mathbb{Q}(i)$ because $A$ is a
field, while $Z(B) = \mathbb{Q} \cdot I$, and $a + bJ$ is scalar only when $b = 0$. So

$$
k = f^{-1}(Z(B)) = \mathbb{Q} \subsetneq \mathbb{Q}(i) = Z(A).
$$

This is the generic situation for a subfield of a central simple algebra: $Z(A)$ is a *splitting*
field sitting inside $B$, not a central one.

---

## 7. $f(1) = 1$ is not decorative

Drop it and the theorem fails. Let $A$ be simple and

$$
f : A \longrightarrow M_2(A), \qquad a \longmapsto \operatorname{diag}(a, 0).
$$

This is additive and multiplicative, injective, and $M_2(A)$ is simple. But
$Z(M_2(A)) = \{\operatorname{diag}(z,z) : z \in Z(A)\}$, so $\operatorname{diag}(a,0)$ is central only
for $a = 0$, and

$$
f^{-1}\bigl(Z(M_2(A))\bigr) = \{0\},
$$

which is not a field. The conclusion of §5 survives, though: $\operatorname{char} A = \operatorname{char} B$
still holds for nonzero non-unital $f$, since $f(1_A) = e \neq 0$ and a ring of characteristic $0$ is
torsion-free as an abelian group.

Without unitality one is really looking at $f : A \to eBe$, a homomorphism into a corner, and the
right statement concerns $Z(eBe)$ rather than $Z(B)$.

---

## 8. No finiteness anywhere

Nothing above uses a chain condition, a dimension count, or Wedderburn:

| step | what it uses |
|---|---|
| Lemma 1 | $zR$ is a two-sided ideal |
| Lemma 2 | $\ker f$ is a two-sided ideal |
| centrality of $k$ | injectivity of $f$ |
| inverses in $k$ | $Z(A)$ is a field; uniqueness of two-sided inverses |
| §5 | the prime subring of a field is a domain |

So the theorem applies verbatim to simple non-Artinian rings and to algebras of infinite dimension
over their centers. A concrete instance: the Weyl algebra $A_1(\mathbb{Q})$ is simple with center
$\mathbb{Q}$, infinite-dimensional over it (see the companion note *Two criteria for a central simple
algebra to be a division algebra*, §3), and it is an Ore domain, so it embeds in its skew field of
fractions $D_1(\mathbb{Q})$ — also simple with center $\mathbb{Q}$. The theorem returns
$k = \mathbb{Q}$ for that embedding.

Finiteness enters one step later, when one asks *which* $f$ occur rather than whether $k$ exists:

- **Skolem–Noether.** Two embeddings of a simple algebra into a central simple algebra
  finite-dimensional over $k$ are conjugate; in particular an endomorphism of a central simple algebra
  is inner.
- **Double centralizer.** $C_B(C_B(f(A))) = f(A)$, with $\dim_k f(A) \cdot \dim_k C_B(f(A)) = \dim_k B$.
- **Equal dimensions.** An injection of central simple $k$-algebras of the same finite dimension is an
  isomorphism.

Each of these fails for $A_1(\mathbb{Q}) \hookrightarrow D_1(\mathbb{Q})$, which is not surjective
despite both sides being central simple over $\mathbb{Q}$.
