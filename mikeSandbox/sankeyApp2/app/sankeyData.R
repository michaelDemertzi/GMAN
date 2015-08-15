library(dplyr)

sankeyData <- allBills %>%
  group_by(Contributor, Legislator, bill) %>%
  summarise(Value = sum(Contribution.Amount))

sankeyDataTopSource <- sankeyData %>%
  group_by(Contributor, bill) %>%
  summarise(Value = sum(Value)) %>%
  ungroup() %>%
  arrange(desc(Value)) %>%
  group_by(bill) %>%
  slice(1:10)

sankeyDataTopTarget <- sankeyData %>%
  group_by(Legislator, bill) %>%
  summarise(Value = sum(Value)) %>%
  ungroup() %>%
  arrange(desc(Value)) %>%
  group_by(bill) %>%
  slice(1:10)

sankeyData <- filter(sankeyData, Contributor %in% sankeyDataTopSource$Contributor,
                     Legislator %in% sankeyDataTopTarget$Legislator)
sankeyData <- ungroup(sankeyData)
colnames(sankeyData) <- c('sourceName', 'targetName', 'bill', 'value')
