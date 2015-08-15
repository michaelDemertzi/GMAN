library(dplyr)

lineOutputBill <- function(lineData, billName) {
  return(filter(lineData, bill == billName))
}