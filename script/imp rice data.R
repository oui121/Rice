# Restart R Session
rm(list=ls())

library(readxl)
library(tidyverse)

path <- "1_ricemajor.xls"

prod <- list()

for (i in 24:44){
    prod$i <- read_excel("1_ricemajor.xls", sheet = paste(i), 
                         col_names = c("prv","pa","ha","prod","yp","yh"), skip=3) 
}

for (i in seq_along(x)) {
    name <- names(x)[[i]]
    value <- x[[i]]
}


prod24 <- read_excel("1_ricemajor.xls", sheet="24", 
                     col_names = c("prv","pa","ha","prod","yp","yh"), skip=3)

