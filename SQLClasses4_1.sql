[15:16] Karol Pytlos
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





