#let icon(offset: 0em, scale: 1, name) = text(
  font: "Material Symbols Outlined Filled",
  size: 5em/6 * scale,
  baseline: 5em/72 + offset,
  weight: 900,
  features: (("FILL": 1)),
  top-edge: "bounds",
  bottom-edge: "bounds",
  name)
#let rd-icon =  text(baseline: -1pt, font: "Romeosymbols", "a")
#let uc-logo() =  text.with(font: "Romeosymbols", "A")
#let romeo-sig() =  text.with(font: "Romeosymbols", "j")