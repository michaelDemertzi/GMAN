library(dplyr)
library(ggplot2)
library(shiny)
library(gridExtra)
library(grid)
library(scales)
library(extrafont)
library(networkD3)
library(choroplethr)

source('dataRead.R')
source('choroData.R')
source('sankeyData.R')
source('lineData.R')

source('lineOutput.R')
source('choroOutput.R')
source('sankeyOutput.R')



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
             ),
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
                        mainPanel(plotOutput("choropleth"))
                      )         
             )
  )
)
