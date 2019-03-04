library(shiny)

shinyUI(fluidPage(
  
  titlePanel("Slovenske občine"),
  
  tabsetPanel(
      tabPanel("Velikost družine",
               DT::dataTableOutput("druzine")),
      
      tabPanel("Število naselij",
               sidebarPanel(
                  uiOutput("pokrajine")
                ),
               mainPanel(plotOutput("naselja")))
    )
))

shinyUI(fluidPage(
  titlePanel("Igralci tedna"),
  sidebarLayout(
    sidebarPanel(
      selectInput("sezona","Izberi sezono", choices=igralci_tedna$Sezona_okrajsano
    ),
    
    mainPanel(
      tableOutput("igralci_sezone")
    )
  )
)))


  
  

  
  
  
  
  
  
  
  
