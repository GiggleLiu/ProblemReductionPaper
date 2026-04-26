#import "@preview/cetz:0.4.2": *

#set page(width: auto, height: auto, margin: 2pt, fill: none)

#canvas(length: 1cm, {
  import draw: *

  let col-frame = rgb("#8a5f7e")    // violet (harness)
  let col-pass  = rgb("#59a14f")    // green

  let frame-stroke = (paint: col-frame, thickness: 1.4pt, cap: "round", join: "round")
  let thin-stroke  = (paint: col-frame, thickness: 1.1pt, cap: "round", join: "round")
  // Dashed stroke for the simulated user (signals "agent acting as user").
  let user-stroke  = (paint: col-frame, thickness: 1.4pt, cap: "butt",
                      dash: (array: (3pt, 2pt)))
  let pass-stroke  = (paint: col-pass,  thickness: 1.6pt, cap: "round", join: "round")
  let pass-thin    = (paint: col-pass,  thickness: 1.4pt, cap: "round", join: "round")

  // Force bbox height to match type-check.typ exactly. (Width can vary;
  // height parity matters because the icon shares a row with type-check
  // in the harness panel.) hide() does not contribute to layout, so we use
  // an invisible-but-real stroke to anchor the canvas extent.
  rect((-0.78, -0.765), (0.78, 0.765),
    stroke: (paint: white, thickness: 0.1pt), fill: none)

  // ─── BOT (left): rounded-square head with antenna and two eye dots ───
  let bx = -0.45
  let by = -0.05
  let hw = 0.27
  let hh = 0.26

  // Antenna
  line((bx, by + hh), (bx, by + hh + 0.14), stroke: thin-stroke)
  circle((bx, by + hh + 0.20), radius: 0.06,
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
  circle((bx - 0.10, by + 0.04), radius: 0.05,
    fill: col-frame, stroke: none)
  circle((bx + 0.10, by + 0.04), radius: 0.05,
    fill: col-frame, stroke: none)

  // ─── USER (right): head + shoulder silhouette ───
  let ux = 0.40
  let uy = 0.06

  // Head
  circle((ux, uy), radius: 0.18,
    stroke: frame-stroke, fill: col-frame.lighten(85%))

  // Shoulders (rounded bezier, tangent to the head, kept inside bbox)
  bezier(
    (ux - 0.36, -0.58),
    (ux + 0.36, -0.58),
    (ux - 0.20, -0.20),
    (ux + 0.20, -0.20),
    stroke: frame-stroke,
  )

  // ─── Dialogue dots between them (•••) ───
  let dy = -0.07
  circle((-0.07, dy), radius: 0.045, fill: col-frame, stroke: none)
  circle(( 0.05, dy), radius: 0.045, fill: col-frame, stroke: none)
  circle(( 0.17, dy), radius: 0.045, fill: col-frame, stroke: none)

  // ─── Green check badge (top-right corner, mirrors type-check placement) ───
  group({
  scale(1.2)
  let cx = 0.50
  let cy = 0.48
  circle((cx, cy), radius: 0.16, stroke: pass-thin, fill: white)
  line(
    (cx - 0.09, cy + 0.00),
    (cx - 0.02, cy - 0.07),
    (cx + 0.10, cy + 0.08),
    stroke: pass-stroke,
  )})
})
