############################################################################################################
###### --- README --- ######################################################################################
############################################################################################################
# 
############################################################################################################
###### --- spxOptions.R --- ################################################################################
############################################################################################################
#
# --- The spxOptions.R file processes and retrieves daily SPX options data. Ideally our options are rebalanced 
# --- every 3rd Friday, but the option dataset at our disposal is sparse and therefore we opt for a weekly 
# --- rebalanced strategy for all our indices, which would mean increased transaction costs. Of course, this
# --- is all theoretical and tradable ETFs will be tailored for various maturities. In case there are missing 
# --- bid/ask data, an OLS (simple linear regression) method from Monday to Friday interpolates and extrapolates the 
# --- mid price for the remaining missing weekly data.
#
############################################################################################################
###### --- coveredCall.R --- ###############################################################################
############################################################################################################
#
### Key assumptions:
###
###   (1) Options are rebalanced every third Friday of the month. Options are let to EXPIRE 
###       and aren't covered/bought back
###   (2) Strikes are rebalanced at open since midday prices aren't available
###   (3) Rebalanced strike is ATM, if not substituted by an ITM strike that's as ATM as possible, 
###       i.e. strike is the min of all strikes greater than the S&P 500 at open
###   (4) VWAP of the new call is sold at the BID at open since midday prices aren't available
###   (5) VWAP of the S&P 500 is replaced by the S&P 500 at open since midday prices aren't available
###   (6) SPX SOQ is ALSO replaced by the S&P 500 at open, i.e. SPX VWAP/SPX SOQ = 1
###   (7) For any missing options bids and asks, they're replaced by monthly interpolations via OLS
###   (8) For further calculation intricacies, please refer to pgs. 2-3 in the following link:
###       https://cdn.cboe.com/api/global/us_indices/governance/BXM_Methodology.pdf
