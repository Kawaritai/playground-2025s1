# 7. Practical Exercises: DBSCAN and K-means ⌨️
URLS:
  * Book: https://wattlecourses.anu.edu.au/mod/book/view.php?id=3353601&chapterid=535930
  * Lab: https://wattlecourses.anu.edu.au/mod/page/view.php?id=3353612
  * Solutions - https://wattlecourses.anu.edu.au/mod/page/view.php?id=3353613

## Objectives
The objectives of this exercise are to experiment with the clustering package available in R, in order to better understand the difference between kmeans and DBSCAN algorithm. 

## Preliminaries
For this exercise, we will mainly use a synthetic dataset from `factoextra` package. To get the data set, install library:
```R
    install.packages("factoextra")
```
We will use dbscan library in R. To install the library.
```R
    install.packages("dbscan")
```
You can get help on packages used in this exercise by typing the following three commands into the R console. Specifically for the dbscan algorithm, type:
```R
    help(dbscan)
    help(kNNdistplot)
    help(kNNdist)
```

## Notes

* Finished. See `W7-Prac2.R`

* "It is really important to configure proper values of two parameters, eps(ilon) and minPts"

* Often the usage of these libraries boils down to 2-3 commands. You just need to know the names of the functions and the necessary arguments. 

* I probably can compile the used libraries in a cheatsheet for usage in the assignment

* Okay, so the `multishapes` data set on a scatter plot is, literally, just multiple shapes
  * k-means spherical-limited, and cannot cluster the full torus
  * On the other hand, the DBSCAN so obviously is better at this task. 


* So, the parameters are sensitive. Introduce the elbow technique. What does it do? It helps us choose a sensible epsilon after fixing a minPts (k)
  * For k=5, can you see how we would derive 0.15 as an optimal epsilon from the kNNdistplot?

