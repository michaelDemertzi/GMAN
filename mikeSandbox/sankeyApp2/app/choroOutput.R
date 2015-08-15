library(dplyr)
library(jsonlite)

choroOutputBill <- function(choroData, billName) {
  return(toJSON(filter(choroData, bill == billName)))
}
