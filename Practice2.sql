--EX1
SELECT DISTINCT CITY
FROM STATION
WHERE ID%2=0

--EX2
 SELECT COUNT(CITY)- COUNT(DISTINCT CITY) FROM STATION

--EX4
SELECT 
SUM(item_count*order_occurrences)/SUM(order_occurrences) AS MEAN
FROM items_per_order

--EX5
SELECT 
ROUND(CAST(SUM(item_count*order_occurrences)/SUM(order_occurrences) AS DECIMAL),1) AS MEAN
FROM items_per_order

