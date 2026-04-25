#import "@preview/cetz:0.4.2": *

#set page(width: auto, height: auto, margin: 1pt)
#set text(size: 7.5pt, font: "Helvetica")

#let text-size = 7.5pt
#let text-red(body, size: text-size) = text(size, weight: "bold", fill: red, body)
#let text-blue(body, size: text-size) = text(size, weight: "bold", fill: blue, body)
#let text-green(body, size: text-size) = text(size, weight: "bold", fill: green, body)

#canvas({
  import draw: *
  circle((0, 0), radius: 1.4cm)
  content((0, 0), text(7.5pt, weight: "bold", [(#text-blue("3"))]))
})