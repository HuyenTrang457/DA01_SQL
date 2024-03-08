--sử dụng BOXPLOT-
--B1: Xd Q1, Q3, IQR
--B2: Min= Q1-1.5*IQR, MAX= Q3+1.5*IQR
 
 WITH CTE AS
       (SELECT  Q1-1.5*IQR AS Min_value, Q3+1.5*IQR AS Max_value
        FROM 
       (select percentile_cont(0.25) WITHIN GROUP (ORDER BY users) AS Q1,
               percentile_cont(0.75) WITHIN GROUP (ORDER BY users) AS Q3,
               percentile_cont(0.75) WITHIN GROUP (ORDER BY users)-percentile_cont(0.25) WITHIN GROUP (ORDER BY users) AS IQR
       FROM user_data) AS a)
 --XD outlier <min or >max
 SELECT *
 FROM user_data
 WHERE users< (SELECT Min_value FROM CTE) OR users> (SELECT Max_value FROM CTE)

-- sử dụng Z - SCORE
 --cach 2: sd Z-score= (users-avg)/stddev (độ lệch chuẩn)
 
 WITH CTE AS (SELECT data_date, users, 
      (SELECT AVG(users) AS avg
       FROM user_data),
      (SELECT  stddev(users) AS stddev
       FROM user_data)
 FROM user_data),

  CTE_2 AS (SELECT *,(users-avg)/stddev AS Z_score
            FROM CTE
                WHERE abs((users-avg)/stddev)>2)
 
 UPDATE user_data
 SET USERS=(SELECT AVG(users) AS avg
            FROM user_data)
 WHERE USERS IN(SELECT users FROM CTE_2 )
 

