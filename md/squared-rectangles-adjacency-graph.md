# Does the adjacency graph of a squared rectangle determine the squares?

**Setup.** A rectangle of width $W$ and height $H$ is partitioned into finitely many squares with side lengths $s_1,\dots,s_n$. Let $G$ be the graph with one vertex per square, where two squares are joined by an edge when they share a segment of positive length. Squares that meet only at a corner are not adjacent.

**The question.** Squared rectangles are always rigid. Is there a simple proof that $G$ alone determines all ratios $s_i/H$, and with them the aspect ratio $W/H$?

**Answer: no, not as stated.** $G$ alone does not determine the sizes (§1). It does once you also mark which squares touch the top side and which touch the bottom side, and this strengthened statement has a short proof by extremal length (§2–3).

---

## 1. A counterexample

Both tilings below have the same adjacency graph: $K_4$ minus an edge, where two vertices are joined to everything and the other two are not joined to each other.

```
  2×5 rectangle              3×4 rectangle
 ┌────┬──┬────┐             ┌──┬──────┐
 │    │1 │    │             │1 │      │
 │ 2  ├──┤ 2  │             ├──┤      │
 │    │1 │    │             │1 │  3   │
 └────┴──┴────┘             ├──┤      │
                            │1 │      │
                            └──┴──────┘
```

- **Left tiling:** the two unit squares touch each other and both large squares, so they have degree $3$. The two large squares don't touch each other, so they have degree $2$.
- **Right tiling:** the large square and the middle unit square have degree $3$. The two outer unit squares have degree $2$.

The sizes are $\{2,2,1,1\}$ and $\{3,1,1,1\}$, and the aspect ratios are $5:2$ and $4:3$. So $G$ determines neither the sizes nor the shape of the rectangle.

**Computer search.** I checked every tiling of an integer rectangle of area $\le 36$ by integer squares, skipping tilings that are scaled-up copies of smaller ones. That gives $56\,407$ tilings and $16\,067$ distinct graphs $G$. Comparing graphs with Sage's canonical labelling turned up $99$ conflicting pairs: tilings with isomorphic $G$ whose size assignments do not correspond under any isomorphism. No conflict has fewer than four squares, so the example above is a smallest one. The same graph $K_4$ minus an edge has a third realization: a $3\times 5$ rectangle tiled by squares of sizes $3, 2, 1, 1$. The search script is [`scripts/squared-rectangles-search.py`](scripts/squared-rectangles-search.py).

The counterexample works because $G$ does not record where the boundary of the rectangle is, or which direction is "vertical".

---

## 2. The corrected statement

**Theorem.** Let $T$ be the set of squares touching the top side and $B$ the set touching the bottom side. Then the triple $(G, T, B)$ determines every ratio $s_i/H$, and therefore also
$$\frac{W}{H} = \sum_i \Big(\frac{s_i}{H}\Big)^2 .$$

The second claim holds because the squares fill the rectangle: $\sum_i s_i^2 = WH$.

**Computer check.** Rerunning the search with $T$ and $B$ added as two extra marked vertices (one joined to the squares in $T$, one joined to those in $B$) gave **no conflicts**. That run covered $101\,637$ tilings in both orientations and $32\,300$ distinct marked graphs.

---

## 3. Proof by extremal length

A **crossing** is a path in $G$ from a square in $T$ to a square in $B$. A weighting $\rho \colon V(G) \to \mathbb{R}_{\ge 0}$ is **admissible** if
$$\sum_{v \in \gamma} \rho(v) \ge 1 \quad \text{for every crossing } \gamma .$$
Consider the problem
$$\text{minimise } \sum_v \rho(v)^2 \text{ over all admissible } \rho .$$
The admissible weightings form a closed convex set, and the objective is strictly convex and tends to infinity as $\rho$ grows, so there is **exactly one minimiser**. The problem is defined using $(G, T, B)$ only. So it suffices to show that the minimiser is $\rho^* = s/H$, meaning $\rho^*(v) = s(v)/H$.

**Step 1: $\rho^*$ is admissible, with value $W/H$.** The closed squares along a crossing form a connected set that touches both the top and the bottom. Its projection onto the vertical axis is therefore an interval containing $[0,H]$. A projection of a union is covered by the projections of the pieces, so the heights add up to at least $H$:
$$\sum_{v \in \gamma} s(v) \ge H, \qquad\text{that is,}\qquad \sum_{v\in\gamma} \rho^*(v) \ge 1 .$$
Its value is $\sum_v (s(v)/H)^2 = WH/H^2 = W/H$.

**Step 2: every admissible $\rho$ has value at least $W/H$.** Take a vertical line at position $x \in (0, W)$, avoiding the finitely many $x$-coordinates of vertical edges.

- Listed from top to bottom, the squares the line passes through form a crossing. Two consecutive squares on the line share a horizontal segment of positive length, because $x$ lies strictly inside both of their $x$-ranges.
- Since $\rho$ is admissible, the $\rho$-weights of the squares met by the line add up to at least $1$.
- Integrate over $x$. Square $v$ is met for an $x$-interval of length $s(v)$, so
$$\sum_v \rho(v)\, s(v) = \int_0^W \sum_{v \text{ met at } x} \rho(v)\, dx \;\ge\; W .$$
- By Cauchy–Schwarz,
$$W \le \sum_v \rho(v)\, s(v) \le \Big(\sum_v \rho(v)^2\Big)^{1/2} \Big(\sum_v s(v)^2\Big)^{1/2} = \Big(\sum_v \rho(v)^2\Big)^{1/2} \sqrt{WH},$$
so $\sum_v \rho(v)^2 \ge W/H$.

So $\rho^*$ attains the lower bound and is the unique minimiser. Two tilings with the same $(G, T, B)$ therefore have the same ratio $s(v)/H$ for every square $v$. $\square$

---

## 4. Remarks

- **The Kirchhoff proof.** The other classical argument is due to Brooks, Smith, Stone and Tutte. Make each maximal horizontal segment a node and each square a unit resistor joining its top segment to its bottom segment. A square's side is then the current through its resistor, and the heights of the segments are the potentials. Kirchhoff's current law at a segment says that the squares above it and the squares below it have the same total width. The potentials are pinned at $0$ and $H$ on the bottom and top, so the maximum principle gives uniqueness. This proof needs the whole horizontal-segment structure, which is more information than $(G, T, B)$.
- **Rationality.** The Kirchhoff equations are linear with integer coefficients, so all ratios $s_i/H$ and $W/H$ are rational. Compare the MathOverflow problem of six circles in a rectangle: there the tangency conditions are quadratic, and the ratios generate a non-Galois sextic field containing $\mathbb{Q}(\sqrt 2)$.
- **Existence.** The extremal-length method also gives existence. Schramm and Cannon–Floyd–Parry show that every triangulated quadrilateral is the contact graph of a square tiling of a rectangle, where some squares may degenerate to points.

## References

- R. L. Brooks, C. A. B. Smith, A. H. Stone, W. T. Tutte, *The dissection of rectangles into squares*, Duke Math. J. **7** (1940).
- O. Schramm, *Square tilings with prescribed combinatorics*, Israel J. Math. **84** (1993).
- J. W. Cannon, W. J. Floyd, W. R. Parry, *Squaring rectangles: the finite Riemann mapping theorem*, Contemp. Math. **169** (1994).
