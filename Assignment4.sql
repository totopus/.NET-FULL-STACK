--1.What is View? What are the benefits of using views?
--2.Can data be modified through views?
--3.What is stored procedure and what are the benefits of using it?
--4.What is the difference between view and stored procedure?
--5.What is the difference between stored procedure and functions?
--6.Can stored procedure return multiple result sets?
--7.Can stored procedure be executed as part of SELECT Statement? Why?
--8.What is Trigger? What types of Triggers are there?
--9.What are the scenarios to use Triggers?
--10.What is the difference between Trigger and Stored Procedure?

use Northwind
go

--Use Northwind database. All questions are based on assumptions described by 
--the Database Diagram sent to you yesterday. When inserting, make up info if 
--necessary. Write query for each step. Do not use IDE. BE CAREFUL WHEN DELETING 
--DATA OR DROPPING TABLE.

--1.Lock tables Region, Territories, EmployeeTerritories and Employees. 
--Insert following information into the database. In case of an error, 
--no changes should be made to DB.
--a.A new region called “Middle Earth”;
begin tran
select * from region with (TABLOCKX)
select * from territories with (TABLOCKX)
select * from EmployeeTerritories with (TABLOCKX)
select * from Employees with (TABLOCKX)
rollback tran
go

insert into region (regionid, regiondescription)
values (5,'Middle Earth')

delete from region where regionid = 5

--b.A new territory called “Gondor”, belongs to region “Middle Earth”;
select * from territories
insert into territories (territoryid,territorydescription,regionid)
values (12354,'Gordon',5)

--c.A new employee “Aragorn King” who's territory is “Gondor”.
select * from employees
insert into employees (lastname,firstname)
values ('King','Aragorn')

select * from employeeterritories
insert into employeeterritories (employeeid,territoryid)
values (10,12354)

--2.Change territory “Gondor” to “Arnor”.
select * from territories
update territories set territorydescription = 'Arnor'
where territoryid = 12354


--3.Delete Region “Middle Earth”. (tip: remove referenced data first) 
--(Caution: do not forget WHERE or you will delete everything.) 
--In case of an error, no changes should be made to DB. 
--Unlock the tables mentioned in question 1.
select * from region
delete from employeeterritories where employeeid = 10
delete from territories where territorydescription = 'Arnor'
delete from region where regiondescription = 'Middle Earth'

--4.Create a view named “view_product_order_[your_last_name]”, 
--list all products and total ordered quantity for that product.
create view view_product_order_wang as
select p.productname, sum(d.quantity) total from [order details] d
right join products p
on p.productid = d.productid
group by p.productname

select * from view_product_order_wang

--5.Create a stored procedure “sp_product_order_quantity_[your_last_name]” 
--that accept product id as an input and total quantities of order as output parameter.

create procedure sp_product_order_quantity_wang @input int
as
select totalquantity from
(select productid,sum(quantity) as totalquantity from [order details]
group by productid) as new
where productid = @input

exec sp_product_order_quantity_wang @input = 23

--6.Create a stored procedure “sp_product_order_city_[your_last_name]” 
--that accept product name as an input and top 5 cities that ordered most that product 
--combined with the total quantity of that product ordered from that city as output.

create procedure sp_product_order_city_wang @input varchar(255) as
select * from
(select p.productname,sum(d.quantity) quantity, o.shipcity,
dense_rank() over(partition by productname order by sum(d.quantity) desc) as rnk
from orders o
inner join [order details] d
on o.orderid = d.orderid
inner join products p
on p.productid = d.productid
group by p.productname, o.shipcity) new
where rnk<=5 and productname = @input

exec sp_product_order_city_wang @input = "Alice Mutton"

--7.Lock tables Region, Territories, EmployeeTerritories and Employees. 
--Create a stored procedure “sp_move_employees_[your_last_name]” that automatically 
--find all employees in territory “Tory”; if more than 0 found, insert a new territory 
--“Stevens Point” of region “North” to the database, and then move those employees to 
--“Stevens Point”.
 

 select * from employees
 select * from EmployeeTerritories
 select * from Territories

create procedure sp_move_employees_wang as

if 
 (select count(1) from 
 (select e.firstname, t.TerritoryDescription from Employees e
 join EmployeeTerritories et 
 on et.employeeid = e.employeeid
 join Territories t
 on t.TerritoryID = et.TerritoryID
 where t.TerritoryDescription = 'Troy' ) tbl) >0

 begin
 insert into Territories (territoryid,TerritoryDescription,RegionID)
 values (11111,'Stevens Point',3)

 update EmployeeTerritories set territoryID = 11111
 where TerritoryID=48084
 end

 
 exec sp_move_employees_wang


--8.Create a trigger that when there are more than 100 employees in territory “Stevens Point”, 
--move them back to Troy. (After test your code,) remove the trigger. Move those employees back 
--to “Troy”, if any. Unlock the tables.

create trigger trig
on territories


--9.Create 2 new tables “people_your_last_name” “city_your_last_name”. 
--City table has two records: {Id:1, City: Seattle}, {Id:2, City: Green Bay}. 
--People has three records: {id:1, Name: Aaron Rodgers, City: 2}, {id:2, Name: Russell Wilson, City:1}, 
--{Id: 3, Name: Jody Nelson, City:2}. Remove city of Seattle. If there was anyone from Seattle, 
--put them into a new city “Madison”. Create a view “Packers_your_name” lists all people from Green Bay. 
--If any error occurred, no changes should be made to DB. (after test) Drop both tables and view.

drop table people_wang
select * from people_wang

create table city_wang
(Id int primary key,
City varchar(255)
)

create table people_wang
(Id int primary key,
Name varchar(255),
City int foreign key references city_wang(Id)
)

insert into city_wang (id,city)
values(1,'Seattle'),(2,'Green Bay')

insert into people_wang (id,name,city)
values(1,'Aaron Rodgers',2),(2,'Russell Wilson',1),(3,'Jody Nelson',2)

select p.name,c.city from city_wang c
join people_wang p
on p.city = c.id

if ((select count(1) from people_wang 
where city=1)>0)
begin 
update city_wang set city='Madison'
where city='Seattle'
end

select * from city_wang


--10.Create a stored procedure “sp_birthday_employees_[you_last_name]” that creates a new table 
--“birthday_employees_your_last_name” and fill it with all employees that have a birthday on Feb. 
--(Make a screen shot) drop the table. Employee table should not be affected.

create procedure sp_birthday_employees_wang as

select top 0 * into birthday_employees_wang
from Employees

insert into birthday_employees_wang(lastname,firstname,
title,titleofcourtesy,birthdate,hiredate,address,city,region,postalcode,
country,homephone,extension,photo,notes,reportsto,photopath)
SELECT lastname,firstname,
title,titleofcourtesy,birthdate,hiredate,address,city,region,postalcode,
country,homephone,extension,photo,notes,reportsto,photopath
FROM  Employees 
where MONTH(birthdate) =2

exec sp_birthday_employees_wang

select * from birthday_employees_wang
drop table birthday_employees_wang


--11.	Create a stored procedure named “sp_your_last_name_1” that returns all cites that have 
--at least 2 customers who have bought no or only one kind of product. Create a stored procedure 
--named “sp_your_last_name_2” that returns the same but using a different approach. 
--(sub-query and no-sub-query).

create procedure sp_wang_1 as
select shipcity,count(shipcity) from 
(select o.shipcity,o.customerid,count(d.ProductID) total from orders o
join [Order Details] d
on o.orderid = d.orderid
group by o.shipcity,o.CustomerID
having count(d.ProductID)<10) new
group by shipcity
having count(shipcity) >1

exec sp_wang_1


create procedure sp_wang_2 as

select o.shipcity,d.productid from orders o
join [Order Details] d
on o.orderid = d.orderid

--12.How do you make sure two tables have the same data?
--use a FULL OUTER JOIN between the two tables in the following form:

--SELECT count (1)
--    FROM table_a a
--    FULL OUTER JOIN table_b b 
--        USING (<list of columns to compare>)
--    WHERE a.id IS NULL
--        OR b.id IS NULL ;

--14.
--First Name	Last Name	Middle Name
--John	Green	
--Mike	White	M
--Output should be
--Full Name
--John Green
--Mike White M.
--Note: There is a dot after M when you output.

create table #name (
firstname varchar(255) not null,
lastname varchar(255) not null,
middlename varchar(255))

insert into #name(firstname,lastname,middlename)
values('John','Green',null),('Mike','White','M')

select * from #name

select concat(firstname,' ',lastname,isnull(' '+middlename+'.','')) as 'full name'
from #name

--15.
--Student	Marks	Sex
--Ci	70	F
--Bob	80	M
--Li	90	F
--Mi	95	M
--Find the top marks of Female students.
--If there are to students have the max score, only output one.

create table #students 
(student varchar(255) not null,
marks int not null,
sex varchar(255) not null)

insert into #students (student, marks, sex)
values('Ci',70,'F'),('Bob',80,'M'),('Li',90,'F'),('Mi',95,'M'),('Di',90,'F')

select * from #students

select top 1 * from (
select student,marks, DENSE_RANK() over(order by marks desc) as rnk from #students
where sex='F') as stu
where rnk = 1

--16.
--Student	Marks	Sex
--Li	90	F
--Ci	70	F
--Mi	95	M
--Bob	80	M
--How do you out put this?

--???