library(dplyr)
library(jsonlite)
library(rMaps)
library(reshape2)

choroOutputBill <- function(choroData, states, billName) {
  if(is.null(billName)) {
    return('{}')
  }
  choroDataBill <- choroData %>%
    filter(bill == billName) %>%
    select(-bill) %>%
    arrange(desc(dollar))

  states <- select(states, -id)
  names(states)[9] <- 'id'
  # cc <- merge(choroDataBill, states, by.x="id", by.y="fips_state")
  # ccc <- cc[,c("name", "dollar")]
  # names(ccc) <- c("region", "value")

  ccc <- inner_join(choroDataBill, states, by = 'id')
  ccc$region <- tolower(ccc$region)
  state_choropleth(ccc)
}
