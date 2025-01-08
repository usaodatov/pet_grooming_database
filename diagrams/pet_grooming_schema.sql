-- Create the database
CREATE DATABASE IF NOT EXISTS pet_grooming;
USE pet_grooming;

-- Create the Clients table
CREATE TABLE client (
    Client_ID INT AUTO_INCREMENT PRIMARY KEY, -- Unique ID for each client
    Client_Name VARCHAR(50), -- Name of the client
    Contact_Number VARCHAR(20), -- Phone number
    Email VARCHAR(50), -- Email address
    Home_Address VARCHAR(100), -- Home address
    Pet_Type VARCHAR(30), -- Type of pet (e.g., Dog, Cat)
    Pet_Name VARCHAR(30) -- Name of the pet
);

-- Create the Services table
CREATE TABLE service (
    Service_ID INT AUTO_INCREMENT PRIMARY KEY, -- Unique ID for each service
    Service_Name VARCHAR(50), -- Name of the service
    Service_Description VARCHAR(100), -- Description of the service
    Price DECIMAL(10, 2) -- Cost of the service
);

-- Create the Appointments table
CREATE TABLE appointment (
    Appointment_ID INT AUTO_INCREMENT PRIMARY KEY, -- Unique ID for each appointment
    Client_ID INT, -- Foreign key referencing Clients table
    Appointment_Date DATE, -- Date of the appointment
    Appointment_Time TIME, -- Time of the appointment
    FOREIGN KEY (Client_ID) REFERENCES client(Client_ID) -- Foreign key constraint
);

-- Create the Appointment Services table
CREATE TABLE appointmentservice (
    Appointment_ID INT, -- Foreign key referencing Appointments table
    Service_ID INT, -- Foreign key referencing Services table
    FOREIGN KEY (Appointment_ID) REFERENCES appointment(Appointment_ID), -- Foreign key constraint
    FOREIGN KEY (Service_ID) REFERENCES service(Service_ID), -- Foreign key constraint
    PRIMARY KEY (Appointment_ID, Service_ID) -- Composite primary key
);

-- Create the Income table
CREATE TABLE income (
    Income_ID INT AUTO_INCREMENT PRIMARY KEY, -- Unique ID for each income record
    Appointment_ID INT, -- Foreign key referencing Appointments table
    Amount_Received DECIMAL(10, 2), -- Amount received from the client
    Payment_Date DATE, -- Date of payment
    FOREIGN KEY (Appointment_ID) REFERENCES appointment(Appointment_ID) -- Foreign key constraint
);

-- Create the Expenses table
CREATE TABLE expensecategory (
    Expense_ID INT AUTO_INCREMENT PRIMARY KEY, -- Unique ID for each expense record
    Expense_Name VARCHAR(50), -- Name of the expense
    Amount DECIMAL(10, 2), -- Amount of the expense
    Expense_Date DATE -- Date of the expense
);

-- Create the Reviews table
CREATE TABLE review (
    Review_ID INT AUTO_INCREMENT PRIMARY KEY, -- Unique ID for each review
    Appointment_ID INT, -- Foreign key referencing Appointments table
    Client_ID INT, -- Foreign key referencing Clients table
    Comments VARCHAR(255), -- Client feedback
    FOREIGN KEY (Appointment_ID) REFERENCES appointment(Appointment_ID), -- Foreign key constraint
    FOREIGN KEY (Client_ID) REFERENCES client(Client_ID) -- Foreign key constraint
);
