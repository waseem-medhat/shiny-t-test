library(shiny)
library(shinyhelper)
library(ggplot2)

theme_set(theme_light())

ui <- fluidPage(
  title = "Student t-tests",
  tags$link(rel = "stylesheet", type = "text/css", href="style.css"),
  div(class = "page-header text-center", h1("Student's t-tests")),
  sidebarLayout(
    sidebarPanel = sidebarPanel(
      h3('Control Panel'), hr(),
      div(
        fileInput(
          'uploaded_dataset',
          'Upload file',
          buttonLabel = icon('file-upload')
        ),
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
          textOutput('g1_mean'),
          textOutput('g1_sd'),
          plotOutput('g1_hist')
        ),
        column(
          6,
          h2('Group 2'),
          textOutput('g2_mean'),
          textOutput('g2_sd'),
          plotOutput('g2_hist')
        )
      ),
      hr(),
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
  dtf_exists <- reactive({ !is.null(dtf_path()) })
  dtf <- reactive({ if (dtf_exists()) read.csv(dtf_path()) else iris })
  
  # name selectors ui
  output$variables_ui <- renderUI({
    if (input$format == "long") {
      div(
        selectizeInput(
          'dv',
          'Dependent varaible',
          choices = c('Choose a variable' = '', names(dtf())), selected = 'Sepal.Length'
        ),
        selectInput(
          'iv',
          'Independent (grouping) variable',
          choices = c('Choose a variable' = '', names(dtf())), selected = 'Species'
        ), actionButton('printer', 'printer')
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
  
  # extract data
  iv <- reactive({ dtf()[, input$iv] })
  dv <- reactive({ dtf()[, input$dv] })
  g1 <- reactive({ unique(iv())[1] })
  g2 <- reactive({ unique(iv())[2] })
  s1 <- reactive({ dv()[iv() == g1()] })
  s2 <- reactive({ dv()[iv() == g2()] })
  
  # descriptives
  g1_mean <- reactive({ mean(s1()) })
  g2_mean <- reactive({ mean(s2()) })
  g1_sd <- reactive({ sd(s1()) })
  g2_sd <- reactive({ sd(s2()) })
  
  # plots
  g1_hist <- reactive({
    ggplot(NULL, aes(s1())) +
      geom_histogram(bins = input$n_bins, fill = 'gray20') +
      geom_vline(xintercept = g1_mean(), color = 'steelblue', size = 2) +
      labs(x = '', y = '')
  })
  g2_hist <- reactive({
    ggplot(NULL, aes(s2())) +
      geom_histogram(bins = input$n_bins, fill = 'gray20') +
      geom_vline(xintercept = g2_mean(), color = 'steelblue', size = 2) +
      labs(x = '', y = '')
  })
  
  # test output
  output_df <- reactive({
    data.frame(
      name  = c("Test statistic", "Degrees of freedom", "p-value"),
      value = rep(NA, 3)
    )
  })
  
  # renders
  output$g1_mean <- renderText({
    paste( "Mean:", round(g1_mean(), 3) ) 
  })
  output$g2_mean <- renderText({
    paste( "Mean:", round(g2_mean(), 3) ) 
  })
  output$g1_sd <- renderText({
    paste( "Std. deviation:", round(g1_sd(), 3) ) 
  })
  output$g2_sd <- renderText({
    paste( "Std. deviation:", round(g2_sd(), 3) ) 
  })
  output$g1_hist <- renderPlot({
    g1_hist()
  })
  output$g2_hist <- renderPlot({
    g2_hist()
  })
  output$test_output <- renderTable(
    output_df(),
    colnames = FALSE,
    width = "100%",
    align = 'l'
  )
}

shinyApp(ui, server)