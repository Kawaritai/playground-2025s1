# 9. Practical Exercise: Decision trees
URLS:
  * Book: https://wattlecourses.anu.edu.au/mod/book/view.php?id=3353551&chapterid=535847
  * Lab: Decision trees - https://wattlecourses.anu.edu.au/mod/page/view.php?id=3353557


# Objectives

The objectives of this lab are to experiment with the decision tree package available in R and Rattle, in order to better understand the issues involved with this data mining technique; and to experiment with the different evaluation methods for supervised classification available in the Rattle tool.

# Preliminaries

Read through the following two sections in the Rattle online documentation:

  * Building a Model (http://www.togaware.com/datamining/survivor/Building_Model.html)

  * Decision Trees (http://www.togaware.com/datamining/survivor/Decision_Trees.html)

For this lab, we will mainly use the `audit.csv` dataset which you have used previously. If you want to use another data set to conduct more experiments at the end of the lab please do so.

The binary (2-class) supervised decision tree classifier in Rattle is based on the R package rpart (Recursive partitioning and regression trees). You can get help on this package by typing the following three commands into the R console (type R as a command in a terminal and then):

```
library(rpart)

help(rpart)

help(rpart.control)
```

Tasks

1. Start Rattle by tapping the rattle icon on your desktop.

2. You will then see the Rattle app's Welcome page.

3. Go to the Dataset tab and tap the Dataset button, then tap the Audit button to load Rattle's version of the audit.csv CSV data set.

4. Ensure the variable (attribute) "adjusted" is selected as the Target variable, and that you partition the data (e.g., leave the Partition button on and in Settings leave the default 70/15/15 percentage split as is). This means that we will use 70% of all records in the audit data set for training, 15% for validation (sometimes called tuning), and 15% for testing.

5. Also, make sure that the variable "id" is set to role Ident(ifier).

6. You can select or set to Ignore other variables if you feel they are not suitable for decision tree classification. After building a decision tree, you might later want to revisit the Dataset tab and change your variable selection.

7. Next, explore the data set (on the Dataset tab and also the Explore tab) to become familiar with it. Specifically, examine the values of the target variable "adjusted." How many unique values does it have, and what are they?

8. You might also want to look at the actual data values for all the variables (which you can do in the Dataset tab under the Roles feature by clicking on the top right View button).

9. Go to the Model tab and choose the Tree feature. As you can see, various parameters can be set and modified. Please read the Rattle documentation on decision trees for more information and review the tooltips that Rattle provides. You can also get additional help for these parameters from R by typing into the R console: `help(rpart.control)`.

10. To generate a decision tree, tap the Build Decision Tree button and navigate to the next page to view a textual description of the resulting Decision Tree Model. Tap the Open button (top right within the page) to view the textual description as a PDF file in a separate window. Next, navigate to the Decision Tree Visualization and tap the Open button to view the tree in a separate window. What can you see on this tree drawing?

11. Compare the Decision Tree visualization with the textual Decision Tree Model. Each node in the drawing has a boxed number corresponding to the node number. The assigned class label from the audit data set is shown as one of the values of the target variable "adjusted." The accuracy of the class assignment at the node can be understood with the two numbers showing the proportions of "No" and "Yes" targets in the dataset at this node. The percentage represents the proportion of all observations that reach this node in the tree. In the textual summary, you can see the same information for each node, including the error rate for the node, taking account of its context in the tree. On the drawing, you can see the splitting criterion written with the "yes" case sub-node on the left and the "no" sub-node on the right below. In the textual summary, instead, you can see the splitting criterion labeling each node with a different expression for each case of the pair, corresponding to an expression on one node that is the logical inverse of the expression on the other node of the pair.

12. Notice that we have built a very simple decision tree by default based on a single variable (adjustment amount). Comment on what you think about using this adjustment amount to predict whether there has been an adjustment! Go back to the Dataset tab and the Roles feature to set the variable role for adjustment to be "Risk." Now, rebuild the tree. That looks a lot more interesting.

13. Now, go to the Evaluate tab and examine the different options to evaluate the accuracy of the decision tree you just generated. Tap the Evaluate button to perform the model evaluation. Navigate to the next page and check each Error matrix that is printed. Why are there 2 matrices, and how are they related? What do the 4 internal numbers mean for each matrix? What is the error rate of your decision tree? What is its accuracy (Hint: error rate = 100% - accuracy)? Write down the four internal numbers for this tree and each of the following trees you generate.

14. Next, navigate to the different graphical evaluation tools available on the Evaluate tab, and for each, read more about these evaluation measures in the Rattle documentation section on evaluation and deployment. For now, just note they are available. We will learn more about some of these measures in another set of exercises.

15. Now, go back to the Model tab and experiment with different values for the parameters Complexity, Min Bucket, Min Split, and Max Depth. Which tree will give you the best accuracy, and which one the worst? Which tree is the easiest to interpret? Which is the hardest?

16. You can also navigate through the Model tab to the Decision Tree as Rules page to see the rules generated from a given tree. What is easier to understand, the tree diagram or the rules? What is the highest accuracy you can achieve on the audit data set using the Rattle decision tree classifier? Which is the best tree you can generate?

