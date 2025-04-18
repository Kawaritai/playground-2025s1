protein_df <- read.csv("protein.csv")

head(protein_df)
# 3. There are 25 observations and 10 attributes in this dataset

## STEP 1: Start Clustering with k-means (2 attributes)
set.seed(1234567891) ## to fix the random starting clusters
grpMeat <- kmeans(protein_df[,c("RedMeat","Fish")], centers=5, nstart=10)

grpMeat

# We get a list of cluster means. We have 5 centers, so 5 means. 
# The first cluster consumes the most fish: (1    6.20 14.200000)

# Check assignment for each country
o=order(grpMeat$cluster)
data.frame(protein_df$Country[o],grpMeat$cluster[o])
# AKA: What class of cluster does this country's protein products belong to?

plot(protein_df$Red, protein_df$Fish, type="p", xlim=c(3,19), ylim=c(0,15), xlab="Red Meat", ylab="Fish", col=grpMeat$cluster+1)
text(x=protein_df$Red, y=protein_df$Fish-.6, labels=protein_df$Country, col=grpMeat$cluster+1)

# Miraculously, yes, there is a mild geographical relationship between the clusters.
# For example, the slavic countries, the nordic countries, and the developed economies.

## STEP 2: Clustering with all attributes.
set.seed(1234567891)
grpProtein <- kmeans(protein_df[,-1], centers=5, nstart=10)
o=order(grpProtein$cluster)
data.frame(protein_df$Country[o],grpProtein$cluster[o])

# The clusters seem to progress from east to west. 

## STEP 3: Hierarchical Clustering
library(cluster)
agg<-agnes(protein_df[,-1], diss=FALSE, metric="euclidian", method="average")

# Dendrogram -- Truly, hit enter in the console twice. This gives two graphs
plot(agg, main='Dendrogram', labels=protein_df$Country)

# After dendrogram, extract 5 clusters

rect.hclust(agg, k=5, border="red")

## STEP 4: Single Link hierarchical clustering
agg<-agnes(protein_df[,-1], diss=FALSE, metric="euclidian", method="single")
# NB: method="single"
  
plot(agg, main='Dendrogram', labels=protein_df$Country)
rect.hclust(agg, k=5, border="red")
