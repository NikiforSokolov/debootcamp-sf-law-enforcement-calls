select
    nhood                           as neighborhood_name,
    replace(the_geom:type, '"', '') as neighborhood_geo_type,
    the_geom:coordinates            as neighborhood_coordinates
from {{ source('dispatch', 'analysis_neighborhoods') }}
