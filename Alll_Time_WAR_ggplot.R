## All Time WAR Plots
# Get latest Batting and Pitching WAR Data
# https://www.baseball-reference.com/leaders/WAR_bat_career.shtml
library(tidyverse)
library(readxl)
library(lubridate)
library(Lahman)
library(XML)
library(RCurl)
library(rlist)
library(knitr)
library(grid)
library(xtable)

source("../Baseball/Baseball_Functions.r")

if(!exists("batWar")) {batWar <- getDailyBatWar()}
if(!exists("pitWar")) {pitWar <- getDailyPitWar()}


batALL <- batWar %>% arrange(mlb_ID,year_ID) %>% 
  group_by(mlb_ID, name_common) %>% 
  summarize(Start   = min(year_ID), 
            End     = max(year_ID),
            Years   = End - Start + 1,
            Games   = sum(G), 
            PA      = sum(PA),
            WAR     = sum(WAR)) %>%
  arrange(desc(WAR)) 
batALL$Rank <- 1:nrow(batALL)
b <- filter(batALL, Years >= 10)

ggplot(b, aes(Years, WAR)) + geom_point()

ggplot(b, aes(x = factor(Years), y = WAR)) + geom_boxplot()

ggplot(b, aes(Years, WAR)) + geom_point() #+ geom_jitter(stat = "identity",
                                          #                  position = "jitter")


url <- "https://www.baseball-reference.com/teams/COL/2017-roster.shtml#the40man::none"

doc <- getURL(url)
colHeaders <-  c("Rk", "Uni", "Name", "Nat", "Position", "OnActv", 
                 "DL", "Age", "B", "T", "Ht", "Wt", "DoB", "FirstYr")


tables <-  readHTMLTable(doc)
roster <- tables[[1]]
roster <- as_tibble(roster)
