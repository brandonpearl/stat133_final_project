# clean-data-script oster-salary-stats.csv
library(stringr)

setwd("~/Documents/stat133_final_project/project/data/rawdata/roster-data")
folder <-
    "~/Documents/stat133_final_project/project/data/rawdata/roster-data/"
file_list <- list.files(path = folder, pattern = "*.csv")

roster_stat_salary = data.frame()

for (k in 1:5) {
    setwd("~/Documents/stat133_final_project/project/data/rawdata/roster-data")
    folder <-
        "~/Documents/stat133_final_project/project/data/rawdata/roster-data/"
    #read roster_file
    
    roster_file = read.csv(paste(folder, file_list[k], sep = ''),
                           as.is = TRUE,
                           row.names = NULL)
    
    # change the variable name/col name
    colnames(roster_file)[7] <- "roster.Country"
    colnames(roster_file)[6] <- "roster.Birth Date"
    col_names <-
        sapply(str_split(colnames(roster_file), "[.]"), "[[", 2)
    colnames(roster_file) <- col_names
    index = c(1, 3, 4, 5, 8)
    name = c("Number", "Position", "Height", "Weight", "Experience")
    for (i in 1:length(index)) {
        names(roster_file)[index[i]] <- paste(name[i])
    }
    
    # remove position
    position_ls <- c("C", "PF", "SF", "SG", "PG")
    removed =  which(!roster_file$Position %in% position_ls)
    if (length(removed) >= 1) {
        roster_file =  roster_file[-removed, ]
    }
    roster_file$Position = factor(roster_file$Position)
    
    # change Number to numeric
    roster_file[, 1] <- as.numeric(roster_file[, 1])
    
    # Clean Country column ( change to upper case)
    roster_file[, 7] <- toupper(roster_file[, 7])
    
    # Clean the Experience Column
    invalid_R = which(roster_file$Experience == "R")
    if (length(invalid_R >= 1)) {
        roster_file[, 8][which(roster_file$Experience == "R")] <- "0"
    }
    
    roster_file[, 8] <- as.numeric(roster_file[, 8])
    
    # Clean the Height Column
    ft = sapply(str_split(roster_file$Height, "-"), "[[", 1)
    inches = sapply(str_split(roster_file$Height, "-"), "[[", 2)
    roster_file$Height = round(as.numeric(paste0(ft, ".", inches)) * 0.3048, digits = 2)
    
    # Clean the weight column
    roster_file[, 5] = round(as.numeric(roster_file[, 5] * 0.453592), digits = 2)
    # Clean the Birth Date column
    year <-
        sapply(str_split(roster_file$"Birth Date", ","), "[[", 2)
    temp <-
        sapply(str_split(roster_file$"Birth Date", ","), "[[", 1)
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
    roster_file$"Birth Date" = as.Date(paste(year, month, day, sep = "-"),
                                       format = "%Y-%m-%d")
    
    # Clean the College Column
    roster_file[, 9][which(roster_file$College == "")] <- NA
    str(roster_file)
    
    
    
    
    # clean stats-data
    setwd("~/Documents/stat133_final_project/project/data/rawdata/stat-data")
    folder <-
        "~/Documents/stat133_final_project/project/data/rawdata/stat-data/"
    
    stat_file = read.csv(paste(folder, file_list[k], sep = ''), as.is = TRUE)
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
    colnames(stat_file) <- col_names
    
    #remove the one whose position is not one of the 5 required positions
    if (length(removed) >= 1) {
        stat_file = stat_file[-removed,]
    }
    
    stat_file[, 1] <- as.numeric(stat_file[, 1])
    
    for (i in 3:ncol(stat_file)) {
        index = which(is.na(stat_file[, i]))
        if (length(index) >= 1) {
            stat_file[, i][which(is.na(stat_file[, i]))] <-  NA
        }
        stat_file[, i] = as.numeric(stat_file[, i])
        
    }
    str(stat_file)
    
    
    # clean salary-data
    setwd("~/Documents/stat133_final_project/project/data/rawdata/salary-data")
    folder <-
        "~/Documents/stat133_final_project/project/data/rawdata/salary-data/"
    
    salary_file = read.csv(paste(folder, file_list[k], sep = ''), as.is = TRUE)
    
    if (length(removed) >= 1) {
        salary_file = salary_file[-removed,]
    }
    
    colnames(salary_file)[1] <- "Rank"
    colnames(salary_file)[2] <- "Player"
    colnames(salary_file)[3] <- "Salary"
    
    salary_file[, 1] <- as.numeric(salary_file[, 1])
    salary_file[, 3] <-
        sapply(str_split(salary_file[, 3], "[$]"), "[[", 2)
    salary_file[, 3] <- gsub(",", "", salary_file[, 3])
    salary_file[, 3] <- as.numeric(salary_file[, 3])
    str(salary_file)
    
    temp = data.frame()
    temp = merge(
        x = roster_file,
        y = stat_file,
        z = salary_file,
        by = "Player",
        all = TRUE
    )
    roster_stat_salary = rbind(roster_stat_salary, temp)
    
    write.csv(
        file_name,
        file = paste0('../../cleandata/', "roster_stat_salary" , ".csv"),
        row.names = FALSE
    )
    
    
}