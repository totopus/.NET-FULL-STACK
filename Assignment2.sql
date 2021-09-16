
--1.What is a result set?
-- A result set is the output of a query

--2.What is the difference between Union and Union All?
--Union extracts the rows that that are being specified in the query
--Union All extracts all the rows including the duplicates from both the queries

--3.What are the other Set Operators SQL Server has?
--There are also EXCEPT and INTERSECT

--4.What is the difference between Union and Join?
--Join is used to combine columns from different tables
--Union is used to combine rows

--5.What is the difference between INNER JOIN and FULL JOIN?
--A full join returns all rows in both the left and right tables
--Any time a row has no match in the other table, the select list columns
--from the other table contain null values. When there is match from the
--tables, the entire result set row contains data values from the base table

--Inner join fetches data from both left and right tables which satisfy the join condition.

--6.What is difference between left join and outer join
--An outer join returns all rows in both the left and right tables
--Any time a row has no match in the other table, the select list columns
--from the other table contain null values. When there is match from the
--tables, the entire result set row contains data values from the base table

--Left join fetches all data from left table and only that data from right table
--which satisfy the join condition. For extra record from the left table, right
--table will return null value.

--7.What is cross join?

--8.What is the difference between WHERE clause and HAVING clause?
--Where clause is used in the selection of rows according to given conditions.
--Having clause is used to specify a condition for filtering values from a group.

--9.Can there be multiple group by columns?
--Yes. A group by clause can contain two or more columns

Use AdventureWorks2019
GO

--1.How many products can you find in the Production.Product table?
Select Count(1) As [Products Count] From Production.Product

--2.Write a query that retrieves the number of products in the Production.
--Product table that are included in a subcategory. The rows that have NULL 
--in column ProductSubcategoryID are considered to not be a part of any subcategory.

Select Count(ProductSubcategoryID) As [Products Count] From Production.Product

--3.How many Products reside in each SubCategory? Write a query to display the results with the following titles.
--ProductSubcategoryID CountedProducts
-------------------- ---------------

Select  ProductSubcategoryID, COUNT(ProductSubcategoryID) AS CountedProducts From Production.Product
Group By ProductSubcategoryID
Having ProductSubcategoryID IS NOT NULL

--4.How many products that do not have a product subcategory. 

Select COUNT(1) - COUNT(ProductSubcategoryID) AS [Products Count] From Production.Product

--5.Write a query to list the summary of products quantity in the Production.ProductInventory table.

Select COUNT(1) AS [Sum] From Production.ProductInventory 

Select ProductID, SUM(Quantity) AS [Products Quantity] From Production.ProductInventory
Group By ProductID

--6.Write a query to list the summary of products in the Production.ProductInventory 
--table and LocationID set to 40 and limit the result to include just summarized quantities less than 100.
--              ProductID    TheSum
-----------        ----------

Select ProductID, SUM(Quantity) AS [The Sum] From Production.ProductInventory
Where LocationID = 40
Group By ProductID 
Having SUM(Quantity) < 100


--7.Write a query to list the summary of products with the shelf information in the 
--Production.ProductInventory table and LocationID set to 40 and limit the result to 
--include just summarized quantities less than 100
--Shelf      ProductID    TheSum
---------- -----------        -----------

Select Shelf,ProductID, SUM(Quantity) AS [TheSum] From Production.ProductInventory
Where LocationID = 40
Group By ProductID,Shelf
Having SUM(Quantity) < 100

--8.Write the query to list the average quantity for products where column LocationID 
--has the value of 10 from the table Production.ProductInventory table.

Select AVG(Quantity) AS [Average Quantity] From Production.ProductInventory
Where LocationID = 10

--9.Write query to see the average quantity of products by shelfs from the table Production.ProductInventory
--ProductID   Shelf      TheAvg
----------- ---------- -----------

Select ProductID, Shelf, AVG(Quantity) AS [TheAvg] From Production.ProductInventory
Group By ProductID, Shelf

--10.Write query  to see the average quantity  of  products by shelf excluding rows 
--that has the value of N/A in the column Shelf from the table Production.ProductInventory
--ProductID   Shelf      TheAvg
----------- ---------- -----------

Select ProductID, Shelf, AVG(Quantity) AS [TheAvg] From Production.ProductInventory
Where Shelf IS NOT NULL
Group By Shelf, ProductID
Order By Shelf,ProductID

--11.List the members (rows) and average list price in the Production.Product table. 
--This should be grouped independently over the Color and the Class column. Exclude the rows where Color or Class are null.
--Color           	Class 	TheCount   	 AvgPrice
--------------	- ----- 	----------- 	---------------------
Select * From Production.Product

Select Color, Class, COUNT(1) AS [TheCount], AVG(ListPrice) AS [AvgPrice] From Production.Product
Where Color IS NOT NULL AND Class IS NOT NULL
Group By Color, Class

--12.Write a query that lists the country and province names from person.CountryRegion and person.StateProvince tables. 
--Join them and produce a result set similar to the following. 
--Country                        Province
---------                          ----------------------

Select c.Name AS [Country], p.Name AS [Province] From Person.CountryRegion c
Join Person.StateProvince p
ON p.CountryRegionCode = c.CountryRegionCode
Order By Country

--13.Write a query that lists the country and province names from person. CountryRegion and person. StateProvince 
--tables and list the countries filter them by Germany and Canada. Join them and produce a result set similar to the following.
--Country                        Province
---------                          ----------------------

Select c.Name AS [Country], p.Name AS [Province] From Person.CountryRegion c
Join Person.StateProvince p
ON p.CountryRegionCode = c.CountryRegionCode
AND c.Name IN ('Germany','Canada')
Order By Country

--Using Northwnd Database: (Use aliases for all the Joins)
Use Northwind
GO
--14.List all Products that has been sold at least once in last 25 years.

Select p.ProductName AS [ProductName], COUNT(d.ProductID) AS [Quantity Sold]From [Order Details] d
Left Join Products p 
ON d.ProductID = p.ProductID
Group By d.ProductID,p.ProductName
Having COUNT(d.ProductID) > 0
Order By ProductName

--15.List top 5 locations (Zip Code) where the products sold most.
Select TOP 5 ShipPostalCode AS [Locations], COUNT(ShipPostalCode) AS [Counts] From Orders
Where ShipPostalCode IS NOT NULL
Group By ShipPostalCode
Order By Counts DESC

--16.List top 5 locations (Zip Code) where the products sold most in last 20 years??????????
Select TOP 5 ShipPostalCode AS [Locations], COUNT(ShipPostalCode) AS [Counts] From Orders
Where ShipPostalCode IS NOT NULL
Group By ShipPostalCode
Order By Counts DESC

--17.List all city names and number of customers in that city. 
Select City, COUNT(CustomerID) AS [Number of Customers] From Customers
Group By City
Order By [Number of Customers] DESC

--18.List city names which have more than 10 customers, and number of customers in that city 

Select City, COUNT(CustomerID) AS [Number of Customers] From Customers
Group By City
Having COUNT(CustomerID) > 10

--19.List the names of customers who placed orders after 1/1/98 with order date.

Select c.ContactName,o.OrderDate From Orders o
Join Customers c
ON c.CustomerID = o.CustomerID AND o.OrderDate > '1998-01-01 00:00:00.000'
Order By ContactName

--20.List the names of all customers with most recent order dates 

Select c.ContactName,MAX(o.OrderDate) AS [Most Recent Date] From Orders o
Join Customers c
ON c.CustomerID = o.CustomerID AND o.OrderDate > '1998-01-01 00:00:00.000'
Group By(ContactName)
Order By ContactName

--21.Display the names of all customers  along with the  count of products they bought 

Select c.ContactName, SUM(d.Quantity) AS [Count of Products] From Customers c
Join Orders o
ON c.CustomerID = o.CustomerID
Join [Order Details] d
ON o.OrderID = d.OrderID
Group By c.ContactName
Order By [Count of Products] DESC

--22.Display the customer ids who bought more than 100 Products with count of products.

Select c.CustomerID, SUM(d.Quantity) AS [Count of Products] From Customers c
Join Orders o
ON c.CustomerID = o.CustomerID
Join [Order Details] d
ON o.OrderID = d.OrderID
Group By c.CustomerID
Having SUM(d.Quantity) >100
Order By [Count of Products]

--23.List all of the possible ways that suppliers can ship their products. Display the results as below
--Supplier Company Name   	Shipping Company Name
---------------------------------            ----------------------------------

Select DISTINCT s.CompanyName AS [Supplier Company Name], i.CompanyName AS [Shipping Company Name]From Orders o
Join Shippers i
ON o.ShipVIa = i.ShipperID
Full Join [Order Details] d
ON o.OrderID = d.OrderID
Join Products p
ON p.ProductID = d.ProductID
Join Suppliers s
ON s.SupplierID = p.SupplierID
Order By [Supplier Company Name]

--24.Display the products order each day. Show Order date and Product Name.

Select o.OrderDate, p.ProductName From Orders o
Right Join [Order Details] d
ON d.OrderID = o.OrderID
Join Products p
ON p.ProductID = d.ProductID
Order By o.OrderDate

--25.Displays pairs of employees who have the same job title.

Select DISTINCT CONCAT(a.FirstName,' ',a.LastName) AS Employee1, CONCAT(b.FirstName,' ',b.LastName) AS Employee2 From Employees a
INNER JOIN Employees b
ON a.Title = b.Title AND a.FirstName <> b.FirstName

--26.	Display all the Managers who have more than 2 employees reporting to them.

Select CONCAT(a.FirstName,' ',a.LastName) As Manager,COUNT(CONCAT(a.FirstName,' ',a.LastName)) AS [Number of Employees] From Employees a
Join Employees b
ON a.EmployeeID=b.ReportsTo
Group By CONCAT(a.FirstName,' ',a.LastName)
Having COUNT(CONCAT(a.FirstName,' ',a.LastName)) > 2

--27.	Display the customers and suppliers by city. The results should have the following columns
--City Name Contact Name,Type (Customer or Supplier)

Select City AS [City Name], ContactName AS [Contact Name], 'Customer' AS [Type] From Customers
UNION ALL
Select City AS [City Name], ContactName AS [Contact Name], 'Supplier' AS [Type] From Suppliers

--28. Have two tables T1 and T2
--Please write a query to inner join these two tables and write down the result of this query.

Select t1.F1, t2.F2 From T1 t1 
Inner Join T2 t2
ON t1.F1 = t2.F2

--29. Based on above two table, Please write a query to left outer join these two tables and write down the result of this query.
Select t1.F1, t2.F2 From T1 t1 
Left Join T2 t2
ON t1.F1 = t2.F2

F1.T1	F2.T2
  1	    null
  2	    null
  3	    null

