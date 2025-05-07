# Clinic-Booking-System-Task-Manager-API
# Clinic Booking System & Task Manager API

## Project Description
This repository contains two distinct projects:
1. **Clinic Booking System**: A database schema designed to manage clinic operations, including patients, doctors, appointments, treatments, and prescriptions.
2. **Task Manager**: A Python-based API built with FastAPI to manage tasks and users. It supports full CRUD operations and connects to a MySQL database.

These projects demonstrate practical implementations of database design and API development using industry-standard tools and best practices.

---

## How to Run/Setup the Project

### **1. Clinic Booking System**
- **Database Schema**: 
  The SQL script for the Clinic Booking System (`clinic_booking_system.sql`) creates the database structure and includes sample data for testing.
- **Steps to Import the Schema**:
  1. Open your MySQL client or command-line tool.
  2. Execute the SQL script:
     ```bash
     mysql -u <username> -p < database_name> < clinic_booking_system.sql
     ```
  3. The schema will create tables for `Patients`, `Doctors`, `Appointments`, `Treatments`, and `Prescriptions`.

- **ERD**:
  - The Entity-Relationship Diagram (ERD) for the Clinic Booking System is available in the repository as a PDF file (`clinic_booking_system_erd.pdf`). This diagram visually represents the database structure, including entities and their relationships.

---

### **2. Task Manager API**
- **API**: The Task Manager API is built using FastAPI to manage tasks and users.
- **Steps to Run**:
  1. Install Python dependencies:
     ```bash
     pip install fastapi sqlalchemy pymysql uvicorn pydantic
     ```
  2. Set up the MySQL database:
     - Import the `task_manager_schema.sql` file into your MySQL database.
  3. Run the API server:
     ```bash
     uvicorn task_manager_api:app --reload
     ```
  4. Access the API:
     - Navigate to the Swagger UI: `http://127.0.0.1:8000/docs` to test the API endpoints.
     - 
- **ERD**:
  - The Entity-Relationship Diagram (ERD) for the Task Manager database schema can also be generated from the `task_manager_schema.sql` file if needed.


---

## Features
### **Clinic Booking System**
- Manage patients, doctors, and specializations.
- Schedule and track appointments.
- Record treatments and prescriptions.

### **Task Manager**
- Create, read, update, and delete tasks.
- Manage user accounts and associate tasks with users.
- Supports filtering tasks by status (Pending, In Progress, Completed).

---

Feel free to explore the repository and adapt it to your needs!
