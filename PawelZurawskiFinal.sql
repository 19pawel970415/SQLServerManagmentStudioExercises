--1] Wy�wietl pracownik�w (FirstName, LastName), kt�rych nazwiska zaczynaj� si� na liter� C.

SELECT FirstName, LastName FROM Employees
WHERE LastName LIKE 'C%';

--2] Wy�wietl list� pracownik�w (FirstName, LastName, HireDate z tabeli Employees), kt�rzy NIE zostali zatrudnieni w latach od 01.01.1950 do 01.01.1960.

select FirstName, LastName, HireDate from Employees where HireDate not between '1950-01-01' and '1960-01-01';

--3] Napisz zapytanie wy�wietlaj�ce list� produkt�w (ProductName, UnitsOnOrder, UnitsInStock), kt�rych zapas (UnitsInStock) jest wi�kszy lub r�wny ilo�� zam�wie� (UnitsOnOrder).

select ProductName, UnitsOnOrder, UnitsInStock from Products where UnitsInStock >= UnitsOnOrder;

--4] Utw�rz nowy Login o nazwie Andrzej z has�em admin. Dodaj nowego u�ytkownika o nazwie UpdateOnly. Nadaj mu uprawnienia do wykonywania UPDATE.

create login Andrzej with password = 'admin';

CREATE USER UpdateOnly FOR LOGIN Andrzej;

Grant UPDATE TO UpdateOnly;

--5] Utw�rz sekwencj�, kt�ra zwraca liczby parzyste z przedzia�u od 0 do 24. Gdy warto�� przekroczy 24, sekwencja ma zacz�� liczy� od pocz�tku. Uruchom sekwencj�!

CREATE SEQUENCE getEven0to24 as integer
START WITH 0
INCREMENT BY 2
MINVALUE 0
MAXVALUE 24
CYCLE;

SELECT next value for getEven0to24;

--6] Wy�wietl list� zam�wie� (OrderID, OrderDate) wraz z odpowiedzialnymi za nie pracownikami (FirstName, LastName), nazw� (ProductName) oraz ilo�ci� zam�wionego produktu (Quantity) postortowane malej�co wed�ug ilo�ci (Quantity).

select o.orderID, o.OrderDate,e.FirstName, e.LastName, p.ProductName, od.Quantity
from Orders as o, Employees as e, Products as p, [Order Details] as od
where o.EmployeeID = e.EmployeeID and o.OrderID = od.OrderID and od.ProductID = p.ProductID
order by od.Quantity desc;

--7] Utw�rz tabel� o nazwie Defects w bazie Northwind. Tabela ma posiada� nast�puj�ce kolumny: id, productid, quantity, description, date, type.
--Id jest kluczem g��wnym z autonumeracj�;
--productid to klucz obcy z tabeli Products;
--kolumna quantity oznacza liczb� produkt�w wadliwych;
--kolumna description ma przechowywa� tekst unicode (max 300 znak�w);
--kolumna date ma przechowywa� dat� znalezienia defektu;
--kolumna type ma przechowywa� jedn� z czterech warto�ci: 'Product�, 'Package�, 'Name�, 'Other�;
--pole tabeli Description mo�e przyjmowa� warto�ci puste, pozosta�e pola maj� nie pozwala� na warto�� pust�.

create table Defects (
id int identity (1,1) not null primary key,
productid int not null foreign key references Northwind.dbo.Products(ProductId),
quantity int not null,
[description] nvarchar(300) null,
[date] datetime2 not null,
[type] varchar(7) check ([type] IN ('Product', 'Package', 'Name', 'Other')) not null
);

--8]Utw�rz perspektyw�, kt�ra przechowa 10 kraj�w z najwi�ksz� ��czn� ilo�ci� klient�w.

create view view1 as
Select Top 10 City, COUNT(CustomerID) as numerberOfClients
from Customers group by City order by COUNT(CustomerID) desc;

--9] Utw�rz transakcj�, kt�ra zmniejszy cene najdro�szego produktu z kategorii 'Seafood� o 10%. Je�eli cena produktu spadnie poni�ej 30, transakcja ma zosta� wycofana.

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

--10]Wy�wietl trzy kraje (ShipCountry) o najwy�szym �rednim �adunku zam�wienia (Freight), posortowane malej�co wed�ug �redniego �adunku.

select top 3 ShipCountry from Orders group by ShipCountry order by AVG(Freight) desc;