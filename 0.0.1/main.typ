#import "@preview/modpattern:0.1.0": *
#import "icons.typ": icon as iconloader

#let catppuccin = (
  crust: rgb("#11111b"),
  mantle: rgb("#181825"),
  base: rgb("#1e1e2e"),
  surface0: rgb("#313244"),
  surface1: rgb("#45475a"),
  surface2: rgb("#585b70"),
  text: rgb("#cdd6f4"),
  blue: rgb("#89b4fa"),
  red: rgb("#f38ba8"),
  yellow: rgb("#f9e2af"),
  green: rgb("#a6e3a1"),
  sky: rgb("#89dceb"),
  mauve: rgb("#cba6f7"),
  subtext0: rgb("#a6adc8"),
)

#let scheduler(inp) = [
  #assert(type(inp) == dictionary, message: "Input must be YAML!")
  #let parameters = inp.parameters
  #let subjects = inp.subjects
  #let breaks = inp.at("breaks", default: none)
  #let breakcells = ()
  #let subjectcells = ()
  #let coordslist = ()
  #let times = ()
  #let formattedtimes = ()
  #let periods = ()
  #let periodcells = ()
  #let daycells = ()
  #{
    parameters.title = parameters.at("title", default: "Schedule")
    parameters.period-length = parameters.at("period-length", default: 80)
    parameters.day-start = parameters.at("day-start", default: 450)
    parameters.height = parameters.at("height", default: 8)
    parameters.days = parameters.at("days", default: 6)
    parameters.offset = parameters.at("offset", default: 0)
    parameters.font-size = parameters.at("font-size", default: 18)
    parameters.page-width = parameters.at("page-width", default: 14)
    parameters.page-height = parameters.at("page-height", default: 28)
    parameters.font = parameters.at("font", default: "Iosevka")
    parameters.export = parameters.at("export", default: true)
    parameters.military-time = parameters.at("military-time", default: false)
    parameters.exclude = parameters.at("exclude", default: 0)
    parameters.darkmode = parameters.at("darkmode", default: false)
    parameters.mini = parameters.at("mini", default: false)
    parameters.icon-scale = parameters.at("icon-scale", default: 1)
  }

  #set text(size: 1pt * parameters.at("font-size", default: 20))
  #show grid.cell: gc => if (parameters.exclude != 0 and gc.y > parameters.exclude) { none } else { gc }
  #let daycolours = (
    catppuccin.subtext0,
    catppuccin.blue,
    catppuccin.red,
    catppuccin.green,
    catppuccin.yellow,
    catppuccin.sky,
    catppuccin.mauve,
    catppuccin.subtext0,
  )

  #let days = if(parameters.mini){
    (
    "Mon.",
    "Tue.",
    "Wed.",
    "Thu.",
    "Fri.",
    "Sat.",
    "Sun.",
  )
  } else {(
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
  )}

  #let general-gradient(colour, textcol: none, factor: 20%, angle: 45deg) = gradient.linear(
    angle: angle,
    colour.lighten(factor*2).saturate(factor / 2),
    colour,
    colour.darken(factor*2/3).saturate(factor),
  )

  #let rawdt(raw) = {
    let selperiodhour = calc.rem(calc.floor(raw / 60), 24)
    let selperiodminute = calc.rem(raw, 60)
    return datetime(hour: selperiodhour, minute: selperiodminute, second: 0)
  }

  #for i in range(
    1 + parameters.offset,
    parameters.height + parameters.offset + 2,
  ) {
    times.push(rawdt(parameters.day-start + (i - 1) * parameters.period-length))
  }

  #for i in times {
    if (not parameters.military-time) {
      formattedtimes.push(
        i.display("[hour repr:12 padding:none]:[minute padding:zero]") + if (i.hour() < 12) { "am" } else { "pm" },
      )
    } else {
      formattedtimes.push(i.display("[hour repr:24 padding:zero]:[minute padding:zero]"))
    }
  }

  #let subjectcell(
    x,
    y,
    lab: false,
    span: 1,
    scale: 1,
    name: "Subject McSubjectFace",
    colour: "#4040dd",
    room: "Rubber Room",
    textcol: "#ffffff",
    code: "CCXX",
    csc: "NNXX",
    inst: "",
    icon: "",
    section: "",
    time: "All Focking day",
  ) = {
    let textfill = if (textcol == none) {
      if (luma(rgb(colour)).components().at(0) > 63%) {
        color.mix((black, 95%), (rgb(colour), 5%)).lighten(40%).saturate(200%)
      } else {
        color.mix((white, 95%), (rgb(colour), 5%)).lighten(80%).saturate(10%)
      }
    } else { rgb(textcol) }
    let cellfill = general-gradient(rgb(colour), textcol: rgb(textcol), angle: 45deg)


    return grid.cell(x: x, y: y, rowspan: span, inset: 0em, fill: cellfill, [
      #set text(
        size: 1.25em,
        fill: textfill,
      )

      

      #if (lab) {
        place(top + left, dx: 1pt / 2, dy: 1pt / 2, rect(width: 100% - 1pt, height: 100% - 1pt, fill: modpattern(
          (parameters.page-width * parameters.icon-scale * 2in / 40, parameters.page-width * parameters.icon-scale *2in / 40),
          [
            #line(
              start: (100%, 0%),
              end: (0%, 100%),
              stroke: parameters.page-width *parameters.icon-scale *2in / (80 * calc.sqrt(2))
                + textfill.mix(rgb(colour)).saturate(50%).transparentize(100% - parameters.at("pattern-opacity", default: 12.5%) * 1% * 1.5),
            )
          ],
        )))
      } else {
        place(top + left, rect(width: 100%, height: 100%, fill: modpattern(
          (parameters.page-width * 1in / 40, parameters.page-width * 1in / 40),
          [
            #let linefill = textfill.mix(rgb(colour)).saturate(50%).transparentize(100% - parameters.at("pattern-opacity", default: 12.5%) * 1% * 0.25)
      #place(line(stroke: 2pt + linefill, start:(0%,0%), end: (100%,0%)))
      #place(line(stroke: 2pt + linefill, start:(0%,0%), end: (0%,100%)))
          ],
        )))
        place(top + left, dx: 1pt / 2, dy: 1pt / 2, rect(width: 100%, height: 100%, fill: modpattern((1in * parameters.icon-scale, 1in * parameters.icon-scale), [
          #set text(fill: textfill.mix(rgb(colour)).saturate(50%).transparentize(100% - parameters.at("pattern-opacity", default: 12.5%) *1%* 1.5), size: 2in  * parameters.icon-scale / 3)
          #place(top + left, dx: 50%)[#iconloader(icon)]
          #place(bottom + left, dx: 0%)[#iconloader(icon)]
        ])))
      }

      #set par(leading: 0.5em)
      #if(not parameters.mini){[#if (lab) {
        place(top + right, dx: -1pt / 2, dy: 1pt / 2)[
          #rect(inset: 0.2em, fill: textfill, stroke: (bottom: 0.5em + textfill.transparentize(33%), left: 0.5em + textfill.transparentize(50%)))[
            #set text(fill: cellfill, weight: 900, size: 1em)
            Lab
          ]
        ]
      }
      #block(
        inset: (
          x: 1em / 4,
          top: 1em / 4,
          bottom: 1em / 2,
        ),
        stroke: none,
        width: 100%,
        height: 100%,
      )[
        #place(top + left)[
          #set par(leading: 0.25em)

          #text(weight: 900, 5em * 0.6 / 3)[#iconloader("meeting_room", offset: 1pt, scale: 1.25)#h(1em / 4)#room\ ]
        #set text(
            if(parameters.page-height / parameters.page-width >= 1.5){0.6129em}else{0.6em}
          , weight: 700)
          #if (not parameters.export) {
            [#iconloader("code", offset: 1pt, scale: 1.25)#h(1em / 4)*#csc/#code*
              #if (parameters.page-height / parameters.page-width > 1.5) { linebreak() }
            ]
          }
          #iconloader("co_present", offset: 1pt, scale: 1.25)#h(1em / 4)_*#inst*_\
          #iconloader("schedule", offset: 1pt, scale: 1.25)#h(1em / 4)*#time*
        ]

        #place(bottom + left)[
          #text(weight: 900, size: 1em * scale)[#set par(leading: 1em / 3);

            #text(fill: textfill.mix(rgb(colour)).mix(textfill).saturate(10%),
            if(parameters.export) {
              [#code#if(section == ""){}else{"-"+section}]
            } else {
              [#sym.section#section]
            }) #name]
        ]
      ]]} else {[
        
        

        #block(
        inset: (
          x: 1em / 4,
          top: 1em / 4,
          bottom: 1em / 4,
        ),
        stroke: none,
        width: 100%,
        height: 100%,
      )[
        #place(horizon)[
          #set par(leading: 0.25em)
          #set text(1.125em, weight: 900)
          *#csc/#code*#if(lab){set text(3em/4);[ Lab.]}
          #text(weight: 700, 1em)[\@#room]
        ]
      ]

      ]}
    ])
  }

  #let breakcell(
    x,
    y,
    span: 1,
    colspan: 1,
    title: "Break",
  ) = grid.cell(
    x: x,
    y: y,
    colspan: colspan,
    rowspan: span,
    inset: 1em / 2,
    align: horizon + center,
  )[
    #set text(fill: if(parameters.darkmode) {
      catppuccin.text
    } else {
      catppuccin.surface1.transparentize(50%)
    }, size: if(parameters.mini){
      1.5em
    }else{2em})
    #emph(title)#linebreak()
    #text(0.6em)[
      #formattedtimes.at(y - 2) - #formattedtimes.at(y + span - 2)
    ]
  ]

  #let daycell(
    x,
    name: "Day",
  ) = grid.cell(
    inset: 1em,
    y: 1,
    x: x + 1,
    fill: gradient.linear(angle: 45deg, catppuccin.surface0, catppuccin.base, catppuccin.mantle),
    align: horizon + center,
  )[
    #set text(
      fill: { daycolours.at(x + 1) },
      size: 1.5em,
      weight: 900,
    )
    #name
  ]

  #let timecell(
    pn,
    start: "",
    end: "",
  ) = grid.cell(
    inset: 1em / 2,
    fill: gradient.linear(angle: 45deg, catppuccin.surface0, catppuccin.base, catppuccin.mantle),
    x: 0,
    y: pn - parameters.offset + 1,
    align: horizon + center,
  )[
    #set text(fill: catppuccin.text, weight: 900)
    #show "am": upper
    #show "pm": upper
    #show "am": text.with(2em/3, fill: catppuccin.yellow)
    #show "pm": text.with(2em/3, fill: catppuccin.sky)
    #if(parameters.mini){[
      #set par(leading: 0.3em)
      #set text(1.35em)
      #text(catppuccin.text.transparentize(30%))[\##pn] \
      #start \
    #end \
    ]}else{[
      Period \
    #text(
      size: 1em
        * calc.max(
          parameters.page-height * 2 / parameters.page-width,
          3,
        ),
      weight: 900,
      [#pn],
    ) \
    #set text(
      size: if(parameters.page-height / parameters.page-width >= 1.25){1.5em}else{1em}
    )
    #start \
    #end \
    ]}
  ]

  

  

  #for i in range(1, parameters.height + 1) {
    if (parameters.exclude == 0 or (i < parameters.exclude)) {
      periodcells.push(timecell(i + parameters.offset, start: formattedtimes.at(i - 1), end: formattedtimes.at(i)))

      periods.push(
        formattedtimes.at(i - 1) + " - " + formattedtimes.at(i),
      )
    }
  }

  #for i in range(0, parameters.days) {
    daycells.push(daycell(i, name: days.at(i)))
  }

  #let coordsdecoder(sstr, offset: 0) = {
    let y = if (sstr.starts-with(regex("\d+"))) {
      int(sstr.slice(0, sstr.position(regex("\D+")))) - offset
    } else { none }
    let x = ()
    let sstrdays = sstr.slice(sstr.position(regex("\D+")))
    if (sstrdays.contains("m")) { x.push(1) }
    if (sstrdays.contains("t")) { x.push(2) }
    if (sstrdays.contains("w")) { x.push(3) }
    if (sstrdays.contains("h")) { x.push(4) }
    if (sstrdays.contains("f")) { x.push(5) }
    if (sstrdays.contains("r")) { x.push(6) }
    if (sstrdays.contains("s")) { x.push(7) }
    return (x, y)
  }

  #for i in subjects {
    let subparams = i.at(1)
    if (type(subparams.schedule) == str and subparams.schedule.starts-with(regex("\d"))) {
      let decodedsched = coordsdecoder(subparams.schedule, offset: parameters.offset)
      for j in decodedsched.at(0) {
        if (((j, decodedsched.at(1)) not in coordslist) and (parameters.exclude == 0 or (decodedsched.at(1) < parameters.exclude))) {
          coordslist.push((j, decodedsched.at(1)))
          subjectcells.push(subjectcell(
            j,
            decodedsched.at(1) + 1,
            colour: subparams.at("colour", default: "3040dd"),
            textcol: subparams.at("textcolour", default: "eeeeee"),
            inst: subparams.at("teacher", default: "---"),
            room: subparams.at("room", default: "---"),
            name: subparams.at("name", default: "---"),
            icon: subparams.at("icon", default: "deployed_code"),
            scale: subparams.at("scale", default: 1),
            csc: subparams.at("csc", default: "---"),
            code: subparams.at("code", default: "---"),
            section: subparams.at("section", default: ""),
            time: periods.at(decodedsched.at(1) - 1, default: "---"),
            span: subparams.at("span", default: 1),
          ))
        }
      }
    }
    if (subparams.at("lab-schedule", default: none) != none) {
      if (subparams.lab-schedule.starts-with(regex("\d"))) {
        let decodedsched = coordsdecoder(subparams.lab-schedule, offset: parameters.offset)
        for j in decodedsched.at(0) {
          if (((j, decodedsched.at(1)) not in coordslist) and (parameters.exclude == 0 or (decodedsched.at(1) < parameters.exclude))) {
            coordslist.push((j, decodedsched.at(1)))
            subjectcells.push(subjectcell(
              j,
              decodedsched.at(1) + 1,
              lab: true,
              colour: subparams.at("colour", default: "1820cc"),
              textcol: subparams.at("textcolour", default: "eeeeee"),
              inst: subparams.at("lab-teacher", default: "---"),
              room: subparams.at("lab-room", default: "---"),
              name: subparams.at("name", default: "---"),
              icon: subparams.at("icon", default: "deployed_code"),
              scale: subparams.at("scale", default: 1),
              csc: subparams.at("csc", default: "---"),
              code: subparams.at("code", default: "---"),
              section: subparams.at("section", default: ""),
              time: periods.at(decodedsched.at(1) - 1, default: "---"),
              span: subparams.at("span", default: 1),
            ))
          }
        }
      }
    }
  }

  #if (breaks != none) {
    for i in breaks {
      let subparams = i.at(1)
      let decodedsched = coordsdecoder(subparams.schedule, offset: parameters.offset)
      for j in decodedsched.at(0) {
        if (((j, decodedsched.at(1)) not in coordslist) and (parameters.exclude == 0 or (decodedsched.at(1) < parameters.exclude))) {
          coordslist.push((j, decodedsched.at(1)))
          breakcells.push(breakcell(
            j,
            decodedsched.at(1) + 1,
            title: subparams.at("name", default: "Break"),
            span: subparams.at("span", default: 1),
            colspan: subparams.at("colspan", default: 1)
            ))
        }
      }
    }
  }

  #page(
    width: parameters.page-width * 1in,
    height: parameters.page-height * 1in,
    margin: 0pt,
    fill: tiling(size: (parameters.page-width * 1in / 40, parameters.page-width * 1in / 40))[
      #place(top+left, rect(width:100%,height:100%, fill:
      if(parameters.darkmode){catppuccin.crust}else{white.mix(catppuccin.text)}))
      #place(line(stroke: 4pt + catppuccin.surface2.transparentize(50%), start:(0%,0%), end: (100%,0%)))
      #place(line(stroke: 4pt + catppuccin.surface2.transparentize(50%), start:(0%,0%), end: (0%,100%)))
    ], 
  )[
    #set text(font: if (parameters.font != none) { (parameters.font, "Iosevka SS04", "Romeosevka", "Iosevka") } else { font })

    #grid(
      stroke: (_, y) => if (parameters.exclude == 0 or y - 1 < parameters.exclude) {
        (x: stroke(
          dash: "dotted",
          paint: catppuccin.base,
          thickness: 1pt,
        ), y: stroke(
          dash: "dashed",
          paint: catppuccin.base,
          thickness: 1pt,
        ))
      } else { none },
      columns: (auto, ..(parameters.days * (1fr,))),
      rows: (auto, auto, ..(parameters.height * (1fr,))),
      fill: if(not parameters.darkmode) {
        gradient.linear(angle: 45deg, white.transparentize(20%), catppuccin.text.mix(white).transparentize(10%))
      } else {
        gradient.linear(angle: 45deg, catppuccin.surface1.transparentize(20%), catppuccin.surface0.transparentize(10%), )
      },
      grid.cell(fill: gradient.linear(angle: 45deg, catppuccin.surface0, catppuccin.base, catppuccin.mantle))[],
      grid.cell(
        inset: if(parameters.mini){0pt}else{1em},
        fill: gradient.linear(angle: 90deg, catppuccin.surface0, catppuccin.base, catppuccin.mantle),
        colspan: parameters.days,
        align: center + horizon,
      )[
        #set text(
          fill: rgb("#cdd6f4"),
          weight: 900,
          size: 3em,
        )
        #if(parameters.mini){}else{parameters.title}
      ],
      grid.cell(fill: gradient.linear(angle: 45deg, catppuccin.surface0, catppuccin.base, catppuccin.mantle))[],
      ..daycells,
      ..periodcells,
      ..subjectcells,
      ..breakcells,
    )
  ]
]
