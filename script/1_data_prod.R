# Step 0: Clear R envi, set options and load packages
rm(list=ls())

setwd("C:/Users/Piyayut/Google Drive/OAE/Rice-OAE")
Sys.setlocale(category = "LC_ALL", locale = "thai")
options(encoding="UTF-8")

# load essential packages
pack <- c("tidyverse", "readxl", "reshape2")
lapply(pack, library, character.only = TRUE) # load the required packages

# Converting Table
tbl_prov <- read_excel("tbl_prov.xlsx", sheet="oae")
tbl_subname <- read_excel("tbl_subname.xlsx", sheet="ricevar")

# Functions
read_prod <- function(path,intyear,endyear){
    df <- data.frame(matrix(ncol = 6, nrow = 0)) %>% 
        set_colnames(c("prv","pa","ha","prod","yp","yh"))
    for(i in intyear:endyear){
         read_excel(path, sheet=paste(i), skip = 3, col_names = FALSE) %>% 
            select(1:4) %>%
            set_colnames(c("prv","pa","ha","prod")) %>% 
            subset(!is.na(.[1])) %>%
            mutate(yp = prod*1000/pa) %>% 
            mutate(yh = prod*1000/ha) %>% 
            mutate(year = as.numeric(paste("25", i+1, sep=""))) %>% 
            mutate(season = 1) %>%
            bind_rows(df,.) %>% 
            {.} -> df
    }
    return(df)
}

sep_data <- function(df){
    left_join(df, tbl_prov, by = c('prv'='KEY_1')) %>%
    mutate(subname = prv) %>%
    mutate(filt = OAEID) %>%
    select(-prv,-NAME_1) %>%
    rename(prv = NAMETH_1) %>% 
    fill(OAEID:HASC_1) %>%
    filter(is.na(.$filt)) %>%
    select(prv,subname,everything(),-filt) %>%
    mutate(subname = trim(.$subname))
}

reshape_data <- function(df){
    melt(df, id = c("prv","year","subname","season","OAEID","HASC_1"),
         na.rm = TRUE) %>% 
    dcast(OAEID + prv + year ~ variable + subname, fun.aggregate = sum)
}

trim <- function (x) gsub("^\\s+|\\s+$", "", x)

# DATA WRANGLING

# base table
rice1 <- read_prod(path = "1_total.xls", intyear = 45, endyear = 58) %>% 
    left_join(tbl_prov, by = c('prv'='KEY_1')) %>%
    mutate(prv = NAMETH_1) %>% 
    select(OAEID:HASC_1,prv,year,season,everything(),-(NAMETH_1:NAME_1))

# by 4 groups of rice which are obtained from ricetype and rice varities table
rice2.1 <- read_prod(path = "2_ricetype.xls", intyear = 45, endyear = 58) %>% 
    sep_data()
rice2.2 <- read_prod(path = "5_ricevar_45-58.xls", intyear = 45, endyear = 58) %>% 
    sep_data()
rice2 <- bind_rows(rice2.1, rice2.2) %>%
    left_join(., tbl_subname, by = c('subname'='ricevar')) %>% 
    filter(!is.na(.$ricegrp_t)) %>%
    mutate(subname = id_1) %>% 
    group_by(OAEID,prv,year,subname,season,HASC_1) %>%
    summarise_each(funs(sum),pa:yh) %>% 
    mutate(yp = prod*1000/pa) %>% 
    mutate(yh = prod*1000/ha) %>%     
    arrange(OAEID,year,subname)
rm(rice2.1,rice2.2)
rice2re <- reshape_data(rice2) %>% 
    mutate(pa_3 = pa_0 - pa_1 - pa_2) %>% 
    mutate(ha_3 = ha_0 - ha_1 - ha_2) %>% 
    mutate(prod_3 = prod_0 - prod_1 - prod_2) %>% 
    mutate(yp_3 = prod_3*1000/pa_3) %>%    
    mutate(yh_3 = prod_3*1000/ha_3)

# by irrigation
rice3 <- read_prod(path = "4_irri_45-58.xls", intyear = 45, endyear = 58)
rice3re <- sep_data(rice3) %>% 
    reshape_data()

# by rice planting methods
rice4 <- read_prod(path = "8_method_45-58.xls", intyear = 45, endyear = 58)
rice4re <- sep_data(rice4) %>% 
    reshape_data()

ricedb <- left_join(rice1, rice2re, by = c("prv","year","OAEID")) %>% 
    left_join(rice3re,by = c("prv","year","OAEID")) %>% 
    left_join(rice4re,by = c("prv","year","OAEID"))
    
write_excel_csv(ricedb,"ricedb.xls")

temp <- sep_data(rice4) %>% 
    group_by(subname, year) %>% 
    summarise(totalpa = sum(pa))