monte_carlo <- function(returns_vec, num_simulations = 200, number_of_time_periods = 90,
                        number_of_returns_averaged = 5, prop_profits_kept = .67, replace = T){
    tibble(
        trial = 1:num_simulations,
        simulation = map(
            1:num_simulations,
            ~ tibble(
                day = 1:number_of_time_periods,
                return = replicate(
                    n = number_of_time_periods,
                    mean(sample(returns_vec, size = number_of_returns_averaged, replace = replace)) * prop_profits_kept
                )
            )
        )
    )
}

plot_monte_carlo <- function(monte_carlo_tbl, raw = T, quantiles){
    
    if(raw){
        g <- monte_carlo_tbl %>% 
            unnest(simulation) %>% 
            group_by(trial) %>% 
            mutate(wealth = cumprod(1 + return)) %>% 
            ungroup() %>% 
            mutate(trial = as.factor(trial)) %>% 
            ggplot(aes(day, wealth, color = trial)) +
            geom_line() +
            theme_tq() +
            scale_color_tq() +
            scale_y_continuous(labels = scales::label_dollar()) +
            labs(title = "Monte Carlo Simulation") +
            theme(legend.position = "none", plot.title = element_text(hjust = .5))
    }
    
    if(!raw){
        g <- monte_carlo_tbl %>% 
            unnest(simulation) %>% 
            group_by(trial) %>% 
            mutate(wealth = cumprod(1 + return)) %>% 
            ungroup() %>% 
            group_by(day) %>% 
            mutate(wealth_quantile = ntile(wealth, quantiles)) %>% 
            ungroup() %>% 
            group_by(day, wealth_quantile) %>% 
            summarize(median_wealth = median(wealth)) %>% 
            ungroup() %>% 
            mutate(wealth_quantile = as.factor(wealth_quantile)) %>% 
            ggplot(aes(day, median_wealth, color = wealth_quantile)) +
            geom_smooth(se = F) +
            theme_tq() +
            scale_color_tq() +
            scale_y_continuous(labels = scales::label_dollar()) +
            labs(title = "Monte Carlo Simulation", subtitle = str_glue("Median Value of {quantiles} Quantiles")) +
            theme(legend.position = "none", plot.title = element_text(hjust = .5), plot.subtitle = element_text(hjust = .5))
    }
    
    return(g)
}
