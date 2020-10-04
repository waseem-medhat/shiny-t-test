ggDarkTheme <- function() {
  theme_minimal(base_size = 14) +
    theme(axis.text = element_text(color = 'gray90'),
          panel.background = element_blank(),
          panel.grid = element_blank(),
          rect = element_rect(fill = 'transparent', color = NA))
}