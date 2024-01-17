--ex1
SELECT Name
FROM STUDENTS 
WHERE Marks >75
ORDER BY RIGHT(Name,3) asc, ID asc
--ex2
SELECT user_id,
concat(UPPER(LEFT(name,1)),LOWER(RIGHT(name,LENGTH(name)-1))) AS name
FROM Users
ORDER BY name 
--cach 2: SUBSTRING(name,2)
--ex3
 SELECT manufacturer,
 '$'||ROUND((SUM(total_sales)/1000000),0)||' million' AS sales_mil
 FROM pharmacy_sales
 GROUP BY manufacturer
 ORDER BY SUM(total_sales) desc, manufacturer asc
--ex4
SELECT EXTRACT(month FROM submit_date) AS mth,
product_id,
ROUND(AVG(stars),2) AS avg_stars
FROM reviews
GROUP BY mth, product_id
ORDER BY mth, product_id
--ex5
SELECT sender_id,
COUNT(message_id) AS message_count
FROM messages
WHERE TO_CHAR(sent_date,'mm-yyyy')= '08-2022'
GROUP BY sender_id
ORDER BY message_count desc
LIMIT 2
--ex6
SELECT tweet_id
FROM Tweets
WHERE LENGTH(content)>15
--ex7
 SELECT activity_date AS day,
 COUNT(DISTINCT user_id) AS active_users
 FROM Activity
 WHERE activity_date BETWEEN '2019-06-28'AND '2019-07-27'
 GROUP BY activity_date
--ex8
select COUNT(id) AS number_employee
FROM employees
WHERE EXTRACT(month FROM joining_date) BETWEEN 1 AND 7
AND EXTRACT(year from joining_date)=2022
--ex9
select POSITION('a' in first_name)
from worker
where first_name='Amitah'
--ex10
SELECT title,
SUBSTRING(title FROM LENGTH(winery)+2 FOR 4)
FROM winemag_p2
WHERE country='Macedonia'
