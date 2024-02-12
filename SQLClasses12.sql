--1] Wy�wietl posortowan� alfabetycznie list� produkt�w (same nazwy produkt�w), kt�re nie s� ju� oferowane w sprzeda�y (discontinued).

select ProductName from [Northwind].[dbo].[Products] where Discontinued = 1;

--2] Utw�rz nowy login o nazwie admin z has�em 1234.

create login admin1 with password = '1234';

--3] Wy�wietl liczb� dostawc�w (Suppliers). U�yj aliasu do podpisania wyniku zapytania jako "Liczba dostawc�w".

select COUNT(SupplierId) as "Liczba dostawc�w" from [Northwind].[dbo].[Suppliers];

--4] Znajd� dostawc� produktu 'Ipoh Coffee'. W wyniku zapytania, poka� id, nazw�, adres oraz numer kontaktowy dostawcy.

select [SupplierID]
      ,[CompanyName]
      ,[Address]
      ,[Phone]
from [Northwind].[dbo].[Suppliers]
where [SupplierID] = (select [SupplierID] from [Northwind].[dbo].[Products] where [ProductName] like 'Ipoh Coffee');

--5] Utw�rz sekwencj�, kt�ra b�dzie zwraca�a liczby nieparzyste z przedzia�u od 1 do 100 w cyklu (gdy warto�� przekroczy 99, sekwencja ma zacz�� liczy� od pocz�tku). Uruchom sekwencj�.

CREATE SEQUENCE getOdd1to100 as integer
START WITH 1
INCREMENT BY 2
MINVALUE 1
MAXVALUE 100
CYCLE;

SELECT next value for getOdd1to100;

--6] Utw�rz tabel� o nazwie 'Complaints' w bazie Northwind. Tabela ma posiada� nast�puj�ce kolumny: id, employeeid, description, date, type.
-- Id jest kluczem g��wnym z autonumeracj�.
-- employeeid klucz obcy z tabeli Employees
-- pole descripion ma przechowywa� tekst unicode (max 200 znak�w)
-- pole date ma przechowywa� dat� zg�oszenia
-- pole type ma przechowywa� jedn� z trzech warto�ci: 'P', 'R', 'S'. �adna inna warto�� nie jest dopuszczalna.

create table Complaints (
id int identity (1,1) not null primary key,
employeeid int not null foreign key references Northwind.dbo.Employees(EmployeeId),
[description] nvarchar(200),
[date] datetime2  not null,
[type] nchar(1) check ([type] IN ('P', 'R', 'S'))
);

--7] Utw�rz perspektyw� pokazuj�c� list� terytori�w (ich id) wraz z przypisanymi do nich pracownikami (imi� i nazwisko).

create view terEmp as
Select Top 1000 et.TerritoryId, e.FirstName, e.LastName
from EmployeeTerritories as et, Employees as e where et.EmployeeID = e.EmployeeID;

--8] Wy�wietl list� produkt�w (tylko nazwa produktu i cena) o cenie przekraczaj�cej �redni� cen� produktu w tabeli products. Posortuj wynik wed�ug ceny.

select [ProductName], [UnitPrice] from Products where [UnitPrice] > (SELECT AVG([UnitPrice]) FROM Products) order by [UnitPrice];

--9] Utw�rz transakcj�, kt�ra zwi�kszy cen� najta�szego produktu z kategorii 'Produce' o 15%. Je�eli cena produktu przekroczy 16, transakcja ma zosta� wycofana.

begin transaction increasePrice

DECLARE @ProductID INT
DECLARE @UnitPrice FLOAT

SELECT @MINPrice = MIN(UnitPrice) FROM Products WHERE @ProductCategoryID = (SELECT TOP (1000) [CategoryID] where [CategoryName] like 'Produce')

END

--10] Wy�wietl list� przedstawiaj�c� podliczon� ilo�� zam�wie� z danej kategorii dla danego kraju. Lista ma by� posortowana alfabetycznie, wed�ug nazwy kategorii.