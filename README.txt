############################################################################################################
###### --- README --- ######################################################################################
############################################################################################################
# 
# --- The spxOptions.R file processes and retrieves daily SPX options data. Ideally our options are rebalanced 
# --- every 3rd Friday, but the option dataset at our disposal is sparse and therefore we opt for a weekly 
# --- rebalanced strategy for all our indices, which would mean increased transaction costs. Of course, this
# --- is all theoretical and tradable ETFs will be tailored for various maturities. In case there are missing 
# --- bid/ask data, an OLS (simple linear regression) method from Monday to Friday interpolates and extrapolates the 
# --- mid price for the remaining missing weekly data.
