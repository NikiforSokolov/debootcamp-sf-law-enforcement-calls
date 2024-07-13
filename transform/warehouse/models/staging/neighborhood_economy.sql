select neighborhood as neighborhood_name,
housholds as neighborhood_households_count,
rank() over(order by per_capita_income desc) as neighborhood_income_rnk,
percent_in_poverty as  neighborhood_pct_in_poverty,
case when percent_in_poverty <=0.1 then '0%-10%'
     when percent_in_poverty <=0.2 then '10%-20%'
     when percent_in_poverty <=0.3 then '20%-30%'
     when percent_in_poverty <=0.4 then '30%-40%'
     else '>40%'
end as percent_in_poverty_category
from {{ref('neighborhood_lookup')}}