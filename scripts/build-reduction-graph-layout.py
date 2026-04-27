#!/usr/bin/env python3
"""Build the reduction-graph layout for figures/reduction-graph-clean.typ.

Pipeline:
  1. Run `cargo run --example export_graph` in the submodule to dump a fresh
     JSON of (nodes, edges).
  2. Collapse variant entries into one node per problem-type name.
  3. Drop isolated nodes (no incoming/outgoing edges).
  4. Compute a force-directed layout (Kamada-Kawai → spring polish), with
     ILP and 3-SAT pinned as anchors so the two hubs sit at predictable
     positions for the paper figure.
  5. Write data/reduction-graph-layout.json — consumed by the Typst figure.

Usage:
    python3 scripts/build-reduction-graph-layout.py [--no-export]

Options:
    --no-export  Skip the cargo step and reuse /tmp/reduction_graph.json.
"""

import argparse
import json
import subprocess
import sys
from collections import defaultdict
from pathlib import Path

import networkx as nx

ROOT = Path(__file__).resolve().parent.parent
SUBMODULE = ROOT / "problem-reductions"
RAW_JSON = Path("/tmp/reduction_graph.json")
OUTPUT = ROOT / "data" / "reduction-graph-layout.json"

# Hubs are pinned to deterministic anchor positions so the paper figure
# always reads "3-SAT on the left, ILP on the right".
HUB_ANCHORS = {
    "KSatisfiability": (-1.0,  0.55),
    "ILP":             ( 1.0, -0.10),
}


def export_graph(skip: bool) -> None:
    if skip and RAW_JSON.exists():
        return
    print("Running cargo export_graph in submodule...", file=sys.stderr)
    subprocess.run(
        ["cargo", "run", "--quiet", "--example", "export_graph", "--", str(RAW_JSON)],
        cwd=SUBMODULE,
        check=True,
    )


def collapse_variants(raw: dict) -> tuple[list[dict], list[tuple[str, str]]]:
    """Return (unique_nodes, unique_edges) keyed by problem-type name."""
    by_name: dict[str, dict] = {}
    for n in raw["nodes"]:
        # Keep the first variant we see for category/doc fields.
        by_name.setdefault(n["name"], {"name": n["name"], "category": n["category"]})

    name_of = [n["name"] for n in raw["nodes"]]
    edge_set = set()
    for e in raw["edges"]:
        s = name_of[e["source"]]
        t = name_of[e["target"]]
        if s != t:
            edge_set.add((s, t))

    return list(by_name.values()), sorted(edge_set)


def drop_isolated(nodes: list[dict], edges: list[tuple[str, str]]) -> list[dict]:
    deg: dict[str, int] = defaultdict(int)
    for s, t in edges:
        deg[s] += 1
        deg[t] += 1
    return [n for n in nodes if deg[n["name"]] > 0]


def compute_layout(nodes: list[dict], edges: list[tuple[str, str]]) -> dict[str, tuple[float, float]]:
    """Use Graphviz `twopi` rooted at ILP — radial layout with concentric
    shells by graph distance. ILP has 114 of 155 neighbours here, so any
    force layout produces a dense halo around it; twopi spreads those
    114 nodes uniformly on the inner ring instead, giving balanced
    density across the whole figure."""
    import math
    import subprocess

    lines = [
        'graph G {',
        '  layout=twopi;',
        '  root="ILP";',
        '  ranksep="2.5";',
        '  overlap=prism;',
        '  overlap_scaling=-7;',
        '  sep="+10";',
        '  node [shape=circle, fixedsize=true];',
    ]
    for n in nodes:
        w = 1.4 if n["name"] in HUB_ANCHORS else 0.55
        lines.append(f'  "{n["name"]}" [width={w}];')
    for s, t in edges:
        lines.append(f'  "{s}" -- "{t}";')
    lines.append('}')
    dot_input = "\n".join(lines)

    proc = subprocess.run(
        ["twopi", "-Tplain"],
        input=dot_input, text=True,
        capture_output=True, check=True,
    )
    pos: dict[str, tuple[float, float]] = {}
    for line in proc.stdout.splitlines():
        parts = line.split()
        if parts and parts[0] == "node":
            name = parts[1].strip('"')
            pos[name] = (float(parts[2]), float(parts[3]))

    # Rotate so 3-SAT sits at the TOP and ILP at the BOTTOM of the
    # final figure (the paper figure is portrait-oriented).
    if all(h in pos for h in HUB_ANCHORS):
        sat = pos["KSatisfiability"]
        ilp = pos["ILP"]
        theta = math.atan2(ilp[1] - sat[1], ilp[0] - sat[0])
        # Want SAT→ILP along +x then we'll relabel +x → −y when
        # rendering; equivalently rotate by (−theta − π/2) so SAT→ILP is +y.
        rot = -theta - math.pi / 2
        c, s = math.cos(rot), math.sin(rot)
        cx = (sat[0] + ilp[0]) / 2
        cy = (sat[1] + ilp[1]) / 2
        pos = {
            k: (c * (x - cx) - s * (y - cy), s * (x - cx) + c * (y - cy))
            for k, (x, y) in pos.items()
        }

    return {k: (float(v[0]), float(v[1])) for k, v in pos.items()}


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--no-export", action="store_true")
    args = ap.parse_args()

    export_graph(args.no_export)
    raw = json.loads(RAW_JSON.read_text())
    nodes, edges = collapse_variants(raw)
    nodes = drop_isolated(nodes, edges)
    keep = {n["name"] for n in nodes}
    edges = [(s, t) for s, t in edges if s in keep and t in keep]

    pos = compute_layout(nodes, edges)

    payload = {
        "nodes": [
            {
                "name": n["name"],
                "category": n["category"],
                "x": pos[n["name"]][0],
                "y": pos[n["name"]][1],
                "degree": sum(1 for s, t in edges if s == n["name"] or t == n["name"]),
            }
            for n in nodes
        ],
        "edges": [{"source": s, "target": t} for s, t in edges],
        "hubs": list(HUB_ANCHORS),
    }

    OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    OUTPUT.write_text(json.dumps(payload, indent=2))
    print(f"Wrote {OUTPUT}: {len(payload['nodes'])} nodes, {len(payload['edges'])} edges", file=sys.stderr)


if __name__ == "__main__":
    main()
