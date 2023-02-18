with top10 as (
  select
  city, 
  sum(y.orders_count) as top10users_orders_count
  from (
     select *
     from (
            select
            city, 
            user_id, 
            Row_number() over(partition by city order by count(*) desc) as ranking,
            count(*) as orders_count
            from `efood2022-378208.main_assessment.orders`
            group by
            city, 
            user_id 

          ) x
         where ranking <= 10
  ) y
  group by city
)

, cities as (
  select 
  city,
  count(*) as city_orders_count
  from `efood2022-378208.main_assessment.orders`
  group by city
)

SELECT 
cities.city,
cities.city_orders_count,
top10.top10users_orders_count,
top10.top10users_orders_count/cities.city_orders_count as perc_of_top10
FROM cities
LEFT JOIN top10 ON top10.city = cities.city
ORDER BY city ASC

