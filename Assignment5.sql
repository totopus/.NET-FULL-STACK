--1.What is an object in SQL?

--2.What is Index? What are the advantages and disadvantages of using Indexes?
--Indexed are database objects based on table column for faster retrieval of data
--Query optimizer depends on indexed columns to function
--Separate structure attached to a table
--Contain pointers to the physical data
--Used to 
--To quickly find data that satisfy conditions in the WHERE clause.
--To find matching rows in the JOIN clause.
--To maintain uniqueness of key column during INSERT and UPDATE.
--To Sort, Aggregate and Group data.
--Disadvantages
--Additional Disk Space
--Insert, Update, Delete Statement become slow

--3.What are the types of Indexes?
--There are cluster index and non cluster index

--4.Does SQL Server automatically create indexes when a table is created? If yes, under which constraints?
--primary key automatically creates a clustered index

--5.Can a table have multiple clustered index? Why?
--No,because the data rows themselves can be stored in only one order.
--6.Can an index be created on multiple columns? Is yes, is the order of columns matter?
8.	What is normalization? What are the steps (normal forms) to achieve normalization?
9.	What is denormalization and under which scenarios can it be preferable?
10.	How do you achieve Data Integrity in SQL Server?
11.	What are the different kinds of constraint do SQL Server have?
--12.What is the difference between Primary Key and Unique Key?

13.	What is foreign key?
14.	Can a table have multiple foreign keys?
15.	Does a foreign key have to be unique? Can it be null?
16.	Can we create indexes on Table Variables or Temporary Tables?
17.	What is Transaction? What types of transaction levels are there in SQL Server?

Write queries for following scenarios
--1.Write an sql statement that will display the name of each 
--customer and the sum of order totals placed by that customer 
--during the year 2002

use totopus_biag_test
go

 Create table customer(cust_id int,  name varchar (50)) 
 create table orders (order_id int,cust_id int,amount money,order_date smalldatetime)

 select * from customer
 select * from orders

 select c.iname,sum(o.amount) from customer c
 join orders o
 on c.cust_id = o.cust_id
 where year(o.order_date) = 2002
 group by c.iname


--2.The following table is used to store information about company’s personnel:
--write a query that returns all employees whose last names  start with “A”.

Create table person (id int, firstname varchar(100), lastname varchar(100))
select * from person 
where lastname like 'a%'
drop table person

--3.The information about company’s personnel is stored in the following table:
Create table person(person_id int primary key, manager_id int, name varchar(100)not null) 
--The filed managed_id contains the person_id of the employee’s manager.
--Please write a query that would return the names of all top managers
--(an employee who does not have  a manger, and the number of people that 
--report directly to this manager.

select * from person

select bossname,count(name) from (
select a.name,b.name 'bossname'  from person a
left join person b
on b.person_id = a.manager_id) as tbl
group by bossname
having 
bossname = (select name from person where manager_id is null)
--4.List all events that can cause a trigger to be executed.
--DML Statements like Insert , Delete or Update

--5.Generate a destination schema in 3rd Normal Form.  
--Include all necessary fact, join, and dictionary tables, 
--and all Primary and Foreign Key relationships.  The following assumptions can be made:
--a.Each Company can have one or more Divisions.


b. Each record in the Company table represents a unique combination 
c. Physical locations are associated with Divisions.
d. Some Company Divisions are collocated at the same physical of Company Name and Division Name.
e. Contacts can be associated with one or more divisions and the address, but are differentiated by suite/mail drop records.status of each association should be separately maintained and audited.
