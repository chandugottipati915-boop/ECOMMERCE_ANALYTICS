# dbt Session Notes — 2026-04-20

## What We Did

### 1. Fixed Source Not Found Error
- **Issue:** `dbt run` failed with `Model 'model.ecommerce_analytics.stg_orders' depends on a source named 'raw.orders' which was not found`
- **Fix:** Created `models/staging/sources.yml` defining the `raw` source

### 2. Fixed Snowflake Database Error
- **Issue:** `Database error while listing schemas in database "analytics"` — database didn't exist
- **Fix:** Updated `~/.dbt/profiles.yml` to use `ECOMMERCE_DEV` instead of `analytics`

### 3. Created All Staging Models
Created the following files in `models/staging/`:

| File | Source Table |
|------|-------------|
| `stg_orders.sql` | `raw.orders` |
| `stg_customers.sql` | `raw.customers` |
| `stg_order_items.sql` | `raw.order_items` |
| `stg_order_payments.sql` | `raw.order_payments` |
| `stg_order_reviews.sql` | `raw.order_reviews` |
| `stg_products.sql` | `raw.products` |
| `stg_sellers.sql` | `raw.sellers` |
| `stg_geolocation.sql` | `raw.geolocation` |
| `stg_product_category_translations.sql` | `raw.product_category_name_translation` |

### 4. Updated sources.yml
- Added all 9 source tables
- Set `database: ecommerce_dev` and `schema: raw`

### 5. IDE Linting Errors
- **Issue:** VS Code showing SQL syntax errors on `{{ source() }}` Jinja syntax
- **Cause:** IDE SQL linter doesn't understand dbt/Jinja templating — false positives, not real errors
- **Fix:** dbt Power User extension (`innoverio.vscode-dbt-power-user`) was already installed — configure `dbt.projectPath` in VS Code settings to resolve

## Final State
- All 9 staging models running successfully as views in `ECOMMERCE_DEV.ecommerce_analytics_staging`
- `dbt run` result: `PASS=9 WARN=0 ERROR=0`

## Next Steps
- Create `intermediate` models
- Create `marts` models
