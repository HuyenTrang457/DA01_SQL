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

  
