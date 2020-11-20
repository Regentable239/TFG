CREATE DATABASE Cincinnati;

USE Cincinnati;

CREATE TABLE DATE
(
  Date_id               VARCHAR(10)     PRIMARY KEY,
  Date_Format_YYYYMMDD  VARCHAR(10)     NOT NULL,
  Day                   INT             NOT NULL,
  Month                 INT             NOT NULL,
  Year                  INT             NOT NULL
);

CREATE TABLE EMPLOYEE
(
  Employee_id           INT             PRIMARY KEY,
  Employee_Name         VARCHAR(25)     NOT NULL,
  Employee_Surname      VARCHAR(20)     NOT NULL,
  Age_Range             VARCHAR(10)     NOT NULL,
  Race                  VARCHAR(35)     NOT NULL,
  Gender                VARCHAR(2)      NOT NULL
);

CREATE TABLE DEPARTAMENT
(
  Departament_id        INT             PRIMARY KEY,
  Departament_Code      INT             NOT NULL,
  Departament_Name      VARCHAR(35)     NOT NULL,
  Departament_ABBRV     VARCHAR(10)     NOT NULL
);

CREATE TABLE JOB
(
  Job_id                INT             PRIMARY KEY,
  Job_Code              VARCHAR(5)      NOT NULL,
  Job_Name              VARCHAR(35)     NOT NULL,
  Job_ABBRV             VARCHAR(10)     NOT NULL
);

CREATE TABLE PAYMENT_PLAN_EMPLOYEE
(
  Payment_Plan_id       INT             PRIMARY KEY,
  Salary_Plan           VARCHAR(3)      NOT NULL,
  Pay_Group             VARCHAR(3)      NOT NULL
);

CREATE TABLE EMPLOYEE_SALARY
(
  Employee_id                   INT             ,
  Date_Entry_DT                 VARCHAR(10)     ,
  Hire_Date                     VARCHAR(10)     ,
  Departament_id                INT             ,
  Job_id                        INT             ,
  Payment_Plan_id               INT             ,
  Standard_Hours                INT             ,
  Type_Shift_Full_Or_Part_Time  FLOAT           , 
  Rank_Grade_Employee           INT             ,
  Annual_RT                     FLOAT           , 
  PRIMARY KEY (Employee_id,Date_Entry_DT),
  FOREIGN KEY (Employee_id) REFERENCES EMPLOYEE(Employee_id),
  FOREIGN KEY (Date_Entry_DT) REFERENCES DATE(Date_id),
  FOREIGN KEY (Hire_Date) REFERENCES DATE(Date_id),
  FOREIGN KEY (Departament_id) REFERENCES DEPARTAMENT(Departament_id),
  FOREIGN KEY (Job_id) REFERENCES JOB(Job_id),
  FOREIGN KEY (Payment_Plan_id) REFERENCES PAYMENT_PLAN_EMPLOYEE(Payment_Plan_id)
);
