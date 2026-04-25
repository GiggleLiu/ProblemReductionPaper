#import "@preview/cetz:0.4.2": *

#set page(width: auto, height: auto, margin: 1pt)
#set text(size: 7.5pt, font: "Helvetica")

#let text-size = 4.5pt
#let text-purple(body, size: text-size) = text(size, fill: rgb("#83379d"), body)
#let text-orange(body, size: text-size) = text(size, fill: rgb("#f28e2b"), body)
#let text-blue(body, size: text-size) = text(size, fill: blue, body)
#let text-green(body, size: text-size) = text(size, fill: rgb("#59a14f"), body)

#canvas({
  import draw: *
  circle((0, 0), radius: 1.4cm, fill: rgb("#f6f9fe"), stroke: 1pt + rgb("#AAC4E9"))
  rect((-0.9, 0.9), (0.9, 0.5), radius: 0.05cm, fill: none, stroke: 0.5pt)
  content((0, 0.7), text(text-size, [U = { 1, 2, 3, 4, 5, 6, 7 }]))

  rect((-1.2, 0.3), (-0.1, -0.1), radius: 0.05cm, fill: none, stroke: 0.5pt + blue)
  content((-1.0, 0.4), text(text-size, text-blue([S#sub[1] = { 1, 2, 4 }])))
  rect((0.1, 0.3), (1.2, -0.1), radius: 0.05cm, fill: none, stroke: 0.5pt + rgb("#59a14f"))
  rect((-1.2, -0.2), (-0.1, -0.6), radius: 0.05cm, fill: none, stroke: 0.5pt + rgb("#83379d"))
  rect((0.1, -0.2), (1.2, -0.6), radius: 0.05cm, fill: none, stroke: 0.5pt + rgb("#f28e2b"))


})