# Steiner's proof of Pascal's theorem

*Jacob Steiner, Vorlesungen über synthetische Geometrie, Erster Theil: Die Theorie der Kegelschnitte in elementarer Darstellung. Edited by C. F. Geiser from Steiner's lectures and unpublished manuscripts; Teubner, Leipzig 1867.*

The relevant sections are:

| Section | Content | Pages |
|---|---|---|
| § 3 | *Aehnlichkeitspunkte*: centres of similitude, and Monge's three-circle theorem | 8–11 |
| § 4 | *Der Pascal'sche Satz*: Pascal's theorem for a circle | 11–13 |
| § 6 | *Pol und Polare*: Brianchon's theorem for a circle | 21–22 |
| § 23 | *Die Polarfigur des Kreises*: transfer to arbitrary conics | 159–160 |
| § 26 | *Die Sätze von Pascal und Brianchon*: transfer again, by central projection | 175 ff. |

Part I is deliberately **elementary and metric**. It uses similar triangles, isosceles triangles and ratios of radii, not cross-ratios or projective pencils. Its proof of Pascal's theorem runs in three stages:

1. **Circle.** Pascal's theorem for a circle is reduced to Monge's theorem on centres of similitude of three auxiliary circles.
2. **Brianchon for the circle.** Polarity in the circle itself turns Pascal's theorem into Brianchon's.
3. **Conics.** Polarity in a circle centred at a focus turns a conic into a circle. Brianchon's theorem for that circle then gives Pascal's theorem for the conic.

The projective proof, which derives Pascal's theorem from Steiner's generation of conics by projective pencils, belongs to Part II (edited by H. Schröter). It is not discussed here.

---

## 1. Preliminaries from § 3: centres of similitude

### 1.1 Two circles

Let circles *M*₁, *M*₂ have radii *r*₁ ≠ *r*₂. Draw **parallel radii** *M*₁*a* and *M*₂*a′*. The line *aa′* meets the line of centres at a point *A*. Similar triangles give

  *M*₁*A* : *M*₂*A* = *r*₁ : *r*₂ and *M*₁*A* − *M*₂*A* = *M*₁*M*₂.

These two equations determine *A* uniquely. So *A* does not depend on which pair of parallel radii was chosen. Steiner calls *A* the **äusserer Aehnlichkeitspunkt**, the external centre of similitude. If the radii point in opposite directions (*M*₁*a* and *M*₂*b′*), the line *ab′* passes through a fixed point *J* between the centres, the **innerer Aehnlichkeitspunkt** or internal centre of similitude. (*A* and *J* are also where the external and internal common tangents meet.)

<div align="center">
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 690 217" width="690" role="img" aria-label="Centres of similitude of two circles">
<rect width="100%" height="100%" fill="#ffffff"/>
<circle cx="105.0" cy="115.5" r="84.0" stroke="#1f5fbf" stroke-width="1.6" fill="none" fill-opacity="1"/>
<circle cx="357.0" cy="115.5" r="45.5" stroke="#1e8a4c" stroke-width="1.6" fill="none" fill-opacity="1"/>
<line x1="91.0" y1="115.5" x2="668.8" y2="115.5" stroke="#777" stroke-width="1" stroke-opacity="1"/>
<line x1="105.0" y1="115.5" x2="144.4" y2="41.3" stroke="#1f5fbf" stroke-width="1.6" stroke-opacity="1"/>
<line x1="357.0" y1="115.5" x2="378.4" y2="75.3" stroke="#1e8a4c" stroke-width="1.6" stroke-opacity="1"/>
<line x1="357.0" y1="115.5" x2="335.6" y2="155.7" stroke="#1e8a4c" stroke-width="1.6" stroke-opacity="1" stroke-dasharray="5 3"/>
<line x1="134.0" y1="39.8" x2="665.2" y2="117.0" stroke="#c0272d" stroke-width="1.3" stroke-opacity="1"/>
<line x1="135.4" y1="35.9" x2="344.7" y2="161.1" stroke="#c96a00" stroke-width="1.3" stroke-opacity="1"/>
<circle cx="105.0" cy="115.5" r="2.8" fill="#222"/>
<circle cx="357.0" cy="115.5" r="2.8" fill="#222"/>
<circle cx="144.4" cy="41.3" r="2.8" fill="#222"/>
<circle cx="378.4" cy="75.3" r="2.8" fill="#222"/>
<circle cx="335.6" cy="155.7" r="2.8" fill="#222"/>
<circle cx="654.8" cy="115.5" r="3.5" fill="#c0272d"/>
<circle cx="268.5" cy="115.5" r="3.5" fill="#c96a00"/>
<text x="101.2644774876375" y="127.95174170787497" fill="#222" font-size="15" text-anchor="middle" dominant-baseline="middle" font-family="Georgia, 'Times New Roman', serif" font-style="italic">M<tspan font-size="11" dy="4">1</tspan></text>
<text x="361.8280787926033" y="127.57019698150837" fill="#222" font-size="15" text-anchor="middle" dominant-baseline="middle" font-family="Georgia, 'Times New Roman', serif" font-style="italic">M<tspan font-size="11" dy="4">2</tspan></text>
<text x="658.5355225123625" y="127.95174170787497" fill="#c0272d" font-size="15" text-anchor="middle" dominant-baseline="middle" font-family="Georgia, 'Times New Roman', serif" font-style="italic">A</text>
<text x="271.0495097567964" y="128.24754878398196" fill="#c96a00" font-size="15" text-anchor="middle" dominant-baseline="middle" font-family="Georgia, 'Times New Roman', serif" font-style="italic">J</text>
<text x="136.6" y="30.9" fill="#222" font-size="15" text-anchor="middle" dominant-baseline="middle" font-family="Georgia, 'Times New Roman', serif" font-style="italic">a</text>
<text x="374.6644774876375" y="62.84825829212503" fill="#222" font-size="15" text-anchor="middle" dominant-baseline="middle" font-family="Georgia, 'Times New Roman', serif" font-style="italic">a′</text>
<text x="347.47955013206337" y="160.97980005869482" fill="#222" font-size="15" text-anchor="middle" dominant-baseline="middle" font-family="Georgia, 'Times New Roman', serif" font-style="italic">b′</text>
<text x="136.3275534829989" y="84.21377674149946" fill="#1f5fbf" font-size="15" text-anchor="middle" dominant-baseline="middle" font-family="Georgia, 'Times New Roman', serif" font-style="italic">r<tspan font-size="11" dy="4">1</tspan></text>
<text x="379.3275534829989" y="101.21377674149946" fill="#1e8a4c" font-size="15" text-anchor="middle" dominant-baseline="middle" font-family="Georgia, 'Times New Roman', serif" font-style="italic">r<tspan font-size="11" dy="4">2</tspan></text>
</svg>
</div>

*Figure 1. Parallel radii in the same direction give lines through the external centre A. Radii in opposite directions give lines through the internal centre J.*

Steiner then proves a **converse**, which is the form he actually uses. Suppose two parallel lines through *M*₁ and *M*₂ meet a line *G* at α₁, α₂, with the segments pointing the same way and

  *M*₁α₁ : *M*₂α₂ = *r*₁ : *r*₂.

Then *G* passes through *A*. The proof: let *A′* = *G* ∩ *M*₁*M*₂. By similar triangles *M*₁α₁*A′* ∼ *M*₂α₂*A′*, we get *M*₁*A′* : *M*₂*A′* = *r*₁ : *r*₂. This is the equation that characterises *A*, so *A′* = *A*. If the segments point in opposite directions, *G* passes through *J* instead.

### 1.2 Three circles (Monge's theorem)

Three circles *M*₁, *M*₂, *M*₃ give six centres of similitude. Write *A*ₖ and *J*ₖ for the external and internal centres of the pair *not* containing *M*ₖ. Steiner's theorem:

> The three external centres lie on a line. Likewise, each external centre lies on a line with the two internal centres that do not belong to it.

So there are **four collinear triples**:

  *A*₁*A*₂*A*₃, *A*₁*J*₂*J*₃, *J*₁*A*₂*J*₃, *J*₁*J*₂*A*₃.

Steiner proves only the first; the others are "analogous". Draw the line *A*₁*A*₂. Through the three centres draw **arbitrary parallel lines**, meeting *A*₁*A*₂ at α₁, α₂, α₃.

* The line passes through *A*₁, the centre of *M*₂ and *M*₃, so *M*₂α₂ : *M*₃α₃ = *r*₂ : *r*₃.
* It also passes through *A*₂, the centre of *M*₁ and *M*₃, so *M*₁α₁ : *M*₃α₃ = *r*₁ : *r*₃.
* Dividing the two proportions gives **M₁α₁ : M₂α₂ = r₁ : r₂**.

By the converse lemma, *A*₁*A*₂ passes through a centre of similitude of *M*₁ and *M*₂. All three centres *M*ₖ lie on the same side of *A*₁*A*₂. So *M*₁α₁ and *M*₂α₂ point the same way, and that centre is the external one, *A*₃.

<div align="center">
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 555 489" width="555" role="img" aria-label="Monge's theorem on three external centres of similitude">
<rect width="100%" height="100%" fill="#ffffff"/>
<circle cx="148.8" cy="313.8" r="110.5" stroke="#1f5fbf" stroke-width="1.6" fill="#1f5fbf" fill-opacity="0.05"/>
<circle cx="354.4" cy="243.2" r="30.6" stroke="#1e8a4c" stroke-width="1.6" fill="#1e8a4c" fill-opacity="0.05"/>
<circle cx="276.2" cy="154.8" r="46.8" stroke="#c96a00" stroke-width="1.6" fill="#c96a00" fill-opacity="0.05"/>
<line x1="148.8" y1="313.8" x2="433.2" y2="216.2" stroke="#777" stroke-width="0.9" stroke-opacity="1"/>
<line x1="502.6" y1="410.7" x2="276.2" y2="154.8" stroke="#777" stroke-width="0.9" stroke-opacity="1"/>
<line x1="369.8" y1="38.2" x2="148.8" y2="313.8" stroke="#777" stroke-width="0.9" stroke-opacity="1"/>
<line x1="525.3" y1="474.4" x2="361.2" y2="14.2" stroke="#c0272d" stroke-width="1.8" stroke-opacity="1"/>
<line x1="148.8" y1="313.8" x2="516.8" y2="450.4" stroke="#555" stroke-width="1.1" stroke-opacity="1" stroke-dasharray="4 3"/>
<line x1="354.4" y1="243.2" x2="456.4" y2="281.0" stroke="#555" stroke-width="1.1" stroke-opacity="1" stroke-dasharray="4 3"/>
<line x1="276.2" y1="154.8" x2="432.0" y2="212.6" stroke="#555" stroke-width="1.1" stroke-opacity="1" stroke-dasharray="4 3"/>
<circle cx="148.8" cy="313.8" r="2.8" fill="#1f5fbf"/>
<circle cx="354.4" cy="243.2" r="2.8" fill="#1e8a4c"/>
<circle cx="276.2" cy="154.8" r="2.8" fill="#c96a00"/>
<circle cx="516.8" cy="450.4" r="2.6" fill="#555"/>
<circle cx="456.4" cy="281.0" r="2.6" fill="#555"/>
<circle cx="432.0" cy="212.6" r="2.6" fill="#555"/>
<circle cx="502.6" cy="410.7" r="3.8" fill="#c0272d"/>
<circle cx="369.7" cy="38.3" r="3.8" fill="#c0272d"/>
<circle cx="433.2" cy="216.2" r="3.8" fill="#c0272d"/>
<text x="136.72980301849165" y="318.62807879260333" fill="#222" font-size="15" text-anchor="middle" dominant-baseline="middle" font-family="Georgia, 'Times New Roman', serif" font-style="italic">M<tspan font-size="11" dy="4">1</tspan></text>
<text x="365.54740803426307" y="249.88844482055782" fill="#222" font-size="15" text-anchor="middle" dominant-baseline="middle" font-family="Georgia, 'Times New Roman', serif" font-style="italic">M<tspan font-size="11" dy="4">2</tspan></text>
<text x="264.5724465170011" y="148.98622325850056" fill="#222" font-size="15" text-anchor="middle" dominant-baseline="middle" font-family="Georgia, 'Times New Roman', serif" font-style="italic">M<tspan font-size="11" dy="4">3</tspan></text>
<text x="515.347548783982" y="408.1504902432036" fill="#c0272d" font-size="15" text-anchor="middle" dominant-baseline="middle" font-family="Georgia, 'Times New Roman', serif" font-style="italic">A<tspan font-size="11" dy="4">1</tspan></text>
<text x="357.248258292125" y="34.564477487637504" fill="#c0272d" font-size="15" text-anchor="middle" dominant-baseline="middle" font-family="Georgia, 'Times New Roman', serif" font-style="italic">A<tspan font-size="11" dy="4">2</tspan></text>
<text x="443.8500149667475" y="223.65501047672325" fill="#c0272d" font-size="15" text-anchor="middle" dominant-baseline="middle" font-family="Georgia, 'Times New Roman', serif" font-style="italic">A<tspan font-size="11" dy="4">3</tspan></text>
<text x="529.6623938856882" y="442.6825636685871" fill="#555" font-size="15" text-anchor="middle" dominant-baseline="middle" font-family="Georgia, 'Times New Roman', serif" font-style="italic">α<tspan font-size="11" dy="4">1</tspan></text>
<text x="469.26239388568814" y="273.2825636685871" fill="#555" font-size="15" text-anchor="middle" dominant-baseline="middle" font-family="Georgia, 'Times New Roman', serif" font-style="italic">α<tspan font-size="11" dy="4">2</tspan></text>
<text x="426.42913985468846" y="198.6728496367211" fill="#555" font-size="15" text-anchor="middle" dominant-baseline="middle" font-family="Georgia, 'Times New Roman', serif" font-style="italic">α<tspan font-size="11" dy="4">3</tspan></text>
</svg>
</div>

*Figure 2. Steiner's proof of Monge's theorem. The dashed lines through the centres are parallel, and the ratio conditions coming from A₁ and A₂ force the line through A₃.*

This is Menelaus' theorem in disguise. The three ratios (*r*₁/*r*₂)(*r*₂/*r*₃)(*r*₃/*r*₁) multiply to 1 automatically. That identity is what powers the proof of Pascal's theorem below.

---

## 2. § 4: Pascal's theorem for a circle

Number six points on a circle *M* as 1, …, 6 in any order and join them in sequence to form a hexagon. The **opposite vertices** are 1 & 4, 2 & 5, 3 & 6. The **opposite sides** are 12 & 45, 23 & 56, 34 & 61. Steiner's figure deliberately shows a self-intersecting (*überschlagenes*) hexagon, "to preserve the generality of the argument". The theorem:

> *In einem Kreissechseck schneiden sich die drei Paare gegenüberliegender Seiten in drei Punkten, welche auf einer Geraden liegen.*

(In a hexagon inscribed in a circle, the three pairs of opposite sides meet in three points that lie on a line.)

### 2.1 Strategy

Let *P* = 12 ∩ 45, *Q* = 23 ∩ 56, *R* = 34 ∩ 61. Steiner states his plan:

> *…dann wird der Satz bewiesen, wenn man zeigt, dass P, Q, R aufgefasst werden können als das System von drei äussern Aehnlichkeitspunkten oder das System von einem äussern und den zwei ihm nicht zugehörigen innern Aehnlichkeitspunkten dreier Kreise.*

In other words, he exhibits *P*, *Q*, *R* as one of the collinear triples of Monge's theorem.

### 2.2 The auxiliary circles

For each pair of opposite vertices, draw the tangents to *M* at those two vertices. Let their intersection be the centre of a circle through the two vertices. This works because the two tangent segments from that point are equal.

* Vertices 1 & 4 give the circle *M*₁.
* Vertices 2 & 5 give the circle *M*₂.
* Vertices 3 & 6 give the circle *M*₃.

Each radius *M*ₖ1, *M*ₖ4, … is tangent to *M*, so **each auxiliary circle cuts *M* at right angles**. Equivalently, *M*₁ is the circle orthogonal to *M* through the points 1 and 4.

<div align="center">
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 599 458" width="599" role="img" aria-label="Steiner's construction for Pascal's theorem">
<rect width="100%" height="100%" fill="#ffffff"/>
<circle cx="147.1" cy="161.9" r="109.6" stroke="#1f5fbf" stroke-width="1.5" fill="#1f5fbf" fill-opacity="0.05"/>
<circle cx="359.3" cy="99.6" r="51.8" stroke="#1e8a4c" stroke-width="1.5" fill="#1e8a4c" fill-opacity="0.05"/>
<circle cx="381.7" cy="347.2" r="79.6" stroke="#c96a00" stroke-width="1.5" fill="#c96a00" fill-opacity="0.05"/>
<circle cx="302.1" cy="222.2" r="125" stroke="#111" stroke-width="2.0" fill="none" fill-opacity="1"/>
<line x1="147.1" y1="161.9" x2="184.6" y2="264.9" stroke="#1f5fbf" stroke-width="1" stroke-opacity="1" stroke-dasharray="4 3"/>
<line x1="147.1" y1="161.9" x2="244.4" y2="111.3" stroke="#1f5fbf" stroke-width="1" stroke-opacity="1" stroke-dasharray="4 3"/>
<line x1="359.3" y1="99.6" x2="394.2" y2="137.7" stroke="#1e8a4c" stroke-width="1" stroke-opacity="1" stroke-dasharray="4 3"/>
<line x1="359.3" y1="99.6" x2="307.5" y2="97.3" stroke="#1e8a4c" stroke-width="1" stroke-opacity="1" stroke-dasharray="4 3"/>
<line x1="381.7" y1="347.2" x2="302.1" y2="347.2" stroke="#c96a00" stroke-width="1" stroke-opacity="1" stroke-dasharray="4 3"/>
<line x1="381.7" y1="347.2" x2="415.4" y2="275.0" stroke="#c96a00" stroke-width="1" stroke-opacity="1" stroke-dasharray="4 3"/>
<line x1="184.6" y1="264.9" x2="549.1" y2="43.8" stroke="#333" stroke-width="1.1" stroke-opacity="1"/>
<line x1="244.4" y1="111.3" x2="549.1" y2="43.8" stroke="#333" stroke-width="1.1" stroke-opacity="1"/>
<line x1="394.2" y1="137.7" x2="302.1" y2="347.2" stroke="#333" stroke-width="1.1" stroke-opacity="1"/>
<line x1="307.5" y1="97.3" x2="415.4" y2="275.0" stroke="#333" stroke-width="1.1" stroke-opacity="1"/>
<line x1="302.1" y1="347.2" x2="244.4" y2="111.3" stroke="#333" stroke-width="1.1" stroke-opacity="1"/>
<line x1="415.4" y1="275.0" x2="184.6" y2="264.9" stroke="#333" stroke-width="1.1" stroke-opacity="1"/>
<line x1="568.2" y1="27.6" x2="263.9" y2="285.4" stroke="#c0272d" stroke-width="2.0" stroke-opacity="1"/>
<circle cx="184.6" cy="264.9" r="3" fill="#111"/>
<circle cx="394.2" cy="137.7" r="3" fill="#111"/>
<circle cx="302.1" cy="347.2" r="3" fill="#111"/>
<circle cx="244.4" cy="111.3" r="3" fill="#111"/>
<circle cx="307.5" cy="97.3" r="3" fill="#111"/>
<circle cx="415.4" cy="275.0" r="3" fill="#111"/>
<circle cx="147.1" cy="161.9" r="3.2" fill="#1f5fbf"/>
<circle cx="359.3" cy="99.6" r="3.2" fill="#1e8a4c"/>
<circle cx="381.7" cy="347.2" r="3.2" fill="#c96a00"/>
<circle cx="302.1" cy="222.2" r="3" fill="#111"/>
<circle cx="549.1" cy="43.7" r="4" fill="#c0272d"/>
<circle cx="368.1" cy="197.1" r="4" fill="#c0272d"/>
<circle cx="283.0" cy="269.2" r="4" fill="#c0272d"/>
<text x="171.4459433090812" y="269.6927854711112" fill="#222" font-size="15" text-anchor="middle" dominant-baseline="middle" font-family="Georgia, 'Times New Roman', serif">1</text>
<text x="404.5282655639252" y="128.2487074724651" fill="#222" font-size="15" text-anchor="middle" dominant-baseline="middle" font-family="Georgia, 'Times New Roman', serif">2</text>
<text x="302.11399999300005" y="361.19999300000524" fill="#222" font-size="15" text-anchor="middle" dominant-baseline="middle" font-family="Georgia, 'Times New Roman', serif">3</text>
<text x="237.94654207938876" y="98.8761165142738" fill="#222" font-size="15" text-anchor="middle" dominant-baseline="middle" font-family="Georgia, 'Times New Roman', serif">4</text>
<text x="308.124643864818" y="83.31394194055575" fill="#222" font-size="15" text-anchor="middle" dominant-baseline="middle" font-family="Georgia, 'Times New Roman', serif">5</text>
<text x="428.09080610980993" y="280.9112976818301" fill="#222" font-size="15" text-anchor="middle" dominant-baseline="middle" font-family="Georgia, 'Times New Roman', serif">6</text>
<text x="308.27394906513035" y="232.48991510855052" fill="#222" font-size="15" text-anchor="middle" dominant-baseline="middle" font-family="Georgia, 'Times New Roman', serif" font-style="italic">M</text>
<text x="156.2923881554251" y="152.7076118445749" fill="#1f5fbf" font-size="15" text-anchor="middle" dominant-baseline="middle" font-family="Georgia, 'Times New Roman', serif" font-style="italic">M<tspan font-size="11" dy="4">1</tspan></text>
<text x="350.1076118445749" y="90.40761184457487" fill="#1e8a4c" font-size="15" text-anchor="middle" dominant-baseline="middle" font-family="Georgia, 'Times New Roman', serif" font-style="italic">M<tspan font-size="11" dy="4">2</tspan></text>
<text x="390.8923881554251" y="338.00761184457485" fill="#c96a00" font-size="15" text-anchor="middle" dominant-baseline="middle" font-family="Georgia, 'Times New Roman', serif" font-style="italic">M<tspan font-size="11" dy="4">3</tspan></text>
<text x="560.2474080342631" y="37.011555179442155" fill="#c0272d" font-size="15" text-anchor="middle" dominant-baseline="middle" font-family="Georgia, 'Times New Roman', serif" font-style="italic">P</text>
<text x="356.95259196573693" y="190.41155517944216" fill="#c0272d" font-size="15" text-anchor="middle" dominant-baseline="middle" font-family="Georgia, 'Times New Roman', serif" font-style="italic">Q</text>
<text x="293.1512945227594" y="277.32103561820753" fill="#c0272d" font-size="15" text-anchor="middle" dominant-baseline="middle" font-family="Georgia, 'Times New Roman', serif" font-style="italic">R</text>
</svg>
</div>

*Figure 3. Steiner's construction, drawn to scale from computed coordinates. The dashed segments are the tangents from Mₖ, which are also radii of the auxiliary circles. In this configuration, as in Steiner's own figure, P is the external centre of M₁ and M₂. Q and R are the internal centres of (M₂, M₃) and (M₃, M₁). So P, Q, R is the Monge triple J₁J₂A₃ and lies on a line.*

### 2.3 The key step: side 45 passes through a centre of similitude of M₁ and M₂

Vertex 4 lies on *M*₁ and vertex 5 lies on *M*₂. Steiner argues as follows (Figure 4).

1. **Tangents through M.** *M*₁ is orthogonal to *M* at 4, so the line *M*4 is tangent to *M*₁ at 4. Likewise *M*5 is tangent to *M*₂ at 5.
2. **The isosceles triangle M45.** *M*4 = *M*5 because both are radii of *M*, so ∠*M*45 = ∠*M*54. Add a right angle to each; the radii *M*₁4 and *M*₂5 are perpendicular to *M*4 and *M*5. This gives **∠M₁45 = ∠M₂54**.
3. **The isosceles triangle M₂5p₂.** Let *p*₂ be the second intersection of line 45 with circle *M*₂. Then *M*₂5 = *M*₂*p*₂, so ∠*M*₂*p*₂5 = ∠*M*₂5*p*₂.
4. **Parallel radii.** Combining steps 2 and 3, the radii *M*₁4 and *M*₂*p*₂ make equal corresponding angles with the transversal 45. (In Figure 4 these are the double red arcs.) So ***M*₁4 ∥ *M*₂*p*₂**, and the two radii point the same way.
5. **Conclusion.** By § 3, the line 4*p*₂, which is the line 45, passes through the **external centre of similitude of *M*₁ and *M*₂**.

<div align="center">
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 704 363" width="704" role="img" aria-label="Key step: line 45 passes through the external centre of similitude">
<rect width="100%" height="100%" fill="#ffffff"/>
<circle cx="362.5" cy="259.1" r="150" stroke="#111" stroke-width="1.6" fill="none" fill-opacity="1"/>
<circle cx="176.5" cy="186.8" r="131.5" stroke="#1f5fbf" stroke-width="1.5" fill="#1f5fbf" fill-opacity="0.05"/>
<circle cx="431.1" cy="112.0" r="62.1" stroke="#1e8a4c" stroke-width="1.5" fill="#1e8a4c" fill-opacity="0.05"/>
<polygon points="362.5,259.1 293.2,126.1 369.0,109.3" fill="#999" fill-opacity="0.18" stroke="none"/>
<line x1="362.5" y1="259.1" x2="262.1" y2="66.2" stroke="#111" stroke-width="1" stroke-opacity="1"/>
<line x1="362.5" y1="259.1" x2="372.0" y2="41.8" stroke="#111" stroke-width="1" stroke-opacity="1"/>
<path d="M 309.9,158.0 L 311.9,156.9 L 313.9,155.6 L 315.8,154.2 L 317.6,152.6 L 319.2,151.0 L 320.8,149.2 L 322.3,147.4 L 323.6,145.4 L 324.8,143.4 L 325.9,141.3 L 326.8,139.1 L 327.6,136.9 L 328.2,134.6 L 328.7,132.3 L 329.0,130.0 L 329.2,127.7 L 329.2,125.3 L 329.1,122.9 L 328.8,120.6 L 328.4,118.3" stroke="#444" stroke-width="1.2" fill="none"/>
<path d="M 367.5,145.2 L 365.1,145.1 L 362.8,144.7 L 360.5,144.2 L 358.2,143.6 L 356.0,142.8 L 353.8,141.9 L 351.7,140.8 L 349.7,139.6 L 347.7,138.3 L 345.9,136.9 L 344.1,135.3 L 342.5,133.6 L 341.0,131.8 L 339.5,129.9 L 338.3,128.0 L 337.1,125.9 L 336.1,123.8 L 335.2,121.6 L 334.5,119.3 L 333.9,117.1" stroke="#444" stroke-width="1.2" fill="none"/>
<path d="M 277.3,134.4 L 278.6,136.6 L 280.3,138.6 L 282.2,140.3 L 284.4,141.7 L 286.7,142.9 L 289.2,143.6 L 291.7,144.0 L 294.3,144.0 L 296.9,143.7 L 299.4,143.0 L 301.7,141.9 L 303.9,140.6 L 305.9,138.9 L 307.6,136.9 L 309.0,134.7 L 310.1,132.4 L 310.8,129.9 L 311.2,127.3 L 311.2,124.7 L 310.8,122.2" stroke="#c0272d" stroke-width="1.3" fill="none"/>
<path d="M 272.6,136.8 L 274.4,139.7 L 276.5,142.2 L 279.0,144.5 L 281.8,146.3 L 284.8,147.8 L 288.0,148.7 L 291.3,149.3 L 294.6,149.3 L 298.0,148.8 L 301.2,147.9 L 304.2,146.6 L 307.1,144.8 L 309.6,142.6 L 311.8,140.1 L 313.6,137.3 L 315.0,134.2 L 316.0,131.0 L 316.4,127.7 L 316.4,124.4 L 315.9,121.0" stroke="#c0272d" stroke-width="1.3" fill="none"/>
<path d="M 470.3,91.6 L 471.6,93.8 L 473.3,95.8 L 475.2,97.5 L 477.4,99.0 L 479.7,100.1 L 482.2,100.8 L 484.7,101.2 L 487.3,101.3 L 489.9,100.9 L 492.4,100.2 L 494.7,99.2 L 496.9,97.8 L 498.9,96.1 L 500.6,94.1 L 502.0,92.0 L 503.1,89.6 L 503.8,87.1 L 504.2,84.6 L 504.2,82.0 L 503.8,79.4" stroke="#c0272d" stroke-width="1.3" fill="none"/>
<path d="M 465.6,94.0 L 467.4,96.9 L 469.5,99.4 L 472.0,101.7 L 474.8,103.5 L 477.8,105.0 L 481.0,106.0 L 484.3,106.5 L 487.6,106.5 L 491.0,106.1 L 494.2,105.1 L 497.2,103.8 L 500.0,102.0 L 502.6,99.8 L 504.8,97.3 L 506.6,94.5 L 508.0,91.4 L 508.9,88.2 L 509.4,84.9 L 509.4,81.6 L 508.9,78.3" stroke="#c0272d" stroke-width="1.3" fill="none"/>
<line x1="278.6" y1="129.3" x2="673.6" y2="41.8" stroke="#333" stroke-width="1.3" stroke-opacity="1"/>
<line x1="176.5" y1="186.8" x2="659.0" y2="45.0" stroke="#777" stroke-width="0.9" stroke-opacity="1" stroke-dasharray="5 3"/>
<line x1="176.5" y1="186.8" x2="293.2" y2="126.1" stroke="#1f5fbf" stroke-width="2.2" stroke-opacity="1"/>
<line x1="431.1" y1="112.0" x2="486.2" y2="83.3" stroke="#1e8a4c" stroke-width="2.2" stroke-opacity="1"/>
<line x1="431.1" y1="112.0" x2="369.0" y2="109.3" stroke="#1e8a4c" stroke-width="1.2" stroke-opacity="1" stroke-dasharray="4 3"/>
<circle cx="362.5" cy="259.1" r="3.2" fill="#111"/>
<circle cx="293.2" cy="126.1" r="3.2" fill="#111"/>
<circle cx="369.0" cy="109.3" r="3.2" fill="#111"/>
<circle cx="176.5" cy="186.8" r="3.2" fill="#1f5fbf"/>
<circle cx="431.1" cy="112.0" r="3.2" fill="#1e8a4c"/>
<circle cx="486.2" cy="83.3" r="3.2" fill="#1e8a4c"/>
<circle cx="659.0" cy="45.0" r="4.2" fill="#c0272d"/>
<text x="366.2355225123625" y="271.551741707875" fill="#222" font-size="15" text-anchor="middle" dominant-baseline="middle" font-family="Georgia, 'Times New Roman', serif" font-style="italic">M</text>
<text x="290.6504902432036" y="113.35245121601804" fill="#222" font-size="15" text-anchor="middle" dominant-baseline="middle" font-family="Georgia, 'Times New Roman', serif">4</text>
<text x="357.3724465170011" y="103.48622325850054" fill="#222" font-size="15" text-anchor="middle" dominant-baseline="middle" font-family="Georgia, 'Times New Roman', serif">5</text>
<text x="188.1275534829989" y="180.98622325850056" fill="#1f5fbf" font-size="15" text-anchor="middle" dominant-baseline="middle" font-family="Georgia, 'Times New Roman', serif" font-style="italic">M<tspan font-size="11" dy="4">1</tspan></text>
<text x="433.6495097567964" y="124.74754878398196" fill="#1e8a4c" font-size="15" text-anchor="middle" dominant-baseline="middle" font-family="Georgia, 'Times New Roman', serif" font-style="italic">M<tspan font-size="11" dy="4">2</tspan></text>
<text x="497.016653826392" y="76.08889744907202" fill="#1e8a4c" font-size="15" text-anchor="middle" dominant-baseline="middle" font-family="Georgia, 'Times New Roman', serif" font-style="italic">p<tspan font-size="11" dy="4">2</tspan></text>
<text x="671.4517417078749" y="41.26447748763751" fill="#c0272d" font-size="15" text-anchor="middle" dominant-baseline="middle" font-family="Georgia, 'Times New Roman', serif" font-style="italic">P</text>
</svg>
</div>

*Figure 4. The key step. The triangle M45 is isosceles (grey arcs). Adding right angles and using the isosceles triangle M₂5p₂ makes the radii M₁4 and M₂p₂ parallel (double red arcs). So the line 45 passes through the external centre of similitude P of M₁ and M₂, which lies on the line of centres (dashed).*

The same argument applied to vertices 1 (on *M*₁) and 2 (on *M*₂) shows that side 12 passes through **the same** centre of similitude. So that centre is *P* = 12 ∩ 45. Steiner then says it "needs no further elaboration" (*bedarf keiner weitern Ausführung*) that *Q* is the internal centre of *M*₂, *M*₃ and *R* the internal centre of *M*₃, *M*₁. By § 3 the three points are collinear:

> *Unter Beachtung aller angegebenen Beweiselemente kann man nun den Pascal'schen Satz als für jedes Kreissechseck bewiesen annehmen.*

### 2.4 Comments on the argument

* **What makes it work.** Pascal's theorem is a projective incidence statement. Steiner turns it into a statement about **ratios of radii**, where collinearity is automatic because (*r*₁/*r*₂)(*r*₂/*r*₃)(*r*₃/*r*₁) = 1. The orthogonal circles through opposite vertices are exactly what make each pair of opposite sides pass through a centre of similitude of the matching pair of circles.
* **Case bookkeeping.** Whether a given intersection point is an external or an internal centre depends on the configuration. It depends on whether the radii in step 4 come out pointing the same way or opposite ways, and on how the angles in step 2 sit. Steiner handles his figure and leaves the rest to the reader. A fully rigorous version would track this with oriented angles or signed radii. For the proof to go through, *P*, *Q*, *R* must always form one of the four Monge triples, i.e. an even number of them must be internal. That is indeed what happens. In a numerical check on 20,000 random inscribed hexagons, the pattern was always either all three external or one external and two internal, never an odd number internal, and all four collinear patterns occurred.
* **Degenerate cases.** If two opposite vertices are diametrically opposite, the tangents there are parallel and the auxiliary "circle" degenerates into the diameter through them. Steiner does not discuss this. It can be handled as a limiting case.

---

## 3. § 6: Brianchon's theorem for a circle

Once poles and polars with respect to a circle are available, Brianchon's theorem follows by duality in that circle. Take a hexagon circumscribed about *M*, with tangents 1, …, 6, and replace every element by its pole or polar with respect to *M*:

| circumscribed hexagon | ↦ | inscribed hexagon |
|---|---|---|
| tangent *i* | ↦ | its point of contact *i* |
| vertex (*i*, *i*+1) | ↦ | side (*i*, *i*+1) |
| main diagonal joining opposite vertices | ↦ | intersection point of opposite sides |

By Pascal's theorem, the three intersection points lie on a line. Their polars, the three main diagonals, therefore pass through one point, the pole of that line.

---

## 4. § 23: Pascal's theorem for an arbitrary conic

In Part I, conics are largely studied as **polar figures of a circle**. Reciprocate a circle *K* in a circle centred at a point *F*, and you get a conic with **focus** *F*: an ellipse, parabola or hyperbola as *F* lies inside, on, or outside *K*. Conversely, reciprocating a conic in a circle centred at one of its foci gives a circle. Steiner's transfer:

1. Take a hexagon inscribed in a conic 𝔎. Reciprocate in a circle centred at a focus *F*. 𝔎 becomes a circle *K*.
2. The six **vertices** become six **tangents** of *K*, so the inscribed hexagon becomes a hexagon circumscribed about *K*.
3. Opposite **sides** become opposite **vertices**, and the three intersection points of opposite sides become the three **main diagonals**.
4. By **Brianchon's theorem for the circle** (§ 6), the main diagonals meet in a point *B*.
5. The original three points are the poles of these concurrent lines, so they lie on a line, the polar of *B*. **This is Pascal's theorem for 𝔎.**

<div align="center">
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 744 368" width="744" role="img" aria-label="Pascal for conics from Brianchon for the circle by polar reciprocity">
<rect width="100%" height="100%" fill="#ffffff"/>
<circle cx="246.8" cy="179.4" r="105.0" stroke="#777" stroke-width="1" fill="none" fill-opacity="1" stroke-dasharray="3 3"/>
<circle cx="246.8" cy="179.4" r="3.2" fill="#6b3fa0"/>
<text x="236.14998503325248" y="186.85501047672327" fill="#6b3fa0" font-size="15" text-anchor="middle" dominant-baseline="middle" font-family="Georgia, 'Times New Roman', serif" font-style="italic">F</text>
<circle cx="497.2" cy="179.4" r="105.0" stroke="#777" stroke-width="1" fill="none" fill-opacity="1" stroke-dasharray="3 3"/>
<circle cx="497.2" cy="179.4" r="3.2" fill="#6b3fa0"/>
<text x="486.5499850332525" y="186.85501047672327" fill="#6b3fa0" font-size="15" text-anchor="middle" dominant-baseline="middle" font-family="Georgia, 'Times New Roman', serif" font-style="italic">F</text>
<path d="M 316.8,179.4 L 316.7,177.5 L 316.7,175.7 L 316.6,173.9 L 316.5,172.0 L 316.3,170.2 L 316.2,168.4 L 316.0,166.5 L 315.7,164.7 L 315.4,162.9 L 315.1,161.1 L 314.8,159.2 L 314.4,157.4 L 314.0,155.6 L 313.6,153.7 L 313.1,151.9 L 312.6,150.1 L 312.1,148.2 L 311.5,146.4 L 310.9,144.6 L 310.2,142.7 L 309.5,140.9 L 308.8,139.1 L 308.0,137.3 L 307.2,135.4 L 306.4,133.6 L 305.5,131.8 L 304.6,130.0 L 303.6,128.2 L 302.6,126.3 L 301.6,124.5 L 300.5,122.7 L 299.4,120.9 L 298.2,119.1 L 297.0,117.3 L 295.8,115.5 L 294.4,113.7 L 293.1,111.9 L 291.7,110.2 L 290.2,108.4 L 288.8,106.6 L 287.2,104.9 L 285.6,103.1 L 283.9,101.4 L 282.2,99.7 L 280.5,98.0 L 278.7,96.2 L 276.8,94.6 L 274.9,92.9 L 272.9,91.2 L 270.8,89.6 L 268.7,87.9 L 266.5,86.3 L 264.3,84.8 L 262.0,83.2 L 259.6,81.7 L 257.2,80.1 L 254.7,78.7 L 252.1,77.2 L 249.5,75.8 L 246.8,74.4 L 244.0,73.0 L 241.1,71.7 L 238.2,70.4 L 235.2,69.2 L 232.1,68.0 L 228.9,66.9 L 225.7,65.8 L 222.4,64.8 L 219.0,63.8 L 215.5,62.9 L 212.0,62.0 L 208.4,61.3 L 204.7,60.6 L 200.9,60.0 L 197.1,59.4 L 193.1,59.0 L 189.1,58.6 L 185.1,58.3 L 180.9,58.2 L 176.8,58.1 L 172.5,58.2 L 168.2,58.4 L 163.8,58.7 L 159.3,59.1 L 154.9,59.6 L 150.3,60.3 L 145.8,61.1 L 141.2,62.1 L 136.5,63.2 L 131.9,64.5 L 127.2,66.0 L 122.6,67.6 L 117.9,69.4 L 113.3,71.3 L 108.7,73.4 L 104.1,75.7 L 99.6,78.2 L 95.1,80.9 L 90.7,83.7 L 86.4,86.8 L 82.1,90.0 L 78.0,93.4 L 74.0,97.0 L 70.2,100.8 L 66.5,104.7 L 62.9,108.8 L 59.5,113.1 L 56.3,117.5 L 53.4,122.1 L 50.6,126.8 L 48.0,131.7 L 45.7,136.6 L 43.7,141.7 L 41.9,146.9 L 40.3,152.2 L 39.0,157.5 L 38.0,163.0 L 37.3,168.4 L 36.9,173.9 L 36.8,179.4 L 36.9,184.9 L 37.3,190.4 L 38.0,195.8 L 39.0,201.2 L 40.3,206.6 L 41.9,211.8 L 43.7,217.0 L 45.7,222.1 L 48.0,227.1 L 50.6,231.9 L 53.4,236.7 L 56.3,241.2 L 59.5,245.7 L 62.9,249.9 L 66.5,254.1 L 70.2,258.0 L 74.0,261.8 L 78.0,265.3 L 82.1,268.7 L 86.4,272.0 L 90.7,275.0 L 95.1,277.9 L 99.6,280.5 L 104.1,283.0 L 108.7,285.3 L 113.3,287.4 L 117.9,289.4 L 122.6,291.2 L 127.2,292.8 L 131.9,294.2 L 136.5,295.5 L 141.2,296.6 L 145.8,297.6 L 150.3,298.4 L 154.9,299.1 L 159.3,299.7 L 163.8,300.1 L 168.2,300.4 L 172.5,300.6 L 176.7,300.6 L 180.9,300.6 L 185.1,300.4 L 189.1,300.1 L 193.1,299.8 L 197.1,299.3 L 200.9,298.8 L 204.7,298.2 L 208.4,297.5 L 212.0,296.7 L 215.5,295.9 L 219.0,295.0 L 222.4,294.0 L 225.7,293.0 L 228.9,291.9 L 232.1,290.7 L 235.2,289.6 L 238.2,288.3 L 241.1,287.1 L 244.0,285.7 L 246.8,284.4 L 249.5,283.0 L 252.1,281.6 L 254.7,280.1 L 257.2,278.6 L 259.6,277.1 L 262.0,275.6 L 264.3,274.0 L 266.5,272.4 L 268.7,270.8 L 270.8,269.2 L 272.9,267.5 L 274.9,265.9 L 276.8,264.2 L 278.7,262.5 L 280.5,260.8 L 282.2,259.1 L 283.9,257.4 L 285.6,255.6 L 287.2,253.9 L 288.8,252.1 L 290.2,250.4 L 291.7,248.6 L 293.1,246.8 L 294.4,245.0 L 295.8,243.2 L 297.0,241.4 L 298.2,239.6 L 299.4,237.8 L 300.5,236.0 L 301.6,234.2 L 302.6,232.4 L 303.6,230.6 L 304.6,228.8 L 305.5,227.0 L 306.4,225.1 L 307.2,223.3 L 308.0,221.5 L 308.8,219.7 L 309.5,217.8 L 310.2,216.0 L 310.9,214.2 L 311.5,212.4 L 312.1,210.5 L 312.6,208.7 L 313.1,206.9 L 313.6,205.0 L 314.0,203.2 L 314.4,201.4 L 314.8,199.5 L 315.1,197.7 L 315.4,195.9 L 315.7,194.0 L 316.0,192.2 L 316.2,190.4 L 316.3,188.5 L 316.5,186.7 L 316.6,184.9 L 316.7,183.0 L 316.7,181.2 Z" stroke="#111" stroke-width="1.8" fill="none"/>
<line x1="263.5" y1="84.2" x2="321.7" y2="234.4" stroke="#444" stroke-width="1.1" stroke-opacity="1"/>
<line x1="321.7" y1="234.4" x2="226.8" y2="292.6" stroke="#444" stroke-width="1.1" stroke-opacity="1"/>
<line x1="319.7" y1="331.7" x2="307.8" y2="136.7" stroke="#444" stroke-width="1.1" stroke-opacity="1"/>
<line x1="319.7" y1="331.7" x2="43.0" y2="215.3" stroke="#444" stroke-width="1.1" stroke-opacity="1"/>
<line x1="325.7" y1="47.2" x2="283.4" y2="257.9" stroke="#444" stroke-width="1.1" stroke-opacity="1"/>
<line x1="43.0" y1="215.3" x2="325.7" y2="47.2" stroke="#444" stroke-width="1.1" stroke-opacity="1"/>
<line x1="326.3" y1="21.0" x2="319.1" y2="357.9" stroke="#c0272d" stroke-width="2.0" stroke-opacity="1"/>
<circle cx="263.5" cy="84.2" r="3" fill="#111"/>
<text x="265.9458270351509" y="70.41530086965534" fill="#222" font-size="15" text-anchor="middle" dominant-baseline="middle" font-family="Georgia, 'Times New Roman', serif">1</text>
<circle cx="312.2" cy="209.9" r="3" fill="#111"/>
<text x="324.89193544425945" y="215.8088725387125" fill="#222" font-size="15" text-anchor="middle" dominant-baseline="middle" font-family="Georgia, 'Times New Roman', serif">2</text>
<circle cx="307.8" cy="136.7" r="3" fill="#111"/>
<text x="319.2746096990381" y="128.67919379022646" fill="#222" font-size="15" text-anchor="middle" dominant-baseline="middle" font-family="Georgia, 'Times New Roman', serif">3</text>
<circle cx="283.4" cy="257.9" r="3" fill="#111"/>
<text x="289.33057443252363" y="270.5818092912761" fill="#222" font-size="15" text-anchor="middle" dominant-baseline="middle" font-family="Georgia, 'Times New Roman', serif">4</text>
<circle cx="226.8" cy="292.6" r="3" fill="#111"/>
<text x="224.38132742148483" y="306.3894895829374" fill="#222" font-size="15" text-anchor="middle" dominant-baseline="middle" font-family="Georgia, 'Times New Roman', serif">5</text>
<circle cx="43.0" cy="215.3" r="3" fill="#111"/>
<text x="29.212905901153576" y="217.7322903423634" fill="#222" font-size="15" text-anchor="middle" dominant-baseline="middle" font-family="Georgia, 'Times New Roman', serif">6</text>
<circle cx="321.7" cy="234.4" r="4" fill="#c0272d"/>
<text x="334.151741707875" y="230.66447748763753" fill="#c0272d" font-size="15" text-anchor="middle" dominant-baseline="middle" font-family="Georgia, 'Times New Roman', serif" font-style="italic">P</text>
<circle cx="319.7" cy="331.7" r="4" fill="#c0272d"/>
<text x="307.6298030184916" y="326.87192120739667" fill="#c0272d" font-size="15" text-anchor="middle" dominant-baseline="middle" font-family="Georgia, 'Times New Roman', serif" font-style="italic">Q</text>
<circle cx="325.7" cy="47.2" r="4" fill="#c0272d"/>
<text x="337.3275534829989" y="53.013776741499456" fill="#c0272d" font-size="15" text-anchor="middle" dominant-baseline="middle" font-family="Georgia, 'Times New Roman', serif" font-style="italic">R</text>
<text x="181.2" y="12.6" fill="#333" font-size="14" text-anchor="middle" dominant-baseline="middle" font-family="Georgia, 'Times New Roman', serif">conic: inscribed hexagon</text>
<circle cx="549.7" cy="179.4" r="105.0" stroke="#111" stroke-width="1.8" fill="none" fill-opacity="1"/>
<circle cx="549.7" cy="179.4" r="2.6" fill="#111"/>
<text x="558.2895569038734" y="186.27164552309867" fill="#222" font-size="15" text-anchor="middle" dominant-baseline="middle" font-family="Georgia, 'Times New Roman', serif" font-style="italic">K</text>
<path d="M 702.7,99.7 L 670.5,168.8 L 707.5,221.7 L 564.1,288.5 L 459.0,270.0 L 420.2,49.9 Z" stroke="#444" stroke-width="1.1" fill="none"/>
<line x1="705.8" y1="95.5" x2="561.0" y2="292.8" stroke="#1f5fbf" stroke-width="1.4" stroke-opacity="1"/>
<line x1="675.2" y1="166.5" x2="454.3" y2="272.3" stroke="#1f5fbf" stroke-width="1.4" stroke-opacity="1"/>
<line x1="712.0" y1="224.3" x2="415.7" y2="47.2" stroke="#1f5fbf" stroke-width="1.4" stroke-opacity="1"/>
<circle cx="702.7" cy="99.7" r="2.6" fill="#111"/>
<circle cx="670.5" cy="168.8" r="2.6" fill="#111"/>
<circle cx="707.5" cy="221.7" r="2.6" fill="#111"/>
<circle cx="564.1" cy="288.5" r="2.6" fill="#111"/>
<circle cx="459.0" cy="270.0" r="2.6" fill="#111"/>
<circle cx="420.2" cy="49.9" r="2.6" fill="#111"/>
<circle cx="567.9" cy="76.0" r="2.2" fill="#999"/>
<text x="569.8101299543362" y="65.16711471686571" fill="#666" font-size="12" text-anchor="middle" dominant-baseline="middle" font-family="Georgia, 'Times New Roman', serif">1</text>
<circle cx="644.8" cy="223.8" r="2.2" fill="#999"/>
<text x="654.7693856574031" y="228.4488008791477" fill="#666" font-size="12" text-anchor="middle" dominant-baseline="middle" font-family="Georgia, 'Times New Roman', serif">2</text>
<circle cx="635.7" cy="119.2" r="2.2" fill="#999"/>
<text x="644.710672487179" y="112.8906592001385" fill="#666" font-size="12" text-anchor="middle" dominant-baseline="middle" font-family="Georgia, 'Times New Roman', serif">3</text>
<circle cx="594.1" cy="274.5" r="2.2" fill="#999"/>
<text x="598.7488008791477" y="284.46938565740317" fill="#666" font-size="12" text-anchor="middle" dominant-baseline="middle" font-family="Georgia, 'Times New Roman', serif">4</text>
<circle cx="531.5" cy="282.8" r="2.2" fill="#999"/>
<text x="529.5898700456638" y="293.6328852831343" fill="#666" font-size="12" text-anchor="middle" dominant-baseline="middle" font-family="Georgia, 'Times New Roman', serif">5</text>
<circle cx="446.3" cy="197.6" r="2.2" fill="#999"/>
<text x="435.4671147168657" y="199.51012995433624" fill="#666" font-size="12" text-anchor="middle" dominant-baseline="middle" font-family="Georgia, 'Times New Roman', serif">6</text>
<circle cx="641.9" cy="182.5" r="4" fill="#1f5fbf"/>
<text x="646.0231056256176" y="198.99242250247065" fill="#1f5fbf" font-size="15" text-anchor="middle" dominant-baseline="middle" font-family="Georgia, 'Times New Roman', serif" font-style="italic">B</text>
<text x="563.9" y="12.6" fill="#333" font-size="14" text-anchor="middle" dominant-baseline="middle" font-family="Georgia, 'Times New Roman', serif">reciprocal circle: circumscribed hexagon</text>
</svg>
</div>

*Figure 5. The transfer to conics, with both halves computed in the same coordinates. Left: a hexagon inscribed in an ellipse with focus F, and its Pascal line. Right: the polar figure with respect to the dashed circle centred at F. Each vertex i becomes the tangent to the circle K at the grey point i; the hexagon becomes circumscribed; its main diagonals meet at B. The Pascal line PQR is exactly the polar of B.*

Brianchon's theorem for conics follows the same way. So the complete logical chain in Part I is:

  **Pascal (circle)** — by polarity in *M* → **Brianchon (circle)** — by polarity about a focus → **Pascal (conic)**.

### Second transfer (§ 26)

After §§ 24–25 exhibit conics as plane sections of a right circular cone, § 26 notes a second route. Pascal's and Brianchon's theorems "transfer at once from the circle to the conic", because a central projection preserves incidence and collinearity. Steiner adds the converse remark that *any* central projection of a circle satisfies both theorems. He then uses them to show that a conic is determined by five points (or five tangents), and to construct further points and tangents with a ruler alone.

---

## Sources

* Jacob Steiner, *Vorlesungen über synthetische Geometrie*, Theil I, ed. C. F. Geiser (Leipzig: Teubner, 1867). Scans: [Internet Archive](https://archive.org/details/bub_gb_jCgPAAAAQAAJ), [Gallica](https://gallica.bnf.fr/ark:/12148/bpt6k996746).
* The German quotations are transcribed from the Internet Archive OCR, with obvious OCR errors corrected. The figures are new drawings computed from exact coordinates, not reproductions of Geiser's plates.
