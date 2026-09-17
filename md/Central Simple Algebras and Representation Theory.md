# Central Simple Algebras and Representation Theory

*Notes from a conversation with Claude, 17 September 2026. Companion to "How Central Simple Algebras Entered Number Theory", whose §2(c) sketches the representation-theoretic strand of the history. First written from memory, then checked online. Markers:*

- **[G]** J. A. Green's memoir of Brauer, *Biographical Memoirs of the National Academy of Sciences* (online at nasonline.org; see *Sources*).
- **[E]** Encyclopedia of Mathematics, article "Schur group".
- **[W]** Checked online against publisher, journal or library records (see *Sources* at the end).
- *(unchecked)* Still from memory.

*Mathematical statements are standard textbook material (Curtis–Reiner, Isaacs, Yamada) and are not individually marked.*

---

## The question

Brauer came to central simple algebras from Schur's theory of group representations, and Noether wanted representation theory absorbed into the theory of algebras. What was the connection, and what did the theory of algebras give back to representation theory?

**Short answer.** The group algebra K[G] of a finite group is semisimple, so by Wedderburn it is a product of matrix algebras over division algebras. Over ℂ the division algebras are all ℂ, and one gets the classical character theory. Over a smaller field K they need not be, and the division algebra attached to an irreducible character χ is precisely the obstruction to writing the representation with matrix entries in the character field K(χ). Its index is **Schur's index** m_K(χ), its class in the Brauer group is what Brauer set out to understand, and the deepest results about it (Brauer–Speiser, Brauer–Witt, Benard–Schacher, Roquette, Yamada) are applications of the Brauer group over number fields, i.e. of Brauer–Hasse–Noether.

---

## 1. Wedderburn decomposition of the group algebra

Let G be finite and K a field with char K ∤ |G|. Maschke's theorem says K[G] is semisimple, so Wedderburn gives

  K[G] ≅ ∏ᵢ M_{rᵢ}(Dᵢ),

with Dᵢ division algebras, finite-dimensional over K. Each factor is a simple algebra whose center Kᵢ = Z(Dᵢ) is a finite extension of K, and Dᵢ is a central simple Kᵢ-algebra of index mᵢ. The simple K[G]-modules are the column spaces Dᵢ^{rᵢ}, one for each factor.

Over ℂ (or any algebraically closed field) every Dᵢ = ℂ and every Kᵢ = ℂ; the factors are M_{nᵢ}(ℂ) with nᵢ = χᵢ(1), and Σ nᵢ² = |G|. The whole content of the theory of algebras in representation theory lies in what happens when K is not algebraically closed, in which case two independent things can go wrong:

1. **The center can grow:** Kᵢ ≠ K. This is the commutative phenomenon: the character values generate a bigger field.
2. **The division algebra can be noncommutative:** Dᵢ ≠ Kᵢ. This is the phenomenon the Brauer group measures.

---

## 2. Character fields and the Schur index

Fix an absolutely irreducible character χ of G (a character of an irreducible ℂ[G]-module) and a field K ⊆ ℂ. The **character field** is K(χ) = K(χ(g) : g ∈ G), a finite abelian extension of K inside a cyclotomic field. The simple component of K[G] whose simple module has χ as a constituent is

  A_χ = M_r(D),  Z(A_χ) = K(χ),  D central division over K(χ) of index m.

Here m = m_K(χ) is the **Schur index** of χ over K, and r·m = χ(1). The simple K[G]-module in this component has character

  m · Σ_{τ ∈ Gal(K(χ)/K)} χ^τ.

Both phenomena of §1 are visible here: the Galois sum is the growth of the center, and the multiplicity m is the division algebra.

**Equivalent descriptions of m_K(χ).** These are all the same number, and their equivalence is exactly Wedderburn theory applied to A_χ:

- The index of the division algebra D, i.e. √dim_{K(χ)} D.
- The smallest multiple m such that mχ is the character of a representation defined over K(χ).
- The smallest degree [L : K(χ)] of a field L ⊇ K(χ) over which a representation with character χ can be written (a field of realisation, or *Darstellungskörper*), where L ranges over the maximal subfields of D. (Schur's original definition, in his 1906 *Arithmetische Untersuchungen* [W].)
- The minimal L-dimension of an A_χ-module, in the sense of the "Key fact from this viewpoint" passage in the companion note.

**Splitting fields.** L ⊇ K is a splitting field for G if every Dᵢ ⊗ L is a matrix algebra, i.e. every irreducible representation of G can be written over L. Then m_L(χ) = 1 for all χ. Every field of realisation is a splitting field for the relevant component, but minimal splitting fields need not be fields of realisation and need not have degree m: this is the content of the 1927 Brauer–Noether–Hasse episode about minimal splitting fields of the quaternions (companion note, §2(c)), which in representation-theoretic terms is about the 2-dimensional representation of the quaternion group. Green describes the Brauer–Noether note of 1927 as characterising "Schur's splitting fields" of an irreducible representation in terms of the associated division algebra, and says flatly that Brauer's theory of simple algebras "was the result of Brauer's studies on the Schur index of a representation" [G].

**The basic example: Q₈.** The quaternion group Q₈ = {±1, ±i, ±j, ±k} has four linear characters and one character χ of degree 2, with values χ(±1) = ±2 and χ = 0 elsewhere. So ℚ(χ) = ℚ. But the representation cannot be written over ℚ, or even over ℝ:

  ℚ[Q₈] ≅ ℚ⁴ × (−1, −1)_ℚ,  ℝ[Q₈] ≅ ℝ⁴ × ℍ.

The last factor is Hamilton's quaternion algebra, the division algebra generated by i, j with i² = j² = −1, ij = −ji. So m_ℚ(χ) = m_ℝ(χ) = 2, and the representation can be written over ℚ(i) (i ↦ diag(i, −i), j ↦ the matrix (0, 1; −1, 0)) but not over any real field.

The Brauer-group point of view makes this precise. The class of (−1, −1)_ℚ in Br(ℚ) has local invariants ½ at 2 and ∞ and 0 elsewhere. A number field L is a field of realisation exactly when it splits the quaternion algebra, i.e. when every place of L above 2 and above ∞ has even local degree. So ℚ(i), ℚ(√−2), ℚ(√−3) work; ℚ(√2) (real places) and ℚ(√−7) (2 splits) do not; and there are minimal fields of realisation of arbitrarily large degree, which is what Hasse showed Noether in October 1927.

---

## 3. Br(ℝ) and the Frobenius–Schur indicator

The simplest case is K = ℝ, where Br(ℝ) = {ℝ, ℍ} ≅ ℤ/2. For an irreducible complex character χ, the component of ℝ[G] is one of

  M_n(ℝ),  M_{n/2}(ℍ),  M_n(ℂ)  (the last when χ is not real-valued, with ℝ(χ) = ℂ),

and Frobenius and Schur (1906) [W] showed which one it is:

  ν(χ) = (1/|G|) Σ_{g ∈ G} χ(g²) ∈ {1, −1, 0}.

The three values correspond to the three cases (**real**, **quaternionic**, **complex** type). So the Frobenius–Schur indicator is a formula for the class of A_χ in Br(ℝ), and ν(χ) = −1 says exactly that m_ℝ(χ) = 2. For Q₈, ν(χ) = (2·2 + 6·(−2))/8 = −1.

This is the first instance of a pattern that recurs throughout: an invariant of the representation, computable from the character, equals a Brauer-group invariant of the simple component. The same trichotomy governs irreducible representations of compact groups in general and appears in physics as Dyson's "threefold way" (1962) [W], which classifies random-matrix ensembles by whether the symmetry algebra is real, complex or quaternionic.

---

## 4. Factor systems came from projective representations

The 2-cocycles that Noether's crossed products are built from did not originate in the theory of algebras. They originated in Schur's work on **projective representations** (Crelle 127, 1904, and 132, 1907) [W]. A homomorphism G → PGL_n(ℂ) lifts to a map ρ: G → GL_n(ℂ) with

  ρ(g)ρ(h) = α(g, h)·ρ(gh),  α(g, h) ∈ ℂ*,

and associativity forces α to be a 2-cocycle. Schur studied the group H²(G, ℂ*), now the **Schur multiplier**, and showed it is finite. A projective representation with cocycle α is the same thing as a module over the **twisted group algebra** ℂ^α[G], the algebra with basis u_g and multiplication u_g u_h = α(g, h) u_{gh}.

This is a crossed product with trivial Galois action: the "field" is ℂ acted on trivially by G, and the twisting is all in the factor system. Noether's crossed product (L/K, G, a) is the case where the group also acts nontrivially on the coefficient field. Both special cases are important and the general object, a crossed product of a G-ring with a cocycle, contains both.

Twisted group algebras come up unavoidably in **Clifford theory**: for N ◁ G and an irreducible representation V of N stable under G, the algebra End_N(Ind_N^G V) is a twisted group algebra of G/N over the field of definition, with a cocycle in H²(G/N, K*) measuring the obstruction to extending V to G. So the crossed products of class field theory and the twisted group algebras of representation theory are the same construction seen from two sides, and this is presumably part of what Noether meant by absorbing representation theory into the theory of algebras.

---

## 5. Brauer's theorems on splitting fields and induced characters

**The splitting-field theorem.** Brauer (Amer. J. Math. 67, 1945) [W] proved that ℚ(ζ_g) with g = |G| is a splitting field for G, i.e. every irreducible representation of G can be written over the g-th roots of unity. The sharper statement, with the exponent e of G in place of |G|, follows from:

**Brauer's induction theorem** (announced 1946, published 1947 in Ann. of Math. 48 and Amer. J. Math. 69) [W]. Every character of G is a ℤ-linear combination of characters induced from one-dimensional characters of *elementary* subgroups (direct products of a cyclic group and a p-group). One-dimensional characters take values in ℚ(ζ_e), and induction preserves fields of definition, so every character is a virtual combination of characters realisable over ℚ(ζ_e). A representation whose character is a virtual combination of characters realisable over L is itself realisable over L (this needs m_L(χ) = 1 whenever χ appears with multiplicity 1 in something realisable over L, which is where Schur index theory enters), and the exponent version of the splitting-field theorem follows. Brauer and Tate (Ann. of Math. 62, 1955) [W] gave a cleaner proof of the induction theorem. Brauer also treated splitting fields of simple algebras in general in "On splitting fields of simple algebras" (Ann. of Math. 48, 1947) [W].

**Application outside representation theory.** Brauer's induction theorem is what proves that Artin L-functions L(s, χ) of arbitrary Galois representations are meromorphic on ℂ: for one-dimensional χ, L(s, χ) is a Hecke L-function (by Artin reciprocity), and the induction theorem writes a general L(s, χ) as a product of integer powers of Hecke L-functions. So the representation theory Brauer developed to understand Schur indices was also the tool that connected Artin's reciprocity law to L-functions of nonabelian extensions. Green dates the Artin–Brauer collaboration to Brauer's 1942 visit to Artin in Bloomington and notes that this work earned Brauer the Cole Prize in 1949 [G].

---

## 6. Schur indices over number fields: applications of Brauer–Hasse–Noether

Over a number field K, the Brauer group is described by the exact sequence of the companion note, §2(f):

  0 → Br(K) → ⊕_v Br(K_v) → ℚ/ℤ → 0,

and index equals exponent. Applied to A_χ ∈ Br(K(χ)) this gives a sequence of results about Schur indices, each of which reads the Brauer group back into representation theory.

**Local-global for the Schur index.** m_K(χ) is the least common multiple of the local Schur indices m_{K(χ)_v}(χ), and the local index at v is the order of the invariant of A_χ ⊗ K(χ)_v. Moreover:

- At a real place v of K(χ), the local index is 1 or 2 according to the Frobenius–Schur indicator (§3).
- At a finite place v above p with p ∤ |G|, the local index is 1. Reason: K(χ)_v[G] has a maximal order that reduces to the group algebra over the residue field, which is semisimple since p ∤ |G|, and the Brauer group of a finite field is trivial (Wedderburn's little theorem). So only the primes dividing |G| and the real places contribute.

**Brauer–Speiser.** If χ is real-valued then m_ℚ(χ) ≤ 2. Modern proof: χ real means the representation is isomorphic to its contragredient, and the contragredient corresponds to the opposite algebra, so A_χ ≅ A_χ^op and [A_χ]² = 1 in Br(ℚ(χ)). So the exponent is ≤ 2, and over a number field index = exponent. (Speiser, Math. Z. 5, 1919, pp. 1–6, immediately followed by a note of Schur on the same paper, pp. 7–10 [W]; Brauer returned to it in "On hypercomplex arithmetic and a theorem of Speiser", Speiser Festschrift, 1945 [G]. The original proofs predate BHN. What exactly Speiser's paper proves was not checked.)

**Roquette's theorem** (Arch. Math. 9, 1958) [W]. For a p-group G with p odd, m_K(χ) = 1 for every χ and every field K of characteristic 0. For a 2-group, m_K(χ) ≤ 2, with the quaternion group of order 8 the smallest example of index 2 [W]. This is the same Roquette whose historical account underlies the companion note.

**Brauer–Witt.** Define the **Schur subgroup** S(K) ⊆ Br(K) as the set of classes of simple components A_χ of K[G], over all finite G and all χ with K(χ) = K. Brauer (J. Math. Soc. Japan 3, 1951) and Witt (Crelle 190, 1952) [W] showed that S(K) is a subgroup and that every class in it is represented by a **cyclotomic algebra**: a crossed product (K(ζ)/K, G, a) with ζ a root of unity and the cocycle a taking values in roots of unity. Their theorem reduces the computation of m_K(χ) for arbitrary G to "K-elementary" subgroups, where the simple components are explicitly cyclotomic algebras. This is representation theory's own "every division algebra is cyclic": not every class in Br(K) comes from a group algebra, but those that do are of the most explicit possible kind.

**Benard–Schacher** (J. Algebra 22, 1972) [W, E]. If m = m_ℚ(χ) then ζ_m ∈ ℚ(χ); more generally m_K(χ) divides the number of roots of unity in K(χ) [E]. The same circle of ideas gives that the local indices of A_χ at the primes of K(χ) above a given rational prime are all equal *(unchecked as to attribution)*. This is a strong constraint: for a general class in Br(K) the local invariants at conjugate primes are unrelated.

**Yamada** (Lecture Notes in Math. 397, 1974) [W]. The Schur subgroup S(K) is computed for local and global fields K. For a p-adic field K, S(K) is finite: its order divides the ramification index of K(ζ_p)/K for p odd, and of K(ζ₄)/K for p = 2 [E]. This is in sharp contrast to Br(K) ≅ ℚ/ℤ, so most local division algebras never arise from group representations.

---

## 7. Characteristic p: where the Brauer group disappears

Brauer's later work (from the 1930s, with Nesbitt) took the theory of algebras into characteristic p dividing |G|, where k[G] is no longer semisimple. Wedderburn's theorem applies only to k[G]/rad, but the general theory of algebras (idempotents, projective modules, blocks) is exactly the tool needed, and modular representation theory is built on it.

One point deserves emphasis here. Over a finite field there is **no Schur index**: Br(𝔽_q) = 0 by Wedderburn's little theorem, so every irreducible representation over 𝔽̄_p is realisable over the field generated by its Brauer character values. All the subtlety of §2 and §6 is a characteristic-0 phenomenon, and its disappearance modulo p is one reason Brauer characters and decomposition numbers can be defined so cleanly.

---

## 8. Summary of the two-way traffic

Representation theory → theory of algebras:

- Factor systems and the Schur multiplier (Schur 1904) are the prototype of the 2-cocycles in Noether's crossed products.
- The Schur index (Schur 1906) is the index of a central simple algebra, and Brauer's group was invented to organise Schur indices (Brauer 1928–29; "the result of Brauer's studies on the Schur index of a representation" [G]).
- The 1927 splitting-field question about quaternions (Brauer, Noether, Hasse) is the nucleus of the local-global principle for algebras.

Theory of algebras → representation theory:

- Wedderburn: K[G] is a product of matrix algebras over division algebras; irreducible representations over K are governed by these division algebras.
- Br(ℝ) = ℤ/2 gives the real/complex/quaternionic trichotomy and the Frobenius–Schur indicator.
- Brauer–Hasse–Noether gives the local-global description of Schur indices, and index = exponent gives Brauer–Speiser.
- Brauer–Witt, Benard–Schacher and Yamada describe exactly which algebra classes arise from group representations.
- Wedderburn's little theorem: no Schur index in characteristic p.

---

## Standard references (not consulted for this note)

- C. W. Curtis and I. Reiner, *Methods of Representation Theory*, vol. I (Wiley, 1981), esp. the chapters on the Schur index and on Brauer's induction theorem.
- C. W. Curtis and I. Reiner, *Representation Theory of Finite Groups and Associative Algebras* (Wiley, 1962), §§70–74.
- I. M. Isaacs, *Character Theory of Finite Groups* (Academic Press, 1976), ch. 9–10 (Schur index, Brauer's theorems).
- W. Feit, *Characters of Finite Groups* (Benjamin, 1967).
- J.-P. Serre, *Linear Representations of Finite Groups* (Springer, 1977), Part II (rationality questions).
- I. Reiner, *Maximal Orders* (Academic Press, 1975).
- T. Yamada, *The Schur Subgroup of the Brauer Group*, Lecture Notes in Math. 397 (Springer, 1974).
- C. W. Curtis, *Pioneers of Representation Theory: Frobenius, Burnside, Schur and Brauer* (AMS/LMS, 1999).

## Historical account

- J. A. Green, "Richard Dagobert Brauer", *Biographical Memoirs of the National Academy of Sciences* (Washington, D.C., 1998), adapted from *Bull. London Math. Soc.* 10 (1978), 317–325 and 337–342. Online: https://www.nasonline.org/wp-content/uploads/2024/06/brauer-richard-d.pdf [G]

## Primary sources

- I. Schur, "Über die Darstellung der endlichen Gruppen durch gebrochene lineare Substitutionen", *J. reine angew. Math.* 127 (1904), 20–50. [W]
- I. Schur, "Untersuchungen über die Darstellung der endlichen Gruppen durch gebrochene lineare Substitutionen", *J. reine angew. Math.* 132 (1907), 85–137. [W]
- I. Schur, "Arithmetische Untersuchungen über endliche Gruppen linearer Substitutionen", *Sitzungsber. Preuß. Akad. Wiss. Berlin* (1906), 164–184. [W]
- G. Frobenius and I. Schur, "Über die reellen Darstellungen der endlichen Gruppen", *Sitzungsber. Preuß. Akad. Wiss. Berlin* (1906), 186–208. [W]
- A. Speiser, "Zahlentheoretische Sätze aus der Gruppentheorie", *Math. Z.* 5 (1919), 1–6; I. Schur, "Einige Bemerkungen zu der vorstehenden Arbeit des Herrn A. Speiser", ibid., 7–10. [W]
- R. Brauer and E. Noether, "Über minimale Zerfällungskörper irreduzibler Darstellungen", *Sitzungsber. Preuß. Akad. Wiss. Berlin* (1927), 221–228. [G]
- R. Brauer, "On hypercomplex arithmetic and a theorem of Speiser", *Festschrift for the 60th birthday of Andreas Speiser* (Zürich, 1945). [G]
- R. Brauer, "On the representation of a group of order g in the field of the g-th roots of unity", *Amer. J. Math.* 67 (1945), 461–471. [G, W]
- R. Brauer, "On splitting fields of simple algebras", *Ann. of Math.* 48 (1947), 79–90. [G]
- R. Brauer, "On Artin's L-series with general group characters", *Ann. of Math.* 48 (1947), 502–514. [G, W]
- R. Brauer, "Applications of induced characters", *Amer. J. Math.* 69 (1947), 709–716. [G]
- R. Brauer, "On the algebraic structure of group rings", *J. Math. Soc. Japan* 3 (1951). [W]
- E. Witt, "Die algebraische Struktur des Gruppenringes einer endlichen Gruppe über einem Zahlkörper", *J. reine angew. Math.* 190 (1952), 231–245. [W]
- R. Brauer and J. Tate, "On the characters of finite groups", *Ann. of Math.* 62 (1955), 1–7. [W]
- P. Roquette, "Realisierung von Darstellungen endlicher nilpotenter Gruppen", *Arch. Math.* 9 (1958), 241–250. [W]
- F. J. Dyson, "The Threefold Way. Algebraic Structure of Symmetry Groups and Ensembles in Quantum Mechanics", *J. Math. Phys.* 3 (1962), 1199–1215. [W]
- M. Benard and M. M. Schacher, "The Schur subgroup II", *J. Algebra* 22 (1972), 378–385. [W]
- T. Yamada, "The Schur subgroup of a 2-adic field", *J. Math. Soc. Japan* 26 (1974), 168–179. [W]

## Sources consulted online

- Green's memoir of Brauer (NAS): https://www.nasonline.org/wp-content/uploads/2024/06/brauer-richard-d.pdf
- Encyclopedia of Mathematics, "Schur group": https://encyclopediaofmath.org/wiki/Schur_group
- Schur 1907 (De Gruyter): https://www.degruyterbrill.com/document/doi/10.1515/crll.1907.132.85/html
- Speiser 1919 and Schur's reply (Springer): https://link.springer.com/article/10.1007/BF01203150 , https://link.springer.com/article/10.1007/BF01203151
- Witt 1952 (De Gruyter): https://www.degruyterbrill.com/document/doi/10.1515/crll.1952.190.231/html
- Brauer 1951 (Project Euclid): https://projecteuclid.org/euclid.jmsj/1261734968
- Roquette 1958 (Springer): https://link.springer.com/article/10.1007/BF01900587
- Roquette's theorem, statement: https://groupprops.subwiki.org/wiki/Odd-order_p-group_implies_every_irreducible_representation_has_Schur_index_one
- Benard–Schacher 1972: https://www.sciencedirect.com/science/article/pii/0021869372901548 (part I) and the Encyclopedia of Mathematics entry above
- Yamada, LNM 397 (Springer): https://link.springer.com/book/10.1007/BFb0061703
- Brauer's induction theorem (Wikipedia): https://en.wikipedia.org/wiki/Brauer%27s_theorem_on_induced_characters
- Dyson 1962 (ADS): https://ui.adsabs.harvard.edu/abs/1962JMP.....3.1199D/abstract
- History of projective representations (arXiv): https://arxiv.org/abs/1912.10235
