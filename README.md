# Volatility of Treasury Yields During Election Cycles
This project sought to tackle whether U.S. general presidential election years actually drive higher volatility in Treasury yields, once you account for recessions and exchange rate swings.

## Overview
This project examines daily Treasury yield data across three maturities (3-month, 1-year, and 10-year) from 1982 to 2025 to test whether presidential election years are associated with elevated yield volatility. Using a probit regression with marginal effects, and two-sample t-tests, I estimate the standalone effect of an election-year dummy on volatility at each tenor while controlling for NBER recessions and USD/EUR exchange rate movements. I then forecast 365-day forward volatility for both the 10-year and 1-year treasury securities using a GJR-GARCH volatility model. Results suggest that election years do not meaningfully increase Treasury volatility at any tenor once these macro controls are in place. The results also suggest that recessions are the dominant driver of extreme volatility events.

*Code was debugged with the assistance of AI tools; all research design, modeling choices, and interpretation of results are my own.*

## Data
### Source: 
Federal Reserve Bank of St. Louis, Federal Reserve Economic Data (FRED). Data was pulled directly from FRED via R package quantmod (getSymbols()). General Presidential election dates sourced from Encyclopædia Britannica. [Link to FRED](https://fred.stlouisfed.org/)
### Time Period:
1981 to 2025 (bounded by the 3-month yield series, DGS3MO, which is the shortest available history among the three tenors)
### Key Variables:
#### Binary Dependent Variable:
**more2vol -** binary indicator equal to 1 if a day's absolute return exceeds two standard deviations for **10-year Treasury**, 0 otherwise
**more2vol1 -** binary indicator equal to 1 if a day's absolute return exceeds two standard deviations for **1-year Treasury**, 0 otherwise
**more2vol3 -** binary indicator equal to 1 if a day's absolute return exceeds two standard deviations for **3-Month Treasury**, 0 otherwise

#### Yields (Daily Value):
**DGS10 -** 10 Year Treasury Yield
**ret_DGS10 -** 10 Year Treasury Yield *return* calculated as the difference of yield within period t and t-1
**DGS1 -** 1 Year Treasury Yield 
**DGS1 -** 1 Year Treasury Yield *return* calculated as the difference of yield within period t and t-1
**DGS3MO -** 3-Month Treasury Yield
**DGS3MO -** 3-Month Treasury Yield *return* calculated as the difference of yield within period t and t-1
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
For each tenor, I plotted both the yield and return variables to get a better understanding of how the data was moving. The yield graphs show the overall trend of nearly 40 years of data, while the return plots show the variation in returns (volatility) the study is looking to measure.
<img width="695" height="338" alt="image" src="https://github.com/user-attachments/assets/851868f3-d98c-432d-bf5c-4f17d9ba7ab8" />

#### Screenshot 2.1

<img width="948" height="390" alt="image" src="https://github.com/user-attachments/assets/8411ac39-bedb-4cfc-9dc9-093010791d8e" />

#### Screenshot 2.2

<img width="948" height="390" alt="image" src="https://github.com/user-attachments/assets/766b8025-b5e8-4831-9e65-a46c174bc8d0" />

#### Screenshot 2.3

### Step 3: Stationarity Test
Before utilizing any volatility models, I had to confirm that the data was stationary, as this is a requirement to use the GJR-GARCH model. To confirm that my data was stationary I ran an Augmented Dickey Fuller test for all of my data series, which adopts a null hypothesis of non-stationarity. The test statistic of the yield series revealed that they were either non-stationary or just barely stationary (P-Value > .05), however the test results for the return series showed that they were highly stationary (P-value < 0.01). This confirmation allowed me to move forward and utilize a GJR-GARCH model.

*See screenshot 3.1 for 3-month yield ADF test results & screenshot 3.2 for 3-month return ADF test results*

<img width="480" height="117" alt="image" src="https://github.com/user-attachments/assets/a999a0dc-c68e-4d38-b88c-ef1433c53559" />

#### Screenshot 3.1

<img width="480" height="165" alt="image" src="https://github.com/user-attachments/assets/87f34a65-fa30-4625-8de1-35c1e102e28a" />

#### Screenshot 3.2

### Step 4: Construct Presidential Election Years Dummy Variable
Using the year extracted from each series' date index, I constructed a dummy variable (DGS10election in screenshot) equal to 1 for each presidential election year from 1980 to 2024 (1980,1984,1988,...,2024) and 0 otherwise. I constructed this separately for each tenor as I wanted to ensure that, despite different lengths of data (3-month only going to 1981), each of the years had the correct status as an election year when I ultimately merged my data. This inefficiency is something I would improve in an expansion of this study.

<img width="480" height="117" alt="image" src="https://github.com/user-attachments/assets/c6d6c413-0f69-4dc8-b745-62864aff078e" />

#### Screenshot 4.1

### Step 5: Merging Data for Regression / Binary Dependent Variable Creation
Before running the probit regression and t-tests, I merged each tenor's return series with the U.S. recession indicator (USREC), the differenced exchange rate (DEXUSEU), and the previous election dummy variable (DGS10election). I also constructed my binary dependent variable for each tenor's return series (more2vol). If a given day's absolute return is greater than 2 standard deviations, this binary variable will equal 1, if not it will equal 0. 

<img width="576" height="215" alt="image" src="https://github.com/user-attachments/assets/f5321c57-a19c-41d9-9aee-6ad0830070a1" />

#### Screenshot 5.1

### Step 6: Probit Regression and Two-Sample t-Tests
For each tenor, I ran a probit regression of the respective volatility measure, in this case the 1-year variably more2vol1, on the election dummy, recession dummy, and exchange rate. Since probit coefficients do not reveal the change in probabilities, but how much the z-score changes for a one unit change in the control variables, I converted the raw probit coefficients (Screenshot 6.1) into interpretable marginal effects using probitmfx (Screenshot 6.2). I also ran a Welch two-sample t-test comparing mean volatility (probability of a >2 SD move) between election and non-election years, to verify the probit result with a simpler comparison of means.

<img width="461" height="351" alt="image" src="https://github.com/user-attachments/assets/8f54b622-5366-4ca4-a6d8-32ff5679b69e" />

#### Screenshot 6.1

<img width="579" height="286" alt="image" src="https://github.com/user-attachments/assets/bd52b28a-f8ce-4552-8dd5-f530cb8938e3" />

#### Screenshot 6.2

### Step 7: Volatility Plotting and GJR-GARCH Forecasting
To begin the volatility plots I took the annualized, trailing 30-day moving standard deviation of 10-year logged returns and plotted this in blue. Since there is a wide range of yields in the 40+ years of data logging returns puts any fluctuations into percent terms and ultimately levels the comparison, regardless of yield. The effect that a one percentage point fluctuation has on a 15% yield may not be the same effect on a 5% yield in percent terms (6.6% change at 15% yield compared to a 20% change at 5% yield). In red I used the package rugarch and fit a GJR-GARCH(1,1) model to the 10-year logged returns to capture asymmetric volatility (negative returns in period t-1 increase volatility in period t more than a positive return of the same magnitude) and I then forecast annualized volatility for the next 365 days. The same process was applied for 1-year Treasuries, however the 3-month Treasury was excluded, since its extreme fat tails (kurtosis ≈ 55) caused the model fitting procedure itself to fail rather than produce a usable, stable set of parameters. 

<img width="610" height="463" alt="image" src="https://github.com/user-attachments/assets/5ebd5599-73f1-497c-9de8-75dae2852914" />

#### Screenshot 7.1

<img width="848" height="390" alt="image" src="https://github.com/user-attachments/assets/32e871f2-d110-408c-8308-2c756eac5eb3" />

#### Screenshot 7.2


### How to Reproduce
Requirements:
R version 4.x or higher
Packages: quantmod, timeSeries, tseries, rugarch, mfx, zoo, fBasics
