#!/usr/bin/env python3
"""
merge_geojson.py — Merge GeoJSON features whose name contains a given string.

All non-matching features are passed through unchanged. Matching features are
replaced by a single merged feature whose geometry is the dissolved union and
whose properties are taken from the first matched feature, with the name
property set to the search string.

Usage:
    python merge_geojson.py <input.geojson> <search_string> [output.geojson]

Examples:
    python merge_geojson.py regions.geojson "London"
    python merge_geojson.py regions.geojson "London" london_merged.geojson
    python merge_geojson.py regions.geojson "London" out.geojson --name-property label

Dependencies:
    pip install shapely
"""

import json
import sys
import argparse
import copy

try:
    from shapely.ops import unary_union
    from shapely.geometry import shape, mapping
except ImportError:
    sys.exit(
        "Error: 'shapely' is required.\n"
        "Install it with:  pip install shapely"
    )


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

def load_geojson(path: str) -> dict:
    with open(path, encoding="utf-8") as f:
        return json.load(f)


def get_feature_name(feature: dict, name_property: str) -> str:
    """Return the feature's name from its properties (case-insensitive key lookup)."""
    props = feature.get("properties") or {}
    if name_property in props:
        return str(props[name_property] or "")
    for k, v in props.items():
        if k.lower() == name_property.lower():
            return str(v or "")
    return ""


def find_name_property(features: list) -> str:
    """
    Auto-detect the property key most likely to hold a feature's name.
    Prefers keys like 'name', 'Name', 'NAME', then falls back to the first string property.
    """
    preferred = ["name", "Name", "NAME", "label", "Label", "LABEL",
                 "title", "Title", "TITLE", "nm", "NM"]
    if not features:
        return "name"
    sample_props = features[0].get("properties") or {}
    for key in preferred:
        if key in sample_props:
            return key
    for k, v in sample_props.items():
        if isinstance(v, str):
            return k
    return "name"


def merge_properties(matched_features: list, name_property: str, search_string: str) -> dict:
    """
    Build a merged properties dict from all matched features.
    Uses the first feature's properties as the base, then sets the name
    property to the search string.
    """
    if not matched_features:
        return {name_property: search_string}
    # Deep copy properties from the first matched feature as the base
    props = copy.deepcopy(matched_features[0].get("properties") or {})
    props[name_property] = search_string
    return props


# ---------------------------------------------------------------------------
# Core logic
# ---------------------------------------------------------------------------

def process(
    geojson: dict,
    search_string: str,
    name_property: str | None = None,
    case_sensitive: bool = False,
) -> dict:
    """
    - Non-matching features are passed through unchanged.
    - Matching features are dissolved into a single feature inserted at the
      position of the first match. Properties come from the first matched
      feature, with the name field set to search_string.
    """
    features = geojson.get("features", [])
    if not features:
        raise ValueError("GeoJSON contains no features.")

    if name_property is None:
        name_property = find_name_property(features)
        print(f"[info] Using name property: '{name_property}'")

    needle = search_string if case_sensitive else search_string.lower()

    matched = []       # (index, feature) of matching features
    unmatched = []     # features that don't match
    first_match_index = None

    for i, feat in enumerate(features):
        raw_name = get_feature_name(feat, name_property)
        haystack = raw_name if case_sensitive else raw_name.lower()
        if needle in haystack:
            matched.append((i, feat))
            if first_match_index is None:
                first_match_index = i
        else:
            unmatched.append((i, feat))

    if not matched:
        raise ValueError(
            f"No features found whose '{name_property}' contains '{search_string}'."
        )

    matched_names = [get_feature_name(f, name_property) for _, f in matched]
    print(f"[info] Matched {len(matched)} feature(s):")
    for n in matched_names:
        print(f"         • {n}")

    # Union matched geometries
    shapes = []
    for _, feat in matched:
        geom = feat.get("geometry")
        if geom is None:
            print(f"[warn] Skipping feature with null geometry: {get_feature_name(feat, name_property)}")
            continue
        try:
            shapes.append(shape(geom))
        except Exception as e:
            print(f"[warn] Could not parse geometry for '{get_feature_name(feat, name_property)}': {e}")

    if not shapes:
        raise ValueError("No valid geometries found among matched features.")

    merged_geom = unary_union(shapes)

    # Build the merged feature (properties from first match, name = search_string)
    merged_feature = {
        "type": "Feature",
        "properties": merge_properties([f for _, f in matched], name_property, search_string),
        "geometry": mapping(merged_geom),
    }

    # Reconstruct feature list: non-matching features in original order,
    # with the merged feature inserted at the position of the first match.
    all_features = [(i, f) for i, f in unmatched] + [(first_match_index, merged_feature)]
    all_features.sort(key=lambda x: x[0])
    output_features = [f for _, f in all_features]

    # Preserve all top-level GeoJSON fields (crs, bbox, etc.) except features
    result = {k: v for k, v in geojson.items() if k != "features"}
    result["type"] = "FeatureCollection"
    result["features"] = output_features
    return result


# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------

def main():
    parser = argparse.ArgumentParser(
        description=(
            "Merge GeoJSON features whose name contains a given string. "
            "Non-matching features are preserved unchanged."
        )
    )
    parser.add_argument("input", help="Path to the input GeoJSON file")
    parser.add_argument("search", help='String to match in feature names (e.g. "London")')
    parser.add_argument(
        "output",
        nargs="?",
        help="Path for the output GeoJSON file (default: <search>_merged.geojson)",
    )
    parser.add_argument(
        "--name-property",
        default=None,
        metavar="PROP",
        help="Feature property key that holds the name (auto-detected if omitted)",
    )
    parser.add_argument(
        "--case-sensitive",
        action="store_true",
        help="Use case-sensitive string matching (default: case-insensitive)",
    )

    args = parser.parse_args()

    if args.output:
        output_path = args.output
    else:
        safe_name = args.search.replace(" ", "_").replace("/", "_")
        output_path = f"{safe_name}_merged.geojson"

    print(f"[info] Loading '{args.input}' …")
    geojson = load_geojson(args.input)

    result = process(
        geojson,
        search_string=args.search,
        name_property=args.name_property,
        case_sensitive=args.case_sensitive,
    )

    with open(output_path, "w", encoding="utf-8") as f:
        json.dump(result, f, separators=(",", ":"))

    total_in  = len(geojson.get("features", []))
    total_out = len(result["features"])
    print(f"[info] Features in  : {total_in}")
    print(f"[info] Features out : {total_out} ({total_in - total_out} merged away)")
    print(f"[info] Output written to: '{output_path}'")


if __name__ == "__main__":
    main()
