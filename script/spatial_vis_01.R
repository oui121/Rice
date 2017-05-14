rm(list=ls())

#setwd("D:/GDrive/OAE/Rice-OAE")
setwd("C:/Users/Piyayut/Google Drive/OAE/Rice-OAE") 
Sys.setlocale(category = "LC_ALL", locale = "thai")
options(encoding="UTF-8")

pck <- c("ggmap", "rgdal", "rgeos", "maptools", "tidyverse", 
         "tmap", "readxl","extrafont")
lapply(pck, library, character.only = TRUE) # load the required packages

# import shapefile
# provice
tha1 <- readOGR(dsn = "data/7_shapefile/THA_adm_shp", layer = "THA_adm1")
# amphore
tha2 <- readOGR(dsn = "data/7_shapefile/THA_adm_shp", layer = "THA_adm2") 
# tambon
tha3 <- readOGR(dsn = "data/7_shapefile/THA_adm_shp", layer = "THA_adm3")
# village
tha4 <- readOGR(dsn = "data/7_shapefile/THA_adm_shp", layer = "Village_77P") 
# landuse
landuse <- readOGR(dsn = "data/7_shapefile/THA", layer = "landuse")
water <- readOGR(dsn = "data/7_shapefile/THA", layer = "waterways")
points <- readOGR(dsn = "data/7_shapefile/THA", layer = "points") 

tm_shape (tha2[tha2$ID_1=="11",]) +
    tm_polygons("NAME_2", palette = "Set3",
                legend.show = FALSE) +
    tm_text("NAME_2",scale = 0.5) +
    tm_borders(alpha = 0.8) +
tm_shape(water) +
    tm_lines(col="dodgerblue3") +
tm_shape (tha1)+
    tm_text("NAME_1",scale = 0.8) +
    tm_borders(alpha = 0.8)

install.packages("ImageMagick")

## Not run: 
data(World, metro, Europe)

m1 <- tm_shape(Europe) + 
    tm_polygons("yellow") +
    tm_facets(along = "name")

animation_tmap(m1, filename="European countries.gif", width=800, delay=40)

m2 <- tm_shape(World) +
    tm_polygons() +
    tm_shape(metro) + 
    tm_bubbles(paste0("pop", seq(1970, 2030, by=10)), 
               border.col = "black", border.alpha = .5) +
    tm_facets(free.scales.symbol.size = FALSE, nrow=1,ncol=1) + 
    tm_format_World(scale=.5)

animation_tmap(m2, filename="World population.gif", width=1200, delay=100)

## End(Not run)
