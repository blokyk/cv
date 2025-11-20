// template by: https://github.com/caffeinatedgaze
#let settings = yaml("settings.yaml")

#let lang = settings.lang
#let lang = (
  config-filename: (
    fr: "config-fr.yaml",
    en: "config-en.yaml"
  ),
  titles: (
    edu: (fr: "Éducation", en: "Education"),
    skills: (fr: "Compétences", en: "Skills"),
    exp: (
      fr: "Expériences professionnelles",
      en: "Professional experience"
    ),
    proj: (
      fr: "Engagements & projets personnels",
      en: "Personal projects & involvements"
    )
  ),
)

#let intl = prop => prop.at(settings.lang)

#let conf = yaml(intl(lang.config-filename))

#set text(lang: settings.lang)

#set page(
  paper: "a4",
  margin: 5em
)

#show link: set text(blue)

#show heading: set text(
  size: eval(settings.font.size.heading_large),
  font: settings.font.general
)

#let sidebarSection = [
  #[
    #set text(
      size: eval(settings.font.size.contacts),
      font: settings.font.minor_highlight,
    )

    Email: #link("mailto:" + conf.contacts.email) \
    Phone: #link("tel:" + conf.contacts.phone) \
    // LinkedIn: #link(configuration.contacts.linkedin)[Zoë Courvoisier-Clément] \
    GitHub: #link("https://github.com/" + conf.contacts.github)[#conf.contacts.github]

    #conf.contacts.address
    #text(fill: luma(45%))[(#conf.contacts.mobility)]
  ]

  #line(length: 100%)

  #[
    #set par(justify: true)
    #set text(
      eval(settings.font.size.education_description),
      font: settings.font.minor_highlight,
    )

    #conf.bio
  ]

  = #intl(lang.titles.edu)

  #{
    for place in conf.education [
      #set par(spacing: .8em)
      #set text(
        size: eval(settings.font.size.heading),
        font: settings.font.general
      )

      #link(place.university.link)[#place.university.name]

      #set text(
        eval(settings.font.size.education_description),
        font: settings.font.minor_highlight,
      )

      *#place.degree*
      _ #place.from #sym.dash.en #place.to _ \
      #place.description

      #v(.5em)
    ]
  }

  = #intl(lang.titles.skills)

  #{
    for skill in conf.skills [
      #set text(
        // size: eval(settings.font.size.tags),
        size: eval(settings.font.size.description),
        font: settings.font.minor_highlight,
      )

      #strong(skill.name) \
      #skill.items.join(" • ")
    ]
  }
]

#let mainSection = {[
  #text(
    size: eval(settings.font.size.heading_huge),
    font: settings.font.general,
    strong(conf.contacts.name)
  )

  #text(
    size: eval(settings.font.size.heading),
    font: settings.font.minor_highlight,
    top-edge: 0pt,
    conf.contacts.title
  )


  = #intl(lang.titles.exp)

  #v(.5em)

  #{
    set par(spacing: .6em)

    for job in conf.jobs.rev() [
      #set par(leading: eval(settings.paragraph.leading) + .1em)
      #[
        #set text(
          size: eval(settings.font.size.heading),
          font: settings.font.general
        )

        #if(job.at("from", default: none) != none) {
          emph[#job.from #sym.dash.en #job.to]
        } else {
          emph[#job.date]
        }

        *#job.position*
        #link(job.company.link)[\@  #job.company.name]
      ]

      #parbreak()

      #list(
        indent: .8em,
        ..(job.description.map(
          p =>
            text(
              size: eval(settings.font.size.description),
              font: settings.font.general,
              p
            )
        ))
      )

      #linebreak()
    ]
  }

  #v(-1em)

  = #intl(lang.titles.proj)

  #v(.5em)

  #{
    set par(justify: true, leading: eval(settings.paragraph.leading), spacing: .5em)
    set text(
      size: eval(settings.font.size.heading),
      font: settings.font.general
    )

    let items = conf.projects.map(
      proj => [
        #let hasLink = proj.project.keys().contains("link");
        #let name = if (hasLink) {[
          #link(proj.project.link)[#proj.project.name #box(image("github-mark.svg"), height: .7em)]
        ]} else {[
          #proj.project.name
        ]};

        #let tags = text(
          size: eval(settings.font.size.tags),
          font: settings.font.general,
          fill: luma(45%)
        )[#proj.project.tags.join(" • ")]

        #set par(spacing: .6em)

        #grid(
          columns: (1fr, auto),
          // gutter: .5em,
          name, align(right, tags)
        )

        #text(
          size: eval(settings.font.size.description),
          font: settings.font.general,
          proj.description
        )
      ]
    );

    list(
      spacing: eval(settings.paragraph.leading) + 1em, ..items
    )
  }
]}

#{
  grid(
    columns: (2fr, 5fr),
    column-gutter: 3em,
    sidebarSection,
    mainSection,
  )
}