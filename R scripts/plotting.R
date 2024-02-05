# Plotting Functions ----

## Themes ----
theme_max <- function(minimal = FALSE, base_size = 11) {
    
    base_theme <- theme_bw(base_size = base_size) %+replace% theme(
        # Common Text Elements
        plot.caption  = element_text(face = "italic", size = 10, hjust = 1, color = "#5c5c5c"),
        plot.subtitle = element_text(size = base_size * 1.15, face = "plain", hjust = 0.5, color = "#5c5c5c"),
        plot.title    = element_text(size = base_size * 1.3, face = "bold", hjust = 0.5, color = "#040404"),
        axis.text     = element_text(face = "italic", color = "#040404"),
        
        # Common Legend
        legend.position = "bottom",
        
        # Common Axis Elements
        axis.line = element_line(size = .9, color = "#040404"),
        axis.ticks = element_line(size = .9, color = "#040404"),
        panel.border = element_blank()
    )
    
    if (minimal) {
        base_theme %+replace% theme(
            # Grid Elements for Minimal Theme
            panel.grid.major = element_blank(),
            panel.grid.minor = element_blank(),
            axis.ticks = element_blank()
        )
    } else {
        base_theme
    }
}



## Colors ----
# Discrete color scale
scale_fill_max_d <- function(type = 1) {
    discrete_palette <- function(n) {
        if(type == 1){
            discrete_colors = c("#040404", "#7118c1", "#5c5c5c", "#ecebec", "#9357c6", "#3f0d6c")
        } else if(type == 2){
            discrete_colors = c("#7118c1", "#040404", "#5c5c5c", "#ecebec", "#9357c6", "#3f0d6c")
        } else if(type == 3){
            discrete_colors = c("#040404", "#7118c1", "#ecebec", "#5c5c5c", "#9357c6", "#3f0d6c")
        } else { # type 4
            discrete_colors = c("#040404", "#7118c1", "#9357c6", "#5c5c5c", "#ecebec", "#3f0d6c")
        }
        return(discrete_colors)
    }
    discrete_scale('fill', 'max_d', palette = discrete_palette)
}

scale_color_max_d <- function(type = 1) {
    discrete_palette <- function(n) {
        if(type == 1){
            discrete_colors = c("#040404", "#7118c1", "#5c5c5c", "#ecebec", "#9357c6", "#3f0d6c")
        } else if(type == 2){
            discrete_colors = c("#7118c1", "#040404", "#5c5c5c", "#ecebec", "#9357c6", "#3f0d6c")
        } else if(type == 3){
            discrete_colors = c("#040404", "#7118c1", "#ecebec", "#5c5c5c", "#9357c6", "#3f0d6c")
        } else { # type 4
            discrete_colors = c("#040404", "#7118c1", "#9357c6", "#5c5c5c", "#ecebec", "#3f0d6c")
        }
        return(discrete_colors)
    }
    discrete_scale('color', 'max_d', palette = discrete_palette)
}

# Continuous color scale with type argument
scale_fill_max_c <- function(type = 1) {
    if (type == 1) {
        continuous_colors = c("#040404", "#ecebec") # From black to light grey
    } else { # type == 2
        continuous_colors = c("#9357c6", "#ecebec") # From purple to light grey
    }
    scale_fill_gradientn(colours = continuous_colors)
}

scale_color_max_c <- function(type = 1) {
    if (type == 1) {
        continuous_colors = c("#040404", "#ecebec") # From black to light grey
    } else { # type == 2
        continuous_colors = c("#9357c6", "#ecebec") # From purple to light grey
    }
    scale_color_gradientn(colours = continuous_colors)
}



# Sequential color scale
scale_fill_max_seq <- function(n = 5) {
    sequential_palette <- colorRampPalette(c("#040404", "#7118c1", "#9357c6", "#5c5c5c", "#ecebec"))
    scale_fill_manual(values = sequential_palette(n))
}

scale_color_max_seq <- function(n = 5) {
    sequential_palette <- colorRampPalette(c("#040404", "#7118c1", "#9357c6", "#5c5c5c", "#ecebec"))
    scale_color_manual(values = sequential_palette(n))
}
