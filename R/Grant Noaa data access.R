library(countyweather)
library(rnoaa)

any(grepl("^\\.Renviron", list.files("~", all.files = TRUE)))
Sys.getenv("noaakey")
options("noaakey" = Sys.getenv("noaakey"))

