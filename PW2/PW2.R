#1st "exercise"
x = c(1,7,3,4)
y = 100:1
x[3] + y[4]
cos(x[3]) + sin(x[2])*exp(-y[2])
x[3]=0
y[2]=-1
x[3] + y[4]
cos(x[3]) + sin(x[2])*exp(-y[2])
x[3]=0
z = y[x+1]
z

#2nd "exercise"
qf(p=0.9,df1=1,df2=5)
qf(p=0.95,df1=1,df2=5)
qf(p=0.99,df1=1,df2=5)
rpois(100,lambda=5)
x1=seq(-4,4,l=100)
y1=dt(x=x1,df=1)
plot(x1,y1,type="l")
y2=dt(x=x1,df=5)
y3=dt(x=x1,df=10)
y4=dt(x=x1,df=50)
y5=dt(x=x1,df=100)
lines(x1,y2,col="green")
lines(x1,y3,col="red")
lines(x1,y4,col="blue")
lines(x1,y5,col="yellow")

#3rd "exercise"
load("EU.RData")
myModel = lm(formula = CamCom2011 ~ Population2010, data=EU)
myModel$residuals
myModel$coefficients
summaryMyModel = summary(myModel)
summaryMyModel$sigma

#4th "exercise"
#STEP 1: Split the Dataset
train = 1:400
test = -train
variables = which(names(Boston) ==c("lstat", "medv"))
training_data = Boston[train, variables]
testing_data = Boston[test, variables]
dim(training_data)
#STEP 2 : Check for Linearity
plot(training_data$lstat, training_data$medv,main = "Plot of lstat vs medv",xlab = "lstat",ylab = "medv",pch=2,col="red",cex=0.5)
plot(log(training_data$lstat),training_data$medv)
model = lm(medv ~ log(lstat),data=training_data)
model
summary(model)
#With all these informations we can assume that the slope is very different from 0
#Furthermore, the p-value is inferior to 0.05 (p-value = -25.9) which means that
#there is a significant relationship between the percentage of households with low socioeconomic income 
#and the median house value.
#This relationship is negative. That is as the percantage of household with low socioeconomic income increases, 
#the median house value decreases.
#Looking at  R2, we can deduce that  62.7% of the model variation is being explained by the predictor log(lstat).
names(model)
model$coefficients
confint(model,level=0.95)
#So, a  95% confidence interval for the slope of log(lstat) is (−13.13,−11.28).
plot(log(training_data$lstat),training_data$medv,
     xlab = "Log Transform of % of Houshold wit Low Socioeconomic Income",
     ylab = "Median House Value",
     col="red",
     pch=20)
abline(model,col="blue",lwd=3)
predict(model,data.frame(lstat=c(5)))
#Median value of the house with lstat = 5% is 32.1
predict(model, data.frame(lstat = c(5,10,15), interval="prediction"))
#Median values of houses with lstat = 5%, 10%, 15% are 32.1, 23.7, 18.7
y = testing_data$medv
y_hat = predict(model, data.frame(lstat=testing_data$lstat))
error = y-y_hat
error_squared=error^2
MSE=mean(error_squared)
MSE
#We find MSE = 17.7