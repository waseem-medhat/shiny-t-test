library(shiny)
library(shinyhelper)
library(shinydashboard)
library(dashboardthemes)
library(shinyWidgets)
library(DT)
library(ggplot2)
library(foreign)

source('dbSidebar.R')
source('dbBody.R')
source('ggDark.R')
source('variablesUI.R')

ui <- dashboardPage(
  title = "Shiny t-Test",
  header = dashboardHeader(title = shinyDashboardLogo(
    theme = 'grey_light',
    boldText = 'Shiny t-Test',
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
  dtf <- reactive({ if (dtf_exists()) {
    if (input$file_type == 'csv') {
      read.csv(dtf_path()) }
    else if (input$file_type == 'spss') {
      read.spss(dtf_path(), to.data.frame = TRUE)
    }
  }})
  
  # name selectors ui
  output$variables_ui <- renderUI({
    if (input$format == "long") longVariablesUI(dtf()) else wideVariablesUI(dtf())
  })
  
  # explore button ui
  output$explore_ui <- renderUI({
    if (
      all(is_long(), input$dv != '', input$iv != '') |
      all(!is_long(), input$v1 != '', input$v2 != '')
    ) {
      alert('Ready to explore!', status = 'success',
            actionButton(class = 'btn-primary',
                         style = 'margin: auto 15px;',
                         'explore', 'Start/Update'))
    } else {
      alert('Make sure you successfully uploaded data and chose your variables.',
            status = 'danger')
    }
  })
  
  # analyze button ui
  output$analyze_ui <- renderUI({
    if (
      all(is_long(), input$dv != '', input$iv != '') |
      all(!is_long(), input$v1 != '', input$v2 != '')
    ) {
      alert('Ready to analyze!', status = 'success',
            actionButton(class = 'btn-primary',
                         style = 'margin: auto 15px;',
                         'analyze', 'Start/Update'))
    } else {
      alert('Make sure you successfully uploaded data and chose your variables.',
            status = 'danger')
    }
  })
  
  # extract data
  is_long <- reactive({ input$format == 'long' })
  iv <- reactive({ if (is_long()) dtf()[, input$iv] })
  dv <- reactive({ if (is_long()) dtf()[, input$dv] })
  g1 <- reactive({ if (is_long()) unique(iv())[1] })
  g2 <- reactive({ if (is_long()) unique(iv())[2] })
  s1 <- reactive({
    if (is_long()) dv()[iv() == g1()] else dtf()[, input$v1]
  })
  s2 <- reactive({
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
  g1_mean <- reactive({ mean(s1()) })
  g2_mean <- reactive({ mean(s2()) })
  g1_sd <- reactive({ sd(s1()) })
  g2_sd <- reactive({ sd(s2()) })
  
  # plots
  g1_hist <- eventReactive(input$explore, {
    ggDarkHist(s1(), input$n_bins) +
      { if (input$mean_overlay) ggDarkVline(g1_mean()) } +
      { if (input$density_overlay) ggDarkDensity() }
  })
  g2_hist <- eventReactive(input$explore, {
    ggDarkHist(s2(), input$n_bins) +
      { if (input$mean_overlay) ggDarkVline(g2_mean()) } +
      { if (input$density_overlay) ggDarkDensity() }
  })
  
  # test output
  t_obj <- eventReactive(input$analyze, {
    t.test(
      x = s1(),
      y = s2(),
      paired = input$paired,
      var.equal = input$var_equal
    )
  })
  output_df <- eventReactive(input$analyze, {
    data.frame(
      name  = c("Test statistic", "Degrees of freedom", "p-value"),
      value = c(t_obj()$statistic, t_obj()$parameter, t_obj()$p.value)
    )
  })
  
  # renders
  output$dtf <- renderDataTable({ dtf() },
                                options = list(scrollX = TRUE,
                                               scrollY = 250,
                                               scrollCollapse = TRUE,
                                               paging = FALSE))
  observeEvent(input$explore, {
    output$g1_mean <- renderText({ paste("Mean:", round(g1_mean(), 3)) })
    output$g2_mean <- renderText({ paste("Mean:", round(g2_mean(), 3)) })
    output$g1_sd <- renderText({ paste("Std. deviation:", round(g1_sd(), 3)) })
    output$g2_sd <- renderText({ paste("Std. deviation:", round(g2_sd(), 3)) })
    output$g1_hist <- renderPlot(bg = 'transparent', { g1_hist() })
    output$g2_hist <- renderPlot(bg = 'transparent', { g2_hist() })
  })
  
  observeEvent(input$analyze, {
    output$test_output <- renderTable({ output_df() },
                                      colnames = FALSE,
                                      width = "100%",
                                      align = 'l')
  })
}

shinyApp(ui, server)