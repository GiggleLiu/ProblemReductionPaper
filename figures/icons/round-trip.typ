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

  hide(rect((-0.78, -0.78), (0.78, 0.78)))

  // Triangular layout: A (top-left) → B (right) → A' (bottom-left)
  let r = 0.22
  let xa = -0.42
  let yA = 0.50
  let xb = 0.45
  let yB = 0.00
  let xc = -0.42
  let yC = -0.50

  // ─── A: source problem ───
  circle((xa, yA), radius: r, stroke: frame-stroke, fill: white)
  content((xa, yA), text(8pt, weight: "bold", fill: col-frame, [?]))

  // ─── B: target with solver indicator ───
  rect((xb - r, yB - r), (xb + r, yB + r), radius: 0.04,
    stroke: frame-stroke, fill: col-frame.lighten(85%))
  // Mini gear inside B (6 teeth)
  let mini-pts = ()
  for i in range(6) {
    let cdeg = i * 60
    let half = 13
    let r-tip-m = 0.13
    let r-base-m = 0.09
    let a1 = (cdeg - half) * 1deg
    let a2 = (cdeg + half) * 1deg
    mini-pts.push((xb + r-tip-m * calc.cos(a1), yB + r-tip-m * calc.sin(a1)))
    mini-pts.push((xb + r-tip-m * calc.cos(a2), yB + r-tip-m * calc.sin(a2)))
    mini-pts.push((xb + r-base-m * calc.cos((cdeg + 30) * 1deg),
                   yB + r-base-m * calc.sin((cdeg + 30) * 1deg)))
  }
  line(..mini-pts, close: true,
    stroke: (paint: col-frame, thickness: 1.0pt), fill: white)

  // ─── A': recovered (with ✓) ───
  circle((xc, yC), radius: r, stroke: frame-stroke, fill: white)
  line(
    (xc - 0.12, yC + 0.00),
    (xc - 0.02, yC - 0.10),
    (xc + 0.12, yC + 0.10),
    stroke: pass-stroke,
  )

  // ─── Arrows: A → B → A' ───
  // A → B (diagonal down-right)
  let dx1 = xb - xa
  let dy1 = yB - yA
  let len1 = calc.sqrt(dx1*dx1 + dy1*dy1)
  let ux1 = dx1 / len1
  let uy1 = dy1 / len1
  line(
    (xa + ux1 * (r + 0.03), yA + uy1 * (r + 0.03)),
    (xb - ux1 * (r + 0.03), yB - uy1 * (r + 0.03)),
    stroke: arrow-stroke, mark: arrow-mark,
  )
  // B → A' (diagonal down-left)
  let dx2 = xc - xb
  let dy2 = yC - yB
  let len2 = calc.sqrt(dx2*dx2 + dy2*dy2)
  let ux2 = dx2 / len2
  let uy2 = dy2 / len2
  line(
    (xb + ux2 * (r + 0.03), yB + uy2 * (r + 0.03)),
    (xc - ux2 * (r + 0.03), yC - uy2 * (r + 0.03)),
    stroke: arrow-stroke, mark: arrow-mark,
  )
})
