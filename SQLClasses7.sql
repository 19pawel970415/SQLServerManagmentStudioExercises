--2

SELECT 
    Employees.FirstName,
    Employees.LastName,
    EmployeeTerritories.TerritoryID
FROM 
    Employees
INNER JOIN 
    EmployeeTerritories ON Employees.EmployeeID = EmployeeTerritories.EmployeeID;

--3
INSERT INTO [dbo].[Customers]
           ([CustomerID]
           ,[CompanyName]
           ,[ContactName]
           ,[ContactTitle]
           ,[Address]
           ,[City]
           ,[Region]
           ,[PostalCode]
           ,[Country]
           ,[Phone]
           ,[Fax])
     VALUES
           ('ABCDE', 'ABCcompany', 'ABC', 'Title', 'Address', 'City', 'region', '666', 'Poland', '78767889', '7787889')

--4
INSERT INTO Orders (EmployeeID)
SELECT MAX(EmployeeID)
FROM Employees;

--5
SELECT
    Customers.ContactName,
    Orders.OrderID
FROM 
    Customers
LEFT JOIN 
    Orders ON Customers.CustomerID = Orders.CustomerID
--6
SELECT
    Customers.ContactName,
    Orders.OrderID
FROM 
    Customers
RIGHT JOIN 
    Orders ON Customers.CustomerID = Orders.CustomerID
--7
SELECT
    Customers.ContactName,
    Orders.OrderID
FROM 
    Customers
FULL JOIN 
    Orders ON Customers.CustomerID = Orders.CustomerID

--8
SELECT 
    A.ContactName AS Supplier1,
    B.ContactName AS Supplier2,
    A.Country
FROM 
    Suppliers A
JOIN 
    Suppliers B ON A.Country = B.Country AND A.SupplierID <> B.SupplierID
ORDER BY
	A.Country;

--9
CREATE SEQUENCE onetwothree as integer
START WITH 1
INCREMENT BY 1
MINVALUE 1
MAXVALUE 3
CYCLE;

SELECT NEXT VALUE FOR onetwothree;


--10
SELECT 
    Suppliers.CompanyName,
    Suppliers.Country
FROM 
    Suppliers
WHERE EXISTS (SELECT Products.ProductName FROM Products WHERE Products.SupplierID = Suppliers.SupplierID AND Products.UnitsInStock > 100
    AND Products.UnitPrice < 10);

--11
SELECT 
    ProductName
FROM 
    Products
WHERE 
    SupplierID = (SELECT SupplierID FROM Suppliers WHERE CompanyName = 'Leka Trading')
	EXCEPT SELECT ProductName FROM Products WHERE Discontinued = 1 OR UnitsInStock <= 0;

--12
SELECT 
    SupplierID
FROM 
    Products
WHERE 
    CategoryID = (SELECT CategoryID FROM Categories WHERE CategoryName = 'Beverages')
    AND UnitPrice > 10
INTERSECT
SELECT 
    SupplierID
FROM 
    Suppliers
WHERE 
    Country = 'UK';
