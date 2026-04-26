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

  // Force same bounding extent as unit-tests (~±0.78) for visual size parity.
  hide(rect((-0.78, -0.78), (0.78, 0.78)))

  // ─── Document with folded top-right corner ───
  let dx = 0.58
  let dy = 0.75
  let fold = 0.22

  let body-pts = (
    (-dx, dy),
    (dx - fold, dy),
    (dx, dy - fold),
    (dx, -dy),
    (-dx, -dy),
  )
  line(..body-pts, close: true, stroke: frame-stroke, fill: col-frame.lighten(85%))

  // Fold flap
  line(
    (dx - fold, dy),
    (dx - fold, dy - fold),
    (dx, dy - fold),
    stroke: frame-stroke,
  )

  // ─── 4 code-line strokes inside ───
  line((-0.38, 0.42),  (0.20, 0.42),  stroke: line-stroke)
  line((-0.38, 0.18),  (0.30, 0.18),  stroke: line-stroke)
  line((-0.38, -0.06), (0.10, -0.06), stroke: line-stroke)
  line((-0.38, -0.30), (0.20, -0.30), stroke: line-stroke)

  // ─── Check badge: green-stroked circle with green check ───
  let bx = 0.50
  let by = -0.50
  circle((bx, by), radius: 0.28, stroke: pass-stroke, fill: white)
  line(
    (bx - 0.15, by + 0.00),
    (bx - 0.04, by - 0.12),
    (bx + 0.16, by + 0.12),
    stroke: pass-stroke,
  )
})
