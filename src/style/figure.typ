#import "../common/note.typ": note
#import "../common/strip.typ": strip

#let figure-style(body, multiple-authors: false, year: 0) = {
  set figure.caption(
    separator: [--],
    position: top
  )
  // show figure.where(kind: table): set figure(supplement: [Quadro])

  show figure: it => {
    if not it.body.has("children") {panic[Figura deve ter menção de autoria.]}
    let children = strip(it.body.children)
    block(
      breakable: false,
      spacing: 2.5em,
      note[
        #it.caption
        #children.first()
        FONTE: #children.slice(1).join().
      ]
    )
  }
  show figure.caption: it => [
    #upper(it.supplement)
    #it.counter.display(it.numbering)
    #it.separator
    #upper(it.body)
  ]

  body
}
