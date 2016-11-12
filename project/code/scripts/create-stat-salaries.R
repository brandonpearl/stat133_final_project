library(dplyr)
setwd("C:/Users/Nicolas Min/Desktop/stat133_final_project/project/data/cleandata")

team_data = read.csv(file = "roster-salary-stats_dummy.csv"
                     , sep = ",")



#Computing Missed FG & Missed FT.
missed_fg <- team_data$FGA - team_data$FG
missed_ft <- team_data$FTA - team_data$FT

#Dividing variables PTS, REB, ... TO by PG.
PTS_new <- team_data$PTS/team_data$G
TRB_new <- team_data$TRB/team_data$G
AST_new <- team_data$AST/team_data$G
STL_new <- team_data$STL/team_data$G
BLK_new <- team_data$BLK/team_data$G
missed_fg_new <- -(missed_fg/team_data$G)
missed_ft_new <- -(missed_ft/team_data$G)
TOV_new <- -(team_data$TOV/team_data$G)


#Combining the new variables.
team_data_2 <- data.frame(PTS_new,
                          TRB_new,
                          AST_new,
                          STL_new,
                          BLK_new,
                          missed_fg_new,
                          missed_ft_new,
                          TOV_new,
                          position=team_data$position)

#positions = c("C", "PF", ""...)
#final_frame <- data.frame()
#for (i in 1:length(positions)) {
#  calc
#  calc
#  calc
#  final_frame <- rbind(final_frame, this_cal)
#}

#Subsetting the data frame according to positions.
C_subset <- filter(team_data_2, position=="C") %>% select(-position)
PF_subset <- filter(team_data_2, position=="PF") %>% select(-position)
SF_subset <- filter(team_data_2, position=="SF") %>% select(-position)
SG_subset <- filter(team_data_2, position=="SG") %>% select(-position)
PG_subset <- filter(team_data_2, position=="PG") %>% select(-position)

#Performing a PCA on each subset (scaled)
PCA_C <- prcomp(C_subset, center= TRUE, scale = TRUE)
PCA_PF <- prcomp(PF_subset, center= TRUE, scale = TRUE)
PCA_SF <- prcomp(SF_subset, center= TRUE, scale = TRUE)
PCA_SG <- prcomp(SG_subset, center= TRUE, scale = TRUE)
PCA_PG <- prcomp(PG_subset, center= TRUE, scale = TRUE)

#Re expressing PCA weights using (PC1/sd). 
PCA_C_2 <- (as.vector(PCA_C$rotation[,1]))/(PCA_C$sdev)
PCA_PF_2 <- (as.vector(PCA_PF$rotation[,1]))/(PCA_PF$sdev)
PCA_SF_2 <- (as.vector(PCA_SF$rotation[,1]))/(PCA_SF$sdev)
PCA_SG_2 <- (as.vector(PCA_SG$rotation[,1]))/(PCA_SG$sdev)
PCA_PG_2 <- (as.vector(PCA_PG$rotation[,1]))/(PCA_PG$sdev)

#EFFs of players in each position
EFF_C <- data.matrix(C_subset) %*% PCA_C_2  
EFF_PF <- data.matrix(PF_subset) %*% PCA_PF_2  
EFF_SF <- data.matrix(SF_subset) %*% PCA_SF_2  
EFF_SG <- data.matrix(SG_subset) %*% PCA_SG_2  
EFF_PG <- data.matrix(PG_subset) %*% PCA_PG_2  

#Data set "eff-stats-salary.csv" 

#Assigning Variables
EFF <- rbind(EFF_C, EFF_PF, EFF_PG, EFF_SF, EFF_SG)
TOV <- team_data$TOV
G <- team_data$G
salary <- team_data$salary

#Creating data set, putting variables together
eff_salary_stats <- team_data %>% 
  select(position, player, PTS, TRB, AST, STL, BLK) %>%
  mutate(missed_fg, missed_ft, TOV, G, salary) %>%
  
  #not necessary if the data is cleaned
  filter(grepl('C|PF|PG|SF|SG', position)) %>% 
  #not necessary if the data is cleaned
  filter(!grepl('F-C', position)) %>% 
  
  arrange(position) %>%
  
  mutate(EFF) %>%
  
  select(-position) %>%
  select(player, PTS, TRB, AST, STL, BLK, missed_fg, missed_ft, TOV, G,
         EFF, salary)

#Creating a new table in the directory 
write.csv(eff_salary_stats, file = "eff-salary-stats_dummy.csv")
