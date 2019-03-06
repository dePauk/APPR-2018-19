library(shiny)


# 
# shinyServer(function(input,output){
#   output$igralci_tedna <- renderTable({
#     ekipa_filter <- subset(igralci_tedna, igralci_tedna$Igralceva_ekipa == input$id_klub)
#     
#   })
# })



shinyServer(function(input,output){
  output$graf1 <- renderPlot({
    graf_shiny(input$id_poz)
  })
})


