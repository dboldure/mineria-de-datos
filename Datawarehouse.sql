CREATE DATABASE  IF NOT EXISTS `datawarehouse`;
USE `datawarehouse`;

--
-- Table structure for table `alcohol`
--
#DATAWAREHOUSE
DROP TABLE IF EXISTS `obesidad`;
CREATE TABLE `obesidad` (
  `idObesidad` int(11) NOT NULL AUTO_INCREMENT,
  `pais`varchar(50) NOT NULL,
  `codigo` varchar(50) NOT NULL,
  `anio` int NOT NULL,
  `porcentajeSobrepeso` double NOT NULL,
  `porcentajeObesos` double NOT NULL,
    PRIMARY KEY (`idObesidad`)
);

DROP TABLE IF EXISTS `muerte`;
CREATE TABLE `muerte` (
  `idMuerte` int(11) NOT NULL AUTO_INCREMENT,
  `pais`varchar(50) NOT NULL,
  `anio` int NOT NULL,
  `codigoX` varchar(50) NOT NULL,
  `ejecucion` double NOT NULL,
  `muertesMeningitis` double NOT NULL,
  `Infeccionesvíasrespiratoriasinferiores(muertes)` double NOT NULL,
  `Enfermedades infecciosas intestinales (muertes)` double NOT NULL,
  `desnutrición proteico-energética (muertes)` double NOT NULL,
  `terrorismo (muertes)` double NOT NULL,
  `Enfermedades cardiovasculares (muertes)` double NOT NULL,
  `Demencia (muertes)` double NOT NULL,
  `Enfermedad renal (muertes)` double NOT NULL,
  `muertesEnfermedadRespiratoria` double NOT NULL,
  `Enfermedades del hígado (muertes)` double NOT NULL,
  `Enfermedades digestivas (muertes)` double NOT NULL,
  `Hepatitis (muertes)` double NOT NULL,
  `Cánceres (muertes)` double NOT NULL,
  `Enfermedad de Parkinson (muertes)` double NOT NULL,
  `Fuego (muertes)` double NOT NULL,
  `malaria (muertes)` double NOT NULL,
  `ahogamiento (muertes)` double NOT NULL,
  `homicidio (muertes)` double NOT NULL,
  `VIH / SIDA (muertes)` double NOT NULL,
  `trastornos por consumo de drogas (muertes)` double NOT NULL,
  `Tuberculosis (muertes)` double NOT NULL,
  `Lesiones viales (muertes)` double NOT NULL,
  `Trastornos maternos (muertes)` double NOT NULL,
  `Trastornos neonatales (muertes)` double NOT NULL,
  `Trastornos por consumo de alcohol (muertes)` double NOT NULL,
  `desastres naturales (muertes)` double NOT NULL,
  `enfermedades diarreicas (muertes)` double NOT NULL,
  `calor (exposición al calor y al frío) (muertes)` double NOT NULL,
  `Deficiencias nutricionales (muertes)` double NOT NULL,
  `Suicidio (muertes)` double NOT NULL,
  `Conflicto (muertes)` double NOT NULL,
  `Diabetes (muertes)` double NOT NULL,
  `Envenenamientos (muertes)` double NOT NULL,
  `codigoy` double NOT NULL,
  `Fuente de agua insegura (muertes)` double NOT NULL,
  `Saneamiento deficiente (muertes)` double NOT NULL,
  `Sin acceso a instalaciones de lavado de manos (muertes)` double NOT NULL,
  `Contaminación del aire interior (muertes)` double NOT NULL,
  `Lactancia no exclusiva (muertes)` double NOT NULL,
  `Lactancia discontinua (muertes)` double NOT NULL,
  `Emaciación infantil (muertes)` double NOT NULL,
  `Niño retraso en el crecimiento (muertes)` double NOT NULL,
  `bajo peso al nacer (muertes)` double NOT NULL,
   `muertesPorExposicionHumo` double NOT NULL,
  `muertesAlcohol` double NOT NULL,
  `muertesDrogas` double NOT NULL,
  `muertesDietaBajaFrutas` double NOT NULL,
  `muertesDietaBajaVerduras` double NOT NULL,
  `sexo inseguro (muertes)` double NOT NULL,
   `Actividad física baja (muertes)` double NOT NULL,
   `muertesAltoContenidoAzucar` double NOT NULL,
   `muertesAltoColesterol` double NOT NULL,
   `muertesObesidad` double NOT NULL,
   `muertesAltaPresionSanguinea` double NOT NULL,
   `muertesTabaco` double NOT NULL,
   `Deficiencia de hierro (muertes)` double NOT NULL,
   `Deficiencia de zinc (muertes)` double NOT NULL,
   `Deficiencia de vitamina A (muertes)` double NOT NULL,
   `Baja densidad mineral ósea (muertes)` double NOT NULL,
   `Contaminación del aire (exterior e interior) (muertes)` double NOT NULL,
   `Contaminación del aire exterior (muertes)` double NOT NULL,
   `Dieta baja en fibra (muertes)` double NOT NULL,
   `Dieta alta en sodio (muertes)` double NOT NULL,
   `Dieta baja en legumbres (muertes)` double NOT NULL,
   `Dieta baja en calcio (muertes)` double NOT NULL,
   `Dieta alta en carnes rojas (muertes)` double NOT NULL,
   `Dieta baja en granos enteros (muertes)` double NOT NULL,
	`Dieta baja en nueces y semillas (muertes)` double NOT NULL,
	`Dieta baja en omega de mariscos graso ácidos (muertes)` double NOT NULL,
      PRIMARY KEY (`idMuerte`)

);

DROP TABLE IF EXISTS `alcohol`;
CREATE TABLE `alcohol` (
  `idAlcohol` int(11) NOT NULL AUTO_INCREMENT,
  `pais` varchar(45) NOT NULL,
  `codigo` varchar(45) NOT NULL,
  `anio` int(11) NOT NULL,
  `porcentajeTrastornos` double NOT NULL,
  `tasaMuertesPrematuras` double NOT NULL,
  `tasaMuertesTrastornos` double NOT NULL,
  PRIMARY KEY (`idAlcohol`)
);


DROP TABLE IF EXISTS alimentacion;
CREATE TABLE alimentacion (
  `idAlimentacion` int(11) NOT NULL AUTO_INCREMENT,
  `codigo` varchar(45) NOT NULL,
  `pais` varchar(45) NOT NULL,
  `anio` int(11) NOT NULL,  
  `azucar` double NOT NULL,
  `otras` double NOT NULL,
  `aceite` double NOT NULL,
  `starchy` double NOT NULL,
  `pulses` double NOT NULL,
  `preciotee` double NOT NULL,
  `preciocacahuete` double NOT NULL,
  `precioaceitePalm` double NOT NULL,
  `preciocafe` double NOT NULL,
  `preciocacao` double NOT NULL,
  `preciowheat` double NOT NULL,
  `preciorie` double NOT NULL,
  `precioarroz` double NOT NULL,
  `preciomaiz` double NOT NULL,
  `preciobarley` double NOT NULL,
  `preciocerdo` double NOT NULL,
  `precioternera` double NOT NULL,
  `preciolamb` double NOT NULL,
  `carne` double NOT NULL,
  `huevosLactosa` double NOT NULL,
  `frutasVerduras` double NOT NULL,
  `cereales` double NOT NULL,
  `alcohol` double NOT NULL,
  `proteinaAnimal` double NOT NULL,
  `proteinaVegetal` double NOT NULL,
  `grasa` double NOT NULL,
  `carbohidratos` double NOT NULL,
  `precioAzucar` double NOT NULL,
  PRIMARY KEY (idAlimentacion)
);

DROP TABLE IF EXISTS drogas;
CREATE TABLE drogas (
  `idDrogas` int(11) NOT NULL AUTO_INCREMENT,
  `codigo` varchar(45) NOT NULL,
  `pais` varchar(45) NOT NULL,
  `anio` int(11) NOT NULL,  
  `muerteTrastornoCocaina` double NOT NULL,
  `muerteTrasUsoDrogasIleg` double NOT NULL,
  `muerteTrastornoOpioides` double NOT NULL,
  `muerteTrasOtrasDrogasIleg` double NOT NULL,
  `muerteTrastornoAnfetaminas` double NOT NULL,
  `muerteTrastornAlcohol` double NOT NULL,
  `proporcionConsumoDrogasIleg` double NOT NULL,
  `proporcionConsumoAlcoholTras` double NOT NULL,
  PRIMARY KEY (idDrogas)
);

DROP TABLE IF EXISTS tabaco;
CREATE TABLE tabaco (
  idTabaco int(11) NOT NULL AUTO_INCREMENT,
  `codigo` varchar(45) NOT NULL,
  `pais` varchar(45) NOT NULL,
  `anio` int(11) NOT NULL, 
  `porcentajeMuertes` double NOT NULL,
  `tasaMuertesFumar` double NOT NULL,
  `muertesCada100mil` double NOT NULL,
  PRIMARY KEY (idTabaco)
);
