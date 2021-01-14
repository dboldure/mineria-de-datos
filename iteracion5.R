install.packages('dplyr');
install.packages("rpart.plot") 
library(RMySQL);
library(dplyr)
library(rpart)
library(rpart.plot)
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

#Hemos eliminado todas las entradas del año 2016 
final1 <- final %>% filter(anio<2016)
#Hemos incrementado el valor del año en 1 para que así los valores que guarda cada fila en función de su año, corresponden a los valores del año anterior
final1$anio <- final1$anio +1
names(final1) <-c("idAlcoholN","idObesidadN","porcentajeObesosN","porcentajeSobrepesoN","muertesAltoContendidoAzucarN","muertesAltoColesterolN","muertesAltaPresionSanguineaN","idDrogasN","idAlimentacionN","idTabacoN","anio","pais","muertesDietaBajaFrutasN","muertesDietsaBajaVerdurasN","muertesTabacoN","muertesAlcoholN","muertesDrogasN","muertesObesidadN","porcentajeTrastornosN","tasaMuertesPrematurasN","tasaMuertesTrastornosN")

ok <- merge(final,final1,all = F)

#FORMULA
modelo1<- lm(ok$muertesObesidad ~ ok$porcentajeObesosN+ok$porcentajeSobrepesoN+ok$porcentajeTrastornosN+ok$muertesObesidadN, data=ok)
summary(modelo1)

#GRAFICA
muertesObesidad2016 = 5.9*-2.526e+00 + 32.9*-1.426e+01 + 	1.2321900*-3.358e+02 + 783343.89467*1.039e+00 + 9.575e+02 + 1952 # Muchas variables
layout(matrix(c(1,2,3,4),2,2)) # 4 gráficos por ventana
plot(modelo1)
style <- c(rep(1,12), rep(2,4))
plot(c(ok$muertesObesidad, muertesObesidad2016), xaxt="n", ylab="muertesObesidad", xlab="", pch=style, col=style)


#EVALUACION
#A priori

ok <- ok %>% filter(anio>1990)
set.seed(1234)
ind <- sample(2, nrow(ok), replace=TRUE, prob=c(0.75, 0.25))
entrenamiento <- ok[ind==1,]
test <- ok[ind==2,]
lm_1 <- lm(muertesObesidad ~ porcentajeObesosN+porcentajeSobrepesoN+porcentajeTrastornosN+muertesObesidadN,data=entrenamiento) 
ECMaPriori <- sum((residuals(lm_1)^2))/length(residuals(lm_1)); 
ECMaPriori
EMAaPriori <- sqrt(ECMaPriori); 
EMAaPriori
EMRaPriori <- EMAaPriori / mean(test$muertesObesidad); 
EMRaPriori

#A posteriori

data<- test %>% select(porcentajeObesosN,porcentajeSobrepesoN ,porcentajeTrastornosN ,muertesObesidadN) 
predict1 <- predict(lm_1, newdata=data.frame(porcentajeObesosN =test[,"porcentajeObesosN"],porcentajeSobrepesoN =test[,"porcentajeSobrepesoN"],porcentajeTrastornosN= test[,"porcentajeTrastornosN"],muertesObesidadN=test[,"muertesObesidadN"]))
residuosAPosteriori <- test$muertesObesidad -  as.integer(predict1)
residuosAPosteriori
ECMaPosteriori <-sum(residuosAPosteriori^2)/length(residuosAPosteriori)
ECMaPosteriori
EMAaPosteriori <- sqrt(ECMaPosteriori);
EMAaPosteriori
EMRaPosteriori <- EMAaPosteriori / mean(test$muertesObesidad); 
EMRaPosteriori



