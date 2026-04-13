-- Dataset Overview
SELECT
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS total_customers,
    COUNT(DISTINCT product_id) AS total_products,
FROM `seraphic-result-479320-t2.ecommerce_data_warehouse.fact_sales`;

-- Monthly Sales, Deductions and Returns Analysis
SELECT
    d.year_month,
    ROUND(SUM(s.net_sales),2) AS total_net_sales,
    ROUND(SUM(s.gross_sales),2) AS total_gross_sales,
    ROUND(SUM(s.gross_sales - s.net_sales), 2) AS total_deductions_returns,
    ROUND(SAFE_DIVIDE(SUM(s.gross_sales - s.net_sales), SUM(s.gross_sales)) * 100, 2) AS deduction_percentage
FROM `seraphic-result-479320-t2.ecommerce_data_warehouse.fact_sales` s
JOIN `seraphic-result-479320-t2.ecommerce_data_warehouse.dim_date` d
ON s.date_key = d.date_key
GROUP BY d.year_month
ORDER BY d.year_month;

-- Yearly Sales, Deductions and Returns Analysis
SELECT
    d.year,
    ROUND(SUM(s.net_sales),2) AS total_net_sales,
    ROUND(SUM(s.gross_sales),2) AS total_gross_sales,
    ROUND(SUM(s.gross_sales - s.net_sales), 2) AS total_deductions_returns,
    ROUND(SAFE_DIVIDE(SUM(s.gross_sales - s.net_sales), SUM(s.gross_sales)) * 100, 2) AS deduction_percentage
FROM `seraphic-result-479320-t2.ecommerce_data_warehouse.fact_sales` s
JOIN `seraphic-result-479320-t2.ecommerce_data_warehouse.dim_date` d
ON s.date_key = d.date_key
GROUP BY d.year
ORDER BY d.year;

-- Monthly Total Order Count Summary
SELECT
    d.year_month,
    COUNT(DISTINCT s.order_id) AS total_orders
FROM `seraphic-result-479320-t2.ecommerce_data_warehouse.fact_sales` s
JOIN `seraphic-result-479320-t2.ecommerce_data_warehouse.dim_date` d
ON s.date_key = d.date_key
GROUP BY d.year_month
ORDER BY d.year_month;

-- Yearly Total Order Count Summary
SELECT
    d.year,
    COUNT(DISTINCT s.order_id) AS total_orders 
FROM `seraphic-result-479320-t2.ecommerce_data_warehouse.fact_sales` s
JOIN `seraphic-result-479320-t2.ecommerce_data_warehouse.dim_date` d
ON s.date_key = d.date_key
GROUP BY d.year
ORDER BY d.year;

-- Monthly Delivered Order Count
WITH monthly_sales AS (
SELECT
    d.month_number,
    COUNT(DISTINCT CASE WHEN d.year = 2024 THEN s.order_id END) AS orders_count_2024,
    COUNT(DISTINCT CASE WHEN d.year = 2025 THEN s.order_id END) AS orders_count_2025
FROM `seraphic-result-479320-t2.ecommerce_data_warehouse.fact_sales` s
JOIN `seraphic-result-479320-t2.ecommerce_data_warehouse.dim_date` d
ON s.date_key = d.date_key
WHERE s.is_returned = false
AND s.order_status = 'delivered'
GROUP BY d.month_number
)
SELECT
    month_number,
    orders_count_2024,
    orders_count_2025,
    ROUND(SAFE_DIVIDE(orders_count_2025 - orders_count_2024, orders_count_2024) * 100, 2) AS percentage_change
FROM monthly_sales
ORDER BY month_number;

-- Monthly Cancellation Rate
WITH monthly_sales AS (
SELECT
    d.month_number,
    COUNT(DISTINCT CASE WHEN d.year = 2024 THEN s.order_id END) AS total_orders_2024,
    COUNT(DISTINCT CASE WHEN d.year = 2025 THEN s.order_id END) AS total_orders_2025,
    COUNT(DISTINCT CASE WHEN d.year = 2024 AND s.order_status IN ('canceled', 'unavailable') THEN s.order_id END) AS cancelled_orders_2024,
    COUNT(DISTINCT CASE WHEN d.year = 2025 AND s.order_status IN ('canceled', 'unavailable') THEN s.order_id END) AS cancelled_orders_2025
FROM `seraphic-result-479320-t2.ecommerce_data_warehouse.fact_sales` s
JOIN `seraphic-result-479320-t2.ecommerce_data_warehouse.dim_date` d
ON s.date_key = d.date_key
GROUP BY d.month_number
)
SELECT
    month_number,
    ROUND(SAFE_DIVIDE(cancelled_orders_2024, total_orders_2024) * 100, 2) AS cancellation_rate_2024,
    ROUND(SAFE_DIVIDE(cancelled_orders_2025, total_orders_2025) * 100, 2) AS cancellation_rate_2025
FROM monthly_sales
ORDER BY month_number;

-- Monthly Return Rate   
WITH monthly_sales AS (
SELECT
    d.month_number,
    COUNT(DISTINCT CASE WHEN d.year = 2024 AND s.order_status = 'delivered' THEN s.order_id END) AS total_orders_2024,
    COUNT(DISTINCT CASE WHEN d.year = 2025 AND s.order_status = 'delivered' THEN s.order_id END) AS total_orders_2025,
    COUNT(DISTINCT CASE WHEN d.year = 2024 AND s.order_status = 'delivered' AND s.is_returned = true THEN s.order_id END) AS returned_orders_2024,
    COUNT(DISTINCT CASE WHEN d.year = 2025 AND s.order_status = 'delivered' AND s.is_returned = true THEN s.order_id END) AS returned_orders_2025
FROM `seraphic-result-479320-t2.ecommerce_data_warehouse.fact_sales` s
JOIN `seraphic-result-479320-t2.ecommerce_data_warehouse.dim_date` d
ON s.date_key = d.date_key
GROUP BY d.month_number
)
SELECT
    month_number,
    ROUND(SAFE_DIVIDE(returned_orders_2024, total_orders_2024) * 100, 2) AS returned_rate_2024,
    ROUND(SAFE_DIVIDE(returned_orders_2025, total_orders_2025) * 100, 2) AS returned_rate_2025
FROM monthly_sales
ORDER BY month_number;

-- Monthly Gross Sales, Net Sales and Profit Analysis
SELECT
    d.year_month,
    ROUND(SUM(gross_sales),2) AS total_gross_sales,
    ROUND(SUM(s.net_sales),2) AS total_net_sales,
    ROUND(SUM(s.profit),2) AS total_profit
FROM `seraphic-result-479320-t2.ecommerce_data_warehouse.fact_sales` s
JOIN `seraphic-result-479320-t2.ecommerce_data_warehouse.dim_date` d
ON s.date_key = d.date_key
GROUP BY d.year_month
ORDER BY d.year_month;

-- Monthly Net Sales Trend with 3 Month Moving Average
WITH monthly_summary AS (
SELECT
    d.year_month,
    SUM(s.net_sales) AS monthly_net_sales
FROM `seraphic-result-479320-t2.ecommerce_data_warehouse.fact_sales` s
JOIN `seraphic-result-479320-t2.ecommerce_data_warehouse.dim_date` d
ON s.date_key = d.date_key
GROUP BY d.year_month
)
SELECT
    year_month,
    monthly_net_sales,
    ROUND(AVG(monthly_net_sales) OVER (ORDER BY year_month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW ), 2) AS moving_avg
FROM monthly_summary
ORDER BY year_month;

-- Profit Margin
SELECT
    d.year_month,
    ROUND(SUM(net_sales),2) AS total_net_sales,
    ROUND(SUM(profit),2) AS profit,
    ROUND(SAFE_DIVIDE(SUM(profit), SUM(net_sales)) * 100, 2) AS profit_margin
FROM `seraphic-result-479320-t2.ecommerce_data_warehouse.fact_sales` s
JOIN `seraphic-result-479320-t2.ecommerce_data_warehouse.dim_date` d
ON s.date_key = d.date_key
GROUP BY d.year_month;































