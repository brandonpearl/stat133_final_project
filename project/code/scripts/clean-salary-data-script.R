setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
setwd("../../data/rawdata/salary-data")
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
 
    file_name = read.csv(paste( paste0(folder,"/"), file_list[k], sep = ''), as.is = TRUE)
    
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
    
    file_name$Team <- rep(f_name[i], time = nrow(file_name))
    
    
    write.csv(
        file_name,
        file = paste0('../../cleandata/clean-salary-data/', f_name[k] , ".csv"),
        row.names = FALSE
    )
    

    
}