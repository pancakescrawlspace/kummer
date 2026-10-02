# =====================================================================
# circle-genus-zigzag.sage -- genus of the family obtained from a two-row
# zigzag by dropping ANY one tangency (circle-genus.typ).
#
#     cd kummer
#     sage circle-genus-zigzag.sage K [SECONDS] > ../results/circle-genus-zigzag-kK.txt
#
# Notation of circle-genus.sage: height 1, top row A_1..A_k, bottom row
# B_1..B_k, the pattern a lattice path of cross tangencies A_i B_j, signed
# square roots a = sqrt r of the radii, K = Q(sqrt 2).
#
# Construction.  The configuration is built with as few parameters as
# possible, by propagation:
#   - left corner (A_1, B_1 touch each other, the left side, the top and the
#     bottom): a_1 = t, b_1 = 1 - t;  right corner likewise from v, with the
#     width W as a further parameter;
#   - one step (lemma of circle-genus.typ): if A_i, B_j are known and touch,
#     and A_{i+1} touches the top, A_i and B_j, then
#         a_i / a_{i+1} = Y_j - X_i + eps sqrt2 b_j,  X_{i+1} = X_i + 2 a_i a_{i+1},
#     and the mirror image of this to the left, and the same for B; eps is
#     the root that holds at the packing;
#   - a circle on a line touching a known neighbour on that line, or a side,
#     gets its x-coordinate linearly from its (new parameter) square root;
#   - otherwise a new parameter: (a, X) for a circle on a line, (x, y, r)
#     for a circle that touches neither line.
# Every tangency not guaranteed by the construction becomes an equation.
# The ideal is saturated by the denominators and the parameters, the prime
# through the packing is kept, and its genus computed by Singular.  The
# parameter curve maps onto the family of configurations; to check that
# this map is birational, the genus is also computed for the image under
# (geometric parameters, squares of the square-root parameters): if both
# genera agree, so does the genus of the family, which lies in between.
# =====================================================================
import sys, time, json
from collections import Counter
from cysignals.signals import AlarmInterrupt

KMAX = int(sys.argv[1]) if len(sys.argv) > 1 and sys.argv[1] != 'one' else 4
TLIM = int(sys.argv[2]) if len(sys.argv) > 2 and sys.argv[1] != 'one' else 600
SHARD = int(sys.argv[3]) if len(sys.argv) > 3 and sys.argv[1] != 'one' else 0
NSHARDS = int(sys.argv[4]) if len(sys.argv) > 4 and sys.argv[1] != 'one' else 1
KMIN = int(sys.argv[5]) if len(sys.argv) > 5 and sys.argv[1] != 'one' else 2

K.<s> = QuadraticField(2)
RF = RealField(400)
embp = [e for e in K.embeddings(RF) if e(s) > 0][0]
NP = 12
PR = PolynomialRing(K, ['W'] + ['q%d' % i for i in range(NP)], order='degrevlex')
FFP = PR.fraction_field()
Wv = PR.gen(0)


def lattice_paths(k):
    out = []
    def rec(p):
        i, j = p[-1]
        if (i, j) == (k, k):
            out.append(p); return
        if i < k: rec(p + [(i + 1, j)])
        if j < k: rec(p + [(i, j + 1)])
    rec([(1, 1)])
    return out


def pstr(path):
    return ' '.join('%d%d' % e for e in path)


def packing(k, path):
    """The rigid packing, numerically: dict label -> (x, y, r), and W."""
    load_t = None
    q = sqrt(RF(2))
    def run(tv):
        a = {1: tv}; b = {1: 1 - tv}; X = {1: tv^2}; Y = {1: (1 - tv)^2}
        for (i, j), (i2, j2) in zip(path, path[1:]):
            if i2 == i + 1:
                a[i2] = a[i] / (Y[j] - X[i] + q * b[j]); X[i2] = X[i] + 2 * a[i] * a[i2]
            else:
                b[j2] = b[j] / (X[i] - Y[j] + q * a[i]); Y[j2] = Y[j] + 2 * b[j] * b[j2]
        return a, b, X, Y
    # the closing equation as a polynomial in t: solve by bisection on the honest root
    # (scan (0,1) for sign changes of the closing function, keep the honest one)
    def close(tv):
        a, b, X, Y = run(tv)
        return X[k] + a[k]^2 - Y[k] - b[k]^2
    cands = []
    N = 4000
    prev = None
    for n_ in range(1, N):
        tv = RF(n_) / N
        try:
            c = close(tv)
        except ZeroDivisionError:
            prev = None; continue
        if prev is not None and prev[1] * c < 0 and abs(prev[1]) < 1 and abs(c) < 1:
            lo, hi = prev[0], tv
            for _ in range(400):
                mid = (lo + hi) / 2
                if close(lo) * close(mid) <= 0: hi = mid
                else: lo = mid
            cands.append(lo)
        prev = (tv, c)
    for tv in cands:
        a, b, X, Y = run(tv)
        if min(a.values()) <= 0 or min(b.values()) <= 0:
            continue
        W = X[k] + a[k]^2
        C = {}
        for i in a: C['A%d' % i] = (X[i], 1 - a[i]^2, a[i]^2)
        for j in b: C['B%d' % j] = (Y[j], b[j]^2, b[j]^2)
        if honest(C, W):
            return C, W
    raise ValueError('no packing for %s' % pstr(path))


def honest(C, W, tol=RF(1e-30)):
    L = list(C.items())
    for nm, (x, y, r) in L:
        if r <= 0 or x - r < -tol or x + r > W + tol or y - r < -tol or y + r > 1 + tol:
            return False
    for p in range(len(L)):
        for q in range(p + 1, len(L)):
            (x1, y1, r1), (x2, y2, r2) = L[p][1], L[q][1]
            if sqrt((x1 - x2)^2 + (y1 - y2)^2) - r1 - r2 < -tol:
                return False
    return True


def tangencies(k, path):
    T = set()
    for i in range(1, k + 1):
        T.add(('wall', 'A%d' % i, 'top')); T.add(('wall', 'B%d' % i, 'bottom'))
    for c in ('A1', 'B1'): T.add(('wall', c, 'left'))
    for c in ('A%d' % k, 'B%d' % k): T.add(('wall', c, 'right'))
    for i in range(1, k):
        T.add(('cc', 'A%d' % i, 'A%d' % (i + 1))); T.add(('cc', 'B%d' % i, 'B%d' % (i + 1)))
    for i, j in path:
        T.add(('cc', 'A%d' % i, 'B%d' % j))
    return T


def sym_images(k, tau):
    """Images of a tangency under the symmetries of the rectangle, with the
    corresponding path maps."""
    def relabel(c, f):
        return f(c[0], int(c[1:]))
    maps = []
    for swap in (False, True):
        for mirror in (False, True):
            def f(row, i, swap=swap, mirror=mirror):
                row2 = {'A': 'B', 'B': 'A'}[row] if swap else row
                return row2 + str(k + 1 - i if mirror else i)
            def side(sd, swap=swap, mirror=mirror):
                if sd in ('top', 'bottom'):
                    return {'top': 'bottom', 'bottom': 'top'}[sd] if swap else sd
                return {'left': 'right', 'right': 'left'}[sd] if mirror else sd
            def pmap(path, swap=swap, mirror=mirror):
                q = [((j, i) if swap else (i, j)) for i, j in path]
                if mirror:
                    q = [(k + 1 - i, k + 1 - j) for i, j in q]
                return tuple(sorted(q))
            def tmap(tau, f=f, side=side):
                if tau[0] == 'wall':
                    return ('wall', f(tau[1][0], int(tau[1][1:])), side(tau[2]))
                a, b = sorted([f(tau[1][0], int(tau[1][1:])), f(tau[2][0], int(tau[2][1:]))])
                return ('cc', a, b)
            maps.append((pmap, tmap))
    return maps


def canonical(k, path, tau):
    return min((str(pm(path)), str(tm(tau))) for pm, tm in sym_images(k, tau))


class Build:
    """Propagation for the pattern T (a set of tangencies) of a zigzag."""

    def __init__(self, k, T, C, W):
        self.k, self.T, self.C, self.Wn = k, T, C, W
        self.known = {}          # label -> dict(kind='line'/'free', line, X, a) or (x, y, r)
        self.used = set()
        self.params = []         # (name, kind, numeric value)
        self.q = 0
        self.vals = {'W': W}
        self.signs = []
        self.meaning = {'W': ('W',)}

    def newp(self, kind, value, meaning=None):
        g = PR.gen(1 + self.q)
        self.params.append((str(g), kind, value))
        self.meaning[str(g)] = meaning
        self.vals[str(g)] = value
        self.q += 1
        assert self.q <= NP
        return FFP(g)

    def line_of(self, c):
        if ('wall', c, 'top') in self.T: return 'top'
        if ('wall', c, 'bottom') in self.T: return 'bottom'
        return None

    def has(self, *tau):
        if tau[0] == 'cc':
            a, b = sorted(tau[1:])
            return ('cc', a, b) in self.T
        return tau in self.T

    def use(self, *tau):
        if tau[0] == 'cc':
            a, b = sorted(tau[1:]); tau = ('cc', a, b)
        self.used.add(tau)

    def num(self, e):
        n_, d_ = e.numerator(), e.denominator()
        vals = [self.vals['W']] + [self.vals.get('q%d' % i, 0) for i in range(NP)]
        return n_.map_coefficients(embp, RF)(*vals) / d_.map_coefficients(embp, RF)(*vals)

    def set_line(self, c, X, a, line):
        self.known[c] = dict(kind='line', line=line, X=X, a=a)
        # sanity: agrees with the packing
        x0, y0, r0 = self.C[c]
        assert abs(self.num(X) - x0) < 1e-50 and abs(self.num(a)^2 - r0) < 1e-50, (c, self.num(X), x0)
        self.use('wall', c, line)

    def run(self):
        k = self.k
        Wf = FFP(Wv)
        # corners
        for side, i1 in (('left', 1), ('right', k)):
            A, B = 'A%d' % i1, 'B%d' % i1
            if all(self.has(*tau) for tau in (('wall', A, side), ('wall', B, side), ('cc', A, B), ('wall', A, 'top'), ('wall', B, 'bottom'))):
                p = self.newp('geo', sqrt(self.C[A][2]), (A, 'a'))
                if side == 'left':
                    self.set_line(A, p^2, p, 'top'); self.set_line(B, (1 - p)^2, 1 - p, 'bottom')
                else:
                    self.set_line(A, Wf - p^2, p, 'top'); self.set_line(B, Wf - (1 - p)^2, 1 - p, 'bottom')
                for tau in (('wall', A, side), ('wall', B, side), ('cc', A, B)):
                    self.use(*tau)
        while True:
            if self.propagate():
                continue
            if len(self.known) == 2 * k:
                break
            self.introduce()

    def propagate(self):
        k = self.k
        rows = {'A': 'top', 'B': 'bottom'}
        for c1, d1 in list(self.known.items()):
            if d1['kind'] != 'line':
                continue
            for c2, d2 in list(self.known.items()):
                if d2['kind'] != 'line' or c1[0] == c2[0] or c1[0] != 'A':
                    continue
                if not self.has('cc', c1, c2):
                    continue
                # A = c1 (top), B = c2 (bottom) touch; try to add a neighbour of either
                for (base, other) in ((c1, c2), (c2, c1)):
                    row, i = base[0], int(base[1:])
                    for step in (+1, -1):
                        nb = row + str(i + step)
                        if not 1 <= i + step <= k or nb in self.known:
                            continue
                        if not (self.has('cc', base, nb) and self.has('cc', nb, other) and self.line_of(nb) == rows[row]):
                            continue
                        db, do = self.known[base], self.known[other]
                        D = do['X'] - db['X']                  # Y - X for (base = A), mirrored otherwise
                        cands = []
                        for eps in (1, -1):
                            if step == +1:
                                den = (do['X'] - db['X'] + eps * s * do['a'])
                            else:
                                den = (db['X'] - do['X'] + eps * s * do['a'])
                            if den == 0:
                                continue
                            anew = db['a'] / den
                            Xnew = db['X'] + step * 2 * db['a'] * anew
                            try:
                                ok = abs(self.num(Xnew) - self.C[nb][0]) < 1e-50 and abs(self.num(anew)^2 - self.C[nb][2]) < 1e-50
                            except ZeroDivisionError:
                                ok = False
                            if ok:
                                cands.append((eps, anew, Xnew))
                        if not cands:
                            continue
                        eps, anew, Xnew = cands[0]
                        self.signs.append(eps)
                        self.set_line(nb, Xnew, anew, rows[row])
                        self.use('cc', base, nb); self.use('cc', nb, other)
                        return True
        return False

    def introduce(self):
        """New parameters for one unknown circle: prefer a circle on a line
        with a known neighbour on that line (then X is linear), or touching
        a side."""
        k = self.k
        Wf = FFP(Wv)
        cands = []
        for row in 'AB':
            for i in range(1, k + 1):
                c = row + str(i)
                if c in self.known:
                    continue
                line = self.line_of(c)
                score = 0
                if line:
                    score += 1
                    for nb in (row + str(i - 1), row + str(i + 1)):
                        if nb in self.known and self.known[nb]['kind'] == 'line' and self.has('cc', c, nb):
                            score += 2
                    if self.has('wall', c, 'left') or self.has('wall', c, 'right'):
                        score += 2
                cands.append((score, c))
        score, c = max(cands)
        line = self.line_of(c)
        x0, y0, r0 = self.C[c]
        if line:
            a = self.newp('sqrt', sqrt(r0), (c, 'a'))
            row, i = c[0], int(c[1:])
            X = None
            for nb, step in ((row + str(i - 1), +1), (row + str(i + 1), -1)):
                if X is None and nb in self.known and self.known[nb]['kind'] == 'line' and self.has('cc', c, nb):
                    sg = 1 if x0 > self.C[nb][0] else -1
                    X = self.known[nb]['X'] + sg * 2 * self.known[nb]['a'] * a
                    # the sign of the product is fixed by the packing
                    if abs(self.num(X) - x0) > 1e-50:
                        X = self.known[nb]['X'] - sg * 2 * self.known[nb]['a'] * a
                    self.use('cc', c, nb)
            if X is None and self.has('wall', c, 'left'):
                X = a^2; self.use('wall', c, 'left')
            if X is None and self.has('wall', c, 'right'):
                X = Wf - a^2; self.use('wall', c, 'right')
            if X is None:
                X = self.newp('geo', x0, (c, 'X'))
            self.set_line(c, X, a, line)
        else:
            x = self.newp('geo', x0, (c, 'X')); y = self.newp('geo', y0, (c, 'y')); r = self.newp('geo', r0, (c, 'r'))
            self.known[c] = dict(kind='free', x=x, y=y, r=r)

    def xyr(self, c):
        d = self.known[c]
        if d['kind'] == 'free':
            return d['x'], d['y'], d['r']
        r = d['a']^2
        return d['X'], (1 - r if d['line'] == 'top' else r), r

    def equations(self):
        eqs = []
        Wf = FFP(Wv)
        for tau in sorted(self.T - self.used):
            if tau[0] == 'wall':
                x, y, r = self.xyr(tau[1])
                e = {'top': y + r - 1, 'bottom': y - r, 'left': x - r, 'right': Wf - x - r}[tau[2]]
            else:
                c1, c2 = tau[1], tau[2]
                d1, d2 = self.known[c1], self.known[c2]
                if d1['kind'] == 'line' and d2['kind'] == 'line' and d1['line'] == d2['line']:
                    sg = 1 if self.C[c2][0] > self.C[c1][0] else -1
                    e = d2['X'] - d1['X'] - sg * 2 * d1['a'] * d2['a']
                else:
                    x1, y1, r1 = self.xyr(c1); x2, y2, r2 = self.xyr(c2)
                    e = (x1 - x2)^2 + (y1 - y2)^2 - (r1 + r2)^2
            assert abs(self.num(e)) < 1e-40, (tau, self.num(e))
            eqs.append((tau, e))
        return eqs


def point_vector(B, ring):
    return [B.vals.get(str(g), 0) for g in ring.gens()]


def vanishes(g, pt):
    gg = g.map_coefficients(embp, RF)
    scale = max(abs(c) for c in gg.coefficients()) * max(1, max(abs(c) for c in pt))^max(1, g.degree())
    return abs(gg(*pt)) < scale * RF(10)^-80


from sage.libs.singular.function import singular_function, lib as singular_lib
singular_lib('normal.lib')
_sgenus = singular_function('genus')
PRIMES = (1000033, 1000081)          # both = 1 mod 8, so sqrt 2 lies in F_p


def genus_modp(P, ring, p):
    """Genus of the reduction of the prime P modulo a prime of K above p
    (sqrt 2 -> a square root of 2 mod p).  None if the reduction is not
    a single reduced curve."""
    F = GF(p)
    r2 = F(2).sqrt()
    Rp = PolynomialRing(F, [str(g) for g in ring.gens()], order='degrevlex')
    red = lambda c: F(c[0]) + F(c[1]) * r2
    gens = []
    for g in P.gens():
        gens.append(sum(red(c) * Rp.monomial(*m) for m, c in g.dict().items()))
    Ip = Rp.ideal(gens)
    comps = Ip.minimal_associated_primes()
    if len(comps) != 1 or comps[0].dimension() != 1:
        return None
    if Ip.radical() != Ip:
        Ip = Ip.radical()
    return ZZ(_sgenus(Ip))


def genus_of_prime(P, ring):
    gs = [genus_modp(P, ring, p) for p in PRIMES]
    return gs


def toQ(e, R):
    """A polynomial over K in the parameter ring -> R = Q[s, ...] (s = sqrt 2)."""
    out = R(0)
    for m, c in e.dict().items():
        mon = prod(R(str(g))^ex for g, ex in zip(e.parent().gens(), m) if ex)
        out += (c[0] + c[1] * R('s')) * mon
    return out


def genus_modp_Q(P, R, p, drop=()):
    """Genus of the reduction of a prime P of Q[s, ...] (containing s^2 - 2)
    modulo p, at s = a square root of 2 mod p.  None if that reduction is
    not a single reduced curve."""
    F = GF(p)
    r2 = F(2).sqrt()
    names = [str(g) for g in R.gens() if str(g) != 's' and str(g) not in drop]
    Rp = PolynomialRing(F, names, order='degrevlex')
    sub = {R('s'): r2}
    imgs = [Rp(nm) if nm in names else F(0) for nm in [str(g) for g in R.gens()]]
    gens = []
    for g in P.gens():
        h = g.map_coefficients(F, F) if False else None
        val = sum(F(c) * prod((r2 if str(v) == 's' else Rp(str(v)))^ex for v, ex in zip(R.gens(), m)) for m, c in g.dict().items())
        gens.append(Rp(val))
    Ip = Rp.ideal(gens)
    comps = Ip.minimal_associated_primes()
    if len(comps) != 1 or comps[0].dimension() != 1:
        return None
    return ZZ(_sgenus(comps[0]))


Rt.<tt> = K[]


def rigid_f(k, path, t0):
    """The irreducible factor over K of the closing equation of the rigid
    packing that vanishes at t0."""
    FFt = Rt.fraction_field()
    a = {1: FFt(tt)}; b = {1: 1 - FFt(tt)}; X = {1: FFt(tt)^2}; Y = {1: (1 - FFt(tt))^2}
    for (i, j), (i2, j2) in zip(path, path[1:]):
        if i2 == i + 1:
            a[i2] = a[i] / (Y[j] - X[i] + s * b[j]); X[i2] = X[i] + 2 * a[i] * a[i2]
        else:
            b[j2] = b[j] / (X[i] - Y[j] + s * a[i]); Y[j2] = Y[j] + 2 * b[j] * b[j2]
    E = (X[k] + a[k]^2 - Y[k] - b[k]^2).numerator()
    hits = [f for f, _ in E.factor() if abs(f.map_coefficients(embp, RF)(t0)) < RF(10)^-60]
    assert len(hits) == 1
    return hits[0]


def packing_modp(k, path, f, p):
    """Points over F_p reducing from the conjugates of the packing: for each
    root of f modulo a prime above p, all a, X, b, Y and W."""
    F = GF(p); r2 = F(2).sqrt()
    fp = PolynomialRing(F, 'z')([F(c[0]) + F(c[1]) * r2 for c in f.list()])
    out = []
    for tb in fp.roots(multiplicities=False):
        try:
            a = {1: tb}; b = {1: 1 - tb}; X = {1: tb^2}; Y = {1: (1 - tb)^2}
            for (i, j), (i2, j2) in zip(path, path[1:]):
                if i2 == i + 1:
                    a[i2] = a[i] / (Y[j] - X[i] + r2 * b[j]); X[i2] = X[i] + 2 * a[i] * a[i2]
                else:
                    b[j2] = b[j] / (X[i] - Y[j] + r2 * a[i]); Y[j2] = Y[j] + 2 * b[j] * b[j2]
        except ZeroDivisionError:
            continue
        vals = {'W': X[k] + a[k]^2}
        for i in a: vals[('A%d' % i, 'a')] = a[i]; vals[('A%d' % i, 'X')] = X[i]; vals[('A%d' % i, 'y')] = 1 - a[i]^2; vals[('A%d' % i, 'r')] = a[i]^2
        for j in b: vals[('B%d' % j, 'a')] = b[j]; vals[('B%d' % j, 'X')] = Y[j]; vals[('B%d' % j, 'y')] = b[j]^2; vals[('B%d' % j, 'r')] = b[j]^2
        out.append(vals)
    return out


PRIMES_SEARCH = [p for p in prime_range(1000000, 1003000) if p % 8 in (1, 7)]


def genus_at(B, eqs, f, k, path, p, sq):
    """Genus over F_p of the component through a reduced conjugate of the
    packing: (parameter curve, its image under squaring the square-root
    parameters).  None if no usable point."""
    F = GF(p); r2 = F(2).sqrt()
    pnames = ['W'] + [nm for nm, kind, val in B.params]
    Rp = PolynomialRing(F, pnames, order='degrevlex')
    def redp(e):
        out = Rp(0)
        for m, c in e.dict().items():
            out += (F(c[0]) + F(c[1]) * r2) * prod(Rp(str(g))^ex for g, ex in zip(PR.gens(), m) if ex)
        return out
    gens = [redp(PR(e.numerator())) for _, e in eqs]
    for vals in packing_modp(k, path, f, p):
        pt = [vals['W'] if nm == 'W' else vals[B.meaning[nm]] for nm in pnames]
        if any(g(*pt) != 0 for g in gens):
            continue
        Jm = matrix(F, [[g.derivative(Rp(nm))(*pt) for nm in pnames] for g in gens])
        if len(pnames) - Jm.rank() != 1:
            continue                             # not a smooth point of a curve mod p
        comps = [Q for Q in Rp.ideal(gens).minimal_associated_primes() if all(g(*pt) == 0 for g in Q.gens())]
        if len(comps) != 1 or comps[0].dimension() != 1:
            continue
        Q = comps[0]
        g1 = ZZ(_sgenus(Q))
        if not sq or g1 == 0:
            return g1, g1        # an image of a rational curve is rational (Lueroth)
        S = PolynomialRing(F, pnames + ['R_' + nm for nm in sq], order='degrevlex')
        QS = S.ideal([S(str(g)) for g in Q.gens()] + [S('R_' + nm) - S(nm)^2 for nm in sq])
        E = QS.elimination_ideal([S(nm) for nm in sq])
        Sg = PolynomialRing(F, [nm for nm in pnames if nm not in sq] + ['R_' + nm for nm in sq], order='degrevlex')
        Eg = Sg.ideal([Sg(str(g)) for g in E.gens()])
        cg = Eg.minimal_associated_primes()
        g2 = ZZ(_sgenus(cg[0])) if len(cg) == 1 and cg[0].dimension() == 1 else None
        return g1, g2
    return None


def analyse(k, path, tau, C, W):
    T = tangencies(k, path) - {tau}
    B = Build(k, T, C, W)
    B.run()
    eqs = B.equations()
    pnames = ['W'] + [nm for nm, kind, val in B.params]
    out = dict(nparams=len(B.params), neqs=len(eqs), kinds=[kind for _, kind, _ in B.params], params=pnames, signs=B.signs)
    # local dimension at the packing
    pt = [B.vals[nm] for nm in pnames]
    Rn = PolynomialRing(K, pnames)
    nums = [Rn(str(PR(e.numerator()))) if False else PR(e.numerator()) for _, e in eqs]
    vals = [B.vals['W']] + [B.vals.get('q%d' % i, 0) for i in range(NP)]
    rows = []
    for g in nums:
        row = [g.derivative(PR(nm)).map_coefficients(embp, RF)(*vals) for nm in pnames]
        nr = sqrt(sum(x^2 for x in row))
        rows.append([RDF(x / nr) if nr else RDF(0) for x in row])
    Jm = matrix(RDF, rows) if rows else matrix(RDF, 0, len(pnames))
    sv = Jm.singular_values() if Jm.nrows() else []
    out['local_dim'] = len(pnames) - sum(1 for x in sv if x > 1e-9 * max(sv)) if sv else len(pnames)
    if out['local_dim'] != 1:
        return out
    t0 = sqrt(C['A1'][2])
    f = rigid_f(k, path, t0)
    sq = [nm for nm, kind, val in B.params if kind == 'sqrt']
    res = []
    for p in PRIMES_SEARCH:
        r = genus_at(B, eqs, f, k, path, p, sq)
        if r is not None:
            res.append(r)
        if len(res) == 2:
            break
    out['genus_param'] = [r[0] for r in res]
    out['genus_image'] = [r[1] for r in res]
    out['eqs'] = eqs
    return out


def tstr(tau):
    if tau[0] == 'wall':
        return '%s-%s' % (tau[1], tau[2])
    return tau[1] + tau[2]


ONE = None
if len(sys.argv) > 1 and sys.argv[1] == 'one':
    # one case in a fresh process: sage circle-genus-zigzag.sage one K 'PATH' TAU
    k = int(sys.argv[2])
    path = [(int(w[0]), int(w[1])) for w in sys.argv[3].split()]
    tau_s = sys.argv[4]
    T = tangencies(k, path)
    tau = [x for x in T if tstr(x) == tau_s][0]
    C, W = packing(k, path)
    t1 = time.time()
    o = analyse(k, path, tau, C, W)
    g, gi = o.get('genus_param'), o.get('genus_image')
    if o['local_dim'] != 1:
        res = 'local dimension %d' % o['local_dim']
    elif len(set(g + gi)) == 1 and None not in g + gi:
        res = 'genus %d' % g[0]
    else:
        res = 'genus mod p: parameter curve %s, image %s' % (g, gi)
    print(' %-22s drop %-10s params %-28s eqs %d  %s   [%.0fs]'
          % (pstr(path), tstr(tau), ','.join(o['kinds']), o['neqs'], res, time.time() - t1), flush=True)
    sys.exit(0)

if __name__ == '__main__' or True:
    for k in range(KMIN, KMAX + 1):
        print('=' * 78)
        print(' k = %d: every tangency of every two-row zigzag, one per symmetry class' % k)
        print('=' * 78)
        seen = {}
        stats = Counter()
        T0 = time.time()
        for path in lattice_paths(k):
            C, W = packing(k, path)
            for tau in sorted(tangencies(k, path)):
                key = canonical(k, path, tau)
                if key in seen:
                    continue
                seen[key] = True
                if (len(seen) - 1) % NSHARDS != SHARD:
                    continue
                t1 = time.time()
                try:
                    alarm(TLIM)
                    o = analyse(k, path, tau, C, W)
                    cancel_alarm()
                    if o['local_dim'] != 1:
                        res = 'local dimension %d' % o['local_dim']
                        stats['local dim %d' % o['local_dim']] += 1
                    else:
                        g, gi = o['genus_param'], o['genus_image']
                        if len(set(g + gi)) == 1 and None not in g + gi:
                            res = 'genus %d' % g[0]
                        else:
                            res = 'genus mod p: parameter curve %s, image %s' % (g, gi)
                        stats[res] += 1
                    print(' %-22s drop %-10s params %-28s eqs %d  %s   [%.0fs]'
                          % (pstr(path), tstr(tau), ','.join(o['kinds']), o['neqs'], res, time.time() - t1), flush=True)
                    if o['local_dim'] == 1 and any(x is not None and x > 0 for x in o['genus_param'] + o['genus_image']):
                        print('      equations: %s' % [(tstr(t_), e.numerator()) for t_, e in o['eqs']], flush=True)
                except AlarmInterrupt:
                    stats['timeout'] += 1
                    print(' %-22s drop %-10s TIMEOUT' % (pstr(path), tstr(tau)), flush=True)
                except Exception as e:
                    cancel_alarm()
                    stats['error'] += 1
                    print(' %-22s drop %-10s ERROR %s' % (pstr(path), tstr(tau), str(e)[:120]), flush=True)
        print()
        print(' k = %d: %d classes;  %s   (%.0fs)' % (k, len(seen), ', '.join('%s: %d' % kv for kv in sorted(stats.items())), time.time() - T0))
        print()
