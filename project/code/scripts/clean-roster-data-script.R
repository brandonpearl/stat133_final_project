
library(stringr)

# Set current working directory to the one containing clean-data-scripts.R
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
setwd("../../data/rawdata/roster-data")
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
    #ncol(file_name)
    file_name = read.csv(paste(paste0(folder,"/"), file_list[k], sep = ''), as.is = TRUE)
    
    # change the variable name/col name
    colnames(file_name)[7] <- "roster.Country"
    colnames(file_name)[6] <- "roster.Birth Date"
    col_names <-
        sapply(str_split(colnames(file_name), "[.]"), "[[", 2)
    colnames(file_name) <- col_names
    index = c(1, 3, 4, 5, 8)
    name = c("Number", "Position", "Height", "Weight", "Experience")
    for (i in 1:length(index)) {
        names(file_name)[index[i]] <- paste(name[i])
    }
    
    # remove position
    position_ls <- c("C", "PF", "SF", "SG", "PG")
    removed =  which(!file_name$Position %in% position_ls)
    if (length(removed) >= 1) {
        file_name = file_name[-removed, ]
    }
    file_name$Position = factor(file_name$Position)
    
    # change Number to numeric
    file_name[, 1] <- as.numeric(file_name[, 1])
    
    # Clean Country column ( change to upper case)
    file_name[, 7] <- toupper(file_name[, 7])
    
    # Clean the Experience Column
    file_name[, 8][which(file_name$Experience == "R")] <- "0"
    file_name[, 8] <- as.numeric(file_name[, 8])
    
    # Clean the Height Column
    ft = sapply(str_split(file_name$Height, "-"), "[[", 1)
    inches = sapply(str_split(file_name$Height, "-"), "[[", 2)
    file_name$Height = round(as.numeric(paste0(ft, ".", inches)) * 0.3048, digits = 2)
    
    # Clean the weight column
    file_name[, 5] = round(as.numeric(file_name[, 5] * 0.453592), digits = 2)
    # Clean the Birth Date column
    year <- sapply(str_split(file_name$"Birth Date", ","), "[[", 2)
    temp <- sapply(str_split(file_name$"Birth Date", ","), "[[", 1)
    month <- str_trim(str_extract(temp, "\\D+"))
    day <- str_trim(str_extract(temp, "\\d+"))
    
    
    num2Month <- function(x) {
        months <- c(
            january = 1,
            february = 2,
            march = 3,
            april = 4,
            may = 5,
            june = 6,
            july = 7,
            august = 8,
            september = 9,
            october = 10,
            november = 11,
            december = 12
        )
        x <- tolower(x)
        month_new = lapply(x, function(x)
            months[x])
        month_new = as.numeric(unlist(month_new))
    }
    
    month = as.character(num2Month(month))
    file_name$"Birth Date" = as.Date(paste(year, month, day, sep = "-"),
                                     format = "%Y-%m-%d")
    
    # Clean the College Column
    file_name[, 9][which(file_name$College == "")] <- NA
    
    file_name$Team <- rep(f_name[i], time = nrow(file_name))
    
    write.csv(
        file_name,
        file = paste0('../../cleandata/clean-roster-data/', f_name[k] , ".csv"),
        row.names = FALSE
    )
    
    
}