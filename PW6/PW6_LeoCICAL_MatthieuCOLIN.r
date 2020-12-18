rm(list = ls())

################## PW6 Leo CICAL Matthieu COLIN ##################################

# 1)

iris_data = read.csv("iris.data")
iris_data


#2)

boxplot(sepal_length ~ class, data=iris_data, col = "blue", main="Sepal Length")
boxplot(sepal_width ~ class, data=iris_data, col = "blue", main="Sepal Width")
boxplot(petal_length ~ class, data=iris_data, col = "blue", main="Petal Length")
boxplot(petal_width ~ class, data=iris_data, col = "blue", main="Petal Width")
par(mfrow=c(2,2))

# For Sepal :

# - lenght :

# We see that we have the 3 differents means for sepal : 5cm for setosa < 6 cm for versicolor < 6.5 cm for viriginica
# In general, setosa are smallest (the smallest sepal lentgh is 4.35, it's a setosa), followed by versicolor (the max sepal lenght for setosa is the
#beginning of the second quartile for versicolor,env 5.6cm !) then by viriginica (the min sepal length for virigina is 5.6cm, the
#beginning of the second quartile for versicolor)

# - Width :

# We see that we have the 3 differents means for sepal : 2.8cm for versicolor < env  3 cm for virginica < 3.45 cm for setosa
#In general, versicolor are smallest (the smallest sepal width is 2, it's a versicolor), followed very close by virginica (the box are close, but
# virginica have bigger values (but very close) then by setosa. But the are very close in terms of sepal width 

# For Petal :

# Length :
# We directly remark Setosa's Petal Length are smaller and vary the less, with a mean around 1.5 cm.
# Versicolor's and Virginica's petal length both vary a lot more, between 3cm/5cm and 4,5cm/7cm respectively 

# Width :
# Logically Setosa's petal width are the smallest, with a width close to 0cm.
# The petal width is smaller than the petal length for all 3 different classes but they respect the same gap in both graph:
# Setosa's petal width are by far the smallest, close to 0cm, and Versicolor's and Virginica's petal width are bigger, respectively between 1cm/1.8cm and 1.4cm/2.5cm



#3)


# Let's use the ggplot2 library
# ggplot2 is the most advanced package for data visualization
# gg corresponds to The Grammar of Graphics.

library(ggplot2) 

# histogram of sepal_length
ggplot(iris, aes(x=iris_data$sepal_length, fill=iris_data$class)) +
  geom_histogram(binwidth=.2, alpha=.5)
# histogram of sepal_width
ggplot(iris, aes(x=iris_data$sepal_width, fill=iris_data$class)) +
  geom_histogram(binwidth=.2, alpha=.5)
# histogram of petal_length
ggplot(iris, aes(x=iris_data$petal_length, fill=iris_data$class)) +
  geom_histogram(binwidth=.2, alpha=.5)
# histogram of petal_width
ggplot(iris, aes(x=iris_data$petal_width, fill=iris_data$class)) +
  geom_histogram(binwidth=.2, alpha=.5)

# 4)

pcairis=princomp(iris[,-5], cor=T) 

# To display the internal structure of pcairis
str(pcairis)


# To see the variance explained by the the pcs
summary(pcairis) 

# To plot the variance explained by each pc
plot(pcairis) 
# So we see that COmp 1 (here, Sepal Length) explain 72% of the results, followed by Sepal Width

# To plot together the scores for PC1 and PC2 and the 
# variables expressed in terms of PC1 and PC2.
biplot(pcairis) 

# 5)

library("factoextra")

# Scree plot :
fviz_eig(pcairis, addlabels = TRUE, ylim = c(0, 50))

# Graph of individuals :

fviz_pca_ind(pcairis,col.ind = "contrib", # Color by their contribution to axes
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
             repel = TRUE     
)

# Graph of variables :

fviz_pca_var(pcairis, col.var = "contrib", 
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
             repel = TRUE     
)

#Dim 1 : 73%, Dim 2 : 22.9%


# Biplot :

fviz_pca_biplot(pcairis, repel = TRUE,
                col.var = "#2E9FDF", 
                col.ind = "#696969"  
)

# Contribution of variables in 2 principals componoents :

fviz_contrib(pcairis, choice = "var", axes = 1:2)

#In the scree plot, we can clearly see the "elbow" at dimension 3, so we can say that the 2 first dimensions are giving us already enough informations.
#Graph of individuals and the graph of variables shows us that all the variables are going in the same direction but one: we can explain that looking at the boxplot again.
#Indeed, Setosas have small characteristics sometimes close to 0 in all variable but not in Sepal Width, which is the one also popping out of our graph of variables here because he's giving us different informations compared to the others.




############################# Step By Step PCA ###########################################

#6)

X <- iris[,-5]
y <- iris[,5]

#7)

X_scaled = scale(X)
X_scaled

# To verify if we scaled right, the means have to be = 0 and ts SD to 1

colMeans(X_scaled)  
apply(X_scaled, 2, sd)

# 8)

cov_X = cov(X_scaled)
cov_X #Covariance matrix


#9)

ev = eigen(cov_X)
ev

# We see that the largest eigen value is 2.92, and it's the varicance of comp 1 (so Sepal Length)
# The elements for these eigenvectors will be the coefficients of the principal components.


#10)

cor_X_scaled = cor(X_scaled) #Correlation Matrix based on Standardized data
cor_X_scaled

ev_cor_scaled = eigen(cor_X_scaled)
ev_cor_scaled #Same results as the question 9

#11) 

cor_X = cor(X)
cor_X

ev_cor_X = eigen(cor_X)
ev_cor_X

# We have the same values for the 3 methods !

#12)

#Individual explained variation :

pc1_ind = ev$values[1] / sum(ev$values)
pc2_ind = ev$values[2] / sum(ev$values)
pc3_ind = ev$values[3] / sum(ev$values)
pc4_ind = ev$values[4] / sum(ev$values)

# Cumulative explained variation : 

pc1_cum = (ev$values[1]) / sum(ev$values)
pc2_cum = (ev$values[1] + ev$values[2]) / sum(ev$values)
pc3_cum = (ev$values[1] + ev$values[2] + ev$values[3]) / sum(ev$values)
pc4_cum = (ev$values[1] + ev$values[2] + ev$values[3]  + ev$values[4]) / sum(ev$values)

# There are the same that the one that we obtain with summary(pcairis)


# 13 ) 

ind_pc = c(pc1_ind,pc2_ind,pc3_ind,pc4_ind)
ind_pc

plot(ind_pc, type = 'b') #We creeated the scree plot manueal


# 14)

# Projection matrix is just our k eighten vectors. Here, we're gonna take the first 2.

A = cbind(ev$vectors[,1],ev$vectors[,2])
A

# 15)

Y = X_scaled %*% A
Y # Y is the scores matrix


# 16)

plot(Y, xlab = "PC1", ylab = "PC2")

# 17)

y
col = c(1:150)
col

for (i in 1:length(col)){
  if (y[i] ==  'setosa') col[i] = 'red'
  if (y[i] ==  'versicolor') col[i] = 'blue'
  if (y[i] ==  'virginica') col[i] = 'green'
}
col


plot(Y, xlab = "PC1", ylab = "PC2", col = col, pch = 19)

