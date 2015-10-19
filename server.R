# ################################################################################# #
# REI101M                     Hópverkefni 1               Háskóli Íslands, okt 2015 #       
#                                                                                   #
# Andrea Björk Björnsdóttir                                                         #
# Björn Bjarnsteinsson                                                              #
# Leó Jóhannsson                                                                    #
# ################################################################################# #

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
  
  # yearData is the input function for google charts package, it returns df, the main data frame for all our data by year.
  # The data depends on our data_menu input where the data is specified.
  yearData <- reactive({
    differentTable <- tablename != input$data_menu
    # Global var for easily acquiring index of the table: 
    tablename <<- input$data_menu
    currentData <- datalist[[selectIndex[tablename]]]
    
    if(differentTable){
      lim <<- list(
        min = 0,
        max = max(max(currentData$Male[!is.na(currentData$Male)]), max(currentData$Female[!is.na(currentData$Female)]))+200
      )
      
      # Update the slider for our various graphs, since the data is not all from the same years.
      updateSliderInput(session, "year", min = min(currentData$Year), max = max(currentData$Year), value=min(currentData$Year))
      updateSliderInput(session, "year2", min = min(currentData$Year), max = max(currentData$Year), value=min(currentData$Year))
      updateSliderInput(session, "year3", min = min(currentData$Year), max = max(currentData$Year), value=min(currentData$Year))
    }
    
    
    # Filter to the desired year, and put the columns
    # in the order that Google's Bubble Chart expects
    # them (name, x, y, color, size). Also sort by region
    # so that Google Charts orders and colors the regions
    # consistently.
    
    # Income by Economic Activity
    if(input$data_menu == "income_res") {
      if('total' %in% input$dist && 'grouped' %in% input$dist) {
        data <- datalist[[1]]
      } else if('total' %in% input$dist) {
        data <- subset(datalist[[1]], Region == 'Total')
      } else if('grouped' %in% input$dist) {
        data <- subset(datalist[[1]], Region != 'Total')
      } else {
        data <- subset(datalist[[1]], Region == '')
      }
      
      lim <<- list(
        min = 0,
        max = max(max(data$Male[!is.na(data$Male)]), max(data$Female[!is.na(data$Female)]))+200
      )
      
      df <- data %>%
        filter(Year == input$year) %>%
        select(Economic.Activity, Male, Female, Region, Total)  %>%
        arrange(Region)
      
      # Income by Age
    } else if(input$data_menu == "income_rsa"){
      if('total' %in% input$dist && 'grouped' %in% input$dist) {
        data <- datalist[[2]]
      } else if('total' %in% input$dist) {
        data <- subset(datalist[[2]], Region == 'Total')
      } else if('grouped' %in% input$dist) {
        data <- subset(datalist[[2]], Region != 'Total')
      } else {
        data <- subset(datalist[[2]], Region == '')
      }
      
      lim <<- list(
        min = 0,
        max = 6000 # the code always returned around 11000 here for seemingly no reason ?!?
        )
      
      df <- data %>%
        filter(Year == input$year) %>%
        select(Region, Male, Female, Age, Total)  %>%
        arrange(Age)
      
      # Registered students in undergraduate programs
    } else if(input$data_menu == "schoolreg") {
      if('total' %in% input$dist && 'grouped' %in% input$dist) {
        data <- datalist[[3]]
      } else if('total' %in% input$dist) {
        data <- subset(datalist[[3]], School == 'Total')
      } else if('grouped' %in% input$dist) {
        data <- subset(datalist[[3]], School != 'Total')
      } else {
        data <- subset(datalist[[3]], School == '')
      }
      
      lim <<- list(
        min = 0,
        max = max(max(data$Male[!is.na(data$Male)]), max(data$Female[!is.na(data$Female)]))+200
      )
      
      df <- data %>%
        filter(Year == input$year) %>%
        select(School, Male, Female, Group, Total)  %>%
        arrange(School)
      
      # Graduated students by school level
    } else if(input$data_menu == "schoolgrad") {
      data <- datalist[[4]]
      
      lim <<- list(
        min = 0,
        max = max(max(data$Male[!is.na(data$Male)]), max(data$Female[!is.na(data$Female)]))+200
      )
      
      df <- datalist[[4]] %>%
        filter(Year == input$year3) %>%
        select(Level, Male, Female, Group, Total)  %>%
        arrange(Level)
      
      # Prison sentences
    } else if(input$data_menu == "prisonSentences") {
      if('total' %in% input$dist && 'grouped' %in% input$dist) {
        data <- datalist[[5]]
      } else if('total' %in% input$dist) {
        data <- subset(datalist[[5]], Reason == 'Total')
      } else if('grouped' %in% input$dist) {
        data <- subset(datalist[[5]], Reason != 'Total')
      } else {
        data <- subset(datalist[[5]], Reason == '')
      }
      
      lim <<- list(
        min = 0,
        max = max(max(data$Male[!is.na(data$Male)]), max(data$Female[!is.na(data$Female)]))+10
      )
      
      df <- data %>%
        filter(Year == input$year) %>%
        select(Reason, Males, Females, Group, Total)  %>%
        arrange(Reason)
      
      # Population by age
    } else if(input$data_menu == "population") {
      data <- datalist[[6]]
      
      lim <<- list(
        min = 0,
        max = max(max(data$Male[!is.na(data$Male)]), max(data$Female[!is.na(data$Female)]))+200
      )
      
      df <- subset(datalist[[6]], Age != -1) %>%
        filter(Year == input$year2) %>%
        select(Age, Males, Females)  %>%
        arrange(Age)
    }
    
    #print("banana")
    #print(max(max(data$Male[!is.na(data$Male)]), max(data$Female[!is.na(data$Female)]))+200)
    
  })
  
  # Using google charts function as used in the bubble chart demo
  output$bubbleChart <- reactive({
    # Return the data and options
    list(
      data = googleDataTable(yearData()),
      options = list(
        title = sprintf(
          names(data_menu)[selectIndex[input$data_menu]],
          input$year),
        # Set axis labels and ranges
        hAxis = list(
          title = "Males",
          minValue = lim$min,
          maxValue = lim$max
        ),
        vAxis = list(
          title = "Females",
          minValue = lim$min,
          maxValue = lim$max
        ),
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