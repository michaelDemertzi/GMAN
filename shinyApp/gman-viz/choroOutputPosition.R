library(dplyr)
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

choroOutputPositionBill <- function(choroDataPosition, states, billName,
                                    position) {
  if(is.null(billName)) {
    return('{}')
  }
  choroDataSupportBill <- choroDataPositionSupport %>%
    filter(bill == billName) %>%
    ungroup() %>%
    select(-bill)

  states <- read.csv('data/state_table.csv', stringsAsFactors = FALSE)
  states <- select(states, -id)
  names(states)[9] <- 'id'

  ccc <- inner_join(choroDataSupportBill, states, by = 'id')
  ccc <- select(ccc, name, supportDollar)
  colnames(ccc) <- c('region', 'value')
  ccc$region <- tolower(ccc$region)

  ccc$value <- cut2(ccc$value,
                    c(100000, 300000, 800000, 2000000, 3000000, 500000))
  ccc$value2 <- ccc$value
  levels(ccc$value2) <- sapply(levels(ccc$value),
                               trans_level)
  ccc <- select(ccc, region, value2)
  colnames(ccc) <- c('region', 'value')

  choro1 <- StateChoropleth$new(ccc)
  choro1$title <- "Contributions Denisty Supporting in US States"
  choro1$ggplot_scale <- scale_fill_brewer(name="Dollars",
                                          palette = 6, drop = FALSE)

  p1 <- choro1$render() +
    theme(legend.position = "bottom",
          title = element_text(size = 16),
          legend.title = element_blank(),
          legend.text = element_text(size = 8)) +
    guides(col = guide_legend(nrow = 2, byrow = TRUE))

  choroDataOpposeBill <- choroDataPositionOppose %>%
    filter(bill == billName) %>%
    ungroup() %>%
    select(-bill)

  states <- read.csv('data/state_table.csv', stringsAsFactors = FALSE)
  states <- select(states, -id)
  names(states)[9] <- 'id'

  ccc <- inner_join(choroDataOpposeBill, states, by = 'id')
  ccc <- select(ccc, name, opposeDollar)
  colnames(ccc) <- c('region', 'value')
  ccc$region <- tolower(ccc$region)

  ccc$value <- cut2(ccc$value,
                    c(100000, 300000, 800000, 2000000, 3000000, 500000))
  ccc$value2 <- ccc$value
  levels(ccc$value2) <- sapply(levels(ccc$value),
                               trans_level)
  ccc <- select(ccc, region, value2)
  colnames(ccc) <- c('region', 'value')

  choro2 <- StateChoropleth$new(ccc)
  choro2$title <- "Contributions Denisty Opposing in US States"
  choro2$ggplot_scale <- scale_fill_brewer(name="Dollars",
                                          palette = 6, drop = FALSE)

  p2 <- choro2$render() +
    theme(legend.position = "bottom",
          title = element_text(size = 16),
          legend.title = element_blank(),
          legend.text = element_text(size = 8)) +
    guides(col = guide_legend(nrow = 2, byrow = TRUE))

  if (position == 'support') {
    grid.arrange(p1, nrow = 1)
  } else {
    grid.arrange(p2, nrow = 1)
  }
}
