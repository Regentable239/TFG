CREATE DATABASE Instacart;

USE Instacart;

CREATE TABLE DEPARTMENT
(
  Department_ID    INT          PRIMARY KEY,
  Department_Name   VARCHAR(30)        NOT NULL
);

CREATE TABLE AISLE
(
  Aisle_ID    INT          PRIMARY KEY,
  Aisle_Name   VARCHAR(30)        NOT NULL
);

CREATE TABLE PRODUCT
(
  Product_ID                INT          PRIMARY KEY,
  Product_Name              VARCHAR(170)         NOT NULL
);

CREATE TABLE ORDERS
(
  Order_ID                  INT          PRIMARY KEY,
  Days_since_prior_order    VARCHAR(25)          
);

CREATE TABLE WEEKDAY
(
  Weekday_ID                  INT          PRIMARY KEY,
  Weekday_Name    VARCHAR(25)         NOT NULL          
);

CREATE TABLE HOUR
(
  Hour_ID                  INT          PRIMARY KEY,
  Format_HHMM    VARCHAR(25)         NOT NULL          
);

CREATE TABLE SALES
(
  D_Department_ID             INT          ,
  A_Aisle_ID                  INT          ,  
  C_Customer_ID               INT          ,
  H_Hour_ID                   INT          ,
  W_Weekday_ID                INT          , 
  O_Order_ID                  INT          ,
  P_Product_ID                INT          ,
  add_to_cart_order           INT          ,
  suggested_sale              INT          ,
  order_number				  INT          ,
  PRIMARY KEY (O_Order_ID,P_Product_ID),
  FOREIGN KEY (O_Order_ID) REFERENCES ORDERS(Order_ID),
  FOREIGN KEY (P_Product_ID) REFERENCES PRODUCT(Product_ID),
  FOREIGN KEY (D_Department_ID) REFERENCES DEPARTMENT(Department_ID),
  FOREIGN KEY (A_Aisle_ID) REFERENCES AISLE(Aisle_ID),
  FOREIGN KEY (W_Weekday_ID) REFERENCES WEEKDAY(Weekday_ID),
  FOREIGN KEY (H_Hour_ID) REFERENCES HOUR(Hour_ID)
);

