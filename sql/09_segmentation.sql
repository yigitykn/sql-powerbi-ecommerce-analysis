-- Customer Segmentation
WITH custRFM AS (
  SELECT
    customer_id,
    DATE_DIFF(DATE '2025-12-31', DATE(MAX(order_datetime)), DAY) AS recency,
    COUNT(DISTINCT order_id) AS frequency,
    SUM(net_sales) AS monetary
  FROM `seraphic-result-479320-t2.ecommerce_data_warehouse.fact_sales`
  WHERE order_status = 'delivered'
    AND is_returned = false
  GROUP BY customer_id
),

RFM_score AS(
  SELECT
    customer_id,
    recency,
    frequency,
    monetary,
    NTILE(5) OVER (ORDER BY recency DESC) AS R,
    NTILE(5) OVER (ORDER BY frequency ASC) AS F,
    NTILE(5) OVER (ORDER BY monetary ASC) AS M
  FROM custRFM
),
segmented AS(
  SELECT 
    *,
  CASE
      WHEN R >= 5 AND F >= 5 AND M >= 4 THEN 'Champions'
      WHEN R >= 3 AND F >= 3 AND M >= 3 THEN 'Loyal Customers'
      WHEN R >= 4 AND F <= 2 AND M >= 2 THEN 'Potential Customers'
      WHEN R <= 2 AND F >= 3 AND M >= 3 THEN 'At Risk'
      WHEN R = 1 AND F <= 2 AND M <= 2 THEN 'Lost'
      WHEN R <= 2 AND F <= 2 THEN 'Hibernating'
      ELSE 'Hibernating'
    END AS segment_name
FROM RFM_Score
)

-- Segmented Customer Profile
SELECT
  m.*,
  s.recency,
  s.frequency,
  ROUND(s.monetary,2) AS monetary ,
  s.R,
  s.F,
  s.M,
  s.segment_name,
  CASE
    WHEN segment_name = 'Champions' THEN 1
    WHEN segment_name = 'Loyal Customers' THEN 2
    WHEN segment_name = 'Potential Customers' THEN 3
    WHEN segment_name = 'At Risk' THEN 4
    WHEN segment_name = 'Hibernating' THEN 5
    WHEN segment_name = 'Lost' THEN 6
  END AS segment_sort
FROM `seraphic-result-479320-t2.ecommerce_data_warehouse.dim_customer` AS m
LEFT JOIN segmented AS s
  ON m.customer_id = s.customer_id;



