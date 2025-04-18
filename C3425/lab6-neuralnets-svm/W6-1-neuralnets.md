# 4. Practical Exercises: Neural Network and Linear Regression in R
URLS:
  * Book: https://wattlecourses.anu.edu.au/mod/book/view.php?id=3353585&chapterid=535900
  * Lab: https://wattlecourses.anu.edu.au/mod/page/view.php?id=3353594


## **Objectives**

The objectives of this lab are to experiment with the neural network package available in R, in order to better understand the issues involved with this data mining technique; to compare the neural network classification results with the results from linear regression for predicting the value of a numerical variable.

---

## **Preliminaries**

- Use the `weather.csv` dataset (used in previous labs).
- Rattle has limited functionality, so use the R console directly.
- For help with packages:

```r
help(lm)                  # Help on linear model
library(neuralnet)        # Load neuralnet package
help(neuralnet)           # Help on neural network
```

---

## Feedback
All steps completed. See `W6-1-neuralnets.R`

This tutorial covered simple computation for neural networks and linear regression (really, GLM) in R. 

Tweaking the training parameters produces inconsistent results. 

I learned you can import the relu function via the `sigmoid` package.   

I liked the plots from this tutorial. 