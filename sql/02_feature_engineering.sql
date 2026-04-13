-- Add Financial Columns to Fact_sales
ALTER TABLE `seraphic-result-479320-t2.ecommerce_data_warehouse.fact_sales`
ADD COLUMN gross_sales FLOAT64,
ADD COLUMN net_sales FLOAT64,
ADD COLUMN profit FLOAT64,
ADD COLUMN is_returned BOOL;

-- Calculate Sales Metrics and Return Status
UPDATE `seraphic-result-479320-t2.ecommerce_data_warehouse.fact_sales`
SET
    gross_sales = ROUND(quantity * unit_price,2),
    net_sales = ROUND((quantity * unit_price) - discount_amount - return_amount,2),
    profit = ROUND(((quantity * unit_price) - discount_amount - return_amount) - cost,2),
    is_returned = return_amount > 0;

-- Add Time Attributes to dim_date
ALTER TABLE `seraphic-result-479320-t2.ecommerce_data_warehouse.dim_date`
ADD COLUMN day_name STRING,
ADD COLUMN is_weekend BOOL;

-- Populate Day Names and Weekend Flags
UPDATE `seraphic-result-479320-t2.ecommerce_data_warehouse.dim_date`
SET
    day_name = FORMAT_DATE('%A', full_date),
    is_weekend = EXTRACT(DAYOFWEEK FROM full_date) IN (1,7);
















