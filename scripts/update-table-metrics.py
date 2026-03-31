#!/usr/bin/env python3
"""Generate data/table-metrics.json from the reduction graph.

Runs `cargo run --example export_graph` in the problem-reductions submodule,
then computes Table I metrics from the exported JSON:
  - problem_types: unique base problem names
  - registered_variants: variant-level nodes
  - reduction_rules: directed edges (primitive reductions)
  - reachable_from_3sat: variants reachable from KSatisfiability via directed paths
  - reducible_to_ilp: variants that have a directed path to any ILP node
"""

import json
import subprocess
import sys
import tempfile
from collections import defaultdict, deque
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
SUBMODULE = REPO_ROOT / "problem-reductions"
OUTPUT = REPO_ROOT / "data" / "table-metrics.json"


def export_graph() -> dict:
    """Run export_graph example and return parsed JSON."""
    with tempfile.NamedTemporaryFile(suffix=".json", delete=False) as f:
        tmp = f.name
    subprocess.run(
        ["cargo", "run", "--example", "export_graph", tmp],
        cwd=SUBMODULE,
        check=True,
        capture_output=True,
    )
    with open(tmp) as f:
        return json.load(f)


def reachable_from(graph: dict, source_name: str) -> set[int]:
    """BFS forward from all nodes with the given base name. Returns reachable node indices."""
    adj = defaultdict(list)
    for edge in graph["edges"]:
        adj[edge["source"]].append(edge["target"])

    sources = {i for i, n in enumerate(graph["nodes"]) if n["name"] == source_name}
    visited = set(sources)
    queue = deque(sources)
    while queue:
        u = queue.popleft()
        for v in adj[u]:
            if v not in visited:
                visited.add(v)
                queue.append(v)
    return visited


def can_reach(graph: dict, target_name: str) -> set[int]:
    """BFS backward from all nodes with the given base name. Returns node indices that can reach target."""
    rev_adj = defaultdict(list)
    for edge in graph["edges"]:
        rev_adj[edge["target"]].append(edge["source"])

    targets = {i for i, n in enumerate(graph["nodes"]) if n["name"] == target_name}
    visited = set(targets)
    queue = deque(targets)
    while queue:
        u = queue.popleft()
        for v in rev_adj[u]:
            if v not in visited:
                visited.add(v)
                queue.append(v)
    return visited


def main():
    print("Exporting reduction graph from submodule...")
    graph = export_graph()
    nodes = graph["nodes"]
    edges = graph["edges"]

    unique_names = {n["name"] for n in nodes}
    reachable_3sat = reachable_from(graph, "KSatisfiability")
    reducible_ilp = can_reach(graph, "ILP")

    # Count unique base names (not variant nodes) for 3-SAT and ILP metrics
    names_from_3sat = {nodes[i]["name"] for i in reachable_3sat} - {"KSatisfiability"}
    names_to_ilp = {nodes[i]["name"] for i in reducible_ilp} - {"ILP"}

    metrics = {
        "problem_types": len(unique_names),
        "registered_variants": len(nodes),
        "reduction_rules": len(edges),
        "reachable_from_3sat": len(names_from_3sat),
        "reducible_to_ilp": len(names_to_ilp),
    }

    OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    with open(OUTPUT, "w") as f:
        json.dump(metrics, f, indent=2)
        f.write("\n")

    print(f"Written to {OUTPUT}")
    for k, v in metrics.items():
        print(f"  {k}: {v}")


if __name__ == "__main__":
    main()
