# ################################################################################# #
# REI101M                     Hópverkefni 1               Háskóli Íslands, okt 2015 #       
#                                                                                   #
# Andrea Björk Björnsdóttir                                                         #
# Björn Bjarnsteinsson                                                              #
# Leó Jóhannsson                                                                    #
# ################################################################################# #

require(pxweb)
update_pxweb_apis()
# Use: d <- fetchData(tableIndex)
# Pre: tableIndex is the table ID, in {"income_res", "income_rsa", "schoolreg", "schoolgrad", "prisonSentences","population"}
# Post: d is our data fetched from hagstofa.is using their px.hagstofa.is API. The data frame structures have been 
# manipulated to include the rows and columns best suited to our needs.
fetchData <- function(tableIndex){
  # Large if loop for the various tableIndex cases:
  if(tableIndex == "income_res"){
    ## Average income by region, economic activity og sex 1998-2005 
    data <- data.frame(get_pxweb_data(url='http://px.hagstofa.is/pxen/api/v1/en/Samfelag/launogtekjur/3_tekjur/VIN07001.px',
                        dims=list('Region'='*', 'Economic activity'='*', 'Sex'='*', 'Year'='*'), clean=FALSE))
    
    ## The number of rows in the original dataframe
    n <- dim(data)[1]
    years <- c(1998:2005)
    
    ## The desired columns in the resulting dataframe
    Region <- c()
    Economic.Activity <- c()
    Year <- c()
    Total <- c()
    Male <- c()
    Female <-c()
    
    ## column manipulation to add a Year column
    for(i in c(1:8)) {
      Region <- c(Region, data[,1])
      Economic.Activity <- c(Economic.Activity, data[,2])
      Year <- c(Year, rep(years[i], n))
      Total <- c(Total, data[,2+i])
      Male <- c(Male, data[,10+i])
      Female <- c(Female, data[,18+i])
    }
    
    data <- data.frame(Region, Economic.Activity, Year, Total, Male, Female)
    colnames(data) <- c("Region", "Economic.Activity", "Year", "Total", "Male", "Female")
    return(data)
  }else if(tableIndex == "income_rsa"){
    ## Average income by region, sex and age 1998-2005 
    data <- data.frame(get_pxweb_data(url='http://px.hagstofa.is/pxen/api/v1/en/Samfelag/launogtekjur/3_tekjur/VIN07002.px',
                        dims=list('Region'='*', 'Age'='*', 'Sex'='*', 'Year'='*'), clean=FALSE))
    
    ## The number of rows in the original dataframe
    n <- dim(data)[1]
    years <- c(1998:2005)
    
    Region <- c()
    Age <- c()
    Year <- c()
    Total <- c()
    Male <- c()
    Female <-c()
    
    ## column manipulation to add a Year column
    for(i in c(1:8)) {
      Region <- c(Region, data[,1])
      Age <- c(Age, data[,2])
      Year <- c(Year, rep(years[i], n))
      Total <- c(Total, data[,2+i])
      Male <- c(Male, data[,10+i])
      Female <- c(Female, strtoi(data[,18+i]))
    }

    data <- data.frame(Region, Age, Year, Total, Male, Female)
    return(data)
    
  }else if(tableIndex == "schoolreg"){
    
    ## Registered students at upper secondary and tertiary level by sex and detailed fields 2007-2013
    data <- data.frame(get_pxweb_data(url='http://px.hagstofa.is/pxen/api/v1/en/Samfelag/skolamal/0_yfirlit/SKO00001.px',
                                      dims=list('ISCED Level'='Total', 'School'='*', 'Line of study'='Total', 'Year'='*', 'Sex'='*'), clean=FALSE))
    
    ## The number of rows in the original dataframe
    n <- dim(data)[1]
    years <- c(2007:2013)
    
    School <- c()
    Year <- c()
    Total <- c()
    Male <- c()
    Female <-c()
    
    ## column manipulation to add a Year column
    for(i in c(1:7)) {
      School <- c(School, data[,2])
      Year <- c(Year, rep(years[i], n))
      Total <- c(Total, data[,1+3*i])
      Male <- c(Male, data[,2+3*i])
      Female <- c(Female, data[,3+3*i])
    }
    
    Group <- c(School)
    
    data <- data.frame(School, Group, Year, Total, Male, Female)
    return(data)
    
  }else if(tableIndex == "schoolgrad"){
    ## Graduated students by level, age, sex and domicile 1995-2012
    data <- data.frame(get_pxweb_data(url='http://px.hagstofa.is/pxen/api/v1/en/Samfelag/skolamal/4_haskolastig/1_hsProf/SKO04201.px',
                                      dims=list('Level'='*', 'Region'='0', 'Age'='0', 'Year'='*', 'Sex'='*'), clean=FALSE))
    
    ## The number of rows in the original dataframe
    n <- dim(data)[1]
    years <- c(1995:2011)
    
    Level <- c()
    Year <- c()
    Total <- c()
    Male <- c()
    Female <-c()
    
    ## column manipulation to add a Year column
    for(i in c(1:17)) {
      Level <- c(Level, data[,1])
      Year <- c(Year, rep(years[i], n))
      Total <- c(Total, data[,1+3*i])
      Male <- c(Male, data[,2+3*i])
      Female <- c(Female, data[,3+3*i])
    }
    
    Group <- c(Level)
    
    data <- data.frame(Level, Group, Year, Total, Male, Female)
    return(data)
  }else if(tableIndex == "influence"){
    ## Ratios of women and men in positions of power
    data <- data.frame(get_pxweb_data(url='http://px.hagstofa.is/pxen/api/v1/en/Samfelag/felagsmal/jafnrettismal/3_kk75/HEI11507.px',
                                      dims=list('power and decision making'='*', 'year'='*', 'sex'='*'), clean=FALSE))
    
    ## The number of rows in the original dataframe
    n <- dim(data)[1]
    years <- seq(from=1975, to=2005, by=10)
    
    Year <- c()
    Male <- c()
    Female <-c()
    Position <- c()
    
    ## column manipulation to add a Year column
    for(i in c(1:floor(dim(data)[2]/2))) {
      Year <- c(Year, rep(years[i], n))
      Male <- c(Male, data[,1+2*i])
      Female <- c(Female, data[,2*i])
      Position <- c(Position, data[,1][i])
    }
    
    data <- data.frame(Year, Position, Male, Female)
    return(data)
  }else if(tableIndex == "prisonSentences"){
    ## Population by sex and age 1841-2015
    data <- data.frame(get_pxweb_data(url='http://px.hagstofa.is/pxen/api/v1/en/Samfelag/domsmal/afbrot/KOS02200.px',
                                      dims=list('Year'='*', 'Reason'='*', 'Sex'='*'), clean=TRUE))
    
    ##column manipulation
    data$Year = as.numeric(as.character(data$Year))
    data = data[data$Year>1994,]
    males = data[data$Sex=='Males', ]
    females = data[data$Sex=='Females', ]
    total = data[data$Sex=='Total', ]
    
    Group <- c(as.character(total$Reason))
    
    data1 = data.frame(total$Year, total$Reason, Group, total$values, males$values, females$values)
    colnames(data1) = c('Year', 'Reason', 'Group', 'Total', 'Males', 'Females')

    return(data1) 
  }else if(tableIndex == "population"){
    ## Population - key figures 1703-2015
    data <- data.frame(get_pxweb_data(url='http://px.hagstofa.is/pxen/api/v1/en/Ibuar/mannfjoldi/1_yfirlit/yfirlit/MAN00101.px',
                                      dims=list('Year'='*', 'Sex'='*', 'Age'='*'), clean=TRUE))

    
    ## Changing the ages to numerics
    data$Age = gsub("Total", "0000", data$Age)
    data$Age = gsub("Under 1 year", "0", data$Age)
    data$Age = gsub("[^0-9]", "", data$Age)
    data$Age = gsub("0000", "-1", data$Age)
    data$Age = as.numeric(data$Age)
    
    ## column manipulation
    data$Year = as.numeric(as.character(data$Year))
    males = data[data$Sex=='Males', ]
    females = data[data$Sex=='Females', ]
    total = data[data$Sex=='Total', ]
    
    data = data.frame(males$Year, as.numeric(males$Age), total$values, -males$values, females$values)
    colnames(data) = c('Year', 'Age', 'Total', 'Males', 'Females')
    return(data)
  }
}






















