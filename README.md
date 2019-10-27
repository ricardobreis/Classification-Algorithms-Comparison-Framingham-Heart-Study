# Classification-Algorithms-Comparison-Framingham-Heart-Study

## A Brief Explanation
The aim of this project is to study the database called Framingham Heart Study on people who have suffered a coronary heart disease or not in the last ten years and to develop a predictive model that allows us, with a good degree of generalization, to identify and predict which patients are most likely to have coronary problems. To this study, it will be used:

1. Logistic Regression
2. Decision Tree
3. Random Forest
4. Boosting

## Features
- Male: 0 = Female; 1 = Male
- Age: Age at exam time.
- Education: 1 = Some High School; 2 = High School or GED; 3 = Some College or Vocational School; 4 = college
- CurrentSmoker: 0 = nonsmoker; 1 = smoker
- CigsPerDay: number of cigarettes smoked per day (estimated average)
- BPMeds: 0 = Not on Blood Pressure medications; 1 = Is on Blood Pressure medications
- PrevalentStroke: AVC
- PrevalentHyp: Hypertension
- Diabetes: 0 = No; 1 = Yes
- TotChol: Cholesterol total mg/dL
- SysBP: Systolic pressure mmHg
- DiaBP: Diastolic pressure mmHg
- BMI: Body Mass Index calculated as: Weight (kg) / Height(meter-squared)
- HeartRate: Beats/Min (Ventricular)
- Glucose: Blood glucose mg/dL
- TenYearCHD: Coronary heart disease in 10 years

## Checking Missing Values
As you can see we have several missing values, so I've chosen to take these features off the dataset mostly because of the logistic regression algorithm, unlike tree based algorithms, this technique doesn't accept missing values.

![Missing Values](https://github.com/ricardobreis/Classification-Algorithms-Comparison-Framingham-Heart-Study/blob/master/missing-values.png)

## Checking Multicollinearity
To check if exists multicollinearity in this dataset, I'm using the VIF (Variance Inflation Factor), which quantifies the severity of multicollinearity. According to Gareth James, Daniela Witten, Trevor Hastie and Robert Tibshirani in "An Introduction to Statistical Learning": 

> "As a rule of thumb, a VIF value that exceeds 5 or 10 indicates a problematic amount of collinearity."

Checking the VIF column on the image below, there is no multicollinearity in Framingham Heart Study dataset.

![Multicollinearity](https://github.com/ricardobreis/Classification-Algorithms-Comparison-Framingham-Heart-Study/blob/master/Multicollinearity.PNG)

## ROC Curves
![ROC Curves](https://github.com/ricardobreis/Classification-Algorithms-Comparison-Framingham-Heart-Study/blob/master/Roc-curves.png)

## Framingham Heart Study Dataset
- [https://www.kaggle.com/amanajmera1/framingham-heart-study-dataset](https://www.kaggle.com/amanajmera1/framingham-heart-study-dataset)
- [https://www.framinghamheartstudy.org/](https://www.framinghamheartstudy.org/)
