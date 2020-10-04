dbBody <- dashboardBody(
  tabItems(
    tabItem(
      'prep',
      fileInput(
        'uploaded_dataset',
        'Upload file',
        buttonLabel = icon('file-upload')
      ),
      radioGroupButtons(
        'file_type',
        'Specify file type',
        choices = list('CSV' = 'csv', 'SPSS' = 'spss')
      ),
      helper(
        content = 'format',
        fade = TRUE,
        radioButtons(
          'format',
          'Data format',
          choices = list('Long' = 'long', 'Wide' = 'wide')
        )
      ),
      uiOutput('variables_ui')
    ),
    tabItem(
      'explore'
    )
  )
)