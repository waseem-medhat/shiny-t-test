dbBody <- dashboardBody(
  tags$link(rel = "stylesheet", type = "text/css", href="style.css"),
  tabItems(
    tabItem(
      'prep',
      box(
        title = 'Import',
        width = 12,
        status = 'info',
        solidHeader = TRUE,
        fluidRow(
          column(
            7,
            fileInput(
              'uploaded_dataset',
              'Upload file',
              buttonLabel = icon('file-upload')
            )
          ),
          column(
            5,
            radioGroupButtons(
              'file_type',
              'Specify file type',
              choices = list('CSV' = 'csv', 'SPSS' = 'spss'),
              justified = TRUE
            )
          )
        )
      ),
      box(
        title = 'Select variables',
        width = 12,
        status = 'info',
        solidHeader = TRUE,
        fluidRow(
          column(
            5,
            helper(
              content = 'format',
              fade = TRUE,
              radioButtons(
                'format',
                'Data format',
                choices = list('Long' = 'long', 'Wide' = 'wide')
              )
            )
          ),
          column(7, uiOutput('variables_ui'))
        )
      ),
      uiOutput('start_ui')
    ),
    tabItem(
      'explore',
      numericInput(
        'n_bins',
        'Number of histogram bins',
        value = 10,
        min = 5,
        max = 30
      ),
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
      )
    ),
    tabItem(
      'analyze',
      checkboxInput('paired', 'Paired'),
      checkboxInput('var_equal', 'Assume equal variances'),
      h2('Test output'),
      tableOutput('test_output')
    )
  )
)
