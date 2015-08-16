library(dplyr)
library(ggplot2)
library(shiny)
library(gridExtra)
library(grid)
library(scales)
library(extrafont)

source('dataRead.R')
source('choroData.R')
source('sankeyData.R')
source('lineData.R')

source('lineOutput.R')
source('choroOutput.R')
source('sankeyOutput.R')

server <- function(input, output) {
  # output$line <- renderPlot({
  #   plotData <- lineOutputBill(lineData, input$billLine)
  #   limits <- c(min(lineData$Contribution.Amount),
  #               max(lineData$Contribution.Amount))
  #   breaks <- seq(0, max(lineData$Contribution.Amount), 200000)
  #   p1 <- ggplot(filter(plotData, Vote == 'No'),
  #                       aes(x = Contribution.Date, y = Contribution.Amount)) +
  #     geom_line(size = 0.5, col = I('Sienna4')) +
  #     theme_bw() +
  #     ylab('No Vote') +
  #     theme(plot.margin = unit(c(1, 0, 0, 1), 'cm'),
  #           axis.title.y = element_text(vjust = 1),
  #           axis.title.x = element_blank()) +
  #     scale_y_continuous(labels = comma, limits = limits, breaks = breaks)
  #   p2 <- ggplot(filter(plotData, Vote == 'Yes'),
  #                aes(x = Contribution.Date, y = Contribution.Amount)) +
  #     geom_line(size = 0.5, col = I('Olivedrab4')) +
  #     theme_bw() +
  #     ylab('Yes Vote') +
  #     theme(plot.margin = unit(c(1, 0, 0, 1), 'cm'),
  #           axis.title.y = element_text(vjust = 1),
  #           axis.title.x = element_blank()) +
  #     scale_y_continuous(labels = comma, limits = limits, breaks = breaks)
  #   grid.arrange(p1, p2, ncol = 1)
  # })

  output$sankeyJSON <- reactive({
    as.character(sankeyOutputBill(input$billSankey))
  })   
  
  output$choroJSON <- reactive({
    as.character(choroOutputBill(choroData, input$billChoro))
  })
}
