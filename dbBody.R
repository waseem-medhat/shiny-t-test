prepTabItem <- function() {
  tabItem('prep',
          box(title = 'Import',
              width = 12,
              status = 'success',
              fluidRow(column(4,
                              radioGroupButtons('file_type',
                                                'Specify file type',
                                                choices = list('CSV' = 'csv',
                                                               'SPSS' = 'spss'),
                                                justified = TRUE)),
                       column(8,
                              fileInput('uploaded_dataset',
                                        'Upload file',
                                        buttonLabel = icon('file-upload'))))),
          box(title = 'Select variables',
              width = 12,
              status = 'success',
              fluidRow(column(4,
                              helper(content = 'format',
                                     fade = TRUE,
                                     colour = '#eee',
                                     radioButtons(
                                       'format',
                                       'Data format',
                                       choices = list('Long' = 'long',
                                                      'Wide' = 'wide')))),
                       column(8, uiOutput('variables_ui')))))
}

exploreTabItem <- function() {
  tabItem('explore',
          box(title = 'Tweak',
              width = 12,
              status = 'success',
              numericInput('n_bins',
                           'Number of histogram bins',
                           value = 10,
                           min = 5,
                           max = 30),
          uiOutput('start_ui')
              ),
          fluidRow(column(6,
                          h2('Group 1'),
                          textOutput('g1_mean'),
                          textOutput('g1_sd'),
                          plotOutput('g1_hist')),
                   column(6,
                          h2('Group 2'),
                          textOutput('g2_mean'),
                          textOutput('g2_sd'),
                          plotOutput('g2_hist'))))
}

analyzeTabItem <- function () {
  tabItem('analyze',
          checkboxInput('paired', 'Paired'),
          checkboxInput('var_equal', 'Assume equal variances'),
          h2('Test output'),
          tableOutput('test_output'))
}

dbBody <- dashboardBody(
  shinyDashboardThemes(theme = 'grey_dark'),
  tags$link(rel = "stylesheet", type = "text/css", href="style.css"),
  tabItems(
    prepTabItem(),
    exploreTabItem(),
    analyzeTabItem()
  )
)
