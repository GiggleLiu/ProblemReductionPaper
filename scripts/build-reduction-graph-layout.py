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
    g = nx.DiGraph()
    for n in nodes:
        g.add_node(n["name"])
    for s, t in edges:
        if s in g and t in g:
            g.add_edge(s, t)
    ug = g.to_undirected()

    # ForceAtlas2 with strong scaling + gravity gives a much wider spread
    # than spring/Kamada-Kawai when one node (ILP) is a massive sink. We
    # keep dissuade_hubs on so the hub doesn't drag every neighbor inward.
    # Make hubs visually "large" so ForceAtlas2 pushes neighbors farther
    # from them (node_size acts as a per-node repulsion radius).
    node_size = {n["name"]: 12.0 if n["name"] in HUB_ANCHORS else 1.0 for n in nodes}
    pos = nx.forceatlas2_layout(
        ug,
        max_iter=2000,
        jitter_tolerance=1.0,
        scaling_ratio=15.0,
        gravity=1.2,
        distributed_action=False,
        strong_gravity=False,
        linlog=True,
        node_size=node_size,
        seed=7,
    )

    # Re-anchor so 3-SAT sits on the left and ILP on the right of the
    # final figure, regardless of how ForceAtlas2 oriented the embedding.
    if all(h in pos for h in HUB_ANCHORS):
        import math
        sat = pos["KSatisfiability"]
        ilp = pos["ILP"]
        dx = ilp[0] - sat[0]
        dy = ilp[1] - sat[1]
        theta = math.atan2(dy, dx)  # current SAT→ILP angle
        c, s = math.cos(-theta), math.sin(-theta)
        # Center on midpoint, rotate so SAT→ILP is along +x.
        cx = (sat[0] + ilp[0]) / 2
        cy = (sat[1] + ilp[1]) / 2
        rotated = {}
        for k, (x, y) in pos.items():
            x0, y0 = x - cx, y - cy
            rotated[k] = (c * x0 - s * y0, s * x0 + c * y0)
        pos = rotated

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
