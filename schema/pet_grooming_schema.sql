-- Create the database if it doesn't exist
CREATE DATABASE IF NOT EXISTS `pet_grooming`
/*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */;
USE `pet_grooming`;

-- Create a single user with full access
CREATE USER 'saodatov_user'@'localhost' IDENTIFIED BY 'Saodatov2025'; -- Create a user for the database
GRANT ALL PRIVILEGES ON pet_grooming.* TO 'saodatov_user'@'localhost'; -- Grant full access to the user
FLUSH PRIVILEGES; -- Apply the changes

-- Create the `client` table
DROP TABLE IF EXISTS `client`;
CREATE TABLE `client` (
  Client_ID INT AUTO_INCREMENT PRIMARY KEY, -- Unique ID for each client
  Client_Name VARCHAR(50) NOT NULL, -- Name of the client
  Contact_Number VARCHAR(20) NOT NULL, -- Phone number of the client
  Email VARCHAR(50) NOT NULL, -- Email address
  Home_Address VARCHAR(50), -- Home address
  Pet_Type VARCHAR(20), -- Type of pet (e.g., Dog, Cat)
  Pet_Name VARCHAR(30) -- Name of the pet
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Create the `appointment` table
DROP TABLE IF EXISTS `appointment`;
CREATE TABLE `appointment` (
  Appointment_ID INT AUTO_INCREMENT PRIMARY KEY, -- Unique ID for each appointment
  Client_ID INT NOT NULL, -- Links to the client who booked the appointment
  Appointment_Date DATE NOT NULL, -- Date of the appointment
  Appointment_Time TIME NOT NULL, -- Time of the appointment
  Creation_Timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Automatically records when the appointment is created
  FOREIGN KEY (Client_ID) REFERENCES `client` (Client_ID) -- Ensures the Client_ID exists in the `client` table
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Create a trigger to set the Creation_Timestamp automatically
DELIMITER $$
CREATE TRIGGER set_creation_timestamp
BEFORE INSERT ON appointment
FOR EACH ROW
BEGIN
  SET NEW.Creation_Timestamp = CURRENT_TIMESTAMP;
END;
$$
DELIMITER ;

-- Create the `service` table
DROP TABLE IF EXISTS `service`;
CREATE TABLE `service` (
  Service_ID INT AUTO_INCREMENT PRIMARY KEY, -- Unique ID for each service
  Service_Name VARCHAR(50) NOT NULL, -- Name of the service
  Service_Description VARCHAR(100), -- Description of the service
  Price DECIMAL(10,2) NOT NULL -- Cost of the service
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Create the `appointmentservice` table
DROP TABLE IF EXISTS `appointmentservice`;
CREATE TABLE `appointmentservice` (
  Appointment_ID INT NOT NULL, -- Links to an appointment
  Service_ID INT NOT NULL, -- Links to a service
  PRIMARY KEY (Appointment_ID, Service_ID), -- Composite primary key
  FOREIGN KEY (Appointment_ID) REFERENCES `appointment` (Appointment_ID), -- Ensures Appointment_ID exists
  FOREIGN KEY (Service_ID) REFERENCES `service` (Service_ID) -- Ensures Service_ID exists
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Create the `income` table
DROP TABLE IF EXISTS `income`;
CREATE TABLE `income` (
  Income_ID INT AUTO_INCREMENT PRIMARY KEY, -- Unique ID for each income record
  Appointment_ID INT NOT NULL, -- Links to the appointment for which the payment was made
  Amount_Received DECIMAL(10,2) NOT NULL, -- Payment amount
  Payment_Date DATE NOT NULL, -- Date of the payment
  FOREIGN KEY (Appointment_ID) REFERENCES `appointment` (Appointment_ID) -- Ensures Appointment_ID exists
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Create a procedure to calculate total income for a given date
DELIMITER $$
CREATE PROCEDURE GetTotalIncomeByDate(IN input_date DATE, OUT total_income FLOAT)
BEGIN
  SELECT SUM(Amount_Received) INTO total_income
  FROM `income`
  WHERE Payment_Date = input_date;
END;
$$
DELIMITER ;

-- Create the `review` table
DROP TABLE IF EXISTS `review`;
CREATE TABLE `review` (
  Review_ID INT AUTO_INCREMENT PRIMARY KEY, -- Unique ID for each review
  Appointment_ID INT NOT NULL, -- Links to the appointment being reviewed
  Client_ID INT NOT NULL, -- Links to the client who wrote the review
  Comments VARCHAR(255), -- Review comments
  FOREIGN KEY (Appointment_ID) REFERENCES `appointment` (Appointment_ID), -- Ensures Appointment_ID exists
  FOREIGN KEY (Client_ID) REFERENCES `client` (Client_ID) -- Ensures Client_ID exists
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Create a view summarizing income details
DROP VIEW IF EXISTS `income_summary`;
CREATE VIEW `income_summary` AS
SELECT
  i.Income_ID AS Income_ID, -- ID of the income record
  c.Client_Name AS Client_Name, -- Name of the client who paid
  i.Amount_Received AS Amount_Received, -- Amount paid
  i.Payment_Date AS Payment_Date -- Date of the payment
FROM
  income i
  JOIN appointment a ON i.Appointment_ID = a.Appointment_ID -- Links income to appointments
  JOIN client c ON a.Client_ID = c.Client_ID; -- Links appointments to clients
