flights <- read.csv('flights.csv', header = TRUE, stringsAsFactors = FALSE)

# exercise
# Flight data
# Now that you're back in the time series mindset, it's time to get to work! Your task is to understand the travel patterns of tourists visiting Boston. As a first step, you've been assigned to explore patterns in flights arriving at Boston's Logan International Airport (BOS). In this exercise, you'll view the structure and qualities of some data in preparation for time series manipulation.
# 
# Lucky for you, the U.S. Bureau of Transportation Statistics provides open source data on flight arrival times. The flights data file has been preloaded in your workspace.
# 
# This course touches on a lot of concepts you may have forgotten, so if you ever need a quick refresher, download the xts in R Cheat Sheet and keep it handy!
# 
# Instructions
# 100 XP
# Explore the structure of flights using str() to understand the information contained in the data file.
# View the first 5 rows of flights using head() to get a feel for what the data look like.
# The first step in preparing an object for conversion to xts is to ensure that the time/date column is in a proper time-based format. Check the class of the relevant column in flights using class().

#View the structure of the flights data
str(flights)

#Examine the first five rows of the flights data
head(flights, n = 5)

#Identify class of the column containing date information
class(flights$date)

# Pick out the xts object
# It looks like your flights data will need some modifications before it can be turned into an xts object. As you know, there are many different types of objects in R. xts objects are specifically designed for time series functionality.
# 
# Which of the following accurately describes the internal structure of an xts object?
#   
#   Answer the question
# 50XP
# Possible Answers
# 
# A simple matrix.
# press
# 1
# 
# A data frame in which one column is a time-based object.
# press
# 2
# 
# A vector of time information.
# press
# 3
# 
# A matrix indexed on a time-based object.       <- answer
# press
# 4



# Exercise
# Encoding your flight data
# You're ready to encode your data to an xts object! Remember that flights is a data frame containing four columns of flight data and one column of dates.
# 
# To convert to an xts object, you'll need to ensure that your date column is in a time-based format. As you discovered earlier, the date column is currently a character. Once date is saved in a time-based format, you're ready to convert to xts! To do so, you'll use as.xts(), which takes two primary arguments.
# 
# First, you'll need to specify the object being converted (in this case, flights). To avoid redundancies, you should generally remove the time-based column from the data when you convert to xts. In this case, you'll remove the fifth column (dates), by specifying [, -5] in your as.xts() call.
# 
# Second, you'll need to tell xts how to index your object by specifying the order.by argument. In this case, you want to index your object on the date column.
# 
# The flights data frame is preloaded for you.
# 
# Instructions
# 100 XP
# Instructions
# 100 XP
# Load the xts package.
# Use as.Date() to convert the date column in flights from a character to a Date object.
# Convert your data to an xts object using as.xts(). To do so, you'll need to specify the data being encoded followed by the order.by argument, which generates the time-based index. Save this object as flights_xts.
# Check the class of flights_xts in your workspace.
# Examine the first 5 rows of flights_xts.

# Load the xts package
library(xts)

# Convert date column to a time-based class
flights$date <- as.Date(flights$date)

# Convert flights to an xts object using as.xts
flights_xts <- as.xts(flights [ , -5], order.by = flights$date)

# Check the class of flights_xts
class(flights_xts)

# Examine the first five lines of flights_xts
head(flights_xts, 5)


# Exercise
# Exploring your flight data
# Before any analysis can be done, it is critical to explore the basic qualities of your data, including periodicity, scope, and comprehensiveness.
# 
# In this exercise, you'll gain a better understanding of your data by exploring these qualities. As you may recall from the earlier exercises, your time index seemed to be in months. To check that this is constant throughout your xts object, you can use the periodicity() command to tell you the periodicity and scope of the data.
# 
# Once you are sure of periodicity, you may also want to know how many periods are covered. To identify the number of periods in your data, you can use the ndays() command, or one of its wrappers, nmonths(), nyears(), etc.
# 
# Finally, you may find it useful to query for a particular date by subsetting For example, inputting xts_object["date"] will generate the row pertaining to that date.
# 
# Instructions
# 100 XP
# Identify the periodicity and scope of your flights_xts object using periodicity().
# Identify the number of periods in your data using the most relevant command.
# Query your data for information on flights arriving in BOS in June 2014.


# Identify the periodicity of flights_xts
periodicity(flights_xts)

# Identify the number of periods in flights_xts
nmonths(flights_xts)

# Find data on flights arriving in BOS in June 2014
flights_xts['2014-06']


# Exercise
# Visualize flight data
# Now that you have a grip on your data, the next step is to visualize trends in your data over time. In this exercise, you'll plot the flights_xts data over time using a few different methods for plotting time series data.
# 
# Often the simplest way to plot xts objects is to use plot.xts(), which requires only a single argument for the y-axis in the plot. The x-axis is supplied by the time index in your xts object.
# 
# For more complicated plots, you may want to use plot.zoo(), which allows you to include multiple columns of data. In particular, the plot.type argument allows you to specify whether you'd like your data to appear in a single panel ("single") or multiple panels ("multiple"). This can be useful when comparing multiple columns of data over time.
# 
# Instructions
# 100 XP
# Use plot.xts() to view the total monthly flights into BOS (total_flights) over time. This command only requires you to specify the data for the y-axis, although you do need to be specific about which column of data you want to plot.
# Use another call to plot.xts() to produce a plot of monthly delayed flights into BOS over time.
# Generate a plot of all four time series columns in flights_xts using plot.zoo(). Set the plot.type argument to "multiple" to produce a plot with four different panels. Leave the ylab argument as is.
# Put all four plots on a single panel using another call to plot.zoo(). Leave the lty argument and the legend function as they are.

labels = c("Total", "Delay", "Cancel", "Divert")
# Use plot.xts() to view total monthly flights into BOS over time
plot.xts(flights_xts$total_flights)

# Use plot.xts() to view monthly delayed flights into BOS over time
plot.xts(flights_xts$delay_flights)

# Use plot.zoo() to view all four columns of data in their own panels
plot.zoo(flights_xts, plot.type = "multiple", ylab = labels)

# Use plot.zoo() to view all four columns of data in one panel
plot.zoo(flights_xts, plot.type = "single", lty = 1:4)
legend("right", lty = 1:4, legend = labels)


# Exercise
# Calculate time series trends
# One of the most useful qualities of xts objects is the ability to conduct simple mathematical equations across time. In your flight data, one valuable metric to calculate would be the percentage of flights delayed, cancelled, or diverted each month.
# 
# In this exercise, you'll use your data to generate a new time series column containing the percentage of flights arriving late to Boston each month. You'll then generate a plot for this metric, before going on to calculate additional metrics for flight cancellations and diversions.
# 
# Instructions
# 100 XP
# Use simple math expressions on flights_xts to calculate the percentage of flights delayed each month. Save this as a new column in flights_xts called pct_delay.
# Use plot.xts() to view the percent of flights delayed each month.
# Replicate your calculation above to produce two additional columns of data in your xts object -- pct_cancel and pct_divert -- for cancelled and diverted flights, respectively.
# Use plot.zoo() to view all three trends together. To do so, you'll need to select a subset of the flights_xts data containing the three columns you just generated.

# Calculate percentage of flights delayed each month: pct_delay
flights_xts$pct_delay <- (flights_xts$delay_flights / flights_xts$total_flights) * 100

# Use plot.xts() to view pct_delay over time
plot.xts(flights_xts$pct_delay)

# Calculate percentage of flights cancelled each month: pct_cancel
flights_xts$pct_cancel <- (flights_xts$cancel_flights / flights_xts$total_flights) * 100


# Calculate percentage of flights diverted each month: pct_divert
flights_xts$pct_divert <- (flights_xts$divert_flights / flights_xts$total_flights) * 100


# Use plot.zoo() to view all three trends over time
plot.zoo(x = flights_xts[ , c("pct_delay", "pct_cancel", "pct_divert")])



# Exercise
# Saving time - I
# You've now successfully converted your flights data into an xts object, plotted information over time, and calculated a few valuable metrics to help you proceed with analysis. You've even been able to conduct some quick descriptive analysis on your data by plotting these metrics over time.
# 
# The final step in any time series data manipulation is to save your xts object so you can easily return to it in the future.
# 
# As a first step, you'll want to save your xts object as a rds file for your own use. To do this, you'll use the command saveRDS(), which saves your object to a file with the name you specify (using the file argument). By default, saveRDS() will save to the current working directory.
# 
# When you're ready to return your saved data, you can use the readRDS() command to reopen the file. As you'll see in this exercise, this method maintains the class of your xts object.
# 
# Instructions
# 100 XP
# Use saveRDS() to save your flights_xts data object to a rds file. Call this file "flights_xts.rds".
# Open your rds file using readRDS(). Save your new data as flights_xts2.
# Use class() to check the class of your new flights_xts2 object.

# Save your xts object to rds file using saveRDS
saveRDS(object = flights_xts, file = "flights_xts.rds")

# Read your flights_xts data from the rds file
flights_xts2 <- readRDS("flights_xts.rds")

# Check the class of your new flights_xts2 object
class(flights_xts2)

# Examine the first five rows of your new flights_xts2 object
head(flights_xts2, n = 5)


# Exercise
# Saving time - II
# You've saved your flights_xts data to a rds file for future use. But what if you'd like to share your data with colleagues who don't use R?
# 
# A second option for saving xts objects is to convert them to shareable formats beyond the R environment, including comma-separated values (CSV) files. To do this, you'll use the write.zoo() command.
# 
# Once you've succesfully exported your xts object to a csv file, you can load the data back into R using the read.zoo() command. Unlike readRDS, however, you will need to re-encode your data to an xts object (using as.xts).
# 
# Instructions
# 100 XP
# Use write.zoo() to save the flights_xts data to "flights_xts.csv". Be sure to specify comma-separated values (",") using the sep argument.
# Read your file back into R using read.zoo(). Specify the name of the file you exported as well as the method used to separate the data. Take a look at the other arguments but don't change the code. Save this new object as flights2.
# Encode your flights2 object back into xts using as.xts(). Save your new xts object as flights_xts2.

# Export your xts object to a csv file using write.zoo
write.zoo(flights_xts, file = "flights_xts.csv", sep = ",")

# Open your saved object using read.zoo
flights2 <- read.zoo("flights_xts.csv", sep = ",", FUN = as.Date, header = TRUE, index.column = 1)

# Encode your new object back into xts
flights_xts2 <- as.xts(flights2)

# Examine the first five rows of your new flights_xts2 object
head(flights_xts2, n = 5)

