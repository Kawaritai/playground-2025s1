relative_path2csv = "1-2.csv"

data <- read.csv(relative_path2csv)

wind <- as.list(data)$avg_wind_speed

# Generate histogram
hist(
  wind,
  main = "Histogram of Average Wind Speed in Chicago",
  freq = FALSE,
  xlab = "Average Wind Speed (mi/h)",
  ylab = "Relative Frequency",
  ylim = c(0, 0.5),
  breaks = "FD" # Determine the bins.
)

# What % cities > 10.3?
f <- length(wind[wind > 10.3]) * 100 / length(wind)


# Question 1.13
library(dplyr)

ybar <- mean(wind)

s <- sd(wind)

min_max <- c(min(wind), max(wind)) %>% print()

interval1 <- c(ybar - s, ybar + s) %>% print()

interval2 <- c(ybar - 2 * s, ybar + 2 * s) %>% print()

interval3 <- c(ybar - 3 * s, ybar +  3 * s) %>% print()
 
wind[wind > interval1[1] & wind < interval1[2]] %>% length() %>% print()

wind[wind > interval2[1] & wind < interval2[2]] %>% length() %>% print()

wind[wind > interval3[1] & wind < interval3[2]] %>% length() %>% print()

length(wind)

expected <- c(
  0.68 * length(wind),
  0.95 * length(wind),
  0.997 * length(wind)
) %>% print()
