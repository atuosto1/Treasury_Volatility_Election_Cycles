library(quantmod)  # <=== load the package "quantmod"
library(timeSeries) # Library from module 3
library(fBasics)  #<== Load the package "fBasics"

getSymbols("DGS10", src="FRED", from = "1981-09-01", to = "2025-11-24")

#To clean data (10 Year)
DGS10 = na.omit(DGS10)
ret_DGS10=diff(DGS10)
return_DGS10 = na.omit(ret_DGS10)

#Code to plot yield of 10 year treasury bond.
plot(DGS10, main = "",col = "darkblue", yaxis.right = FALSE, ylab="Yield", xlab = "Date")   # <- Plots treasury yields throughout the time period we have.
axis(4, labels = FALSE, tick = FALSE) # takes the axis labels off of the right side
title("10-year Treasury Yield",
     col.main = "black",
     cex.main = "1.5",
     adj = .5,
     line = 2.5 ) # formats the title to reflect what I want "10 year treasury yield"

#Plotting Return not yield
plot(return_DGS10, main = "",col = "darkblue", yaxis.right = FALSE, ylim=c(-1,1), ylab="Return", 
     xlab = "Date")# <- Plots treasury yields throughout the time period we have.
axis(4, labels = FALSE, tick = FALSE) # takes the axis labels off of the right side

title("10-year Treasury Return",
      col.main = "black",
      cex.main = "1.5",
      adj = .5,
      line = 2.5 )

#ADF to test if stationary
library(tseries)
#for 10 year yield
adf.test(DGS10) # P Value < 0.05, reject the null of unit root. not significant at 1% level
adf.test(return_DGS10) # P Value is so small it is significant at the 1% level

#Summary Statistics
basicStats(DGS10) 
basicStats(return_DGS10)

######################################################################################################

#3 months
getSymbols("DGS3MO", src="FRED", from = "1981-09-01", to = "2025-11-24")

#To clean data 
DGS3MO = na.omit(DGS3MO)
ret_DGS3MO=diff(DGS3MO)
return_DGS3MO = na.omit(ret_DGS3MO)
#Code to plot yield of 3 month treasury bond.
plot(DGS3MO, main = "",col = "darkgreen", yaxis.right = FALSE, ylab="Yield", xlab = "Date")# <- Plots treasury yields throughout the time period we have.
axis(4, labels = FALSE, tick = FALSE) # takes the axis labels off of the right side
title("3-Month Treasury Yield",
     col.main = "black",
     cex.main = "1.5",
     adj = .5,
     line = 2.5 ) # formats the title to reflect what I want "10 year treasury yield"

#Plotting Return not yield
plot(return_DGS3MO, main = "",col = "darkgreen", yaxis.right = FALSE, ylim=c(-1.5,1.5),  
     ylab="Return", 
     xlab = "Date")# <- Plots treasury yields throughout the time period we have.
axis(4, labels = FALSE, tick = FALSE) # takes the axis labels off of the right side

title("3-Month Treasury Return",
      col.main = "black",
      cex.main = "1.5",
      adj = .5,
      line = 2.5 )

#ADF to test if stationary
library(tseries)
#for 10 year yield
adf.test(DGS3MO) # P Value > 0.05, Fail to reject Unit Root at 5%, and 1% level
adf.test(return_DGS3MO) # P Value is so small it is significant at the 1% level

#Summary Statistics
basicStats(DGS3MO)
basicStats(return_DGS3MO)

######################################################################################################

getSymbols("DGS1", src="FRED", from = "1981-09-01", to = "2025-11-24")

#To clean data 
DGS1 = na.omit(DGS1)
ret_DGS1=diff(DGS1)
return_DGS1 = na.omit(ret_DGS1)
#Code to plot yield of 1 year treasruy bond.
plot(DGS1, main = "",col = "darkred", yaxis.right = FALSE, ylab="Yield", xlab = "Date")# <- Plots treasury yields throughout the time period we have.
axis(4, labels = FALSE, tick = FALSE) # takes the axis labels off of the right side
title("1-Year Treasury Yield",
      col.main = "black",
      cex.main = "1.5",
      adj = .5,
      line = 2.5 ) # formats the title to reflect what I want "10 year treasury yield"

#Plotting Return not yield
plot(return_DGS1, main = "",col = "darkred", yaxis.right = FALSE, ylim=c(-1.5,1.5), ylab="Return", xlab = "Date")# <- Plots treasury yields throughout the time period we have.
axis(4, labels = FALSE, tick = FALSE) # takes the axis labels off of the right side

title("1-Year Treasury Return",
      col.main = "black",
      cex.main = "1.5",
      adj = .5,
      line = 2.5 )

#ADF to test if stationary
library(tseries)
#for 10 year yield
adf.test(DGS1) # P Value < 0.05, reject Unit Root at 5%, fail to at 1% level
adf.test(return_DGS1) # P Value is so small it is significant at the 1% level

#Summary Statistics
basicStats(DGS1)
basicStats(return_DGS1)


#PLOT ALL 3 Yields
combined = merge(DGS10,DGS1,DGS3MO)
plot(combined, 
     col = c("darkblue", "darkred","darkgreen"),
     main = "",
     legend.loc = "right",
     ylab="Yield",
    )
title("Treasury Yield by Tenor",
      col.main = "black",
      cex.main = "1.5",
      adj = .5,
      line = 2.5 )

######################################################################################################
# Getting Years from FRED Code

years10 = as.numeric(format(index(DGS10), "%Y"))
election_years = c(1980, 1984, 1988, 1992, 1996, 2000, 
                    2004, 2008, 2012, 2016, 2020, 2024)
election_dummy10 = ifelse(years10 %in% election_years, 1, 0)
DGS10election= xts(election_dummy10, order.by = index(DGS10))

years1 = as.numeric(format(index(DGS1), "%Y"))
election_years = c(1980, 1984, 1988, 1992, 1996, 2000, 
                   2004, 2008, 2012, 2016, 2020, 2024)
election_dummy1 = ifelse(years1 %in% election_years, 1, 0)
DGS1election = xts(election_dummy1, order.by = index(DGS1))

years3 = as.numeric(format(index(DGS3MO), "%Y"))
election_years = c(1980, 1984, 1988, 1992, 1996, 2000, 
                    2004, 2008, 2012, 2016, 2020, 2024)
election_dummy3 = ifelse(years3 %in% election_years, 1, 0)
DGS3MOelection = xts(election_dummy3, order.by = index(DGS3MO))

#Each of the yields has a dummy variable attached to it now with a 1 where 
#there is a 1 for a presidential election year and a 0 for non election year
#This had to be done 3 times to compensate for the years in each being encoded once in each data series


rm(ret_DGS1,ret_DGS3MO,ret_DGS10) #gets rid of the intermediary calculations to get return, leaving us with the cleaned return data
######################################################################################################

#Start Probit Regression, looking to measure the probability of having volatility above 2 standard deviations. 
#10 YEAR 

# Merging data so everything lines up for the regression, plots were different because I wanted to show a longer trend
# make data all line up with the shortest timeset (excrate)
#getting recession Variable for regression, Xi in regression. 
getSymbols("USREC", src = "FRED")
recess_dummy= ifelse(USREC == 1,1,0)
#getting exchange rate variable for regression, another Xi in regression
getSymbols("DEXUSEU", src = "FRED")
excrate= na.omit(DEXUSEU) # this line makes our exchange rate variable clean by omitting all n/a points

aligned = merge(diff(excrate), return_DGS10, USREC, DGS10election, all=FALSE)
#aligns our data so that we can run the probit regression as now everything is the same length, anything without data across all of the categories will be dropped. 
# make binary dependent variable, y in probit regression
abs_ret = abs(aligned$DGS10)
sd_ret = sd(aligned$DGS10)
more2vol = ifelse(abs_ret > 2*sd_ret,1,0)

probit= glm(more2vol~aligned$DGS10election+aligned$USREC+aligned$DEXUSEU,family=binomial (link = "probit"))
summary(probit)
# MARGINAL EFFECTS
library(mfx)
df <- data.frame(
  more2vol       = more2vol,
  DGS10election  = aligned$DGS10election,
  USREC          = aligned$USREC,
  DEXUSEU        = aligned$DEXUSEU
)
df <- na.omit(df)

mfx_results <- probitmfx(
  formula = more2vol ~ DGS10election + USREC + DEXUSEU,
  data = df,
  atmean = FALSE  
)
mfx_results # provides marginal effects # the average change for persidential year is 5% probability lower that a year will experience above 2 standard dev volatility


#Two tailed T test to see if presidential years have more volatility than non presidential years 
t.test(more2vol ~ aligned$DGS10election)


#The probit and t test both point to treasuries having less volatility for years that are considered to be presidential election years
######################################################################################################
# 1 YEAR 


getSymbols("USREC", src = "FRED")
recess_dummy= ifelse(USREC == 1,1,0)
#getting exchange rate variable for regression, another Xi in regression
getSymbols("DEXUSEU", src = "FRED")
excrate= na.omit(DEXUSEU) # this line makes our exchange rate variable clean by omitting all n/a points

aligned1 = merge(diff(excrate), return_DGS1, USREC, DGS1election, all=FALSE)
#aligns our data so that we can run the probit regression as now everything is the same length, anything without data in all of the categories will be dropped.
# make binary dependent variable, y in probit regression
abs_ret1 = abs(aligned1$DGS1)
sd_ret1 = sd(aligned1$DGS1)
more2vol1 = ifelse(abs_ret1 > 2*sd_ret1,1,0)

probit1= glm(more2vol1~aligned1$DGS1election+aligned1$USREC+aligned1$DEXUSEU,family=binomial (link = "probit"))
summary(probit1)
# MARGINAL EFFECTS
library(mfx)
df1 <- data.frame(
  more2vol1       = more2vol1,
  DGS1election  = aligned1$DGS1election,
  USREC          = aligned1$USREC,
  DEXUSEU        = aligned1$DEXUSEU
)
df1 <- na.omit(df1)

mfx_results1 <- probitmfx(
  formula = more2vol1 ~ DGS1election + USREC + DEXUSEU,
  data = df1,
  atmean = FALSE  
)
mfx_results1 # provides marginal effects

#Two tailed T test to see if presidential years have more volatility than non presidential years 
t.test(more2vol1 ~ aligned1$DGS1election)

######################################################################################################
# 3 MONTH

aligned3 = merge(diff(excrate), return_DGS3MO, USREC, DGS3MOelection, all=FALSE)
#aligns our data so that we can run the probit regression as now everything is the same length
# make binary dependent variable, y in probit regression
abs_ret3 = abs(aligned3$DGS3MO)
sd_ret3 = sd(aligned3$DGS3MO)
more2vol3 = ifelse(abs_ret3 > 2*sd_ret3,1,0)

probit3= glm(more2vol3~aligned3$DGS3MOelection+aligned3$USREC+aligned3$DEXUSEU,family=binomial (link = "probit"))
summary(probit3)
# MARGINAL EFFECTS
library(mfx)
df3 = data.frame(
  more2vol3       = more2vol3,
  DGS3MOelection  = aligned3$DGS3MOelection,
  USREC          = aligned3$USREC,
  DEXUSEU        = aligned3$DEXUSEU
)
df3 <- na.omit(df3)

mfx_results3 <- probitmfx(
  formula = more2vol3 ~ DGS3MOelection + USREC + DEXUSEU,
  data = df3,
  atmean = FALSE  
)
mfx_results3 # provides marginal effects

#Two tailed T test to see if presidential years have more volatility than non presidential years 
t.test(more2vol3 ~ aligned3$DGS3MOelection)


######################################################################################################
# Predict 10 year Using GJR GARCH
library(rugarch)
spec.gjrGARCH = ugarchspec(variance.model=list(model="gjrGARCH", garchOrder=c(1,1)), 
                           mean.model=list(armaOrder=c(0,0), include.mean=F))
#re-getting dsg10 now to find log returns
getSymbols("DGS10", src = "FRED")
lgdgs10=na.omit(DGS10)
lgdgs10= diff(log(lgdgs10))
lgdgs10= na.omit(lgdgs10)
#makes new logged returns variable for 10 year treasury yield which shows % change
data10 = lgdgs10   # RETURN series, not the yield level
data10 = na.omit(data10)
g10 = ugarchfit(data=data10, spec=spec.gjrGARCH)
G10 = ugarchforecast(g10, n.ahead=365)
G10
#to plot historical volatility & predictions
library(zoo)
hist_vol = rollapply(
  data = lgdgs10,   
  width = 30,       
  FUN = sd,         
  align = "right",  
  fill = NA         
)
# finds 30 day volatility, I want annualized 
hist_vol_annual = hist_vol * sqrt(252)
#annualized volatility based on the sd of last 30 days 
forecast_sigma = sigma(G10) * sqrt(252)
#gives annualized forecast for volatility
forecast_dates= seq(
  from = index(lgdgs10)[length(lgdgs10)], 
  length.out = 365, 
  by = "days"
)
# gives the dates we are looking to forecast for, were looking to predict...
#volatility and want a clear distinction between measured and forecasted measures

plot(index(hist_vol), hist_vol_annual, type="l", col="darkblue", lwd=2,
     xlab="Date", ylab="Annualized Volatility (Std Dev)",
     main="GJR-GARCH Forecasted Annualized Volatility of 10-Year Treasury Returns")
lines(forecast_dates, forecast_sigma, col="red", lwd=2)
#gives predicted values of annualized volatility for 1 year out as we forecasted 365 days ahead in line 198
abline(v = index(lgdgs10)[length(lgdgs10)], col="black", lwd=2, lty=3)
#vertical line at the end of the series where annualized volatility is being predicted
legend("topleft",
       legend=c("Historical Volatility (30-day SD)", 
                "GJR-GARCH Forecast (Next 365 Days)",
                "Today"),
       col=c("darkblue", "red", "black"),
       lwd=c(2,2,2),
       lty=c(1,1,2),
       bty="o")
#generates a legend to show what the lines mean in the context of this graph. 

######################################################################################################
spec.gjrGARCH = ugarchspec(variance.model=list(model="gjrGARCH", garchOrder=c(1,1)), mean.model=list(armaOrder=c(0,0), include.mean=F))
#re-getting dsg1 now to find log returns
getSymbols("DGS1", src = "FRED")
lgdgs1=na.omit(DGS1)
lgdgs1= diff(log(lgdgs1))
lgdgs1= na.omit(lgdgs1)
#makes new logged returns variable for 1 year treasury yield which shows % change
data1 = lgdgs1   # RETURN series, not the yield level
data1 <- na.omit(data1)
g1 = ugarchfit(data=data1, spec=spec.gjrGARCH)
G1 = ugarchforecast(g1, n.ahead=365)
G1
#to plot historical volatility & predictions
hist_vol1 = rollapply(
  data = lgdgs1,   
  width = 30,       
  FUN = sd,         
  align = "right",  
  fill = NA         
)
# finds 30 day volatility, I want annualized 
hist_vol1_annual = hist_vol1 * sqrt(252)
#annualized volatility based on the sd of last 30 days 
forecast_sigma1 = sigma(G1) * sqrt(252)
#gives annualized forecast for volatility
forecast_dates1= seq(
  from = index(lgdgs1)[length(lgdgs1)], 
  length.out = 365, 
  by = "days"
)
# gives the dates we are looking to forecast for, were looking to predict...
#volatility and want a clear distinction between measured and forecasted measures

plot(index(hist_vol1), hist_vol1_annual, type="l", col="darkred", lwd=2,
     xlab="Date", ylab="Annualized Volatility (Std Dev)",
     main="GJR-GARCH Forecasted Annualized Volatility of 1-Year Treasury Returns")
lines(forecast_dates1, forecast_sigma1, col="green", lwd=2)
#gives predicted values of annualized volatility for 1 year out as we forecasted 365 days ahead in line 198
abline(v = index(lgdgs10)[length(lgdgs10)], col="black", lwd=2, lty=3)
#vertical line at the end of the series where annualized volatility is being predicted
legend("topleft",
       legend=c("Historical Volatility (30-day SD)", 
                "GJR-GARCH Forecast (Next 365 Days)",
                "Today"),
       col=c("darkred", "green", "black"),
       lwd=c(2,2,2),
       lty=c(1,1,2),
       bty="o")
#this is copied and pasted with each of the respective variables being changed
#From DGS10 to DGS1 because we are now looking for annualized 1 year treasury return volatility

######################################################################################################


#3 month was returning error messages (Error in eigen(fit$hessian) : infinite or missing values in 'x') 
#because 3-month's tails were so fat that it was unable to produce reliable forecasts
#spec.gjrGARCH = ugarchspec(variance.model=list(model="gjrGARCH", garchOrder=c(1,1)), mean.model=list(armaOrder=c(0,0), include.mean=F))
#re-getting DGS3MO now to find log returns
#getSymbols("DGS3MO", src = "FRED")
#lgdgs3mo=na.omit(DGS3MO)
#lgdgs3mo= diff(log(lgdgs3mo))
#lgdgs3mo= na.omit(lgdgs3mo)
#makes new logged returns variable for 10 year treasury yield which shows % change
#data3 = lgdgs3mo   # RETURN series, not the yield level
#data3 = na.omit(data3)
#g3 = ugarchfit(data=data3, spec=spec.gjrGARCH,solver = "hybrid")
#G3 = ugarchforecast(g3, n.ahead=1)
#G3
#to plot historical volatility & predictions
#hist_vol3 = rollapply(
  #data = lgdgs1,   
 # width = 30,       
 # FUN = sd,         
 # align = "right",  
 # fill = NA         
#)
# finds 30 day volatility, I want annualized 
#hist_vol3_annual = hist_vol1 * sqrt(252)
#annualized volatility based on the sd of last 30 days 
#forecast_sigma3 = sigma(G1) * sqrt(252)
#gives annualized forecast for volatility
#forecast_dates3= seq(
#  from = index(lgdgs3mo)[length(lgdgs3mo)], 
#  length.out = 365, 
#  by = "days"
#)
# gives the dates we are looking to forecast for, were looking to predict volatility and want a clear distinction between measured and forecasted measures)
