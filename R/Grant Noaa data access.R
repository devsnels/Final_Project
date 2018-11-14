library(countyweather)
library(rnoaa)
library(dplyr)
library(stringr)
library(tidyr)
library(ggplot2)
library(ggthemes)
library(ggmap)



any(grepl("^\\.Renviron", list.files("~", all.files = TRUE)))
Sys.getenv("noaakey")
options("noaakey" = Sys.getenv("noaakey"))

daily_fips(fips = "06073", date_min = "2006-01-01", date_max = "2006-01-31", var = prcp)

humanwn <- read.csv("Data/wnv_human_cases.csv")
countywn <- humanwn %>% 
  group_by(County) %>% 
  count()

countyplot <- ggplot(countywn, aes(x = County, y = n))+
                       geom_point()
countyplot



countyfips <- read.csv("Data/county fips codes.csv")

countyfips <- countyfips %>% 
  mutate()