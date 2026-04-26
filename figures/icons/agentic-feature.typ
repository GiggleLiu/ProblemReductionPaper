#import "@preview/cetz:0.4.2": *

#set page(width: auto, height: auto, margin: 2pt, fill: none)

#canvas(length: 1cm, {
  import draw: *

  let col-frame = rgb("#8a5f7e")    // violet (harness)
  let col-pass  = rgb("#59a14f")    // green

  let frame-stroke = (paint: col-frame, thickness: 1.4pt, cap: "round", join: "round")
  let thin-stroke  = (paint: col-frame, thickness: 1.0pt, cap: "round", join: "round")
  let pass-stroke  = (paint: col-pass,  thickness: 1.6pt, cap: "round", join: "round")

  hide(rect((-0.78, -0.78), (0.78, 0.78)))

  // ─── Mask body (slightly egg-shaped: wider on top) ───
  circle((0, 0.05), radius: (0.50, 0.62),
    stroke: frame-stroke, fill: col-frame.lighten(85%))

  // ─── Mask tie ribbon stub on left side (visual cue: this is a mask) ───
  line((-0.50, 0.05), (-0.68, 0.18), stroke: thin-stroke)
  line((-0.50, 0.05), (-0.68, -0.10), stroke: thin-stroke)

  // ─── Eyes: white fill, violet outline (friendly bot-style, not creepy) ───
  circle((-0.20, 0.18), radius: 0.11,
    stroke: frame-stroke, fill: white)
  circle((0.20, 0.18), radius: 0.11,
    stroke: frame-stroke, fill: white)
  // Small pupils
  circle((-0.20, 0.18), radius: 0.045, fill: col-frame, stroke: none)
  circle((0.20, 0.18), radius: 0.045, fill: col-frame, stroke: none)

  // ─── Big upturned smile (clearly comedy mask) ───
  bezier(
    (-0.25, -0.12),
    (0.25, -0.12),
    (-0.15, -0.40),
    (0.15, -0.40),
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
