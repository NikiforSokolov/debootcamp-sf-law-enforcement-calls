with supervisor_districts_current_clean as (
select replace(multipolygon:type,'"','') as supervisor_districts_polygon_type,
multipolygon:coordinates as supervisor_districts_polygon_coordinates,
sup_name as supervisor_districts_sup_name,
sup_dist as supervisor_districts_id,
data_loaded_at as supervisor_districts_data_loaded_at,
row_number() over(partition by sup_dist_num, sup_name order by data_loaded_at desc) as supervisor_districts_row_version_num
from {{source('dispatch', 'supervisor_districts_current')}}
)

select
supervisor_districts_id,
supervisor_districts_sup_name,
supervisor_districts_polygon_type,
supervisor_districts_polygon_coordinates,
supervisor_districts_data_loaded_at
from supervisor_districts_current_clean
where supervisor_districts_row_version_num = 1