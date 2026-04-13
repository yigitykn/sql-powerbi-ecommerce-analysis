-- Order Value Distribution
WITH order_summary AS (
SELECT
    d.year,
    f.order_id,
    SUM(f.net_sales) AS order_value
FROM `seraphic-result-479320-t2.ecommerce_data_warehouse.fact_sales` f
JOIN `seraphic-result-479320-t2.ecommerce_data_warehouse.dim_date` d
ON f.date_key = d.date_key
WHERE f.order_status = 'delivered'
AND f.is_returned = FALSE
GROUP BY d.year, f.order_id
)

SELECT
year,
CASE
    WHEN order_value < 500 THEN '0-499'
    WHEN order_value < 1000 THEN '500-999'
    WHEN order_value < 2000 THEN '1000-1999'
    WHEN order_value < 3000 THEN '2000-2999'
    WHEN order_value < 5000 THEN '3000-4999'
    ELSE '5000+'
END AS order_value_range,
COUNT(*) AS order_count
FROM order_summary
GROUP BY year, order_value_range
ORDER BY year, order_value_range;

-- Customer Purchase Frequency
WITH customer_orders AS (
SELECT
    customer_id,
    COUNT(DISTINCT order_id) AS order_count
FROM `seraphic-result-479320-t2.ecommerce_data_warehouse.fact_sales`
WHERE order_status = 'delivered'
AND is_returned = FALSE
GROUP BY customer_id
)

SELECT
    CASE
    WHEN order_count = 1 THEN '1'
    WHEN order_count = 2 THEN '2'
    WHEN order_count = 3 THEN '3'
    WHEN order_count = 4 THEN '4'
    WHEN order_count = 5 THEN '5'
    WHEN order_count = 6 THEN '6'
    WHEN order_count = 7 THEN '7'
    WHEN order_count = 8 THEN '8'
    WHEN order_count = 9 THEN '9'
    ELSE '10+'
    END AS order_frequency,
    COUNT(*) AS customer_count
FROM customer_orders
GROUP BY order_frequency
ORDER BY order_frequency;

-- Order Profitability Segments
WITH order_profit AS (
SELECT
    d.year,
    order_id,
    SUM(profit) AS total_profit
FROM `seraphic-result-479320-t2.ecommerce_data_warehouse.fact_sales` f
JOIN `seraphic-result-479320-t2.ecommerce_data_warehouse.dim_date` d
ON f.date_key = d.date_key
WHERE order_status = 'delivered'
AND is_returned = FALSE
GROUP BY d.year, order_id
)

SELECT
    year,
    CASE
    WHEN total_profit < 0 THEN 'negative'
    WHEN total_profit < 200 THEN '0-199'
    WHEN total_profit < 500 THEN '200-499'
    WHEN total_profit < 1000 THEN '500-999'
    WHEN total_profit < 2000 THEN '1000-1999'
    ELSE '2000+'
    END AS profit_range,
    COUNT(*) AS order_count
FROM order_profit
GROUP BY year, profit_range
ORDER BY year, profit_range;

-- Basket Size Analysis
WITH A AS (
SELECT
    d.year,
    order_id,
    COUNT(order_item_id) AS items_in_order
FROM `seraphic-result-479320-t2.ecommerce_data_warehouse.fact_sales` f
JOIN `seraphic-result-479320-t2.ecommerce_data_warehouse.dim_date` d
ON f.date_key = d.date_key
WHERE order_status = 'delivered'
AND is_returned = FALSE
GROUP BY d.year, order_id
)

SELECT
    year,
    CASE
    WHEN items_in_order = 1 THEN '1'
    WHEN items_in_order = 2 THEN '2'
    WHEN items_in_order = 3 THEN '3'
    WHEN items_in_order = 4 THEN '4'
    ELSE '5+'
    END AS order_item_count,
    COUNT(order_id) AS order_count
FROM A
GROUP BY year,order_item_count
ORDER BY year,order_item_count;






    


















