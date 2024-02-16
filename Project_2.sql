--1.Thống kê tổng số lượng người mua và số lượng đơn hàng đã hoàn thành mỗi tháng ( Từ 1/2019-4/2022)
    --insight: total_order và total_user tăng theo thời gian mỗi tháng, nhưng không đều

SELECT
  FORMAT_DATE( '%Y-%m',b.delivered_at) AS month_year,
  COUNT(b.order_id) AS total_order,
  COUNT(DISTINCT b.user_id) AS total_user,
FROM bigquery-public-data.thelook_ecommerce.order_items AS b
WHERE
  FORMAT_DATE( '%Y-%m',b.created_at) BETWEEN '2019-01' AND '2022-04'
  AND b.status='Complete'
GROUP BY  1
ORDER BY  1


--2.Thống kê giá trị đơn hàng trung bình và tổng số người dùng khác nhau mỗi tháng ( Từ 1/2019-4/2022)
    --insight: distinct_user tăng dần theo thời gian, average_order_value lúc tăng lúc giảm


SELECT
  FORMAT_DATE( '%Y-%m',b.created_at) AS month_year,
  ROUND(SUM(b.sale_price)/COUNT(b.sale_price),2) AS average_order_value,
  COUNT(DISTINCT b.user_id) AS distinct_user,
  
FROM bigquery-public-data.thelook_ecommerce.order_items AS b
WHERE
  FORMAT_DATE( '%Y-%m',b.created_at) BETWEEN '2019-01' AND '2022-04'
GROUP BY  1
ORDER BY  1
--------



--3. Nhóm khách hàng theo độ tuổi
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

    --------
     WITH female_age AS (
  SELECT min(age) as min_age, max(age) as max_age
  FROM bigquery-public-data.thelook_ecommerce.users
  WHERE gender='F' AND FORMAT_DATE( '%Y-%m',created_at) BETWEEN '2019-01' AND '2022-04'
 ),
 male_age AS (
  SELECT min(age) as min_age, max(age) as max_age
  FROM bigquery-public-data.thelook_ecommerce.users
  WHERE gender='M' AND FORMAT_DATE( '%Y-%m',created_at) BETWEEN '2019-01' AND '2022-04'
 ),
 young_old_group AS (
    (SELECT m1.first_name, m1.last_name, m1.gender, m1.age
    FROM bigquery-public-data.thelook_ecommerce.users m1
    JOIN female_age m2 ON m1.age=m2.min_age OR m1.age=m2.max_age
    WHERE m1.gender='F' AND FORMAT_DATE( '%Y-%m',m1.created_at) BETWEEN '2019-01' AND '2022-04'
    )
    UNION ALL
    (
      SELECT n1.first_name, n1.last_name, n1.gender, n1.age
      FROM  bigquery-public-data.thelook_ecommerce.users n1
      JOIN male_age n2 ON n1.age=n2.min_age OR n1.age=n2.max_age
      WHERE n1.gender='M' AND FORMAT_DATE( '%Y-%m',n1.created_at) BETWEEN '2019-01' AND '2022-04'
    )
 ),
 age_tag AS (
  SELECT *,
      CASE 
          WHEN age IN (select min(age) from bigquery-public-data.thelook_ecommerce.users 
                        where gender='F' and FORMAT_DATE( '%Y-%m',created_at) BETWEEN '2019-01' AND '2022-04')
                THEN 'youngest'
          WHEN age IN (select min(age) from bigquery-public-data.thelook_ecommerce.users 
                        where gender='M' and FORMAT_DATE( '%Y-%m',created_at) BETWEEN '2019-01' AND '2022-04')
                THEN 'youngest'
          ELSE 'oldest'
      END as tag
  FROM young_old_group
 )
 SELECT gender, tag,count(*)
 FROM age_tag
 GROUP BY gender,tag





--4.Thống kê top 5 sản phẩm có lợi nhuận cao nhất từng tháng (xếp hạng cho từng sản phẩm). 
    
 WITH CTE AS (SELECT FORMAT_DATE( '%Y-%m',a.created_at) AS month_year, a.product_id, a.product_name,
                  SUM(b.sale_price)-sum(a.cost)AS profit
                  
            FROM bigquery-public-data.thelook_ecommerce.inventory_items a
            JOIN bigquery-public-data.thelook_ecommerce.order_items b ON a.product_id=b.product_id
            WHERE b.status='Complete'
            GROUP BY month_year, a.product_id, a.product_name
            ),
    CTE_2 AS (SELECT *, 
                      DENSE_RANK() OVER(PARTITION BY month_year ORDER BY profit DESC ) AS rank_per_month
              FROM CTE
              ORDER BY month_year)
SELECT *
FROM CTE_2
WHERE rank_per_month<=5

--5.Thống kê tổng doanh thu theo ngày của từng danh mục sản phẩm (category) trong 3 tháng qua ( giả sử ngày hiện tại là 15/4/2022)
    
SELECT * 
FROM (SELECT FORMAT_DATE( '%Y-%m-%d',sold_at) AS dates,product_category,
              ROUND(SUM(product_retail_price),2) AS revenue
      FROM bigquery-public-data.thelook_ecommerce.inventory_items
      WHERE sold_at IS NOT NULL  
      GROUP BY product_category,FORMAT_DATE( '%Y-%m-%d',sold_at)
) AS a
WHERE dates BETWEEN '2022-01-15'  AND '2022-04-15'
ORDER BY dates,product_category
















