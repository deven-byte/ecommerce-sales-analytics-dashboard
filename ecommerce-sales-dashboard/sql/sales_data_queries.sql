USE ecommerce_db;

-- 1. Total Orders, Sales, Profit
SELECT 
COUNT(*) AS Total_Orders,
ROUND(SUM(Sales),2) AS Total_Sales,
ROUND(SUM(Profit),2) AS Total_Profit
FROM sales_data;

-- 2. Average Order Value
SELECT 
ROUND(SUM(Sales)/COUNT(*),2) AS Avg_Order_Value
FROM sales_data;

-- 3. Top 10 Categories by Revenue
SELECT 
Category,
ROUND(SUM(Sales),2) AS Revenue
FROM sales_data
GROUP BY Category
ORDER BY Revenue DESC
LIMIT 10;

-- 4. Top 10 Products by Revenue
SELECT 
Product,
ROUND(SUM(Sales),2) AS Revenue
FROM sales_data
GROUP BY Product
ORDER BY Revenue DESC
LIMIT 10;

-- 5. Top 10 Products by Profit
SELECT 
Product,
ROUND(SUM(Profit),2) AS Profit
FROM sales_data
GROUP BY Product
ORDER BY Profit DESC
LIMIT 10;

-- 6. Bottom 10 Products by Profit
SELECT 
Product,
ROUND(SUM(Profit),2) AS Profit
FROM sales_data
GROUP BY Product
ORDER BY Profit ASC
LIMIT 10;

-- 7. Sales by State
SELECT 
State,
ROUND(SUM(Sales),2) AS Revenue
FROM sales_data
GROUP BY State
ORDER BY Revenue DESC;

-- 8. Top 10 Cities by Revenue
SELECT 
City,
ROUND(SUM(Sales),2) AS Revenue
FROM sales_data
GROUP BY City
ORDER BY Revenue DESC
LIMIT 10;

-- 9. Top 10 Cities by Orders
SELECT 
City,
COUNT(*) AS Orders_Count
FROM sales_data
GROUP BY City
ORDER BY Orders_Count DESC
LIMIT 10;

-- 10. Monthly Sales Trend
SELECT 
YEAR(Order_Date) AS Year_No,
MONTH(Order_Date) AS Month_No,
ROUND(SUM(Sales),2) AS Revenue
FROM sales_data
GROUP BY YEAR(Order_Date), MONTH(Order_Date)
ORDER BY Year_No, Month_No;

-- 11. Quarter-wise Performance
SELECT 
QUARTER(Order_Date) AS Quarter_No,
ROUND(SUM(Sales),2) AS Revenue,
ROUND(SUM(Profit),2) AS Profit
FROM sales_data
GROUP BY QUARTER(Order_Date)
ORDER BY Quarter_No;

-- 12. Payment Mode Share
SELECT 
Payment_Mode,
COUNT(*) AS Orders_Count,
ROUND(SUM(Sales),2) AS Revenue
FROM sales_data
GROUP BY Payment_Mode
ORDER BY Orders_Count DESC;

-- 13. Highest Discount Categories
SELECT 
Category,
ROUND(AVG(Discount),2) AS Avg_Discount
FROM sales_data
GROUP BY Category
ORDER BY Avg_Discount DESC;

-- 14. Profit Margin by Category
SELECT 
Category,
ROUND(SUM(Profit)/SUM(Sales)*100,2) AS Profit_Margin_Percent
FROM sales_data
GROUP BY Category
ORDER BY Profit_Margin_Percent DESC;

-- 15. Repeat Customers (same customer more than 1 order)
SELECT 
Full_Name,
COUNT(*) AS Orders_Count,
ROUND(SUM(Sales),2) AS Total_Spent
FROM sales_data
GROUP BY Full_Name
HAVING COUNT(*) > 1
ORDER BY Orders_Count DESC, Total_Spent DESC
LIMIT 20;

-- 16. Top Customers by Spending
SELECT 
Full_Name,
ROUND(SUM(Sales),2) AS Total_Spent
FROM sales_data
GROUP BY Full_Name
ORDER BY Total_Spent DESC
LIMIT 10;

-- 17. Orders Above Average Sales Value
SELECT *
FROM sales_data
WHERE Sales > (SELECT AVG(Sales) FROM sales_data);

-- 18. State-wise Rank by Revenue
SELECT 
State,
ROUND(SUM(Sales),2) AS Revenue,
RANK() OVER (ORDER BY SUM(Sales) DESC) AS Revenue_Rank
FROM sales_data
GROUP BY State;

-- 19. Running Monthly Revenue
SELECT 
YEAR(Order_Date) AS Year_No,
MONTH(Order_Date) AS Month_No,
ROUND(SUM(Sales),2) AS Monthly_Revenue,
ROUND(
SUM(SUM(Sales)) OVER (
ORDER BY YEAR(Order_Date), MONTH(Order_Date)
),2) AS Running_Revenue
FROM sales_data
GROUP BY YEAR(Order_Date), MONTH(Order_Date);

-- 20. Best Selling Product in Each Category
WITH cte AS (
SELECT 
Category,
Product,
SUM(Sales) AS Revenue,
RANK() OVER(PARTITION BY Category ORDER BY SUM(Sales) DESC) AS rn
FROM sales_data
GROUP BY Category, Product
)
SELECT Category, Product, ROUND(Revenue,2) AS Revenue
FROM cte
WHERE rn = 1;

-- 21. Weekend vs Weekday Sales
SELECT 
CASE 
WHEN DAYOFWEEK(Order_Date) IN (1,7) THEN 'Weekend'
ELSE 'Weekday'
END AS Day_Type,
ROUND(SUM(Sales),2) AS Revenue
FROM sales_data
GROUP BY Day_Type;

-- 22. Highest Single Order Value
SELECT *
FROM sales_data
ORDER BY Sales DESC
LIMIT 1;

-- 23. Low Performing States (Below Average Revenue)
SELECT 
State,
ROUND(SUM(Sales),2) AS Revenue
FROM sales_data
GROUP BY State
HAVING SUM(Sales) < (
SELECT AVG(StateRevenue)
FROM (
SELECT SUM(Sales) AS StateRevenue
FROM sales_data
GROUP BY State
) x
);

-- 24. Customer Segmenting by Spend
SELECT 
Full_Name,
ROUND(SUM(Sales),2) AS Total_Spent,
CASE
WHEN SUM(Sales) >= 100000 THEN 'Premium'
WHEN SUM(Sales) >= 50000 THEN 'Regular'
ELSE 'Basic'
END AS Customer_Type
FROM sales_data
GROUP BY Full_Name
ORDER BY Total_Spent DESC;

-- 25. Most Popular Product by Quantity Sold
SELECT 
Product,
SUM(Quantity) AS Units_Sold
FROM sales_data
GROUP BY Product
ORDER BY Units_Sold DESC
LIMIT 10;