#let page-style(body, is-digital: true) = {
  set page(
    margin: if is-digital {
      (top: 3cm, bottom: 2cm, left: 3cm, right: 2cm)
    } else {
      (top: 3cm, bottom: 2cm, inside: 3cm, outside: 2cm)
    },
    header-ascent: 1cm
  )
  body
}
