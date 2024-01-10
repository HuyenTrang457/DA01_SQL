--EX1
SELECT DISTINCT CITY
FROM STATION
WHERE ID%2=0

--EX2
 SELECT COUNT(CITY)- COUNT(DISTINCT CITY) FROM STATION

--EX4
SELECT 
ROUND(CAST(SUM(item_count*order_occurrences)/SUM(order_occurrences) AS DECIMAL),1) AS MEAN
FROM items_per_order

--EX5
SELECT candidate_id
FROM candidates
WHERE skill IN ('Python','Tableau','PostgreSQL')
GROUP BY candidate_id
HAVING COUNT(skill)=3

 --EX6
 SELECT user_id,
MAX(DATE(post_date))-MIN(DATE(post_date)) AS days_between
FROM posts
WHERE post_date BETWEEN '2021-01-01' AND '2022-01-01'
GROUP BY user_id
HAVING COUNT(user_id)>=2
 
--EX7
SELECT card_name,
MAX(issued_amount)- MIN(issued_amount) AS difference
FROM monthly_cards_issued
GROUP BY card_name
ORDER BY difference desc

--EX8
SELECT manufacturer,
COUNT(drug) AS drug_counts,
ABS(SUM(total_sales-cogs)) AS total_loss
FROM pharmacy_sales
WHERE total_sales-cogs<=0
GROUP BY manufacturer
ORDER BY  total_loss desc

-- CÁCH 2
SELECT manufacturer,
COUNT(drug) AS drug_counts,
SUM(cogs - total_sales) AS total_loss
FROM pharmacy_sales
WHERE cogs> total_sales
GROUP  BY manufacturer
ORDER BY total_loss DESC

--EX9


