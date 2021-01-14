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
final <- merge(obesidad, muertes, by.x="idObesidad",  by.y="idObesidad", all = T);
final <- merge(final, alcohol, by.x="idAlcohol",  by.y="idAlcohol", all = T);

#N-1
#Hemos eliminado todas las entradas del año 2016
final1 <- final %>% filter(anio<2016)
#Hemos incrementado el valor del año en 1 para que así los valores que guarda cada fila en función de su año, corresponden a los valores del año anterior
final1$anio <- final1$anio +1
#Hemos renombrado todos los atributos para saber qué son los del año anterior
names(final1) <-c("idAlcoholN","idObesidadN","porcentajeObesosN","porcentajeSobrepesoN","muertesAltoContendidoAzucarN","muertesAltoColesterolN","muertesAltaPresionSanguineaN","idDrogasN","idAlimentacionN","idTabacoN","anio","pais","muertesDietaBajaFrutasN","muertesDietsaBajaVerdurasN","muertesTabacoN","muertesAlcoholN","muertesDrogasN","muertesObesidadN","porcentajeTrastornosN","tasaMuertesPrematurasN","tasaMuertesTrastornosN")

#JUNTAMOS EN UN UNICO DATAFRAME
ok <- merge(final,final1,all = F)

#N-2
#Hemos eliminado todas las entradas del año 2016
final2 <- final %>% filter(anio<2016)
#Hemos incrementado el valor del año en 2 para que así los valores que guarda cada fila en función de su año, corresponden a los valores de dos año anteriores
final2$anio <- final2$anio +2
#Hemos renombrado todos los atributos para saber qué son los del año anterior
names(final2) <-c("idAlcoholN2","idObesidadN2","porcentajeObesosN2","porcentajeSobrepesoN2","muertesAltoContendidoAzucarN2","muertesAltoColesterolN2","muertesAltaPresionSanguineaN2","idDrogasN2","idAlimentacionN2","idTabacoN2","anio","pais","muertesDietaBajaFrutasN2","muertesDietsaBajaVerdurasN2","muertesTabacoN2","muertesAlcoholN2","muertesDrogasN2","muertesObesidadN2","porcentajeTrastornosN2","tasaMuertesPrematurasN2","tasaMuertesTrastornosN2")

#JUNTAMOS EN UN UNICO DATAFRAME
ok <- merge(ok,final2,all = F)
  
#SELECCIONAMOS LAS VARIABLES QUE USAREMOS
ok <- ok %>% select(muertesObesidad, muertesObesidadN, porcentajeTrastornosN, muertesObesidadN2, porcentajeTrastornosN2)

#DE CADA UNA DE LAS VARIABLES QUITAREMOS LOS NA
ok <- ok%>% filter( !is.na(muertesObesidad))
ok <- ok%>% filter( !is.na(muertesObesidadN))
ok <- ok%>% filter( !is.na(muertesObesidadN2))
ok <- ok%>% filter( !is.na(porcentajeTrastornosN))
ok <- ok%>% filter( !is.na(porcentajeTrastornosN2))

#CALCULAMOS EL MODELO
modelo1<- lm(ok$muertesObesidad ~ ok$porcentajeTrastornosN+ok$muertesObesidadN + ok$muertesObesidadN2 + ok$porcentajeTrastornosN2, data=ok)
summary(modelo1)


#GRAFICA
muertesObesidad2016 = 1.1516501*-4.024e+02 + 783343.89467*1.039e+00 + 3.919e+02 + 3378


layout(matrix(c(1,2,3,4),2,2)) # 4 gráficos por ventana
plot(modelo1)
style <- c(rep(1,12), rep(2,4))
plot(c(ok$muertesObesidad, muertesObesidad2016), xaxt="n", ylab="muertesObesidad", xlab="", pch=style, col=style)
axis(1, at=1:4968, las=3,labels=c(paste(ok$anio)))


#EVALUACION
#A priori
ok <- ok %>% filter(anio>1990)
set.seed(1234)
ind <- sample(2, nrow(ok), replace=TRUE, prob=c(0.75, 0.25))
entrenamiento <- ok[ind==1,]
test <- ok[ind==2,]
lm_1 <- lm(muertesObesidad ~ porcentajeTrastornosN+muertesObesidadN + porcentajeTrastornosN2+muertesObesidadN2, data=entrenamiento) 
ECMaPriori <- sum((residuals(lm_1)^2))/length(residuals(lm_1)); 
ECMaPriori
EMAaPriori <- sqrt(ECMaPriori); 
EMAaPriori
EMRaPriori <- EMAaPriori / mean(test$muertesObesidad); 
EMRaPriori

layout(matrix(c(1,2,3,4),2,2)) # 4 gráficos por ventana
plot(lm_1)
#A posteriori

data<- test %>% select(porcentajeTrastornosN ,muertesObesidadN, porcentajeTrastornosN2 ,muertesObesidadN2) 
predict1 <- predict(lm_1, newdata=data.frame(porcentajeTrastornosN= test[,"porcentajeTrastornosN"],muertesObesidadN=test[,"muertesObesidadN"], porcentajeTrastornosN2= test[,"porcentajeTrastornosN2"],muertesObesidadN2=test[,"muertesObesidadN2"]))
residuosAPosteriori <- test$muertesObesidad -  as.integer(predict1)
residuosAPosteriori
ECMaPosteriori <-sum(residuosAPosteriori^2)/length(residuosAPosteriori)
ECMaPosteriori
EMAaPosteriori <- sqrt(ECMaPosteriori);
EMAaPosteriori
EMRaPosteriori <- EMAaPosteriori / mean(test$muertesObesidad); 
EMRaPosteriori


style <- c(rep(1,12), rep(2,4))
plot(c(predict1, EMRaPosteriori), pch=style, col=style)


