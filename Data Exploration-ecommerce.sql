-- DATA EXPLORATION
SELECT *
FROM ecommerce_sales;

SELECT DISTINCT CITY
FROM ecommerce_sales;

-- City and platform with the highest and lowest performance
SELECT DISTINCT city, platform, brand, category, product,
    SUM(quantity) AS total_sold,
    SUM(quantity * price) AS total_revenue,
    COUNT(reviews) AS review_count
FROM ecommerce_sales
GROUP BY order_id
ORDER BY total_revenue DESC;

-- platform performance
SELECT 
    platform,
    SUM(total_amount) AS total_revenue,
    ROUND(SUM(total_amount) * 100.0 / SUM(SUM(total_amount)) OVER (), 2) AS revenue_percentage
FROM ecommerce_sales
GROUP BY platform
ORDER BY total_revenue DESC
LIMIT 10; 

-- City order performance
SELECT city,
SUM(total_amount) AS total_revenue,
ROUND(SUM(total_amount) * 100.0 / SUM(SUM(total_amount)) OVER (), 2) AS revenue_percentage
FROM ecommerce_sales
GROUP BY city
ORDER BY total_revenue DESC
LIMIT 10;

-- PRODUCT PERFORMANCE
-- Product performance in each city
SELECT product,
SUM(total_amount) AS total_revenue,
ROUND(SUM(total_amount) * 100.0 / SUM(SUM(total_amount)) OVER (), 2) AS revenue_percentage
FROM ecommerce_sales
WHERE city = 'Giza'
GROUP BY product
ORDER BY total_revenue DESC
LIMIT 10;

-- Distinct product performance*
SELECT DISTINCT product, brand,
    SUM(quantity) AS total_sold,
    SUM(quantity * price) AS total_revenue,
	ROUND(AVG(rating), 2) AS avg_rating, 
    COUNT(reviews) AS review_count
FROM ecommerce_sales
GROUP BY order_id
ORDER BY total_revenue DESC;

-- Revenue analysis
SELECT COUNT(*) AS total_orders, 
       SUM(total_amount) AS total_revenue,
       AVG(total_amount) AS avg_order_value
FROM ecommerce_sales; 

SELECT 
    DATE(order_date) AS order_day,
    COUNT(DISTINCT quantity) AS total_orders,
    SUM(total_amount) AS total_revenue,
    AVG(total_amount) AS avg_order_value,
    COUNT(DISTINCT order_id) AS unique_customers
FROM ecommerce_sales
GROUP BY DATE(order_date)
ORDER BY order_day DESC
LIMIT 10;

SELECT DISTINCT
    product,
    SUM(total_amount) AS total_revenue,
    ROUND(SUM(total_amount) * 100.0 / SUM(SUM(total_amount)) OVER (), 2) AS revenue_percentage
FROM ecommerce_sales
GROUP BY product
ORDER BY total_revenue DESC
LIMIT 10; 

-- Monthly Sales Trend with Growth Rate
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS y_month,
    DATE_FORMAT(order_date, '%b %Y') AS month_display,
    SUM(total_amount) AS monthly_sales,
    LAG(SUM(total_amount)) OVER (ORDER BY DATE_FORMAT(order_date, '%Y-%m')) AS prev_month_sales,
    ROUND(
        ((SUM(total_amount) - LAG(SUM(total_amount)) OVER (ORDER BY DATE_FORMAT(order_date, '%Y-%m'))) 
        / LAG(SUM(total_amount)) OVER (ORDER BY DATE_FORMAT(order_date, '%Y-%m'))) * 100, 
        2
    ) AS month_over_month_growth_percent
FROM ecommerce_sales
WHERE YEAR(order_date) = 2024
GROUP BY DATE_FORMAT(order_date, '%Y-%m'), DATE_FORMAT(order_date, '%b %Y')
ORDER BY month_over_month_growth_percent DESC;





