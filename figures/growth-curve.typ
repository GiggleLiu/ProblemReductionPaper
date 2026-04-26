#import "lib.typ": *

#set page(..fig-page)
#set text(..fig-text)

// Weekly data mined from git history (week index, count).
#let data-models = (
  (0, 17), (2, 20), (3, 20), (4, 20), (5, 21),
  (6, 21), (7, 23), (8, 23), (9, 39), (10, 107), (11, 116),
  (12, 187), (13, 187),
)
#let data-rules = (
  (0, 0), (2, 21), (3, 24), (4, 35), (5, 45),
  (6, 52), (7, 52), (8, 52), (9, 56), (10, 73), (11, 153),
  (12, 214), (13, 239),
)
#let phase2-start = 7
#let phase3-start = 8.5

#let col-models = accent             // steel blue (problem types)
#let col-rules  = rgb("#e15759")     // coral red (reduction rules)

#canvas(length: 0.6cm, {
  import draw: *

  // Plot area in canvas units.
  let x-min  = 0
  let x-max  = 13.5
  let y-max  = 260
  let plot-w = 13.0
  let plot-h = 6.0
  let x0 = 0.0
  let y0 = 0.0

  // Data → canvas coordinates.
  let sx(w) = x0 + (w - x-min) / (x-max - x-min) * plot-w
  let sy(c) = y0 + c / y-max * plot-h
  let pt(p) = (sx(p.at(0)), sy(p.at(1)))

  // ─── Phase boundary verticals (drawn first so curves overlay) ───
  line((sx(phase2-start), y0), (sx(phase2-start), y0 + plot-h),
    stroke: (thickness: 0.5pt, paint: luma(170), dash: "dashed"))
  line((sx(phase3-start), y0), (sx(phase3-start), y0 + plot-h),
    stroke: (thickness: 0.5pt, paint: luma(170), dash: "dashed"))

  // ─── Reduction rules curve (red, drawn first → behind) ───
  let rules-pts = data-rules.map(pt)
  let rules-fill = rules-pts + (
    (rules-pts.last().at(0), y0),
    (rules-pts.first().at(0), y0),
  )
  merge-path(close: true, fill: col-rules.lighten(85%), stroke: none, {
    line(..rules-fill)
  })
  line(..rules-pts, stroke: (thickness: 1.4pt, paint: col-rules))
  for p in rules-pts {
    circle(p, radius: 0.16, fill: white,
      stroke: (thickness: 0.7pt, paint: col-rules))
  }

  // ─── Problem types curve (blue, on top) ───
  let models-pts = data-models.map(pt)
  let models-fill = models-pts + (
    (models-pts.last().at(0), y0),
    (models-pts.first().at(0), y0),
  )
  merge-path(close: true, fill: col-models.lighten(85%), stroke: none, {
    line(..models-fill)
  })
  line(..models-pts, stroke: (thickness: 1.4pt, paint: col-models))
  for p in models-pts {
    circle(p, radius: 0.16, fill: white,
      stroke: (thickness: 0.7pt, paint: col-models))
  }

  // ─── Axes (arrow-headed, schematic) ───
  line((x0, y0), (x0 + plot-w + 0.6, y0),
    stroke: (thickness: 0.7pt, paint: fg),
    mark: (end: "straight", scale: 0.35))
  line((x0, y0), (x0, y0 + plot-h + 0.8),
    stroke: (thickness: 0.7pt, paint: fg),
    mark: (end: "straight", scale: 0.35))

  // Axis labels
  content((x0 + plot-w / 2, -1.1),
    text(8pt, fill: fg, [weeks since project start]))
  content((-0.6, y0 + plot-h / 2), angle: 90deg,
    text(8pt, fill: fg, [count]))

  // ─── Phase labels above the plot top ───
  // Phase widths: 1 ≈ 0–7, 2 ≈ 7–8.5 (narrow), 3 ≈ 8.5–13.
  content((sx(3.5),  y0 + plot-h + 0.6),
    text(7.5pt, fill: fg-light, [Phase 1: manual]))
  content((sx(7.75), y0 + plot-h + 0.6),
    text(7pt,   fill: fg-light, [Phase 2:\ basic skills]))
  content((sx(10.75), y0 + plot-h + 0.6),
    text(7.5pt, fill: fg-light, [Phase 3: full pipeline]))

  // ─── Title (top-left, above the phase strip) ───
  content((x0, y0 + plot-h + 1.7),
    anchor: "south-west",
    text(10pt, fill: fg, weight: "bold", [Growth over time]))

  // ─── Mini legend (inside plot, top-left where curves are still low) ───
  let lx = sx(0.3)
  let ly = y0 + plot-h - 0.4
  let lh = 0.5
  rect((lx - 0.15, ly - lh - 0.15), (lx + 3.2, ly + 0.3),
    fill: white, stroke: (thickness: 0.4pt, paint: luma(220)),
    radius: 0.06)
  // Problem types entry
  line((lx, ly), (lx + 0.7, ly),
    stroke: (thickness: 1.4pt, paint: col-models))
  circle((lx + 0.35, ly), radius: 0.13, fill: white,
    stroke: (thickness: 0.7pt, paint: col-models))
  content((lx + 0.85, ly), anchor: "west",
    text(7pt, fill: fg, [problem types]))
  // Reduction rules entry
  line((lx, ly - lh), (lx + 0.7, ly - lh),
    stroke: (thickness: 1.4pt, paint: col-rules))
  circle((lx + 0.35, ly - lh), radius: 0.13, fill: white,
    stroke: (thickness: 0.7pt, paint: col-rules))
  content((lx + 0.85, ly - lh), anchor: "west",
    text(7pt, fill: fg, [reduction rules]))
})
