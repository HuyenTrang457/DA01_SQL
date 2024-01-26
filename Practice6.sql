--EX1
-- count of companies that have posted duplicate job listings.
WITH count_dupl AS
  (SELECT company_id,COUNT(company_id) as company_count,
  title, description
  FROM job_listings
  GROUP BY company_id,title,description)
  
  SELECT COUNT(company_count) as duplicate_companies
  FROM count_dupl
  WHERE company_count=2

--EX3
WITH CTE_amount as
(SELECT policy_holder_id,
  COUNT(case_id)  AS amount_case
FROM callers
GROUP BY policy_holder_id
)

SELECT COUNT(policy_holder_id)
FROM CTE_amount
  WHERE amount_case >=3

--EX4
 SELECT a.page_id
 FROM pages a
 LEFT JOIN page_likes b ON a.page_id=b.page_id
   WHERE user_id is NULL
 ORDER BY a.page_id 
--EX4/ cach2
 SELECT page_id
 FROM pages 
   WHERE page_id NOT IN (
    SELECT page_id FROM page_likes
 )
--EX5
WITH curr_d AS
(SELECT user_id,event_date
FROM user_actions
  WHERE EXTRACT(MONTH from event_date)='7'),

past_d AS 
(SELECT user_id,event_date
FROM user_actions
  WHERE EXTRACT(MONTH from event_date)='6'
)

SELECT EXTRACT(MONTH from a.event_date) AS mth,
    COUNT(DISTINCT a.user_id) monthly_active_users
FROM curr_d a
  JOIN past_d b ON a.user_id=b.user_id
  GROUP BY EXTRACT(MONTH from a.event_date)

--EX6
SELECT SUBSTRING(trans_date,1,7 ) AS month, country,  
COUNT(id) trans_count, 
SUM(CASE
        WHEN state='approved' THEN 1 ELSE 0
END) AS approved_count,
SUM(amount)AS trans_total_amount, 
SUM(CASE
        WHEN state='approved' THEN amount ELSE 0
END) AS approved_total_amount
FROM Transactions
GROUP BY country, SUBSTRING(trans_date,1,7 )

--EX7

SELECT product_id, MIN(year) AS first_year,quantity,price
FROM Sales
  GROUP BY product_id

--EX8
SELECT customer_id
FROM customer
  GROUP BY customer_id
  HAVING COUNT(DISTINCT product_key )= (SELECT COUNT(*) FROM Product)

--EX9
SELECT employee_id
 FROM Employees
   WHERE salary< 30000 AND manager_id NOT IN (SELECT employee_id FROM Employees)
 ORDER BY employee_id

--EX10
  WITH count_dupl AS
    (SELECT company_id,COUNT(company_id) as company_count,
  title, description
  FROM job_listings
  GROUP BY company_id,title,description)
  
  SELECT COUNT(company_count) as duplicate_companies
  FROM count_dupl
    WHERE company_count=2

--EX11
 
  (
    SELECT b.name AS results
    FROM MovieRating a
        JOIN Users AS b ON a.user_id=b.user_id
        GROUP BY a.user_id
    ORDER BY  COUNT(a.user_id) DESC,b.name
        LIMIT 1)
UNION ALL
(
     SELECT  d.title AS results
    FROM MovieRating c
    JOIN Movies d ON c.movie_id=d.movie_id
    WHERE EXTRACT(YEAR FROM created_at)=2020 AND EXTRACT(MONTH FROM created_at)=2
        GROUP BY c.movie_id
    ORDER BY AVG(rating) DESC, d.title
        LIMIT 1
)

--EX12
WITH CTE_A AS (SELECT requester_id FROM RequestAccepted
UNION ALL
    SELECT accepter_id FROM RequestAccepted)
SELECT requester_id AS id,COUNT(*) AS num
FROM CTE_A
    GROUP BY requester_id
ORDER BY num DESC
    LIMIT 1





