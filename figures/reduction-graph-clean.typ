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

// ── Geometry ──
#let plot-w = 16.0       // canvas width in cetz units
#let plot-h = 11.0
#let r-node = 0.16       // ordinary-node radius
#let r-hub  = 0.55       // hub-node radius
#let edge-stroke = (thickness: 0.28pt, paint: luma(150))
#let arrow-mark  = (end: "straight", scale: 0.18, fill: luma(150))

// ── Load layout data ──
#let data = json("../data/reduction-graph-layout.json")
#let hubs = ("KSatisfiability", "ILP")

// Compute data bounds for normalization.
#let xs = data.nodes.map(n => n.x)
#let ys = data.nodes.map(n => n.y)
#let x-min = calc.min(..xs)
#let x-max = calc.max(..xs)
#let y-min = calc.min(..ys)
#let y-max = calc.max(..ys)
#let pad   = 0.06   // 6 % padding so nodes don't touch the edge

#let nx(x) = {
  let t = (x - x-min) / (x-max - x-min)
  pad * plot-w + t * (1 - 2 * pad) * plot-w
}
#let ny(y) = {
  let t = (y - y-min) / (y-max - y-min)
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

  // ── Edges (back layer) ──
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
    // Shrink endpoints so arrowheads don't overlap node disks.
    let r-src = if is-hub(e.source) { r-hub } else { r-node }
    let r-tgt = if is-hub(e.target) { r-hub } else { r-node }
    line(
      (px + ux * r-src, py + uy * r-src),
      (qx - ux * r-tgt, qy - uy * r-tgt),
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
      fill: col.lighten(70%),
      stroke: (thickness: 0.4pt, paint: col.darken(5%)),
    )
  }

  // ── Hub nodes (drawn last so labels sit on top) ──
  for n in data.nodes {
    if not is-hub(n.name) { continue }
    let col = category-color(n.category)
    let label = if n.name == "KSatisfiability" { [3-SAT] } else { [ILP] }
    circle(
      (nx(n.x), ny(n.y)),
      radius: r-hub,
      fill: col.lighten(75%),
      stroke: (thickness: 1.0pt, paint: col.darken(10%)),
      name: n.name,
    )
    content(
      n.name,
      text(8pt, weight: "bold", fill: col.darken(25%), label),
    )
  }

  // ── Compact category legend, top-right ──
  let lx = plot-w - 2.5
  let ly = plot-h - 0.2
  let row-gap = 0.42
  let entries = (
    (col-graph,     "graph"),
    (col-formula,   "formula"),
    (col-set,       "set"),
    (col-algebraic, "algebraic"),
    (col-misc,      "misc"),
  )
  for (i, e) in entries.enumerate() {
    let (col, label) = e
    let cy = ly - i * row-gap
    circle(
      (lx, cy),
      radius: 0.14,
      fill: col.lighten(70%),
      stroke: (thickness: 0.4pt, paint: col.darken(5%)),
    )
    content(
      (lx + 0.3, cy),
      anchor: "west",
      text(6pt, fill: fg, label),
    )
  }
})
