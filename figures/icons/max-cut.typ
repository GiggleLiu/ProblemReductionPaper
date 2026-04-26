#import "@preview/cetz:0.4.2": *

#set page(width: auto, height: auto, margin: 1pt, fill: none)
#set text(size: 7.5pt, font: "DejaVu Sans Mono")
#canvas({
  import draw: *
  let red-circle(position, name: none) = circle(position, radius: 0.1cm, fill: rgb("#e42f29"), stroke: 0.5pt, name: name)
  let blue-circle(position, name: none) = circle(position, radius: 0.1cm, fill: rgb("#4e79a7"), stroke: 0.5pt, name: name)

  circle((0, 0), radius: 1.4cm, fill: white, stroke: 2pt + rgb("#AAC4E9"))
  red-circle((-0.4, 0.9), name: "r1")
  red-circle((-0.9, 0.4), name: "r2")
  red-circle((-0.5, -0.1), name: "r3")
  red-circle((-0.7, -0.6), name: "r4")
  blue-circle((0.6, 0.5), name: "b1")
  blue-circle((0.85, -0.1), name: "b2")
  blue-circle((0.5, -0.7), name: "b3")

  line("r1", "b1", stroke: (paint: black.lighten(20%), thickness: 0.8pt, dash: "densely-dashed"))
  line("r1", "b2", stroke: (paint: black.lighten(20%), thickness: 0.8pt, dash: "densely-dashed"))
  line("r2", "b2", stroke: (paint: black.lighten(20%), thickness: 0.8pt, dash: "densely-dashed"))
  line("r3", "b1", stroke: (paint: black.lighten(20%), thickness: 0.8pt, dash: "densely-dashed"))
  line("r4", "b2", stroke: (paint: black.lighten(20%), thickness: 0.8pt, dash: "densely-dashed"))
  line("r4", "b3", stroke: (paint: black.lighten(20%), thickness: 0.8pt, dash: "densely-dashed"))

  line("r1", "r2", stroke: (paint: black.lighten(20%), thickness: 0.8pt))
  line("r3", "r2", stroke: (paint: black.lighten(20%), thickness: 0.8pt))
  line("r3", "r4", stroke: (paint: black.lighten(20%), thickness: 0.8pt))

  line("b1", "b2", stroke: (paint: black.lighten(20%), thickness: 0.8pt))
  line("b2", "b3", stroke: (paint: black.lighten(20%), thickness: 0.8pt))
})