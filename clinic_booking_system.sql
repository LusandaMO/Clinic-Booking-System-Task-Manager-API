-- Clinic Booking System Database Schema
-- Author: Software Engineer
-- Purpose: Real-world use case for a Clinic Booking System using MySQL
-- Features: Patients, Doctors, Appointments, Specializations, Prescriptions, and Treatments
 
-- ===========================
-- DATABASE CREATION
-- ===========================
 
CREATE DATABASE clinic;
USE clinic;
 
-- ===========================
-- PHASE 1: INDEPENDENT TABLES
-- ===========================
 
-- 2. Create the Patient table
CREATE TABLE Patient (
    PatientID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    DateOfBirth DATE NOT NULL,
    Gender ENUM('Male', 'Female', 'Other') NOT NULL,
    Phone VARCHAR(20) UNIQUE,
    Email VARCHAR(100) UNIQUE
);
 
-- 3. Create the Doctor table
CREATE TABLE Doctor (
    DoctorID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Phone VARCHAR(20) UNIQUE,
    Email VARCHAR(100) UNIQUE
);
 
-- 4. Create the Specialization table
CREATE TABLE Specialization (
    SpecializationID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL UNIQUE
);
 
-- ===========================
-- PHASE 2: DEPENDENT TABLES
-- ===========================
 
-- 5. Create the DoctorSpecialization table (Many-to-Many: Doctor <-> Specialization)
CREATE TABLE DoctorSpecialization (
    DoctorID INT NOT NULL,
    SpecializationID INT NOT NULL,
    PRIMARY KEY (DoctorID, SpecializationID),
    FOREIGN KEY (DoctorID) REFERENCES Doctor(DoctorID) ON DELETE CASCADE,
    FOREIGN KEY (SpecializationID) REFERENCES Specialization(SpecializationID) ON DELETE CASCADE
);
 
-- 6. Create the Appointment table
CREATE TABLE Appointment (
    AppointmentID INT AUTO_INCREMENT PRIMARY KEY,
    PatientID INT NOT NULL,
    DoctorID INT NOT NULL,
    AppointmentDate DATETIME NOT NULL,
    Status ENUM('Scheduled', 'Completed', 'Cancelled') NOT NULL DEFAULT 'Scheduled',
    Notes VARCHAR(255),
    FOREIGN KEY (PatientID) REFERENCES Patient(PatientID) ON DELETE CASCADE,
    FOREIGN KEY (DoctorID) REFERENCES Doctor(DoctorID) ON DELETE CASCADE
);
 
-- 7. Create the Treatment table (1-to-Many with Appointment)
CREATE TABLE Treatment (
    TreatmentID INT AUTO_INCREMENT PRIMARY KEY,
    AppointmentID INT NOT NULL,
    Description VARCHAR(255) NOT NULL,
    Cost DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (AppointmentID) REFERENCES Appointment(AppointmentID) ON DELETE CASCADE
);
 
-- 8. Create the Prescription table (1-to-Many with Appointment)
CREATE TABLE Prescription (
    PrescriptionID INT AUTO_INCREMENT PRIMARY KEY,
    AppointmentID INT NOT NULL,
    Medication VARCHAR(100) NOT NULL,
    Dosage VARCHAR(50) NOT NULL,
    Instructions VARCHAR(255),
    FOREIGN KEY (AppointmentID) REFERENCES Appointment(AppointmentID) ON DELETE CASCADE
);
 
-- ===========================
-- INSERT SAMPLE DATA
-- ===========================
 
-- Insert data into Patient table
INSERT INTO Patient (FirstName, LastName, DateOfBirth, Gender, Phone, Email) VALUES
('John', 'Doe', '1990-05-12', 'Male', '1234567890', 'john.doe@email.com'),
('Jane', 'Smith', '1985-03-20', 'Female', '2345678901', 'jane.smith@email.com'),
('Emily', 'Clark', '2000-11-02', 'Female', '3456789012', 'emily.clark@email.com');
 
-- Insert data into Doctor table
INSERT INTO Doctor (FirstName, LastName, Phone, Email) VALUES
('Alice', 'Brown', '4567890123', 'alice.brown@clinic.com'),
('Bob', 'Johnson', '5678901234', 'bob.johnson@clinic.com');
 
-- Insert data into Specialization table
INSERT INTO Specialization (Name) VALUES
('General Practitioner'),
('Pediatrics'),
('Dermatology');
 
-- Insert data into DoctorSpecialization table
INSERT INTO DoctorSpecialization (DoctorID, SpecializationID) VALUES
(1, 1), -- Dr. Alice Brown: GP
(1, 3), -- Dr. Alice Brown: Dermatology
(2, 2); -- Dr. Bob Johnson: Pediatrics
 
-- Insert data into Appointment table
INSERT INTO Appointment (PatientID, DoctorID, AppointmentDate, Status, Notes) VALUES
(1, 1, '2025-05-06 10:00:00', 'Scheduled', 'First time appointment.'),
(2, 2, '2025-05-06 11:30:00', 'Completed', 'Follow-up visit.'),
(3, 1, '2025-05-07 09:00:00', 'Completed', 'Routine checkup.');
 
-- Insert data into Treatment table
INSERT INTO Treatment (AppointmentID, Description, Cost) VALUES
(1, 'General Consultation', 50.00),
(2, 'Vaccination', 30.00),
(3, 'Skin Allergy Test', 100.00);
 
-- Insert data into Prescription table
INSERT INTO Prescription (AppointmentID, Medication, Dosage, Instructions) VALUES
(1, 'Paracetamol', '500mg', 'Take one tablet every 6 hours as needed.'),
(3, 'Antihistamine', '10mg', 'Take once daily for 7 days.');