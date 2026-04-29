// Library architecture: 3-layer block diagram (Interface / Library / Infrastructure).
// Width = NeurIPS textwidth (5.5 in ≈ 14 cm).

#import "lib.typ": *
#import "@preview/cetz:0.4.2": canvas, draw

#set page(width: auto, height: auto, margin: 2pt)
#set text(font: "Helvetica", size: 8pt)

// Per-layer accents
#let int-acc = rgb("#34568b")
#let int-bd  = rgb("#a8bedf")
#let int-bg  = rgb("#eef2f8")

#let lib-acc = rgb("#3d6b3a")
#let lib-bd  = rgb("#9ec38a")
#let lib-bg  = rgb("#ecf2e6")

#let inf-acc = rgb("#5b3f8a")
#let inf-bd  = rgb("#b39fc8")
#let inf-bg  = rgb("#efeaf4")

#let body-c  = luma(50)
#let arrow-c = rgb("#4f4080")

// ── Icons (typst content; ~14pt × 14pt boxes) ──

#let icon-term = box(
  width: 14pt, height: 14pt, baseline: 2pt,
  fill: rgb("#1c2840"), radius: 1.5pt, inset: 1pt,
  align(horizon + center,
    text(6.5pt, font: "Courier", fill: white, weight: "bold", [>\_])))

#let icon-doc = box(width: 14pt, height: 14pt, baseline: 2pt, {
  place(top + left, dx: 2pt, dy: 0.5pt,
    rect(width: 10pt, height: 13pt,
      stroke: 0.8pt + int-acc, fill: white, radius: 0.5pt))
  place(top + left, dx: 3.5pt, dy: 4pt,
    rect(width: 7pt, height: 0.6pt, fill: int-acc, stroke: none))
  place(top + left, dx: 3.5pt, dy: 6pt,
    rect(width: 7pt, height: 0.6pt, fill: int-acc, stroke: none))
  place(top + left, dx: 3.5pt, dy: 8pt,
    rect(width: 7pt, height: 0.6pt, fill: int-acc, stroke: none))
  place(top + left, dx: 3.5pt, dy: 10pt,
    rect(width: 5pt, height: 0.6pt, fill: int-acc, stroke: none))
})

#let icon-share = box(width: 14pt, height: 14pt, baseline: 2pt,
  canvas(length: 1pt, {
    import draw: *
    let c = lib-acc
    line((4, 11), (10.5, 11), stroke: 1pt + c)
    line((4, 11), (7, 4), stroke: 1pt + c)
    circle((4, 11), radius: 1.9, fill: c.lighten(40%), stroke: 0.7pt + c)
    circle((10.5, 11), radius: 1.9, fill: c.lighten(70%), stroke: 0.7pt + c)
    circle((7, 4), radius: 1.9, fill: c, stroke: 0.7pt + c)
  }))

#let icon-arrows = box(width: 14pt, height: 14pt, baseline: 2pt,
  canvas(length: 1pt, {
    import draw: *
    let c = lib-acc
    line((1, 10), (12, 10), stroke: 1.8pt + c, mark: (end: "straight", scale: 0.4))
    line((1, 4.5), (12, 4.5),
      stroke: (paint: c, thickness: 1.4pt, dash: "dashed"),
      mark: (end: "straight", scale: 0.4))
  }))

#let icon-db = box(width: 14pt, height: 14pt, baseline: 2pt,
  canvas(length: 1pt, {
    import draw: *
    let c = lib-acc
    let cx = 7
    let rx = 4.5
    let ry = 1.3
    rect((cx - rx, 3), (cx + rx, 11), fill: c.lighten(55%), stroke: none)
    arc((cx - rx, 3), start: 180deg, stop: 360deg, radius: (rx, ry),
      stroke: 0.8pt + c, fill: c.lighten(55%))
    arc((cx - rx, 7), start: 180deg, stop: 360deg, radius: (rx, ry),
      stroke: 0.7pt + c)
    circle((cx, 11), radius: (rx, ry), fill: c.lighten(75%), stroke: 0.8pt + c)
    line((cx - rx, 11), (cx - rx, 3), stroke: 0.8pt + c)
    line((cx + rx, 11), (cx + rx, 3), stroke: 0.8pt + c)
  }))

#let icon-cpu = box(width: 14pt, height: 14pt, baseline: 2pt,
  canvas(length: 1pt, {
    import draw: *
    let c = inf-acc
    rect((3, 3), (11, 11), fill: c.lighten(60%), stroke: 1pt + c, radius: 0.8)
    rect((5.5, 5.5), (8.5, 8.5), fill: c, stroke: none, radius: 0.4)
    for i in range(3) {
      let p = 4.5 + i * 1.5
      line((p, 11), (p, 13), stroke: 0.7pt + c)
      line((p, 1), (p, 3), stroke: 0.7pt + c)
      line((11, p), (13, p), stroke: 0.7pt + c)
      line((1, p), (3, p), stroke: 0.7pt + c)
    }
  }))

#let icon-fx = box(width: 14pt, height: 14pt, baseline: 2pt,
  align(horizon + center, text(10pt, fill: inf-acc, style: "italic", $f(x)$)))

#let icon-graph = box(width: 14pt, height: 14pt, baseline: 2pt,
  canvas(length: 1pt, {
    import draw: *
    let c = inf-acc
    let r = 1.7
    let p-top   = (7, 12.5)
    let p-left  = (2, 7)
    let p-right = (12, 7)
    let p-bot   = (7, 1.5)
    line(p-top, p-left, stroke: 0.8pt + c)
    line(p-top, p-right, stroke: 0.8pt + c)
    line(p-left, p-bot, stroke: 0.8pt + c)
    line(p-right, p-bot, stroke: 0.8pt + c)
    circle(p-top,   radius: r, fill: c, stroke: 0.5pt + c)
    circle(p-left,  radius: r, fill: c.lighten(55%), stroke: 0.5pt + c)
    circle(p-right, radius: r, fill: c.lighten(55%), stroke: 0.5pt + c)
    circle(p-bot,   radius: r, fill: c.lighten(55%), stroke: 0.5pt + c)
  }))

// ── Header (icon + title) helper ──
#let header(icon, title, accent) = {
  box(baseline: 1.5pt, icon)
  h(4pt)
  text(8pt, weight: "bold", fill: accent, title)
}

// ── Main canvas ──
#canvas(length: 1cm, {
  import draw: *

  let W = 14.0
  let label-w = 2.7
  let pad = 0.15
  let band-h = 2.35
  let gap-h = 0.75
  let col-gap = 0.2
  let col-w = (W - label-w - 0.1 - 0.1 - 2 * col-gap) / 3
  let col-x = (
    label-w + 0.1,
    label-w + 0.1 + col-w + col-gap,
    label-w + 0.1 + 2 * (col-w + col-gap),
  )

  // y-positions (origin bottom-left, y increases upward)
  let y3-bot = 0
  let y3-top = band-h
  let y2-bot = band-h + gap-h
  let y2-top = 2 * band-h + gap-h
  let y1-bot = 2 * band-h + 2 * gap-h
  let y1-top = 3 * band-h + 2 * gap-h

  // Background bands
  rect((0, y3-bot), (W, y3-top), fill: inf-bg, stroke: none, radius: 4pt)
  rect((0, y2-bot), (W, y2-top), fill: lib-bg, stroke: none, radius: 4pt)
  rect((0, y1-bot), (W, y1-top), fill: int-bg, stroke: none, radius: 4pt)

  // Layer titles + descriptions (left column)
  let layer-label(yt, accent, num, title, desc) = {
    content((0.3, yt - 0.25), anchor: "north-west",
      box(width: (label-w - 0.4) * 1cm, [
        #text(8.5pt, weight: "bold", fill: accent, [#num. #title])
        #v(2pt)
        #text(6.5pt, fill: luma(70), desc)
      ]))
  }
  layer-label(y1-top, int-acc, [1], [Interface Layer],
    [How users talk to the library.])
  layer-label(y2-top, lib-acc, [2], [Library Layer],
    [What the library knows.])
  layer-label(y3-top, inf-acc, [3], [Infrastructure Layer],
    [How the library computes.])

  // Box helper (uses inline header instead of grid)
  let mkbox(x, y-bot, w, h, accent, border, icon, title, items, name) = {
    rect((x, y-bot), (x + w, y-bot + h),
      fill: white, stroke: 0.9pt + border, radius: 4pt, name: name)
    content((x + 0.15, y-bot + h - 0.13), anchor: "north-west",
      box(width: (w - 0.32) * 1cm, [
        #header(icon, title, accent)
        #v(2.5pt)
        #set text(6.5pt, fill: body-c)
        #set par(leading: 2.5pt)
        #items.map(it => [• #it]).join([\ ])
      ]))
  }

  let bx-h = band-h - 2 * pad

  // Interface row: 2 wider boxes (spanning ~1.5 library columns each)
  let int-w = col-w * 1.5 + col-gap / 2 - 0.1
  let int-y = y1-bot + pad
  mkbox(label-w + 0.1, int-y, int-w, bx-h, int-acc, int-bd,
    icon-term, [`pred` CLI],
    ([create a problem instance],
     [reduce to another problem],
     [solve and evaluate]),
    "predcli")
  mkbox(W - 0.1 - int-w, int-y, int-w, bx-h, int-acc, int-bd,
    icon-doc, [PDF Manual],
    ([problem definitions],
     [reduction proofs],
     [worked examples]),
    "pdfmanual")

  // Library row
  let y2 = y2-bot + pad
  mkbox(col-x.at(0), y2, col-w, bx-h, lib-acc, lib-bd,
    icon-share, [Problem Types],
    ([mathematical definition],
     [size measures],
     [best-known complexity]),
    "ptypes")
  mkbox(col-x.at(1), y2, col-w, bx-h, lib-acc, lib-bd,
    icon-arrows, [Reduction Rules],
    ([source $arrow$ target instance],
     [recover source solution],
     [how size grows]),
    "rrules")
  mkbox(col-x.at(2), y2, col-w, bx-h, lib-acc, lib-bd,
    icon-db, [Example Database],
    ([one instance per problem],
     [with a known solution],
     [shared by tests and docs]),
    "exdb")

  // Infrastructure row
  let y3 = y3-bot + pad
  mkbox(col-x.at(0), y3, col-w, bx-h, inf-acc, inf-bd,
    icon-cpu, [Solvers],
    ([ILP (default)],
     [problem-specific],
     [brute force]),
    "solvers")
  mkbox(col-x.at(1), y3, col-w, bx-h, inf-acc, inf-bd,
    icon-fx, [Symbolic Engine],
    ([polynomial expressions],
     [compose along a path],
     [compare and evaluate]),
    "symeng")
  mkbox(col-x.at(2), y3, col-w, bx-h, inf-acc, inf-bd,
    icon-graph, [Reduction Graph],
    ([all problems and rules],
     [find the shortest path],
     [look up by name]),
    "graphreg")

  // ── Intra-layer (bidirectional) arrows ──
  let bidir(c) = (
    stroke: (paint: c, thickness: 1pt),
    mark: (start: "straight", end: "straight", scale: 0.4),
  )
  line("ptypes.east",  "rrules.west",   ..bidir(lib-acc))
  line("rrules.east",  "exdb.west",     ..bidir(lib-acc))
  line("solvers.east", "symeng.west",   ..bidir(inf-acc))
  line("symeng.east",  "graphreg.west", ..bidir(inf-acc))

  // ── Inter-layer arrows with labels ──
  let inter-stroke = (paint: arrow-c, thickness: 0.9pt)
  let inter-mark   = (end: "straight", scale: 0.4)

  let inter-label(pos, txt) = content(pos, anchor: "center",
    text(7pt, fill: arrow-c, txt),
    frame: "rect", fill: white, stroke: none, padding: 0.04)

  // pred CLI ──uses──▶ Reduction Rules
  line("predcli.south", "rrules.north",
    stroke: inter-stroke, mark: inter-mark)
  inter-label((rel: (0, 0.45), to: "rrules.north"), [uses])

  // Example Database ──generated from──▶ PDF Manual
  line("exdb.north", "pdfmanual.south",
    stroke: inter-stroke, mark: inter-mark)
  inter-label((rel: (0, -0.45), to: "pdfmanual.south"), [generated from])

  // Problem Types ──registered in──▶ Solvers
  line("ptypes.south", "solvers.north",
    stroke: inter-stroke, mark: inter-mark)
  inter-label((rel: (0, 0.45), to: "solvers.north"), [registered in])

  // Reduction Rules ──composed via──▶ Symbolic Engine
  line("rrules.south", "symeng.north",
    stroke: inter-stroke, mark: inter-mark)
  inter-label((rel: (0, 0.45), to: "symeng.north"), [composed via])

  // Example Database ──used for testing & docs──▶ Graph / Registry
  line("exdb.south", "graphreg.north",
    stroke: inter-stroke, mark: inter-mark)
  inter-label((rel: (0, 0.45), to: "graphreg.north"), [used for testing \& docs])
})
