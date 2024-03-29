/* danh sách fim có chi phí thay thế lớn nhất trong mỗi loại rating.Ngoài film_id, title, rating, cần hiển thị chi phí tt trung bình của mỗi loại*/
SELECT film_id, title,rating ,
 (SELECT AVG(replacement_cost)
 FROM film  WHERE a.rating=rating
 GROUP BY rating)
 FROM film a
  WHERE replacement_cost=(
	 SELECT MAX(replacement_cost) FROM film
	  WHERE a.rating =rating
	 GROUP BY rating
 )
 GROUP BY film_id, title,rating

/*kh có nhiều hơn 30 hđ, mã kh, tên,số lượng hđ, tổng tiền, tgian tb*/

WITH total_payment AS(SELECT customer_id, COUNT(*) as soluog_hd,
					  SUM(amount) as tong_tien
FROM payment p
GROUP BY customer_id
HAVING COUNT(*)>30),
avg_time AS(SELECT customer_id, AVG(return_date-rental_date)
FROM rental r
GROUP BY customer_id)

SELECT c.customer_id, c.first_name||'  '||c.last_name,
soluog_hd,tong_tien
FROM customer c
JOIN total_payment AS b ON c.customer_id=b.customer_id
JOIN avg_time AS d ON d.customer_id=c.customer_id

 /* tìm hđ có số tiền cao hơn số tiền TB của mỗi khách hàng đó chi tiêu
 trên mỗi hóa đơn,kq: mã kh, tên kh, số lượng hđ, số tiền,
 số tiền TB mỗi kh*/
 
WITH amount_payment AS(SELECT customer_id, AVG(amount)  as avg_payment,
			COUNT(payment_id) as soluong_hd
FROM payment
GROUP BY customer_id)
SELECT c.customer_id,c.first_name,soluong_hd,avg_payment,d.amount
FROM customer c
JOIN amount_payment as p ON c.customer_id=p.customer_id
JOIN payment as d ON d.customer_id =p.customer_id
WHERE d.amount>avg_payment
ORDER BY customer_id
 
