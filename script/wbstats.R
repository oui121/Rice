rm(list=ls())

install.packages("countrycode")

library(countrycode)
data <- countrycode_data
??WDI

library(wbstats)
library(data.table)
library(googleVis)
# Download World Bank data and turn into data.table
myDT <- data.table(
    wb(indicator = c("SP.POP.TOTL",
                     "SP.DYN.LE00.IN",
                     "SP.DYN.TFRT.IN"), mrv = 60)
)  
# Download country mappings
countries <- data.table(wbcountries())

write.table(data, "mydata.csv", sep=",")
