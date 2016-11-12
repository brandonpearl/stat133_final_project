library(dplyr)
library(rstudioapi)

# Set working directory to the current directory
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

team_data <- read.csv(file = "../../data/cleandata/roster-salary-stats.csv"
                      , sep = ",")

salary_aggregates <- team_data %>% group_by(Team) %>% select(Salary, Team) %>% 
  summarise(total = sum(Salary, na.rm = TRUE), 
            minimum = min(Salary, na.rm = TRUE),
            maximum = max(Salary, na.rm = TRUE), 
            first_quartile = quantile(Salary, .25, na.rm = TRUE), 
            median = median(Salary, na.rm = TRUE), 
            third_quartile = quantile(Salary, .75, na.rm = TRUE), 
            average = mean(Salary, na.rm = TRUE),
            interquartile_range = IQR(Salary, na.rm = TRUE), 
            standard_deviation = sd(Salary, na.rm = TRUE))


write.csv(salary_aggregates, file = "../../data/cleandata/team-salaries.csv", 
          row.names = FALSE)
