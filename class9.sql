create database healthcare;
use healthcare;

select * from patients;
select * from appointments;
select * from billing;
select * from doctors;
select * from prescriptions;

SELECT * FROM Appointments
WHERE patient_id = 1;

SELECT * FROM Prescriptions
WHERE appointment_id = 1;

SELECT * FROM Billing
WHERE appointment_id = 2;

SELECT a.appointment_id, p.first_name AS patient_first_name, p.last_name AS patient_last_name,       
d.first_name AS doctor_first_name, d.last_name AS doctor_last_name, a.appointment_date, a.reason
FROM Appointments a
JOIN Patients p ON a.patient_id = p.patient_id
JOIN Doctors d ON a.doctor_id = d.doctor_id;

SELECT a.appointment_id, p.first_name AS patient_first_name, p.last_name AS patient_last_name,       
d.first_name AS doctor_first_name, d.last_name AS doctor_last_name,       
b.amount, b.payment_date, b.status
FROM Appointments a
JOIN Patients p ON a.patient_id = p.patient_id
JOIN Doctors d ON a.doctor_id = d.doctor_id
JOIN Billing b ON a.appointment_id = b.appointment_id;

SELECT * FROM Billing
WHERE status = 'Paid';

SELECT     
(SELECT SUM(amount) FROM Billing) AS total_billed,    
(SELECT SUM(amount) FROM Billing WHERE status = 'Paid') AS total_paid;

SELECT d.specialty, COUNT(a.appointment_id) AS number_of_appointments
FROM Appointments a
JOIN Doctors d ON a.doctor_id = d.doctor_id
GROUP BY d.specialty;

SELECT reason, 
COUNT(*) AS count
FROM Appointments
GROUP BY reason
ORDER BY count DESC;

SELECT p.patient_id, p.first_name, p.last_name, MAX(a.appointment_date) AS latest_appointment
FROM Patients p
JOIN Appointments a ON p.patient_id = a.patient_id
GROUP BY p.patient_id, p.first_name, p.last_name;

SELECT d.doctor_id, d.first_name, d.last_name, COUNT(a.appointment_id) AS number_of_appointments
FROM Doctors d
LEFT JOIN Appointments a ON d.doctor_id = a.doctor_id
GROUP BY d.doctor_id, d.first_name, d.last_name;

SELECT DISTINCT p.*
FROM Patients p
JOIN Appointments a ON p.patient_id = a.patient_id
WHERE a.appointment_date >= CURDATE() - INTERVAL 30 DAY;

SELECT pr.prescription_id, pr.medication, pr.dosage, pr.instructions
FROM Prescriptions pr
jOIN Appointments a ON pr.appointment_id = a.appointment_id
JOIN Billing b ON a.appointment_id = b.appointment_id
WHERE b.status = 'Pending';

SELECT p.patient_id, p.first_name, p.last_name, p.dob, p.gender, p.address,     
a.appointment_id, a.appointment_date, a.reason,       
b.amount, b.payment_date, b.status AS billing_status
FROM Patients p
LEFT JOIN Appointments a ON p.patient_id = a.patient_id
LEFT JOIN Billing b ON a.appointment_id = b.appointment_id
ORDER BY p.patient_id, a.appointment_date;

SELECT gender, COUNT(*) AS count
FROM Patients
GROUP BY gender;

SELECT DATE_FORMAT(appointment_date, '%Y-%m') AS month, COUNT(*) AS number_of_appointments
FROM Appointments
GROUP BY month
ORDER BY month;

SELECT YEAR(appointment_date) AS year, COUNT(*) AS number_of_appointments
FROM Appointments
GROUP BY year
ORDER BY year;

SELECT medication, COUNT(*) AS frequency, SUM(CAST(SUBSTRING_INDEX(dosage, ' ', 1) AS UNSIGNED)) AS total_dosage
FROM Prescriptions
GROUP BY medication
ORDER BY frequency DESC;

SELECT p.patient_id, COUNT(a.appointment_id) AS appointment_count, AVG(b.amount) AS avg_billing_amount
FROM Patients p
LEFT JOIN Appointments a ON p.patient_id = a.patient_id
LEFT JOIN Billing b ON a.appointment_id = b.appointment_id
GROUP BY p.patient_id;

SELECT p.patient_id, p.first_name, p.last_name, SUM(b.amount) AS total_billed
FROM Patients p
JOIN Appointments a ON p.patient_id = a.patient_id
JOIN Billing b ON a.appointment_id = b.appointment_id
GROUP BY p.patient_id, p.first_name, p.last_name
ORDER BY total_billed DESC
LIMIT 10;

SELECT DATE_FORMAT(payment_date, '%Y-%m') AS month, status, COUNT(*) AS count
FROM Billing
GROUP BY month, status
ORDER BY month, status;

SELECT p.patient_id, p.first_name, p.last_name, SUM(b.amount) AS total_unpaid
FROM Patients p
JOIN Appointments a ON p.patient_id = a.patient_id
JOIN Billing b ON a.appointment_id = b.appointment_id
WHERE b.status = 'Pending'
GROUP BY p.patient_id, p.first_name, p.last_name
ORDER BY total_unpaid DESC;

SELECT d.doctor_id, d.first_name, d.last_name, COUNT(a.appointment_id) AS number_of_appointments
FROM Doctors d
LEFT JOIN Appointments a ON d.doctor_id = a.doctor_id
GROUP BY d.doctor_id, d.first_name, d.last_name;

SELECT appointment_date, COUNT(*) AS appointment_count
FROM Appointments
GROUP BY appointment_date;

SELECT p.patient_id, p.first_name, p.last_name
FROM Patients p
LEFT JOIN Appointments a ON p.patient_id = a.patient_id
WHERE a.appointment_id IS NULL;

SELECT a.appointment_id, a.patient_id, a.doctor_id, a.appointment_date
FROM Appointments a
LEFT JOIN Billing b ON a.appointment_id = b.appointment_id
WHERE b.billing_id IS NULL;

SELECT a.appointment_id, p.first_name AS patient_first_name, p.last_name AS patient_last_name, a.appointment_date, a.reason
FROM Appointments a
JOIN Patients p ON a.patient_id = p.patient_id
WHERE a.doctor_id = 1; 

SELECT p.medication, p.dosage, p.instructions, b.amount, b.payment_date, b.status
FROM Prescriptions p
JOIN Appointments a ON p.appointment_id = a.appointment_id
JOIN Billing b ON a.appointment_id = b.appointment_id
WHERE b.status = 'Pending';

SELECT DISTINCT p.first_name, p.last_name, p.dob, p.gender, a.appointment_date
FROM Patients p
JOIN Appointments a ON p.patient_id = a.patient_id
WHERE DATE_FORMAT(a.appointment_date, '%Y-%m') = '2024-08';

SELECT d.first_name, d.last_name, a.appointment_date, p.first_name AS patient_first_name, p.last_name AS patient_last_name
FROM Doctors d
JOIN Appointments a ON d.doctor_id = a.doctor_id
JOIN Patients p ON a.patient_id = p.patient_id
WHERE a.appointment_date BETWEEN '2024-08-01' AND '2024-08-10'; 

SELECT d.first_name, d.last_name, d.specialty, SUM(b.amount) AS total_billed
FROM Doctors d
JOIN Appointments a ON d.doctor_id = a.doctor_id
JOIN Billing b ON a.appointment_id = b.appointment_id
GROUP BY d.first_name, d.last_name, d.specialty
ORDER BY total_billed desc;
