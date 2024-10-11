--- 1. top 5 customer who have placed the most orders
SELECT o.customer_id, count(o.customer_id) as amount
FROM orders as o
JOIN customers as c on o.customer_id=c.customer_id 
GROUP BY o.customer_id
order by amount desc 
limit 5

---2. top 10 producrs that have been ordered the most
 SELECT c.product_name,a.product_id, count(b.order_id) as amount
    FROM order_details as a
    JOIN orders as b ON a.order_id= b.order_id
    join products as c on c.product_id= a.product_id
    GROUP BY a.product_id,c.product_name
	ORDER BY amount desc 
	LIMIT 10 

---3.Sales revenue by each category in 1997:
SELECT b.category_id,d.category_name, SUM(a.unit_price*a.quantity*(1-a.discount)) as revenue
FROM order_details as a
JOIN products as b ON a.product_id= b.product_id
JOIN orders as c ON c.order_id= a.order_id
join categories as d on d.category_id= b.category_id
WHERE EXTRACT( YEAR FROM c.order_date) = '1997'
GROUP BY b.category_id,d.category_name



---4. number of orders placed by each employee in 1996
select e.employee_id, e.last_name, e.first_name, count(o.order_id) as number_orders
from orders as o 
join employees as e ON o.employee_id= e.employee_id
WHERE EXTRACT( YEAR FROM o.order_date) = '1996'
group by e.employee_id, e.last_name,e.first_name

---5. find customers who not placed any orders
SELECT c.company_name
FROM customers AS c
LEFT JOIN orders AS o ON o.customer_id = c.customer_id
WHERE o.order_id IS NULL


---Python------------------------------------------------------------------------------------------


## EX1

a= list(map(int, input().split()))
b= a[::-1]
for i in range(len(b)):
    print(b[i],end=" ")

##EX2
import mysql.connector
def write_to_mysql(products): 
   db = mysql.connector.connect( 
      host="your_host", # e.g., "localhost"
      user="root", # e.g., "root" 
      password="root",# e.g., "password"
      database="mydatabase" # e.g., "product_db" 
      ) 
   mycursor = db.cursor() 
   #mycursor.execute("CREATE DATABASE mydatabase") # Create new table 
   mycursor.execute("CREATE TABLE IF NOT EXISTS products (name VARCHAR(100),price DECIMAL(10, 2),quantity INT)") 
   Insert data into table mycursor.execute("INSERT INTO products (name, price, quantity) VALUES (%s, %s, %s)",("Milks","15","1000")) 
   for product in products: 
      print(product) 
   db.commit() 
   mycursor.close() 
   db.close()


##EX3
import time 
def time_decorator(func):
   def wrapper(*args,**kwargs):
      time_before = time.time()
      result = func(*args, **kwargs)  
      print("function took:",time.time()- time_before,"(s)")
      return result
   return wrapper
