# PW3 - Social Network Ads

# 1. Dowload the dataset and import it into R

dataset = read.csv("Social_Network_Ads.csv")

# 2. Explore and Describe the dataset using str() and summary() functions

str(dataset)
summary(dataset)

cor(dataset$Age, dataset$Purchased)# 0.6224542 quite good
cor(dataset$EstimatedSalary, dataset$Purchased)# 0.362083 not that good

plot(dataset$EstimatedSalary, dataset$Purchased)
plot(dataset$Age, dataset$Purchased)

# We can see that these two features are correlated with the Purchased value

# 3. We now want to split the dataset into training set and testing set

library(caTools)
set.seed(123)
split = sample.split(dataset$Purchased, SplitRatio = 0.75)
training_set = subset(dataset, split = TRUE)
test_set = subset(dataset, split = FALSE)

# 4. Scale the input variables in both training set and test set

# Scale, with default settings, will calculate the mean and standard deviation of the entire vector, then "scale" each element by those values by subtracting the mean and dividing by the sd.

training_set[c(3,4)] = scale(training_set[c(3,4)])
test_set[c(3,4)] = scale(test_set[c(3,4)])

# 5. Fit a simple logistic regression model of Purchased in function of Age

model = glm(Purchased ~ Age, family="binomial", data = training_set)
summary(model)

# 6. We use family argument as binomial because we want to tell R to run a logistic regression rather than some other type of generalized linear model.

# 7. p(X) = exp(-0.9292 + 1.9807 * X)/(1 + exp(-0.9292 + 1.9807 * X))

# 8. Age is very significant, because his p_value < 0.05 (and it's have ***)

# 9. AIC value of the model

AIC(model, k=2)

# We obtained 340.2613 with k = 2 because we have beta0 and beta1

# 10. Plot Purchased in function of Age

plot(training_set$Age, training_set$Purchased, xlab = "Age", ylab = "Purchased")
curve(predict(model,data.frame(Age = x), type="response"),add=TRUE)

# 11. Let's add a new feature to our model

model2 = glm(Purchased ~ Age + EstimatedSalary, data = training_set)
summary(model2)

# 12. Are the predictors significant to the new model ?

# Yes because we have the p-values < 2e-16 so this is very close to zero 
# and we also have the code '***' that tells us that the predictors are significant

# 13. Do we obtain a better model by adding the estimated salary?

# Yes because we have AIC(model2) < AIC(model) so model2 is better

# 14. Predict the probability of purchasing the product by the users using the obtained model.

prediction = predict(model2,test_set,type='response')
summary(prediction)

# 15. Transform the predicted values to 0 or 1

prediction = ifelse(prediction < 0.5,0,1)

# 16. Compute the confusion matrix

conf = table(prediction,test_set$Purchased)

# So we have 238 true positives, 97 true negatives, 46 false positives and 19 false negatives

# 17. Calculate  the accuracy, specificity, sensitivity and the precision of the model.

analysis = function(conf){
  tp = conf[1]
  tn = conf[4]
  fp = conf[3]
  fn = conf[2]
  return (list((tp+tn)/(tp+tn+fn+fp),(tn/(tn+fp)),tp/(tp+fn),tp/(tp+fp)))
}
analysis(conf)

# 18. Plot the ROC curve and calculate AUC value

library(ROCR)
prediction = predict(model2,test_set,type='response')
pred_ROCR = prediction(prediction,test_set$Purchased)
perf = performance(pred_ROCR,measure = "tpr",x.measure = "fpr")
perf_auc = performance(pred_ROCR, measure = "auc")
plot(perf, title="ROC Curve",col='red')
abline(0,1,lty=3 )
perf_auc@y.values[[1]]
# We have AUC = 0.9267231

# 19. 
prediction = predict(model,test_set,type='response')
pred_ROCR = prediction(prediction,test_set$Purchased)
perf = performance(pred_ROCR,measure = "tpr",x.measure = "fpr")
perf_auc = performance(pred_ROCR, measure = "auc")
par(new=TRUE)
plot(perf,col='blue')
perf_auc@y.values[[1]]
# We have AUC = 0.868575

# We can see that AUC value of model2 is higher than model1 so 
# model2 is better

