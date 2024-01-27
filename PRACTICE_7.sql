--EX1
WITH CTE_A AS 
  (SELECT EXTRACT(YEAR FROM transaction_date) AS year, product_id, spend AS curr_year_spend,
      LAG(spend) OVER(PARTITION BY product_id ORDER BY EXTRACT(YEAR FROM transaction_date))
          AS prev_year_spend
  FROM user_transactions)
    
SELECT year, product_id,curr_year_spend,prev_year_spend,
    ROUND(100*((curr_year_spend-prev_year_spend)/prev_year_spend),2) AS yoy_rate
FROM CTE_A

--EX2
SELECT card_name,issued_amount
FROM
  (SELECT card_name,issued_amount,
      ROW_NUMBER() OVER (PARTITION BY issue_year ORDER BY issue_month) AS stt
  FROM monthly_cards_issued) AS m
  WHERE m.stt=1

--EX3
SELECT user_id,spend,transaction_date
FROM (SELECT user_id,spend, transaction_date,
          ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY transaction_date) AS stt
      FROM transactions) AS M
WHERE M.stt=3

--EX4
SELECT transaction_date,user_id,purchase_count
FROM 
  (SELECT transaction_date,user_id,
      COUNT(*) OVER(PARTITION BY user_id,DATE(transaction_date)) AS purchase_count, 
      ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY transaction_date DESC) AS stt
  FROM user_transactions) AS m
  WHERE m.stt=1
  ORDER BY transaction_date
