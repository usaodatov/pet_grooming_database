-- Create the database if it doesn't already exist
CREATE DATABASE IF NOT EXISTS `pet_grooming`
/*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */;
-- Switch to using the `pet_grooming` database
USE `pet_grooming`;

-- Create a user for the admin with full access
CREATE USER 'admin_user'@'localhost' IDENTIFIED BY 'adminpassword';
-- Create a user for staff with limited access
CREATE USER 'staff_user'@'localhost' IDENTIFIED BY 'securepassword';

-- Grant all permissions on the database to the admin
GRANT ALL PRIVILEGES ON pet_grooming.* TO 'admin_user'@'localhost';
-- Grant limited permissions (only SELECT and INSERT) to the staff user
GRANT SELECT, INSERT ON pet_grooming.* TO 'staff_user'@'localhost';
-- Apply the changes to make sure the permissions are set
FLUSH PRIVILEGES;

-- Drop the `client` table if it already exists (prevents errors when re-running)
DROP TABLE IF EXISTS `client`;
-- Create the `client` table to store information about clients and their pets
CREATE TABLE `client` (
  Client_ID INT AUTO_INCREMENT PRIMARY KEY, -- Unique ID for each client
  Client_Name VARCHAR(50) NOT NULL, -- Client's name
  Contact_Number VARCHAR(20) NOT NULL, -- Client's phone number
  Email VARCHAR(50) NOT NULL, -- Client's email address
  Home_Address VARCHAR(50), -- Client's home address
  Pet_Type VARCHAR(20), -- Type of pet (e.g., Dog, Cat)
  Pet_Name VARCHAR(30) -- Name of the pet
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Drop the `appointment` table if it already exists
DROP TABLE IF EXISTS `appointment`;
-- Create the `appointment` table to store details about client appointments
CREATE TABLE `appointment` (
  Appointment_ID INT AUTO_INCREMENT PRIMARY KEY, -- Unique ID for each appointment
  Client_ID INT NOT NULL, -- Links to the client who booked the appointment
  Appointment_Date DATE NOT NULL, -- Date of the appointment
  Appointment_Time TIME NOT NULL, -- Time of the appointment
  Creation_Timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Automatically records when the appointment is created
  FOREIGN KEY (Client_ID) REFERENCES `client` (Client_ID) -- Ensures the Client_ID exists in the `client` table
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Create a trigger that sets the Creation_Timestamp automatically when a new appointment is added
DELIMITER $$
CREATE TRIGGER set_creation_timestamp
BEFORE INSERT ON appointment
FOR EACH ROW
BEGIN
  -- Sets the timestamp for the new appointment to the current time
  SET NEW.Creation_Timestamp = CURRENT_TIMESTAMP;
END;
$$
DELIMITER ;

-- Drop the `service` table if it already exists
DROP TABLE IF EXISTS `service`;
-- Create the `service` table to store information about services offered
CREATE TABLE `service` (
  Service_ID INT AUTO_INCREMENT PRIMARY KEY, -- Unique ID for each service
  Service_Name VARCHAR(50) NOT NULL, -- Name of the service (e.g., Grooming, Nail Clipping)
  Service_Description VARCHAR(100), -- Description of the service
  Price DECIMAL(10,2) NOT NULL -- Cost of the service
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Drop the `appointmentservice` table if it already exists
DROP TABLE IF EXISTS `appointmentservice`;
-- Create the `appointmentservice` table to handle the many-to-many relationship between appointments and services
CREATE TABLE `appointmentservice` (
  Appointment_ID INT NOT NULL, -- Links to an appointment
  Service_ID INT NOT NULL, -- Links to a service
  PRIMARY KEY (Appointment_ID, Service_ID), -- Combines both columns as the unique identifier
  FOREIGN KEY (Appointment_ID) REFERENCES `appointment` (Appointment_ID), -- Ensures Appointment_ID exists in `appointment`
  FOREIGN KEY (Service_ID) REFERENCES `service` (Service_ID) -- Ensures Service_ID exists in `service`
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Drop the `income` table if it already exists
DROP TABLE IF EXISTS `income`;
-- Create the `income` table to store payment details from clients
CREATE TABLE `income` (
  Income_ID INT AUTO_INCREMENT PRIMARY KEY, -- Unique ID for each payment record
  Appointment_ID INT NOT NULL, -- Links the payment to an appointment
  Amount_Received DECIMAL(10,2) NOT NULL, -- Amount paid by the client
  Payment_Date DATE NOT NULL, -- Date of the payment
  FOREIGN KEY (Appointment_ID) REFERENCES `appointment` (Appointment_ID) -- Ensures Appointment_ID exists in `appointment`
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Create a procedure to calculate total income for a given date
DELIMITER $$
CREATE PROCEDURE GetTotalIncomeByDate(IN input_date DATE, OUT total_income FLOAT)
BEGIN
  -- Calculates the sum of all payments received on the specified date
  SELECT SUM(Amount_Received) INTO total_income
  FROM `income`
  WHERE Payment_Date = input_date;
END;
$$
DELIMITER ;

-- Drop the `review` table if it already exists
DROP TABLE IF EXISTS `review`;
-- Create the `review` table to store feedback from clients about appointments
CREATE TABLE `review` (
  Review_ID INT AUTO_INCREMENT PRIMARY KEY, -- Unique ID for each review
  Appointment_ID INT NOT NULL, -- Links the review to an appointment
  Client_ID INT NOT NULL, -- Links the review to a client
  Comments VARCHAR(255), -- Client feedback
  FOREIGN KEY (Appointment_ID) REFERENCES `appointment` (Appointment_ID), -- Ensures Appointment_ID exists in `appointment`
  FOREIGN KEY (Client_ID) REFERENCES `client` (Client_ID) -- Ensures Client_ID exists in `client`
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Drop the `income_summary` view if it already exists
DROP VIEW IF EXISTS `income_summary`;
-- Create a view that provides a summary of income along with client details
CREATE VIEW `income_summary` AS
SELECT
  i.Income_ID AS Income_ID, -- ID of the income record
  c.Client_Name AS Client_Name, -- Name of the client who made the payment
  i.Amount_Received AS Amount_Received, -- Payment amount
  i.Payment_Date AS Payment_Date -- Date of the payment
FROM
  income i
  JOIN appointment a ON i.Appointment_ID = a.Appointment_ID -- Links income to appointments
  JOIN client c ON a.Client_ID = c.Client_ID; -- Links appointments to clients
