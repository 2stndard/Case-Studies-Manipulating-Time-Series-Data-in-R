library(xts)

gdp <- read.csv('gdp.csv', header = TRUE, stringsAsFactors = TRUE, na.strings = 'NA')

# Exercise
# Exploring economic data
# Now that you've explored weather and flight patterns in Boston, your client has asked you to step back and prepare some economic data. You've gathered some data on the US economy, including gross domestic product (GDP) and unemployment in the US in general and the state of Massachusetts (home to Boston) in particular.
# 
# As always, your first step in manipulating time series data should be to convert your data to the xts class. In this exercise, you'll examine and encode time series data on US GDP, which is available in your workspace as gdp.
# 
# Instructions
# 100 XP
# Instructions
# 100 XP
# View information about your gdp data using summary(). What can you conclude from the output of this command?
# Begin the process of encoding gdp to xts by converting the date column to a time object. In this case, it looks like your GDP data are quarterly, so you should use the yearqtr class.
# Use as.xts() to convert gdp to an xts object. Remember to index your xts object on the date column and remove that column from the xts output using the data[, 1] subsetting format.
# Use plot.xts() to view your GDP data over time. Does anything stand out in your plot?


# Get a summary of your GDP data
summary(gdp)

# Convert GDP date column to time object
gdp$date <- as.yearqtr(gdp$date)

# Convert GDP data to xts
gdp_xts <- as.xts(gdp[, -1], order.by = gdp[,1])

# Plot GDP data over time
plot.xts(gdp_xts)


# Exercise
# Replace missing data - I
# As you discovered in the previous exercise, your quarterly GDP data appear to be missing several observations. In fact, your call to summary() in the previous exercise revealed 80 missing data points!
#   
#   As you may recall from the first xts course, xts and zoo provide a variety of functions to handle missing data.
# 
# The simplest technique is the na.locf() command, which carries forward the last observation before the missing data (hence, "last observation carried forward", or locf). This approach is often the most appropriate way to handle missingness, especially when you have reasons to be conservative about growth in your data.
# 
# A similar approach works in the opposite direction by taking the first observation after the missing value and carrying it backward ("next observation carried backward", or nocb). This technique can also be done using the na.locf() command by setting the fromLast argument to TRUE.
# 
# Which method is best depends on the type of data you are working with and your preconceived notions about how the data changes over time.
# 
# Instructions
# 100 XP
# Use na.locf() to fill the missing values in gdp_xts based on the last observation carried forward. Save this new xts object as gdp_locf.
# Use another call to na.locf() to fill missing values in gdp_xts based on the next observation carried backward. To do so, set the fromLast argument to TRUE. Save this new xts object as gdp_nocb.
# Plot each of these objects using plot.xts(). Include the pre-written par() command to display both plots together.
# Query each object (gdp_locf and gdp_nocb) for GDP in 1993.


# Fill NAs in gdp_xts with the last observation carried forward
gdp_locf <- na.locf(gdp_xts)

# Fill NAs in gdp_xts with the next observation carried backward 
gdp_nocb <- na.locf(gdp_xts, fromLast = TRUE)

# Produce a plot for each of your new xts objects
par(mfrow = c(2,1))
plot.xts(gdp_locf, major.format = "%Y")
plot.xts(gdp_nocb, major.format = "%Y")

# Query for GDP in 1993 in both gdp_locf and gdp_nocb
gdp_locf['1993']
gdp_nocb['1993']



# Exercise
# Replace missing data - II
# Like most aspects of time series data manipulation, there are many ways to handle missingness. As you discovered in the previous exercise, both the locf and nocb approach require you to make certain assumptions about growth patterns in your data. While locf is more conservative and nocb is a more aggressive, both generate step-wise growth from missing data.
# 
# But what if you have reason to expect linear growth in your data? In this case, it may be more useful to use linear interpolation, which generates new values between the data on either end of the missing value weighted according to time.
# 
# In this exercise, you'll fill the missing values in your gdp_xts data using the na.approx() command, which uses interpolation to estimate linear values in time.
# 
# Instructions
# 100 XP
# Use na.approx() to fill the missing values in gdp_xts using linear interpolation. Save this new xts object as gdp_approx.
# Plot your new xts object using plot.xts().
# Query your new xts object for GDP in 1993.


# Fill NAs in gdp_xts using linear approximation
gdp_approx <- na.approx(gdp_xts)

# Plot your new xts object
par(mfrow = c(1,1))
plot.xts(gdp_approx, major.format = "%Y")

# Query for GDP in 1993 in gdp_approx
gdp_approx['1993']



# Exercise
# Exploring unemployment data
# Now that you've reviewed the basic steps for handling missing data, you can more easily examine and clean new time series data on the fly.
# 
# In this exercise, you'll gain a bit more practice by exploring, cleaning, and plotting data on unemployment, both in the United States in general and in Massachusetts (MA) in particular. An xts object containing this data, unemployment is available in your workspace.
# 
# Instructions
# 100 XP
# Instructions
# 100 XP
# View summary information about your unemployment data using summary(). Pay close attention to the number of NA's identified in your output. Also note that the min and max values of your time index tell you the period covered by your data.
# Use na.approx() to remove missing values from your unemployment data through linear interpolation. Save these values back into your unemployment object.
# Use plot.zoo() to plot your unemployment data. Specify plot.type as "single" to put both US-wide and Massachusetts-specific data on the same plot. Keep the lty argument and the call to legend() as they are.


unemployment <- readRDS('unemployment.RData')

# View a summary of your unemployment data
summary(unemployment)

# Use na.approx to remove missing values in unemployment data
unemployment <- na.approx(unemployment)

# Plot new unemployment data
plot.zoo(unemployment, plot.type = "single", lty = 1:2)
legend("topright", lty = 1:2, legend = c("US Unemployment (%)", "MA Unemployment (%)"), bg = "white")



# Exercise
# Lagging unemployment
# Given that economic trends may take some time to influence tourism, it may be helpful to lag your unemployment data before proceeding with analysis.
# 
# Generating a lag in xts is straightforward with the lag() command, which requires that you specify the data being lagged (the x argument) and a k value to determine the direction and scale of the lag.
# 
# Be careful to keep your formatting consistent. Base R and the zoo package require that you specify a lag with a negative value, so that a lag of 1 is expressed using "-1" (and a lead of 1 is counterintuitively expressed using "1"). By contrast, the xts package specifies lags using a positive value, so that a lag of 1 is expressed using "1" (and a lead of 1 is expressed using "-1").
# 
# Instructions
# 100 XP
# Instructions
# 100 XP
# Use lag() to generate a one-month lag of US unemployment. For a one month lag using monthly data, simply set the k argument equal to 1. Remember that your unemployment object contains time series data on both US unemployment (us) and MA unemployment (ma). You'll need to specify which column you want to lag. Save this new xts object as us_monthlag.
# Use another call to lag() to generate a one-year lag of US unemployment. Once again, make sure you specify the correct column in unemployment and the appropriate k value to generate a lag over an entire year. Save this new xts object as us_yearlag.
# Use merge() to combine your original unemployment data (unemployment) with your new lags (us_monthlag and us_yearlag). Save this combined data as unemployment_lags.
# Use head() to view the first 15 rows of unemployment_lags.


# Create a one month lag of US unemployment
us_monthlag <- lag(unemployment$us, k = 1)

# Create a one year lag of US unemployment
us_yearlag <-  lag(unemployment$us, k = 12)

# Merge your original data with your new lags 
unemployment_lags <- merge(unemployment, us_monthlag, us_yearlag)

# View the first 15 rows of unemployment_lags
head(unemployment_lags, n = 15)



# Exercise
# Differencing unemployment
# In addition to adding lags to your data, you may find it helpful to generate a difference of the series.
# 
# To calculate a difference, simply use the diff() command. This command requires you to specify the original data object, the number of lags (lag), and the order of the difference (differences).
# 
# In this exercise, you'll expand your unemployment data in a different direction by adding a few useful difference measures.
# 
# Instructions
# 100 XP
# Instructions
# 100 XP
# Construct a first order monthly difference in US unemployment using diff(). In your call to diff(), specify the column you are drawing from in unemployment as well as the lag and differences arguments. Rather than saving this to a new object for merging, save your data into a new column in unemployment called us_monthlydiff.
# Use a similar call to diff() to construct an annual difference in US unemployment. Save this to unemployment$us_yearlydiff.
# Use two calls to plot.xts() to generate plots of US unemployment (unemployment$us) and annual change (unemployment$us_yearlydiff), respectively. Leave the type argument as is in your second call to plot.xts() to produce a barplot. The pre-written par() command allows you to view both plots at the same time.


# Generate monthly difference in unemployment
unemployment$us_monthlydiff <- diff(unemployment$us, lag = 1, differences = 1)

# Generate yearly difference in unemployment
unemployment$us_yearlydiff <- diff(unemployment$us, lag = 12, differences = 1)

# Plot US unemployment and annual difference
par(mfrow = c(2,1))
plot.xts(unemployment$us)
plot.xts(unemployment$us_yearlydiff, type = "h")



# Exercise
# Add a discrete rolling sum to GDP data
# While it helps to know the amount of change from one period to the next, you may want to know the total change since the beginning of the year. To generate this type of indicator, you can use the split-lapply-rbind pattern. This process is similar to the process used to generate monthly temperature averages in the previous chapter.
# 
# 
# In this exercise, you'll return to the gdp data used earlier in the chapter. In addition to static GDP values in each quarter, you'd like to generate a measure of GDP change from one quarter to the next (using diff()) as well as a rolling sum of year-to-date GDP change (using split(), lapply() and rbind().


# Use diff() to produce a simple quarterly difference in gdp. Be sure to specify the gdp column and set the lag equal to 1 period (in this case, 1 quarter). Save this into your gdp object as quarterly_diff.
# Now that you have a measure of quarterly GDP change, your next step is to split your quarterly_diff data into years using split(). In your call to split(), be sure to specify the quarterly_diff column of gdp and set the f argument equal to "years" (with quotes).
# Use lapply() on your newly split data. To calculate a cumulative sum in each year, set the FUN argument equal to cumsum (without quotes).
# Use do.call() to rbind your gdpchange_ytd data back into an xts object.
# Finally, use plot.xts() to examine year-to-date change in GDP (gdpchange_xts).

colnames(gdp_approx) <- c('gdp')
# Add a quarterly difference in gdp
gdp_approx$quarterly_diff <- diff(gdp_approx$gdp, lag = 1, differences = 1)

# Split gdp$quarterly_diff into years
gdpchange_years <- split(gdp_approx$quarterly_diff, f = "years")

# Use lapply to calculate the cumsum each year
gdpchange_ytd <- lapply(gdpchange_years, FUN = cumsum)

# Use do.call to rbind the results
gdpchange_xts <- do.call(rbind, gdpchange_ytd)

# Plot cumulative year-to-date change in GDP
par(mfrow = c(1,1))
plot.xts(gdpchange_xts, type = "h")




# Exercise
# Add a continuous rolling average to unemployment data
# In addition to discrete measures such as year-to-date sums, you may be interested in adding a rolling sum or average to your time series data.
# 
# To do so, let's return to your monthly unemployment data. While you may be interested in static levels of unemployment in any given month, a broader picture of the economic environment might call for rolling indicators over several months.
# 
# To do this, you'll use the rollapply() command, which takes a time series object, a window size width, and a FUN argument to apply to each rolling window.
# 
# Instructions
# 100 XP
# Use rollapply() to calculate the rolling yearly average US unemployment. Be sure to specify the us column of your unemployment data, set the width argument to the appropriate number of monthly periods, and set the FUN argument to mean. Save your rolling average into your unemployment object as year_avg.
# Plot your two indicators of US unemployment (us and year_avg) using plot.zoo(). Set the plot.type argument to "single" to place both measures in the same panel.


# Use rollapply to calculate the rolling yearly average US unemployment
unemployment$year_avg <- rollapply(unemployment$us, width = 12, FUN = mean)

# Plot all columns of US unemployment data
plot.zoo(unemployment[, c("us", "year_avg")], plot.type = "single", lty = c(2, 1), lwd = 1:2)



# Exercise
# Manipulating MA unemployment data
# Now that you've added some lags, differences, and rolling values to your GDP and US unemployment data, it's time to take these skills back to your assignment.
# 
# Remember that your client wants information relevant to the Boston tourism industry. In addition to data on the US economy in general, it may help to prepare some relevant indicators for your Massachusetts economic data.
# 
# In this exercise, you'll use your time series data manipulation skills to generate: a one-year lag, a six-month first order difference, a six-month rolling average, and a one-year rolling maximum in the MA unemployment rate. Your client is waiting!
# 
# Instructions
# 100 XP
# Instructions
# 100 XP
# Use lag() to generate a one-year lag of the MA unemployment rate (contained in the ma column of your monthly unemployment data). Remember to set the k argument equal to a year's worth of observations. Save this indicator to your unemployment data as ma_yearlag.
# Use diff() to generate a six-month first order difference in the MA unemployment rate. Remember to specify the correct column in your unemployment data. Save this indicator to your unemployment data as ma_sixmonthdiff.
# Measure the six-month rolling average of MA unemployment using rollapply() Be sure to provide the appropriate specification for the width and FUN arguments. Save this indicator to your unemployment data as ma_sixmonthavg.
# Measure the "high water mark" in unemployment over the past year using another call to rollapply() with the appropriate specification of the width argument. This time, set the FUN argument to max. Save this final indicator to your unemployment data as ma_yearmax.
# Use tail() to view the last year of unemployment data (n = 12).


# Add a one-year lag of MA unemployment
unemployment$ma_yearlag <- lag(unemployment$ma, 12)

# Add a six-month difference of MA unemployment
unemployment$ma_sixmonthdiff <- diff(unemployment$ma, lag = 6)

# Add a six-month rolling average of MA unemployment
unemployment$ma_sixmonthavg <- rollapply(unemployment$ma, width = 6, FUN = mean)

# Add a yearly rolling maximum of MA unemployment
unemployment$ma_yearmax <- rollapply(unemployment$ma, width = 12, FUN = max)

# View the last year of unemployment data
tail(unemployment, n = 12)
head(unemployment, n = 12)
