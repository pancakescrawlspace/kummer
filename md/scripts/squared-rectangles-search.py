# =====================================================================
# squared-rectangles-search.py -- the computer search behind
# md/squared-rectangles-adjacency-graph.md.
#
# Run with Sage's Python (it uses Sage's canonical graph labelling):
#
#     sage -python squared-rectangles-search.py [MAX_AREA]
#
# MAX_AREA defaults to 36.  For every tiling of an a x b integer
# rectangle (area <= MAX_AREA) by integer squares, skipping tilings
# whose sizes have a common factor (scaled copies of smaller tilings),
# it builds the adjacency graph G: one vertex per square, an edge when
# two squares share a segment of positive length.
#
# Two searches:
#
#   1. Plain G, one orientation per rectangle (a <= b).  A "conflict"
#      is a pair of tilings with isomorphic G whose size assignments do
#      not correspond under any isomorphism, i.e. the canonical forms of
#      G agree but those of G coloured by square size differ.
#
#   2. G with two extra vertices, one joined to the squares touching the
#      top side and one to those touching the bottom side, both
#      rectangle orientations.  The two side vertices form one colour
#      class, because swapping top and bottom is a symmetry.
#
# Expected output for MAX_AREA = 36 (about 30 seconds):
#
#     plain G:  56407 tilings, 16067 graphs, 99 conflicts
#     marked G: 101637 tilings, 32300 graphs, 0 conflicts
#
# Conflicts are printed fewest squares first; the first one is the
# 2x5 / 3x4 pair from section 1 of the note.  A square is written (row, column, side), with row 0 at the
# top.
# =====================================================================

import sys
import time
from functools import reduce
from math import gcd

from sage.all import Graph


def tilings(a, b):
    """All tilings of an a x b grid (a rows, b columns) by squares."""
    grid = [[-1] * b for _ in range(a)]
    squares = []

    def fits(i, j, s):
        return (i + s <= a and j + s <= b
                and all(grid[i + s - 1][j + t] < 0 for t in range(s))
                and all(grid[i + t][j + s - 1] < 0 for t in range(s)))

    def fill(i, j, s, k):
        for u in range(i, i + s):
            for v in range(j, j + s):
                grid[u][v] = k

    def rec(start):
        # first empty cell in reading order; it is the top-left corner
        # of whichever square covers it
        for idx in range(start, a * b):
            i, j = divmod(idx, b)
            if grid[i][j] < 0:
                break
        else:
            yield list(squares)
            return
        s = 1
        while fits(i, j, s):
            squares.append((i, j, s))
            fill(i, j, s, len(squares) - 1)
            yield from rec(idx)
            fill(i, j, s, -1)
            squares.pop()
            s += 1

    yield from rec(0)


def adjacency_edges(squares):
    """Pairs of squares sharing a segment of positive length."""
    edges = []
    for p, (i1, j1, s1) in enumerate(squares):
        for q in range(p + 1, len(squares)):
            i2, j2, s2 = squares[q]
            stacked = (i1 + s1 == i2 or i2 + s2 == i1) \
                and min(j1 + s1, j2 + s2) - max(j1, j2) > 0
            beside = (j1 + s1 == j2 or j2 + s2 == j1) \
                and min(i1 + s1, i2 + s2) - max(i1, i2) > 0
            if stacked or beside:
                edges.append((p, q))
    return edges


def canonical(graph, partition):
    return graph.canonical_label(partition=partition).graph6_string()


def size_classes(sizes):
    """The partition of the squares by size, ordered by size."""
    classes = {}
    for v, s in enumerate(sizes):
        classes.setdefault(s, []).append(v)
    return [classes[s] for s in sorted(classes)], tuple(sorted(classes))


def search(dims, marked):
    seen = {}       # graph key -> (coloured key, first tiling)
    conflicts = []
    count = 0
    for (a, b) in dims:
        for squares in tilings(a, b):
            sizes = [s for (_, _, s) in squares]
            if reduce(gcd, sizes) > 1:
                continue
            count += 1
            n = len(squares)
            edges = adjacency_edges(squares)
            base = [list(range(n))]
            extra = []
            if marked:
                top, bottom = n, n + 1
                edges += [(p, top) for p, (i, _, _) in enumerate(squares) if i == 0]
                edges += [(p, bottom) for p, (i, _, s) in enumerate(squares) if i + s == a]
                extra = [[top, bottom]]
            graph = Graph([list(range(n + (2 if marked else 0))), edges],
                          format='vertices_and_edges')
            key = canonical(graph, base + extra)
            classes, size_values = size_classes(sizes)
            coloured = (size_values, tuple(len(c) for c in classes),
                        canonical(graph, classes + extra))
            if key not in seen:
                seen[key] = (coloured, (a, b, squares))
            elif seen[key][0] != coloured:
                conflicts.append((key, seen[key][1], (a, b, squares)))
    return count, len(seen), conflicts


def main():
    max_area = int(sys.argv[1]) if len(sys.argv) > 1 else 36

    t0 = time.time()
    dims = sorted([(a, b) for a in range(1, max_area + 1)
                   for b in range(a, max_area + 1) if a * b <= max_area],
                  key=lambda d: (d[0] * d[1], d))
    count, graphs, conflicts = search(dims, marked=False)
    print("plain G:  %d tilings, %d graphs, %d conflicts  (%.0fs)"
          % (count, graphs, len(conflicts), time.time() - t0))
    conflicts.sort(key=lambda c: len(c[1][2]))   # fewest squares first
    for key, first, second in conflicts[:3]:
        print("  conflict, graph6 %s" % key)
        print("    %d x %d: %s" % first)
        print("    %d x %d: %s" % second)

    t0 = time.time()
    dims = [(a, b) for a in range(1, max_area + 1)
            for b in range(1, max_area + 1) if a * b <= max_area]
    count, graphs, conflicts = search(dims, marked=True)
    print("marked G: %d tilings, %d graphs, %d conflicts  (%.0fs)"
          % (count, graphs, len(conflicts), time.time() - t0))
    conflicts.sort(key=lambda c: len(c[1][2]))   # fewest squares first
    for key, first, second in conflicts[:3]:
        print("  conflict, graph6 %s" % key)
        print("    %d x %d: %s" % first)
        print("    %d x %d: %s" % second)


if __name__ == '__main__':
    main()
