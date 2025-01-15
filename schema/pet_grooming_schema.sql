CREATE DATABASE  IF NOT EXISTS `pet_grooming` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `pet_grooming`;
-- MySQL dump 10.13  Distrib 8.0.38, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: pet_grooming
-- ------------------------------------------------------
-- Server version	8.0.39

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `allocated_amount`
--

DROP TABLE IF EXISTS allocated_amount;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE allocated_amount (
  Fund_ID int NOT NULL,
  Appointment_ID int DEFAULT NULL,
  Allocated_Amount float DEFAULT NULL,
  Current_Balance float DEFAULT NULL,
  PRIMARY KEY (Fund_ID),
  KEY Appointment_ID (Appointment_ID),
  CONSTRAINT allocated_amount_ibfk_1 FOREIGN KEY (Appointment_ID) REFERENCES appointment (Appointment_ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `appointment`
--

DROP TABLE IF EXISTS appointment;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE appointment (
  Appointment_ID int NOT NULL,
  Client_ID int DEFAULT NULL,
  Appointment_Date date DEFAULT NULL,
  Appointment_Time time DEFAULT NULL,
  Creation_Timestamp timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (Appointment_ID),
  KEY Client_ID (Client_ID),
  CONSTRAINT appointment_ibfk_1 FOREIGN KEY (Client_ID) REFERENCES `client` (Client_ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `appointmentservice`
--

DROP TABLE IF EXISTS appointmentservice;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE appointmentservice (
  Appointment_ID int NOT NULL,
  Service_ID int NOT NULL,
  PRIMARY KEY (Appointment_ID,Service_ID),
  KEY Service_ID (Service_ID),
  CONSTRAINT appointmentservice_ibfk_1 FOREIGN KEY (Appointment_ID) REFERENCES appointment (Appointment_ID),
  CONSTRAINT appointmentservice_ibfk_2 FOREIGN KEY (Service_ID) REFERENCES service (Service_ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `client`
--

DROP TABLE IF EXISTS client;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `client` (
  Client_ID int NOT NULL,
  Client_Name varchar(50) DEFAULT NULL,
  Contact_Number varchar(20) DEFAULT NULL,
  Email varchar(50) DEFAULT NULL,
  Home_Address varchar(50) DEFAULT NULL,
  Pet_Type varchar(20) DEFAULT NULL,
  Pet_Name varchar(30) DEFAULT NULL,
  PRIMARY KEY (Client_ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `expensecategory`
--

DROP TABLE IF EXISTS expensecategory;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE expensecategory (
  Expense_ID int NOT NULL,
  Service_ID int DEFAULT NULL,
  Expense_Amount float DEFAULT NULL,
  Expense_Date date DEFAULT NULL,
  Expense_Category varchar(30) DEFAULT NULL,
  `Description` varchar(50) DEFAULT NULL,
  PRIMARY KEY (Expense_ID),
  KEY Service_ID (Service_ID),
  CONSTRAINT expensecategory_ibfk_1 FOREIGN KEY (Service_ID) REFERENCES service (Service_ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `income`
--

DROP TABLE IF EXISTS income;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE income (
  Income_ID int NOT NULL,
  Appointment_ID int DEFAULT NULL,
  Amount_Received float DEFAULT NULL,
  Payment_Date date DEFAULT NULL,
  PRIMARY KEY (Income_ID),
  KEY Appointment_ID (Appointment_ID),
  CONSTRAINT income_ibfk_1 FOREIGN KEY (Appointment_ID) REFERENCES appointment (Appointment_ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary view structure for view `income_summary`
--

DROP TABLE IF EXISTS income_summary;
/*!50001 DROP VIEW IF EXISTS income_summary*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `income_summary` AS SELECT 
 1 AS Income_ID,
 1 AS Client_Name,
 1 AS Amount_Received,
 1 AS Payment_Date*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `review`
--

DROP TABLE IF EXISTS review;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE review (
  Review_ID int NOT NULL,
  Appointment_ID int DEFAULT NULL,
  Client_ID int NOT NULL,
  Comments varchar(255) DEFAULT NULL,
  PRIMARY KEY (Review_ID),
  KEY Appointment_ID (Appointment_ID),
  KEY fk_client_review (Client_ID),
  CONSTRAINT fk_client_review FOREIGN KEY (Client_ID) REFERENCES `client` (Client_ID) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT review_ibfk_1 FOREIGN KEY (Appointment_ID) REFERENCES appointment (Appointment_ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `service`
--

DROP TABLE IF EXISTS service;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE service (
  Service_ID int NOT NULL,
  Service_Name varchar(50) DEFAULT NULL,
  Service_Description varchar(50) DEFAULT NULL,
  Price float DEFAULT NULL,
  PRIMARY KEY (Service_ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping routines for database 'pet_grooming'
--
/*!50003 DROP PROCEDURE IF EXISTS GetTotalIncomeByDate */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=root@localhost PROCEDURE GetTotalIncomeByDate(IN input_date DATE, OUT total_income FLOAT)
BEGIN
    SELECT SUM(Amount_Received) INTO total_income
    FROM income
    WHERE Payment_Date = input_date;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `income_summary`
--

/*!50001 DROP VIEW IF EXISTS income_summary*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=root@localhost SQL SECURITY DEFINER */
/*!50001 VIEW income_summary AS select i.Income_ID AS Income_ID,c.Client_Name AS Client_Name,i.Amount_Received AS Amount_Received,i.Payment_Date AS Payment_Date from ((income i join appointment a on((i.Appointment_ID = a.Appointment_ID))) join `client` c on((a.Client_ID = c.Client_ID))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed
