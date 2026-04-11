#import "lib.typ": *
#import "@preview/cetz:0.4.2": canvas, draw
#import "@preview/cetz-plot:0.1.2": plot

#set page(..fig-page)
#set text(..fig-text)

// Weekly data mined from git history (week index, count)
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
    x-min: 0, x-max: 14,
    y-min: 0, y-max: 260,
    legend: "inner-north-west",
    legend-style: (
      stroke: none,
      fill: white,
      padding: 0.3,
    ),
    name: "plot",
    {
      // Phase boundary lines
      plot.add-vline(phase2-start, style: (stroke: (paint: luma(180), thickness: 0.8pt, dash: "dashed")))
      plot.add-vline(phase3-start, style: (stroke: (paint: luma(180), thickness: 0.8pt, dash: "dashed")))

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
    },
  )

  // Phase labels above the plot
  let label-y = 0.4  // offset above plot top
  content(
    (rel: (5.5 * 12/14, label-y), to: "plot.north-west"),
    text(6pt, fill: fg-light, [Phase 1: Manual]),
  )
  content(
    (rel: (9.6 * 12/14, label-y + 0.12), to: "plot.north-west"),
    text(6pt, fill: fg-light, [Phase 2:\ Basic skills]),
  )
  content(
    (rel: (13.2 * 12/14, label-y), to: "plot.north-west"),
    text(6pt, fill: fg-light, [Phase 3: Full pipeline]),
  )
})
