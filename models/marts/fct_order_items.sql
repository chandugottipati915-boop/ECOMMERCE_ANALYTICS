WITH order_items AS (
    SELECT * FROM {{ ref('int_order_items_with_products') }}
),

orders AS (
    SELECT
        order_id,
        order_status,
        order_purchase_timestamp,
        customer_id
    FROM {{ ref('stg_orders') }}
),

translations AS (
    SELECT * FROM {{ ref('stg_product_category_translations') }}
)

SELECT
    oi.order_id,
    oi.order_item_id,
    oi.seller_id,
    oi.product_id,
    oi.product_category_name,
    t.product_category_name_english,
    oi.price,
    oi.freight_value,
    oi.total_item_value,
    oi.product_weight_g,
    o.order_status,
    o.order_purchase_timestamp,
    o.customer_id,

    -- Derived
    ROUND(oi.freight_value / NULLIF(oi.price, 0) * 100, 2) AS freight_pct_of_price

FROM order_items oi
LEFT JOIN orders o       ON oi.order_id = o.order_id
LEFT JOIN translations t ON oi.product_category_name = t.product_category_name