-- Overrides the default dbt behavior that prepends target.schema to custom schemas.
-- Without this, staging becomes dev_staging, marts becomes dev_marts, etc.
-- With this, custom schema names are used as-is across all environments.
{% macro generate_schema_name(custom_schema_name, node) -%}
    {%- set default_schema = target.schema -%}
    {%- if custom_schema_name is none -%}
        {{ default_schema }}
    {%- else -%}
        {{ custom_schema_name | trim }}
    {%- endif -%}
{%- endmacro %}
