#import "@preview/cetz:0.4.2": *

#set page(width: auto, height: auto, margin: 1pt, fill: none)
#set text(size: 7.5pt, weight: "bold", font: "Helvetica")

#let text-size = 9pt
#let text-purple(body, size: text-size) = text(size, fill: rgb("#83379d"), body)
#let text-orange(body, size: text-size) = text(size, fill: rgb("#f28e2b"), body)
#let text-blue(body, size: text-size) = text(size, fill: blue, body)
#let text-green(body, size: text-size) = text(size, fill: rgb("#59a14f"), body)

#canvas({
  import draw: *
  circle((0, 0), radius: 1.4cm, fill: white, stroke: 2pt + rgb("#AAC4E9"))
  rect((-0.9, 0.9), (0.9, 0.5), radius: 0.05cm, fill: none, stroke: 0.5pt)
  content((0, 0.7), text(text-size, [U = {1, 2, 3, 4, 5, 6, 7}]))

  rect((-1.15, 0.3), (-0.05, -0.1), radius: 0.05cm, fill: none, stroke: 0.5pt + blue)
  content((-0.6, 0.1), text(text-size, text-blue([S#sub[1] = {1, 2, 4}])))
  rect((0.05, 0.3), (1.15, -0.1), radius: 0.05cm, fill: none, stroke: 0.5pt + rgb("#59a14f"))
  content((0.6, 0.1), text(text-size, text-green([S#sub[2] = {2, 3, 5}])))
  rect((-1.15, -0.3), (-0.05, -0.7), radius: 0.05cm, fill: none, stroke: 0.5pt + rgb("#83379d"))
  content((-0.6, -0.5), text(text-size, text-purple([S#sub[3] = {4, 5, 6}])))
  rect((0.05, -0.3), (1.15, -0.7), radius: 0.05cm, fill: none, stroke: 0.5pt + rgb("#f28e2b"))
  content((0.6, -0.5), text(text-size, text-orange([S#sub[4] = {1, 6, 7}])))

})