library(dplyr)
library(jsonlite)
library(rMaps)
library(reshape2)
library(plyr)

choroOutputBill <- function(choroData, billName) {
  if(is.null(billName)) {
    return('{}')
  }
  choroDataBill <- choroData %>%
    filter(bill == billName) %>%
    select(-bill) %>%
    arrange(desc(dollar))
#   return(toJSON(choroDataBill))
  choroDataBill
}

cc <- merge(c, states, by.x="id", by.y="fips_state")
ccc <- cc[,c("name", "dollar")]
names(ccc) <- c("region", "value")
ccc$region <- tolower(ccc$region)

state_choropleth(ccc)

datm2 <- transform(ccc,
                   fillKey = cut(value, quantile(value, seq(0, 1, 1/5)), labels = LETTERS[1:5]))

fills = setNames(
  c(RColorBrewer::brewer.pal(5, 'YlOrRd'), 'white'),
  c(LETTERS[1:5], 'defaultFill')
)

dat2 <- dlply(na.omit(datm2), "value", function(x){
  y = toJSONArray2(x, json = F)
  names(y) = lapply(y, '[[', 'region')
  return(y)
})

options(rcharts.cdn = TRUE)
map <- Datamaps$new()
map$set(
  dom = 'chart_1',
  scope = 'usa',
  fills = fills,
  data = ccc$value,
  legend = TRUE,
  labels = TRUE
)
map

map("state", col = "white", fill = FALSE, add = TRUE,
    lty = 1, lwd = 1, projection = "polyconic", 
    myborder = 0, mar = c(0,0,0,0))
