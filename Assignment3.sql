--1.In SQL Server, assuming you can find the result by using both joins and subqueries, 
--which one would you prefer to use and why?
-- On a case by case basis, I prefer to joins most of the time because joins execute faster and have better performance.
-- But in the case that I need to group by multiple columns when join, I prefer using subqueries.

--2.What is CTE and when to use it?
--CTE stands for Common Table Expression. 
--CTE is a temporary named result set that you can reference within a SELECT, INSERT, UPDATE, or DELETE statement.
--can be defined in user-defined routines, such as functions, stored procedures, triggers, or views.
--used when 1. create a recursive query 2. It can be a substitute of view when the general of a view is not required
--3. Improve readibility and ease in maintenance.

--3.What are Table Variables? What is their scope and where are they created in SQL Server?
--A table variable is a data type that can be used within a Transact-SQL batch, stored procedure, 
--or function—and is created and defined similarly to a table, only with a strictly defined lifetime scope. 


--4.What is the difference between DELETE and TRUNCATE? Which one will have better performance and why?
--Truncate reseeds identity values, whereas delete doesn't.
--Truncate removes all records and doesn't fire triggers.
--Truncate is faster compared to delete as it makes less use of the transaction log.
--Truncate is not possible when a table is referenced by a Foreign Key or tables are used in replication or with indexed views.

--5.What is Identity column? How does DELETE and TRUNCATE affect it?
--Truncate reseeds identity values, whereas delete doesn't.

--6.What is difference between “delete from table_name” and “truncate table table_name”?
--Truncate reseeds identity values, whereas delete doesn't.
--Truncate removes all records and doesn't fire triggers.
--Truncate is faster compared to delete as it makes less use of the transaction log.
--Truncate is not possible when a table is referenced by a Foreign Key or tables are used in replication or with indexed views.


USE Northwind
GO

--1.List all cities that have both Employees and Customers.


Select distinct c.city from customers c
inner join employees e
on c.city=e.city 

--2.List all cities that have Customers but no Employee.
--a.Use sub-query

select distinct city from customers
where city NOT IN (Select City from employees)

--b.Do not use sub-query


Select distinct c.city from customers c
left join employees e
on c.city=e.city 

--3.List all products and their total order quantities throughout all orders.
select p.ProductName, SUM(d.Quantity) 'quantity' from [Order Details] d
join  products p
on d.productid = p.productid
group by p.productname

--4.List all Customer Cities and total products ordered by that city.
select c.city,count(d.productid) 'types of products ordered' from [order details] d--count(d.productid) 'types of products ordered' 
join orders o
on o.orderid = d.orderid
right join customers c
on o.customerid = c.customerid
group by c.city,o.shipcity


--5.List all Customer Cities that have at least two customers.
--a.Use union

select city,count(customerid) 'customer counts' from customers
group by city 
having count(customerid) > 2


--b.Use sub-query and no union

select city,count(customerid) 'customer counts' from customers
group by city 
having count(customerid) > 2

--6.List all Customer Cities that have ordered at least two different kinds of products.

with CTEnew as
(select distinct c.City,d.ProductID from [order details] d--count(d.productid) 'types of products ordered' 
join orders o
on o.orderid = d.orderid
right join customers c
on o.ShipCity = c.city)

select city,count(productid) 'Counts' from CTEnew
group by city
having count(productid) > 2


--7.List all Customers who have ordered products, but have the ‘ship city’ on the order different from their own customer cities.

with CTEnew as
(select c.ContactName, o.shipcity, c.city from customers c
full join orders o
on o.customerid = c.customerid)

select distinct * from CTEnew
where shipcity <> city
order by contactname

--8.List 5 most popular products, their average price, and the customer 
--city that ordered most quantity of it.

--top 5 products and quantity and price
with CTEproduct as
(select top 5 p.productname,p.ProductID, sum(d.quantity) 'quantity ordered'  from orders o
join [Order Details] d
on o.orderid = d.orderid
join products p 
on p.productid = d.productid
group by p.productname,p.ProductID
order by [quantity ordered] DESC)

select o.shipcity, d.productid, sum(d.Quantity) 'total' from orders o
inner join [Order Details] d
on o.orderid = d.orderid
group by o.shipcity, d.productid
having d.productid in (select productid from CTEproduct)



--9.List all cities that have never ordered something but we have employees there.
--a.Use sub-query

select city from employees
where city not in
(select shipcity from orders)

--b.Do not use sub-query
select distinct e.city from employees e
left join orders o
on e.city = o.shipcity 
where o.shipcity is null

--10.List one city, if exists, that is the city from where the employee 
--sold most orders (not the product quantity) is, and also the city of most 
--total quantity of products ordered from. (tip: join  sub-query)
???

select top 1 o.shipcity, sum(d.Quantity) 'quantity' from [Order Details] d
inner join Orders o
on o.orderid = d.orderid
group by o.shipcity
order by 'quantity' desc


--11.How do you remove the duplicates record of a table?

--Insert the distinct rows from the duplicate rows table to new 
--temporary table. Then delete all the data from duplicate rows 
--table then insert all data from temporary table which has no duplicates as shown below.


--12.Sample table to be used for solutions below- 
--Employee ( empid integer, mgrid integer, deptid integer, salary integer) 
--Dept (deptid integer, deptname text)
--Find employees who do not manage anybody.

select empid from employee
where empid not in
(select distinct mgrid from employee where mgrid is not null)

--13.Find departments that have maximum number of employees. 
--(solution should consider scenario having more than 1 departments 
--that have maximum number of employees). Result should only have - deptname, 
--count of employees sorted by deptname.

Select DEPTNAME from dept 
where DEPTID = (select DEPTID from 
(Select DEPTID, count(DEPTID) from Employee 
group by DEPT_ID order by count(DEPT_ID) desc) 
where rownum = 1)

--14.Find top 3 employees (salary based) in every department. 
--Result should have deptname, empid, salary sorted by deptname 
--and then employee with high to low salary.

select e.empid,d.deptname,max(e.salary) from employee e
inner join dept d
on e.deptid = d.deptid
where 
(select count(distinct salary) from employee as e2
where e2.salary > e1.salary and e1.deptid = e2.deptid
)
order by dept asc, salary desc