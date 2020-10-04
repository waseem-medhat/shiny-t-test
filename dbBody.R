source("boxDef.R")

prepTabItem <- function() {
  tabItem('prep',
          boxDef('Import',
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
          boxDef('Select variables',
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
          boxDef(title = 'Tweak',
                 fluidRow(column(3,
                                 numericInput('n_bins',
                                              'Histogram bins',
                                              value = 10,
                                              min = 5,
                                              max = 30)),
                          column(3,
                                 checkboxInput('normal_overlay',
                                               'Show normal curve overlay')),
                          column(6, uiOutput('start_ui')))),
          fluidRow(column(6,
                          boxDef('Group 1',
                                 textOutput('g1_mean'),
                                 textOutput('g1_sd'),
                                 plotOutput('g1_hist'))),
                   column(6,
                          boxDef('Group 2',
                                 textOutput('g2_mean'),
                                 textOutput('g2_sd'),
                                 plotOutput('g2_hist')))))
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
  tabItems(
    prepTabItem(),
    exploreTabItem(),
    analyzeTabItem()
  )
)
