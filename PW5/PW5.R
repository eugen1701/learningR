# PW5 

# LAMAUVE Antoine
# JEANNEAU Baptiste
# FLOCEA Eugen
# GRAU Quentin

# Regression Trees

# Single Tree

# 1.
library(MASS)
library(caTools)
set.seed(18)
Boston_idx = sample(1:nrow(Boston), nrow(Boston) / 2) 
Boston_train = Boston[Boston_idx,]
Boston_test  = Boston[-Boston_idx,]

# 2.
library(rpart)
Boston_tree = rpart(medv~.,data=Boston_train)

# 3.
plot(Boston_tree)
text(Boston_tree,pretty=0)
title(main="Regression Tree")

# 4.
library(rpart.plot)
rpart.plot(Boston_tree)
prp(Boston_tree)

# 5.
summary(Boston_tree)
printcp(Boston_tree)
plotcp(Boston_tree)

# 5bis
RMSE = function(v1,v2){
  sqrt(mean((v1-v2)^2))
}

# 6.
pred.regtree = predict(Boston_tree, newdata=Boston_test, type = "vector")
reg_err = RMSE(pred.regtree, Boston_test$medv)

# 7.
model = lm(medv~.,data=Boston_train)
pred.lm = predict(model, Boston_test,type="response")
lm_err = RMSE(pred.lm, Boston_test$medv)

plot(pred.regtree, Boston_test$medv)
abline(0,1,lty=3)
plot(pred.lm,Boston_test$medv)
abline(0,1,lty=3)

# Bagging

# 8.
library(randomForest)
bagging.boston = randomForest(medv~.,data=Boston, subset=Boston_idx, mtry=13)

# 9.
pred.bag = predict(bagging.boston, newdata=Boston_test, type = "response")
bag_err = RMSE(pred.bag, Boston_test$medv)

# Yes the performance of the model is better than linear regression
# Indeed, 3.902412 < 5.016083

# 10.
rf.boston = randomForest(medv~.,data=Boston, subset=Boston_idx, mtry=13/3)
pred.rf = predict(rf.boston, newdata=Boston_test, type = "response")
rf_err = RMSE(pred.rf, Boston_test$medv)

# 11.
importance(rf.boston)

# 12.
varImpPlot(rf.boston)

# Boosting

library(gbm)

# 10.

boost.boston = gbm(medv ~ ., data = Boston_train, distribution = "gaussian", 
                   n.trees = 5000, interaction.depth = 4, shrinkage = 0.01)
pred.boost = predict(boost.boston, newdata=Boston_test, type = "response")
boost_err = RMSE(pred.boost, Boston_test$medv)

# 11.
summary(boost.boston)

# Comparison

# 12.
name_model = c('Tree Model', 'Linear Model','Bagging Model','Rf Model','Boosted Model')
errors_list = c(reg_err,lm_err,bag_err,rf_err,boost_err)
df_error = data.frame(name_model,errors_list)
library(knitr)
kable(df_error)

# Classification Trees

Spam = read.csv('C:/Users/33610/Documents/ESILV/A4/spam.csv')
Spam$spam = ifelse(Spam$spam == FALSE, 0, 1)
summary(Spam)

# Spam

# We subset the dataset
set.seed(10)
spam_idx = sample(1:nrow(Spam), nrow(Spam) / 2)
spam_train = Spam[spam_idx,]
spam_test  = Spam[-spam_idx,]

# We create the models

# Logistic regression
glm_mod = glm(spam ~ ., data = spam_train, family = "binomial")

# Regression tree
spam_tree = rpart(spam ~ ., data = spam_train)
rpart.plot(spam_tree)

# Random forest
spam_rf = randomForest(spam ~ ., data=Spam, subset = spam_idx, mtry = sqrt(13))

# Bagging
spam_bag = randomForest(spam ~ ., data=Spam, subset = spam_idx, mtry = 13)

# Boosting
spam_boost = gbm(spam ~ ., data = spam_train, distribution = "gaussian", 
                 n.trees = 5000, interaction.depth = 4, shrinkage = 0.01)

# Then, we predict the spam value
pred_spam_tree = predict(spam_tree, spam_test, type="vector")
pred_spam_lm= predict(glm_mod, spam_test, type = "response")
pred_spam_rf = predict(spam_rf, spam_test, type = "response")
pred_spam_bag = predict(spam_bag, spam_test, type = "response")
pred_spam_boost = predict(spam_boost, spam_test, type = "response")

# We round the data to 0 or 1
pred_spam_tree_0_1 = ifelse(pred_spam_tree > 0.5, 1,0)
pred_spam_lm_0_1 = ifelse(pred_spam_lm > 0.5, 1,0)
pred_spam_rf_0_1 = ifelse(pred_spam_rf > 0.5, 1,0)
pred_spam_bag_0_1 = ifelse(pred_spam_bag > 0.5, 1,0)
pred_spam_boost_0_1 = ifelse(pred_spam_boost > 0.5, 1,0)

# We create the accuracy function
accuracy = function(v1,v2){
  conf=table(v1,v2)
  tp = conf[1]
  tn = conf[4]
  fp = conf[3]
  fn = conf[2]
  return ((tp+tn)/(tp+tn+fn+fp))
}

# And we calculate the accuracy for each model
acc_tree = accuracy(pred_spam_tree_0_1, spam_test$spam)
acc_tree
acc_lm = accuracy(pred_spam_lm_0_1, spam_test$spam)
acc_lm
acc_rf = accuracy(pred_spam_rf_0_1, spam_test$spam)
acc_rf
acc_bag = accuracy(pred_spam_bag_0_1, spam_test$spam)
acc_bag
acc_boost = accuracy(pred_spam_boost_0_1, spam_test$spam)
acc_boost

# And present the results in a dataframe
name_model = c('Tree Model', 'Linear Model','Bagging Model','Rf Model','Boosted Model')
name_model
accuracy = c(acc_tree,acc_lm,acc_bag,acc_rf,acc_boost)
df_acc = data.frame(name_model,accuracy)

kable(df_acc)
