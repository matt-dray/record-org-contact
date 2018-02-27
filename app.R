#
# This is a Shiny web application.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# Inspiration and code from
# https://github.com/cenuno/shiny/blob/master/DT-Download-All-Rows-Button/app.r

library(shiny)
library(DT)
library(shinythemes)
library(dplyr)
fake <- readRDS("global/fake_dataset.RDS") %>%
  mutate(Name = gsub("School", "Ltd.", Name))



# User interface ----------------------------------------------------------



ui <- fluidPage(
  
  theme = shinythemes::shinytheme("cerulean"),

  
  # Application title
  titlePanel("Record Contact"),
  
  # panels
  
  navlistPanel(
    widths = c(2, 10),
  
    tabPanel(
      "About this app",  # tab name
      
      h3("Purpose"),  # new subsection
      HTML(
        "<p>This is a dummy app to show the possibilities for analysts in our department to:
        <ul>
        <li>keep a record of the research projects that have taken place</li>
        <li>keep a record of organisations that we have contacted in these projects</li>
        <li>explore data about organisations with whom we've had contact</li>
        <li>use this infomration to inform the design of future studies, including the sampling of organisations for contact
        </ul>
        <p>'Contact' in this context is defined as any interaction for research purposes."
      ),  # end of subsection
      
      h3("The data"),  # new subsection
      HTML(
        "<p>All the data are <b>completely fake</b> and any relation to existing organisations is coincidental.
        <p> The data were generated using the <a href='https://github.com/ropensci/charlatan'>charlatan</a> package for R."
      ),  # end of subsection
      
      h3("Publishing details"),  # new subsection
      HTML("Matt Dray, Feb 2018, version 0.1")
      
    ),  # end of tabPanel
    
    
    tabPanel(
      "How to use",  # tab name
      
      h3("Navigate"),
      HTML(
        "<p>You are presented initially with a table containing the full dataset.
        <p>The table is grouped into 'pages' of 10 rows. You can navigate through these pages using the 'Next' and 'Previous' buttons in the lower right corner.
        <p>You can also jump straight to one of the pages numbered in this area. This defaults to the first and last pages (i.e. 1 and 250, your current page, and the ones immediately before and after it.
        <p>You can alter the number of rows displayed per page with the 'Show X entries' dropdown menu in the upper left corner (i.e. 10, 20 or 'all')."
        ),
      
      h3("Search, sort and filter"),
      HTML(
        "<p>To <i>search</i> the data you can type any single phrase or value in the search box (upper right).
        <p>To <i>sort</i> the data, you can click any of the column headers to arrange by that variable in ascending (blue arrow pointing up) or descending order (pointing down).
        <p>To <i>filter</i> the data, click in the boxes below the column header names and -- depending on teh data type -- either select from the dropdown (factors), type a phrase (string)  or use the sliders (dates). You can filter on multiple columns and make several selections from within each column."
        ),
      
      h3("Copy and download"),
      HTML(
        "Once you've made your selections you can:
        <ul>
        <li>copy the selection to your clipboard with the 'Copy' button
        <li>download the selection using 'Download' button (choose from .csv, .xlsx and .pdf outputs)
        </ul>"
        ),

      h3("Variables"),
      HTML(
        "<table style='width:75%'>
        <tr>
        <th>Variable</th>
        <th>Description</th> 
        <th>Example</th>
        </tr>
        <tr>
        <td>Name</td>
        <td>The name of the organisation</td>
        <td><i>Holostigma school</i></td>
        </tr>
        <tr>
        <td>URN</td>
        <td>The Unique Reference Number for the organisation</td>
        <td><i>123456</i></td>
        </tr>
        <tr>
        <td>Reason tag</td>
        <td>Short phrase to describe the theme of the project</td>
        <td><i>Accountability</i></td>
        </tr>
        <tr>
        <td>Reason text</td>
        <td>Short free-text to explain the project in more depth than the tag alone</td>
        <td><i>To gather evidence on accountability</i></td>
        </tr>
        <tr>
        <td>Mode</td>
        <td>Through what medium the contact was made</td>
        <td><i>Email</i></td>
        </tr>
        <tr>
        <td>Contact start</td>
        <td>The date on which contact began</td>
        <td><i>2017-01-01</i></td>
        </tr>
        <tr>
        <td>Contact end</td>
        <td>The date on which contact ended</td>
        <td><i>2017-12-31</i></td>
        </tr>
        <tr>
        <td>Research ref</td>
        <td>A unique value that identifies the project</td>
        <td><i>11.88782/27976-33440-4281</i></td>
        </tr>
        <tr>
        <td>Lead</td>
        <td>The email address of the lead researcher on the project</td>
        <td><i>example@email.com</i></td>
        </tr>
        </table>")

    )  # end of tabPanel  
  

  , tabPanel(
    "The data table",
    DT::dataTableOutput("fancyTable") # Show a plot of the generated distribution
  ) # end of tabPanel
  
  ) # end of navlistPanel
) # end of fluid page


# Server ------------------------------------------------------------------


# Define server logic required to create datatable
server <- function(input, output) {
  
  output$fancyTable <- DT::renderDataTable(
    datatable( data = fake
               , filter = "top"
               , extensions = 'Buttons'
               , options = list(
                 autoWidth = TRUE  # column width consistent when making selections
                 , dom = "Blfrtip"
                 , buttons = 
                   list("copy", list(
                     extend = "collection"
                     , buttons = c("csv", "excel", "pdf")
                     , text = "Download"
                   ) ) # end of buttons customization
                 
                 # customize the length menu
                 , lengthMenu = list( c(10, 20, -1) # declare values
                                      , c(10, 20, "All") # declare titles
                 ) # end of lengthMenu customization
                 , pageLength = 10
                 
                 
               ) # end of options
               
    ) # end of datatables
  )
} # end of server

# Run the application 
shinyApp(ui = ui, server = server)