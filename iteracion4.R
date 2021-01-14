
install.packages('dplyr');
install.packages("rpart.plot") 

library(dplyr)
library(rpart)
library(rpart.plot)
library(RMySQL);

rm(list=ls())
#CONEXION A NUESTRO DATAMART
conexion2 = dbConnect(MySQL(),host="localhost",dbname="mineria",user="root",password="");

#EXTRAEMOS LOS DATOS DE NUESTRO DATAMART
obesidad <-dbGetQuery(conexion2, paste("select * from obesidad"))
alcohol <-dbGetQuery(conexion2, paste("select * from alcohol"))
tabaco <-dbGetQuery(conexion2, paste("select * from tabaco"))
drogas <- dbGetQuery(conexion2, paste("select * from drogas"))

muertes <- dbGetQuery(conexion2, paste("select * from muertes"))

#JUNTAMOS LOS DATAFRAMES OBESIDAD,MUERTES Y ALCOHOL EN UN SOLO DATAFRAME LLAMADO FINAL
final <- merge(obesidad, muertes, by.x="idObesidad",  by.y="idObesidad", all = F);
final <- merge(final, alcohol, by.x="idAlcohol",  by.y="idAlcohol", all = F);

#CATEGORIZAMOS LA VARIABLE OBJETIVO
final <- final %>% mutate(muertesObesidad = case_when(
  muertesObesidad >= 0 & muertesObesidad <= 20000 ~ 1,
  muertesObesidad > 20000 & muertesObesidad <= 40000 ~ 2,
  muertesObesidad > 40000 & muertesObesidad <= 60000 ~ 3,
  muertesObesidad > 60000 & muertesObesidad <= 100000 ~ 4,
  muertesObesidad > 100000 & muertesObesidad <= 500000 ~ 5,
  muertesObesidad > 500000  ~ 6
))

#CAMBIAMOS DE DATAFRAME A UNO NUEVO
ok <- final

#SEPARAMOS LOS DATOS DE ENTRENAMIENTO (0,7) Y PRUEBA (0,3)
set.seed(1234)
ind <- sample(2, nrow(ok), replace=TRUE, prob=c(0.7, 0.3))
ok.train <- ok[ind==1,]
ok.test <- ok[ind==2,]

#ESCOGEMOS LA FORMULA CON LA QUE TRABAJAR
myFormula <-muertesObesidad ~ tasaMuertesTrastornos + tasaMuertesPrematuras + muertesAltaPresionSanguinea 
#APLICAMOS LA FUNCION RPART A NUESTRA FORMULA
fit <- rpart(myFormula,data = ok.train)

#PINTAMOS EL RESULTADO
rpart.plot(fit,shadow.col = "gray")

#EVALUAMOS CALCULANDO LA PRECISIÓN
predict_unseen <-predict(fit, ok.test)
predict_unseen
table_mat <- table(ok.test$muertesObesidad, predict_unseen)
table_mat
accuracy_Test <- sum(diag(table_mat)) / sum(table_mat)
print(paste('Accuracy for test', accuracy_Test))

