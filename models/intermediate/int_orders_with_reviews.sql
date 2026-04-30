WITH reviews AS (
    SELECT * FROM {{ ref('stg_order_reviews') }}
)

SELECT
    order_id,
    review_id,
    review_score,
    review_comment_title,
    review_comment_message,
    review_creation_date,
    review_answer_timestamp
FROM reviews