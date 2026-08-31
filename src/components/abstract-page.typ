#let abstract-page(
  body,
  title: [Resumo],
  lang: "pt",
  region: "BR",
  keywords-term: [Palavras-chave],
  keywords: ()
) = [
  #set text(lang: lang, region: region)
  = #title
  #set par(first-line-indent: 0cm, leading: 1em)
  #body
  \ \
  #keywords-term: #keywords.join("; ").
  #pagebreak(weak: true)
]
