# This file retrieves the raw data files from the specified source
# This file MUST be run in RStudio to work correctly

# Set current working directory to the one containing get-raw-data.R
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Source our helper functions
source("../functions/raw-data-helpers.R")

# Teams to fetch
teams <- c("ATL",
           "BRK",
           "BOS",
           "CHO",
           "CHI",
           "CLE",
           "DAL",
           "DEN",
           "DET",
           "GSW",
           "HOU",
           "IND",
           "LAC",
           "LAL",
           "MEM",
           "MIA",
           "MIL",
           "MIN",
           "NOP",
           "NYK",
           "OKC",
           "ORL",
           "PHI",
           "PHO",
           "POR",
           "SAC",
           "SAS",
           "TOR",
           "UTA",
           "WAS")

# Setup and execution of code to get player data

url_base <- "http://www.basketball-reference.com/teams"
url_files <- c(roster = "2016.html#all_roster",
               totals = "2016.html#all_totals",
               salaries = "2016.html#all_salaries")
dst_names <- c(roster = "roster-data",
               totals = "stat-data",
               salaries = "salary-data")

create_player_csvs <- function() {
  for (url_file in names(url_files))
    for (team in teams) {
      team_url <- paste(url_base, 
                        team, 
                        unname(url_files[url_file]), 
                        sep = "/")
      print(paste("accessing", team_url))
      xml_doc <- get_xml_document(team_url)
      location <- paste0("#div_", url_file, " #", url_file)
      print(location)
      player_frame <- get_player_table(xml_doc, location)
      
      # Roster's country isn't labeled, so we label it for convenience 
      if (url_file == "roster") {
        colnames(player_frame)[7] = "Country"
      }
      
      # Where to write
      file_name <- paste0("../../data/rawdata/", 
                          unname(dst_names[url_file]), 
                          "/", 
                          team, 
                          ".csv")
      
      # Write to csv in rawdata directory
      write.csv(player_frame, file_name, row.names = FALSE)
    }
}

# Get player data and store in csv files
create_player_csvs()
