library(shiny)

# Set working directory to the current directory
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
# Get the team-salaries table
salary_data = read.csv(file = "../../data/cleandata/eff-stats-salary.csv")
total_data = read.csv(file = "../../data/cleandata/roster-salary-stats.csv")
merge_data = merge(salary_data, total_data)
fluidPage(
  headerPanel('Salary Statistics by Team'),
  sidebarPanel(
    selectInput(
        'x_var', 
        'X Variable', 
        names(merge_data)[c(2:9, 11:13, 17, 18, 21, 23:29, 36:43)], 
        selected = names(merge_data)[13]),
    selectInput(
        'y_var', 
        'Y Variable', 
        names(merge_data)[c(2:9, 11:13, 17, 18, 21, 23:29, 36:43)], 
        selected = names(merge_data)[13]),
    radioButtons("color_by", label = "Color", 
                 choices = c("Team" = "team", "Position" = "position"),
                 selected = "team"),
    checkboxInput("regression_by", 
                  label = "Show Regression Line", 
                  value = FALSE),
    textOutput("correlation")
  ),
  mainPanel(
    plotOutput("plot1")
  )
)