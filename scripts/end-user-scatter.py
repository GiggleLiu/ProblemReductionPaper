#!/usr/bin/env python3
"""Quality-vs-speed scatter for the 40-run team_split benchmark.

y-axis: percentage gap below the per-instance best (0% = matched best).
This collapses the ten per-instance reference lines from the previous version
into a single y=0 line, and lets catastrophic misses sink visibly below the
main cluster without an extra marker shape.
"""
import json
from pathlib import Path
import matplotlib.pyplot as plt
import matplotlib.lines as mlines

RESULTS = Path("/Users/xiweipan/Codes/problem-reductions/benchmark/solve-instance/results")
OUT_PDF = Path(__file__).resolve().parent.parent / "figures" / "end_user_scatter.pdf"
OUT_PNG = OUT_PDF.with_suffix(".png")

rows = []
for f in sorted(RESULTS.glob("team_split_*_seed*.json")):
    rows.append(json.loads(f.read_text()))

seeds = sorted({r["seed"] for r in rows})
best = {s: max(r["objective"] for r in rows if r["seed"] == s) for s in seeds}

COLORS = {
    "A": "#d62728",  # red    — bare AI
    "B": "#ff7f0e",  # orange — bare AI + web
    "C": "#1f77b4",  # blue   — + pred
    "D": "#2ca02c",  # green  — + pred + web
}
LABELS = {
    "A": "Bare AI",
    "B": "Bare AI + web",
    "C": "+ pred",
    "D": "+ pred + web",
}

fig, ax = plt.subplots(figsize=(6.0, 4.0))

ax.axhline(0, color="0.55", linewidth=0.8, linestyle=(0, (3, 3)), zorder=1)

for r in rows:
    cond = r["condition"]
    obj  = r["objective"]
    wall = max(r["solver_wall_s"], 0.5)
    gap_pct = 100.0 * (obj - best[r["seed"]]) / best[r["seed"]]
    ax.scatter(wall, gap_pct,
               c=COLORS[cond], s=42, marker="o",
               edgecolors="none", alpha=0.9, zorder=3)

ax.set_xscale("log")
ax.set_xlim(0.7, 110)
ax.set_xlabel("Solver wall time (s, log)")
ax.set_ylabel("Gap from per-instance best (%)")
ax.set_title("End-user benchmark: quality vs. solver wall, all 40 runs")

handles = [
    mlines.Line2D([], [], color=col, marker="o", linestyle="None",
                  markersize=6, label=LABELS[c])
    for c, col in COLORS.items()
]
handles.append(mlines.Line2D([], [], color="0.55", linestyle=(0, (3, 3)),
                             label="per-instance best (0%)"))
ax.legend(handles=handles, loc="lower left", fontsize=8, framealpha=0.95)

ax.axvline(90, color="0.55", linewidth=0.8, linestyle=":", zorder=1)
ymax = ax.get_ylim()[1]
ax.text(90, ymax - 0.5, "90 s timeout", color="0.4",
        fontsize=8, ha="right", va="top", rotation=90)

ax.grid(axis="y", color="0.92", linewidth=0.5)
fig.tight_layout()

plt.rcParams["text.usetex"] = False

fig.savefig(OUT_PDF)
fig.savefig(OUT_PNG, dpi=160)
print(f"wrote {OUT_PDF} and {OUT_PNG}")
