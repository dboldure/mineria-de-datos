CREATE DATABASE  IF NOT EXISTS `mineria`;
USE `mineria`;



DROP TABLE IF EXISTS `muertes`;
--
-- Table structure for table `alcohol`
--

DROP TABLE IF EXISTS `alcohol`;
CREATE TABLE `alcohol` (
  `idAlcohol` int(11) NOT NULL,
  `porcentajeTrastornos` double NOT NULL,
  `tasaMuertesPrematuras` double NOT NULL,
  `tasaMuertesTrastornos` double NOT NULL,
  PRIMARY KEY (`idAlcohol`)
);

--
-- Table structure for table `alimentacion`
--

DROP TABLE IF EXISTS `alimentacion`;
CREATE TABLE `alimentacion` (
  `idAlimentacion` int(11) NOT NULL,
  `azucar` double NOT NULL,
  `aceite` double NOT NULL,
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
  PRIMARY KEY (`idAlimentacion`)
);

--
-- Table structure for table `drogas`
--

DROP TABLE IF EXISTS `drogas`;
CREATE TABLE `drogas` (
  `idDrogas` int(11) NOT NULL,
  `muerteTrastornoCocaina` double NOT NULL,
  `muerteTrasUsoDrogasIleg` double NOT NULL,
  `muerteTrastornoOpioides` double NOT NULL,
  `muerteTrasOtrasDrogasIleg` double NOT NULL,
  `muerteTrastornoAnfetaminas` double NOT NULL,
  `proporcionConsumoDrogasIleg` double NOT NULL,
  PRIMARY KEY (`idDrogas`)
);

--
-- Table structure for table `obesidad`
--

DROP TABLE IF EXISTS `obesidad`;
CREATE TABLE `obesidad` (
  `idObesidad` int(11) NOT NULL,
  `porcentajeObesos` double NOT NULL,
  `porcentajeSobrepeso` double NOT NULL,
  `muertesAltoContenidoAzucar` double NOT NULL,
  `muertesAltoColesterol` double NOT NULL,
  `muertesAltaPresionSanguinea` double NOT NULL,
  PRIMARY KEY (`idObesidad`)
);

--
-- Table structure for table `tabaco`
--

DROP TABLE IF EXISTS `tabaco`;
CREATE TABLE `tabaco` (
  `idTabaco` int(11) NOT NULL,
  `porcentajeMuertes` double NOT NULL,
  `muertesCada100mil` double NOT NULL,
  `muertesPorExposicionHumo` double NOT NULL,
  `muertesEnfermedadRespiratoria` double NOT NULL,
  PRIMARY KEY (`idTabaco`)
);

--
-- Table structure for table `muertes`
--


CREATE TABLE `muertes` (
  `idAlcohol` int(11) DEFAULT NULL,
  `idDrogas` int(11) DEFAULT NULL,
  `idAlimentacion` int(11) DEFAULT NULL,
  `idTabaco` int(11) DEFAULT NULL,
  `idObesidad` int(11) DEFAULT NULL,
  `anio` int(11) NOT NULL,
  `pais` varchar(45) NOT NULL,
  `muertesDietaBajaFrutas` double DEFAULT NULL,
  `muertesDietaBajaVerduras` double DEFAULT NULL,
  `muertesTabaco` double DEFAULT NULL,
  `muertesAlcohol` double DEFAULT NULL,
  `muertesDrogas` double DEFAULT NULL,
  `muertesObesidad` double DEFAULT NULL,
  KEY `idAlcohol_idx` (`idAlcohol`),
  KEY `idTabaco_idx` (`idTabaco`),
  KEY `idDrogas_idx` (`idDrogas`),
  KEY `idAlimentacion_idx` (`idAlimentacion`),
  KEY `idObesidad_idx` (`idObesidad`),
  CONSTRAINT `idAlcohol` FOREIGN KEY (`idAlcohol`) REFERENCES `alcohol` (`idAlcohol`),
  CONSTRAINT `idAlimentacion` FOREIGN KEY (`idAlimentacion`) REFERENCES `alimentacion` (`idAlimentacion`),
  CONSTRAINT `idDrogas` FOREIGN KEY (`idDrogas`) REFERENCES `drogas` (`idDrogas`),
  CONSTRAINT `idObesidad` FOREIGN KEY (`idObesidad`) REFERENCES `obesidad` (`idObesidad`),
  CONSTRAINT `idTabaco` FOREIGN KEY (`idTabaco`) REFERENCES `tabaco` (`idTabaco`)
);