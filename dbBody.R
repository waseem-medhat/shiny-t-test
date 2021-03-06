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
                          column(8, uiOutput('variables_ui')))),
          boxDef('Display', dataTableOutput('dtf')))
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
                                 checkboxInput('mean_overlay',
                                               'Show mean'),
                                 checkboxInput('density_overlay',
                                               'Show density curve')),
                          column(6, uiOutput('explore_ui')))),
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
          boxDef('Tweak',
                 fluidRow(column(4,
                                 checkboxInput('paired', 'Paired'),
                                 checkboxInput('var_equal', 'Assume equal variances')),
                          column(8, uiOutput('analyze_ui')))),
          boxDef('Output',
                 tableOutput('test_output')))
}

dbBody <- dashboardBody(
  shinyDashboardThemes(theme = 'grey_dark'),
  tabItems(
    prepTabItem(),
    exploreTabItem(),
    analyzeTabItem()
  )
)
