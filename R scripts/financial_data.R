# Alpha Query ----
alpha_query_get_earnings_history <- function(ticker){
    tryCatch(
        {
            output_tbl <- read_html(paste0("https://www.alphaquery.com/stock/", ticker,"/earnings-history")) %>% 
                html_table() %>% 
                pluck(1) %>% 
                janitor::clean_names()
            
            return(output_tbl)
        },
        error = function(e) {
            message(paste("Unable to retrieve earnings history for", ticker, "- Error message:", e$message))
            return(NULL)
        }
    )
}

alpha_query_get_upcoming_earnings_data <- function(ticker){
    output_tbl <- try({
        read_html(paste0("https://www.alphaquery.com/stock/", ticker, "/earnings-history")) %>% 
            html_elements("#below-chart-text") %>% 
            html_elements("strong") %>% 
            html_text2() %>% 
            as_tibble() %>% 
            slice(5:7) %>% 
            t() %>% 
            as_tibble() %>% 
            set_names(c("announcement_date", "estimated_eps", "fiscal_quarter_end"))
    })
    
    return(output_tbl)
}


# Yahoo Finance ----
yf_get_price_data <- function(ticker, date, end_date){
    return(try(tq_get(ticker, from = date, to = end_date)))
}


# Calculations ----
calculate_rolling_correlation <- function(data, target_ticker, periods) {
    data_split <- data %>% split(.$ticker)
    target_data <- data_split[[target_ticker]]
    
    calculate_cor <- function(target_data, other_data, period) {
        merged_data <- full_join(target_data, other_data, by = "date") %>%
            select(date, target = price.x, other = price.y) %>%
            na.omit()
        
        result <- rollapply(data = merged_data[, c("target", "other")], 
                            width = period, 
                            FUN = function(x) cor(x[, 1], x[, 2]), 
                            by.column = FALSE, 
                            align = "right")
        
        return(data.frame(date = merged_data$date[(period):nrow(merged_data)], cor = result))
    }
    
    results <- list()
    for (ticker in names(data_split)) {
        if (ticker != target_ticker) {
            for (period in periods) {
                result <- calculate_cor(target_data, data_split[[ticker]], period)
                colname <- paste0("cor_", period, "_", target_ticker, "_", ticker)
                result <- result %>% rename(!!colname := cor)
                results[[colname]] <- result
            }
        }
    }
    
    output <- reduce(results, left_join, by = "date")
    return(as_tibble(output))
}