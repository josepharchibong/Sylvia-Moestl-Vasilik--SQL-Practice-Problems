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


--25. High freight charges
--    Some of the countries we ship to have very high freight charges. We'd like to investigate some more shipping options for our customers, to be able to offer
--    them lower freight charges. Return the three ship countries with the highest average freight overall, in descending order by average freight.

SELECT TOP 3 ShipCountry, ROUND(AVG(Freight), 4) as AverageFreight
FROM dbo.Orders
GROUP BY ShipCountry
ORDER BY AverageFreight DESC



--26. High freight charges - 2015.
--    We're continuing on the question above on high freight charges. Now, instead of using all the orders we have, we only want to see orders from the year 2015.

SELECT TOP 3 ShipCountry, ROUND(AVG(Freight), 4) as AverageFreight
FROM dbo.Orders
WHERE OrderDate LIKE '%2015%'
GROUP BY ShipCountry
ORDER BY AverageFreight DESC



--28. High freight charges - last year.
--    We're continuing to work on high freight charges. We now want to get the three ship countries with the highest average freight charges. But instead of
--    filtering for a particular year, we want to use the last 12 months of order data, using as the end date the last OrderDate in Orders. (2015/05/06 - 2016/05/06)

SELECT MAX(OrderDate) FROM  dbo.Orders --(query to return the last date)
SELECT DATEADD(yy, -1, (SELECT MAX(OrderDate) FROM dbo.Orders)) --(query to return the latest date + 12 months)

SELECT TOP 3 ShipCountry, ROUND(AVG(Freight), 4) as AverageFreight
FROM dbo.Orders
WHERE OrderDate BETWEEN '2015-05-06 18:00:00:000' AND '2016-05-06 18:00:00:000'
GROUP BY ShipCountry
ORDER BY AverageFreight DESC

SELECT TOP 3 ShipCountry, ROUND(AVG(Freight), 4) as AverageFreight
FROM dbo.Orders
WHERE OrderDate >= '2015-05-07' --I use 07 instead of 06 because the time difference
GROUP BY ShipCountry
ORDER BY AverageFreight DESC



--29. Inventory list.
--    We're doing inventory, and need to show information like the below, for all orders. Sort by OrderID and Product ID.

SELECT ord.EmployeeID, LastName, ord.OrderID, ProductName, Quantity
FROM dbo.Orders as ord
	JOIN dbo.OrderDetails as ordd
		ON ord.OrderID = ordd.OrderID
	JOIN dbo.Products as pro
		ON ordd.ProductID = pro.ProductID
	JOIN dbo.Employees as emp
		ON ord.EmployeeID = emp.EmployeeID
ORDER BY ord.OrderID, ordd.ProductID



--30. Customers with no orders
--    There are some customers who have never actually placed an order. Show these customers.

SELECT cus.CustomerID as CustomerCustomerID, ord.CustomerID as OrderCustomerID
FROM dbo.Customers as cus
	LEFT OUTER JOIN dbo.Orders as ord
		ON cus.CustomerID = ord.CustomerID
WHERE ord.CustomerID IS NULL



--31. Customers with no orders for EmployeeID 4.
--    One employee (Margaret Peacock, EmployeeID 4) has placed the most orders. However, there are some customers who've never placed an order with her.
--    Show only those customers who have never placed an order with her.

SELECT cus.CustomerID as CusCustomerID, cus.ContactName
FROM dbo.Customers as cus
	LEFT OUTER JOIN dbo.Orders as ord
		ON cus.CustomerID = ord.CustomerID AND ord.EmployeeID = 4
WHERE ord.CustomerID IS NULL 
ORDER BY 1



--32. High-value customers
--    We want to send all of our high-value customers a special VIP gift. We're defining high-value customers as those who've made at least 1 order with a total
--    value (not including the discount) equal to $10,000 or more. We only want to consider orders made in the year 2016.

SELECT cust.CustomerID, cust.CompanyName, ords.OrderID, SUM(ordd.UnitPrice * ordd.Quantity)  as TotalOrderAmount
FROM dbo.Customers as cust
	JOIN dbo.Orders as ords
		ON cust.CustomerID = ords.CustomerID
	JOIN dbo.OrderDetails as ordd
		ON ords.OrderID = ordd.OrderID
WHERE ords.OrderDate >= '20160101' AND ords.OrderDate < '20170101'
GROUP BY cust.CustomerID, cust.CompanyName, ords.OrderID
HAVING SUM(ordd.UnitPrice * ordd.Quantity) >= 10000
ORDER BY 4 DESC



--33. High-value customers - total orders
--    The manager has changed his mind. Instead of requiring that customers have at least one individual orders totaling $10,000 or more, he wants to define
--    high-value customers as those who have orders totaling $15,000 or more in 2016. How would you change the answer to the problem above?

SELECT cust.CustomerID, cust.CompanyName, SUM(ordd.UnitPrice * ordd.Quantity)  as TotalOrderAmount
FROM dbo.Customers as cust
	JOIN dbo.Orders as ords
		ON cust.CustomerID = ords.CustomerID
	JOIN dbo.OrderDetails as ordd
		ON ords.OrderID = ordd.OrderID
WHERE ords.OrderDate >= '20160101' AND ords.OrderDate < '20170101'
GROUP BY cust.CustomerID, cust.CompanyName 
HAVING SUM(ordd.UnitPrice * ordd.Quantity) >= 15000
ORDER BY 3 DESC



--34. High-value customers - with discount
--    Change the above query to use the discount when calculating high-value customers. Order by the total amount which includes the discount.

SELECT cust.CustomerID, cust.CompanyName, SUM(ordd.UnitPrice * ordd.Quantity)  as TotalWithoutDiscount,
       SUM((ordd.UnitPrice * ordd.Quantity) * (1 - ordd.Discount))  as TotalWithDiscount
FROM dbo.Customers as cust
	JOIN dbo.Orders as ords
		ON cust.CustomerID = ords.CustomerID
	JOIN dbo.OrderDetails as ordd
		ON ords.OrderID = ordd.OrderID
WHERE ords.OrderDate >= '20160101' AND ords.OrderDate < '20170101'
GROUP BY cust.CustomerID, cust.CompanyName 
HAVING SUM((ordd.UnitPrice * ordd.Quantity) * (1 - ordd.Discount)) >= 15000
ORDER BY 3 DESC


--34. High-value customers - with discount
--    Change the above query to use the discount when calculating high-value customers. Order by the total amount which includes the discount.

SELECT cust.CustomerID, cust.CompanyName, SUM(ordd.UnitPrice * ordd.Quantity)  as TotalWithoutDiscount,
       SUM((ordd.UnitPrice * ordd.Quantity) * (1 - ordd.Discount))  as TotalWithDiscount
FROM dbo.Customers as cust
	JOIN dbo.Orders as ords
		ON cust.CustomerID = ords.CustomerID
	JOIN dbo.OrderDetails as ordd
		ON ords.OrderID = ordd.OrderID
WHERE ords.OrderDate >= '20160101' AND ords.OrderDate < '20170101'
GROUP BY cust.CustomerID, cust.CompanyName 
HAVING SUM((ordd.UnitPrice * ordd.Quantity) * (1 - ordd.Discount)) >= 15000
ORDER BY 3 DESC



--35. Month-end orders
--    At the end of the month, salespeople are likely to try much harder to get orders, to meet their month-end quotas. Show all orders made on the last day of the
--    month. Order by EmployeeID and OrderID


SELECT EmployeeID, OrderID, OrderDate 
FROM dbo.Orders
WHERE OrderDate = EOMONTH(OrderDate)
ORDER BY 1, 2



--36. Orders with many line items
--    The Northwind mobile app developers are testing an app that customers will use to show orders. In order to make sure that even the largest orders will show up correctly
--    on the app, they'd like some samples of orders that have lots of individual line items. Show the 10 orders with the most line items, in order of total line items.

SELECT TOP 10 ordd.OrderID, COUNT(ordd.OrderID) as TotalOrderDetails
FROM dbo.OrderDetails as ordd
	LEFT JOIN dbo.Orders as ords
		ON ordd.OrderID = ords.OrderID
GROUP BY ordd.OrderID
ORDER BY 2 DESC, 1 DESC

SELECT TOP 10 Orders.OrderID, TotalOrderDetails = COUNT(*)
FROM Orders
	Join OrderDetails
		ON Orders.OrderID = OrderDetails.OrderID
GROUP BY Orders.OrderID
ORDER BY COUNT(*) DESC



--37. Orders - random assortment
--    The Northwind mobile app developers would now like to just get a random assortment of orders for beta testing on their app. Show a random set of 2% of all orders.

SELECT TOP 2 PERCENT OrderId
FROM dbo.Orders
ORDER BY NewID()



--38. Orders - accidental double-entry
--    Janet Leverling, one of the salespeople, has come to you with a request. She thinks that she accidentally double-entered a line item on an order, with a different 
--    ProductID, but the same quantity. She remembers that the quantity was 60 or more. Show all the OrderIDs with line items that match this, in order of OrderID.

SELECT OrderID
FROM dbo.OrderDetails
WHERE Quantity >= 60
GROUP BY OrderID, Quantity
HAVING COUNT(*) > 1



--39. Orders - accidental double-entry details
--    Based on the previous question, we now want to show details of the order, for orders that match the above criteria.

--USING CTE (Common Table Expressions)
WITH AccidetanlOrdersDetails
AS
(
	SELECT OrderID
	FROM dbo.OrderDetails
	WHERE Quantity >= 60
	GROUP BY OrderID, Quantity
	HAVING COUNT(*) > 1
)

SELECT OrderID, ProductID, UnitPrice, Quantity, Discount
FROM dbo.OrderDetails
WHERE OrderID IN (SELECT OrderID FROM AccidetanlOrdersDetails)
ORDER BY OrderID, Quantity

--USING Temp Tables
DROP TABLE IF exists #AccidetanlOrdersDetails
CREATE TABLE #AccidetanlOrdersDetails
(
OrderID int,
)
INSERT INTO #AccidetanlOrdersDetails
	SELECT OrderID
	FROM dbo.OrderDetails
	WHERE Quantity >= 60
	GROUP BY OrderID, Quantity
	HAVING COUNT(*) > 1

SELECT OrderID, ProductID, UnitPrice, Quantity, Discount
FROM dbo.OrderDetails
WHERE OrderID IN (SELECT OrderID FROM #AccidetanlOrdersDetails)
ORDER BY OrderID, Quantity


