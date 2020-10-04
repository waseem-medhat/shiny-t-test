library(shiny)
library(shinyhelper)
library(shinydashboard)
library(dashboardthemes)
library(shinyWidgets)
library(ggplot2)

source('dbSidebar.R')
source('dbBody.R')
source('ggDark.R')

ui <- dashboardPage(
  header = dashboardHeader(title = shinyDashboardLogo(
    theme = 'grey_light',
    boldText = 't-test',
    badgeText = ' by Waseem'
  )),
  sidebar = dbSidebar,
  body = dbBody
)

server <- function(input, output, session) {
  observe_helpers()
  
  # import data
  dtf_path <- reactive({ input$uploaded_dataset$datapath })
  dtf_exists <- reactive({ !is.null(dtf_path()) })
  dtf <- reactive({ if (dtf_exists()) read.csv(dtf_path()) })
  
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
        ),
        uiOutput('iv_binary_warning')
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
  
  # action button ui
  output$start_ui <- renderUI({
    if (
      all(dtf_exists(), input$dv != '', input$iv != '') |
      all(dtf_exists(), input$v1 != '', input$v2 != '')
    ) {
      alert('Ready to explore!', status = 'success',
            actionButton(class = 'btn-primary',
                         style = 'margin: auto 15px;',
                         'start', 'Start/Update'))
    } else {
      alert('Make sure you successfully uploaded data and chose your variables.',
            status = 'danger')
    }
  })
  
  # extract data
  is_long <- reactive({ input$format == 'long' })
  iv <- reactive({ if (is_long()) dtf()[, input$iv] })
  dv <- reactive({ if (is_long()) dtf()[, input$dv] })
  g1 <- eventReactive(input$start, { if (is_long()) unique(iv())[1] })
  g2 <- eventReactive(input$start, { if (is_long()) unique(iv())[2] })
  s1 <- eventReactive(input$start, {
    if (is_long()) dv()[iv() == g1()] else dtf()[, input$v1]
  })
  s2 <- eventReactive(input$start, {
    if (is_long()) dv()[iv() == g2()] else dtf()[, input$v2]
  })
  
  # dependent variable warning
  output$iv_binary_warning <- renderUI({
    if (!dtf_exists() | input$iv == '') {
      NULL
    } else if (length(unique(iv())) != 2) {
      alert('The independent variable is not binary.',status = 'danger')
    } else {
      NULL
    }
  })
  
  # descriptives
  g1_mean <- eventReactive(input$start, { mean(s1()) })
  g2_mean <- eventReactive(input$start, { mean(s2()) })
  g1_sd <- eventReactive(input$start, { sd(s1()) })
  g2_sd <- eventReactive(input$start, { sd(s2()) })
  
  # plots
  g1_hist <- eventReactive(input$start, {
    ggplot(NULL, aes(s1())) +
      geom_histogram(bins = input$n_bins, fill = 'gray80', color = 'gray10') +
      geom_vline(xintercept = g1_mean(), color = 'steelblue') +
      labs(x = '', y = '') +
      ggDarkTheme()
  })
  g2_hist <- eventReactive(input$start, {
    ggplot(NULL, aes(s2())) +
      geom_histogram(bins = input$n_bins, fill = 'gray80', color = 'gray10') +
      geom_vline(xintercept = g2_mean(), color = 'steelblue') +
      labs(x = '', y = '') +
      ggDarkTheme()
  })
  
  # test output
  t_obj <- eventReactive(input$start, {
    t.test(
      x = s1(),
      y = s2(),
      paired = input$paired,
      var.equal = input$var_equal
    )
  })
  output_df <- eventReactive(input$start, {
    data.frame(
      name  = c("Test statistic", "Degrees of freedom", "p-value"),
      value = c(t_obj()$statistic, t_obj()$parameter, t_obj()$p.value)
    )
  })
  
  # renders
  observeEvent(input$start, {
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
    output$g1_hist <- renderPlot(bg = 'transparent', {
      g1_hist()
    })
    output$g2_hist <- renderPlot(bg = 'transparent', {
      g2_hist()
    })
    output$test_output <- renderTable(
      output_df(),
      colnames = FALSE,
      width = "100%",
      align = 'l'
    )
  })
}

shinyApp(ui, server)