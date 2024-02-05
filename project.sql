


--1.Chuyển đổi kiểu dữ liệu 
SET datestyle = 'iso,mdy';  
ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN orderdate TYPE date USING (TRIM(orderdate):: date)

ALTER TABLE sales_dataset_rfm_prj ALTER COLUMN ordernumber TYPE INTEGER USING ordernumber::integer;
ALTER TABLE sales_dataset_rfm_prj ALTER COLUMN quantityordered TYPE INTEGER USING quantityordered::integer;
ALTER TABLE sales_dataset_rfm_prj ALTER COLUMN priceeach TYPE DECIMAL(18,2) USING priceeach::decimal;
ALTER TABLE sales_dataset_rfm_prj ALTER COLUMN orderlinenumber TYPE INTEGER USING orderlinenumber::integer;
ALTER TABLE sales_dataset_rfm_prj ALTER COLUMN sales TYPE DECIMAL(18,2) USING sales::decimal;
ALTER TABLE sales_dataset_rfm_prj ALTER COLUMN productline TYPE TEXT USING productline::text;
ALTER TABLE sales_dataset_rfm_prj ALTER COLUMN customername TYPE VARCHAR USING customername::varchar;
ALTER TABLE sales_dataset_rfm_prj ALTER COLUMN msrp TYPE INTEGER USING msrp::integer;
--2.Check NULL/BLANK (‘’)ở các trường: ORDERNUMBER, QUANTITYORDERED, PRICEEACH, ORDERLINENUMBER, SALES, ORDERDATE.
SELECT *
FROM sales_dataset_rfm_prj
WHERE ORDERLINENUMBER IS NULL OR QUANTITYORDERED IS NULL OR PRICEEACH IS NULL 
OR ORDERLINENUMBER IS NULL OR  SALES IS NULL OR  ORDERDATE IS NULL


--3.Thêm cột CONTACTLASTNAME, CONTACTFIRSTNAME được tách ra từ CONTACTFULLNAME . 

ALTER TABLE sales_dataset_rfm_prj
ADD COLUMN contactlastname VARCHAR(50),
ADD COLUMN contactfirstname VARCHAR(50)

UPDATE sales_dataset_rfm_prj
SET
    contactlastname = LEFT(contactfullname,POSITION('-' IN contactfullname)-1),
    contactfirstname = SUBSTRING(contactfullname FROM POSITION('-' IN contactfullname)+1 FOR 30);
/*3.Chuẩn hóa CONTACTLASTNAME, CONTACTFIRSTNAME theo định dạng chữ cái đầu tiên viết hoa,
chữ cái tiếp theo viết thường */
UPDATE sales_dataset_rfm_prj
SET	
	contactlastname = INITCAP(contactlastname),
	contactfirstname = INITCAP(contactfirstname)
	
/* 4.Thêm cột QTR_ID, MONTH_ID, YEAR_ID lần lượt là Qúy, tháng, năm được lấy ra từ ORDERDATE */
ALTER TABLE sales_dataset_rfm_prj
		ADD COLUMN QTR_ID INT, 
		ADD COLUMN MONTH_ID INT,
		ADD COLUMN YEAR_ID INT 
UPDATE  sales_dataset_rfm_prj
SET MONTH_ID = EXTRACT(MONTH FROM orderdate),
 	YEAR_ID = EXTRACT(YEAR FROM orderdate),
	QTR_ID= (MONTH_ID-1)/3+1

/*5.Hãy tìm outlier (nếu có) cho cột QUANTITYORDERED và hãy chọn cách xử lý cho bản ghi đó (2 cách)*/
--cách 1: sử dụng BOXPLOT
--B1: Xd Q1, Q3, IQR -->B2: Min= Q1-1.5*IQR, MAX= Q3+1.5*IQR
WITH CTE AS(SELECT Q1-1.5*IQR AS min_data ,  Q3+1.5*IQR AS max_data
FROM 
		(SELECT 
				percentile_cont(0.25) WITHIN GROUP (ORDER BY quantityordered) AS Q1,
				percentile_cont(0.75) WITHIN GROUP (ORDER BY quantityordered) AS Q3,
				percentile_cont(0.75) WITHIN GROUP (ORDER BY quantityordered) - percentile_cont(0.25) WITHIN GROUP (ORDER BY quantityordered) AS IQR
		FROM public.sales_dataset_rfm_prj) AS a )

SELECT * FROM public.sales_dataset_rfm_prj
WHERE quantityordered<(SELECT min_data FROM CTE) OR quantityordered> (SELECT max_data FROM CTE)
		
 --cach 2: sd Z-score= (users-avg)/stddev (stddev: độ lệch chuẩn)
 WITH CTE_A AS (SELECT quantityordered,
 		(SELECT AVG(quantityordered) AS avg_quan FROM sales_dataset_rfm_prj),
 		(SELECT stddev(quantityordered) AS stddev FROM sales_dataset_rfm_prj)
 		FROM sales_dataset_rfm_prj),
 
WITH CTE_B AS (SELECT *, (quantityordered-avg_quan)/stddev AS Z_SCORE FROM CTE_A
		WHERE ABS((quantityordered-avg_quan)/stddev) >=3)
 
-- xử lí outlier
--cách 1:
 UPDATE sales_dataset_rfm_prj
 SET quantityordered=(SELECT AVG(quantityordered) 
            FROM sales_dataset_rfm_prj)
 WHERE quantityordered IN(SELECT quantityordered FROM CTE_B )
 
--cách 2: 
DELETE FROM sales_dataset_rfm_prj
WHERE quantityordered IN(SELECT quantityordered FROM CTE_B )

--6.Sau khi làm sạch dữ liệu, hãy lưu vào bảng mới  tên là 
CREATE TABLE SALES_DATASET_RFM_PRJ_CLEAN
AS SELECT * FROM sales_dataset_rfm_prj







