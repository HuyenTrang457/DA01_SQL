--GROUP BY, HAVING

select customer_id, DATE(payment_date),
round(avg(amount),3) as average_amount,
count(payment_id) as amount_payment
from payment
where (DATE(payment_date) between '2020-04-28' and '2020-05-01')

group by customer_id, DATE(payment_date)
having count(payment_id)>1
order by customer_id  desc
