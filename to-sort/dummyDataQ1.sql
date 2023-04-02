USE CasinoDB

-- ROLE
INSERT INTO ROLE (ROLE_ID, ROLE_TITLE, ROLE_DESCRIPTION) VALUES
(1, 'Manager', 'Responsible for managing the team and resources.'),
(2, 'Supervisor', 'Oversees the work of employees and ensures quality.'),
(3, 'Team Lead', 'Leads a team and coordinates tasks and projects.'),
(4, 'Senior Developer', 'Develops software and mentors junior developers.'),
(5, 'Junior Developer', 'Develops software under the guidance of seniors.');

-- CERTIFICATION
INSERT INTO CERTIFICATION (CERT_ID, CERT_NAME, CERT_VALID_FOR, ORG_NAME) VALUES
(1, 'Project Management Professional', '2024-03-01', 'PMI'),
(2, 'Certified ScrumMaster', '2024-06-01', 'Scrum Alliance'),
(3, 'AWS Certified Solutions Architect', '2024-07-01', 'Amazon Web Services'),
(4, 'Microsoft Certified: Azure Administrator', '2024-08-01', 'Microsoft'),
(5, 'Google Cloud Professional Data Engineer', '2024-09-01', 'Google Cloud');

-- SKILL
INSERT INTO SKILL (SKILL_ID, SKILL_NAME, IS_VALID) VALUES
(1, 'JavaScript', 1),
(2, 'Python', 1),
(3, 'Java', 1),
(4, 'C#', 1),
(5, 'SQL', 1);

-- SECTION
INSERT INTO SECTION (SEC_ID, SEC_NAME) VALUES
(1, 'HR'),
(2, 'IT'),
(3, 'Sales'),
(4, 'Marketing'),
(5, 'Finance');

-- INVENTORY
INSERT INTO INVENTORY (INV_ID, INV_TITLE, INV_PRICE, INV_QTY) VALUES
(1, 'Laptop Dell XPS 13', 1200, 10),
(2, 'Monitor HP Z27', 450, 15),
(3, 'Microsoft Ergonomic Keyboard', 80, 20),
(4, 'Logitech MX Master 3 Mouse', 100, 25),
(5, 'Office Chair', 150, 30);

-- TRAINING_SESSION
INSERT INTO TRAINING_SESSION (TRAIN_ID, TRAIN_TYPE, TRAIN_DATE) VALUES
(1, 'I', '2023-04-01'),
(2, 'I', '2023-04-02'),
(3, 'E', '2023-04-03'),
(4, 'E', '2023-04-04'),
(5, 'I', '2023-04-05');

-- DEPARTMENT
INSERT INTO DEPARTMENT (DEP_ID, DEP_NAME) VALUES
(1, 'Human Resources'),
(2, 'Information Technology'),
(3, 'Sales'),
(4, 'Marketing'),
(5, 'Finance');

-- EMPLOYEE


INSERT INTO EMPLOYEE (EMP_ID, EMP_NAME, EMP_ADDRESS, EMP_DOB, EMP_GENDER, EMP_HIRE_DATE, EMP_PAY_RATE, EMP_VACATION_ENTITLEMENT, EMP_SICK_DAYS_ENTITLEMENT, DEP_ID, ROLE_ID) VALUES
(1, 'Alice Johnson', '123 Main St', '1990-01-01', 'F', '2019-01-01', 25.00, 10, 5, 1, 1),
(2, 'Bob Smith', '456 Oak St', '1985-02-01', 'M', '2018-02-01', 30.00, 12, 6, 2, 2),
(3, 'Charlie Brown', '789 Pine St', '1992-03-01', 'M', '2017-03-01', 20.00, 8, 4, 3, 3),
(4, 'Diana Prince', '111 Elm St', '1980-04-01', 'F', '2016-04-01', 35.00, 15, 7, 4, 4),
(5, 'Eva Green', '222 Birch St', '1988-05-01', 'F', '2015-05-01', 28.00, 11, 6, 5, 5),
(6, 'Frank Miller', '333 Cedar St', '1995-06-01', 'M', '2014-06-01', 24.00, 9, 5, 1, 2),
(7, 'Grace Lee', '444 Maple St', '1983-07-01', 'F', '2013-07-01', 31.00, 13, 7, 2, 3),
(8, 'Hank Moody', '555 Walnut St', '1979-08-01', 'M', '2012-08-01', 36.00, 16, 8, 3, 4),
(9, 'Iris West', '666 Cherry St', '1982-09-01', 'F', '2011-09-01', 29.00, 12, 6, 4, 5),
(10, 'Jack Ryan', '777 Ash St', '1991-10-01', 'M', '2010-10-01', 22.00, 7, 4, 5, 1);
