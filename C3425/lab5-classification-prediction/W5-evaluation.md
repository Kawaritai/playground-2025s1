# 3. Practical Exercises: Evaluation
URLS:
  * Book: https://wattlecourses.anu.edu.au/mod/book/view.php?id=3353554&chapterid=535885
  * Lab: Evaluation - https://wattlecourses.anu.edu.au/mod/page/view.php?id=3353558
  * Solutions - https://wattlecourses.anu.edu.au/mod/page/view.php?id=3353559


  # Lab: Evaluation

## Objectives
The objectives of this lab are to experiment with the evaluation methods available in R and Rattle, in order to better understand the issues involved with evaluation in data mining; and to experiment with the different evaluation methods for supervised classification available in the Rattle tool.

## Preliminaries
- Read through the following section in the Rattle online documentation:
    - [Evaluating Models](https://www.togaware.com/datamining/survivor/Evaluation1.html)  
      - This goes from Basics -> Calibration Curves
- For more information about ROC, please have a look at the paper:
    - [ROC Graphs: Notes and Practical Considerations](https://wattlecourses.anu.edu.au/mod/resource/view.php?id=3353560)  

For this lab, we will mainly use the `weather.csv` dataset which you have used previously. If you want to use another dataset to conduct more experiments at the end of the lab, feel free to do so.

## Tasks

1. [x] **Start Rattle**
    1. Tap the Rattle icon on your desktop to open the Rattle application.
    2. On the Welcome page, go to the **Dataset** tab.
    3. Tap the **Dataset** button and choose the **Weather** button to load the weather dataset.

2. [x] **Training / Validation and Overfitting**
    1. Ensure that the variable `rain_tomorrow` is selected as the target variable.
    2. Partition the data by enabling the **Partition** option with a 70/15/15 split for training, validation, and testing respectively.
        - This means 70% of the records will be used for training, 15% for validation, and 15% for testing.
    3. Make sure the variable `date` is set to the **Identifier** role.
    4. Go to the **Model** tab and select the **Tree** feature.
    5. Set the following parameters:
        - **Min Split**: 2
        - **Min Bucket**: 1
        - **Max Depth**: 30
        - **Complexity**: 0.01
    6. Tap **Build Decision Tree** and navigate to the **Decision Tree Model** page. Inspect the structure of the tree.
    
3. [x] **Evaluate the Model**
    1. Go to the **Evaluate** tab and examine the performance of the decision tree.
    2. First, evaluate the tree on the **Training** dataset.
        1. Navigate to the **Error Matrix** page.
        2. Tap the **Training** button and hover over it to read its tooltip hint.
        3. Click on **Evaluate** and note the **overall error** rate.
        4. Write down the error rate and try to understand why the model yields that error rate.
    3. Next, tap the **Validation** (or **Tuning**) option and read its tooltip.
        1. Click on **Evaluate** and note the **error rate** and **accuracy**.
        2. Discuss why the error rate is different between the training and validation sets. Why is the training error rate usually better, and why is it considered unreliable for evaluation?
    4. Experiment with tree-building parameters:
        1. Go back to the **Model** tab.
        2. Set the following new parameters:
            - **Min Split**: 20
            - **Min Bucket**: 7
            - **Max Depth**: 30
            - **Complexity**: 0.01
        3. Click on **Execute**, inspect the tree structure in the Rattle output, and move to the **Evaluate** tab again.
        4. Check the overall error for the new model.
    5. Evaluate the error rate for this model on the **Validation** dataset.
        1. What are the errors on the validation dataset? Which tree model seems better?
        2. Check the **Testing** dataset error rate by reading the tooltip for **Testing**.
    6. Discuss the importance and roles of distinct **Training**, **Validation**, and **Testing** datasets. Why are they important in model evaluation?

The error rate on the training set is 0.39%. That is, the model is very good at classification with observations from the dataset it was trained over. 

The error rate on the tuning/validation set is 16.67%. It is less good at classifying observations on this data which it has not seen before. The training error rate is unreliable for evaluation because in practical applications, the model will be used for unseen data classification. If the training error rate was a reliable measure, then we'd all be trying to overfit our models for the "best" outcome. 

For the new model, we have the training error as 8.27% and tuning/validation error as 16.67%. So the first one grew substantially higher with a less granular tree but the tuning error remained the same. The testing error is 10.91%. 

For (6.), we obviously need a training dataset in order to construct a model in the first place. However, once we're constructing the model, we need some indication of how the model is performing in order to guide to towards greater accuracy, and this is where the tuning/validation set comes it. It helps us validate that we are indeed improving the model even over unseen data. However, once we believe that we are completing with training and tuning the model, we once again want to test the performance of our model in circumstances which mimic how we want the model to actually be used. The test set is unseen during the training/tuning process, and that is what accomplishes this goal. 


4. [x] **ROC Curve**
    1. Go to the **Model** tab and select the **Tree** feature.
    2. Set the following parameters:
        - **Min Split**: 15
        - **Min Bucket**: 5
        - **Max Depth**: 30
        - **Complexity**: 0.01
    3. Generate a decision tree and inspect the result printed in the main Rattle output.
    4. Move to the **Evaluate** tab and check the overall error and averaged class error.
        1. Make sure **Validation** is selected.
        2. Note the error rate.
    5. Navigate to the **ROC Curve** page.
        1. What does the ROC curve look like?
        2. What are the axes of the graph?
        3. What is the value of **Area under the ROC curve** in the main Rattle output area?
    6. Go back to the **Model** tab, and set the following parameters:
        - **Min Split**: 13
        - **Min Bucket**: 3
        - **Max Depth**: 30
        - **Complexity**: 0.01
    7. Build the decision tree and inspect the result.
    8. Move to the **Evaluate** tab and check the overall error and averaged class error.
        1. Does the new model perform better in terms of overall error than the previously trained model?
    9. Inspect the **ROC Curve** and the **Area under the ROC curve**.
    10. Discuss the relationship between the overall error and the **Area under the ROC curve**. Which measure is more appropriate for predicting the `rain_tomorrow` variable? Why?

We have a validation error of 18.52% overall and avg error 35.31%. The ROC curve looks jagged and convex above the linear diagonal. The axes of the graph are False Positive rate and True Positive Rate. The value AUC = 0.80. 

To the second model, the overall error is 18.52% and avg error 35.31%. The same? The ROC is leaning with a peak closer to a lower FPR and the AUC is 0.72. 

I don't fucking get what ROC does. 


5. [x] **Training Proportion (Optional Extension Lab)**
    1. Choose any dataset you'd like to experiment with (e.g., audit, weather, or another dataset).
    2. Enable the **Partition** box and adjust training/validation/test proportions to **15/70/15** under settings (gear icon).
    3. Go to the **Model** tab and train a decision tree with appropriate parameters.
    4. Evaluate the trained model on the **Evaluate** tab.
        1. Review the **Error Matrix** or **ROC measure**.
        2. Evaluate performance on the **Testing** dataset.
    5. Change the training/validation/test proportions to **30/55/15** in the settings.
        1. Repeat steps 6.3–6.4 and compare performance.
        2. Did performance increase or decrease?
    6. Increase the proportion assigned to the training data, but keep the same testing proportion.
        1. Measure the performance with the adjusted proportions.
        2. Discuss when performance saturation occurs. Does adding more training data always improve performance?

Audit dataset with adjustment to RISK
(15/79/15 with 1,1 params): 2.25/5.36%, 3.79/7.94%, 4.33/8.44% => 3.60%/7.78%
ROC curve: sharp, near right angle convex to the diagonal. 

(30/55/15 with 40, 13 params): 13.50%, 17.45%, 21.00% => 16.80%
ROC curve: similar
Performance very much worse with shallower ROC charts. 

(60, 25, 15 with 40, 13 params): 14.83%, 17.00%, 17.00% => 15.70%

I don't know when performance saturation actually occurs, because for some reason accuracy was REALLY low when using only 15% of the data to train. But using slighter more data (from 30 -> 60) did improve error rate. The risk of adding too much training data is overfitting. And adjusting the paramters manually (especially in something as tedious as Rattle) is certainly not an efficient manner of optimisation. 

---

**Final Notes:**
Make sure you log out from your computer before leaving the lab room!