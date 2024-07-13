
select 
{{ dbt_utils.generate_surrogate_key(['call_disposition_lkp.call_disposition_id']) }} as call_disposition_key
,*
from {{ ref('call_disposition_lkp') }} as call_disposition_lkp