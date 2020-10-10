
if(!require("pacman")){install.packages("pacman")}
pacman::p_load(readxl,tidyverse,DT,shiny)

DF=read_excel("C:\\Users\\svalv\\Dropbox\\Lele\\Rpg\\DmExcel.xlsx",sheet = "Pflanzen")
DF=DF[-1,]
DF$Alle<-1
# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Planzen"),
        # Show a plot of the generated distribution
        mainPanel(
            selectInput("Gebiet","Gebiet",choices = c("Alle",colnames(DF)[c(2:15)])),
            DTOutput("Table")
        )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$Table<-renderDT({
        DF%>%filter(get(input$Gebiet,DF) == 1)%>%select(1,17:ncol(DF))%>%datatable()})
}

# Run the application
shinyApp(ui = ui, server = server)
