options("noaakey" = Sys.getenv("noaakey"))
install.packages("countyweather")
library(countyweather)
library(dplyr)
library(tidyr)
library(tidyverse)
library(lubridate)
library(stringr)
library(readr)
library(ggplot2)
library(leaflet)

#looking at temperature and pricipitaiton 
# some kinda map 
#selecitng particular counties
# making a map with layering(possibly) 
#total number of counties per week per year

report <-  read_csv( "/Users/anastasiaratcliff/Desktop/R- Programing /Final_Project/Data/wnv_human_cases.csv")

a <- report %>%
  filter(Year == "2006":"2010")


