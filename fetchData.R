require(pxweb)
income <- data.frame(get_pxweb_data(url='http://px.hagstofa.is/pxen/api/v1/en/Samfelag/launogtekjur/3_tekjur/VIN07001.px',
                                        dims=list('Region'='*', 'Economic activity'='*', 'Sex'='*', 'Year'='*'), clean=FALSE))

n <- dim(income)[1]
years <- c(1998:2005)

Region <- c()
Economic.Activity <- c()
Year <- c()
Total <- c()
Male <- c()
Female <-c()

for(i in c(1:8)) {
  Region <- c(Region, income[,1])
  Economic.Activity <- c(Economic.Activity, income[,2])
  Year <- c(Year, rep(years[i], n))
  Total <- c(Total, income[,2+i])
  Male <- c(Male, income[,10+i])
  Female <- c(Female, income[,18+i])
}

income <- data.frame(Region, Economic.Activity, Year, Total, Male, Female)

