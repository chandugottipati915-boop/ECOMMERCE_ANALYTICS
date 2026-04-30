WITH orders AS (
    SELECT * FROM {{ ref('int_orders_with_customers') }}
),

payments AS (
    SELECT * FROM {{ ref('int_orders_with_payments') }}
),

reviews AS (
    SELECT DISTINCT
        order_id,
        -- Keep the most recent review per order
        FIRST_VALUE(review_id) OVER (
            PARTITION BY order_id ORDER BY review_creation_date DESC
        ) AS review_id,
        FIRST_VALUE(review_score) OVER (
            PARTITION BY order_id ORDER BY review_creation_date DESC
        ) AS review_score,
        FIRST_VALUE(review_comment_title) OVER (
            PARTITION BY order_id ORDER BY review_creation_date DESC
        ) AS review_comment_title
    FROM {{ ref('int_orders_with_reviews') }}
),

order_items AS (
    SELECT
        order_id,
        COUNT(order_item_id)    AS total_items,
        SUM(price)              AS total_price,
        SUM(freight_value)      AS total_freight,
        SUM(total_item_value)   AS total_order_value
    FROM {{ ref('int_order_items_with_products') }}
    GROUP BY order_id
)

SELECT
    o.order_id,
    o.customer_id,
    o.customer_unique_id,
    o.customer_city,
    o.customer_state,
    o.order_status,
    o.order_purchase_timestamp,
    o.order_approved_at,
    o.order_delivered_customer_date,
    o.order_estimated_delivery_date,

    -- Payment info
    p.total_payment_value,
    p.payment_type,
    p.payment_count,
    p.max_installments,

    -- Order items info
    oi.total_items,
    oi.total_price,
    oi.total_freight,
    oi.total_order_value,

    -- Review info
    r.review_score,
    r.review_comment_title,

    -- Derived metrics
    DATEDIFF('day',
        o.order_purchase_timestamp,
        o.order_delivered_customer_date)    AS delivery_days,

    DATEDIFF('day',
        o.order_delivered_customer_date,
        o.order_estimated_delivery_date)    AS days_early_or_late,

    CASE
        WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date
        THEN 'On Time'
        ELSE 'Late'
    END AS delivery_status

FROM orders o
LEFT JOIN payments p  ON o.order_id = p.order_id
LEFT JOIN reviews r   ON o.order_id = r.order_id
LEFT JOIN order_items oi ON o.order_id = oi.order_id