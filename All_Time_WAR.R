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

if (!exists("batWar")) {
  batWar <- getDailyBatWar()
}
if (!exists("pitWar")) {
  pitWar <- getDailyPitWar()
}

batTop20 <- batWar %>% arrange(mlb_ID, year_ID) %>%
  group_by(mlb_ID, name_common) %>%
  summarize(
    Start   = min(year_ID),
    End     = max(year_ID),
    Years   = End - Start + 1,
    Games   = sum(G),
    PA      = sum(PA),
    WAR     = sum(WAR)
  ) %>%
  arrange(desc(WAR)) %>%
  head(n = 20)
batTop20$Rank <- 1:20

batALL <- batWar %>% arrange(mlb_ID, year_ID) %>%
  group_by(mlb_ID, name_common) %>%
  summarize(
    Start   = min(year_ID),
    End     = max(year_ID),
    Years   = End - Start + 1,
    Games   = sum(G),
    PA      = sum(PA),
    WAR     = sum(WAR)
  ) %>%
  arrange(desc(WAR))
batALL$Rank <- 1:nrow(batALL)

pitTop20 <- pitWar %>% arrange(mlb_ID, year_ID) %>%
  group_by(mlb_ID, name_common) %>%
  summarize(
    Start  = min(year_ID),
    End    = max(year_ID),
    Years  = End - Start + 1,
    Games  = sum(G),
    IPouts = sum(IPouts),
    WAR    = sum(WAR)
  ) %>%
  arrange(desc(WAR)) %>%
  head(n = 20)
pitTop20$Rank <- 1:20

colNames <-
  c("Rank",
    "Player",
    "Career Start",
    "Career End",
    "Years",
    "Games",
    "IPouts",
    "WAR")
knitr::kable(
  pitTop20[, c(9, 2:8)],
  col.names = colNames,
  #format.args = list(big.mark = ','),
  cap = "All-Time Best Pitchers (WAR)",
  align = c("c", "l", "c", "c", "c", "r", "r", "r")
)

colNames <-
  c("Rank",
    "Player",
    "Career Start",
    "Career End",
    "Years",
    "Games",
    "PA",
    "WAR")
knitr::kable(
  batTop20[, c(9, 2:8)],
  col.names = colNames,
  cap = "All-Time Best Position Players (WAR)",
  align = c("c", "l", "c", "c", "c", "r", "r", "r")
)

# Hall of Fame Players

hof <- getHOF()
hofPlayers <- hof %>% filter(Inducted.As == "Player")
