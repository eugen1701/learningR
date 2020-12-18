# PW4

# LAMAUVE Antoine, 
# JEANNEAU Baptiste, 
# FLOCEA Eugen, 
# GRAU Quentin

dataset <- read.csv('http://www.mghassany.com/MLcourse/datasets/Social_Network_Ads.csv')

dataset = dataset[3:5]

library(caTools)
set.seed(123) 
split = sample.split(dataset$Purchased, SplitRatio = 0.75)
training_set = subset(dataset, split == TRUE)
test_set = subset(dataset, split == FALSE)

training_set[-3] <- scale(training_set[-3]) 
test_set[-3] <- scale(test_set[-3])


classifier.logreg <- glm(Purchased ~ Age + EstimatedSalary , family = binomial, data=training_set)

# 2.

slope = coef(classifier.logreg)[2]/(-coef(classifier.logreg)[3])
intercept = coef(classifier.logreg)[1]/(-coef(classifier.logreg)[3])
intercept
slope

plot(test_set$EstimatedSalary, test_set$Age)
abline(intercept,slope)

# 3.

pred.glm = predict(classifier.logreg, newdata = test_set[,-3], type="response")

pred.glm_0_1 = ifelse(pred.glm >= 0.5, 1,0)

bg_pred = ifelse(pred.glm_0_1 == 1, 'red', 'green')
#bg_pred


plot(test_set$Age,test_set$EstimatedSalary)
points(test_set$Age, test_set$EstimatedSalary, bg=bg_pred, pch=21)
abline(intercept,slope)

# 4. 

bg_real = ifelse(test_set$Purchased == 1, 'red', 'green')
plot(test_set$Age,test_set$EstimatedSalary)
points(test_set$Age, test_set$EstimatedSalary, bg=bg_real, pch=21)
abline(intercept,slope)

# We can count 10 false positives

conf = table(pred.glm_0_1,test_set$Purchased)
conf

# We confirm that there are 10 false positives

# 5.

library(MASS)
classifier.lda = lda(Purchased~Age+EstimatedSalary, data= training_set)

# 6.

classifier.lda

# The prior probabilities are pi0 = 0.6433333 and pi1 = 0.3566667

# For Age : mu0 = -0.4617220 and mu1 = 0.8328257
# For EstimatedSalary : mu0 = -0.2827853 and mu1 = 0.5100707

# The coefficients of linear discriminants are :
# For Age : 1.1499003 and the EstimatedSalary : 0.5750509

classifier.lda$prior
classifier.lda$means

# 7.
pred_lda = predict(classifier.lda, newdata = test_set[,-3], type="response")
str(pred_lda)

# 8.
conf_lda = table(pred_lda$class,test_set$Purchased)
conf_lda

analysis = function(conf){
  tp = conf[1]
  tn = conf[4]
  fp = conf[3]
  fn = conf[2]
  return (list((tp+tn)/(tp+tn+fn+fp),(tn/(tn+fp)),tp/(tp+fn),tp/(tp+fp)))
}
analysis(conf)
analysis(conf_lda)

# We obtained exactly the same matrix than the logistic regression
# So the accuracy is the same

# 9.

# create a grid corresponding to the scales of Age and EstimatedSalary
# and fill this grid with lot of points
X1 = seq(min(training_set[, 1]) - 1, max(training_set[, 1]) + 1, by = 0.01)
X2 = seq(min(training_set[, 2]) - 1, max(training_set[, 2]) + 1, by = 0.01)
grid_set = expand.grid(X1, X2)
# Adapt the variable names
colnames(grid_set) = c('Age', 'EstimatedSalary')

# plot 'Estimated Salary' ~ 'Age'
plot(test_set[, 1:2],
     main = 'Decision Boundary LDA',
     xlab = 'Age', ylab = 'Estimated Salary',
     xlim = range(X1), ylim = range(X2))

# color the plotted points with their real label (class)
points(test_set[1:2], pch = 21, bg = ifelse(test_set[, 3] == 1, 'green4', 'red3'))

# Make predictions on the points of the grid, this will take some time
pred_grid = predict(classifier.lda, newdata = grid_set)$class

# Separate the predictions by a contour
contour(X1, X2, matrix(as.numeric(pred_grid), length(X1), length(X2)), add = TRUE)

#10.1

class0 = subset(training_set,training_set$Purchased==0)

class1 = subset(training_set,training_set$Purchased==1)

# 10.2

N = length(training_set$Purchased)
N0 = length(class0$Purchased)
N1 = length(class1$Purchased)
pi0 = N0/N
pi1 = N1/N
pi0
pi1

# 10.3

mu0 = c(mean(class0$Age),mean(class0$EstimatedSalary))
mu1 = c(mean(class1$Age),mean(class1$EstimatedSalary))
mu0
mu1

# 10.4

class0_without_purshased = class0[0:2]
class1_without_purshased = class1[0:2]
cov0 = cov(class0_without_purshased)
cov0
cov1 = cov(class1_without_purshased)
cov0
cov1

Sigma = ((nrow(class0)-1)*cov0 + (nrow(class1)-1)*cov1)/(nrow(class0)+nrow(class1)-2)
Sigma

# 10.5

Sigma_inv = solve(Sigma) 
Sigma_inv
x = c(1,1.5)
x

d0 = (x %*% Sigma_inv %*% t(t(mu0))) - 0.5 *  mu0 %*% Sigma_inv  %*% t(t(mu0)) + log(pi0) 
d0
d1 = (x %*% Sigma_inv %*% t(t(mu1))) - 0.5 *  mu1 %*% Sigma_inv  %*% t(t(mu1)) + log(pi1)
d1

# This spesific x is more likely to be in class 1 because d1 = 0.7041412 > d0 = -2.077352

# 10.6

predict_lda_from_scratch = data.frame()

for (i in 1:nrow(test_set)){
  
  d0_i = ((c(test_set$Age[i],test_set$EstimatedSalary[i]) %*% Sigma_inv %*% t(t(mu0))) - 0.5 *  mu0 %*% Sigma_inv  %*% t(t(mu0)) + log(pi0))
  d1_i = ((c(test_set$Age[i],test_set$EstimatedSalary[i]) %*% Sigma_inv %*% t(t(mu1))) - 0.5 *  mu1 %*% Sigma_inv  %*% t(t(mu1)) + log(pi1))
  d = c(d0_i,d1_i)
  predict_lda_from_scratch = rbind(predict_lda_from_scratch,d)
}  


predict_lda_from_scratch_bg = ifelse(predict_lda_from_scratch[1]>predict_lda_from_scratch[2],'green','red')

plot(test_set$Age,test_set$EstimatedSalary)
points(test_set$Age, test_set$EstimatedSalary, bg=predict_lda_from_scratch_bg, pch=21)

conf=table(predict_lda_from_scratch_bg,test_set$Purchased)
conf

# We obtained the same confusion matrix so the results are the same

# 11.

classifier.qda <- qda(Purchased~., data = training_set)
classifier.qda

# 12.

pred_qda = predict(classifier.qda, newdata = test_set[,-3], type="response")

conf_qda = table(pred_qda$class,test_set$Purchased)
conf_qda

# The matrix is more precise because there are less false positives and false negatives

# 13.

X1 = seq(min(training_set[, 1]) - 1, max(training_set[, 1]) + 1, by = 0.01)
X2 = seq(min(training_set[, 2]) - 1, max(training_set[, 2]) + 1, by = 0.01)
grid_set = expand.grid(X1, X2)

colnames(grid_set) = c('Age', 'EstimatedSalary')

plot(test_set[, 1:2],
     main = 'Decision Boundary QDA',
     xlab = 'Age', ylab = 'Estimated Salary',
     xlim = range(X1), ylim = range(X2))

points(test_set[1:2], pch = 21, bg = ifelse(test_set[, 3] == 1, 'green4', 'red3'))

pred_grid = predict(classifier.qda, newdata = grid_set)$class

contour(X1, X2, matrix(as.numeric(pred_grid), length(X1), length(X2)), add = TRUE)

# 14.

# For Logistic Regression :

require(ROCR)
score <- prediction(pred.glm,test_set[,3]) # we use the predicted probabilities not the 0 or 1
performance(score,"auc") # y.values
plot(performance(score,"tpr","fpr"),col="blue")
abline(0,1,lty=8)

par(new=TRUE)

# For LDA :

require(ROCR)
score <- prediction(pred_lda$posterior[,2],test_set[,3]) # we use the predicted probabilities not the 0 or 1
performance(score,"auc") # y.values
plot(performance(score,"tpr","fpr"),col="green")

par(new=TRUE)

# For QDA :

require(ROCR)
score <- prediction(pred_qda$posterior[,2],test_set[,3]) # we use the predicted probabilities not the 0 or 1
performance(score,"auc") # y.values
plot(performance(score,"tpr","fpr"),col="red")

# The best model for this dataset is the QDA because the area under the curve is the highest
# This means that the model is better at distinguishing between Purchased and not Purchased
