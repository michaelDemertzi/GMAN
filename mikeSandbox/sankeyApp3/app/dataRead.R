library(dplyr)

usaFreedom <- read.csv('../data/usaFreedom.csv', stringsAsFactors = FALSE)
names(usaFreedom)[4] <- 'Vote'
names(usaFreedom)[14] <- 'Interest.Group.Position'
usaFreedom$bill <- 'USA Freedom Act'

keystone <- read.csv('../data/keystone.csv', stringsAsFactors = FALSE)
names(keystone)[4] <- 'Vote'
names(keystone)[14] <- 'Interest.Group.Position'
keystone$bill <- 'Keystone Pipeline Approval Act'

smallBusinessBurden <- read.csv('../data/smallBusinessBurden.csv', stringsAsFactors = FALSE)
names(smallBusinessBurden)[4] <- 'Vote'
names(smallBusinessBurden)[14] <- 'Interest.Group.Position'
smallBusinessBurden$bill <- 'Small Business Regulatory Flexibility Improvement Act'

foodSafety <- read.csv('../data/foodsafety.csv', stringsAsFactors = FALSE)
names(foodSafety)[4] <- 'Vote'
names(foodSafety)[14] <- 'Interest.Group.Position'
foodSafety$bill <- 'Food Safety Labeling Act'

studentSuccess <- read.csv('../data/studentSuccess.csv', stringsAsFactors = FALSE)
names(studentSuccess)[4] <- 'Vote'
names(studentSuccess)[14] <- 'Interest.Group.Position'
studentSuccess$bill <- 'Student Success Act'

allBills <- rbind(usaFreedom, keystone, smallBusinessBurden,
                  foodSafety, studentSuccess)
allBills$Contributor <- gsub(',', '', allBills$Contributor)
allBills$Legislator <- gsub(',', '', allBills$Legislator)

allBills$bill <- as.factor(allBills$bill)
allBills$Party <- as.factor(allBills$Party)
allBills$Vote <- as.factor(allBills$Vote)
allBills$Contribution.Type <- as.factor(allBills$Contribution.Type)
allBills$Contribution.Date <- as.Date(allBills$Contribution.Date,
                                      format = '%m/%d/%Y', tz = '')
allBills$Interest.Group.Position <- as.factor(allBills$Interest.Group.Position)

allBills$Contribution.Amount <- gsub('\\$', '', allBills$Contribution.Amount)
allBills$Contribution.Amount <- as.numeric(allBills$Contribution.Amount)

allBills$Contributor <- gsub('\\"', '', allBills$Contributor)
allBills$Legislator <- gsub('\\"', '', allBills$Legislator)
allBills$Legislator <- enc2native(allBills$Legislator)
allBills$Legislator <- gsub('<e1>', 'a', allBills$Legislator)
allBills$Legislator <- gsub('<e9>', 'e', allBills$Legislator)
