library(dplyr)
library(jsonlite)
library(Hmisc)
library(stringr)

trans_level <- function(x,nsep=" to ") {
  n <- str_extract_all(x,"\\d+")[[1]]  ## extract numbers
  v <- formatC(as.numeric(n), big.mark = ",", format = 'd') ## change format
  x <- as.character(x)
  paste0(
    substring(x, 1, 1),
    paste(v,collapse=nsep),
    substring(x, nchar(x), nchar(x)))  ## recombine
}

choroOutputBill <- function(choroData, states, billName) {
  if(is.null(billName)) {
    return('{}')
  }
  choroDataBill <- choroData %>%
    filter(bill == billName) %>%
    ungroup() %>%
    select(-bill)

  states <- read.csv('data/state_table.csv', stringsAsFactors = FALSE)
  states <- select(states, -id)
  names(states)[9] <- 'id'

  ccc <- inner_join(choroDataBill, states, by = 'id')
  ccc <- select(ccc, name, dollar)
  colnames(ccc) <- c('region', 'value')
  ccc$region <- tolower(ccc$region)

  ccc$value <- cut2(ccc$value,
                    c(100000, 300000, 800000, 3000000, 1000000))
  ccc$value2 <- ccc$value
  levels(ccc$value2) <- sapply(levels(ccc$value),
                               trans_level)
  ccc <- select(ccc, region, value2)
  colnames(ccc) <- c('region', 'value')

  choro <- StateChoropleth$new(ccc)
  choro$title <- "Contributions Denisty in US States"
  choro$ggplot_scale <- scale_fill_brewer(name="Dollars",
                                          palette = 6, drop = FALSE)

  p <- choro$render() +
    theme(legend.position = "bottom",
          title = element_text(size = 16),
          legend.title = element_blank(),
          legend.text = element_text(size = 8)) +
    guides(col = guide_legend(nrow = 2, byrow = TRUE))
  grid.arrange(p, nrow = 1)
}
