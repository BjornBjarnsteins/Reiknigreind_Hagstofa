source('fetchData.R')

selectIndex <- c(1,2,3,4)
names(selectIndex) <- c("income_res", "income_rsa", "schoolreg", "schoolgrad")

datalist <- list(fetchData("income_res"), fetchData("income_rsa"), fetchData("schoolreg"), fetchData("schoolgrad"))

tablename <- "input_res"

# Use global max/min for axes so the view window stays
# constant as the user moves between years
xlim <- list(
  min = 0,
  max = max(datalist[[selectIndex[tablename]]]$Male)+200
)
ylim <- list(
  min = 0,
  max = max(datalist[[selectIndex[tablename]]]$Male)+200
)

#datalist <- list()
#for(tablename in names(selectIndex)) {
#  datalist <- c(datalist, fetchData(tablename))
#}

