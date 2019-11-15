use Northwind;
go

-- Exercise 1
--Select all category names with their descriptions from the Categories table.

SELECT CategoryName, Description FROM Categories;

--Exercise #2
--Select the contact name, customer id, and company name of all Customers in London

SELECT ContactName, CustomerID, CompanyName
FROM Customers
WHERE City = 'London';

--Exercise #3
--Marketing managers and sales representatives have asked you to select all available columns in the Suppliers tables that have a FAX number.

SELECT *
FROM Suppliers
WHERE Fax IS NOT NULL;

--Exercise #4
--Select a list of customers id’s from the Orders table with required dates between Jan 1, 1997 and Jan 1, 1998 and with freight under 100 units.

SELECT CustomerID
FROM Orders
WHERE RequiredDate BETWEEN '1997-01-01' and 'Jan 1, 1998'  AND Freight < 100;

--Exercise #5
--Select a list of company names and contact names of all the Owners from the Customer table from Mexico, Sweden and Germany.

select * from Customers;

SELECT CompanyName, ContactName
FROM Customers
WHERE Country IN ('Mexico', 'Sweden', 'Germany') AND ContactTitle = 'Owner';

--Exercise #6
--Count the number of discontinued products in the Products table.

SELECT COUNT(*)
FROM Products
WHERE Discontinued = 1;

--Exercise #7
--Select a list of category names and descriptions of all categories beginning with 'Co' from the Categories table.

SELECT [CategoryName], [Description]
FROM [Categories]
WHERE [CategoryName] LIKE 'Co%';

--Exercise #8
--Select all the company names, city, country and postal code from the Suppliers table with the word 'rue' in their address. The list should be ordered alphabetically by company name.

SELECT CompanyName, City, Country, PostalCode
FROM Suppliers
WHERE Address LIKE '%rue%'
ORDER BY CompanyName;

--Exercise #9
--Select the product id and the total quantities ordered for each product id in the Order Details table.

select * from [Order Details]

SELECT ProductID AS [Product ID], SUM(Quantity) AS [Total Quantity]
FROM [Order Details]
GROUP BY ProductID
ORDER BY [Total Quantity]

--Exercise #10
--Select the customer name and customer address of all customers with orders that shipped using Speedy Express.

--1st way
SELECT ContactName, Address
FROM Customers
WHERE CustomerID IN 
	(SELECT DISTINCT CustomerID
	 FROM Orders
	 WHERE ShipVia IN 
		(SELECT ShipperID 
		 FROM Shippers
		 WHERE CompanyName = 'Speedy Express'))

--2nd way
SELECT DISTINCT Customers.ContactName, Customers.Address
FROM Customers
INNER JOIN Orders
ON Customers.CustomerID = Orders.CustomerID
INNER JOIN Shippers
ON Orders.ShipVia = Shippers.ShipperID
WHERE Shippers.CompanyName = 'Speedy Express'

--Exercise #11
--Select a list of Suppliers containing company name, contact name, contact title and region description.

SELECT CompanyName, ContactName, ContactTitle, Region
FROM Suppliers
WHERE ContactName IS NOT NULL AND ContactTitle IS NOT NULL AND Region IS NOT NULL

--Exercise #12
--Select all product names from the Products table that are condiments.

-- 1st way
SELECT ProductName
FROM Products
WHERE CategoryID IN 
	(SELECT CategoryID
	 FROM Categories
	 WHERE CategoryName = 'Condiments');


--2nd way
SELECT Products.ProductName
FROM Products
INNER JOIN Categories
ON Products.CategoryID = Categories.CategoryID
WHERE Categories.CategoryName = 'Condiments'

--Exercise #13
--Select a list of customer names who have no orders in the Orders table.

SELECT ContactName
FROM Customers
WHERE CustomerID NOT IN 
	(SELECT DISTINCT CustomerID
	 FROM Orders);

--Exercise #14
--Add a shipper named 'Amazon' to the Shippers table using SQL.

--Exercise #15
--Change the company name from 'Amazon' to 'Amazon Prime Shipping' in the Shippers table using SQL.

UPDATE Shippers 
SET CompanyName = 'Amazon Prime Shipping'
WHERE CompanyName =  'Amazon';

--Exercise #16
--Select a complete list of company names from the Shippers table. 
--Include freight totals rounded to the nearest whole number for each shipper from the Orders table for those shippers with orders.

--SELECT Shippers.CompanyName, ROUND(SUM(Orders.Freight), 0) AS [Total Freights]
--FROM Shippers
--LEFT OUTER JOIN Orders
--ON Orders.ShipVia = Shippers.ShipperID
--GROUP BY Shippers.CompanyName

--Exercise #17
--Select all employee first and last names from the Employees table by combining the 2 columns aliased as 'DisplayName'.
--The combined format should be 'LastName, FirstName'.

--SELECT CONCAT(LastName, ', ', FirstName) AS [DisplayName]
--FROM Employees

--Exercise #18
--Add yourself to the Customers table with an order for 'Grandma's Boysenberry Spread'.

--DECLARE @customer_id varchar(5)= 'NAMAR';
--INSERT INTO Customers(CustomerID, ContactName, CompanyName) VALUES(@customer_id, 'Amartolos Nikos', 'PeopleCert')
--INSERT INTO Orders (CustomerID) VALUES (@customer_id)

--DECLARE @order_id int = scope_identity();

--DECLARE @product_id int = (SELECT ProductID
--						   FROM Products
--						   WHERE ProductName = 'Grandma''s Boysenberry Spread');

--INSERT INTO [Order Details] VALUES(@order_id, @product_id, 50.50, 15, 0 )

--Exercise #19
--Remove yourself and your order from the database.

--DECLARE @customer_id varchar(5)= 'NAMAR';
--DECLARE @order_id int =(SELECT OrderID
--						FROM Orders
--						WHERE CustomerID = 'NAMAR');

--DECLARE @product_id int = (SELECT ProductID
--						   FROM Products
--						   WHERE ProductName = 'Grandma''s Boysenberry Spread');

--DELETE FROM [Order Details] WHERE OrderID = @order_id AND ProductID = @product_id;
--DELETE FROM Orders WHERE OrderID = @order_id;
--DELETE FROM Customers WHERE CustomerID = @customer_id;

--Exercise #20
--Select a list of products from the Products table along with the total units in stock for each product.
--Give the computed column a name using the alias, 'TotalUnits'. Include only products with TotalUnits greater than 100.

SELECT ProductName, UnitsInStock AS TotalUnits
FROM Products
WHERE UnitsInStock > 100;