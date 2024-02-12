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
SELECT 150.10,	'T',	1, '£Ûdü', 'Prosta', '20', 'opis domu przy ulicy Prostej' UNION ALL
SELECT 320.05,	'N',	2, 'Warszawa', 'Øucza', '1', '≥adny domek' 

INSERT INTO dbo.umowa (nr, data, dom_id, osoba_id)
SELECT '1', CAST(getdate() AS date), --'2023-10-08'
  (SELECT id FROM dbo.dom WHERE miasto = '£Ûdü' AND ulica = 'Prosta' AND nr_ulicy = '20'),
  (SELECT id FROM dbo.osoba WHERE nazwisko = 'Kowalski' AND imie = 'Jan')
UNION ALL
SELECT '2', CAST(getdate() AS date), --'2023-10-08'
  (SELECT id FROM dbo.dom WHERE miasto = 'Warszawa' AND ulica = 'Øucza' AND nr_ulicy = '1'),
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
SELECT '£Ûdü', '99999', 'Sowojska', '11', '4', 'Z', (SELECT id FROM osoba WHERE pesel = 85021012345) union all
SELECT '£Ûdü', '99999', 'InnaUlica', '22', '5', 'K', (SELECT id FROM osoba WHERE pesel = 76031523456) union all
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

--6 Dodaj do tabel ADRES oraz DOM pole miasto_id, bÍdπce kluczem obcym do id w tabeli MIASTO. Dodane pole ma byÊ niewymagalne.
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