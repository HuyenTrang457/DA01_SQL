--ex1
LECT NAME FROM CITY
WHERE POPULATION >120000
AND COUNTRYCODE= 'USA'
--ex2
SELECT * from CITY
WHERE COUNTRYCODE ='JPN' 
--ex3
SELECT CITY, STATE FROM STATION
--ex4

SELECT CITY FROM STATION 
WHERE CITY LIKE 'a%' 
OR CITY LIKE 'e%'
OR CITY LIKE 'i%'
OR CITY LIKE 'o%'
OR CITY LIKE 'u%'

--ex7
SELECT name  FROM Employee
ORDER BY name asc
--ex8
SELECT name FROM Employee
WHERE salary >2000 AND months <10
ORDER BY employee_id asc

--ex9
SELECT  product_id FROM Products
WHERE low_fats= 'Y' AND recyclable='Y'

--ex10
SELECT name FROM Customer
WHERE  id !=2
--ex11
# Write your MySQL query statement below
SELECT name, population, area FROM World
WHERE area >= 3000000 AND population >=  25000000
