-- MySQL dump 10.13  Distrib 9.0.1, for macos14 (arm64)
--
-- Host: 127.0.0.1    Database: cf_user
-- ------------------------------------------------------
-- Server version	9.0.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `employees`
--

DROP TABLE IF EXISTS `employees`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employees` (
  `employee_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE ascii_bin DEFAULT NULL,
  `position` varchar(100) COLLATE ascii_bin DEFAULT NULL,
  `salary` decimal(10,2) DEFAULT NULL,
  `office` varchar(100) COLLATE ascii_bin DEFAULT NULL,
  `extn` int DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  PRIMARY KEY (`employee_id`),
  UNIQUE KEY `id_UNIQUE` (`employee_id`)
) ENGINE=InnoDB AUTO_INCREMENT=58 DEFAULT CHARSET=ascii COLLATE=ascii_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employees`
--

/*!40000 ALTER TABLE `employees` DISABLE KEYS */;
INSERT INTO `employees` VALUES (1,'Tiger Nixon','System Architect',320800.00,'Edinburgh',5421,'2011-04-25'),(2,'Garrett Winters','Accountant',170750.00,'Tokyo',8422,'2011-07-25'),(3,'Ashton Cox','Junior Technical Author',86000.00,'San Francisco',1562,'2009-01-12'),(4,'Cedric Kelly','Senior Javascript Developer',433060.00,'Edinburgh',6224,'2012-03-29'),(5,'Airi Satou','Accountant',162700.00,'Tokyo',5407,'2008-11-28'),(6,'Brielle Williamson','Integration Specialist',372000.00,'New York',4804,'2012-12-02'),(7,'Herrod Chandler','Sales Assistant',137500.00,'San Francisco',9608,'2012-08-06'),(8,'Rhona Davidson','Integration Specialist',327900.00,'Tokyo',6200,'2010-10-14'),(9,'Colleen Hurst','Javascript Developer',205500.00,'San Francisco',2360,'2009-09-15'),(10,'Sonya Frost','Software Engineer',103600.00,'Edinburgh',1667,'2008-12-13'),(11,'Jena Gaines','Office Manager',90560.00,'London',3814,'2008-12-19'),(12,'Quinn Flynn','Support Lead',342000.00,'Edinburgh',9497,'2013-03-03'),(13,'Charde Marshall','Regional Director',470600.00,'San Francisco',6741,'2008-10-16'),(14,'Haley Kennedy','Senior Marketing Designer',313500.00,'London',3597,'2012-12-18'),(15,'Tatyana Fitzpatrick','Regional Director',385750.00,'London',1965,'2010-03-17'),(16,'Michael Silva','Marketing Designer',198500.00,'London',1581,'2012-11-27'),(17,'Paul Byrd','Chief Financial Officer (CFO)',725000.00,'New York',3059,'2010-06-09'),(18,'Gloria Little','Systems Administrator',237500.00,'New York',1721,'2009-04-10'),(19,'Bradley Greer','Software Engineer',132000.00,'London',2558,'2012-10-13'),(20,'Dai Rios','Personnel Lead',217500.00,'Edinburgh',2290,'2012-09-26'),(21,'Jenette Caldwell','Development Lead',345000.00,'New York',1937,'2011-09-03'),(22,'Yuri Berry','Chief Marketing Officer (CMO)',675000.00,'New York',6154,'2009-06-25'),(23,'Caesar Vance','Pre-Sales Support',106450.00,'New York',8330,'2011-12-12'),(24,'Doris Wilder','Sales Assistant',85600.00,'Sydney',3023,'2010-09-20'),(25,'Angelica Ramos','Chief Executive Officer (CEO)',1200000.00,'London',5797,'2009-10-09'),(26,'Gavin Joyce','Developer',92575.00,'Edinburgh',8822,'2010-12-22'),(27,'Jennifer Chang','Regional Director',357650.00,'Singapore',9239,'2010-11-14'),(28,'Brenden Wagner','Software Engineer',206850.00,'San Francisco',1314,'2011-06-07'),(29,'Fiona Green','Chief Operating Officer (COO)',850000.00,'San Francisco',2947,'2010-03-11'),(30,'Shou Itou','Regional Marketing',163000.00,'Tokyo',8899,'2011-08-14'),(31,'Michelle House','Integration Specialist',95400.00,'Sydney',2769,'2011-06-02'),(32,'Suki Burks','Developer',114500.00,'London',6832,'2009-10-22'),(33,'Prescott Bartlett','Technical Author',145000.00,'London',3606,'2011-05-07'),(34,'Gavin Cortez','Team Leader',235500.00,'San Francisco',2860,'2008-10-26'),(35,'Martena Mccray','Post-Sales support',324050.00,'Edinburgh',8240,'2011-03-09'),(36,'Unity Butler','Marketing Designer',85675.00,'San Francisco',5384,'2009-12-09'),(37,'Howard Hatfield','Office Manager',164500.00,'San Francisco',7031,'2008-12-16'),(38,'Hope Fuentes','Secretary',109850.00,'San Francisco',6318,'2010-02-12'),(39,'Vivian Harrell','Financial Controller',452500.00,'San Francisco',9422,'2009-02-14'),(40,'Timothy Mooney','Office Manager',136200.00,'London',7580,'2008-12-11'),(41,'Jackson Bradshaw','Director',645750.00,'New York',1042,'2008-09-26'),(42,'Olivia Liang','Support Engineer',234500.00,'Singapore',2120,'2011-02-03'),(43,'Bruno Nash','Software Engineer',163500.00,'London',6222,'2011-05-03'),(44,'Sakura Yamamoto','Support Engineer',139575.00,'Tokyo',9383,'2009-08-19'),(45,'Thor Walton','Developer',98540.00,'New York',8327,'2013-08-11'),(46,'Finn Camacho','Support Engineer',87500.00,'San Francisco',2927,'2009-07-07'),(47,'Serge Baldwin','Data Coordinator',138575.00,'Singapore',8352,'2012-04-09'),(48,'Zenaida Frank','Software Engineer',125250.00,'New York',7439,'2010-01-04'),(49,'Zorita Serrano','Software Engineer',115000.00,'San Francisco',4389,'2012-06-01'),(50,'Jennifer Acosta','Junior Javascript Developer',75650.00,'Edinburgh',3431,'2013-02-01'),(51,'Cara Stevens','Sales Assistant',145600.00,'New York',3990,'2011-12-06'),(52,'Hermione Butler','Regional Director',356250.00,'London',1016,'2011-03-21'),(53,'Lael Greer','Systems Administrator',103500.00,'London',6733,'2009-02-27'),(54,'Jonas Alexander','Developer',86500.00,'San Francisco',8196,'2010-07-14'),(55,'Shad Decker','Regional Director',183000.00,'Edinburgh',6373,'2008-11-13'),(56,'Michael Bruce','Javascript Developer',183000.00,'Singapore',5384,'2011-06-27'),(57,'Donna Snider','Customer Support',112000.00,'New York',4226,'2011-01-25');
/*!40000 ALTER TABLE `employees` ENABLE KEYS */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-08-12 16:06:03
