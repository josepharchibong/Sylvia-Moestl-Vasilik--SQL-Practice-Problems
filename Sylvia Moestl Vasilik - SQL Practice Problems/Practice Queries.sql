--INTRODUCTORY PROBLEMS
--1. Which shippers do we have? 
--   We have a table called Shippers. Return all the fields from all the shippers

SELECT *
FROM dbo.Shippers


--2. Certain fields from Categories.
--   We only want to see two columns, CategoryName and Description

SELECT CategoryName, Description
FROM dbo.Categories


-- 3. Sales Representatives. 
--    We’d like to see just the FirstName, LastName, and HireDate of all the employees with the Title of Sales Representative.

SELECT FirstName, LastName, HireDate
FROM dbo.Employees
WHERE Title LIKE '%Rep%'


--4. Sales Representatives in the United States. 
--   Now we’d like to see the same columns as above, but only for those employees that both have the title of Sales Representative, and also are in the United States.

SELECT FirstName, LastName, HireDate
FROM dbo.Employees
WHERE Title LIKE '%Rep%' AND Country LIKE 'USA'


--5. Orders placed by specific EmployeeID. 
--   Show all the orders placed by a specific employee. The EmployeeID for this Employee (Steven Buchanan) is 5.

SELECT OrderID, OrderDate
FROM dbo.Orders
WHERE EmployeeID LIKE '5'


--6. Suppliers and ContactTitles
--   In the Suppliers table, show the SupplierID, ContactName, and ContactTitle for those Suppliers whose ContactTitle is not Marketing Manager.

SELECT SupplierID, ContactName, ContactTitle
FROM dbo.Suppliers
WHERE ContactTitle NOT LIKE 'Marketing Manager'


--7. Products with “queso” in ProductName.
--   In the products table, we’d like to see the ProductID and ProductName for those products where the ProductName includes the string “queso”.

SELECT ProductID, ProductName
FROM dbo.Products
WHERE ProductName LIKE '%queso%'


--8. Orders shipping to France or Belgium.
--   Looking at the Orders table, there’s a field called ShipCountry. Write a query that shows the OrderID, CustomerID, and ShipCountry 
--   for the orders where the ShipCountry is either France or Belgium.

SELECT OrderID, CustomerID, ShipCountry
FROM dbo.Orders
WHERE ShipCountry = 'France' OR ShipCountry = 'Belgium'


--9. Orders shipping to any country in Latin America.
--   Now, instead of just wanting to return all the orders from France of Belgium, we want to show all the orders from any Latin American country. But we
--   don’t have a list of Latin American countries in a table in the Northwind database. So, we’re going to just use this list of Latin American countries that
--   happen to be in the Orders table: Brazil, Mexico, Argentina, Venezuela. It doesn’t make sense to use multiple Or statements anymore, it would get too convoluted. 
--   Use the In statement.

SELECT OrderID, CustomerID, ShipCountry
FROM dbo.Orders
WHERE ShipCountry IN ('Brazil', 'Mexico', 'Argentina', 'Venezuela')


-- 10. Employees, in order of age. 
--     For all the employees in the Employees table, show the FirstName, LastName, Title, and BirthDate. Order the results by BirthDate, 
--     so we have the oldest employees first.

SELECT FirstName, LastName, Title, BirthDate
FROM dbo.Employees
ORDER BY BirthDate


--11. Showing only the Date with a DateTime field.
--    In the output of the query above, showing the Employees in order of BirthDate, we see the time of the BirthDate field, which we don’t want. 
--    Show only the date portion of the BirthDate field.

SELECT FirstName, LastName, Title, CAST(BirthDate as date) as BirthDate
FROM dbo.Employees
ORDER BY BirthDate


--12. Employees full name.
--    Show the FirstName and LastName columns from the Employees table, and then create a new column called FullName, showing FirstName and LastName
--    joined together in one column, with a space inbetween.

SELECT FirstName, LastName, (FirstName + ' ' + LastName) as FullName
FROM dbo.Employees


--13. OrderDetails amount per line item.
--    In the OrderDetails table, we have the fields UnitPrice and Quantity. Create a new field, TotalPrice, that multiplies these two together. We’ll
--    ignore the Discount field for now. In addition, show the OrderID, ProductID, UnitPrice, and Quantity. Order by OrderID and ProductID.

SELECT OrderID, ProductID, UnitPrice, Quantity, (UnitPrice * Quantity) as TotalPrice
FROM dbo.OrderDetails
ORDER BY 1,2


--14. How many customers?
--    How many customers do we have in the Customers table? Show one value only, and don’t rely on getting the recordcount at the end of a resultset.

SELECT COUNT(ContactName) as TotalCustomers
FROM dbo.Customers


--15. When was the first order?
--    Show the date of the first order ever made in the Orders table.

SELECT MIN(OrderDate) as FirstOrder
FROM dbo.Orders
ORDER BY 1


--16. Countries where there are customers
--    Show a list of countries where the Northwind company has customers.

SELECT ShipCountry
FROM dbo.Orders
GROUP BY ShipCountry



--17. Contact titles for customers
--    Show a list of all the different values in the Customers table for ContactTitles. Also include a count for each ContactTitle.
--    This is similar in concept to the previous question “Countries where there are customers”, except we now want a count for each ContactTitle.

SELECT ContactTitle, COUNT(ContactTitle) as CountContactTitle
FROM dbo.Customers
GROUP BY ContactTitle
ORDER BY CountContactTitle DESC


--18. Products with associated supplier names.
--    We’d like to show, for each product, the associated Supplier. Show the ProductID, ProductName, and the CompanyName of the Supplier. Sort by ProductID.
--    This question will introduce what may be a new concept, the Join clause in SQL. The Join clause is used to join two or more relational database tables
--    together in a logical way. Here’s a data model of the relationship between Products and Suppliers.

SELECT ProductID, ProductName, CompanyName
FROM dbo.Products as pro
JOIN dbo.Suppliers as sup
ON pro.SupplierID = sup.SupplierID
ORDER BY ProductID


--19. Orders and the Shipper that was used.
--    We’d like to show a list of the Orders that were made, including the Shipper that was used. Show the OrderID, OrderDate (date only), and CompanyName
--    of the Shipper, and sort by OrderID. In order to not show all the orders (there’s more than 800), show only those rows with an OrderID of less than 10300.

SELECT OrderID, CAST(OrderDate as Date) as OrderDate, CompanyName as Shippers
FROM dbo.Orders as ord
JOIN dbo.Shippers as shp
ON ord.ShipVia = shp.ShipperID
WHERE OrderID < '10300'
ORDER BY OrderID


--20. Categories, and the total products in each category.
--    For this problem, we’d like to see the total number of products in each category. Sort the results by the total number of products, in descending order.

SELECT CategoryName, COUNT(CategoryName) as TotalProducts
FROM dbo.Categories as cat
JOIN dbo.Products as pro
ON cat.CategoryID = pro.CategoryID
GROUP BY CategoryName
ORDER BY 2 DESC


--21. Total customers per country/city.
--    In the Customers table, show the total number of customers per Country and City.

SELECT Country, City, COUNT(City) as TotalCustomers
FROM dbo.Customers
GROUP BY City, Country
ORDER BY 3 DESC


--22. Products that need reordering
--    What products do we have in our inventory that should be reordered? For now, just use the fields UnitsInStock and ReorderLevel, where UnitsInStock
---   is less than the ReorderLevel, ignoring the fields UnitsOnOrder and Discontinued. Order the results by ProductID.

SELECT ProductID, ProductName, UnitsInStock, ReorderLevel
FROM dbo.Products
WHERE UnitsInStock < ReorderLevel
ORDER BY ProductID


--23. Products that need reordering, continued
--    Now we need to incorporate these fields— UnitsInStock, UnitsOnOrder, ReorderLevel, Discontinued—into our calculation. We’ll define
--    “products that need reordering” with the following: (1) UnitsInStock plus UnitsOnOrder are less than or equal to ReorderLevel 
--    (2) The Discontinued flag is false (0).

SELECT ProductID, ProductName, UnitsInStock, UnitsOnOrder, ReorderLevel, Discontinued
FROM dbo.Products
WHERE (UnitsInStock + UnitsOnOrder) <= ReorderLevel AND Discontinued = '0'


--24. Customer list by region
--    A salesperson for Northwind is going on a business trip to visit customers, and would like to see a list of all customers, sorted by region, alphabetically.
--    However, he wants the customers with no region (null in the Region field) to be at the end, instead of at the top, where you’d normally find the null values.
--	  Within the same region, companies should be sorted by CustomerID.

SELECT CustomerID, CompanyName, Region
FROM dbo.Customers
ORDER BY
	CASE
		WHEN Region IS NULL THEN 1
		ELSE 0
	END,
Region, CustomerID