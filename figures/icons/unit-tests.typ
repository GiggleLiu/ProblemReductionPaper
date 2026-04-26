#import "@preview/cetz:0.4.2": *

#set page(width: auto, height: auto, margin: 2pt, fill: none)

#canvas(length: 1cm, {
  import draw: *

  let col-frame = rgb("#8a5f7e")    // violet (harness)
  let col-pass  = rgb("#59a14f")    // green
  let col-fail  = rgb("#e15759")    // red
  let col-arrow = rgb("#b07aa1")    // light violet

  let frame-stroke = (paint: col-frame, thickness: 1.4pt, cap: "round", join: "round")
  let pass-stroke  = (paint: col-pass,  thickness: 1.6pt, cap: "round", join: "round")
  let fail-stroke  = (paint: col-fail,  thickness: 1.6pt, cap: "round", join: "round")
  let arrow-stroke = (paint: col-arrow, thickness: 1.0pt, cap: "round")
  let arrow-mark   = (end: "straight", scale: 0.4)

  // ─── Gear in center (8 trapezoidal teeth + circular hub) ───
  let n = 8
  let r-tip = 0.55
  let r-base = 0.42
  let pts = ()
  for i in range(n) {
    let cdeg = i * 360 / n
    let a-base-l = (cdeg - 22.5 + 5) * 1deg
    let a-tip-l  = (cdeg - 22.5 + 11) * 1deg
    let a-tip-r  = (cdeg + 22.5 - 11) * 1deg
    let a-base-r = (cdeg + 22.5 - 5) * 1deg
    pts.push((r-base * calc.cos(a-base-l), r-base * calc.sin(a-base-l)))
    pts.push((r-tip  * calc.cos(a-tip-l),  r-tip  * calc.sin(a-tip-l)))
    pts.push((r-tip  * calc.cos(a-tip-r),  r-tip  * calc.sin(a-tip-r)))
    pts.push((r-base * calc.cos(a-base-r), r-base * calc.sin(a-base-r)))
  }
  line(..pts, close: true, stroke: frame-stroke, fill: col-frame.lighten(85%))

  // Hub
  circle((0, 0), radius: 0.20, stroke: frame-stroke, fill: white)
  // Checkmark inside hub (passing)
  line((-0.10, 0.00), (-0.02, -0.08), (0.12, 0.09), stroke: pass-stroke)

  // ─── 4 corner checkboxes ───
  let positions = (
    (-0.95, 0.95, "v"),    // top-left ✓
    (0.95, 0.95, "x"),     // top-right ✗
    (-0.95, -0.95, "v"),   // bottom-left ✓
    (0.95, -0.95, "v"),    // bottom-right ✓
  )
  let bh = 0.18
  for (cx, cy, mark) in positions {
    rect(
      (cx - bh, cy - bh),
      (cx + bh, cy + bh),
      radius: 0.04,
      stroke: frame-stroke,
      fill: white,
    )
    if mark == "v" {
      line(
        (cx - 0.10, cy + 0.00),
        (cx - 0.02, cy - 0.08),
        (cx + 0.12, cy + 0.08),
        stroke: pass-stroke,
      )
    } else {
      line((cx - 0.10, cy - 0.10), (cx + 0.10, cy + 0.10), stroke: fail-stroke)
      line((cx - 0.10, cy + 0.10), (cx + 0.10, cy - 0.10), stroke: fail-stroke)
    }
  }

  // ─── 4 curved arrows connecting boxes (loop around perimeter) ───
  // top: top-left → top-right via above
  bezier(
    (-0.62, 1.10), (0.62, 1.10),
    (-0.2, 1.40), (0.2, 1.40),
    stroke: arrow-stroke, mark: arrow-mark,
  )
  // right: top-right → bottom-right via right
  bezier(
    (1.10, 0.62), (1.10, -0.62),
    (1.40, 0.2), (1.40, -0.2),
    stroke: arrow-stroke, mark: arrow-mark,
  )
  // bottom: bottom-right → bottom-left via below
  bezier(
    (0.62, -1.10), (-0.62, -1.10),
    (0.2, -1.40), (-0.2, -1.40),
    stroke: arrow-stroke, mark: arrow-mark,
  )
  // left: bottom-left → top-left via left
  bezier(
    (-1.10, -0.62), (-1.10, 0.62),
    (-1.40, -0.2), (-1.40, 0.2),
    stroke: arrow-stroke, mark: arrow-mark,
  )
})
