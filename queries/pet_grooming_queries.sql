-- Switch to the pet_grooming database
USE pet_grooming;



-- Retrieve all client names and their pet names
SELECT Client_Name, Pet_Name -- Select client and pet names
FROM client; -- From the client table



-- Retrieve all columns from the client table
SELECT * -- Select all columns
FROM client; -- From the client table



-- Retrieve all dogs owned by clients
SELECT Client_Name -- Select client names
FROM client -- From the client table
WHERE Pet_Type = 'Dog'; -- Where the pet type is 'Dog'



-- Retrieve clients who live in London and own a cat
SELECT Client_Name -- Select client names
FROM client -- From the client table
WHERE Home_Address LIKE '%London%' -- Where the address contains 'London'
  AND Pet_Type = 'Cat'; -- And the pet type is 'Cat'




-- Retrieve client names and pet names sorted alphabetically by client name
SELECT Client_Name, Pet_Name -- Select client and pet names
FROM client -- From the client table
ORDER BY Client_Name ASC; -- Sort results in ascending order by client name




-- Retrieve all appointments sorted by appointment date in descending order
SELECT * -- Select all columns
FROM appointment -- From the appointment table
ORDER BY Appointment_Date DESC; -- Sort results by date in descending order




-- Retrieve client names along with their appointment dates
SELECT client.Client_Name, appointment.Appointment_Date -- Select client name and appointment date
FROM client -- From the client table
INNER JOIN appointment -- Join the appointment table
ON client.Client_ID = appointment.Client_ID; -- Match by client ID




-- Retrieve all services linked to appointments
SELECT appointmentservice.Appointment_ID, service.Service_Name -- Select appointment ID and service name
FROM appointmentservice -- From the appointment-service linking table
INNER JOIN service -- Join the service table
ON appointmentservice.Service_ID = service.Service_ID; -- Match by service ID




-- Retrieve all records from the appointmentservice table (for debugging or verification)
SELECT * 
FROM appointmentservice; -- Select all columns from appointmentservice table




-- Retrieve all services linked to appointments along with the client's name
SELECT 
    appointmentservice.Appointment_ID, -- Select appointment ID
    service.Service_Name, -- Select service name
    client.Client_Name -- Select client name
FROM appointmentservice -- From the appointment-service linking table
INNER JOIN service -- Join the service table
ON appointmentservice.Service_ID = service.Service_ID -- Match by service ID
INNER JOIN appointment -- Join the appointment table
ON appointmentservice.Appointment_ID = appointment.Appointment_ID -- Match by appointment ID
INNER JOIN client -- Join the client table
ON appointment.Client_ID = client.Client_ID; -- Match by client ID


-- This query retrieves all services provided in December 2024
SELECT service.Service_Name, appointment.Appointment_Date -- Select service name and appointment date
FROM appointmentservice -- From the appointment-service linking table
INNER JOIN service -- Join the service table
ON appointmentservice.Service_ID = service.Service_ID -- Match by service ID
INNER JOIN appointment -- Join the appointment table
ON appointmentservice.Appointment_ID = appointment.Appointment_ID -- Match by appointment ID
WHERE MONTH(appointment.Appointment_Date) = 12 -- Filter for December
  AND YEAR(appointment.Appointment_Date) = 2024; -- Filter for the year 2024
  
  
  -- This query calculates the total revenue generated from all appointments
SELECT SUM(income.Amount_Received) AS Total_Revenue -- Calculate the sum of all income received
FROM income; -- From the income table


-- This query retrieves the names of clients who left reviews and their comments
SELECT client.Client_Name, review.Comments -- Select client name and review comments
FROM review -- From the review table
INNER JOIN client -- Join the client table
ON review.Client_ID = client.Client_ID; -- Match by client ID



-- This query retrieves the total number of appointments for each client
SELECT client.Client_Name, COUNT(appointment.Appointment_ID) AS Total_Appointments -- Select client name and count of appointments
FROM client -- From the client table
INNER JOIN appointment -- Join the appointment table
ON client.Client_ID = appointment.Client_ID -- Match by client ID
GROUP BY client.Client_Name -- Group by client name
ORDER BY Total_Appointments DESC; -- Order by the total number of appointments in descending order



-- This query retrieves all appointments with their allocated amounts and linked services
SELECT 
    appointment.Appointment_ID, -- Select appointment ID
    client.Client_Name, -- Select client name
    allocated_amount.Allocated_Amount, -- Select allocated amount
    service.Service_Name -- Select service name
FROM allocated_amount -- From the allocated amount table
INNER JOIN appointment -- Join the appointment table
ON allocated_amount.Appointment_ID = appointment.Appointment_ID -- Match by appointment ID
INNER JOIN client -- Join the client table
ON appointment.Client_ID = client.Client_ID -- Match by client ID
INNER JOIN appointmentservice -- Join the appointment-service linking table
ON appointment.Appointment_ID = appointmentservice.Appointment_ID -- Match by appointment ID
INNER JOIN service -- Join the service table
ON appointmentservice.Service_ID = service.Service_ID; -- Match by service ID


