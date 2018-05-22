# Download Daily WAR from Baseball-Reference
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

getDailyBatWar <- function() {
  #Daily Updated Batting WAR data (in CSV).
  require(tidyverse)
  require(readxl)
  require(RCurl)
  
  burl <- "https://www.baseball-reference.com/data/war_daily_bat.txt"
  tf <- tempfile()
  
  doc <- getURL(burl)
  writeLines(doc, tf)
  # Define Column Classes
  c.Classes <- c("character","integer",   "integer", "character", # 4
                 "integer",  "character", "integer", "character", # 8
                 "integer",  "integer",   "double",  "double",    #12
                 "double",   "double",    "double",  "double",    #16
                 "double",   "double",    "double",  "double",    #20
                 "double",   "double",    "double",  "double",    #24
                 "double",   "double",    "double",  "double",    #28
                 "double",   "double",    "double",  "double",    #32
                 "double",   "double",    "double",  "character", #36
                 "double",   "double",    "double",  "double",    #40
                 "double",   "double",    "double",  "double",    #44
                 "double",   "double",    "double",  "double",    #48
                 "double")          
  battingWAR <-
    as_tibble(read.csv(tf, header = TRUE, stringsAsFactors = FALSE,
                       colClasses = c.Classes, na.strings = c("NULL")))
  unlink(tf)
  return(battingWAR) 
}


getDailyPitWar <- function() {
  # Daily Updated Pitching WAR data (in CSV).
  require(tidyverse)
  require(readxl)
  require(RCurl)
  
  purl <-
    "https://www.baseball-reference.com/data/war_daily_pitch.txt"
  ptf <- tempfile()
  pdoc <- getURL(purl)
  writeLines(pdoc, ptf)
  c.Classes <- c("character","integer",   "integer", "character", # 4
                 "integer",  "character", "integer", "character", # 8
                 "integer",  "integer",   "integer", "integer",   #12
                 "integer",  "integer",   "double",  "double",    #16
                 "double",   "integer",   "double",  "double",    #20
                 "integer",  "double",    "double",  "double",    #24
                 "double",   "double",    "double",  "double",    #28
                 "double",   "double",    "double",  "double",    #32
                 "double",   "double",    "double",  "double",    #36
                 "double",   "double",    "double",  "double",    #40
                 "double",   "double")

  pitchingWAR <- as_tibble(read.csv(ptf, header = TRUE, stringsAsFactors = FALSE,
                  colClasses = c.Classes, na.strings = c("NULL")))
  return(pitchingWAR)
}
