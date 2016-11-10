


#clean stat-data r
setwd("~/Documents/stat133_final_project/project/data/rawdata/stat-data")
folder <-
    "~/Documents/stat133_final_project/project/data/rawdata/stat-data/"

file_list <- list.files(path = folder, pattern = "*.csv")
library(stringr)
f_name <- as.vector(0)
for (i in 1:length(file_list)) {
    name <- str_split(file_list[i], pattern = '')
    name <- unlist(name)
    name <- name[1:which(name == '.') - 1]
    f_name[i] <- paste0(name, collapse = '')
}

for (k in 1:length(file_list)) {
    file_name = read.csv(paste(folder, file_list[k], sep = ''), as.is = TRUE)
    # change column names
    col_names <- c(
        "Rank",
        "Player",
        "Age",
        "Games",
        "Games Started",
        "Minutes Played",
        "Field Goals",
        "Field Goal Attempts",
        "Field Goal Percentage",
        "3-Point Field Goals",
        "3-Point Field Goal Attempts",
        "3-Point Field Goal Percentage",
        "2-Point Field Goals",
        "2-point Field Goal Attempts",
        "2-Point Field Goal Percentage",
        "Effective Field Goal Percentage",
        "Free Throws",
        "Free Throw Attempts",
        "Free Throw Percentage",
        "Offensive Rebounds",
        "Defensive Rebounds",
        "Total Rebounds",
        "Assists",
        "Steals",
        "Blocks",
        "Turnovers",
        "Personal Fouls",
        "Points"
    )
    colnames(file_name) <- col_names
    
    #remove the one whose position is not one of the 5 required positions 
    if (length(removed) >= 1) {
        file_name = file_name[-removed, ]
    } 
    
    file_name[, 1] <- as.numeric(file_name[, 1])
    
    for (i in 3:ncol(file_name)) {
        index = which(is.na(file_name[, i]))
        if (length(index) >= 1) {
            file_name[, i][which(is.na(file_name[, i]))] <-  NA
        }
        file_name[, i] = as.numeric(file_name[, i])
    }
    
    write.csv(
        file_name,
        file = paste0('../../cleandata/clean-stat-data/', f_name[k] , ".csv"),
        row.names = FALSE
    )
    
}

