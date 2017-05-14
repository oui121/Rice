rm(list=ls())

setwd("F:/Project/Rice-OAE")
Sys.setlocale(category = "LC_ALL", locale = "thai")
options(encoding="UTF-8")

# set of required packages
pck <- c("ggmap", "rgdal", "rgeos", "maptools", "tidyverse", "curl", "jsonlite", 
       "tmap", "readxl","XLConnect")

# lapply(x, install.packages) # install all the required packages
lapply(pck, library, character.only = TRUE) # load the required packages


# initialize data
rice <- read_excel("1_ricemajor.xls", sheet="rice")


# import shapefile
tha1 <- readOGR(dsn = "./shapefile/THA_adm_shp", layer = "THA_adm1") # provice
tha2 <- readOGR(dsn = "./shapefile/THA_adm_shp", layer = "THA_adm2") # amphore

# import the area, production, yield of 2558/59 rice data

wb <- loadWorkbook("1_ricemajor.xls")

rice59 <- readWorksheet(wb, sheet = "58", startRow = 4, startCol=1, 
                        endCol=6, header = FALSE)
colnames(rice59) <- c("prv","pa","ha","prod","yp","yh") #rename columns


# import province mathcing table 
prov <- read_excel("thprovinces.xlsx", sheet="oae")

# merge province name into rice59 
rice59 <- left_join(rice59, prov, by = c('prv'='NAMETH_1'))

# merge rice59 into spatial data

tha1@data <- left_join(tha1@data, rice59,by = c('HASC_1'='HASC_1'))
sapply(tha1@data, class)

tm <- qtm(shp = tha1, fill = "pa", 
          fill.palette="Blues", 
          fill.title="Planted Area(Rai)")

save_tmap(tm, "thai_rice59.png", width=1200, height=2000)


for(i in 30:58) {
    
    ricei <- readWorksheet(wb, sheet = "i", startRow = 4, startCol=1, 
                            endCol=6, header = FALSE)
    colnames(rice59) <- c("prv","pa","ha","prod","yp","yh") #rename columns
    
    usq[i] <- u1[i]*u1[i]
    print(usq[i])
}




plot(tha1)
sel <- tha2$ID_1 == 11
plot(tha2[sel, ], col = "turquoise", add = TRUE)

sel <- tha2$ID_1 == 11
plot(tha2[sel, ])

plot(world)
sapply(world@data, class)


args(read_excel)





colnames(rice) <- c("prv","pa","ha","prod","yp","yh") #rename columns


# sapply(tha2@data, class)
world <- readOGR(dsn = "./shapefile/TM_WORLD", layer = "TM_WORLD_BORDERS-0.3") # world
world$POP2005 <- as.numeric(as.character(world$POP2005)) # coerce population into numeric
worlddata <- world@data # subsetting non-spatial data

rice59 <- read_excel("1_ricemajor.xls", sheet="58", 
                     col_names = c("prv","pa","ha","prod","yp","yh"), skip=8)
