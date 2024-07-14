{% snapshot dim_supervisor_districts %}

{{
   config(
       target_schema='marts',
       unique_key='supervisor_districts_id',
       strategy='timestamp',
       updated_at='supervisor_districts_data_loaded_at',
       invalidate_hard_deletes=True
   )
}}

select 
{{ dbt_utils.generate_surrogate_key(['supervisor_districts_id', 'SUPERVISOR_DISTRICTS_SUP_NAME']) }} as supervisor_districts_key,
* FROM {{ref('supervisor_districts')}}

{% endsnapshot %}