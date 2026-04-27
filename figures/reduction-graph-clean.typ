// Reduction graph — simplified rendering.
//
// Source: data/reduction-graph-layout.json (built by
// scripts/build-reduction-graph-layout.py from the submodule's
// `cargo run --example export_graph`).
//
// Style: small uniform colored dots (one per problem type), thin gray
// directed edges; only the two hubs (3-SAT and ILP) carry a text label
// and a larger circle. Matches the panel-3 sketch in main.typ.

#import "lib.typ": *
#import "@preview/cetz:0.4.2": canvas, draw

#set page(width: auto, height: auto, margin: 6pt)
#set text(size: 7pt, font: "Helvetica")

// ── Category palette (mirrors panel-3 sketch in main.typ) ──
#let col-graph     = rgb("#4e79a7")  // blue
#let col-formula   = rgb("#59a14f")  // green
#let col-set       = rgb("#e15759")  // red
#let col-algebraic = rgb("#b07aa1")  // violet
#let col-misc      = rgb("#76b7b2")  // teal

#let category-color(c) = {
  if c == "graph" { col-graph }
  else if c == "formula" { col-formula }
  else if c == "set" { col-set }
  else if c == "algebraic" { col-algebraic }
  else { col-misc }
}

// ── Geometry — portrait, tight ──
#let plot-w = 11.0
#let plot-h = 16.0
#let r-node = 0.20       // ordinary-node radius
#let r-hub  = 0.32       // hub radius — only modestly bigger than regular
#let edge-paint  = rgb(120, 120, 130, 70)   // 70/255 alpha — quiet
#let edge-stroke = (thickness: 0.22pt, paint: edge-paint)
#let edge-curve  = 0.18  // perpendicular offset of bezier control point

// ── Load layout data ──
#let data = json("../data/reduction-graph-layout.json")
#let hubs = ("KSatisfiability", "ILP")

// Use percentile-based bounds (clip outliers) so the bulk of nodes fills
// the canvas instead of getting compressed into the centre by a few far-
// flung points. Then clamp the projected coordinates so outliers still
// render — just at the edge.
#let xs-sorted = data.nodes.map(n => n.x).sorted()
#let ys-sorted = data.nodes.map(n => n.y).sorted()
#let pct(arr, p) = arr.at(calc.min(arr.len() - 1, calc.max(0, int(p * arr.len()))))
#let x-min = pct(xs-sorted, 0.02)
#let x-max = pct(xs-sorted, 0.98)
#let y-min = pct(ys-sorted, 0.02)
#let y-max = pct(ys-sorted, 0.98)
#let pad   = 0.04   // 4 % padding

#let clamp(v, lo, hi) = calc.max(lo, calc.min(hi, v))
#let nx(x) = {
  let t = clamp((x - x-min) / (x-max - x-min), 0.0, 1.0)
  pad * plot-w + t * (1 - 2 * pad) * plot-w
}
#let ny(y) = {
  let t = clamp((y - y-min) / (y-max - y-min), 0.0, 1.0)
  pad * plot-h + t * (1 - 2 * pad) * plot-h
}

// Build a name → (x, y, category) map for edge lookup.
#let name-to-pos = (:)
#for n in data.nodes {
  name-to-pos.insert(n.name, (nx(n.x), ny(n.y), n.category))
}

#let is-hub(name) = name in hubs

#canvas(length: 0.55cm, {
  import draw: *

  // ── Edges (back layer) — quadratic bezier curves with a slight
  // perpendicular bow so overlapping fans separate visually.
  for e in data.edges {
    let p = name-to-pos.at(e.source)
    let q = name-to-pos.at(e.target)
    let (px, py, _) = p
    let (qx, qy, _) = q
    let dx = qx - px
    let dy = qy - py
    let len = calc.sqrt(dx * dx + dy * dy)
    if len < 0.01 { continue }
    let ux = dx / len
    let uy = dy / len
    let r-src = if is-hub(e.source) { r-hub } else { r-node }
    let r-tgt = if is-hub(e.target) { r-hub } else { r-node }
    let sx = px + ux * r-src
    let sy = py + uy * r-src
    let tx = qx - ux * r-tgt
    let ty = qy - uy * r-tgt
    // Control point: midpoint pushed perpendicular by edge-curve * len
    let mx = (sx + tx) / 2
    let my = (sy + ty) / 2
    let bow = edge-curve * len * 0.5
    let cx-pt = mx + (-uy) * bow
    let cy-pt = my + ( ux) * bow
    bezier(
      (sx, sy), (tx, ty), (cx-pt, cy-pt),
      stroke: edge-stroke,
    )
  }

  // ── Ordinary nodes ──
  for n in data.nodes {
    if is-hub(n.name) { continue }
    let col = category-color(n.category)
    circle(
      (nx(n.x), ny(n.y)),
      radius: r-node,
      fill: col.lighten(35%),
      stroke: (thickness: 0.25pt, paint: col.darken(15%)),
    )
  }

  // ── Hub nodes — slightly bigger filled disk, label set OUTSIDE
  // (top for 3-SAT, bottom for ILP) so the figure reads as one family
  // of dots with two callouts.
  for n in data.nodes {
    if not is-hub(n.name) { continue }
    let col = category-color(n.category)
    let label = if n.name == "KSatisfiability" { [3-SAT] } else { [ILP] }
    let cx = nx(n.x)
    let cy = ny(n.y)
    circle(
      (cx, cy),
      radius: r-hub,
      fill: col.darken(5%),
      stroke: (thickness: 0.4pt, paint: col.darken(20%)),
    )
    let dy = if n.name == "KSatisfiability" { 0.55 } else { -0.55 }
    let anchor = if n.name == "KSatisfiability" { "south" } else { "north" }
    content(
      (cx, cy + dy),
      anchor: anchor,
      text(9pt, weight: "bold", fill: col.darken(25%), label),
    )
  }


  // ── Compact category legend, bottom strip ──
  let entries = (
    (col-graph,     "graph"),
    (col-formula,   "formula"),
    (col-set,       "set"),
    (col-algebraic, "algebraic"),
    (col-misc,      "misc"),
  )
  let col-gap = plot-w / entries.len()
  let ly = -0.55
  for (i, e) in entries.enumerate() {
    let (col, label) = e
    let cx-leg = (i + 0.5) * col-gap - 0.4
    circle(
      (cx-leg, ly),
      radius: 0.12,
      fill: col.lighten(35%),
      stroke: (thickness: 0.3pt, paint: col.darken(15%)),
    )
    content(
      (cx-leg + 0.25, ly),
      anchor: "west",
      text(6pt, fill: fg, label),
    )
  }
})
