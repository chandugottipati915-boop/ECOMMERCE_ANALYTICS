-- Review scores must be integers between 1 and 5.
-- Any value outside this range indicates upstream data quality issues.
SELECT order_id
FROM {{ ref('fct_orders') }}
WHERE review_score IS NOT NULL
  AND review_score NOT BETWEEN 1 AND 5
