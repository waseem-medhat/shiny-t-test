dbSidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem('Upload', icon = icon('file-upload')),
    menuItem('Explore', icon = icon('search')),
    menuItem('Analyze', icon = icon('chart-bar'))
  )
)