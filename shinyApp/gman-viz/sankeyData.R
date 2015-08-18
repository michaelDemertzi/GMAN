library(dplyr)

# sankeyData <- allBills %>%
#   group_by(Contributor, Legislator, bill) %>%
#   summarise(value = sum(Contribution.Amount))
# 
# sankeyDataTopSource <- sankeyData %>%
#   group_by(Contributor, bill) %>%
#   summarise(value = sum(value)) %>%
#   ungroup() %>%
#   arrange(desc(value)) %>%
#   group_by(bill) %>%
#   slice(1:10)
# 
# sankeyDataTopTarget <- sankeyData %>%
#   group_by(Legislator, bill) %>%
#   summarise(value = sum(value)) %>%
#   ungroup() %>%
#   arrange(desc(value)) %>%
#   group_by(bill) %>%
#   slice(1:10)
# 
# sankeyData <- filter(sankeyData, Contributor %in% sankeyDataTopSource$Contributor,
#                      Legislator %in% sankeyDataTopTarget$Legislator)
# sankeyData <- ungroup(sankeyData)
# colnames(sankeyData) <- c('sourceName', 'targetName', 'bill', 'value')


########################### LAYERS CODE HERE ##########################

sankeyDataTopSource <- allBills %>%
  group_by(Contributor, bill) %>%
  summarise(value = sum(Contribution.Amount)) %>%
  ungroup() %>%
  arrange(desc(value)) %>%
  group_by(bill) %>%
  slice(1:20)

sankeyDataTopTarget <- allBills %>%
  filter(Contributor %in% sankeyDataTopSource$Contributor) %>%
  group_by(Legislator, bill) %>%
  summarise(value = sum(Contribution.Amount)) %>%
  ungroup() %>%
  arrange(desc(value)) %>%
  group_by(bill) %>%
  slice(1:20)

sankeyDataTopContributions <- inner_join(inner_join(allBills,
                                                    sankeyDataTopSource),
                                         sankeyDataTopTarget,
                                         by = c('Legislator', 'bill')) %>%
  group_by(Contributor, Legislator, bill) %>%
  summarise(value = sum(Contribution.Amount))

sankeyDataTopSupport <- inner_join(inner_join(allBills,
                                              sankeyDataTopSource),
                                   sankeyDataTopTarget,
                                   by = c('Legislator', 'bill')) %>%
  group_by(Legislator, Interest.Group.Position, bill) %>%
  summarise(value = sum(Contribution.Amount))

sankeyDataTopVote <- inner_join(inner_join(allBills,
                                           sankeyDataTopSource),
                                sankeyDataTopTarget,
                                by = c('Legislator', 'bill')) %>%
  group_by(Interest.Group.Position, Vote, bill) %>%
  summarise(value = sum(Contribution.Amount))
