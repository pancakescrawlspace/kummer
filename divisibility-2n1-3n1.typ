#set page(paper: "a4", margin: (x: 2.0cm, y: 2.2cm), numbering: "1")
#set text(font: "New Computer Modern", size: 10.5pt)
#set par(justify: true)
#set heading(numbering: "1.")
#show link: set text(fill: blue.darken(20%))
#show raw.where(block: true): it => block(
  fill: luma(247), inset: 8pt, radius: 3pt, width: 100%, breakable: true,
  text(size: 8pt, it),
)

#align(center)[
  #text(size: 16pt, weight: "bold")[For which $n$ does $2^n + 1$ divide $3^n + 1$?]
  #v(2mm)
  #text(size: 10pt)[The companion to Problem 2017-3/C, with the odd-order argument
  replaced by a sign cancellation]
  #v(1mm)
  #text(size: 9pt, style: "italic")[René Pannekoek]
]

#v(4mm)

#block(fill: luma(240), inset: 8pt, radius: 3pt, width: 100%)[
  *Theorem.* The only $n in NN$ with $2^n + 1 divides 3^n + 1$ are $n = 0$ (trivially, $2 divides 2$)
  and $n = 2$ (where $5 divides 10$).
]

= The shape of the argument <sec-shape>

Problem 2017-3/C asked for all $n$ with $2^n - 1 divides 3^n - 1$, and the published solution of
Aart Blokhuis runs as follows. Even $n$ die immediately because $3 divides 2^n - 1$ while
$3 divides.not 3^n - 1$. For odd $n$, every prime $p divides 2^n - 1$ has $3^n equiv 1 (mod p)$ with $n$
odd, so $"ord"_p (3)$ is odd, so $3$ is a square mod $p$; quadratic reciprocity turns this into
$p equiv plus.minus 1 (mod 12)$, whence $2^n - 1 equiv plus.minus 1 (mod 12)$ --- but
$2^n - 1 equiv 7 (mod 12)$ for odd $n >= 3$.

The plus-sign problem admits the same three-step shape:

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *(a)* A parity step kills one residue class of $n$ outright (@sec-parity).

  #v(1.5mm)
  *(b)* A reciprocity step forces every prime divisor of $2^n plus 1$ into a proper subgroup
  of $(ZZ slash m ZZ)^times$ (@sec-qr).

  #v(1.5mm)
  *(c)* A direct computation of $2^n plus 1 mod m$ lands outside that subgroup (@sec-mod24).
]

What changes is step (b). With minus signs, $n$ odd makes $"ord"_p (3)$ odd, and oddness of the
order is what delivers the square. With plus signs the surviving $n$ are *even*, so the
odd-order trick is unavailable --- $"ord"_p (3)$ is in fact forced to be *even*. The replacement
is that $2^n$ and $3^n$ are both $equiv -1$, so the two signs cancel in the product:
$6^n equiv 1 (mod p)$. It is $6$, not $3$, whose quadratic character is pinned down, and the
modulus is accordingly $24$ rather than $12$.

= The parity step <sec-parity>

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Lemma 1.* If $n >= 1$ and $2^n + 1 divides 3^n + 1$, then $n$ is even; consequently
  $3 divides.not 2^n + 1$.

  #v(2mm)
  _Proof._ If $n$ is odd then $2^n equiv 2 equiv -1 (mod 3)$, so $3 divides 2^n + 1$. But
  $3^n + 1 equiv 1 (mod 3)$ for $n >= 1$, so $3 divides.not 3^n + 1$, contradicting the divisibility.
  Hence $n$ is even, and then $2^n equiv 1 (mod 3)$, so $2^n + 1 equiv 2 (mod 3)$. $qed$
]

The second clause matters: it is what allows us to speak of the Legendre symbol
$(6 slash p)$ for every prime $p$ dividing $2^n + 1$, since such a $p$ is now coprime to $6$.
This is the exact analogue of the role the parity step plays in 2017-3/C, where it is
what leaves $n$ odd for the order argument.

= The reciprocity step <sec-qr>

Throughout, fix $n = 2^a k$ with $k$ odd and, by Lemma 1, $a >= 1$. Write $N = 2^n + 1$ and
assume $N divides 3^n + 1$. We record the elementary $2$-adic fact that drives everything.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Lemma 2.* Let $p$ be an odd prime and $x in (ZZ slash p ZZ)^times$ with $x^n equiv -1 (mod p)$.
  Then $v_2 ("ord"_p (x)) = a + 1$, where $2^a parallel n$.

  #v(2mm)
  _Proof._ Put $e = "ord"_p (x)$. From $x^(2 n) equiv 1$ we get $e divides 2 n = 2^(a+1) k$, and from
  $x^n equiv.not 1$ we get $e divides.not n$. Write $e = 2^b c$ with $c$ odd; then $b <= a + 1$ and
  $c divides k$. If $b <= a$ then $e = 2^b c divides 2^a k = n$, a contradiction. So $b = a + 1$. $qed$
]

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Proposition 3.* Let $p$ be a prime dividing $N = 2^n + 1$, where $n$ is even and
  $N divides 3^n + 1$. Then $6$ is a quadratic residue mod $p$.

  #v(2mm)
  _Proof._ Both $p divides 2^n + 1$ and $p divides 3^n + 1$ hold, the latter because $p divides N divides 3^n + 1$;
  and $p$ is odd with $p != 3$ by Lemma 1. So
  $ 2^n equiv -1 (mod p), quad 3^n equiv -1 (mod p) . $

  Apply Lemma 2 to $x = 2$: $v_2 ("ord"_p (2)) = a + 1$. Since $"ord"_p (2) divides p - 1$,
  $ v_2 (p - 1) >= a + 1 . $

  Now multiply the two congruences. The signs cancel:
  $ 6^n = 2^n dot 3^n equiv (-1)(-1) = 1 (mod p) , $
  so $e := "ord"_p (6)$ divides $n = 2^a k$, giving $v_2 (e) <= a$. Write $p - 1 = 2^t s$ with $s$ odd;
  we have just seen $t >= a + 1$. Since $e divides p - 1$, the odd part of $e$ divides $s$; and
  $v_2 (e) <= a <= t - 1$. Therefore
  $ e divides 2^(t-1) s = (p - 1) slash 2 , $
  so $6^((p-1) slash 2) equiv 1 (mod p)$, i.e. $(6 slash p) = 1$. $qed$
]

It is worth isolating why the naive transposition of Blokhuis's argument fails, since it explains
the shape of the fix. One would like to argue that $3$ itself is a square mod $p$. But Lemma 2
applied to $x = 3$ gives $v_2 ("ord"_p (3)) = a + 1$ exactly, so $"ord"_p (3) divides (p-1) slash 2$
if and only if $v_2 (p - 1) >= a + 2$ --- and all we know is $v_2 (p - 1) >= a + 1$. The character
of $3$ alone is genuinely undetermined. Only the product $6$, whose order loses the factor
$2^(a+1)$ shared by $2$ and $3$, is forced.

= The congruence obstruction <sec-mod24>

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Lemma 4.* For a prime $p > 3$ with $p equiv 1 (mod 4)$: $(6 slash p) = 1$ if and only if
  $p equiv 1$ or $5 (mod 24)$. Moreover ${1, 5}$ is a subgroup of $(ZZ slash 24 ZZ)^times$.
]

#v(2mm)

For the "moreover": $5 dot 5 = 25 equiv 1 (mod 24)$. For the criterion, note first that
$N = 2^n + 1 = (2^(n slash 2))^2 + 1$ for even $n$, so $-1$ is a square mod every $p divides N$ and
hence $p equiv 1 (mod 4)$; this restricts $p mod 24$ to ${1, 5, 13, 17}$. Now
$(2 slash p) = 1$ iff $p equiv plus.minus 1 (mod 8)$, and since $p equiv 1 (mod 4)$ reciprocity gives
$(3 slash p) = (p slash 3)$, which is $1$ iff $p equiv 1 (mod 3)$. The four cases:

#v(2mm)
#align(center)[
#table(
  columns: 5,
  align: (center, center, center, center, center),
  stroke: 0.5pt + luma(160),
  inset: 6pt,
  table.header(
    [$p mod 24$], [$p mod 8$], [$p mod 3$], [$(2 slash p) dot (3 slash p)$], [$(6 slash p)$]
  ),
  [$1$],  [$1$], [$1$], [$(+1)(+1)$], [$+1$],
  [$5$],  [$5$], [$2$], [$(-1)(-1)$], [$+1$],
  [$13$], [$5$], [$1$], [$(-1)(+1)$], [$-1$],
  [$17$], [$1$], [$2$], [$(+1)(-1)$], [$-1$],
)
]

#v(3mm)

We can now finish.

#block(stroke: 0.6pt + black, inset: 9pt, radius: 3pt, width: 100%)[
  *Proof of the Theorem.* Let $n >= 1$ with $N = 2^n + 1$ dividing $3^n + 1$. By Lemma 1, $n$ is
  even. By Proposition 3 and Lemma 4, every prime factor of $N$ is $equiv 1$ or $5 (mod 24)$;
  since these form a subgroup, the product $N$ of such primes (with multiplicity) satisfies
  $ N equiv 1 "or" 5 (mod 24) . $

  But for even $n >= 4$ we have $8 divides 2^n$ and $2^n equiv 1 (mod 3)$, so $N equiv 1 (mod 8)$ and
  $N equiv 2 (mod 3)$, that is
  $ N = 2^n + 1 equiv 17 (mod 24) , $
  a contradiction. So no even $n >= 4$ survives; being even and $>= 1$, $n$ must be $2$, and indeed
  $2^2 + 1 = 5$ divides $3^2 + 1 = 10$. Together with the trivial $n = 0$ this exhausts the
  solutions. $qed$
]

The last step is perhaps cleanest as a single Jacobi symbol computation. For even $n >= 4$,
$N equiv 1 (mod 8)$ gives $(2 slash N) = 1$, while $N equiv 1 (mod 4)$ and $N equiv 2 (mod 3)$ give
$(3 slash N) = (N slash 3) = (2 slash 3) = -1$. Hence
$ (6 slash N) = -1 , $
which is incompatible with $(6 slash p) = +1$ for every prime $p divides N$, the Jacobi symbol being
the product of the Legendre symbols over the prime factors of $N$ with multiplicity.

= Numerical corroboration <sec-num>

The table below lists the first values; $r$ denotes $3^n + 1 mod (2^n + 1)$. The final column
shows the congruence class that Section 4 predicts is eventually constant at $17$.

#v(2mm)
#align(center)[
#table(
  columns: 6,
  align: (right, right, right, right, right, center),
  stroke: 0.5pt + luma(160),
  inset: 5pt,
  table.header(
    [$n$], [$2^n + 1$], [$3^n + 1$], [$r$], [$(2^n+1) mod 24$], [divides?]
  ),
  [0],  [2],    [2],      [0],    [2],  [yes],
  [1],  [3],    [4],      [1],    [3],  [no],
  [2],  [5],    [10],     [0],    [5],  [yes],
  [3],  [9],    [28],     [1],    [9],  [no],
  [4],  [17],   [82],     [14],   [17], [no],
  [5],  [33],   [244],    [13],   [9],  [no],
  [6],  [65],   [730],    [15],   [17], [no],
  [7],  [129],  [2188],   [124],  [9],  [no],
  [8],  [257],  [6562],   [137],  [17], [no],
  [9],  [513],  [19684],  [190],  [9],  [no],
  [10], [1025], [59050],  [625],  [17], [no],
  [11], [2049], [177148], [934],  [9],  [no],
  [12], [4097], [531442], [2929], [17], [no],
)
]

#v(3mm)

An exhaustive search over $0 <= n <= 20000$ returns exactly ${0, 2}$:

```python
sols = [n for n in range(20001) if pow(3, n, 2**n + 1) == (2**n) % (2**n + 1)]
# -> [0, 2]
```

Proposition 3 was also checked directly. For even $n <= 300$, the primes dividing
$gcd(2^n + 1, 3^n + 1)$ are $5, 29, 97, 101$, with residues $5, 5, 1, 5$ mod $24$ and
$(6 slash p) = +1$ throughout; and $(6 slash (2^n + 1)) = -1$ for every even $n$ from $4$ to $20$,
as the Jacobi computation above predicts.

= Remarks <sec-remarks>

*On the two moduli.* The minus problem is obstructed by the character of $3$ and the subgroup
$\{plus.minus 1\} subset (ZZ slash 12 ZZ)^times$; the plus problem by the character of $6$ and the
subgroup $\{1, 5\} subset (ZZ slash 24 ZZ)^times$. In both cases the obstruction bites because
$2^n$ stabilises modulo a small modulus --- $2^n - 1 equiv 7 (mod 12)$ for odd $n >= 3$,
$2^n + 1 equiv 17 (mod 24)$ for even $n >= 4$ --- so a single congruence disposes of all but
finitely many $n$ at once.

*On the cyclotomic reformulation.* Bas Edixhoven's solution to 2017-3/C replaces the appeal to
reciprocity by exhibiting a quadratic character of $(ZZ slash N ZZ)^times$ directly, via the
inclusion $ZZ[sqrt(-N)] subset ZZ[zeta_N]$ and the restriction of $sigma_3$ to the quadratic
subring, where it induces the $3$-Frobenius on
$ZZ[sqrt(-N)] slash 3 ZZ[sqrt(-N)] = FF_3 [X] slash (X^2 + 1)$. The same reformulation should
transpose here: one wants a quadratic character of $(ZZ slash N ZZ)^times$ that is nontrivial on
$6$, equivalently a quadratic subfield of $QQ(zeta_N)$ in which $6$ is inert. The elementary
argument above is short enough that we have not pursued this, but it is the reason the answer
depends only on $N mod 24$: $QQ(sqrt(2))$ and $QQ(sqrt(3))$ sit inside $QQ(zeta_8)$ and
$QQ(zeta_(12))$, and $24$ is the least common multiple.

*On generalisations.* Nothing in Sections 3--4 used the specific values $2$ and $3$ beyond
(i) that the parity step disposes of one class of $n$, and (ii) that the product $2 dot 3 = 6$ has
computable character. For $b^n + 1 divides c^n + 1$ the same cancellation gives
$(b c slash p) = 1$ for all $p divides b^n + 1$, and the question becomes whether $b^n + 1$ can lie in
the corresponding subgroup of $(ZZ slash 4 b c ZZ)^times$ --- a finite check once $b^n mod 4 b c$
becomes eventually periodic, which it always does.
