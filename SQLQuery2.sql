--Creating New Table Population 
CREATE TABLE Population
(id INT,
 country VARCHAR(255),
 population2023 INT 
 )
 
 -- Dropping new table
 DROP TABLE Population

 -- Creating a new table
 CREATE TABLE EmployeeInformation
 (id INT,
  fname VARCHAR(255),
  lname VARCHAR(255),
  position VARCHAR(255),
  )

  -- Inserts values into EmployeeInformation
  INSERT INTO EmployeeInformation VALUES
  (1, 'Charles', 'Smith', 'Accountant'),
  (2, 'Chad', 'Whiner', 'Salesman'),
  (3, 'Jenny', 'Edgar', 'IT');

  -- Keeps the table up, but deletes all information within
 TRUNCATE TABLE EmployeeInformation

 --Adding record into EmployeeInformation
 INSERT INTO EmployeeInformation VALUES
  (1, 'Charles', 'Smith', 'Accountant'),
  (2, 'Chad', 'Whiner', 'Sales Assistant'),
  (3, 'Jenny', 'Edgar', 'IT'),
  (4, 'Terrance', 'Carter', 'Maintenance'),
  (5, 'Jim', 'Halpert', 'Sales Assistant'),
  (6, 'Michael', 'Scott', 'Office Manager'), 
  (7, 'Aubrey', 'Plaza', 'Assistant'),
  (8, 'Anna', 'Taylor-Joy', 'Sales Assistant'),
  (9, 'Kyle', 'Chandler', 'HR Manager');

  --Creating a new table
  CREATE TABLE EmployeeSalary
  (id INT,
   department VARCHAR(255),
   Salary INT);

--Inserting values into table
INSERT INTO EmployeeSalary VALUES
(1, 'Finance', 65000),
(2, 'Sales', 57000),
(3, 'IT', 78000),
(4, 'Maintenance', 48000),
(5, 'Sales', 61000),
(6, 'Office', 90000),
(7, 'Office', 50000),
(8, 'Sales', 59000),
(9, 'HR', 73000);

-- Adding a new column into EmployeeSalary
ALTER TABLE EmployeeSalary
ADD CompanyYears INT;

-- Dropping column CompanyYears
ALTER TABLE EmployeeSalary
DROP COLUMN CompanyYears;

--Inner joining tables to get information from both
SELECT fname, lname, position, Salary FROM EmployeeSalary AS sal
INNER JOIN EmployeeInformation AS info
ON sal.id = info.id;

-- Making sure no rows were excluded in inner join
SELECT id from EmployeeSalary
UNION
SELECT id from EmployeeInformation
ORDER BY id;
