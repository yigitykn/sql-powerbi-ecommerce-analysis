-- Customer Profit Margin Analysis
WITH customer_sales AS (
SELECT
    f.customer_id,
    d.year,
    ROUND(SUM(f.net_sales),2) AS net_sales,
    ROUND(SUM(f.profit),2) AS profit
FROM `seraphic-result-479320-t2.ecommerce_data_warehouse.fact_sales` f
JOIN `seraphic-result-479320-t2.ecommerce_data_warehouse.dim_date` d
    ON f.date_key = d.date_key
WHERE f.order_status = 'delivered'
AND f.is_returned = FALSE
GROUP BY f.customer_id, d.year
)

(SELECT
    'Highest Profit Margin - 2024' AS analysis_type,
    customer_id,
    net_sales,
    profit,
    ROUND(SAFE_DIVIDE(profit, net_sales) * 100,2) AS profit_margin
FROM customer_sales
WHERE year = 2024
ORDER BY profit_margin DESC
LIMIT 10)

UNION ALL

(SELECT
    'Lowest Profit Margin - 2024' AS analysis_type,
    customer_id,
    net_sales,
    profit,
    ROUND(SAFE_DIVIDE(profit, net_sales) * 100,2) AS profit_margin
FROM customer_sales
WHERE year = 2024
ORDER BY profit_margin ASC
LIMIT 10)

UNION ALL

(SELECT
    'Highest Profit Margin - 2025' AS analysis_type,
    customer_id,
    net_sales,
    profit,
    ROUND(SAFE_DIVIDE(profit, net_sales) * 100,2) AS profit_margin
FROM customer_sales
WHERE year = 2025
ORDER BY profit_margin DESC
LIMIT 10)

UNION ALL

(SELECT
    'Lowest Profit Margin - 2025' AS analysis_type,
    customer_id,
    net_sales,
    profit,
    ROUND(SAFE_DIVIDE(profit, net_sales) * 100,2) AS profit_margin
FROM customer_sales
WHERE year = 2025
ORDER BY profit_margin ASC
LIMIT 10);

-- Customer Order Frequency
WITH customer_orders AS (
SELECT
    f.customer_id,
    COUNT(DISTINCT (order_id)) AS count_order
FROM `seraphic-result-479320-t2.ecommerce_data_warehouse.fact_sales` f
JOIN `seraphic-result-479320-t2.ecommerce_data_warehouse.dim_date` d
ON f.date_key = d.date_key
WHERE d.year = 2024
AND order_status = 'delivered'
AND is_returned = FALSE
GROUP BY f.customer_id
)

SELECT
    count_order,
    COUNT(*) AS count_customer
FROM customer_orders
GROUP BY count_order
ORDER BY count_order;

-- Customer Lifetime Value Distribution
WITH customer_lifetime_value AS (
SELECT
    f.customer_id,
    ROUND(SUM(f.net_sales), 2) AS lifetime_value
FROM `seraphic-result-479320-t2.ecommerce_data_warehouse.fact_sales` f
WHERE f.order_status = 'delivered'
AND f.is_returned = FALSE
GROUP BY f.customer_id
)

SELECT
    CASE
    WHEN lifetime_value < 2500 THEN '0-2499'
    WHEN lifetime_value < 5000 THEN '2500-4999'
    WHEN lifetime_value < 10000 THEN '5000-9999'
    WHEN lifetime_value < 20000 THEN '10000-19999'
    WHEN lifetime_value < 50000 THEN '20000-49999'
    ELSE '50000+'
    END AS sales_range,
    COUNT(*) AS customer_count
FROM customer_lifetime_value
GROUP BY sales_range
ORDER BY sales_range;







