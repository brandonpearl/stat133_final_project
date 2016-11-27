library(stringr)

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
setwd("../../data/rawdata/stat-data")
folder <- getwd()
# path to folder that holds multiple .csv files

file_list <- list.files(path = paste0(folder,"/"), pattern = "*.csv")

# function is used to clean the roster table

f_name <- as.vector(0)
for (i in 1:length(file_list)) {
    name <- str_split(file_list[i], pattern = '')
    name <- unlist(name)
    name <- name[1:which(name == '.') - 1]
    f_name[i] <- paste0(name, collapse = '')
}


for (k in 1:length(file_list)) {
    file_name = read.csv(paste(paste0(folder,"/"), file_list[k], sep = ''), as.is = TRUE)
    # change column names
    col_names <- c(
        "Rank",
        "Player",
        "Age",
        "Games",
        "Games_Started",
        "Minutes_Played",
        "Field_Goals",
        "Field_Goal_Attempts",
        "Field_Goal_Percentage",
        "3-Point_Field_Goals",
        "3-Point_Field_Goal_Attempts",
        "3-Point_Field_Goal_Percentage",
        "2-Point_Field_Goals",
        "2-point_Field_Goal_Attempts",
        "2-Point_Field_Goal_Percentage",
        "Effective_Field_Goal_Percentage",
        "Free_Throws",
        "Free_Throw_Attempts",
        "Free_Throw_Percentage",
        "Offensive_Rebounds",
        "Defensive_Rebounds",
        "Total_Rebounds",
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
    
    file_name$Team <- rep(f_name[i], time = nrow(file_name))
    
    write.csv(
        file_name,
        file = paste0('../../cleandata/clean-stat-data/', f_name[k] , ".csv"),
        row.names = FALSE
    )
    
}
