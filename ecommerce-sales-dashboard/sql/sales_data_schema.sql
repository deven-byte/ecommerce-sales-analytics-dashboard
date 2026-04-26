CREATE DATABASE ecommerce_db;
USE ecommerce_db;

CREATE TABLE sales_data (
Order_Id INT PRIMARY KEY,
Order_Date DATE,
Full_Name VARCHAR(100),
City VARCHAR(50),
State VARCHAR(50),
Category VARCHAR(50),
Product VARCHAR(100),
Quantity INT,
Unit_Price DECIMAL(10,2),
Discount INT,
Sales DECIMAL(12,2),
Profit DECIMAL(12,2),
Payment_Mode VARCHAR(50),
Month VARCHAR(10),
Year INT,
Quarter VARCHAR(5)
);
