library(dplyr)
library(jsonlite)

sankeyOutputBill <- function(sankeyData, billName) {
  print("debugging")
  print(billName)
  sankeyDataLinks <- filter(sankeyData, bill == billName)
  sankeyDataNodes <- rbind(data.frame(node = seq(0, n_distinct(sankeyData$sourceName) - 1, 1),
                                      name = unique(sankeyData$sourceName)),
                           data.frame(node = seq(n_distinct(sankeyData$sourceName),
                                                 n_distinct(sankeyData$sourceName) +
                                                   n_distinct(sankeyData$targetName) - 1, 1),
                                      name = unique(sankeyData$targetName)))

  colnames(sankeyDataNodes) <- c('source', 'sourceName')
  sankeyDataLinks <- inner_join(sankeyData, sankeyDataNodes)

  colnames(sankeyDataNodes) <- c('target', 'targetName')
  sankeyDataLinks <- inner_join(sankeyDataLinks, sankeyDataNodes)

  sankeyDataLinks <- select(sankeyDataLinks, source, target, value)
  sankeyDataLinks <- arrange(sankeyDataLinks, desc(value))

  colnames(sankeyDataNodes) <- c('node', 'name')

  links <- toJSON(sankeyDataLinks)
  nodes <- toJSON(sankeyDataNodes)
  return(list('links' = links, 'nodes' = nodes))
}