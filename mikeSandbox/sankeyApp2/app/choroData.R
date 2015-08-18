library(dplyr)

source('dataRead.R')

data(zip.regions)
states <- read.csv('../data/state_table.csv', stringsAsFactors = FALSE)
stateCodes <- data.frame(Contributor.State = c('AL', 'AK', 'AZ', 'AR', 'CA', 'CO',
                                               'CT', 'DE', 'DC', 'FL', 'GA', 'HI',
                                               'ID', 'IL', 'IN', 'IA', 'KS', 'KY',
                                               'LA', 'ME', 'MD', 'MA', 'MI', 'MN',
                                               'MS', 'MO', 'MT', 'NE', 'NV', 'NH',
                                               'NJ', 'NM', 'NY', 'NC', 'ND', 'OH',
                                               'OK', 'OR', 'PA', 'RI', 'SC', 'SD',
                                               'TN', 'TX', 'UT', 'VT', 'VA', 'WA',
                                               'WV', 'WI', 'WY'),
                         id = c(1, 2, 4, 5, 6, 8, 9, 10, 11, 12, 13, 15, 16, 17, 18,
                                19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31,
                                32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 44, 45,
                                46, 47, 48, 49, 50, 51, 53, 54, 55, 56),
                         stringsAsFactors = FALSE
)

allBillsState <- allBills %>%
  filter(!is.na(Contributor.State),
         Contributor.State %in% stateCodes$Contributor.State)
allBillsState <- arrange(allBillsState, bill, Contributor.State,
                            desc(Contribution.Amount), Contributor)

allBillsStateAgg <- allBillsState %>%
  group_by(bill, Contributor.State) %>%
  summarise(Contribution.Amount = sum(Contribution.Amount))

allBillsStateTop5 <- allBillsState %>%
  select(bill, Contributor.State, Contribution.Amount,
         Legislator, Party, Contributor) %>%
  group_by(bill, Contributor.State) %>%
  slice(1:5) %>%
  mutate(tooltipText = paste('$', Contribution.Amount, ' to ',
                             Legislator, ' (', Party, ') from ',
                             Contributor, sep = ''))
allBillsStateTop5 <- allBillsStateTop5 %>%
  group_by(bill, Contributor.State) %>%
  summarise(tooltipText = paste(tooltipText, collapse = '\n', sep = ''))
allBillsStateTop5$tooltipText <- paste('5 largest donations: \n',
                                       allBillsStateTop5$tooltipText, '\n',
                                       sep = '')

allBillsStateAgg <- inner_join(allBillsStateAgg, allBillsStateTop5)
allBillsStateAgg <- inner_join(allBillsStateAgg, stateCodes)

choroData <- allBillsStateAgg %>%
  ungroup() %>%
  select(id, Contribution.Amount, tooltipText, bill)
colnames(choroData) <- c('id', 'dollar', 'tooltiptext', 'bill')

