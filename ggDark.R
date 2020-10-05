ggDarkTheme <- function() {
  theme_minimal(base_size = 14) +
    theme(axis.text = element_text(color = 'gray90'),
          panel.background = element_blank(),
          panel.grid = element_blank(),
          rect = element_rect(fill = 'transparent', color = NA))
}

ggDarkHist <- function(var, mean, n_bins) {
  ggplot(NULL, aes(var)) +
    geom_histogram(bins = n_bins, fill = 'gray80', color = 'gray10') +
    geom_vline(xintercept = mean, color = 'steelblue',
               size = 1, linetype = 2) +
    labs(x = '', y = '') +
    ggDarkTheme()
}