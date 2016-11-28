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
    file_name1 = read.csv(paste(paste0(folder,"/"), file_list[k], sep = ''),
                         as.is = TRUE)
    # change column names
    file_name <- clean_stats_helpers(file_name1)
    
    file_name$Team <- rep(f_name[k], time = nrow(file_name))
    
    write.csv(
        file_name,
        file = paste0('../../cleandata/clean-stat-data/', f_name[k] ,
                      ".csv"),
        row.names = FALSE
    )
    
}