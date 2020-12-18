challenger = read.delim("challenger.txt")
require(car)
scatterplot(nfails.field ~ temp, reg.line = lm, smooth = FALSE, spread = FALSE,
            boxplots = FALSE, data = challenger, subset = nfails.field > 0)
scatterplot(nfails.field ~ temp, reg.line = lm, smooth = FALSE, spread = FALSE,
            boxplots = FALSE, data = challenger)
mod <- lm(nfails.field ~ temp, data = challenger)
par(mfrow = 1:2)
plot(mod, 1)
plot(mod, 2)

nasa <- glm(fail.field ~ temp, family = "binomial", data = challenger)
summary(nasa)

predict(nasa, newdata = data.frame(temp = -0.6), type = "response")
