#import "@preview/cetz:0.4.2": *

#set page(width: auto, height: auto, margin: 2pt, fill: none)

#canvas(length: 1cm, {
  import draw: *

  let col-frame = rgb("#8a5f7e")    // violet (harness)
  let col-pass  = rgb("#59a14f")    // green

  let user-stroke = (paint: col-frame, thickness: 1.4pt, cap: "round", join: "round")
  let pass-stroke = (paint: col-pass,  thickness: 1.6pt, cap: "round", join: "round")
  let pass-thin   = (paint: col-pass,  thickness: 1.4pt, cap: "round", join: "round")
  let mag-stroke = (paint: col-frame, thickness: 1.0pt, cap: "round")

  // Force bbox to match other harness icons (±0.78)
  rect((-0.78, -0.78), (0.78, 0.78),
    stroke: (paint: white, thickness: 0.1pt), fill: none)

  // ─── BOT (head-only, on the left) ───
  let bot-cx = -0.42
  let bot-cy = 0.00
  let hw = 0.30   // half-width of head
  let hh = 0.28   // half-height of head

  // Outer head (rounded rect, filled)
  rect(
    (bot-cx - hw, bot-cy - hh),
    (bot-cx + hw, bot-cy + hh),
    radius: 0.06,
    fill: col-frame, stroke: none,
  )

  // White face cutout
  rect(
    (bot-cx - hw + 0.06, bot-cy - hh + 0.06),
    (bot-cx + hw - 0.06, bot-cy + hh - 0.06),
    radius: 0.02,
    fill: white, stroke: none,
  )

  // Side ears (small rectangles)
  rect(
    (bot-cx - hw - 0.05, bot-cy - 0.07),
    (bot-cx - hw + 0.005, bot-cy + 0.07),
    radius: 0.015, fill: col-frame, stroke: none,
  )
  rect(
    (bot-cx + hw - 0.005, bot-cy - 0.07),
    (bot-cx + hw + 0.05, bot-cy + 0.07),
    radius: 0.015, fill: col-frame, stroke: none,
  )

  // Antenna stem
  rect(
    (bot-cx - 0.025, bot-cy + hh),
    (bot-cx + 0.025, bot-cy + hh + 0.10),
    fill: col-frame, stroke: none,
  )
  // Antenna ball
  circle(
    (bot-cx, bot-cy + hh + 0.16),
    radius: 0.07,
    fill: col-frame, stroke: none,
  )

  // Eyes (vertical filled ovals)
  circle((bot-cx - 0.11, bot-cy + 0.05), radius: (0.045, 0.08),
    fill: col-frame, stroke: none)
  circle((bot-cx + 0.11, bot-cy + 0.05), radius: (0.045, 0.08),
    fill: col-frame, stroke: none)

  // Mouth (small filled rectangle)
  rect(
    (bot-cx - 0.11, bot-cy - 0.18),
    (bot-cx + 0.11, bot-cy - 0.12),
    fill: col-frame, stroke: none,
  )

  // ─── Magnification cone: two diverging lines from bot toward user ───
  // (like a comic-book "this is the zoomed-in view" effect)
  line((-0.04, 0.06), (0.32, 0.34), stroke: mag-stroke)
  line((-0.04, -0.06), (0.32, -0.34), stroke: mag-stroke)

  // ─── USER silhouette (right) ───
  let user-cx = 0.50
  // Head
  circle((user-cx, 0.18), radius: 0.16,
    stroke: user-stroke, fill: white)
  // Shoulders
  bezier(
    (user-cx - 0.28, -0.38),
    (user-cx + 0.28, -0.38),
    (user-cx - 0.16, -0.05),
    (user-cx + 0.16, -0.05),
    stroke: user-stroke,
  )

  // ─── Check stamp (top-right corner of user) ───
  let cx = 0.68
  let cy = 0.50
  circle((cx, cy), radius: 0.13, stroke: pass-thin, fill: white)
  line(
    (cx - 0.07, cy + 0.00),
    (cx - 0.02, cy - 0.05),
    (cx + 0.08, cy + 0.06),
    stroke: pass-stroke,
  )
})
