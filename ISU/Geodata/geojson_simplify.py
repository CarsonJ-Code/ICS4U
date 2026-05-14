#!/usr/bin/env python3
"""
geojson_simplify.py
--------------------
Simplifies GeoJSON polygon/multipolygon geometries by keeping only the N points
that are "most important" — i.e. the points that lie furthest from the straight
line between their two neighbours.  This is a greedy, iterative version of the
classic Ramer–Douglas–Peucker idea but inverted: instead of removing the least
significant point each pass, we *keep* only the top-N most significant ones.

Usage
-----
    python geojson_simplify.py input.geojson output.geojson --keep 12

    # or import and call directly:
    from geojson_simplify import simplify_geojson
    simplified = simplify_geojson(data, keep=12)
"""

import json
import math
import argparse
import sys
from copy import deepcopy
from typing import List, Tuple

# ---------------------------------------------------------------------------
# Core geometry helpers
# ---------------------------------------------------------------------------

Coord = Tuple[float, float]  # (lon, lat) or (x, y)


def _perpendicular_distance(point: Coord, line_start: Coord, line_end: Coord) -> float:
    """
    Return the perpendicular distance from *point* to the infinite line defined
    by *line_start* → *line_end*.

    If the two line endpoints are identical the function returns the straight-
    line distance from the point to that single location.
    """
    x0, y0 = point
    x1, y1 = line_start
    x2, y2 = line_end

    dx = x2 - x1
    dy = y2 - y1
    line_len_sq = dx * dx + dy * dy

    if line_len_sq == 0.0:
        # Degenerate segment — both endpoints are the same point
        return math.hypot(x0 - x1, y0 - y1)

    # ||(p - a) × (b - a)|| / ||b - a||
    cross = abs(dy * x0 - dx * y0 + x2 * y1 - y2 * x1)
    return cross / math.sqrt(line_len_sq)


# ---------------------------------------------------------------------------
# Ring simplification
# ---------------------------------------------------------------------------

def simplify_ring(ring: List[Coord], keep: int) -> List[Coord]:
    """
    Simplify a closed polygon ring (first == last coord) to *keep* unique
    vertices, preserving the closure.

    Strategy
    --------
    1.  Strip the duplicate closing point so we work with a plain list of
        unique vertices.
    2.  Always anchor the first and last unique vertices (they are topological
        extremes and give us a stable starting segment).
    3.  Score every remaining point by its perpendicular distance from the
        straight line between its current neighbours.
    4.  Greedily pick the highest-scoring point, insert it into the kept set,
        and re-score its new neighbours (because their neighbour line has
        changed).  Repeat until we have *keep* points.
    5.  Re-close the ring and return.

    Edge cases
    ----------
    * If the ring already has ≤ keep vertices it is returned unchanged.
    * *keep* is clamped to [3, len(ring)] so the output is always a valid
      ring.
    """
    # Remove duplicate closing coordinate
    if len(ring) > 1 and ring[0] == ring[-1]:
        unique = ring[:-1]
    else:
        unique = list(ring)

    n = len(unique)
    keep = max(3, min(keep, n))   # at least a triangle; at most what we have

    if n <= keep:
        # Nothing to simplify
        return list(ring)

    # --- bookkeeping --------------------------------------------------------
    # We maintain a doubly-linked list over the indices of *unique* so we can
    # cheaply find neighbours and update scores after each insertion.

    prev = [(i - 1) % n for i in range(n)]
    next_ = [(i + 1) % n for i in range(n)]
    kept = [False] * n
    scores = [0.0] * n

    def score(i: int) -> float:
        return _perpendicular_distance(unique[i], unique[prev[i]], unique[next_[i]])

    # Seed: keep index 0 and the geometrically "opposite" point as the first
    # two anchors to give a meaningful initial segment for scoring.
    anchor_a = 0
    anchor_b = n // 2
    kept[anchor_a] = True
    kept[anchor_b] = True

    # Build initial linked list excluding the two anchors
    # (they are already kept; we score only the candidates)
    for i in range(n):
        if not kept[i]:
            scores[i] = score(i)

    # Iteratively pick the highest-scoring non-kept point
    kept_count = 2
    while kept_count < keep:
        best_i = -1
        best_s = -1.0
        for i in range(n):
            if not kept[i] and scores[i] > best_s:
                best_s = scores[i]
                best_i = i

        if best_i == -1:
            break  # All remaining points are collinear (score == 0)

        kept[best_i] = True
        kept_count += 1

        # Update scores of the immediate neighbours whose neighbour-line changed.
        # We don't update *best_i* itself because it is now kept.
        for neighbour in (prev[best_i], next_[best_i]):
            if not kept[neighbour]:
                scores[neighbour] = score(neighbour)

    # Collect kept points in original order and re-close
    simplified = [unique[i] for i in range(n) if kept[i]]
    simplified.append(simplified[0])   # close the ring
    return simplified


# ---------------------------------------------------------------------------
# GeoJSON traversal
# ---------------------------------------------------------------------------

def _simplify_polygon(coordinates: list, keep: int) -> list:
    """Simplify all rings of a Polygon geometry."""
    return [simplify_ring(ring, keep) for ring in coordinates]


def _simplify_multipolygon(coordinates: list, keep: int) -> list:
    """Simplify all polygons inside a MultiPolygon geometry."""
    return [_simplify_polygon(polygon, keep) for polygon in coordinates]


def _simplify_geometry(geometry: dict, keep: int) -> dict:
    """Dispatch to the right simplifier based on geometry type."""
    if geometry is None:
        return geometry

    geom = deepcopy(geometry)
    gtype = geom.get("type", "")

    if gtype == "Polygon":
        geom["coordinates"] = _simplify_polygon(geom["coordinates"], keep)
    elif gtype == "MultiPolygon":
        geom["coordinates"] = _simplify_multipolygon(geom["coordinates"], keep)
    elif gtype == "GeometryCollection":
        geom["geometries"] = [
            _simplify_geometry(g, keep) for g in geom.get("geometries", [])
        ]
    # Point / MultiPoint / LineString / MultiLineString — no simplification needed
    return geom


def simplify_geojson(data: dict, keep: int = 12) -> dict:
    """
    Return a new GeoJSON object with all polygon rings simplified to at most
    *keep* vertices.

    Parameters
    ----------
    data : dict
        Parsed GeoJSON (FeatureCollection, Feature, or bare geometry).
    keep : int
        Number of vertices to keep per ring.  Defaults to 12.

    Returns
    -------
    dict
        Deep-copied, simplified GeoJSON.
    """
    result = deepcopy(data)
    dtype = result.get("type", "")

    if dtype == "FeatureCollection":
        for feature in result.get("features", []):
            if feature.get("geometry"):
                feature["geometry"] = _simplify_geometry(feature["geometry"], keep)

    elif dtype == "Feature":
        if result.get("geometry"):
            result["geometry"] = _simplify_geometry(result["geometry"], keep)

    else:
        # Bare geometry object
        result = _simplify_geometry(result, keep)

    return result


# ---------------------------------------------------------------------------
# Stats helper
# ---------------------------------------------------------------------------

def _count_coords(geojson: dict) -> int:
    """Roughly count total coordinate pairs in a GeoJSON object."""
    text = json.dumps(geojson)
    # Each coordinate pair is a two-element array; rough proxy via comma count
    # in coordinate arrays — good enough for reporting.
    total = 0

    def walk(obj):
        nonlocal total
        if isinstance(obj, dict):
            if obj.get("type") in ("Polygon", "MultiPolygon", "LineString",
                                    "MultiLineString", "MultiPoint"):
                coords_str = json.dumps(obj.get("coordinates", []))
                # Count opening brackets of inner arrays as a coord-pair proxy
                total += coords_str.count("[") // 2
            else:
                for v in obj.values():
                    walk(v)
        elif isinstance(obj, list):
            for item in obj:
                walk(item)

    walk(geojson)
    return total


# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------

def main():
    parser = argparse.ArgumentParser(
        description="Simplify GeoJSON polygon geometries by keeping only the "
                    "N most geometrically significant vertices per ring."
    )
    parser.add_argument("input",  help="Input GeoJSON file (use - for stdin)")
    parser.add_argument("output", help="Output GeoJSON file (use - for stdout)")
    parser.add_argument(
        "--keep", "-k",
        type=int,
        default=12,
        metavar="N",
        help="Number of vertices to keep per ring (default: 12)",
    )
    parser.add_argument(
        "--indent",
        type=int,
        default=2,
        metavar="N",
        help="JSON indentation spaces (default: 2; use 0 for compact output)",
    )
    args = parser.parse_args()

    # Read
    if args.input == "-":
        data = json.load(sys.stdin)
    else:
        with open(args.input, "r", encoding="utf-8") as f:
            data = json.load(f)

    # Simplify
    simplified = simplify_geojson(data, keep=args.keep)

    # Report
    before = _count_coords(data)
    after  = _count_coords(simplified)
    reduction = 100 * (1 - after / before) if before else 0
    print(
        f"Simplification complete  |  keep={args.keep}  |  "
        f"~{before} → ~{after} coord-pairs  ({reduction:.1f}% reduction)",
        file=sys.stderr,
    )

    # Write
    indent = args.indent if args.indent > 0 else None
    if args.output == "-":
        json.dump(simplified, sys.stdout, indent=indent)
    else:
        with open(args.output, "w", encoding="utf-8") as f:
            json.dump(simplified, f, indent=indent)
        print(f"Written to {args.output}", file=sys.stderr)


if __name__ == "__main__":
    main()
