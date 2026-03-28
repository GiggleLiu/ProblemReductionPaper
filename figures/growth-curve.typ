#import "lib.typ": *
#import "@preview/cetz:0.4.2": canvas, draw
#import "@preview/cetz-plot:0.1.2": plot

#set page(..fig-page)
#set text(..fig-text)

// Weekly data mined from git history (week index, count)
#let data-models = (
  (0, 17), (2, 20), (3, 20), (4, 20), (5, 21),
  (6, 21), (7, 23), (8, 23), (9, 39), (10, 107), (11, 114),
)
#let data-rules = (
  (0, 0), (2, 21), (3, 24), (4, 38), (5, 48),
  (6, 55), (7, 55), (8, 55), (9, 59), (10, 77), (11, 159),
)

// Phase boundaries (week indices)
#let phase2-start = 7
#let phase3-start = 8.5

#let col-models = accent
#let col-rules = rgb("#e15759")

#canvas(length: 0.6cm, {
  import draw: *

  plot.plot(
    size: (12, 6),
    axis-style: "scientific",
    x-label: [Weeks since project start],
    y-label: [Count],
    x-tick-step: 2,
    y-tick-step: 40,
    x-min: 0, x-max: 12,
    y-min: 0, y-max: 180,
    legend: "inner-north-west",
    legend-style: (
      stroke: none,
      fill: white,
      padding: 0.3,
    ),
    {
      // Phase background shading
      plot.add-fill-between(
        domain: (phase2-start, phase3-start),
        x => 0, x => 180,
        style: (stroke: none, fill: luma(240)),
      )
      plot.add-fill-between(
        domain: (phase3-start, 12),
        x => 0, x => 180,
        style: (stroke: none, fill: luma(228)),
      )

      // Data lines
      plot.add(
        data-models,
        mark: "o",
        mark-size: 0.12,
        line: "linear",
        label: [Problem types],
        style: (stroke: (paint: col-models, thickness: 1.5pt)),
      )
      plot.add(
        data-rules,
        mark: "triangle",
        mark-size: 0.12,
        line: "linear",
        label: [Reduction rules],
        style: (stroke: (paint: col-rules, thickness: 1.5pt)),
      )

      // Phase labels via annotate
      plot.annotate({
        content((3.5, 170), text(6pt, fill: fg-light, [Phase 1: Manual]))
        content((7.75, 170), text(6pt, fill: fg-light, [P2]))
        content((10.25, 170), text(6pt, fill: fg-light, [Phase 3: Full pipeline]))
      })
    },
  )
})
