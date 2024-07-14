select
    key         as call_types_key,
    priority    as call_types_priority,
    call_type   as call_types_code,
    description as call_types_description,
    data_as_of  as call_types_data_as_of
from {{ source('dispatch','call_types') }}
