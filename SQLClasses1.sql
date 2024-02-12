--1
--SELECT * FROM Customers Where Country = 'Poland';
--SELECT ContactName FROM Customers Where City = 'Berlin';
--SELECT ProductName, UnitPrice FROM [Products] ORDER BY UnitPrice DESC;
--SELECT TOP 1 OrderID FROM Orders ORDER BY OrderDate;
-- SELECT TOP 1 FirstName, LastName, Notes, BirthDate FROM Employees ORDER BY BirthDate DESC;
-- DELETE FROM Customers WHERE Country = 'USA'; 
/*USE [Northwind]
GO

INSERT INTO [dbo].[Products]
           ([ProductName]
           ,[SupplierID]
           ,[CategoryID]
           ,[QuantityPerUnit]
           ,[UnitPrice]
           ,[UnitsInStock]
           ,[UnitsOnOrder]
           ,[ReorderLevel]
           ,[Discontinued])
     VALUES
           ('Chocolate Cake',
            'Peter Wilson ',
           'Confections',
            '1kg pkg',
            12,
            100,
            10,
            0,
            0)
GO
*/
/*INSERT INTO Employees(FirstName, LastName, BirthDate,Photo,Notes) 
VALUE ('Janusz', 'Tracz', '1963-07-02', ' EmpID11.pic', ' ...'); */

--UPDATE Products SET UnitPrice = 30 Where ProductName = 'Chocolade';
UPDATE Products SET UnitPrice = UnitPrice + 10 
Where SupplierID = (Select SupplierID  From Suppliers where CompanyName = 'Exotic Liquid');

--CREATE TABLE ProductsInfo (ProductID int, Note varchar(200), Warning text);

SELECT AVG(UnitPrice) AS 'œrednia cena' From Products ;

SELECT COUNT(CountryID) AS 'Niemcy' From Customers Where Country = 'Germany'

ALTER TABLE Orders ADD isShipped  tinyint;