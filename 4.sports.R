library(tidyverse)

sports <- readRDS('sports.RData', 'redsox')
date <- as.Date(index(sports))
redsox <- as.data.frame(sports)
rownames(redsox) <- 1:nrow(redsox)
redsox$date <- date
redsox <- redsox %>%
  select(date, everything()) %>%
  filter(mlb == 1)


# Exercise
# Encoding and plotting Red Sox data
# After exploring and manipulating data on flights, weather, and the economy, your client wants to cover all the bases. Naturally, they'd like you to collect data on Boston's major sports teams: the Boston Red Sox (baseball), the New England Patriots (football), the Boston Bruins (hockey), and the Boston Celtics (basketball). In this chapter, you'll prepare data on the schedule and outcome of all games involving these teams from 2010 through 2015. It's a perfect opportunity to gain further practice manipulating time series data!
#   
#   As a start, you've compiled data on games played by the Boston Red Sox from 2010 through 2015. In this exercise, you'll explore the data, encode it to xts, and plot some trends over time. The redsox data frame is available in your workspace.
# 
# Instructions
# 100 XP
# Use summary() to view some summary statistics about your redsox data. Keep an eye out for the date column and assess whether or not you have missing data (NAs) that needs addressing.
# Once you're satisfied that the redsox data can be converted to xts, start this process by encoding the date column to a time-based object using as.Date().
# Use as.xts() to convert your redsox data to xts, being sure to order.by the date column. Also remove the date column (using [, -1] notation) to ensure that your xts object is numeric.
# Use plot.zoo() to plot Red Sox scores (boston_score) and opponent scores (opponent_score) over time. What trends can you identify from these plots?


# View summary information about your redsox data
summary(redsox)
class(redsox)

# Convert the date column to a time-based format
redsox$date <- as.Date(redsox$date)

# Convert your red sox data to xts
redsox_xts <- as.xts(redsox[,-1], order.by = redsox$date)

# Plot the Red Sox score and the opponent score over time
plot.zoo(redsox_xts[, c("boston_score", "opponent_score")])



# Exercise
# Calculate a closing average
# Now that you've explored some trends in your Red Sox data, you want to produce some useful indicators. In this exercise, you'll calculate the team's win/loss average at the end of each season. In financial terms, you can think of this as the team's value at the close of the season.
# 
# To calculate a closing win/loss average, you'll need to combine a few of the commands used in previous chapters.
# 
# First, you'll identify wins based on the score of each game. You can do this using a simple ifelse() command and the knowledge that the Red Sox win each game in which they score more points than the opposing team.
# 
# Second, you'll identify the date of the last game in each season using endpoints(). This command identifies the last date in your object within certain periods.
# 
# Finally, to calculate the closing win/loss average each season, simply use period.apply() on the win_loss column of your data, specifying the close dates as the index, and mean as the function.
# 
# The redsox_xts object is available in your workspace.
# 
# Instructions
# 100 XP
# Use ifelse to calculate win_loss, which is coded as a 1 if boston_score is greater than opponent_score and a 0 otherwise.
# Use endpoints() to identify the date of the last game in each season. Because baseball seasons are contained in a single year, you can specify the on argument to "years" to give you the final game each year. Save these dates as close.
# Use period.apply() to calculate the win/loss average at the close of the season. Specify the win_loss column of your redsox_xts data, the close dates as the period, and mean as the function.


# Generate a new variable coding for red sox wins
redsox_xts$win_loss <- ifelse(redsox_xts$boston_score > redsox_xts$opponent_score, 1, 0)

# Identify the date of the last game each season
close <- endpoints(redsox_xts, on = "years")

# Calculate average win/loss record at the end of each season
period.apply(redsox_xts[, "win_loss"], close, FUN = mean)



# Exercise
# Calculate and plot a seasonal average
# In the previous exercise you used endpoints() and period.apply() to quickly calculate the win/loss average for the Boston Red Sox at the end of each season. But what if you need to know the cumulative average throughout each season? Statisticians and sports fans alike often rely on this average to compare a team with its rivals.
# 
# To calculate a cumulative average in each season, you'll need to return to the split-lapply-rbind formula practiced in Chapter Three. First, you'll split the data by season, then you'll apply a cumulative mean function to the win_loss column in each season, then you'll bind the values back into an xts object.
# 
# A custom cummean() function, which generates a cumulative sum and divides by the number of values included in the sum, has been generated for you. The redsox_xts data, including the win_loss column, is available in your workspace.
# 
# Instructions
# 100 XP
# Use split() to break up the redsox_xts data into seasons (in this case, years). Assign this to redsox_seasons.
# Use lapply() to calculate the cumulative mean for each season. For this exercise, a cummean() function has been designed which calculates the sum (using cumsum()) and divides by the number of entries in the sum (using seq_along()). Save this data to redsox_ytd.
# Use do.call() with rbind to convert your list output to a single xts object (redsox_winloss) which contains the win/loss average throughout each season.
# Use plot.xts() to view the cumulative win/loss average during the 2013 season. Leave the ylim argument as is in your prewritten code.


# Split redsox_xts win_loss data into years 
redsox_seasons <- split(redsox_xts$win_loss, f = "years")

# Use lapply to calculate the cumulative mean for each season
redsox_ytd <- lapply(redsox_seasons, cummean)

# Use do.call to rbind the results
redsox_winloss <- do.call(rbind, redsox_ytd)

# Plot the win_loss average for the 2013 season
plot.xts(redsox_winloss["2013"], ylim = c(0, 1))



# Exercise
# Calculate and plot a rolling average
# The final baseball indicator you'd like to generate is the L10, or the moving win/loss average from the previous ten games. While the cumulative win/loss average tells you how the team is doing overall, the L10 indicator provides a more specific picture of the team's recent performance. Beyond the world of sports, this measure is comparable to a financial indicator focused on recent portfolio performance.
# 
# To generate a rolling win/loss average, return to the rollapply() command used in the previous chapter. In this case, you'll want to apply the mean function to the last 10 games played by the Red Sox at any given time during the 2013 season.
# 
# The redsox_xts object, including the win_loss column, is available in your workspace.
# 
# Instructions
# 100 XP
# Generate a new xts object containing only the 2013 season. Call this object redsox_2013.
# Use rollapply() to calculate your lastten_2013 indicator based on the win_loss column in redsox_2013. Set the width equal to 10 to include the last ten games played by the Red Sox and set the FUN argument to mean to generate an average of the win_loss column.
# Use plot.xts() to view your new indicator during the 2013 season. Leave the ylim argument as is in the prewritten code.


# Select only the 2013 season
redsox_2013 <- redsox_xts["2013"]

# Use rollapply to generate the last ten average
lastten_2013 <- rollapply(redsox_2013$win_loss, width = 10, FUN = mean)

# Plot the last ten average during the 2013 season
plot.xts(lastten_2013, ylim = c(0, 1))



# Exercise
# Extract weekend games
# After calculating some useful indicators from your Red Sox data, it's time to step back and explore data from other Boston sports teams. Specifically, you've collected additional data on the New England Patriots (football), the Boston Bruins (hockey), and the Boston Celtics (basketball). Data for these teams, along with your redsox data, have been merged into a single xts object, sports, which now contains data on all games played by Boston-area sports teams from 2010 through 2015.
# 
# Before conducting further analysis, you want to refine your data into a few potentially useful subsets. In particular, it may be helpful to focus exclusively on weekend games involving Boston sports teams.
# 
# To identify games based on the day of the week, you should use the .indexwday() command, which tells you the day of the week of each observation in your xts object. These values range from 0-6, with Sunday equal to 0 and Saturday equal to 6.
# 
# Instructions
# 100 XP
# Practice with the xts indexing commands by extracting the day of the week of each observation in your sports data using .indexwday(). Save these values to weekday and view the first few rows of this weekday object usign head().
# Create an index of weekend observations by combining the which() command with two calls to .indexwday(). The goal here is to extract only those dates falling on a Saturday or a Sunday. Save this index as weekend.
# Generate a new xts object (weekend_games) containing only games falling on a weekend. Use head() to view the first few rows of your new weekend_games object.


# Extract the day of the week of each observation
weekday <- .indexwday(sports)
head(weekday)

# Generate an index of weekend dates
weekend <- which(.indexwday(sports) == 6 | .indexwday(sports) == 0)

# Subset only weekend games
weekend_games <- sports[weekend]
head(weekend_games)



# Exercise
# Calculate a rolling average across all sports
# Now that you've mastered subsetting your data to include only weekend games, your client would like you to take a different approach. Perhaps Boston's tourism industry receives a boost when local sports teams win more games at home.
# 
# Instead of focusing on weekend games, you are tasked with generating a rolling win/loss average focused on games played in Boston. To produce this indicator, you'll return to the rollapply() command used above, this time applying your calculation to all Boston-area sports teams but subsetting to include only games played at home.
# 
# Instructions
# 100 XP
# Instructions
# 100 XP
# Subset your sports data to include only data from games played in Boston (homegame = 1) using the data[column == x] format. Save this new object as homegames.
# Use rollapply() to calculate the win/loss average of the last 20 homegames by Boston sports teams. You'll need to specify the win_loss column of your homegames data, set the width to 20, and set the FUN argument to mean. Save this indicator to your homegames object as win_loss_20.
# Use a similar call to rollapply() to calculate a 100 game moving win/loss average. Save this indicator to your homegames object as win_loss_100.
# Use plot.zoo() to visualize both indicators. Be sure to select the win_loss_20 and win_loss_100 columns and set the plot.type argument to "single" to view both in the same panel. Leave the lty and lwd arguments as they are.


# Generate a subset of sports data with only homegames
homegames <- sports[sports$homegame == 1]
head(sports)

# Calculate the win/loss average of the last 20 home games
homegames$win_loss_20 <- rollapply(homegames$win_loss, width = 20, FUN = mean)

# Calculate the win/loss average of the last 100 home games
homegames$win_loss_100 <- rollapply(homegames$win_loss, width = 100, FUN = mean)

# Use plot.xts to generate
plot.zoo(homegames[, c("win_loss_20", "win_loss_100")], plot.type = "single", lty = c(3, 1), lwd = 1:2)


