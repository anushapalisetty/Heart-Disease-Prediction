## Implement Maximum Likelihood Classifier to predict heart disease

## Objective:
To use the Maximum Likelihood statistical method to predict if a patient has a Heart Disease or not. Given a set of parameters and i.i.d samples we calculate the maximum likelihood of a function for new data point and predict if he has a heart disease or not. We estimate the parameters of assumed distribution for the data and evaluate the PDF for each class label. The label is classified for each data point which has the maximum PDF value.

## Approach:

1) We consider data from https://archive.ics.uci.edu/ml/datasets/Heart+Disease for 303 patients. We have two values of observation “0” and “1” where “0” represent no Heart disease, “1” represent the presence of heart disease. We make sure the number of samples are more than the number of variables.
2) From the dataset we have 303 observations, 13 variables and one class label. We implement the Maximum likelihood function by estimating the μ and Σ values for each class.
3) Calculate the covariance matrix for the and calculate the PDF for Multivariate Gaussian distribution, for each class and assign the label which has maximum PDF value. We consider the argmax value of the likelihoods. Based on the predictions we calculate the accuracy score.

## R Script:
### Step 1:
Intially Install these packages

library(matlib)
library(corrplot)
library(ggplot2)


### Step 2:
The name of the data file is heart.csv. 
Copy the file into your local folder and the path of the file as below 

data = read.csv("\Users\pavan\Desktop\Comp Stats\Project\heart.csv")


### Step 3:

Now execute all commands in the R code step by step.

Step 4:

"accuracy" in the last step is the final score of the prediction. 

