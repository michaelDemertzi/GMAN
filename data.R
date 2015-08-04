library(dplyr)
library(ggplot2)
library(choroplethrZip)
library(choroplethrMaps)
library(mapproj)

data(zip.regions)
states <- read.csv('state_table.csv', stringsAsFactors = FALSE)

usaFreedom <- read.csv('usaFreedom.csv', stringsAsFactors = FALSE)
names(usaFreedom)[4] <- 'Vote'
names(usaFreedom)[14] <- 'Interest.Group.Position'
usaFreedom$bill <- 'USA Freedom Act'

keystone <- read.csv('keystone.csv', stringsAsFactors = FALSE)
names(keystone)[4] <- 'Vote'
names(keystone)[14] <- 'Interest.Group.Position'
keystone$bill <- 'Keystone Pipeline Approval Act'

smallBusinessBurden <- read.csv('smallBusinessBurden.csv', stringsAsFactors = FALSE)
names(smallBusinessBurden)[4] <- 'Vote'
names(smallBusinessBurden)[14] <- 'Interest.Group.Position'
smallBusinessBurden$bill <- 'Small Business Regulatory Flexibility Improvement Act'

ppDefunding <- read.csv('ppDefunding.csv', stringsAsFactors = FALSE)
names(ppDefunding)[4] <- 'Vote'
names(ppDefunding)[14] <- 'Interest.Group.Position'
ppDefunding$bill <- 'Planned Parenthood Defunding Act'

studentSuccess <- read.csv('studentSuccess.csv', stringsAsFactors = FALSE)
names(studentSuccess)[4] <- 'Vote'
names(studentSuccess)[14] <- 'Interest.Group.Position'
studentSuccess$bill <- 'Student Success Act'

marketPlaceFairness <- read.csv('marketPlaceFairness.csv', stringsAsFactors = FALSE)
names(marketPlaceFairness)[4] <- 'Vote'
names(marketPlaceFairness)[14] <- 'Interest.Group.Position'
marketPlaceFairness$bill <- 'Market Place Fairness Act'

allBills <- rbind(usaFreedom, keystone, smallBusinessBurden, ppDefunding,
                  studentSuccess, marketPlaceFairness)
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