library(RMySQL)
library(party)

conexion = dbConnect(MySQL(),host="localhost",dbname="datawarehouse",user="root",password=""); 
conexion2 = dbConnect(MySQL(),host="localhost",dbname="mineria",user="root",password="");


obesidad <-dbGetQuery(conexion2, paste("select * from obesidad"))
alcohol <-dbGetQuery(conexion2, paste("select * from alcohol"))
tabaco <-dbGetQuery(conexion2, paste("select * from tabaco"))
drogas <- dbGetQuery(conexion2, paste("select * from drogas"))

muertes <- dbGetQuery(conexion2, paste("select * from muertes"))

final <- merge(obesidad, muertes);
final <- merge(final, alcohol);


final <- final %>% mutate(muertesObesidad = case_when(
  muertesObesidad >= 0 & muertesObesidad <= 20000 ~ 1,
  muertesObesidad > 20000 & muertesObesidad <= 40000 ~ 2,
  muertesObesidad > 40000 & muertesObesidad <= 60000 ~ 3,
  muertesObesidad > 60000 & muertesObesidad <= 100000 ~ 4,
  muertesObesidad > 100000 & muertesObesidad <= 500000 ~ 5,
  muertesObesidad > 500000  ~ 6
))


set.seed(1235)
ind <- sample(2, nrow(final), replace=TRUE, prob=c(0.7, 0.3))
head(ind, 10)
# [1] 1 1 1 1 2 1 1 1 1 1
trainData <- final[ind==1,] ; dim(trainData)
# [1] 3457   20
testData <- final[ind==2,] ; dim(testData)
# [1] 1511   20

myFormula <-   muertesObesidad ~ porcentajeTrastornos 

iris_ctree <- ctree(myFormula, data=trainData)
#print(iris_ctree)
predict_unseen <-predict(iris_ctree, testData)
#predict_unseen
table_mat <- table(testData$muertesObesidad, predict_unseen)
table_mat
accuracy_Test <- (sum(diag(table_mat)) / sum(table_mat))
print(paste('Accuracy for test', accuracy_Test))
plot(iris_ctree, type = "simple")