library(shiny)
salary_data = read.csv(file = "C:/Users/Ryan/Desktop/final_proj_133/downloads/data/cleandata/team-salaries.csv")

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