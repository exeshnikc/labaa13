-- Лр7
use master
go
drop database if exists dbcar_hire
create database dbcar_hire
go
use dbcar_hire
go

-- Удаление таблиц (если существуют)
drop table if exists tblCustomer
drop table if exists tblRental
drop table if exists tblCity
drop table if exists tblVehicle
drop table if exists tblLocation
drop table if exists tblContract
drop table if exists tblRentalDetails
go

-- Таблица пунктов проката 
create table tblLocation (
    pk_idLocation int not null identity (1,1) primary key,
    nameLocation varchar(50) not null unique,
    typeOfLocation varchar(30) not null
)
go

-- Города
create table tblCity (
    pk_idCity int not null identity (1,1) primary key,
    nameCity varchar(30) not null
)
go

-- Клиенты
create table tblCustomer (
    pk_idCustomer int not null identity (1,1) primary key,
    fullName varchar(50) not null unique,
    phone nvarchar(20) not null unique,
    fk_idCity int not null foreign key references tblCity(pk_idCity)
)
go

-- Аренда (основная сделка аренды)
create table tblRental (
    pk_idRental int not null identity (1,1) primary key,
    rentalCode varchar(20) not null unique,
    rentalDurationDays int not null default 1,
    totalCost decimal(10,2) not null check (totalCost > 500),
    fk_idLocation int not null foreign key references tblLocation(pk_idLocation)
)
go

-- Автомобили
create table tblVehicle (
    pk_idVehicle int not null identity (1,1) primary key,
    modelName varchar(30) not null unique,
    dailyRate decimal(10,2) not null check (dailyRate > 10),
    registrationExpiry date not null
)
go

-- Контракты аренды
create table tblContract (
    pk_idContract int not null identity (1,1) primary key,
    contractCode varchar(25) not null unique,
    fk_idCustomer int not null foreign key references tblCustomer(pk_idCustomer),
    fk_idRental int not null foreign key references tblRental(pk_idRental)
)
go

-- Детали аренды (автомобили в рамках аренды)
create table tblRentalDetails (
    pk_idRentalDetail int not null identity (1,1) primary key,
    carPosition int not null check (carPosition < 300) default 1,
    fk_idVehicle int not null foreign key references tblVehicle(pk_idVehicle),
    fk_idRental int not null foreign key references tblRental(pk_idRental),
    calculation as pk_idRentalDetail + carPosition
)
go
