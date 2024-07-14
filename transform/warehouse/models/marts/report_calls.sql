{{
    config(
        materialized = "incremental",
        unique_key = "cad_number",
        incremental_strategy = "merge"
    )
}}

select
{{ dbt_utils.star(from=ref('fact_calls'), relation_alias='fact_calls', except=[
        "supervisor_districts_key", "call_types_key", "neighborhood_key", "call_disposition_key", "call_date"
    ]) }},
    {{ dbt_utils.star(from=ref('dim_supervisor_districts'), relation_alias='dim_supervisor_districts', except=["supervisor_districts_key","dbt_scd_id","dbt_updated_at"]) }},
    {{ dbt_utils.star(from=ref('dim_call_types'), relation_alias='dim_call_types', except=["call_types_key","call_types_data_as_of"]) }},
    {{ dbt_utils.star(from=ref('dim_neighborhood'), relation_alias='dim_neighborhood', except=["neighborhood_key"]) }},
    {{ dbt_utils.star(from=ref('dim_call_disposition'), relation_alias='dim_call_disposition', except=["call_disposition_key"]) }},
    {{ dbt_utils.star(from=ref('dim_date'), relation_alias='dim_date', except=["date_day"]) }}
from {{ref('fact_calls')}} as fact_calls
left join {{ref('dim_supervisor_districts_prod')}} as dim_supervisor_districts on fact_calls.supervisor_districts_key = dim_supervisor_districts.supervisor_districts_key
left join {{ref('dim_call_types')}} as dim_call_types on fact_calls.call_types_key = dim_call_types.call_types_key
left join {{ref('dim_neighborhood')}} as dim_neighborhood on fact_calls.neighborhood_key = dim_neighborhood.neighborhood_key
left join {{ref('dim_call_disposition')}} as dim_call_disposition on fact_calls.call_disposition_key = dim_call_disposition.call_disposition_key
left join {{ref('dim_date')}} as dim_date on fact_calls.call_date = dim_date.date_day

{% if is_incremental() %}
    where call_data_updated_at >= (select max(call_data_updated_at) from {{this}})
{% endif %}
