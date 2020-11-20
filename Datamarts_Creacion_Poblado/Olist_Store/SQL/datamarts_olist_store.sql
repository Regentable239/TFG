CREATE DATABASE Olist_Store;

USE Olist_Store;

CREATE TABLE DATE
(
  Date_id               VARCHAR(10)     PRIMARY KEY,
  Date_Format_YYYYMMDD  VARCHAR(10)     NOT NULL,
  Day_of_Month          INT             NOT NULL,
  Month                 INT             NOT NULL,
  Year                  INT             NOT NULL,
  Week_of_Year          INT             NOT NULL,
  Quarter               INT             NOT NULL,
  is_Weekend            INT             NOT NULL,
  is_Holiday            INT             NOT NULL,
  Weekday_Name          VARCHAR(30)     NOT NULL,
  Weekday_Num           INT             NOT NULL
);

CREATE TABLE HOUR
(
  Hour_id               VARCHAR(8)      PRIMARY KEY,
  Hour_Format_HHMMSS    VARCHAR(8)      NOT NULL,
  Hour                  INT             NOT NULL,
  Minute                INT             NOT NULL,
  Second                INT             NOT NULL
);

CREATE TABLE PAYMENT_METHOD
(
  Payment_id            INT             PRIMARY KEY,
  Payment_Type          VARCHAR(20)     NOT NULL,
  Payment_Installments  INT             NOT NULL
);

CREATE TABLE CUSTOMER
(
  Customer_id               INT             PRIMARY KEY,
  Customer_Code             VARCHAR(32)     NOT NULL,
  Customer_Unique_Code      VARCHAR(32)     NOT NULL,
  Customer_State            VARCHAR(32)     NOT NULL,
  Customer_City             VARCHAR(32)     NOT NULL,
  Customer_Zip_Code_Prefix  INT             NOT NULL
);

CREATE TABLE ORDERS
(
  Order_id                  VARCHAR(32) PRIMARY KEY,
  Customer_id               INT             NOT NULL,
  Purchase_Timestamp_Date   VARCHAR(10)     ,
  Purchase_Timestamp_Hour   VARCHAR(8)      ,
  Approved_Payment_Date     VARCHAR(10)     ,
  Approved_Payment_Hour     VARCHAR(8)      ,
  Delivered_Carrier_Date    VARCHAR(10)     ,
  Delivered_Carrier_Hour    VARCHAR(8)      ,
  Delivered_Customer_Date   VARCHAR(10)     ,
  Delivered_Customer_Hour   VARCHAR(8)      ,
  Estimated_Delivery_Date   VARCHAR(10)     ,
  Estimated_Delivery_Hour   VARCHAR(8)      ,
  Payment_id                INT             ,
  Amount_Voucher            FLOAT           ,  
  Total_Price_Order         FLOAT           , 
  Num_Products              INT             ,
  FOREIGN KEY (Purchase_Timestamp_Date) REFERENCES DATE(Date_id),
  FOREIGN KEY (Purchase_Timestamp_Hour) REFERENCES HOUR(Hour_id),
  FOREIGN KEY (Approved_Payment_Date) REFERENCES DATE(Date_id),
  FOREIGN KEY (Approved_Payment_Hour) REFERENCES HOUR(Hour_id),
  FOREIGN KEY (Delivered_Carrier_Date) REFERENCES DATE(Date_id),
  FOREIGN KEY (Delivered_Carrier_Hour) REFERENCES HOUR(Hour_id),
  FOREIGN KEY (Delivered_Customer_Date) REFERENCES DATE(Date_id),
  FOREIGN KEY (Delivered_Customer_Hour) REFERENCES HOUR(Hour_id),
  FOREIGN KEY (Estimated_Delivery_Date) REFERENCES DATE(Date_id),
  FOREIGN KEY (Estimated_Delivery_Hour) REFERENCES HOUR(Hour_id),
  FOREIGN KEY (Payment_id) REFERENCES PAYMENT_METHOD(Payment_id),
  FOREIGN KEY (Customer_id) REFERENCES CUSTOMER(Customer_id)
);

CREATE TABLE SELLER
(
  Seller_id               INT             PRIMARY KEY,
  Seller_Code             VARCHAR(32)     NOT NULL,
  Seller_State            VARCHAR(32)     NOT NULL,
  Seller_City             VARCHAR(32)     NOT NULL,
  Seller_Zip_Code_Prefix  INT             NOT NULL
);


CREATE TABLE PRODUCT
(
  Product_id                    INT             PRIMARY KEY,
  Product_Code                  VARCHAR(32)     NOT NULL,
  Product_Name_Lenght           INT             NOT NULL,
  Product_Description_Lenght    INT             NOT NULL,
  Product_Photos_qty            INT             NOT NULL,
  Product_Weight_g              INT             NOT NULL,
  Product_Length_cm             INT             NOT NULL,
  Product_Height_cm             INT             NOT NULL,
  Product_Width_cm              INT             NOT NULL,
  Category_Name_ENG             VARCHAR(50)     NOT NULL,
  Category_Name_PORT            VARCHAR(50)     NOT NULL
);


CREATE TABLE PRODUCT_SALE
(
  Order_id                  VARCHAR(32)     ,
  Product_id                INT             ,
  Customer_id               INT             ,
  Seller_id                 INT             ,
  Date_Sale_id              VARCHAR(10)     ,
  Hour_Sale_id              VARCHAR(8)      ,
  Price                     FLOAT           , 
  Order_Item                INT             ,
  Freight_Value             FLOAT           , 
  FOREIGN KEY (Product_id) REFERENCES PRODUCT(Product_id),
  FOREIGN KEY (Customer_id) REFERENCES CUSTOMER(Customer_id),
  FOREIGN KEY (Seller_id) REFERENCES SELLER(Seller_id),
  FOREIGN KEY (Date_Sale_id) REFERENCES DATE(Date_id),
  FOREIGN KEY (Hour_Sale_id) REFERENCES HOUR(Hour_id)
);

CREATE TABLE REVIEW
(
  Review_id                    INT              PRIMARY KEY,
  Review_Code                  VARCHAR(32)      NOT NULL,
  Review_Comment_Title         VARCHAR(250)     ,
  Review_Comment_Message       VARCHAR(250)     
);


CREATE TABLE REVIEW_ORDER
(
  Order_id                      VARCHAR(32)     ,
  Review_id                     INT             ,
  Customer_id                   INT             ,
  Date_Permit_Review            VARCHAR(10)     ,
  Hour_Permit_Review            VARCHAR(8)      ,
  Date_Answer_review            VARCHAR(10)     ,
  Hour_Answer_Review            VARCHAR(8)      ,
  Score                         INT             ,
  FOREIGN KEY (Review_id) REFERENCES REVIEW(Review_id),
  FOREIGN KEY (Customer_id) REFERENCES CUSTOMER(Customer_id),
  FOREIGN KEY (Date_Permit_Review) REFERENCES DATE(Date_id),
  FOREIGN KEY (Hour_Permit_Review) REFERENCES HOUR(Hour_id),
  FOREIGN KEY (Date_Answer_review) REFERENCES DATE(Date_id),
  FOREIGN KEY (Hour_Answer_Review) REFERENCES HOUR(Hour_id)
);