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
