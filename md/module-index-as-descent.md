# The module index $[M:N]$ as a genuine descent

**Setup.** $R$ is a Dedekind domain with fraction field $K$, $V$ is a $K$-vector space of dimension $n$, and $M, N \subset V$ are **lattices**: finitely generated $R$-submodules that span $V$. Write $X = \operatorname{Spec} R$.

Cassels–Fröhlich (Ch. I, §3 "Module index") define $[M:N]$ in two steps:

1. If $M$ and $N$ are free, choose $\sigma \in GL(V)$ mapping an $R$-basis of $M$ to an $R$-basis of $N$ and put
   $$[M:N] = R \cdot \det\sigma .$$
   This is well defined because two choices of $\sigma$ differ by an element of $\operatorname{Aut}_R(M) = GL_n(R)$, whose determinant is a unit.
2. In general, $M_\mathfrak{p}$ and $N_\mathfrak{p}$ are free over the DVR $R_\mathfrak{p}$, and $M_\mathfrak{p} = N_\mathfrak{p}$ for almost all $\mathfrak{p}$. So one puts
   $$[M:N] = \prod_\mathfrak{p} \mathfrak{p}^{v_\mathfrak{p}([M_\mathfrak{p}:N_\mathfrak{p}])}.$$

Example: $R = \mathbb{Z}$, $M = \mathbb{Z}$, $N = 2\mathbb{Z}$ gives $\sigma = 2$ and $[M:N] = (2)$, the usual index.

**The question.** Step 2 looks like descent: a quantity defined locally, then patched together, with the patching made "automatic" by unique factorization of ideals. Can the construction be made into an *actual* descent?

**Answer: yes.** It is a Zariski descent in disguise.

- The local indices $R_{f}\cdot\det\sigma$ are sections of the presheaf $K^\times/\mathcal{O}^\times$.
- They agree on overlaps for the same reason the classical definition is well defined: a change of basis has unit determinant.
- Gluing produces a global section of the sheafification, the sheaf of Cartier divisors, whose global sections are the invertible fractional ideals.
- "Unique factorization" is the computation of those global sections.

The object being descended exists globally: it is the ratio of the determinant lines $\Lambda^n N$ and $\Lambda^n M$.

---

## 1. The sheaf in which the patching happens

Let $\mathcal{D}$ be the sheaf on $X$ of invertible fractional ideals:
$$\mathcal{D}(U) = \{\text{invertible } \mathcal{O}(U)\text{-submodules of } K\}.$$

This is a sheaf because invertible quasi-coherent subsheaves of the constant sheaf $K$ glue. Lemma 2 below gives the elementary version. $\mathcal{D}$ is the sheafification of the presheaf $U \mapsto K^\times/\mathcal{O}(U)^\times$, i.e. the sheaf of Cartier divisors, and there is an exact sequence of sheaves
$$0 \to \mathcal{O}^\times \to K^\times \to \mathcal{D} \to 0 .$$

Because $R$ is Dedekind (normal of dimension one), Cartier divisors are Weil divisors:
$$\mathcal{D} \cong \bigoplus_{\mathfrak{p}} (i_\mathfrak{p})_*\mathbb{Z}, \qquad \Gamma(X,\mathcal{D}) = \bigoplus_\mathfrak{p} \mathbb{Z}.$$

The second isomorphism *is* unique factorization of fractional ideals. So the "automatic patching" step in Cassels–Fröhlich is the computation of the global sections of $\mathcal{D}$.

Note that the presheaf $K^\times/\mathcal{O}^\times$ is **not** a sheaf. A fractional ideal that is principal on each member of an open cover need not be principal. This is why the glued index need not be principal; see §4.

---

## 2. The descent with a finite Zariski cover

**Lemma 1 (local freeness).** There are $f_1,\dots,f_r \in R$ with $(f_1,\dots,f_r) = R$ such that $M_{f_i}$ and $N_{f_i}$ are free $R_{f_i}$-modules for every $i$.

*Proof.* A finitely generated torsion-free module over a Dedekind domain is projective. A finitely generated projective module over a noetherian ring is locally free on standard opens: for each $\mathfrak{p}$ there is $f \notin \mathfrak{p}$ with $M_f$ free, and likewise $g \notin \mathfrak{p}$ with $N_g$ free. Then $M_{fg}$ and $N_{fg}$ are both free. Since $X$ is quasi-compact, finitely many such $D(fg)$ cover $X$. $\square$

**Construction.**

1. **Local index.** For each $i$, choose $\sigma_i \in GL(V)$ with $\sigma_i(M_{f_i}) = N_{f_i}$, i.e. $\sigma_i$ maps an $R_{f_i}$-basis of $M_{f_i}$ to one of $N_{f_i}$. Put
   $$\mathfrak{a}_i = R_{f_i}\cdot \det\sigma_i \in \mathcal{D}(D(f_i)).$$
2. **Compatibility on overlaps.** On $D(f_if_j)$, both $\sigma_i$ and $\sigma_j$ map $M_{f_if_j}$ onto $N_{f_if_j}$. So $\sigma_j^{-1}\sigma_i \in \operatorname{Aut}(M_{f_if_j}) \cong GL_n(R_{f_if_j})$, and $\det\sigma_j^{-1}\sigma_i \in R_{f_if_j}^\times$. Hence
   $$\mathfrak{a}_i R_{f_if_j} = \mathfrak{a}_j R_{f_if_j}.$$
   No cocycle condition is needed. The $\mathfrak{a}_i$ are *subobjects of the fixed object* $K$, not abstract modules glued along isomorphisms, so agreement on overlaps is all that gluing requires.
3. **Glue.** By Lemma 2, there is a unique invertible fractional ideal $\mathfrak{a}$ with $\mathfrak{a}_{f_i} = \mathfrak{a}_i$ for all $i$, namely $\mathfrak{a} = \bigcap_i \mathfrak{a}_i$. Define $[M:N] = \mathfrak{a}$.

**Lemma 2 (gluing fractional ideals).** Let $(f_1,\dots,f_r) = R$, and let $\mathfrak{a}_i \subset K$ be invertible $R_{f_i}$-submodules with $\mathfrak{a}_i R_{f_if_j} = \mathfrak{a}_j R_{f_if_j}$ for all $i,j$. Then $\mathfrak{a} = \bigcap_i \mathfrak{a}_i$ is an invertible fractional ideal of $R$ with $\mathfrak{a}_{f_k} = \mathfrak{a}_k$ for all $k$, and it is the only one.

*Proof.* The inclusion $\mathfrak{a}_{f_k} \subseteq \mathfrak{a}_k$ holds because $\mathfrak{a} \subseteq \mathfrak{a}_k$ and $\mathfrak{a}_k$ is an $R_{f_k}$-module.

For the converse, let $x \in \mathfrak{a}_k$. For each $i$,
$$x \in \mathfrak{a}_k R_{f_kf_i} = \mathfrak{a}_i R_{f_kf_i} = (\mathfrak{a}_i)_{f_k},$$
so $f_k^{m} x \in \mathfrak{a}_i$ for $m \gg 0$. Taking $m$ large enough for all finitely many $i$ gives $f_k^m x \in \mathfrak{a}$, so $x \in \mathfrak{a}_{f_k}$.

A module that is finitely generated on a finite standard open cover is finitely generated, and $\mathfrak{a}$ is locally principal, hence invertible. Uniqueness: a fractional ideal is the intersection of its localizations, so it is determined by its restrictions to a cover. $\square$

**Independence of choices.**
- Changing $\sigma_i$ changes $\det\sigma_i$ by a unit of $R_{f_i}$, as in step 2.
- Changing the cover: pass to the common refinement $\{D(f_ig_j)\}$. The glued ideals agree there, so they agree by uniqueness in Lemma 2.

**Agreement with Cassels–Fröhlich.** If $\mathfrak{p} \in D(f_i)$, then $\sigma_i$ maps $M_\mathfrak{p}$ onto $N_\mathfrak{p}$. So
$$\mathfrak{a}_\mathfrak{p} = R_\mathfrak{p}\det\sigma_i = [M_\mathfrak{p}:N_\mathfrak{p}].$$
Both definitions give fractional ideals with the same localizations at every prime, so they are equal.

---

## 3. Cassels–Fröhlich's construction as a finite cover

Cassels–Fröhlich glue along the "pro-cover" $\{\operatorname{Spec} R_\mathfrak{p}\}$, which is not an open cover. Here is how to turn it into a finite Zariski cover.

Since $M$ and $N$ span the same $V$ and are finitely generated, there is a nonzero $d \in R$ with $dM \subseteq N$ and $dN \subseteq M$.

- On $U_0 = D(d)$, $M_d = N_d$. So the local index there is the unit ideal, and $M_\mathfrak{p} = N_\mathfrak{p}$ for all $\mathfrak{p} \nmid d$. This is the "almost all $\mathfrak{p}$" statement.
- For each of the finitely many $\mathfrak{p} \mid d$, choose a standard open neighbourhood $D(f_\mathfrak{p})$ on which $M$ and $N$ are free (Lemma 1).

The overlaps of this cover only carry information already visible at the generic point, where both $M$ and $N$ become $V$. That is why no patching data ever has to be checked by hand.

---

## 4. Why the index need not be principal

Each local index $\mathfrak{a}_i$ is principal, but they are sections of the presheaf $K^\times/\mathcal{O}^\times$. The glued $\mathfrak{a}$ is only a section of its sheafification $\mathcal{D}$. The long exact sequence
$$K^\times \to \Gamma(X,\mathcal{D}) \xrightarrow{\ \partial\ } H^1(X,\mathcal{O}^\times) = \operatorname{Pic} R \to 0$$
identifies the obstruction to principality with the ideal class of $\mathfrak{a}$.

Write $\operatorname{St}(M) = [\Lambda^n_R M] \in \operatorname{Pic} R = \operatorname{Cl}(R)$ for the Steinitz class of $M$. By §5, $\Lambda^n N = [M:N]\cdot\Lambda^n M$, so
$$\text{class of } [M:N] = \operatorname{St}(N) - \operatorname{St}(M) \quad\text{in } \operatorname{Cl}(R).$$

By Steinitz's theorem, two lattices of the same rank are isomorphic iff their Steinitz classes agree. So:
$$[M:N] \text{ is principal} \iff M \cong N \text{ as } R\text{-modules}.$$

---

## 5. The global object: the determinant line

The descent in §2 reconstructs something that already exists globally.

Since $M$ is projective of rank $n$, $\Lambda^n_R M$ is an invertible $R$-module. It is torsion-free with $\Lambda^n_R M \otimes_R K = \Lambda^n_K V$, so it embeds in the one-dimensional $K$-space $L = \Lambda^n_K V$. The same holds for $N$.

Fix $0 \ne \omega \in L$. Then $\Lambda^n M = \mathfrak{b}_M\,\omega$ and $\Lambda^n N = \mathfrak{b}_N\,\omega$ for fractional ideals $\mathfrak{b}_M, \mathfrak{b}_N$. The ideal $\mathfrak{b}_N\mathfrak{b}_M^{-1}$ does not depend on $\omega$.

**Proposition.** $[M:N] = \mathfrak{b}_N\mathfrak{b}_M^{-1}$. In other words, $[M:N]$ is characterized, without any choices, by
$$\boxed{\ \Lambda^n N = [M:N]\cdot \Lambda^n M \quad\text{inside } \Lambda^n_K V.\ }$$

*Proof.* Both sides are compatible with localization, because $\Lambda^n$ commutes with flat base change. So it suffices to check on $D(f_i)$. There, take a basis $e_1,\dots,e_n$ of $M_{f_i}$. Then $\sigma_i e_1,\dots,\sigma_i e_n$ is a basis of $N_{f_i}$, and
$$\Lambda^n N_{f_i} = R_{f_i}\,\sigma_ie_1\wedge\dots\wedge\sigma_ie_n = R_{f_i}\det\sigma_i\cdot e_1\wedge\dots\wedge e_n = \mathfrak{a}_i\cdot\Lambda^n M_{f_i}. \qquad\square$$

So the local definition is the global one written in local trivializations. The descent says that $\det = \Lambda^n$ is a functor on lattices that commutes with localization, so the transition data between trivializations, i.e. the units $\det(\sigma_j^{-1}\sigma_i)$, are trivial in $\mathcal{D}$.

### Formal consequences

With the boxed characterization, the standard properties need no localization:

- **Multiplicativity:** $[L:M]\,[M:N] = [L:N]$ for lattices $L, M, N$ in $V$. In particular $[M:M] = R$ and $[N:M] = [M:N]^{-1}$.
- **Functoriality:** $[\tau M : \tau N] = [M:N]$ for $\tau \in GL(V)$, and $[M : \tau M] = R\cdot\det\tau$ when $M$ is free. For general $M$ the second formula still holds, since $\Lambda^n(\tau M) = \det\tau\cdot\Lambda^n M$.
- **Comparison with the order ideal:** if $N \subseteq M$, then
  $$[M:N] = \operatorname{Fitt}_0(M/N) = \prod_\mathfrak{p} \mathfrak{p}^{\,\operatorname{length}_{R_\mathfrak{p}}(M/N)_\mathfrak{p}},$$
  the order ideal of the torsion module $M/N$. Locally, $M_\mathfrak{p}/N_\mathfrak{p}$ is presented by the matrix of $\sigma_\mathfrak{p}$, so its zeroth Fitting ideal is $(\det\sigma_\mathfrak{p})$. Over a DVR this equals $\mathfrak{p}^{\text{length}}$ by elementary divisors.

The last formula is a special case of the Knudsen–Mumford determinant of the two-term complex $N \to M$. The index is the divisor of $\det(M/N)$.

---

## Summary

$[M:N]$ is a global section of the divisor sheaf $\mathcal{D} = K^\times/\mathcal{O}^\times$. It is obtained by gluing the locally defined classes $\det\sigma \bmod$ units over a Zariski cover on which $M$ and $N$ are free.

- The gluing condition is the same fact that makes the classical definition well defined: a change of basis has unit determinant.
- "Patching by unique factorization" is the computation $\Gamma(X,\mathcal{D}) = \bigoplus_\mathfrak{p}\mathbb{Z}$.
- The failure of the presheaf $K^\times/\mathcal{O}^\times$ to be a sheaf, measured by $\operatorname{Pic} R$, is why $[M:N]$ need not be principal. Its class is $\operatorname{St}(N) - \operatorname{St}(M)$.
- The descended object is the ratio of the determinant lines: $\Lambda^n N = [M:N]\cdot\Lambda^n M$.
