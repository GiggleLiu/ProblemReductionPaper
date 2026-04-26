#import "@preview/cetz:0.4.2": *

#set page(width: auto, height: auto, margin: 2pt, fill: none)

#canvas(length: 1cm, {
  import draw: *

  let col-frame = rgb("#8a5f7e")    // violet (harness)
  let col-pass  = rgb("#59a14f")    // green
  let col-eye   = col-frame.darken(15%)

  let frame-stroke = (paint: col-frame, thickness: 1.4pt, cap: "round", join: "round")
  let pass-stroke  = (paint: col-pass,  thickness: 1.6pt, cap: "round", join: "round")

  hide(rect((-0.78, -0.78), (0.78, 0.78)))

  // ─── Mask body (ellipse) ───
  circle((0, 0), radius: (0.55, 0.68),
    stroke: frame-stroke, fill: col-frame.lighten(85%))

  // ─── Two eye holes (hollow, slightly tilted up — comedy mask) ───
  // Left eye
  circle((-0.22, 0.18), radius: (0.13, 0.10),
    stroke: frame-stroke, fill: col-eye)
  // Right eye
  circle((0.22, 0.18), radius: (0.13, 0.10),
    stroke: frame-stroke, fill: col-eye)

  // ─── Smile mouth ───
  bezier(
    (-0.22, -0.18),
    (0.22, -0.18),
    (-0.10, -0.40),
    (0.10, -0.40),
    stroke: frame-stroke,
  )

  // ─── Small green ✓ stamp at top-right (verified) ───
  let bx = 0.55
  let by = 0.55
  circle((bx, by), radius: 0.18, stroke: pass-stroke, fill: white)
  line(
    (bx - 0.09, by + 0.00),
    (bx - 0.02, by - 0.07),
    (bx + 0.09, by + 0.07),
    stroke: pass-stroke,
  )
})
