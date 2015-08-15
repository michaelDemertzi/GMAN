library(dplyr)

lineData <- allBills %>%
  filter(Vote != 'Not Voting') %>%
  group_by(bill, Vote, Contribution.Date) %>%
  summarise(Contribution.Amount = sum(Contribution.Amount))
lineData$Vote <- factor(lineData$Vote)
