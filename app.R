library(shiny)
library(shinyhelper)

ui <- fluidPage(
  title = "Student t-tests",
  tags$link(rel = "stylesheet", type = "text/css", href="style.css"),
  div(class = "page-header text-center", h1("Student's t-tests")),
  sidebarLayout(
    sidebarPanel = sidebarPanel(
      h3('Control Panel'), hr(),
      div(
        fileInput('uploaded_dataset', 'Upload file'),
        textOutput('uploaded_text')
      ),
      helper( # TODO: help file content
        content = 'format',
        fade = TRUE,
        radioButtons(
          'format',
          'Data format',
          choices = list('Long' = 'long', 'Wide' = 'wide')
        )
      ),
      uiOutput('variables_ui'), hr(),
      numericInput(
        'n_bins',
        'Number of histogram bins',
        value = 10,
        min = 5,
        max = 30
      )
    ),
    mainPanel = mainPanel(
      h1('Descriptives'),
      fluidRow(
        column(
          6,
          h2('Group 1'),
          p(class = 'mean', 'Mean: ', textOutput('g1_mean')),
          p(class = 'sd', 'Std. deviation: ', textOutput('g1_sd'))
        ),
        column(
          6,
          h2('Group 2'),
          p(class = 'mean', 'Mean: ', textOutput('g2_mean')),
          p(class = 'sd', 'Std. deviation: ', textOutput('g2_sd'))
        ),
      ), hr(),
      h1('t-test'),
      h2('Two-sample, ', textOutput('test_type')),
      tableOutput('test_output')
    )
  )
)

server <- function(input, output, session) {
  observe_helpers()
  
  # import data
  dtf_path <- reactive({ input$uploaded_dataset$datapath })
  dtf <- reactive({ if (!is.null(dtf_path())) read.csv(dtf_path()) })
  
  # name selectors ui
  output$variables_ui <- renderUI({
    if (input$format == "long") {
      div(
        selectizeInput(
          'dv',
          'Dependent varaible',
          choices = c('Choose a variable' = '', names(dtf()))
        ),
        selectInput(
          'iv',
          'Independent (grouping) variable',
          choices = c('Choose a variable' = '', names(dtf()))
        )
      )
    } else {
      div(
        selectInput(
          'v1',
          'Sample 1',
          choices = c('Choose a variable' = '', names(dtf()))
        ),
        selectInput(
          'v2',
          'Sample 2',
          choices = c('Choose a variable' = '', names(dtf()))
        )
      )
    }
  })
  
  # test output
  output$test_output <- renderTable({
    data.frame(
      name  = c("Test statistic", "Degrees of freedom", "p-value"),
      value = 1:3
    )
  },
  colnames = FALSE, width = "100%", align = 'l')
}

shinyApp(ui, server)