# This file generates all of our EDA analysis

# Set current working directory to the one containing download-data-script.R
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Source helper functions
source("../functions/generate-statistics.R") #Brandon's
source("../functions/generate-plots.R") #Trams's

# Get the full player table
t_location <- "../../data/cleandata/clean-stat-data/roster-salary-stats.csv"

full_player_table <- read.csv(table_loc,
                       stringsAsFactors = FALSE)

brandon_function(full_player_table)

tram_function(full_player_table)