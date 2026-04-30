WITH sellers AS (
    SELECT * FROM {{ ref('stg_sellers') }}
),

order_items AS (
    SELECT * FROM {{ ref('stg_order_items') }}
),

orders AS (
    SELECT * FROM {{ ref('stg_orders') }}
),

seller_metrics AS (
    SELECT
        s.seller_id,
        s.seller_city,
        s.seller_state,
        COUNT(DISTINCT oi.order_id)         AS total_orders,
        COUNT(oi.order_item_id)             AS total_items_sold,
        SUM(oi.price)                       AS total_revenue,
        AVG(oi.price)                       AS avg_item_price,
        SUM(oi.freight_value)               AS total_freight_charged,
        MIN(o.order_purchase_timestamp)     AS first_sale_date,
        MAX(o.order_purchase_timestamp)     AS last_sale_date
    FROM sellers s
    LEFT JOIN order_items oi ON s.seller_id = oi.seller_id
    LEFT JOIN orders o       ON oi.order_id = o.order_id
    GROUP BY
        s.seller_id,
        s.seller_city,
        s.seller_state
)

SELECT
    seller_id,
    seller_city,
    seller_state,
    total_orders,
    total_items_sold,
    total_revenue,
    avg_item_price,
    total_freight_charged,
    first_sale_date,
    last_sale_date,

    -- Seller tier
    CASE
        WHEN total_revenue >= 50000     THEN 'Platinum'
        WHEN total_revenue >= 20000     THEN 'Gold'
        WHEN total_revenue >= 5000      THEN 'Silver'
        ELSE                                'Bronze'
    END AS seller_tier

FROM seller_metrics