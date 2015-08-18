library(dplyr)
library(ggplot2)
library(shiny)
library(gridExtra)
library(grid)
library(scales)
library(extrafont)
library(networkD3)
library(choroplethr)
library(choroplethrMaps)

source('dataRead.R')
source('choroData.R')
source('choroDataPosition.R')
source('sankeyData.R')
source('lineData.R')

source('lineOutput.R')
source('choroOutput.R')
source('sankeyOutput.R')
source('choroOutputPosition.R')

ui <- fluidPage(
  navbarPage('What is in Your Wallet?',

             tabPanel('Dollar Flows',
                      titlePanel('Contributor and Legislator Relationship'),
                      sidebarLayout(
                        sidebarPanel(selectInput('billSankey', 'Select a Congressional Bill',
                                                 choices = unique(levels(sankeyDataTopSupport$bill)),
                                                 selected = unique(levels(sankeyDataTopSupport$bill)[1]))),
                        mainPanel(sankeyNetworkOutput("sankeyPlot"))
                      )         
             ),
             tabPanel('Dollar Timing',
                      titlePanel('Contributions by Date and Vote'),
                      sidebarLayout(
                        sidebarPanel(selectInput('billLine', 'Select a Congressional Bill',
                                                 choices = unique(levels(lineData$bill)),
                                                 selected = unique(levels(lineData$bill)[1]))),
                        mainPanel(plotOutput('line'))
                      )
             ), 
             tabPanel('Dollar Map',
                      titlePanel('Contributions by State'),
                      sidebarLayout(
                        sidebarPanel(selectInput('billChoro', 'Select a Congressional Bill',
                                                 choices = unique(levels(choroData$bill)),
                                                 selected = unique(levels(choroData$bill)[1]))),
                        mainPanel(plotOutput("choropleth"))
                      )         
             ),
             tabPanel('Dollar Map and Position',
                      titlePanel('Contributions by State and Contributor Position'),
                      sidebarLayout(
                        sidebarPanel(selectInput('billChoroPosition', 'Select a Congressional Bill',
                                                 choices = unique(levels(choroData$bill)),
                                                 selected = unique(levels(choroData$bill)[1]))),
                        mainPanel(
    div(class="span6", plotOutput("choroplethPositionSupport")),
    div(class="span6", plotOutput("choroplethPositionOppose")))
                      )         
             )
  )
)
