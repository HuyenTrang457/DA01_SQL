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

 


--3
WITH CTE AS(SELECT *,
                 DENSE_RANK() OVER(PARTITION BY gender ORDER BY age) AS stt
             FROM bigquery-public-data.thelook_ecommerce.users),

 CTE_2 AS(SELECT *,
                 MIN(stt) OVER(PARTITION BY gender ) AS min_stt ,
                 MAX(stt) OVER(PARTITION BY gender )  AS max_stt
         FROM CTE)
SELECT first_name, last_name, gender, age,
       (CASE WHEN stt=min_stt THEN 'youngest' ELSE 'oldest'END) AS c,
        COUNT(*) OVER(PARTITION BY gender, age)
FROM CTE_2 AS a
 JOIN bigquery-public-data.thelook_ecommerce.order_items AS b ON a.id=b.id
 WHERE stt IN (max_stt,min_stt) AND FORMAT_DATE( '%Y-%m',b.created_at) BETWEEN '2019-01' AND '2022-04'
 ORDER BY gender , age 

 /* insight: Male: trẻ nhất là 12t, số lượng: 220
                    lớn nhất 70t, số lượng: 250
            Female: trẻ nhất là 12t, số lượng: 211
                    lớn nhất 70t, số lượng: 218 */

--4
--Thống kê top 5 sản phẩm có lợi nhuận cao nhất từng tháng (xếp hạng cho từng sản phẩm). 
WITH CTE AS (SELECT FORMAT_DATE( '%Y-%m',created_at) AS month_year, product_id, product_name,
                  SUM(product_retail_price-cost) OVER(PARTITION BY product_id,FORMAT_DATE( '%Y-%m',created_at)) AS profit,
            FROM bigquery-public-data.thelook_ecommerce.inventory_items
            WHERE sold_at IS NOT NULL
            ORDER BY FORMAT_DATE( '%Y-%m',created_at)),
    CTE_2 AS (SELECT *, 
                      DENSE_RANK() OVER(PARTITION BY month_year ORDER BY profit DESC) AS rank_per_month
              FROM CTE
              ORDER BY month_year)
SELECT *
FROM CTE_2
WHERE rank_per_month<=5

--5
SELECT * FROM
(SELECT FORMAT_DATE( '%Y-%m-%d',sold_at) AS dates,product_category,
ROUND(SUM(product_retail_price),2) AS revenue
FROM bigquery-public-data.thelook_ecommerce.inventory_items
WHERE sold_at IS NOT NULL  
GROUP BY product_category,FORMAT_DATE( '%Y-%m-%d',sold_at)
) AS a
WHERE dates BETWEEN '2022-01-15'  AND '2022-04-15'
ORDER BY dates,product_category
















