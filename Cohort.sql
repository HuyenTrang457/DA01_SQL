/* Bước 1: khám phá và làm sạch dữ liệu
- cta đang quan tâm đến trường nào
- check null
- chuyển đổi kiểu dữ liệu
- số tiền và số lượng >0
- check dup */
SELECT * FROM public.online_retail;
WITH CTE AS (SELECT invoiceno,
	stockcode,
	description,
	CAST(quantity AS INT) AS quantity,
	invoicedate,
	CAST(unitprice AS numeric) AS unitprice,
	customerid,
	country
FROM online_retail
WHERE customerid <> '' 
AND CAST(quantity AS INT) >0 AND  CAST(unitprice AS numeric)>0),

online_retail_main AS(SELECT * FROM (SELECT *, ROW_NUMBER() OVER(PARTITION BY invoiceno,stockcode,quantity ORDER BY invoicedate ) AS stt
FROM CTE) AS t 
WHERE stt=1),

/*Bước 2:
- tìm ngày mua hàng đầu tiên của mỗi khách hàng
- tìm index= tháng(ngày mua hàng - ngày đầu tiên) +1
- Count số lượng khhoặc tổng doanh thu tại mỗi cohort_date và index tương ứng 
- Pivot table */
online_retail_index AS 
(SELECT customerid, amount, 
		TO_CHAR(first_purchase_date,'yyyy-mm') AS cohort_date, 
		invoicedate,
		(EXTRACT(year FROM invoicedate)-EXTRACT(year FROM first_purchase_date))*12
			+ (EXTRACT(month FROM invoicedate)-EXTRACT(month FROM first_purchase_date)) +1 AS index
	FROM (SELECT  customerid, quantity*unitprice AS amount,
				MIN(invoicedate) OVER(PARTITION BY customerid ) AS first_purchase_date,
				invoicedate
		FROM online_retail_main) AS a),
xxx AS 	
(SELECT  cohort_date, index,
	COUNT(DISTINCT customerid) as cnt ,
	SUM(amount) AS revenue
FROM online_retail_index
GROUP BY cohort_date,index),

--pivot table --> cohort chart

--customer_cohort
customer_cohort AS 
(SELECT cohort_date,
SUM(CASE WHEN index=1 THEN cnt ELSE 0 END) AS "m1",
SUM(CASE WHEN index=2 THEN cnt ELSE 0 END) AS "m2",
SUM(CASE WHEN index=3 THEN cnt ELSE 0 END) AS "m3",
SUM(CASE WHEN index=4 THEN cnt ELSE 0 END) AS "m4",
SUM(CASE WHEN index=5 THEN cnt ELSE 0 END) AS "m5",
SUM(CASE WHEN index=6 THEN cnt ELSE 0 END) AS "m6",
SUM(CASE WHEN index=7 THEN cnt ELSE 0 END) AS "m7",
SUM(CASE WHEN index=8 THEN cnt ELSE 0 END) AS "m8",
SUM(CASE WHEN index=9 THEN cnt ELSE 0 END) AS "m9",
SUM(CASE WHEN index=10 THEN cnt ELSE 0 END) AS "m10",
SUM(CASE WHEN index=11 THEN cnt ELSE 0 END) AS "m11",
SUM(CASE WHEN index=12 THEN cnt ELSE 0 END) AS "m12",
SUM(CASE WHEN index=13 THEN cnt ELSE 0 END) AS "m13"
FROM xxx
GROUP BY cohort_date)

--retention cohort
SELECT cohort_date,
ROUND(100* m1/m1,0)||' %' AS m1,
ROUND(100*m2/m1,2)||' %' AS m2,
ROUND(100*m3/m1,2)||' %' AS m3,
ROUND(100*m4/m1,2)||' %' AS m4,
ROUND(100*m5/m1,2)||' %' AS m5,
ROUND(100*m6/m1,2)||' %' AS m6,
ROUND(100*m7/m1,2)||' %' AS m7,
ROUND(100*m8/m1,2)||' %' AS m8,
ROUND(100*m9/m1,2)||' %' AS m9,
ROUND(100*m10/m1,2)||' %' AS m10,
ROUND(100*m11/m1,2)||' %' AS m11,
ROUND(100*m12/m1,2)||' %' AS m12,
ROUND(100*m13/m1,2)||' %' AS m13
FROM customer_cohort




