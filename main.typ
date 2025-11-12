// template by: https://github.com/caffeinatedgaze
#let configuration = yaml("config.yaml")
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

#let sidebarSection = {[
  #par(justify: true)[

    #par[
      #set text(
        size: eval(settings.font.size.contacts),
        font: settings.font.minor_highlight,
      )
      
      Email: #link("mailto:" + configuration.contacts.email) \
      Phone: #link("tel:" + configuration.contacts.phone) \
      // LinkedIn: #link(configuration.contacts.linkedin)[Zoë Courvoisier-Clément] \
      GitHub: #link("https://github.com/" + configuration.contacts.github)[#configuration.contacts.github]
      
      #configuration.contacts.address
      #text(fill: luma(45%))[(#configuration.contacts.mobility)]
    ]
    #line(length: 100%)
  ]

  #par[
    #set text(
        eval(settings.font.size.education_description),
        font: settings.font.minor_highlight,
    )
    #configuration.bio
  ]

  = Education

  #{
    for place in configuration.education [
        #par[
          #set text(
            size: eval(settings.font.size.heading),
            font: settings.font.general
          )
            #place.from – #place.to \
            #link(place.university.link)[#place.university.name]

          #set text(
            eval(settings.font.size.education_description),
            font: settings.font.minor_highlight,
          )

          *#place.degree* \
          #place.description
        ]
    ]
  }

  = Skills

  #{
    for skill in configuration.skills [
      #par[
        #set text(
          size: eval(settings.font.size.description),
        )
        #set text(
          // size: eval(settings.font.size.tags),
          font: settings.font.minor_highlight,
        )
        *#skill.name* 
        #linebreak()
        #skill.items.join(" • ")
      ]
    ]
  }
]}

#let mainSection = {[

  // #par[
  //   #set align(center)
  //   #figure(
  //     image("images/Kodak 20 Zanvoort Lumi.jpg", width: 6em),
  //     placement: top,
  //   )
  // ]

  #par[
    #set text(
      size: eval(settings.font.size.heading_huge),
      font: settings.font.general,
    )
    *#configuration.contacts.name*
  ]

  #par[
    #set text(
      size: eval(settings.font.size.heading),
      font: settings.font.minor_highlight,
      top-edge: 0pt
    )  
    #configuration.contacts.title
  ]

  #v(.8em)
  
  = Professional experience

  #v(.8em)
  #{
    set par(spacing: .5em)
    for job in configuration.jobs [
      #par(justify: false)[
        #set text(
          size: eval(settings.font.size.heading),
          font: settings.font.general
        )
        #if(job.at("from", default: none) != none) {
          emph[#job.from – #job.to]
        } else {
          emph[#job.date]
        }
        
        *#job.position*
        #link(job.company.link)[\@  #job.company.name]    
      ]
      #par(
        justify: false,
        leading: eval(settings.paragraph.leading)
      )[
        #set text(
          size: eval(settings.font.size.description),
          font: settings.font.general
        )
        #{
          for point in job.description [
            #h(.8em) • #point \
          ]
        }
      ]
      #v(1em)
    ]
  }

  #v(.8em)

  = Personal projects & involvements

  #v(.8em)
  #{
    for proj in configuration.projects [

      - #par(
        justify: true,
        leading: eval(settings.paragraph.leading),
      )[
        #set par(spacing: 0.8em)

        #par[
          #set text(
            size: eval(settings.font.size.heading),
            font: settings.font.general
          )

          #let name = if (proj.project.at("link", default: none) != none) {[
            #link(proj.project.link)[#proj.project.name]
          ]} else {[
            #proj.project.name
          ]};

          #let tags = text(
            size: eval(settings.font.size.tags),
            font: settings.font.general,
            fill: luma(45%)
          )[#proj.project.tags.join(" • ")]

          #grid(
            columns: (1fr, auto),
            // gutter: .5em,
            name, align(right, tags)
          )
        ]
        #par[
          #set text(
            size: eval(settings.font.size.description),
            font: settings.font.general
          )
          #proj.description
        ]
      ]
      #v(1em)
    ]
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