# This file generates all of our EDA analysis

# Set current working directory to the one containing download-data-script.R
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Source helper functions
source("../functions/generate-statistics.R") #Brandon's
source("../functions/generate-plots.R") #Trams's

# List of fields to treat as pure text fields
text_fields <- c("Player",
                 "Team",
                 "Position",
                 "Country",
                 "College")

# Get the full player table
t_location <- "../../data/cleandata/roster-salary-stats.csv"

full_player_table <- read.csv(t_location,
                              stringsAsFactors = FALSE)

full_player_table$Birth.Date <-
    as.Date(full_player_table$Birth.Date)

# Generate sink()'d data
result <- create_summary_file(full_player_table, text_fields)
if (!result) {
    print("Failure in generating summary statistic file.")
}

# Generate Plots
data = full_player_table
player_data = full_player_table
bar_graphs <- create_plot_graphs(data, text_fields)
hist_graphs <- create_box_histogram(player_data, text_fields)
