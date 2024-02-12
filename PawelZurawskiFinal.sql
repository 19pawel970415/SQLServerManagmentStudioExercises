--1] Wyœwietl pracowników (FirstName, LastName), których nazwiska zaczynaj¹ siê na literê C.

SELECT FirstName, LastName FROM Employees
WHERE LastName LIKE 'C%';

--2] Wyœwietl listê pracowników (FirstName, LastName, HireDate z tabeli Employees), którzy NIE zostali zatrudnieni w latach od 01.01.1950 do 01.01.1960.

select FirstName, LastName, HireDate from Employees where HireDate not between '1950-01-01' and '1960-01-01';

--3] Napisz zapytanie wyœwietlaj¹ce listê produktów (ProductName, UnitsOnOrder, UnitsInStock), których zapas (UnitsInStock) jest wiêkszy lub równy iloœæ zamówieñ (UnitsOnOrder).

select ProductName, UnitsOnOrder, UnitsInStock from Products where UnitsInStock >= UnitsOnOrder;

--4] Utwórz nowy Login o nazwie Andrzej z has³em admin. Dodaj nowego u¿ytkownika o nazwie UpdateOnly. Nadaj mu uprawnienia do wykonywania UPDATE.

create login Andrzej with password = 'admin';

CREATE USER UpdateOnly FOR LOGIN Andrzej;

Grant UPDATE TO UpdateOnly;

--5] Utwórz sekwencjê, która zwraca liczby parzyste z przedzia³u od 0 do 24. Gdy wartoœæ przekroczy 24, sekwencja ma zacz¹æ liczyæ od pocz¹tku. Uruchom sekwencjê!

CREATE SEQUENCE getEven0to24 as integer
START WITH 0
INCREMENT BY 2
MINVALUE 0
MAXVALUE 24
CYCLE;

SELECT next value for getEven0to24;

--6] Wyœwietl listê zamówieñ (OrderID, OrderDate) wraz z odpowiedzialnymi za nie pracownikami (FirstName, LastName), nazw¹ (ProductName) oraz iloœci¹ zamówionego produktu (Quantity) postortowane malej¹co wed³ug iloœci (Quantity).

select o.orderID, o.OrderDate,e.FirstName, e.LastName, p.ProductName, od.Quantity
from Orders as o, Employees as e, Products as p, [Order Details] as od
where o.EmployeeID = e.EmployeeID and o.OrderID = od.OrderID and od.ProductID = p.ProductID
order by od.Quantity desc;

--7] Utwórz tabelê o nazwie Defects w bazie Northwind. Tabela ma posiadaæ nastêpuj¹ce kolumny: id, productid, quantity, description, date, type.
--Id jest kluczem g³ównym z autonumeracj¹;
--productid to klucz obcy z tabeli Products;
--kolumna quantity oznacza liczbê produktów wadliwych;
--kolumna description ma przechowywaæ tekst unicode (max 300 znaków);
--kolumna date ma przechowywaæ datê znalezienia defektu;
--kolumna type ma przechowywaæ jedn¹ z czterech wartoœci: 'Product’, 'Package’, 'Name’, 'Other’;
--pole tabeli Description mo¿e przyjmowaæ wartoœci puste, pozosta³e pola maj¹ nie pozwalaæ na wartoœæ pust¹.

create table Defects (
id int identity (1,1) not null primary key,
productid int not null foreign key references Northwind.dbo.Products(ProductId),
quantity int not null,
[description] nvarchar(300) null,
[date] datetime2 not null,
[type] varchar(7) check ([type] IN ('Product', 'Package', 'Name', 'Other')) not null
);

--8]Utwórz perspektywê, która przechowa 10 krajów z najwiêksz¹ ³¹czn¹ iloœci¹ klientów.

create view view1 as
Select Top 10 City, COUNT(CustomerID) as numerberOfClients
from Customers group by City order by COUNT(CustomerID) desc;

--9] Utwórz transakcjê, która zmniejszy cene najdro¿szego produktu z kategorii 'Seafood’ o 10%. Je¿eli cena produktu spadnie poni¿ej 30, transakcja ma zostaæ wycofana.

DECLARE @ProductID int
DECLARE @MAXPrice float

BEGIN TRANSACTION DecreasePrice
SELECT @MAXPrice = MAX(Products.UnitPrice) FROM Products WHERE CategoryID IN (SELECT CategoryID FROM Categories WHERE CategoryName = 'Seafood')
SELECT @ProductID = productid FROM Products WHERE CategoryID IN (SELECT CategoryID FROM Categories WHERE CategoryName = 'Seafood') AND UnitPrice = @MAXPrice
UPDATE Products SET UnitPrice = UnitPrice - (UnitPrice * 0.1) WHERE ProductID = @ProductID
SET @MAXPrice = @MAXPrice - (@MAXPrice*0.1)
IF @MAXPrice < 30
BEGIN
ROLLBACK TRANSACTION DecreasePrice
Print 'too cheap'
Print @MAXPrice
END
ELSE
BEGIN
COMMIT TRANSACTION DecreasePrice
PRINT 'SUCCESS!'
Print @MAXPrice
END

--10]Wyœwietl trzy kraje (ShipCountry) o najwy¿szym œrednim ³adunku zamówienia (Freight), posortowane malej¹co wed³ug œredniego ³adunku.

select top 3 ShipCountry from Orders group by ShipCountry order by AVG(Freight) desc;