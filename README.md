# Volatility of Treasury Yields During Election Cycles
This project sought to tackle whether U.S. general presidential election years actually drive higher volatility in Treasury yields, once you account for recessions and exchange rate swings.

## Overview
This project examines daily Treasury yield data across three maturities (3-month, 1-year, and 10-year) from 1982 to 2025 to test whether presidential election years are associated with elevated yield volatility. Using a probit regression with marginal effects, and two-sample t-tests, I estimate the standalone effect of an election-year dummy on volatility at each tenor while controlling for NBER recessions and USD/EUR exchange rate movements. I then forecast 365-day forward volatility for both the 10-year and 1-year treasury securities using a GJR-GARCH volatility model. Results suggest that election years do not meaningfully increase Treasury volatility at any tenor once these macro controls are in place. The results also suggest that recessions are the dominant driver of extreme volatility events.

*Code was debugged with the assistance of AI tools; all research design, modeling choices, and interpretation of results are my own.*

## Data
### Source: 
Federal Reserve Economic Data (FRED®), maintained by the Federal Reserve Bank of St. Louis. Data was pulled directly from FRED via R package quantmod (getSymbols()). General Presidential election dates sourced from Encyclopædia Britannica. [Link to FRED](https://fred.stlouisfed.org/) [Link to Encyclopædia Britannica](https://www.britannica.com/topic/United-States-Presidential-Election-Results-1788863)
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
R version 4.x or higher
Packages: quantmod, timeSeries, tseries, rugarch, mfx, zoo, fBasics
*Code to install necessary packages:* 
install.packages(c("quantmod", "timeSeries", "tseries", "rugarch",
                    "mfx", "zoo", "fBasics")) 

### Getting Data:

No manual downloads are needed to get data. Running source("FinalProject.R") calls getSymbols() directly against FRED for DGS10, DGS1, DGS3MO, USREC, and DEXUSEU, so the script will automatically pick up new daily observations as they're published. Presidential election years are hardcoded as a vector (1980–2024) directly in the script, since Britannica's election-date list isn't available as a structured data feed.

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

<img width="628" height="308" alt="image" src="https://github.com/user-attachments/assets/5ef04c5b-4905-468b-b80e-938c2e98be5b" />


#### Screenshot 7.2

<img width="628" height="308" alt="image" src="https://github.com/user-attachments/assets/f3e23830-26e2-4bcb-96c9-c3fa8ef8fb20" />

#### Screenshot 7.3

## Findings:
When looking at the results for each of probit regressions and their respective marginal effects outputs, the only statistically significant result for the election year variable is within the 10-year Treasury. In this regression, election years' effect is statistically significant at the 5% level and actually contradicts my initial hypothesis: it reveals that, on average, election years decrease the probability that a day's return will be greater than 2 standard deviations, by around 5% (See slide 37 in presentation for entire table output). 1-year Treasuries experience the same directional relationship as the 10-year, however the magnitude of this relationship is much lower, only around a 1% decrease in volatility for election years, and is highly statistically insignificant even if we expand our scope to the 10% significance level (p-value is .68, much higher than 0.1). The 3-month probit is once more statistically insignificant yet reverses the relationship faced by the other two tenors; the 3-month probit shows that, on average, an election year has a 7% higher probability of having a return more than 2 standard deviations, if we were to interpret it as significant. The results from the probits ultimately show that any effects that elections have on volatility are largely concentrated in shorter-dated measures, despite little significance.

The Welch Two-Sample t-Tests reveal the same truths as the probit regressions when measuring the difference in means. The p-values for each tenor are as follows: 10-year = 0.134, 1-year = 0.93, 3-Month = 0.20. The lack of statistical significance within these tests signifies that the difference in mean volatility between election and non-election years cannot be attributed to anything but random noise.

Additionally, the GJR-GARCH forecasts for 10-year and 1-year annualized volatility echo the trend from both the regressions and the t-tests. Forecasts for 1-year annualize at a value just shy of 2% (0.019) and 10-year forecasts are extremely low, less than 1% (0.0092). This can be seen on the volatility plots as well, as the forecast for 1-year is on a clear upward trend (green line, screenshot 7.3 and slide 29) while the same forecast for 10-year treasuries look nearly flat (red line, screenshot 7.2 and slide 28). Additionally there are fewer large spikes on the 10-year plot compared to the 1-year, echoing the sentiment from above in a graphical way.

## Planned Extensions
For the future, I'd like to add a few additional controls and refine the measured window from 1 year to a timeframe closer to political elections. In the future I would control for the following variables, hypotheses included:
**Fed policy variables:** My hypothesis is that rate hikes/cuts drive far more Treasury volatility than the election cycle does, and including a Fed funds rate change variable may account for more variance within the probit models.
**Candidate party affiliation** I hypothesize that markets may price uncertainty regarding trade or fiscal policy differences into their decisions, which simple binary election-year dummy can't capture. By splitting elections by expected policy direction could reveal an effect this specification misses. This could involve using projections for the popular vote or current standings.
**VIX as an additional control:** Including the CBOE Volatility Index (VIX) as a proxy for market wide volatility fears may help show if Treasury volatility is being carried over from equity markets, or if volatility is specifically due to the presidential cycle.
**Pre- vs. post-election windows:** Rather than treating the entire calendar year as "election year," I'd like to isolate the weeks immediately before and after the election itself, since I suspect any real volatility effect is more concentrated in window closer to a general election, but dissipates over the year.

I would additionally rework this project to other countries, developed and developing, to see if this is a trend specifically in the United States, or if this is a trend within developed nations. I hypothesize that in developed nations this would be a similar pattern to the US, but may vary in developing nations. This same model can also be applied to other assets, and 

This project was completed as a group final for Data Analysis in Finance (FIN 325) with five other researchers (Sonakshi Jain, Kenny Nguyen, Khadija Oussabban, Virginia Vaquero, and Lucas Zenobio). I served as lead researcher and designed the research question and project scope, wrote all of the R code for the analysis pipeline, and was responsible for quality control on the final statistical work and presentation. Data sourced from Federal Reserve Economic Data (FRED®), maintained by the Federal Reserve Bank of St. Louis. 
