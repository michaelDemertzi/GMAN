library(shiny)
library(dplyr)

df <- data.frame(b = c('Food Safety Labeling Act', 'Keystone Pipeline Approval Act',
                       'Small Business Regulatory Flexibility Improvement Act'),
                 jsonBlob = c('{"bill": "Food Safety Labeling Act", "links":[{\"source\":40,\"target\":71,\"value\":47500},{\"source\":19,\"target\":71,\"value\":45000},{\"source\":10,\"target\":71,\"value\":37500},{\"source\":13,\"target\":75,\"value\":35000},{\"source\":22,\"target\":73,\"value\":35000},{\"source\":22,\"target\":70,\"value\":32500}],"nodes":[{\"node\":0,\"name\":\"American Assn For Justice\"},{\"node\":1,\"name\":\"American Bankers Assn\"},{\"node\":2,\"name\":\"American Council Of Engineering Cos\"},{\"node\":3,\"name\":\"American Crystal Sugar\"},{\"node\":4,\"name\":\"American Federation Of Teachers\"},{\"node\":5,\"name\":\"American Fedn Of St/cnty/munic Employees\"}]}',
                              '{"bill": "Keystone Pipeline Approval Act", "links":[{\"source\":40,\"target\":71,\"value\":47500},{\"source\":19,\"target\":71,\"value\":45000},{\"source\":10,\"target\":71,\"value\":37500},{\"source\":13,\"target\":75,\"value\":35000},{\"source\":22,\"target\":73,\"value\":35000},{\"source\":22,\"target\":70,\"value\":32500}],"nodes":[{\"node\":0,\"name\":\"American Assn For Justice\"},{\"node\":1,\"name\":\"American Bankers Assn\"},{\"node\":2,\"name\":\"American Council Of Engineering Cos\"},{\"node\":3,\"name\":\"American Crystal Sugar\"},{\"node\":4,\"name\":\"American Federation Of Teachers\"},{\"node\":5,\"name\":\"American Fedn Of St/cnty/munic Employees\"}]}',
                              '{"bill": "Small Business Regulatory Flexibility Improvement Act", "links":[{\"source\":40,\"target\":71,\"value\":47500},{\"source\":19,\"target\":71,\"value\":45000},{\"source\":10,\"target\":71,\"value\":37500},{\"source\":13,\"target\":75,\"value\":35000},{\"source\":22,\"target\":73,\"value\":35000},{\"source\":22,\"target\":70,\"value\":32500}],"nodes":[{\"node\":0,\"name\":\"American Assn For Justice\"},{\"node\":1,\"name\":\"American Bankers Assn\"},{\"node\":2,\"name\":\"American Council Of Engineering Cos\"},{\"node\":3,\"name\":\"American Crystal Sugar\"},{\"node\":4,\"name\":\"American Federation Of Teachers\"},{\"node\":5,\"name\":\"American Fedn Of St/cnty/munic Employees\"}]}'),
                 stringsAsFactors = FALSE)
df$jsonBlob <- gsub("([\\])", '', df$jsonBlob)
shinyServer <- function(input, output) {
  output$sankeyJSON <- renderText({
    filter(df, b == input$bill)$jsonBlob
  })
}
