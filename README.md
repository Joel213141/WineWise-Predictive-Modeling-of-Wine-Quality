# Wine Quality Prediction and Analysis

## Overview

This project analyzes the quality of red wine based on several physicochemical properties. Using the `RedWine.txt` dataset, various transformations are applied to the data, and different models are built to predict wine quality. The analysis primarily uses R scripts, focusing on methods like Weighted Arithmetic Mean (WAM), Quasi Arithmetic Mean (QAM), and Ordered Weighted Average (OWA).

## Data Preparation

The initial dataset `RedWine.txt` contains physicochemical properties of red wine. The data preparation includes:
- Sampling 400 instances from the original dataset.
- Selecting specific variables such as citric acid, chlorides, total sulfur dioxide, pH, and alcohol for analysis.
- Generating scatterplots and histograms to visualize relationships and distributions.

## Data Transformation
To improve the data distribution for modeling, specific transformations were applied:

- Logarithmic transformation for variables like total sulfur dioxide and chlorides.
- Min-Max normalization to scale the data to a common range.

## Model Fitting

The project investigates three models for predicting wine quality:

- **Weighted Arithmetic Mean (WAM)**
- **Quasi Arithmetic Mean (QAM)**
- **Ordered Weighted Average (OWA)**

These models are evaluated based on metrics such as Root Mean Square Error (RMSE), Average Absolute Error, and correlation coefficients.

### Results Summary

- **Quasi Arithmetic Mean (QAM)** was selected as the most effective model due to its flexibility in handling variable importance and its better fit for the data.
- The output files for each model are saved in the `models/` directory.
- ![Error Measures/Correlation Coefficients and Weights/Parameters](./image.png)

## Results
Predicted Quality: 6.08
Interpretation: The predicted score of 6.08 indicates a wine quality slightly above the average recorded score of 5.615.

## Analysis & Conclusion
- The analysis shows that citric acid and pH have a significant impact on wine quality. The QAM model provided the best predictions, considering the non-linear relationships between variables and wine quality.

##Citations and References
- Deakin University, 2023. Redwine Dataset. Available at: Deakin University Link [Accessed 20 April 2023]
- Deakin University, 2023. AggWaFit718.R Script. Available at: Deakin University Link [Accessed 20 April 2023]
