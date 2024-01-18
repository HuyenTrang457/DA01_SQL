--EX1
SELECT
SUM(
CASE
  WHEN  device_type ='laptop' THEN 1 ELSE 0
END 
) AS laptop_views,
SUM(
CASE
  WHEN device_type IN ('tablet','phone') THEN 1 ELSE 0
END
) AS mobile_views
FROM viewership

--EX2
SELECT x,y,z,
CASE
    WHEN x+y>z AND x+z>y AND y+z>x THEN 'Yes' ELSE 'No'
END AS triangle
FROM Triangle

--EX3
SELECT 
(SUM(CASE 
  WHEN call_category IN ('null','n/a') THEN 1 ELSE 0
END
)/SUM(call_category))*100 AS call_percentage
FROM callers

--EX4
select name 
from customer 
where referee_id is null or referee_id!=2;
--CACH 2, EX4
select name 
from customer 
where coalesce(referee_id,0) <>2

--EX5
SELECT survived,

SUM(CASE WHEN pclass=1 THEN 1 ELSE 0 END ) AS first_class,
SUM(CASE WHEN pclass=2 THEN 1 ELSE 0 END ) AS second_class,
SUM(CASE WHEN pclass=3 THEN 1 ELSE 0 END ) AS third_class
FROM titanic
GROUP BY survived
