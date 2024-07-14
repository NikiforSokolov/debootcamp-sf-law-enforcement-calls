{{
    config(
        materialized = "incremental",
        unique_key = "cad_number",
        incremental_strategy = "merge"
    )
}}

select 
{{ dbt_utils.generate_surrogate_key(['calls.cad_number']) }} as call_key,
cad_number,
cad_event_id,
call_received_date as call_date,
agency,
dim_call_types.call_types_key as call_types_key,
calls.call_priority,
calls.call_type_desc,
calls.call_type_notes,
{{ dbt_utils.generate_surrogate_key(['calls.call_disposition']) }} as call_disposition_key,
{{ dbt_utils.generate_surrogate_key(['calls.neighborhood_name']) }} as neighborhood_key,
dim_supervisor_districts.supervisor_districts_key,
event_initiated_by,
dup_cad_number,
num_units_on_scene,
police_district,
call_received_datetime,
call_entry_datetime,
unit_dispatch_datetime,
onscene_datetime,
call_closed_datetime,
intake_time,
queue_time,
travel_time,
sfpd_response_time,
response_time,
call_duration,
unit_got_onscene,
call_location_geo_type,
call_location_coordinates,
pd_incident_report,
is_sensitive_call,
call_data_updated_at

from {{ref('calls')}} as calls
left join {{ref('dim_supervisor_districts_prod')}} as dim_supervisor_districts
on calls.supervisor_district_id = dim_supervisor_districts.supervisor_districts_id
and calls.call_received_datetime::timestamp >=dim_supervisor_districts.dbt_valid_from
and calls.call_received_datetime::timestamp < coalesce(dim_supervisor_districts.dbt_valid_to, '9999-01-01'::timestamp)
left join {{ref('dim_call_types')}} as dim_call_types
    on dim_call_types.call_types_code = calls.call_type_code

{% if is_incremental() %}
    where call_data_updated_at >= (select max(call_data_updated_at) from {{this}})
{% endif %}

