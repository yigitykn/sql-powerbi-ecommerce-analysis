-- Comparison of the Best-Selling Products in 2024 And 2025.
WITH product_sales AS (
SELECT
    d.year,
    p.product_name,
    SUM(f.quantity) AS total_quantity
FROM `seraphic-result-479320-t2.ecommerce_data_warehouse.fact_sales` f
JOIN `seraphic-result-479320-t2.ecommerce_data_warehouse.dim_product` p
    ON f.product_id = p.product_id
JOIN `seraphic-result-479320-t2.ecommerce_data_warehouse.dim_date` d
    ON f.date_key = d.date_key
WHERE f.is_returned = FALSE
AND f.order_status = 'delivered'
GROUP BY d.year, p.product_name
)

(SELECT
    'Top Selling Products - 2024' AS analysis_type,
    product_name,
    total_quantity AS quantity
FROM product_sales
WHERE year = 2024
ORDER BY quantity DESC
LIMIT 10)

UNION ALL

(SELECT
    'Top Selling Products - 2025' AS analysis_type,
    product_name,
    total_quantity AS quantity
FROM product_sales
WHERE year = 2025
ORDER BY quantity DESC
LIMIT 10)

UNION ALL

(SELECT
    'Least Selling Products - 2024' AS analysis_type,
    product_name,
    total_quantity AS quantity
FROM product_sales
WHERE year = 2024
ORDER BY quantity
LIMIT 10)

UNION ALL

(SELECT
    'Least Selling Products - 2025' AS analysis_type,
    product_name,
    total_quantity AS quantity
FROM product_sales
WHERE year = 2025
ORDER BY quantity
LIMIT 10);

-- Comparative Product Sales Analysis
WITH product_sales AS (
SELECT
    d.year,
    p.product_name,
    ROUND(SUM(f.profit),2) AS total_profit
FROM `seraphic-result-479320-t2.ecommerce_data_warehouse.fact_sales` f
JOIN `seraphic-result-479320-t2.ecommerce_data_warehouse.dim_product` p
    ON f.product_id = p.product_id
JOIN `seraphic-result-479320-t2.ecommerce_data_warehouse.dim_date` d
    ON f.date_key = d.date_key
WHERE f.is_returned = FALSE
AND f.order_status = 'delivered'
GROUP BY d.year, product_name
)

(SELECT
    'Most Profitable Products - 2024' AS analysis_type,
    product_name,
    total_profit AS profit
FROM product_sales
WHERE year = 2024
ORDER BY total_profit DESC
LIMIT 10)

UNION ALL 

(SELECT
    'Most Profitable Products - 2025' AS analysis_type,
    product_name,
    total_profit AS profit
FROM product_sales
WHERE year = 2025
ORDER BY total_profit DESC
LIMIT 10)

UNION ALL

(SELECT
    'Least Profitable Products - 2024' AS analysis_type,
    product_name,
    total_profit AS profit
FROM product_sales
WHERE year = 2024
ORDER BY total_profit
LIMIT 10)

UNION ALL

(SELECT
    'Least Profitable Products - 2025' AS analysis_type,
    product_name,
    total_profit AS profit
FROM product_sales
WHERE year = 2025
ORDER BY total_profit
LIMIT 10);


























