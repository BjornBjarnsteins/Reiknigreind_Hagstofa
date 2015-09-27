
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
  
  
  h2("Awesome demo"),
  
  sidebarPanel(
    selectInput("data_menu", "Data", data_menu),
    checkboxGroupInput("dist", "Distribution type:",
                       c("Grouped data" = "grouped",
                         "Total values" = "total"),
                       selected = c("grouped", "total")),
    sliderInput("year", "Year",
                min = min(datalist[[1]]$Year), max = max(datalist[[1]]$Year),
                value = min(datalist[[1]]$Year), animate = TRUE, step=1)
  ),
  
  mainPanel(
    
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
)
)
