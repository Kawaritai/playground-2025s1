# 8. Practical Exercise: More association mining
URLS:
  * Book: https://wattlecourses.anu.edu.au/mod/book/view.php?id=3353513&chapterid=535818
  * [] Association Mining Practical: Extended - https://wattlecourses.anu.edu.au/mod/page/view.php?id=3353537
  * Solutions: https://wattlecourses.anu.edu.au/mod/page/view.php?id=3353538


Using Rattle and the provided Association Mining Practical: Reference, use the audit.csv or Audit dataset to answer the following questions.

# Understanding the data:

(a) How many observations are in the data set?
2000 observations, as there are 2000 unique ids. `nrow(ds)`

(b) What is the median income?
Median : 59768.9  dollars (?)

(Correct.)

(c) Which attibutes have missing values?  Remove attributes with missing values from the data.
Employment and Occupation

Fix: also "IGNORE_accounts"

Done. deleted. Gone. Dusted. Thanos'd

# Frequency plot:

(d) What does this graph tell you about the distribution of records with Female and Male gender?

About double the number of males than females. 

(e) Why are Marital=Widowed or Marital=Unmarried not shown?
They're about 70/2000 = 0.035 frequency, which is very low. 

(f) At what support value would all Education related results not appear in the graph?

Greater than 660/2000 = 0.33 support

(g) Why don’t you see numerical variables such as Age or Income in these frequency plots?
Because there are too many unique values such that any individual value does not have great frequency within the dataset. 

Fix: "Because they are numeric, not categorical and a-priori cannot work with them. If we wanted this, we would need to pre-process the numerical data into categories, and even then, because a-priori does not take account of any ordering in the attributes, we may not see any interesting trends."

# Association rules:

heart Using Rattle’s default setting (Support = 0.1, Confidence = 0.1. MinLength=2), how many association rules are generated for this data set?

19 rules are generated.

(i) Which rules appear in at least a quarter of all transactions?

Just the rules involving the itemset (Married, Male), which are 2. 

# Impute missing variables for the Occupation attribute before answering the following question

(j) What new rules appear after the missing Occupation values have been imputed?
6 new rules generated.
[13] {IMO_occupation=Executive}          => {gender=Male}              0.1370  0.7025641  0.1950   1.0271405 274  
[14] {gender=Male}                       => {IMO_occupation=Executive} 0.1370  0.2002924  0.6840   1.0271405 274  
[20] {IMO_occupation=Repair}             => {gender=Male}              0.1090  0.9688889  0.1125   1.4165042 218  
[21] {gender=Male}                       => {IMO_occupation=Repair}    0.1090  0.1593567  0.6840   1.4165042 218  
[22] {IMO_occupation=Executive}          => {marital=Married}          0.1085  0.5564103  0.1950   1.2135447 217  
[23] {marital=Married}                   => {IMO_occupation=Executive} 0.1085  0.2366412  0.4585   1.2135447 217  

# Convert numeric variables for the Age numeric variable into a categorical variable with 6 categories before answering the following question

(k) What is the highest frequency age range based on the new frequency plot?
(24, 31]

(l) What new rules appear after transforming Age into a categorical variable? Are they interesting?
[10] {marital=Absent}                    => {BQT_age_6=[17,24]}        0.1510  0.4514200  0.3345   2.6711244 302  

Essentially, it's saying that there is an absence of marriage for individuals in the interval [17, 24). It makes sense and reinforces the common sense knowledge that younger adults have a higher proportion of unmarried people. Whether that's interesting (outside of numerically so), not really. Nothing new is learned.

Other association rules tell us that people in a certain age group happen to be Male -- but that has to do with the distribution of males/females anyway!

(m) Of all the rules generated, pick one that looks interesting and explain why.

[1] {education=HSgrad}         => {marital=Married}          0.1515  0.4590909  0.3300   1.001289 303 

This is interesting. It has somewhat moderate support and confidence level. Individuals with HS grad as highest education level are associated with marriage. Could it be that the time they spend building a relationship and getting married substituted the time to pursue a higher education? 

No Pick a rule with high support that does not look interesting and explain why.

[1]  {marital=Married}                   => {gender=Male}              0.4115  0.8974918  0.4585   1.3121225 823  

Considering the context of the dataset, we have high support association rules that associate Males and Marriage, but also Males and Unmarried. While one might take this to differentiate between males and females, this is not interesting because the dataset already has a higher ratio of males to females so comparing the support relative to all observations is not interesting w.r.t. male-focused rules. 