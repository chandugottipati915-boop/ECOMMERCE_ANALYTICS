WITH source AS (
    SELECT * FROM {{ source('raw', 'product_category_name_translation') }}
)

SELECT
    product_category_name,
    product_category_name_english
FROM source
