-- tên kh, qg, số lượng thanh toán, xếp hạng kh có doanh thu cao nhất mỗi qg
-- top 3 kh co doanh thu cao nhat 
SELECT * 
FROM (SELECT a.first_name||' '||a.last_name, d.country,
COUNT(a.customer_id)  AS amount ,
RANK() OVER(PARTITION BY d.country ORDER BY SUM(amount) DESC )AS stt
FROM customer a
JOIN address b ON a.address_id=b.address_id
JOIN city c ON c.city_id=b.city_id
JOIN country d ON d.country_id= c.country_id
JOIN payment e ON e.customer_id=a.customer_id
GROUP BY a.first_name||' '||a.last_name,d.country) AS m
WHERE m.stt<=3

