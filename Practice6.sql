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
 
  
