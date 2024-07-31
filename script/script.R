##################################
#Question 1 - Understand the Data
##################################

data.energy <- as.matrix(read.table("C:/Users/User/Desktop/Assesment 2/RedWine.txt"))

set.seed(222006748) # using your student ID number for reproducible sampling with the seed function

data.subset <- data.energy[sample(1:1599, 400), c(1:6)]

data.variable.names <- c("citric acid", "chlorides", "total sulfur dioxide", "pH", "alcohol")


# Create 5 scatterplots function (for each X variable against the variable of interest Y) 

par(mfrow = c(2,3))
plot(data.subset[,1],data.subset[,6], xlab=data.variable.names[1], ylab="Quality")
plot(data.subset[,2],data.subset[,6], xlab=data.variable.names[2], ylab="Quality")
plot(data.subset[,3],data.subset[,6], xlab=data.variable.names[3], ylab="Quality")
plot(data.subset[,4],data.subset[,6], xlab=data.variable.names[4], ylab="Quality")
plot(data.subset[,5],data.subset[,6], xlab=data.variable.names[5], ylab="Quality")

install.packages("lpSolve")

# Create 6 histograms for each X variable and Y
par(mfrow = c(2,3))
hist(data.subset[,1],xlab=data.variable.names[1], main="Citric Acid")
hist(data.subset[,2],xlab=data.variable.names[2], main="chlorides")
hist(data.subset[,3],xlab=data.variable.names[3], main="total sulfur dioxide")
hist(data.subset[,4],xlab=data.variable.names[4], main="pH")
hist(data.subset[,5],xlab=data.variable.names[5], main="alcohol")
hist(data.subset[,6],xlab=data.variable.names[6], main="Quality")
mean(data.subset[,6])
################################
#Question 2 - Transform the Data
################################


I <- c(1,2,3,4,6) # Choose any four X variables and Y
I
variables_to_transform <- data.subset[,I]  # obtain a 400 by 5 matrix

variables_to_transform
data.variable.names.new <- c("citric acid", "chlorides", "total sulfur dioxide","pH")

# for each variable, you need to figure out a good data transformation method, 
# such as Polynomial, log and negation transformation. The k-S test and Skewness 
# calculation may be helpful to select the transformation method

ks.test(variables_to_transform[,3],"pnorm", mean(variables_to_transform[,3]), sd(variables_to_transform[,3]))
ks.test(x,y)
data.transformed=variables_to_transform
p=2 # for example, using p=2 to transform the first variable. You should change p based on your distribution.
data.transformed[,3]=log(variables_to_transform[,3]) 
data.transformed[,2]=log(variables_to_transform[,2])
hist(data.transformed[,2], main = 'After transformation',xlab='chlorides')

ks.test(log(variables_to_transform[,3]),"pnorm", mean(log(variables_to_transform[,3])), sd(log(variables_to_transform[,3])))
# A Min-Max and/or Z-score transformation should then be used to adjust the scale of each variable

# minmax normalisation
minmax <- function(x){
  (x - min(x))/(max(x)-min(x))
}

# z-score standardisation and scaling to unit interval
unit.z <- function(x){
  0.15*((x-mean(x))/sd(x)) + 0.5
}

data.transformed[,1]=minmax(data.transformed[,1]) # for example,using min-max normalisation for the first varible.
data.transformed[,2]=minmax(data.transformed[,2])
data.transformed[,3]=minmax(data.transformed[,3])
data.transformed[,4]=minmax(data.transformed[,4])
data.transformed[,5]=minmax(data.transformed[,5])

# Save this transformed data to a text file
write.table(data.transformed, "Joel-transformed.txt")  # replace ??name?? with either your surname or first name.

##########################################
#Question 3 - Build models and investigate
##########################################

source("C:/Users/User/Desktop/Assesment 2/AggWaFit718.R")

data.transformed_copy <- as.matrix(read.table("Joel-transformed.txt"))  # import your saved data
data.transformed_copy

# Get weights for Weighted Arithmetic Mean with fit.QAM() 
install.packages("lpSolve")
library(lpSolve)
fit.QAM(data.transformed_copy[,c(1:4,5)],"WAMoutput.txt", "WAMstats.txt")
read.table("WAMstats.txt")

# Get weights for Power Mean p=2 with fit.QAM()
fit.QAM(data.transformed_copy[,c(1:4,5)],"QMoutput.txt", "QMstats.txt", g=QM, g.inv = invQM)
read.table("QMoutput.txt")

# Get weights for Ordered Weighted Average with fit.OWA()
fit.OWA(data.transformed_copy[,c(1:4,5)],"OWAoutput.txt", "OWAstats.txt")
read.table("OWAoutput.txt")

#######################################
#Question 4 - Use Model for Prediction
#######################################

new_input <- c(1, 0.75, 40, 3.53, 8.3) 

new_input_to_transform <- new_input[c(1,2,3,4)] # choose the same four X variables as in Q2 


# transforming the four variables in the same way as in question 2 

new.data.transformed=new_input[c(1,2,3,4)]
new.data.transformed[3]=log(new_input_to_transform[3]) 
new.data.transformed[2]=log(new_input_to_transform[2])
new.data.transformed[1]=  (new.data.transformed[1]-min(variables_to_transform[,1],new_input_to_transform[1]))/ (max(variables_to_transform[,1],new_input_to_transform[1]) - min(variables_to_transform[,1],new_input_to_transform[1]))
new.data.transformed[2]=  (new.data.transformed[2]-min(variables_to_transform[,2],new_input_to_transform[2]))/ (max(variables_to_transform[,2],new_input_to_transform[2]) - min(variables_to_transform[,2],new_input_to_transform[2]))
new.data.transformed[3]=  (new.data.transformed[3]-min(variables_to_transform[,3],new_input_to_transform[3]))/ (max(variables_to_transform[,3],new_input_to_transform[3]) - min(variables_to_transform[,3],new_input_to_transform[3]))
new.data.transformed[4]=  (new.data.transformed[4]-min(variables_to_transform[,4],new_input_to_transform[4]))/ (max(variables_to_transform[,4],new_input_to_transform[4]) - min(variables_to_transform[,4],new_input_to_transform[4]))
# applying the transformed variables to the best model selected from Q3 for Y prediction

QAM.weights=c(0.43976592456774,0.0303548541532766,0.125944870482142,0.403934350796841)
result=QAM(new.data.transformed,QAM.weights)

# Reverse the transformation to convert back the predicted Y to the original scale and then round it to integer

result= (result*(max(variables_to_transform[,5],result) - min(variables_to_transform[,5],result))) + min(variables_to_transform[,5],result)
result

# Citations and References
# Deakin University,2023.Redwine.Deakin University.Available at:https://d2l.deakin.edu.au/d2l/le/content/1316530/viewContent/6673443/View [Accessed 20 April 2023]
# Deakin University,2023.AggWaFit718.R.Deakin University.Available at:https://d2l.deakin.edu.au/d2l/le/content/1316530/viewContent/6673443/View [Accessed 20 April 2023]
# 