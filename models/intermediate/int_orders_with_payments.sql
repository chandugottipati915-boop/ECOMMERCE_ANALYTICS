WITH order_payments AS (
    SELECT * FROM {{ ref('stg_order_payments') }}
),

payment_summary AS (
    SELECT
        order_id,
        SUM(payment_value)        AS total_payment_value,
        COUNT(payment_sequential)  AS payment_count,
        MAX(payment_installments)  AS max_installments,
        MAX(payment_type)          AS payment_type
    FROM order_payments
    GROUP BY order_id
)

SELECT * FROM payment_summary