dbSidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem('Prepare', tabName = 'prep', icon = icon('file-upload')),
    menuItem('Explore', tabName = 'explore', icon = icon('search')),
    menuItem('Analyze', tabName = 'analyze', icon = icon('chart-bar'))
  )
)