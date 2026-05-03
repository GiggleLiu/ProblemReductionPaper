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

// ── Icons (typst content; 14pt × 14pt boxes) ──
// All icons live in a 14×14pt canvas so they line up with the title at 8pt.

// 1. Terminal (pred CLI): dark rounded square, green prompt, white cursor underline.
#let icon-term = box(
  width: 14pt, height: 14pt, baseline: 2pt,
  fill: rgb("#1c2840"), radius: 2pt, inset: 0pt,
  {
    place(top + left, dx: 2.2pt, dy: 2.4pt,
      text(7pt, font: "Courier", fill: white, weight: "bold", [*>*]))
    place(top + left, dx: 6.5pt, dy: 8pt,
      rect(width: 4.5pt, height: 1pt, fill: white, stroke: none))
  }
)

// 2. Document (PDF Manual): page with folded top-right corner + 4 text lines.
#let icon-doc = box(width: 14pt, height: 14pt, baseline: 2pt,
  canvas(length: 1pt, {
    import draw: *
    let c = int-acc
    // Page outline (notched at top-right for the fold).
    line((2, 13), (10, 13), (12, 11), (12, 1), (2, 1), close: true,
      stroke: 0.8pt + c, fill: white)
    // Folded corner triangle (lighter fill to imply a flap).
    line((10, 13), (10, 11), (12, 11), close: true,
      stroke: 0.6pt + c, fill: c.lighten(75%))
    // Text lines.
    for (y, len) in ((10, 6.5), (8.5, 6.5), (7, 6.5), (5.5, 4)) {
      line((3.5, y), (3.5 + len, y), stroke: 0.6pt + c)
    }
  }))

// 3. Types (Problem Types): three different shapes — square, circle, triangle.
#let icon-types = box(width: 14pt, height: 14pt, baseline: 2pt,
  canvas(length: 1pt, {
    import draw: *
    let c = lib-acc
    rect((1.5, 8), (5.5, 12), stroke: 0.9pt + c, fill: c.lighten(60%))
    circle((10, 10), radius: 2.4, stroke: 0.9pt + c, fill: c.lighten(40%))
    line((4, 1.5), (10, 1.5), (7, 6), close: true,
      stroke: 0.9pt + c, fill: c.lighten(75%))
  }))

// 4. Rule (Reduction Rules): source shape ─▶ target shape, long visible arrow shaft.
#let icon-rule = box(width: 14pt, height: 14pt, baseline: 2pt,
  canvas(length: 1pt, {
    import draw: *
    let c = lib-acc
    // Small shapes pushed to the edges so the arrow shaft is clearly visible.
    circle((1.8, 7), radius: 1.5, stroke: 1pt + c, fill: c.lighten(45%))
    line((3.5, 7), (10.6, 7),
      stroke: 1.2pt + c, mark: (end: "straight", scale: 0.5))
    rect((10.8, 5.5), (13.7, 8.5), stroke: 1pt + c, fill: c.lighten(45%))
  }))

// 5. Database (Example Database): cylinder with one disk separator.
#let icon-db = box(width: 14pt, height: 14pt, baseline: 2pt,
  canvas(length: 1pt, {
    import draw: *
    let c = lib-acc
    let cx = 7
    let rx = 4.5
    let ry = 1.4
    rect((cx - rx, 2.5), (cx + rx, 11.5), fill: c.lighten(65%), stroke: none)
    arc((cx - rx, 2.5), start: 180deg, stop: 360deg, radius: (rx, ry),
      stroke: 0.9pt + c, fill: c.lighten(65%))
    arc((cx - rx, 7), start: 180deg, stop: 360deg, radius: (rx, ry),
      stroke: 0.7pt + c)
    circle((cx, 11.5), radius: (rx, ry), fill: c.lighten(85%), stroke: 0.9pt + c)
    line((cx - rx, 11.5), (cx - rx, 2.5), stroke: 0.9pt + c)
    line((cx + rx, 11.5), (cx + rx, 2.5), stroke: 0.9pt + c)
  }))

// 6. Magnifier (Solvers): magnifying glass — searches for the answer.
#let icon-gear = box(width: 14pt, height: 14pt, baseline: 2pt,
  canvas(length: 1pt, {
    import draw: *
    let c = inf-acc
    // Lens
    circle((5.6, 8.4), radius: 3.7, stroke: 1.4pt + c, fill: c.lighten(75%))
    // Lens highlight (small inner arc)
    arc((3.7, 9.0), start: 200deg, stop: 260deg, radius: 2.6,
      stroke: 0.7pt + white)
    // Handle (thick stroke from lens edge to bottom-right corner)
    line((8.3, 5.7), (12.5, 1.5), stroke: 2.2pt + c)
  }))

// 7. Math expression (Symbolic Engine): bold italic f(x).
#let icon-fx = box(width: 14pt, height: 14pt, baseline: 2pt,
  align(horizon + center,
    text(8.5pt, fill: inf-acc, weight: "bold", style: "italic", $f(x)$)))

// ── Header (icon + title) helper ──
// Use grid with horizon alignment so the icon vertically centers with the title text
// regardless of each icon's intrinsic baseline.
#let header(icon, title, accent) = grid(
  columns: (auto, 1fr),
  column-gutter: 4pt,
  align: horizon + left,
  icon,
  text(8pt, weight: "bold", fill: accent, title),
)

// ── Main canvas ──
#canvas(length: 1cm, {
  import draw: *

  let W = 12.7
  let label-w = 3.8
  let pad = 0.15
  let band-h = 2
  let inf-band-h = 1.6
  let gap-h = 0.3
  let col-gap = 0.2

  // Library has two sub-rows (Example DB on top, Problem Types + Reduction Rules below)
  let lib-sub-h = 0.7
  let lib-sub-gap = 0.25
  let lib-bot-h = 0.7
  let lib-band-h = lib-sub-h + lib-bot-h + lib-sub-gap + 2 * pad

  let lib-col-w = (W - label-w - 0.1 - 0.1 - col-gap) / 2

  // y-positions (origin bottom-left, y increases upward)
  let y3-bot = 0
  let y3-top = inf-band-h
  let y2-bot = y3-top + gap-h
  let y2-top = y2-bot + lib-band-h
  let y1-bot = y2-top + gap-h
  let y1-top = y1-bot + band-h

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
    [Entry points for human users and AI agents.])
  layer-label(y2-top, lib-acc, [2], [Library Layer],
    [Registered problem types and the reductions between them.])
  layer-label(y3-top, inf-acc, [3], [Infrastructure Layer],
    [Backends that serve each problem and rule.])

  // Box helper. If `items` is empty, render only the header centered vertically.
  let mkbox(x, y-bot, w, h, accent, border, icon, title, items, name) = {
    rect((x, y-bot), (x + w, y-bot + h),
      fill: white, stroke: 0.9pt + border, radius: 4pt, name: name)
    if items.len() == 0 {
      content((x + w / 2, y-bot + h / 2), anchor: "center",
        box(width: (w - 0.32) * 1cm, header(icon, title, accent)))
    } else {
      content((x + 0.15, y-bot + h - 0.13), anchor: "north-west",
        box(width: (w - 0.32) * 1cm, [
          #set block(spacing: 3pt)
          #header(icon, title, accent)
          #block(inset: (left: 18pt))[
            #set text(7.5pt, fill: body-c)
            #set par(leading: 3pt)
            #items.map(it => [• #it]).join([\ ])
          ]
        ]))
    }
  }

  let bx-h = band-h - 2 * pad

  // Interface row: 2 boxes aligned with the Library bottom-row columns
  let int-w = lib-col-w
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

  // Library row: two sub-rows
  //   top:    Example Database (full width)
  //   bottom: Problem Types | Reduction Rules
  let lib-bot-y = y2-bot + pad
  let lib-top-y = lib-bot-y + lib-bot-h + lib-sub-gap
  let lib-x0 = label-w + 0.1
  let lib-x1 = lib-x0 + lib-col-w + col-gap
  // All three Library boxes share the same narrow width.
  let lib-bot-w = 3.5
  let exdb-x = lib-x0 + (2 * lib-col-w + col-gap - lib-bot-w) / 2
  let ptypes-x = lib-x0 + (lib-col-w - lib-bot-w) / 2
  let rrules-x = lib-x1 + (lib-col-w - lib-bot-w) / 2

  mkbox(ptypes-x, lib-bot-y, lib-bot-w, lib-bot-h, lib-acc, lib-bd,
    icon-types, [Problem Types], (), "ptypes")
  mkbox(rrules-x, lib-bot-y, lib-bot-w, lib-bot-h, lib-acc, lib-bd,
    icon-rule, [Reduction Rules], (), "rrules")
  mkbox(exdb-x, lib-top-y, lib-bot-w, lib-sub-h, lib-acc, lib-bd,
    icon-db, [Example Database], (), "exdb")

  // Infrastructure row: 2 boxes mirroring Interface row, but shorter.
  let y3 = y3-bot + pad
  let inf-bx-h = inf-band-h - 2 * pad
  let inf-w = int-w
  mkbox(label-w + 0.1, y3, inf-w, inf-bx-h, inf-acc, inf-bd,
    icon-gear, [Solvers],
    ([for round-trip testing],
     [ILP or brute-force]),
    "solvers")
  mkbox(W - 0.1 - inf-w, y3, inf-w, inf-bx-h, inf-acc, inf-bd,
    icon-fx, [Symbolic Engine],
    ([reduction overheads],
     [algorithm complexities]),
    "symeng")

  // ── Intra-layer (bidirectional) arrows ──
  let bidir(c) = (
    stroke: (paint: c, thickness: 1pt),
    mark: (start: "straight", end: "straight", scale: 0.4),
  )
  // Triangle outline: bottom edge + two outer slants from Example Database
  // down to the outer corners of the boxes below.
  line("ptypes.east",       "rrules.west",        ..bidir(lib-acc))
  line("exdb.south-west",   "ptypes.north",  ..bidir(lib-acc))
  line("exdb.south-east",   "rrules.north",  ..bidir(lib-acc))

})
