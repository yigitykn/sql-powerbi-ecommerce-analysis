-- Payment Performance Summary
SELECT
    d.year,
    p.payment_method,
    COUNT(DISTINCT f.order_id) AS count_order,
    ROUND(SUM(f.net_sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SAFE_DIVIDE(SUM(f.net_sales), COUNT(DISTINCT f.order_id)), 2) AS avg_order_value
FROM `seraphic-result-479320-t2.ecommerce_data_warehouse.fact_sales` f
JOIN `seraphic-result-479320-t2.ecommerce_data_warehouse.dim_payment_method` p
    ON p.payment_method_id = f.payment_method_id
JOIN `seraphic-result-479320-t2.ecommerce_data_warehouse.dim_date` d
    ON d.date_key = f.date_key
WHERE is_returned = FALSE
AND order_status = 'delivered'
GROUP BY d.year, p.payment_method
ORDER BY d.year, p.payment_method;














