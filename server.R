library(dplyr)

shinyServer(function(input, output, session) {
  # Provide explicit colors for regions, so they don't get recoded when the
  # different series happen to be ordered differently from year to year.
  # http://andrewgelman.com/2014/09/11/mysterious-shiny-things/
  defaultColors <-c("#3366cc", "#dc3912", "#ff9900", "#109618", "#990099", "#0099c6", "#dd4477", "#74104d", "#ce3303", "#4f40b5", "#fa648d", "#4792de")
  
  series <- structure(
    lapply(defaultColors, function(color) { list(color=color) }),
    names = levels(datalist[[1]]$Region)
  )
  
  
  yearData <- reactive({
    differentTable <- tablename != input$data_menu
    tablename <<- input$data_menu
    currentData <- datalist[[selectIndex[tablename]]]
    if(differentTable){
      updateSliderInput(session, "year", min = min(currentData$Year), max = max(currentData$Year), value=min(currentData$Year))
    }
    
    
    # Filter to the desired year, and put the columns
    # in the order that Google's Bubble Chart expects
    # them (name, x, y, color, size). Also sort by region
    # so that Google Charts orders and colors the regions
    # consistently.
    if(input$data_menu == "income_res") {
      df <- datalist[[1]] %>%
        filter(Year == input$year) %>%
        select(Economic.Activity, Male, Female, Region, Total)  %>%
        arrange(Region)
    } else if(input$data_menu == "income_rsa"){
      df <- datalist[[2]] %>%
        filter(Year == input$year) %>%
        select(Region, Male, Female, Age, Total)  %>%
        arrange(Age)
    } else if(input$data_menu == "schoolreg") {
      df <- datalist[[3]] %>%
        filter(Year == input$year) %>%
        select(School, Male, Female, Group, Total)  %>%
        arrange(School)
    } else if(input$data_menu == "schoolgrad") {
      df <- datalist[[4]] %>%
        filter(Year == input$year) %>%
        select(Level, Male, Female, Group, Total)  %>%
        arrange(Level)
    } else if(input$data_menu == "prisonSentences") {
      df <- datalist[[5]] %>%
        filter(Year == input$year) %>%
        select(Reason, Males, Females, Group, Total)  %>%
        arrange(Reason)
    } else if(input$data_menu == "population") {
      df <- subset(datalist[[6]], Age != -1) %>%
        filter(Year == input$year) %>%
        select(Age, Males, Females)  %>%
        arrange(Age)
#       df$Males <- -df$Males
    }
    
  })
  
  output$bubbleChart <- reactive({
    # Return the data and options
    list(
      data = googleDataTable(yearData()),
      options = list(
        title = sprintf(
          names(data_menu)[selectIndex[input$data_menu]],
          input$year),
        series = series
      )
    )
  })
  output$barChart <- reactive({
    # Return the data and options
    list(
      data = googleDataTable(yearData()),
      options = list(
        title = sprintf(
          names(data_menu)[selectIndex[input$data_menu]],
          input$year),
        series = series
      )
    )
  })
})