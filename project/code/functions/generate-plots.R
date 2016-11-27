# This script is used to generate graph histograms and boxplots
# for quantitative variables (e.g. salary, games played, free throws, etc) 
# and graph barcharts of their frequencies for qualitative variables 
# (e.g. position, team)

# generate the qualitative variable ( variable on x and frequency on y)
library(ggplot2)
# set current directory to the one that contains this script

create_plot_graphs <- function(data, text_fields){
    if (class(full_player_table) != "data.frame" ||
        class(text_fields) != "character") {
        stop("Please check input types to 'create_summary_file'.")
    }
# generating the plot of qualitative variables 
col_number = c(1,2,4,8,10)
for (idx in col_number){
    data[,idx][which(is.na(data[,idx]))] <-  "NA" 
}

data$College = abbreviate(
    data$College,
    minlength = 4,
    use.classes = TRUE,
    dot = FALSE,
    strict = FALSE,
    method = c("left.kept")
)

setwd("../../images")
# use switch to generate aes in ggplot according to each variable
for (field in text_fields) {
    switch(field, 
           Player = {
               aes = aes(x = Player)
           },
           Team = {
               aes = aes(x = Team)
           },
           Position = {
               aes = aes(x = Position)
           },
           Country = {
               aes = aes(x = Country)
           },
           College = {
               aes = aes(x = College)
           }
    )
    
    # generate ggplot 
    p <- ggplot(data, aes) + geom_bar()
    # label the y axis 
    p <- p + ylab("Frequency")
    # change the color of the bar 
    p <- p + geom_bar( fill="#00BFC4", colour="black")
    # modify the title and label of x and y axis in terms of font, size, etc
    p <- p + theme(axis.text.x = element_text(face = "bold", size = rel(1.1)))
    p <- p + theme(axis.text.y = element_text(face = "bold", size = rel(1.1)))
    p <- p + theme(axis.title.x = element_text(size = 12, face = "bold"))
    p <- p + theme(axis.title.y = element_text(size = 12, face = "bold"))
    p <- p + ggtitle(paste("Frequency of", noquote(field))) +
        theme(plot.title = element_text(size = rel(1.2), face = "bold"))
    # save plot in png format to file images 
    png(filename = paste0(noquote(field),".png"),  width=800, height=500)
    plot(p)
    dev.off()
}

}
# generate the quantitative variable
create_box_histogram <- function(player_data, text_fields){
    # checking inputs
    if (class(full_player_table) != "data.frame" ||
        class(text_fields) != "character") {
        stop("Please check input types to 'create_summary_file'.")
    }
    # modify the Birth.Date columns
player_data$Birth.Date = sapply(str_split(player_data$Birth.Date, "-"), "[[", 1)
number_cols <- names(player_data[, !names(player_data) %in% text_fields])
setwd("../../images")
# loop through all quantitative variable in roster-salary-stats data frame
for (field in number_cols) {
    freq <- player_data %>%
        dplyr::select_(field) %>%
        dplyr::group_by_(field) %>%
        dplyr::count() %>%
        dplyr::arrange()
    
    freq = as.data.frame(freq)
# boxplot for quantitative variables    
    switch( field,
          Number = {
              aes = aes(x = Number ,y = n)
              aes1 = aes( x = Number)
              
          },
          Weight = { 
              aes = aes(x = Weight ,y = n)
              aes1 = aes( x = Weight)
              
          },
          Experience = {
              aes = aes(x = Experience ,y = n)
              aes1 = aes( x = Experience)
              
          },
          Age = {
              aes = aes(x = Age ,y = n)
              aes1 = aes( x = Age)
          },
          Games_Started = {
              aes = aes(x = Games_Started ,y = n)
              aes1 = aes( x = Games_Started)
              
          },
          Field_Goals =  {
              aes = aes(x = Field_Goals ,y = n)
              aes1 = aes( x = Field_Goals)
              
          },
          Field_Goal_Percentage ={
              aes = aes(x = Field_Goal_Percentage ,y = n)
              aes1 = aes( x = Field_Goal_Percentage)
              
          },
          X3.Point_Field_Goal_Attempts = {
              aes = aes(x = X3.Point_Field_Goal_Attempts ,y = n)
              aes1 = aes( x = X3.Point_Field_Goal_Attempts)
              
          },
          X2.Point_Field_Goals = {
              aes = aes(x = X2.Point_Field_Goals ,y = n)
              aes1 = aes( x = X2.Point_Field_Goals)
              
          },
          X2.Point_Field_Goal_Percentage = {
              aes = aes(x = X2.Point_Field_Goal_Percentage ,y = n)
              aes1 = aes( x = X2.Point_Field_Goal_Percentage)
              
          },
          Free_Throws = {
              aes = aes(x = Free_Throws ,y = n)
              aes1 = aes( x = Free_Throws)
              
          },
          Free_Throw_Percentage = {
              aes = aes(x = Free_Throw_Percentage ,y = n)
              aes1 = aes( x = Free_Throw_Percentage)
              
          },
          Defensive_Rebounds = {
              aes = aes(x = Defensive_Rebounds ,y = n)
              aes1 = aes( x = Defensive_Rebounds)
              
          },
          Assists = {
              aes = aes(x = Assists ,y = n)
              aes1 = aes( x = Assists)
              
          },
          Blocks = {
              aes = aes(x = Blocks ,y = n)
              aes1 = aes( x = Blocks)
              
          },
          Personal.Fouls = {
              aes = aes(x = Personal.Fouls ,y = n)
              aes1 = aes( x = Personal.Fouls)
              
          },
          Rank_Salary = {
              aes = aes(x = Rank_Salary ,y = n)
              aes1 = aes( x = Rank_Salary)
              
          },
          Height = {
              aes = aes(x = Height ,y = n)
              aes1 = aes( x = Height)
              
          },
          Birth.Date = {
              aes = aes(x = Birth.Date ,y = n)
              aes1 = aes( x = Birth.Date)
              
          },
          Rank_Totals = {
              aes = aes(x = Rank_Totals ,y = n)
              aes1 = aes( x = Rank_Totals)
              
          },
          Games = {
              aes = aes(x = Games ,y = n)
              aes1 = aes( x = Games)
              
          },
          Minutes_Played = {
              aes = aes(x = Minutes_Played ,y = n)
              aes1 = aes( x = Minutes_Played)
              
          },
          Field_Goal_Attempts = {
              aes = aes(x = Field_Goal_Attempts ,y = n)
              aes1 = aes( x = Field_Goal_Attempts)
              
          },
          X3.Point_Field_Goals = {
              aes = aes(x = X3.Point_Field_Goals ,y = n)
              aes1 = aes( x = X3.Point_Field_Goals)
              
          },
          X3.Point_Field_Goal_Percentage = {
              aes = aes(x = X3.Point_Field_Goal_Percentage ,y = n)
              aes1 = aes( x = X3.Point_Field_Goal_Percentage)
              
          },
          X2.point_Field_Goal_Attempts = {
              aes = aes(x = X2.point_Field_Goal_Attempts ,y = n)
              aes1 = aes( x = X2.point_Field_Goal_Attempts)
              
          },
          Effective_Field_Goal_Percentage = {
              aes = aes(x = Effective_Field_Goal_Percentage ,y = n)
              aes1 = aes( x = Effective_Field_Goal_Percentage)
              
          },
          Free_Throw_Attempts = {
              aes = aes(x = Free_Throw_Attempts ,y = n)
              aes1 = aes( x = Free_Throw_Attempts)
              
          },
          Offensive_Rebounds = {
              aes = aes(x = Offensive_Rebounds ,y = n)
              aes1 = aes( x = Offensive_Rebounds)
              
          },
          Total_Rebounds = {
              aes = aes(x = Total_Rebounds ,y = n)
              aes1 = aes( x = Total_Rebounds)
              
          },
          Steals = {
              aes = aes(x = Steals ,y = n)
              aes1 = aes( x = Steals)
              
          },
          Turnovers = {
              aes = aes(x = Turnovers ,y = n)
              aes1 = aes( x = Turnovers)
              
          },
          Points = {
              aes = aes(x = Points ,y = n)
              aes1 = aes( x = Points)
              
          },
          Salary = {
              aes = aes(x = Salary ,y = n)
              aes1 = aes( x = Salary)
              
          }
    )

    # plotting box plot
    p <- ggplot(freq,aes ) + geom_boxplot()
    p <- p + ylab("Frequency")
    p <- p + theme(axis.text.x = element_text(face = "bold", size = rel(1.1)))
    p <- p + theme(axis.text.y = element_text(face = "bold", size = rel(1.1)))
    p <- p + theme(axis.title.x = element_text(size = 12, face = "bold"))
    p <- p + theme(axis.title.y = element_text(size = 12, face = "bold"))
    p <- p + ggtitle(paste("Frequency of", noquote(field))) +
        theme(plot.title = element_text(size = rel(1.2), face = "bold"))
    # save plot in png format to file images 
    png(filename = paste0(noquote(field),".png"),  width=800, height=500)
    plot(p)
   dev.off()
    
    # plotting histogram
    p_his <- ggplot(player_data, aes1) +
             geom_histogram(fill="#00BFC4", colour="black", size=.2)
    p_his <- p_his + ylab("Frequency")
    p_his <- p_his + theme(axis.text.x = element_text(face = "bold", size = rel(1.1)))
    p_his <- p_his + theme(axis.text.y = element_text(face = "bold", size = rel(1.1)))
    p_his <- p_his + theme(axis.title.x = element_text(size = 12, face = "bold"))
    p_his <- p_his + theme(axis.title.y = element_text(size = 12, face = "bold"))
    #p_his <- p_his + scale_x_continuous(breaks = seq(from = 0, to = 40, by = 2 ))
    png(filename = paste0(noquote(field),".png"),  width=800, height=500)
    plot(p_his)
    dev.off()
}

}