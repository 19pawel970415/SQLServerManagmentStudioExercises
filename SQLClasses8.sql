SET XACT_ABORT ON

--1
begin transaction

declare @CATEGORYID int
declare @SUPPLIERID int

insert into Categories values ('random', 'randomDescription', 'randomPicture')
select top 1 @CATEGORYID = Categories.CategoryID from Categories;

select @SUPPLIERID = Suppliers.SupplierID from Suppliers where CompanyName = 'Exotic Liquids'
insert into Products values ('random Product', @SUPPLIERID, @CATEGORYID, 10, 10, 1000, 0, 0, 0)

commit transaction

--2
begin transaction MoreExpensive

DECLARE @ProductID INT
DECLARE @MAXPrice FLOAT
DECLARE @PriceIncrease INT
SET @PriceIncrease = 10;

SELECT @MAXPrice = MAX(UnitPrice) FROM Products
WHERE CategoryID IN (SELECT CategoryID FROM Categories WHERE CategoryName = 'Beverages');

SELECT @ProductID = productID FROM Products
WHERE CategoryID IN (SELECT CategoryID FROM Categories WHERE CategoryName = 'Beverages') AND UnitPrice = @MAXPrice;

UPDATE Products 
SET UnitPrice += @PriceIncrease
WHERE ProductID = @ProductID;
SET @MAXPrice += @PriceIncrease;


IF @MAXPrice > 300
BEGIN
    ROLLBACK TRANSACTION MoreExpensive;
    PRINT 'Too expensive';
    PRINT @MAXPrice;
END
ELSE
BEGIN
    COMMIT TRANSACTION MoreExpensive;
    PRINT 'SUCCESS!';
    PRINT @MAXPrice;
END

--3
BEGIN TRANSACTION;

DELETE FROM [Order Details]
WHERE ProductID IN (
    SELECT ProductID
    FROM Products
    WHERE CategoryID IN (
        SELECT CategoryID
        FROM Categories
        WHERE CategoryName = 'Seafood'
    )
);

DELETE FROM Products
WHERE CategoryID IN (
    SELECT CategoryID
    FROM Categories
    WHERE CategoryName = 'Seafood'
);

DELETE FROM Categories
WHERE CategoryName = 'Seafood';

COMMIT TRANSACTION;

--4
BEGIN TRANSACTION;

DELETE FROM [Order Details]
WHERE OrderID IN (
    SELECT OrderID
    FROM Orders
    WHERE EmployeeID IN (
        SELECT EmployeeID
        FROM Employees
        WHERE City = 'London'
    )
);

DELETE FROM [Orders]
WHERE EmployeeID IN (
	SELECT EmployeeID
	FROM Employees
	WHERE City = 'London'
    );

DELETE FROM EmployeeTerritories
WHERE EmployeeID IN (
    SELECT EmployeeID
    FROM Employees
    WHERE City = 'London'
);

DELETE FROM Employees
WHERE City = 'London';

COMMIT TRANSACTION;


