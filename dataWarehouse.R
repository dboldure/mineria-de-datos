install.packages("RMySQL", type="source");
install.packages('dplyr');
install.packages("readr")
library(RMySQL);
library(dplyr);
conexion = dbConnect(MySQL(),host="localhost",dbname="datawarehouse",user="root");

# Instalar el paquete 

# Cargar el paquete
library("readr")

#ALCOHOL

# Leemos los csv que vamos a utilizar y los guardamos en las variables
porcentajeTrastornos <-read.csv("./Alcohol/porcentaje_trastornos_por_consumo_de_alcohol.csv",header=TRUE, numerals = c("no.loss"), 
                                check.names=TRUE);
tasaMuertesPrematuras <-read.csv("./Alcohol/tasa_de_muertes_prematuras_debido_al_alcohol.csv",header=TRUE, numerals = c("no.loss"), 
                                 check.names=TRUE);
tasaMuertesTrastornos <-read.csv("./Alcohol/tasas_de_mortalidad_por_trastornos_por_consumo_de_alcohol.csv",header=TRUE, numerals = c("no.loss"), 
                                 check.names=TRUE);

# Juntamos todas las columnas en una sola variable
alcohol = merge(tasaMuertesPrematuras,porcentajeTrastornos)
alcohol = merge(alcohol,tasaMuertesTrastornos)


# Renombramos las columnas
names (alcohol) = c("pais", "codigo", "anio", "tasaMuertesPrematuras", "porcentajeTrastornos", "tasaMuertesTrastornos")



# Escribimos en la base de datos
dbWriteTable(conn=conexion , name='alcohol', alcohol, append=TRUE, row.name=FALSE);

#OBESIDAD

#DATAWAREHOUSE OBESIDAD
#Volcado de archivos
sobrepeso <- read.csv("./Obesidad/Porcentaje de adultos con sobrepeso.csv", header=TRUE, numerals = c("no.loss"), 
                      check.names=TRUE);
obesidad <- read.csv("./Obesidad/Porcentaje de adultos definidos como obesos.csv", header=TRUE, numerals = c("no.loss"), 
                     check.names=TRUE);

obesidad <- merge(sobrepeso, obesidad);
names (obesidad) = c("pais",  "codigo", "anio", "porcentajeSobrepeso", "porcentajeObesos")

dbWriteTable(conn=conexion , name='obesidad', obesidad, append=TRUE, row.name=FALSE);

#DROGAS

#Extraemos los datos de los csv y los guardamos en unas variables para luego transformarlos
drogas1 <-read.csv("./Drogas/muertes trastornos de sustancias por años.csv",header=TRUE, check.names=TRUE);
drogas2 <-read.csv("./Drogas/share-with-alcohol-vs-drug-use-disorder.csv",header=TRUE, check.names=TRUE);


drogas<-merge(drogas1,drogas2,all=T)
names (drogas) = c("pais","codigo", "anio", "muerteTrastornoCocaina", "muerteTrasUsoDrogasIleg", "muerteTrastornoOpioides","muerteTrastornAlcohol", "muerteTrasOtrasDrogasIleg","muerteTrastornoAnfetaminas","proporcionConsumoAlcoholTras","proporcionConsumoDrogasIleg");


#Conexion con la bases de datos
dbWriteTable(conn = conexion ,name ='drogas' ,drogas, append =TRUE,row.names=FALSE);


#ALIMENTACION
#Extraemos los datos de los csv y los guardamos en unas variables para luego transformarlos
alimentacion1 <-read.csv("./Alimentacion/daily-caloric-supply-derived-from-carbohydrates-protein-and-fat.csv",header=TRUE, numerals = c("no.loss"), 
                         check.names=TRUE);
alimentacion2 <-read.csv("./Alimentacion/dietary-compositions-by-commodity-group.csv",header=TRUE, numerals = c("no.loss"), 
                         check.names=TRUE);
precio <-read.csv("./Alimentacion/precio-1850-2015.csv",header=TRUE, numerals = c("no.loss"), 
                  check.names=TRUE)

alimentacionMerge <-merge(alimentacion1,alimentacion2,all=TRUE)
alimentacionMerge <-merge(alimentacionMerge,precio ,all=TRUE)
names (alimentacionMerge) = c("pais","codigo" ,"anio", "proteinaAnimal","proteinaVegetal","grasa","carbohidratos","otras","azucar", "aceite", "carne", "huevosLactosa", "frutasVerduras","starchy","pulses","cereales","alcohol","preciotee","precioAzucar","preciocacahuete","precioaceitePalm","preciocafe","preciocacao","preciowheat","preciorie","precioarroz","preciomaiz","preciobarley","preciocerdo","precioternera","preciolamb");

dbWriteTable(conn = conexion ,name ='alimentacion' , alimentacionMerge , append =TRUE , row.names=FALSE);

#TABACO

tabaco1 <-read.csv("./Tabaco/porcentaje_de_mortalidad.csv",header=TRUE, numerals = c("no.loss"), 
                   check.names=TRUE);
tabaco2 <-read.csv("./Tabaco/Tasa_de_mortalidad_1990-2017.csv",header=TRUE, numerals = c("no.loss"), 
                   check.names=TRUE);
tabaco3 <-read.csv("./Tabaco/muertes_por_fumar_1990-2017.csv",header=TRUE, numerals = c("no.loss"), 
                   check.names=TRUE);


tabaco1 <- merge(tabaco1, tabaco2, all = TRUE);
tabaco1 <- merge(tabaco1, tabaco3, all = TRUE);

names (tabaco1) = c("pais","codigo","anio","porcentajeMuertes","tasaMuertesFumar","muertesCada100mil");

dbWriteTable(conn=conexion, name='tabaco',tabaco1, append=TRUE, row.name=FALSE);


#MUERTE

#DATAWAREHOUSE
#Lee los csv que se van a utilizar
muertesPorCausa <-read.csv("./Muertes/númeroanualdemuertesporcausa.csv",header=TRUE);
muertesPorFactorRiesgo <-read.csv("./Muertes/númerodemuertesporfactorderiesgo.csv",header=TRUE);

muerte <- merge(muertesPorCausa, muertesPorFactorRiesgo, by.x=c("Entity", "Year"), by.y=c("Entity", "Year"), all = TRUE);


names (muerte) = c(
  "pais","anio", "codigoX","ejecucion","muertesMeningitis","Infeccionesvíasrespiratoriasinferiores(muertes)",
  "Enfermedades infecciosas intestinales (muertes)", "desnutrición proteico-energética (muertes)", "terrorismo (muertes)",
  "Enfermedades cardiovasculares (muertes)", "Demencia (muertes)", "Enfermedad renal (muertes)", "muertesEnfermedadRespiratoria",
  "Enfermedades del hígado (muertes)", "Enfermedades digestivas (muertes)", "Hepatitis (muertes)", "Cánceres (muertes)", "Enfermedad de Parkinson (muertes)",
  "Fuego (muertes)", "malaria (muertes)", "ahogamiento (muertes)", "homicidio (muertes)", "VIH / SIDA (muertes)", "trastornos por consumo de drogas (muertes)",
  "Tuberculosis (muertes)", "Lesiones viales (muertes)", "Trastornos maternos (muertes)", "Trastornos neonatales (muertes)",
  "Trastornos por consumo de alcohol (muertes)", "desastres naturales (muertes)", "enfermedades diarreicas (muertes)", "calor (exposición al calor y al frío) (muertes)"
  , "Deficiencias nutricionales (muertes)", "Suicidio (muertes)", "Conflicto (muertes)", "Diabetes (muertes)", "Envenenamientos (muertes)", "codigoy"
  , "Fuente de agua insegura (muertes)", "Saneamiento deficiente (muertes)", "Sin acceso a instalaciones de lavado de manos (muertes)", 
  "Contaminación del aire interior (muertes)", "Lactancia no exclusiva (muertes)", "Lactancia discontinua (muertes)", 
  "Emaciación infantil (muertes)", "Niño retraso en el crecimiento (muertes)", "bajo peso al nacer (muertes)", 
  "muertesPorExposicionHumo", "muertesAlcohol", "muertesDrogas", "muertesDietaBajaFrutas", 
  "muertesDietaBajaVerduras", "sexo inseguro (muertes)", "Actividad física baja (muertes)", 
  "muertesAltoContenidoAzucar", "muertesAltoColesterol", "muertesObesidad", "muertesAltaPresionSanguinea", 
  "muertesTabaco", "Deficiencia de hierro (muertes)","Deficiencia de zinc (muertes)" , "Deficiencia de vitamina A (muertes)",
  "Baja densidad mineral ósea (muertes)", "Contaminación del aire (exterior e interior) (muertes)", "Contaminación del aire exterior (muertes)", 
  "Dieta baja en fibra (muertes)", "Dieta alta en sodio (muertes)" , "Dieta baja en legumbres (muertes)", "Dieta baja en calcio (muertes)",
  "Dieta alta en carnes rojas (muertes)", "Dieta baja en granos enteros (muertes)", "Dieta baja en nueces y semillas (muertes)", 
  "Dieta baja en omega de mariscos graso ácidos (muertes)"
)
dbWriteTable(conn=conexion , name='muerte', muerte, append=TRUE, row.name=FALSE);

#FIN