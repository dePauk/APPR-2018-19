library(shiny)


  
fluidPage(
  titlePanel("Igralci tedna po pozicijah"),
    sidebarPanel(
      selectInput("id_poz", "Izberi pozicijo", choices = unique(igralci_tedna_pozicijefilt$Pozicija))
    ),
    mainPanel(plotOutput("graf1"))
)

      


  
  
  
  
  
  
  
  
