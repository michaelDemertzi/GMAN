server <- function(input, output) {
  
  
  output$sankeyPlot <- renderSankeyNetwork({sankeyOutputBill(input$billSankey)})
  output$choropleth <- renderPlot({choroOutputBill(choroData, states, input$billChoro)})
}

