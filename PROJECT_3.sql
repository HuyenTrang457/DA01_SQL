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
SELECT month_id, revenue, order_number
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































