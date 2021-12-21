MySQL, MySQL Workbench

show databases;

create database Name_DB;

use Name_DB;

show tables;

create table users(
	id int not null auto_increment,
	name varshar(20) not null,
	age int not null,
	gender varshar(6) not null,
	primary key (id)
);

select * from users;

insert into users 
values (null, 'Max', '20', 'male');

select * from users limit 100;
select * from users limit 100 offset 100;
select * from users limit 100 offset 200;
...
-- comment
select * from users order by age desc limit 1; -- max age template

-- agregate functions
-- min, max, avg, count, sum

select   max(age) as max_age, gender
    from users 
group by gender;


update users set name = 'Kostya' where id = 6;

delete from users where id = 6;


-- 91.201.233.14  сервер Okten

-- ДЗ
show databases;
use vkopka; -- моя подбазенка
show tables;
-- найти все машины старше 2000 г
select * from cars where year < 2000;
-- найти все машины млатше 2015 г
select * from cars where year > 2015;
-- найти все машины 2008, 2009, 2010 годов
select * from cars where year in (2008, 2009, 2010);
-- найти все машины не с этих годов 2008, 2009, 2010 годов
select * from cars where year not in (2008, 2009, 2010);
-- найти все машины год которых совпадает с ценой
select * from cars where year = price;
-- найти все машины bmw старше 2014 года
select * from cars where year < 2014 and model like '%bmw%';
-- найти все машины audi младше 2014 года
select * from cars where model like '%audi%'  and year > 2014;
-- найти первые 5 машин
select * from cars order by id limit 5;
-- найти последнии 5 машин
select * from cars order by id desc limit 5;
-- найти среднее арифметическое цен машин модели KIA
select avg(price) from cars where model like '%kia%';
-- найти среднее арифметическое цен каждой машины
select avg(price) from cars;
-- посчитать количество каждой марки машин
select count(price) as count, model from cars group by model;
-- найти марку машины количество которых больше всего
select m.model from (select count(*) as count, model from cars 
group by model order by count desc limit 1) as m;
-- тоже вариант
select model from cars group by model order by count(model) desc limit 1;
-- найти все машины в модели которых вторая и предпоследняя буква "а"
select * from cars where model like '_a%a_';
-- найти все машины модели которых больше 8 символов
select * from cars where length(model) > 8;
-- ***найти машины цена которых больше чем цена 
-- среднего арифметического всех машин
select * from cars
where price > (select avg(price) from cars);
