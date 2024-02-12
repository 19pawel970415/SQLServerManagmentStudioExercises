--1] Wyœwietl posortowan¹ alfabetycznie listê produktów (same nazwy produktów), które nie s¹ ju¿ oferowane w sprzeda¿y (discontinued).

select ProductName from [Northwind].[dbo].[Products] where Discontinued = 1;

--2] Utwórz nowy login o nazwie admin z has³em 1234.

create login admin1 with password = '1234';

--3] Wyœwietl liczbê dostawców (Suppliers). U¿yj aliasu do podpisania wyniku zapytania jako "Liczba dostawców".

select COUNT(SupplierId) as "Liczba dostawców" from [Northwind].[dbo].[Suppliers];

--4] ZnajdŸ dostawcê produktu 'Ipoh Coffee'. W wyniku zapytania, poka¿ id, nazwê, adres oraz numer kontaktowy dostawcy.

select [SupplierID]
      ,[CompanyName]
      ,[Address]
      ,[Phone]
from [Northwind].[dbo].[Suppliers]
where [SupplierID] = (select [SupplierID] from [Northwind].[dbo].[Products] where [ProductName] like 'Ipoh Coffee');

--5] Utwórz sekwencjê, która bêdzie zwraca³a liczby nieparzyste z przedzia³u od 1 do 100 w cyklu (gdy wartoœæ przekroczy 99, sekwencja ma zacz¹æ liczyæ od pocz¹tku). Uruchom sekwencjê.

CREATE SEQUENCE getOdd1to100 as integer
START WITH 1
INCREMENT BY 2
MINVALUE 1
MAXVALUE 100
CYCLE;

SELECT next value for getOdd1to100;

--6] Utwórz tabelê o nazwie 'Complaints' w bazie Northwind. Tabela ma posiadaæ nastêpuj¹ce kolumny: id, employeeid, description, date, type.
-- Id jest kluczem g³ównym z autonumeracj¹.
-- employeeid klucz obcy z tabeli Employees
-- pole descripion ma przechowywaæ tekst unicode (max 200 znaków)
-- pole date ma przechowywaæ datê zg³oszenia
-- pole type ma przechowywaæ jedn¹ z trzech wartoœci: 'P', 'R', 'S'. ¯adna inna wartoœæ nie jest dopuszczalna.

create table Complaints (
id int identity (1,1) not null primary key,
employeeid int not null foreign key references Northwind.dbo.Employees(EmployeeId),
[description] nvarchar(200),
[date] datetime2  not null,
[type] nchar(1) check ([type] IN ('P', 'R', 'S'))
);

--7] Utwórz perspektywê pokazuj¹c¹ listê terytoriów (ich id) wraz z przypisanymi do nich pracownikami (imiê i nazwisko).

create view terEmp as
Select Top 1000 et.TerritoryId, e.FirstName, e.LastName
from EmployeeTerritories as et, Employees as e where et.EmployeeID = e.EmployeeID;

--8] Wyœwietl listê produktów (tylko nazwa produktu i cena) o cenie przekraczaj¹cej œredni¹ cenê produktu w tabeli products. Posortuj wynik wed³ug ceny.

select [ProductName], [UnitPrice] from Products where [UnitPrice] > (SELECT AVG([UnitPrice]) FROM Products) order by [UnitPrice];

--9] Utwórz transakcjê, która zwiêkszy cenê najtañszego produktu z kategorii 'Produce' o 15%. Je¿eli cena produktu przekroczy 16, transakcja ma zostaæ wycofana.

begin transaction increasePrice

DECLARE @ProductID INT
DECLARE @UnitPrice FLOAT

SELECT @MINPrice = MIN(UnitPrice) FROM Products WHERE @ProductCategoryID = (SELECT TOP (1000) [CategoryID] where [CategoryName] like 'Produce')

END

--10] Wyœwietl listê przedstawiaj¹c¹ podliczon¹ iloœæ zamówieñ z danej kategorii dla danego kraju. Lista ma byæ posortowana alfabetycznie, wed³ug nazwy kategorii.