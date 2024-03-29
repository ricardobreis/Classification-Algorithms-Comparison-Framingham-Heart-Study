# Classification-Algorithms-Comparison-Framingham-Heart-Study

## A Brief Explanation
The aim of this project is to study the database called Framingham Heart Study on people who have suffered a coronary heart disease or not in the last ten years and to develop a predictive model that allows us, with a good degree of generalization, to identify and predict which patients are most likely to have coronary problems. To this study, it will be used:

1. Logistic Regression
2. Decision Tree
3. Random Forest
4. Boosting

## Data Preparation
The Framingham Heart Study sample is a set with 4240 rows and 16 columns (15 independent variables and 1 dependent).

### Features
1. Male: 0 = Female; 1 = Male
2. Age: Age at exam time.
3. Education: 1 = Some High School; 2 = High School or GED; 3 = Some College or Vocational School; 4 = college
4. CurrentSmoker: 0 = nonsmoker; 1 = smoker
5. CigsPerDay: number of cigarettes smoked per day (estimated average)
6. BPMeds: 0 = Not on Blood Pressure medications; 1 = Is on Blood Pressure medications
7. PrevalentStroke: AVC
8. PrevalentHyp: Hypertension
9. Diabetes: 0 = No; 1 = Yes
10. TotChol: Cholesterol total mg/dL
11. SysBP: Systolic pressure mmHg
12. DiaBP: Diastolic pressure mmHg
13. BMI: Body Mass Index calculated as: Weight (kg) / Height(meter-squared)
14. HeartRate: Beats/Min (Ventricular)
15. Glucose: Blood glucose mg/dL
16. TenYearCHD: Coronary heart disease in 10 years

### Checking Missing Values
As you can see we have several missing values, so I've chosen to take these rows off the dataset mostly because of the logistic regression algorithm, unlike tree based algorithms, this technique doesn't accept missing values.

![Missing Values](https://github.com/ricardobreis/Classification-Algorithms-Comparison-Framingham-Heart-Study/blob/master/missing-values.png)

### Checking Multicollinearity
To check if exists multicollinearity in this dataset, I'm using the VIF (Variance Inflation Factor), which quantifies the severity of multicollinearity. According to Gareth James, Daniela Witten, Trevor Hastie and Robert Tibshirani in "An Introduction to Statistical Learning": 

> "As a rule of thumb, a VIF value that exceeds 5 or 10 indicates a problematic amount of collinearity."

Checking the VIF column on the image below, there is no multicollinearity in Framingham Heart Study dataset.

![Multicollinearity](https://github.com/ricardobreis/Classification-Algorithms-Comparison-Framingham-Heart-Study/blob/master/Multicollinearity.PNG)

## Partitioning
After the preparation, the dataset was reduced to 3658 rows and, to this study, it was divided into 2 datasets, a validation (with 2.561 observations) and test (with 1.097 observations) samples, a proportion of 70% and 30%.

## Best Model
![ROC Curves](https://github.com/ricardobreis/Classification-Algorithms-Comparison-Framingham-Heart-Study/blob/master/Roc-curves.png)

Analyzing the ROC Curves picture above, the model that best explains the response variable is Logistic Regression. Using the Stepwise Method, we can obtain only the significant features (which means a very low p-value) that minimize the Akaike information criterion (AIC), as you can see below:

![Stepwise](https://github.com/ricardobreis/Classification-Algorithms-Comparison-Framingham-Heart-Study/blob/master/stepwise.PNG)

and it generated an equation with the following parameters:

> Z = -8.374414 + 0.553255 * (male) + 0.057016 * (age) + 0.019111 * (cigsPerDay) + 0.019128 * (sysBP) + 0.008241 * (glucose)

### Confusion Matrix
It was generated the confusion matrix for the logistic regression model with different cutoff points, and 20% is the cutoff point that has the highest number of hits in patients who will suffer heart disease without losing much accuracy in the hits of patients who will not suffer the disease. A cutoff above 20% decreases the hits of patients who will have the disease despite increasing the hits of patients who will not have the disease. As the objective of this study is to identify patients at risk for the disease, we conclude that 20% is the best fit cutoff level.

![Confusion Matrix](https://github.com/ricardobreis/Classification-Algorithms-Comparison-Framingham-Heart-Study/blob/master/confusion-matrix.PNG)

## Framingham Heart Study Dataset
- [https://www.kaggle.com/amanajmera1/framingham-heart-study-dataset](https://www.kaggle.com/amanajmera1/framingham-heart-study-dataset)
- [https://www.framinghamheartstudy.org/](https://www.framinghamheartstudy.org/)
