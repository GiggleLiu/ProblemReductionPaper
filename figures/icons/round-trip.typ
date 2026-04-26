#import "@preview/cetz:0.4.2": *

#set page(width: auto, height: auto, margin: 2pt, fill: none)

#canvas(length: 1cm, {
  import draw: *

  let col-frame = rgb("#8a5f7e")    // violet (harness)
  let col-pass  = rgb("#59a14f")    // green

  let frame-stroke = (paint: col-frame, thickness: 1.4pt, cap: "round", join: "round")
  let arrow-stroke = (paint: col-frame, thickness: 1.4pt, cap: "round")
  let pass-stroke  = (paint: col-pass,  thickness: 1.6pt, cap: "round", join: "round")
  let arrow-mark   = (end: "straight", scale: 0.4)

  // Match bbox of unit-tests / type-check
  hide(rect((-0.78, -0.78), (0.78, 0.78)))

  // ─── Two endpoint nodes — white fill, violet stroke (matches other icons) ───
  let r = 0.22
  let cx = 0.48
  circle((-cx, 0), radius: r, stroke: frame-stroke, fill: white)
  circle((cx, 0),  radius: r, stroke: frame-stroke, fill: white)

  // Tiny green check inside the right node — "verified equal after round-trip"
  line(
    (cx - 0.10, 0.00),
    (cx - 0.02, -0.07),
    (cx + 0.10, 0.07),
    stroke: pass-stroke,
  )

  // ─── Top arrow: left → right via top (reduce) ───
  bezier(
    (-cx + r + 0.04,  0.04),
    (cx - r - 0.04,   0.04),
    (-0.18, 0.42),
    (0.18,  0.42),
    stroke: arrow-stroke, mark: arrow-mark,
  )

  // ─── Bottom arrow: right → left via bottom (extract) ───
  bezier(
    (cx - r - 0.04,   -0.04),
    (-cx + r + 0.04,  -0.04),
    (0.18,  -0.42),
    (-0.18, -0.42),
    stroke: arrow-stroke, mark: arrow-mark,
  )
})
