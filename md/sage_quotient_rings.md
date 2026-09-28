# Constructing finite quotient rings in Sage

Short answer: **yes to both** — quotients of rings of integers $\mathcal{O}_K$, and quotients of monogenic orders $\mathbb{Z}[\alpha]$ — but with different levels of built-in support. Sage has genuine machinery for this, though it's less polished for non-maximal orders.

## 1. Ring of integers $\mathcal{O}_K$, quotient by an ideal

This is the well-supported case.

```python
R.<x> = QQ[]
K.<a> = NumberField(x^3 - 2)
OK = K.maximal_order()          # = K.ring_of_integers()

I = OK.ideal(5, a - 1)          # any ideal, generators as elements of OK
Q.<b> = OK.quotient(I)          # or OK.quo(I)
Q
```

Key point: **give the quotient's generator a name** (`Q.<b> = OK.quotient(I)`, not just `Q = OK.quotient(I)`). There's a longstanding quirk where omitting the name breaks arithmetic in the quotient — this is a known Sage issue, not a mathematical limitation.

If $I$ happens to be prime, you can instead get the residue field directly (a nicer object when you know the ideal is maximal):

```python
P = K.ideal(5).factor()[0][0]
F.<c> = OK.residue_field(P)
```

`OK.quotient(I)` works for *any* nonzero ideal $I$, not just prime ones — you'll just get a finite ring rather than a field.

## 2. Monogenic order $\mathbb{Z}[\alpha]$, quotient by an ideal

Sage does support arbitrary (possibly non-maximal) orders and ideals in them, via `sage.rings.number_field.order` and `sage.rings.number_field.order_ideal`:

```python
R.<x> = QQ[]
K.<a> = NumberField(x^3 - 40)
O = K.order(a)          # this *is* Z[a] (assuming a generates a full-rank Z-module, which it does here)

I = O.ideal([13, a - 1])   # constructs a NumberFieldOrderIdeal
Q.<b> = O.quotient(I)      # should work via the generic CommutativeRing.quotient machinery
```

Caveat, stated candidly: the ideal-of-non-maximal-order functionality is explicitly flagged in Sage's own docs as "currently only very limited functionality" — things like primality testing, factoring, and general ideal arithmetic are less complete than for the maximal order. `O.quotient(I)` isn't specifically documented/tested the way `OK.quotient(I)` is, so **test it on your case first**; it may just work (the underlying `QuotientRing` machinery is generic to any commutative ring + ideal), but this can't be promised from documentation alone.

### Fallback that always works

If `O.quotient(I)` misbehaves, build the finite quotient ring by hand from the additive data, which Sage does support robustly for any order/ideal:

```python
M_O = O.free_module()        # Z-lattice of O
M_I = I.free_module()        # Z-lattice of I, contained in M_O
Ob = O.basis()

# additive quotient group O/I, with its structure
Qadd = M_O.quotient(M_I)

# to multiply: lift a class to a Z-linear combo of Ob, multiply in O,
# then push back down to Qadd via M_O.coordinate_vector() composed with the quotient map
def mult(x_rep, y_rep):
    xO = sum(c * O(g) for c, g in zip(x_rep, Ob))
    yO = sum(c * O(g) for c, g in zip(y_rep, Ob))
    return Qadd(M_O.coordinate_vector(vector((xO * yO))))
```

(This would normally be wrapped in a small class, or you'd just work with representative vectors directly — the point is `free_module()` + Smith normal form quotient always gives you the additive group correctly, `norm()`/index matches $|O/I|$, and multiplication is just "lift, multiply in $O$ (or $K$), reduce" using the coordinates Sage already exposes.)

## Practical recommendation

- For (1), just use `OK.quotient(I)` (naming the generator) — it's solid.
- For (2), try `O.quotient(I)` first for your specific case; if you hit missing functionality, fall back to the free-module construction above, which is guaranteed to work since it only relies on `free_module()`, `norm()`, and basic ring multiplication in $K$, all of which are properly supported for non-maximal orders.

## References

- [Orders in number fields — Sage Reference Manual](https://doc.sagemath.org/html/en/reference/number_fields/sage/rings/number_field/order.html)
- [Ideals of (Not Necessarily Maximal) Orders in Number Fields — Sage Reference Manual](https://doc.sagemath.org/html/en/reference/number_fields/sage/rings/number_field/order_ideal.html)
- [Quotient Rings — Sage Reference Manual](https://doc.sagemath.org/html/en/reference/rings/sage/rings/quotient_ring.html)
- [Quotienting a ring of integers — Ask Sage](https://ask.sagemath.org/question/9556/quotienting-a-ring-of-integers/)
