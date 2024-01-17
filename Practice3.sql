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
