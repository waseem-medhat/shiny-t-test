longVariablesUI <- function(dtf) {
  div(
    selectizeInput(
      'dv',
      'Dependent varaible',
      choices = c('Choose a variable' = '', names(dtf))
    ),
    selectInput(
      'iv',
      'Independent (grouping) variable',
      choices = c('Choose a variable' = '', names(dtf))
    ),
    uiOutput('iv_binary_warning')
  )
}

wideVariablesUI <- function(dtf) {
  div(
    selectInput(
      'v1',
      'Sample 1',
      choices = c('Choose a variable' = '', names(dtf)),
      selected = ''
    ),
    selectInput(
      'v2',
      'Sample 2',
      choices = c('Choose a variable' = '', names(dtf)),
      selected = ''
    )
  )
}