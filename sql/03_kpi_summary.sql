-- KPI Summary: Total Orders, Sales, Profit and AOV
SELECT
    d.year,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(net_sales), 2) AS total_net_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SAFE_DIVIDE(SUM(net_sales), COUNT(DISTINCT order_id)), 2) AS avg_order_value   
FROM `seraphic-result-479320-t2.ecommerce_data_warehouse.fact_sales` f
JOIN `seraphic-result-479320-t2.ecommerce_data_warehouse.dim_date` d
ON f.date_key = d.date_key
WHERE order_status = 'delivered'
AND is_returned = false
GROUP BY d.year
ORDER BY d.year;

-- Return Rate
SELECT
     ROUND(COUNT(DISTINCT CASE WHEN is_returned = TRUE THEN order_id END) / COUNT(DISTINCT order_id)* 100, 2) AS return_rate
FROM `seraphic-result-479320-t2.ecommerce_data_warehouse.fact_sales`;



