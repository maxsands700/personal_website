__all__ = ['theme_max', 'scale_fill_max_d', 'scale_color_max_d',
           'scale_fill_max_c', 'scale_color_max_c',
           'scale_fill_max_seq', 'scale_color_max_seq']

from plotnine import theme, theme_bw, element_text, element_line, element_blank, scale_fill_manual, scale_color_manual, scale_fill_gradientn, scale_color_gradientn

def theme_max(minimal=False, base_size=11):
    theme_elements = {
        'plot_caption': element_text(face='italic', size=10, ha='right', color='#5c5c5c'),
        'plot_subtitle': element_text(size=base_size * 1.15, face='plain', ha='center', color='#5c5c5c'),
        'plot_title': element_text(size=base_size * 1.3, face='bold', ha='center', color='#040404'),
        'axis_text': element_text(face='italic', color='#040404'),
        'legend_position': 'bottom',
        'axis_line': element_line(size=.9, color='#040404'),
        'axis_ticks': element_line(size=.9, color='#040404'),
        'panel_border': element_blank()
    }

    if minimal:
        theme_elements.update({
            'panel_grid_major': element_blank(),
            'panel_grid_minor': element_blank(),
            'axis_ticks': element_blank()
        })

    return theme_bw(base_size=base_size) + theme(**theme_elements)


# Discrete color scales
def scale_fill_max_d(type=1):
    discrete_colors = {
        1: ["#040404", "#7118c1", "#5c5c5c", "#ecebec", "#9357c6", "#3f0d6c"],
        2: ["#7118c1", "#040404", "#5c5c5c", "#ecebec", "#9357c6", "#3f0d6c"],
        3: ["#040404", "#7118c1", "#ecebec", "#5c5c5c", "#9357c6", "#3f0d6c"],
        4: ["#040404", "#7118c1", "#9357c6", "#5c5c5c", "#ecebec", "#3f0d6c"],
    }.get(type, ["#040404", "#7118c1", "#5c5c5c", "#ecebec", "#9357c6", "#3f0d6c"])
    return scale_fill_manual(values=discrete_colors)

def scale_color_max_d(type=1):
    discrete_colors = {
        1: ["#040404", "#7118c1", "#5c5c5c", "#ecebec", "#9357c6", "#3f0d6c"],
        2: ["#7118c1", "#040404", "#5c5c5c", "#ecebec", "#9357c6", "#3f0d6c"],
        3: ["#040404", "#7118c1", "#ecebec", "#5c5c5c", "#9357c6", "#3f0d6c"],
        4: ["#040404", "#7118c1", "#9357c6", "#5c5c5c", "#ecebec", "#3f0d6c"],
    }.get(type, ["#040404", "#7118c1", "#5c5c5c", "#ecebec", "#9357c6", "#3f0d6c"])
    return scale_color_manual(values=discrete_colors)

# Continuous color scales
def scale_fill_max_c(type=1):
    continuous_colors = {
        1: ["#040404", "#ecebec"], # From black to light grey
        2: ["#9357c6", "#ecebec"], # From purple to light grey
    }.get(type, ["#040404", "#ecebec"])
    return scale_fill_gradientn(colors=continuous_colors)

def scale_color_max_c(type=1):
    continuous_colors = {
        1: ["#040404", "#ecebec"], # From black to light grey
        2: ["#9357c6", "#ecebec"], # From purple to light grey
    }.get(type, ["#040404", "#ecebec"])
    return scale_color_gradientn(colors=continuous_colors)

# Sequential color scales
def scale_fill_max_seq(n=5):
    # Adjust the number of colors based on n
    colors = ["#040404", "#7118c1", "#9357c6", "#5c5c5c", "#ecebec"]
    return scale_fill_manual(values=colors[:n])

def scale_color_max_seq(n=5):
    # Adjust the number of colors based on n
    colors = ["#040404", "#7118c1", "#9357c6", "#5c5c5c", "#ecebec"]
    return scale_color_manual(values=colors[:n])