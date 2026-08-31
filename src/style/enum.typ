#let enum-style(body) = {
  set enum(
    numbering: "a)",
    indent: 1.5cm,
    body-indent: 1em,
  )
  show enum: it => {
    v(1.5em, weak: true)
    it
  }
  body
}
