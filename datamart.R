install.packages("RMySQL", type="source");
install.packages('dplyr');
install.packages("readr")
library(RMySQL);
library(dplyr);
conexion = dbConnect(MySQL(),host="localhost",dbname="datawarehouse",user="root", password=""); 
conexion2 = dbConnect(MySQL(),host="localhost",dbname="mineria",user="root", password="");


# Instalar el paquete 

# Cargar el paquete
library("readr")

#DROGAS

drogasBD <- dbGetQuery(conexion,paste("select * from drogas"))
#Transformamos los datos y los limpiamos : 
#-renombramos variables
drogasBD <- drogasBD %>%   filter(anio >=1990) %>% select(-codigo ,-pais,-anio,-muerteTrastornAlcohol,-proporcionConsumoAlcoholTras)
dbWriteTable(conn = conexion2 ,name ='drogas' , drogasBD , append =TRUE , row.names=FALSE);
#Escribimos los datos limpios en un csv
write.csv(drogasBD,file="drogas.csv");


#ALIMENTACION

alimentacionBD <- dbGetQuery(conexion,paste("select * from alimentacion"))
alimentacionBD <- alimentacionBD %>% select(-codigo,-pais,-anio,-otras,-starchy,-pulses,-preciotee,-precioAzucar,-preciocacahuete,-precioaceitePalm,-preciocafe,-preciocacao,-preciowheat,-preciorie,-precioarroz,-preciomaiz,-preciobarley,-preciocerdo,-precioternera,-preciolamb)
dbWriteTable(conn = conexion2 ,name ='alimentacion' , alimentacionBD , append =TRUE , row.names=FALSE);
#Escribimos los datos limpios en un csv
write.csv(alimentacionBD,file="alimentacion.csv");

#OBESIDAD

tablaMuertes <- dbGetQuery(conexion, paste("select pais, anio, muertesAltaPresionSanguinea, muertesAltoContenidoAzucar, 
                                           muertesAltoColesterol from muerte"))
obesidad <- dbGetQuery(conexion, paste("select * from obesidad"))

obesidad <- merge(obesidad, tablaMuertes,all = TRUE);
names (obesidad)[1] = c("pais")


write.csv(obesidad, file="Obesidad.csv");
obesidadResult <-obesidad %>% select(-pais, -anio, -codigo);
dbWriteTable(conn=conexion2 , name='obesidad', obesidadResult, append=TRUE, row.name=FALSE);

#ALCOHOL
# Sacamos de la base de datos
alcohol <- dbGetQuery(conexion, paste("select * from alcohol"));
# Nos quedamos las columnas que nos interesan
datamart <- alcohol[,c(1,5,6,7)];
# Guardamos en la base de datos final
dbWriteTable(conn=conexion2 , name='alcohol', datamart, append=TRUE, row.name=FALSE);

#TABACO

tabaco <- dbGetQuery(conexion, paste("select * from tabaco"));
tablaMuertesTabaco <- dbGetQuery(conexion, paste("select pais, anio, muertesPorExposicionHumo,
  muertesEnfermedadRespiratoria from muerte"))
names (tablaMuertesTabaco)[1] = c("pais")
tabacoFinal <- merge(tabaco, tablaMuertesTabaco, all=T);



tabacoFinal <-tabacoFinal %>% select(-pais, -anio, -codigo,-tasaMuertesFumar);
dbWriteTable(conn=conexion2 , name='tabaco', tabacoFinal, append=TRUE, row.name=FALSE);


#MUERTE

muerteDatamart <- dbGetQuery(conexion, paste("select pais, anio, muertesAlcohol, muertesDrogas, 
                                             muertesObesidad, muertesTabaco, muertesDietaBajaFrutas ,
                                             muertesDietaBajaVerduras from muerte"))
#IDS
idTabaco <- dbGetQuery(conexion, paste("select pais, anio, idTabaco from tabaco"))
idAlcohol <- dbGetQuery(conexion, paste("select pais, anio, idAlcohol from alcohol"))
idDrogas <- dbGetQuery(conexion, paste("select pais, anio, idDrogas from drogas"))
idObesidad <- dbGetQuery(conexion, paste("select pais, anio, idObesidad from obesidad"))
idAlimentacion <- dbGetQuery(conexion, paste("select pais, anio, idAlimentacion from alimentacion"))

names (idObesidad)[1] = c("pais")
names (muerteDatamart)[1] = c("pais")

muerteFinal <- merge(idTabaco, muerteDatamart, by.x=c("pais", "anio"), by.y=c("pais", "anio"), all = TRUE);
muerteFinal <- merge(idAlcohol, muerteFinal, by.x=c("pais", "anio"), by.y=c("pais", "anio"), all = TRUE);
muerteFinal <- merge(idDrogas, muerteFinal, by.x=c("pais", "anio"), by.y=c("pais", "anio"), all = TRUE);
muerteFinal <- merge(idObesidad, muerteFinal, by.x=c("pais", "anio"), by.y=c("pais", "anio"), all = TRUE);
muerteFinal <- merge(idAlimentacion, muerteFinal, by.x=c("pais", "anio"), by.y=c("pais", "anio"), all = TRUE);




dbWriteTable(conn=conexion2 , name='muertes', muerteFinal, append=TRUE, row.name=FALSE);

