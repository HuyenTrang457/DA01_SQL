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
  COUNT(b.order_id) AS total_user
FROM
  CTE AS a
RIGHT JOIN
  bigquery-public-data.thelook_ecommerce.order_items AS b
ON a.order_id=b.order_id
WHERE
  FORMAT_DATE( '%Y-%m',b.created_at) BETWEEN '2019-01' AND '2022-04'
GROUP BY  1
ORDER BY  1

