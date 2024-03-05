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
--EX3-----------------------------------------------------------
SELECT 
CASE
        WHEN id=(SELECT MAX(id) FROM Seat) AND id%2=1 THEN  id
        WHEN id%2=1 THEN id+1
        ELSE id-1
END AS  id,student
FROM Seat
ORDER BY id
---EX5---------------------------------------------------------
SELECT round(sum(tiv_2016),2) as tiv_2016
FROM Insurance
WHERE  tiv_2015 IN 
        (select tiv_2015 
        from insurance 
        group by tiv_2015
        having count(*)>1)

 AND (lat,lon) IN
        (select lat,lon
        from insurance 
        group by lat,lon
        having count(*)=1)
 

---EX6---------------------------------------------------------

WITH CTE AS (SELECT departmentId,name,salary,
                        DENSE_RANK() OVER(PARTITION BY departmentId ORDER BY salary DESC) AS stt
                FROM Employee)
SELECT b.name AS Department, a.name AS Employee, a.salary AS Salary
FROM CTE a
JOIN Department b ON a.departmentId=b.id
WHERE a.stt<=3
---EX7------------------------------------------------------------
with cte as (select person_name,
                sum(weight) over(order by turn) as sum 
        from Queue)
select person_name from cte
where sum <=1000
order by sum desc 
 limit 1
