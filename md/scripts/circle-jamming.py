#!/usr/bin/env python3
"""Are the circle packings of kummer/circle-packings.typ jammed?

The note is md/circle-packings-jamming.md.  The packings are read from
kummer/circle-packings.json (written by kummer/circle-packings.py).

Jamming is about the packing as a *tensegrity*: the radii are fixed, the
centres may move, and every contact is an inequality -- two tangent
circles may separate but not overlap, a circle touching a side may move
away from it but not through it.  Writing v for the velocities of the
centres (and, for strict jamming, dW, dH for the rate of change of the
box), every contact k gives a linear inequality (A v)_k >= 0:

    circles i, j tangent, unit normal u from i to j:   (v_j - v_i) . u >= 0
    circle i on the bottom / left side:                 v_iy >= 0 / v_ix >= 0
    circle i on the top / right side:                   dH - v_iy >= 0 / dW - v_ix >= 0
    strict jamming only, area may not grow:             -(H dW + W dH) >= 0

(dW = dH = 0 for collective jamming.)  A first-order motion is a v with
A v >= 0.  For packings, first order is the whole story: if A v >= 0 then
the straight-line motion z + t v keeps every constraint for small t > 0,
because |d + t e|^2 = |d|^2 + 2t d.e + t^2 |e|^2 and the quadratic term
only helps.  So

    jammed  <=>  the only v with A v >= 0 is v = 0
            <=>  ker A = 0  and  some stress w > 0 has w^T A = 0

(the second line is Stiemke's alternative).  A strictly positive stress
is a set of contact forces, all of them pushing, in equilibrium.  The
script checks the rank, finds the stress maximising its smallest entry
(normalised to sum 1) by linear programming, and cross-checks with the
primal LP  max sum(A v) subject to A v >= 0, |v_i| <= 1, which is zero
exactly when a positive stress exists.

    cd md/scripts
    sage -python circle-jamming.py      # needs numpy and scipy
"""
import json
import os

import numpy as np
from scipy.optimize import linprog

HERE = os.path.dirname(os.path.abspath(__file__))
DATA = os.path.join(HERE, '..', '..', 'kummer', 'circle-packings.json')


def contact_matrix(p, strict):
    """Rows of A and a label for each.  Variables: (x_0, y_0, ..., x_{n-1},
    y_{n-1}) and, if strict, dW, dH."""
    cs = p['circles']
    n = len(cs)
    nv = 2 * n + (2 if strict else 0)
    rows, labels = [], []
    for i, j in p['cc']:
        d = np.array([cs[j]['x'] - cs[i]['x'], cs[j]['y'] - cs[i]['y']])
        u = d / np.linalg.norm(d)
        row = np.zeros(nv)
        row[2 * i:2 * i + 2] = -u
        row[2 * j:2 * j + 2] = u
        rows.append(row)
        labels.append('%s-%s' % (name(cs, i), name(cs, j)))
    for i, side in p['walls']:
        row = np.zeros(nv)
        if side == 'bottom':
            row[2 * i + 1] = 1
        elif side == 'left':
            row[2 * i] = 1
        elif side == 'top':
            row[2 * i + 1] = -1
            if strict:
                row[2 * n + 1] = 1
        elif side == 'right':
            row[2 * i] = -1
            if strict:
                row[2 * n] = 1
        rows.append(row)
        labels.append('%s-%s' % (name(cs, i), side))
    if strict:
        row = np.zeros(nv)
        row[2 * n] = -1.0          # -(H dW + W dH) with H = 1
        row[2 * n + 1] = -p['W']
        rows.append(row)
        labels.append('area')
    return np.array(rows), labels


def name(cs, i):
    return cs[i]['label'] or 'new%d' % i


def best_stress(A):
    """max s subject to A^T w = 0, w >= s, sum w = 1.  Returns (s, w)."""
    m = A.shape[0]
    # variables (w_1..w_m, s); minimise -s
    c = np.zeros(m + 1)
    c[-1] = -1
    A_eq = np.vstack([np.hstack([A.T, np.zeros((A.shape[1], 1))]),
                      np.hstack([np.ones((1, m)), [[0]]])])
    b_eq = np.concatenate([np.zeros(A.shape[1]), [1]])
    A_ub = np.hstack([-np.eye(m), np.ones((m, 1))])          # s - w_k <= 0
    res = linprog(c, A_ub=A_ub, b_ub=np.zeros(m), A_eq=A_eq, b_eq=b_eq,
                  bounds=[(None, None)] * (m + 1), method='highs')
    if res.status != 0:          # no nonzero stress at all
        return -np.inf, np.zeros(m)
    return res.x[-1], res.x[:m]


def best_motion(A):
    """max sum(A v) subject to A v >= 0, -1 <= v <= 1: zero iff no motion
    breaks a contact."""
    nv = A.shape[1]
    res = linprog(-A.sum(axis=0), A_ub=-A, b_ub=np.zeros(A.shape[0]),
                  bounds=[(-1, 1)] * nv, method='highs')
    return -res.fun


def locally_jammed(p):
    """Each circle on its own, the others frozen: is it trapped?"""
    A, _ = contact_matrix(p, strict=False)
    free = []
    for i in range(len(p['circles'])):
        Ai = A[:, 2 * i:2 * i + 2]
        Ai = Ai[np.abs(Ai).sum(axis=1) > 0]
        if len(Ai) == 0 or np.linalg.matrix_rank(Ai) < 2 or best_stress(Ai)[0] <= 1e-9:
            free.append(name(p['circles'], i))
    return free


def analyse(p, strict):
    A, labels = contact_matrix(p, strict)
    sv = np.linalg.svd(A, compute_uv=False)
    rank = int((sv > 1e-9).sum())
    s, w = best_stress(A)
    motion = best_motion(A)
    jammed = rank == A.shape[1] and s > 1e-9
    # Stiemke: a stress w > 0 exists  <=>  no v with A v >= 0 opens a contact
    assert (s > 1e-9) == (motion < 1e-9), (p['name'], strict, rank, s, motion)
    return {'contacts': A.shape[0], 'unknowns': A.shape[1], 'rank': rank,
            'sigma_min': sv[min(len(sv), A.shape[1]) - 1], 'stress_dim': A.shape[0] - rank,
            'min_stress': s, 'stress': w, 'labels': labels, 'motion': motion,
            'jammed': jammed}


def main():
    with open(DATA) as f:
        data = json.load(f)

    cases = [('six circles', data['six'])]
    for k in ('2', '3', '4'):
        for p in data['zigzag'][k]:
            cases.append(('zigzag k=%s %s' % (k, ' '.join('%d%d' % tuple(e) for e in p['path'])), p))
    cases.append(('three rows', data['three_rows']))
    cases.append(('six circles + 4 inserted', data['inserted']))
    for p in data['flex']:
        cases.append(("six circles minus BB', r(A) = %.3f" % p['t'], p))
    # controls, where the answer is known to be NO
    one = {'name': 'control', 'W': 2.0,
           'circles': [{'x': 0.5, 'y': 0.5, 'r': 0.5, 'label': 'D', 'row': 'top'}],
           'cc': [], 'walls': [[0, 'top'], [0, 'bottom'], [0, 'left']]}
    cases.append(('control: one disk, 2x1 box, 3 sides', one))
    six = data['six']
    rattler = dict(six, cc=[e for e in six['cc'] if 1 not in e],
                   walls=[w for w in six['walls'] if w[0] != 1])
    cases.append(('control: six circles, B a rattler', rattler))

    out = []
    say = out.append
    say('=' * 76)
    say(' Jamming of the packings in kummer/circle-packings.json')
    say('=' * 76)
    say('')
    say(' radii fixed, box fixed (collective) or allowed to change shape without')
    say(' growing in area (strict).  "jammed" <=> rank A = #unknowns and a stress')
    say(' w > 0 with w^T A = 0 exists; min w is the best smallest entry with')
    say(' sum w = 1.  The primal LP (largest first-order separation) is 0')
    say(' exactly when such a w exists; the script asserts that they agree.')
    say('')
    say(' %-44s %4s %4s  %-9s %-9s  %s' % ('packing', 'm', 'N', 'collect.', 'strict', 'local'))
    for title, p in cases:
        c = analyse(p, strict=False)
        st = analyse(p, strict=True)
        free = locally_jammed(p)
        say(' %-44s %4d %4d  %-9s %-9s  %s' % (
            title, c['contacts'], c['unknowns'],
            'yes' if c['jammed'] else 'NO', 'yes' if st['jammed'] else 'NO',
            'yes' if not free else 'free: ' + ' '.join(free)))

    # details for the six circles
    p = data['six']
    for strict in (False, True):
        r = analyse(p, strict)
        say('')
        say('-' * 76)
        say(' six circles, %s jamming' % ('strict' if strict else 'collective'))
        say('-' * 76)
        say('   contacts m = %d, unknowns N = %d, rank A = %d, smallest singular value %.4f'
            % (r['contacts'], r['unknowns'], r['rank'], r['sigma_min']))
        say('   stresses: dimension %d; best smallest entry %.6f (sum 1)'
            % (r['stress_dim'], r['min_stress']))
        say('   primal LP (largest first-order separation): %.2e' % r['motion'])
        say('   a strictly positive stress (contact forces, scaled so the largest is 1):')
        w = r['stress'] / max(r['stress'])
        for lab, x in zip(r['labels'], w):
            say('     %-14s %.4f' % (lab, x))
        say('   check |A^T w| = %.1e' % np.linalg.norm(contact_matrix(p, strict)[0].T @ r['stress']))

    text = '\n'.join(out) + '\n'
    with open(os.path.join(HERE, 'circle-jamming.txt'), 'w') as f:
        f.write(text)
    print(text, end='')


if __name__ == '__main__':
    main()
