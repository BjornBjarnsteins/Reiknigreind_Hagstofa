# ################################################################################# #
# REI101M                     Hópverkefni 1               Háskóli Íslands, okt 2015 #       
#                                                                                   #
# Andrea Björk Björnsdóttir                                                         #
# Björn Bjarnsteinsson                                                              #
# Leó Jóhannsson                                                                    #
# ################################################################################# #


# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(googleCharts)
# Use global max/min for axes so the view window stays
# constant as the user moves between years

shinyUI(fluidPage(
  theme = "bootstrap.css",
  fluidRow(
    # This line loads the Google Charts JS library
    googleChartsInit(),
    
    # Use the Google webfont "Source Sans Pro"
    tags$link(
      href=paste0("http://fonts.googleapis.com/css?",
                  "family=Source+Sans+Pro:300,600,300italic"),
      rel="stylesheet", type="text/css"),
    tags$style(type="text/css",
               "body {font-family: 'Source Sans Pro'}"
    ),
    
    
    h2("Gender Disparity in Iceland", style="margin-left: 15px"),
    
    # Controls and about data text
    sidebarPanel(
      style = "height: 600px",
      h3("Controls"),
      selectInput("data_menu", "Data", data_menu),
      conditionalPanel(
        condition = "input.data_menu !== 'population' && input.data_menu !== 'schoolgrad'",
        checkboxGroupInput("dist", "Distribution type:",
                         c("Grouped data" = "grouped",
                           "Total values" = "total"),
                         selected = c("grouped", "total")),
        sliderInput("year", "Year",
                    min = min(datalist[[1]]$Year), max = max(datalist[[1]]$Year),
                    value = min(datalist[[1]]$Year), animate = TRUE, step=1)
        
      ),
      conditionalPanel(
        condition = "input.data_menu === 'population'",
        sliderInput("year2", "Year",
                    min = min(datalist[[1]]$Year), max = max(datalist[[1]]$Year),
                    value = min(datalist[[1]]$Year), animate = animationOptions(interval=50, loop=F), step=1)
        
      ),
      conditionalPanel(
        condition = "input.data_menu === 'schoolgrad'",
        sliderInput("year3", "Year",
                    min = min(datalist[[1]]$Year), max = max(datalist[[1]]$Year),
                    value = min(datalist[[1]]$Year), animate = TRUE, step=1)
        
      ),
      includeHTML("about.html")
      
    
    ),
    
    # Panel for our graphs.
    mainPanel(
      # Population graph
      conditionalPanel(
        condition = "input.data_menu == 'population'", 
        
        googleBarChart(
          "barChart",
          width="100%", height = "600px",
          options = list(
            # The default padding is a little too spaced out
            chartArea = list(
              top = 50, left = 75, right = 175,
              height = "75%", width = "75%"
            ),
            # Set axis labels and ranges
            hAxis = list(
              title = "Population",
              minValue = "-3000",
              maxValue = "3000"
            ),
            vAxis = list(
              title = "Age",
              minValue = 0,
              maxValue = 110
            )
          )
        )
      ),
      
      # Other graphs
      conditionalPanel(
        condition = "input.data_menu != 'population'",
        googleBubbleChart(
          "bubbleChart",
          width="100%", height = "600px",
          # Set the default options for this chart; they can be
          # overridden in server.R on a per-update basis. See
          # https://developers.google.com/chart/interactive/docs/gallery/bubblechart
          # for option documentation.
          options = list(
            fontName = "Source Sans Pro",
            fontSize = 13,
            # Set axis labels and ranges
            hAxis = list(
              title = "Males",
              minValue = xlim[1],
              maxValue = xlim[2]
            ),
            vAxis = list(
              title = "Females",
              minValue = ylim[1],
              maxValue = ylim[2]
            ),
            # The default padding is a little too spaced out
            chartArea = list(
              top = 50, left = 75, right = 175,
              height = "75%", width = "75%"
            ),
            # Allow pan/zoom
            explorer = list(),
            # Set bubble visual props
            bubble = list(
              opacity = 0.4, stroke = "none",
              # Hide bubble label
              textStyle = list(
                color = "none"
              )
            ),
            # Set fonts
            titleTextStyle = list(
              fontSize = 16
            ),
            tooltip = list(
              textStyle = list(
                fontSize = 12
              )
            )
            
          )
        )
      )
    )
  ),
  fluidRow(
    # SUMMARY TEXT
      wellPanel(
        style = "margin-left: 15px; margin-right: 15px; margin-top: 5px;",
        h3(style = "font-weight: bold", "Summary"),
        p("The topic in question is gender disparity in various areas of Icelandic society. We wish to answer whether there is a tendency to favour one gender over the other. To answer this question, the more data the better! The more gender separated data we can look at the more accurately we can depict the disparity between males and females. For the purposes of this observation we picked a handful of data tables from Statistics Iceland which were categorized by gender and year and plotted the comparison between females and males."),
        p("The main questions we tried to answer with these graphs were:"),
        tags$ol(
          tags$li("Is there a clear difference in income by gender?"),
          tags$li("If there is an income gap, can it be explained by a similar gap in education?"),
          tags$li("Is there a difference in the amount of prison sentences between the genders and if so, how does it compare to the gap in education?")
        ),
        
        br(),
        br(),
        p("Following are some of the conclusions we were able to draw from the data depicted in our graphs:"),
        
        h4(style = "font-weight: bold", "Income by Economic activity:"),
        p(style = "margin-left: 1em","Our first graph shows average yearly income of females vs males, grouped by residency and categorized by economic activity (e.g. construction, education etc). The graph shows that women have lower income in almost all fields. The biggest difference appears to be in fishing and agriculture while the least difference is in education and hotels and restaurants." ),
        
        h4(style = "font-weight: bold", "Income by Age:"),
        p(style = "margin-left: 1em","This graph shows average yearly income of females vs males, grouped by age and categorized by residency (e.g. Capital area, Southwest etc.). The graph follows the same trend as the Income by Economic Activity graph, furthermore it shows that women have lower income independent of their age. The graph also shows that both genders have highest income around the age 45-55."),
        
        h4(style = "font-weight: bold", "Registered Students in Undergraduate Programs:"),
        p(style = "margin-left: 1em","This graph shows the number of registered female students vs male, grouped by school. We see that there are significantly more women registered in undergraduate programs."),
        
        h4(style = "font-weight: bold", "Graduated Students by School Levels:"),
        p(style = "margin-left: 1em","While the previous graph showed registered students by schools, this graph shows the number of graduated female students vs male, grouped by school level. Looking at the data from 2011, we see the same trend in University graduates as with undergraduate programs in the graph before: There are almost twice as many women as men who graduated from a tertiary level education."),
        
        h4(style = "font-weight: bold", "Prison Sentences:"),
        p(style = "margin-left: 1em","This graph shows the yearly number of prison sentences of females vs males, grouped by type of offense. (e.g. Drug crimes, Sexual crimes etc). The data shows a very clear distinction between men and women, 23 women were incarcerated in 2013 compared to 350 men. The greatest difference is in sexual crimes where 52 males got prison sentences in 2013 but no women."),
        
        h4(style = "font-weight: bold", "Population by Age:"),
        p(style = "margin-left: 1em","Our final graph shows the number of males by age in blue (on the left side) and the number of females by age in red (on the right side).")
      )
  )
)
)
