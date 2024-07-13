{{
    config(
        materialized = "table"
    )
}}
{{ dbt_date.get_date_dimension('2014-12-31', '2024-12-31') }}