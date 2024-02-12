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
