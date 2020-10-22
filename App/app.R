# if(!require("pacman")){install.packages("pacman")}
# pacman::p_load(readxl,tidyverse,DT,shiny)

library(tidyverse)
library(DT)
library(shiny)

DF= readxl::read_excel("./Data/Pflanzenfile.xlsx")
DF=DF[c(-1,-nrow(DF)),]

color<-rep("#F3EACB",length(DF$Name))
# Define UI for application that draws a histogram
ui <- fluidPage(
    shinyWidgets::setBackgroundColor(color),
    # Application title
    titlePanel("Pflanzen in Orbis Astera"),
    # Show a plot of the generated distribution
    mainPanel(
        selectInput("Gebiet","Gebiet",choices = c(colnames(DF)[c(2:25)])),
        DTOutput("Table")
    )
)

Colls<-c("Name", "Kosten", "Häufigkeit", "Wirkung 1", "W1 Effekt", "Wirkung 2", "W2 Effekt", "Wirkung 3", "W3 Effekt", "Wirkung 4", "W4 Effekt")

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$Table<-renderDT({
        DF%>%dplyr::filter(get(input$Gebiet,DF) == 1)%>%dplyr::select(1,28:ncol(DF))%>%datatable() %>%formatStyle(Colls,target="row",backgroundColor = styleEqual(DF$Name,color))
        })
}

# Run the application
shinyApp(ui = ui, server = server)
