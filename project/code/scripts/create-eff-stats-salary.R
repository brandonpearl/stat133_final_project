library(dplyr)

# Load data file, "roster-salary-stats.csv".
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
team_data <- read.csv(file = "../../data/cleandata/roster-salary-stats.csv",
                      sep = ",")

# Subset data for position 'PG' (point guard)
# and add columns, "Missed_Field_Goals", "Missed_Free_Throws", and "Turnovers"
# (these variables have negative sign)

c <- team_data %>%
  filter(Position == 'C') %>%
  mutate(Missed_Free_Throws = Free_Throws - Free_Throw_Attempts) %>%
  mutate(Missed_Field_Goals = Field_Goals - Field_Goal_Attempts) %>%
  mutate(Turnovers = -1 * Turnovers)

pf <- team_data %>%
  filter(Position == 'PF') %>%
  mutate(Missed_Free_Throws = Free_Throws - Free_Throw_Attempts) %>%
  mutate(Missed_Field_Goals = Field_Goals - Field_Goal_Attempts) %>%
  mutate(Turnovers = -1 * Turnovers)

pg <- team_data %>%
  filter(Position == 'PG') %>%
  mutate(Missed_Free_Throws = Free_Throws - Free_Throw_Attempts) %>%
  mutate(Missed_Field_Goals = Field_Goals - Field_Goal_Attempts) %>%
  mutate(Turnovers = -1 * Turnovers)

sf <- team_data %>%
  filter(Position == 'SF') %>%
  mutate(Missed_Free_Throws = Free_Throws - Free_Throw_Attempts) %>%
  mutate(Missed_Field_Goals = Field_Goals - Field_Goal_Attempts) %>%
  mutate(Turnovers = -1 * Turnovers)

sg <- team_data %>%
  filter(Position == 'SG') %>%
  mutate(Missed_Free_Throws = Free_Throws - Free_Throw_Attempts) %>%
  mutate(Missed_Field_Goals = Field_Goals - Field_Goal_Attempts) %>%
  mutate(Turnovers = -1 * Turnovers)

# Statistics for efficiency
stats <- c('Points', 'Total_Rebounds', 'Assists', 'Steals', 'Blocks', 'Missed_Field_Goals',
           'Missed_Free_Throws', 'Turnovers')

# All variables are divided by number of games
X1 <- as.matrix(c[ ,stats] / c$Games)
print(round(cor(X1), 2), print.gap = 2)

X2 <- as.matrix(pf[ ,stats] / pf$Games)
print(round(cor(X2), 2), print.gap = 2)

X3 <- as.matrix(pg[ ,stats] / pg$Games)
print(round(cor(X3), 2), print.gap = 2)

X4 <- as.matrix(sf[ ,stats] / sf$Games)
print(round(cor(X4), 2), print.gap = 2)

X5 <- as.matrix(sg[ ,stats] / sg$Games)
print(round(cor(X5), 2), print.gap = 2)


# PCA with prcomp()
c_pca <- prcomp(X1, center = TRUE, scale. = TRUE)
c_weights <- c_pca$rotation[,1]

pf_pca <- prcomp(X2, center = TRUE, scale. = TRUE)
pf_weights <- pf_pca$rotation[,1]

pg_pca <- prcomp(X3, center = TRUE, scale. = TRUE)
pg_weights <- pg_pca$rotation[,1]

sf_pca <- prcomp(X4, center = TRUE, scale. = TRUE)
sf_weights <- sf_pca$rotation[,1]

sg_pca <- prcomp(X5, center = TRUE, scale. = TRUE)
sg_weights <- sg_pca$rotation[,1]

# Std deviations for each columns
c_sigmas <- apply(X1, 2, sd)
pf_sigmas <- apply(X2, 2, sd)
pg_sigmas <- apply(X3, 2, sd)
sf_sigmas <- apply(X4, 2, sd)
sg_sigmas <- apply(X5, 2, sd)

# Modified efficiency
c_eff <- X1 %*% (c_weights / c_sigmas)
pf_eff <- X2 %*% (pf_weights / pf_sigmas)
pg_eff <- X3 %*% (pg_weights / pg_sigmas)
sf_eff <- X4 %*% (sf_weights / sf_sigmas)
sg_eff <- X5 %*% (sg_weights / sg_sigmas)

c$EFF <- c_eff
pf$EFF <- pf_eff
pg$EFF <- pg_eff
sf$EFF <- sf_eff
sg$EFF <- sg_eff

# Create data set "eff-stats-salary.csv" 

# Modify team_data
team_data_modified <- rbind(c, pf, pg, sf, sg)

# Create a new table by selecting columns from team_data_modified
eff_stats_salary <- team_data_modified %>% 
  select (Player, Points, Total_Rebounds, Assists, Steals, Blocks, Missed_Field_Goals, 
          Missed_Free_Throws, Turnovers, Games, EFF, Salary)

#======================================================================================
# NOW, COLUMNS, "MISSED_FREE_THROWS", "MISSED_FIELD_GOALS", "TURNOVERS" ARE NEGATIVE,
# SO I TRIED THE CODE BELOW TO MAKE THEM POSITIVE.
# HOWEVER, THE CODE BELOW GIVES AN ERROR:
# Error: Each variable must be a 1d atomic vector or list. Problem variables: 'EFF'

# eff_stats_salary <- team_data_modified %>% 
#   select (Player, Points, Total_Rebounds, Assists, Steals, Blocks, Missed_Field_Goals, 
#           Missed_Free_Throws, Turnovers, Games, EFF, Salary) %>%
#   mutate(Missed_Free_Throws = -1 * Missed_Free_Throws) %>%
#   mutate(Missed_Field_Goals = -1 * Missed_Field_Goals) %>%
#   mutate(Turnovers = -1 * Turnovers)

# ALSO, NOT SURE HOW TO DO FOR LOOPS...
#=======================================================================================

# Write data set, "eff-stats-salary.csv" 
write.csv(eff_stats_salary, file = "../../data/cleandata/eff-stats-salary.csv")

