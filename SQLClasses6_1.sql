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
