library(dplyr)
library(ggplot2)
library(shiny)
library(gridExtra)
library(grid)
library(scales)
library(extrafont)


ui <- fluidPage(
  navbarPage('Shiny Application',
             tabPanel('Line Plot',
                      titlePanel('Contributions by Date and Vote'),
                      sidebarLayout(
                        sidebarPanel(selectInput('billLine', 'Select a Congressional Bill',
                                                 choices = unique(levels(lineData$bill)),
                                                 selected = unique(levels(lineData$bill)[1]))),
                        mainPanel(plotOutput('line'))
                      )
             ),
             tabPanel('Choropleth',
                      titlePanel('Contributions by State'),
                      sidebarLayout(
                        sidebarPanel(selectInput('billChoro', 'Select a Congressional Bill',
                                                 choices = unique(levels(choroData$bill)),
                                                 selected = unique(levels(choroData$bill)[1]))),
                        mainPanel(textOutput('choro'))
                      )
             ),
             tabPanel('Sankey',
                      titlePanel('Contributor and Legislator Relationship'),
                      sidebarLayout(
                        sidebarPanel(selectInput('billSankey', 'Select a Congressional Bill',
                                                 choices = unique(levels(sankeyData$bill)),
                                                 selected = unique(levels(sankeyData$bill)[1]))),
                        mainPanel(includeHTML('www/sankeyPlot/index.html'))
                      )         
             )
  )
)