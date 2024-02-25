
--Bước 1: tính giá tri RFM

WITH customer_rfm AS

(select a.customer_id, 
current_date - MAX(cast(b.order_date as timestamp)) AS R,
COUNT(DISTINCT b.order_id) AS F,
SUM(b.sales) AS M
FROM customer a
JOIN sales b ON a.customer_id=b.customer_id
GROUP BY a.customer_id)

--Bước 2: chia các giá trị thành các khoảng trên thang 1->5
,rfm_score AS (SELECT customer_id,
ntile(5) OVER(ORDER BY R DESC) AS R_score,
ntile(5) OVER(ORDER BY F DESC) AS F_score,
ntile(5) OVER(ORDER BY M DESC) AS M_score
FROM customer_rfm)

--Bước 3: Phân nhóm theo 125 tổ hợp RFM
, rfm_final as (SELECT customer_id,
cast(R_score AS varchar)||cast(F_score AS varchar)||cast(M_score AS varchar) as rfm_score
FROM rfm_score)

SELECT segment,COUNT(*) as amount
FROM (SELECT a.customer_id,
b.segment AS segment
FROM rfm_final a
JOIN public.segment_score b ON a.rfm_score=b.scores) AS a
GROUP BY segment
order by COUNT(*)






















