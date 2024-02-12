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











