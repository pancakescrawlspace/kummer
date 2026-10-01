# Are the six circles jammed?

**Setup.** This continues the note on rigid circle packings in a rectangle (`kummer/circle-packings.typ`). There, a packing of $n$ circles in a rectangle $[0,W]\times[0,1]$ was studied through its *tangency map*
$$F\colon \mathbb{R}^{3n+1} \to \mathbb{R}^m, \qquad z = (\text{centres}, \text{radii}, W) \mapsto (\text{one gap per tangency}).$$
Each entry of $F$ is the gap of one tangency, which is $0$ when the two objects touch. "Rigid" meant that the *pattern* of tangencies determines the packing, with the radii and the width free to change. For triangulated packings (every gap a curvilinear triangle) this holds by Koebe–Andreev–Thurston, and the Jacobian $J = DF$ is square and invertible.

**The question.** Physically, one asks something different. Fix the radii and the box, and let the circles move. A tangency may then *open*, but no two circles may overlap and no circle may leave the box. Can the circles move at all? If they cannot, the packing is **jammed**.

**Answer: yes, the six circles are jammed, in the strongest of the usual senses.** They stay stuck even if the box may change shape without growing in area. The same holds for every packing in the earlier note, including the non-triangulated ones that were flexible when the radii were free. So jamming is a much weaker property than rigidity of the pattern. For triangulated packings, half of jamming follows from the invertibility of $J$ (§4). The other half, the existence of a positive stress, held in every case tested, but I have no proof.

---

## 1. Rigidity and jamming in one framework

Both questions are about a constraint map and its Jacobian. They differ in which variables are free and whether the constraints are equalities.

| | rigidity of the pattern | jamming |
|---|---|---|
| free variables | centres, radii, $W$ ($3n+1$) | centres only ($2n$), plus $W, H$ for strict jamming |
| constraints | tangencies as **equalities** | tangencies as **inequalities** (gaps $\ge 0$) |
| first-order motions | $J v = 0$ | $A v \ge 0$ |
| obstruction to motion | full rank of $J$ | full rank of $A$ **and** a positive stress |

Here $A$ is the block of $J$ belonging to the centre variables. A tangency between circles $i$ and $j$, with unit normal $u$ from $i$ to $j$, gives the row $(v_j - v_i)\cdot u \ge 0$. A circle on the bottom or left side gives $v_{iy} \ge 0$ or $v_{ix} \ge 0$, and a circle on the top or right side gives $-v_{iy} \ge 0$ or $-v_{ix} \ge 0$. In the language of rigidity theory, a packing with fixed radii is a **tensegrity**: every contact is a *strut*, a bar that may lengthen but not shorten.

The usual notions, after Torquato and Stillinger:

- **Locally jammed:** each circle is trapped by its neighbours when all other circles are frozen.
- **Collectively jammed:** no collective motion of the circles in the fixed box.
- **Strictly jammed:** also no motion when the box may change shape without growing in area. With the corner fixed at the origin, this adds the variables $dW, dH$. The top and right rows become $dH - v_{iy} \ge 0$ and $dW - v_{ix} \ge 0$, and there is one extra row $-(H\,dW + W\,dH) \ge 0$.

---

## 2. For packings, first order is enough

**Lemma.** If $v \ne 0$ satisfies $A v \ge 0$, then the straight-line motion $z + t v$ is an honest motion of the packing for small $t > 0$.

*Proof.* Let $d$ be the vector between two touching centres and $e$ its rate of change. Then
$$|d + t e|^2 = |d|^2 + 2t\, d\cdot e + t^2 |e|^2 \ge |d|^2$$
whenever $d \cdot e \ge 0$, and the quadratic term only helps. The wall constraints are linear. Pairs that do not touch have a positive gap, which survives for small $t$. For strict jamming the area changes by $t(H\,dW + W\,dH) + t^2\,dW\,dH$. If the linear term is $0$, then $dW$ and $dH$ have opposite signs, so the quadratic term is $\le 0$. The box is pinned at a corner, so there are no trivial motions left. $\square$

Conversely, if there is no nonzero first-order motion there is no motion at all: infinitesimal rigidity of a tensegrity implies rigidity (Roth–Whiteley). So
$$\text{jammed} \iff \{v : A v \ge 0\} = \{0\} \iff \ker A = 0 \ \text{ and }\ \exists\, w > 0 \text{ with } w^{\mathsf T} A = 0 .$$
The second equivalence is Stiemke's theorem of the alternative applied to $A$. A vector $w$ with $w^{\mathsf T} A = 0$ is a **self-stress**. When all its entries are positive, it is a set of contact forces, every one of them pushing, that are in equilibrium at every circle. For frictionless disks the forces are normal, so they pass through the centres and there is no torque condition.

So jamming is decided by one rank computation and one linear programme.

---

## 3. The six circles

Collective jamming has $m = 19$ contacts and $N = 12$ unknowns. $A$ has full rank $12$, with smallest singular value $0.771$. The stresses form a space of dimension $19 - 12 = 7$. The linear programme maximising the smallest entry of $w$, with the entries summing to $1$, gives $\min_k w_k = 0.0416 > 0$. The primal programme, which looks for a first-order motion that opens a contact, has value $0$, as Stiemke's theorem requires.

One strictly positive stress, scaled so that the largest force is $1$:

| contact | force | contact | force |
|---|---|---|---|
| $A$–$B$ | 0.742 | $B'$–$A'$ | 0.742 |
| $A$–$C'$ | 0.601 | $C$–$A'$ | 0.601 |
| $A$–$B'$ | 0.601 | $B$–$A'$ | 0.601 |
| $B$–$C$ | 0.601 | $C'$–$B'$ | 0.601 |
| $B$–$B'$ | 0.601 | | |
| $A$–left | 1.000 | $A'$–right | 1.000 |
| $A$–top | 0.997 | $A'$–bottom | 0.997 |
| $B$–top | 0.997 | $B'$–bottom | 0.997 |
| $C$–top | 0.665 | $C'$–bottom | 0.665 |
| $C$–right | 0.716 | $C'$–left | 0.716 |

This particular stress is invariant under the half-turn, but stresses are far from unique. Any positive combination of positive stresses is again one.

**Strict jamming** has $m = 20$ (the area row included) and $N = 14$. $A$ again has full rank, the stress space has dimension $6$, and the best smallest entry is $0.0369 > 0$. Every circle is also locally jammed.

---

## 4. All the packings of the earlier note

| packings | $m$ | $N$ | collectively | strictly | locally |
|---|---|---|---|---|---|
| six circles | 19 | 12 | yes | yes | yes |
| all 28 two-row zigzags, $k = 2, 3, 4$ | $6k+1$ | $4k$ | yes | yes | yes |
| three rows (two circles touching no side) | 25 | 16 | yes | yes | yes |
| six circles $+$ 4 inserted circles | 31 | 20 | yes | yes | yes |
| six circles minus $BB'$, 8 members of the family | 18 | 12 | yes | yes | yes |
| *control:* one disk in a $2\times1$ box, touching 3 sides | 3 | 2 | **no** | **no** | **no** |
| *control:* six circles with $B$ shrunk to a rattler | 14 | 12 | **no** | **no** | **no** |

The last two rows are sanity checks of the test. The packings without the tangency $BB'$ are the interesting ones. With the radii free they move in a one-parameter family: $18$ equations on $19$ unknowns. With the radii and the box fixed, each one is jammed: the same $18$ contacts, now inequalities, on only $12$ unknowns.

**What follows in general.** Let $P$ be a triangulated packing, so that $J$ is square and invertible.

*Proposition.* $\ker A = 0$, and the stresses of $A$ form a space of dimension exactly $n + 1$.

*Proof.* Order the variables as centres, radii, $W$, so that $J = [\,A \mid J_r \mid J_W\,]$. The columns of an invertible matrix are independent, so in particular the $2n$ columns of $A$ are. For the stresses, $w \mapsto w^{\mathsf T} J$ is a bijection $\mathbb{R}^{3n+1} \to \mathbb{R}^{3n+1}$. It carries the stresses of $A$, those $w$ with $w^{\mathsf T} A = 0$, onto the vectors supported on the $n + 1$ radius and width coordinates. $\square$

So for a triangulated packing, jamming comes down to whether this $(n+1)$-dimensional space of stresses contains a vector with all entries positive.

*Conjecture.* Every triangulated packing in a rectangle is strictly jammed. It held for all $31$ triangulated packings tested. A proof would presumably need a variational characterisation of the Koebe–Andreev–Thurston packing, in which the positive stress appears as a Lagrange multiplier.

The converse fails: the family without $BB'$ consists of jammed packings that are not triangulated.

---

## 5. Remarks

- **Numerics.** The ranks are numerical (singular values above $10^{-9}$), and the stresses come from floating-point linear programmes (HiGHS). The margins are comfortable: for the six circles the smallest singular value is $0.77$, and the best positive stress has smallest entry $0.04$ against a total of $1$. An exact certificate is possible, because the stress conditions are linear over the degree-$6$ field of the configuration. This has not been done.
- **The tensegrity viewpoint explains the earlier one-sided family.** After $BB'$ is dropped, the family in which the radii vary exists only on the side where $B$ and $B'$ separate. That is exactly the behaviour of a strut.
- **Stresses and rigidity theory.** By the proposition in §4, the $n+1$ stresses of a triangulated packing correspond to the "loads" on the radii and the width. This is the linear-algebra shadow of the fact that the triangulated pattern fixes all the radii.

## References

- B. Roth, W. Whiteley, *Tensegrity frameworks*, Trans. Amer. Math. Soc. **265** (1981).
- R. Connelly, *Rigid circle and sphere packings. Part I: Finite packings*, Structural Topology **14** (1988).
- S. Torquato, F. H. Stillinger, *Multiplicity of generation, selection, and classification procedures for jammed hard-particle packings*, J. Phys. Chem. B **105** (2001).
- A. Donev, S. Torquato, F. H. Stillinger, R. Connelly, *A linear programming algorithm to test for jamming in hard-sphere packings*, J. Comput. Phys. **197** (2004).

Script: [`scripts/circle-jamming.py`](scripts/circle-jamming.py), output in [`scripts/circle-jamming.txt`](scripts/circle-jamming.txt). It reads the packings from `kummer/circle-packings.json`, so run `kummer/circle-packings.py` first if that file has changed.
