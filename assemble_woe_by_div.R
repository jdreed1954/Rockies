require(tidyverse)
require(readr)
require(tidyverse)
require(readxl)
require(lubridate)
require(Lahman)
require(XML)
require(RCurl)
require(rlist)
require(knitr)
require(grid)
require(xtable)
require(scales)
require(reshape2)
require(RColorBrewer)

# 
# NLE <- getDivWoe("NLE", 2017)
# NLW <- getDivWoe("NLW", 2017)
# NLC <- getDivWoe("NLC", 2017)
# 
# ALE <- getDivWoe("ALE", 2017)
# ALW <- getDivWoe("ALW", 2017)
# ALC <- getDivWoe("ALC", 2017)


getTeams <- function(DIV){
  require(tidyverse)
  DIVISIONS <- c("ALE", "ALC", "ALW", "NLE", "NLC", "NLW")
  index <- which(DIV == DIVISIONS)
  teamsDiv <- tibble(
      ALE = c("BAL", "BOS", "NYY", "TB", "TOR"),
      ALC = c("CWS", "CLE", "DET", "KC", "MIN"),
      ALW = c("HOU", "LAA", "OAK", "SEA", "TEX"),
      
      NLE = c("ATL", "MIA", "NYM", "PHI", "WAS"),
      NLC = c("CHC", "CIN", "MIL", "PIT", "STL"),
      NLW = c("ARI", "COL", "LAD", "SDP", "SFG")
  )
  
  return(teamsDiv[[index]])
}

getGBGTmYr <- function(Team,Yr) {
  # Function retrieves the Game-by-Game from baseball-reference.com and re-formats
  # so it is suitable for display.  Note, Classes variable below helps cast the various
  # fields into a data type suitable to its purposes.
  #
  Classes <- c(
    "integer",
    rep("character", 6),
    rep("integer", 3),
    "character",
    rep("integer", 2),
    rep("character", 5),
    "integer",
    "character"
  )
  
  URL <- paste("https://www.baseball-reference.com/teams/",Team,"/",Yr,
               "-schedule-scores.shtml#team_schedule::none", sep="")
  gbgurl <- getURL(URL)
  
  tables <-
    readHTMLTable(gbgurl, stringsAsFactors = FALSE, colClasses = Classes)
  
  tables <- list.clean(tables, fun = is.null, recursive = FALSE)
  
  n.rows <- unlist(lapply(tables, function(t) dim(t)[1]))
  colnames(tables$team_schedule)[3] <- "X3"
  colnames(tables$team_schedule)[5] <- "H/A"
  
  G <-  tables$team_schedule %>% filter(!(Tm == "Tm"))
  
  G <-  as_tibble(G) %>% select(-c(3, 4, 10:13, 17, 19)) %>% 
    separate(Date, into = c("Day", "Date"), sep = ",")
  
  G$Day <- strtrim(G$Day, 3)
  
  # G <- mutate(G, `H/A` = ifelse(G$`H/A` == "@", "A", "H")) %>% 
  #  filter(!is.na(Win))
  BLANK <- " "
  G <- mutate(G, `H/A` = ifelse(G$`H/A` == "@", "A", "H"))
  n.col <- ncol(G)
  for ( i in 1:nrow(G)) {
    if (is.na(G$Win[i])) {
      G[i,6] <- BLANK
      G[i,7:8] <- 0
      G[i,9:n.col] <- BLANK
    }
  }
  
  return(G)
}
