select
{{ dbt_utils.generate_surrogate_key(['call_types_key']) }} as call_types_key,
call_types_priority,
call_types_code,
call_types_description,
call_types_data_as_of
from {{ref('call_types')}}