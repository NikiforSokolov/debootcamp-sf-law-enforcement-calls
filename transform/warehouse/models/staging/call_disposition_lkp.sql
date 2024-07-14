select code as call_disposition_id,
definition as call_disposition_definition,
explanation as call_disposition_explanation
from {{ref('calls_disposition_lookup')}}