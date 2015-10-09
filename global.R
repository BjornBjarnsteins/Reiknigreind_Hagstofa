# ################################################################################# #
# REI101M                     Hópverkefni 1               Háskóli Íslands, okt 2015 #       
#                                                                                   #
# Andrea Björk Björnsdóttir                                                         #
# Björn Bjarnsteinsson                                                              #
# Leó Jóhannsson                                                                    #
# ################################################################################# #


source('fetchData.R')

# Index vector to get indices of selected data
selectIndex <- c(1,2,3,4,5,6)
names(selectIndex) <- c("income_res", "income_rsa", "schoolreg", "schoolgrad", "prisonSentences","population")

# datalist is the list of our data frames, gotten with the fetchData function.
datalist <- list(fetchData("income_res"), fetchData("income_rsa"), fetchData("schoolreg"), fetchData("schoolgrad"), fetchData("prisonSentences"), fetchData("population"))
# Titles for the graphs
data_menu <- c("Income by Economic Activity" = "income_res", "Income by Age" = "income_rsa", "Registered Students in Undergraduate Programs"="schoolreg", "Graduated Students by School Levels"="schoolgrad", "Prison Sentences"="prisonSentences", "Population by Age"="population")

# Starting table
tablename <- "income_res"
# 
# # Use global max/min for axes so the view window stays
# # constant as the user moves between years
xlim <- list(
  min = 0,
  max = max(datalist[[selectIndex[tablename]]]$Male)+200
)
ylim <- list(
  min = 0,
  max = max(datalist[[selectIndex[tablename]]]$Male)+200
)