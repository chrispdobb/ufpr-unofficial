#let _note(body) = {
  set par(leading: 1em)
  set text(size: 10pt)
  body
}

#let _figure-outline(kind) = context {
  let cells = ()
  for f in query(figure.where(kind: kind, outlined: true)) {
    cells.push(link(f.location())[
      #upper(f.caption.supplement)
      #f.caption.counter.at(f.location()).first()
      #f.caption.separator
    ])
    cells.push(link(f.location())[
      #f.caption.body
      #box(width: 1fr, repeat[.])
      #counter(page).at(f.location()).first()
    ])
  }
  if cells != () [
    = Lista de #if kind == table [Tabelas] else [Figuras]
    #grid(..cells)
    #pagebreak(weak: true)
  ]
}

#let current-year = {
  let y = datetime.today().year()
  if y == none {return 0}
  y
}

// Template principal para a construção de trabalhos acadêmicos no padrão ABNT, incluindo elementos pré-textuais, textuais e pós-textuais.
//
// - body (content): Conteúdo textual do trabalho.
// -> content
#let template(
  body,

  // Obrigatórios
  title: [],
  authors: (),
  city: "",
  description: [],

  // Opcionais
  font: "Arial",
  bib: none,
  year: current-year,
  is-digital: true,
  has-cover: true,
  abstract: (body: [], keywords: ()),
  abstract-foreign: (lang: "en", title: [], body: [], keywords-term: [], keywords: ()),
  approval: []
) = {
  // Confere parâmetros obrigatórios
  if type(title) != content {
    panic("Trabalho deve ter um título em `title` do tipo `content`.")
  }
  if authors.len() == 0 {
    panic("Trabalho deve ter ao menos um autor em `authors`")
  }
  for author in authors {
    if type(author) != str {
      panic("Nome dos autores devem ser do tipo `str`.")
    }
  }
  if city == "" {
    panic("Trabalho deve ter uma cidade em `city` do tipo `str`.")
  }
  if type(description) != content {
    panic("Trabalho deve ter uma descrição em `desc` do tipo `content`.")
  }

  // Confere parâmetros opcionais
  if not ("Arial", "Times New Roman").contains(font) {
    panic("Recomenda-se o uso de \"Arial\" ou \"Times New Roman\" como fontes.")
  }

  // Dependentes de parâmetros
  let author-display = authors.map(upper).join("\n")
  let title-display = text(hyphenate: false)[#upper(title)]
  let city-year = align(bottom)[
    #upper(city)

    #year
  ]

  // Configurações de parâmetros
  set page(
    margin: if is-digital {
      (top: 3cm, bottom: 2cm, left: 3cm, right: 2cm)
    } else {
      (top: 3cm, bottom: 2cm, inside: 3cm, outside: 2cm)
    },
    header-ascent: 1cm
  )

  set text(
    font: font,
    size: 12pt,
    lang: "pt", region: "BR"
  )
  set par(
    justify: true,
    first-line-indent: (amount: 1.5cm, all: true),
    leading: 1.5em
  )
  set heading(
    numbering: none,
    supplement: none,
    outlined: false,
    bookmarked: true
  )
  set enum(
    numbering: "a)",
    indent: 1.5cm,
    body-indent: 1em
  )
  set list(
    marker: [--],
    body-indent: 1em
  )
  set bibliography(
    style: "associacao-brasileira-de-normas-tecnicas",
    full: true,
    title: [Referências]
  )
  set figure.caption(
    separator: [--],
    position: top
  )
  set cite(form: "prose")
  set grid(
    columns: (auto, 1fr),
    column-gutter: 1em,
    row-gutter: 1.5em
  )

  // Configurações de representação
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
  show heading.where(numbering: none): it => align(center)[#it]

  show figure: set cite(form: "prose")
  show figure: it => {
    show: _note
    show cite: c => [FONTE: #c]
    it
    if not it.body.has("children") {
      [FONTE: ] + if authors.len() > 1 [Autores (#year)] else [Autor (#year)]
    }
  }
  show figure.caption: it => [
    #upper(it.supplement)
    #it.counter.display(it.numbering)
    #it.separator
    #it.body
  ]

  show footnote.entry: set cite(form: "full")

  // Seção pré-textual sem numeração
  if has-cover { // capa
    page(background: image("cover.png"))[
      #set align(center)
      UNIVERSIDADE FEDERAL DO PARANÁ
      \ \
      #author-display
      #place(horizon)[#title-display]
      #city-year
    ]
    if not is-digital {page[]}
    counter(page).update(0)
  }

  page[ // folha de rosto
    #set align(center)
    #author-display
    #for i in range(0, 13 - authors.len()) {linebreak()}
    #title-display
    \ \ \
    #align(right, block(width: 50%)[
      #set align(left)
      #set par(first-line-indent: 0cm)
      #show: _note
      #description
    ])
    #city-year
  ]
  if not is-digital {page[]} // espaço para a ficha catalográfica

  if approval != [] { // folha de aprovação
    page[#approval]
  }

  // TODO dedicatória, agradecimentos, epígrafe

  if abstract.body != [] [ // resumo em língua vernácula
    #set par(first-line-indent: 0cm, leading: 1em)
    = Resumo
    #abstract.body
    \ \
    Palavras-chave: #abstract.keywords.join("; ").
    #pagebreak(weak: true)
  ]

  if abstract-foreign.body != [] [ // resumo em língua estrangeira
    #set text(lang: abstract-foreign.lang)
    #set par(first-line-indent: 0cm, leading: 1em)
    = #abstract-foreign.title
    #abstract-foreign.body
    \ \
    #abstract-foreign.keywords-term: #abstract-foreign.keywords.join("; ").
    #pagebreak(weak: true)
  ]

  _figure-outline(image) // lista de ilustrações

  _figure-outline(table) // lista de tabelas

  // TODO lista de abreviaturas e/ou siglas

  [= Sumário]
  context {
    let cells = ()
    let weight
    let case-func
    for h in query(heading.where(outlined: true)) {
      if h.level == 1 {
        weight = "bold"
        case-func = upper
      }
      else if h.level == 2 {
        weight = "regular"
        case-func = upper
      }
      else {
        weight = "regular"
        case-func = it => it
      }

      if h.numbering == none {cells.push[]}
      else {
        cells.push(link(
          h.location(),
          text(weight: weight)[#numbering(h.numbering, ..counter(heading).at(h.location()))]
        ))
      }

      cells.push(link(
        h.location(),
        text(
          weight: weight,
          case-func[#h.body#box(width: 1fr, repeat[.])#counter(page).at(h.location()).first()]
        )
      ))
    }
    grid(..cells)
  }

  // Seção textural com numeração
  set page(
    header: if is-digital {
      context align(right)[#counter(page).display()]
    } else {context {
      let page-number = counter(page).get().first()
      align(if calc.rem(page-number, 2) == 0 {left} else {right})[#page-number]
    }}
  )
  set heading(outlined: true, numbering: "1.1")

  body

  set heading(numbering: none)
  bib
}
