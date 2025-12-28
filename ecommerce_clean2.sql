SELECT *
FROM ecommerce_sales;

-- DATA CLEANING
-- 1. Row count
SELECT COUNT(*)
FROM ecommerce_sales;

SELECT COUNT(DISTINCT product)
FROM ecommerce_sales;

SELECT COUNT(DISTINCT CONCAT(city, product))
FROM ecommerce_sales;

-- 2. Check for missings values and nullify them
SELECT COUNT(*)
FROM ecommerce_sales
WHERE price IS NULL;

 -- 3. Check for missing strings
SELECT *
FROM ecommerce_sales
WHERE category = '';

SELECT COUNT(*) as empty_count 
FROM ecommerce_sales 
WHERE price = '';

-- 4. Check for duplicates and remove unwanted duplicates
SELECT 
    product, 
    category, 
    COUNT(*) as duplicate_count
FROM ecommerce_sales
GROUP BY product, category
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;

SELECT 
    *,
    ROW_NUMBER() OVER (
        PARTITION BY product, category, price
        ORDER BY order_id  
    ) as row_num
FROM ecommerce_sales; 

ALTER TABLE ecommerce_sales
ADD row_num INT;
 
ALTER TABLE ecommerce_sales
DROP COLUMN row_num;

-- Duplicate removal 

CREATE TABLE ecommerce_clean2 AS
SELECT DISTINCT order_id, product, category, brand, platform, city, price, quantity, total_amount, rating, reviews, order_date
FROM ecommerce_sales;

DROP TABLE ecommerce_sales;
ALTER TABLE ecommerce_clean2 RENAME TO ecommerce_sales2;

SELECT * 
FROM ecommerce_sales2;

-- 7. Check for extra spaces
SELECT 
    SUM(CASE WHEN price LIKE ' %' THEN 1 ELSE 0 END) as leading_spaces,
    SUM(CASE WHEN price LIKE '% ' THEN 1 ELSE 0 END) as trailing_spaces,
    SUM(CASE WHEN order_id LIKE ' %' OR order_id LIKE '% ' THEN 1 ELSE 0 END) as total_affected
FROM ecommerce_sales2;








