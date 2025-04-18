install.packages("factoextra")

install.packages("dbscan")

# Get the synthetic dataset
library(factoextra)
data("multishapes")
multishapes <- multishapes[,1:2]

# Preview data
plot(multishapes)

# STEP 1: Clustering with k-means
set.seed(123456789)
km.res <- kmeans(multishapes, 5, nstart = 25)


plot(multishapes, type="p", col=km.res$cluster+1, main = "K-means")

## STEP 2: DBSCAN library and algo
library(dbscan)
set.seed(123456789)
db <- dbscan(multishapes, eps = 0.15, minPts = 5)

# Plot result
plot(multishapes, main = "DBSCAN", col=db$cluster)

# Pretend with different DBSCAN parameters
db <- dbscan(multishapes, eps = 0.5, minPts = 5)
plot(multishapes, main = "DBSCAN", col=db$cluster)

## STEP 3: Use elbow technique (k is fixed)
kNNdistplot(multishapes, k =  5)

# What about k = 10?
kNNdistplot(multishapes, k =  10)
# My answer: choose epsilon = 0.2
# Now test it out
db <- dbscan(multishapes, eps = 0.2, minPts = 10)
plot(multishapes, main = "DBSCAN", col=db$cluster)
# Honestly, not bad! I also think it classifies more points than 0.15, 5
