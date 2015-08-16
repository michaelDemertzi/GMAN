library(dplyr)
library(jsonlite)

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

  colnames(sankeyDataNodes) <- c('source', 'Legislator')
  sankeyDataSupportLinks <- inner_join(sankeyDataTopSupport, sankeyDataNodes)
  colnames(sankeyDataNodes) <- c('target', 'Interest.Group.Position')
  sankeyDataSupportLinks$Interest.Group.Position <-
    as.character(sankeyDataSupportLinks$Interest.Group.Position)
  sankeyDataSupportLinks <- inner_join(sankeyDataSupportLinks, sankeyDataNodes)
  sankeyDataSupportLinks <- ungroup(sankeyDataSupportLinks)
  sankeyDataSupportLinks <- select(sankeyDataSupportLinks,
                                   source, target, value)
  sankeyDataSupportLinks <- arrange(sankeyDataSupportLinks,
                                         desc(value))

  colnames(sankeyDataNodes) <- c('source', 'Interest.Group.Position')
  sankeyDataTopVote$Interest.Group.Position <-
    as.character(sankeyDataTopVote$Interest.Group.Position)
  sankeyDataVoteLinks <- inner_join(sankeyDataTopVote, sankeyDataNodes)
  sankeyDataVoteLinks$Vote <- as.character(sankeyDataVoteLinks$Vote)
  colnames(sankeyDataNodes) <- c('target', 'Vote')
  sankeyDataVoteLinks <- inner_join(sankeyDataVoteLinks, sankeyDataNodes)
  sankeyDataVoteLinks <- ungroup(sankeyDataVoteLinks)
  sankeyDataVoteLinks <- select(sankeyDataVoteLinks,
                                   source, target, value)
  sankeyDataVoteLinks <- arrange(sankeyDataVoteLinks,
                                    desc(value))
  
  sankeyDataLinks <- rbind(sankeyDataContributionLinks,
                           sankeyDataSupportLinks,
                           sankeyDataVoteLinks)
  
  colnames(sankeyDataNodes) <- c('node', 'name')

  return(toJSON(list('nodes' = sankeyDataNodes,
                     'links' = sankeyDataLinks)))
}
