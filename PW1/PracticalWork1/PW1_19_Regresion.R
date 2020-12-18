# Load the dataset, when we load an .RData using load()
# function we do not attribute it to a name like we did
# when we used read.table() or when we use read.csv()

load("F:\\Facultate\\Anul 2\\ESILV\\Machin Learning\\PracticalWork1\\EU.RData")

# lm (for linear model) has the syntax: 
# lm(formula = response ~ predictor, data = data)
# The response is the y in the model. The predictor is x.
# For example (after loading the EU dataset)
mod <- lm(formula = Seats2011 ~ Population2010, data = EU)

# We have saved the linear model into mod, which now contains all the output of lm
# You can see it by typing
mod
#ans> 
#ans> Call:
#ans> lm(formula = Seats2011 ~ Population2010, data = EU)
#ans> 
#ans> Coefficients:
#ans>    (Intercept)  Population2010  
#ans>       7.91e+00        1.08e-06

# mod is indeed a list of objects whose names are
names(mod)
#ans>  [1] "coefficients"  "residuals"     "effects"       "rank"         
#ans>  [5] "fitted.values" "assign"        "qr"            "df.residual"  
#ans>  [9] "na.action"     "xlevels"       "call"          "terms"        
#ans> [13] "model"

# We can access these elements by $
# For example
mod$coefficients
#ans>    (Intercept) Population2010 
#ans>       7.91e+00       1.08e-06

# The residuals
mod$residuals
#ans>        Germany         France United Kingdom          Italy 
#ans>         2.8675        -3.7031        -1.7847         0.0139 
#ans>          Spain         Poland        Romania    Netherlands 
#ans>        -3.5084         1.9272         1.9434         0.2142 
#ans>         Greece        Belgium       Portugal Czech Republic 
#ans>         1.8977         2.3994         2.6175         2.7587 
#ans>        Hungary         Sweden        Austria       Bulgaria 
#ans>         3.2898         2.0163         2.0575         1.9328 
#ans>        Denmark       Slovakia        Finland        Ireland 
#ans>        -0.8790        -0.7606        -0.6813        -0.7284 
#ans>      Lithuania         Latvia       Slovenia        Estonia 
#ans>         0.4998        -1.3347        -2.1175        -3.3552 
#ans>         Cyprus     Luxembourg          Malta 
#ans>        -2.7761        -2.4514        -2.3553

# The fitted values
mod$fitted.values
#ans>        Germany         France United Kingdom          Italy 
#ans>          96.13          77.70          74.78          72.99 
#ans>          Spain         Poland        Romania    Netherlands 
#ans>          57.51          49.07          31.06          25.79 
#ans>         Greece        Belgium       Portugal Czech Republic 
#ans>          20.10          19.60          19.38          19.24 
#ans>        Hungary         Sweden        Austria       Bulgaria 
#ans>          18.71          17.98          16.94          16.07 
#ans>        Denmark       Slovakia        Finland        Ireland 
#ans>          13.88          13.76          13.68          12.73 
#ans>      Lithuania         Latvia       Slovenia        Estonia 
#ans>          11.50          10.33          10.12           9.36 
#ans>         Cyprus     Luxembourg          Malta 
#ans>           8.78           8.45           8.36

# Summary of the model
sumMod <- summary(mod)
sumMod
#ans> 
#ans> Call:
#ans> lm(formula = Seats2011 ~ Population2010, data = EU)
#ans> 
#ans> Residuals:
#ans>    Min     1Q Median     3Q    Max 
#ans> -3.703 -1.951  0.014  1.980  3.290 
#ans> 
#ans> Coefficients:
#ans>                Estimate Std. Error t value Pr(>|t|)    
#ans> (Intercept)    7.91e+00   5.66e-01    14.0  2.6e-13 ***
#ans> Population2010 1.08e-06   1.92e-08    56.3  < 2e-16 ***
#ans> ---
#ans> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
#ans> 
#ans> Residual standard error: 2.29 on 25 degrees of freedom
#ans>   (1 observation deleted due to missingness)
#ans> Multiple R-squared:  0.992,   Adjusted R-squared:  0.992 
#ans> F-statistic: 3.17e+03 on 1 and 25 DF,  p-value: <2e-16
MyModel <- lm(formula = CamCom2011  ~ Population2010, data = EU)
MyModel$residuals
MyModel$coefficients
summaryMyModel = summary(MyModel)
summaryMyModel$sigma

# First, install the MASS package using the command: install.packages("MASS")

# load MASS package
library(MASS)
#ans> Warning: le package 'MASS' a été compilé avec la version R 3.6.3

# Check the dimensions of the Boston dataset
dim(Boston)
#ans> [1] 506  14

# Split the data by using the first 400 observations as the training
# data and the remaining as the testing data
train = 1:400
test = -train

# Speficy that we are going to use only two variables (lstat and medv)
variables = which(names(Boston) ==c("lstat", "medv"))
training_data = Boston[train, variables]
testing_data = Boston[test, variables]

# Check the dimensions of the new dataset
dim(training_data)
#ans> [1] 400   2

# Scatterplot of lstat vs. medv
plot(training_data$lstat, training_data$medv)

plot(training_data$lstat, training_data$medv, xlab = "x line", ylab = "y line", main = "Title", col.main = "red", pch = 17, cex = 1.3, col = "blue")

# Scatterplot of log(lstat) vs. medv
plot(log(training_data$lstat), training_data$medv)

model = lm(medv ~ log(lstat), data = training_data)
model
#ans> 
#ans> Call:
#ans> lm(formula = medv ~ log(lstat), data = training_data)
#ans> 
#ans> Coefficients:
#ans> (Intercept)   log(lstat)  
#ans>        51.8        -12.2

summary(model)
#ans> 
#ans> Call:
#ans> lm(formula = medv ~ log(lstat), data = training_data)
#ans> 
#ans> Residuals:
#ans>     Min      1Q  Median      3Q     Max 
#ans> -11.385  -3.908  -0.779   2.245  25.728 
#ans> 
#ans> Coefficients:
#ans>             Estimate Std. Error t value Pr(>|t|)    
#ans> (Intercept)   51.783      1.097    47.2   <2e-16 ***
#ans> log(lstat)   -12.203      0.472   -25.9   <2e-16 ***
#ans> ---
#ans> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
#ans> 
#ans> Residual standard error: 5.6 on 398 degrees of freedom
#ans> Multiple R-squared:  0.627,   Adjusted R-squared:  0.626 
#ans> F-statistic:  669 on 1 and 398 DF,  p-value: <2e-16

names(model)
#ans>  [1] "coefficients"  "residuals"     "effects"       "rank"         
#ans>  [5] "fitted.values" "assign"        "qr"            "df.residual"  
#ans>  [9] "xlevels"       "call"          "terms"         "model"

model$coefficients
#ans> (Intercept)  log(lstat) 
#ans>        51.8       -12.2

confint(model, level = 0.95)
#ans>             2.5 % 97.5 %
#ans> (Intercept)  49.6   53.9
#ans> log(lstat)  -13.1  -11.3


# Scatterplot of lstat vs. medv
plot(log(training_data$lstat), training_data$medv)

# Add the regression line to the existing scatterplot
abline(model)

# Scatterplot of lstat vs. medv
plot(log(training_data$lstat), training_data$medv,
     xlab = "Log Transform of % of Houshold with Low Socioeconomic Income",
     ylab = "Median House Value",
     col = "red",
     pch = 20)

# Make the line color blue, and the line's width =3 (play with the width!)
abline(model, col = "blue", lwd =3)

# Predict what is the median value of the house with lstat= 5%
predict(model, data.frame(lstat = c(5)))
#ans>    1 
#ans> 32.1

# Predict what is the median values of houses with lstat= 5%, 10%, and 15%
predict(model, data.frame(lstat = c(5,10,15)), interval = "prediction")
#ans>    fit  lwr  upr
#ans> 1 32.1 21.1 43.2
#ans> 2 23.7 12.7 34.7
#ans> 3 18.7  7.7 29.8


# Save the testing median values for houses (testing y) in y
y = testing_data$medv

# Compute the predicted value for this y (y hat)
y_hat = predict(model, data.frame(lstat = testing_data$lstat))

# Now we have both y and y_hat for our testing data. 
# let's find the mean square error
error = y-y_hat
error_squared = error^2
MSE = mean(error_squared)
MSE
#ans> [1] 17.7