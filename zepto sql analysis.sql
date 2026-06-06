-- 1. Database & Table Creation
drop table if exists zepto;

create table zepto (
sku_id SERIAL PRIMARY KEY,
category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp NUMERIC(8,2),
discountPercent NUMERIC(5,2),
availableQuantity INTEGER,
discountedSellingPrice NUMERIC(8,2),
weightInGms INTEGER,
outOfStock BOOLEAN,	
quantity INTEGER
);
--2. load data 
-- 3. 🔍 Data Exploration
-- Counted the total number of records in the dataset
select count(*) from zepto;
-- Viewed a sample of the dataset to understand structure and content

select * from zepto;
SELECT * FROM zepto LIMIT 10;

-- Checked for null values across all columns
select * from zepto
where category is null
or
name is null
or
mrp is null
or
discountPercent is null
or
availableQuantity Is null
or
discountedSellingPrice is null
or
weightInGms is null
or
outOfStock is null
or
quantity is null;




-- Identified distinct product categories available in the dataset
select distinct category
from zepto
order by category;



-- Compared in-stock vs out-of-stock product counts
select outofstock, count(sku_id) 
from zepto
group by outofstock;

-- Detected products present multiple times, representing different SKUs
select name ,count(sku_id) 
from zepto
group by name 
having count(sku_id) >1
order by count(sku_id) desc
limit 10;

-- 4. 🧹 Data Cleaning
-- Identified and removed rows where MRP or discounted selling price was zero
select * from zepto
where mrp = 0;

delete  from zepto
where sku_id = 3607;


-- Converted mrp and discountedSellingPrice from paise to rupees for consistency and readability
update zepto
set mrp = mrp/100.0,
discountedSellingPrice = discountedSellingPrice/100.0;

select * from zepto;


-- 5. 📊 Business Insights
-- Found top 10 best-value products based on discount percentage
select distinct name ,mrp, discountpercent
from zepto
order by discountpercent desc
limit 10;


-- Identified high-MRP products that are currently out of stock
select name , mrp, outofstock
from zepto
where outofstock = TRUE
order by mrp desc;

-- Estimated potential revenue for each product category
select category , 
sum(discountedSellingPrice * availablequantity) as totalrevenue
from zepto
group by category
order by totalrevenue ;



-- Filtered expensive products (MRP > ₹500) with minimal discount
select name,mrp,discountpercent from zepto
where mrp > 500
order by discountpercent asc;

SELECT name, mrp, discountpercent
FROM zepto
WHERE mrp > 500
  AND discountpercent = (
      SELECT MIN(discountpercent)
      FROM zepto
      WHERE mrp > 500
  );


-- Ranked top 5 categories offering highest average discounts
select category, 
Round(avg(discountpercent),2) as avg_discount
from zepto
group by category
order by avg_discount desc
limit 5;

-- . Find the price per gram for products above 100g and sort by best value.
SELECT DISTINCT name, weightInGms, discountedSellingPrice,
ROUND(discountedSellingPrice/weightInGms,2) AS price_per_gram
FROM zepto
WHERE weightInGms >= 100
ORDER BY price_per_gram;

--.Group the products into categories like Low, Medium, Bulk.
SELECT DISTINCT name, weightInGms,
CASE WHEN weightInGms < 1000 THEN 'Low'
	WHEN weightInGms < 5000 THEN 'Medium'
	ELSE 'Bulk'
	END AS weight_category
FROM zepto;

--.What is the Total Inventory Weight Per Category 
SELECT category,
SUM(weightInGms * availableQuantity) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight;




