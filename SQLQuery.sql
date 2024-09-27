SELECT *
FROM retail_sales

SELECT COUNT(*) 
FROM retail_sales


-- Data Cleaning
SELECT *
FROM Retail_sales
WHERE  transactions_id IS NULL 
	OR 
	sale_date IS NULL 
	or 
	sale_time IS NULL 
	or 
	customer_id IS NULL 
	OR 
	gender IS NULL 
	OR 
	age IS NULL 
	OR 
	category IS NULL
	OR 
	quantiy IS NULL 
	OR 
	price_per_unit IS NULL 
	OR 
	cogs IS NULL 
	OR 
	total_sale IS NULL

--Replace the NULL in the age column with the average age in a created new column
SELECT *, 
CASE 
	WHEN age IS NULL THEN (SELECT AVG(age) FROM Retail_sales)
	ELSE age
	END AS age_replace
FROM Retail_sales

--Replace the NULL in the age column with the average age 
SELECT *, 
	COALESCE (age, (SELECT AVG(age) FROM Retail_sales)) AS age_replace
FROM Retail_sales

--Replace the NULL in the age column with the average age and Update the table
UPDATE 
	Retail_sales
SET 
	age = (SELECT AVG(age) FROM Retail_sales)
WHERE age IS NULL

--Delete other rows with NULL
DELETE 
FROM Retail_sales 
WHERE transactions_id IS NULL 
	OR 
	sale_date IS NULL 
	or 
	sale_time IS NULL 
	or 
	customer_id IS NULL 
	OR 
	gender IS NULL 
	OR 
	age IS NULL 
	OR 
	category IS NULL
	OR 
	quantiy IS NULL 
	OR 
	price_per_unit IS NULL 
	OR 
	cogs IS NULL 
	OR 
	total_sale IS NULL

--perform Exploratory Data Analysis (EDA)
-- How many sales we have?
SELECT 
	COUNT(*) 
FROM Retail_sales  

-- How many uniuque customers do we have ?
SELECT 
	COUNT(DISTINCT customer_id) 
FROM Retail_sales 

-- how many category do we have?
SELECT 
	category,  
	Count(*) AS sales
FROM retail_sales
GROUP BY 
	category

--OR
SELECT DISTINCT category FROM retail_sales


-- Data Analysis & Business Key Problems & Answers


-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05'

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 3 in the month of Nov-2022
SELECT *
FROM retail_sales
WHERE 
	category = 'Clothing' 
	AND 
	FORMAT(sale_date,'yyyy-MM') = '2022-11' 
	AND
	quantiy >3;


-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT 
	category, 
	SUM(total_sale) as net_sale,
    COUNT(*) as total_orders
FROM retail_sales
GROUP BY category
ORDER BY category


-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT  AVG(age)
FROM retail_sales
WHERE category = 'beauty'


-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT *
FROM retail_sales
WHERE total_sale = 1000


-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT 
    category,
    gender,
    COUNT(*) as total_trans
FROM retail_sales
GROUP 
    BY 
   category,
    gender
ORDER BY 1

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year


SELECT 
	year_totalsales, 
	mm_totalsales,
	Avg_sales
FROM 
(
 SELECT 
        DATEPART(YEAR, sale_date) AS year_totalsales,
        DATEPART(MONTH, sale_date) AS mm_totalsales, 
        AVG(total_sale) AS Avg_sales, 
        RANK() OVER (PARTITION BY DATEPART(YEAR, sale_date) ORDER BY AVG(total_sale) DESC) AS RANK_val
FROM retail_sales
GROUP BY DATEPART(YEAR, sale_date), DATEPART(MONTH, sale_date)
) AS MonthlySales
WHERE RANK_val = 1;




-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales
SELECT  
	TOP(5) customer_id,
	SUM(total_sale) AS total_sales
FROM Retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC



-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT 
	category, 
	COUNT(DISTINCT customer_id) AS unique_cust
FROM Retail_sales
GROUP BY category
ORDER BY  unique_cust DESC



-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

SELECT time_shift, COUNT(*) AS no_of_orders
FROM
(
SELECT *,
	CASE 
	WHEN  DATEPART(HOUR, sale_time)  <= 12 THEN 'Morning'
    WHEN  DATEPART(HOUR, sale_time) BETWEEN 12 AND 17 THEN  'Afternoon'
	ELSE  'Evening'
	END AS time_shift
FROM Retail_sales
) ShiftedSales
GROUP BY time_shift
ORDER BY  no_of_orders DESC


 OR 


 WITH hourly_sale
AS
(
SELECT *,
    CASE
     WHEN  DATEPART(HOUR, sale_time)  <= 12 THEN 'Morning'
	 WHEN  DATEPART(HOUR, sale_time) BETWEEN 12 AND 17 THEN  'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift


