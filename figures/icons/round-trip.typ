#import "@preview/cetz:0.4.2": *

#set page(width: auto, height: auto, margin: 2pt, fill: none)

#canvas(length: 1cm, {
  import draw: *

  let col-frame = rgb("#8a5f7e")    // violet (harness)
  let col-pass  = rgb("#59a14f")    // green
  let col-arrow = rgb("#8a5f7e")    // arrows match frame

  let frame-stroke = (paint: col-frame, thickness: 1.4pt, cap: "round", join: "round")
  let arrow-stroke = (paint: col-arrow, thickness: 1.4pt, cap: "round")
  let pass-stroke  = (paint: col-pass,  thickness: 1.8pt, cap: "round", join: "round")
  let arrow-mark   = (end: "straight", scale: 0.4)

  // Match bbox of unit-tests / type-check
  hide(rect((-0.78, -0.78), (0.78, 0.78)))

  // ─── Two endpoint nodes (source ↔ target) ───
  let r = 0.20
  let cx = 0.50
  circle((-cx, 0), radius: r,
    stroke: frame-stroke, fill: col-frame.lighten(70%))
  circle((cx, 0),  radius: r,
    stroke: frame-stroke, fill: col-frame.lighten(70%))

  // ─── Top arrow: left → right via top (reduce) ───
  bezier(
    (-cx + r + 0.02, 0.06),
    (cx - r - 0.02, 0.06),
    (-0.20, 0.55),
    (0.20, 0.55),
    stroke: arrow-stroke, mark: arrow-mark,
  )

  // ─── Bottom arrow: right → left via bottom (extract) ───
  bezier(
    (cx - r - 0.02, -0.06),
    (-cx + r + 0.02, -0.06),
    (0.20, -0.55),
    (-0.20, -0.55),
    stroke: arrow-stroke, mark: arrow-mark,
  )

  // ─── Equality mark in center: round-trip preserves the value ───
  line((-0.10, 0.05),  (0.10, 0.05),  stroke: pass-stroke)
  line((-0.10, -0.05), (0.10, -0.05), stroke: pass-stroke)
})
