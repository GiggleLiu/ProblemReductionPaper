#!/usr/bin/env python3
"""Clean reduction-graph.svg for paper inclusion.

Removes orphan nodes (no edges), strips background fill,
and converts to PDF via rsvg-convert.

Usage:
    python scripts/clean-reduction-graph.py [input.svg] [output.pdf]

Defaults:
    input:  figures/reduction-graph.svg
    output: figures/reduction-graph-clean.pdf
"""

import sys
import subprocess
import xml.etree.ElementTree as ET
import re
from math import sqrt
from pathlib import Path

NS = "http://www.w3.org/2000/svg"
ET.register_namespace("", NS)
ET.register_namespace("xlink", "http://www.w3.org/1999/xlink")

EDGE_THRESHOLD = 80  # max distance from text anchor to edge endpoint


def parse_args():
    base = Path(__file__).resolve().parent.parent / "figures"
    svg_in = Path(sys.argv[1]) if len(sys.argv) > 1 else base / "reduction-graph.svg"
    pdf_out = Path(sys.argv[2]) if len(sys.argv) > 2 else base / "reduction-graph-clean.pdf"
    return svg_in, pdf_out


def build_parent_map(root):
    parent_map = {}
    for parent in root.iter():
        for child in parent:
            parent_map[child] = parent
    return parent_map


def near(x1, y1, x2, y2, threshold=EDGE_THRESHOLD):
    return sqrt((x1 - x2) ** 2 + (y1 - y2) ** 2) < threshold


def collect_texts(root):
    """Return list of (name, x, y, element) for all named node labels."""
    texts = []
    for t in root.iter(f"{{{NS}}}text"):
        content = "".join(t.itertext()).strip()
        x, y = t.get("x"), t.get("y")
        if content and content != "×2" and x:
            texts.append((content, float(x), float(y), t))
    return texts


def collect_edge_endpoints(root):
    """Return list of (x, y) for all edge line start/end points."""
    points = []
    for p in root.iter(f"{{{NS}}}path"):
        fill = p.get("fill", "none")
        stroke = p.get("stroke", "none")
        d = p.get("d", "")
        # Edge lines: no fill, has stroke
        if fill == "none" and stroke != "none":
            coords = re.findall(r"[ML]\s*([\d.]+)\s+([\d.]+)", d)
            if len(coords) >= 2:
                points.append((float(coords[0][0]), float(coords[0][1])))
                points.append((float(coords[-1][0]), float(coords[-1][1])))
    return points


def find_orphans(texts, edge_points):
    """Return set of orphan node names and their (x, y) positions."""
    orphan_names = set()
    orphan_positions = []
    for name, tx, ty, _ in texts:
        connected = any(near(tx, ty, ex, ey) for ex, ey in edge_points)
        if not connected:
            orphan_names.add(name)
            orphan_positions.append((name, tx, ty))
    return orphan_names, orphan_positions


def remove_background(root):
    """Remove the full-canvas background rect."""
    removed = 0
    for g in root.findall(f"{{{NS}}}g"):
        for rect in list(g.findall(f"{{{NS}}}rect")):
            fill = rect.get("fill", "")
            if "hsl" in fill or fill == "#1a1d2e":
                g.remove(rect)
                removed += 1
    return removed


def remove_orphan_elements(root, parent_map, orphan_names, orphan_positions):
    """Remove text labels and their preceding path (node background) for orphans."""
    # The SVG structure is: ...path (node bg), text (label), path (node bg), text, ...
    # Each node is a path+text pair in the same parent group.
    removed_texts = 0
    removed_paths = 0

    # Collect all elements to remove (text + preceding path sibling)
    elements_to_remove = []

    for t in list(root.iter(f"{{{NS}}}text")):
        content = "".join(t.itertext()).strip()
        if content not in orphan_names:
            continue

        parent = parent_map.get(t)
        if parent is None:
            continue

        children = list(parent)
        idx = None
        for i, child in enumerate(children):
            if child is t:
                idx = i
                break

        # Remove the text element
        elements_to_remove.append((parent, t))
        removed_texts += 1

        # The node background path is the element just before the text
        if idx is not None and idx > 0:
            prev = children[idx - 1]
            if prev.tag == f"{{{NS}}}path":
                fill = prev.get("fill", "none")
                # Node backgrounds have a colored fill (not 'none')
                if fill != "none":
                    elements_to_remove.append((parent, prev))
                    removed_paths += 1

    for parent, elem in elements_to_remove:
        try:
            parent.remove(elem)
        except ValueError:
            pass  # already removed

    return removed_texts, removed_paths


def main():
    svg_in, pdf_out = parse_args()
    print(f"Input:  {svg_in}")
    print(f"Output: {pdf_out}")

    tree = ET.parse(svg_in)
    root = tree.getroot()
    parent_map = build_parent_map(root)

    # Remove background
    n_bg = remove_background(root)
    print(f"Background rects removed: {n_bg}")

    # Find orphans
    texts = collect_texts(root)
    edge_points = collect_edge_endpoints(root)
    orphan_names, orphan_positions = find_orphans(texts, edge_points)
    print(f"Connected nodes: {len(texts) - len(orphan_names)}")
    print(f"Orphan nodes:    {len(orphan_names)}")
    for name, x, y in sorted(orphan_positions):
        print(f"  - {name}")

    # Remove orphan elements
    n_texts, n_paths = remove_orphan_elements(root, parent_map, orphan_names, orphan_positions)
    print(f"Removed: {n_texts} text labels, {n_paths} node backgrounds")

    # Write cleaned SVG
    svg_clean = pdf_out.with_suffix(".svg")
    tree.write(str(svg_clean), xml_declaration=True, encoding="unicode")
    print(f"Wrote {svg_clean}")

    # Convert to PDF
    try:
        subprocess.run(
            ["rsvg-convert", "-f", "pdf", "-o", str(pdf_out), str(svg_clean)],
            check=True,
        )
        print(f"Wrote {pdf_out}")
    except FileNotFoundError:
        print("rsvg-convert not found. Install librsvg: brew install librsvg")
        sys.exit(1)


if __name__ == "__main__":
    main()
