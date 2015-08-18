library(dplyr)
library(ggplot2)
library(shiny)
library(gridExtra)
library(grid)
library(scales)
library(extrafont)
library(networkD3)

source('dataRead.R')
source('choroData.R')
source('app/sankeyData.R')
source('lineData.R')

source('lineOutput.R')
source('choroOutput.R')
source('app/sankeyOutput.R')

ui <- fluidPage(
  navbarPage('Shiny Application',

             tabPanel('Sankey',
                      titlePanel('Contributor and Legislator Relationship'),
                      sidebarLayout(
                        sidebarPanel(selectInput('billSankey', 'Select a Congressional Bill',
                                                 choices = unique(levels(sankeyDataTopSupport$bill)),
                                                 selected = unique(levels(sankeyDataTopSupport$bill)[1]))),
                        mainPanel(sankeyNetworkOutput(sankeyPlot))
                      )         
             )
  )
)

server <- function(input, output) {
  

  output$sankeyPlot <- renderSankeyNetwork({sankeyOutputBill("Food Safety Labeling Act")})
}
shinyApp(ui, server)
