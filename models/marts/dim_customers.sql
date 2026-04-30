WITH customers AS (
    SELECT * FROM {{ ref('stg_customers') }}
),

orders AS (
    SELECT * FROM {{ ref('stg_orders') }}
),

payments AS (
    SELECT * FROM {{ ref('int_orders_with_payments') }}
),

customer_orders AS (
    SELECT
        c.customer_unique_id,
        MAX(c.customer_city)                    AS customer_city,
        MAX(c.customer_state)                   AS customer_state,
        COUNT(DISTINCT o.order_id)              AS total_orders,
        MIN(o.order_purchase_timestamp)         AS first_order_date,
        MAX(o.order_purchase_timestamp)         AS last_order_date,
        SUM(p.total_payment_value)              AS lifetime_value,
        AVG(p.total_payment_value)              AS avg_order_value,
        DATEDIFF('day',
            MIN(o.order_purchase_timestamp),
            MAX(o.order_purchase_timestamp))    AS customer_age_days
    FROM customers c
    LEFT JOIN orders o      ON c.customer_id = o.customer_id
    LEFT JOIN payments p    ON o.order_id = p.order_id
    GROUP BY
        c.customer_unique_id
)

SELECT
    customer_unique_id,
    customer_city,
    customer_state,
    total_orders,
    first_order_date,
    last_order_date,
    lifetime_value,
    avg_order_value,
    customer_age_days,

    -- Customer segmentation
    CASE
        WHEN total_orders >= 5              THEN 'Champion'
        WHEN total_orders >= 3              THEN 'Loyal'
        WHEN total_orders = 2              THEN 'Returning'
        ELSE                                    'One Time'
    END AS customer_segment,

    -- LTV segmentation
    CASE
        WHEN lifetime_value >= 1000         THEN 'High Value'
        WHEN lifetime_value >= 300          THEN 'Mid Value'
        ELSE                                    'Low Value'
    END AS ltv_segment

FROM customer_orders