#import "@preview/cetz:0.4.2": *

#set page(width: auto, height: auto, margin: 2pt, fill: none)

#canvas(length: 1cm, {
  import draw: *

  let col-frame = rgb("#8a5f7e")    // violet (harness)
  let col-pass  = rgb("#59a14f")    // green

  let frame-stroke = (paint: col-frame, thickness: 1.4pt, cap: "round", join: "round")
  let thin-stroke  = (paint: col-frame, thickness: 1.1pt, cap: "round", join: "round")
  let pass-stroke  = (paint: col-pass,  thickness: 1.6pt, cap: "round", join: "round")
  let pass-thin    = (paint: col-pass,  thickness: 1.4pt, cap: "round", join: "round")

  // Match other harness icons (±0.78 bbox)
  hide(rect((-0.78, -0.78), (0.78, 0.78)))

  // ─── BOT (left): rounded-square head with antenna and two eye dots ───
  let bx = -0.42
  let by = -0.02
  let hw = 0.30
  let hh = 0.26

  // Antenna
  line((bx, by + hh), (bx, by + hh + 0.16), stroke: thin-stroke)
  circle((bx, by + hh + 0.22), radius: 0.06,
    fill: col-frame, stroke: none)

  // Head (stroke + light fill, matches other icons)
  rect(
    (bx - hw, by - hh),
    (bx + hw, by + hh),
    radius: 0.07,
    stroke: frame-stroke,
    fill: col-frame.lighten(85%),
  )

  // Eyes (filled violet dots)
  circle((bx - 0.11, by + 0.04), radius: 0.05,
    fill: col-frame, stroke: none)
  circle((bx + 0.11, by + 0.04), radius: 0.05,
    fill: col-frame, stroke: none)

  // ─── USER (right): head + shoulder silhouette ───
  let ux = 0.46
  let uy = 0.10

  // Head
  circle((ux, uy), radius: 0.18,
    stroke: frame-stroke, fill: col-frame.lighten(85%))

  // Shoulders (rounded bezier, anchored below the head)
  bezier(
    (ux - 0.40, -0.55),
    (ux + 0.40, -0.55),
    (ux - 0.22, -0.18),
    (ux + 0.22, -0.18),
    stroke: frame-stroke,
  )

  // ─── Dialogue dots between them (•••) ───
  let dy = -0.05
  circle((-0.06, dy), radius: 0.045, fill: col-frame, stroke: none)
  circle(( 0.06, dy), radius: 0.045, fill: col-frame, stroke: none)
  circle(( 0.18, dy), radius: 0.045, fill: col-frame, stroke: none)

  // ─── Green check badge (top-right corner) ───
  let cx = 0.62
  let cy = 0.58
  circle((cx, cy), radius: 0.16, stroke: pass-thin, fill: white)
  line(
    (cx - 0.09, cy + 0.00),
    (cx - 0.02, cy - 0.07),
    (cx + 0.10, cy + 0.08),
    stroke: pass-stroke,
  )
})
