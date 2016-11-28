library(shiny)
library(ggplot2)

# Set working directory to the current directory
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
# Get the team-salaries table
salary_data = read.csv(file = "../../data/cleandata/team-salaries.csv")

function(input, output) {
  
  selectedOrder <- reactive({
    input$order
  })
  
  plotObj <- reactive({
    
    if (selectedOrder() == "asc") {
      p = ggplot(
            salary_data, 
            aes(
                reorder(
                    x = Team, 
                    -salary_data[,input$var]), 
                y = salary_data[,input$var], 
                fill=Team)) +
        geom_bar(stat='identity') + coord_flip() +
        labs(
            x = "Team", 
            y = paste(input$var, "(US Dollars)"), 
            title = paste("Salary", input$var, "by Team"))
    } else {
      p = ggplot(
            salary_data, 
            aes(
                reorder(
                    x = Team, 
                    salary_data[,input$var]), 
                y = salary_data[,input$var], 
                fill=Team)) +
        geom_bar(stat='identity') + coord_flip() +
        labs(
            x = "Team", 
            y = paste(input$var, "(US Dollars)"), 
            title = paste("Salary", input$var, "by Team"))
    }
  })
  
  
  
  output$plot1 <- renderPlot({
    print(plotObj())
  })
  
}