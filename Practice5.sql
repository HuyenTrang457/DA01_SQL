--ex1
SELECT a.CONTINENT, FLOOR(AVG(b.POPULATION))
FROM COUNTRY as a
JOIN CITY as b ON a.CODE=b.COUNTRYCODE
GROUP BY a.CONTINENT

--EX2
SELECT ROUND((COUNT(t.email_id) :: DECIMAL
/COUNT(DISTINCT e.email_id)),2) AS confirm_rate
FROM emails e
LEFT JOIN texts t ON e.email_id=t.email_id
AND t.signup_action='Confirmed'

--EX3
