-- Table Preview
SELECT *
FROM `seraphic-result-479320-t2.ecommerce_data_warehouse.fact_sales`
LIMIT 10;

-- Null Validation
SELECT 
    COUNT(*) AS null_count
FROM `seraphic-result-479320-t2.ecommerce_data_warehouse.fact_sales`
WHERE order_id IS NULL
    OR date_key IS NULL
    OR customer_id IS NULL
    OR product_id IS NULL
    OR store_id IS NULL
    OR payment_method_id IS NULL;

-- ID Length Validation
SELECT 
    COUNT(*) AS length_count
FROM `seraphic-result-479320-t2.ecommerce_data_warehouse.fact_sales`
WHERE
    LENGTH(order_id) != 12
    OR LENGTH(CAST(date_key AS STRING)) != 8
    OR LENGTH(customer_id) != 10
    OR LENGTH(product_id) != 8
    OR LENGTH(store_id) != 4
    OR LENGTH(payment_method_id) != 4;

-- Check For Distinct Order Status Values
SELECT
    DISTINCT(order_status)
FROM `seraphic-result-479320-t2.ecommerce_data_warehouse.fact_sales`;

-- Negative Value Check
SELECT
    COUNTIF(quantity <= 0) AS negative_quantity,
    COUNTIF(unit_price <= 0) AS negative_unit_price,
    COUNTIF(cost <= 0) AS negative_cost,
    COUNTIF(discount_amount < 0) AS negative_discount_amount,
    COUNTIF(return_amount < 0) AS negative_return_amount
FROM `seraphic-result-479320-t2.ecommerce_data_warehouse.fact_sales`;

-- Data Range Validation
SELECT
    MIN(date_key) AS min_date,
    MAX(date_key) AS max_date
FROM `seraphic-result-479320-t2.ecommerce_data_warehouse.fact_sales`;

-- Invalid Cancellation Logic Check
SELECT
    COUNT(*)
FROM `seraphic-result-479320-t2.ecommerce_data_warehouse.fact_sales`
WHERE order_status = 'cancelled'
AND return_amount > 0;

-- Logic Errors
SELECT
    COUNT(*)
FROM `seraphic-result-479320-t2.ecommerce_data_warehouse.fact_sales`
WHERE discount_amount > (unit_price * quantity)
OR return_amount > (unit_price * quantity);

-- Composite Key Validation
WITH cleaned_duplicates AS (
  SELECT
      ROW_NUMBER() OVER(PARTITION BY order_id, order_item_id) AS duplicate_count
  FROM`seraphic-result-479320-t2.ecommerce_data_warehouse.fact_sales`
)
SELECT  COUNT(*) AS duplicate_count
FROM cleaned_duplicates
WHERE duplicate_count > 1;

-- Foreign Key Consistency Check 1: Product ID
SELECT 
    f.product_id AS missing_value,
    COUNT(*)
FROM `seraphic-result-479320-t2.ecommerce_data_warehouse.fact_sales` f
LEFT JOIN `seraphic-result-479320-t2.ecommerce_data_warehouse.dim_product` p
ON f.product_id = p.product_id
WHERE p.product_id IS NULL
GROUP BY f.product_id;

-- Foreign Key Consistency Check 2: Store ID
SELECT  
    f.store_id AS missing_value,
    COUNT(*)
FROM `seraphic-result-479320-t2.ecommerce_data_warehouse.fact_sales` f
LEFT JOIN `seraphic-result-479320-t2.ecommerce_data_warehouse.dim_store` s
ON f.store_id = s.store_id
WHERE s.store_id IS NULL
GROUP BY f.store_id;

-- Foreign Key Consistency Check 3: Payment Method ID
SELECT 
    f.payment_method_id,
    COUNT(*)
FROM `seraphic-result-479320-t2.ecommerce_data_warehouse.fact_sales` f
LEFT JOIN `seraphic-result-479320-t2.ecommerce_data_warehouse.dim_payment_method` p
ON f.payment_method_id = p.payment_method_id
WHERE p.payment_method_id IS NULL
GROUP BY f.payment_method_id;

-- Foreign Key Consistency Check 4: Date key
SELECT 
    f.date_key,
    COUNT(*)
FROM `seraphic-result-479320-t2.ecommerce_data_warehouse.fact_sales` f
LEFT JOIN `seraphic-result-479320-t2.ecommerce_data_warehouse.dim_date` d
ON f.date_key = d.date_key
WHERE d.date_key IS NULL
GROUP BY f.date_key;

-- Foreign Key Consistency Check 5: Customer ID
SELECT
    f.customer_id,
    COUNT(*)
FROM `seraphic-result-479320-t2.ecommerce_data_warehouse.fact_sales` f
LEFT JOIN `seraphic-result-479320-t2.ecommerce_data_warehouse.dim_customer` c
ON f.customer_id = c.customer_id
WHERE c.customer_id IS NULL
GROUP BY f.customer_id;


























