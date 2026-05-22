#!/usr/bin/env python3
"""
merge_geojson.py — Merge GeoJSON features by name, for any number of merge groups.

Merges are defined in a JSON config file. Each group has one or more search
strings — any feature whose name contains at least one of them is included.
"search" may be a single string or a list of strings. All non-matching features
are passed through unchanged.

Config file format (merges.json):
    [
        {"search": ["East London", "Inner London"], "output_name": "London"},
        {"search": ["Devon", "Cornwall"],           "output_name": "Southwest Peninsula"},
        {"search": "Yorkshire",                     "output_name": "Yorkshire"}
    ]

Usage:
    python merge_geojson.py <input.geojson> <merges.json> [output.geojson]

Examples:
    python merge_geojson.py regions.geojson merges.json
    python merge_geojson.py regions.geojson merges.json out.geojson
    python merge_geojson.py regions.geojson merges.json out.geojson --name-property label

A feature is consumed by the first group that matches its name.
Each merged feature is inserted at the position of the first match in its group.

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
    """Auto-detect the property key most likely to hold a feature's name."""
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


def normalise_search(raw) -> list:
    """Accept a string or list of strings; always return a list of strings."""
    if isinstance(raw, str):
        return [raw]
    if isinstance(raw, list):
        return [str(s) for s in raw]
    raise ValueError(f"'search' must be a string or list of strings, got: {type(raw)}")


def feature_matches(haystack: str, needles: list) -> bool:
    """Return True if haystack contains any of the needles."""
    return any(n in haystack for n in needles)


def merge_properties(matched_features: list, name_property: str, output_name: str) -> dict:
    """Properties from the first matched feature, with name overwritten."""
    if not matched_features:
        return {name_property: output_name}
    props = copy.deepcopy(matched_features[0].get("properties") or {})
    props[name_property] = output_name
    return props


# ---------------------------------------------------------------------------
# Core logic
# ---------------------------------------------------------------------------

def process(
    geojson: dict,
    merge_groups: list,
    name_property: str | None = None,
    case_sensitive: bool = False,
) -> dict:
    """
    Apply multiple merge groups to a GeoJSON FeatureCollection.

    Each group is a dict with keys:
        needles     – list of strings to match against feature names
        output_name – name for the merged output feature

    A feature is claimed by the first group that matches. Unmatched features
    pass through unchanged.
    """
    features = geojson.get("features", [])
    if not features:
        raise ValueError("GeoJSON contains no features.")

    if name_property is None:
        name_property = find_name_property(features)
        print(f"[info] Using name property: '{name_property}'")

    # Prepare groups with pre-computed needles
    groups = []
    for g in merge_groups:
        raw_needles = normalise_search(g["search"])
        needles = raw_needles if case_sensitive else [n.lower() for n in raw_needles]
        groups.append({
            "search":      raw_needles,
            "output_name": g.get("output_name", raw_needles[0]),
            "needles":     needles,
            "matched":     [],      # list of (original_index, feature)
            "first_index": None,
        })

    # Single pass: assign each feature to the first matching group
    unclaimed = []  # (original_index, feature)

    for i, feat in enumerate(features):
        raw_name = get_feature_name(feat, name_property)
        haystack = raw_name if case_sensitive else raw_name.lower()
        claimed = False
        for g in groups:
            if feature_matches(haystack, g["needles"]):
                g["matched"].append((i, feat))
                if g["first_index"] is None:
                    g["first_index"] = i
                claimed = True
                break
        if not claimed:
            unclaimed.append((i, feat))

    # Build merged features
    merged_entries = []  # (first_index, merged_feature)

    for g in groups:
        if not g["matched"]:
            print(f"[warn] No features matched {g['search']} — skipping.")
            continue

        matched_names = [get_feature_name(f, name_property) for _, f in g["matched"]]
        print(f"[info] '{g['output_name']}': matched {len(g['matched'])} feature(s):")
        for n in matched_names:
            print(f"         • {n}")

        shapes = []
        for _, feat in g["matched"]:
            geom = feat.get("geometry")
            if geom is None:
                print(f"[warn] Skipping null geometry in group '{g['output_name']}'")
                continue
            try:
                shapes.append(shape(geom))
            except Exception as e:
                print(f"[warn] Could not parse geometry for '{get_feature_name(feat, name_property)}': {e}")

        if not shapes:
            print(f"[warn] No valid geometries for '{g['output_name']}' — skipping.")
            continue

        merged_geom = unary_union(shapes)
        merged_feature = {
            "type": "Feature",
            "properties": merge_properties(
                [f for _, f in g["matched"]], name_property, g["output_name"]
            ),
            "geometry": mapping(merged_geom),
        }
        merged_entries.append((g["first_index"], merged_feature))

    # Reconstruct ordered feature list
    all_features = unclaimed + merged_entries
    all_features.sort(key=lambda x: x[0])
    output_features = [f for _, f in all_features]

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
            "Merge GeoJSON features by name using a JSON config file. "
            "Non-matching features are preserved unchanged."
        )
    )
    parser.add_argument("input",  help="Path to the input GeoJSON file")
    parser.add_argument("merges", help="Path to the JSON merge-config file")
    parser.add_argument(
        "output",
        nargs="?",
        help="Path for the output GeoJSON file (default: <input>_merged.geojson)",
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

    output_path = args.output or f"{args.input.rsplit('.', 1)[0]}_merged.geojson"

    print(f"[info] Loading '{args.input}' …")
    geojson = load_geojson(args.input)

    print(f"[info] Loading merge config '{args.merges}' …")
    with open(args.merges, encoding="utf-8") as f:
        merge_groups = json.load(f)

    if not isinstance(merge_groups, list) or not merge_groups:
        sys.exit("Error: merges config must be a non-empty JSON array.")
    for g in merge_groups:
        if "search" not in g:
            sys.exit(f"Error: every merge group must have a 'search' key. Got: {g}")

    print(f"[info] {len(merge_groups)} merge group(s) defined.")

    result = process(
        geojson,
        merge_groups=merge_groups,
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
