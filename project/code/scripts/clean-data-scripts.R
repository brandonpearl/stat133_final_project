# clean-data-script oster-salary-stats.csv
library(stringr)

# Set current working directory to the one containing clean-data-scripts.R
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
setwd("../../data/rawdata/roster-data")
folder <- getwd()

#folder = paste0(folder, "/")
file_list <-
    list.files(path = paste0(folder, "/"), pattern = "*.csv")
f_name = c()

# get the name of each team only
for (id in 1:length(file_list)) {
    name <- str_split(file_list[id], pattern = '')
    name <- unlist(name)
    name <- name[1:which(name == '.') - 1]
    f_name[id] <- paste0(name, collapse = '')
}

roster_salary_stats = data.frame()
removed = 0


for (k in 1:length(file_list)) {
     k = 25
    setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
    setwd("../../data/rawdata/roster-data")
    # setwd("../rawdata/roster-data")
    folder <- getwd()
    
    #read roster_file
    roster_file1 <- read.csv(
        paste(paste0(folder, "/"), file_list[k], sep = ''),
        as.is = TRUE,
        row.names = NULL,
        header = TRUE
    )
    
    roster_file <- clean_roster_helper(roster_file1)
    roster_file$Team <- rep(f_name[k], time = nrow(roster_file))
    
    str(roster_file)
    
    
    # clean stats-data
    setwd("../stat-data")
    folder <- getwd()
    
    stat_file = read.csv(paste(paste0(folder, "/"), file_list[k], sep = ''),
                         as.is = TRUE)
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
    colnames(stat_file) <- col_names
    
    #remove the one whose position is not one of the 5 required positions
    if (length(removed) >= 1) {
        stat_file = stat_file[-removed, ]
    }
    
    stat_file[, 1] <- as.numeric(stat_file[, 1])
    
    for (i in 3:ncol(stat_file)) {
        index = which(is.na(stat_file[, i]))
        if (length(index) >= 1) {
            stat_file[, i][which(is.na(stat_file[, i]))] <-  NA
        }
        stat_file[, i] = as.numeric(stat_file[, i])
        
    }
    stat_file$Team <- rep(f_name[k], time = nrow(stat_file))
    str(stat_file)
    
    
    # clean salary-data
    setwd("../salary-data")
    folder <- getwd()
    salary_file = read.csv(paste(paste0(folder, "/"), file_list[k], sep = ''),
                           as.is = TRUE)
    
    if (length(removed) >= 1) {
        salary_file = salary_file[-removed, ]
    }
    
    colnames(salary_file)[1] <- "Rank"
    colnames(salary_file)[2] <- "Player"
    colnames(salary_file)[3] <- "Salary"
    
    salary_file[, 1] <- as.numeric(salary_file[, 1])
    salary_file[, 3] <-
        sapply(str_split(salary_file[, 3], "[$]"), "[[", 2)
    salary_file[, 3] <- gsub(",", "", salary_file[, 3])
    salary_file[, 3] <- as.numeric(salary_file[, 3])
    salary_file$Team <- rep(f_name[k], time = nrow(salary_file))
    str(salary_file)
    
    temp = data.frame()
    temp = merge(
        x = roster_file,
        y = stat_file,
        by = c("Player", "Team"),
        all = TRUE
    )
    temp = merge(
        x = temp,
        y = salary_file,
        by = c("Player", "Team"),
        all = TRUE
    )
    roster_salary_stats = rbind(roster_salary_stats, temp)
    
}

colnames(roster_salary_stats)[11] <- "Rank_Totals"
colnames(roster_salary_stats)[38] <- "Rank_Salary"
dup_filter = !duplicated(roster_salary_stats$Player)
roster_salary_stats = roster_salary_stats[dup_filter, ]



write.csv(
    roster_salary_stats,
    file = paste0('../../cleandata/', "roster-salary-stats" , ".csv"),
    row.names = FALSE
)