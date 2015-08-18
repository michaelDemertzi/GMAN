library(dplyr)

source('dataRead.R')

states <- read.csv('data/state_table.csv', stringsAsFactors = FALSE)
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
                            Interest.Group.Position,
                            desc(Contribution.Amount), Contributor)

allBillsStatePositionAgg <- allBillsState %>%
  group_by(bill, Contributor.State, Interest.Group.Position) %>%
  summarise(Contribution.Amount = sum(Contribution.Amount))

allBillsStatePositionTop5 <- allBillsState %>%
  select(bill, Contributor.State, Interest.Group.Position,
         Contribution.Amount,
         Legislator, Party, Contributor) %>%
  group_by(bill, Contributor.State, Interest.Group.Position) %>%
  slice(1:5) %>%
  mutate(tooltipText = paste('$', Contribution.Amount, ' to ',
                             Legislator, ' (', Party, ') from ',
                             Contributor, 'with Position',
                             Interest.Group.Position, sep = ''))
allBillsStatePositionTop5 <- allBillsStatePositionTop5 %>%
  group_by(bill, Contributor.State, Interest.Group.Position) %>%
  summarise(tooltipText = paste(tooltipText, collapse = '\n', sep = ''))
allBillsStatePositionTop5$tooltipText <- paste('5 largest donations: \n',
                                       allBillsStatePositionTop5$tooltipText, '\n',
                                       sep = '')

allBillsStatePositionAgg <- inner_join(allBillsStatePositionAgg, allBillsStatePositionTop5)
allBillsStatePositionAgg <- inner_join(allBillsStatePositionAgg, stateCodes)

choroDataPosition <- allBillsStatePositionAgg %>%
  ungroup() %>%
  select(id, Interest.Group.Position, Contribution.Amount, tooltipText, bill)
colnames(choroDataPosition) <- c('id', 'position', 'dollar', 'tooltiptext', 'bill')

choroDataPosition <- choroDataPosition %>%
  filter(position != 'Split') %>%
  group_by(bill, id, position) %>%
  summarise(dollar = sum(dollar),
            tooltiptext = min(tooltiptext),
            tooltiptext = min(tooltiptext))
choroDataPositionSupport <- choroDataPosition %>%
  filter(position == 'Support') %>%
  select(-position)
colnames(choroDataPositionSupport) <- c('bill', 'id', 'supportDollar', 'supportTooltiptext')
choroDataPositionOppose <- choroDataPosition %>%
  filter(position == 'Oppose') %>%
  select(-position)
colnames(choroDataPositionOppose) <- c('bill', 'id', 'opposeDollar', 'opposeTooltiptext')
choroDataPosition <- inner_join(choroDataPositionSupport, choroDataPositionOppose)
choroDataPosition$percentSupport <- with(choroDataPosition,
                                 round(supportDollar /
                                         (supportDollar + opposeDollar)
                                       * 100, 2))
choroDataPosition$percentOppose = 100 - choroDataPosition$percentSupport