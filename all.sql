--WYbieranie/usuwanie z tabel, tworzenie/dodawanie do/aktualizajca tabel


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

insert into dbo.pracownik values ('Arek', 'Iwan', 'M', 9000, 2, 1)

--tworzenie bazy/perspektyw

--CREATE DATABASE PROG2

/*
set identity_insert dbo.stanowisko on

insert into dbo.stanowisko (st_id, st_nazwa, st_dodatek)
select st_id, st_nazwa, st_dodatek from PROG.dbo.stanowisko

set identity_insert dbo.stanowisko off
*/

/*
set identity_insert dbo.pracownik on

insert into dbo.pracownik(pr_id, pr_imie, pr_nazwisko, pr_pensja, pr_plec, pr_st_id, pr_szef_id)
select pr_id, pr_imie, pr_nazwisko, pr_pensja, pr_plec, pr_st_id, pr_szef_id from PROG.dbo.pracownik

set identity_insert dbo.pracownik off
*/

/*
set identity_insert dbo.nagroda on

insert into dbo.nagroda(na_id, na_kwota, na_pr_id,na_z_tytulu)
select na_id, na_kwota, na_pr_id,na_z_tytulu from PROG.dbo.nagroda

set identity_insert dbo.nagroda off
*/

/*
set identity_insert dbo.kara on

insert into dbo.kara(ka_id, ka_kwota,ka_pr_id,ka_z_tytulu)
select ka_id, ka_kwota,ka_pr_id,ka_z_tytulu from PROG.dbo.kara

set identity_insert dbo.kara off
*/

/*
create table dbo.info(
in_id int identity(1,1) primary key not null,--identity autonumerowanie
in_adres varchar(90) not null,
in_tresc varchar(255) not null,
in_data_wystawienia date not null,
in_email varchar(120) not null,
-- w sql server: constraint PK_info primary key clustered (in_id)
);
*/

-- select GETDATE();

-- select cast (GETDATE() as date) as data_dzisiaj;

--select iif(pracownik.pr_plec = 'M', 'Pan', 'Pani')
--+ ' ' + pracownik.pr_imie + ' ' + pracownik.pr_nazwisko  as adresat from pracownik

/*
SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
        LOWER(p.pr_imie) + '.' + LOWER(p.pr_nazwisko)
        ,' ',''),'¹','a'),'æ','c'),'ê','e'),'³','l'),'ñ','n'),'ó','o'),'œ','s'),'Ÿ','z'),'¿','z')
       + '.' + REPLACE(CAST(p.pr_id AS char),' ','')
	   + '@prog.pl' AS email
  FROM pracownik p;
*/

/*
CREATE VIEW vpracownik AS
SELECT p.pr_id AS vpr_id
     , p.pr_imie AS vpr_imie
	 , p.pr_nazwisko AS vpr_nazwisko
	 , p.pr_pensja AS vpr_pensja
	 , p.pr_plec AS vpr_plec
	 , p.pr_st_id AS vpr_st_id
	 , p.pr_szef_id AS vpr_szef_id
	 , IIF(p.pr_plec = 'M', 'Pan', 'Pani') AS vpr_pan_pani
	 , REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
        LOWER(p.pr_imie) + '.' + LOWER(p.pr_nazwisko)
        ,' ',''),'¹','a'),'æ','c'),'ê','e'),'³','l'),'ñ','n'),'ó','o'),'œ','s'),'Ÿ','z'),'¿','z')
       + '.' + REPLACE(CAST(p.pr_id AS char),' ','')
	   + '@prog.pl' AS vpr_email
  FROM pracownik AS p
*/

/*
INSERT INTO dbo.info (in_adres, in_tresc, in_data_wystawienia, in_email)
SELECT vp.vpr_pan_pani + ' ' + vp.vpr_imie + ' ' + vp.vpr_nazwisko
	 , IIF(vp.vpr_plec='M','Otrzyma³ Pan','Otrzyma³a Pani') + ' ' 
       + 'nagrodê w kwocie ' + CAST(na_kwota AS varchar) + ' z³ '
	   + 'z tytu³u "' + n.na_z_tytulu + '".'
	   AS tresc
	 , CAST(getdate() AS date) AS data_wstawienia
	 , vpr_email
  FROM dbo.nagroda AS n
     , dbo.vpracownik AS vp
 WHERE vp.vpr_id = n.na_pr_id
 */

 /*
INSERT INTO dbo.info (in_adres, in_tresc, in_data_wystawienia, in_email)
SELECT vp.vpr_pan_pani + ' ' + vp.vpr_imie + ' ' + vp.vpr_nazwisko
	 , IIF(vp.vpr_plec='M','Otrzyma³ Pan','Otrzyma³a Pani') + ' ' 
       + 'kare w kwocie ' + CAST(ka_kwota AS varchar) + ' z³ '
	   + 'z tytu³u "' + k.ka_z_tytulu + '".'
	   AS tresc
	 , CAST(getdate() AS date) AS data_wstawienia
	 , vpr_email
  FROM dbo.kara AS k
     , dbo.vpracownik AS vp
 WHERE vp.vpr_id = k.ka_pr_id
 */

INSERT INTO dbo.info (in_adres, in_tresc, in_data_wystawienia, in_email)
SELECT vszef.vpr_pan_pani + ' ' + vszef.vpr_imie + ' ' + vszef.vpr_nazwisko
	 , IIF(vszef.vpr_plec='M','Pana','Pani') + ' '
	   + IIF(vp.vpr_plec='M','podw³adny otrzyma³','podw³adna otrzyma³a') + ' '
	   + 'karê w kwocie ' + CAST(k.ka_kwota AS varchar) + ' z³ z tytu³u "' + k.ka_z_tytulu + '".'
	   AS tresc
	 , CAST(getdate() AS date) AS data_wstawienia
	 , vszef.vpr_email AS email
  FROM dbo.kara AS k
	 , dbo.vpracownik AS vp
	 , dbo.vpracownik AS vszef
 WHERE vp.vpr_id = k.ka_pr_id
 AND vp.vpr_szef_id = vszef.vpr_id

 --tworzenie tabel

 --1

-- CREATE DATABASE DOMY
 
--2

CREATE TABLE DOM (

id int IDENTITY(1,1) primary key nonclustered  NOT NULL,

powierzchnia decimal(5,2) NOT NULL,

piwnica nchar(1) NOT NULL CHECK (piwnica IN ('T', 'N')),

pieter smallint NOT NULL,

miasto nvarchar(50) NOT NULL,

ulica nvarchar(100) NOT NULL,

nr_ulicy nvarchar(10) NOT NULL,

opis nvarchar(255) NOT NULL

)

--3
CREATE TABLE OSOBA (
	id int IDENTITY(1,1) primary key nonclustered NOT NULL,
	imie nvarchar (50) not null,
	nazwisko nvarchar (50) not null,
	pesel nchar(11) not null)

--4
create table umowa (
	id int IDENTITY(1,1) primary key nonclustered NOT NULL,
	nr nvarchar(10) not null,
	[data] date not null,
	dom_id int not null,
	osoba_id int not null,
constraint [umowa_osoba_FK] foreign key(osoba_id) references osoba (id),
constraint [umowa_dom_FK] foreign key(dom_id) references dom (id)
)

--5
delete from umowa
delete from dom
delete from osoba

insert into osoba (imie, nazwisko, pesel)
select 'Jan', 'Kowalski', '12345678901' union all
select 'Adam', 'Nowak', '10987654321'

insert into dom (powierzchnia, piwnica, pieter, miasto, ulica, nr_ulicy, opis)
select 150.10, 'T', 1, 'Lodz', 'Prosta', '20', 'opis' union all
select 175.10, 'N', 1, 'Krakow', 'Jasna', '25', 'opis'

insert into umowa (nr, data, dom_id, osoba_id)
select '1', cast(getdate() as date ),
	(select id from dom where miasto = 'Lodz' and ulica = 'Prosta' and nr_ulicy = '20'),
	(select id from OSOBA where pesel = '12345678901')
union all
select '2', cast(getdate() as date ),
	(select id from dom where miasto = 'Krakow' and ulica = 'Jasna' and nr_ulicy = '25'),
	(select id from OSOBA where pesel = '10987654321')

--7 kolejnosc!!!!!!!
if exists (select * from sys.views where object_id = OBJECT_ID(N'vmiasta'))
drop view vmiasta

drop table UMOWA
drop table OSOBA
drop table DOM

CREATE VIEW [dbo].[vmiasta] AS SELECT DISTINCT(miasto) nazwa FROM DOM

--1
USE [master]
DROP DATABASE [DOMY]
CREATE DATABASE [DOMY]
USE[DOMY]
--2
CREATE TABLE [dbo].[dom](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[powierzchnia] decimal(5,2) NOT NULL,
	[piwnica] [nchar](1) NOT NULL CHECK (piwnica IN ('T','N')),
	[pieter] [smallint] NOT NULL,
	[miasto] [nvarchar](100) NOT NULL,
	[ulica] [nvarchar](100) NOT NULL,
	[nr_ulicy] [nvarchar](10) NOT NULL,
	[opis] [nvarchar](255) NULL,
 CONSTRAINT [dom_PK] PRIMARY KEY NONCLUSTERED ([id] ASC)
) ON [PRIMARY]


--3
CREATE TABLE [dbo].[osoba](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[imie] [nvarchar](50) NOT NULL,
	[nazwisko] [nvarchar](50) NOT NULL,
	[pesel] [nchar](11) NOT NULL,
 CONSTRAINT [osoba_PK] PRIMARY KEY NONCLUSTERED ([id] ASC)
) ON [PRIMARY]

--4
CREATE TABLE [dbo].[umowa](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[nr] [nvarchar](10) NOT NULL,
	[data] [date] NOT NULL,
	[dom_id] [int] NOT NULL,
	[osoba_id] [int] NOT NULL,
 CONSTRAINT [umowa_PK] PRIMARY KEY NONCLUSTERED ([id] ASC),
 CONSTRAINT [umowa_osoba_FK] FOREIGN KEY([osoba_id]) REFERENCES [dbo].[osoba] ([id]),
 CONSTRAINT [umowa_dom_FK] FOREIGN KEY([dom_id]) REFERENCES [dbo].[dom] ([id])
) ON [PRIMARY]

--5
-- usuniecie danych
DELETE FROM [dbo].[umowa]
DELETE FROM [dbo].[dom]
DELETE FROM [dbo].[osoba]

INSERT INTO [dbo].osoba (imie, nazwisko, pesel)
SELECT 'Jan',	'Kowalski',	'85021012345' UNION ALL
SELECT 'Adam',	'Nowak',	'76031523456'

INSERT INTO [dbo].dom (powierzchnia, piwnica, pieter, miasto, ulica, nr_ulicy, opis)
SELECT 150.10,	'T',	1, '£ódŸ', 'Prosta', '20', 'opis domu przy ulicy Prostej' UNION ALL
SELECT 320.05,	'N',	2, 'Warszawa', '¯ucza', '1', '³adny domek' 

INSERT INTO dbo.umowa (nr, data, dom_id, osoba_id)
SELECT '1', CAST(getdate() AS date), --'2023-10-08'
  (SELECT id FROM dbo.dom WHERE miasto = '£ódŸ' AND ulica = 'Prosta' AND nr_ulicy = '20'),
  (SELECT id FROM dbo.osoba WHERE nazwisko = 'Kowalski' AND imie = 'Jan')
UNION ALL
SELECT '2', CAST(getdate() AS date), --'2023-10-08'
  (SELECT id FROM dbo.dom WHERE miasto = 'Warszawa' AND ulica = '¯ucza' AND nr_ulicy = '1'),
  (SELECT id FROM dbo.osoba WHERE nazwisko = 'Nowak' AND imie = 'Adam')



/*
USE [DOMY]
CREATE VIEW [dbo].[vmiasta]
AS
SELECT DISTINCT(miasto) nazwa
FROM  dbo.dom

*/

/*
--7
-- perspektywa vmiasta
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vmiasta]'))
DROP VIEW [dbo].[vmiasta]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[umowa]') AND type in (N'U'))
DROP TABLE [dbo].[umowa]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[osoba]') AND type in (N'U'))
DROP TABLE [dbo].[osoba]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dom]') AND type in (N'U'))
DROP TABLE [dbo].[dom]
GO
*/

--1
CREATE TABLE ADRES (
    id int IDENTITY(1,1) primary key nonclustered,
    miasto NVARCHAR(50) NOT NULL,
    kod_pocztowy NCHAR(5) NOT NULL,
    ulica NVARCHAR(100) NOT NULL,
    nr_domu NVARCHAR(10) NOT NULL,
    nr_lokalu NVARCHAR(50) NULL,
    typ NCHAR(1) NOT NULL CHECK (typ IN ('Z', 'K')),
    osoba_id INT NOT NULL FOREIGN KEY REFERENCES OSOBA(id)
);


--2
INSERT INTO ADRES (miasto, kod_pocztowy, ulica, nr_domu, nr_lokalu, typ, osoba_id)
SELECT '£ódŸ', '99999', 'Sowojska', '11', '4', 'Z', (SELECT id FROM osoba WHERE pesel = 85021012345) union all
SELECT '£ódŸ', '99999', 'InnaUlica', '22', '5', 'K', (SELECT id FROM osoba WHERE pesel = 76031523456) union all
SELECT 'Warszawa', '12345', 'Krakowska', '33', '7', 'Z', (SELECT id FROM osoba WHERE pesel = 76031523456);

--3
Create unique index adres_UX1 on ADRES (osoba_id ASC, typ ASC);

--4
ALTER VIEW dbo.vmiasta AS SELECT miasto AS nazwa FROM dom UNION SELECT miasto AS nazwa FROM ADRES;

--5
CREATE TABLE MIASTO (
    id INT IDENTITY(1,1) not null primary key nonclustered,
    nazwa NVARCHAR(50) NOT NULL unique,
    stawka MONEY NULL
);

--6 Dodaj do tabel ADRES oraz DOM pole miasto_id, bêd¹ce kluczem obcym do id w tabeli MIASTO. Dodane pole ma byæ niewymagalne.
ALTER TABLE ADRES ADD miasto_id INT NOT NULL FOREIGN KEY REFERENCES MIASTO(id);
ALTER TABLE DOM ADD miasto_id INT NOT NULL FOREIGN KEY REFERENCES MIASTO(id);

--7
INSERT INTO miasto(nazwa) SELECT nazwa FROM vmiasta;

--8
UPDATE DOM SET miasto_id = (SELECT id from miasto where miasto.nazwa = dom.miasto);
UPDATE ADRES SET miasto_id = (SELECT id from miasto where miasto.nazwa = ADRES.miasto);

--9
ALTER TABLE ADRES DROP COLUMN miasto
ALTER TABLE ADRES ALTER COLUMN miasto_id [int] NOT NULL
ALTER TABLE DOM DROP COLUMN miasto
ALTER TABLE DOM ALTER COLUMN miasto_id [int] NOT NULL

--10
DROP VIEW vmiasta

--11
UPDATE MIASTO SET stawka = id * DATEPART(MICROSECOND, GETDATE()) / 123;

--12
create view vdomy
as
select dom.id, dom.powierzchnia, dom.piwnica, dom.pieter, dom.ulica, dom.nr_ulicy, dom.opis, miasto.nazwa AS miasto, ISNULL(miasto.stawka, 0) as stawka_za_metr, dom.powierzchnia * ISNULL(miasto.stawka, 0) AS wycena
from dom, miasto where miasto.id = dom.miasto_id;

--1
create table obserwacje (
id bigint not null primary key nonclustered,
[data] datetime2  not null,
[IP] nvarchar(15) not null,
dom_id int not null foreign key references dom(id)
)
--2
create sequence seq_obserwacje_id
	as int
	start with 1
	increment by 1
	no cycle

select next value for seq_obserwacje_id

--3
create type ut_IPv4 from nvarchar(15) -- deklaracja nowego typu danych

--4
alter table obserwacje alter column [IP] ut_IPv4 not null

--5
create clustered index obserwacje_idx_IP on obserwacje([IP])

--7
create view domy_wg_odwiedin as
Select Top 1000 obserwacje.dom_id, count(*) as liczba_odwiedzin --Top niezbedny by zadzialalo w sql server
from obserwacje group by obserwacje.dom_id order by 2 desc

--8
create view vtop10dom as
Select Top 10 obserwacje.dom_id, count(*) as liczba_obserwacji_dzien
from obserwacje where [data] between getdate() - 100 and getdate()
group by obserwacje.dom_id order by 2 desc --sortuje po druguiej rzeczy w selectcie w tym wypadku po count(*)

--9
create view vIP3razy as
select dom_id, [IP], count(*) as liczba_obserwacji
from obserwacje group by dom_id, [IP]
having count(*) > 3

--joiny

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


--transakcje

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


--merge

--2
MERGE Territories AS T
USING EmployeeTerritories AS S
ON T.TerritoryID = S.TerritoryID
WHEN NOT MATCHED BY SOURCE
THEN DELETE;

--3
MERGE Categories AS T
USING (Values ('Dummy')) AS S (Nazwa)
ON CategoryName = S.Nazwa
WHEN MATCHED THEN
UPDATE SET T.[Description] = 'New dummy description'
WHEN NOT MATCHED THEN
INSERT (CategoryName, [Description], Picture) VALUES ('Dummy', 'Dummy description', 'Picture');

--4
MERGE Categories AS T
USING Products AS S
ON T.CategoryID = S.CategoryID
WHEN NOT MATCHED BY SOURCE
THEN DELETE;

--5
MERGE [Order Details] AS T
USING Orders AS S
ON T.OrderID = S.OrderID
WHEN MATCHED AND S.ShipCountry = 'USA' THEN
UPDATE SET T.Discount = 0.3;

--6
MERGE Products AS T
USING Suppliers AS S
ON T.SupplierID = S.SupplierID
WHEN MATCHED AND S.CompanyName = 'Exotic Liquids' THEN
UPDATE SET T.Discontinued = 1;

--7
-- na 5 na kolosie
MERGE Products AS T
USING (Values ('Finlandia')) AS S (ProductName)
ON T.ProductName = S.ProductName
WHEN MATCHED THEN
UPDATE SET UnitsInStock += 10
WHEN NOT MATCHED THEN
INSERT (ProductName, SupplierId, CategoryID) VALUES ('Finlandia', (Select SupplierID FROM Suppliers WHERE CompanyName = 'Exotic Liquids'),
(Select CategoryID FROM Categories WHERE CategoryName = 'Bevereges'));

--login, user, uprawnienia

--1
create login login10 with password = 'admin'
select PWDENCRYPT('admin')

create login login11 with password = 0x0200A971EB5D21EFB48844A5F84FB90A6765FBED81CDFB5320C17A546DC2BF313CD10C5A4F89826E6E01BA579283FFD78306AB3E0E9E1D6ED91F5CDBD1CDCEE4F15268002952 hashed

--2
select sp.name as Login, sp.type_desc as login_type from sys.server_principals sp

--3
USE Northwind;

CREATE USER NorthwindUser FOR LOGIN Login10

use domy

CREATE USER OtherUser FOR LOGIN Login11

--4
setuser 'NorthwindUser'
select * from Customers
setuser
grant select to NorthwindUSer

--5
grant update, insert on [Orders] To NorthwindUser
grant update, insert on [Order Details] To NorthwindUser

--6
revoke insert on [Orders] from NorthwindUser
revoke insert on [Order Details] from NorthwindUser

--7
alter login login10 with password = 'admin 1234'
alter login login11 disable

--8
DROP LOGIN login11
setuser 'OtherUser'
alter user OtherUser with login = login10;

--9
use Northwind
create role Salesman
grant select, insert to Salesman
alter role Salesman add member NorthwindUser

select name, principal_id, type, type_desc, owning_principal_id from sys.database_principals

--próbny kolos, 8 zadañ ok


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
