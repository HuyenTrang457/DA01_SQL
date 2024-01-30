--EX1

SELECT 
        ROUND(SUM(CASE 
                        WHEN order_date = customer_pref_delivery_date THEN 1 ELSE 0
                END)*100.0/COUNT(DISTINCT customer_id),2) AS immediate_percentage
FROM Delivery
WHERE (customer_id,order_date) IN (
    SELECT customer_id,MIN(order_date) AS first_order_date
FROM Delivery
GROUP BY customer_id)

--EX2
--EX3
SELECT 
CASE
        WHEN id=(SELECT MAX(id) FROM Seat) AND id%2=1 THEN  id
        WHEN id%2=1 THEN id+1
        ELSE id-1
END AS  id,student
FROM Seat
ORDER BY id

--EX6

WITH CTE AS (SELECT departmentId,name,salary,
                        DENSE_RANK() OVER(PARTITION BY departmentId ORDER BY salary DESC) AS stt
                FROM Employee)
SELECT b.name AS Department, a.name AS Employee, a.salary AS Salary
FROM CTE a
JOIN Department b ON a.departmentId=b.id
WHERE a.stt<=3
