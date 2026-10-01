# Locus problems with answers of positive genus

**Question.** The classical locus problems usually lead to curves of genus $0$. For example, the centres of the circles tangent to two given circles fill two conics (see `circle-tangent-to-two-circles-locus.md`). Is there a natural locus problem whose answer is a curve of genus $> 0$?

**Answer.** Yes. Here are two classical examples, and both give **elliptic curves** (genus $1$):

1. **Cassini ovals.** The locus of points whose distances to two fixed points have a constant *product*.
2. **Coupler curves of a four-bar linkage.** The locus of a point carried by a rod whose two ends move on two fixed circles. Watt's curve is a special case.

Both have genus $1$ for generic data. In both, the genus drops to $0$ exactly when an extra node appears: for Cassini, the lemniscate of Bernoulli; for the linkage, the Grashof boundary. All genera below were checked in Sage with `md/scripts/locus-genus.sage`, and its output is in `md/scripts/locus-genus.txt`.

---

## 1. Cassini ovals

**Problem.** Given two points $A, B$, find the locus of the points $P$ with $|PA| \cdot |PB| = k^2$.

Put $A = (-c, 0)$ and $B = (c, 0)$ with $c, k > 0$. Squaring $|PA|^2 |PB|^2 = k^4$ and expanding gives
$$\bigl((x+c)^2 + y^2\bigr)\bigl((x-c)^2 + y^2\bigr) = k^4,$$
$$(x^2 + y^2)^2 - 2c^2(x^2 - y^2) + c^4 - k^4 = 0.$$

**Proposition.** For $k \ne c$ this quartic is irreducible of genus $1$. For $k = c$ it is the lemniscate of Bernoulli, which has genus $0$.

*Proof.* Use the isotropic coordinates $u = x + iy$ and $v = x - iy$. Then $x^2 + y^2 = uv$ and $x^2 - y^2 = \tfrac12(u^2 + v^2)$. The homogenised equation becomes
$$u^2v^2 - c^2(u^2 + v^2)z^2 + (c^4 - k^4)z^4 = 0.$$

- **At infinity.** The curve meets the line $z = 0$ only where $uv = 0$, which means at the circular points $I$ and $J$. Take $I$, the point $v = z = 0$, in the chart $u = 1$. There the lowest-order terms are $v^2 - c^2z^2 = (v - cz)(v + cz)$. So $I$ is an **ordinary node**, and so is $J$ by symmetry.
- **In the affine plane.** Setting both partial derivatives to zero leaves only the origin as a candidate singular point. The origin lies on the curve only when $k = c$.
- **Irreducibility.** The quartic is irreducible. Sage confirms this for the sample values below.

So for $k \ne c$ the only singularities are two nodes. A plane quartic has arithmetic genus $3$, so the geometric genus is $3 - 2 = 1$. For $k = c$ the node at the origin lowers the genus to $0$. $\square$

**The real picture.** For $k > c$ the real locus is one oval. For $k < c$ it is two ovals, one around each focus. Two ovals are the two components of the real points of an elliptic curve with positive discriminant. At $k = c$ the two ovals meet at the origin, and the curve becomes the rational lemniscate.

**Sage.** For $c = 1$:

| $k$ | singular points | genus |
|---|---|---|
| $2$ | ordinary nodes at $I$, $J$ | $1$ |
| $\tfrac12$ | ordinary nodes at $I$, $J$ | $1$ |
| $1$ (lemniscate) | ordinary nodes at $I$, $J$, $(0,0)$ | $0$ |

**Compare with the circle problem.** In that problem the conditions $|PO_1| \pm |PO_2| = \text{const}$ (*sum* or *difference*) lead to conics. Here the condition is on the *product*, and that already gives genus $1$.

---

## 2. Coupler curves of the four-bar linkage

**Problem.** The point $X$ moves on the circle about $A = (0,0)$ of radius $r_1$. The point $Y$ moves on the circle about $B = (d, 0)$ of radius $r_2$, and $|XY| = l$. A point $P$ is rigidly attached to the rod $XY$:
$$P = X + s\,(Y - X) + t\,J(Y - X),$$
where $J$ is the rotation by $90°$. Find the locus of $P$.

Mechanically, this is the four-bar linkage $A\!-\!X\!-\!Y\!-\!B$ with bars $r_1$, $l$, $r_2$ and the fixed bar $d$. The locus of $P$ is its **coupler curve**. **Watt's curve** is the case $r_1 = r_2$, $s = \tfrac12$, $t = 0$. It traces the midpoint of the rod in Watt's straight-line linkage.

**Proposition.** For generic lengths the coupler curve is an irreducible sextic of genus $1$. Its singularities are:

- an ordinary triple point at each of the circular points $I$ and $J$ (so it is a *tricircular* sextic);
- three further nodes.

The genus is then $\binom{5}{2} - 3 - 3 - 3 = 10 - 9 = 1$. That the curve is a tricircular sextic goes back to Roberts and Cayley (§3).

### Why genus 1: the configuration space

A *configuration* of the linkage is a pair $(X, Y)$ satisfying the three conditions $|XA| = r_1$, $|YB| = r_2$ and $|XY| = l$. The configurations form a curve $E$. The coupler point $P$ is a function on $E$, and for generic $s, t$ it is birational onto its image. So the coupler curve has the same geometric genus as $E$.

Project $E$ to the position of $X$. The circle of $X$ is a conic, so a $\mathbb{P}^1$.

- Over a given $X$, the point $Y$ is an intersection of the circle about $B$ of radius $r_2$ with the circle about $X$ of radius $l$. Two circles meet in two finite points, so $E \to \mathbb{P}^1$ has degree $2$.
- The two choices of $Y$ coincide when the two circles are tangent. That happens when $|XB| = r_2 + l$ or $|XB| = |r_2 - l|$. Each of these two conditions is a circle about $B$, and it meets the circle of $X$ in two points. That gives **four branch points**.

A double cover of $\mathbb{P}^1$ branched at four points has genus $1$ by Riemann–Hurwitz: $2g - 2 = 2(-2) + 4 = 0$.

### When the genus drops

Two branch points collide when the circle $|XB| = r_2 \pm l$ is tangent to the circle of $X$. That means $r_2 \pm l = d \pm r_1$, i.e. a relation $\pm d \pm r_1 \pm r_2 \pm l = 0$ splitting the four bars two against two.

Sort the bar lengths as $b_1 \le b_2 \le b_3 \le b_4$. Any two-against-two relation then forces $b_1 + b_4 = b_2 + b_3$. This is the **Grashof boundary**, where the linkage can fold flat. At the collision $E$ acquires a node, and the genus drops to $0$.

### Sage

Here $d, r_1, r_2, l, s, t$ are the data above. The Grashof column is $b_1 + b_4 - b_2 - b_3$ for the four bar lengths; it is $0$ exactly on the Grashof boundary.

| $(d, r_1, r_2, l)$, $(s, t)$ | Grashof | singularities | genus |
|---|---|---|---|
| $(5, 2, 4, \tfrac72)$, $(\tfrac13, \tfrac12)$ | $-\tfrac12$ | ordinary triple points at $I$, $J$, plus 3 nodes | $1$ |
| $(4, 3, 3, \tfrac32)$, $(\tfrac12, 0)$, Watt | $-\tfrac12$ | ordinary triple points at $I$, $J$, plus 3 nodes, one of them the real crossing at $(2, 0)$ | $1$ |
| $(5, 2, 4, 3)$, $(\tfrac13, \tfrac12)$ | $0$ | ordinary triple points at $I$, $J$, plus 4 nodes | $0$ |
| $(4, 3, 3, 2)$, $(\tfrac12, 0)$, Watt | $0$ | ordinary triple points at $I$, $J$, plus 2 nodes and a tacnode at $(2, 0)$ | $0$ |

The script counts the singular points over $\bar{\mathbb{Q}}$ and computes the total Tjurina number, which is $1$ for a node and $4$ for an ordinary triple point. From these it reads off the node counts. For example, in the generic row there are $5$ singular points with total Tjurina number $11 = 4 + 4 + 1 + 1 + 1$. In the last row there are $5$ points with total $13$. Sage reports $(2,0)$ as a non-ordinary double point, so the split is $4 + 4 + 1 + 1 + 3$, and Tjurina number $3$ at a double point means a tacnode.

---

## 3. References

- G. D. Cassini introduced the ovals in 1680, in connection with planetary orbits. Jacob Bernoulli described the lemniscate in *Acta Eruditorum* (1694).
- J. D. Lawrence, *A Catalog of Special Plane Curves*, Dover, New York, 1972. It includes entries on Cassini's ovals, the lemniscate and Watt's curve.
- S. Roberts, "On three-bar motion in plane space", *Proc. London Math. Soc.* (1) **7** (1875–76).
- A. Cayley, "On three-bar motion", *Proc. London Math. Soc.* (1) **7** (1875–76). Cayley treats the problem differently and acknowledges Roberts' priority.
- F. Grashof, *Theoretische Maschinenlehre*, vol. 2, Voss, Leipzig/Hamburg, 1883. It contains Grashof's condition for full rotatability of a four-bar linkage.
- K. H. Hunt, *Kinematic Geometry of Mechanisms*, Clarendon Press, Oxford, 1978. It treats coupler curves as tricircular sextics.
- W. Fulton, *Algebraic Curves*, Benjamin, 1969, Ch. 8. It gives the genus formula $g = \binom{n-1}{2} - \sum_P \binom{m_P}{2}$ for a plane curve whose singularities are all ordinary.
