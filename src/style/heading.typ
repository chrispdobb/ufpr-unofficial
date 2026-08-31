#let heading-style(body) = {
  set heading(
    numbering: none,
    supplement: none,
    outlined: false,
    bookmarked: true
  )

  show heading: set text(size: 12pt, weight: "regular")
  show heading: set par(leading: 1em)
  show heading: it => {
    v(2*1.5em, weak: true)
    it
    v(2*1.5em, weak: true)
  }
  show heading.where(level: 1): it => {
    pagebreak(weak: true)
    text(weight: "bold", upper(it))
  }
  show heading.where(level: 2): upper
  show heading.where(numbering: none): it => align(center, it)

  body
}
