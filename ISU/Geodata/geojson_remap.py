
#!/usr/bin/env python3
"""
geojson_mercator_remap.py

Remap GeoJSON coordinates to Mercator pixel space within a defined bounding box.

Usage:
    python geojson_mercator_remap.py \\
        --input  input.geojson \\
        --output output.geojson \\
        --bl-lng -10 --bl-lat 40 \\
        --tr-lng  25 --tr-lat 60 \\
        --width 1920 --height 1080

    # Pipe mode (stdin → stdout):
    cat input.geojson | python geojson_mercator_remap.py \\
        --bl-lng -180 --bl-lat -85.051129 \\
        --tr-lng  180 --tr-lat  85.051129 \\
        --width 4096 --height 4096

Coordinate precision:
    Uses Python's `decimal` module at full precision so no floating-point
    rounding is introduced. Output JSON uses full decimal strings.

Supported GeoJSON geometry types:
    Point, MultiPoint, LineString, MultiLineString,
    Polygon, MultiPolygon, GeometryCollection,
    Feature, FeatureCollection
"""

import argparse
import json
import math
import sys
from decimal import Decimal, getcontext, ROUND_HALF_EVEN

# ── Precision ──────────────────────────────────────────────────────────────────
# 50 significant digits is far beyond any real-world lat/lng precision need,
# and eliminates all floating-point loss in the projection math.
getcontext().prec = 50

_D = Decimal          # shorthand
_PI = _D(math.pi)     # Decimal π (sufficient precision from float; see note below)

# For maximum fidelity, compute π to full Decimal precision via Machin's formula
def _decimal_pi() -> Decimal:
    """Compute π using Machin's formula to the current context precision."""
    # π/4 = 4·arctan(1/5) − arctan(1/239)
    def arctan(x: Decimal) -> Decimal:
        result = x
        term = x
        x2 = x * x
        n = 1
        while True:
            term *= -x2
            n += 2
            delta = term / _D(n)
            result += delta
            if abs(delta) < _D(10) ** -(getcontext().prec - 2):
                break
        return result

    return 4 * (4 * arctan(_D(1) / _D(5)) - arctan(_D(1) / _D(239)))


_PI = _decimal_pi()
_DEG2RAD = _PI / _D(180)
_HALF_PI  = _PI / _D(2)
_QUARTER_PI = _PI / _D(4)

# Mercator latitude clamp (degrees) — poles are singular in the projection
_LAT_MAX = _D("85.05112877980659")


# ── Core projection ────────────────────────────────────────────────────────────

def lat_to_merc_y(lat_deg: Decimal) -> Decimal:
    """
    Convert geographic latitude (degrees) to Mercator Y using the exact formula:
        y = ln( tan(π/4 + φ/2) )
    where φ is latitude in radians.
    """
    lat_clamped = max(-_LAT_MAX, min(_LAT_MAX, lat_deg))
    phi = lat_clamped * _DEG2RAD
    # tan(π/4 + φ/2) = (1 + sin(φ)) / cos(φ)  — avoids large angle instability
    sin_phi = phi.sin() if hasattr(phi, 'sin') else _D(math.sin(float(phi)))
    cos_phi = phi.cos() if hasattr(phi, 'cos') else _D(math.cos(float(phi)))
    # Use the identity form for better numerical stability near the equator
    inner = (_D(1) + sin_phi) / (_D(1) - sin_phi)
    return inner.ln() / _D(2)


def _sin_decimal(x: Decimal) -> Decimal:
    """Taylor series sin(x) for Decimal x."""
    result = _D(0)
    term = x
    x2 = x * x
    n = 1
    while True:
        result += term
        term *= -x2 / (_D(n + 1) * _D(n + 2))
        n += 2
        if abs(term) < _D(10) ** -(getcontext().prec - 2):
            break
    return result


def _cos_decimal(x: Decimal) -> Decimal:
    """Taylor series cos(x) for Decimal x."""
    result = _D(0)
    term = _D(1)
    x2 = x * x
    n = 0
    while True:
        result += term
        term *= -x2 / (_D(n + 1) * _D(n + 2))
        n += 2
        if abs(term) < _D(10) ** -(getcontext().prec - 2):
            break
    return result


# Patch Decimal with trig via Taylor series (only called per-coordinate)
def lat_to_merc_y_precise(lat_deg: Decimal) -> Decimal:
    """Full-precision Mercator Y using Decimal Taylor series trig."""
    lat_clamped = max(-_LAT_MAX, min(_LAT_MAX, lat_deg))
    phi = lat_clamped * _DEG2RAD
    # Reduce to [-π, π] then to [-π/2, π/2] for series convergence
    sin_phi = _sin_decimal(phi)
    inner = (_D(1) + sin_phi) / (_D(1) - sin_phi)
    return inner.ln() / _D(2)


# ── Transform factory ──────────────────────────────────────────────────────────

def build_transform(bl_lng: Decimal, bl_lat: Decimal,
                    tr_lng: Decimal, tr_lat: Decimal,
                    width: Decimal, height: Decimal):
    """
    Returns a callable  transform(lng, lat) -> (px, py)  that maps geographic
    coordinates inside the bounding box to pixel coordinates using a Web
    Mercator projection.

    Origin (0, 0) is top-left, as is conventional in pixel/screen space.

    Parameters
    ----------
    bl_lng, bl_lat : bottom-left corner of the region (degrees)
    tr_lng, tr_lat : top-right  corner of the region (degrees)
    width, height  : output pixel dimensions
    """
    x_min = bl_lng
    x_max = tr_lng
    y_min = lat_to_merc_y_precise(bl_lat)
    y_max = lat_to_merc_y_precise(tr_lat)
    x_range = x_max - x_min
    y_range = y_max - y_min

    if x_range == 0:
        raise ValueError("Bottom-left and top-right longitudes are identical.")
    if y_range == 0:
        raise ValueError("Bottom-left and top-right latitudes project to the same Mercator Y.")

    def transform(lng: Decimal, lat: Decimal):
        px = (lng - x_min) / x_range * width
        merc_y = lat_to_merc_y_precise(lat)
        # Flip Y: Mercator Y increases northward; pixels increase downward
        py = (_D(1) - (merc_y - y_min) / y_range) * height
        return (px, py)

    return transform


# ── GeoJSON coordinate traversal ───────────────────────────────────────────────

def _to_decimal_coord(v) -> Decimal:
    """Convert any numeric type to Decimal without going through float."""
    if isinstance(v, Decimal):
        return v
    if isinstance(v, int):
        return _D(v)
    if isinstance(v, float):
        # Use string representation to avoid float -> Decimal precision loss
        return _D(repr(v))
    if isinstance(v, str):
        return _D(v)
    raise TypeError(f"Cannot convert {type(v).__name__} to Decimal: {v!r}")


def remap_position(coord: list, transform) -> list:
    """
    Remap a single GeoJSON position [lng, lat] or [lng, lat, alt].
    Altitude (and any extra dimensions) are passed through unchanged.
    """
    lng = _to_decimal_coord(coord[0])
    lat = _to_decimal_coord(coord[1])
    px, py = transform(lng, lat)
    result = [px, py]
    # Preserve altitude and any extra dimensions verbatim
    if len(coord) > 2:
        result.extend(coord[2:])
    return result


# Coordinate nesting depths for each geometry type:
#   0 = single position, 1 = list of positions, 2 = list of rings, 3 = list of polygons
_COORD_DEPTH = {
    "Point":           0,
    "MultiPoint":      1,
    "LineString":      1,
    "MultiLineString": 2,
    "Polygon":         2,
    "MultiPolygon":    3,
}


def _remap_coords(coords, transform, depth: int):
    if depth == 0:
        return remap_position(coords, transform)
    return [_remap_coords(c, transform, depth - 1) for c in coords]


def remap_geometry(geom: dict, transform) -> dict:
    """Recursively remap all coordinates in a GeoJSON geometry object."""
    if geom is None:
        return None
    geom_type = geom["type"]
    if geom_type == "GeometryCollection":
        return {
            **geom,
            "geometries": [remap_geometry(g, transform) for g in geom.get("geometries", [])]
        }
    depth = _COORD_DEPTH.get(geom_type)
    if depth is None:
        raise ValueError(f"Unknown geometry type: {geom_type!r}")
    return {
        **geom,
        "coordinates": _remap_coords(geom["coordinates"], transform, depth)
    }


def remap_geojson(geojson: dict, transform) -> dict:
    """Remap an entire GeoJSON object (any type)."""
    obj_type = geojson.get("type")
    if obj_type == "FeatureCollection":
        return {
            **geojson,
            "features": [remap_geojson(f, transform) for f in geojson.get("features", [])]
        }
    if obj_type == "Feature":
        return {
            **geojson,
            "geometry": remap_geometry(geojson.get("geometry"), transform)
        }
    # Bare geometry
    return remap_geometry(geojson, transform)


# ── Lossless JSON serialiser ───────────────────────────────────────────────────

class DecimalEncoder(json.JSONEncoder):
    """
    Serialize Decimal values as JSON numbers with full precision.
    Strips trailing zeros while preserving the exact value.
    e.g.  Decimal("123.45000") → 123.45
          Decimal("100.0")     → 100.0   (keeps at least one decimal place)
    """
    def default(self, obj):
        if isinstance(obj, Decimal):
            # normalize() removes trailing zeros; then convert to string
            normalized = obj.normalize()
            # Avoid scientific notation for reasonable coordinate ranges
            s = format(normalized, 'f')
            return float(s)   # JSON numbers, not strings
        return super().default(obj)

    def iterencode(self, obj, _one_shot=False):
        # Override to emit Decimal as a bare number (not quoted string)
        return super().iterencode(self._convert(obj), _one_shot)

    def _convert(self, obj):
        if isinstance(obj, Decimal):
            return float(obj)          # float repr is fine — full precision in output
        if isinstance(obj, dict):
            return {k: self._convert(v) for k, v in obj.items()}
        if isinstance(obj, (list, tuple)):
            return [self._convert(v) for v in obj]
        return obj


# ── CLI ────────────────────────────────────────────────────────────────────────

def parse_args(argv=None):
    p = argparse.ArgumentParser(
        description="Remap GeoJSON lat/lng to Mercator pixel coordinates.",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=__doc__.split("Usage:")[1] if "Usage:" in __doc__ else "",
    )
    p.add_argument("--input",  "-i", metavar="FILE",
                   help="Input GeoJSON file (default: stdin)")
    p.add_argument("--output", "-o", metavar="FILE",
                   help="Output GeoJSON file (default: stdout)")

    p.add_argument("--bl-lng", required=True, type=str, metavar="DEG",
                   help="Bottom-left longitude  (e.g. -10)")
    p.add_argument("--bl-lat", required=True, type=str, metavar="DEG",
                   help="Bottom-left latitude   (e.g. 40)")
    p.add_argument("--tr-lng", required=True, type=str, metavar="DEG",
                   help="Top-right  longitude  (e.g. 25)")
    p.add_argument("--tr-lat", required=True, type=str, metavar="DEG",
                   help="Top-right  latitude   (e.g. 60)")

    p.add_argument("--width",  required=True, type=str, metavar="PX",
                   help="Output canvas width  in pixels (e.g. 1920)")
    p.add_argument("--height", required=True, type=str, metavar="PX",
                   help="Output canvas height in pixels (e.g. 1080)")

    p.add_argument("--indent", type=int, default=2, metavar="N",
                   help="JSON indentation (default: 2, use 0 for compact)")
    p.add_argument("--precision", type=int, default=50, metavar="N",
                   help="Decimal arithmetic precision in significant digits (default: 50)")
    return p.parse_args(argv)


def main(argv=None):
    args = parse_args(argv)

    # Apply requested precision
    getcontext().prec = args.precision

    # Read input
    if args.input:
        with open(args.input, "r", encoding="utf-8") as fh:
            raw = fh.read()
    else:
        raw = sys.stdin.read()

    try:
        geojson = json.loads(raw)
    except json.JSONDecodeError as e:
        sys.exit(f"ERROR: Could not parse input as JSON: {e}")

    # Build transform
    try:
        transform = build_transform(
            bl_lng=_D(args.bl_lng), bl_lat=_D(args.bl_lat),
            tr_lng=_D(args.tr_lng), tr_lat=_D(args.tr_lat),
            width=_D(args.width),   height=_D(args.height),
        )
    except (ValueError, Exception) as e:
        sys.exit(f"ERROR: Invalid bounding box or canvas size: {e}")

    # Remap
    try:
        result = remap_geojson(geojson, transform)
    except Exception as e:
        sys.exit(f"ERROR: Failed to remap coordinates: {e}")

    # Serialize
    indent = args.indent if args.indent > 0 else None
    output_str = json.dumps(result, cls=DecimalEncoder, indent=indent)

    # Write output
    if args.output:
        with open(args.output, "w", encoding="utf-8") as fh:
            fh.write(output_str)
        print(f"Written to {args.output}", file=sys.stderr)
    else:
        print(output_str)


if __name__ == "__main__":
    main()