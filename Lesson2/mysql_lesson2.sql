show databases;
use vkopka; --
show tables;
-- 1.Вибрати усіх клієнтів, чиє ім'я має менше ніж 6 символів.
select * from client c where length(c.firstname) < 6;
-- 2.Вибрати львівські відділення банку.
select * from vkopka.department d where d.DepartmentCity = 'Lviv';
-- 3.Вибрати клієнтів з вищою освітою та посортувати по прізвищу.
select * from vkopka.client c where c.Education = 'high' order by c.FirstName;
-- 4.Виконати сортування у зворотньому порядку над таблицею
-- Заявка і вивести 5 останніх елементів.
select * from vkopka.application a order by a.idApplication desc limit 5;
-- 5.Вивести усіх клієнтів, чиє прізвище закінчується на OV чи OVA.
select * from vkopka.client c where c.LastName like '%ov' or c.LastName like '%ova';
-- 6.Вивести клієнтів банку, які обслуговуються київськими відділеннями.
select c.* from vkopka.client c
		 join vkopka.department d
           on d.idDepartment = c.Department_idDepartment
where d.DepartmentCity = 'Kyiv';
-- 7.Знайти унікальні імена клієнтів.
select distinct c.FirstName from vkopka.client c;
-- 8.Вивести дані про клієнтів, які мають кредит
-- більше ніж на 5000 тисяч гривень.
select * from vkopka.client c
  join vkopka.application a on a.Client_idClient = c.idClient
where a.Sum > 5000
  and a.Currency = 'Gryvnia'
  and a.CreditState = 'Not returned';
select
      (select count(*) as count_clients from client c
         join department d
           on d.idDepartment = c.Department_idDepartment)
    as AllCount,
	  (select count(*) as count_clients from client c
         join department d
           on d.idDepartment = c.Department_idDepartment
        where d.DepartmentCity = 'Lviv')
	as LvivCount
from dual;


-- 9.Порахувати кількість клієнтів усіх відділень та лише львівських відділень.
select count(*) as count_clients from vkopka.client c
  join vkopka.department d on d.idDepartment = c.Department_idDepartment; -- All
select count(*) as count_clients from vkopka.client c
  join vkopka.department d on d.idDepartment = c.Department_idDepartment
 where d.DepartmentCity = 'Lviv'; -- Lviv
-- 10.Знайти кредити, які мають найбільшу суму для кожного клієнта окремо.
select c.idClient, c.FirstName, c.LastName,
	   c.Age, c.City, c.Passport, c.Education,
	   c.Department_idDepartment, max(a.sum) as maxsum
  from vkopka.application a
  join vkopka.client c
    on a.Client_idClient = c.idClient
group by c.idClient, c.FirstName, c.LastName, c.Age, c.City,
         c.Passport, c.Education, c.Department_idDepartment;
-- 11. Визначити кількість заявок на крдеит для кожного клієнта.
select c.idClient, c.FirstName, c.LastName,
	   c.Age, c.City, c.Passport, c.Education,
	   c.Department_idDepartment, count(a.sum) as cnt
  from vkopka.application a
  join vkopka.client c
    on a.Client_idClient = c.idClient
group by c.idClient, c.FirstName, c.LastName, c.Age, c.City,
         c.Passport, c.Education, c.Department_idDepartment;
-- 12. Визначити найбільший та найменший кредити.
select
	(select max(a.sum) from vkopka.application a) as maxsum,
    (select min(a.sum) from vkopka.application a) as minsum
from dual;
-- 13. Порахувати кількість кредитів для клієнтів,які мають вищу освіту
select c.idClient, c.FirstName, c.LastName,
	   c.Age, c.City, c.Passport, c.Education,
	   c.Department_idDepartment, count(a.sum) as cnt
  from vkopka.application a
  join vkopka.client c
    on a.Client_idClient = c.idClient
where c.Education = 'high'
group by c.idClient, c.FirstName, c.LastName, c.Age, c.City,
         c.Passport, c.Education, c.Department_idDepartment;
-- 14. Вивести дані про клієнта, в якого середня сума кредитів найвища.
select c.idClient, c.FirstName, c.LastName,
	   c.Age, c.City, c.Passport, c.Education,
	   c.Department_idDepartment,
       avg(a.sum) as avgsum
  from vkopka.application a
  join vkopka.client c
    on a.Client_idClient = c.idClient
where c.Education = 'high'
group by c.idClient, c.FirstName, c.LastName, c.Age, c.City,
         c.Passport, c.Education, c.Department_idDepartment
order by avgsum desc
limit 1;
-- 15. Вивести відділення, яке видало в кредити найбільше грошей
select d.idDepartment, d.DepartmentCity, d.CountOfWorkers, sum(a.Sum) as sum
  from vkopka.department  d
  join vkopka.client      c on c.Department_idDepartment = d.idDepartment
  join vkopka.application a on a.Client_idClient = c.idClient
group by d.idDepartment, d.DepartmentCity, d.CountOfWorkers
order by sum desc
limit 1;
-- 16. Вивести відділення, яке видало найбільший кредит.
select d.idDepartment, d.DepartmentCity, d.CountOfWorkers, max(a.Sum) as maxsum
  from vkopka.department  d
  join vkopka.client      c on c.Department_idDepartment = d.idDepartment
  join vkopka.application a on a.Client_idClient = c.idClient
group by d.idDepartment, d.DepartmentCity, d.CountOfWorkers
order by maxsum desc
limit 1;
-- 17. Усім клієнтам, які мають вищу освіту, встановити усі їхні кредити у розмірі 6000 грн.
-- установка
update vkopka.application as app,
	(select a.idApplication
	   from vkopka.application a
	   join vkopka.client c on c.idClient = a.Client_idClient
	  where c.Education = 'high') as ids
set app.Sum = 6000, app.Currency = 'Gryvnia'
where app.idApplication = ids.idApplication;
-- проверка
select *
  from vkopka.application a
  join vkopka.client c on c.idClient = a.Client_idClient
 where c.Education = 'high';
-- 18. Усіх клієнтів київських відділень пересилити до Києва.
update vkopka.client as cli,
	(select c.idClient
	   from vkopka.client c
       join vkopka.department d on d.idDepartment = c.Department_idDepartment
       where c.City != 'Kyiv' and d.DepartmentCity = 'Kyiv') as dc
set cli.City = 'Kyiv'
where cli.idClient = dc.idClient;
-- 19. Видалити усі кредити, які є повернені.
delete from vkopka.application as a
 where a.CreditState = 'Returned' and a.idApplication > 0;
 -- 20. Видалити кредити клієнтів, в яких друга літера прізвища є голосною.
 -- a,e,i,o,u,y
delete from vkopka.application as a
 where a.idApplication > 0
   and a.Client_idClient in
      (select c.idClient
         from vkopka.client c
		where c.LastName rlike '^.[aeiouy]'
      );
-- 21.Знайти львівські відділення, які видали кредитів на загальну суму більше ніж 10000
select d.idDepartment, d.DepartmentCity, d.CountOfWorkers, sum(a.Sum) as asum
  from vkopka.department  d
  join vkopka.client      c on c.Department_idDepartment = d.idDepartment
  join vkopka.application a on a.Client_idClient = c.idClient
where d.DepartmentCity = 'Lviv'
group by d.idDepartment, d.DepartmentCity, d.CountOfWorkers
having asum > 10000;
-- 22.Знайти клієнтів, які повністю погасили кредити на суму більше ніж 5000
select *
  from vkopka.client c
 where c.idClient in
     (select distinct a.Client_idClient
        from vkopka.application a
	   where a.Sum > 5000 and a.CreditState = 'Returned');
-- 23.Знайти максимальний неповернений кредит.
select *
  from vkopka.application a
 where a.CreditState = 'Not returned'
order by a.Sum desc
limit 1;
-- 24.Знайти клієнта, сума кредиту якого найменша
select *
  from vkopka.client as c
  join vkopka.application as a
    on a.Client_idClient = c.idClient
order by a.Sum
limit 1;
-- 25.Знайти кредити, сума яких більша за середнє значення усіх кредитів
-- 1 вариант
with ext as (select avg(a.Sum) as sumavg from vkopka.application a)
select * from vkopka.application app, ext
 where app.Sum > ext.sumavg;
-- 2 вариант
select * from vkopka.application app
 where app.Sum > (select avg(a.Sum) as sumavg from vkopka.application a);
-- что лучше?
-- 26. Знайти клієнтів, які є з того самого міста, що і клієнт, який взяв найбільшу кількість кредитів
select *
from client
where City = (
    select c.City
    from client c
             join application a on c.idclient = a.client_idclient
    group by idclient
    order by count(idapplication) desc
    limit 1
);
-- # 27. Місто клієнта з найбільшою кількістю кредитів
select c.City
from client c
         join application a on c.idclient = a.client_idclient
group by idclient
order by count(idapplication) desc
limit 1;
--
select * from vkopka.department;
select * from vkopka.client c;
select * from vkopka.application a;

