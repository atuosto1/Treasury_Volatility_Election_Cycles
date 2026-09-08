# Volatility of Treasury Yields During Election Cycles
This project sought to tackle whether U.S. general presidential election years actually drive higher volatility in Treasury yields, once you account for recessions and exchange rate swings.

## Overview
This project examines daily Treasury yield data across three maturities (3-month, 1-year, and 10-year) from 1982 to 2025 to test whether presidential election years are associated with elevated yield volatility. Using GJR-GARCH volatility modeling, two-sample t-tests, and a probit regression with marginal effects, I estimate the standalone effect of an election-year dummy on volatility at each tenor while controlling for NBER recessions and USD/EUR exchange rate movements. Results suggest that election years do not meaningfully increase Treasury volatility at any tenor once these macro controls are in place. The results also suggest that recessions are the dominant driver of extreme volatility events.

*Code was debugged with the assistance of AI tools; all research design, modeling choices, and interpretation of results are my own.*

## Data
### Source: 
Federal Reserve Bank of St. Louis, Federal Reserve Economic Data (FRED). Data was pulled directly from FRED via R package quantmod (getSymbols()). General Presidential election dates sourced from Encyclopædia Britannica. [Link to FRED](https://fred.stlouisfed.org/)
### Time Period:
1982 to 2025 (bounded by the 3-month yield series, DGS3MO, which is the shortest available history among the three tenors)
### Key Variables:
#### Yields (Daily Value):
**DGS10 -** 10 Year Treasury Yield
**ret_DGS10 -** 10 Year Treasury Yield *return* calculated as the difference of yield within period t and t-1
**DGS1 -** 1 Year Treasury Yield 
**DGS1 -** 1 Year Treasury Yield *return* calculated as the difference of yield within period t and t-1
**DGS3MO -** 3 Month Treasury Yield
**DGS3MO -** 3 Month Treasury Yield *return* calculated as the difference of yield within period t and t-1
#### Controls:
**USREC -** NBER recession indicator, binary where 1 = Recession, 0 Otherwise (daily)
**DEXUSEU -** USD/EUR exchange rate (daily)
**election_dummy -** Yearly binary indicator, 1 = U.S. general presidential election year, 0 Otherwise (1980–2024)

## How to Reproduce
### Requirements:
- R/Rstudio
- R Packages
### Getting Data:
Ensure Packages are installed in R and use getSymbols()

## Methodology
Screenshots contain code for different tenors, but the process is the same for all three.
### Step 1: Gathering data and Cleaning
Using the package quantmod's function "getSymbols" the first step in this project was collecting the data from FRED. Following the import, na.omit(DGS10) was used in order to remove any missing values within the data. Additionally, the diff() function was used to find the daily return on DGS10, as volatility measuring requires stationary data. 
<img width="520" height="173" alt="image" src="https://github.com/user-attachments/assets/7517e081-35ee-4525-8616-38ce84cf750e" />

#### Screenshot 1.1

### Step 2: Plotting Yields and Returns
Plotting steps
<img width="695" height="333" alt="image" src="https://github.com/user-attachments/assets/507a715c-2722-44e1-8306-293229dd9711" />

#### Screenshot 2.1



