library(tidyverse)
library(readxl)
library(RCurl)
library(rlist)
library(knitr)
library(grid)
library(XML)
library(ggplot2)

# Workflow - save data as csv files:
cg_path <-"./data/Carlos-Gonzalez_batting.xlsx"
cg_sheets <- excel_sheets(cg_path)
cg_all <- tibble()
for (i in cg_sheets){
  file <-  paste("./data/cg_", i,".csv", sep = "")
  cg_sheet <- cg_path %>% read_excel(sheet = i) %>% write_csv(file)
  cg_sheet$Year <- year(ymd(cg_sheet$Date))
  cg_all <- rbind(cg_all, cg_sheet)
}

# Let's rearrange columns in data_frame
cg_all <- select(cg_all, Year,c(1:27)) %>%
  filter(AVG < .500)

# Facet Wrap for his 
sp <- ggplot(cg_all, aes(as.Date(Date),OPS, group = Year), size = OBP) + 
  scale_x_date(date_breaks = "1 month", 
      date_labels="%b") +
      geom_point() + geom_smooth()

sp + facet_wrap(~Year, scales=("free_x")) + theme_bw()

# Career OBP + SLG
ggplot(cg_all, aes(as.Date(Date),OBP+SLG), size = OBP) + 
  scale_x_date(date_breaks = "1 year", 
               date_labels="%Y") +
  geom_point() + geom_smooth()

# Violin Plots
bp <- ggplot(cg_all, aes(as.Date(Date),OBP+SLG), size = OBP) + 
  scale_x_date(date_breaks = "1 year", 
  date_labels="%Y") +
  geom_violin()

bp + facet_wrap(~Year, scales=("free_x")) + theme_bw()

# Baseball-Reference.com
cg_url <- "http://www.baseball-reference.com/players/g/gonzaca01.shtml#batting_standard::none"
C.Classes <-  c("integer", "integer", "character","character",rep("integer", 13),
                rep("double",4), rep("integer",7), "character", "character")
tables <- readHTMLTable(cg_url,stringsAsFactors = FALSE, colClasses = C.Classes)
tables <- list.clean(tables, fun = is.null, recursive = FALSE)
n.rows <- unlist(lapply(tables, function(t) dim(t)[1]))

CargoBatting <- as_tibble(tables$batting_standard)

# Filter out minor league stints.
cg <- filter(CargoBatting, Lg == "AL" | Lg == "NL")
ggplot(cg,aes(x = Year, y = BA)) + geom_point() + geom_smooth()

ggplot(cg,aes(x = Year, y = OBP + SLG)) + geom_point() + geom_smooth()

BrowseURL("http://eadxl.tidyverse.org")

