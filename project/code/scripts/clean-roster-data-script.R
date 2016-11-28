
library(stringr)

# Set current working directory to the one containing
# clean-data-scripts.R
setwd(dirname(rstudioapi::getActiveDocumentContext()$path)) 
setwd("../../data/rawdata/roster-data")
folder <- getwd()
# source for function helpers
source("../../../code/functions/clean-roster-helpers.R")

# path to folder that holds multiple .csv files
file_list <- list.files(path = paste0(folder, "/"),
                        pattern = "*.csv")

# function is used to clean the roster table

f_name <- as.vector(0)
for (i in 1:length(file_list)) {
    name <- str_split(file_list[i], pattern = '')
    name <- unlist(name)
    name <- name[1:which(name == '.') - 1]
    f_name[i] <- paste0(name, collapse = '')
}

for (k in 1:length(file_list)) {
    file_name = read.csv(paste(paste0(folder, "/"),
                               file_list[k], sep = ''), as.is = TRUE)
    
    file_name1 <- clean_roster_helper(file_name)
    
    write.csv(
        file_name1,
        file = paste0('../../cleandata/clean-roster-data/', f_name[k] , ".csv"),
    )
}
