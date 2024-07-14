{{
    config(
        materialized = "incremental",
        unique_key = "cad_number",
        incremental_strategy = "merge"
    )
}}

with calls_clean as (
select 
cad_number,
case when dup_cad_number is null then cad_number
    else dup_cad_number 
end as cad_event_id,
agency,
disposition as call_disposition,
analysis_neighborhood as  neighborhood_name,
supervisor_district as supervisor_district_id,
onview_flag,
case when onview_flag='Y' then 'agency-initiated'
     else 'call-initiated' 
end as event_initiated_by,
dup_cad_number,
case when dup_cad_number is not null then 'Multi-units'
     else 'singe-unit'
end as num_units_on_scene,
priority_final as call_priority,
call_type_final as call_type_code,
call_type_final_desc as call_type_desc,
call_type_final_notes as call_type_notes,
police_district,
received_datetime as call_received_datetime,
entry_datetime as call_entry_datetime,
datediff(second,received_datetime,entry_datetime) as intake_time,
dispatch_datetime as unit_dispatch_datetime,
datediff(second,entry_datetime,dispatch_datetime) as queue_time,
onscene_datetime,
datediff(second,dispatch_datetime,onscene_datetime) as travel_time,
close_datetime as call_closed_datetime,
datediff(second,ifnull(onscene_datetime,dispatch_datetime),close_datetime) as call_duration,
case when onscene_datetime is not null then 1
     else 0
end as unit_got_onscene,
replace(intersection_point:type,'"','') as call_location_geo_type,
intersection_point:coordinates as call_location_coordinates,
case when pd_incident_report is not null then 1 
     else 0 
end as pd_incident_report,
case when sensitive_call = TRUE then 1
     else 0
end as is_sensitive_call,
data_updated_at  as call_data_updated_at
from {{source('dispatch','calls')}}
{% if is_incremental() %}
    where data_updated_at >= (select max(call_data_updated_at) from {{this}})
{% endif %}


)

select cad_number,
cad_event_id,
agency,
call_type_code,
call_priority,
call_disposition,
call_type_desc,
call_type_notes,
neighborhood_name,
supervisor_district_id,
event_initiated_by,
dup_cad_number,
num_units_on_scene,
police_district,
call_received_datetime::date as call_received_date,
call_received_datetime,
call_entry_datetime,
intake_time,
unit_dispatch_datetime,
queue_time,
onscene_datetime,
travel_time,
queue_time + travel_time as sfpd_response_time,
intake_time + queue_time + travel_time as response_time,
call_closed_datetime,
call_duration,
unit_got_onscene,
call_location_geo_type,
call_location_coordinates,
pd_incident_report,
is_sensitive_call,
call_data_updated_at
from calls_clean