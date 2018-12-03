library(countyweather)
library(dplyr)
library(tidyr)
library(tidyverse)
library(lubridate)
library(stringr)
library(readr)
library(ggplot2)
library(leaflet)
library(shiny)


report <-  read_csv( "Data/wnv_human_cases.csv")

#filtering dates to match CDC Data 2006- 2010 
#year objects and merging 

a <- report %>%
  filter(Year == "2006") 
  
a <- a %>% 
  mutate(date = lubridate::ymd( "2006-01-01" ) + lubridate::weeks(a$`Week Reported` - 1 ))
  
b <- report %>%
  filter(Year == "2007")
  
b <- b %>% 
  mutate(date = lubridate::ymd( "2007-01-01" ) + lubridate::weeks(b$`Week Reported` - 1 ))

c <- report %>%
  filter(Year == "2008")
  
c <- c %>% 
  mutate(date = lubridate::ymd( "2008-01-01" ) + lubridate::weeks(c$`Week Reported` - 1 ))

d <- report %>%
  filter(Year == "2009")
  
d <- d %>% 
  mutate(date = lubridate::mdy( "2009-01-01" ) + lubridate::weeks(d$`Week Reported` - 1 ))

e <- report %>%
  filter(Year == "2010")

e <- e %>% 
  mutate(date = lubridate::ymd( "2010-01-01" ) + lubridate::weeks(e$`Week Reported` - 1 ))

ab <- merge(a,b, all = TRUE)
abc <- merge(ab, c, all = TRUE)
abcd <- merge(abc, d, all = TRUE)
abcde <- merge(abcd, e, all = TRUE)

cases <- abcde %>% 
  select(date, 
         county = County, 
         positive_cases = "Positive Cases") %>% 
  mutate(date = ymd(date)) %>% 
  mutate(date = floor_date(date, unit = "month")) %>% 
  group_by(date, county) %>% 
  summarize(positive_cases = sum(positive_cases)) %>% 
  ungroup

cases  

system.file("examples", package = "shiny")
runExample("01_hello")
  
  
  
  
  
  
  
  
