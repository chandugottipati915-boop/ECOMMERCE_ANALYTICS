-- Delivered orders must have a positive delivery_days value.
-- Negative or zero values indicate bad data in the timestamp fields.
SELECT order_id
FROM {{ ref('fct_orders') }}
WHERE order_status = 'delivered'
  AND (delivery_days IS NULL OR delivery_days <= 0)
