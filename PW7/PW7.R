# You can import directly from my website (instead of downloading it..)
ligue1 <- read.csv("http://mghassany.com/MLcourse/datasets/ligue1_17_18.csv", row.names=1, sep=";")
#knitr::kable(ligue1[1:2])
pointsCards=ligue1[c('Points', 'yellow.cards')]
pointsCards
#::kable(pointsCards[1:2,])
km=kmeans