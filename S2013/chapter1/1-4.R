library(dplyr)

path2csv = "1-4.csv"

data <- read.csv(path2csv)

dlist <- data$outstanding_pct

# a)
hist(dlist, freq = FALSE)

# b)
more_than_4pct <- length(dlist[dlist > 4]) / length(dlist)
print(more_than_4pct)

# c)
less_than_5ct <- length(dlist[dlist < 5]) / length(dlist)
print(less_than_5ct_probability)


# Q1.15
# mean
ybar <- mean(dlist) %>% print()

# standard deviation
s <- sd(dlist) %>% print()

min_max <- c(min(dlist), max(dlist)) %>% print()

interval1 <- c(ybar - s, ybar + s) %>% print()

interval2 <- c(ybar - 2 * s, ybar + 2 * s) %>% print()

interval3 <- c(ybar - 3 * s, ybar +  3 * s) %>% print()

actual1 <- dlist[dlist > interval1[1] &
                   dlist < interval1[2]] %>% length() %>% print()

actual2 <- dlist[dlist > interval2[1] &
                   dlist < interval2[2]] %>% length() %>% print()

actual3 <- dlist[dlist > interval3[1] &
                   dlist < interval3[2]] %>% length() %>% print()

interval_strings <- c(
  sprintf("[%.2f, %.2f]", interval1[1], interval1[2]),
  sprintf("[%.2f, %.2f]", interval2[1], interval2[2]),
  sprintf("[%.2f, %.2f]", interval3[1], interval3[2])
)
actuals <- c(actual1, actual2, actual3)
expected <- c(0.68 * length(dlist), 0.95 * length(dlist), 0.997 * length(dlist))

tab <- data.frame(
  Intervals = interval_strings,
  Actual_Frequency = actuals,
  Expected_Frequency = expected
)

View(tab)
