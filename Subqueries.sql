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

 
