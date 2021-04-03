# if(!require("pacman")){install.packages("pacman")}
# pacman::p_load(readxl,tidyverse,DT,shiny)

library(tidyverse)
library(DT)
library(shiny)
library(stringr)

DF= readxl::read_excel("./Data/Pflanzenfile.xlsx")
DF=DF[c(-1,-nrow(DF)),]
a=DF[,30:33]

b=data.frame(x=c(1:nrow(a)))
for (i in 1:ncol(a)){
    Effekt= str_extract(unlist(a[,i]),"[0-9]+")
    Wirkung= str_trim(str_remove(unlist(a[,i]),"[0-9]+"))
    b[paste("Wirkung", i, sep=" ")]=Wirkung
    b[paste("W", i," Effekt",sep="")]=Effekt
}

DF=cbind(DF[,1:29],b[,-1])
rm(a,b)

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
