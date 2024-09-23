DROP DATABASE IF EXISTS `Final_Project`;
CREATE DATABASE IF NOT EXISTS `Final_Project`;
USE `Final_Project`;

CREATE TABLE `Coffee`(
	`Area Code` INT,
    `Cogs` INT,
    `Difference Between Actual and Target Profit` INT,
    `Date` DATE,
    `Inventory Margin` INT,
    `Margin` INT,
    `Market_size` VARCHAR(255),
	`Market` VARCHAR(255),
    `Marketing` INT,
    `Product_line` VARCHAR(255),
    `Product_type` VARCHAR(255),
    `Product` VARCHAR(255),
    `Profit` INT,
    `Sales` INT,
    `State` VARCHAR(255),
    `Target_cogs` INT,
    `Target_margin` INT,
    `Target_profit` INT,
    `Target_sales` INT,
    `Total_expenses` INT,
    `Type` VARCHAR(255));
    
SET GLOBAL local_infile = TRUE;

LOAD DATA LOCAL INFILE "C:/Users/KenKY_Chi/Desktop/HW/6030/Coffee_Chain_Sales .csv"
INTO TABLE `Coffee`
	FIELDS TERMINATED BY ',' 
	LINES TERMINATED BY '\n' 
	IGNORE 1 LINES
    (`Area Code`, `Cogs`, `Difference Between Actual and Target Profit`, @Date, `Inventory Margin`, `Margin`, 
    `Market_size`, `Market`, `Marketing`, `Product_line`, `Product_type`, `Product`, `Profit`, `Sales`, `State`, 
    `Target_cogs`, `Target_margin`, `Target_profit`, `Target_sales`, `Total_expenses`, `Type`)
    SET `Date` = STR_TO_DATE(@Date, '%m/%d/%Y');
-- -------------------------------------------------------------------
-- CREATE TABLES & INSERT DATA -----------------------------------------------------
-- -------------------------------------------------------------------
CREATE TABLE `Product_line` (
	`Product_line_ID` INT AUTO_INCREMENT PRIMARY KEY,
    `Product_line` VARCHAR(255)
);

INSERT INTO `Product_line` (`Product_line`)
SELECT DISTINCT `Product_line` FROM `Coffee`;

CREATE TABLE `Product_type` (
	`Product_type_ID` INT AUTO_INCREMENT PRIMARY KEY,
    `Product_type` VARCHAR(255)
);

INSERT INTO `Product_type` (`Product_type`)
SELECT DISTINCT `Product_type` FROM `Coffee`;

CREATE TABLE `Product` (
    `Product_ID` INT AUTO_INCREMENT PRIMARY KEY,
    `Product_line_ID` INT,
    `Product_type_ID` INT,
    `Product` VARCHAR(255),
    FOREIGN KEY (`Product_line_ID`) REFERENCES `Product_line`(`Product_line_ID`),
    FOREIGN KEY (`Product_type_ID`) REFERENCES `Product_type`(`Product_type_ID`));

INSERT INTO `Product` (`Product_line_ID`, `Product_type_ID`, `Product`)
SELECT DISTINCT
    pl.`Product_line_ID`,
    pt.`Product_type_ID`,
    c.`Product`
FROM 
    `Coffee` c
    JOIN `Product_line` pl ON c.`Product_line` = pl.`Product_line`
    JOIN `Product_type` pt ON c.`Product_type` = pt.`Product_type`;

CREATE TABLE `Market_size` (
    `Market_size_ID` INT AUTO_INCREMENT PRIMARY KEY,
    `Market_size` VARCHAR(255)
);

INSERT INTO `Market_size` (`Market_size`)
SELECT DISTINCT `Market_size` FROM `Coffee`;


CREATE TABLE `Market_type` (
	`Market_type_ID` INT AUTO_INCREMENT PRIMARY KEY,
    `Market` VARCHAR(255)
);


INSERT INTO `Market_type` (`Market`)
SELECT DISTINCT `Market` FROM `Coffee`;

CREATE TABLE `State` (
    `State_ID` INT AUTO_INCREMENT PRIMARY KEY,
    `State` VARCHAR(255)
);

INSERT INTO `State` (`State`)
SELECT DISTINCT `State` FROM `Coffee`;

CREATE TABLE `Market` (
    `Market_ID` INT AUTO_INCREMENT PRIMARY KEY,
    `Market_size_ID` INT,
    `Market_type_ID` INT,
    `State_ID` INT,
    `Marketing` INT,
    FOREIGN KEY (`Market_size_ID`) REFERENCES `Market_size`(`Market_size_ID`),
    FOREIGN KEY (`Market_type_ID`) REFERENCES `Market_type`(`Market_type_ID`),
    FOREIGN KEY (`State_ID`) REFERENCES `State`(`State_ID`)
);

INSERT INTO `Market` (`Market_size_ID`, `Market_type_ID`, `State_ID`, `Marketing`)
SELECT 
    ms.`Market_size_ID`,
    mt.`Market_type_ID`,
    ss.`State_ID`,
    c.`Marketing`
FROM 
    `Coffee` c
    JOIN `Market_size` ms ON c.`Market_size` = ms.`Market_size`
    JOIN `Market_type` mt ON c.`Market` = mt.`Market`
    JOIN `State` ss ON c.`State` = ss.`State`;

CREATE TABLE `Sales` (
    `Sales_ID` INT AUTO_INCREMENT PRIMARY KEY,
    `Date` DATE,
    `Inventory Margin` INT,
    `Margin` INT,
    `Profit` INT,
    `Sales` INT,
    `Cogs` INT,
    `Difference Between Actual and Target Profit` INT,
    `Total_expenses` INT,
    `Type` VARCHAR(255),
    `Product_ID` INT,
    `Market_size_ID` INT,
    `State_ID` INT,
    FOREIGN KEY (`Product_ID`) REFERENCES `Product`(`Product_ID`),
    FOREIGN KEY (`Market_size_ID`) REFERENCES `Market`(`Market_size_ID`),
    FOREIGN KEY (`State_ID`) REFERENCES `State`(`State_ID`)
);

INSERT INTO `Sales` (`Date`, `Inventory Margin`, `Margin`, `Profit`, `Sales`, `Cogs`, `Difference Between Actual and Target Profit`, `Total_expenses`, `Type`, `Product_ID`, `Market_size_ID`, `State_ID`)
SELECT
    c.`Date`,
    c.`Inventory Margin`,
    c.`Margin`,
    c.`Profit`,
    c.`Sales`,
    c.`Cogs`,
    c.`Difference Between Actual and Target Profit`,
    c.`Total_expenses`,
    c.`Type`,
    p.`Product_ID`,
    m.`Market_size_ID`,
    st.`State_ID`
FROM
    `Coffee` c
    INNER JOIN `Product` p ON c.`Product` = p.`Product`
    INNER JOIN `Market_size` m ON c.`Market_size` = m.`Market_size`
    JOIN `State` st ON c.`State` = st.`State`;

CREATE TABLE `Target` (
    `Target_ID` INT AUTO_INCREMENT PRIMARY KEY,
    `Date` DATE,
    `Area Code` INT,
    `Target_cogs` INT,
    `Target_margin` INT,
    `Target_profit` INT,
    `Target_sales` INT,
    `Product_ID` INT,
    FOREIGN KEY (`Product_ID`) REFERENCES `Product`(`Product_ID`)
);

INSERT INTO `Target`(`Date`, `Area Code`, `Target_cogs`, `Target_margin`, `Target_profit`, `Target_sales`, `Product_ID`)
SELECT 
	c.`Date`,
    c.`Area Code`, 
    c.`Target_cogs`, 
    c.`Target_margin`,
    c.`Target_profit`, 
    c.`Target_sales`,
    p.`Product_ID`
FROM
	`Coffee` c
    JOIN `Product` p ON c.`Product` = p.`Product`;
    
-- -------------------------------------------------------------------
-- Business Questions-------------------------------------------------
-- -------------------------------------------------------------------
USE Final_Project;

-- KEY PERFORMANCE INDICATORS(KPIs) -- Overall Total Expenses , Margin , Sales ,Profit  & COGS

SELECT
  SUM(Total_expenses) AS Overall_Total_Expenses,
  SUM(Margin) AS Overall_Margin,
  SUM(Sales) AS Overall_Sales,
  SUM(Profit) AS Overall_Profit,
  SUM(Cogs) AS Overall_COGS
FROM Sales;

-- Q1. Product Sales Performance : Which are the best performing products based on Sales revenue ?
SELECT
    p.`Product`,
    SUM(s.`Sales`) AS TotalSales
FROM
    `Product` p
JOIN `Sales` s ON p.`Product_ID` = s.`Product_ID`
GROUP BY
  p.`Product` 
ORDER BY TotalSales DESC;

-- Q2. Product Line Performance: How does each product line contribute to the overall profit margin?

SELECT 
    pl.Product_line,
    SUM(s.Profit) AS TotalProfit,
    (SUM(s.Profit) / (SELECT SUM(Profit) FROM Sales) * 100) 
    AS ProfitMarginPercentage
FROM Sales s
JOIN Product p ON s.Product_ID = p.Product_ID
JOIN Product_line pl ON p.Product_line_ID = pl.Product_line_ID
GROUP BY pl.Product_line
ORDER BY TotalProfit DESC;

-- Q3. Which product types are the most profitable, and which are the most popular based on sales volume?

SELECT 
    pt.Product_type,
    SUM(s.Sales) AS TotalSalesVolume,
    SUM(s.Profit) AS TotalProfit
FROM Sales s
JOIN Product p ON s.Product_ID = p.Product_ID
JOIN Product_type pt ON p.Product_type_ID = pt.Product_type_ID
GROUP BY pt.Product_type
ORDER BY TotalProfit DESC, TotalSalesVolume DESC;

-- Q4. State Sales Comparison & Performance: Which states has the highest contribution to Sales & Profit and how do their expenses compare to Sales?
SELECT 
    st.State,
    SUM(s.Sales) AS TotalSales,
	SUM(s.Profit) AS TotalProfit,
    SUM(Total_expenses) as TotalExpenses
FROM Sales s
JOIN State st ON s.State_ID = st.State_ID
GROUP BY st.State
ORDER BY TotalSales DESC , TotalProfit DESC;


-- Q5. Market Analysis: How do sales volumes vary across different market sizes ?
SELECT 
	ms.Market_size , sum(s.Sales) as TotalSales 
FROM Sales s
JOIN
	Market_size ms ON s.Market_size_ID = ms.Market_size_ID
GROUP BY ms.Market_size 
ORDER BY TotalSales desc;

-- Q6. Target Sales Achievement: Which products  are consistently meeting or exceeding sales targets?
SELECT 
    p.Product,
    SUM(s.Sales) AS ActualSales,
    SUM(t.Target_sales) AS TargetSales,
	(SUM(s.Sales) - SUM(t.Target_sales)) AS TargetDifference
FROM Sales s
JOIN Product p ON s.Product_ID = p.Product_ID
JOIN Target t ON p.Product_ID = t.Product_ID 
GROUP BY p.Product
HAVING SUM(s.Sales) >= SUM(t.Target_sales)
ORDER BY TargetDifference DESC;

-- Q7. Target Profit Achievement: Which products are consistently meeting or exceeding profits?
SELECT 
    p.Product,
    SUM(s.Profit) AS ActualProfit,
    SUM(t.Target_profit) AS TargetProfit,
    SUM(s.`Difference Between Actual and Target Profit`) 
AS TotalProfitDifference 
FROM Sales s
JOIN Product p ON s.Product_ID = p.Product_ID
JOIN Target t ON p.Product_ID = t.Product_ID 
GROUP BY p.Product 
HAVING TotalProfitDifference >=0  
ORDER BY TotalProfitDifference DESC;

-- Q8. Seasonal Trends: Are there any seasonal patterns in sales over the years, and how do they align with inventory margins?

SELECT 
    YEAR(s.Date) AS SaleYear, 
    SUM(s.Sales) AS TotalSales,
    AVG(s.`Inventory Margin`) AS AverageInventoryMargin
FROM Sales s
GROUP BY YEAR(s.Date)  
ORDER BY YEAR(s.Date);  


-- Q9. Expense Management: How do total expenses relate to the overall profit in each market?
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
SELECT 
    mt.Market, 
    SUM(s.Total_expenses) AS TotalExpenses,
    SUM(s.Profit) AS TotalProfit,
    (SUM(s.Profit) - SUM(s.Total_expenses)) AS NetProfit
FROM Sales s
JOIN Market m ON s.Market_size_ID = m.Market_size_ID
JOIN Market_type mt ON m.Market_type_ID = mt.Market_type_ID
GROUP BY  mt.Market
ORDER BY mt.Market;

-- Q10. Inventory and Sales Correlation: Is there a correlation between inventory margin and sales volume in different product lines?

SELECT 
    pl.Product_line,
    SUM(s.Sales) AS TotalSalesVolume,
    AVG(s.`Inventory Margin`) AS AverageInventoryMargin 
FROM Sales s
JOIN Product p ON s.Product_ID = p.Product_ID
JOIN Product_line pl ON p.Product_line_ID = pl.Product_line_ID
GROUP BY pl.Product_line
ORDER BY pl.Product_line;