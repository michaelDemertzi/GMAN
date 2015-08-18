library(dplyr)
library(jsonlite)

find_index <- function(string, nodes){
  as.integer(match(string, nodes$name) - 1)
}

sankeyOutputBill <- function(billName) {
  if(is.null(billName)) {
    return('{}')
  }
  
  sankeyDataTopContributions <- filter(sankeyDataTopContributions,
                                       bill == billName)
  sankeyDataTopContributions <- select(sankeyDataTopContributions, -bill)
  sankeyDataTopSupport <- filter(sankeyDataTopSupport,
                                 bill == billName)
  sankeyDataTopSupport <- select(sankeyDataTopSupport, -bill)
  sankeyDataTopVote <- filter(sankeyDataTopVote,
                              bill == billName)
  sankeyDataTopVote <- select(sankeyDataTopVote, -bill)
  
  sankeyDataNodes <- rbind(
    data.frame(node = seq(0, n_distinct(sankeyDataTopContributions$Contributor)
                          - 1, 1),
               name = unique(sankeyDataTopContributions$Contributor),
               stringsAsFactors = FALSE),
    data.frame(node = seq(n_distinct(sankeyDataTopContributions$Contributor),
                          n_distinct(sankeyDataTopContributions$Contributor) +
                            n_distinct(sankeyDataTopContributions$Legislator)
                          - 1, 1),
               name = unique(sankeyDataTopContributions$Legislator),
               stringsAsFactors = FALSE),
    data.frame(node =
                 seq(n_distinct(sankeyDataTopContributions$Contributor) +
                       n_distinct(sankeyDataTopContributions$Legislator),
                     n_distinct(sankeyDataTopContributions$Contributor) +
                       n_distinct(sankeyDataTopContributions$Legislator) +
                       n_distinct(sankeyDataTopSupport$Interest.Group.Position)
                     - 1, 1),
               name = unique(sankeyDataTopSupport$Interest.Group.Position),
               stringsAsFactors = FALSE),
    data.frame(node =
                 seq(n_distinct(sankeyDataTopContributions$Contributor) +
                       n_distinct(sankeyDataTopContributions$Legislator) +
                       n_distinct(sankeyDataTopSupport$Interest.Group.Position),
                     n_distinct(sankeyDataTopContributions$Contributor) +
                       n_distinct(sankeyDataTopContributions$Legislator) +
                       n_distinct(sankeyDataTopSupport$Interest.Group.Position)
                     + n_distinct(sankeyDataTopVote$Vote) - 1, 1),
               name = unique(sankeyDataTopVote$Vote),
               stringsAsFactors = FALSE
    )
  )
  
  colnames(sankeyDataNodes) <- c('source', 'Contributor')
  sankeyDataContributionLinks <- inner_join(sankeyDataTopContributions,
                                            sankeyDataNodes)
  colnames(sankeyDataNodes) <- c('target', 'Legislator')
  sankeyDataContributionLinks <- inner_join(sankeyDataContributionLinks,
                                            sankeyDataNodes)
  sankeyDataContributionLinks <- ungroup(sankeyDataContributionLinks)
  sankeyDataContributionLinks <- select(sankeyDataContributionLinks,
                                        source, target, value)
  sankeyDataContributionLinks <- arrange(sankeyDataContributionLinks,
                                         desc(value))
  
  colnames(sankeyDataNodes) <- c('source', 'Interest.Group.Position')
  
  colnames(sankeyDataNodes) <- c('node', 'name')
  
  sankeyContribSupport <- unique(merge(subset(allBills, bill==billName), sankeyDataTopContributions, by="Contributor")[,c("Interest.Group.Position", "Contributor")])
  sankeyContribTotals <- aggregate(value ~ source, sankeyDataContributionLinks, sum)
  sankeyContribSupport$Interest.Group.Position <- sapply(sankeyContribSupport$Interest.Group.Position, find_index, nodes=sankeyDataNodes)
  sankeyContribSupport$Contributor <- sapply(sankeyContribSupport$Contributor, find_index, nodes=sankeyDataNodes)
  sankeyContribSupport <- unique(merge(sankeyContribSupport, sankeyContribTotals, by.x="Contributor", by.y="source")[,c("Interest.Group.Position", "Contributor", "value")])
  names(sankeyContribSupport) <- c("source", "target", "value")

  sankeyLegSupport <- unique(merge(subset(allBills, bill==billName), sankeyDataTopContributions, by="Legislator")[,c("Legislator", "Vote")])
  sankeyLegTotals <- aggregate(value ~ target, sankeyDataContributionLinks, sum)
  sankeyLegSupport$Legislator <- sapply(sankeyLegSupport$Legislator, find_index, nodes=sankeyDataNodes)
  sankeyLegSupport$Vote <- sapply(sankeyLegSupport$Vote, find_index, nodes=sankeyDataNodes)
  sankeyLegSupport <- unique(merge(sankeyLegSupport, sankeyLegTotals, by.x="Legislator", by.y="target")[,c("Legislator", "Vote", "value")])
  names(sankeyLegSupport) <- c("source", "target", "value")
  
  
  
  sankeyDataLinks <- rbind(sankeyContribSupport,sankeyDataContributionLinks,sankeyLegSupport)
  
  

  sankeyNetwork(sankeyDataLinks, sankeyDataNodes, "source", "target", "value", "name")
}

