#import "@preview/cetz:0.4.2": *

#set page(width: auto, height: auto, margin: 2pt, fill: none)

#canvas(length: 1cm, {
  import draw: *

  let col-frame = rgb("#8a5f7e")    // violet (harness)
  let col-pass  = rgb("#59a14f")    // green
  let col-fail  = rgb("#e15759")    // red

  let frame-stroke = (paint: col-frame, thickness: 1.4pt, cap: "round", join: "round")
  let arrow-stroke = (paint: col-frame, thickness: 1.4pt, cap: "round")
  let pass-stroke  = (paint: col-pass,  thickness: 1.6pt, cap: "round", join: "round")
  let arrow-mark   = (end: "straight", scale: 0.4)

  hide(rect((-0.78, -0.78), (0.78, 0.78)))

  // ─── Three nodes: A (problem) → B (target with solver) → A' (recovered, ✓) ───
  let r = 0.18
  let xa = -0.58
  let xb = 0.00
  let xc = 0.58

  // A: source problem (empty circle)
  circle((xa, 0), radius: r, stroke: frame-stroke, fill: white)
  // Question mark inside to suggest "unknown / need to solve"
  content((xa, 0), text(7pt, weight: "bold", fill: col-frame, [?]))

  // B: target with a small gear inside, indicating "solver runs here"
  rect((xb - r, -r), (xb + r, r), radius: 0.04,
    stroke: frame-stroke, fill: col-frame.lighten(85%))
  // Mini gear glyph inside B (4 little teeth + hub)
  let mini-pts = ()
  for i in range(6) {
    let cdeg = i * 60
    let half = 12
    let r-tip-m = 0.10
    let r-base-m = 0.07
    let a1 = (cdeg - half) * 1deg
    let a2 = (cdeg + half) * 1deg
    let a3 = (cdeg + 60 - half) * 1deg
    mini-pts.push((xb + r-tip-m * calc.cos(a1), r-tip-m * calc.sin(a1)))
    mini-pts.push((xb + r-tip-m * calc.cos(a2), r-tip-m * calc.sin(a2)))
    mini-pts.push((xb + r-base-m * calc.cos((cdeg + 30) * 1deg),
                   r-base-m * calc.sin((cdeg + 30) * 1deg)))
  }
  line(..mini-pts, close: true,
    stroke: (paint: col-frame, thickness: 1.0pt), fill: white)

  // A': recovered solution (circle with green ✓)
  circle((xc, 0), radius: r, stroke: frame-stroke, fill: white)
  line(
    (xc - 0.10, 0.00),
    (xc - 0.02, -0.07),
    (xc + 0.10, 0.07),
    stroke: pass-stroke,
  )

  // Arrows: A → B → A'
  line((xa + r + 0.03, 0), (xb - r - 0.03, 0),
    stroke: arrow-stroke, mark: arrow-mark)
  line((xb + r + 0.03, 0), (xc - r - 0.03, 0),
    stroke: arrow-stroke, mark: arrow-mark)
})
