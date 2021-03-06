library(shiny)


shinyServer(function(input,output){
  output$graf1 <- renderPlot({
    ggplot(data=igralci_tedna_pozicijefilt %>% 
             filter(Pozicija == input$id_poz), aes(x=Sezona_okrajsano)) +xlab("Leto") + ylab("Število") + 
      geom_histogram(binwidth =1, color="dodgerblue4", fill="dodgerblue4", alpha = 0.7) + theme_bw() + 
      ggtitle("Osvojeni nazivi igralca tedna glede na pozicijo igranja skozi čas")
  })
})


