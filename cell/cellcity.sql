-- MySQL dump 10.14  Distrib 5.5.38-MariaDB, for Linux (x86_64)
--
-- Host: localhost    Database: cellcity
-- ------------------------------------------------------
-- Server version	5.5.38-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `cliente`
--

DROP TABLE IF EXISTS `cliente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cliente` (
  `id` int(3) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) DEFAULT NULL,
  `email` varchar(30) DEFAULT NULL,
  `celular` bigint(20) DEFAULT NULL,
  `telefono` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cliente`
--

LOCK TABLES `cliente` WRITE;
/*!40000 ALTER TABLE `cliente` DISABLE KEYS */;
INSERT INTO `cliente` VALUES (1,'rob','rcarreon.gn@gmail.com',6621716734,6623011024),(2,'nuevo ','nuevo@gmail.com',6621232425,6622202122);
/*!40000 ALTER TABLE `cliente` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dispos`
--

DROP TABLE IF EXISTS `dispos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dispos` (
  `folio` int(11) NOT NULL AUTO_INCREMENT,
  `modelo` varchar(20) DEFAULT NULL,
  `imei` varchar(30) DEFAULT NULL,
  `cliente` varchar(40) DEFAULT NULL,
  `status` varchar(20) DEFAULT NULL,
  `reparacion` varchar(100) DEFAULT NULL,
  `detalles` varchar(120) DEFAULT NULL,
  `password` varchar(40) DEFAULT NULL,
  `fecha` varchar(12) DEFAULT NULL,
  `email` varchar(25) DEFAULT NULL,
  `contacto` int(25) DEFAULT NULL,
  PRIMARY KEY (`folio`)
) ENGINE=InnoDB AUTO_INCREMENT=5032 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dispos`
--

LOCK TABLES `dispos` WRITE;
/*!40000 ALTER TABLE `dispos` DISABLE KEYS */;
INSERT INTO `dispos` VALUES (5000,'dfgdfg','2345345','rob','En reparacion','',' sdfsd','dfsdf','2014-08-19','undefined',0),(5001,'fsfs','23423','rob','listo','touch,ccarga,bateria,servicio','detalles aqui y aya','sdfsdf','2014-08-19','rcarreon.gn@gmail.com',2147483647),(5002,'asdasd','asdasd','rob','En reparacion','',' asdas','asdad','2014-08-19','undefined',0),(5003,'sdfs','dfsdfs','rob','En reparacion','',' sfdfs','sdfsd','2014-08-19','undefined',0),(5004,'wrewer','23423','rob','En reparacion','','  vamos a acabarnos los caracteres de los 115 , hasta aqui todavia no se acaba pero estamos cerca de llegar al limi','','2014-08-19','undefined',0),(5005,'asda','asdas','rob','En reparacion','',' asda','asda','2014-08-19','undefined',0),(5006,'asdasd','asdad','rob','En reparacion','',' asdasd','asdasd','2014-08-19','undefined',0),(5007,'ad','asdas','rob','En reparacion','',' asd','asd','2014-08-19','undefined',0),(5008,'asda','asda','rob','En reparacion','',' asd','asd','2014-08-19','undefined',0),(5009,'moto','283427','rob','listo','bocina,bateria,servicio','detalles aqui y aya','la contrasena es lo de mas','2014-08-19','rcarreon.gn@gmail.com',2147483647),(5010,'','','rob','undefined','','','','2014-08-19','undefined',0),(5011,'','','rob','undefined','','','','2014-08-19','undefined',0),(5012,'','','rob','undefined','','','','2014-08-19','undefined',0),(5013,'','','rob','undefined','','','','2014-08-19','undefined',0),(5014,'','','rob','undefined','','','','2014-08-19','undefined',0),(5015,'','','rob','undefined','','','','2014-08-19','undefined',0),(5016,'','asd','rob','undefined','','','','2014-08-19','undefined',0),(5017,'','','rob','undefined','','','','2014-08-19','undefined',0),(5018,'HTC','9998867','rob','En reparacion','',' Pantalla estrellada en una peda','YOLO','2014-08-19','undefined',0),(5019,'','','rob','undefined','','','','2014-08-19','undefined',0),(5020,'','','rob','undefined','','','','2014-08-19','undefined',0),(5021,'','','rob','undefined','','','','2014-08-19','undefined',0),(5022,'','','rob','undefined','','','','2014-08-19','undefined',0),(5023,'motorola','232','rob','listo','ccarga,bocina,mic,camara','El detalle es que   no sirve nada nada','asda','2014-08-20','rcarreon.gn@gmail.com',2147483647),(5024,'moto','iiiuuu','rob','En reparacion','','asdasd','asdas','2014-08-20','undefined',0),(5025,'iphone','888777','nuevo ','Garantia','','no sirven los botones de volumen','yoyo!','2014-08-21','undefined',0),(5026,'iwerwi','9283742`','rob','undefined','','dllelelle','kajhfa','2014-08-23','undefined',0),(5027,'rwerw','23423','rob','En reparacion','','werwe','werwe','2014-08-25','undefined',0),(5028,'HTC','44555484877','nuevo ','listo','bocina,bateria,camara,servicio','la pantalla  no se ve , el telefono prende pero la pantalla no se ve','4548487','2014-08-25','nuevo@gmail.com',2147483647),(5029,'motorola','55454584454','nuevo ','En reparacion','','detallado','yoo yoo ','2014-08-25','undefined',0),(5030,'werwerwe','23423423','nuevo ','En reparacion','','werwerwe','werwe','2014-08-25','undefined',0),(5031,'el que sea','16546488877','rob','En reparacion','','no sirve','no hay ','2014-08-25','undefined',0);
/*!40000 ALTER TABLE `dispos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuarios`
--

DROP TABLE IF EXISTS `usuarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `usuarios` (
  `idu` int(3) NOT NULL AUTO_INCREMENT,
  `usuario` varchar(20) DEFAULT NULL,
  `passwd` varchar(20) DEFAULT NULL,
  `nombre` varchar(30) DEFAULT NULL,
  `tipo` int(3) DEFAULT NULL,
  PRIMARY KEY (`idu`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuarios`
--

LOCK TABLES `usuarios` WRITE;
/*!40000 ALTER TABLE `usuarios` DISABLE KEYS */;
INSERT INTO `usuarios` VALUES (1,'rob','admino','roberto carreon',1),(2,'invitado','guest','invitado',2),(3,'uno','pass','uno',1),(4,'admin','admino','admin',1);
/*!40000 ALTER TABLE `usuarios` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2014-08-25 17:04:04
