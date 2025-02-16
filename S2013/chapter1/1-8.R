relative_path2csv = "1-8.csv"

# Read data
data <- read.csv(relative_path2csv)

# Get the data of % aluminum oxide
pct_ao <- as.list(data)$alum_oxide

length(pct_ao)

# Specify plot layout
par (mfrow = c(1,1))
# Generate histogram
hist(
  pct_ao,
  main = "Histogram of Aluminum Oxide % measurements",
  freq = FALSE,
  xlab = "Aluminum Oxide (%)",
  ylab = "Relative Frequency",
  xlim = c(10, 22),
  breaks=10
  # ylim = c(0, 0.2),
)

site_tables <- split(data$alum_oxide, data$site)

par(mfrow = c(2, 2))  # Adjust layout for multiple plots

for (sname in names(site_tables)) {
  hist(
    site_tables[[sname]],
    main = paste("Histogram of", sname),
    xlab = "Aluminum Oxide (%)",
    ylab = "Relative Frequency",
    xlim = c(0, 30),
    ylim = c(0, 4)
  )
}


