library(shiny)
library(shinyBS)
library(texreg)
library(magrittr)
library(dplyr)
library(data.table)
library(ggplot2)
library(ggthemes)
library(scales)
library(hexbin)
library(sqldf)
library(tcltk)

# input paths
dir_db <- 'db'


# set up DB
db_path <- paste0(dir_db,'/FHA_db_small.sqlite')
db_src <- src_sqlite(db_path)

# Add DB Table sources
tbl_fha <- tbl(db_src, 'fha') 
tbl_acs_zip <- tbl(db_src, 'acs_zip')


# Load Time Series data in RAM
dt_ts <- 
    tbl(db_src, 'ts') %>% 
    collect() %>% 
    setDT(key = 'yr_mo')

choice_st <- 
    sqldf('select distinct state from fha', dbname=db_path) %>% 
    extract2(1) %>% sort()

