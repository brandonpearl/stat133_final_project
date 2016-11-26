library(shiny)
library(ggplot2)

# Set working directory to the current directory
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
# Get the team-salaries table
salary_data = read.csv(file = "../../data/cleandata/eff-stats-salary.csv")
total_data = read.csv(file = "../../data/cleandata/roster-salary-stats.csv")
merge_data = merge(salary_data, total_data)

function(input, output) {
  
  selectedColor <- reactive({
    input$color_by
  })
  
  showRegression <- reactive({
    input$regression_by
  })
  
  plotObj <- reactive({
    if (selectedColor() == "team") {
      p = ggplot(merge_data, aes(x = merge_data[,input$x_var], 
                                 y = merge_data[,input$y_var], 
                                 colour = Team)) + geom_point()
        
    } else {
      p = ggplot(merge_data, aes(x = merge_data[,input$x_var], 
                                 y = merge_data[,input$y_var], 
                                 colour = Position)) + geom_point()
    }
    
    if (showRegression() == TRUE) {
      p = p + geom_smooth(method = "lm", se = FALSE)
    }
    p = p + labs(x = input$x_var, y = input$y_var, 
                 title = paste(input$x_var, "vs", input$y_var))
  })
  
  output$plot1 <- renderPlot({
    print(plotObj())
  })
  
  output$correlation <- renderText({
    if (is.numeric(merge_data[,input$x_var]) && merge_data[,input$y_var]) {
      paste("Correlation:", 
            cor(merge_data[,input$x_var], merge_data[,input$y_var], 
                use = 'pairwise.complete.obs'))
    }
  })
  
}