#set page(width: 12cm, height: auto, margin: 1.5cm)

= Hello, Typst!

This is a simple test document to try out *Typst*, a modern typesetting system.

== Features to try

- Easy *bold* and _italic_ text
- Automatic numbered lists:
  + First item
  + Second item
  + Third item
- Inline math: $x^2 + y^2 = r^2$
- Block math:

$ integral_0^infinity e^(-x^2) dif x = sqrt(pi) / 2 $

== A simple table

#table(
  columns: 3,
  [*Name*], [*Language*], [*Year*],
  [Typst], [Rust], [2019],
  [LaTeX], [TeX], [1984],
)

#line(length: 100%)