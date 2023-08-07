library(ggplot2)
theme_max <- function(){
    theme(
        panel.grid.minor = element_blank(),
        axis.title = element_text(face = "italic"),
        plot.subtitle = element_text(face = "italic"),
        plot.caption = element_text(face = "italic", size = 10),
        legend.position = "top"
    )
}