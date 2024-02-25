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
	 rank() over(partition by year_id order by sum(sales),count(ordernumber)) AS stt
	from sales_dataset_rfm_prj_clean
	 group by month_id, year_id
	) AS a
WHERE stt=1






























