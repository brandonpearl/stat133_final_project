library(dplyr)

setwd("C:/Users/Nicolas Min/Desktop/stat133_final_project/project/data/cleandata")
eff_salary_data = read.csv(file = "eff-salary-stats_dummy.csv", sep = ",")

#Entire List of players in order of their values
rank_value <- eff_salary_data %>%
  mutate (value = EFF/salary) %>%
  arrange (value) %>%
  select (player)

#Extracting only the top 20 and bottom 20 players
best <- head(rank_value, 20)
worst <- tail(rank_value, 20)
best_worst <- rbind (best, worst)

#Creating txt of the list of top20 & bottom20 players (WHAT TO CHOOSE???)
write.table(best_worst, "best-worst-value-players_dummy.txt", sep="\t")
write.table(best_worst, "best-worst-value-players_dummy.txt", sep=",")

