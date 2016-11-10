#clean salary-data
setwd("~/Documents/stat133_final_project/project/data/rawdata/salary-data")
folder <-
    "~/Documents/stat133_final_project/project/data/rawdata/salary-data/"
setwd("./salary-data")

file_list <- list.files(path = folder, pattern = "*.csv")
library(stringr)
f_name <- as.vector(0)

for (i in 1:length(file_list)) {
    name <- str_split(file_list[i], pattern = '')
    name <- unlist(name)
    name <- name[1:which(name == '.') - 1]
    f_name[i] <- paste0(name, collapse = '')
}

for (i in 1:length(file_list)) {
    file_name = read.csv(paste(folder, file_list[1], sep = ''), as.is = TRUE)
    
    if (length(removed) >= 1) {
        file_name = file_name[-removed,]
    }
    colnames(file_name)[1] <- "Rank"
    colnames(file_name)[2] <- "Player"
    colnames(file_name)[3] <- "Salary"
    
    file_name[, 1] <- as.numeric(file_name[, 1])
    file_name[, 3] <-
        sapply(str_split(file_name[, 3], "[$]"), "[[", 2)
    file_name[, 3] <- gsub(",", "", file_name[, 3])
    file_name[, 3] <- as.numeric(file_name[, 3])
    
    
    write.csv(
        file_name,
        file = paste0('../../cleandata/clean-salary-data/', f_name[i] , ".csv"),
        row.names = FALSE
    )
    
    
}