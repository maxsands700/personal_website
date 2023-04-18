library(ggplot2)
theme_max <- theme(
        plot.title = element_text(hjust = .5),
        plot.subtitle = element_text(hjust = .5),
        plot.caption = element_text(size = 10, face = "italic",
                                    margin = margin(t = 20))
    )