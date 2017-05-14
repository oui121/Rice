rm(list=ls())

setwd("D:/GDrive/OAE/Rice-OAE")
Sys.setlocale(category = "LC_ALL", locale = "thai")
options(encoding="UTF-8")

pck <- c("ggmap", "rgdal", "rgeos", "maptools", "tidyverse", 
         "tmap", "readxl","extrafont")
lapply(pck, library, character.only = TRUE) # load the required packages

# rice
rice <- read_excel("data/rice60.xls", sheet="r60")

# prov
prov <- read_excel("tbl_prov.xlsx", sheet="oae")

# import shapefile
tha1 <- readOGR(dsn = "data/shapefile/THA_adm_shp", layer = "THA_adm1") # provice
tha2 <- readOGR(dsn = "data/shapefile/THA_adm_shp", layer = "THA_adm2") # amphore

# merge
rice <- left_join(rice, prov, by = c('prv'='KEY_1'))

# merge rice59 into spatial data

tha1@data <- left_join(tha1@data, rice,by = c('HASC_1'='HASC_1'))
sapply(tha1@data, class)

tm <- tm_shape (tha1) +
    tm_fill("pa", palette = "Greens",
            breaks = c(0, 200000, 1000000, 2000000, Inf),
            legend.show = TRUE,
            title = "พื้นที่ปลูกข้าว (ไร่)") +
    tm_borders(alpha = 0.8) +
    tm_text("prv", size = "pa", size.lim = 1000000, root = 5, scale = 1.6,
            bg.color = "white", bg.alpha = 0.8, col = "grey20",
            legend.size.show = FALSE,
            remove.overlap = TRUE,
            print.tiny = FALSE) +
    tm_layout(outer.margins = 0,
              frame = FALSE,
              scale = 0.5,
              fontfamily = "TH SarabunPSK",
              legend.width = 0.8,
              legend.title.size = 2.5,
              legend.text.size = 1.8,
              legend.position = c("0.55","0.15"),
              legend.bg.color = "white",
              legend.bg.alpha = 0,
              legend.format = list(fun = NULL, 
                                   scientific = FALSE, 
                                   digits = NA,
                                   text.separator = "-",
                                   text.less.than = "น้อยกว่า",
                                   text.or.more = "หรือมากกว่า"))

tm <- tm_shape (tha1) +
    tm_fill("pa", palette = "Greens",
            breaks = c(0, 200000, 1000000, 2000000, Inf),
            legend.show = TRUE,
            title = "พื้นที่ปลูกข้าว (ไร่)") +
    tm_borders(alpha = 0.8) +
    tm_text("prv", col = "grey20",
            legend.size.show = FALSE,
            remove.overlap = FALSE,
            print.tiny = TRUE) +
    tm_layout(outer.margins = 0,
              frame = FALSE,
              scale = 0.5,
              fontfamily = "TH SarabunPSK",
              legend.width = 0.8,
              legend.title.size = 2,
              legend.text.size = 1.5,
              legend.position = c("0.55","0.15"),
              legend.bg.color = "white",
              legend.bg.alpha = 0,
              legend.format = list(fun = NULL, 
                                   scientific = FALSE, 
                                   digits = NA,
                                   text.separator = "-",
                                   text.less.than = "น้อยกว่า",
                                   text.or.more = "หรือมากกว่า"))


save_tmap(tm, "rice_map.png", width = 2400, height = 4000, dpi = 600)
