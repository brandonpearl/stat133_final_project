library(dplyr)
setwd("C:/Users/Ryan/Desktop/final_proj_133/stat133_final_project/project")

team_data = read.csv(file = "data/cleandata/roster-salary-stats.csv"
                     , sep = ",")

salary_aggregates = team_data %>% group_by(Team) %>% select(salary, Team) %>% 
  summarise(total = sum(salary), minimum = min(salary), maximum = max(salary), 
            first_quartile = quantile(salary, .25), median = median(salary), 
            third_quartile = quantile(salary, .75), average = mean(salary),
            iqr = IQR(salary), standard_deviation = sd(salary))
  

write.csv(salary_aggregates, file = "data/cleandata/team-salaries.csv")
