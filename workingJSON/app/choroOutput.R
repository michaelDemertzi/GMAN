library(dplyr)
library(jsonlite)

choroOutputBill <- function(choroData, billName) {
  if(is.null(billName)) {
    return('{}')
  }
  choroDataBill <- choroData %>%
    filter(bill == billName) %>%
    select(-bill) %>%
    arrange(desc(dollar))
  return(toJSON(choroDataBill))
}
