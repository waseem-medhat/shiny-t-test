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
      )
    ),
    tabItem(
      'explore'
    )
  )
)