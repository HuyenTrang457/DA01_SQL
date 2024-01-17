SELECT
CASE 
	WHEN length>120 THEN 'long'
	WHEN length BETWEEN 60 AND 120 THEN 'Medium'
	ELSE 'short'
END AS category,
SUM(CASE 
	WHEN rating ='R' THEN 1 ELSE 0
END) AS r,
SUM(CASE
	WHEN rating ='PG' THEN 1 ELSE 0
END ) AS pg,
SUM(CASE 
	WHEN rating ='PG-13' THEN 1 ELSE 0
END) AS pg_13

FROM film
GROUP BY category

