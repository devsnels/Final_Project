library(dplyr)
library(stringr)
library(tidyselect)
library(ggplot2)
library(rmarkdown)
library(RColorBrewer)
library(knitr)
library(forcats)
library(readr)
library(tidyr)
library(broom)
library(purrr)
library(scales)
library(lubridate)
library(viridis)
library(RColorBrewer)
library(scales)
library(tidyverse)

temp_2006 <- read_csv("Data/temp/temp_2006.csv")
temp_2007 <- read_csv("Data/temp/temp_2007.csv")
temp_2008 <- read_csv("Data/temp/temp_2008.csv")
temp_2009 <- read_csv("Data/temp/temp_2009.csv")
temp_2010 <- read_csv("Data/temp/temp_2010.csv")
temp_2011 <- read_csv("Data/temp/temp_2011.csv")
precip_2006 <- read_csv("Data/precip/precip_2006.csv")
precip_2007 <- read_csv("Data/precip/precip_2007.csv")
precip_2008 <- read_csv("Data/precip/precip_2008.csv")
precip_2009 <- read_csv("Data/precip/precip_2009.csv")
precip_2010 <- read_csv("Data/precip/precip_2010.csv")
precip_2011 <- read_csv("Data/precip/precip_2011.csv")

temp <- rbind(temp_2006, temp_2007, temp_2008, temp_2009, 
              temp_2010, temp_2011)

temp <- temp %>% 
  select(County, "County Code", "Month Day, Year Code", "Day of Year", 
         "Avg Daily Max Air Temperature (F)", 
         "Avg Daily Min Air Temperature (F)") %>% 
  rename(county = County,
         fip = "County Code",
         date = "Month Day, Year Code",
         day_year = "Day of Year",
         max_temp_f = "Avg Daily Max Air Temperature (F)",
         min_temp_f = "Avg Daily Min Air Temperature (F)") %>% 
  mutate(date = mdy(date))
head(temp)
tail(temp)

precip <- rbind(precip_2006, precip_2007, precip_2008, precip_2009, 
                precip_2010, precip_2011)

precip <- precip %>%
  select(County, "Month Day, Year Code", "Avg Daily Precipitation (mm)")%>%
  rename(county = County,
         date = "Month Day, Year Code",
         avg_precip = "Avg Daily Precipitation (mm)") %>% 
  mutate(date = mdy(date))

head(precip)
tail(precip)

ca_weather <- merge(temp, precip, by = c("county", "date"))
head(ca_weather)
tail(ca_weather)

ca_precip <- ca_weather %>% 
  select(county, date, fip, avg_precip) %>% 
  separate(county, c("county", "state"), sep = " County, CA") %>% 
  select(county, date, fip, avg_precip) %>% 
  mutate(month = month(date)) %>% 
  mutate(year = year(date)) %>% 
  group_by(county, fip, month, year) %>% 
  summarise(avg_precip = mean(avg_precip)) %>% 
  ungroup %>% 
  arrange(year)

ca_precip

ca_precip_cases <- full_join(ca_precip, cases, by = c('month', 'year', 'county'))

ca_precip_cases$positive_cases[is.na(ca_precip_cases$positive_cases)] <- 0

ca_precip_cases <- ca_precip_cases %>% 
  arrange(positive_cases)

View(ca_precip_cases)

    