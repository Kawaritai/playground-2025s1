# 5. Practical Exercises: K-means and Hierarchical Clustering ⌨️
  * Book: https://wattlecourses.anu.edu.au/mod/book/view.php?id=3353601&chapterid=535929
  * Note: Choosing the R option rather than the new Rattle option. 
  * Lab: https://wattlecourses.anu.edu.au/mod/page/view.php?id=3353606
  * Solutions - https://wattlecourses.anu.edu.au/mod/page/view.php?id=3353607

## Objectives
The objectives of this lab are to experiment with the `clustering` package available in R and Rattle, in order to better understand k-means and hierarchical clustering algorithms. 

## Preliminaries
For this exercise, we will mainly use "protein.csv" data set which contains 25 European countries and their protein intakes from nine major food sources. Click the following link to download the dataset:

  * European Protein Consumption dataset

We will use `clustering` library in R. To install the library type:
```R
  install.packages("cluster")
```
You can get help on packages used in this lab by typing the following three commands into the R console. Specifically for the k-means algorithm, type:
```R
    help(kmeans)
```
And for Hierarchical clustering (AGNES) type:
```R
    library(cluster)
    help(agnes)
```


## Notes
Finished. See `W7-Prac1.R`. I like it, the dendrograms were nice. The clustering happened to be geographical. I guess the data extraction is pretty cool. 

* Keywords: k-mean clustering, centers, AGNES hierarchical clustering, dendrogram, single link