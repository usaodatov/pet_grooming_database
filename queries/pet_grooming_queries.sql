-- Show All Tables in the Current Database Schema
-- This script displays all the tables within the 'pet_grooming' database to provide an overview of the database schema.
SHOW TABLES;

-- Explore Specific Tables with 'SHOW CREATE TABLE'
-- This section gives details on the structure of the 'client' and 'appointment' tables, including constraints and relationships.
SHOW CREATE TABLE client;
SHOW CREATE TABLE appointment;

-- Test Database Connection for 'saodatov_user' and 'tomas'
-- Confirm that database connections work for both the primary user and a secondary user, checking the environment setup.
-- Login as 'saodatov_user'
-- Use password 'Saodatov2025' (copy and paste during demonstration)
mysql -u saodatov_user -pSaodatov2025 -h localhost
-- Login as 'tomas'
-- Use password 'test1234' (copy and paste during demonstration)
mysql -u tomas -ptest1234 -h localhost

-- Insert a New Client Record and a New Service Offering
-- Populate the tables with initial data to demonstrate basic data manipulation operations.
INSERT INTO client (Client_Name, Contact_Number, Email, Home_Address, Pet_Type, Pet_Name)
VALUES ('Amir', '555-1234', 'amirdoe@example.com', '123 Elm St', 'Dog', 'Beast');
INSERT INTO service (Service_Name, Service_Description, Price)
VALUES ('Full Groom', 'Complete grooming package', 49.99);

-- Schedule an Appointment for an Existing Client
-- This demonstrates how to link data from different tables through foreign keys and add records to the 'appointment' table.
INSERT INTO appointment (Client_ID, Appointment_Date, Appointment_Time)
VALUES (1, '2023-10-01', '10:00:00');

-- Retrieve and Show the Creation Trigger in Action
-- Insert a record into the 'appointment' table and immediately retrieve it to show the functionality of the automatic timestamp trigger.
INSERT INTO appointment (Client_ID, Appointment_Date, Appointment_Time)
VALUES (2, '2023-10-02', '11:00:00');
SELECT * FROM appointment WHERE Client_ID = 2;

-- Create and Display Data from 'client_appointments_summary' View
-- Demonstrate creating and using a view to simplify querying and provide meaningful data summaries.
CREATE VIEW client_appointments_summary AS
SELECT client.Client_ID, client.Client_Name, COUNT(appointment.Appointment_ID) AS Num_Appointments
FROM client
JOIN appointment ON client.Client_ID = appointment.Client_ID
GROUP BY client.Client_ID, client.Client_Name;
SELECT * FROM client_appointments_summary;

-- Create and Display Data from 'service_details' View
-- Show how to create a view for detailed service and price information and then retrieve data from this view.
CREATE VIEW service_details AS
SELECT Service_Name, Service_Description, Price
FROM service;
SELECT * FROM service_details;

-- Demonstrate JOIN Operation Between 'client' and 'appointment' Tables
-- This JOIN example shows how data from two related tables can be combined to provide comprehensive output.
SELECT client.Client_Name, appointment.Appointment_Date, appointment.Appointment_Time
FROM appointment
JOIN client ON appointment.Client_ID = client.Client_ID;

-- Check Data Aggregation in the 'income_summary' View
-- Use this view to demonstrate the capability of SQL to aggregate and summarize financial data.
CREATE VIEW income_summary AS
SELECT income.Appointment_ID, SUM(income.Amount_Received) AS Total_Revenue, appointment.Appointment_Date
FROM income
JOIN appointment ON income.Appointment_ID = appointment.Appointment_ID
GROUP BY income.Appointment_ID, appointment.Appointment_Date;
SELECT * FROM income_summary;

-- Update Client Information (Email Address)
-- Update an existing record to demonstrate how data within the database can be modified.
UPDATE client
SET Email = 'new.amir@example.com'
WHERE Client_Name = 'Amir';

-- Call Procedure to Calculate Total Income for a Specific Date
-- Show the use of a stored procedure to handle more complex business logic directly within the database.
CALL GetTotalIncomeByDate('2023-10-01', @total_income);
SELECT @total_income AS TotalIncome;

-- Create a New Database User with Limited Privileges
-- Demonstrate best practices for security by creating a user with restricted access to necessary operations only.
CREATE USER 'jane_doe'@'localhost' IDENTIFIED BY 'secure_password123';
GRANT SELECT, INSERT ON pet_grooming.client TO 'jane_doe'@'localhost';
FLUSH PRIVILEGES;
