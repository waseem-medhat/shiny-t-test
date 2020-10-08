ggDarkTheme <- function() {
  theme_minimal(base_size = 14) +
    theme(axis.text = element_text(color = 'gray90'),
          panel.background = element_blank(),
          panel.grid = element_blank(),
          rect = element_rect(fill = 'transparent', color = NA))
}

ggDarkHist <- function(var, n_bins) {
  ggplot(NULL, aes(var, ..density..)) +
    geom_histogram(bins = n_bins, fill = 'gray80', color = 'gray10', alpha = 0.5) +
    labs(x = '', y = '') +
    ggDarkTheme()
}

ggDarkVline <- function(mean) {
  geom_vline(xintercept = mean, color = 'aquamarine2', size = 1, linetype = 2)
}

ggDarkDensity <- function() {
  geom_density(size = 1, color = 'gold')
}