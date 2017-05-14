install.packages("devtools")
library(devtools)
pkgs <- c("slidify", "slidifyLibraries", "rCharts")
install_github(pkgs, 'ramnathv', ref = 'dev')
