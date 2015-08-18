library(dplyr)
library(ggplot2)
library(shiny)
library(gridExtra)
library(grid)
library(scales)
library(extrafont)
library(networkD3)

source('app/dataRead.R')
source('app/choroData.R')
source('app/sankeyData.R')
source('app/lineData.R')

source('app/lineOutput.R')
source('app/choroOutput.R')
source('app/sankeyOutput.R')

ui <- fluidPage(
  navbarPage('Shiny Application',

             tabPanel('Sankey',
                      titlePanel('Contributor and Legislator Relationship'),
                      sidebarLayout(
                        sidebarPanel(selectInput('billSankey', 'Select a Congressional Bill',
                                                 choices = unique(levels(sankeyDataTopSupport$bill)),
                                                 selected = unique(levels(sankeyDataTopSupport$bill)[1]))),
                        mainPanel(sankeyNetworkOutput("sankeyPlot"))
                      )         
             )
  )
)

server <- function(input, output) {
  

  output$sankeyPlot <- renderSankeyNetwork({sankeyOutputBill(input$billSankey)})
}
shinyApp(ui, server)
