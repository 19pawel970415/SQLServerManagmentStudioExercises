--1]

select ContactName, CompanyName, Phone from Customers where Fax is NULL;

--2]

select FirstName, LastName, HireDate from Employees where HireDate between '1990-01-01' and '1999-01-01';

--3]
select ProductName, UnitsOnOrder, UnitsInStock from Products where UnitsInStock < UnitsOnOrder;

--4] 

create login Andrzej with password = 'admin';

CREATE USER ViewOnly FOR LOGIN Andrzej;

Grant SELECT TO ViewOnly;

--5]
CREATE SEQUENCE getOdd1to1001 as integer
START WITH 1
INCREMENT BY 2
MINVALUE 1
MAXVALUE 25
CYCLE;

SELECT next value for getOdd1to1001;

--6]
select o.orderID, o.OrderDate, e.EmployeeID, e.FirstName, e.LastName, p.ProductName, od.Quantity
from Orders as o, Employees as e, Products as p, [Order Details] as od
where o.EmployeeID = e.EmployeeID and o.OrderID = od.OrderID and od.ProductID = p.ProductID
order by o.OrderDate;

--7]
create table Defects (
id int identity (1,1) not null primary key nonclustered,
productid int not null foreign key references Northwind.dbo.Products(ProductId),
quantity int not null,
[description] nvarchar(300)  not null,
[date] datetime2 not null
);

--8]
create view view1 as
Select Top 10 City, COUNT(CustomerID) as numerberOfClients
from Customers group by City order by COUNT(CustomerID) desc;

--9] TODO
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