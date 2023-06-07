library(ggplot2)
theme_max <- theme(
        plot.title = element_text(hjust = .5, size = 20),
        plot.subtitle = element_text(hjust = .5, size = 16),
        plot.caption = element_text(size = 10, face = "italic",
                                    margin = margin(t = 20)),
        axis.title.x = element_text(margin = margin(t = 10)),
        text = element_text(family = "AppleGothic")
    )
