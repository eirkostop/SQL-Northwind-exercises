use Northwind;
go

--Exercise Simple SQL Queries

--1. Get all columns from the tables Customers, Orders and Suppliers

SELECT * FROM Customers;
SELECT * FROM Orders;
SELECT * FROM Suppliers;

--2. Get all Customers alphabetically, by Country and name

SELECT *
FROM Customers
ORDER BY Country, ContactName;

--3. Get all Orders by date

SELECT * 
FROM Orders 
ORDER BY OrderDate;

--4. Get the count of all Orders made during 1997

SELECT COUNT(*) AS [Number of Orders During 1997]
FROM Orders
WHERE YEAR(OrderDate) = 1997
--WHERE OrderDate BETWEEN '1997-1-1' AND '1997-12-31';
--WHERE OrderDate LIKE '%1997%'

--5. Get the names of all the contact persons where the person is a manager, alphabetically

SELECT ContactName
FROM Customers
WHERE ContactTitle LIKE '%Manager%'
ORDER BY ContactName;

--6. Get all orders placed on the 19th of May, 1997

SELECT *
FROM Orders
WHERE OrderDate = '1997-05-19';

--Exercise SQL Queries for JOINS

---1. Create a report for all the orders of 1996 and their Customers (152 rows)

SELECT *
FROM Orders o
INNER JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE YEAR(o.OrderDate) = '1996';

--2. Create a report that shows the number of employees and customers from each city that has employees in it (5 rows)

SELECT e.City AS City, COUNT(DISTINCT e.EmployeeID) AS [Number of Employees], COUNT(DISTINCT c.CustomerID) AS [Number of Customers]
FROM Employees e 
LEFT JOIN Customers c ON e.City = c.City
GROUP BY e.City
ORDER BY City;

--3. Create a report that shows the number of employees and customers from each city that has customers in it (69 rows)

SELECT c.City AS City, COUNT(DISTINCT c.CustomerID) AS [Number of Customers], COUNT(DISTINCT e.EmployeeID) AS [Number of Employees] 
FROM Employees e 
RIGHT JOIN Customers c ON e.City = c.City
GROUP BY c.City
ORDER BY City;

--4. Create a report that shows the number of employees and customers from each city (71 rows)

SELECT
	e.City,
	c.City,
	COUNT(DISTINCT e.EmployeeID) AS [Number of Employees],
	COUNT(DISTINCT c.CustomerID) AS [Number of Customers]
FROM Employees e 
FULL JOIN Customers c ON e.City = c.City
GROUP BY e.City, c.City
ORDER BY e.City;

SELECT
	ISNULL (e.City,	c.City) AS [City],
	COUNT(DISTINCT e.EmployeeID) AS [Number of Employees],
	COUNT(DISTINCT c.CustomerID) AS [Number of Customers]
FROM Employees e FULL JOIN Customers c ON 
	e.City = c.City
GROUP BY e.City, c.City
ORDER BY [City];

--Exercise SQL Queries for HAVING

--1. Create a report that shows the order ids and the associated employee names for orders that
--shipped after the required date (37 rows)

SELECT o.OrderID, e.LastName, e.FirstName
FROM Orders o
JOIN Employees e ON o.EmployeeID = e.EmployeeID
AND o.ShippedDate > o.RequiredDate;

--2. Create a report that shows the total quantity of products (from the Order_Details table)
--ordered. Only show records for products for which the quantity ordered is fewer than 200 (5 rows)

SELECT o.ProductID, p.ProductName, SUM(o.Quantity) AS [Total Quantity]
FROM [Order Details] o
JOIN Products p ON p.ProductID = o.ProductID
GROUP BY o.ProductID, p.ProductName
HAVING SUM(o.Quantity) < 200
ORDER BY [Total Quantity] DESC;

--3. Create a report that shows the total number of orders by Customer since December 31, 1996. The report should only return rows for which the total number of orders is greater than 15 (5 rows)

SELECT CustomerID, COUNT(OrderID) AS [Total Number of Orders]
FROM Orders
WHERE OrderDate > '1996-12-31'
GROUP BY CustomerID
HAVING COUNT(OrderID) > 15
ORDER BY [Total Number of Orders];

--Exercise SQL Inserting Records

BEGIN TRANSACTION

--1. Insert yourself into the Employees table. Include the following fields: LastName, FirstName, Title, TitleOfCourtesy, BirthDate, HireDate, City, Region, PostalCode, Country, HomePhone, ReportsTo

INSERT INTO Employees(LastName, FirstName, Title, TitleOfCourtesy, BirthDate,HireDate, City, Region, PostalCode, Country, HomePhone, ReportsTo)
VALUES('Amartolos', 'Nikos', 'Student', 'Mr.', '1992-09-14','2019-03-01', 'Athens', NULL, '11523', 'Greece', '2101234567', 5)

--2. Insert an order for yourself in the Orders table. Include the following fields: CustomerID, EmployeeID, OrderDate, RequiredDate

DECLARE @employee_id int = SCOPE_IDENTITY();

INSERT INTO Orders (CustomerID, EmployeeID, OrderDate, RequiredDate) VALUES ('VINET', @employee_id, '2019-03-01','2019-03-02')

--3. Insert order details in the Order_Details table. Include the following fields: OrderID, ProductID, UnitPrice, Quantity, Discount

DECLARE @order_id int = SCOPE_IDENTITY();
DECLARE @product_id int = 1;
INSERT INTO [Order Details] VALUES(@order_id, @product_id, 10.0, 15, 0);

COMMIT

--Exercise SQL Updating Records

--1. Update the phone of yourself (from the previous entry in Employees table) (1 row)

SELECT * FROM Employees
UPDATE Employees
SET HomePhone = '(+30)2101234567'
WHERE EmployeeID = @employee_id;

--2. Double the quantity of the order details record you inserted before (1 row)

SELECT * FROM [Order Details];
UPDATE [Order Details]
SET Quantity = 2 * Quantity
WHERE OrderID = @order_id AND ProductID = @product_id;

--3. Repeat previous update but this time update all orders associated with you (1 row)

SELECT * FROM Orders
UPDATE [Order Details]
SET Quantity = 2 * Quantity
FROM [Order Details]
JOIN Orders ON Orders.OrderID = [Order Details].OrderID
WHERE Orders.EmployeeID = @employee_id;

--Exercise SQL Deleting Records

--1. Delete the records you inserted before. Don't delete any other records!

BEGIN TRANSACTION
DELETE FROM [Order Details] WHERE OrderID = @order_id AND ProductID = @product_id;
DELETE FROM Orders WHERE EmployeeID = @employee_id;
DELETE FROM Employees WHERE EmployeeID = @employee_id;
COMMIT

--Exercise Advances SQL queries

--1. What were our total revenues in 1997 (Result must be 617.085,27)

SELECT SUM(([Order Details].UnitPrice)* [Order Details].Quantity * (1.0-[Order Details].Discount)) AS [1997 Total Revenues]
FROM [Order Details]
INNER JOIN (SELECT OrderID FROM Orders WHERE YEAR(OrderDate) = '1997') AS Ord 
ON Ord.OrderID = [Order Details].OrderID

--2. What is the total amount each customer has payed us so far (Hint: QUICK-Stop has payed us 110.277,32)

SELECT Customers.CompanyName, SUM([Order Details].UnitPrice * [Order Details].Quantity * (1.0- [Order Details].Discount)) AS [Total]
FROM Customers
INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID
INNER JOIN [Order Details] ON [Order Details].OrderID = Orders.OrderID
GROUP BY Customers.CompanyName
ORDER BY [Total] DESC;

--3. Find the 10 top selling products (Hint: Top selling product is "Cote de Blaye")

SELECT Products.ProductName, SUM([Order Details].UnitPrice * [Order Details].Quantity * (1.0- [Order Details].Discount)) AS [Sales]
FROM Products
INNER JOIN [Order Details]
ON [Order Details].ProductID = Products.ProductID
GROUP BY Products.ProductName
ORDER BY [Sales] DESC;
GO
--4. Create a view with total revenues per customer

DROP VIEW IF EXISTS [Total Revenues Per Customer];
GO
CREATE VIEW [Total Revenues Per Customer] AS
	SELECT c.CustomerID, c.ContactName, ISNULL(CAST(CONVERT(money, SUM(od.UnitPrice * od.Quantity * (1.0-od.Discount)*100)/100) AS DECIMAL(11,2)),0) AS [Revenue]
	FROM Customers c
	FULL JOIN Orders o ON c.CustomerID = o.CustomerID
	FULL JOIN [Order Details] od ON od.OrderID = o.OrderID
	GROUP BY c.CustomerID, c.ContactName;
GO

SELECT *
FROM [Total Revenues Per Customer]
ORDER BY Revenue DESC;
GO

--5. Which UK Customers have payed us more than 1000 dollars (6 rows)

SELECT Customers.ContactName, CONVERT(money,SUM([Order Details].UnitPrice * [Order Details].Quantity * (1.0- [Order Details].Discount)*100)/100) AS [Payments]
FROM Customers
INNER JOIN Orders ON Orders.CustomerID = Customers.CustomerID
INNER JOIN [Order Details] ON [Order Details].OrderID = Orders.OrderID
WHERE Customers.Country = 'UK'
GROUP BY Customers.ContactName
HAVING SUM([Order Details].UnitPrice * [Order Details].Quantity * (1.0- [Order Details].Discount)) > 1000;

--6. How much has each customer payed in total and how much in 1997.

SELECT Customers.CustomerID, Customers.CompanyName, Customers.Country, ISNULL(SUM([Order Subtotals].Subtotal), 0) AS [Customer Total], ISNULL(SUM(CONVERT(money, [1997].Payments/100)*100),0) AS [1997]
FROM Customers
LEFT JOIN Orders ON Orders.CustomerID = Customers.CustomerID
LEFT JOIN [Order Details] ON [Order Details].OrderID = Orders.OrderID
LEFT JOIN [Order Subtotals] ON [Order Subtotals].OrderID = Orders.OrderID
LEFT JOIN (SELECT Customers.CustomerID, Customers.CompanyName, Customers.Country, ([Order Details].UnitPrice * [Order Details].Quantity * (1.0- [Order Details].Discount)) AS [Payments]
			FROM Customers
			INNER JOIN Orders ON Orders.CustomerID = Customers.CustomerID
			INNER JOIN [Order Details] ON [Order Details].OrderID = Orders.OrderID
			WHERE YEAR(Orders.OrderDate) = '1997') AS [1997] 
ON [1997].CustomerID = Customers.CustomerID
GROUP BY Customers.CustomerID, Customers.CompanyName, Customers.Country
ORDER BY [Customer Total]

--SELECT * FROM Customers

--SELECT  [Order Subtotals].OrderID, [Order Subtotals].Subtotal
--FROM [Order Subtotals]






