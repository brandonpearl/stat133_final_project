# This file retrieves the raw data files from the specified source
# This file MUST be run in RStudio to work correctly

# Set current working directory to the one containing download-data-script.R
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Source helper functions
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

# Constants
url_base <- "http://www.basketball-reference.com/teams"
url_file <- "2016.html"
dst_names <- c(roster = "roster-data",
               totals = "stat-data",
               salaries = "salary-data")

# Retrieves and stores player tables in csv files
# @param tables, the tables to fetch and save (subset of names(dst_names))
# @return NULL
create_player_csvs <- function(tables = names(dst_names)) {
  for (team in teams) {
    team_url <- paste(url_base, 
                      team, 
                      url_file, 
                      sep = "/")
    print(paste("accessing", team_url))
    xml_doc <- get_xml_document(team_url)
    for (table_name in tables) {
      print(table_name)
      location <- paste0("#div_", table_name, " #", table_name)
      player_frame <- get_player_table(xml_doc, location)
      
      # Roster's country isn't labeled, so we label it for convenience 
      if (table_name == "roster") {
        colnames(player_frame)[7] = "Country"
      }
      
      # Where to write
      file_name <- paste0("../../data/rawdata/", 
                          unname(dst_names[table_name]), 
                          "/", 
                          team, 
                          ".csv")
      
      # Write to csv in rawdata directory
      write.csv(player_frame, file_name, row.names = FALSE)
    }
  }
}

# Get player data and store in csv files
create_player_csvs(names(dst_names)[2])
