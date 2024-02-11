WITH
  CTE AS ((
    SELECT *
    FROM bigquery-public-data.thelook_ecommerce.order_items
    WHERE
      delivered_at IS NOT NULL
      AND returned_at IS NULL ))
SELECT
  FORMAT_DATE( '%Y-%m',b.created_at) AS month_year,
  COUNT(a.order_id) AS total_order,
  COUNT(b.user_id) AS total_user,
  ROUND(SUM(b.sale_price)/COUNT(b.sale_price),2) AS average_order_value,
  COUNT(DISTINCT b.user_id) AS distinct_user,
  
FROM
  CTE AS a
RIGHT JOIN
  bigquery-public-data.thelook_ecommerce.order_items AS b
ON a.order_id=b.order_id
WHERE
  FORMAT_DATE( '%Y-%m',b.created_at) BETWEEN '2019-01' AND '2022-04'
GROUP BY  1
ORDER BY  1

 
--2
 WITH CTE AS(SELECT *,
 DENSE_RANK() OVER(PARTITION BY gender ORDER BY age) AS stt
 FROM bigquery-public-data.thelook_ecommerce.users),

 CTE_2 AS(SELECT *,
 MIN(stt) OVER(PARTITION BY gender ) AS min_stt ,
 MAX(stt) OVER(PARTITION BY gender )  AS max_stt
 FROM CTE)
 SELECT
 first_name, last_name, gender, age
 FROM CTE_2
 WHERE stt=min_stt OR stt=max_stt
