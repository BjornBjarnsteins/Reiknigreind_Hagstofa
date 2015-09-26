require(pxweb)
fetchData <- function(tableIndex){
  if(tableIndex == "income_res"){
    ## Average income by region, economic activity og sex 1998-2005 
    data <- data.frame(get_pxweb_data(url='http://px.hagstofa.is/pxen/api/v1/en/Samfelag/launogtekjur/3_tekjur/VIN07001.px',
                        dims=list('Region'='*', 'Economic activity'='*', 'Sex'='*', 'Year'='*'), clean=FALSE))
    
    n <- dim(data)[1]
    years <- c(1998:2005)
    
    Region <- c()
    Economic.Activity <- c()
    Year <- c()
    Total <- c()
    Male <- c()
    Female <-c()
    
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
    
    n <- dim(data)[1]
    years <- c(1998:2005)
    
    Region <- c()
    Age <- c()
    Year <- c()
    Total <- c()
    Male <- c()
    Female <-c()
    
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
    
    n <- dim(data)[1]
    years <- c(2007:2013)
    
    School <- c()
    Year <- c()
    Total <- c()
    Male <- c()
    Female <-c()
    
    for(i in c(1:7)) {
      School <- c(School, data[,2])
      Year <- c(Year, rep(years[i], n))
      Total <- c(Total, data[,1+3*i])
      Male <- c(Male, data[,2+3*i])
      Female <- c(Female, data[,3+3*i])
    }
    
    data <- data.frame(School, Year, Total, Male, Female)
    return(data)
    
  }else if(tableIndex == "schoolgrad"){
    ## Graduated students by level, age, sex and domicile 1995-2012
    data <- data.frame(get_pxweb_data(url='http://px.hagstofa.is/pxen/api/v1/en/Samfelag/skolamal/4_haskolastig/1_hsProf/SKO04201.px',
                                      dims=list('Level'='*', 'Region'='0', 'Age'='0', 'Year'='*', 'Sex'='*'), clean=FALSE))
    
    n <- dim(data)[1]
    years <- c(1995:2011)
    
    Level <- c()
    Year <- c()
    Total <- c()
    Male <- c()
    Female <-c()
    
    for(i in c(1:17)) {
      Level <- c(Level, data[,1])
      Year <- c(Year, rep(years[i], n))
      Total <- c(Total, data[,1+3*i])
      Male <- c(Male, data[,2+3*i])
      Female <- c(Female, data[,3+3*i])
    }
    
    data <- data.frame(Level, Year, Total, Male, Female)
    return(data)
  }
}

