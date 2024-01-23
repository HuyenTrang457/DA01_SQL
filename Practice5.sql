--ex1
SELECT a.CONTINENT, FLOOR(AVG(b.POPULATION))
FROM COUNTRY as a
JOIN CITY as b ON a.CODE=b.COUNTRYCODE
GROUP BY a.CONTINENT

--EX2
SELECT ROUND((COUNT(t.email_id) :: DECIMAL
/COUNT(DISTINCT e.email_id)),2) AS confirm_rate
FROM emails e
LEFT JOIN texts t ON e.email_id=t.email_id
AND t.signup_action='Confirmed'

--EX3
SELECT b.age_bucket,
ROUND((SUM(a.time_spent) FILTER (WHERE a.activity_type='send')/SUM(a.time_spent)*100),2) AS send_perc,
ROUND((SUM(a.time_spent) FILTER (WHERE a.activity_type='open' )/SUM(a.time_spent)*100),2) as open_perc
FROM activities a
JOIN age_breakdown b ON a.user_id=b.user_id
WHERE a.activity_type IN('send','open')
GROUP BY b.age_bucket
--EX4
SELECT  c.customer_id

FROM customer_contracts c 
INNER JOIN products p ON c.product_id=p.product_id

GROUP BY c.customer_id
HAVING COUNT(DISTINCT(p.product_category))=3
/*cach2: =(select count(DISTINCT product_category) 
as product_category  from  products) */
--ex5
 SELECT e1.employee_id,e1.name,
 COUNT(e2.reports_to) AS reports_count,
ROUND(AVG(e2.age)) AS average_age
 FROM employees AS e1
 JOIN employees AS e2 ON e1.employee_id=e2.reports_to
 GROUP BY e1.employee_id,e1.name
 ORDER BY e1.employee_id
--EX6
SELECT p.product_name,
SUM(o.unit) as unit
FROM Products as p
JOIN Orders as o ON p.product_id=o.product_id
WHERE o.order_date BETWEEN '2020-02-01' AND '2020-02-29'
GROUP BY p.product_name
HAVING SUM(o.unit)>=100
--EX7
SELECT a.page_id 
FROM pages AS a
LEFT JOIN page_likes AS b ON a.page_id=b.page_id
WHERE b.liked_date IS NULL
ORDER BY a.page_id 
	
--QUESTION 1
SELECT DISTINCT replacement_cost
FROM film
ORDER BY replacement_cost 
LIMIT 1
	
--QUESTION 2
SELECT 
CASE 
	WHEN replacement_cost BETWEEN 9.99 AND 19.99 THEN 'low'
	WHEN replacement_cost BETWEEN 20.00 AND 24.99 THEN 'medium'
	WHEN replacement_cost BETWEEN 25.00 AND 29.99 THEN 'high'
 END AS category,
 COUNT(*)
FROM film
GROUP BY category
	
--QUESTION 3
SELECT a.title, a.length, c.name
FROM film AS a
JOIN film_category AS b ON a.film_id=b.film_id
JOIN category AS c ON b.category_id=c.category_id
WHERE c.name IN ('Drama','Sports')
ORDER BY a.length DESC
	
--QUESTION 4
SELECT c.name,
COUNT(a.title) AS so_luong
FROM film AS a
JOIN film_category AS b ON a.film_id=b.film_id
JOIN category AS c ON b.category_id=c.category_id
GROUP BY c.name
ORDER BY so_luong DESC

--QUESTION 5
SELECT a.first_name, a.last_name,
COUNT(b.film_id) AS so_luong
FROM actor AS a
JOIN film_actor AS b ON a.actor_id=b.actor_id
GROUP BY a.first_name, a.last_name
ORDER BY so_luong DESC

--QUESTION 6
SELECT a.address
FROM address a
LEFT JOIN customer c ON a.address_id=c.address_id
WHERE c.customer_id IS NULL

--QUESTION 7
SELECT a.city, 
SUM(d.amount) AS sum_amount

FROM city a
JOIN address b ON a.city_id=b.city_id
JOIN customer c ON c.address_id=b.address_id
JOIN payment d ON d.customer_id=c.customer_id
GROUP BY a.city
ORDER BY sum_amount DESC

--EX8
SELECT a.city||', '||b.country,
SUM(e.amount)
FROM city a
JOIN country b ON a.country_id=b.country_id
JOIN address c ON c.city_id=a.city_id
JOIN customer d ON c.address_id=d.address_id
JOIN payment e ON e.customer_id=d.customer_id
GROUP BY a.city, b.country
ORDER BY Sum(e.amount) asc


