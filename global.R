source('fetchData.R')

selectIndex <- c(1,2,3,4,5)
names(selectIndex) <- c("income_res", "income_rsa", "schoolreg", "schoolgrad", "prisonSentences")

datalist <- list(fetchData("income_res"), fetchData("income_rsa"), fetchData("schoolreg"), fetchData("schoolgrad"), fetchData("prisonSentences"))
data_menu <- c("Income by Economic Activity" = "income_res", "Income by Age" = "income_rsa", "Registered students in undergraduate programs"="schoolreg", "Graduated students by school levels"="schoolgrad", "Prison sentences"="prisonSentences")

tablename <- "income_res"
# 
# # Use global max/min for axes so the view window stays
# # constant as the user moves between years
xlim <- list(
  min = 0
  # max = max(datalist[[selectIndex[tablename]]]$Male)+200
)
ylim <- list(
  min = 0
  # max = max(datalist[[selectIndex[tablename]]]$Male)+200
)

#datalist <- list()
#for(tablename in names(selectIndex)) {
#  datalist <- c(datalist, fetchData(tablename))
#}

