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
library(scales)
library(reshape2)
library(RColorBrewer)
library(kableExtra)

url <- "https://www.baseball-reference.com/teams/COL/2018-schedule-scores.shtml#div_win_loss , #win_loss_2 table , #win_loss_1 , h2"

doc <- getURL(url)

tables <- readHTMLTable(doc, header = TRUE, 
                        stringsAsFactors = FALSE, colClasses = cClasses)


#Loading the rvest package
library('rvest')


#Reading the HTML code from the website
webpage <- read_html(url)
