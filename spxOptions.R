#.rs.restartR()
rm(list = ls())

library(RcppBDT)
library(quantmod)
library(timeDate)
library(tidyverse)
library(RQuantLib)
library(data.table)

options(digits = 15)

################################################################################
###### --- Merging SPY Options and Spot Rate Data --- ##########################
################################################################################

d1 <- data.frame(fread("C:\\Users\\kim_t\\Desktop\\data\\options\\db1_2022-09-21_142854.csv", 
      data.table = FALSE)) %>% 
      rename(ticker = act_symbol, expr_date = expiration, k = strike, c_p = call_put) %>% 
      mutate(date = as.Date(date), expr_date = as.Date(expr_date), mid = 0.5 * (bid + ask), 
             c_p = if_else(c_p == "Call", "c", "p")) %>%
      filter(ticker == "SPY", date >= (Sys.Date()-100)) %>%
      arrange(date, expr_date, k) 

d2 <- data.frame(getSymbols("SPY", from = min(d1$date), to = max(d1$date), auto.assign = FALSE)) %>%
      rownames_to_column() %>%
      rename("date" = 1, "open" = 2, "high" = 3, "low" = 4, "close" = 5, "volume" = 6, "adj" = 7) %>% 
      mutate(ticker = "SPY", date = as.Date(date)) %>%
      select(-ticker)

d3 <- inner_join(d1, d2, by = c("date")) %>% 
      mutate(comments = "") %>%
      arrange(date, expr_date, k) 

################################################################################
###### --- Trading and Rebalance (3rd Friday) Days --- #########################
######
###### Columbus Day is NOT a holiday
###### Good Friday is
################################################################################

holidays <- as.Date(c(holidayNYSE(2019), holidayNYSE(2020), holidayNYSE(2021), holidayNYSE(2022)))

dates <- seq(min(d1$date), max(d1$date), by = 1) 
dates <- dates[!(weekdays(dates) %in% c("Saturday", "Sunday"))]
dates <- dates[!(dates %in% holidays)]

rebalanceDays <- vector()
for (i in 2020:2022) {
  
  for (j in 1:12) {
    
    temp <- getNthDayOfWeek(third, Fri, j, i)
    
    if (temp < min(d3$date)) {
      
      next;
    }
    if (temp > max(d3$date)) {
      
      break;
    }
    while(TRUE) {
      
      if (!(temp %in% d3$date)) {
       
        temp <- temp-1 
        print(temp)
      }
      else {
        
        rebalanceDays <- c(rebalanceDays, as.character(temp))
        break;
      }
    }
  }
}; rebalanceDays <- as.Date(rebalanceDays)

d3 <- d3 %>% 
      filter(expr_date %in% rebalanceDays, 
      abs(as.numeric(date - expr_date)) <= max(as.numeric(diff(rebalanceDays))))





