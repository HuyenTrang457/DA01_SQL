--select * from public.sales_dataset_rfm_prj_clean
/*1) Doanh thu theo từng ProductLine, Year  và DealSize?
Output: PRODUCTLINE, YEAR_ID, DEALSIZE, REVENUE */
SELECT productline, year_id, dealsize, 
					SUM(sales) AS revenue
			FROM sales_dataset_rfm_prj_clean
			GROUP BY productline, year_id, dealsize
			ORDER BY productline, year_id, dealsize
/*2) Đâu là tháng có bán tốt nhất mỗi năm?
Output: MONTH_ID, REVENUE, ORDER_NUMBER
*/
SELECT month_id, revenue, order_number
FROM 
	(select  month_id,year_id, sum(sales) as revenue, count(ordernumber) as order_number,
	 rank() over(partition by year_id order by sum(sales) desc ,count(ordernumber) desc) AS stt
	from sales_dataset_rfm_prj_clean
	 group by month_id, year_id
	) AS a
WHERE stt=1

/*3) Product line nào được bán nhiều ở tháng 11?
Output: MONTH_ID, REVENUE, ORDER_NUMBER
*/
SELECT productline, revenue, order_number
FROM 
	(select  productline,month_id,year_id, sum(sales) as revenue, count(ordernumber) as order_number,
	 	rank() over(partition by year_id order by sum(sales) desc ,count(ordernumber) desc) AS stt
	from sales_dataset_rfm_prj_clean
	 where month_id=11
	 group by month_id, year_id,productline
	 order by year_id, stt
	) AS a
WHERE stt=1 

/*4) Đâu là sản phẩm có doanh thu tốt nhất ở UK mỗi năm? 
Xếp hạng các các doanh thu đó theo từng năm.
Output: YEAR_ID, PRODUCTLINE,REVENUE, RANK
*/
SELECT * FROM 
	(select year_id, productline, sum(sales) as revenue,
		rank() over(partition by year_id order by sum(sales) desc ) as rank
	from sales_dataset_rfm_prj_clean
	where country='UK'
	group by  year_id, productline) AS a
WHERE rank =1


/*5) Ai là khách hàng tốt nhất, phân tích dựa vào RFM 
(sử dụng lại bảng customer_segment ở buổi học 23)
*/
--B1: tinh RFM
WITH rfm AS
(select contactfullname, postalcode,
		current_date - max(orderdate) as R,
		COUNT(distinct ordernumber) as F,
		SUM(sales) as M
FROM public.sales_dataset_rfm_prj_clean
group by  contactfullname, postalcode)
--B2: chia cac gtri tu 1-->5
,CTE as (select contactfullname, postalcode,
		ntile(5) over(order by R desc) AS R_score,
		ntile(5) over(order by F ) AS F_score,
		ntile(5) over(order by M ) AS M_score
from rfm)

--B3: phan nhom 
, rfm_final as (SELECT contactfullname, postalcode,
cast(R_score AS varchar)||cast(F_score AS varchar)||cast(M_score AS varchar) as rfm_score
FROM CTE)

SELECT b.contactfullname, b.postalcode,b.rfm_score
FROM public.segment_score a
JOIN rfm_final b ON a.scores=b.rfm_score
 where segment = 'Champions'
 
 
 
 
 
 
 
 
 


















































