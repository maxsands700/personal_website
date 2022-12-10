library(tidyverse)
library(tidyquant)
library(lubridate)
library(plotly)

# identify periods where the high yield spread was 'high'
dates_high_spread <- function(data, boundary){
    
    temp_tbl <- data %>% 
        filter(symbol %in% c("hys")) %>% 
        mutate(is_high = case_when(
            value >= boundary & lag(value) < boundary ~ 1,
            value < boundary & lag(value) >= boundary ~ 2,
            T ~ 0
        )) %>% 
        filter(is_high != 0) %>% 
        select(date, is_high)
    
    output_tbl <- tibble(
        start_date = temp_tbl %>% 
            filter(is_high == 1) %>% 
            pull(date),
        end_date = temp_tbl %>% 
            filter(is_high == 2) %>% 
            pull(date),
        y1 = -Inf,
        y2 = Inf
    )
    
    return(output_tbl)
}


# plot time series
plot_time_series <- function(data, boundary){
    ggplot() +
        geom_line(data = data, mapping = aes(date, value, color = name)) +
        geom_rect(data = dates_high_spread(data, boundary),
                  mapping = aes(xmin = start_date, xmax = end_date, ymin = y1, ymax = y2),
                  alpha = .3, color = "grey") +
        facet_wrap(~name, scales = "free", ncol = 1) +
        theme_bw() +
        theme(legend.position = "none") +
        labs(y = "",
             x = "")
}

# calculate return

plot_return <- function(data, boundary = 10, months = 36, slice = 1){
    g <- data %>% 
        filter(symbol %in% c("hyi", "spy")) %>% 
        filter(date >= dates_high_spread(data, boundary) %>% 
                   slice(slice) %>% select(start_date) %>% pull()) %>% 
        filter(date <= dates_high_spread(data, boundary) %>% 
                   mutate(end_period = start_date + months(months)) %>% 
                   slice(slice) %>% pull(end_period)) %>% 
        group_by(symbol) %>% 
        mutate(value = value / first(value)) %>% 
        ungroup() %>% 
        ggplot(aes(date, value, color = name)) +
        geom_line() +
        theme_bw() +
        scale_y_continuous(labels = scales::dollar_format()) +
        labs(x = "", y = "Wealth Index ($1)", color = "")
    
    return(ggplotly(g))
}

