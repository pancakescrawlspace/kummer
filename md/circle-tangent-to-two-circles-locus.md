# The locus of centres of circles tangent to two circles

**Problem.** Two circles $C_1$ and $C_2$ are given. Find the locus of the centre of a circle $C_3$ that touches both.

**Answer.** The locus is the union of two conics. Both have their foci at the centres $O_1$ and $O_2$. One has "axis" $r_1 + r_2$ and the other $|r_1 - r_2|$. Each conic is an ellipse or a hyperbola, depending on how $C_1$ and $C_2$ sit relative to each other. The only points to remove are the intersection points of $C_1$ and $C_2$, where $C_3$ shrinks to a point.

---

## 1. Notation

- $O_1, O_2$ are the centres of $C_1, C_2$, and $r_1 \ge r_2 > 0$ are their radii.
- $d = |O_1O_2|$.
- $P$ is the centre of $C_3$ and $r > 0$ is its radius.
- $a = |PO_1|$ and $b = |PO_2|$.

---

## 2. Eliminating the radius

$C_3$ touches $C_1$ externally when $a = r + r_1$, and internally when $a = |r - r_1|$. Both cases together say
$$r = \pm a \pm r_1 \quad\text{for some choice of signs,}$$
or equivalently $(r \pm r_1)^2 = a^2$. In the same way, touching $C_2$ means
$$r = \pm b \pm r_2.$$
Setting the two expressions for $r$ equal removes $r$:
$$a \pm b = \pm(r_1 + r_2) \qquad\text{or}\qquad a \pm b = \pm(r_1 - r_2).$$

So $P$ satisfies one of two conditions, with $c = r_1 + r_2$ or $c = r_1 - r_2$:

| condition | curve | real when |
|---|---|---|
| $\lvert PO_1\rvert + \lvert PO_2\rvert = c$ | ellipse, foci $O_1, O_2$, major axis $c$ | $c > d$ |
| $\bigl\lvert\, \lvert PO_1\rvert - \lvert PO_2\rvert \,\bigr\rvert = c$ | hyperbola, foci $O_1, O_2$, transverse axis $c$ | $c < d$ |

For each value of $c$, exactly one row of the table gives a real curve, so each $c$ contributes **one conic**. When $c = d$ both rows degenerate (see §5).

---

## 3. The converse

Every point of these conics is the centre of some tangent circle.

Take $P$ on one of the conics. The equation it satisfies, say $\varepsilon_1 a + \delta_1 r_1 = \varepsilon_2 b + \delta_2 r_2$ with signs $\varepsilon_i, \delta_i$, defines a common value $r$. This $r$ may be negative. But the sets $\{\pm a \pm r_1\}$ and $\{\pm b \pm r_2\}$ are both symmetric under $r \mapsto -r$, so $|r|$ also lies in both. That gives a genuine tangent circle unless $r = 0$.

$r = 0$ only when $a = r_1$ and $b = r_2$, which means $P \in C_1 \cap C_2$. So:

> The locus is exactly the union of the two conics, minus the points of $C_1 \cap C_2$ if point-circles are not counted.

---

## 4. Which conic means what

- **$c = r_1 - r_2$:** $C_3$ touches both circles *the same way*. Either it touches both externally, or it touches both internally (it encloses both, or lies inside both).
- **$c = r_1 + r_2$:** $C_3$ touches one circle externally and the other internally.

In terms of oriented circles, $c = r_1 - r_2$ comes from giving $C_1$ and $C_2$ the same orientation, and $c = r_1 + r_2$ from opposite orientations.

**Example: separate circles.** Take the "same way" hyperbola $\bigl\lvert\, \lvert PO_1\rvert - \lvert PO_2\rvert \,\bigr\rvert = r_1 - r_2$.

- On the branch near the smaller centre $O_2$, $|PO_1| - |PO_2| = r_1 - r_2$. These are the circles touching both externally: $|PO_1| = r + r_1$, $|PO_2| = r + r_2$.
- On the branch near $O_1$, $|PO_2| - |PO_1| = r_1 - r_2$. These are the circles enclosing both: $|PO_1| = r - r_1$, $|PO_2| = r - r_2$.

**Example: nested circles** ($C_2$ inside $C_1$). Both conics are ellipses.

- A circle in the annulus, touching $C_2$ from outside and $C_1$ from inside, has $|PO_1| = r_1 - r$ and $|PO_2| = r + r_2$. So $|PO_1| + |PO_2| = r_1 + r_2$.
- A circle inside $C_1$ that encloses $C_2$ has $|PO_1| = r_1 - r$ and $|PO_2| = r - r_2$. So $|PO_1| + |PO_2| = r_1 - r_2$.

---

## 5. By relative position

| position of $C_1, C_2$ | locus |
|---|---|
| separate, $d > r_1 + r_2$ | two hyperbolas ($2a = r_1 + r_2$ and $2a = r_1 - r_2$) |
| touching externally, $d = r_1 + r_2$ | hyperbola ($2a = r_1 - r_2$) and the line $O_1O_2$ |
| intersecting, $r_1 - r_2 < d < r_1 + r_2$ | ellipse ($2a = r_1 + r_2$) and hyperbola ($2a = r_1 - r_2$) |
| touching internally, $d = r_1 - r_2 > 0$ | ellipse ($2a = r_1 + r_2$) and the line $O_1O_2$ |
| nested, $0 < d < r_1 - r_2$ | two ellipses ($2a = r_1 + r_2$ and $2a = r_1 - r_2$) |
| concentric, $d = 0$ | two circles about $O$, radii $\tfrac12(r_1 + r_2)$ and $\tfrac12(r_1 - r_2)$ |

**Degenerate cases.**

- **Tangent circles ($c = d$).** The condition $|PO_1| + |PO_2| = d$ gives the segment $O_1O_2$. The condition $\bigl\lvert\, |PO_1| - |PO_2| \,\bigr\rvert = d$ gives the two rays of the line $O_1O_2$ outside the segment. Together they form the whole line. This is expected: every circle centred on $O_1O_2$ and passing through the point of contact touches both circles there.
- **Equal radii ($r_1 = r_2$).** The hyperbola with $2a = 0$ becomes the perpendicular bisector of $O_1O_2$.
- **Concentric circles ($d = 0$).** The ellipse condition becomes $2|PO| = c$, a circle of radius $c/2$. The hyperbola condition can only hold with $c = 0$. If moreover $r_1 = r_2$, the two circles coincide, and every point $P \ne O$ is a centre.

---

## 6. Context and references

This locus is the classical first step in one approach to the **problem of Apollonius**: find the circles tangent to three given circles. Each pair of the given circles gives two conics of centres, as above. The centres of the solutions are the common points of these conics. Adriaan van Roomen solved the problem this way in 1596, by intersecting hyperbolas. His method locates the solutions but is not a ruler-and-compass construction. Viète gave a ruler-and-compass solution in reply, in *Apollonius Gallus* (1600).

- A. van Roomen, *Problema Apolloniacum quo datis tribus circulis, quaeritur quartus eos contingens*, Würzburg, 1596.
- F. Viète, *Apollonius Gallus, seu exsuscitata Apollonii Pergaei Περὶ Ἐπαφῶν geometria*, Paris, 1600.
- T. L. Heath, *A History of Greek Mathematics*, vol. II, Clarendon Press, Oxford, 1921. It covers Apollonius' lost treatise *Tangencies* (Περὶ Ἐπαφῶν).
- J. L. Coolidge, *A Treatise on the Circle and the Sphere*, Clarendon Press, Oxford, 1916. It covers tangent circles, oriented circles and the Apollonius problem.
- H. Dörrie, *100 Great Problems of Elementary Mathematics*, Dover, New York, 1965, Problem 32 ("Apollonius' Tangency Problem").
- Wikipedia, ["Problem of Apollonius"](https://en.wikipedia.org/wiki/Problem_of_Apollonius), the section on intersecting hyperbolas. It states that the centres of circles tangent to two given circles lie on two conics.
