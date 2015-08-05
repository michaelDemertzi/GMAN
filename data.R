library(dplyr)
library(ggplot2)
library(choroplethrZip)
library(choroplethrMaps)
library(mapproj)
library(shiny)
library(grid)
library(scales)
library(extrafont)

options(warn=-1)

data(zip.regions)
states <- read.csv('data/state_table.csv', stringsAsFactors = FALSE)

usaFreedom <- read.csv('data/usaFreedom.csv', stringsAsFactors = FALSE)
names(usaFreedom)[4] <- 'Vote'
names(usaFreedom)[14] <- 'Interest.Group.Position'
usaFreedom$bill <- 'USA Freedom Act'

keystone <- read.csv('data/keystone.csv', stringsAsFactors = FALSE)
names(keystone)[4] <- 'Vote'
names(keystone)[14] <- 'Interest.Group.Position'
keystone$bill <- 'Keystone Pipeline Approval Act'

smallBusinessBurden <- read.csv('data/smallBusinessBurden.csv', stringsAsFactors = FALSE)
names(smallBusinessBurden)[4] <- 'Vote'
names(smallBusinessBurden)[14] <- 'Interest.Group.Position'
smallBusinessBurden$bill <- 'Small Business Regulatory Flexibility Improvement Act'

foodSafety <- read.csv('data/foodsafety.csv', stringsAsFactors = FALSE)
names(foodSafety)[4] <- 'Vote'
names(foodSafety)[14] <- 'Interest.Group.Position'
foodSafety$bill <- 'Food Safety Labeling Act'

# ppDefunding <- read.csv('data/ppDefunding.csv', stringsAsFactors = FALSE)
# names(ppDefunding)[4] <- 'Vote'
# names(ppDefunding)[14] <- 'Interest.Group.Position'
# ppDefunding$bill <- 'Planned Parenthood Defunding Act'

studentSuccess <- read.csv('data/studentSuccess.csv', stringsAsFactors = FALSE)
names(studentSuccess)[4] <- 'Vote'
names(studentSuccess)[14] <- 'Interest.Group.Position'
studentSuccess$bill <- 'Student Success Act'

# marketPlaceFairness <- read.csv('data/marketPlaceFairness.csv', stringsAsFactors = FALSE)
# names(marketPlaceFairness)[4] <- 'Vote'
# names(marketPlaceFairness)[14] <- 'Interest.Group.Position'
# marketPlaceFairness$bill <- 'Market Place Fairness Act'

# allBills <- rbind(usaFreedom, keystone, smallBusinessBurden, ppDefunding,
#                   studentSuccess, marketPlaceFairness)

allBills <- rbind(usaFreedom, keystone, smallBusinessBurden,
                  foodSafety, studentSuccess)

allBills$bill <- as.factor(allBills$bill)
allBills$Party <- as.factor(allBills$Party)
allBills$Vote <- as.factor(allBills$Vote)
allBills$Contribution.Type <- as.factor(allBills$Contribution.Type)
allBills$Contribution.Date <- as.Date(allBills$Contribution.Date,
                                      format = '%m/%d/%Y', tz = '')
allBills$Interest.Group.Position <- as.factor(allBills$Interest.Group.Position)
allBills$Contributor.State <- as.factor(allBills$Contributor.State)

allBills$Contribution.Amount <- gsub('\\$', '', allBills$Contribution.Amount)
allBills$Contribution.Amount <- as.numeric(allBills$Contribution.Amount)

allBillsStateZip <- allBills %>%
  filter(!is.na(Contributor.State), !is.na(Contributor.Zip),
         Contributor.State %in% states$abbreviation,
         Contributor.Zip %in% zip.regions$region)
allBillsStateZip$Contributor.State <- factor(allBillsStateZip$Contributor.State)

allBillsStateAgg <- allBillsStateZip %>%
  group_by(bill, Contributor.State) %>%
  summarise(Contribution.Amount = sum(Contribution.Amount))

billsVoteDate <- allBills %>%
  group_by(bill, Vote, Contribution.Date) %>%
  summarise(Contribution.Amount = sum(Contribution.Amount))

ui <- fluidPage(
  navbarPage('Shiny Application',
             tabPanel('Main',
                      titlePanel('Contributions by Date and Vote'),
                      sidebarLayout(
                        sidebarPanel(selectInput('bill', 'Select a Congressional Bill',
                                                 choices = unique(levels(billsVoteDate$bill)),
                                                 selected = unique(levels(billsVoteDate$bill)[1]))),
                        mainPanel(plotOutput('line'))
                      )
             ),
             tabPanel('Documentation',
                      fluidPage(
                        sidebarLayout(
                          sidebarPanel(h3('Uage Guide')),
                          mainPanel(p('This app provides some stuff'))
                        )
                      )
             )
  )
)

server <- function(input, output) {
  output$line <- renderPlot({
    selectedData <- filter(billsVoteDate, bill == input$bill)
    limits <- c(min(billsVoteDate$Contribution.Amount),
                max(billsVoteDate$Contribution.Amount))
    breaks <- seq(0, max(billsVoteDate$Contribution.Amount), 200000)
    p1 <- ggplot(filter(selectedData, Vote == 'No'),
                        aes(x = Contribution.Date, y = Contribution.Amount)) +
      geom_line(size = 0.5, col = I('Sienna4')) +
      theme_bw() +
      ylab('No Vote') +
      theme(plot.margin = unit(c(1, 0, 0, 1), 'cm'),
            axis.title.y = element_text(vjust = 1),
            axis.title.x = element_blank()) +
      scale_y_continuous(labels = comma, limits = limits, breaks = breaks)
    p2 <- ggplot(filter(selectedData, Vote == 'Not Voting'),
                 aes(x = Contribution.Date, y = Contribution.Amount)) +
      geom_line(size = 0.5, col = I('Yellow4')) +
      theme_bw() +
      ylab('Not Voted') +
      theme(plot.margin = unit(c(1, 0, 0, 1), 'cm'),
            axis.title.y = element_text(vjust = 1),
            axis.title.x = element_blank()) +
      scale_y_continuous(labels = comma, limits = limits, breaks = breaks)
    p3 <- ggplot(filter(selectedData, Vote == 'Yes'),
                 aes(x = Contribution.Date, y = Contribution.Amount)) +
      geom_line(size = 0.5, col = I('Olivedrab4')) +
      theme_bw() +
      ylab('Yes Vote') +
      theme(plot.margin = unit(c(1, 0, 0, 1), 'cm'),
            axis.title.y = element_text(vjust = 1),
            axis.title.x = element_blank()) +
      scale_y_continuous(labels = comma, limits = limits, breaks = breaks)
    grid.arrange(p1, p2, p3, ncol = 1)
# #       ggtitle("Contributions by Date and Vote") +
# #       xlab("Date") +
#       theme(plot.margin = unit(c(2, 2, 2, 2), 'cm'),
#             title = element_text(size = 14, color = I('grey20'),
#                                  family = 'Helvetica', face = 'bold', vjust = 2),
#             axis.title.y = element_blank(),
#             axis.title.x = element_text(vjust = -2),
#             axis.line = element_line(size = 0.5, color = I('grey50'))) +
#       scale_x_date(limits = c(min(billsVoteDate$Contribution.Date),
#                               max(billsVoteDate$Contribution.Date)),
#                    labels = date_format('%Y-%m'), breaks = ('12 months')) +
#       scale_y_continuous(labels = comma,
#                          limits = c(min(billsVoteDate$Contribution.Amount),
#                                     max(billsVoteDate$Contribution.Amount)),
#                          breaks = c(-10000, seq(0, 1000000, 100000)))
  })
}

shinyApp(ui = ui, server = server)

