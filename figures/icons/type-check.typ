#import "@preview/cetz:0.4.2": *

#set page(width: auto, height: auto, margin: 2pt, fill: none)

#canvas(length: 1cm, {
  import draw: *

  let col-frame = rgb("#8a5f7e")    // violet (harness)
  let col-pass  = rgb("#59a14f")    // green
  let col-line  = rgb("#b07aa1")    // light violet for code lines

  let frame-stroke = (paint: col-frame, thickness: 1.4pt, cap: "round", join: "round")
  let line-stroke  = (paint: col-line,  thickness: 1.4pt, cap: "round")
  let pass-stroke  = (paint: col-pass,  thickness: 1.6pt, cap: "round", join: "round")

  // ─── Document with folded top-right corner ───
  let dx = 0.50
  let dy = 0.65
  let fold = 0.20

  let body-pts = (
    (-dx, dy),               // top-left
    (dx - fold, dy),         // top, before fold
    (dx, dy - fold),         // diagonal end (fold tip)
    (dx, -dy),               // bottom-right
    (-dx, -dy),              // bottom-left
  )
  line(..body-pts, close: true, stroke: frame-stroke, fill: col-frame.lighten(85%))

  // Fold flap — small triangle drawn on top
  line(
    (dx - fold, dy),
    (dx - fold, dy - fold),
    (dx, dy - fold),
    stroke: frame-stroke,
  )

  // ─── 3 code-line strokes inside ───
  line((-0.30, 0.30),  (0.20, 0.30),  stroke: line-stroke)
  line((-0.30, 0.05),  (0.30, 0.05),  stroke: line-stroke)
  line((-0.30, -0.20), (0.10, -0.20), stroke: line-stroke)

  // ─── Check badge: green-stroked circle with green check, lower-right ───
  let bx = 0.45
  let by = -0.45
  circle((bx, by), radius: 0.25, stroke: pass-stroke, fill: white)
  line(
    (bx - 0.13, by + 0.00),
    (bx - 0.04, by - 0.10),
    (bx + 0.14, by + 0.10),
    stroke: pass-stroke,
  )
})
