#import "style/page.typ": page-style
#import "style/text.typ": text-style
#import "style/par.typ": par-style
#import "style/heading.typ": heading-style
#import "style/enum.typ": enum-style
#import "style/list.typ": list-style
#import "style/bibliography.typ": bibliography-style
#import "style/cite.typ": cite-style
#import "style/figure.typ": figure-style
#import "style/grid.typ": grid-style
#import "style/footnote.typ": footnote-style

#import "components/title-page.typ": title-page
#import "components/outline-page.typ": outline-page
#import "components/figure-outline-page.typ": figure-outline-page
#import "components/abstract-page.typ": abstract-page
#import "components/sheet.typ": sheet

#let current-year = {
  let y = datetime.today().year()
  if y == none {return 0}
  y
}

// TODO documentação
#let template(
  body,

  // Obrigatórios
  title: [],
  authors: (),
  city: "",
  description: [],

  // Opcionais
  font: "Arial",
  references: none,
  year: current-year,
  is-digital: true,
  has-cover: true,
  abstract: (body: [], keywords: ()),
  abstract-foreign: (
    body: [],
    keywords: (),
    title: [= Abstract],
    keywords-term: [Key words],
    lang: "en",
    region: "US",
  )
) = {
  // Confere parâmetros obrigatórios
  if type(title) != content {panic[
    Trabalho deve ter um título em `title` do tipo `content`.
  ]}
  if authors.len() == 0 {panic[
    Trabalho deve ter ao menos um autor em `authors`.
  ]}
  for author in authors {
    if type(author) != str {panic[
      Nome dos autores devem ser do tipo `str`.
    ]}
  }
  if city == "" {panic[
    Trabalho deve ter uma cidade em `city` do tipo `str`.
  ]}
  if type(description) != content {panic[
    Trabalho deve ter uma descrição em `desc` do tipo `content`.
  ]}

  // Confere parâmetros opcionais
  if not ("Arial", "Times New Roman").contains(font) {panic[
    Recomenda-se o uso de "Arial" ou "Times New Roman" como fontes.
  ]}

  // Variáveis
  let author-display = authors.map(upper).join("\n")
  let title-display = text(hyphenate: false, upper(title))
  let city-year = align(bottom)[
    #upper(city)

    #year
  ]

  // Configuração de estilos
  show: page-style.with(is-digital: is-digital)
  show: text-style.with(font: font)
  show: par-style
  show: heading-style
  show: enum-style
  show: list-style
  show: bibliography-style
  show: cite-style
  show: figure-style.with(
    multiple-authors: authors.len() > 1,
    year: year
  )
  show: grid-style
  show: footnote-style

  // Seção pré-textual sem numeração
  if has-cover { // Folha de capa
    import "components/cover-page.typ": cover-page
    cover-page(
      title-display: title-display,
      author-display: author-display,
      city-year: city-year
    )
    if not is-digital {page[]}
    counter(page).update(1)
  }
  title-page( // Folha de rosto
    title-display: title-display,
    author-display: author-display,
    author-count: authors.len(),
    city-year: city-year,
    description: description
  )
  if not is-digital {page[]}
  // TODO folha de aprovação, dedicatória, agradecimentos, epígrafe
  if abstract.body != [] {abstract-page( // Resumo em língua vernácula
    abstract.body,
    keywords: abstract.keywords
  )}
  if abstract-foreign.body != [] { // Resumo em língua estrangeira
    let foreign = (
      lang: "en",
      region: "US",
      keywords-term: [Key words],
      title: [Abstract]
    ) + abstract-foreign
    abstract-page(
      foreign.body,
      keywords: foreign.keywords,
      keywords-term: foreign.keywords-term,
      title: foreign.title,
      lang: foreign.lang,
      region: foreign.region
    )
  }

  figure-outline-page // Lista de ilustrações
  // TODO Lista de tabelas
  outline-page // Sumário

  // Seção textual com numeração
  set page(
    header: if is-digital {
      context align(right, counter(page).display())
    } else {context {
      let page-number = counter(page).get().first()
      align(if calc.rem(page-number, 2) == 0 {left} else {right})[#page-number]
    }}
  )
  set heading(outlined: true, numbering: "1.1")
  body

  // Seção pós-textual com numeração
  set heading(numbering: none)
  references
}
