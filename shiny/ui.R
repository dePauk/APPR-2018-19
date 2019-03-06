library(shiny)



# fluidPage(
#   titlePanel("Igralci tedna"),
#   sidebarLayout(
#     sidebarPanel(
#       selectInput("id_klub","Izberi klub", choices=igralci_tedna$Igralceva_ekipa)
#     ),
#     
#     mainPanel(
#       tableOutput("igralci_tedna")
#     )
#   )
# )


  
  
fluidPage(
  titlePanel("Igralci tedna po pozicijah"),
    sidebarPanel(
      selectInput("id_poz", "Izberi pozicijo", choices = igralci_tedna_pozicijefilt$Pozicija)
    ),
    mainPanel(plotOutput("graf_shiny"))
)

      


  
  
  
  
  
  
  
  
