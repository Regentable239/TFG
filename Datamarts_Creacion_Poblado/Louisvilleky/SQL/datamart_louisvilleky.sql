CREATE DATABASE Louisvilleky;

USE Louisvilleky;

CREATE TABLE PAYMENT_DATE
(
  Date_id               VARCHAR(10)     PRIMARY KEY,
  Date_Format_YYYYMMDD  VARCHAR(10)     NOT NULL,
  Day                   INT             NOT NULL,
  Month                 INT             NOT NULL,
  Year                  INT             NOT NULL,
  Quarter               INT             NOT NULL
);

CREATE TABLE DEPARTAMENT
(
  Departament_id        INT             PRIMARY KEY,
  Departament_Name      VARCHAR(35)     NOT NULL
);

CREATE TABLE ABSENTEEISM_TYPE
(
  Absenteeism_Type_id   INT             PRIMARY KEY,
  Absenteeism_Type_name VARCHAR(15)     NOT NULL
);

CREATE TABLE ABSENTEEISM
(
  Departament_id                INT             ,
  Payment_Date                  VARCHAR(10)     ,
  Absenteeism_Type_id           INT             ,
  Total_Absenteeism_Hours       FLOAT           ,
  Total_Aval_Hours              FLOAT           ,
  Total_Employees               INT             ,
  PRIMARY KEY (Departament_id,Payment_Date,Absenteeism_Type_id),
  FOREIGN KEY (Departament_id) REFERENCES DEPARTAMENT(Departament_id),
  FOREIGN KEY (Payment_Date) REFERENCES PAYMENT_DATE(Date_id),
  FOREIGN KEY (Absenteeism_Type_id) REFERENCES ABSENTEEISM_TYPE(Absenteeism_Type_id)
);

CREATE TABLE OSHA_TYPE
(
  OSHA_Type_id          INT             PRIMARY KEY,
  OSHA_Description      VARCHAR(40)     NOT NULL
);

CREATE TABLE OSHA_ACCIDENTS
(
  OSHA_id                               INT             PRIMARY KEY,
  Departament_id                        INT             ,
  Payment_Date                          VARCHAR(10)     ,
  OSHA_Type_id                          INT             ,
  numIncidentsLeadingToLostDays         INT             ,
  numIncidentsLeadingToRestrictedDays   INT             ,
  FOREIGN KEY (Departament_id) REFERENCES DEPARTAMENT(Departament_id),
  FOREIGN KEY (Payment_Date) REFERENCES PAYMENT_DATE(Date_id),
  FOREIGN KEY (OSHA_Type_id) REFERENCES OSHA_TYPE(OSHA_Type_id)
);

CREATE TABLE WORKED_HOURS_TYPE
(
  Worked_Hours_Type_id              INT             PRIMARY KEY,
  Description_Type_Worked_Hours     VARCHAR(35)     NOT NULL,
  Code_Hours_Type                   VARCHAR(5)      NOT NULL,
  Name_Hours_Type                   VARCHAR(35)     NOT NULL
);

CREATE TABLE TOTAL_HOUR_WORKED
(
  Departament_id                INT             ,
  Payment_Date                  VARCHAR(10)     ,
  Worked_Hours_Type             INT             ,
  Amount_Hours                  FLOAT           ,
  Amount_Dollars                FLOAT           ,
  PRIMARY KEY (Departament_id,Payment_Date,Worked_Hours_Type),
  FOREIGN KEY (Departament_id) REFERENCES DEPARTAMENT(Departament_id),
  FOREIGN KEY (Payment_Date) REFERENCES PAYMENT_DATE(Date_id),
  FOREIGN KEY (Worked_Hours_Type) REFERENCES WORKED_HOURS_TYPE(Worked_Hours_Type_id)
);

CREATE TABLE SICK_LEAVE
(
  Departament_id                INT             ,
  Payment_Date                  VARCHAR(10)     ,
  High_Consumer_Employee        INT             ,
  Total_Employees               INT             ,
  PRIMARY KEY (Departament_id,Payment_Date),
  FOREIGN KEY (Departament_id) REFERENCES DEPARTAMENT(Departament_id),
  FOREIGN KEY (Payment_Date) REFERENCES PAYMENT_DATE(Date_id)
);

CREATE TABLE MONTH_END_DATE
(
  Date_id               VARCHAR(10)     PRIMARY KEY,
  Date_Format_YYYYMMDD  VARCHAR(10)     NOT NULL,
  Day                   INT             NOT NULL,
  Month                 INT             NOT NULL,
  Year                  INT             NOT NULL,
  Quarter               INT             NOT NULL
);

CREATE TABLE EMPLOYEE_PROFILE
(
  Employee_Profile_id       INT             PRIMARY KEY,
  Gender                    VARCHAR(10)     NOT NULL,
  Ethnic_Group              VARCHAR(10)     NOT NULL,
  Type_Employee             VARCHAR(10)     NOT NULL,
  Age_Range                 VARCHAR(15)     NOT NULL,
  Years_Worked_Range        VARCHAR(20)     NOT NULL
);

CREATE TABLE TURNOVER_REASON
(
  Turnover_Reason_id       INT             PRIMARY KEY,
  Description_Reason       VARCHAR(30)     NOT NULL,
  Description_Leave_Type   VARCHAR(15)     NOT NULL
);

CREATE TABLE EMPLOYEE_TURNOVER
(
  Employee_Turnover_id          INT             PRIMARY KEY,
  Date_End_worked               VARCHAR(10)     ,
  Departament_id                INT             ,
  Employee_Profile_id           INT             ,
  Turnover_Reason_id            INT             ,
  FOREIGN KEY (Departament_id) REFERENCES DEPARTAMENT(Departament_id),
  FOREIGN KEY (Date_End_worked) REFERENCES MONTH_END_DATE(Date_id),
  FOREIGN KEY (Employee_Profile_id) REFERENCES EMPLOYEE_PROFILE(Employee_Profile_id),
  FOREIGN KEY (Turnover_Reason_id) REFERENCES TURNOVER_REASON(Turnover_Reason_id)
);