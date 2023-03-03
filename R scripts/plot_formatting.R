library(ggplot2)
theme_max_bw <- theme_bw(base_size = 16, base_family = "serif") +
    theme(plot.title = element_text(hjust = .5),
          plot.subtitle = element_text(hjust = .5),
          legend.position = c(.1, .8),
          legend.background = element_rect(fill = RColorBrewer::brewer.pal(9, "Greys")[2],
                                           color = RColorBrewer::brewer.pal(9, "Greys")[4]),
          plot.caption = element_text(size = 10, face = "italic",
                                      color = RColorBrewer::brewer.pal(9, "Greys")[5]))