-- =====================================================================
-- Real Estate Property Management Database
-- =====================================================================

-- =====================================================================
-- TASK 4: DATABASE SCHEMA CREATION (DDL)
-- =====================================================================

DROP DATABASE IF EXISTS real_estate_db;
CREATE DATABASE real_estate_db;
USE real_estate_db;

DROP TABLE IF EXISTS Tenant;
CREATE TABLE Tenant (
  TenantID int not null,
  First_name varchar(25) not null,
  Last_name varchar(25) not null,
  Contact_number int,
  Emirates_ID char(15) not null,
  CONSTRAINT pk_tenant primary key (TenantID),
  CONSTRAINT uk_emirates_id UNIQUE (Emirates_ID)
);

DROP TABLE IF EXISTS Property;
CREATE TABLE Property (
  PropertyID int not null,
  Name varchar(25) not null,
  Location varchar(50),
  Number_of_bedrooms int,
  Market_rent decimal(10,2),
  Availability char(1),
  CONSTRAINT pk_property primary key (PropertyID)
);

DROP TABLE IF EXISTS Lease;
CREATE TABLE Lease (
  LeaseID int not null,
  TenantID int not null,
  PropertyID int not null,
  Type varchar(15),
  Start_date date not null,
  End_date date not null,
  Annual_rate decimal(10,2),
  Security_deposit decimal(10,2),
  CONSTRAINT pk_lease primary key (LeaseID),
  CONSTRAINT fk_lease_tenant foreign key (TenantID) references Tenant(TenantID),
  CONSTRAINT fk_lease_property foreign key (PropertyID) references Property(PropertyID),
  CONSTRAINT ck_lease_dates CHECK (End_date > Start_date)
);

DROP TABLE IF EXISTS Payment;
CREATE TABLE Payment (
  PaymentID int not null,
  LeaseID int not null,
  Category varchar(20),
  Amount decimal(10,2),
  Payment_date date,
  CONSTRAINT pk_payment primary key (PaymentID),
  CONSTRAINT fk_payment_lease foreign key (LeaseID) references Lease(LeaseID)
);

DROP TABLE IF EXISTS Certificate;
CREATE TABLE Certificate (
  RegNum int not null,
  LeaseID int not null,
  Issue_date date,
  Expiry_date date,
  CONSTRAINT pk_certificate primary key (RegNum),
  CONSTRAINT uk_certificate_lease UNIQUE (LeaseID),
  CONSTRAINT fk_certificate_lease foreign key (LeaseID) references Lease(LeaseID)
);

DROP TABLE IF EXISTS Contractor;
CREATE TABLE Contractor (
  ContractorID int not null,
  Name varchar(50) not null,
  Service_type varchar(20),
  Contact_number int,
  Rating int CHECK (Rating >= 1 AND Rating <= 5),
  CONSTRAINT pk_contractor primary key (ContractorID)
);

DROP TABLE IF EXISTS Staff;
CREATE TABLE Staff (
  StaffID int not null,
  First_name varchar(25) not null,
  Last_name varchar(25) not null,
  Role varchar(25),
  Contact_number int,
  Residence_expiry date,
  Status varchar(10),
  CONSTRAINT pk_staff primary key (StaffID)
);

-- Request_age is a derived attribute (from Creation_date and today's date), so it is not stored.
DROP TABLE IF EXISTS Request;
CREATE TABLE Request (
  RequestID int not null,
  PropertyID int not null,
  StaffID int not null,
  Description varchar(500),
  Due_date date,
  Completion_status varchar(15),
  Creation_date date not null,
  CONSTRAINT pk_request primary key (RequestID),
  CONSTRAINT fk_request_property foreign key (PropertyID) references Property(PropertyID),
  CONSTRAINT fk_request_staff foreign key (StaffID) references Staff(StaffID)
);

DROP TABLE IF EXISTS Property_Staff;
CREATE TABLE Property_Staff (
  PropertyID int not null,
  StaffID int not null,
  CONSTRAINT pk_property_staff primary key (PropertyID, StaffID),
  CONSTRAINT fk_ps_property foreign key (PropertyID) references Property(PropertyID),
  CONSTRAINT fk_ps_staff foreign key (StaffID) references Staff(StaffID)
);

DROP TABLE IF EXISTS Property_Contractor;
CREATE TABLE Property_Contractor (
  PropertyID int not null,
  ContractorID int not null,
  CONSTRAINT pk_property_contractor primary key (PropertyID, ContractorID),
  CONSTRAINT fk_pc_property foreign key (PropertyID) references Property(PropertyID),
  CONSTRAINT fk_pc_contractor foreign key (ContractorID) references Contractor(ContractorID)
);

-- =====================================================================
-- TASK 5: DATABASE POPULATION (DML)
-- =====================================================================

INSERT INTO Tenant VALUES (1, 'Ahmed', 'Al Mansoori', 100000001, '000000000000001');
INSERT INTO Tenant VALUES (2, 'Fatima', 'Al Hashimi', 100000002, '000000000000002');
INSERT INTO Tenant VALUES (3, 'Rahul', 'Menon', 100000003, '000000000000003');
INSERT INTO Tenant VALUES (4, 'Omar', 'Khalil', 100000004, '000000000000004');
INSERT INTO Tenant VALUES (5, 'Sara', 'Al Qasimi', 100000005, '000000000000005');
INSERT INTO Tenant VALUES (6, 'Daniel', 'Okafor', 100000006, '000000000000006');
INSERT INTO Tenant VALUES (7, 'Mariam', 'Al Nuaimi', 100000007, '000000000000007');
INSERT INTO Tenant VALUES (8, 'Li', 'Wei', 100000008, '000000000000008');
INSERT INTO Tenant VALUES (9, 'Yousef', 'Haddad', 100000009, '000000000000009');
INSERT INTO Tenant VALUES (10, 'Aisha', 'Rahman', 100000010, '000000000000010');

INSERT INTO Property VALUES (1, 'Marina Heights 1204', 'Dubai Marina, Dubai', 2, 120000.00, 'N');
INSERT INTO Property VALUES (2, 'Al Nahda Villa 7', 'Al Nahda, Sharjah', 4, 95000.00, 'N');
INSERT INTO Property VALUES (3, 'Business Bay Office 310', 'Business Bay, Dubai', 0, 180000.00, 'N');
INSERT INTO Property VALUES (4, 'Al Majaz Tower 805', 'Al Majaz, Sharjah', 1, 42000.00, 'Y');
INSERT INTO Property VALUES (5, 'JLT Retail Unit G2', 'Jumeirah Lake Towers, Dubai', 0, 150000.00, 'N');
INSERT INTO Property VALUES (6, 'Khalifa City Villa 22', 'Khalifa City, Abu Dhabi', 5, 210000.00, 'N');
INSERT INTO Property VALUES (7, 'Al Reem Apartment 1502', 'Al Reem Island, Abu Dhabi', 3, 135000.00, 'N');
INSERT INTO Property VALUES (8, 'Muwaileh Shop 4', 'Muwaileh, Sharjah', 0, 60000.00, 'N');
INSERT INTO Property VALUES (9, 'Ajman Corniche 903', 'Corniche, Ajman', 2, 38000.00, 'Y');
INSERT INTO Property VALUES (10, 'Deira Office 211', 'Deira, Dubai', 0, 85000.00, 'N');

INSERT INTO Lease VALUES (1, 1, 1, 'Commercial', '2025-01-01', '2025-12-31', 110000.00, 5500.00);
INSERT INTO Lease VALUES (2, 2, 1, 'Residential', '2026-01-15', '2027-01-14', 118000.00, 5900.00);
INSERT INTO Lease VALUES (3, 3, 2, 'Residential', '2026-03-01', '2027-02-28', 92000.00, 4600.00);
INSERT INTO Lease VALUES (4, 4, 3, 'Commercial', '2025-06-01', '2026-05-31', 170000.00, 8500.00);
INSERT INTO Lease VALUES (5, 5, 3, 'Commercial', '2026-06-01', '2027-05-31', 178000.00, 8900.00);
INSERT INTO Lease VALUES (6, 6, 5, 'Commercial', '2026-02-01', '2027-01-31', 148000.00, 7400.00);
INSERT INTO Lease VALUES (7, 7, 6, 'Residential', '2026-05-01', '2027-04-30', 205000.00, 10250.00);
INSERT INTO Lease VALUES (8, 8, 7, 'Residential', '2026-07-01', '2027-06-30', 132000.00, 6600.00);
INSERT INTO Lease VALUES (9, 9, 8, 'Commercial', '2026-01-01', '2026-12-31', 58000.00, 2900.00);
INSERT INTO Lease VALUES (10, 10, 10, 'Commercial', '2026-04-01', '2027-03-31', 84000.00, 4200.00);

INSERT INTO Payment VALUES (1, 1, 'Security deposit', 5500.00, '2025-01-01');
INSERT INTO Payment VALUES (2, 1, 'Rent', 55000.00, '2025-01-01');
INSERT INTO Payment VALUES (3, 1, 'Rent', 55000.00, '2025-07-01');
INSERT INTO Payment VALUES (4, 2, 'Security deposit', 5900.00, '2026-01-15');
INSERT INTO Payment VALUES (5, 2, 'Rent', 59000.00, '2026-01-15');
INSERT INTO Payment VALUES (6, 2, 'Service charge', 1500.00, '2026-03-01');
INSERT INTO Payment VALUES (7, 5, 'Rent', 89000.00, '2026-06-01');
INSERT INTO Payment VALUES (8, 5, 'Service charge', 3500.00, '2026-06-15');
INSERT INTO Payment VALUES (9, 7, 'Rent', 102500.00, '2026-05-01');
INSERT INTO Payment VALUES (10, 10, 'Rent', 42000.00, '2026-04-01');

INSERT INTO Certificate VALUES (20250001, 1, '2024-12-28', '2025-12-31');
INSERT INTO Certificate VALUES (20260002, 2, '2026-01-12', '2027-01-14');
INSERT INTO Certificate VALUES (20260003, 3, '2026-02-26', '2027-02-28');
INSERT INTO Certificate VALUES (20250004, 4, '2025-05-28', '2026-05-31');
INSERT INTO Certificate VALUES (20260005, 5, '2026-05-27', '2027-05-31');
INSERT INTO Certificate VALUES (20260006, 6, '2026-01-29', '2027-01-31');
INSERT INTO Certificate VALUES (20260007, 7, '2026-04-28', '2027-04-30');
INSERT INTO Certificate VALUES (20260008, 8, '2026-06-28', '2027-06-30');
INSERT INTO Certificate VALUES (20250009, 9, '2025-12-29', '2026-12-31');
INSERT INTO Certificate VALUES (20260010, 10, '2026-03-29', '2027-03-31');

INSERT INTO Contractor VALUES (1, 'Blue Line Plumbing', 'Plumbing', 200000001, 5);
INSERT INTO Contractor VALUES (2, 'Spark Electrical Services', 'Electrical', 200000002, 4);
INSERT INTO Contractor VALUES (3, 'CoolAir AC Maintenance', 'Air conditioning', 200000003, 5);
INSERT INTO Contractor VALUES (4, 'Desert Wood Carpentry', 'Carpentry', 200000004, 3);
INSERT INTO Contractor VALUES (5, 'Fresh Coat Painting', 'Painting', 200000005, 4);
INSERT INTO Contractor VALUES (6, 'Sparkle Cleaning Co', 'Cleaning', 200000006, 2);
INSERT INTO Contractor VALUES (7, 'Gulf Pipe Solutions', 'Plumbing', 200000007, 3);
INSERT INTO Contractor VALUES (8, 'Volt Pro Electric', 'Electrical', 200000008, 5);
INSERT INTO Contractor VALUES (9, 'Arctic Breeze AC', 'Air conditioning', 200000009, 4);
INSERT INTO Contractor VALUES (10, 'Pure Shine Cleaning', 'Cleaning', 200000010, 1);

INSERT INTO Staff VALUES (1, 'Hassan', 'Al Ali', 'Property manager', 300000001, '2027-05-10', 'Active');
INSERT INTO Staff VALUES (2, 'Priya', 'Nair', 'Leasing agent', 300000002, '2026-12-20', 'Active');
INSERT INTO Staff VALUES (3, 'Mohammed', 'Saeed', 'Maintenance technician', 300000003, '2027-08-01', 'Active');
INSERT INTO Staff VALUES (4, 'John', 'Mathew', 'Maintenance technician', 300000004, '2027-02-14', 'Active');
INSERT INTO Staff VALUES (5, 'Layla', 'Ibrahim', 'Supervisor', 300000005, '2028-01-30', 'Active');
INSERT INTO Staff VALUES (6, 'Arjun', 'Patel', 'Maintenance technician', 300000006, '2026-12-31', 'On leave');
INSERT INTO Staff VALUES (7, 'Hind', 'Al Marri', 'Leasing agent', 300000007, '2027-10-05', 'Active');
INSERT INTO Staff VALUES (8, 'Carlos', 'Reyes', 'Maintenance technician', 300000008, '2027-03-22', 'Active');
INSERT INTO Staff VALUES (9, 'Salma', 'Youssef', 'Property manager', 300000009, '2027-06-18', 'Inactive');
INSERT INTO Staff VALUES (10, 'Tariq', 'Aziz', 'Supervisor', 300000010, '2027-09-09', 'Active');

INSERT INTO Request VALUES (1, 1, 3, 'Kitchen sink leaking under the counter', '2026-02-10', 'Completed', '2026-02-03');
INSERT INTO Request VALUES (2, 2, 4, 'AC not cooling in the master bedroom', '2026-06-15', 'Completed', '2026-06-10');
INSERT INTO Request VALUES (3, 3, 8, 'Office lights flickering in meeting room', '2026-03-05', 'Completed', '2026-03-01');
INSERT INTO Request VALUES (4, 6, 3, 'Water heater not working', '2026-08-20', 'Completed', '2026-08-15');
INSERT INTO Request VALUES (5, 7, 6, 'Balcony door lock broken', '2026-09-12', 'Completed', '2026-09-05');
INSERT INTO Request VALUES (6, 5, 8, 'Power socket sparking near the entrance', '2026-10-02', 'Completed', '2026-09-30');
INSERT INTO Request VALUES (7, 1, 4, 'Bathroom tiles cracked', '2026-11-25', 'In progress', '2026-11-10');
INSERT INTO Request VALUES (8, 10, 5, 'Inspection of the fire alarm system', '2026-12-01', 'Pending', '2026-11-12');
INSERT INTO Request VALUES (9, 6, 1, 'Garden irrigation pipe burst', '2026-11-22', 'In progress', '2026-11-17');
INSERT INTO Request VALUES (10, 8, 4, 'Shop shutter jammed', '2026-10-20', 'Completed', '2026-10-14');

INSERT INTO Property_Staff VALUES (1, 1);
INSERT INTO Property_Staff VALUES (1, 3);
INSERT INTO Property_Staff VALUES (2, 4);
INSERT INTO Property_Staff VALUES (3, 8);
INSERT INTO Property_Staff VALUES (4, 2);
INSERT INTO Property_Staff VALUES (5, 8);
INSERT INTO Property_Staff VALUES (6, 3);
INSERT INTO Property_Staff VALUES (7, 6);
INSERT INTO Property_Staff VALUES (9, 7);
INSERT INTO Property_Staff VALUES (10, 5);

INSERT INTO Property_Contractor VALUES (1, 1);
INSERT INTO Property_Contractor VALUES (1, 2);
INSERT INTO Property_Contractor VALUES (1, 3);
INSERT INTO Property_Contractor VALUES (2, 9);
INSERT INTO Property_Contractor VALUES (3, 2);
INSERT INTO Property_Contractor VALUES (5, 8);
INSERT INTO Property_Contractor VALUES (6, 1);
INSERT INTO Property_Contractor VALUES (6, 3);
INSERT INTO Property_Contractor VALUES (6, 5);
INSERT INTO Property_Contractor VALUES (7, 5);
-- Select statements to check all the tables were created and filled properly
SELECT * FROM Tenant;
SELECT * FROM Property;
SELECT * FROM Lease;
SELECT * FROM Payment;
SELECT * FROM Certificate;
SELECT * FROM Contractor;
SELECT * FROM Staff;
SELECT * FROM Request;
SELECT * FROM Property_Staff;
SELECT * FROM Property_Contractor;

