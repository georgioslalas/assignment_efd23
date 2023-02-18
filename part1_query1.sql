--part1: efood
with efood as (
select
`efood2022-378208.main_assessment.orders`.city,
count(distinct user_id) as efood_users,
count(*) as efood_orders,
sum(amount)/count(*) as efood_basket,
count(*)/count(distinct user_id) as efood_freq,
ifnull(freq3.freq3users,0)/count(distinct user_id) as efood_usersFreq3_perc
from `efood2022-378208.main_assessment.orders` 
left join (
  SELECT xyz.city, count(*) as freq3users 
  FROM (
        SELECT
        city,
        user_id,
        count(*) as orders_count
        FROM `efood2022-378208.main_assessment.orders`
        GROUP BY 
        city,
        user_id
        HAVING count(*) > 3
       ) as xyz group by xyz.city) as freq3 on freq3.city = `efood2022-378208.main_assessment.orders`.city
group by `efood2022-378208.main_assessment.orders`.city, freq3.freq3users
)
--part2: breakfast
, breakfast as (
select
`efood2022-378208.main_assessment.orders`.city,
count(distinct user_id) as breakfast_users,
count(*) as breakfast_orders,
sum(amount)/count(*) as breakfast_basket,
count(*)/count(distinct user_id) as breakfast_freq,
ifnull(freq3.freq3users,0)/count(distinct user_id) as breakfast_usersFreq3_perc
from `efood2022-378208.main_assessment.orders` 
left join (
  SELECT xyz.city, count(*) as freq3users 
  FROM (
        SELECT
        city,
        user_id,
        count(*) as orders_count
        FROM `efood2022-378208.main_assessment.orders`
        where cuisine = 'Breakfast'
        GROUP BY 
        city,
        user_id
        HAVING count(*) > 3
       ) as xyz group by xyz.city) as freq3 on freq3.city = `efood2022-378208.main_assessment.orders`.city
where cuisine = 'Breakfast'
group by `efood2022-378208.main_assessment.orders`.city, freq3.freq3users
)
--and bring everything together
SELECT 
efood.city
,breakfast.breakfast_basket
,efood.efood_basket
,breakfast.breakfast_freq
,efood.efood_freq
,breakfast.breakfast_usersFreq3_perc
,efood.efood_usersFreq3_perc
,breakfast.breakfast_orders
,efood.efood_orders
FROM efood 
LEFT JOIN breakfast ON breakfast.city = efood.city 
WHERE efood.city in (SELECT city  
  FROM `efood2022-378208.main_assessment.orders` 
  group by city having count(*) > 1000)
ORDER BY breakfast.breakfast_orders DESC LIMIT 5