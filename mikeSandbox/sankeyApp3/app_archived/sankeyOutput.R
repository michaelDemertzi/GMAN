library(dplyr)
library(jsonlite)

sankeyOutputBill <- function(sankeyDataBill, billName) {
  if(is.null(billName)) {
    return('{}')
  }

  sankeyDataBill <- filter(sankeyData, bill == billName)
  sankeyDataNodes <- rbind(data.frame(node = seq(0, n_distinct(sankeyDataBill$sourceName) - 1, 1),
                                      name = unique(sankeyDataBill$sourceName)),
                           data.frame(node = seq(n_distinct(sankeyDataBill$sourceName),
                                                 n_distinct(sankeyDataBill$sourceName) +
                                                   n_distinct(sankeyDataBill$targetName) - 1, 1),
                                      name = unique(sankeyDataBill$targetName)))

  colnames(sankeyDataNodes) <- c('source', 'sourceName')
  sankeyDataLinks <- inner_join(sankeyDataBill, sankeyDataNodes)

  colnames(sankeyDataNodes) <- c('target', 'targetName')
  sankeyDataLinks <- inner_join(sankeyDataLinks, sankeyDataNodes)

  sankeyDataLinks <- select(sankeyDataLinks, source, target, value)
  sankeyDataLinks <- arrange(sankeyDataLinks, desc(value))

  colnames(sankeyDataNodes) <- c('node', 'name')

  return(toJSON(list('bill' = billName,
                     'links' = head(sankeyDataLinks),
                     'nodes' = head(sankeyDataNodes))))
}
