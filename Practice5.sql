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


