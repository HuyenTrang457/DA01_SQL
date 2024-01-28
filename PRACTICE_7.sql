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

  --EX4
  WITH CTE_A AS (SELECT user_id,tweet_date, tweet_count,
                        LAG(tweet_count,1) OVER(PARTITION BY user_id ORDER BY tweet_date ) AS last1,
                        LAG(tweet_count,2) OVER(PARTITION BY user_id ORDER BY tweet_date ) AS last2,
                        ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY tweet_date ) AS stt
                FROM tweets)

SELECT user_id, tweet_date,
CASE
    WHEN stt=1 THEN   ROUND(tweet_count/1.0,2)
    WHEN stt=2 THEN ROUND((tweet_count+last1)/2.0,2)
    WHEN stt>=3 THEN ROUND((tweet_count+last1+last2)/3.0 ,2)
END AS rolling_avg_3d
FROM CTE_A

--EX5
  
--EX6
  WITH CTE AS (SELECT merchant_id,credit_card_id,amount,transaction_timestamp AS time,
    LEAD(transaction_timestamp) OVER(PARTITION BY merchant_id,credit_card_id,amount ORDER BY transaction_timestamp ) AS next_time,
    (LEAD(transaction_timestamp) OVER (PARTITION BY merchant_id,credit_card_id,amount ORDER BY transaction_timestamp )
        - transaction_timestamp) AS diff
    FROM transactions)

SELECT COUNT(*) 
FROM CTE  
WHERE EXTRACT(HOUR FROM diff)*60+ EXTRACT(MINUTE FROM diff) <=10

--EX7
  WITH CTE_A AS (SELECT category,product ,SUM(spend) AS total_spend,
                      DENSE_RANK() OVER(PARTITION BY category ORDER BY SUM(spend) DESC) AS stt
                FROM product_spend
                WHERE EXTRACT(YEAR FROM transaction_date)='2022'
                GROUP BY product,category)
SELECT category,product,total_spend
FROM CTE_A
WHERE stt IN (1,2)


--EX8
WITH CTE_A AS (SELECT a.artist_name,
                    DENSE_RANK() OVER(ORDER BY COUNT(*) DESC ) AS artist_rank
              FROM artists AS a  
                JOIN songs AS b ON a.artist_id=b.artist_id
                JOIN global_song_rank AS c ON c.song_id=b.song_id
              WHERE c.rank<=10
              GROUP BY a.artist_name)

SELECT artist_name,artist_rank
FROM CTE_A
WHERE artist_rank<=5
