select  {{ dbt_utils.generate_surrogate_key(['neighborhood_spatial.neighborhood_name']) }} as neighborhood_key,
neighborhood_spatial.neighborhood_name,
neighborhood_spatial.neighborhood_geo_type,
neighborhood_spatial.neighborhood_coordinates,
neighborhood_economy.neighborhood_households_count,
neighborhood_economy.neighborhood_income_rnk,
neighborhood_economy.neighborhood_pct_in_poverty,
neighborhood_economy.percent_in_poverty_category
from {{ref('neighborhood_spatial')}} as neighborhood_spatial
inner join {{ref('neighborhood_economy')}} as neighborhood_economy
    using (neighborhood_name)