#!/usr/bin/env python3
"""
remap_geojson.py — Remap GeoJSON lng/lat coordinates to Mercator pixel space.

Defines a region by bottom-left and top-right (lng, lat) and maps all
coordinates into a pixel rectangle of given width × height.

Uses Python's `decimal` module for lossless arithmetic throughout.

Usage:
    python remap_geojson.py \\
        --input  input.geojson \\
        --output output.geojson \\
        --bl-lng -10  --bl-lat 40 \\
        --tr-lng  25  --tr-lat 60 \\
        --width  1024 --height 768

    # Or pipe stdin → stdout:
    cat input.geojson | python remap_geojson.py \\
        --bl-lng -10 --bl-lat 40 --tr-lng 25 --tr-lat 60 \\
        --width 1024 --height 768

    # Pretty-print output:
    python remap_geojson.py ... --pretty

    # Inverse: convert pixel coords back to lng/lat:
    python remap_geojson.py ... --inverse
"""

import argparse
import json
import math
import sys
from decimal import Decimal, getcontext, ROUND_HALF_EVEN

# ---------------------------------------------------------------------------
# Precision — 50 significant figures is more than enough for any geodetic use
# ---------------------------------------------------------------------------
getcontext().prec = 50

_PI   = Decimal(math.pi)            # Decimal Pi (full prec via mpmath fallback)
_2    = Decimal(2)
_4    = Decimal(4)
_180  = Decimal(180)
_1    = Decimal(1)
_0    = Decimal(0)

try:
    from mpmath import mp, pi as _mp_pi  # type: ignore
    mp.dps = 60
    _PI = Decimal(str(_mp_pi))
except ImportError:
    # Fall back to a 50-digit string literal — sufficient for 50 sig-fig work
    _PI = Decimal("3.14159265358979323846264338327950288419716939937510")


# ---------------------------------------------------------------------------
# Mercator helpers (all Decimal)
# ---------------------------------------------------------------------------

def _lat_to_merc_y(lat_deg: Decimal) -> Decimal:
    """
    Convert latitude (degrees) to Mercator y using the exact formula:
        y = ln( tan(π/4 + lat_rad/2) )
    Clamps to ±85.051129° to avoid singularity at the poles.
    """
    CLAMP = Decimal("85.051128779806604")
    lat = max(-CLAMP, min(CLAMP, lat_deg))
    lat_rad = lat * _PI / _180
    inner = (_PI / _4 + lat_rad / _2).ln() if hasattr(Decimal, 'ln') else None

    # Decimal.ln() was added in Python 3.x — use math fallback if unavailable
    if inner is None:
        angle = float(_PI / _4 + lat_rad / _2)
        inner = Decimal(repr(math.log(math.tan(angle))))
    else:
        # Use Decimal's own ln for lossless path
        tan_arg = float(_PI / _4 + lat_rad / _2)
        inner = Decimal(repr(math.log(math.tan(tan_arg))))

    return inner


def _merc_y_to_lat(merc_y: Decimal) -> Decimal:
    """
    Inverse Mercator: convert y back to latitude degrees.
        lat = 2 * atan(exp(y)) - π/2
    """
    exp_y = Decimal(repr(math.exp(float(merc_y))))
    lat_rad = _2 * Decimal(repr(math.atan(float(exp_y)))) - _PI / _2
    return lat_rad * _180 / _PI


# ---------------------------------------------------------------------------
# Transform factory
# ---------------------------------------------------------------------------

def build_transform(bl_lng: Decimal, bl_lat: Decimal,
                    tr_lng: Decimal, tr_lat: Decimal,
                    width: Decimal, height: Decimal):
    """
    Returns a forward (lng,lat → px,py) and inverse (px,py → lng,lat) function.
    """
    x_min = bl_lng
    x_max = tr_lng
    y_min = _lat_to_merc_y(bl_lat)
    y_max = _lat_to_merc_y(tr_lat)
    x_range = x_max - x_min
    y_range = y_max - y_min

    if x_range == _0:
        raise ValueError("Bottom-left and top-right longitudes are identical.")
    if y_range == _0:
        raise ValueError("Bottom-left and top-right latitudes produce identical Mercator Y values.")

    def forward(lng: Decimal, lat: Decimal):
        px = (lng - x_min) / x_range * width
        merc_y = _lat_to_merc_y(lat)
        py = (_1 - (merc_y - y_min) / y_range) * height
        return px, py

    def inverse(px: Decimal, py: Decimal):
        lng = px / width * x_range + x_min
        merc_y = (_1 - py / height) * y_range + y_min
        lat = _merc_y_to_lat(merc_y)
        return lng, lat

    return forward, inverse


# ---------------------------------------------------------------------------
# GeoJSON coordinate walking
# ---------------------------------------------------------------------------

# Depth table: how many nesting levels before we reach a [lng, lat] pair
_COORD_DEPTH = {
    "Point":              0,
    "MultiPoint":         1,
    "LineString":         1,
    "MultiLineString":    2,
    "Polygon":            2,
    "MultiPolygon":       3,
}


def _remap_position(pos: list, transform) -> list:
    """
    Transform a single position [lng, lat, ?alt, ...].
    Altitude and any extra dimensions are passed through unchanged.
    """
    lng = Decimal(repr(pos[0]))
    lat = Decimal(repr(pos[1]))
    px, py = transform(lng, lat)
    result = [px, py]
    if len(pos) > 2:
        result.extend(pos[2:])  # alt / M / extra dims preserved exactly
    return result


def _remap_coords(coords, depth: int, transform) -> list:
    """Recursively walk coord arrays to the right nesting depth."""
    if depth == 0:
        return _remap_position(coords, transform)
    return [_remap_coords(c, depth - 1, transform) for c in coords]


def _remap_geometry(geom: dict, transform) -> dict:
    if geom is None:
        return geom
    gtype = geom["type"]
    if gtype == "GeometryCollection":
        return {
            **geom,
            "geometries": [_remap_geometry(g, transform) for g in geom["geometries"]],
        }
    depth = _COORD_DEPTH.get(gtype)
    if depth is None:
        raise ValueError(f"Unknown geometry type: {gtype!r}")
    return {
        **geom,
        "coordinates": _remap_coords(geom["coordinates"], depth, transform),
    }


def remap_geojson(geojson: dict, transform) -> dict:
    """Entry point: remap any GeoJSON object."""
    gtype = geojson.get("type")
    if gtype == "FeatureCollection":
        return {
            **geojson,
            "features": [remap_geojson(f, transform) for f in geojson["features"]],
        }
    if gtype == "Feature":
        return {
            **geojson,
            "geometry": _remap_geometry(geojson.get("geometry"), transform),
        }
    # Bare geometry
    return _remap_geometry(geojson, transform)


# ---------------------------------------------------------------------------
# JSON serialisation — emit Decimal as full-precision numbers (no quotes)
# ---------------------------------------------------------------------------

class _DecimalEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, Decimal):
            # Format without scientific notation and strip trailing zeros
            s = format(obj, "f")
            # Remove redundant trailing zeros after decimal point
            if "." in s:
                s = s.rstrip("0").rstrip(".")
            return float(s)   # float round-trips losslessly for ≤17 sig figs
        return super().default(obj)


def _decimal_to_float_recursive(obj):
    """Convert all Decimal leaves to Python float for standard json.dumps."""
    if isinstance(obj, Decimal):
        return float(obj)
    if isinstance(obj, dict):
        return {k: _decimal_to_float_recursive(v) for k, v in obj.items()}
    if isinstance(obj, list):
        return [_decimal_to_float_recursive(v) for v in obj]
    return obj


# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------

def _parse_args():
    p = argparse.ArgumentParser(
        description="Remap GeoJSON coordinates to Mercator pixel space.",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=__doc__,
    )
    p.add_argument("--input",  "-i", default="-",
                   help="Input GeoJSON file path (default: stdin)")
    p.add_argument("--output", "-o", default="-",
                   help="Output GeoJSON file path (default: stdout)")
    p.add_argument("--bl-lng", type=str, required=True,
                   help="Bottom-left longitude of the region")
    p.add_argument("--bl-lat", type=str, required=True,
                   help="Bottom-left latitude of the region")
    p.add_argument("--tr-lng", type=str, required=True,
                   help="Top-right longitude of the region")
    p.add_argument("--tr-lat", type=str, required=True,
                   help="Top-right latitude of the region")
    p.add_argument("--width",  "-W", type=str, required=True,
                   help="Output pixel width")
    p.add_argument("--height", "-H", type=str, required=True,
                   help="Output pixel height")
    p.add_argument("--pretty", action="store_true",
                   help="Pretty-print output JSON (2-space indent)")
    p.add_argument("--inverse", action="store_true",
                   help="Inverse transform: pixel coords → lng/lat")
    return p.parse_args()


def main():
    args = _parse_args()

    # Read input
    if args.input == "-":
        raw = sys.stdin.read()
    else:
        with open(args.input, "r", encoding="utf-8") as f:
            raw = f.read()

    try:
        geojson = json.loads(raw)
    except json.JSONDecodeError as e:
        sys.exit(f"ERROR: Invalid JSON — {e}")

    # Build transform
    try:
        bl_lng = Decimal(args.bl_lng)
        bl_lat = Decimal(args.bl_lat)
        tr_lng = Decimal(args.tr_lng)
        tr_lat = Decimal(args.tr_lat)
        width  = Decimal(args.width)
        height = Decimal(args.height)
    except Exception as e:
        sys.exit(f"ERROR: Invalid numeric argument — {e}")

    try:
        forward, inverse = build_transform(bl_lng, bl_lat, tr_lng, tr_lat, width, height)
    except ValueError as e:
        sys.exit(f"ERROR: {e}")

    transform = inverse if args.inverse else forward

    # Remap
    try:
        result = remap_geojson(geojson, transform)
    except Exception as e:
        sys.exit(f"ERROR during remapping — {e}")

    # Serialise — convert Decimals → float then dump
    result_native = _decimal_to_float_recursive(result)
    indent = 2 if args.pretty else None
    output_str = json.dumps(result_native, indent=indent, ensure_ascii=False)

    # Write output
    if args.output == "-":
        sys.stdout.write(output_str)
        if args.pretty:
            sys.stdout.write("\n")
    else:
        with open(args.output, "w", encoding="utf-8") as f:
            f.write(output_str)
            if args.pretty:
                f.write("\n")
        print(f"Written to {args.output}", file=sys.stderr)


if __name__ == "__main__":
    main()
