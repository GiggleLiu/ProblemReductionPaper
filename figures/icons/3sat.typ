#import "@preview/cetz:0.4.2": *

#set page(width: auto, height: auto, margin: 1pt, fill: none)
#set text(size: 7.5pt, weight: "bold", font: "DejaVu Sans Mono")

#let text-size = 7.5pt
#let text-red(body, size: text-size) = text(size, fill: red, body)
#let text-blue(body, size: text-size) = text(size, fill: blue, body)
#let text-green(body, size: text-size) = text(size, fill: rgb("#59a14f"), body)

#canvas({
  import draw: *
  circle((0, 0), radius: 1.4cm, fill: rgb("#f6f9fe"), stroke: 1pt + rgb("#AAC4E9"))
  content((0, 0.5), text(text-size, [(#text-green("x") ∨ ¬#text-red("y") ∨ #text-blue("z"))]))
  content((0, 0), text(text-size,[(¬#text-green("x") ∨ #text-red("y") ∨ ¬#text-blue("z"))]))
  content((0, -0.5), text(text-size,[(¬#text-red("y") ∨ #text-blue("z") ∨ ¬#text-green("x"))]))
})