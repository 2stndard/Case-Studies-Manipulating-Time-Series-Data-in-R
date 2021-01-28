# Exercise
# Exploring temperature data
# Now that you've learned a bit about your flights data - and reviewed the basics of time series data manipulation - your next assignment is to explore weather patterns in the Boston area to understand what might be affecting flight delays and cancellations. To do this, you'll need to compile and manipulate some additional time series data.
# 
# In this exercise, you'll explore some temperature data in the Boston area, including measures of min, mean, and max daily temperature over time. These data were collected using the weatherData package in R, which scrapes publicly available data from Weather Underground.
# 
# Before moving forward with your time series data manipulation, the first step in any data analysis is to examine the basic qualities of your data. Specifically, you'll take a closer look at two temperature data objects (temps_1 and temps_2) to understand what information these objects contain and how you should proceed.
# 
# Instructions
# 100 XP
# Use two calls of str() to view the structure of each temperature object: temps_1 and temps_2. Pay close attention to the output!
#   View the first and last few rows of temps_1 using head() and tail().
# View the first and last few rows of temps_2 using head() and tail(). Do these two objects contain similar data?

install.packages("devtools")
library("devtools")
install_github("weatherData", "Ram-N")
library(weatherData)

if(!require(weatherData)) {
  install.packages('weatherData')
  library(weatherData)
}

USAirportWeatherStations

temps_1 <- read.csv('temps_1.csv', header = TRUE, stringsAsFactors = FALSE)
temps_2 <- read.csv('temps_2.csv', header = TRUE, stringsAsFactors = FALSE)

temps_1$date <- as.Date(gsub('\'', '', temps_1$date))
temps_2$date <- as.Date(gsub('\'', '', temps_2$date))

# View the structure of each object
str(temps_1)
str(temps_2)

# View the first and last rows of temps_1
head(temps_1)
tail(temps_1)

# View the first and last rows of temps_2
head(temps_2)
tail(temps_2)


# Exercise
# Next steps - I
# Now that you've examined your data, your next task will be to proceed with data manipulation. Remember that the underlying goal is to explore the possible relationship between Boston area temperature and flights. To do so, you'll need to manipulate your temperature data to make sure it covers a comparable time period at a similar scale to your flights data.
# 
# Based on your examination of the temps_1 and temps_2 objects, which of the following is true?
#   
#   These objects are available in your workspace. Feel free to examine them further using commands such as class() or summary(), or rerunning commands from the previous exercise.
# 
# Instructions
# 50 XP
# Possible Answers
# 
# The temps_1 and temps_2 objects are totally unrelated.
# 
# The temps_1 and temps_2 objects do not contain time series data.
# 
# The temps_1 and temps_2 objects are not xts objects but do contain time series data.    <- answer
# 
# The temps_1 and temps_2 objects are already xts objects and can be easily merged using rbind().



# Exercise
# Merging using rbind()
# Now that you know the structure and scope of your temperature data, your next task will be to convert these objects to xts and merge them using rbind().
# 
# Before you can convert an object to xts, you need to identify the column that will form the time index and ensure it is encoded as a time-based object. In this case, you'll want to check the class of the date column in temps_1 and temps_2. Once you identify the appropriate time-based index, you can encode both objects to xts and merge by row.
# 
# The temps_1 and temps_2 objects are available in your workspace and the xts package has been loaded for you.
# 
# Instructions
# 100 XP
# Instructions
# 100 XP
# Use two calls to class() to check that the date columns in temps_1 and temps_2 are encoded as time-based objects (Date, POSIXct, POSIXlt, yearmon, etc.).
# Use as.xts() to encode each of your temperature data frames (temps_1 and temps_2) into a separate xts object. Be sure to specify the relevant time-based column for the order.by argument. Also remember to remove the time-based column using the data[, -column] format.
# Use two calls to head() to confirm that your new xts objects are properly formatted.
# Use rbind() on your xts objects to merge them into a single object: temps_xts.
# Use a combination of first() and last() to identify data from the first 3 days of the last month of the first year in temps_xts.

# Confirm that the date column in each object is a time-based class
class(temps_1$date)
class(temps_2$date)

# Encode your two temperature data frames as xts objects
temps_1_xts <- as.xts(temps_1[, -4], order.by = temps_1[,4])
temps_2_xts <- as.xts(temps_2[, -4], order.by = temps_2[,4])

# View the first few lines of each new xts object to confirm they are properly formatted
head(temps_1_xts)
head(temps_2_xts)

# Use rbind to merge your new xts objects
temps_xts <- rbind(temps_1_xts, temps_2_xts)

# View data for the first 3 days of the last month of the first year in temps_xts
first(last(first(temps_xts, "1 year"), "1 month"), "3 days")


# Exercise
# Visualizing Boston winters
# You discovered in the previous chapter that a much higher percentage of flights are delayed or cancelled in Boston during the winter. It seems logical that temperature is an important factor here. Perhaps colder temperatures are associated with a higher percentage of flight delays or cancellations?
#   
#   In this exercise, you'll probe the plausibility of this hypothesis by plotting temperature trends over time and generating a visual overview of Boston winters.
# 
# Instructions
# 100 XP
# Instructions
# 100 XP
# Before plotting, check the periodicity and duration of your data using periodicity(). Knowing the periodicity will help you interpret your data and will come in handy as you proceed.
# Use plot.xts() to generate a plot of mean Boston temperature (temps_xts$mean) for the duration of your data.
# Generate another plot of mean Boston temperature from November 2010 through April 2011 (inclusive).
# Use plot.zoo() to replicate your last plot while including the other columns in your data (in this case, min and max temperature). Specify plot.type as "single" to include all three lines on the same panel. Do not change the prewritten lty argument.

# Identify the periodicity of temps_xts
periodicity(temps_xts)

# Generate a plot of mean Boston temperature for the duration of your data
plot.xts(temps_xts$mean)

# Generate a plot of mean Boston temperature from November 2010 through April 2011
plot.xts(temps_xts["2010-11/2011-04"]$mean)

# Use plot.zoo to generate a single plot showing mean, max, and min temperatures during the same period 
plot.zoo(temps_xts["2010-11/2011-04"], plot.type = "single", lty = c(3, 1, 3))


# Exercise
# Subsetting and adjusting periodicity
# Your next step is to merge your temperature data with the flight data from the previous chapter.
# 
# Recall from the previous chapter that your flight data stretches from 2010 through 2015 in monthly periods. By contrast, your temperature data ranges from 2007 through 2015 in daily periods. Before you merge, you should subset your data and adjust the periodicity to monthly.
# 
# To convert the periodicity of xts objects, you can use to.period(), which allows you to quickly convert your data to a lower frequency period. By default, this command produces specific values across the entire period (namely, Open-High-Low-Close, or OHLC) which are useful in financial analysis but may not be relevant in all contexts.
# 
# In this case, you should set the argument OHLC to FALSE. Rather than produce OHLC columns in your monthly xts object, this setting will simply take one row from each period as representative of the entire period. You can specify which row using the indexAt command.
# 
# Both the temps_xts data and the flights_xts data (from the previous chapter) are available in your workspace.
# 
# Instructions
# 100 XP
# Subset your temps_xts object to include only observations from 2010 through 2015. Save this as temps_xts_2.
# Use to.period() to convert your daily temperature data to monthly periodicity. Be sure to specify the period you'd like to convert to ("months"). You also need to set OHLC to FALSE to avoid generating new OHLC columns. Finally, set the indexAt argument to "firstof" to select the first observation each month.
# Use two calls of periodicity() to compare the periodicity and duration of your new monthly temperature data to the flights_xts

# Subset your temperature data to include only 2010 through 2015: temps_xts_2
temps_xts_2 <- temps_xts["2010/2015"]

# Use to.period to convert temps_xts_2 to monthly periodicity
temps_monthly <- to.period(temps_xts_2, period = "months", OHLC = FALSE, indexAt = "firstof")

# Compare the periodicity and duration of temps_monthly and flights_xts 
periodicity(temps_monthly)
periodicity(flights_xts)



# Exercise
# Generating a monthly average
# While the to.period() command is useful in many contexts, for your purposes it may not be useful to select a single row as representative of the entire month.
# 
# Instead, it makes more sense to generate average temperature values per month. To do so, you'll need to manually calculate the monthly average using split() and lapply(), then generate a new xts object using as.xts() This may seem like a complicated process, but you already have the skills to do it!
# 
# The subsetted xts object from the previous exercise, temps_xts_2, is preloaded in your workspace. Also preloaded is an index object containing a vector of dates for the first day of each month covered in the data.
# 
# Instructions
# 100 XP
# Instructions
# 100 XP
# Use split() to generate monthly lists from the mean column of your temps_xts_2 object. Be sure to specify "months" as the period (the f argument).
# Use lapply() to calculate the "mean of means", or the average mean temperature per month.
# Use as.xts() to generate a new xts object containing average monthly temperature in Boston from 2010 through 2015. To do this, you will need to combine your monthly mean_of_means data with your monthly index object.
# Finally, confirm that your new temps_monthly object shares a duration and periodicity with flights_xts.

index <- as.Date(c('2010-01-01','2010-02-01','2010-03-01','2010-04-01','2010-05-01','2010-06-01','2010-07-01','2010-08-01','2010-09-01','2010-10-01','2010-11-01','2010-12-01','2011-01-01','2011-02-01','2011-03-01','2011-04-01','2011-05-01','2011-06-01','2011-07-01','2011-08-01','2011-09-01','2011-10-01','2011-11-01','2011-12-01','2012-01-01','2012-02-01','2012-03-01','2012-04-01','2012-05-01','2012-06-01','2012-07-01','2012-08-01','2012-09-01','2012-10-01','2012-11-01','2012-12-01','2013-01-01','2013-02-01','2013-03-01','2013-04-01','2013-05-01','2013-06-01','2013-07-01','2013-08-01','2013-09-01','2013-10-01','2013-11-01','2013-12-01','2014-01-01','2014-02-01','2014-03-01','2014-04-01','2014-05-01','2014-06-01','2014-07-01','2014-08-01','2014-09-01','2014-10-01','2014-11-01','2014-12-01','2015-01-01','2015-02-01','2015-03-01','2015-04-01','2015-05-01','2015-06-01','2015-07-01','2015-08-01','2015-09-01','2015-10-01','2015-11-01','2015-12-01'))

# Split temps_xts_2 into separate lists per month
monthly_split <- split(temps_xts_2$mean , f = "months")

# Use lapply to generate the monthly mean of mean temperatures
mean_of_means <- lapply(monthly_split, FUN = mean)

# Use as.xts to generate an xts object of average monthly temperature data
temps_monthly <- as.xts(as.numeric(mean_of_means), order.by = index)

# Compare the periodicity and duration of your new temps_monthly and flights_xts 
periodicity(temps_monthly)
periodicity(flights_xts)




# Exercise
# Using merge() and plotting over time
# Now that you have temperature data covering the same time period (2010-2015) at the same frequency (monthly) as your flights data, you are ready to merge.
# 
# To merge xts objects by column, you can use merge(). When two xts objects share the same periodicity, merge() is generally able to combine information into appropriate rows. Even when xts objects do not share the same periodicity, merge() will preserve the correct time ordering of those objects across disparate periods.
# 
# In this exercise, you'll merge your two xts objects by column and generate new plots exploring how flight delays relate to temperature. temps_monthly and flights_xts are available in your workspace.
# 
# Instructions
# 100 XP
# Instructions
# 100 XP
# Use merge() to combine flights_xts and temps_monthly. Because these xts objects share periodicity, your merge command should place temperature data in the appropriate row in your flights_xts object. Note that the order in which you list the objects to be merged determines where the columns will appear in the merged object. To keep things consistent, insert flights_xts first and temps_monthly second.
# Examine the first few rows of your merged xts object (flights_temps) to confirm that the merge was successful. You should see the temperature data lined up with the flights data.
# Use plot.zoo() to generate a single plot containing both the pct_delay and temps_monthly columns from flights_temps. Be sure to subset the relevant columns and specify plot.type as "single". Leave the lty argument as is.


# Use merge to combine your flights and temperature objects
flights_temps <- merge(flights_xts, temps_monthly)

# Examine the first few rows of your combined xts object
head(flights_temps)

# Use plot.zoo to plot these two columns in a single panel
plot.zoo(flights_temps[,c("pct_delay", "temps_monthly")], plot.type = "single", lty = c(1, 2))
legend("topright", lty = c(1, 2), legend = c("Pct. Delay", "Temperature"), bg = "white")



# Exercise
# Are flight delays related to temperature?
#   Plotting over time is a great way to visualize possible relationships in your data. On the right you can see a slightly more complex version of the plot you generated in the previous exercise, this time including data on the percentage of flights cancelled each month.
# 
# Based on this plot, which of the following is a reasonable conclusion about the relationship between flights and temperature?
#   
#   Instructions
# 50 XP
# Possible Answers
# 
# Temperature has no relationship with flight delays or cancellations.
# 
# Temperature is the only factor influencing flight delays and cancellations.
# 
# Cold weather causes flight delays and cancellations.
# 
# Flight cancellations are more likely in colder months, but flight delays are not strongly related to temperature. <- answer

# Exercise
# Next steps - II
# Your temperature data revealed a few potential avenues for exploring the causes of flight delays and cancellations. However, your client is insisting that flight arrival patterns in Boston are influenced by visibility and wind, not temperature. Before moving forward, you'll need to collect more data.
# 
# After conducting extensive research, you've identified some relevant data on weekly average visibility and wind speed in the Boston area. Which of the following steps would you take before merging these data with your existing monthly xts object, flights_temps?
#   
#   1) Encode the data to an xts object with a time-based index.
# 2) Convert the data to monthly periodicity using to.period() with the first observation per week.
# 3) Make sure each data object has only a single column of information.
# 4) Convert the data to monthly periodicity using split() and lapply() to generate monthly averages.
# 5) Check the periodicity and duration of your xts objects before using merge().
# 6) Remove the existing temperature information from flights_temps before using merge().
# Instructions
# 50 XP
# Instructions
# 50 XP
# Possible Answers
# 
# 1, 2, 6
# 
# 1, 4, 5        <- answer
# 
# 1, 3, 5, 6
# 
# 1, 2, 3, 5



# Exercise
# Expanding your data
# Now that you have a handle on time series workflow, you're ready to assess the hypothesis that flight delays are a function of visibility and wind.
# 
# In this exercise, you'll add a few more columns to your xts object by merging data on monthly average visibility (vis) and wind speeds (wind) in the Boston area from 2010 through 2015. These data are derived from the same source as your temperature data, but have already been manipulated and converted to xts to make your job easier.
# 
# This is similar to what you've done before, but this time you have less prewritten code to work with. Your working xts object, flights_temps, is also available in your workspace.
# 
# Instructions
# 100 XP
# Instructions
# 100 XP
# Your first task, as always, is to confirm the periodicity and duration of your vis and wind data by using two calls to periodicity().
# Once you have confirmed that the vis and wind data have the same periodicity and duration as your existing data, use merge() to combine all three objects into a single xts object: flights_weather. To keep things consistent, merge your data in the following order: flights_temps, vis, wind.
# Use head() to view the first few rows of flights_weather and ensure your merge was successful.

vis <- read.csv('vis.csv', header = TRUE, stringsAsFactors = FALSE)
vis <- as.xts(vis, order.by = index)
wind <- read.csv('wind.csv', header = TRUE, stringsAsFactors = FALSE)
wind <- as.xts(wind, order.by = index)
# Confirm the periodicity and duration of the vis and wind data
periodicity(vis)
periodicity(wind)

# Merge vis and wind with your existing flights_temps data
flights_weather <- merge(flights_temps, vis, wind)

# View the first few rows of your flights_weather data
head(flights_weather, n = 1)



# Exercise
# Are flight delays related to visibility or wind?
#   Well done! You've painlessly added some new data to your xts object. It gets easier every time!
# 
# The plot on the right shows the fruits of your labor: the percentage of delayed flights (which you calculated in the previous chapter), the average wind speed in Boston, and the average visibility, all on a monthly basis from 2010 through 2015.
# 
# After manipulating and exploring the data, it's time to report back to your client. Which of the following conclusions would you draw from this plot?
#   
#   Instructions
# 50 XP
# Possible Answers
# 
# There is no clear relationship between visibility and flight delays.
# 
# Higher wind speeds show a weak correlation with percentage of delayed flights, but further analysis is required.
# 
# Neither wind nor visibility can explain the high percentage of flights delayed in early 2011.
# 
# We have reason to doubt the quality of data on visibility prior to 2012.
# 
# All of the above.   <- answer


