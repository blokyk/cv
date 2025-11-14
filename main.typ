// template by: https://github.com/caffeinatedgaze
#let conf = yaml("config.yaml")
#let settings = yaml("settings.yaml")

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
    #set text(
      eval(settings.font.size.education_description),
      font: settings.font.minor_highlight,
    )

    #conf.bio
  ]

  = Education

  #{
    for place in conf.education [
      #set text(
        size: eval(settings.font.size.heading),
        font: settings.font.general
      )

      #place.from #sym.dash.en #place.to \
      #link(place.university.link)[#place.university.name]

      #set text(
        eval(settings.font.size.education_description),
        font: settings.font.minor_highlight,
      )

      *#place.degree* \
      #place.description
    ]
  }

  = Skills

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

  #v(.8em)

  = Professional experience

  #v(.8em)

  #{
    set par(spacing: .6em)

    for job in conf.jobs [
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
        spacing: eval(settings.paragraph.leading),
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

  = Personal projects & involvements

  #v(.8em)

  #{
    set par(justify: true)
    set text(
      size: eval(settings.font.size.heading),
      font: settings.font.general
    )

    let items = conf.projects.map(
      proj => [
        #let hasLink = proj.project.keys().contains("link");
        #let name = if (hasLink) {[
          #link(proj.project.link)[#proj.project.name]
        ]} else {[
          #proj.project.name
        ]};

        #let tags = text(
          size: eval(settings.font.size.tags),
          font: settings.font.general,
          fill: luma(45%)
        )[#proj.project.tags.join(" • ")]

        #set par(spacing: .6em, leading: .5em)

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

        #v(1em)
      ]
    );

    list(
      spacing: eval(settings.paragraph.leading), ..items
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