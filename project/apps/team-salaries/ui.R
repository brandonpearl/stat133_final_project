library(shiny)

# Set working directory to the current directory
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
# Get the team-salaries table
salary_data = read.csv(file = "../../data/cleandata/team-salaries.csv")

fluidPage(
  headerPanel('Salary Statistics by Team'),
  sidebarPanel(
    selectInput('var', 'Variable', names(salary_data)[2:10], selected = names(salary_data)[2]),
    radioButtons("order", label = "Order", 
                 choices = c("Ascending" = "asc", "Descending" = "desc"),
                 selected = "asc")
  ),
  mainPanel(
    plotOutput('plot1')
  )
)