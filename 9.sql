-- ЛР11 для dbcar_hire — исправленный и готовый к запуску

use master
go
if exists(select * from sys.databases where name = 'dbcar_hire')
begin
    alter database dbcar_hire set single_user with rollback immediate
    drop database dbcar_hire
end
go
create database dbcar_hire
go
use dbcar_hire
go

-- Удаление таблиц в правильном порядке
drop table if exists tblRentalDetails
drop table if exists tblContract
drop table if exists tblVehicle
drop table if exists tblRental
drop table if exists tblCustomer
drop table if exists tblCity
drop table if exists tblLocation
drop table if exists tblTable
go

-- Таблицы

create table tblLocation (
    pk_idLocation int not null identity(1,1) primary key,
    nameLocation varchar(50) not null unique,
    typeOfLocation varchar(30) not null
)
go

create table tblCity (
    pk_idCity int not null identity(1,1) primary key,
    nameCity varchar(30) not null
)
go

create table tblCustomer (
    pk_idCustomer int not null identity(1,1) primary key,
    fullName varchar(50) not null unique,
    phone nvarchar(20) not null unique,
    fk_idCity int not null foreign key references tblCity(pk_idCity) on delete cascade on update cascade
)
go

create table tblRental (
    pk_idRental int not null identity(1,1) primary key,
    rentalCode varchar(20) not null unique,
    rentalDurationDays int not null default 1,
    totalCost decimal(10,2) not null check (totalCost > 500),
    fk_idLocation int not null foreign key references tblLocation(pk_idLocation)
)
go

create table tblVehicle (
    pk_idVehicle int not null identity(1,1) primary key,
    modelName varchar(30) not null unique,
    dailyRate decimal(10,2) not null check (dailyRate > 10),
    registrationExpiry date not null
)
go

create table tblContract (
    pk_idContract int not null identity(1,1) primary key,
    contractCode varchar(25) not null unique,
    fk_idCustomer int not null foreign key references tblCustomer(pk_idCustomer),
    fk_idRental int not null foreign key references tblRental(pk_idRental)
)
go

create table tblRentalDetails (
    pk_idRentalDetail int not null identity(1,1) primary key,
    carPosition int not null check (carPosition < 300) default 1,
    fk_idVehicle int not null foreign key references tblVehicle(pk_idVehicle),
    fk_idRental int not null foreign key references tblRental(pk_idRental),
    calculation as pk_idRentalDetail + carPosition
)
go

create table tblTable (
    pk_idTable int not null identity(1,1) primary key,
    nameTable varchar(20) not null unique,
    valueTable int not null check (valueTable > 20) default 21
)
go

-- Данные

insert into tblTable values ('Филиал_Один', 25),('Филиал_Два', 45),('Филиал_Три', 23),
                            ('Филиал_Четыре', 89),('Филиал_Пять', 1000),('Филиал_Шесть', 25),
                            ('Филиал_Семь', 67),('Филиал_Восемь', 44),('Филиал_Девять', 212),
                            ('Филиал_Десять', 1032)
go

insert into tblLocation values 
('Минский филиал', 'Городской'),
('Гомельский филиал', 'Городской'),
('Мобильный пункт', 'Передвижной'),
('Тестовый офис', 'Временный'),
('Дистанционный отдел', 'Онлайн')
go
update tblLocation set typeOfLocation = 'Передвижной' where pk_idLocation = 5
delete from tblLocation where pk_idLocation = 4
go

insert into tblCity values 
('Минск'),('Гомель'),('Заславль'),('Могилев'),('Барановичи')
go
update tblCity set nameCity = 'Витебск' where pk_idCity = 3
-- Гомель используется в клиенте — нельзя удалять
go

insert into tblCustomer values
('Алиса Гаманович', '4472621', (select pk_idCity from tblCity where nameCity = 'Минск')),
('Валерия Садсковская', '4477839', (select pk_idCity from tblCity where nameCity = 'Витебск')),
('Александра Вересова', '2970809', (select pk_idCity from tblCity where nameCity = 'Минск')),
('Илья Абрамушин', '2970899', (select pk_idCity from tblCity where nameCity = 'Гомель')),
('Евгений Веренчик', '3377654', (select pk_idCity from tblCity where nameCity = 'Барановичи'))
go
delete from tblCustomer where pk_idCustomer = 5
go

insert into tblRental values 
('RC-001', 5, 720, 1),
('RC-002', 1, 550, 1),
('RC-003', 3, 600, 2),
('RC-004', 2, 700, 3),
('RC-005', 4, 630, 3)
go
update tblRental set rentalDurationDays = 7 where pk_idRental = 3
delete from tblRental where pk_idRental = 4
go

insert into tblVehicle values 
('Skoda Rapid', 55.0, '2027-06-06'),
('Tesla Model 3', 120.0, '2026-09-06'),
('BMW X5', 150.0, '2030-06-06'),
('Audi Q3', 90.0, '2026-06-06'),
('Lada Granta', 25.0, '2025-12-06')
go
update tblVehicle set modelName = 'Волга Седан', dailyRate = 35 where pk_idVehicle = 5
delete from tblVehicle where pk_idVehicle = 2
go

insert into tblContract values
('CT-001', 1, 1),
('CT-002', 2, 2),
('CT-003', 3, 3),
('CT-004', 4, 5)
go
update tblContract set contractCode = 'CT-000' where pk_idContract = 3
go

insert into tblRentalDetails (carPosition, fk_idVehicle, fk_idRental) values 
(3, 1, 1),
(1, 3, 5),
(2, 4, 3),
(10, 4, 2)
go
update tblRentalDetails set carPosition = 8 where pk_idRentalDetail = 1
delete from tblRentalDetails where pk_idRentalDetail = 4
go
