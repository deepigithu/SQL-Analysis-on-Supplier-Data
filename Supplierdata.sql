---1Q---
---List all customers

select * from Customer

----2Q---
----List the first name,last name and city of all customers

select FirstName,LastName,City
from Customer


----3Q---
----List the customers in Sweden. Remember it is "Sweden" and NOT "sweden" because filtering value is case sensitive in Redshift.

select * from Customer
where Country='Sweden'


----4Q---
----Create a copy of Supplier table. Update the city to Sydney for supplier starting with letter P.

select * into copy_of_supplier
from Supplier

Update copy_of_supplier
set City='Sydney'
where CompanyName like 'P%'


----5Q--
----Create a copy of Products table and Delete all products with unit price higher than $50.

select * into copy_of_product
from Product

delete from copy_of_product
where UnitPrice > 50


-----6Q---
-----List the number of customers in each country

select Country,count(Id) as no_of_cust
from Customer
group by Country


----7Q---
----List the number of customers in each country sorted high to low

select Country,count(Id) as no_of_cust
from Customer
group by Country
order by no_of_cust desc


-----8Q---
----- List the total amount for items ordered by each customer

select CustomerId,sum(TotalAmount) as total_amt
from [Order]
group by CustomerId
order by total_amt desc 


----9Q---
----List the number of customers in each country. Only include countries with more than 10 customers.

select Country,count(Id) as no_of_cust
from Customer
group by Country
having count(Id) >=10


----10Q---
----List the number of customers in each country, except the USA, sorted high to low. Only include countries with 9 or more customers.

select Country,count(Id) as no_of_cust
from Customer
where Country != 'USA'
group by Country
having count(Id) >=9


----11Q---
----List all customers whose first name or last name contains "ill". 

select * from Customer
where FirstName like '%ill%' or LastName like '%ill%'


----12Q---
----List all customers whose average of their total order amount is between $1000 and $1200.Limit your output to 5 results.

select top 5 CustomerId,AVG(TotalAmount) as avg_amt
from [Order]
group by CustomerId
having AVG(TotalAmount) between 1000 and 1200
order by avg_amt desc


----13Q---
----List all suppliers in the 'USA', 'Japan', and 'Germany', ordered by country from A-Z, and then by company name in reverse order.

select CompanyName,Country 
from Supplier
where Country='USA' or Country='Japan' or Country='Germany'
order by Country asc , CompanyName desc


----14Q---
---- Show all orders, sorted by total amount (the largest amount first), within each year.

select *
from [Order]
order by year(OrderDate),TotalAmount desc


----15Q---
----Products with UnitPrice greater than 50 are not selling despite promotions. You are asked to 
----discontinue products over $25. Write a query to relfelct this. Do this in the copy of the Product 
----table. DO NOT perform the update operation in the Product table.


select * from copy_of_product
update copy_of_product
set IsDiscontinued=1
where UnitPrice>25


-----16Q---
-----List top 10 most expensive products

select top 10 ProductName 
from Product
order by UnitPrice desc


-----17Q---
-----Get all but the 10 most expensive products sorted by price

select ProductName
from Product
order by UnitPrice desc
offset 10 rows


-----18Q---
-----Get the 10th to 15th most expensive products sorted by price

select ProductName
from Product
order by UnitPrice desc
offset 10 rows
fetch next 5 rows only


----19Q---
----Write a query to get the number of supplier countries. Do not count duplicate values.

select count(distinct Country) distinct_country
from Supplier


----20Q---
----Find the total sales cost in each month of the year 2013.

select Sum(TotalAmount),DATENAME(month,OrderDate) as month
from [Order]
where year(OrderDate)=2013
group by DATENAME(month,OrderDate) 


----21Q---
----List all products with names that start with 'Ca'.

select ProductName 
from Product
where ProductName like 'Ca%'


----22Q---
----List all products that start with 'Cha' or 'Chan' and have one more character

select ProductName 
from Product
where ProductName like 'Cha_%' or ProductName like 'Chan_%'


----23Q---
----Your manager notices there are some suppliers without fax numbers. He seeks your help to 
----get a list of suppliers with remark as "No fax number" for suppliers who do not have fax 
----numbers (fax numbers might be null or blank).Also, Fax number should be displayed for customer with fax numbers.

select Id,CompanyName,ContactName,ContactTitle,City,Country,Phone,
isnull(Fax,'No Fax Number')[Fax]
from Supplier

--OR---

select Id,CompanyName,ContactName,ContactTitle,City,Country,Phone,
case when Fax is null then 'No Fax Number' else Fax end [Fax]
from Supplier


----24Q---
----List all orders, their orderDates with product names, quantities, and prices.

select o.OrderDate,p.ProductName,oi.Quantity,oi.UnitPrice
from [Order] o inner join OrderItem oi on o.Id=oi.OrderId
inner join Product p on oi.ProductId=p.Id


----25Q---
----List all customers who have not placed any Orders.

select *
from Customer c inner join [Order] o on c.Id=o.CustomerId
where o.Id is null


---26Q---
---List suppliers that have no customers in their country, and customers that have no suppliers 
---in their country, and customers and suppliers that are from the same country.

select c.FirstName,c.LastName,c.Country as CustomerCountry,s.Country as SupplierCountry,s.CompanyName
from Customer c left join Supplier s on c.Country=s.Country


---27Q---
---Match customers that are from the same city and country. That is you are asked to give a list 
---of customers that are from same country and city. Display firstname, lastname, city and country of such customers.

select c1.FirstName as FirstName1,c2.FirstName as FirstName2,c1.LastName as LastName1,c2.LastName as LastNmae2,c1.City,c1.Country
from Customer c1 inner join Customer c2 on c1.City=c2.City 
and c2.Country=c1.Country
where c1.FirstName != c2.FirstName and c1.LastName!=c2.LastName


----28Q---
----List all Suppliers and Customers. Give a Label in a separate column as 'Suppliers' if he is a 
----supplier and 'Customer' if he is a customer accordingly. Also, do not display firstname and 
----lastname as twoi fields; Display Full name of customer or supplier. 

select 'Customer'[Type],CONCAT(FirstName,'',LastName)[ContactName],City,Country,Phone
from Customer c union
select 'Supplier'[Type],ContactName,City,Country,Phone
from Supplier s


---29Q---
---Create a copy of orders table. In this copy table, now add a column city of type varchar (40). 
---Update this city column using the city info in customers table

select o.*,c.City into copy_of_order1
from[Order] o inner join Customer c on o.CustomerId=c.Id

---30Q---
---Suppose you would like to see the last OrderID and the OrderDate for this last order that 
---was shipped to 'Paris'. Along with that information, say you would also like to see the 
---OrderDate for the last order shipped regardless of the Shipping City. In addition to this, you 
---would also like to calculate the difference in days between these two OrderDates that you get. 
---Write a single query which performs this.
---(Hint: make use of max (columnname) function to get the last order date and the output is a single row output.)


select  (select top 1 o.id from [Order] o inner join Customer c on o.CustomerId = c.Id order by OrderDate desc) [ID],
		(select max(orderdate) from [Order] o inner join Customer c on o.CustomerId = c.Id where City = 'Paris' ) [LastParisOrder],
		(select MAX(orderdate) from [Order]) [Overall Last Order],
		(select datediff(DAY,
						(select max(orderdate) from [Order] o inner join Customer c on o.CustomerId = c.Id where City = 'Paris' ),
						(select MAX(orderdate) from [Order]))
		) [Difference in days]



----31Q---
----Find those customer countries who do not have suppliers. This might help you provide
----better delivery time to customers by adding suppliers to these countires. Use SubQueries.

select distinct(c.Country),s.CompanyName,s.Country
from Customer c left join Supplier s on c.Country=s.Country
where s.Country is null and s.CompanyName is null 


----32Q---
----Suppose a company would like to do some targeted marketing where it would contact
----customers in the country with the fewest number of orders. It is hoped that this targeted
----marketing will increase the overall sales in the targeted country. You are asked to write a query
----to get all details of such customers from top 5 countries with fewest numbers of orders. Use Subqueries.

select top 5 c.Country,count(o.Id) as no_of_orders
from Customer c inner join [Order] o on c.Id=o.CustomerId
group by c.Country
order by no_of_orders asc

----OR---

select distinct Country from Customer
where Country in ( select top 5 Country
from [Order] o inner join Customer c on o.CustomerId=c.Id
group by Country
order by count(o.Id) asc)


----33Q---
----Let's say you want report of all distinct "OrderIDs" where the customer did not purchase
----more than 10% of the average quantity sold for a given product. This way you could review
----these orders, and possibly contact the customers, to help determine if there was a reason for
----the low quantity order. Write a query to report such orderIDs.

---CTE
with avg_prod_qty as
(
select p.Id,AVG(oi.Quantity) as avg_qty
from [Order] o inner join OrderItem oi on o.Id=oi.OrderId
inner join Product p on oi.ProductId=p.Id
group by p.Id
)
select o.Id
from [Order] o inner join OrderItem oi on o.Id=oi.OrderId
inner join Product p on oi.ProductId=p.Id
inner join avg_prod_qty apq on apq.Id=p.Id
where Quantity < 0.1*avg_qty

---OR--

--Window Functions
select Id from
(select o.Id,oi.Quantity,AVG(Quantity) over ( partition by p.id) as avg_qty
from [Order] o inner join OrderItem oi on o.Id=oi.OrderId
inner join Product p on oi.ProductId=p.Id)t1
where Quantity < 0.1*avg_qty


----34Q---
----Find Customers whose total orderitem amount is greater than 7500$ for the year 2013. The
----total order item amount for 1 order for a customer is calculated using the formula UnitPrice *
----Quantity * (1 - Discount). DO NOT consider the total amount column from 'Order' table to 
----calculate the total orderItem for a customer.

select CustomerId,SUM(UnitPrice*Quantity*(1-Discount)) as total_order_item_amount 
from Customer c inner join [Order] o on c.Id=o.CustomerId
inner join OrderItem oi on o.Id=oi.OrderId
where year(OrderDate) = 2013
group by CustomerId
having SUM(UnitPrice*Quantity*(1-Discount)) > 7500



----35Q---
----Display the top two customers, based on the total dollar amount associated with their
----orders, per country. The dollar amount is calculated as OI.unitprice * OI.Quantity * (1 -
----OI.Discount). You might want to perform a query like this so you can reward these customers, since they buy the most per country.

select top 2 c.Id,c.FirstName,c.LastName,c.Country,SUM(oi.UnitPrice*oi.Quantity*(1-oi.Discount)) as dollar_amt
from  Customer c inner join [Order] o on c.Id=o.CustomerId
inner join OrderItem oi on o.Id=oi.OrderId
group by c.Id,c.Country,c.FirstName,c.LastName
order by dollar_amt desc


----36Q---
----Create a View of Products whose unit price is above average Price.

create view view_of_prod as 
(
select * from Product
where UnitPrice > (select AVG(UnitPrice) from Product)
)

select * from view_of_prod


----37Q--
----Write a store procedure that performs the following action:
----Check if Product_copy table (this is a copy of Product table) is present. If table exists, the
----procedure should drop this table first and recreated.
----Add a column Supplier_name in this copy table. Update this column with that of
----'CompanyName' column from Supplier tab

create procedure q37 as

if 'copy_of_products' in (select table_name from INFORMATION_SCHEMA_TABLES)
begin
drop table copy_of_products
select p.*,s.CompanyName into copy_of_products
from Product p inner join Supplier s on p.SupplierId=s.Id
END
EXEC q37

