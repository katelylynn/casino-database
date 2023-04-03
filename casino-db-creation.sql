/*
	DATABASE CREATION
*/

use master;
go

IF EXISTS(SELECT * FROM sys.databases WHERE name='CasinoDB')
BEGIN
	ALTER DATABASE CasinoDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE CasinoDB;
END

create database CasinoDB;
go

use CasinoDB;
go


/*
	TABLE CREATION
*/


CREATE TABLE ROLE (
  ROLE_ID int NOT NULL primary key,
  ROLE_TITLE VARCHAR(50) NOT NULL,
  ROLE_DESCRIPTION VARCHAR(200)
);


CREATE TABLE CERTIFICATION (
  CERT_ID int not null primary key,
  CERT_NAME varchar(50) not null,
  CERT_VALID_FOR int not null,
  ORG_NAME varchar(50) not null
);


CREATE TABLE SKILL (
  SKILL_ID int not null primary key,
  SKILL_NAME varchar(50) not null
);


CREATE TABLE SECTION (
  SEC_ID int not null primary key,
  SEC_NAME varchar(50) not null
);


CREATE TABLE INVENTORY (
  INV_ID int not null primary key,
  INV_TITLE varchar(150) not null,
  INV_PRICE float not null check(INV_PRICE >= 0),
  INV_QTY int not null
);


CREATE TABLE TRAINING_SESSION (
  TRAIN_ID int not null primary key,
  TRAIN_TYPE char(1) not null check (TRAIN_TYPE = 'I' or TRAIN_TYPE = 'E'),
  TRAIN_DATE date not null
  );


CREATE TABLE SECTION_SKILL (
  SEC_ID int NOT NULL REFERENCES SECTION(SEC_ID),
  SKILL_ID int NOT NULL REFERENCES SKILL(SKILL_ID),
  PRIMARY KEY (SEC_ID, SKILL_ID)
);


CREATE TABLE DEPARTMENT (
  DEP_ID int not null primary key,
  DEP_NAME varchar(50) not null,
);


CREATE TABLE EMPLOYEE (
  EMP_ID int NOT NULL Primary key,
  EMP_NAME varchar(50) not null,
  EMP_ADDRESS varchar(100) not null,
  EMP_DOB date not null,
  EMP_GENDER char(1) not null,
  EMP_HIRE_DATE date not null,
  EMP_FIRE_DATE date,
  EMP_DEPART_DATE date,
  EMP_LOCKER int check (EMP_LOCKER >= 1),
  EMP_PAY_RATE float not null check (EMP_PAY_RATE >= 15.65),
  EMP_VACATION_ENTITLEMENT int not null check (EMP_VACATION_ENTITLEMENT >= 0),
  EMP_SICK_DAYS_ENTITLEMENT int not null check (EMP_SICK_DAYS_ENTITLEMENT >= 0),
   DEP_ID int NOT NULL,
  ROLE_ID int NOT NULL CHECK (ROLE_ID >= 1 and ROLE_ID <= 6),
  FOREIGN KEY (DEP_ID) REFERENCES DEPARTMENT(DEP_ID),
  FOREIGN KEY (ROLE_ID) REFERENCES ROLE(ROLE_ID)
);


CREATE TABLE EMPLOYEE_SKILL (
  EMP_ID int not null,
  SKILL_ID int not null,
  IS_VALID int not null CHECK (IS_VALID = 0 or IS_VALID = 1),
  foreign key (EMP_ID)references EMPLOYEE(EMP_ID),
  foreign key (SKILL_ID) references SKILL(SKILL_ID),
  PRIMARY KEY (EMP_ID, SKILL_ID)
);


CREATE TABLE DEPARTMENT_HISTORY (
  HST_ID int NOT NULL PRIMARY KEY,
  HST_START_DATE date NOT NULL,
  HST_END_DATE date,
  EMP_ID int NOT NULL,
  DEP_ID int NOT NULL,
  FOREIGN KEY (EMP_ID) REFERENCES EMPLOYEE(EMP_ID),
  FOREIGN KEY (DEP_ID) REFERENCES DEPARTMENT(DEP_ID)
);


CREATE TABLE ROLE_CERT (
  CERT_ID int not null,
  ROLE_ID int not null,
  foreign key (CERT_ID)references CERTIFICATION(CERT_ID),
  foreign key (ROLE_ID) references ROLE(ROLE_ID),
  PRIMARY KEY (CERT_ID, ROLE_ID)
);


CREATE TABLE INTERNAL_SESSION (
  TRAIN_ID int NOT NULL,
  SKILL_ID int NOT NULL,
  EMP_DELIVERER int NOT NULL,
  PRIMARY KEY (TRAIN_ID),
  FOREIGN KEY (TRAIN_ID) REFERENCES TRAINING_SESSION(TRAIN_ID),
  FOREIGN KEY (SKILL_ID) REFERENCES SKILL(SKILL_ID),
  FOREIGN KEY (EMP_DELIVERER) REFERENCES EMPLOYEE(EMP_ID)
);


CREATE TABLE SCHEDULE (
  SCH_ID int not null primary key,
  SCH_DATE date not null,
  EMP_ID int not null,
  foreign key (EMP_ID) references EMPLOYEE(EMP_ID)

);


CREATE TABLE SHIFT (
  SHIFT_ID int not null primary key,
  SHIFT_TYPE char(1) not null check (SHIFT_TYPE = 'S' or SHIFT_TYPE = 'B'),
  SHIFT_START time not null,
  SHIFT_END time not null,
  SCH_ID int not null,
  EMP_ID int not null,
  COVER_ID int,
  SEC_ID int not null,
  foreign key (SCH_ID) references SCHEDULE(SCH_ID),
  foreign key (EMP_ID) references EMPLOYEE(EMP_ID),
  foreign key (COVER_ID) references EMPLOYEE(EMP_ID),
  foreign key (SEC_ID) references SECTION(SEC_ID) 
);


CREATE TABLE INVENTORY_SHIFT (
  INV_ID int NOT NULL REFERENCES INVENTORY(INV_ID),
  SHIFT_ID int NOT NULL REFERENCES SHIFT(SHIFT_ID),
  PRIMARY KEY (INV_ID, SHIFT_ID)
);


CREATE TABLE EXTERNAL_SESSION (
  TRAIN_ID int not null primary key,
  CERT_ID int NOT NULL,
  FOREIGN KEY (CERT_ID) REFERENCES CERTIFICATION(CERT_ID)
);


CREATE TABLE EMP_EXTERNAL_TRAINING (
  TRAIN_ID int NOT NULL REFERENCES EXTERNAL_SESSION(TRAIN_ID),
  EMP_ID int NOT NULL REFERENCES EMPLOYEE(EMP_ID),
  IS_SUCCESSFUL int NOT NULL CHECK (IS_SUCCESSFUL = 1 OR IS_SUCCESSFUL = 0),
  PRIMARY KEY (TRAIN_ID, EMP_ID)
);


CREATE TABLE EMP_INTERNAL_TRAINING (
  TRAIN_ID int NOT NULL REFERENCES INTERNAL_SESSION(TRAIN_ID),
  EMP_ID int NOT NULL REFERENCES EMPLOYEE(EMP_ID),
  IS_SUCCESSFUL int NOT NULL CHECK (IS_SUCCESSFUL = 1 OR IS_SUCCESSFUL = 0),
  PRIMARY KEY (TRAIN_ID, EMP_ID)
);


CREATE TABLE LEAVE (
  LEAVE_ID int NOT NULL PRIMARY KEY,
  LEAVE_TYPE char(1) NOT NULL CHECK (LEAVE_TYPE = 'V' OR LEAVE_TYPE = 'S'),
  LEAVE_START date NOT NULL,
  LEAVE_END date NOT NULL,
  EMP_ID int NOT NULL,
  FOREIGN KEY (EMP_ID) REFERENCES EMPLOYEE(EMP_ID)
);


CREATE TABLE WRITTEN_WARNING (
  WW_ID int NOT NULL PRIMARY KEY,
  WW_DATE date NOT NULL,
  WW_LEVEL int NOT NULL CHECK (WW_LEVEL = 1 OR WW_LEVEL = 2 OR WW_LEVEL = 3),
  WW_STATUS int NOT NULL CHECK (WW_STATUS = 0 OR WW_STATUS = 1),
  WW_COMMENTS varchar(300),
  EMP_ID int NOT NULL,
  ISSUER_ID int NOT NULL,
  FOREIGN KEY (EMP_ID) REFERENCES EMPLOYEE(EMP_ID),
  FOREIGN KEY (ISSUER_ID) REFERENCES EMPLOYEE(EMP_ID)
);


INSERT INTO SECTION (SEC_ID, SEC_NAME) VALUES
(1, 'North'),
(2, 'East'),
(3, 'South'),
(4, 'West'),
(5, 'High');


INSERT INTO TRAINING_SESSION (TRAIN_ID, TRAIN_TYPE, TRAIN_DATE) VALUES
(1, 'I', '2023-01-10'),
(2, 'E', '2000-01-15'),
(3, 'I', '2023-01-20'),
(4, 'E', '2023-01-25'),
(5, 'I', '2023-02-01'),
(6, 'E', '2022-05-10'),
(7, 'I', '2023-02-15'),
(8, 'E', '2000-02-20'),
(9, 'I', '2023-03-01'),
(10, 'E', '2023-03-10'),
(11, 'I', '2023-01-10'),
(12, 'E', '2000-01-15'),
(13, 'I', '2023-01-20'),
(14, 'E', '2023-01-25'),
(15, 'I', '2023-02-01'),
(16, 'E', '2022-05-10'),
(17, 'I', '2023-02-15'),
(18, 'E', '2000-02-20'),
(19, 'I', '2023-03-01'),
(20, 'E', '2023-03-10');


INSERT INTO SKILL (SKILL_ID, SKILL_NAME) VALUES
(1, 'Blackjack Dealing'),
(2, 'Roulette Dealing'),
(3, 'Poker Dealing'),
(4, 'Baccarat Dealing'),
(5, 'Craps Dealing'),
(6, 'Casino Security Procedures'),
(7, 'Slot Machine Maintenance'),
(8, 'Customer Service'),
(9, 'Anti-Money Laundering Compliance'),
(10, 'Responsible Gambling Practices');


INSERT INTO INVENTORY (INV_ID, INV_TITLE, INV_PRICE, INV_QTY) VALUES
(1, 'Poker Chips Set (500 pcs)', 75.99, 100),
(2, 'Playing Cards (12 Decks)', 15.50, 250),
(3, 'Roulette Wheel', 180.00, 10),
(4, 'Blackjack Table', 1200.00, 5),
(5, 'Craps Table', 1500.00, 3),
(6, 'Slot Machine', 2200.00, 20),
(7, 'Poker Table', 850.00, 8),
(8, 'Baccarat Table', 1100.00, 4),
(9, 'Casino Security Camera', 400.00, 50),
(10, 'Casino Employee Uniform', 65.00, 300);


INSERT INTO DEPARTMENT (DEP_ID, DEP_NAME) VALUES
(1, 'Floor'),
(2, 'Foods'),
(3, 'Sales'),
(4, 'Marketing'),
(5, 'Finance'),
(6, 'Security'),
(7, 'Gaming Operations'),
(8, 'Hotel'),
(9, 'Entertainment'),
(10, 'Human Resources');



INSERT INTO ROLE (ROLE_ID, ROLE_TITLE, ROLE_DESCRIPTION) VALUES
(1, 'Director of Operations', 'Responsible for managing the team and resources.'),
(2, 'Shift Manager', 'Oversees the work of employees and ensures quality.'),
(3, 'Floor Supervisor', 'Leads a team and coordinates tasks and floor activities.'),
(4, 'Slot Attendant', 'Attends to slots and makes people happy.'),
(5, 'Human Resources', 'Protects the company at all costs.');


INSERT INTO SECTION_SKILL (SEC_ID, SKILL_ID) VALUES
(1, 1),
(1, 2),
(1, 3),
(2, 4),
(2, 5),
(3, 6),
(3, 7),
(3, 8),
(4, 9),
(4, 10);


INSERT INTO EMPLOYEE (EMP_ID, EMP_NAME, EMP_ADDRESS, EMP_DOB, EMP_GENDER, EMP_HIRE_DATE, EMP_PAY_RATE, EMP_VACATION_ENTITLEMENT, EMP_SICK_DAYS_ENTITLEMENT, DEP_ID, ROLE_ID) VALUES
(1, 'Alice Johnson', '123 Main St', '1990-01-01', 'F', '2019-01-01', 25.00, 10, 5, 1, 5),
(2, 'Bob Smith', '456 Oak St', '1985-02-01', 'M', '2018-02-01', 30.00, 12, 6, 2, 5),
(3, 'Charlie Brown', '789 Pine St', '1992-03-01', 'M', '2017-03-01', 20.00, 8, 4, 3, 3),
(4, 'Diana Prince', '111 Elm St', '1980-04-01', 'F', '2016-04-01', 35.00, 15, 7, 4, 4),
(5, 'Eva Green', '222 Birch St', '1988-05-01', 'F', '2015-05-01', 28.00, 11, 6, 5, 5),
(6, 'Frank Miller', '333 Cedar St', '1995-06-01', 'M', '2014-06-01', 24.00, 9, 5, 1, 5),
(7, 'Grace Lee', '444 Maple St', '1983-07-01', 'F', '2013-07-01', 31.00, 13, 7, 2, 3),
(8, 'Hank Moody', '555 Walnut St', '1979-08-01', 'M', '2012-08-01', 36.00, 16, 8, 3, 4),
(9, 'Iris West', '666 Cherry St', '1982-09-01', 'F', '2011-09-01', 29.00, 12, 6, 4, 5),
(10, 'Jack Ryan', '777 Ash St', '1991-10-01', 'M', '2010-10-01', 22.00, 7, 4, 5, 4);


INSERT INTO INTERNAL_SESSION (TRAIN_ID, SKILL_ID, EMP_DELIVERER) VALUES
(1, 1, 1),
(3, 3, 3),
(5, 5, 5),
(7, 7, 7),
(9, 9, 9),
(11, 1, 1),
(13, 3, 3),
(15, 5, 5),
(17, 7, 7),
(19, 9, 9);


INSERT INTO EMPLOYEE_SKILL (EMP_ID, SKILL_ID, IS_VALID) VALUES
(1, 1, 1),
(1, 2, 0),
(2, 4, 1),
(2, 5, 1),
(1, 6, 1),
(1, 7, 0),
(4, 9, 1),
(4, 10, 1),
(5, 1, 1),
(5, 4, 1);


INSERT INTO DEPARTMENT_HISTORY (HST_ID, HST_START_DATE, HST_END_DATE, EMP_ID, DEP_ID) VALUES
(1, '2020-01-01', '2020-12-31', 1, 1),
(2, '2020-01-01', '2020-12-31', 2, 1),
(3, '2020-01-01', '2020-12-31', 3, 2),
(4, '2020-01-01', '2020-12-31', 4, 2),
(5, '2020-01-01', '2020-12-31', 5, 3),
(6, '2020-01-01', '2020-12-31', 6, 3),
(7, '2021-01-01', NULL, 1, 2),
(8, '2021-01-01', NULL, 2, 3),
(9, '2021-01-01', NULL, 3, 1),
(10, '2021-01-01', NULL, 4, 1);


INSERT INTO SCHEDULE (SCH_ID, SCH_DATE, EMP_ID) VALUES
(1, '2023-04-01', 1),
(2, '2023-04-02', 1),
(3, '2023-04-02', 1),
(4, '2023-04-04', 1),
(5, '2023-04-02', 1),
(6, '2023-03-06', 1),
(7, '2023-03-07', 1),
(8, '2023-03-08', 1),
(9, '2023-03-09', 1),
(10, '2023-03-10', 1);


INSERT INTO SHIFT (SHIFT_ID, SHIFT_TYPE, SHIFT_START, SHIFT_END, SCH_ID, EMP_ID, SEC_ID) VALUES
(1, 'S', '08:00:00', '17:00:00', 1, 4, 1),
(2, 'B', '10:00:00', '19:00:00', 2, 4, 2),
(3, 'B', '08:00:00', '17:00:00', 3, 9, 3),
(4, 'B', '12:00:00', '21:00:00', 4, 2, 4),
(5, 'S', '08:00:00', '17:00:00', 5, 1, 5),
(6, 'S', '14:00:00', '23:00:00', 6, 10, 1),
(7, 'B', '08:00:00', '17:00:00', 7, 8, 2),
(8, 'B', '16:00:00', '01:00:00', 8, 7, 3),
(9, 'S', '08:00:00', '17:00:00', 9, 5, 4),
(10, 'S', '18:00:00', '03:00:00', 10, 3, 5);


INSERT INTO INVENTORY_SHIFT (INV_ID, SHIFT_ID) VALUES
(1, 1),
(1, 2),
(2, 3),
(2, 4),
(3, 5),
(3, 6),
(4, 7),
(4, 8),
(5, 9),
(5, 10);


INSERT INTO CERTIFICATION (CERT_ID, CERT_NAME, CERT_VALID_FOR, ORG_NAME) VALUES
(1, 'Casino Management Certification', 12, 'International Gaming Institute'),
(2, 'Certified Gaming Surveillance Professional', 12, 'Global Surveillance Association'),
(3, 'Certified Casino Security Supervisor', 12, 'Casino Security Association'),
(4, 'Certified Responsible Gambling Specialist', 12, 'Responsible Gambling Council'),
(5, 'Certified Table Games Dealer', 12, 'Professional Dealers Association'),
(6, 'Certified Slot Technician', 12, 'Slot Techs Association'),
(7, 'Certified Casino Compliance Officer', 12, 'Casino Compliance Professionals Association'),
(8, 'Certified Casino Marketing Professional', 12, 'Casino Marketing Association'),
(9, 'Certified Casino Host Professional', 12, 'Casino Hosts Association'),
(10, 'Certified Gaming Financial Analyst', 12, 'Gaming Financial Analysts Association');


INSERT INTO EXTERNAL_SESSION (TRAIN_ID, CERT_ID) VALUES
(2, 1),
(4, 1),
(6, 5),
(8, 2),
(10, 5),
(12, 1),
(14, 1),
(16, 5),
(18, 2),
(20, 5);


INSERT INTO ROLE_CERT (CERT_ID, ROLE_ID) VALUES
(1, 1),
(1, 3),
(1, 5),
(2, 2),
(2, 4),
(3, 3),
(3, 5),
(4, 1),
(4, 2),
(5, 5),
(5, 2);


INSERT INTO EMP_EXTERNAL_TRAINING (TRAIN_ID, EMP_ID, IS_SUCCESSFUL) VALUES
(2, 1, 1),
(4, 2, 1),
(6, 3, 0),
(8, 1, 1),
(10, 5, 1),
(2, 6, 0),
(4, 7, 1),
(6, 1, 1),
(8, 9, 1),
(10, 10, 0),
(6, 9, 1),
(6, 10, 1);


INSERT INTO EMP_INTERNAL_TRAINING (TRAIN_ID, EMP_ID, IS_SUCCESSFUL) VALUES
(1, 1, 1),
(3, 2, 1),
(5, 1, 0),
(7, 4, 1),
(9, 5, 1),
(1, 6, 0),
(3, 7, 1),
(5, 8, 1),
(7, 1, 1),
(9, 10, 0);


INSERT INTO LEAVE (LEAVE_ID, LEAVE_TYPE, LEAVE_START, LEAVE_END, EMP_ID) VALUES
(1, 'V', '2022-04-15', '2022-04-19', 1),
(2, 'S', '2022-12-30', '2023-01-14', 2),
(3, 'V', '2023-06-07', '2023-06-11', 3),
(4, 'S', '2023-07-01', '2023-07-05', 2),
(5, 'V', '2023-07-20', '2023-07-24', 1),
(6, 'S', '2023-08-15', '2023-08-19', 6),
(7, 'V', '2023-09-10', '2023-09-14', 7),
(8, 'S', '2023-10-01', '2023-10-05', 8),
(9, 'V', '2023-10-20', '2023-10-24', 9),
(10, 'S', '2023-11-15', '2023-11-19', 10);


INSERT INTO WRITTEN_WARNING (WW_ID, WW_DATE, WW_LEVEL, WW_STATUS, WW_COMMENTS, EMP_ID, ISSUER_ID) VALUES
(1, '2023-04-04', 1, 1, 'Employee was late for work. Actions taken: Given a lecture.', 1, 10),
(2, '2022-04-15', 1, 1, 'Employee was involved in a verbal altercation with a coworker. Actions taken: Manager had a conversation with each person individually.', 2, 10),
(3, '2022-05-10', 1, 1, 'Employee failed to complete assigned tasks on time. Actions taken: Discussed with manager about improvements/tips for increased performance and focus.', 3, 10),
(4, '2022-05-25', 2, 1, 'Employee was found intoxicated during work hours. Actions taken: Spoke in depth with manager and given stern warning.', 3, 10),
(5, '2012-06-15', 1, 0, 'Employee was absent without prior notice. Actions taken: Given a lecture and reminder of company guidelines.', 5, 10),
(6, '2006-06-30', 1, 0, 'Employee failed to comply with the dress code. Actions taken: Reviewed proper dress code with individual.', 6, 10),
(7, '2007-07-20', 1, 0, 'Employee was late for work. Actions taken: Given a lecture.', 7, 10),
(8, '2013-08-01', 1, 0, 'Employee was late for work. Actions taken: Given a lecture.', 8, 10),
(9, '2015-08-15', 1, 0, 'Employee was found violating company policy. Actions taken: Issued retraining of company policies.', 9, 10),
(10, '2005-09-01', 1, 0, 'Employee failed to meet performance standards. Actions taken: Issued retraining of customer service skill.', 10, 10);








